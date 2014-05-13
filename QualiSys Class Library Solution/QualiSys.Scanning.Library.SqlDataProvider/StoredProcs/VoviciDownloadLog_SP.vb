'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
    Public Const DeleteVoviciDownloadLog As String = "dbo.QSL_DeleteVoviciDownloadLog"
    Public Const InsertVoviciDownloadLog As String = "dbo.QSL_InsertVoviciDownloadLog"
    Public Const SelectAllVoviciDownloadLogs As String = "dbo.QSL_SelectAllVoviciDownloadLogs"
    Public Const SelectVoviciDownloadLog As String = "dbo.QSL_SelectVoviciDownloadLog"
    Public Const SelectVoviciDownloadLogBySurveyID As String = "dbo.QSL_SelectVoviciDownloadLogBySurveyID"
    Public Const UpdateVoviciDownloadLog As String = "dbo.QSL_UpdateVoviciDownloadLog"
End Class
#End Region
