'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

''' <summary>SQL Provider for an export result file controller object</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Friend Class ExportMedicare2012RFileControllerProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportMedicare2012RFileControllerProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SPU_FileLayout Procs "
    ''' <summary>Populates a multi-table data set used to create result file business objects.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <param name="logFileID"></param>
    ''' <param name="markSubmitted"></param>
    ''' <param name="rerunUsingLogDates"></param>
    ''' <param name="startDate2401"></param>
    ''' <param name="endDate2401"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetResultFileDataSet(ByVal exportGroupID As Integer, ByVal logFileID As Integer, ByVal origLogFileID As Integer, ByVal markSubmitted As Boolean, ByVal rerunUsingLogDates As Boolean, ByVal startDate2401 As System.Nullable(Of Date), ByVal endDate2401 As System.Nullable(Of Date), ByVal activeOnly As Boolean) As System.Data.DataSet
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CreateAnwerFile, exportGroupID, markSubmitted, rerunUsingLogDates, logFileID, origLogFileID, startDate2401, endDate2401, DatabaseHelper.CastBoolToInt(activeOnly), 1)
        cmd.CommandTimeout = 7200
        Dim ds As System.Data.DataSet
        ds = Db.ExecuteDataSet(cmd)
        ds.Tables(0).TableName = "RespondentAnswers"
        ds.Tables(1).TableName = "RespondentModel"
        ds.Tables(2).TableName = "RespondentProperties"
        ds.Tables(3).TableName = "ExportGroupData"
        ds.Tables(4).TableName = "ClientInformation"
        ds.Tables(5).TableName = "ScriptInformation"
        ds.Tables(6).TableName = "RespondentMaxEventDate"
        ds.Relations.Add("RespondentAnswersToModel", ds.Tables("RespondentModel").Columns("RespondentID"), ds.Tables("RespondentAnswers").Columns("RespondentID"))
        'TP 20080414  Resp Properties can't have a relation as both tables would be many to many.
        'ds.Relations.Add("RespondentAnswersToProperties", ds.Tables("RespondentProperties").Columns("RespondentID"), ds.Tables("RespondentAnswers").Columns("RespondentID"))
        ds.Relations.Add("RespondentAnswersToClientInfo", ds.Tables("ClientInformation").Columns("ClientID"), ds.Tables("RespondentAnswers").Columns("ClientID"))
        ds.Relations.Add("RespondentAnswersToScriptInfo", ds.Tables("ScriptInformation").Columns("ScriptID"), ds.Tables("RespondentAnswers").Columns("ScriptID"))
        ds.Relations.Add("RespondentAnswersToMaxEventDate", ds.Tables("RespondentMaxEventDate").Columns("RespondentID"), ds.Tables("RespondentAnswers").Columns("RespondentID"))
        Return ds
    End Function
    ''' <summary>Returns number of respondents per export group.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <param name="logFileID"></param>
    ''' <param name="origLogFileID"></param>
    ''' <param name="markSubmitted"></param>
    ''' <param name="rerunUsingLogDates"></param>
    ''' <param name="startDate2401"></param>
    ''' <param name="endDate"></param>
    ''' <returns>long</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetNumberOfRespondentsForExportGroup(ByVal exportGroupID As Integer, ByVal logFileID As Integer, ByVal origLogFileID As Integer, ByVal markSubmitted As Boolean, ByVal rerunUsingLogDates As Boolean, ByVal startDate2401 As System.Nullable(Of Date), ByVal endDate As System.Nullable(Of Date), ByVal activeOnly As Boolean) As Long
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.GetNumberOfRespondentsByClient, exportGroupID, markSubmitted, rerunUsingLogDates, logFileID, origLogFileID, startDate2401, endDate, 1, DatabaseHelper.CastBoolToInt(activeOnly))
        cmd.CommandTimeout = 1024
        Dim respondents As Long
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                respondents += CLng(rdr.Item(0))
            End While
        End Using
        Return respondents
    End Function
#End Region


End Class