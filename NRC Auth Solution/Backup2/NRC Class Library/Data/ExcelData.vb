Namespace Data

    Public Class ExcelData


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overloads ExportToExcel to default the launchExcel to false.
        ''' </summary>
        ''' <param name="table">The data table to export.</param>
        ''' <param name="fileName">The name of the excel file to be created</param>
        ''' <param name="sheetName">The name of the sheet to be created</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	8/13/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Sub ExportToExcel(ByVal table As DataTable, ByVal fileName As String, ByVal sheetName As String)
            ExportToExcel(table, fileName, sheetName, False)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Creates an excel file and fills it with data from a data table.
        ''' </summary>
        ''' <param name="table">The data table to export.</param>
        ''' <param name="fileName">The name of the excel file to be created</param>
        ''' <param name="sheetName">The name of the sheet to be created</param>
        ''' <param name="launchExcel">If true excel is automatically launched in a new process and the newly created file is opened.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	8/13/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Sub ExportToExcel(ByVal table As DataTable, ByVal fileName As String, ByVal sheetName As String, ByVal launchExcel As Boolean)

            'Get the connection
            Dim con As OleDb.OleDbConnection = GetConnection(fileName)
            'Get the create table sql statement to create the sheet
            Dim createSQL As String = GetCreateSQL(table, sheetName)
            'Get the insert sql statement for inserting each row
            Dim insertSQL As String = GetInsertSQL(table, sheetName)
            Dim row As DataRow

            Dim cmd As OleDb.OleDbCommand

            Try

                'If the file already exists then delete it.
                If System.IO.File.Exists(fileName) Then
                    System.IO.File.Delete(fileName)
                End If

                'Open the connection
                con.Open()
                'Create the sheet
                cmd = New OleDb.OleDbCommand(createSQL, con)
                cmd.ExecuteNonQuery()

                'For each row, get the insert command and execute it
                For Each row In table.Rows
                    cmd = GetInsertCmd(table, con, insertSQL, row)
                    cmd.ExecuteNonQuery()
                Next

                Catch ex As Exception
                Throw ex
            Finally
                con.Close()
            End Try
            'If caller wants to launch excel then fire it up
            If launchExcel Then
                System.Diagnostics.Process.Start(fileName)
            End If

        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Gets an oleDB connection object for an excel spreadsheet with the specified file name
        ''' </summary>
        ''' <param name="fileName">The name of the excel file</param>
        ''' <returns>An OleDB connection to the excel file.</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	8/13/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Shared Function GetConnection(ByVal fileName As String) As OleDb.OleDbConnection
            Dim strConnect As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fileName + ";" + "Extended Properties=""Excel 8.0;HDR=yes;"""
            ';  // FIRSTROWHASNAMES=1;READONLY=false\

            Dim con As New OleDb.OleDbConnection(strConnect)

            Return con
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Builds and returns a string representing the SQL Create statement for the data table being exported.
        ''' </summary>
        ''' <param name="table">The data table being exported</param>
        ''' <param name="sheetName">The name of the sheet to create</param>
        ''' <returns>The SQL Create statement</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	8/13/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Shared Function GetCreateSQL(ByVal table As DataTable, ByVal sheetName As String) As String
            Dim sql As New System.Text.StringBuilder

            sql.Append("CREATE TABLE [" & sheetName & "] (")

            'For each column add the column name and type to the create command
            Dim col As DataColumn
            For Each col In table.Columns
                sql.Append(col.ColumnName & " ")

                If col.DataType Is GetType(String) Then
                    sql.Append("char(255),")
                ElseIf col.DataType Is GetType(Integer) Then
                    sql.Append("NUMBER,")
                ElseIf col.DataType Is GetType(DateTime) Then
                    sql.Append("Datetime,")
                Else
                    sql.Append("char(255),")
                End If
            Next

            'Remove the last "," then finish the command
            sql.Remove(sql.Length - 1, 1)
            sql.Append(")")

            Return sql.ToString
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns a string representing a SQL Insert statement for adding each row of data to the sheet
        ''' </summary>
        ''' <param name="table">The data table being exported.</param>
        ''' <param name="sheetName">The name of the sheet to insert into.</param>
        ''' <returns>The SQL Insert statement.</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	8/13/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Shared Function GetInsertSQL(ByVal table As DataTable, ByVal sheetName As String) As String
            Dim sql As New System.Text.StringBuilder


            'Start it off
            sql.Append("INSERT INTO [" & sheetName & "] (")


            'Add the list of columns to insert into
            Dim col As DataColumn
            For Each col In table.Columns
                sql.Append(col.ColumnName & ",")
            Next

            sql.Remove(sql.Length - 1, 1)
            sql.Append(")")

            'Add the parameters for the insert values
            sql.Append(" values (")
            Dim i As Integer = 1
            For Each col In table.Columns
                sql.Append("@p" & i.ToString & ",")
                i += 1
            Next

            sql.Remove(sql.Length - 1, 1)
            sql.Append(")")

            Return sql.ToString

        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns an oleDB command object that inserts a row of data into the spreadsheet
        ''' </summary>
        ''' <param name="table">The data table that is being exported</param>
        ''' <param name="con">The connection object</param>
        ''' <param name="insertSQL">The insert SQL string</param>
        ''' <param name="row">The row of data to insert.</param>
        ''' <returns>The oleDB command object</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	8/13/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Shared Function GetInsertCmd(ByVal table As DataTable, ByVal con As OleDb.OleDbConnection, ByVal insertSQL As String, ByVal row As DataRow) As OleDb.OleDbCommand
            Dim cmd As New OleDb.OleDbCommand(insertSQL, con)

            Dim i As Integer = 0
            Dim paramName As String
            Dim paramType As OleDb.OleDbType

            'Add the parameters to the command
            For i = 0 To table.Columns.Count - 1
                paramName = "@p" & (i + 1).ToString

                If table.Columns(i).DataType Is GetType(String) Then
                    paramType = OleDb.OleDbType.VarChar
                ElseIf table.Columns(i).DataType Is GetType(DateTime) Then
                    paramType = OleDb.OleDbType.Date
                ElseIf table.Columns(i).DataType Is GetType(Integer) Then
                    paramType = OleDb.OleDbType.Numeric
                End If

                cmd.Parameters.Add(paramName, paramType).Value = row(i)
            Next

            Return cmd
        End Function
    End Class

End Namespace
