<Obsolete("use QMS.qmsEvents")> _
Public Enum qmsEventCodes
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
    REMINDER_START = 2040
    REMINDER_END = 2041
    RESPONDENT_MOVED = 2061
    RESPONDENT_SELECTED_CALLLIST = 2200
    RESPONDENT_SELECTED_DATAENTRY = 2201
    RESPONDENT_SELECTED_VERIFICATION = 2202
    RESPONDENT_SELECTED_CATICALL = 2203
    RESPONDENT_SELECTED_REMINDERCALL = 2204
    RESPONDENT_SELECTED_VIEWING = 2205
    DE_INCOMPLETE_SURVEY = 3000
    DE_COMPLETE_SURVEY = 3002
    VERIFY_INCOMPLETE_SURVEY = 3010
    VERIFY_COMPLETE_SURVEY = 3012
    CATI_INCOMPLETE_SURVEY = 3020
    CATI_COMPLETE_SURVEY = 3022
    REMINDER_INCOMPLETE_SURVEY = 3030
    REMINDER_COMPLETE_SURVEY = 3032
    MAILING_SURVEY = 4000
    BATCHED_RESPONDENT_NOT = -2006
    MAILING_SURVEY_1ST = -40001
    MAILING_SURVEY_2ND = -40002

End Enum

Public Enum tblEvents
    EventID = 0
    Name = 1
    Description = 2
    EventTypeID = 3
    FinalCode = 4
    DefaultNonContact = 5

End Enum

<Obsolete("use QMS.qmsEvents")> _
Public Class clsEvent
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal uField As tblEvents) As Object
        Get
            Return MyBase.Details(uField.ToString)

        End Get

        Set(ByVal Value As Object)
            If uField = tblEvents.EventID Then
                Me._iEntityID = Value

            End If

            MyBase.Details(uField.ToString) = Value

        End Set

    End Property

    Public Property PreviousEventID() As Integer
        Get
            Return Me._iEntityID

        End Get
        Set(ByVal Value As Integer)
            Me._iEntityID = Value

        End Set
    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "Events"

        'INSERT SQL for Users table
        Me._sInsertSQL = "INSERT INTO Events(EventID, Name, Description, EventTypeID, FinalCode, DefaultNonContact) "
        Me._sInsertSQL &= "VALUES({0}, {1}, {2}, {3}, {4}, {5}) "

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE Events SET Name = {1}, Description = {2}, EventTypeID = {3}, FinalCode = {4}, DefaultNonContact = {5} "
        Me._sUpdateSQL &= "WHERE EventID = {0} "

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM Events WHERE EventID = {0}"

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT e.EventID, e.Name, e.Description, e.EventTypeID, e.FinalCode, e.DefaultNonContact, et.Name AS EventTypeName "
        Me._sSelectSQL &= "FROM Events e INNER JOIN EventTypes et ON e.EventTypeID = et.EventTypeID "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("e.EventID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Me.Details(tblEvents.Name).ToString.Length > 0 Then
                sWHERESQL &= String.Format("e.Name LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblEvents.Name)))

            End If

            If Me.Details(tblEvents.Description).ToString.Length > 0 Then
                sWHERESQL &= String.Format("e.Description LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblEvents.Description)))

            End If

            If Me.Details(tblEvents.EventTypeID).ToString.Length > 0 Then
                sWHERESQL &= String.Format("e.EventTypeID = {0} AND ", Details(tblEvents.EventTypeID))

            End If

            If Me.Details(tblEvents.FinalCode).ToString.Length > 0 Then
                sWHERESQL &= String.Format("e.FinalCode = {0} AND ", Details(tblEvents.FinalCode))

            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        sSQL = String.Format(sSQL, Details(tblEvents.EventID), _
                            DMI.DataHandler.QuoteString(Details(tblEvents.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblEvents.Description)), _
                            Details(tblEvents.EventTypeID), _
                            Details(tblEvents.FinalCode), _
                            Details(tblEvents.DefaultNonContact))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblEvents.EventID), _
                            DMI.DataHandler.QuoteString(Details(tblEvents.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblEvents.Description)), _
                            Details(tblEvents.EventTypeID), _
                            Details(tblEvents.FinalCode), _
                            Details(tblEvents.DefaultNonContact))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblEvents.EventID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        dr.Item("EventID") = 0
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("EventTypeID") = 1
        dr.Item("FinalCode") = 0
        dr.Item("DefaultNonContact") = 0

    End Sub

    Public Sub AddEvent()
        Dim dr As DataRow

        dr = Me._dsEntity.Tables("Events").NewRow
        Me.SetRecordDefaults(dr)

        Me._dsEntity.Tables("Events").Rows.Add(dr)

    End Sub

    Protected Overrides Function VerifyDelete() As String
        Dim sSQL As String

        sSQL = String.Format("SELECT UserCreated FROM Events WHERE EventID = {0}", Me._iEntityID)

        If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
            Return ""
        End If

        Return String.Format("Cannot delete event id {0}. Event is not a user created event.\n", Me._iEntityID)

    End Function

    Public Function GetEventTypes() As DataTable
        Dim sSQL As String
        Dim ds As DataSet

        sSQL = "SELECT EventTypeID, Name FROM EventTypes ORDER BY EventTypeID "

        If DMI.DataHandler.GetDS(Me.ConnectionString, ds, sSQL, "EventTypes") Then

            Return ds.Tables("EventTypes")

        End If

    End Function

    Protected Overrides Function VerifyInsert() As String
        Dim sSQL As String

        If Me._iEntityID = 0 Then
            sSQL = String.Format("SELECT COUNT(EventID) FROM Events WHERE EventID = {0}", Me.Details(tblEvents.EventID))

            If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
                Return String.Format("Event id {0} already exists. Please choose a different id.", Me.Details(tblEvents.EventID))

            End If

        End If

        Return ""

    End Function

    Public Shared Function GetOutcomeEvents(ByVal iInputmode As QMS.qmsInputMode, ByVal iRespondentID As Integer) As SqlClient.SqlDataReader
        Dim sbSQL As New StringBuilder()
        Dim sEventTypeID As String

        Select Case iInputmode
            Case QMS.qmsInputMode.DATAENTRY, QMS.qmsInputMode.VERIFY
                sEventTypeID = "4"

            Case QMS.qmsInputMode.CATI
                sEventTypeID = "5"

            Case QMS.qmsInputMode.RCALL
                sEventTypeID = "5"

            Case Else
                sEventTypeID = "4,5"

        End Select

        sbSQL.Append("SELECT EventID, EventName FROM v_SurveyInstanceEvents ")
        sbSQL.Append("WHERE SurveyInstanceID = (SELECT SurveyInstanceID FROM Respondents ")
        sbSQL.AppendFormat("WHERE RespondentID = {0}) AND EventTypeID IN ({1}) AND UseEvent > 0 ORDER BY EventName ", iRespondentID, sEventTypeID)

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sbSQL.ToString)

    End Function

End Class
