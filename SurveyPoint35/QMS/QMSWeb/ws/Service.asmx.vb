Imports System.Web.Services

<System.Web.Services.WebService(Namespace:="http://dmisolutions.net/QMSWeb/Service")> _
Public Class Service
    Inherits System.Web.Services.WebService

    Private _Connection As SqlClient.SqlConnection
    Private _UserID As Integer
    Private Const DATASET_INTERVIEW_NAME As String = "wsInterviewDataSet"

#Region " Web Services Designer Generated Code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Web Services Designer.
        InitializeComponent()

        'Add your own initialization code after the InitializeComponent() call
        _Connection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

    End Sub

    'Required by the Web Services Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Web Services Designer
    'It can be modified using the Web Services Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        components = New System.ComponentModel.Container
    End Sub

    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        'CODEGEN: This procedure is required by the Web Services Designer
        'Do not modify it using the code editor.
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

#End Region

    ' Use this as a test method
    <WebMethod()> _
    Public Function HelloWorld() As String
        CleanUp()
        Return "Hello World"
    End Function

    ' Validates user account, starts a user session, and returns a security token
    ' User must send security token to access any web services
    <WebMethod()> _
    Public Function GetSecurityToken(ByVal Username As String, ByVal Password As String) As String
        Dim User As New QMS.clsUsers(_Connection)
        Dim SecurityToken As String = Guid.NewGuid.ToString

        'validate user account and return session id as token
        If Not User.SignInUser(Username, Password, SecurityToken) Then
            SecurityToken = ""
        End If

        CleanUp()

        Return SecurityToken

    End Function

    'Ends a session and invalidates the security token
    <WebMethod()> _
    Public Sub EndSession(ByVal SecurityToken As String)
        If ValidateSecurityToken(SecurityToken) Then
            'log sign out, invalidating security token
            QMS.clsUsers.LogUserEvent(_UserID, QMS.qmsEvents.USER_LOGOFF, SecurityToken)

        End If
        CleanUp()

    End Sub

    'Returns the interview dataset filled with the script and respondent data
    <WebMethod()> _
    Public Function GetInterviewDataSet(ByVal SecurityToken As String, ByVal ScriptID As Integer, ByVal RespondentID As Integer) As QMS.dsInterview
        Dim ds As QMS.dsInterview

        If ValidateSecurityToken(SecurityToken) Then
            Dim Interview As New QMS.clsInterview(_Connection)

            Interview.DSName = DATASET_INTERVIEW_NAME
            Interview.ScriptID = ScriptID
            Interview.InputMode = QMS.qmsInputMode.CATI
            Interview.UserID = Me._UserID

            Dim drCriteria As DataRow = Interview.Respondent.NewSearchRow
            If RespondentID > 0 Then
                drCriteria.Item("RespondentID") = RespondentID
            Else
                drCriteria.Item("RespondentID") = -1
            End If

            Interview.Fill(drCriteria)

            ds = Interview.DataSet

        End If

        CleanUp()
        Return ds

    End Function

    'Commits updates from the interview dataset to the database
    <WebMethod()> _
    Public Function UpdateInterviewDataSet(ByVal SecurityToken As String, ByVal InterviewDataSet As QMS.dsInterview) As Boolean
        If ValidateSecurityToken(SecurityToken) Then
            Dim Interview As New QMS.clsInterview(_Connection)
            Interview.DSName = DATASET_INTERVIEW_NAME
            Interview.InputMode = QMS.qmsInputMode.CATI
            Interview.UserID = Me._UserID

            If Interview.DSVerify(InterviewDataSet) Then
                Interview.Respondent.Save()
                Interview.Responses.Save()
                Interview.EventLog.Save()

            End If

        End If
        CleanUp()

    End Function

    'run this clean up before ending request
    Private Sub CleanUp()
        _Connection.Close()
        _Connection = Nothing

    End Sub

    Private Function ValidateSecurityToken(ByVal SecurityToken As String) As Boolean
        Dim UserID As Integer = QMS.clsQMSTools.GetUserID(_Connection, SecurityToken)
        If UserID > 0 Then
            _UserID = UserID
            Return True

        Else
            Return False

        End If

    End Function

End Class
