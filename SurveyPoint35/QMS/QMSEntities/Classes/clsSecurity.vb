Public Enum qmsSecurity As Integer
    WEB_ACCESS = 6000
    CLIENT_ADMIN = 6001
    USER_ADMIN = 6002
    SURVEY_DESIGNER = 6003
    SCRIPT_DESIGNER = 6004
    PROTOCOL_DESIGNER = 6005
    INSTANCE_ADMIN = 6006
    EVENT_ADMIN = 6007
    USERGROUP_ADMIN = 6008
    CLIENT_VIEWER = 6009
    USER_VIEWER = 6010
    SURVEY_VIEWER = 6011
    SCRIPT_VIEWER = 6012
    PROTOCOL_VIEWER = 6013
    INSTANCE_VIEWER = 6014
    EVENT_VIEWER = 6015
    USERGROUP_VIEWER = 6016
    DATA_ENTRY = 6017
    VERIFICATION = 6018
    CATI = 6019
    RESPONDENT_EDIT = 6020
    IMPORT_ACCESS = 6021
    EXPORT_ACCESS = 6022
    FILEDEF_DESIGNER = 6023
    BATCHER = 6024
    RESPONDENTEVENTS_EDIT = 6025
    EVENTLOG_VIEWER = 6026
    EVENTLOG_EDIT = 6027
    SIPS_ADMIN = 6028
    RESPONDENT_ADMIN = 6029
    OVERRIDE_DE_CHECK = 6050

End Enum

Public Class clsQMSSecurity

    Public Shared Function CheckPrivledge(ByVal arlPrivledges As ArrayList, ByVal iSecurityCode As qmsSecurity) As Boolean
        If Not IsNothing(arlPrivledges) Then
            Return arlPrivledges.Contains(Integer.Parse(iSecurityCode))

        Else
            Return False

        End If

    End Function

    Shared Function NonPrivAccess(ByRef r As System.Web.HttpRequest, ByRef s As System.Web.SessionState.HttpSessionState) As String

        If IsNothing(s.Item("Privledges")) Then
            Return "../login.aspx?signout=1"

        Else
            Return DMI.WebFormTools.ReflectURL(r)

        End If

    End Function

End Class
