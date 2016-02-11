Friend Class SP
#Region " Question File Procs "
    Public Shared ReadOnly CreateQuestionFile As String = "dbo.SPU_CreateQuestionFile"
#End Region
#Region "UpdateType Procs"

    Public Shared ReadOnly SelectAllUpdateTypes As String = "dbo.sp_SPU_GetUpdateTypes"

#End Region

#Region "UpdateMapping Procs"

    Public Shared ReadOnly SelectUpdateMappingsByUpdateTypeID As String = "dbo.sp_SPU_GetUpdateMappings"

#End Region

#Region "UpdateRespondent Procs"

    Public Shared ReadOnly SelectUpdateRespondent As String = "dbo.sp_SPU_GetRespondentName"
    Public Shared ReadOnly SelectUpdateRespondentsByAlreadyUpdated As String = "dbo.SPU_CheckForRespondentsAlreadyProcessed"
    Public Shared ReadOnly SelectUpdateRespondentsByMissingStartCodes As String = "dbo.SPU_CheckForMissingVerificationCodes"
    Public Shared ReadOnly UpdateMissingEventCodes As String = "dbo.sp_SPU_FindMissingRespondentCodes"
    Public Shared ReadOnly UpdateMapping As String = "dbo.sp_SPU_UpdateRespondentEventLog"
    'Public Shared ReadOnly DeleteMapping As String = "dbo.sp_SPU_DeleteRespondentEventLog"
    'Public Shared ReadOnly InsertMapping As String = "dbo.Insert_EventLog"

#End Region

#Region "UpdateFileLog Procs"

    Public Shared ReadOnly InsertUpdateFileLog As String = "dbo.Insert_FileTrackingLog"
    Public Shared ReadOnly InsertUpdateFileLogRespondent As String = "dbo.Insert_RespondentsUpdated"
    Public Shared ReadOnly SelectAllUpdateFileLogs As String = "dbo.sp_SPU_GetFileTrackingLogByDate"
    Public Shared ReadOnly SelectUpdateFileLogsByDate As String = "dbo.sp_SPU_GetFileTrackingLogByDate"
    Public Shared ReadOnly SelectAllUpdateFileLogRespondents As String = "sp_SPU_GetRespondentsUpdated"

#End Region
#Region " Export Result File Controller Procs"
    Public Shared ReadOnly CreateAnwerFile As String = "dbo.SPU_CreateAnswerFile"
    Public Shared ReadOnly GetNumberOfRespondentsByClient As String = "dbo.SPU_CreateAnswerFile_RespondentCountsByClient"
#End Region
#Region " Export File Procs "
    Public Shared ReadOnly Mark2401EventsForLogFile As String = "dbo.SPU_Mark2401Code"                
#End Region
#Region "Script Extension Procs"

    Public Shared ReadOnly DeleteScriptExtension As String = "dbo.SPU_DeleteSPU_Script_Extension"
    Public Shared ReadOnly InsertScriptExtension As String = "dbo.SPU_InsertScript_Extension"
    Public Shared ReadOnly SelectAllScriptExtensions As String = "dbo.SPU_SelectAllSPU_Script_Extensions"
    Public Shared ReadOnly SelectScriptExtensionByID As String = "dbo.SPU_SelectSPU_Script_Extension"
    Public Shared ReadOnly SelectScriptExtensionsByScriptID As String = "dbo.SPU_SelectSPU_Script_ExtensionsByScriptID"
    Public Shared ReadOnly SelectScriptExtensionsByExportGroupID As String = "dbo.SPU_SelectSPU_Script_ExtensionsByExportGroupID"
    Public Shared ReadOnly SelectScriptExtensionsBySurveyID As String = "dbo.SPU_SelectSPU_Script_ExtensionsBySurveyID"
    Public Shared ReadOnly UpdateScriptExtension As String = "dbo.SPU_UpdateSPU_Script_Extension"

#End Region

#Region "Client Extension Procs"
    Public Shared ReadOnly DeleteClientExtension As String = "dbo.SPU_DeleteSPU_Client_Extension"
    Public Shared ReadOnly InsertClientExtension As String = "dbo.SPU_InsertClient_Extension"
    Public Shared ReadOnly SelectAllClientExtensions As String = "dbo.SPU_SelectAllSPU_Client_Extensions"
    Public Shared ReadOnly SelectClientExtensionByID As String = "dbo.SPU_SelectSPU_Client_Extension"
    Public Shared ReadOnly SelectClientExtensionsByClientID As String = "dbo.SPU_SelectSPU_Client_ExtensionsByClientID"
    Public Shared ReadOnly SelectClientExtensionsByExportGroupID As String = "dbo.SPU_SelectSPU_Client_ExtensionsByExportGroupID"
    Public Shared ReadOnly SelectClientExtensionsBySurveyID As String = "dbo.SPU_SelectSPU_Client_ExtensionsBySurveyID"
    Public Shared ReadOnly UpdateClientExtension As String = "dbo.SPU_UpdateSPU_Client_Extension"
#End Region
#Region " Event Procs "
    Public Shared ReadOnly InsertExportEvent As String = "dbo.SPU_InsertExportEvent"
#End Region
#Region "Export Group Procs"
    Public Shared ReadOnly DeleteExportGroup As String = "dbo.SPU_DeleteExportGroup"
    Public Shared ReadOnly InsertExportGroup As String = "dbo.SPU_InsertExportGroup"
    Public Shared ReadOnly SelectAllExportGroups As String = "dbo.SPU_GetAllExportGroups"
    Public Shared ReadOnly SelectExportGroup As String = "dbo.SPU_GetExportGroup"
    Public Shared ReadOnly UpdateExportGroup As String = "dbo.SPU_UpdateExportGroup"
    Public Shared ReadOnly DeleteExportGroupAll As String = "dbo.SPU_DeleteExportGroup_Cascade"
    Public Shared ReadOnly DeleteExportGroupChildren As String = "dbo.SPU_DeleteExportGroup_CascadeChildrenOnly"
    Public Shared ReadOnly CheckExportGroupByName As String = "dbo.SPU_CheckExportExistsByExportName"    
    Public Shared ReadOnly CopyExport As String = "dbo.SPU_CopyExport"
    Public Shared ReadOnly CheckForRunningexport As String = "dbo.SPU_CheckForRunningExport"

#End Region
#Region "Survey Procs"
    Public Shared ReadOnly SP_GetAllSurveies As String = "dbo.SPU_GetAllSurveys"
    Public Shared ReadOnly SP_GetSelectedSurvey As String = "dbo.SPU_GetSelectedSurveys"
    Public Shared ReadOnly SP_GetSurvey As String = "dbo.SPU_GetSurveybySurveyID"
#End Region
#Region "Client Procs"
    Public Shared ReadOnly SP_GetBySurveyID As String = "dbo.SPU_GetAllClients"
    Public Shared ReadOnly SP_GetClientByClientID As String = "dbo.SPU_GetClientByClientID"
    Public Shared ReadOnly SP_GetSelectedClientByClientID As String = "dbo.SPU_GetClientByClientID"
    Public Shared ReadOnly SP_GetSelectedClients As String = "dbo.SPU_GetSelectedClients"
    Public Shared ReadOnly SP_SelectAllClients As String = "dbo.SPU_SelectAllClients"
#End Region

#Region " ExportScriptSelected Procs "
    Public Shared ReadOnly SelectSelectedScripts As String = "dbo.SPU_GetSelectedScripts"
    Public Shared ReadOnly SelectSelectedScriptByScriptID As String = "dbo.SPU_GetScriptByScriptsID"
#End Region
#Region " ExportScriptAvailable Procs "
    Public Shared ReadOnly SelectScriptsBySurveyAndClients As String = "dbo.SPU_GetAllScripts"
    Public Shared ReadOnly SelectScriptByScriptID As String = "dbo.SPU_GetScriptByScriptsID"
#End Region
#Region " ExportFileLayout Procs "
    Public Shared ReadOnly SelectExportFileLayout As String = "dbo.SPU_GetFileLayout"
    Public Shared ReadOnly SelectExportFileLayouts As String = "dbo.SPU_GetAllFileLayouts"
#End Region
    Public Shared ReadOnly SelectAllExportEvents As String = "dbo.SPU_GetAllEvents"
    Public Shared ReadOnly SelectSelectedExportEvents As String = "dbo.SPU_GetSelectedEvents"
    Public Shared ReadOnly SelectedEventByID As String = "dbo.SPU_GetEventByEventID"
#Region "ExportFileLog Procs"
    Public Shared ReadOnly DeleteExportFileLog As String = "dbo.SPU_DeleteExportFileLog"
    Public Shared ReadOnly InsertExportFileLog As String = "dbo.SPU_InsertExportFileLog"
    Public Shared ReadOnly SelectExportFileLog As String = "dbo.SPU_GetExportFileLog_Dynamic"
    Public Shared ReadOnly UpdateExportFileLog As String = "dbo.SPU_UpdateExportFileLog"
    'TP 20080415
    Public Shared ReadOnly CreateFileLog As String = "dbo.SPU_CreateNewExportFileLogEntry"
    'TP 20080415
    Public Shared ReadOnly FinishFileLog As String = "dbo.SPU_FinishExportFileLogEntry"
    'SK 20080423
    Public Shared ReadOnly MarkExportFileLogInActive As String = "dbo.SPU_MarkExportFileLogInActive"
#End Region

#Region " Wellpoint Split Client Procs "
    Public Shared ReadOnly GetWPSplitRespondentDuplicates As String = "dbo.PSETL_ReturnDuplicates"
    Public Shared ReadOnly InsertWPSplitRespondentForDupCheck As String = "dbo.PSETL_InsertWPSplitRespondentForDupCheck"
#End Region
End Class
