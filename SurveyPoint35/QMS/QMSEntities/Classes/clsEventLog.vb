Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsEventLog
    Inherits DMI.clsDBEntity2

    Private _iUserID As Integer = 0

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
        If IsDBNull(drCriteria.Item("Top")) Then
            sbSQL.Append("SELECT * FROM vw_EventLog ")
        Else
            sbSQL.AppendFormat("SELECT TOP {0} * FROM vw_EventLog ", drCriteria.Item("Top"))
        End If
        sbSQL.Append(GetWhereSQL(drCriteria))

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_EventLog", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", SqlDbType.Int, 4, "EventLogID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New QMS.dsEventLog
        _dtMainTable = _ds.Tables("EventLog")
        _sDeleteFilter = "EventLogID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_EventLog", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", SqlDbType.Int, 4, "EventLogID"))
        oCmd.Parameters("@EventLogID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", SqlDbType.Int, 4, "EventID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", SqlDbType.VarChar, 100, "EventParameters"))

        Return oCmd

    End Function

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_EventLog", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", SqlDbType.Int, 4, "EventLogID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventDate", SqlDbType.DateTime, 8, "EventDate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", SqlDbType.Int, 4, "EventID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", SqlDbType.VarChar, 100, "EventParameters"))

        Return oCmd

    End Function

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups - for now

    End Sub

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("EventLogID") = iEntityID

    End Sub
#End Region

    Public Function GetWhereSQL(ByVal drCriteria As DataRow) As String
        Dim sbSQLRespondents As New Text.StringBuilder("") 'query against respondents table
        Dim sbSQLEventLog As New Text.StringBuilder("") 'query against eventlog table
        Dim sbSQLProperties As New Text.StringBuilder("") 'query against respondent properties table
        Dim sbSQLSurveyInstance As New Text.StringBuilder("") 'querty against survey instance table
        Dim sbSQLStates As New Text.StringBuilder("") 'querty against state table
        Dim dh As DMI.DataHandler
        Dim dr As QMS.dsEventLog.SearchRow

        dr = CType(drCriteria, QMS.dsEventLog.SearchRow)

        '*** survey instance table
        'Survey instance start date criteria
        If Not dr.IsSurveyInstanceStartRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate >= '{0:d}' AND ", dr.SurveyInstanceStartRange)
        'Survey instance end date criteria
        If Not dr.IsSurveyInstanceEndRangeNull Then sbSQLSurveyInstance.AppendFormat("InstanceDate <= '{0:d}' AND ", dr.SurveyInstanceEndRange)
        'active criteria
        If Not dr.IsActiveNull Then sbSQLSurveyInstance.AppendFormat("Active = {0} AND ", dr.Active)
        If sbSQLSurveyInstance.Length > 0 Then
            'Survey id criteria
            If Not dr.IsSurveyIDNull Then sbSQLSurveyInstance.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
            'Client id criteria
            If Not dr.IsClientIDNull Then sbSQLSurveyInstance.AppendFormat("ClientID = {0} AND ", dr.ClientID)

        End If

        '*** respondent properties table
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

        '*** respondent table
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
        'DOB date range
        If Not dr.IsDOBStartRangeNull Then sbSQLRespondents.AppendFormat("DOB >= '{0:d}' AND ", dr.DOBStartRange)
        If Not dr.IsDOBEndRangeNull Then sbSQLRespondents.AppendFormat("DOB <= '{0:d}' AND ", dr.DOBEndRange)
        'Batch id list criteria
        If Not dr.IsBatchIDListNull Then sbSQLRespondents.AppendFormat("BatchID IN ({0}) AND ", dr.BatchIDList)
        'Exclude final code criteria
        If Not dr.IsExcludeFinalCodesNull Then sbSQLRespondents.Append("Final = 0 AND ")
        'If Not dr.IsExcludeFinalCodesNull Then
        '    If dr.ExcludeFinalCodes Then sbSQLRespondents.Append("RespondentID NOT IN (SELECT RespondentID FROM vr_RespondentEventLog WHERE Final = 1) AND ")
        'End If
        'File definition filter criteria
        If Not dr.IsFileDefFilterIDNull Then sbSQLRespondents.AppendFormat("({0}) AND ", clsFileDefs.GetFileDefFilter(_oConn, dr.FileDefFilterID))
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
        'Respondent properties table criteria
        If sbSQLProperties.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLProperties, 4)
            sbSQLRespondents.AppendFormat("EXISTS (SELECT 'x' FROM RespondentProperties WHERE (r.RespondentID = RespondentProperties.RespondentID) and ({0})) AND ", sbSQLProperties.ToString)
            'sbSQLRespondents.AppendFormat("RespondentID IN (SELECT RespondentID FROM RespondentProperties WHERE {0}) AND ", sbSQLProperties.ToString)
        End If
        'add respondent id if there is respondent table query
        If sbSQLRespondents.Length > 0 Then
            'Survey instance id criteria
            If Not dr.IsSurveyInstanceIDNull Then sbSQLRespondents.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
            'Survey id criteria
            If Not dr.IsSurveyIDNull Then sbSQLRespondents.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
            'Client id criteria
            If Not dr.IsClientIDNull Then sbSQLRespondents.AppendFormat("ClientID = {0} AND ", dr.ClientID)
            'respondent id criteria
            If Not dr.IsRespondentIDNull Then sbSQLRespondents.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)

        End If

        '*** event log table
        'primary key - event log id
        If Not dr.IsEventLogIDNull Then sbSQLEventLog.AppendFormat("EventLogID = {0} AND ", dr.RespondentID)
        'Event id criteria
        If Not dr.IsEventIDNull Then sbSQLEventLog.AppendFormat("EventID = {0} AND ", dr.EventID)
        'Event id list criteria
        If Not dr.IsEventIDListNull Then sbSQLEventLog.AppendFormat("EventID IN ({0}) AND ", dr.EventIDList)
        'Event id exclude list criteria
        If Not dr.IsExcludeEventIDListNull Then sbSQLEventLog.AppendFormat("EventID NOT IN ({0}) AND ", dr.ExcludeEventIDList)
        'Event log start date criteria
        If Not dr.IsEventStartRangeNull Then sbSQLEventLog.AppendFormat("EventDate >= '{0:d}' AND ", dr.EventStartRange)
        'Event log end date criteria
        If Not dr.IsEventEndRangeNull Then sbSQLEventLog.AppendFormat("EventDate <= '{0:d} 23:59:59' AND ", dr.EventEndRange)
        'Event type criteria
        If Not dr.IsEventTypeIDNull Then sbSQLEventLog.AppendFormat("EventID IN (SELECT EventID FROM Events WHERE EventTypeID = {0}) AND ", dr.EventTypeID)
        'User criteria
        If Not dr.IsUserIDNull Then sbSQLEventLog.AppendFormat("UserID = {0} AND ", dr.UserID)
        'respondent id criteria
        If Not dr.IsRespondentIDNull Then sbSQLEventLog.AppendFormat("RespondentID = {0} AND ", dr.RespondentID)
        'event parameters critiera
        If Not dr.IsEventParametersNull Then sbSQLEventLog.AppendFormat("EventParameters LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.EventParameters))
        'Survey instance id criteria
        If Not dr.IsSurveyInstanceIDNull Then sbSQLEventLog.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        'Survey id criteria
        If Not dr.IsSurveyIDNull Then sbSQLEventLog.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'Client id criteria
        If Not dr.IsClientIDNull Then sbSQLEventLog.AppendFormat("ClientID = {0} AND ", dr.ClientID)

        'Respondent table criteria
        If sbSQLRespondents.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLRespondents, 4)
            sbSQLEventLog.AppendFormat("RespondentID IN (SELECT RespondentID FROM Respondents r WHERE {0}) AND ", sbSQLRespondents.ToString)
        End If

        'Clean up criteria
        If sbSQLEventLog.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLEventLog, 4)
            sbSQLEventLog.Insert(0, "WHERE ")

        End If

        sbSQLStates = Nothing
        sbSQLRespondents = Nothing
        sbSQLProperties = Nothing
        sbSQLSurveyInstance = Nothing

        Return sbSQLEventLog.ToString

    End Function

    Public Sub InsertRow(ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal iRespondentID As Integer, ByVal sParam As String)
        Dim dr As DataRow = Me.NewMainRow()

        dr.Item("EventDate") = Date.Now
        dr.Item("EventID") = iEventID
        dr.Item("UserID") = iUserID
        dr.Item("RespondentID") = iRespondentID
        dr.Item("EventParameters") = sParam

        Me.AddMainRow(dr)

    End Sub

    Public Sub InsertRow(ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal iRespondentID As Integer)
        Dim dr As DataRow = Me.NewMainRow()

        dr.Item("EventID") = iEventID
        dr.Item("UserID") = iUserID
        dr.Item("RespondentID") = iRespondentID
        dr.Item("EventDate") = Now()

        Me.AddMainRow(dr)

    End Sub

    Public Sub InsertRow(ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal sParam As String)
        Dim dr As DataRow = Me.NewMainRow()

        dr.Item("EventID") = iEventID
        dr.Item("UserID") = iUserID
        dr.Item("EventParameters") = sParam
        dr.Item("EventDate") = Now()

        Me.AddMainRow(dr)

    End Sub

    Public Sub InsertRow(ByVal iEventID As Integer, ByVal iUserID As Integer)
        Dim dr As DataRow = Me.NewMainRow()

        dr.Item("EventID") = iEventID
        dr.Item("UserID") = iUserID
        dr.Item("EventDate") = Now()

        Me.AddMainRow(dr)

    End Sub

    Public Shared Sub InsertRow(ByVal Connection As SqlClient.SqlConnection, ByVal EventID As Integer, ByVal UserID As Integer, ByVal Parameters As String)
        'TP Change        
        Using conn As New SqlClient.SqlConnection(Connection.ConnectionString)
            conn.Open()
            Using cmd As New SqlClient.SqlCommand()
                cmd.Connection = conn
                cmd.CommandText = "insert_EventLog"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", DBNull.Value))
                cmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", EventID))
                cmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", UserID))
                cmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", DBNull.Value))
                cmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", Parameters))
                cmd.ExecuteNonQuery()
            End Using
        End Using

    End Sub


    Public Shared Sub InsertRow(ByVal Connection As SqlClient.SqlConnection, ByVal EventID As Integer, ByVal UserID As Integer, ByVal RespondentID As Integer, ByVal Parameters As String)
        ''TP Change
        'Dim cmd As DbCommand = SqlHelper.Db(Connection.ConnectionString).GetStoredProcCommand("insert_EventLog")
        'cmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", DBNull.Value))
        'cmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", EventID))
        'cmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", UserID))
        'cmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", RespondentID))
        'cmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", Parameters))
        'SqlHelper.Db(Connection.ConnectionString).ExecuteNonQuery(cmd)

        ''SqlHelper.ExecuteNonQuery(Connection, CommandType.StoredProcedure, "insert_EventLog", _
        ''    New SqlClient.SqlParameter("@EventLogID", DBNull.Value), _
        ''    New SqlClient.SqlParameter("@EventID", EventID), _
        ''    New SqlClient.SqlParameter("@UserID", UserID), _
        ''    New SqlClient.SqlParameter("@RespondentID", RespondentID), _
        ''    New SqlClient.SqlParameter("@EventParameters", Parameters))
        Using conn As New SqlClient.SqlConnection(Connection.ConnectionString)
            conn.Open()
            Using cmd As New SqlClient.SqlCommand()
                cmd.Connection = conn
                cmd.CommandText = "insert_EventLog"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", DBNull.Value))
                cmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", EventID))
                cmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", UserID))
                cmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", RespondentID))
                cmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", Parameters))
                cmd.ExecuteNonQuery()
            End Using
        End Using

    End Sub

    Public Shared Sub InsertRow(ByVal transaction As SqlClient.SqlTransaction, ByVal EventID As Integer, ByVal UserID As Integer, ByVal RespondentID As Integer, ByVal Parameters As String)
        'TP Change
        'Dim cmd As DbCommand = SqlHelper.Db(transaction.Connection.ConnectionString).GetStoredProcCommand("insert_EventLog")
        Dim cmd As New SqlClient.SqlCommand()
        cmd.Connection = transaction.Connection
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "insert_EventLog"
        cmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", DBNull.Value))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", EventID))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", UserID))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", RespondentID))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", Parameters))
        cmd.Transaction = transaction
        cmd.ExecuteNonQuery()
        'SqlHelper.Db(transaction.Connection.ConnectionString).ExecuteNonQuery(cmd)

        'SqlHelper.ExecuteNonQuery(transaction, CommandType.StoredProcedure, "insert_EventLog", _
        '    New SqlClient.SqlParameter("@EventLogID", DBNull.Value), _
        '    New SqlClient.SqlParameter("@EventID", EventID), _
        '    New SqlClient.SqlParameter("@UserID", UserID), _
        '    New SqlClient.SqlParameter("@RespondentID", RespondentID), _
        '    New SqlClient.SqlParameter("@EventParameters", Parameters))

    End Sub

    Public Sub BulkInsert(ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal sSQLRespondentsWhere As String)
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("INSERT INTO EventLog(EventID, UserID, RespondentID, EventDate) ")
        sbSQL.AppendFormat("SELECT {0}, {1}, RespondentID, GETDATE() ", iEventID, iUserID)
        sbSQL.Append("FROM vw_Respondents ")
        sbSQL.Append(sSQLRespondentsWhere)
        'TP Change
        SqlHelper.Db(_oConn.ConnectionString).ExecuteNonQuery(CommandType.Text, sbSQL.ToString())
        'SqlHelper.ExecuteNonQuery(_oConn, CommandType.Text, sbSQL.ToString)

    End Sub

    Public Sub DeleteAll(ByVal drCriteria As DataRow)
        Dim oThd As Threading.Thread
        Dim dr As DataRow

        _ds.EnforceConstraints = False
        Me.FillMain(drCriteria)

        For Each dr In Me.MainDataTable.Rows
            dr.Delete()
        Next

        oThd = New Threading.Thread(AddressOf _SaveChanges)
        oThd.Start()

        'Dim sbSQL As New Text.StringBuilder()
        'Dim sWhereSQL As String

        ''update survey instance for search
        'sWhereSQL = GetWhereSQL(drCriteria)

        ''check that there are search criteria as a safe guard
        'If sWhereSQL.Length > 0 Then
        '    'delete respondents
        '    sbSQL.Remove(0, sbSQL.Length)
        '    sbSQL.AppendFormat("DELETE EventLog {0}", sWhereSQL)
        '    SqlHelper.ExecuteNonQuery(Me._oConn, CommandType.Text, sbSQL.ToString)

        'Else
        '    Me._sErrorMsg &= "Cannot delete logged events without criteria.\n"

        'End If

        'sbSQL = Nothing

    End Sub

    Private Sub _SaveChanges()
        Me.Save()

        'clean up
        _oConn.Close()
        _oConn = Nothing
        Close()

    End Sub


    Public Shared Sub OverrideSurveyAudit(ByVal connection As SqlClient.SqlConnection, ByVal eventLogID As Integer, ByVal userID As Integer)
        Dim sql As String
        sql = String.Format("UPDATE EventLog SET EventID = 3060, UserID = {1}, EventDate = GETDATE() WHERE EventID IN (3040, 3041, 3042) AND EventLogID = {0}", eventLogID, userID)
        'TP Change
        SqlHelper.Db(connection.ConnectionString).ExecuteNonQuery(CommandType.Text, sql)
        'SqlHelper.ExecuteNonQuery(connection, CommandType.Text, sql)
    End Sub

End Class
