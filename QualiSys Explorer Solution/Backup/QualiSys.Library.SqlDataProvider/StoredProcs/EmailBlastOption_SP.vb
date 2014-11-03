'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
    Public Const DeleteEmailBlastOption As String = "dbo.QCL_DeleteMM_EmailBlast_Option"
    Public Const InsertEmailBlastOption As String = "dbo.QCL_InsertMM_EmailBlast_Option"
    Public Const SelectAllEmailBlastOptions As String = "dbo.QCL_SelectAllMM_EmailBlast_Options"
    Public Const SelectEmailBlastOption As String = "dbo.QCL_SelectMM_EmailBlast_Option"
    Public Const UpdateEmailBlastOption As String = "dbo.QCL_UpdateMM_EmailBlast_Option"
End Class
#End Region
