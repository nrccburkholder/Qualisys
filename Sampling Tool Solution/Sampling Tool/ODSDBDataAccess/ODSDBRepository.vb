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

            Dim query As String = String.Format("SELECT " &
                                                "hss.HoldID, " &
                                                "ClientID, " &
                                                "StudyID, " &
                                                "SurveyID, " &
                                                "CAST(EncounterHoldDate as date) EncounterHoldDate," &
                                                "hr.Description as HoldReason," &
                                                "hst.HoldDescription HoldStatus," &
                                                "TicketNumber," &
                                                "Requester, CompletionDate, " &
                                                "CAST(DateCreated as datetime) DateCreated, CAST(DateModified as datetime)DateModified " &
                                                "FROM odsdb.dbo.HoldSurveys hss " &
                                                "INNER JOIN odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID " &
                                                "INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID " &
                                                "INNER JOIN odsdb.dbo.HoldReason hr on hr.HoldReasonID = hs.HoldReasonID " &
                                                "WHERE hss.ClientID = {0} " &
                                                "AND hss.StudyID = {1} " &
                                                "AND hss.SurveyID in ({2}) " &
                                                "AND CompletionDate IS NULL " &
                                                "ORDER BY EncounterHoldDate, SurveyID", clientid, studyid, surveys)

            Dim dt As New DataTable
            Me.Fill(dt, query, CommandType.Text)

            Using dt
                Return dt
            End Using

        End Function

        Public Function GetMinEncounterHoldDate(clientid As Integer, studyid As Integer, surveyID As Integer) As Date Implements IODSDBRepository.GetMinEncounterHoldDate
            Dim query As String = String.Format("SELECT " &
                                                "min(CAST(EncounterHoldDate as date)) EncounterHoldDate " &
                                                "FROM odsdb.dbo.HoldSurveys hss " &
                                                "INNER JOIN odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID " &
                                                "INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID " &
                                                "WHERE hss.ClientID = {0} " &
                                                "AND hss.StudyID = {1} " &
                                                "AND hss.SurveyID = {2} " &
                                                "AND CompletionDate IS NULL", clientid, studyid, surveyID)

            Dim o As Object = Me.ExecuteScalar(query, CommandType.Text)

            If Not IsDBNull(o) Then
                Return Convert.ToDateTime(o)
            Else
                Return Date.MinValue
            End If
        End Function

        Public Function GetCustomerSettings(ClientId As Integer, ConnectSurveyTypeId As String) As Dictionary(Of String, Object) Implements IODSDBRepository.GetCustomerSettings
            Dim query As String = String.Format("SELECT " &
                                                "ContractNumber, " &
                                                "SurveyStartDate, " &
                                                "SurveyEndDate, " &
                                                "LocationProviderResurveyDays, " &
                                                "IntraCustomerResurveyDays " &
                                                "From ODSDB.dbo.CustomerSurveyConfig " &
                                                "Where CustomerId = {0} And " &
                                                "('{1}' = '' or SurveyTypeID = {1})", ClientId, ConnectSurveyTypeId)

            Dim dt As New DataTable
            Me.Fill(dt, query, CommandType.Text)

            Dim settings As Dictionary(Of String, Object) = New Dictionary(Of String, Object)

            If dt.Rows.Count = 1 Then
                settings.Add("ContractNumber", dt.Rows(1).Item("ContractNumber").ToString())
                settings.Add("SurveyStartDate", DateTime.Parse(dt.Rows(1).Item("SurveyStartDate").ToString()))
                settings.Add("SurveyEndDate", DateTime.Parse(dt.Rows(1).Item("SurveyEndDate").ToString()))
                settings.Add("LocationProviderResurveyDays", Integer.Parse(dt.Rows(1).Item("LocationProviderResurveyDays").ToString()))
                settings.Add("IntraCustomerResurveyDays", Integer.Parse(dt.Rows(1).Item("IntraCustomerResurveyDays").ToString()))
            End If

            Return settings
        End Function

        Public Function GetCustomerQuestionPods(ClientId As Integer) As DataTable Implements IODSDBRepository.GetCustomerQuestionPods
            Dim query As String = String.Format("SELECT " &
                                                "QuestionModuleBK, " &
                                                "QuestionModuleBKID, " &
                                                "q.QuestionModuleName, " &
                                                "q.QuestionModuleID " &
                                                "From [odsdb].[dbo].[QuestionModuleBKs] qbk " &
                                                "inner Join [odsdb].[dbo].[QuestionModule] q on qbk.questionmoduleid = q.questionmoduleid " &
                                                "where qbk.IsIgnored = 0 " &
                                                "Where CustomerId = {0}", ClientId)

            Dim dt As New DataTable
            Me.Fill(dt, query, CommandType.Text)

            Using dt
                Return dt
            End Using
        End Function

#End Region

    End Class

End Namespace


