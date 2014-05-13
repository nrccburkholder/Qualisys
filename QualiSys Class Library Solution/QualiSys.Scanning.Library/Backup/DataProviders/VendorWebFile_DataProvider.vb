Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VendorWebFile_DataProvider

#Region " Singleton Implementation "
    Private Shared mInstance As VendorWebFile_DataProvider
	Private Const mProviderName As String = "VendorWebFile_DataProvider"
	Public Shared ReadOnly Property Instance() As VendorWebFile_DataProvider
        Get
            If mInstance Is Nothing Then
				mInstance = DataProviderFactory.CreateInstance(Of VendorWebFile_DataProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectVendorWebFile_Data(ByVal id As Integer) As VendorWebFile_Data
	Public MustOverride Function SelectAllVendorWebFile_Datas() As VendorWebFile_DataCollection
    Public MustOverride Function SelectVendorWebFile_DatasByVendorFileId(ByVal vendorFileId As Integer, ByVal HidePII As Boolean) As VendorWebFile_DataCollection
    Public MustOverride Function SelectVendorWebFile_DatasByLitho(ByVal litho As String) As VendorWebFile_Data
    Public MustOverride Function InsertVendorWebFile_Data(ByVal instance As VendorWebFile_Data) As Integer
	Public MustOverride Sub UpdateVendorWebFile_Data(ByVal instance As VendorWebFile_Data)
	Public MustOverride Sub DeleteVendorWebFile_Data(ByVal VendorWebFile_Data As VendorWebFile_Data)
End Class

