'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
	Public Const DeleteHCAHPSDisposition As String = "dbo.QCL_DeleteHCAHPSDisposition"
	Public Const InsertHCAHPSDisposition As String = "dbo.QCL_InsertHCAHPSDisposition"
	Public Const SelectAllHCAHPSDispositions As String = "dbo.QCL_SelectAllHCAHPSDispositions"
	Public Const SelectHCAHPSDisposition As String = "dbo.QCL_SelectHCAHPSDisposition"
	Public Const SelectHCAHPSDispositionsByDispositionId As String = "dbo.QCL_SelectHCAHPSDispositionsByDispositionId"
	Public Const UpdateHCAHPSDisposition As String = "dbo.QCL_UpdateHCAHPSDisposition"
End Class
#End Region
