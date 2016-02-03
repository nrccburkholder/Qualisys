Option Explicit On 
Option Strict On

Imports System.Web.SessionState

<Obsolete("use QMS.clsQMSTools")> _
Public Class clsQMSTools

    <Obsolete("use QMS.clsQMSTools", True)> _
        Public Shared Function GetSurveyDataSource(Optional ByVal bActive As Boolean = False) As SqlClient.SqlDataReader
        Dim sSQL As String

        If bActive Then
            sSQL = "SELECT SurveyID, Name FROM Surveys WHERE Active = 1 ORDER BY Name"
        Else
            sSQL = "SELECT SurveyID, Name FROM Surveys ORDER BY Name"
        End If

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Public Shared Function GetClientDataSource(Optional ByVal bActive As Boolean = False) As SqlClient.SqlDataReader
        Dim sSQL As String

        If bActive Then
            sSQL = "SELECT ClientID, Name FROM Clients WHERE Active = 1 ORDER BY Name"
        Else
            sSQL = "SELECT ClientID, Name FROM Clients ORDER BY Name"
        End If

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Public Shared Function GetSurveyInstanceDataSource(Optional ByVal bActive As Boolean = False, Optional ByVal iSurveyID As Integer = 0, Optional ByVal iClientID As Integer = 0) As SqlClient.SqlDataReader
        Dim sSQL As New StringBuilder()

        'build survey instance criteria
        If bActive Then sSQL.Append("Active = 1 AND ")
        If iSurveyID > 0 Then sSQL.AppendFormat("SurveyID = {0} AND ", iSurveyID)
        If iClientID > 0 Then sSQL.AppendFormat("ClientID = {0} AND ", iClientID)

        'build select query
        If sSQL.Length > 0 Then
            DMI.clsUtil.Chop(sSQL, 4)
            sSQL.Insert(0, "WHERE ")
        End If
        sSQL.Insert(0, "SELECT SurveyInstanceID, SurveyName + ' : ' + ClientName + ' : ' + SurveyInstanceName AS Name FROM v_SurveyInstances ")
        sSQL.Append("ORDER BY SurveyName, ClientName, SurveyInstanceName")

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL.ToString)

    End Function

    Public Shared Function GetEventDataSource(Optional ByVal sEventTypeIDs As String = "") As SqlClient.SqlDataReader
        Dim sSQL As New StringBuilder()

        sSQL.Append("SELECT EventID, CAST(EventID As varchar(10)) + ' ' + Name AS Name FROM Events ")
        If sEventTypeIDs.Length > 0 Then sSQL.AppendFormat("WHERE EventTypeID IN ({0}) ", sEventTypeIDs)
        sSQL.Append("ORDER BY EventID")

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL.ToString)

    End Function

    Public Shared Function GetEventTypesDataSource() As SqlClient.SqlDataReader
        Dim sSQL As String = "SELECT EventTypeID, Name FROM EventTypes ORDER BY Name"

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Public Shared Function GetUsersDataSource(Optional ByVal bActive As Boolean = False) As SqlClient.SqlDataReader
        Dim sSQL As String

        If bActive Then
            sSQL = "SELECT UserID, Username FROM Users WHERE Active = 1 ORDER BY Username"
        Else
            sSQL = "SELECT UserID, Username FROM Users ORDER BY Username"
        End If

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Public Shared Function GetUserGroupsDataSource() As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = "SELECT GroupID, Name FROM UserGroups ORDER BY Name"

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Public Shared Function GetFileDefFilterDataSource() As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = "SELECT FileDefFilterID, FilterName FROM FileDefFilters ORDER BY FilterName"

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Shared Function NonPrivAccess(ByRef r As HttpRequest, ByRef s As HttpSessionState) As String

        If IsNothing(s.Item("Privledges")) Then
            Return "../login.aspx?signout=1"

        Else
            Return DMI.WebFormTools.ReflectURL(r)

        End If

    End Function

    Public Shared Sub SetStateListControl(ByRef lc As ListControl, ByVal cs As String)
        Dim sSQL As String = "SELECT State, StateName FROM States ORDER BY State"

        lc.DataSource = DMI.SqlHelper.ExecuteReader(cs, CommandType.Text, sSQL)
        lc.DataValueField = "State"
        lc.DataTextField = "StateName"
        lc.DataBind()

    End Sub

    Public Shared Function GetEventName(ByVal iEventID As Integer) As String
        Dim sSQL As String = String.Format("SELECT Name FROM Events WHERE EventID = {0}", iEventID)

        If iEventID > 0 Then
            Return DMI.SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, CommandType.Text, sSQL).ToString

        Else
            Return "None"

        End If

    End Function

    Public Shared Function GetFileDefFilterName(ByVal iFileDefFilterID As Integer) As String
        Dim sSQL As String = String.Format("SELECT FilterName FROM FileDefFilters WHERE FileDefFilterID = {0}", iFileDefFilterID)

        If iFileDefFilterID > 0 Then
            Return DMI.SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, CommandType.Text, sSQL).ToString

        Else
            Return "None"

        End If

    End Function

    Public Shared Function GetSurveyInstanceProtocolSteps(ByVal iProtocolStepTypeID As Integer) As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = String.Format("SELECT CAST(SurveyInstanceID AS varchar) + ',' + CAST(ProtocolStepID AS varchar) AS RowID, CONVERT(varchar(10), StartDate, 1) + ' ' + SurveyName + ' : ' + ClientName + ' : ' + InstanceName + ' : ' + ProtocolStepName + ' (' + CAST(RespondentCount AS varchar) + ')' AS Name FROM v_SurveyInstanceProtocolSteps WHERE Cleared = 0 AND ProtocolStepTypeID = {0} ORDER BY SurveyName, ClientName, InstanceName, StartDate", iProtocolStepTypeID)

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

End Class
