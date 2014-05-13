Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class TransferResultsNavigatorTreeProvider

#Region " Singleton Implementation "
    Private Shared mInstance As TransferResultsNavigatorTreeProvider
    Private Const mProviderName As String = "TransferResultsNavigatorTreeProvider"
    Public Shared ReadOnly Property Instance() As TransferResultsNavigatorTreeProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of TransferResultsNavigatorTreeProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectTransferResultsNavigatorTreeByDateRange(ByVal StartDate As Date, ByVal EndDate As Date, ByVal sortMode As TransferSortModes) As TransferResultsNavigatorTreeCollection

End Class

