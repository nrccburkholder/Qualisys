Imports System.Text
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Qualisys.Library
Imports System.Configuration
Imports System.Linq

Namespace ODSDBDataAccess

    Public Class ODSDBRepository
        Inherits BaseSqlDataProvider
        Implements IODSDBRepository


        Public Sub New()
            MyBase.New(AppConfig.ODSConnection)
        End Sub

#Region "public methods"

        Public Function GetHoldsTable(clientid As Integer, studyid As Integer, surveyIDs As Dictionary(Of String, String)) As DataTable Implements IODSDBRepository.GetHoldsTable

            Dim surveys As String = String.Join(",", surveyIDs.Keys.ToArray())

            Dim query As String = String.Format("SELECT  
                                                hss.HoldID,
                                                clientid,
                                                studyid,
                                                SurveyID,
                                                CAST(EncounterHoldDate As Date) EncounterHoldDate,
                                                hr.Description As HoldReason, 
                                                hst.HoldDescription HoldStatus,
                                                TicketNumber,
                                                Requester, CompletionDate,
                                                CAST(DateCreated As datetime) DateCreated, CAST(DateModified As datetime)DateModified  
                                                From odsdb.dbo.HoldSurveys hss  
                                                INNER Join odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID  
                                                INNER Join odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID  
                                                INNER Join odsdb.dbo.HoldReason hr on hr.HoldReasonID = hs.HoldReasonID  
                                                WHERE hss.ClientID = {0} 
                                                And hss.StudyID = {1} 
                                                And hss.SurveyID in ({2})  
                                                And CompletionDate Is NULL  
                                                ORDER BY EncounterHoldDate, SurveyID", clientid, studyid, surveys)

            Dim dt As New DataTable
            Me.Fill(dt, query, CommandType.Text)

            Using dt
                Return dt
            End Using

        End Function

        Public Function GetMinEncounterHoldDate(clientid As Integer, studyid As Integer, surveyID As Integer) As Date Implements IODSDBRepository.GetMinEncounterHoldDate
            Dim query As String = String.Format("SELECT 
                                                min(CAST(EncounterHoldDate As Date)) EncounterHoldDate 
                                                FROM odsdb.dbo.HoldSurveys hss 
                                                INNER Join odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID 
                                                INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID 
                                                WHERE hss.ClientID = {0} 
                                                And hss.StudyID = {1} 
                                                And hss.SurveyID = {2} 
                                                And CompletionDate Is NULL", clientid, studyid, surveyID)

            Dim o As Object = Me.ExecuteScalar(query, CommandType.Text)

            If Not IsDBNull(o) Then
                Return Convert.ToDateTime(o)
            Else
                Return Date.MinValue
            End If
        End Function

        Public Function GetCustomerSettings(ClientId As Integer, ConnectSurveyTypeId As String) As Dictionary(Of String, Object) Implements IODSDBRepository.GetCustomerSettings
            Dim query As String = String.Format("SELECT 
                                                IsNull(ContractNumber,'') ContractNumber, 
                                                IsNull(SurveyStartDate, '1/1/1900') SurveyStartDate, 
                                                IsNull(SurveyEndDate, '1/1/1900') SurveyEndDate, 
                                                From ODSDB.dbo.CustomerSurveyConfig 
                                                Where CustomerId = {0} And 
                                                ('{1}' = '' or SurveyTypeID = {1})", ClientId, ConnectSurveyTypeId)

            Dim dt As New DataTable
            Me.Fill(dt, query, CommandType.Text)

            Dim settings As Dictionary(Of String, Object) = New Dictionary(Of String, Object)

            If dt.Rows.Count = 1 Then
                settings.Add("ContractNumber", dt.Rows(0).Item("ContractNumber").ToString())
                settings.Add("SurveyStartDate", DateTime.Parse(dt.Rows(0).Item("SurveyStartDate").ToString()))
                settings.Add("SurveyEndDate", DateTime.Parse(dt.Rows(0).Item("SurveyEndDate").ToString()))
            End If

            Return settings
        End Function

        Public Function GetQuestionPods(QuestionPodIds As List(Of Integer)) As DataTable Implements IODSDBRepository.GetQuestionPods
            Dim sQuestionPodIds As String = String.Empty
            For Each intQ As Integer In QuestionPodIds
                sQuestionPodIds &= intQ.ToString() & ","
            Next
            sQuestionPodIds &= "-1"
            Dim query As String = String.Format("SELECT 
                                                QuestionModuleName, 
                                                QuestionModuleID, 
												LocationProviderResurveyDays,
												IntraCustomerResurveyDays,
                                                ResurveyType
                                                From [odsdb].[dbo].[QuestionModule] 
                                                where QuestionModuleID in ({0})", sQuestionPodIds)

            Dim dt As New DataTable
            Me.Fill(dt, query, CommandType.Text)

            Using dt
                Return dt
            End Using

        End Function

#End Region

    End Class

End Namespace


