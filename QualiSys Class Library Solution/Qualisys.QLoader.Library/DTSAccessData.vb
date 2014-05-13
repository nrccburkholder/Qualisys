Option Explicit On 
Option Strict On

Imports System.Text

Public Class DTSAccessData
    Inherits DTSDataSet

#Region " Private Members "
    Protected mTableName As String
#End Region

#Region " Public Properties "
    Public Property TableName() As String
        Get
            Return Me.mTableName
        End Get
        Set(ByVal Value As String)
            Me.mTableName = Value
        End Set
    End Property

#End Region

#Region " Public Methods "

    Sub New()
        MyBase.New(DataSetTypes.AccessDB)
    End Sub

    Sub New(ByVal tableName As String)
        MyBase.New(DataSetTypes.AccessDB)
        Me.mTableName = tableName
    End Sub

    Public Overrides Sub SplitSettings(ByVal settings As String)
        Dim args() As String = settings.Split(SEPARATOR)

        If args.Length <> 2 Then
            Throw New ArgumentException("Setting string in source data set is incorrect")
        End If

        'Template file name
        Me.TemplateFileName = args(0)

        'Table name
        Me.TableName = args(1)
    End Sub

    Public Overrides Function ConcatSettings() As String
        Dim settings As String
        settings = String.Format("{0}{1}{2}", _
                                 Me.TemplateFileName, _
                                 SEPARATOR, _
                                 Me.TableName)
        Return (settings)
    End Function

    Public Function GetConnection(ByVal filePath As String) As OleDb.OleDbConnection
        Dim connString As String = _
                    "Provider=Microsoft.Jet.OLEDB.4.0;" & _
                    "Data Source=" & filePath & ";" & _
                    "User ID=Admin;" & _
                    "Password="
        Return (New OleDb.OleDbConnection(connString))
    End Function

    Public Overrides Function GetRecordCount(ByVal filePath As String) As Integer
        Dim conn As OleDb.OleDbConnection = GetConnection(filePath)
        Dim sql As String = String.Format("SELECT COUNT(*) FROM {0}", Me.mTableName)
        Dim count As Integer = 0

        Dim command As OleDb.OleDbCommand = conn.CreateCommand
        command.CommandType = CommandType.Text
        command.CommandText = sql

        command.Connection.Open()
        count = CInt(command.ExecuteScalar)
        command.Connection.Close()

        Return count
    End Function

    Public Overrides Function GetDataTable(ByVal filePath As String, ByVal rowCount As Integer) As DataTable
        Dim conn As OleDb.OleDbConnection = GetConnection(filePath)
        Dim sql As String = String.Format("SELECT TOP {0} * FROM {1}", rowCount, Me.mTableName)

        Dim command As OleDb.OleDbCommand = conn.CreateCommand
        command.CommandType = CommandType.Text
        command.CommandText = sql

        Dim adapter As New OleDb.OleDbDataAdapter(command)
        Dim table As New DataTable
        adapter.Fill(table)

        Return table
    End Function


    Protected Overrides Function GetSchema(ByVal filePath As String) As DataTable
        Dim conn As OleDb.OleDbConnection = GetConnection(filePath)
        Dim sql As String = String.Format("SELECT top 10 * FROM {0}", Me.mTableName)


        Dim command As OleDb.OleDbCommand = conn.CreateCommand
        command.CommandType = CommandType.Text
        command.CommandText = sql

        Dim tbl As DataTable
        conn.Open()
        Dim rdr As OleDb.OleDbDataReader = command.ExecuteReader
        tbl = rdr.GetSchemaTable
        conn.Close()

        Return tbl
    End Function

    ' This method is only used for testing/debugging
    Public Overrides Function Settings() As String
        Dim str As New StringBuilder

        str.Append("Dataset type: " + Me.DataSetType.ToString + vbCrLf)
        str.Append("Table name: " + Me.TableName + vbCrLf + vbCrLf)
        str.Append("Ordinal: Name  Data Type  Length  Original Name  Source ID" + vbCrLf)
        str.Append("================================" + vbCrLf)
        Dim col As SourceColumn
        For Each col In Columns
            With col
                str.Append(.Ordinal & ":  ")
                str.Append(.ColumnName + "    ")
                str.Append(.DataType & " (" + .DataTypeString + ")    ")
                str.Append(.Length & "    ")
                str.Append(.OriginalName & "    ")
                str.Append(.SourceID & vbCrLf)
            End With
        Next

        Return str.ToString

    End Function

#End Region

End Class

