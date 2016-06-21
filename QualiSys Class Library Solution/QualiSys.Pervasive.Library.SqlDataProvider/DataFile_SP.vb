'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
	Public Const DeleteDataFile As String = "dbo.LD_DeleteDataFile"
	Public Const InsertDataFile As String = "dbo.LD_InsertDataFile"
	Public Const SelectAllDataFiles As String = "dbo.LD_SelectAllDataFiles"
	Public Const SelectDataFile As String = "dbo.LD_SelectDataFile"
    Public Const UpdateDataFile As String = "dbo.LD_UpdateDataFile"
    Public Const ValidateDataFile As String = "dbo.LD_RunValidation"
    Public Const ApplyDataFile As String = "dbo.LD_ApplyShell"
    Public Const CheckForDuplicateCCNInSampleMonth As String = "dbo.LD_CheckForDuplicateCCNInSampleMonth"
    Public Const DisableAutoSampling As String = "dbo.LD_DisableAutoSamplingByStudyID"
    Public Const UnscheduledSamplesetByDataFileID As String = "LD_UnscheduledSamplesetByDataFileID"
End Class
#End Region
