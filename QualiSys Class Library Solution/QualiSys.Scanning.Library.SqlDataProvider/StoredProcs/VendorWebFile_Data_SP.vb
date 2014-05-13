'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
    Public Const DeleteVendorWebFile_Data As String = "dbo.QSL_DeleteVendorWebFile_Data"
    Public Const InsertVendorWebFile_Data As String = "dbo.QSL_InsertVendorWebFile_Data"
    Public Const SelectAllVendorWebFile_Datas As String = "dbo.QSL_SelectAllVendorWebFile_Datas"
    Public Const SelectVendorWebFile_Data As String = "dbo.QSL_SelectVendorWebFile_Data"
    Public Const SelectVendorWebFile_DatasByVendorFileId As String = "dbo.QSL_SelectVendorWebFile_DatasByVendorFileId"
    Public Const SelectVendorWebFile_DatasByLitho As String = "dbo.QSL_SelectVendorWebFile_DatasByLitho"
    Public Const UpdateVendorWebFile_Data As String = "dbo.QSL_UpdateVendorWebFile_Data"
End Class
#End Region
