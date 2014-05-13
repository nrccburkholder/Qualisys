Imports System.Data.SqlClient

Namespace Data

    Public MustInherit Class SQLDataLayer

        Protected _ConnectionString As String

        Sub New(ByVal ConnectionString As String)
            Me._ConnectionString = ConnectionString
        End Sub

        Protected Shared Function GetParams(ByVal Conn As String, ByVal Procedure As String) As SqlParameter()
            Return SqlHelperParameterCache.GetSpParameterSet(Conn, Procedure)
        End Function

        Protected Shared Function GetParams(ByVal Connection As SqlClient.SqlConnection, ByVal Procedure As String) As SqlParameter()
            Return SqlHelperParameterCache.GetSpParameterSet(Connection, Procedure)
        End Function

        Protected Function GetParams(ByVal Procedure As String) As SqlParameter()
            Return SQLDataLayer.GetParams(Me._ConnectionString, Procedure)
        End Function

        Protected Shared Function ExecuteDataset(ByVal strConnection As String, ByVal Procedure As String, ByVal ParamArray Params() As Object) As DataSet
            If VerifyParams(strConnection, Procedure, Params) Then
                Return SqlHelper.ExecuteDataset(strConnection, Procedure, Params)
            Else
                Throw New Exception("Parameters do not match the stored procedure.")
            End If
        End Function
        Protected Shared Function ExecuteDataset(ByVal Transaction As SqlClient.SqlTransaction, ByVal Procedure As String, ByVal ParamArray Params() As Object) As DataSet
            If VerifyParams(Transaction.Connection, Procedure, Params) Then
                Return SqlHelper.ExecuteDataset(Transaction, CommandType.StoredProcedure, Procedure, Params)
            Else
                Throw New Exception("Parameters do not match the stored procedure.")
            End If
        End Function

        Protected Function ExecuteDataset(ByVal Procedure As String, ByVal ParamArray Params As Object()) As DataSet
            SQLDataLayer.ExecuteDataset(Me._ConnectionString, Procedure, Params)
        End Function

        Protected Shared Function ExecuteDataset(ByVal strConnection As String, ByVal SQL As String) As DataSet
            Return SqlHelper.ExecuteDataset(strConnection, CommandType.Text, SQL)
        End Function
        Protected Shared Function ExecuteDataset(ByVal Transaction As SqlTransaction, ByVal SQL As String) As DataSet
            Return SqlHelper.ExecuteDataset(Transaction, CommandType.Text, SQL)
        End Function

        Protected Function ExecuteDataset(ByVal SQL As String) As DataSet
            Return SQLDataLayer.ExecuteDataset(Me._ConnectionString, SQL)
        End Function

        Protected Shared Function ExecuteReader(ByVal strConnection As String, ByVal Procedure As String, ByVal ParamArray Params() As Object) As SqlDataReader
            If VerifyParams(strConnection, Procedure, Params) Then
                Return SqlHelper.ExecuteReader(strConnection, Procedure, Params)
            Else
                Throw New Exception("Parameters do not match the stored procedure.")
            End If
        End Function
        Protected Shared Function ExecuteReader(ByVal Transaction As SqlTransaction, ByVal Procedure As String, ByVal ParamArray Params() As Object) As SqlDataReader
            If VerifyParams(Transaction.Connection, Procedure, Params) Then
                Return SqlHelper.ExecuteReader(Transaction, Procedure, Params)
            Else
                Throw New Exception("Parameters do not match the stored procedure.")
            End If
        End Function

        Protected Function ExecuteReader(ByVal Procedure As String, ByVal ParamArray Params() As Object) As SqlDataReader
            Return SQLDataLayer.ExecuteReader(Me._ConnectionString, Procedure, Params)
        End Function

        Protected Shared Function ExecuteReader(ByVal strConnection As String, ByVal SQL As String) As SqlDataReader
            Return SqlHelper.ExecuteReader(strConnection, CommandType.Text, SQL)
        End Function
        Protected Shared Function ExecuteReader(ByVal Transaction As SqlTransaction, ByVal SQL As String) As SqlDataReader
            Return SqlHelper.ExecuteReader(Transaction, CommandType.Text, SQL)
        End Function

        Protected Function ExecuteReader(ByVal SQL As String) As SqlDataReader
            Return SQLDataLayer.ExecuteReader(Me._ConnectionString, SQL)
        End Function

        Protected Shared Function ExecuteNonQuery(ByVal strConnection As String, ByVal Procedure As String, ByVal ParamArray Params() As Object) As Integer
            If VerifyParams(strConnection, Procedure, Params) Then
                Return SqlHelper.ExecuteNonQuery(strConnection, Procedure, Params)
            Else
                Throw New Exception("Parameters do not match the stored procedure.")
            End If
        End Function
        Protected Shared Function ExecuteNonQuery(ByVal Transaction As SqlTransaction, ByVal Procedure As String, ByVal ParamArray Params() As Object) As Integer
            If VerifyParams(Transaction.Connection, Procedure, Params) Then
                Return SqlHelper.ExecuteNonQuery(Transaction, Procedure, Params)
            Else
                Throw New Exception("Parameters do not match the stored procedure.")
            End If
        End Function

        Protected Function ExecuteNonQuery(ByVal Procedure As String, ByVal ParamArray Params() As Object) As Integer
            Return SQLDataLayer.ExecuteNonQuery(Me._ConnectionString, Procedure, Params)
        End Function

        Protected Shared Function ExecuteNonQuery(ByVal strConnection As String, ByVal SQL As String) As Integer
            Return SqlHelper.ExecuteNonQuery(strConnection, CommandType.Text, SQL)
        End Function
        Protected Shared Function ExecuteNonQuery(ByVal Transaction As SqlTransaction, ByVal SQL As String) As Integer
            Return SqlHelper.ExecuteNonQuery(Transaction, CommandType.Text, SQL)
        End Function

        Protected Function ExecuteNonQuery(ByVal SQL As String) As Integer
            Return SQLDataLayer.ExecuteNonQuery(Me._ConnectionString, SQL)
        End Function

        Protected Shared Function ExecuteScalar(ByVal strConnection As String, ByVal Procedure As String, ByVal ParamArray Params() As Object) As Object
            If VerifyParams(strConnection, Procedure, Params) Then
                Return SqlHelper.ExecuteScalar(strConnection, Procedure, Params)
            Else
                Throw New Exception("Parameters do not match the stored procedure.")
            End If
        End Function
        Protected Shared Function ExecuteScalar(ByVal Transaction As SqlTransaction, ByVal Procedure As String, ByVal ParamArray Params() As Object) As Object
            If VerifyParams(Transaction.Connection, Procedure, Params) Then
                Return SqlHelper.ExecuteScalar(Transaction, Procedure, Params)
            Else
                Throw New Exception("Parameters do not match the stored procedure.")
            End If
        End Function

        Protected Function ExecuteScalar(ByVal Procedure As String, ByVal ParamArray Params() As Object) As Object
            Return SQLDataLayer.ExecuteScalar(Me._ConnectionString, Procedure, Params)
        End Function

        Protected Shared Function ExecuteScalar(ByVal strConnection As String, ByVal SQL As String) As Object
            Return SqlHelper.ExecuteScalar(strConnection, CommandType.Text, SQL)
        End Function
        Protected Shared Function ExecuteScalar(ByVal Transaction As SqlTransaction, ByVal SQL As String) As Object
            Return SqlHelper.ExecuteScalar(Transaction, CommandType.Text, SQL)
        End Function

        Protected Function ExecuteScalar(ByVal SQL As String) As Object
            Return SQLDataLayer.ExecuteScalar(Me._ConnectionString, SQL)
        End Function

        Protected Shared Function VerifyParams(ByVal Conn As String, ByVal Procedure As String, ByVal Params() As Object) As Boolean
            Dim connection As New SqlConnection(Conn)
            Return VerifyParams(connection, Procedure, Params)
        End Function
        Protected Shared Function VerifyParams(ByVal Conn As SqlConnection, ByVal Procedure As String, ByVal Params() As Object) As Boolean
            Dim ParamsReal As SqlParameter() = GetParams(Conn, Procedure)
            Dim test As Type

            If Not ParamsReal.Length = Params.Length Then
                Return False
            End If

            Dim i As Integer
            For i = 0 To Params.Length - 1
                If Not Params(i) Is Nothing Then
                    Select Case ParamsReal(i).SqlDbType
                        Case SqlDbType.Bit
                            If Not TypeOf Params(i) Is Boolean Then
                                Return False
                            End If
                        Case SqlDbType.Char
                            If Not TypeOf Params(i) Is String Then
                                Return False
                            End If
                        Case SqlDbType.DateTime
                            If Not TypeOf Params(i) Is DateTime Then
                                Return False
                            End If
                        Case SqlDbType.Float
                            If Not TypeOf Params(i) Is Double Then
                                Return False
                            End If
                        Case SqlDbType.Int
                            If Not TypeOf Params(i) Is Integer Then
                                Return False
                            End If
                        Case SqlDbType.Text
                            If Not TypeOf Params(i) Is String Then
                                Return False
                            End If
                        Case SqlDbType.VarChar
                            If Not TypeOf Params(i) Is String Then
                                Return False
                            End If
                    End Select
                End If
            Next

            Return True
        End Function

        Protected Function VerifyParams(ByVal Procedure As String, ByVal Params() As Object) As Boolean
            Return VerifyParams(Me._ConnectionString, Procedure, Params)
        End Function

    End Class

End Namespace
