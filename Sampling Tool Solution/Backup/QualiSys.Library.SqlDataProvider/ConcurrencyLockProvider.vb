Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class ConcurrencyLockProvider
    Inherits Nrc.QualiSys.Library.DataProvider.ConcurrencyLockProvider

    Private Function PopulateConcurrencyLock(ByVal rdr As SafeDataReader) As ConcurrencyLock
        Dim id As Integer = rdr.GetInteger("ConcurrencyLock_id")
        Dim categoryId As Integer = rdr.GetInteger("LockCategory_id")
        If Not System.Enum.IsDefined(GetType(ConcurrencyLockCategory), categoryId) Then
            Throw New Exception(categoryId & " is not a valid ConcurrencyLockCategory value.")
        End If
        Dim lockCategory As ConcurrencyLockCategory = CType(categoryId, ConcurrencyLockCategory)
        Dim lockValueId As Integer = rdr.GetInteger("LockValue_id")
        Dim userName As String = rdr.GetString("UserName")
        Dim machineName As String = rdr.GetString("MachineName")
        Dim processName As String = rdr.GetString("ProcessName")
        Dim acquisitionTime As Date = rdr.GetDate("AcquisitionTime")
        Dim expirationTime As Date = rdr.GetDate("ExpirationTime")

        Return CreateNewConcurrencyLock(id, lockCategory, lockValueId, userName, machineName, processName, acquisitionTime, expirationTime)
    End Function
    Public Overrides Sub Delete(ByVal concurrencyLockId As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteConcurrencyLock, concurrencyLockId)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Function Insert(ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer, ByVal userName As String, ByVal machineName As String, ByVal processName As String, ByVal expirationTime As Date) As ConcurrencyLock
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertConcurrencyLock, CType(lockCategory, Integer), lockValueId, userName, machineName, processName, expirationTime)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateConcurrencyLock(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectAll() As Collection(Of ConcurrencyLock)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllConcurrencyLocks)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ConcurrencyLock)(rdr, AddressOf PopulateConcurrencyLock)
        End Using
    End Function

    Public Overrides Function [Select](ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer) As ConcurrencyLock
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectConcurrencyLock, CType(lockCategory, Integer), lockValueId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateConcurrencyLock(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectByCategory(ByVal lockCategory As ConcurrencyLockCategory) As Collection(Of ConcurrencyLock)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectConcurrencyLocksByCategory, CType(lockCategory, Integer))
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ConcurrencyLock)(rdr, AddressOf PopulateConcurrencyLock)
        End Using
    End Function

    Public Overrides Function SelectServerTime() As Date
        Dim sql As String = "SELECT GETDATE() AS ServerTime"
        Dim cmd As DbCommand = Db.GetSqlStringCommand(sql)
        Using rdr As IDataReader = ExecuteReader(cmd)
            rdr.Read()
            Return rdr.GetDateTime(0)
        End Using
    End Function

    Public Overrides Sub Update(ByVal concurrencyLockId As Integer, ByVal expirationTime As Date)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateConcurrencyLock, concurrencyLockId, expirationTime)
        ExecuteNonQuery(cmd)
    End Sub


End Class
