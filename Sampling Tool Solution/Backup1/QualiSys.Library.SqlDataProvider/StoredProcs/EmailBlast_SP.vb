'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
    Public Const DeleteEmailBlast As String = "dbo.QCL_DeleteMM_EmailBlast"
    Public Const InsertEmailBlast As String = "dbo.QCL_InsertMM_EmailBlast"
    Public Const SelectAllEmailBlasts As String = "dbo.QCL_SelectAllMM_EmailBlasts"
    Public Const SelectEmailBlast As String = "dbo.QCL_SelectMM_EmailBlast"
    Public Const SelectEmailBlastsByEmailBlastId As String = "dbo.QCL_SelectMM_EmailBlastsByEmailBlastId"
    Public Const SelectEmailBlastsByMAILINGSTEPId As String = "dbo.QCL_SelectMM_EmailBlastsByMAILINGSTEPId"
    Public Const UpdateEmailBlast As String = "dbo.QCL_UpdateMM_EmailBlast"
End Class
#End Region
