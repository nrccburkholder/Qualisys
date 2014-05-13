Public MustInherit Class ServiceAlertEmailLogProvider

#Region " Singleton Implementation "

    Private Shared mInstance As ServiceAlertEmailLogProvider
    Private Const mProviderName As String = "ServiceAlertEmailLogProvider"

    Public Shared ReadOnly Property Instance() As ServiceAlertEmailLogProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of ServiceAlertEmailLogProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectAllServiceAlertEmailLogs() As ServiceAlertEmailLogCollection
    Public MustOverride Function InsertServiceAlertEmailLog(ByVal instance As ServiceAlertEmailLog) As Integer
    Public MustOverride Sub UpdateServiceAlertEmailLog(ByVal instance As ServiceAlertEmailLog)

End Class

