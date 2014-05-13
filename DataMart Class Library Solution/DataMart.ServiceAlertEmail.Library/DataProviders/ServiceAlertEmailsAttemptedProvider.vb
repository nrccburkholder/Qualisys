Public MustInherit Class ServiceAlertEmailsAttemptedProvider

#Region " Singleton Implementation "

    Private Shared mInstance As ServiceAlertEmailsAttemptedProvider
    Private Const mProviderName As String = "ServiceAlertEmailsAttemptedProvider"

    Public Shared ReadOnly Property Instance() As ServiceAlertEmailsAttemptedProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of ServiceAlertEmailsAttemptedProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectAllServiceAlertEmailsAttempted() As ServiceAlertEmailsAttemptedCollection
    Public MustOverride Function InsertServiceAlertEmailsAttempted(ByVal instance As ServiceAlertEmailsAttempted) As Integer
    Public MustOverride Sub UpdateServiceAlertEmailsAttempted(ByVal instance As ServiceAlertEmailsAttempted)

End Class

