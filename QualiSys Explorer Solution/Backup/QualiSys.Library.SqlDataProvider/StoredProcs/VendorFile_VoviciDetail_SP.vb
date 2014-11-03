'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
	Public Const DeleteVendorFile_VoviciDetail As String = "dbo.QCL_DeleteVendorFile_VoviciDetail"
	Public Const InsertVendorFile_VoviciDetail As String = "dbo.QCL_InsertVendorFile_VoviciDetail"
	Public Const SelectAllVendorFile_VoviciDetails As String = "dbo.QCL_SelectAllVendorFile_VoviciDetails"
	Public Const SelectVendorFile_VoviciDetail As String = "dbo.QCL_SelectVendorFile_VoviciDetail"
	Public Const SelectVendorFile_VoviciDetailsByMailingStepId As String = "dbo.QCL_SelectVendorFile_VoviciDetailsByMailingStepId"
	Public Const SelectVendorFile_VoviciDetailsBySurveyId As String = "dbo.QCL_SelectVendorFile_VoviciDetailsBySurveyId"
	Public Const UpdateVendorFile_VoviciDetail As String = "dbo.QCL_UpdateVendorFile_VoviciDetail"
End Class
#End Region
