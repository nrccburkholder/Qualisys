'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
	Public Const DeleteHHCAHPSDisposition As String = "dbo.QCL_DeleteHHCAHPSDisposition"
	Public Const InsertHHCAHPSDisposition As String = "dbo.QCL_InsertHHCAHPSDisposition"
	Public Const SelectAllHHCAHPSDispositions As String = "dbo.QCL_SelectAllHHCAHPSDispositions"
	Public Const SelectHHCAHPSDisposition As String = "dbo.QCL_SelectHHCAHPSDisposition"
	Public Const SelectHHCAHPSDispositionsByDispositionId As String = "dbo.QCL_SelectHHCAHPSDispositionsByDispositionId"
	Public Const UpdateHHCAHPSDisposition As String = "dbo.QCL_UpdateHHCAHPSDisposition"
End Class
#End Region
