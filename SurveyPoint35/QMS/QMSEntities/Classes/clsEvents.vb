Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Enum qmsEvents As Integer
    NONE = 0
    USER_LOGON = 1000
    USER_LOGOFF = 1001
    USER_TIMEOUT = 1002
    RESPONDENT_IMPORTED = 2000
    RESPONDENT_UPDATED_ADDRESS = 2001
    RESPONDENT_UPDATED_TELEPHONE = 2002
    RESPONDENT_UPDATED_DEMOGRAPHIC = 2003
    RESPONDENT_UPDATED_NAME = 2004
    RESPONDENT_UPDATED_ID = 2005
    RESPONDENT_UPDATED_EMAIL = 2007
    RESPONDENT_UPDATED_IMPORT = 2008
    RESPONDENT_EXPORTED = 2060
    BATCH_RESPONDENT = 2006
    BATCHED_ATTEMPT = 2009
    RETURN_DATE = 2209
    RESPONDENT_NOTE = 2299
    CALLBACK_NOAPPOINTMENT = 5009
    CALLBACK_APPOINTMENT_SCHEDULED = 5010
    VERIFY_CORRECT_OLD = 2050
    VERIFY_CORRECT_NEW = 2051
    VERIFY_RESELECT = 2052
    DE_START = 2010
    DE_END = 2011
    VERIFY_START = 2020
    VERIFY_END = 2021
    CATI_START = 2030
    CATI_END = 2031
    INCOMING_START = 2032
    INCOMING_END = 2033
    REMINDER_START = 2040
    REMINDER_END = 2041
    WEB_START = 2042
    WEB_END = 2043
    REMOTE_START = 2044
    REMOTE_END = 2045
    KEYSTROKE_STATISTIC = 2059
    RESPONDENT_MOVED = 2061
    RESPONDENT_MAX_CALL_REACHED = 2063
    BAD_ADDRESS = 2064
    BAD_TELEPHONE = 2065
    BAD_EMAIL_ADDRESS = 2066
    SENT_EMAIL_INVITE = 2067
    RESPONDENT_SELECTED_CALLLIST = 2200
    RESPONDENT_SELECTED_DATAENTRY = 2201
    RESPONDENT_SELECTED_VERIFICATION = 2202
    RESPONDENT_SELECTED_CATICALL = 2203
    RESPONDENT_SELECTED_REMINDERCALL = 2204
    RESPONDENT_SELECTED_VIEWING = 2205
    RESPONDENT_SELECTED_WEB = 2206
    RESPONDENT_SELECTED_REMOTE = 2207
    RESPONDENT_SELECTED_INCOMING = 2208
    RESPONDENT_SUBMITTED_TO_CLIENT = 2401
    IMPORT_ERROR = 2300
    IMPORT_COMPLETED = 2301
    EXPORT_ERROR = 2302
    EXPORT_COMPLETED = 2303
    EXPORT_INPROGRESS = 2304
    DE_INCOMPLETE_SURVEY = 3000
    DE_PARTIAL_COMPLETE_SURVEY = 3001
    DE_COMPLETE_SURVEY = 3002
    VERIFY_INCOMPLETE_SURVEY = 3010
    VERIFY_PARTIAL_COMPLETE_SURVEY = 3011
    VERIFY_COMPLETE_SURVEY = 3012
    CATI_INCOMPLETE_SURVEY = 3020
    CATI_PARTIAL_COMPLETE_SURVEY = 3021
    CATI_COMPLETE_SURVEY = 3022
    REMINDER_INCOMPLETE_SURVEY = 3030
    REMINDER_PARTIAL_COMPLETE_SURVEY = 3031
    REMINDER_COMPLETE_SURVEY = 3032
    INCOMING_INCOMPLETE_SURVEY = 3033
    INCOMING_PARTIAL_COMPLETE_SURVEY = 3034
    INCOMING_COMPLETE_SURVEY = 3035
    WEB_INCOMPLETE_SURVEY = 3036
    WEB_COMPLETE_SURVEY = 3038
    REMOTE_INCOMPLETE_SURVEY = 3050
    REMOTE_COMPLETE_SURVEY = 3052
    OVERRIDE_SURVEY_AUDIT = 3060
    MAILING_SURVEY = 4000
    FINAL_CODE = -30000
    BATCHED_RESPONDENT_NOT = -2006
    MAILING_SURVEY_1ST = -40001
    MAILING_SURVEY_2ND = -40002
End Enum

Public Class clsEvents
    Inherits DMI.clsDBEntity2

    Private _iEventTypeID As Integer

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
        Dim dr As QMS.dsEvents.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsEvents.SearchRow)

        If Not dr.IsEventIDNull Then
            'Primary key criteria
            sbSQL.AppendFormat("EventID = {0} AND ", dr.EventID)

        Else
            'keyword criteria
            If Not dr.IsKeywordNull Then sbSQL.AppendFormat("Name + Description LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))
            'event type criteria
            If Not dr.IsEventTypeIDNull Then sbSQL.AppendFormat("EventTypeID = {0} AND ", dr.EventTypeID)
            'final code criteria
            If Not dr.IsFinalCodeNull Then sbSQL.AppendFormat("FinalCode = {0} AND ", dr.FinalCode)
            'user created flag criteria
            If Not dr.IsUserCreatedNull Then sbSQL.AppendFormat("UserCreated = {0} AND ", dr.UserCreated)

        End If

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM vw_Events ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Events", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", SqlDbType.Int, 4, "EventID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsEvents
        _dtMainTable = _ds.Tables("tblEvents")
        _sDeleteFilter = "EventID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Events", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", SqlDbType.Int, 4, "EventID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 500, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventTypeID", SqlDbType.Int, 4, "EventTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FinalCode", SqlDbType.TinyInt, 1, "FinalCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserCreated", SqlDbType.TinyInt, 1, "UserCreated"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DefaultNonContact", SqlDbType.Int, 4, "DefaultNonContact"))
        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("EventID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Events", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", SqlDbType.Int, 4, "EventID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 500, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventTypeID", SqlDbType.Int, 4, "EventTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FinalCode", SqlDbType.TinyInt, 1, "FinalCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserCreated", SqlDbType.TinyInt, 1, "UserCreated"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DefaultNonContact", SqlDbType.Int, 4, "DefaultNonContact"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        'TP Change
        dr.Item("EventID") = CInt(SqlHelper.Db(Me._oConn.ConnectionString).ExecuteScalar(CommandType.Text, "SELECT MAX(EventID) + 1 FROM Events"))
        'dr.Item("EventID") = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, "SELECT MAX(EventID) + 1 FROM Events"))
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("EventTypeID") = 5
        dr.Item("FinalCode") = 0
        dr.Item("UserCreated") = 1
        dr.Item("DefaultNonContact") = 0

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim bVerify As Boolean = True

        If EventCodeInUse(CInt(dr.Item("EventID", DataRowVersion.Original))) Then
            bVerify = False
            Me._sErrorMsg &= String.Format("Cannot delete event id {0}. Event is used in event log.\n", dr.Item("EventID", DataRowVersion.Original))

        End If

        If dr.Item("UserCreated", DataRowVersion.Original) = 0 Then
            bVerify = False
            Me._sErrorMsg &= String.Format("Cannot delete event id {0}. Event is not user created.\n", dr.Item("EventID", DataRowVersion.Original))

        End If

        Return bVerify

    End Function

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean

        If EventCodeExists(dr) Then
            'event already in use
            Me._sErrorMsg &= String.Format("Event id {0} already exists. Please change id number.\n", dr.Item("EventID"))
            Return False

        End If

        Return True

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Dim bVerify As Boolean = True

        'check for change in event id
        If dr.Item("EventID", DataRowVersion.Current) <> dr.Item("EventID", DataRowVersion.Original) Then
            Me._sErrorMsg &= String.Format("Cannot change event id {0}. Event is not user created.\n", dr.Item("EventID", DataRowVersion.Original))
            bVerify = False

        ElseIf CInt(dr.Item("UserCreated")) = 0 Then
            If dr.Item("EventTypeID", DataRowVersion.Current) <> dr.Item("EventTypeID", DataRowVersion.Original) Then
                Me._sErrorMsg &= "Cannot change event type for non-user created event.\n"
                bVerify = False

            End If
            'Else
            '    'can not change non-user created events
            '    If CInt(dr.Item("UserCreated")) = 1 Then
            '        'does new code already exist
            '        If EventCodeExists(dr) Then
            '            'event already in use
            '            Me._sErrorMsg &= String.Format("Event id {0} already exists. Please change id number.\n", dr.Item("EventID"))
            '            bVerify = False

            '        End If

            '        'is old event code in use
            '        If EventCodeInUse(CInt(dr.Item("EventID", DataRowVersion.Original))) Then
            '            'event already in use
            '            Me._sErrorMsg &= String.Format("Cannot change event id {0}. Event is used in event log.\n", dr.Item("EventID", DataRowVersion.Original))
            '            bVerify = False

            '        End If

            '    End If

        End If

        Return bVerify

    End Function

#End Region

    Private Function EventCodeInUse(ByVal iEventID As Integer) As Boolean
        Dim sSQL As String
        Dim iCount As Integer

        sSQL = String.Format("SELECT COUNT(EventLogID) FROM EventLog WHERE EventID = {0}", iEventID)
        'TP Change
        iCount = CInt(SqlHelper.Db(Me._oConn.ConnectionString).ExecuteScalar(CommandType.Text, sSQL))
        'iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sSQL))

        If iCount > 0 Then Return True

        Return False

    End Function

    Private Function EventCodeExists(ByVal dr As DataRow) As Boolean
        Dim sSQL As String

        sSQL = String.Format("SELECT COUNT(EventID) FROM Events WHERE EventID = {0}", dr.Item("EventID"))
        'TP Change
        If CInt(SqlHelper.Db(_oConn.ConnectionString).ExecuteScalar(CommandType.Text, sSQL)) > 0 Then
            Return True
        End If
        'If CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL)) > 0 Then
        '    Return True

        'End If

        Return False

    End Function

#Region "Event Type Lookup"
    Public ReadOnly Property EventTypesTable() As DataTable
        Get
            Return _ds.Tables("EventTypes")

        End Get
    End Property

    Public Sub FillEventTypes()
        Dim da As New SqlClient.SqlDataAdapter("SELECT * FROM EventTypes", _oConn)

        da.Fill(EventTypesTable)
        da.Dispose()
        da = Nothing

    End Sub

    Public Shared Function IsCallEvent(ByVal oConn As SqlClient.SqlConnection, ByVal iEventID As Integer) As Boolean
        Dim iCalls As Integer
        'TP Change
        iCalls = CInt(SqlHelper.Db(oConn.ConnectionString).ExecuteScalar(CommandType.Text, String.Format("SELECT COUNT(EventID) FROM Events WHERE EventID = {0} AND EventTypeID = 5", iEventID)))
        'iCalls = CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, String.Format("SELECT COUNT(EventID) FROM Events WHERE EventID = {0} AND EventTypeID = 5", iEventID)))
        If iCalls > 0 Then Return True
        Return False

    End Function

#End Region

    Public Shared Function GetEventTypesDataSource(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, "SELECT EventTypeID, Name FROM EventTypes ORDER BY Name"), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
        '    "SELECT EventTypeID, Name FROM EventTypes ORDER BY Name")

    End Function

    Public Shared Function GetEventDataSource(ByVal oConn As SqlClient.SqlConnection, ByVal sEventTypeIDs As String) As SqlClient.SqlDataReader
        Dim sSQL As New System.Text.StringBuilder

        sSQL.Append("SELECT e.EventID, CAST(e.EventID AS varchar(10)) + ' ' + et.Name + ': ' + e.Name AS Name FROM Events e INNER JOIN EventTypes et ON e.EventTypeID = et.EventTypeID ")
        If sEventTypeIDs.Length > 0 Then sSQL.AppendFormat("WHERE e.EventTypeID IN ({0}) ", sEventTypeIDs)
        sSQL.Append("ORDER BY e.EventID")
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, sSQL.ToString), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, sSQL.ToString)

    End Function

    Public Shared Function GetSurveyInstanceEventDataSource(ByVal oConn As SqlClient.SqlConnection, ByVal iSurveyInstanceID As Integer, ByVal sEventTypeIDs As String) As SqlClient.SqlDataReader
        Dim sSQL As New System.Text.StringBuilder

        sSQL.Append("SELECT e.EventID, CAST(e.EventID AS varchar(10)) + ' ' + et.Name + ': ' + e.Name AS Name ")
        sSQL.Append("FROM Events e INNER JOIN EventTypes et ON e.EventTypeID = et.EventTypeID ")
        sSQL.Append("INNER JOIN SurveyInstanceEvents sie ON e.EventID = sie.EventID ")
        sSQL.AppendFormat("WHERE sie.SurveyInstanceID = {0} ", iSurveyInstanceID)
        If sEventTypeIDs.Length > 0 Then sSQL.AppendFormat("AND e.EventTypeID IN ({0}) ", sEventTypeIDs)
        sSQL.Append("ORDER BY e.EventID")
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, sSQL.ToString), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, sSQL.ToString)

    End Function

End Class
