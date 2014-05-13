Public Class LockRenewalFailedEventArgs
    Inherits EventArgs

    Private mException As ConcurrencyLockException

    Public ReadOnly Property Exception() As ConcurrencyLockException
        Get
            Return mException
        End Get
    End Property

    Sub New(ByVal ex As ConcurrencyLockException)
        mException = ex
    End Sub

End Class