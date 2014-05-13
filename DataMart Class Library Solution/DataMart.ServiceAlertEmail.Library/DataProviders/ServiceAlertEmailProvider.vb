Imports NRC.Framework.BusinessLogic

Public MustInherit Class ServiceAlertEmailProvider

#Region " Singleton Implementation "

    Private Shared mInstance As ServiceAlertEmailProvider
    Private Const mProviderName As String = "ServiceAlertEmailProvider"

    Public Shared ReadOnly Property Instance() As ServiceAlertEmailProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of ServiceAlertEmailProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectAllServiceAlertEmails() As ServiceAlertEmailCollection

End Class

