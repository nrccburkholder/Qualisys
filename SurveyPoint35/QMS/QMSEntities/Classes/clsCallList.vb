Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsCallList
    Inherits DMI.clsDBEntity2

    Private _iUserID As Integer

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef sConn As String)
        MyBase.New(sConn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsCallList.SearchRow
        Dim sbSQL As New System.Text.StringBuilder
        Dim sbSQLRespondent As New System.Text.StringBuilder

        'get row containing search criteria
        dr = CType(drCriteria, dsCallList.SearchRow)

        'respondent criteria
        If Not dr.IsRespondentIDNull Then sbSQL.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)
        'survey instance criteria
        If Not dr.IsSurveyInstanceIDNull Then sbSQL.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        'survey criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'client criteria
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        'local time range criteria
        If Not dr.IsLocalTimeStartRangeNull And Not dr.IsLocalTimeEndRangeNull Then
            sbSQL.AppendFormat("(CAST(CONVERT(CHAR(8), StateTime, 108) AS datetime) BETWEEN {0} AND {1}) AND ", _
                        DMI.DataHandler.QuoteString(dr.LocalTimeStartRange.TimeOfDay), DMI.DataHandler.QuoteString(dr.LocalTimeEndRange.TimeOfDay))
        ElseIf Not dr.IsLocalTimeStartRangeNull Then
            sbSQL.AppendFormat("(CAST(CONVERT(CHAR(8), StateTime, 108) AS datetime) >= {0}) AND ", _
                        DMI.DataHandler.QuoteString(dr.LocalTimeStartRange.TimeOfDay))
        ElseIf Not dr.IsLocalTimeEndRangeNull Then
            sbSQL.AppendFormat("(CAST(CONVERT(CHAR(8), StateTime, 108) AS datetime) <= {0}) AND ", _
                        DMI.DataHandler.QuoteString(dr.LocalTimeEndRange.TimeOfDay))
        End If
        'time zone difference
        If Not dr.IsTimeZoneDifferenceNull Then sbSQL.AppendFormat("TimeDifference = {0} AND ", dr.TimeZoneDifference)
        'call attempts
        If Not dr.IsCallAttemptsMadeNull Then sbSQL.AppendFormat("CallsMade = {0} AND ", dr.CallAttemptsMade)
        'filter by incompletes codes
        If Not dr.IsEventIDNull Then
            If dr.EventID > 0 Then sbSQL.AppendFormat("EXISTS (SELECT 'x' FROM EventLog e WHERE e.EventID = {0} AND e.RespondentID = r.RespondentID) AND ", dr.EventID)
            If dr.EventID < 0 Then
                Select Case dr.EventID
                    Case -40001 'qmsEventCodes.MAILING_SURVEY_1ST
                        sbSQL.AppendFormat("NOT EXISTS (SELECT 'x' FROM EventLog e WHERE e.EventID = {0} and e.RespondentID = r.RespondentID) AND ", CInt(qmsEvents.BATCH_RESPONDENT))
                        sbSQL.AppendFormat("1 = (SELECT COUNT(*) FROM EventLog e WHERE e.EventID = {0} and e.RespondentID = r.RespondentID) AND ", CInt(qmsEvents.MAILING_SURVEY))

                    Case -40002 'qmsEventCodes.MAILING_SURVEY_2ND
                        sbSQL.AppendFormat("NOT EXISTS (SELECT 'x' FROM EventLog e WHERE e.EventID = {0} and e.RespondentID = r.RespondentID) AND ", CInt(qmsEvents.BATCH_RESPONDENT))
                        sbSQL.AppendFormat("2 <= (SELECT COUNT(*) FROM EventLog e WHERE e.EventID = {0} and e.RespondentID = r.RespondentID) AND ", CInt(qmsEvents.MAILING_SURVEY))

                    Case Else
                        sbSQL.AppendFormat("NOT EXISTS (SELECT 'x' FROM EventLog e WHERE e.EventID = {0} and e.RespondentID = r.RespondentID) AND ", dr.EventID * -1)

                End Select

            End If

        End If
        'File definition filter criteria
        If Not dr.IsFileDefFilterIDNull Then sbSQL.AppendFormat("({0}) AND ", clsFileDefs.GetFileDefFilter(_oConn, dr.FileDefFilterID).Replace("{0}", ""))

        'next contact criteria
        sbSQL.AppendFormat("NextContact <= '{0}' AND ", Now())

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        If Not dr.IsTopNull Then
            sbSQL.Insert(0, String.Format("SELECT TOP {0} * FROM vw_CallList r ", dr.Top))
            sbSQL.Append("ORDER BY TimeDifference DESC")
        Else
            sbSQL.Insert(0, "SELECT * FROM vw_CallList r ")
        End If

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("clear_CallList", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepID", SqlDbType.Int, 4, "ProtocolStepID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", _iUserID))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsCallList
        _dtMainTable = _ds.Tables("CallList")
        _sDeleteFilter = "RowID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ProtocolStepID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)

    End Sub

#End Region

    Public Property UserID() As Integer
        Get
            Return _iUserID

        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value

        End Set
    End Property

    Public Function GetRespondent(ByVal iUserID As Integer, ByVal iInputMode As Integer, ByVal drCriteria As DataRow) As Integer
        Dim sSQL As String
        Dim dr As DataRow
        Dim iRespondentID As Integer
        Dim im As IInputMode = clsInputMode.Create(iInputMode)
        Dim RespondentsTried As New ArrayList

        'pull 10 respondents at a time
        drCriteria.Item("Top") = 20

        'get first set of respondents
        Me.EnforceConstraints = False
        Me.FillMain(drCriteria)

        'if resulting table has respondents...
        Do Until Me.MainDataTable.Rows.Count = 0 Or RespondentsTried.Count > 50
            'try to claim a respondent
            For Each dr In Me.MainDataTable.Rows

                If RespondentsTried.Contains(CInt(dr.Item("RespondentID"))) Then
                    Exit Do

                End If

                sSQL = String.Format("EXEC spGetRespondentFromCallList {0}, {1}, {2}", _
                            dr.Item("RespondentID"), iUserID, CInt(im.SelectEventID))
                Try
                    'TP Change
                    iRespondentID = CInt(SqlHelper.ExecuteScalar(_oConn.ConnectionString, CommandType.Text, sSQL))
                    'iRespondentID = CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL))

                Catch ex As SqlClient.SqlException
                    Me._sErrorMsg = ex.Message & "\nPlease try again."
                    im = Nothing
                    Return -1

                End Try

                If iRespondentID > 0 Then
                    'check that respondent is not batched or is verified incomplete
                    'want to be able to call verified incomplete respondents
                    Dim lastCompletionCode As qmsEvents = clsRespondents.LastCompletionCode(iRespondentID, _oConn)
                    If Not clsRespondents.IsBatched(iRespondentID, _oConn) _
                        OrElse (lastCompletionCode = qmsEvents.VERIFY_INCOMPLETE_SURVEY Or lastCompletionCode = qmsEvents.VERIFY_PARTIAL_COMPLETE_SURVEY) Then
                        'found a respondent
                        RespondentsTried = Nothing
                        im = Nothing
                        Return iRespondentID

                    End If

                End If

                'respondent is not selectable, add to try list
                RespondentsTried.Add(CInt(dr.Item("RespondentID")))

            Next
            'get another set of respondents
            Me.MainDataTable.Clear()
            Me.FillMain(drCriteria)

        Loop

        If Me.MainDataTable.Rows.Count = 0 Then
            Me._sErrorMsg = "No Respondents Available"
        Else
            Me._sErrorMsg = "Unable To Get Respondents, Please Try Again"
        End If

        RespondentsTried = Nothing
        im = Nothing
        Return -1

    End Function

    Public Function CallListCount(ByVal drCriteria As DataRow) As Integer
        Dim sSQL As String
        drCriteria.Item("LocalTimeStartRange") = DBNull.Value
        drCriteria.Item("LocalTimeEndRange") = DBNull.Value
        drCriteria.Item("Top") = DBNull.Value

        sSQL = BuildSelectSQL(drCriteria).Replace("SELECT * ", "SELECT COUNT(*) ")
        Return CInt(SqlHelper.Db(Me._oConn.ConnectionString).ExecuteScalar(CommandType.Text, sSQL))
        'Return CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sSQL))

    End Function

End Class
