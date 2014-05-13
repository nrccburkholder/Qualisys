'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
    Public Const DeleteVendorFileStatus As String = "dbo.QSL_DeleteVendorFileStatus"
    Public Const InsertVendorFileStatus As String = "dbo.QSL_InsertVendorFileStatus"
    Public Const SelectAllVendorFileStatus As String = "dbo.QSL_SelectAllVendorFileStatus"
    Public Const SelectVendorFileStatus As String = "dbo.QSL_SelectVendorFileStatus"
    Public Const SelectVendorFileStatusById As String = "dbo.QSL_SelectVendorFileStatusById"
    Public Const UpdateVendorFileStatus As String = "dbo.QSL_UpdateVendorFileStatus"
End Class
#End Region
