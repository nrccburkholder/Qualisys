'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
	Public Const DeleteSurveyType As String = "dbo.QCL_DeleteSurveyType"
	Public Const InsertSurveyType As String = "dbo.QCL_InsertSurveyType"
	Public Const SelectAllSurveyTypes As String = "dbo.QCL_SelectAllSurveyTypes"
	Public Const SelectSurveyType As String = "dbo.QCL_SelectSurveyType"
	Public Const UpdateSurveyType As String = "dbo.QCL_UpdateSurveyType"
End Class
#End Region
