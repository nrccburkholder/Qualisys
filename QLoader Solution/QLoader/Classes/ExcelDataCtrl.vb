Option Explicit On 
Option Strict On

Imports System.Data
Imports System.Data.OleDb
Imports System.Text
Imports Nrc.Qualisys.QLoader.Library

Public Class ExcelDataCtrl

#Region " Private Constants "

    Private Const MAX_PREVIEW_LINE As Integer = 500

#End Region

#Region " Private Members "

    Private mPath As String             'Path of Excel file for setup
    Private mExcelData As DTSExcelData  'Excel data set
    Private mDataTable As DataTable     'Data table used for containing data

#End Region

#Region " Public Properties"

    Public Property Path() As String
        Get
            Return mPath
        End Get
        Set(ByVal Value As String)
            mPath = Value
        End Set
    End Property

    Public Property HasHeader() As Boolean
        Get
            Return mExcelData.HasHeader
        End Get
        Set(ByVal Value As Boolean)
            mExcelData.HasHeader = Value
            SetColumnNames()
        End Set
    End Property

    Public ReadOnly Property Columns() As ColumnCollection
        Get
            Return mExcelData.Columns
        End Get
    End Property

    Public ReadOnly Property Fields() As String()()
        Get
            Dim beginRow As Integer = CInt(IIf(HasHeader, 1, 0))
            Dim i As Integer
            Dim j As Integer
            Dim rowNum As Integer = mDataTable.Rows.Count - beginRow
            Dim colNum As Integer = mDataTable.Columns.Count
            Dim data(rowNum - 1)() As String
            For i = 0 To rowNum - 1
                ReDim data(i)(colNum - 1)
                For j = 0 To colNum - 1
                    If (mDataTable.Rows(i + beginRow).Item(j) Is DBNull.Value OrElse _
                        mDataTable.Rows(i + beginRow).Item(j).ToString() = "") Then
                        data(i)(j) = ""
                    Else
                        data(i)(j) = CStr(mDataTable.Rows(i + beginRow).Item(j))
                    End If
                Next
            Next
            Return (data)
        End Get

    End Property

    Public ReadOnly Property DataSet() As DTSExcelData
        Get
            Dim col As SourceColumn
            Dim i As Integer = 0
            Dim dt As DataTable = mExcelData.GetColumnNames(Me.mPath)

            For Each col In mExcelData.Columns
                col.DataType = DataTypes.Varchar
                col.Length = 100
                col.Ordinal = i + 1
                col.SourceID = 0
                col.OriginalName = dt.Rows(i).Item("ColumnName").ToString
                i += 1
            Next
            Return (mExcelData)
        End Get
    End Property

#End Region

#Region " Public Methods "

    Public Sub New(ByVal path As String)
        Dim columnSize() As Integer = {}

        Me.mExcelData = New DTSExcelData
        LoadExcelFile(path, columnSize)
        InitColumns(columnSize)
        SetColumnNames()
    End Sub

    Public Sub New(ByVal dataset As DTSExcelData, ByVal path As String)
        Dim columnSize() As Integer = {}

        Me.mExcelData = dataset.Clone
        LoadExcelFile(path, columnSize)
        SetColumnSizes(columnSize)
    End Sub

    Public Function ValidateColumnName( _
                        ByRef errColumn As Integer, _
                        ByRef errMsg As String _
                ) As Boolean

        If (Not AreColumnNamesValid(errColumn, errMsg)) Then Return (False)
        If (mExcelData.Columns.ColumnNameDuplicated(errColumn, errMsg)) Then Return (False)
        Return (True)
    End Function

#End Region

#Region " Private Methods "

    Public Sub LoadExcelFile(ByVal path As String, ByRef columnSizes() As Integer)

        Dim sConnString As String = GetConnectionString(path)

        Dim conn As New OleDb.OleDbConnection(sConnString)

        Try
            Me.mPath = path

            conn.Open()
            Dim tableName As String = Me.mExcelData.TableName(path)

            'Load data from sheet to datatable
            Dim sql As String = _
                    String.Format("SELECT TOP {0} * FROM [{1}]", MAX_PREVIEW_LINE, tableName)
            Dim command As OleDb.OleDbCommand = conn.CreateCommand
            command.CommandType = CommandType.Text
            command.CommandText = sql
            Dim adapter As New OleDb.OleDbDataAdapter(command)
            mDataTable = New DataTable
            adapter.Fill(mDataTable)

            'Find column length
            Dim rowNum As Integer = mDataTable.Rows.Count
            Dim colNum As Integer = mDataTable.Columns.Count
            ReDim columnSizes(colNum - 1)
            Dim i As Integer
            Dim j As Integer

            'Initial column size with minimium width
            For j = 0 To colNum - 1
                columnSizes(j) = 1
            Next

            For i = 0 To rowNum - 1
                For j = 0 To colNum - 1
                    If (Not mDataTable.Rows(i).Item(j) Is DBNull.Value) Then
                        If (columnSizes(j) < CStr(mDataTable.Rows(i).Item(j)).Length) Then
                            columnSizes(j) = CStr(mDataTable.Rows(i).Item(j)).Length
                        End If
                    End If
                Next
            Next

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)
        Finally
            If (Not conn Is Nothing) Then conn.Close()
        End Try

    End Sub

    Private Sub InitColumns(ByVal columnSizes() As Integer)
        If (mDataTable Is Nothing) Then Return

        Dim columns As New ColumnCollection
        Dim col As SourceColumn
        Dim colNum As Integer = mDataTable.Columns.Count
        Dim i As Integer

        For i = 0 To colNum - 1
            col = New SourceColumn
            col.Length = columnSizes(i)
            columns.Add(col)
        Next

        mExcelData.Columns = columns

    End Sub

    Private Sub SetColumnSizes(ByVal columnSizes() As Integer)
        If (mExcelData Is Nothing) Then Return
        If (columnSizes Is Nothing) Then Return

        Dim columns As ColumnCollection = mExcelData.Columns
        Dim col As SourceColumn
        Dim colNum As Integer = mDataTable.Columns.Count
        Dim i As Integer

        For i = 0 To colNum - 1
            col = CType(columns(i), SourceColumn)
            col.Length = columnSizes(i)
        Next

    End Sub

    Private Sub SetColumnNames()
        If (mExcelData Is Nothing) Then Return
        If (mDataTable Is Nothing) Then Return

        Dim fieldID As Integer = 1
        Dim columns As ColumnCollection = mExcelData.Columns
        Dim col As SourceColumn
        Dim colNum As Integer = mDataTable.Columns.Count
        Dim i As Integer
        Dim name As String = ""

        Select Case mExcelData.HasHeader
            Case True   'has header
                For i = 0 To colNum - 1
                    col = CType(columns(i), SourceColumn)
                    If ((Not mDataTable.Rows(0).Item(i) Is DBNull.Value) OrElse _
                        (Not mDataTable.Rows(0).Item(i).ToString() = "")) Then
                        col.ColumnName = mDataTable.Rows(0).Item(i).ToString.Trim
                    Else
                        col.ColumnName = ""
                    End If
                Next

                'Fill blank column name
                i = 1
                For Each col In columns
                    If (col.ColumnName = "") Then
                        Do While True
                            name = String.Format("{0}{1:D3}", _
                                                 Column.DEFAULT_COLUMN_NAME, _
                                                 i)
                            i += 1
                            If (Not ColumnNameExist(name)) Then Exit Do
                        Loop
                        col.ColumnName = name
                    End If
                Next

            Case False  'no header
                For i = 0 To colNum - 1
                    col = CType(columns(i), SourceColumn)
                    col.ColumnName = String.Format( _
                                                "{0}{1:D3}", _
                                                Column.DEFAULT_COLUMN_NAME, _
                                                fieldID)
                    fieldID += 1
                Next
        End Select

    End Sub

    Private Function AreColumnNamesValid( _
                        ByRef errColumn As Integer, _
                        ByRef errMsg As String _
                ) As Boolean

        Dim columns As ColumnCollection = mExcelData.Columns
        Dim i As Integer

        For i = 0 To columns.Count - 1
            If (Not columns(i).IsValidColumnName(errMsg)) Then
                errColumn = i
                Return (False)
            End If
        Next
        Return (True)
    End Function

    Private Function ColumnNameExist(ByVal name As String) As Boolean
        Dim col As SourceColumn

        name = name.ToUpper
        For Each col In mExcelData.Columns
            If (col.ColumnName.ToUpper = name) Then Return True
        Next
        Return False
    End Function

    Private Function GetConnectionString(ByVal path As String) As String

        Dim connectionString As String
        If path.EndsWith(".xls") Then
            connectionString = String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=""Excel 12.0;HDR=No;IMEX=1""", path)
        Else
            connectionString = String.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=""Excel 12.0 Xml;HDR=No;IMEX=1""", path)
        End If

        Return connectionString

    End Function

#End Region

End Class
