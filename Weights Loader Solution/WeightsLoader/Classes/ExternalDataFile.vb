Imports System.Data.OleDb
Public Class ExternalDataFile
#Region "Enums"
    Public Enum SupportedFileType
        dbf = 0
    End Enum
#End Region

#Region "Constants"
    Const DefaultPreviewRowCount As Integer = 20
#End Region

#Region "Private Fields"
    Private mFields As Dictionary(Of String, system.type)
    Private mPath As String
    Private mPreviewTable As DataTable
    Private mPreviewRowCount As Integer
    Private mFileType As SupportedFileType
#End Region

#Region "Constructors"
    Public Sub New(ByVal path As String, ByVal filetype As SupportedFileType)
        Me.new(path, filetype, DefaultPreviewRowCount)
    End Sub

    Public Sub New(ByVal path As String, ByVal filetype As SupportedFileType, ByVal previewRowCount As Integer)
        mPath = path
        mPreviewRowCount = previewRowCount
        mPreviewTable = Me.GetTable(mPreviewRowCount)
    End Sub
#End Region

#Region "Public Properties"
    Public ReadOnly Property FileType() As SupportedFileType
        Get
            Return mFileType
        End Get
    End Property

    Public ReadOnly Property previewTable() As DataTable
        Get
            Return mPreviewTable
        End Get
    End Property

    Public ReadOnly Property Path() As String
        Get
            Return mPath
        End Get
    End Property

    Public ReadOnly Property Fields() As Dictionary(Of String, system.type)
        Get
            Return mFields
        End Get
    End Property
#End Region

#Region "Private Functions"
    Private Function GetFields(ByVal schemaTable As DataTable) As Dictionary(Of String, System.Type)
        Dim fields As New Dictionary(Of String, System.Type)
        For Each row As DataRow In schemaTable.Rows
            fields.Add(CStr(row("ColumnName")), DirectCast(row("DataType"), System.Type))
        Next
        Return fields
    End Function

    Private Function GetConnection() As OleDbConnection
        Dim connectionString As String = ""
        Dim con As OleDbConnection

        Select Case FileType
            Case SupportedFileType.dbf
                connectionString = String.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=dBASE IV;", System.IO.Path.GetDirectoryName(Path))
        End Select

        con = New OleDbConnection(connectionString)
        Return con
    End Function

    Private Function GetCommandText(ByVal rowcount As Integer, ByVal ParamArray columns() As String) As String
        Dim commandText As String = ""
        Dim columnList As String = ""

        If columns IsNot Nothing Then
            For Each item As String In columns
                columnList += item + ","
            Next
            columnList = columnList.Substring(0, columnList.Length - 1)
        Else
            columnList = "*"
        End If

        Select Case FileType
            Case SupportedFileType.dbf
                If rowcount = -1 Then
                    commandText = String.Format("Select {0} from {1}", columnList, System.IO.Path.GetFileNameWithoutExtension(Path))
                Else
                    commandText = (String.Format("Select Top {0} {1} from {2}", rowcount.ToString, columnList, System.IO.Path.GetFileNameWithoutExtension(Path)))
                End If
        End Select

        Return commandText
    End Function
#End Region

#Region "Public Methods"

    ''' <summary>
    ''' Returns a reader with the all rows and columns. 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetReader() As IDataReader
        Return GetReader(-1, Nothing)
    End Function

    ''' <summary>
    ''' Returns a recordset with all rows and the specified columns
    ''' </summary>
    ''' <param name="columns"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetReader(ByVal ParamArray columns() As String) As IDataReader
        Return GetReader(-1, columns)
    End Function

    ''' <summary>
    ''' Returns a reader with the specified number of rows and all columns.  
    ''' </summary>
    ''' <param name="rowCount"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetReader(ByVal rowCount As Integer) As IDataReader
        Return GetReader(rowCount, Nothing)
    End Function

    ''' <summary>
    ''' Returns a reader with the specified number of rows.  If a rowcount of -1 is used, all rows are returned.
    ''' </summary>
    ''' <param name="rowCount"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetReader(ByVal rowCount As Integer, ByVal ParamArray columns() As String) As IDataReader
        Dim con As OleDbConnection = Me.GetConnection

        Dim cmd As New OleDbCommand(GetCommandText(rowCount, columns), con)
        Dim reader As OleDbDataReader

        Try
            con.Open()
            reader = cmd.ExecuteReader()
            If reader.HasRows = False Then Throw New Exception("The selected file has no rows.")
            If mFields Is Nothing Then mFields = GetFields(reader.GetSchemaTable)
        Catch ex As OleDbException
            Throw
        End Try

        Return reader
    End Function


    ''' <summary>
    ''' Returns a datatable with all rows and columns. 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetTable() As DataTable
        Return GetTable(-1, Nothing)
    End Function


    ''' <summary>
    ''' Returns a datatable with all rows and the specified columns
    ''' </summary>
    ''' <param name="columns"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetTable(ByVal ParamArray columns() As String) As DataTable
        Return GetTable(-1, columns)
    End Function

    ''' <summary>
    ''' Returns a datatable with the specified number of rows and all columns.  
    ''' </summary>
    ''' <param name="rowcount"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetTable(ByVal rowcount As Integer) As DataTable
        Return GetTable(rowcount, Nothing)
    End Function

    ''' <summary>
    ''' Returns a datatable with the specified number of rows and the specified columns.
    ''' </summary>
    ''' <param name="rowCount"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetTable(ByVal rowcount As Integer, ByVal ParamArray columns() As String) As DataTable
        Dim previewReader As IDataReader
        Dim table As New DataTable
        previewReader = Me.GetReader(rowcount, columns)
        Using previewReader
            table.Load(previewReader)
        End Using
        Return table
    End Function
#End Region
End Class
