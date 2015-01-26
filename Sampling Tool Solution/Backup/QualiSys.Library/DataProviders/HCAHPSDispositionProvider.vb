Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class HCAHPSDispositionProvider

#Region " Singleton Implementation "
    Private Shared mInstance As HCAHPSDispositionProvider
	Private Const mProviderName As String = "HCAHPSDispositionProvider"
	Public Shared ReadOnly Property Instance() As HCAHPSDispositionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProvider.DataProviderFactory.CreateInstance(Of HCAHPSDispositionProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectHCAHPSDisposition(ByVal hCAHPSDispositionID As Integer) As HCAHPSDisposition
	Public MustOverride Function SelectAllHCAHPSDispositions() As HCAHPSDispositionCollection
	Public MustOverride Function SelectHCAHPSDispositionsByDispositionId(ByVal dispositionId As Integer) As HCAHPSDispositionCollection
	Public MustOverride Function InsertHCAHPSDisposition(ByVal instance As HCAHPSDisposition) As Integer
	Public MustOverride Sub UpdateHCAHPSDisposition(ByVal instance As HCAHPSDisposition)
	Public MustOverride Sub DeleteHCAHPSDisposition(ByVal HCAHPSDisposition As HCAHPSDisposition)
End Class

