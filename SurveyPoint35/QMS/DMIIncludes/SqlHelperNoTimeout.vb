Imports System.Data
Imports System.Data.SqlClient

Public Class SqlHelperNoTimeout

    Public Shared Function ExecuteReader(ByVal connection As SqlConnection, ByVal commandType As CommandType, ByVal commandText As String) As SqlDataReader
        Dim mustCloseConnection As Boolean = False
        Dim cmd As New SqlCommand

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")

        Try
            ' Create a reader
            Dim dataReader As SqlDataReader

            PrepareCommand(cmd, connection, commandType, commandText, mustCloseConnection)

            ' Call ExecuteReader with the appropriate CommandBehavior
            dataReader = cmd.ExecuteReader()

            Return dataReader

        Catch
            If (mustCloseConnection) Then connection.Close()
            Throw
        End Try


    End Function

    Public Overloads Shared Function ExecuteNonQuery(ByVal connection As SqlConnection, _
                                                 ByVal commandType As CommandType, _
                                                 ByVal commandText As String) As Integer

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")

        ' Create a command and prepare it for execution
        Dim cmd As New SqlCommand
        Dim retval As Integer
        Dim mustCloseConnection As Boolean = False

        PrepareCommand(cmd, connection, commandType, commandText, mustCloseConnection)

        ' Finally, execute the command
        retval = cmd.ExecuteNonQuery()

        ' Detach the SqlParameters from the command object, so they can be used again
        cmd.Parameters.Clear()

        If (mustCloseConnection) Then connection.Close()

        Return retval
    End Function ' ExecuteNonQuery

    Public Shared Sub PrepareCommand(ByVal command As SqlCommand, _
                                      ByVal connection As SqlConnection, _
                                      ByVal commandType As CommandType, _
                                      ByVal commandText As String, _
                                      ByRef mustCloseConnection As Boolean)

        If (command Is Nothing) Then Throw New ArgumentNullException("command")
        If (commandText Is Nothing OrElse commandText.Length = 0) Then Throw New ArgumentNullException("commandText")

        ' If the provided connection is not open, we will open it
        If connection.State <> ConnectionState.Open Then
            connection.Open()
            mustCloseConnection = True
        Else
            mustCloseConnection = False
        End If

        ' Associate the connection with the command
        command.Connection = connection

        ' Set the command text (stored procedure name or SQL statement)
        command.CommandText = commandText

        ' Set the command type
        command.CommandType = commandType

        ' Set command to not timeout
        command.CommandTimeout = 0

        Return

    End Sub

End Class
