'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
    Public Const DeleteVendorPhoneFile_Data As String = "dbo.QSL_DeleteVendorPhoneFile_Data"
    Public Const InsertVendorPhoneFile_Data As String = "dbo.QSL_InsertVendorPhoneFile_Data"
    Public Const SelectAllVendorPhoneFile_Datas As String = "dbo.QSL_SelectAllVendorPhoneFile_Datas"
    Public Const SelectVendorPhoneFile_Data As String = "dbo.QSL_SelectVendorPhoneFile_Data"
    Public Const SelectVendorPhoneFile_DatasByVendorFileId As String = "dbo.QSL_SelectVendorPhoneFile_DatasByVendorFileId"
    Public Const UpdateVendorPhoneFile_Data As String = "dbo.QSL_UpdateVendorPhoneFile_Data"
    Public Const PhoneVendorCancelList As String = "dbo.QSL_PhoneVendorCancelList"
    Public Const PhoneVendorListSent As String = "dbo.QSL_PhoneVendorListSent"
End Class
#End Region
