Option Explicit On
Option Strict On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsWebInterviewer
    Public Const RESPONDENT_KEY As String = "RESPONDENT_KEY"

    Public Shared Function GetWebInterviewUserID(ByVal connection As SqlClient.SqlConnection, ByVal url As String) As Integer
        Dim userID As Integer = QMS.clsUsers.GetUserID(connection, url)
        If userID = DMI.Null.NullInteger Then
            Dim password As String = System.Guid.NewGuid().ToString
            Dim groupID As Integer = GetWebInterviewUserGroupID(connection)
            userID = QMS.clsUsers.InsertUser(connection, url, password, "Web", "Interviewer", "", groupID, 0)
        End If
        Return userID
    End Function

    Public Shared Function GetWebInterviewUserGroupID(ByVal connection As SqlClient.SqlConnection) As Integer
        Dim groupID As Integer
        groupID = QMS.clsUserGroups.GetUserGroupID(connection, "Web Interviewer")
        If groupID = DMI.Null.NullInteger Then groupID = QMS.clsUserGroups.InsertUserGroup(connection, "Web Interviewer", "Web Interviewer Dummy Users")
        Return groupID

    End Function

    Public Shared Function GetRespondentIDFromKey(ByVal connection As SqlClient.SqlConnection, ByVal respondentKey As String) As Integer
        Dim sql As New Text.StringBuilder
        Dim result As Object
        sql.AppendFormat("SELECT RespondentID FROM RespondentProperties WHERE PropertyName = '{0}' AND PropertyValue = '{1}'", RESPONDENT_KEY, respondentKey.Replace("'", "''"))
        'TP Change
        result = SqlHelper.Db(connection.ConnectionString).ExecuteScalar(CommandType.Text, sql.ToString())
        'result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql.ToString)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return DMI.DataHandler.NULLRECORDID
    End Function

    Public Shared Function GetSurveyInstanceIDFromKey(ByVal connection As SqlClient.SqlConnection, ByVal surveyInstanceKey As String) As Integer
        'TO DO: write code to get survey instance id from key
        Return DMI.DataHandler.NULLRECORDID
    End Function

    Public Shared Function GetSurveyInstanceKey(ByVal connection As SqlClient.SqlConnection, ByVal surveyInstanceID As Integer) As String

    End Function

    Public Shared Function GetWebInterviewScriptID(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As Integer
        Dim surveyInstanceID As Integer = clsRespondents.GetSurveyInstanceID(connection, respondentID)
        Dim scriptID As Integer = clsScripts.GetDefaultScript(connection, surveyInstanceID, qmsScriptType.Web)
        Return scriptID
    End Function

End Class

Public Class OpenSurveyRequirements
    Public Sub New(ByVal surveyInstanceID As Integer)
        Me.SurveyInstanceID = surveyInstanceID
    End Sub
    Private Sub GetSurveyInstanceRequirements(ByVal surveyInstanceID As Integer)
        Dim connection As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        Try
            Dim sql As New Text.StringBuilder
            Dim dr As SqlClient.SqlDataReader
            sql.Append("SELECT pstp.ProtocolStepParamDesc, psp.ProtocolStepTypeParamID, psp.ProtocolStepParamValue ")
            sql.Append("FROM ProtocolStepTypes pst INNER JOIN ProtocolStepTypeParameters pstp ON pst.ProtocolStepTypeID = pstp.ProtocolStepTypeID INNER JOIN ProtocolStepParameters psp ON pstp.ProtocolStepTypeParamID = psp.ProtocolStepTypeParamID INNER JOIN ProtocolSteps ps ON pst.ProtocolStepTypeID = ps.ProtocolStepTypeID AND psp.ProtocolStepID = ps.ProtocolStepID INNER JOIN SurveyInstances si ON ps.ProtocolID = si.ProtocolID ")            

            sql.AppendFormat("WHERE (pst.ProtocolStepTypeID = 12) AND (si.SurveyInstanceID = {0})", surveyInstanceID)
            'TP Change
            dr = DirectCast(SqlHelper.Db(connection.ConnectionString).ExecuteReader(CommandType.Text, sql.ToString()), SqlClient.SqlDataReader)
            'dr = SqlHelper.ExecuteReader(connection, CommandType.Text, sql.ToString)
            While dr.Read
                Dim required As Boolean = CBool(CInt(dr.Item("ProtocolStepParamValue")) = 1)
                Select Case Trim(dr.Item("ProtocolStepParamDesc").ToString)
                    Case "Require First Name"
                        Me.RequireFirstName = required
                    Case "Require Address1"
                        Me.RequireAddress1 = required
                    Case "Require City"
                        Me.RequireCity = required
                    Case "Require State"
                        Me.RequireState = required
                    Case "Require Zip"
                        Me.RequireZipCode = required
                    Case "Require Telephone"
                        Me.RequireTelephone = required
                    Case "Require Email"
                        Me.RequireEmail = required
                    Case "Require Gender"
                        Me.RequireGender = required
                    Case "Require DOB"
                        Me.RequireDOB = required
                End Select
            End While

        Finally
            connection.Dispose()
        End Try

    End Sub
    Public Const RequireLastName As Boolean = True
    Public RequireFirstName As Boolean = True
    Public RequireEmail As Boolean = True
    Public RequireAddress1 As Boolean = True
    Public RequireCity As Boolean = True
    Public RequireState As Boolean = True
    Public RequireZipCode As Boolean = True
    Public RequireTelephone As Boolean = True
    Public RequireGender As Boolean = True
    Public RequireDOB As Boolean = True
    Private _SurveyInstanceID As Integer
    Public Property SurveyInstanceID() As Integer
        Get
            Return _SurveyInstanceID
        End Get
        Set(ByVal Value As Integer)
            _SurveyInstanceID = Value
            GetSurveyInstanceRequirements(_SurveyInstanceID)
        End Set
    End Property

End Class
