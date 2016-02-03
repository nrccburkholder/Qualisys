Public Class clsResponses
    Inherits DMI.clsDBEntity2

    Private _iRespondentID As Integer

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim sbSQLResponses As New System.Text.StringBuilder()
        Dim sbSQLRespondents As New Text.StringBuilder("") 'query against respondents table
        Dim sbSQLEventLog As New Text.StringBuilder("") 'query against eventlog table
        Dim sbSQLProperties As New Text.StringBuilder("") 'query against respondent properties table
        Dim sbSQLSurveyInstance As New Text.StringBuilder("") 'querty against survey instance table
        Dim sbSQLStates As New Text.StringBuilder("") 'querty against state table
        Dim dh As DMI.DataHandler
        Dim dr As dsResponses.SearchRow

        dr = CType(drCriteria, dsResponses.SearchRow)

        '*** survey instance table
        'Survey instance start date criteria
        If Not dr.IsSurveyInstanceStartRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate >= '{0:d}' AND ", dr.SurveyInstanceStartRange)
        'Survey instance end date criteria
        If Not dr.IsSurveyInstanceEndRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate <= '{0:d}' AND ", dr.SurveyInstanceEndRange)
        'Active criteria
        If Not dr.IsActiveNull And dr.IsSurveyInstanceIDNull Then sbSQLSurveyInstance.AppendFormat("Active ={0} AND ", dr.Active)
        If sbSQLSurveyInstance.Length > 0 Then
            'Survey instance id criteria
            If Not dr.IsSurveyInstanceIDNull Then sbSQLSurveyInstance.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
            'Survey id criteria
            If Not dr.IsSurveyIDNull Then sbSQLSurveyInstance.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
            'Client id criteria
            If Not dr.IsClientIDNull Then sbSQLSurveyInstance.AppendFormat("ClientID = {0} AND ", dr.ClientID)

        End If

        ''Survey id criteria
        'If Not dr.IsSurveyIDNull Then sbSQLSurveyInstance.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        ''Client id criteria
        'If Not dr.IsClientIDNull Then sbSQLSurveyInstance.AppendFormat("ClientID = {0} AND ", dr.ClientID)

        '** event log table
        'Event id criteria
        If Not dr.IsEventIDNull Then sbSQLEventLog.AppendFormat("EventID = {0} AND ", dr.EventID)
        'Event log start date criteria
        If Not dr.IsEventStartRangeNull Then sbSQLEventLog.AppendFormat("EventDate >= '{0:d}' AND ", dr.EventStartRange)
        'Event log end date criteria
        If Not dr.IsEventEndRangeNull Then sbSQLEventLog.AppendFormat("EventDate <= '{0:d} 23:59:59' AND ", dr.EventEndRange)
        If sbSQLEventLog.Length > 0 Then
            'Survey instance id criteria
            If Not dr.IsSurveyInstanceIDNull Then sbSQLEventLog.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
            'Survey id criteria
            If Not dr.IsSurveyIDNull Then sbSQLEventLog.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
            'Client id criteria
            If Not dr.IsClientIDNull Then sbSQLEventLog.AppendFormat("ClientID = {0} AND ", dr.ClientID)
            'respondent id criteria 
            If Not dr.IsRespondentIDNull Then sbSQLEventLog.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)

        End If

        '** respondent properties table
        'Property name criteria
        If Not dr.IsPropertyNameNull Then sbSQLProperties.AppendFormat("PropertyName = {0} AND ", dh.QuoteString(dr.PropertyName))
        'Property value criteria
        If Not dr.IsPropertyValueNull Then sbSQLProperties.AppendFormat("PropertyValue = {0} AND ", dh.QuoteString(dr.PropertyValue))
        'append respondent id criteria only if respondent table will be used
        If sbSQLProperties.Length > 0 And Not dr.IsRespondentIDNull Then sbSQLProperties.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)

        '** state table
        'filter by time difference
        If Not dr.IsTimeZoneDifferenceNull Then sbSQLStates.AppendFormat("TimeDifference = {0} AND ", dr.TimeZoneDifference)
        'filter by time range
        If Not dr.IsLocalTimeStartRangeNull And Not dr.IsLocalTimeEndRangeNull Then
            sbSQLStates.AppendFormat("DATEADD(hour, TimeDifference + 1, GETUTCDATE()) BETWEEN '{0}' AND '{1}') AND ", _
                        dr.LocalTimeStartRange, dr.LocalTimeEndRange)

        ElseIf Not dr.IsLocalTimeStartRangeNull Then
            sbSQLStates.AppendFormat("DATEADD(hour, TimeDifference + 1, GETUTCDATE()) >= '{0}' AND ", _
                        dr.LocalTimeStartRange)

        ElseIf Not dr.IsLocalTimeEndRangeNull Then
            sbSQLStates.AppendFormat("DATEADD(hour, TimeDifference + 1, GETUTCDATE()) <= '{0}' AND ", _
                        dr.LocalTimeEndRange)

        End If

        '** respondent table
        'Survey instance id criteria
        If Not dr.IsSurveyInstanceIDNull Then sbSQLRespondents.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        'Respondent name criteria
        If Not dr.IsRespondentNameNull Then sbSQLRespondents.AppendFormat("ISNULL(FirstName,'') + ' ' + LastName LIKE {0} AND ", dh.QuoteString(dr.RespondentName))
        'Address criteria
        If Not dr.IsAddressNull Then sbSQLRespondents.AppendFormat("ISNULL(Address1,'') + ISNULL(Address2,'') LIKE {0} AND ", dh.QuoteString(dr.Address))
        'City criteria
        If Not dr.IsCityNull Then sbSQLRespondents.AppendFormat("City LIKE {0} AND ", dh.QuoteString(dr.City))
        'State criteria
        If Not dr.IsStateNull Then sbSQLRespondents.AppendFormat("State LIKE {0} AND ", dh.QuoteString(dr.State))
        'Postal code criteria
        If Not dr.IsPostalCodeNull Then sbSQLRespondents.AppendFormat("PostalCode LIKE {0} AND ", dh.QuoteString(dr.PostalCode))
        'Telephone criteria
        If Not dr.IsTelephoneNull Then sbSQLRespondents.AppendFormat("ISNULL(TelephoneDay + ' ','')  + ISNULL(TelephoneEvening,'') LIKE {0} AND ", dh.QuoteString(dr.Telephone))
        'Email criteria
        If Not dr.IsEmailNull Then sbSQLRespondents.AppendFormat("Email LIKE {0} AND ", dh.QuoteString(dr.Email))
        'Gender criteria
        If Not dr.IsGenderNull Then sbSQLRespondents.AppendFormat("Gender = {0} AND ", dh.QuoteString(dr.Gender))
        'SSN criteria
        If Not dr.IsSSNNull Then sbSQLRespondents.AppendFormat("SSN LIKE {0} AND ", dh.QuoteString(dr.SSN))
        'Client respondent id criteria
        If Not dr.IsClientRespondentIDNull Then sbSQLRespondents.AppendFormat("ClientRespondentID LIKE {0} AND ", dh.QuoteString(dr.ClientRespondentID))
        'Batch id criteria
        If Not dr.IsBatchIDNull Then sbSQLRespondents.AppendFormat("BatchID = {0} AND ", dr.BatchID)
        'Survey id criteria
        If Not dr.IsSurveyIDNull Then sbSQLRespondents.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'Client id criteria
        If Not dr.IsClientIDNull Then sbSQLRespondents.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        'DOB date range
        If Not dr.IsDOBStartRangeNull Then sbSQLRespondents.AppendFormat("DOB >= '{0:d}' AND ", dr.DOBStartRange)
        If Not dr.IsDOBEndRangeNull Then sbSQLRespondents.AppendFormat("DOB <= '{0:d}' AND ", dr.DOBEndRange)
        'Batch id list criteria
        If Not dr.IsBatchIDListNull Then sbSQLRespondents.AppendFormat("BatchID IN ({0}) AND ", dr.BatchIDList)
        'Final criteria
        If Not dr.IsFinalNull Then sbSQLRespondents.AppendFormat("Final = {0} AND ", dr.Final)
        'Call attempts criteria
        If Not dr.IsCallAttemptsMadeNull Then sbSQLRespondents.AppendFormat("CallsMade = {0} AND ", dr.CallAttemptsMade)
        'Exclude final code criteria
        If Not dr.IsExcludeFinalCodesNull Then sbSQLRespondents.Append("Final = 0 AND ")
        'File definition filter criteria
        If Not dr.IsFileDefFilterIDNull Then sbSQLRespondents.AppendFormat("({0}) AND ", clsFileDefs.GetFileDefFilter(_oConn, dr.FileDefFilterID))
        'Event log table criteria
        If sbSQLEventLog.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLEventLog, 4)
            sbSQLRespondents.AppendFormat("EXISTS (SELECT 'x' FROM EventLog WHERE (r.RespondentID = EventLog.RespondentID) AND ({0})) AND ", sbSQLEventLog.ToString)
            'sbSQLRespondents.AppendFormat("RespondentID IN (SELECT RespondentID FROM EventLog WHERE {0}) AND ", sbSQLEventLog.ToString)
        End If
        'Respondent properties table criteria
        If sbSQLProperties.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLProperties, 4)
            sbSQLRespondents.AppendFormat("EXISTS (SELECT 'x' FROM RespondentProperties WHERE (r.RespondentID = RespondentProperties.RespondentID) and ({0})) AND ", sbSQLProperties.ToString)
            'sbSQLRespondents.AppendFormat("RespondentID IN (SELECT RespondentID FROM RespondentProperties WHERE {0}) AND ", sbSQLProperties.ToString)
        End If
        'Survey instance table criteria
        If sbSQLSurveyInstance.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLSurveyInstance, 4)
            sbSQLRespondents.AppendFormat("SurveyInstanceID IN (SELECT SurveyInstanceID FROM SurveyInstances WHERE {0}) AND ", sbSQLSurveyInstance.ToString)
        End If
        'State table criteria
        If sbSQLStates.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLStates, 4)
            sbSQLRespondents.AppendFormat("State IN (SELECT State FROM States WHERE {0}) AND ", sbSQLStates.ToString)
        End If
        'append respondent id criteria only if respondent table will be used
        If sbSQLRespondents.Length > 0 And Not dr.IsRespondentIDNull Then sbSQLRespondents.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)

        'Primary key criteria
        If Not dr.IsResponseIDNull Then sbSQLResponses.AppendFormat("ResponseID = {0} AND ", dr.ResponseID)
        'keyword criteria
        If Not dr.IsRespondentIDNull Then sbSQLResponses.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)
        If Not dr.IsKeywordNull Then sbSQLResponses.AppendFormat("Name + Description LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))
        If Not dr.IsSurveyQuestionIDNull Then sbSQLResponses.AppendFormat("SurveyQuestionID = {0} AND ", dr.SurveyQuestionID)
        If Not dr.IsAnswerCategoryIDNull Then sbSQLResponses.AppendFormat("AnswerCategoryID = {0} AND ", dr.AnswerCategoryID)
        If Not dr.IsSurveyIDNull Then sbSQLResponses.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        If Not dr.IsQuestionIDNull Then sbSQLResponses.AppendFormat("QuestionID = {0} AND ", dr.QuestionID)
        If Not dr.IsQuestionPartIDNull Then sbSQLResponses.AppendFormat("QuestionPartID = {0} AND ", dr.QuestionPartID)
        If Not dr.IsQuestionIDListNull Then sbSQLResponses.AppendFormat("QuestionID IN ({0}) AND ", dr.QuestionIDList)
        If Not dr.IsScriptIDNull Then sbSQLResponses.AppendFormat("SurveyQuestionID IN (SELECT SurveyQuestionID FROM ScriptScreens WHERE ScriptID = {0} AND SurveyQuestionID IS NOT NULL) AND ", dr.ScriptID)

        'Respondent table criteria
        If sbSQLRespondents.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLRespondents, 4)
            sbSQLResponses.AppendFormat("RespondentID IN (SELECT RespondentID FROM vw_Respondents r WHERE {0}) AND ", sbSQLRespondents.ToString)
        End If

        'Clean up criteria
        If sbSQLResponses.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLResponses, 4)
            sbSQLResponses.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQLResponses.Insert(0, "SELECT * FROM vr_Responses ")

        Return sbSQLResponses.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Responses", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseID", SqlDbType.Int, 4, "ResponseID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsResponses()
        _dtMainTable = _ds.Tables("Responses")
        _sDeleteFilter = "ResponseID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Responses", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseID", SqlDbType.Int, 4, "ResponseID"))
        oCmd.Parameters("@ResponseID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))
        oCmd.Parameters("@SurveyQuestionID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseText", SqlDbType.VarChar, 1000, "ResponseText"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))
        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ResponseID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Responses", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseID", SqlDbType.Int, 4, "ResponseID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))
        oCmd.Parameters("@SurveyQuestionID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseText", SqlDbType.VarChar, 1000, "ResponseText"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))
        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        'dr.Item("Name") = ""
        'dr.Item("Description") = ""
        'dr.Item("ResponseTypeID") = Me._iResponseTypeID
        'dr.Item("FinalCode") = 0
        'dr.Item("UserCreated") = 1
        'dr.Item("DefaultNonContact") = 0

    End Sub

    'Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
    '    Dim bVerify As Boolean = True

    '    If Not ResponseCodeInUse(CInt(dr.Item("ResponseID", DataRowVersion.Original))) Then
    '        bVerify = False
    '        Me._sErrorMsg &= String.Format("Cannot delete Response id {0}. Response is used in Response log.\n", dr.Item("ResponseID", DataRowVersion.Original))

    '    End If

    '    If dr.Item("UserCreated", DataRowVersion.Original) = 1 Then
    '        bVerify = False
    '        Me._sErrorMsg &= String.Format("Cannot delete Response id {0}. Response is not user created.\n", dr.Item("ResponseID", DataRowVersion.Original))

    '    End If

    '    Return bVerify

    'End Function

    'Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean

    '    If ResponseCodeExists(dr) Then
    '        'Response already in use
    '        Me._sErrorMsg &= String.Format("Response id {0} already exists. Please change id number.\n", dr.Item("ResponseID"))
    '        Return False

    '    End If

    '    Return True

    'End Function

    'Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
    '    Dim bVerify As Boolean = True

    '    'check for change in Response id
    '    If dr.Item("ResponseID", DataRowVersion.Current) <> dr.Item("ResponseID", DataRowVersion.Original) Then
    '        Me._sErrorMsg &= String.Format("Cannot change Response id {0}. Response is not user created.\n", dr.Item("ResponseID", DataRowVersion.Original))
    '        bVerify = False

    '    Else
    '        'can not change non-user created Responses
    '        If CInt(dr.Item("UserCreated")) = 1 Then
    '            'does new code already exist
    '            If ResponseCodeExists(dr) Then
    '                'Response already in use
    '                Me._sErrorMsg &= String.Format("Response id {0} already exists. Please change id number.\n", dr.Item("ResponseID"))
    '                bVerify = False

    '            End If

    '            'is old Response code in use
    '            If ResponseCodeInUse(CInt(dr.Item("ResponseID", DataRowVersion.Original))) Then
    '                'Response already in use
    '                Me._sErrorMsg &= String.Format("Cannot change Response id {0}. Response is used in Response log.\n", dr.Item("ResponseID", DataRowVersion.Original))
    '                bVerify = False

    '            End If

    '        End If

    '    End If

    '    Return bVerify

    'End Function

#End Region

    Public Shared Function GetHistoricalResponses(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, Optional ByVal pointInTime As DateTime = DMI.clsUtil.NULLDATE, Optional ByVal sortColumn As String = "Responses_jn.jn_datetime") As DataTable
        Dim dt As New DataTable
        Dim sql As New System.Text.StringBuilder

        sql.Append("SELECT Responses_jn.jn_datetime AS Datetime, Responses_jn.jn_operation AS Operation, Users.Username AS [User], ")
        sql.Append("SurveyQuestions.ItemOrder AS QuestionNum, Questions.ShortDesc AS Question, AnswerCategories.AnswerValue, AnswerCategories.AnswerText, ")
        sql.Append("Responses_jn.ResponseText ")
        sql.Append("FROM Responses_jn INNER JOIN ")
        sql.Append("SurveyQuestions ON Responses_jn.SurveyQuestionID = SurveyQuestions.SurveyQuestionID INNER JOIN ")
        sql.Append("Questions ON SurveyQuestions.QuestionID = Questions.QuestionID INNER JOIN ")
        sql.Append("AnswerCategories ON Questions.QuestionID = AnswerCategories.QuestionID AND ")
        sql.Append("Responses_jn.AnswerCategoryID = AnswerCategories.AnswerCategoryID LEFT OUTER JOIN ")
        sql.Append("Users ON Responses_jn.UserID = Users.UserID ")
        sql.AppendFormat("WHERE (Responses_jn.RespondentID = {0}) ", respondentID)
        If pointInTime <> DMI.clsUtil.NULLDATE Then sql.AppendFormat("AND ('{0}' BETWEEN jn_datetime AND jn_endtime) AND (jn_operation <> 'D') ", pointInTime)
        sql.AppendFormat("ORDER BY {0} ", sortColumn)

        DMI.DataHandler.GetDataTable(connection, dt, sql.ToString)

        Return dt

    End Function


End Class
