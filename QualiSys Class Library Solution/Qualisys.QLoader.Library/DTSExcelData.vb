Option Explicit On 
Option Strict On

Imports System.Text
Imports System.Data.OleDb


Public Class DTSExcelData
    Inherits DTSDataSet
    Implements ICloneable

#Region " Shared Members "

    Public Shared DEFAULT_HAS_HEADER As Boolean

#End Region

#Region " Private Members "

    Protected mHasHeader As Boolean = DEFAULT_HAS_HEADER
    Private mPath As String
    Private mSheetName As String

#End Region

#Region " Public Properties "

    Public Property HasHeader() As Boolean
        Get
            Return mHasHeader
        End Get
        Set(ByVal Value As Boolean)
            mHasHeader = Value
        End Set
    End Property

#End Region

#Region " Constructors "

    Sub New()

        MyBase.New(DataSetTypes.Excel)

    End Sub

#End Region

#Region " Public Methods "

    Public Function CloneMe() As Object Implements System.ICloneable.Clone

        Return Clone()

    End Function

    Public Function Clone() As DTSExcelData

        Dim excelData As New DTSExcelData

        With excelData
            .TemplateFileName = TemplateFileName
            .HasHeader = HasHeader
            If (Not Columns Is Nothing) Then
                .Columns = Columns.Clone
            End If
        End With

        Return excelData

    End Function

    Public Overrides Sub SplitSettings(ByVal settings As String)

        Dim args() As String = settings.Split(SEPARATOR)

        If args.Length <> 2 Then
            Throw New ArgumentException("Setting string in source data set is incorrect")
        End If

        'Template file name
        TemplateFileName = args(0)

        'Has header
        HasHeader = CBool(IIf(args(1) = "1", True, False))

    End Sub

    Public Overrides Function ConcatSettings() As String

        Dim settings As String = String.Format("{0}{1}{2}", TemplateFileName, SEPARATOR, IIf(HasHeader, "1", "0"))

        Return settings

    End Function

    Public Overrides Function GetRecordCount(ByVal filePath As String) As Integer

        Dim conn As OleDb.OleDbConnection = GetConnection(filePath)

        Try
            Dim sql As String = String.Format("SELECT COUNT(*) FROM [{0}]", TableName(filePath))
            conn.Open()

            Dim command As OleDb.OleDbCommand = conn.CreateCommand
            command.CommandType = CommandType.Text
            command.CommandText = sql

            Return CInt(command.ExecuteScalar())

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)

        Finally
            conn.Close()

        End Try

    End Function

    Public Overrides Function GetDataTable(ByVal filePath As String, ByVal rowCount As Integer) As DataTable

        Dim conn As OleDb.OleDbConnection = GetConnection(filePath)

        Try
            'Construct query statement. The reason why manually write query statement instead of "SELECT * " is that:
            ' (1) Real data can have more or less columns than template data
            ' (2) Column name in package can be different to the header in the first row of the data
            Dim sql As New StringBuilder
            Dim dataColumn As DataTable = GetColumnNames(filePath)
            Dim dataColumnNum As Integer = dataColumn.Rows.Count

            For cnt As Integer = 0 To Columns.Count - 1
                If sql.Length = 0 Then
                    sql.Append(String.Format(" SELECT TOP {0} ", rowCount))
                Else
                    sql.Append(String.Format(",{0}        ", vbCrLf))
                End If

                If cnt < dataColumnNum Then
                    sql.Append(String.Format("[{0}] AS [{1}]", dataColumn.Rows(cnt).Item("ColumnName").ToString, Columns(cnt).ColumnName))
                Else
                    sql.Append(String.Format("NULL AS [{0}]", Columns(cnt).ColumnName))
                End If
            Next

            sql.Append(vbCrLf)
            sql.Append(String.Format("   FROM [{0}]", TableName(filePath)))

            conn.Open()

            Dim command As OleDb.OleDbCommand = conn.CreateCommand
            command.CommandType = CommandType.Text
            command.CommandText = sql.ToString

            Dim adapter As New OleDb.OleDbDataAdapter(command)
            Dim table As New DataTable

            adapter.Fill(table)
            Return table

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)

        Finally
            conn.Close()

        End Try

    End Function

    Protected Overrides Function GetSchema(ByVal filePath As String) As DataTable

        'Excel package can not get schema from file.  It is defined by user
        Return Nothing

    End Function

    Public Overrides Function ValidateFile(ByVal filePath As String, ByRef errMsg As String) As FileValidationResults

        Try
            Dim dt As DataTable = GetColumnNames(filePath)

            'Check column number
            If dt.Rows.Count <> Columns.Count Then
                errMsg = String.Format("Column number unmatched.{0}Column number in DTS package is {1}.{0}Column number in loading file is {2}.", vbCrLf, Columns.Count, dt.Rows.Count)
                Return FileValidationResults.InvalidFile
            End If

            'Check original column name if has header row
            If mHasHeader Then
                Dim fileColumnName As String

                For cnt As Integer = 0 To mColumns.Count - 1
                    If (dt.Rows(cnt).Item("ColumnName") Is DBNull.Value OrElse _
                        dt.Rows(cnt).Item("ColumnName").ToString = "") Then
                        fileColumnName = ""
                    Else
                        fileColumnName = dt.Rows(cnt).Item("ColumnName").ToString
                    End If

                    Dim dtsColumnName As String = CType(mColumns(cnt), SourceColumn).OriginalName

                    If (fileColumnName <> dtsColumnName) Then
                        errMsg = String.Format("Name unmatched for column {0}.{1}Column name in DTS package is {2}.{1}Column name in loading file is {3}.", cnt + 1, vbCrLf, dtsColumnName, fileColumnName)
                        Return FileValidationResults.InvalidFile
                    End If
                Next
            End If

            Return FileValidationResults.ValidFile

        Catch ex As Exception
            errMsg = ex.Message
            Return FileValidationResults.InvalidFile

        End Try

    End Function

    Public Function SheetName(ByVal path As String) As String

        Dim worksheetnames As New List(Of String)

        Dim sheetList As New List(Of String)

        Using conn As OleDb.OleDbConnection = GetConnection(path)
            conn.Open()
            Dim dt As DataTable
            dt = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, New Object() {Nothing, Nothing, Nothing, "TABLE"})
            For Each drSheet As DataRow In dt.Rows
                If drSheet("TABLE_NAME").ToString().Contains("$") Then
                    sheetList.Add(drSheet("TABLE_NAME").ToString())
                End If
            Next
            conn.Close()
        End Using

        Return sheetList(0).Replace("'", "").Replace("$", "")

    End Function

    Public Function TableName(ByVal path As String) As String

        Dim sheet As String = SheetName(path)

        'The dollar sign following the worksheet name is an indication that the table exists.  Refer the MS Q316934 for the detail
        Return String.Format("{0}$", sheet)

    End Function

    ' This method is only used for testing/debugging
    Public Overrides Function Settings() As String

        Dim str As New StringBuilder

        str.Append(String.Format("Dataset type: {0}{1}", DataSetType, vbCrLf))
        str.Append(String.Format("Has header row: {0}{1}{1}", HasHeader, vbCrLf))
        str.Append(String.Format("Ordinal: Name  Data Type  Length  Original Name  Source ID{0}", vbCrLf))
        str.Append(String.Format("================================{0}", vbCrLf))

        For Each col As SourceColumn In Columns
            With col
                str.Append(String.Format("{0}:  ", .Ordinal))
                str.Append(String.Format("{0}    ", .ColumnName))
                str.Append(String.Format("{0} ({1})    ", .DataType, .DataTypeString))
                str.Append(String.Format("{0}    ", .Length))
                str.Append(String.Format("{0}    ", .OriginalName))
                str.Append(String.Format("{0}{1}", .SourceID, vbCrLf))
            End With
        Next

        Return str.ToString

    End Function

    Public Function GetColumnNames(ByVal filePath As String) As DataTable

        Dim conn As OleDb.OleDbConnection = GetConnection(filePath)

        Try
            Dim sql As String = String.Format("SELECT TOP 1 * FROM [{0}]", TableName(filePath))

            Dim command As OleDb.OleDbCommand = conn.CreateCommand
            command.CommandType = CommandType.Text
            command.CommandText = sql

            conn.Open()

            Dim rdr As OleDb.OleDbDataReader = command.ExecuteReader
            Dim tbl As DataTable = rdr.GetSchemaTable

            conn.Close()

            Return tbl

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)

        Finally
            conn.Close()

        End Try

    End Function

#End Region

#Region " Private Methods "

    Private Function GetConnection(ByVal filePath As String) As OleDb.OleDbConnection

        Dim connString As String = ""

        If filePath.ToLower.EndsWith("xls") Then
            connString = String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=""Excel 12.0;HDR={1};IMEX=1""", filePath, IIf(mHasHeader, "Yes", "No"))
        Else
            connString = String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=""Excel 12.0 Xml;HDR={1};IMEX=1""", filePath, IIf(mHasHeader, "Yes", "No"))
        End If

        Return (New OleDb.OleDbConnection(connString))

    End Function

#End Region

End Class
