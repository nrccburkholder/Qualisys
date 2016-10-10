Imports System.Text
Imports Nrc.Qualisys.Library
Imports System.Configuration

Namespace ODSDBDataAccess

    Public Class ODSDBRepository
        Inherits BaseSqlDataProvider
        Implements IODSDBRepository


        Public Sub New()
            MyBase.New(ConfigurationManager.ConnectionStrings("ODSDB").ConnectionString)
        End Sub

#Region "public methods"

        Public Function GetHoldsTable(clientid As Integer, studyid As Integer, surveyIDs As List(Of String)) As DataTable Implements IODSDBRepository.GetHoldsTable

            Dim surveys As String = String.Join(",", surveyIDs.ToArray())

            Dim query As String = String.Format("SELECT " &
                                                "hss.HoldID, " &
                                                "Client + ' (' + CONVERT(varchar,ClientID) + ')' Client, " &
                                                "Study + ' (' + CONVERT(varchar,StudyID) + ')' Study, " &
                                                "Survey + ' (' + CONVERT(varchar,SurveyID) + ')' Survey, " &
                                                "EncounterHoldDate,HoldReason,hst.HoldDescription HoldStatus," &
                                                "TicketNumber," &
                                                "SurveyManager,AccountManager,DataManager,Requester,CompletionDate,DateCreated,DateModified " &
                                                "FROM odsdb.dbo.HoldSurveys hss " &
                                                "INNER JOIN odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID " &
                                                "INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID " &
                                                "WHERE hss.ClientID = {0} " &
                                                "AND hss.StudyID = {1} " &
                                                "AND hss.SurveyID in ({2}) " &
                                                "AND CompletionDate IS NULL", clientid, studyid, surveys)

            Dim dt As New DataTable
            Me.Fill(dt, query, CommandType.Text)

            Using dt
                Return dt
            End Using

        End Function

        Public Function GetMinEncounterHoldDate(clientid As Integer, studyid As Integer, surveyID As Integer) As Date Implements IODSDBRepository.GetMinEncounterHoldDate
            Dim query As String = String.Format("SELECT " &
                                                "min(EncounterHoldDate) EncounterHoldDate " &
                                                "FROM odsdb.dbo.HoldSurveys hss " &
                                                "INNER JOIN odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID " &
                                                "INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID " &
                                                "WHERE hss.ClientID = {0} " &
                                                "AND hss.StudyID = {1} " &
                                                "AND hss.SurveyID = {2} " &
                                                "AND CompletionDate IS NULL", clientid, studyid, surveyID)

            Dim o As Object = Me.ExecuteScalar(query, CommandType.Text)

            If o IsNot Nothing Then
                Return Convert.ToDateTime(o)
            Else
                Return Date.MinValue
            End If


        End Function

#End Region

    End Class

End Namespace


