Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VoviciDownloadLogProvider

#Region " Singleton Implementation "
    Private Shared mInstance As VoviciDownloadLogProvider
	Private Const mProviderName As String = "VoviciDownloadLogProvider"
	Public Shared ReadOnly Property Instance() As VoviciDownloadLogProvider
        Get
            If mInstance Is Nothing Then
				mInstance = DataProviderFactory.CreateInstance(Of VoviciDownloadLogProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectVoviciDownloadLog(ByVal voviciDownloadId As Integer) As VoviciDownloadLog
    Public MustOverride Function SelectVoviciDownloadLogBySurveyID(ByVal voviciSurveyId As String) As VoviciDownloadLog
    Public MustOverride Function SelectAllVoviciDownloadLogs() As VoviciDownloadLogCollection
	Public MustOverride Function InsertVoviciDownloadLog(ByVal instance As VoviciDownloadLog) As Integer
	Public MustOverride Sub UpdateVoviciDownloadLog(ByVal instance As VoviciDownloadLog)
	Public MustOverride Sub DeleteVoviciDownloadLog(ByVal VoviciDownloadLog As VoviciDownloadLog)
End Class

