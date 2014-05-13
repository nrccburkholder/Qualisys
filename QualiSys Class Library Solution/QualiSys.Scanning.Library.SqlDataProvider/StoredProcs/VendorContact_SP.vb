'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
	Public Const DeleteVendorContact As String = "dbo.sp_DeleteVendorContact"
	Public Const InsertVendorContact As String = "dbo.sp_InsertVendorContact"
    Public Const SelectAllVendorContacts As String = "dbo.sp_SelectAllVendorContacts"
    Public Const SelectAllVendorContactsByVendor As String = "dbo.sp_SelectAllVendorContactsByVendor"
	Public Const SelectVendorContact As String = "dbo.sp_SelectVendorContact"
	Public Const UpdateVendorContact As String = "dbo.sp_UpdateVendorContact"
End Class
#End Region
