Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class HHCAHPSDispositionProvider

#Region " Singleton Implementation "
    Private Shared mInstance As HHCAHPSDispositionProvider
	Private Const mProviderName As String = "HHCAHPSDispositionProvider"
	Public Shared ReadOnly Property Instance() As HHCAHPSDispositionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProvider.DataProviderFactory.CreateInstance(Of HHCAHPSDispositionProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectHHCAHPSDisposition(ByVal hHCAHPSDispositionID As Integer) As HHCAHPSDisposition
	Public MustOverride Function SelectAllHHCAHPSDispositions() As HHCAHPSDispositionCollection
	Public MustOverride Function SelectHHCAHPSDispositionsByDispositionId(ByVal dispositionId As Integer) As HHCAHPSDispositionCollection
	Public MustOverride Function InsertHHCAHPSDisposition(ByVal instance As HHCAHPSDisposition) As Integer
	Public MustOverride Sub UpdateHHCAHPSDisposition(ByVal instance As HHCAHPSDisposition)
	Public MustOverride Sub DeleteHHCAHPSDisposition(ByVal HHCAHPSDisposition As HHCAHPSDisposition)
End Class

