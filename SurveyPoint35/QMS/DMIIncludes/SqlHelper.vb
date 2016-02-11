Imports System.Data.Common
Imports Microsoft.Practices.EnterpriseLibrary.Data

Public Module SqlHelper    
    Private mDB As Sql.SqlDatabase = Nothing

    Public Function Db(ByVal conn As String) As Database
        If mDB Is Nothing Then
            mDB = (New Sql.SqlDatabase(conn))
            Return mDB
        Else
            If mDB.ConnectionString = conn Then
                Return mDB
            Else
                mDB = (New Sql.SqlDatabase(conn))
                Return mDB
            End If
        End If
    End Function

    Public Function ExecuteScalar(ByVal conn As SqlClient.SqlConnection, ByVal cmdType As CommandType, ByVal sql As String) As Object
        Return Db(conn.ConnectionString).ExecuteScalar(cmdType, sql)
    End Function
    Public Function ExecuteScalar(ByVal tran As DbTransaction, ByVal cmdType As CommandType, ByVal sql As String) As Object
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = tran.Connection
        If cmdType = CommandType.StoredProcedure Then
            cmd.CommandType = CommandType.StoredProcedure            
        Else
            cmd.CommandType = CommandType.Text            
        End If
        cmd.CommandText = sql
        cmd.Transaction = tran
        Return cmd.ExecuteScalar
    End Function
    Public Function ExecuteScalar(ByVal conn As String, ByVal cmdType As CommandType, ByVal sql As String) As Object
        Return Db(conn).ExecuteScalar(cmdType, sql)
    End Function
    Public Function ExecuteScalar(ByVal conn As SqlClient.SqlConnection, ByVal cmdType As CommandType, ByVal sql As String, ByVal ParamArray params() As SqlClient.SqlParameter) As Object
        If cmdType = CommandType.StoredProcedure Then
            Dim cmd As DbCommand = Db(conn.ConnectionString).GetStoredProcCommand(sql)
            cmd.Parameters.AddRange(params)
            Return Db(conn.ConnectionString).ExecuteScalar(cmd)
        Else
            Dim cmd As DbCommand = Db(conn.ConnectionString).GetSqlStringCommand(sql)
            cmd.Parameters.AddRange(params)
            Return Db(conn.ConnectionString).ExecuteScalar(cmd)
        End If
    End Function
    Public Function ExecuteScalar(ByVal conn As String, ByVal cmdType As CommandType, ByVal sql As String, ByVal ParamArray params() As SqlClient.SqlParameter) As Object
        If cmdType = CommandType.StoredProcedure Then
            Dim cmd As DbCommand = Db(conn).GetStoredProcCommand(sql)
            cmd.Parameters.AddRange(params)
            Return Db(conn).ExecuteScalar(cmd)
        Else
            Dim cmd As DbCommand = Db(conn).GetSqlStringCommand(sql)
            cmd.Parameters.AddRange(params)
            Return Db(conn).ExecuteScalar(cmd)
        End If
    End Function
    Public Function ExecuteReader(ByVal conn As SqlClient.SqlConnection, ByVal cmdType As CommandType, ByVal sql As String) As SqlClient.SqlDataReader
        Return DirectCast(Db(conn.ConnectionString).ExecuteReader(CommandType.Text, sql), SqlClient.SqlDataReader)
    End Function
    Public Function ExecuteReader(ByVal conn As String, ByVal cmdType As CommandType, ByVal sql As String) As SqlClient.SqlDataReader
        Return DirectCast(Db(conn).ExecuteReader(CommandType.Text, sql), SqlClient.SqlDataReader)
    End Function
    Public Function ExecuteReader(ByVal conn As SqlClient.SqlConnection, ByVal cmdType As CommandType, ByVal sql As String, ByVal ParamArray params() As SqlClient.SqlParameter) As SqlClient.SqlDataReader
        If cmdType = CommandType.StoredProcedure Then
            Dim cmd As DbCommand = Db(conn.ConnectionString).GetStoredProcCommand(sql)
            cmd.Parameters.AddRange(params)
            Return DirectCast(Db(conn.ConnectionString).ExecuteReader(cmd), SqlClient.SqlDataReader)
        Else
            Dim cmd As DbCommand = Db(conn.ConnectionString).GetSqlStringCommand(sql)
            cmd.Parameters.AddRange(params)
            Return DirectCast(Db(conn.ConnectionString).ExecuteReader(cmd), SqlClient.SqlDataReader)
        End If
    End Function
    Public Function ExecuteReader(ByVal tran As DbTransaction, ByVal cmdType As CommandType, ByVal sql As String, ByVal ParamArray params() As SqlClient.SqlParameter) As SqlClient.SqlDataReader
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = tran.Connection
        If cmdType = CommandType.StoredProcedure Then
            cmd.CommandType = CommandType.StoredProcedure            
        Else
            cmd.CommandType = CommandType.Text            
        End If
        cmd.CommandText = sql
        cmd.Parameters.AddRange(params)
        Return cmd.ExecuteReader
    End Function
    Public Function ExecuteReader(ByVal conn As String, ByVal cmdType As CommandType, ByVal sql As String, ByVal ParamArray params() As SqlClient.SqlParameter) As SqlClient.SqlDataReader
        If cmdType = CommandType.StoredProcedure Then
            Dim cmd As DbCommand = Db(conn).GetStoredProcCommand(sql)
            cmd.Parameters.AddRange(params)
            Return DirectCast(Db(conn).ExecuteReader(cmd), SqlClient.SqlDataReader)
        Else
            Dim cmd As DbCommand = Db(conn).GetSqlStringCommand(sql)
            cmd.Parameters.AddRange(params)
            Return DirectCast(Db(conn).ExecuteReader(cmd), SqlClient.SqlDataReader)
        End If
    End Function
    Public Function ExecuteNonQuery(ByVal conn As SqlClient.SqlConnection, ByVal cmdType As CommandType, ByVal sql As String) As Integer
        Return Db(conn.ConnectionString).ExecuteNonQuery(cmdType, sql)
    End Function
    Public Function ExecuteNonQuery(ByVal conn As String, ByVal cmdType As CommandType, ByVal sql As String) As Integer
        Return Db(conn).ExecuteNonQuery(cmdType, sql)
    End Function
    Public Function ExecuteNonQuery(ByVal tran As DbTransaction, ByVal cmdType As CommandType, ByVal sql As String) As Integer
        Dim cmd As New SqlClient.SqlCommand()
        cmd.Connection = tran.Connection
        If cmdType = CommandType.StoredProcedure Then
            cmd.CommandType = CommandType.StoredProcedure                        
        Else
            cmd.CommandType = CommandType.Text
        End If
        cmd.CommandText = sql
        cmd.Transaction = tran
        Return cmd.ExecuteNonQuery
    End Function
    Public Function ExecuteNonQuery(ByVal conn As SqlClient.SqlConnection, ByVal cmdType As CommandType, ByVal sql As String, ByVal ParamArray params() As SqlClient.SqlParameter) As Integer
        If cmdType = CommandType.StoredProcedure Then
            Dim cmd As DbCommand = Db(conn.ConnectionString).GetStoredProcCommand(sql)
            cmd.Parameters.AddRange(params)
            Return Db(conn.ConnectionString).ExecuteNonQuery(cmd)
        Else
            Dim cmd As DbCommand = Db(conn.ConnectionString).GetSqlStringCommand(sql)
            cmd.Parameters.AddRange(params)
            Return Db(conn.ConnectionString).ExecuteNonQuery(cmd)
        End If
    End Function
    Public Function ExecuteNonQuery(ByVal conn As String, ByVal cmdType As CommandType, ByVal sql As String, ByVal ParamArray params() As SqlClient.SqlParameter) As Integer
        If cmdType = CommandType.StoredProcedure Then
            Dim cmd As DbCommand = Db(conn).GetStoredProcCommand(sql)
            cmd.Parameters.AddRange(params)
            Return Db(conn).ExecuteNonQuery(cmd)
        Else
            Dim cmd As DbCommand = Db(conn).GetSqlStringCommand(sql)
            cmd.Parameters.AddRange(params)
            Return Db(conn).ExecuteNonQuery(cmd)
        End If
    End Function
    Public Function ExecuteNonQuery(ByVal tran As DbTransaction, ByVal cmdType As CommandType, ByVal sql As String, ByVal ParamArray params() As SqlClient.SqlParameter) As Integer
        Dim cmd As New SqlClient.SqlCommand()
        cmd.Connection = tran.Connection
        If cmdType = CommandType.StoredProcedure Then
            'Dim cmd As DbCommand = Db(tran.Connection.ConnectionString).GetStoredProcCommand(sql)
            'cmd.Transaction = tran
            'cmd.Parameters.AddRange(params)
            'Return Db(tran.Connection.ConnectionString).ExecuteNonQuery(cmd)
            'Switch transaction logic TP 20090911            
            cmd.CommandType = CommandType.StoredProcedure            
        Else
            cmd.CommandType = CommandType.Text
            'Dim cmd As DbCommand = Db(tran.Connection.ConnectionString).GetSqlStringCommand(sql)
            'cmd.Transaction = tran
            'cmd.Parameters.AddRange(params)
            'Return Db(tran.Connection.ConnectionString).ExecuteNonQuery(cmd)
        End If
        cmd.CommandText = sql
        cmd.Parameters.AddRange(params)
        cmd.Transaction = tran
        Return cmd.ExecuteNonQuery()
    End Function
    'SqlHelper.ExecuteNonQuery(DMI.DataHandler.sConnection, CommandType.Text, "SET PARSEONLY OFF")
    'SqlHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, "clean_Responses", _
    'New SqlClient.SqlParameter("@RespondentID", respondentID))
    'Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.StoredProcedure, "get_CurrentCallAttempts", _
    'New SqlClient.SqlParameter("@ProtocolStepID", iProtocolStepID)))    
End Module
