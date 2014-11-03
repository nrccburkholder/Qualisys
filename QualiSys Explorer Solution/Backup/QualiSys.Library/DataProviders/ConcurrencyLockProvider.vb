Namespace DataProvider
    Public MustInherit Class ConcurrencyLockProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ConcurrencyLockProvider
        Private Const mProviderName As String = "ConcurrencyLockProvider"

        Public Shared ReadOnly Property Instance() As ConcurrencyLockProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ConcurrencyLockProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub

        Public MustOverride Function [Select](ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer) As ConcurrencyLock
        Public MustOverride Function SelectByCategory(ByVal lockCategory As ConcurrencyLockCategory) As Collection(Of ConcurrencyLock)
        Public MustOverride Function SelectAll() As Collection(Of ConcurrencyLock)
        Public MustOverride Function Insert(ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer, ByVal userName As String, ByVal machineName As String, ByVal processName As String, ByVal expirationTime As DateTime) As ConcurrencyLock
        Public MustOverride Sub Update(ByVal concurrencyLockId As Integer, ByVal expirationTime As DateTime)
        Public MustOverride Sub Delete(ByVal concurrencyLockId As Integer)
        Public MustOverride Function SelectServerTime() As DateTime

        Protected Shared Function CreateNewConcurrencyLock(ByVal id As Integer, ByVal category As ConcurrencyLockCategory, ByVal lockValueId As Integer, ByVal userName As String, ByVal machineName As String, ByVal processName As String, ByVal acquisitionTime As Date, ByVal expirationTime As Date) As ConcurrencyLock
            Return New ConcurrencyLock(id, category, lockValueId, userName, machineName, processName, acquisitionTime, expirationTime)
        End Function

    End Class
End Namespace