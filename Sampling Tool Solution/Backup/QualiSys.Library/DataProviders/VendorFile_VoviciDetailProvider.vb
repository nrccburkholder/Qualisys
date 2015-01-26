Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VendorFile_VoviciDetailProvider

#Region " Singleton Implementation "
    Private Shared mInstance As VendorFile_VoviciDetailProvider
	Private Const mProviderName As String = "VendorFile_VoviciDetailProvider"
	Public Shared ReadOnly Property Instance() As VendorFile_VoviciDetailProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProvider.DataProviderFactory.CreateInstance(Of VendorFile_VoviciDetailProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectVendorFile_VoviciDetail(ByVal vendorFile_VoviciDetailId As Integer) As VendorFile_VoviciDetail
	Public MustOverride Function SelectAllVendorFile_VoviciDetails() As VendorFile_VoviciDetailCollection
	Public MustOverride Function SelectVendorFile_VoviciDetailsBySurveyId(ByVal surveyId As Integer) As VendorFile_VoviciDetailCollection
	Public MustOverride Function SelectVendorFile_VoviciDetailsByMailingStepId(ByVal mailingStepId As Integer) As VendorFile_VoviciDetailCollection
	Public MustOverride Function InsertVendorFile_VoviciDetail(ByVal instance As VendorFile_VoviciDetail) As Integer
	Public MustOverride Sub UpdateVendorFile_VoviciDetail(ByVal instance As VendorFile_VoviciDetail)
	Public MustOverride Sub DeleteVendorFile_VoviciDetail(ByVal VendorFile_VoviciDetail As VendorFile_VoviciDetail)
End Class

