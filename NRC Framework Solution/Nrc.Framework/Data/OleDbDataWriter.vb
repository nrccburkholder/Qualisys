Imports System.Data
Imports System.Data.OleDb

Namespace Data

    Public MustInherit Class OleDbDataWriter
        Inherits DataWriter

        Private mConnection As OleDbConnection
        Private mParameterizedInsertSql As String

        Protected Sub New(ByVal reader As IDataReader)
            MyBase.New(reader)
        End Sub

        Protected Sub New(ByVal table As DataTable)
            MyBase.New(table)
        End Sub

        Protected Overrides Sub BeginWrite()
            MyBase.BeginWrite()

            mConnection = Me.GetOutputConnection
            mConnection.Open()

            Dim createTableCommand As OleDbCommand = mConnection.CreateCommand
            createTableCommand.CommandType = CommandType.Text
            createTableCommand.CommandText = Me.GetCreateTableSql
            createTableCommand.ExecuteNonQuery()

            mParameterizedInsertSql = Me.GetParameterizedInsertSql
        End Sub

        Protected Overrides Sub WriteRow(ByVal reader As System.Data.IDataReader)
            Dim insertCommand As OleDbCommand = Me.GetInsertCommand(Me.mConnection, Me.mParameterizedInsertSql, reader)
            insertCommand.ExecuteNonQuery()
        End Sub

        Protected Overrides Sub EndWrite(ByVal recordsWritten As Integer)
            MyBase.EndWrite(recordsWritten)

            If mConnection IsNot Nothing Then
                mConnection.Close()
            End If
        End Sub

#Region " Protected Methods "
        Protected MustOverride Function GetOutputConnection() As OleDbConnection
        Protected MustOverride Function GetSqlDataTypeName(ByVal col As DataWriterColumn) As String

        Protected Overridable Function GetOleDbType(ByVal dataTypeName As String) As OleDbType
            Select Case dataTypeName
                Case "System.String"
                    Return OleDbType.VarChar
                Case "System.Int32"
                    Return OleDbType.Integer
                Case "System.Int16"
                    Return OleDbType.SmallInt
                Case "System.Byte"
                    Return OleDbType.UnsignedTinyInt
                Case "System.SByte"
                    Return OleDbType.TinyInt
                Case "System.Decimal"
                    Return OleDbType.Decimal
                Case "System.Single"
                    Return OleDbType.Single
                Case "System.DateTime"
                    Return OleDbType.Date
                Case "System.Boolean"
                    Return OleDbType.Boolean
                Case Else
                    Throw New ArgumentException("Unknown data type '" & dataTypeName & "'", "dataTypeName")
            End Select
        End Function


#End Region

#Region " Private Methods "
        Private Function GetCreateTableSql() As String
            Dim sql As New System.Text.StringBuilder

            sql.Append("CREATE TABLE [" & Me.TableName & "] (")

            'For each column add the column name and type to the create command
            For Each col As DataWriterColumn In Me.Columns
                If col.Name.Length > Me.ColumnNameMaxLength Then
                    sql.AppendFormat("[{0}] ", col.ShortName)
                Else
                    sql.AppendFormat("[{0}] ", col.Name)
                End If
                sql.Append(Me.GetSqlDataTypeName(col) & ",")
            Next

            'Remove the last "," then finish the command
            sql.Remove(sql.Length - 1, 1)
            sql.Append(")")

            Return sql.ToString
        End Function

        Private Function GetParameterizedInsertSql() As String
            Dim sql As New System.Text.StringBuilder

            'Start it off
            sql.Append("INSERT INTO [" & Me.TableName & "] (")


            'Add the list of columns to insert into
            Dim col As DataWriterColumn
            For Each col In Me.Columns
                If col.Name.Length > Me.ColumnNameMaxLength Then
                    sql.Append(col.ShortName & ",")
                Else
                    sql.Append(col.Name & ",")
                End If
            Next

            sql.Remove(sql.Length - 1, 1)
            sql.Append(")")

            'Add the parameters for the insert values
            sql.Append(" values (")
            Dim i As Integer = 1
            For Each col In Me.Columns
                sql.Append("@p" & i.ToString & ",")
                i += 1
            Next

            sql.Remove(sql.Length - 1, 1)
            sql.Append(")")

            Return sql.ToString
        End Function

        Private Function GetInsertCommand(ByVal con As OleDbConnection, ByVal insertSQL As String, ByVal rdr As IDataReader) As OleDbCommand
            Dim cmd As OleDbCommand = con.CreateCommand
            cmd.CommandType = CommandType.Text
            cmd.CommandText = insertSQL

            Dim i As Integer = 0
            Dim param As OleDbParameter

            'Add the parameters to the command
            For i = 0 To Me.Columns.Count - 1
                param = cmd.CreateParameter
                param.Direction = ParameterDirection.Input
                param.ParameterName = "@p" & (i + 1).ToString
                param.OleDbType = Me.GetOleDbType(Me.Columns(i).DataType)
                param.Value = rdr(i)
                cmd.Parameters.Add(param)
            Next

            Return cmd
        End Function

#End Region
    End Class

End Namespace
