Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VendorPhoneFile_DataProvider

#Region " Singleton Implementation "
    Private Shared mInstance As VendorPhoneFile_DataProvider
	Private Const mProviderName As String = "VendorPhoneFile_DataProvider"
	Public Shared ReadOnly Property Instance() As VendorPhoneFile_DataProvider
        Get
            If mInstance Is Nothing Then
				mInstance = DataProviderFactory.CreateInstance(Of VendorPhoneFile_DataProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectVendorPhoneFile_Data(ByVal vendorFile_DataId As Integer) As VendorPhoneFile_Data
	Public MustOverride Function SelectAllVendorPhoneFile_Datas() As VendorPhoneFile_DataCollection
	Public MustOverride Function SelectVendorPhoneFile_DatasByVendorFileId(ByVal vendorFileId As Integer) As VendorPhoneFile_DataCollection
	Public MustOverride Function InsertVendorPhoneFile_Data(ByVal instance As VendorPhoneFile_Data) As Integer
	Public MustOverride Sub UpdateVendorPhoneFile_Data(ByVal instance As VendorPhoneFile_Data)
	Public MustOverride Sub DeleteVendorPhoneFile_Data(ByVal VendorPhoneFile_Data As VendorPhoneFile_Data)
End Class

