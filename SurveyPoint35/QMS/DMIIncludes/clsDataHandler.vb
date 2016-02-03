Imports System.Data.SqlClient
Imports System.Data

Public Class DataHandler

    Public Const NULLRECORDID As Integer = -2
    Public Const NULLDATE As DateTime = #1/1/1900#
    Public Const DEFAULT_CONNECTION_TIMEOUT As Integer = 30
    Public Const DEFAULT_LONG_CONNECTION_TIMEOUT_PAD As Integer = 300
    Public Const CONNECTION_STRING_PROPERTY_KEY_CONNECTION_TIMEOUT1 As String = "CONNECT TIMEOUT"
    Public Const CONNECTION_STRING_PROPERTY_KEY_CONNECTION_TIMEOUT2 As String = "CONNECTION TIMEOUT"
    Public Shared sConnection As String = ""

    Public Shared Function AppendConnStringConnectionTimeOut(ByVal connStr As String, Optional ByVal timeoutLengthInSeconds As Integer = -1) As String
        If (timeoutLengthInSeconds < 1) Then
            timeoutLengthInSeconds = DEFAULT_CONNECTION_TIMEOUT
        End If

        connStr = connStr.Trim()

        'add trailing semicolon (if not present)
        If (connStr.Chars(connStr.Length - 1) <> ";"c) Then
            connStr += ";"
        End If

        Return String.Format("{0}{1}={2}", connStr, CONNECTION_STRING_PROPERTY_KEY_CONNECTION_TIMEOUT1, timeoutLengthInSeconds)
    End Function

    'base function to fill table in dataset, requires sql connection
    Public Shared Function GetDS(ByRef conn As SqlConnection, ByRef ds As DataSet, ByVal sSQL As String, Optional ByVal sTableName As String = "", Optional ByVal bAcceptChanges As Boolean = True) As Boolean
        Dim da As SqlDataAdapter

        If conn.State = ConnectionState.Closed Then conn.Open()

        Try
            da = New SqlDataAdapter(sSQL, conn)
            da.AcceptChangesDuringFill = bAcceptChanges

            If (IsNothing(ds)) Then
                ds = New DataSet
            End If

            ' Fill DataSet from DataAdapter
            If (sTableName.Length = 0) Then
                da.Fill(ds)
            Else
                da.Fill(ds, sTableName)
            End If

        Catch
            Stop
            Throw

        Finally
            conn.Close()
            da = Nothing

        End Try

        Return True

    End Function

    'fills table in dataset, requires connection string
    Public Shared Function GetDS(ByVal sConn As String, ByRef ds As DataSet, ByVal sSQL As String, Optional ByVal sTableName As String = "", Optional ByVal bAcceptChanges As Boolean = True) As Boolean
        Dim conn As SqlConnection

        Try
            conn = New SqlConnection(sConn)

            GetDS(conn, ds, sSQL, sTableName, bAcceptChanges)

        Catch
            Stop
            Throw

        Finally
            conn = Nothing

        End Try

        Return True

    End Function

    'base function to fill table in dataset, requires sql connection
    Public Shared Function GetDataTable(ByRef conn As SqlConnection, ByRef dt As DataTable, ByVal sSQL As String, Optional ByVal bAcceptChanges As Boolean = True) As Boolean
        Dim da As SqlDataAdapter

        If conn.State = ConnectionState.Closed Then conn.Open()

        Try
            da = New SqlDataAdapter(sSQL, conn)
            da.AcceptChangesDuringFill = bAcceptChanges
            da.Fill(dt)

        Catch
            Stop
            Throw

        Finally
            conn.Close()
            da = Nothing

        End Try

        Return True

    End Function

    'base function to fill table in dataset, requires sql connection
    Public Shared Function GetDataTable(ByRef sConn As String, ByRef dt As DataTable, ByVal sSQL As String, Optional ByVal bAcceptChanges As Boolean = True) As Boolean
        Dim conn As SqlConnection

        Try
            conn = New SqlConnection(sConn)

            GetDataTable(conn, dt, sSQL, bAcceptChanges)

        Catch
            Stop
            Throw

        Finally
            conn = Nothing

        End Try

        Return True

    End Function

    Public Shared Function GetSchema(ByRef ds As DataSet, ByVal sTableName As String, ByVal sConnStr As String) As Boolean
        Dim da As SqlDataAdapter
        Dim sSQL As String

        If IsNothing(ds) Then
            ds = New DataSet
        End If

        Try
            sSQL = String.Format("SELECT * FROM {0}", sTableName)

            ' Create new DataAdapter
            da = New SqlDataAdapter(sSQL, sConnStr)


            ' Fill DataSet from DataAdapter
            If sTableName <> "" Then
                da.FillSchema(ds, SchemaType.Source, sTableName)

            End If

        Catch
            Stop
            Throw

        Finally
            da = Nothing

        End Try

        Return True

    End Function

    Public Shared Function GetSchemaSQL(ByRef ds As DataSet, ByVal sSQL As String, ByVal sTableName As String, ByVal sConnStr As String) As Boolean
        Dim da As SqlDataAdapter

        If IsNothing(ds) Then
            ds = New DataSet
        End If

        Try

            ' Create new DataAdapter
            da = New SqlDataAdapter(sSQL, sConnStr)


            ' Fill DataSet from DataAdapter
            da.FillSchema(ds, SchemaType.Source, sTableName)


        Catch
            Stop
            Throw

        End Try

        Return True

    End Function

    Public Shared Function QuoteString(ByVal Value As Object) As String

        If IsDBNull(Value) Then
            Return "''"
        Else
            Return String.Format("'{0}'", Value.ToString.Replace("'", "''"))
        End If


    End Function

    Public Shared Function FormatDateValue(ByVal Value As String) As String

        If IsDate(Value) And Not Value = "1/1/0001" Then
            Return String.Format("'{0}'", FormatDateTime(CDate(Value), DateFormat.GeneralDate))
        Else
            Return "NULL"
        End If

    End Function

    Public Shared Function GetRS(ByRef ds As DataSet, ByVal sDSQuery As String) As DataRow()
        Dim regex As New System.Text.RegularExpressions.Regex("^SELECT (.*) FROM (.*) WHERE (.*)$", Text.RegularExpressions.RegexOptions.IgnoreCase)
        Dim oMatch As System.Text.RegularExpressions.Match
        Dim sDataTable As String
        Dim sCondition As String
        Dim dt As DataTable

        oMatch = regex.Match(sDSQuery)

        If oMatch.Success Then
            'get query parameters
            sDataTable = oMatch.Groups(2).ToString
            sCondition = oMatch.Groups(3).ToString

            'get datatable
            dt = ds.Tables(sDataTable)

            'filter rows
            Return dt.Select(sCondition)

        End If

        Return Nothing

    End Function

    Public Shared Function GetRSValue(ByRef ds As DataSet, ByVal sDSQuery As String) As Object
        Dim regex As New System.Text.RegularExpressions.Regex("^SELECT (.*) FROM .* WHERE .*$", Text.RegularExpressions.RegexOptions.IgnoreCase)
        Dim oMatch As System.Text.RegularExpressions.Match
        Dim sCol As String
        Dim dr As DataRow()

        oMatch = regex.Match(sDSQuery)

        If oMatch.Success Then
            sCol = oMatch.Groups(1).ToString

            dr = GetRS(ds, sDSQuery)

            If dr.Length > 0 Then
                Return dr(0).Item(sCol)

            End If

        End If

        Return Nothing

    End Function

    Public Shared Function GetDataRow(ByRef ds As DataSet, ByVal sDSQuery As String) As DataRow
        Dim dr As DataRow()

        dr = GetRS(ds, sDSQuery)

        If dr.Length > 0 Then
            Return dr(0)

        End If

        Return Nothing

    End Function

    Public Shared Function GetDataRow(ByVal sql As String, ByVal connection As SqlClient.SqlConnection) As DataRow
        Dim ds As New DataSet

        If GetDS(connection, ds, sql) Then
            If ds.Tables(0).Rows.Count = 1 Then
                Return ds.Tables(0).Rows(0)

            End If
        End If

        Return Nothing

    End Function

    'this works like GetDS() but will function for typed datasts even when "option strict" is on
    <Obsolete("Please use sqlHelper functions", False)> _
    Public Shared Function GetTypedDS(ByRef conn As SqlConnection, ByVal ds As DataSet, ByVal sSQL As String, ByVal sTableName As String) As DataSet
        Dim da As SqlDataAdapter

        conn.Open()

        Try
            da = New SqlDataAdapter(sSQL, conn)
            da.Fill(ds, sTableName)
            Return ds

        Catch
            Stop
            Throw

        Finally
            da = Nothing
            conn.Close()

        End Try

    End Function

    <Obsolete("Please use sqlHelper functions", False)> _
Public Shared Function GetValue(ByVal sSQL As String, ByVal sConnStr As String) As Object
        Dim oConn As New SqlConnection(sConnStr)
        Dim oCommand As New SqlCommand(sSQL, oConn)
        Dim oReturnValue As Object

        Try
            oReturnValue = oCommand.ExecuteScalar
            oConn.Close()

        Catch
            Stop
            Throw

        Finally
            oConn = Nothing
            oCommand = Nothing

        End Try

        Return oReturnValue

    End Function

    <Obsolete("Please use sqlHelper functions", False)> _
    Public Shared Function GetValue(ByVal sSQL As String, ByVal oConn As SqlConnection) As Object
        Dim oCommand As New SqlCommand(sSQL, oConn)
        Dim oReturnValue As Object

        Try
            oConn.Open()
            oReturnValue = oCommand.ExecuteScalar
            oConn.Close()
            Return oReturnValue

        Catch
            Stop
            Throw
        End Try


    End Function

    <Obsolete("Please use sqlHelper functions", False)> _
    Public Shared Function ExecCmd(ByVal sSQL As String, ByVal sConnStr As String) As Integer
        Dim cmd As SqlCommand
        Dim intRows As Integer

        Try
            cmd = New SqlCommand
            ' Create a Connection object
            cmd.Connection = New SqlConnection(sConnStr)

            ' Fill in command text, set type
            cmd.CommandText = sSQL
            cmd.CommandType = CommandType.Text

            ' Open the Connection
            cmd.Connection.Open()

            ' Execute SQL
            intRows = cmd.ExecuteNonQuery()
        Catch
            Stop
            Throw

        Finally
            ' Close the Connection
            If ((Not (cmd.Connection Is Nothing)) AndAlso cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
        End Try

        Return intRows

    End Function

End Class
