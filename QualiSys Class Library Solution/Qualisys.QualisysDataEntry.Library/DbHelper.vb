Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Public Class DbHelper

    Private Shared mDatabase As Database

    Private Shared ReadOnly Property Db() As Database
        Get
            If mDatabase Is Nothing Then
                mDatabase = New Sql.SqlDatabase(Config.QualisysConnection)
            End If

            Return mDatabase
        End Get
    End Property
    Public Shared Function CheckNull(ByVal obj As Object, ByVal nullValue As Object) As Object
        If IsDBNull(obj) Then
            Return nullValue
        Else
            Return obj
        End If
    End Function

    Public Shared Function CheckNull(Of T)(ByVal obj As Object, ByVal nullValue As T) As T
        If IsDBNull(obj) Then
            Return nullValue
        Else
            Return CType(obj, T)
        End If
    End Function

    Public Shared Function ExecuteDataset(ByVal procedure As String, ByVal ParamArray params() As Object) As DataSet
        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedure, params)
        cmd.CommandTimeout = Config.SqlTimeout
        Dim ExecuteDataSetLogEntry As Log = New Log("ExecuteDataset", cmd)
        Return Db.ExecuteDataSet(cmd)
    End Function

    Public Shared Function ExecuteReader(ByVal procedure As String, ByVal ParamArray params() As Object) As IDataReader
        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedure, params)
        cmd.CommandTimeout = Config.SqlTimeout
        Dim ExecuteReaderLogEntry As Log = New Log("ExecuteReader", cmd)
        Return Db.ExecuteReader(cmd)
    End Function

    Public Shared Function ExecuteScalar(ByVal procedure As String, ByVal ParamArray params() As Object) As Object
        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedure, params)
        cmd.CommandTimeout = Config.SqlTimeout
        Dim ExecuteScalarLogEntry As Log = New Log("ExecuteScalar", cmd)
        Return Db.ExecuteScalar(cmd)
    End Function

    Public Shared Function ExecuteScalar(Of T)(ByVal procedure As String, ByVal ParamArray params() As Object) As T
        Return CType(ExecuteScalar(procedure, params), T)
    End Function

    Public Shared Sub ExecuteNonQuery(ByVal procedure As String, ByVal ParamArray params() As Object)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedure, params)
        cmd.CommandTimeout = Config.SqlTimeout
        Dim ExecuteNonQueryLogEntry As Log = New Log("ExecuteNonQuery", cmd)
        Db.ExecuteNonQuery(cmd)
    End Sub

    



End Class


