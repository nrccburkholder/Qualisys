Option Explicit On
Option Strict On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports DMI

Public Class clsRespondents
    Inherits DMI.clsDBEntity2

    Private _iSurveyInstanceID As Integer
    Private _iUserID As Integer
    Private _iEventID As Integer
    Private _bChangedAddress As Boolean = False
    Private _bChangedTelephone As Boolean = False
    Private _bChangedName As Boolean = False
    Private _bChangedIdentity As Boolean = False
    Private _bChangedEmail As Boolean = False
    Private _bChangedDemographic As Boolean = False

    Public Const MAIN_SELECT_VIEW_NAME As String = "vw_Respondents"
    Protected Const MAIN_FROM_CLAUSE As String = " FROM " + clsRespondents.MAIN_SELECT_VIEW_NAME + " r "

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsRespondents.SearchRow
        Dim sbSQL As New Text.StringBuilder("")

        'Add SELECT statement
        sbSQL.AppendFormat("SELECT * {0}", clsRespondents.MAIN_FROM_CLAUSE)
        sbSQL.Append(GetWhereSQL(drCriteria))

        'Check for mailing seeds
        dr = CType(drCriteria, dsRespondents.SearchRow)
        If Not dr.IsIncludeMailSeedsNull Then
            If dr.IncludeMailSeeds Then sbSQL.AppendFormat("UNION ALL {0} ", GetMailingSeedsSQL(drCriteria))
        End If

        Return sbSQL.ToString
    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Respondents", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters("@RespondentID").Direction = ParameterDirection.Input

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New QMS.dsRespondents
        _dtMainTable = _ds.Tables("Respondents")
        _sDeleteFilter = "RespondentID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Respondents", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters("@RespondentID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", SqlDbType.VarChar, 100, "FirstName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", SqlDbType.VarChar, 100, "LastName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@MiddleInitial", SqlDbType.VarChar, 10, "MiddleInitial"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address1", SqlDbType.VarChar, 250, "Address1"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address2", SqlDbType.VarChar, 250, "Address2"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@City", SqlDbType.VarChar, 100, "City"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@State", SqlDbType.Char, 2, "State"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCode", SqlDbType.VarChar, 50, "PostalCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCodeExt", SqlDbType.VarChar, 10, "PostalCodeExt"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneDay", SqlDbType.VarChar, 50, "TelephoneDay"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneEvening", SqlDbType.VarChar, 50, "TelephoneEvening"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Email", SqlDbType.VarChar, 50, "Email"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DOB", SqlDbType.DateTime, 8, "DOB"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Gender", SqlDbType.Char, 1, "Gender"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientRespondentID", SqlDbType.VarChar, 50, "ClientRespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SSN", SqlDbType.VarChar, 50, "SSN"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@BatchID", SqlDbType.Int, 8, "BatchID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 8, "SurveyID"))
        oCmd.Parameters("@SurveyID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 8, "ClientID"))
        oCmd.Parameters("@ClientID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceName", SqlDbType.VarChar, 100, "SurveyInstanceName"))
        oCmd.Parameters("@SurveyInstanceName").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyName", SqlDbType.VarChar, 100, "SurveyName"))
        oCmd.Parameters("@SurveyName").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientName", SqlDbType.VarChar, 100, "ClientName"))
        oCmd.Parameters("@ClientName").Direction = ParameterDirection.Output

        Return oCmd

    End Function

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Respondents", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", SqlDbType.VarChar, 100, "FirstName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", SqlDbType.VarChar, 100, "LastName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@MiddleInitial", SqlDbType.VarChar, 10, "MiddleInitial"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address1", SqlDbType.VarChar, 250, "Address1"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address2", SqlDbType.VarChar, 250, "Address2"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@City", SqlDbType.VarChar, 100, "City"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@State", SqlDbType.Char, 2, "State"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCode", SqlDbType.VarChar, 50, "PostalCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCodeExt", SqlDbType.VarChar, 10, "PostalCodeExt"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneDay", SqlDbType.VarChar, 50, "TelephoneDay"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneEvening", SqlDbType.VarChar, 50, "TelephoneEvening"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Email", SqlDbType.VarChar, 50, "Email"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DOB", SqlDbType.DateTime, 8, "DOB"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Gender", SqlDbType.Char, 1, "Gender"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientRespondentID", SqlDbType.VarChar, 50, "ClientRespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SSN", SqlDbType.VarChar, 50, "SSN"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@BatchID", SqlDbType.Int, 8, "BatchID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 8, "SurveyID"))
        oCmd.Parameters("@SurveyID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 8, "ClientID"))
        oCmd.Parameters("@ClientID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceName", SqlDbType.VarChar, 100, "SurveyInstanceName"))
        oCmd.Parameters("@SurveyInstanceName").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyName", SqlDbType.VarChar, 100, "SurveyName"))
        oCmd.Parameters("@SurveyName").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientName", SqlDbType.VarChar, 100, "ClientName"))
        oCmd.Parameters("@ClientName").Direction = ParameterDirection.Output

        Return oCmd

    End Function

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim iRespondentID As Integer = CInt(dr.Item("RespondentID", DataRowVersion.Original))
        Dim sSQL As String

        sSQL = String.Format("SELECT COUNT(*) FROM Responses WHERE RespondentID = {0}", iRespondentID)

        If CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sSQL)) > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete respondent id {0}. Respondent has survey responses.\n", iRespondentID)
            Return False

        End If

        Return True

    End Function

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Return True

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        _bChangedName = False
        _bChangedAddress = False
        _bChangedTelephone = False
        _bChangedEmail = False
        _bChangedDemographic = False
        _bChangedIdentity = False

        'checked for changed name
        If _ChangedName(dr) Then
            _bChangedName = True
            InsertEvent(CInt(qmsEvents.RESPONDENT_UPDATED_NAME), _iUserID)
        End If
        'check for changed address
        If _ChangedAddress(dr) Then
            _bChangedAddress = True
            InsertEvent(CInt(qmsEvents.RESPONDENT_UPDATED_ADDRESS), _iUserID)

        End If
        'check for changed telephone
        If _ChangedTelephone(dr) Then
            _bChangedTelephone = True
            InsertEvent(CInt(qmsEvents.RESPONDENT_UPDATED_TELEPHONE), _iUserID)

        End If
        'check for changed demographic
        If _ChangedDemographic(dr) Then
            _bChangedDemographic = True
            InsertEvent(CInt(qmsEvents.RESPONDENT_UPDATED_DEMOGRAPHIC), _iUserID)
        End If
        'check for changed identity
        If _ChangedIdentity(dr) Then
            _bChangedIdentity = True
            InsertEvent(CInt(qmsEvents.RESPONDENT_UPDATED_ID), _iUserID)
        End If
        'check for changed email
        If _ChangedEmail(dr) Then
            _bChangedEmail = True
            InsertEvent(CInt(qmsEvents.RESPONDENT_UPDATED_EMAIL), _iUserID)
        End If

        Return True

    End Function

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups - for now

    End Sub

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("RespondentID") = iEntityID

    End Sub

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("SurveyInstanceID") = _iSurveyInstanceID
        dr.Item("LastName") = ""

    End Sub

#End Region

    Public Sub FindByClientRespondentID(ByVal clientRespondentID As String)
        Dim dr As QMS.dsRespondents.SearchRow = CType(Me.NewSearchRow, QMS.dsRespondents.SearchRow)
        dr.ClientRespondentID = clientRespondentID
        dr.Active = 1
        Me.FillMain(CType(dr, DataRow))

    End Sub

    Public Sub FindByRespondentID(ByVal respondentID As Integer)
        Dim dr As QMS.dsRespondents.SearchRow = CType(Me.NewSearchRow, QMS.dsRespondents.SearchRow)
        dr.RespondentID = respondentID
        dr.Active = 1
        Me.FillMain(CType(dr, DataRow))

    End Sub

    Public Function GetWhereSQL(ByVal drCriteria As DataRow) As String
        Return GetWhereSQL(drCriteria, _oConn)
    End Function

    Public Shared Function GetWhereSQL(ByRef drCriteria As DataRow, ByRef oConn As Data.SqlClient.SqlConnection) As String
        Dim sbSQLRespondents As New Text.StringBuilder("")   'query against respondents table
        Dim sbSQLEventLog As New Text.StringBuilder("")   'query against eventlog table
        Dim sbSQLProperties As New Text.StringBuilder("")   'query against respondent properties table
        Dim sbSQLSurveyInstance As New Text.StringBuilder("")   'querty against survey instance table
        Dim sbSQLStates As New Text.StringBuilder("")   'querty against state table
        Dim dh As DMI.DataHandler
        Dim dr As QMS.dsRespondents.SearchRow

        dr = CType(drCriteria, QMS.dsRespondents.SearchRow)

        'Primary key criteria
        If Not dr.IsRespondentIDNull Then sbSQLRespondents.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)

        '*** survey instance table
        'Survey instance start date criteria
        If Not dr.IsSurveyInstanceStartRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate >= '{0:d}' AND ", dr.SurveyInstanceStartRange)
        'Survey instance end date criteria
        If Not dr.IsSurveyInstanceEndRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate <= '{0:d}' AND ", dr.SurveyInstanceEndRange)
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
        If Not dr.IsEventIDNull Then
            If dr.EventID = qmsEvents.FINAL_CODE Then
                sbSQLEventLog.AppendFormat("EXISTS (SELECT 1 FROM SurveyInstanceEvents sie RIGHT OUTER JOIN Events e ON sie.EventID = e.EventID AND sie.SurveyInstanceID = EventLog.SurveyInstanceID WHERE (ISNULL(sie.Final, e.FinalCode) = 1) AND (e.EventID = EventLog.EventID)) AND ")
            Else
                sbSQLEventLog.AppendFormat("EventID = {0} AND ", dr.EventID)
            End If

            'Event log start date criteria
            If Not dr.IsEventStartRangeNull Then sbSQLEventLog.AppendFormat("EventDate >= '{0:d}' AND ", dr.EventStartRange)
            'Event log end date criteria
            If Not dr.IsEventEndRangeNull Then sbSQLEventLog.AppendFormat("EventDate <= '{0:d} 23:59:59' AND ", dr.EventEndRange)

        End If

        '** respondent properties table
        'Property name criteria
        If Not dr.IsPropertyNameNull Then sbSQLProperties.AppendFormat("PropertyName = {0} AND ", dh.QuoteString(dr.PropertyName))
        'Property value criteria
        If Not dr.IsPropertyValueNull Then sbSQLProperties.AppendFormat("PropertyValue = {0} AND ", dh.QuoteString(dr.PropertyValue))

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
        'TP20091104
        If Not dr.IsSurveyInstanceIDsNull AndAlso dr.SurveyInstanceIDs.Length > 0 Then
            sbSQLRespondents.AppendFormat("SurveyInstanceID in ({0}) AND ", dr.SurveyInstanceIDs)
        End If
        'TP20091104
        'Respondent name criteria
        If Not dr.IsLastNameNull Then sbSQLRespondents.AppendFormat("LastName LIKE {0} AND ", dh.QuoteString(dr.LastName))
        If Not dr.IsFirstNameNull Then sbSQLRespondents.AppendFormat("FirstName LIKE {0} AND ", dh.QuoteString(dr.FirstName))
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
        If Not dr.IsExcludeFinalCodesNull Then
            sbSQLRespondents.Append("Final = 0 AND ")
            'If dr.ExcludeFinalCodes Then sbSQLRespondents.Append("RespondentID NOT IN (SELECT RespondentID FROM vr_RespondentEventLog WHERE Final = 1) AND ")
        End If
        'File definition filter criteria
        If Not dr.IsFileDefFilterIDNull Then sbSQLRespondents.AppendFormat("({0}) AND ", FormatFileDefFilter(clsFileDefs.GetFileDefFilter(oConn, dr.FileDefFilterID), dr))
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
        'check for mailing seeds include
        If Not (Not dr.IsIncludeMailSeedsNull() AndAlso dr.IncludeMailSeeds) Then
            sbSQLRespondents.Append("MailingSeedFlag = 0 AND ")
        End If

        'Clean up criteria
        If sbSQLRespondents.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLRespondents, 4)
            sbSQLRespondents.Insert(0, "WHERE ")

        End If

        sbSQLEventLog = Nothing
        sbSQLProperties = Nothing
        sbSQLSurveyInstance = Nothing

        Return sbSQLRespondents.ToString

    End Function

    Private Shared Function FormatFileDefFilter(ByVal sFilter As String, ByVal dr As QMS.dsRespondents.SearchRow) As String
        Dim sEventDateFilter As String = ""

        If Not dr.IsEventStartRangeNull AndAlso Not dr.IsEventEndRangeNull Then
            sEventDateFilter = String.Format(" AND (EventLog.EventDate BETWEEN '{0:d}' AND '{1:d} 23:59:59')", dr.EventStartRange, dr.EventEndRange)
        ElseIf Not dr.IsEventStartRangeNull Then
            sEventDateFilter = String.Format(" AND (EventLog.EventDate > '{0:d}')", dr.EventStartRange)
        ElseIf Not dr.IsEventEndRangeNull Then
            sEventDateFilter = String.Format(" AND (EventLog.EventDate <= '{0:d} 23:59:59')", dr.EventEndRange)
        End If

        Return String.Format(sFilter, sEventDateFilter)

    End Function

    Private Function GetMailingSeedsSQL(ByRef drCriteria As DataRow) As String
        Dim sbSQL As New Text.StringBuilder("")
        Dim sbSQLSurveyInstance As New Text.StringBuilder("")
        Dim dr As dsRespondents.SearchRow

        dr = CType(drCriteria, dsRespondents.SearchRow)

        'Survey instance criteria
        If dr.IsSurveyInstanceIDNull Then
            sbSQL.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)

        Else
            'Survey id criteria
            If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
            'Client id criteria
            If Not dr.IsClientIDNull Then sbSQL.AppendFormat("ClientID = {0} AND ", dr.ClientID)

            'Survey instance start date criteria
            If Not dr.IsSurveyInstanceStartRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate >= '{0:d}' AND ", dr.SurveyInstanceStartRange)
            'Survey instance end date criteria
            If Not dr.IsSurveyInstanceEndRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate <= '{0:d}' AND ", dr.SurveyInstanceEndRange)
            'Survey instance table criteria
            If sbSQLSurveyInstance.Length > 0 Then
                DMI.clsUtil.Chop(sbSQLSurveyInstance, 4)
                sbSQL.AppendFormat("SurveyInstanceID IN (SELECT SurveyInstanceID FROM SurveyInstances WHERE {0}) AND ", sbSQLSurveyInstance.ToString)
            End If

        End If

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add SELECT statement
        sbSQL.Insert(0, "SELECT * FROM vw_MailingSeeds ")

        Return sbSQL.ToString

    End Function

#Region "Process All"
    Public Sub MoveAll(ByVal Criteria As DataRow, ByVal SurveyInstanceID As Integer, ByVal UserID As Integer)
        Dim rp As New rpChangeSurveyInstance
        Dim t As New DMI.clsRowProcessorThread
        Dim sqlDR As SqlClient.SqlDataReader

        'setup log row processor
        rp.SurveyInstanceID = SurveyInstanceID
        rp.UserID = UserID

        'get datareader for criteria
        sqlDR = GetDataReader(DMI.DataHandler.sConnection, Criteria, "")

        'run threaded row processor
        t.Start(DMI.DataHandler.sConnection, sqlDR, rp)

    End Sub

    Public Sub DeleteAll(ByVal drCriteria As DataRow)
        Dim sbSQL As New Text.StringBuilder
        Dim sWhereSQL As String

        'update survey instance for search
        sWhereSQL = GetWhereSQL(CType(drCriteria, QMS.dsRespondents.SearchRow))

        'check that there are search criteria as a safe guard
        If sWhereSQL.Length > 0 Then
            'verify delete - check that respondents do not have survey responses
            sbSQL.AppendFormat("SELECT COUNT(*) FROM Responses WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL)
            'TP Change
            If CInt(DMI.SqlHelper.Db(Me._oConn.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString)) = 0 Then
                'delete respondents
                SqlHelper.Db(Me._oConn.ConnectionString).ExecuteNonQuery(CommandType.Text, String.Format("DELETE EventLog WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))
                SqlHelper.Db(Me._oConn.ConnectionString).ExecuteNonQuery(CommandType.Text, String.Format("DELETE RespondentProperties WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))
                SqlHelper.Db(Me._oConn.ConnectionString).ExecuteNonQuery(CommandType.Text, String.Format("DELETE Respondents WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))
                'SqlHelperNoTimeout.ExecuteNonQuery(Me._oConn, CommandType.Text, String.Format("DELETE EventLog WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))
                'SqlHelperNoTimeout.ExecuteNonQuery(Me._oConn, CommandType.Text, String.Format("DELETE RespondentProperties WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))
                'SqlHelperNoTimeout.ExecuteNonQuery(Me._oConn, CommandType.Text, String.Format("DELETE Respondents WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))

            Else
                Me._sErrorMsg &= "Cannot delete respondents. All or some respondents still have responses.\n"

            End If
            'If CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString)) = 0 Then
            '    'delete respondents
            '    SqlHelperNoTimeout.ExecuteNonQuery(Me._oConn, CommandType.Text, String.Format("DELETE EventLog WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))
            '    SqlHelperNoTimeout.ExecuteNonQuery(Me._oConn, CommandType.Text, String.Format("DELETE RespondentProperties WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))
            '    SqlHelperNoTimeout.ExecuteNonQuery(Me._oConn, CommandType.Text, String.Format("DELETE Respondents WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents r {0})", sWhereSQL))

            'Else
            '    Me._sErrorMsg &= "Cannot delete respondents. All or some respondents still have responses.\n"

            'End If

        Else
            Me._sErrorMsg &= "Cannot delete respondents with criteria.\n"

        End If

        sbSQL = Nothing

    End Sub

    Public Sub LogAll(ByVal criteria As DataRow, ByVal eventID As Integer, ByVal userID As Integer, Optional ByVal eventDate As DateTime = DMI.clsUtil.NULLDATE)
        Dim rp As New rpLogEvent
        Dim t As New DMI.clsRowProcessorThread
        Dim sqlDR As SqlClient.SqlDataReader

        'setup log row processor
        rp.EventID = eventID
        rp.UserID = userID
        rp.EventDate = eventDate
        'TP20091102
        ''get datareader for criteria
        'sqlDR = GetDataReaderNoTimeout(DMI.DataHandler.sConnection, criteria, "")
        Dim DT As DataTable = GetDataTable(DMI.DataHandler.sConnection, criteria, "")

        ''run threaded row processor
        't.Start(DMI.DataHandler.sConnection, sqlDR, rp)
        t.Start(DMI.DataHandler.sConnection, DT, rp)
        'TP20091102
    End Sub

    Public Sub ScoreAll(ByVal Criteria As DataRow, ByVal ScriptID As Integer, ByVal UserID As Integer, Optional ByVal updateOnly As Boolean = True)
        Dim rp As New rpScoreResponses
        Dim t As New DMI.clsRowProcessorThread
        Dim sqlDR As SqlClient.SqlDataReader

        'setup score row processor
        rp.ScriptID = ScriptID
        rp.UserID = UserID
        rp.UpdateOnly = updateOnly

        'get datareader for criteria
        sqlDR = GetDataReaderNoTimeout(DMI.DataHandler.sConnection, Criteria, "")

        'run threaded row processor
        t.Start(DMI.DataHandler.sConnection, sqlDR, rp)

    End Sub

    Public Sub RunProcessorAll(ByVal criteria As DataRow, ByVal userID As Integer, ByVal processorCode As String)
        Dim rp As New rpRunCodeProcessor
        Dim t As New DMI.clsRowProcessorThread
        Dim sqlDR As SqlClient.SqlDataReader

        'setup score row processor
        rp.ProcessorCode = processorCode
        rp.UserID = userID

        'get datareader for criteria
        sqlDR = GetDataReaderNoTimeout(DMI.DataHandler.sConnection, criteria, "")

        'run threaded row processor
        t.Start(DMI.DataHandler.sConnection, sqlDR, rp)

    End Sub

    Public Sub ExecuteTriggerAll(ByVal criteria As DataRow, ByVal userID As Integer, ByVal triggerID As Integer)
        Dim rp As New rpTrigger(userID, triggerID)
        Dim t As New DMI.clsRowProcessorThread
        Dim sqlDR As SqlClient.SqlDataReader

        'get datareader for criteria
        sqlDR = GetDataReaderNoTimeout(DMI.DataHandler.sConnection, criteria, "")

        'run threaded row processor
        t.Start(DMI.DataHandler.sConnection, sqlDR, rp)

    End Sub

#End Region

#Region "RowProcessors"

    Public Class rpRunCodeProcessor
        Inherits DMI.clsRowProcessor
        Public ProcessorCode As String
        Public UserID As Integer = 1

        Public Overloads Overrides Function Process(ByVal Row As System.Data.DataRow) As Boolean
            Try
                If Not IsDBNull(Row.Item("RespondentID")) Then
                    RunProcessorCode(CInt(Row.Item("RespondentID")))
                    Return True

                End If

            Catch ex As Exception
                Return False

            End Try

        End Function

        Public Overloads Overrides Function Process(ByVal Row As System.Data.SqlClient.SqlDataReader) As Boolean
            Try
                If Not IsDBNull(Row.Item("RespondentID")) Then
                    RunProcessorCode(CInt(Row.Item("RespondentID")))
                    Return True

                End If

            Catch ex As Exception
                Return False

            End Try

        End Function

        Public Sub RunProcessorCode(ByVal respondentID As Integer)
            SqlHelper.ExecuteNonQuery(Me._Connection, CommandType.Text, _
                String.Format(ProcessorCode, respondentID, UserID))

        End Sub

    End Class

    'send email to each respondent
    Public Class rpEmail
        Inherits DMI.clsRowProcessor
        Public FromEmail As String
        Public SmtpServer As String
        Protected _EmailSubject As String
        Protected _EmailBody As String
        Protected _RespondentID As Integer
        Protected _OtherTextTokens As New Hashtable
        Protected _TextTokenProcessor As New clsTextTokens(_Connection)
        Protected _UserID As Integer
        Protected _RespondentDataReader As SqlClient.SqlDataReader
        Public _Email As DMI.clsEmail

        Public Overloads Overrides Function Process(ByVal Row As System.Data.DataRow) As Boolean
            Try
                If Not IsDBNull(Row.Item("Email")) Then
                    SendEmail(CInt(Row.Item("RespondentID")), Row.Item("Email").ToString)
                    Return True

                End If

            Catch ex As Exception
                Return False

            End Try

        End Function

        Public Overloads Overrides Function Process(ByVal Row As System.Data.SqlClient.SqlDataReader) As Boolean
            Try
                If Not IsDBNull(Row.Item("Email")) Then
                    SendEmail(CInt(Row.Item("RespondentID")), Row.Item("Email").ToString)
                    Return True

                End If

            Catch ex As Exception
                Return False

            End Try

        End Function

        Protected Sub SendEmail(ByVal RespondentID As Integer, ByVal ToEmail As String)
            Dim rx As Text.RegularExpressions.Regex

            If rx.IsMatch(ToEmail, "\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*") Then
                _TextTokenProcessor.RespondentID = RespondentID
                _Email.Send(FromEmail, ToEmail, EmailSubject, EmailBody, SmtpServer)
                clsRespondents.InsertEvent(_Connection, QMS.qmsEvents.SENT_EMAIL_INVITE, Me.UserID, RespondentID, "")

            End If

        End Sub

        Protected Overrides Sub _Init()
            _Email = New DMI.clsEmail

        End Sub

        Public Property EmailSubject() As String
            Get
                Return _TextTokenProcessor.ReplaceTextTokens(_EmailSubject)

            End Get
            Set(ByVal Value As String)
                _EmailSubject = Value

            End Set
        End Property

        Public Property EmailBody() As String
            Get
                Return _TextTokenProcessor.ReplaceTextTokens(_EmailBody)

            End Get
            Set(ByVal Value As String)
                _EmailBody = Value

            End Set
        End Property

        Public ReadOnly Property OtherTextTokens() As Hashtable
            Get
                Return _OtherTextTokens

            End Get
        End Property

        Public Property UserID() As Integer
            Get
                Return _UserID

            End Get
            Set(ByVal Value As Integer)
                _UserID = Value
                _TextTokenProcessor.UserID = _UserID

            End Set
        End Property

        Public WriteOnly Property RespondentDataReader() As SqlClient.SqlDataReader
            Set(ByVal Value As SqlClient.SqlDataReader)
                _RespondentDataReader = Value
                _TextTokenProcessor.RespondentDataReader = Value

            End Set
        End Property
    End Class

    'logs event for each respondent
    Public Class rpLogEvent
        Inherits DMI.clsRowProcessor
        Public EventID As Integer
        Public UserID As Integer
        Public EventDate As DateTime = DMI.clsUtil.NULLDATE

        Public Overloads Overrides Function Process(ByVal Row As System.Data.DataRow) As Boolean
            If EventDate = DMI.clsUtil.NULLDATE Then
                clsRespondents.InsertEvent(_Connection, Me.EventID, Me.UserID, CInt(Row.Item("RespondentID")), "")
            Else
                clsRespondents.InsertEvent(_Connection, Me.EventDate, Me.EventID, Me.UserID, CInt(Row.Item("RespondentID")), "")
            End If

            Return True

        End Function

        Public Overloads Overrides Function Process(ByVal Row As System.Data.SqlClient.SqlDataReader) As Boolean
            If EventDate = DMI.clsUtil.NULLDATE Then
                clsRespondents.InsertEvent(_Connection, Me.EventID, Me.UserID, CInt(Row.Item("RespondentID")), "")
            Else
                clsRespondents.InsertEvent(_Connection, Me.EventDate, Me.EventID, Me.UserID, CInt(Row.Item("RespondentID")), "")
            End If

            Return True

        End Function

    End Class

    'changes survey instance of each respondent
    Public Class rpChangeSurveyInstance
        Inherits DMI.clsRowProcessor
        Public SurveyInstanceID As Integer
        Public UserID As Integer

        Public Overloads Overrides Function Process(ByVal Row As System.Data.DataRow) As Boolean
            Change(CInt(Row.Item("RespondentID")))
            Row.Delete()
            Row.AcceptChanges()
            Return True

        End Function

        Public Overloads Overrides Function Process(ByVal Row As System.Data.SqlClient.SqlDataReader) As Boolean
            Change(CInt(Row.Item("RespondentID")))
            Return True

        End Function

        Private Sub Change(ByVal RespondentID As Integer)
            Dim sSQL As String

            'log move
            sSQL = String.Format("INSERT EventLog(EventDate, EventID, UserID, RespondentID, EventParameters) SELECT GETDATE(), {0}, {1}, RespondentID, CAST(SurveyInstanceID as varchar) FROM vw_Respondents WHERE RespondentID = {2}", 2061, UserID, RespondentID)
            SqlHelper.ExecuteNonQuery(_Connection, CommandType.Text, sSQL)

            'move respondents
            sSQL = String.Format("UPDATE Respondents SET SurveyInstanceID = {0} WHERE RespondentID = {1}", SurveyInstanceID, RespondentID)
            SqlHelper.ExecuteNonQuery(_Connection, CommandType.Text, sSQL)

        End Sub
    End Class

    'rescores each respondent
    Public Class rpScoreResponses
        Inherits DMI.clsRowProcessor
        Private _ScriptID As Integer
        Private _ScriptTypeID As Integer
        Private _InputMode As qmsInputMode
        Public UserID As Integer
        Private _Interview As QMS.clsInterview
        Public UpdateOnly As Boolean = False

        Protected Overrides Sub _Init()
            'get interview object for scoring
            _Interview = New QMS.clsInterview(_Connection)

        End Sub

        Public Overloads Overrides Function Process(ByVal Row As System.Data.DataRow) As Boolean
            Return Score(CInt(Row.Item("RespondentID")))

        End Function

        Public Overloads Overrides Function Process(ByVal Row As System.Data.SqlClient.SqlDataReader) As Boolean
            Score(CInt(Row.Item("RespondentID")))
            Return True

        End Function

        Public Function Score(ByVal RespondentID As Integer) As Boolean
            'determine is script and respondent belongs to same survey
            If clsRespondents.ValidScript(Me._Connection, RespondentID, Me.ScriptID) Then
                _Interview.InputMode = GetInputMode(RespondentID)

                're-score only if not in view mode
                If _Interview.InputMode <> qmsInputMode.VIEW Then

                    'determine if script data has been initialized
                    If _Interview.Script.MainDataTable.Rows.Count = 0 Then
                        'set interview variables
                        _Interview.ScriptID = ScriptID
                        _Interview.UserID = UserID

                        'fill with script data
                        _Interview.Script.FillMain(ScriptID)
                        _Interview.FillScriptScreens()
                        _Interview.FillScriptScreenCategories()
                        _Interview.FillScriptTriggers()

                    End If

                    'clear previous data
                    _Interview.Responses.ClearMainTable()
                    _Interview.Respondent.ClearMainTable()

                    'get respondent data
                    _Interview.RespondentID = RespondentID
                    _Interview.Respondent.FillMain(RespondentID)
                    _Interview.FillResponses()

                    'calculate score
                    _Interview.ScriptTriggers.TriggerPreScript(RespondentID)
                    _Interview.UpdateScreenStatus()
                    _Interview.Score(UpdateOnly)
                    _Interview.ScriptTriggers.TriggerPostScript(RespondentID)
                    Return True
                Else
                    Me._sErrMsg = String.Format("Unable to re-score Respondent {0}. Respondent has no existing completion code.", RespondentID)

                End If

            Else
                Me._sErrMsg = String.Format("Respondent {0} cannot use script {1}. They belong to different surveys.", RespondentID, ScriptID)

            End If

            Return False

        End Function

        Public Overrides Sub Close()
            _Interview.Close()

        End Sub

        Public Property ScriptID() As Integer
            Get
                Return _ScriptID

            End Get
            Set(ByVal Value As Integer)
                Dim ScriptTypeID As Integer
                _ScriptID = Value
                Try
                    'determine input mode of script
                    _ScriptTypeID = CInt(SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, _
                        CommandType.Text, _
                        String.Format("SELECT ScriptTypeID FROM Scripts WHERE ScriptID = {0}", _ScriptID)))

                Catch ex As Exception
                    'invalid script id

                End Try

            End Set
        End Property

        Public ReadOnly Property ScriptTypeID() As Integer
            Get
                Return _ScriptTypeID

            End Get
        End Property

        Private Function GetInputMode(ByVal RespondentID As Integer) As QMS.qmsInputMode
            Dim InputMode As QMS.qmsInputMode = clsInputMode.LastInputMode(Me._Connection, RespondentID)

            If clsInputMode.CheckScriptType(InputMode, ScriptTypeID) Then
                Return InputMode
            Else
                Return qmsInputMode.VIEW
            End If

        End Function

    End Class

    'delete respondents
    Public Class rpDelete
        Inherits DMI.clsRowProcessor
        Public UserID As Integer

        Public Overloads Overrides Function Process(ByVal Row As System.Data.DataRow) As Boolean
            If Delete(_Connection, Me.UserID, CInt(Row.Item("RespondentID"))) Then
                Row.Delete()
                Row.AcceptChanges()
                Return True

            Else
                Return False

            End If

        End Function

        Public Overloads Overrides Function Process(ByVal Row As System.Data.SqlClient.SqlDataReader) As Boolean
            Delete(_Connection, Me.UserID, CInt(Row.Item("RespondentID")))
            Return True

        End Function

        Private Function Delete(ByVal Connection As SqlClient.SqlConnection, ByVal UserID As Integer, ByVal RespondentID As Integer) As Boolean

            SqlHelper.ExecuteNonQuery(Connection, CommandType.StoredProcedure, "delete_Respondent", New SqlClient.SqlParameter("@RespondentID", RespondentID))
            Return True

        End Function

    End Class

    Public Class rpTrigger
        Inherits DMI.clsRowProcessor

        Private _Trigger As SurveyPointDAL.clsTriggers
        Private _UserID As Integer
        Private _TriggerID As Integer
        Private _Conn As SqlClient.SqlConnection

        Public Sub New(ByVal iUserID As Integer, ByVal iTriggerID As Integer)
            UserID = iUserID
            TriggerID = iTriggerID
            Dim connStr As String = DMI.DataHandler.sConnection
            _Conn = New SqlClient.SqlConnection(connStr)
        End Sub

        Protected ReadOnly Property TriggerHelper() As SurveyPointDAL.clsTriggers
            Get
                If IsNothing(_Trigger) Then
                    _Trigger = New SurveyPointDAL.clsTriggers
                    _Trigger.UserID = UserID
                    _Trigger.DBConnection = _Connection
                End If
                Return _Trigger
            End Get
        End Property

        Public Property UserID() As Integer
            Get
                Return _UserID
            End Get
            Set(ByVal Value As Integer)
                _UserID = Value
            End Set
        End Property

        Public Property TriggerID() As Integer
            Get
                Return _TriggerID
            End Get
            Set(ByVal Value As Integer)
                _TriggerID = Value
            End Set
        End Property

        Public Overloads Overrides Function Process(ByVal Row As System.Data.DataRow) As Boolean
            Return ExecuteTrigger(CInt(Row.Item("RespondentID")))

        End Function

        Public Overloads Overrides Function Process(ByVal Row As System.Data.SqlClient.SqlDataReader) As Boolean
            Return ExecuteTrigger(CInt(Row.Item("RespondentID")))

        End Function

        Protected Function ExecuteTrigger(ByVal iRespondentID As Integer) As Boolean
            Dim trans As SqlClient.SqlTransaction

            Try
                Dim trigger As SurveyPointDAL.clsTriggers = TriggerHelper

                trans = _Conn.BeginTransaction
                trigger.RespondentID = iRespondentID
                trigger.DBTransaction = trans

                Dim cmdTrigger As String = trigger.RunTrigger(TriggerID)

                If trigger.HasTriggerErrors() Then
                    trans.Rollback()
                Else
                    trans.Commit()
                End If

            Catch ex As Exception
                If Not IsNothing(trans) Then trans.Rollback()
                Return False

            End Try

            Return True

        End Function

        Public Overrides Sub Close()
            If Not IsNothing(_Conn) Then
                If _Conn.State = ConnectionState.Open Then _Conn.Close()
                _Conn.Dispose()
            End If
        End Sub
    End Class

#End Region

    Public Property SurveyInstanceID() As Integer
        Get
            Return _iSurveyInstanceID

        End Get
        Set(ByVal Value As Integer)
            _iSurveyInstanceID = Value

        End Set
    End Property

    Public Property UserID() As Integer
        Get
            Return _iUserID

        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value

        End Set
    End Property

    Public Shared Function GetSelectCountSQL(ByRef drCriteria As DataRow, ByRef oConn As Data.SqlClient.SqlConnection) As String
        Dim sbSQL As New Text.StringBuilder("")

        'Add SELECT statement
        sbSQL.AppendFormat("SELECT COUNT(*) {0}", clsRespondents.MAIN_FROM_CLAUSE)
        sbSQL.Append(GetWhereSQL(drCriteria, oConn))

        Return sbSQL.ToString
    End Function

    Public Shared Function GetRespondentsCount(ByRef drCriteria As DataRow, ByRef oConn As Data.SqlClient.SqlConnection) As Integer
        Dim respondentsCount As Integer = -1
        Dim sSQL As String = GetSelectCountSQL(drCriteria, oConn)
        'TP Change
        respondentsCount = CInt(SqlHelper.Db(oConn.ConnectionString).ExecuteScalar(CommandType.Text, sSQL))
        'respondentsCount = CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sSQL))
        Return respondentsCount
    End Function

    Public Function GetRespondentsCount(ByRef drCriteria As DataRow) As Integer
        Return GetRespondentsCount(drCriteria, _oConn)
    End Function

    Public Shared Function HasHousehold(ByVal Connection As SqlClient.SqlConnection, ByVal RespondentID As Integer) As Boolean
        Dim Result As Integer
        'TP Change        
        Result = CInt(SqlHelper.Db(Connection.ConnectionString).ExecuteScalar("dbo.HasHousehold", RespondentID))
        'Result = CInt(SqlHelper.ExecuteScalar(Connection, CommandType.Text, "SELECT dbo.HasHousehold(@RespondentID)", _
        'New SqlClient.SqlParameter("@RespondentID", RespondentID)))

        If Result = 1 Then Return True Else Return False

    End Function

    Public Shared Function GetSurveyInstanceID(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As Integer
        Dim sql As String = String.Format("SELECT SurveyInstanceID FROM Respondents WHERE RespondentID = {0}", respondentID)
        'TP Change
        Dim result As Object = SqlHelper.Db(connection.ConnectionString).ExecuteScalar(CommandType.Text, sql)
        'Dim result As Object = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return DMI.DataHandler.NULLRECORDID
    End Function

    Public Shared Function CompletionStatus(ByVal connection As SqlClient.SqlConnection, ByVal RespondentID As Integer) As String

    End Function

#Region "Event Management"
    Public Sub DeleteEvent(ByVal iEventLogID As Integer)
        Dim arParams(1) As SqlClient.SqlParameter

        arParams(0) = New SqlClient.SqlParameter("@EventLogID", iEventLogID)
        'TP Change
        SqlHelper.Db(Me._oConn.ConnectionString).ExecuteNonQuery("delete_EventLog", arParams)
        'SqlHelper.ExecuteNonQuery(Me._oConn, CommandType.StoredProcedure, _
        '"delete_EventLog", arParams)

        arParams = Nothing

    End Sub

    Public Shared Sub InsertEvent(ByVal oConn As SqlClient.SqlConnection, ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal iRespondentID As Integer, Optional ByVal sParam As String = "")
        Dim arParams(4) As SqlClient.SqlParameter
        Dim iEventLogID As Int32 = 0

        arParams(0) = New SqlClient.SqlParameter("@EventLogID", iEventLogID)
        arParams(0).Direction = ParameterDirection.Output
        arParams(1) = New SqlClient.SqlParameter("@EventID", iEventID)
        arParams(2) = New SqlClient.SqlParameter("@UserID", iUserID)
        arParams(3) = New SqlClient.SqlParameter("@RespondentID", iRespondentID)
        arParams(4) = New SqlClient.SqlParameter("@EventParameters", sParam)
        'TP Change
        'SqlHelper.Db(oConn.ConnectionString).ExecuteNonQuery("insert_EventLog", arParams)
        Dim cmd As New SqlClient.SqlCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "insert_EventLog"
        cmd.Parameters.AddRange(arParams)

        SqlHelper.Db(oConn.ConnectionString).ExecuteNonQuery(cmd)
        'SqlHelper.Db(oConn.ConnectionString).ExecuteNonQuery("insert_EventLog", iEventLogID, iEventID, iUserID, iRespondentID, sParam)
        'SqlHelper.ExecuteNonQuery(oConn, CommandType.StoredProcedure, _
        '"insert_EventLog", arParams)

        arParams = Nothing

    End Sub

    Public Shared Sub InsertEvent(ByVal oTrans As SqlClient.SqlTransaction, ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal iRespondentID As Integer, Optional ByVal sParam As String = "")
        Dim arParams(4) As SqlClient.SqlParameter
        Dim iEventLogID As Integer = 0

        arParams(0) = New SqlClient.SqlParameter("@EventLogID", iEventLogID)
        arParams(0).Direction = ParameterDirection.Output
        arParams(1) = New SqlClient.SqlParameter("@EventID", iEventID)
        arParams(2) = New SqlClient.SqlParameter("@UserID", iUserID)
        arParams(3) = New SqlClient.SqlParameter("@RespondentID", iRespondentID)
        arParams(4) = New SqlClient.SqlParameter("@EventParameters", sParam)
        'TP Change
        SqlHelper.Db(oTrans.Connection.ConnectionString).ExecuteNonQuery("insert_EventLog", arParams)
        'SqlHelper.ExecuteNonQuery(oTrans, CommandType.StoredProcedure, "insert_EventLog", arParams)

        arParams = Nothing

    End Sub


    Public Shared Sub InsertEvent(ByVal oConn As SqlClient.SqlConnection, ByVal dtEventDate As DateTime, ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal iRespondentID As Integer, Optional ByVal sParam As String = "")
        Dim arParams(5) As SqlClient.SqlParameter
        Dim iEventLogID As Int32 = 0

        arParams(0) = New SqlClient.SqlParameter("@EventLogID", iEventLogID)
        arParams(0).Direction = ParameterDirection.Output
        arParams(1) = New SqlClient.SqlParameter("@EventDate", dtEventDate)
        arParams(2) = New SqlClient.SqlParameter("@EventID", iEventID)
        arParams(3) = New SqlClient.SqlParameter("@UserID", iUserID)
        arParams(4) = New SqlClient.SqlParameter("@RespondentID", iRespondentID)
        arParams(5) = New SqlClient.SqlParameter("@EventParameters", sParam)
        'TP Change
        Dim cmd As New SqlClient.SqlCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "insert_EventLog_WITHDATE"
        cmd.Parameters.AddRange(arParams)
        SqlHelper.Db(oConn.ConnectionString).ExecuteNonQuery(cmd)
        'SqlHelper.ExecuteNonQuery(oConn, CommandType.StoredProcedure, _
        '"insert_EventLog_WITHDATE", arParams)

        arParams = Nothing

    End Sub

    Public Sub InsertEvent(ByVal iEventID As Integer, ByVal iUserID As Integer, Optional ByVal sParam As String = "", Optional ByVal iProtocolStepID As Integer = -1)
        If Me.MainDataTable.Rows.Count > 0 Then
            Dim bAtMax As Boolean = False
            Dim iRespondentID As Integer = CInt(Me.MainDataTable.Rows(0).Item("RespondentID"))
            InsertEvent(_oConn, iEventID, iUserID, iRespondentID, sParam)
            If IsCallEvent(iEventID) Then
                If iProtocolStepID > 0 Then
                    If clsProtocolSteps.IsMaxAttemptStep(_oConn, iProtocolStepID) Then bAtMax = True
                Else
                    MainDataTable.Rows(0).Item("CallsMade") = CInt(MainDataTable.Rows(0).Item("CallsMade")) + 1
                    If AtMaxCalls() Then bAtMax = True
                End If
                If bAtMax Then InsertEvent(_oConn, qmsEvents.RESPONDENT_MAX_CALL_REACHED, iUserID, iRespondentID, "")
            End If
        End If
    End Sub

    Public Shared Sub CheckMaxCall(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolStepId As Integer, ByVal iUserID As Integer, ByVal iRespondentID As Integer)
        If iProtocolStepId > 0 Then
            If clsProtocolSteps.IsMaxAttemptStep(oConn, iProtocolStepId) Then
                InsertEvent(oConn, qmsEvents.RESPONDENT_MAX_CALL_REACHED, iUserID, iRespondentID, "")
            End If
        End If
    End Sub

    Public Sub InsertEvent(ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal iRespondentID As Integer, ByVal sParam As String)
        InsertEvent(_oConn, iEventID, iUserID, iRespondentID, sParam)

    End Sub

    Public Shared Sub ClearCompleteness(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer)
        'TP Change
        SqlHelper.Db(oConn.ConnectionString).ExecuteNonQuery(CommandType.Text, String.Format("DELETE FROM EventLog WHERE RespondentID = {0} AND EventID IN (3000, 3001, 3002, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3035) ", _
        iRespondentID))
        'SqlHelper.ExecuteNonQuery(oConn, CommandType.Text, _
        'String.Format("DELETE FROM EventLog WHERE RespondentID = {0} AND EventID IN (3000, 3001, 3002, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3035) ", _
        'iRespondentID))

    End Sub

    Public Shared Sub ClearCompleteness(ByVal oTrans As SqlClient.SqlTransaction, ByVal iRespondentID As Integer)
        'SqlHelper.ExecuteNonQuery(oTrans, CommandType.Text, _
        'String.Format("DELETE FROM EventLog WHERE RespondentID = {0} AND EventID IN (3000, 3001, 3002, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3035) ", _
        'iRespondentID))
        'TP Change
        SqlHelper.Db(oTrans.Connection.ConnectionString).ExecuteNonQuery(CommandType.Text, _
            String.Format("DELETE FROM EventLog WHERE RespondentID = {0} AND EventID IN (3000, 3001, 3002, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3035) ", _
        iRespondentID))
    End Sub

    Public Sub ClearCompleteness()
        If Me.MainDataTable.Rows.Count > 0 Then
            ClearCompleteness(_oConn, CInt(Me.MainDataTable.Rows(0).Item("RespondentID")))
        End If

    End Sub

    Public Sub ScheduleAppointment(ByVal dAppointmentDate As Date, ByVal sAppointmentTime As String, ByVal iUserID As Integer)
        If dAppointmentDate >= DateAdd(DateInterval.Day, 1, Now).Date Then
            InsertEvent(qmsEvents.CALLBACK_APPOINTMENT_SCHEDULED, iUserID, _
            String.Format("{0:d} {1}", dAppointmentDate, sAppointmentTime).Trim)
            MainDataTable.Rows(0).Item("NextContact") = DateAdd(DateInterval.Day, 1, dAppointmentDate)
            Save()

        Else
            Me._sErrorMsg = String.Format("Appointment cannot be scheduled earlier than {0:d}", DateAdd(DateInterval.Day, 1, Now).Date)

        End If

    End Sub

    Public Sub SaveNote(ByVal sNote As String, ByVal iUserID As Integer)
        If sNote.Trim.Length > 0 Then
            If sNote.Trim.Length <= 3000 Then
                InsertEvent(qmsEvents.RESPONDENT_NOTE, iUserID, sNote.Trim)

            Else
                Me._sErrorMsg = String.Format("Note cannot exceed 3000 characters. Your note is {0} characters.", sNote.Trim.Length)

            End If

        Else
            Me._sErrorMsg = "Note cannot be blank. Please provide note text."

        End If

    End Sub

    Public Function IsCallEvent(ByVal iEventID As Integer) As Boolean
        Dim dtEvents As DataTable
        Dim dr() As DataRow

        'use events table
        If _dtmaintable.DataSet.Tables.Contains("tblEvents") Then
            dtEvents = _dtmaintable.DataSet.Tables("tblEvents")
            dr = dtEvents.Select(String.Format("EventID = {0} AND EventTypeID = 5", iEventID))
            If dr.Length > 0 Then Return True

        Else
            'check database
            Return clsEvents.IsCallEvent(_oConn, iEventID)

        End If

        Return False

    End Function

#End Region

#Region "Respondent workflow info"
    Public Function AlreadyBatched(ByVal respondentID As Integer, ByVal userID As Integer, Optional ByVal mailingID As String = "") As Boolean
        Me.FindByRespondentID(respondentID)
        If Not IsDBNull(Me.MainDataTable.Rows(0).Item("BatchID")) Then
            'log batch attempt
            Me.InsertEvent(CInt(qmsEvents.BATCHED_ATTEMPT), userID, mailingID)
            Throw New ApplicationException(String.Format("Respondent ID {0} already in batch ID {1}.", respondentID, Me.MainDataTable.Rows(0).Item("BatchID")))
            Return True
        End If

        Return False

    End Function

    Public Shared Function BatchingAllowed(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean
        Dim iProtocolID As Integer

        iProtocolID = ProtocolID(oConn, iRespondentID)

        Return clsProtocols.ContainsBatching(oConn, iProtocolID)

    End Function

    Public Function BatchingAllowed() As Boolean

        Try
            If MainDataTable.Rows.Count > 0 Then
                Dim respondentID As Integer = CInt(MainDataTable.Rows(0).Item("RespondentID"))
                BatchValidation(Me._oConn, respondentID)

            End If

            Return True

        Catch ex As Exception
            Me._sErrorMsg = ex.Message
            Return False

        End Try

    End Function

    Public Shared Function BatchValidation(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As Boolean
        If BatchingAllowed(connection, respondentID) Then
            If Not IsBatchFinal(connection, respondentID) Then
                If Not HasCompletedSurvey(connection, respondentID) Then
                    Return True

                Else
                    Throw New ApplicationException(String.Format("Respondent ({0}) has already completed survey and cannot be batched.", respondentID))

                End If
            Else
                Throw New ApplicationException(String.Format("Respondent ({0}) is final and cannot be batched.", respondentID))

            End If

        Else
            Throw New ApplicationException(String.Format("Survey instance for respondent ({0}) does not allow batching.", respondentID))

        End If

        Return False

    End Function

    Public Shared Function IsBatchFinal(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As Boolean
        Dim sql As New Text.StringBuilder
        Dim result As Object

        'Check for final codes - ignoring Max call attempts, No Telephone number available,
        'Wrong Telephone number, Telephone number disconected
        sql.Append("SELECT COUNT(*) FROM vr_RespondentEventLog WHERE Final = 1 ")
        sql.Append("AND RespondentEventID NOT IN (2063, 5001, 5002, 5003) ")
        sql.AppendFormat("AND RespondentID = {0}", respondentID)

        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql.ToString)

        If Not IsNothing(result) And Not IsDBNull(result) Then
            If CInt(result) > 0 Then Return True
        End If

        Return False

    End Function

    Public Shared Function HasCompletedSurvey(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As Boolean
        Dim sql As New Text.StringBuilder
        Dim result As Object

        'Check for final codes - ignoring Max call attempts, No Telephone number available,
        'Wrong Telephone number, Telephone number disconected
        sql.Append("SELECT COUNT(*) FROM EventLog WHERE ")
        sql.Append("EventID IN (3002, 3012, 3022, 3032) ")
        sql.AppendFormat("AND RespondentID = {0}", respondentID)

        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql.ToString)

        If Not IsNothing(result) And Not IsDBNull(result) Then
            If CInt(result) > 0 Then Return True
        End If

        Return False

    End Function

    Public Shared Function Batch(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer, ByVal lastBatchID As Integer, ByVal userID As Integer, Optional ByVal mailingID As String = "") As Integer
        InsertEvent(connection, QMS.qmsEvents.BATCH_RESPONDENT, userID, respondentID, mailingID)
        Return Batch(connection, respondentID, lastBatchID)

    End Function

    Public Shared Function Batch(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer, ByVal iLastBatchID As Integer) As Integer
        Dim sbSQL As New Text.StringBuilder
        Dim ds As New DataSet
        Dim rNewBatch As DataRow
        Dim rLastBatch As DataRow

        'clear locks on respondent to allow data entry
        sbSQL.AppendFormat("DELETE FROM EventLog WHERE RespondentID = {0} AND EventID IN (2063)", iRespondentID)
        SqlHelper.ExecuteNonQuery(oConn, CommandType.Text, sbSQL.ToString)
        sbSQL.Remove(0, sbSQL.Length)

        'Get batch configuration for respondent's survey instance
        sbSQL.Append("SELECT TOP 1 b.GroupBySurvey * b.SurveyID AS SurveyID, b.GroupByClient * b.ClientID AS ClientID, ")
        sbSQL.Append("b.GroupBySurveyInstance * b.SurveyInstanceID AS SurveyInstanceID, ISNULL(r.BatchID,0) AS BatchID ")
        sbSQL.Append("FROM v_Batches b INNER JOIN Respondents r ON b.SurveyInstanceID = r.SurveyInstanceID ")
        sbSQL.AppendFormat("WHERE (r.RespondentID = {0}) ", iRespondentID)

        'previous batch exists
        If iLastBatchID > 0 Then

            'Get batch configuration for last batch id
            sbSQL.Append("; SELECT BatchID, MAX(SurveyID) * MAX(GroupBySurvey) AS SurveyID, MAX(ClientID) * MAX(GroupByClient) AS ClientID, ")
            sbSQL.Append("MAX(SurveyInstanceID) * MAX(GroupBySurveyInstance) AS SurveyInstanceID, MAX(BatchSize) AS BatchSize, ")
            sbSQL.Append("SUM(RespondentCount) AS RespondentCount FROM v_Batches GROUP BY BatchID ")
            sbSQL.AppendFormat("HAVING (BatchID = {0})", iLastBatchID)

        End If

        DMI.DataHandler.GetDS(oConn, ds, sbSQL.ToString)
        sbSQL.Remove(0, sbSQL.Length)

        'Does survey instance have batch protocol step
        If ds.Tables(0).Rows.Count > 0 Then
            rNewBatch = ds.Tables(0).Rows(0)

            'previous batch exists, compare batch settings
            If iLastBatchID > 0 Then

                rLastBatch = ds.Tables(1).Rows(0)

                'do batch survey config match
                If CInt(rNewBatch.Item("SurveyID")) = CInt(rLastBatch.Item("SurveyID")) Then
                    'do batch client config match
                    If CInt(rNewBatch.Item("ClientID")) = CInt(rLastBatch.Item("ClientID")) Then
                        'do batch survey instance config match
                        If CInt(rNewBatch.Item("SurveyInstanceID")) = CInt(rLastBatch.Item("SurveyInstanceID")) Then
                            'try to batch respondent into last batch
                            sbSQL.AppendFormat("EXEC spBatchSurvey {0}, {1}, {2}", iRespondentID, iLastBatchID, rLastBatch.Item("BatchSize"))
                            ds = Nothing
                            rNewBatch = Nothing
                            rLastBatch = Nothing
                            Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString))

                        End If
                    End If
                End If

            End If

            'batch respondent into new batch
            sbSQL.AppendFormat("EXEC spBatchSurvey {0}, NULL, 0", iRespondentID)
            ds = Nothing
            rNewBatch = Nothing
            rLastBatch = Nothing
            Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString))

        End If

        ds = Nothing
        rNewBatch = Nothing
        rLastBatch = Nothing
        Return -1

    End Function

    Public Function Batch(ByVal iLastBatchID As Integer, ByVal iUserID As Integer) As Integer
        Dim iRespondentID As Integer

        If MainDataTable.Rows.Count > 0 Then
            iRespondentID = CInt(MainDataTable.Rows(0).Item("RespondentID"))
            Me.InsertEvent(QMS.qmsEvents.BATCH_RESPONDENT, iUserID)
            Return Batch(_oConn, iRespondentID, iLastBatchID)

        End If

        Return -1

    End Function

    Public Shared Function MaxCallsAllowed(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Integer
        Dim iProtocolID As Integer

        iProtocolID = ProtocolID(oConn, iRespondentID)

        Return clsProtocols.MaxCallAttempts(oConn, iProtocolID)

    End Function

    Public Shared Function DataEntryAllowed(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean
        Dim iProtocolID As Integer

        iProtocolID = ProtocolID(oConn, iRespondentID)

        Return clsProtocols.ContainsDataEntry(oConn, iProtocolID)

    End Function

    Public Function DataEntryAllowed() As Boolean
        If MainDataTable.Rows.Count > 0 Then
            Return DataEntryAllowed(_oConn, CInt(MainDataTable.Rows(0).Item("RespondentID")))

        End If
        Return False

    End Function

    Public Shared Function VerificationAllowed(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean
        Dim iProtocolID As Integer

        iProtocolID = ProtocolID(oConn, iRespondentID)

        Return clsProtocols.ContainsVerification(oConn, iProtocolID)

    End Function

    Public Function VerificationAllowed() As Boolean
        If MainDataTable.Rows.Count > 0 Then
            Return VerificationAllowed(_oConn, CInt(MainDataTable.Rows(0).Item("RespondentID")))

        End If
        Return False

    End Function

    Public Shared Function CATIAllowed(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean
        Dim iProtocolID As Integer

        iProtocolID = ProtocolID(oConn, iRespondentID)

        Return clsProtocols.ContainsCATI(oConn, iProtocolID)

    End Function

    Public Function CATIAllowed() As Boolean
        If MainDataTable.Rows.Count > 0 Then
            Return CATIAllowed(_oConn, CInt(MainDataTable.Rows(0).Item("RespondentID")))

        End If
        Return False

    End Function

    Public Shared Function ReminderCallsAllowed(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean
        Dim iProtocolID As Integer

        iProtocolID = ProtocolID(oConn, iRespondentID)

        Return clsProtocols.ContainsReminderCalls(oConn, iProtocolID)

    End Function

    Public Function ReminderCallsAllowed() As Boolean
        If MainDataTable.Rows.Count > 0 Then
            Return ReminderCallsAllowed(_oConn, CInt(MainDataTable.Rows(0).Item("RespondentID")))

        End If
        Return False

    End Function

    Public Shared Function ProtocolID(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, _
        String.Format("SELECT si.ProtocolID FROM Respondents r INNER JOIN SurveyInstances si ON r.SurveyInstanceID = si.SurveyInstanceID WHERE (r.RespondentID = {0})", iRespondentID)))
    End Function

    Public Function InputModeAllowed(ByVal iInputMode As qmsInputMode) As Boolean
        Select Case iInputMode
            Case QMS.qmsInputMode.DATAENTRY
                Return DataEntryAllowed()

            Case QMS.qmsInputMode.VERIFY
                Return VerificationAllowed()

            Case QMS.qmsInputMode.CATI
                Return CATIAllowed()

            Case QMS.qmsInputMode.RCALL
                Return ReminderCallsAllowed()

            Case Else
                Return True

        End Select

    End Function

    Public Function IsFinal() As Boolean
        If MainDataTable.Rows.Count > 0 Then
            If CInt(MainDataTable.Rows(0).Item("Final")) = 1 Then Return True

        End If

        Return False

    End Function

    Public Shared Function IsFinal(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean
        Dim sSQL As String
        sSQL = String.Format("SELECT COUNT(RespondentID) FROM Respondents WHERE RespondentID = {0} AND Final = 1", iRespondentID)
        If CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sSQL)) > 0 Then Return True
        Return False

    End Function

    Public Shared Function IsBatched(ByVal respondentID As Integer, ByVal connection As SqlClient.SqlConnection) As Boolean
        Dim sql As String
        sql = String.Format("SELECT COUNT(*) FROM EventLog WHERE RespondentID = {0} AND EventID = {1}", respondentID, CInt(QMS.qmsEvents.BATCH_RESPONDENT))
        If CInt(SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)) > 0 Then Return True
        Return False

    End Function

    Public Shared Function LastCompletionCode(ByVal respondentID As Integer, ByVal connection As SqlClient.SqlConnection) As Integer
        Dim sql As String
        Dim result As Object

        sql = String.Format("SELECT EventID FROM EventLog WHERE RespondentID = {0} AND EventID IN (3000, 3001, 3002, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3035) ", respondentID)
        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If

        Return -1

    End Function

    Public Function AtMaxCalls() As Boolean
        Dim sSQL As String
        Dim Retval As Object
        Dim MaxCalls As Integer

        If MainDataTable.Rows.Count > 0 Then
            MaxCalls = MaxCallsAllowed(_oConn, CInt(MainDataTable.Rows(0).Item("RespondentID")))
            'max calls only applies if max calls is greater than zero
            If MaxCalls > 0 Then
                If CInt(MainDataTable.Rows(0).Item("CallsMade")) >= MaxCalls Then
                    Return True

                End If

            End If

        End If

        Return False

    End Function

    Public Shared Function AtMaxCalls(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer) As Boolean
        Dim iMaxCalls As Integer
        Dim iCalls As Integer

        iCalls = CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, String.Format("SELECT CallsMade FROM Respondents WHERE RespondentID = {0}", iRespondentID)))
        iMaxCalls = MaxCallsAllowed(oConn, iRespondentID)

        If iCalls >= iMaxCalls Then Return True

        Return False

    End Function

    Public Function GroupByHousehold() As Boolean
        Dim sSQL As String
        Dim Retval As Object
        Dim oSI As clsSurveyInstances

        If MainDataTable.Rows.Count > 0 Then
            oSI = New clsSurveyInstances(_oConn)
            oSI.FillMain(CInt(MainDataTable.Rows(0).Item("SurveyInstanceID")))
            If CInt(oSI.MainDataTable.Rows(0).Item("GroupByHousehold")) = 1 Then
                oSI.Close()
                oSI = Nothing
                Return True
            End If


        End If

        oSI.Close()
        oSI = Nothing
        Return False

    End Function

    Public Shared Function HasBeenInputed(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer, ByVal iInputMode As qmsInputMode) As Boolean
        Dim iEventID As Integer
        Dim sSQL As String
        Dim im As IInputMode = clsInputMode.Create(iInputMode)

        sSQL = String.Format("SELECT COUNT(*) FROM EventLog WHERE RespondentID = {0} AND EventID = {1}", iRespondentID, CInt(im.StartEventID))
        im = Nothing
        If CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sSQL)) > 0 Then Return True
        Return False

    End Function

    Public Function HasBeenInputed(ByVal iInputMode As qmsInputMode) As Boolean
        If MainDataTable.Rows.Count > 0 Then
            Return HasBeenInputed(_oConn, CInt(MainDataTable.Rows(0).Item("RespondentID")), iInputMode)

        End If

    End Function

    Public Shared Function ValidScript(ByVal Connection As SqlClient.SqlConnection, ByVal RespondentID As Integer, ByVal ScriptID As Integer) As Boolean
        Dim sqlValidate As New Text.StringBuilder

        sqlValidate.Append("SELECT COUNT(Scripts.ScriptID) AS ValidScript ")
        sqlValidate.Append("FROM SurveyInstances INNER JOIN ")
        sqlValidate.Append("Respondents ON SurveyInstances.SurveyInstanceID = Respondents.SurveyInstanceID INNER JOIN ")
        sqlValidate.Append("Scripts ON SurveyInstances.SurveyID = Scripts.SurveyID ")
        sqlValidate.AppendFormat("WHERE (Scripts.ScriptID = {0}) AND (Respondents.RespondentID = {1})", ScriptID, RespondentID)

        If CInt(SqlHelper.ExecuteScalar(Connection, CommandType.Text, sqlValidate.ToString)) > 0 Then
            'respondent can use script
            Return True

        Else
            'respondent cannot use script, belongs to different survey
            Return False

        End If

    End Function

    Public Shared Function InActiveSurveyInstance(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As Boolean
        Dim sql As String
        Dim result As Object

        sql = String.Format("SELECT COUNT(*) FROM Respondents r INNER JOIN SurveyInstances si ON r.SurveyInstanceID = si.SurveyInstanceID WHERE (si.Active = 1) AND (r.RespondentID = {0})", respondentID)
        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            If CInt(result) = 1 Then Return True
        End If
        Return False

    End Function

#End Region

#Region "Select Respondent"
    Public Function SelectForInput(ByVal iInputMode As QMS.qmsInputMode, ByVal iRespondentID As Integer, ByVal iByUserID As Integer) As Boolean
        Dim iEventCode As QMS.qmsEvents
        Dim dr As DataRow
        Dim im As IInputMode = clsInputMode.Create(iInputMode)

        'get respondent data
        FillMain(iRespondentID)

        'verify existence of respondent
        If MainDataTable.Rows.Count > 0 Then
            'verify input mode is allowed
            If im.AllowRespondent(_oConn, iRespondentID) Then
                'log selection, get related event code
                InsertEvent(im.SelectEventID, iByUserID, iRespondentID, "")

            Else
                Me._sErrorMsg = im.ErrorMsg
                Return False

            End If

        Else
            _sErrorMsg = String.Format("Respondent id {0} does not exist.", iRespondentID)
            Return False

        End If

        Return True

    End Function

#End Region

#Region "Clear responses"
    Public Shared Sub ClearResponses(ByVal oConn As SqlClient.SqlConnection, ByVal iRespondentID As Integer)
        SqlHelper.ExecuteNonQuery(oConn, CommandType.StoredProcedure, "delete_RespondentResponses", _
        New SqlClient.SqlParameter("@RespondentID", iRespondentID))

    End Sub

    Public Sub ClearResponses()
        If _dtmaintable.Rows.Count > 0 Then
            ClearResponses(_oConn, CInt(_dtmaintable.Rows(0).Item("RespondentID")))

        End If

    End Sub
#End Region

#Region "Check Change Functions"
    Private Function _ChangedName(ByVal dr As DataRow) As Boolean
        If Not DMI.clsUtil.ChangedDataItem(dr, "FirstName") Then
            If Not DMI.clsUtil.ChangedDataItem(dr, "LastName") Then
                If Not DMI.clsUtil.ChangedDataItem(dr, "MiddleInitial") Then
                    Return False

                End If
            End If
        End If

        Return True

    End Function

    Private Function _ChangedAddress(ByVal dr As DataRow) As Boolean
        If Not DMI.clsUtil.ChangedDataItem(dr, "Address1") Then
            If Not DMI.clsUtil.ChangedDataItem(dr, "Address2") Then
                If Not DMI.clsUtil.ChangedDataItem(dr, "City") Then
                    If Not DMI.clsUtil.ChangedDataItem(dr, "State") Then
                        If Not DMI.clsUtil.ChangedDataItem(dr, "PostalCode") Then
                            If Not DMI.clsUtil.ChangedDataItem(dr, "PostalCodeExt") Then
                                Return False
                            End If
                        End If
                    End If
                End If
            End If
        End If

        Return True

    End Function

    Private Function _ChangedTelephone(ByVal dr As DataRow) As Boolean
        If Not DMI.clsUtil.ChangedDataItem(dr, "TelephoneDay") Then
            If Not DMI.clsUtil.ChangedDataItem(dr, "TelephoneEvening") Then
                Return False

            End If
        End If

        Return True

    End Function

    Private Function _ChangedEmail(ByVal dr As DataRow) As Boolean
        If Not DMI.clsUtil.ChangedDataItem(dr, "Email") Then Return False
        Return True

    End Function

    Private Function _ChangedDemographic(ByVal dr As DataRow) As Boolean
        If Not DMI.clsUtil.ChangedDataItem(dr, "DOB") Then
            If Not DMI.clsUtil.ChangedDataItem(dr, "Gender") Then
                Return False

            End If
        End If

        Return True

    End Function

    Private Function _ChangedIdentity(ByVal dr As DataRow) As Boolean
        If Not DMI.clsUtil.ChangedDataItem(dr, "SSN") Then
            If Not DMI.clsUtil.ChangedDataItem(dr, "ClientRespondentID") Then
                Return False

            End If
        End If

        Return True

    End Function

    Public ReadOnly Property ChangedName() As Boolean
        Get
            Return _bChangedName

        End Get
    End Property

    Public ReadOnly Property ChangedAddress() As Boolean
        Get
            Return _bChangedAddress

        End Get
    End Property

    Public ReadOnly Property ChangedTelephone() As Boolean
        Get
            Return _bChangedTelephone

        End Get
    End Property

    Public ReadOnly Property ChangedEmail() As Boolean
        Get
            Return _bChangedEmail

        End Get
    End Property

    Public ReadOnly Property ChangedIdentity() As Boolean
        Get
            Return _bChangedIdentity

        End Get
    End Property

    Public ReadOnly Property ChangedDemographic() As Boolean
        Get
            Return _bChangedDemographic

        End Get
    End Property
#End Region

#Region "Datagrid functions"
    'logs event for selected rows in datagrid from dbentity
    Public Function DataGridLogEvent(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal EventID As Integer, ByVal UserID As Integer, ByVal SortBy As String, Optional ByVal eventDate As DateTime = DMI.clsUtil.NULLDATE) As Integer
        Dim rp As New rpLogEvent
        Dim RowCount As Integer

        rp.Init(Me._oConn)
        rp.EventID = EventID
        rp.UserID = UserID
        rp.EventDate = eventDate

        RowCount = DMI.clsDataGridTools.DataGridRowProcessor(dg, Me, rp, SortBy)

        rp.Close()
        rp = Nothing

        Return RowCount

    End Function

    'calculates score for selected rows in datagrid from dbentity
    Public Function DataGridScore(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal ScriptID As Integer, ByVal UserID As Integer, ByVal SortBy As String, Optional ByVal updateOnly As Boolean = True) As Integer
        Dim rp As New rpScoreResponses
        Dim RowCount As Integer

        rp.Init(Me._oConn)
        rp.ScriptID = ScriptID
        rp.UserID = UserID
        rp.UpdateOnly = updateOnly

        RowCount = DMI.clsDataGridTools.DataGridRowProcessor(dg, Me, rp, SortBy)

        rp.Close()
        rp = Nothing

        Return RowCount

    End Function

    'changes survey instance for selected rows in datagrid from dbentity
    Public Function DataGridMove(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal SurveyInstanceID As Integer, ByVal UserID As Integer, ByVal SortBy As String) As Integer
        Dim rp As New rpChangeSurveyInstance
        Dim RowCount As Integer

        rp.Init(Me._oConn)
        rp.SurveyInstanceID = SurveyInstanceID
        rp.UserID = UserID

        RowCount = DMI.clsDataGridTools.DataGridRowProcessor(dg, Me, rp, SortBy)

        rp.Close()
        rp = Nothing

        Return RowCount

    End Function

    'run trigger for selected rows in datagrid from dbentity
    Public Function DataGridTrigger(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal TriggerID As Integer, ByVal UserID As Integer, ByVal SortBy As String) As Integer
        Dim rp As New rpTrigger(UserID, TriggerID)
        Dim RowCount As Integer

        RowCount = DMI.clsDataGridTools.DataGridRowProcessor(dg, Me, rp, SortBy)

        rp.Close()
        rp = Nothing

        Return RowCount

    End Function


    'Run selected rows in datagrid from dbentity thru processor code
    Public Function DataGridProcessorCode(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal UserID As Integer, ByVal processorCode As String, ByVal SortBy As String) As Integer
        Dim rp As New rpRunCodeProcessor
        Dim RowCount As Integer

        rp.Init(Me._oConn)
        rp.UserID = UserID
        rp.ProcessorCode = processorCode

        RowCount = DMI.clsDataGridTools.DataGridRowProcessor(dg, Me, rp, SortBy)

        rp.Close()
        rp = Nothing

        Return RowCount

    End Function

    Public Function DataGridRowProcessor(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal rp As DMI.clsRowProcessor, ByVal SortBy As String) As Integer
        Dim RowCount As Integer

        rp.Init(Me._oConn)

        RowCount = DMI.clsDataGridTools.DataGridRowProcessor(dg, Me, rp, SortBy)

        rp.Close()
        rp = Nothing

        Return RowCount

    End Function

#End Region

#Region "SQL Provider"
    Public Shared Function InsertRespondent(ByVal connection As SqlClient.SqlConnection, ByVal SurveyInstanceID As Integer, ByVal LastName As String, ByVal FirstName As String, ByVal MiddleInitial As String, ByVal Email As String, ByVal Address1 As String, ByVal Address2 As String, ByVal City As String, ByVal State As String, ByVal ZipCode As String, ByVal TelephoneDay As String, ByVal TelephoneEvening As String, ByVal Gender As String, ByVal DOB As DateTime, ByVal SSN As String, ByVal ClientRespondentID As String) As Integer
        Dim null As DMI.Null
        Dim respondentID As New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4)
        respondentID.Direction = ParameterDirection.Output

        SqlHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, "insert_Respondents", _
            respondentID, _
            New SqlClient.SqlParameter("@SurveyInstanceID", SurveyInstanceID), _
            New SqlClient.SqlParameter("@FirstName", null.GetNull(FirstName, DBNull.Value)), _
            New SqlClient.SqlParameter("@MiddleInitial", null.GetNull(MiddleInitial, DBNull.Value)), _
            New SqlClient.SqlParameter("@LastName", LastName), _
            New SqlClient.SqlParameter("@Address1", null.GetNull(Address1, DBNull.Value)), _
            New SqlClient.SqlParameter("@Address2", null.GetNull(Address2, DBNull.Value)), _
            New SqlClient.SqlParameter("@City", null.GetNull(City, DBNull.Value)), _
            New SqlClient.SqlParameter("@State", null.GetNull(State, DBNull.Value)), _
            New SqlClient.SqlParameter("@PostalCode", null.GetNull(ZipCode, DBNull.Value)), _
            New SqlClient.SqlParameter("@TelephoneDay", null.GetNull(TelephoneDay, DBNull.Value)), _
            New SqlClient.SqlParameter("@TelephoneEvening", null.GetNull(TelephoneEvening, DBNull.Value)), _
            New SqlClient.SqlParameter("@Email", null.GetNull(Email, DBNull.Value)), _
            New SqlClient.SqlParameter("@DOB", null.GetNull(DOB, DBNull.Value)), _
            New SqlClient.SqlParameter("@Gender", null.GetNull(Gender, DBNull.Value)), _
            New SqlClient.SqlParameter("@ClientRespondentID", null.GetNull(ClientRespondentID, DBNull.Value)), _
            New SqlClient.SqlParameter("@SSN", null.GetNull(SSN, DBNull.Value)), _
            New SqlClient.SqlParameter("@BatchID", null.GetNull(DBNull.Value, DBNull.Value)))

        Return CInt(respondentID.Value)

    End Function
#End Region
End Class

#Region "Repondent contact validators"
Public MustInherit Class validateRespondentContact
    Protected _oConn As SqlClient.SqlConnection
    Public MustOverride Function Validate(ByVal dr As DataRow) As Boolean
    Public MustOverride Function AffectsProtocolStepTypes() As Integer()
    Public MustOverride Function EventCode() As Integer

End Class

Public Class vrcValidateTelephone
    Inherits validateRespondentContact

    Public Overrides Function Validate(ByVal dr As System.Data.DataRow) As Boolean
        Dim rx As Text.RegularExpressions.Regex

        'check for nulls
        If IsDBNull(dr.Item("TelephoneDay")) Then dr.Item("TelephoneDay") = ""
        If IsDBNull(dr.Item("TelephoneEvening")) Then dr.Item("TelephoneEvening") = ""

        'must have at least one good telephone
        If rx.IsMatch(dr.Item("TelephoneDay").ToString, "(\d{3})?\d{7}") Or _
        rx.IsMatch(dr.Item("TelephoneEvening").ToString, "(\d{3})?\d{7}") Then
            Return True

        End If

        'no good telephone number, null to avoid household grouping
        dr.Item("TelephoneDay") = DBNull.Value
        dr.Item("TelephoneEvening") = DBNull.Value
        Return False

    End Function

    Public Overrides Function AffectsProtocolStepTypes() As Integer()
        'cati and reminder calls
        Return New Integer(1) {5, 6}

    End Function

    Public Overrides Function EventCode() As Integer
        Return 2065

    End Function

End Class

Public Class vrcValidateAddress
    Inherits validateRespondentContact

    Public Overrides Function Validate(ByVal dr As System.Data.DataRow) As Boolean
        Dim rx As Text.RegularExpressions.Regex

        If Not IsDBNull(dr.Item("Address1")) AndAlso Not dr.Item("Address1").ToString.Length = 0 Then
            If Not IsDBNull(dr.Item("City")) AndAlso Not dr.Item("City").ToString.Length = 0 Then
                If Not IsDBNull(dr.Item("State")) AndAlso Not dr.Item("State").ToString.Length = 0 Then
                    If Not IsDBNull(dr.Item("PostalCode")) AndAlso Not dr.Item("PostalCode").ToString.Length = 0 Then
                        If rx.IsMatch(dr.Item("PostalCode").ToString, "\d{5}(-\d{4})?") Then
                            Return True

                        End If
                    End If
                End If
            End If
        End If

        Return False

    End Function

    Public Overrides Function AffectsProtocolStepTypes() As Integer()
        'mailing and batching 
        Return New Integer(1) {1, 2}

    End Function

    Public Overrides Function EventCode() As Integer
        Return 2064

    End Function

End Class

Public Class vrcValidateEmail
    Inherits validateRespondentContact

    Public Overrides Function Validate(ByVal dr As System.Data.DataRow) As Boolean
        Dim rx As Text.RegularExpressions.Regex

        If Not IsDBNull(dr.Item("Email")) AndAlso Not dr.Item("Email").ToString.Length = 0 Then
            If rx.IsMatch(dr.Item("Email").ToString, "\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*") Then
                Return True

            End If
        End If

        Return False

    End Function

    Public Overrides Function AffectsProtocolStepTypes() As Integer()
        Return New Integer(0) {0}

    End Function

    Public Overrides Function EventCode() As Integer
        Return 2066

    End Function

End Class

#End Region