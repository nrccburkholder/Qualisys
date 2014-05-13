Option Explicit On 
Option Strict On

Imports System.Text

Public Class DTSDbaseData
    Inherits DTSDataSet

#Region " Constructors "

    Public Sub New()

        MyBase.New(DataSetTypes.DBF)

    End Sub

#End Region

#Region " Public Methods "

    Public Overrides Sub SplitSettings(ByVal settings As String)

        TemplateFileName = settings

    End Sub

    Public Overrides Function ConcatSettings() As String

        Return (TemplateFileName)

    End Function

    Public Overrides Function GetRecordCount(ByVal filePath As String) As Integer

        Dim count As Integer

        Dim fileName As String = GetFileName(filePath)
        Dim folderName As String = GetFolder(filePath)

        Dim conn As OleDb.OleDbConnection = GetConnection(folderName)

        Dim command As OleDb.OleDbCommand = conn.CreateCommand
        With command
            .CommandType = CommandType.Text
            .CommandText = String.Format("SELECT COUNT(*) FROM [{0}]", fileName)
            .Connection.Open()
        End With

        Try
            count = CInt(command.ExecuteScalar)

        Catch ex As Exception
            command.Connection.Close()
            Throw New Exception(String.Format("{0}{1}{2}", ex.Message, vbCrLf, command.CommandText))

        End Try

        command.Connection.Close()

        Return count

    End Function

    Public Overrides Function GetDataTable(ByVal filePath As String, ByVal rowCount As Integer) As DataTable

        Dim fileName As String = GetFileName(filePath)
        Dim folderName As String = GetFolder(filePath)
        Dim conn As OleDb.OleDbConnection = GetConnection(folderName)

        Using adapter As New OleDb.OleDbDataAdapter()
            Dim command As OleDb.OleDbCommand = conn.CreateCommand
            With command
                .CommandType = CommandType.Text
                .CommandText = String.Format("SELECT TOP {0} * FROM [{1}]", rowCount, fileName)
            End With

            adapter.SelectCommand = command

            Using ds As New DataSet()
                Try
                    adapter.Fill(ds)

                Catch ex As Exception
                    Throw ex

                End Try

                Return ds.Tables(0)
            End Using
        End Using

    End Function

    ' This method is only used for testing/debugging
    Public Overrides Function Settings() As String

        Dim str As New StringBuilder

        str.Append(String.Format("Dataset type: {0}{1}{1}", DataSetType, vbCrLf))
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

#End Region

#Region " Protected Methods "

    Protected Overrides Function GetSchema(ByVal filePath As String) As DataTable

        Dim fileName As String = GetFileName(filePath)
        Dim folderName As String = GetFolder(filePath)

        Dim conn As OleDb.OleDbConnection = GetConnection(folderName)

        Dim sql As String = String.Format("SELECT top 10 * FROM [{0}]", fileName)

        Dim command As OleDb.OleDbCommand = conn.CreateCommand
        With command
            .CommandType = CommandType.Text
            .CommandText = sql
            .Connection.Open()
        End With

        Dim rdr As OleDb.OleDbDataReader = command.ExecuteReader
        Dim tblReturn As DataTable = rdr.GetSchemaTable

        command.Connection.Close()

        Return tblReturn

    End Function

    Protected Function GetConnection(ByVal folder As String) As OleDb.OleDbConnection

        Dim connString As String = String.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=dBASE IV;", folder)
        Dim conn As OleDb.OleDbConnection = New OleDb.OleDbConnection(connString)

        Return conn

    End Function

#End Region

End Class
