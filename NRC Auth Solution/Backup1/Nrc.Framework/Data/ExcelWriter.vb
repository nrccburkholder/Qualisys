Namespace Data

    Public Class ExcelWriter
        Inherits OleDbDataWriter


        Public Sub New(ByVal reader As IDataReader)
            MyBase.New(reader)
        End Sub

        Public Sub New(ByVal table As DataTable)
            MyBase.New(table)
        End Sub

        Protected Overrides ReadOnly Property ColumnNameMaxLength() As Integer
            Get
                Return 255
            End Get
        End Property

        Protected Overrides Function GetOutputConnection() As System.Data.OleDb.OleDbConnection
            Dim conString As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=""Excel 8.0;HDR=Yes"""
            Dim con As New OleDb.OleDbConnection(String.Format(conString, Me.FilePath))
            Return con
        End Function

        Protected Overrides Function GetSqlDataTypeName(ByVal col As DataWriterColumn) As String
            Select Case col.DataType
                Case "System.String"
                    Return "CHAR(255)"
                Case "System.Int32", "System.Int16"
                    Return "INTEGER"
                Case "System.Byte", "System.Decimal", "System.Single"
                    Return "NUMBER"
                Case "System.DateTime"
                    Return "CHAR(255)"
                    'Return "DATETIME"
                Case "System.Boolean"
                    Return "LOGICAL"
                Case Else
                    Return "CHAR(255)"
            End Select
        End Function

    End Class

End Namespace
