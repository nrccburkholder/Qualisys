Partial Class frmInterviewLite
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

#Region " Form Variables "
    Private _Interview As QMS.clsInterviewLite
    Private _Connection As SqlClient.SqlConnection
    Private _StartInterview As Boolean = False
    Private _RespondentID As Integer = -1
    Private _ScriptID As Integer = -1
    Private _ScriptScreenIndex As Integer = -1
    'TP Change
    Private _InputMode As QMS.qmsInputMode = QMS.qmsInputMode.NOTINITIALIZED
    'Private _InputMode As QMS.qmsInputMode = -1
    Private _UserID As Integer = -1
    'TP Change
    Private _InterviewMode As QMS.qmsInterviewMode = QMS.qmsInterviewMode.NotInitialized
    'Private _InterviewMode As QMS.qmsInterviewMode = -1

    Public Const SCRIPT_ID_KEY As String = QMS.clsInterviewLite.SCRIPT_ID_KEY
    Public Const RESPONDENT_ID_KEY As String = QMS.clsInterviewLite.RESPONDENT_ID_KEY
    Public Const INPUTMODE_ID_KEY As String = QMS.clsInterviewLite.INPUTMODE_ID_KEY
    Public Const SCREEN_INDEX_KEY As String = QMS.clsInterviewLite.SCREEN_INDEX_KEY
    Public Const INTERVIEWMODE_ID_KEY As String = "interview"
    Public Const KEYSTOKE_COUNT As String = "keystroke"
#End Region

#Region " Event Handlers "
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        _Connection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        _Interview = New QMS.clsInterviewLite(_Connection)

        'first time on page
        If Not Page.IsPostBack Then
            Try
                InitViewStateVars()
                If ScriptScreenIndex = 1 Then
                    _Interview.StartInterview(InputMode, UserID, RespondentID, ScriptID)
                    CreateKeyStrokeSession()

                Else
                    _Interview.GoToScreen(InputMode, UserID, RespondentID, ScriptID, ScriptScreenIndex)
                End If
                'run routines to check for jumps
                CheckScriptJump()
                If _Interview.ScriptScreenIndex <= 0 Then RedirectUser()
                ReassignViewStateVars()

                'setup page
                InitScreen()
                'setup screen
                SetScreenInfo()


            Catch ex As Exception
                clsLog.LogError(GetType(frmInterviewLite), "Page_Load", ex)
                DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

            Finally
                'cleanp objects
                PageCleanUp()

            End Try

        End If

    End Sub

    Private Sub ibExitScore_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibExitScore.Click
        Try
            _Interview.RecordAnswer(Request, InterviewMode, InputMode, UserID, RespondentID, ScriptID, ScriptScreenIndex)
            _Interview.ExitInterview(InputMode, UserID, RespondentID, ScriptID, True)
            UpdateKeyStrokeSession()
            RedirectUser()

        Catch ex As Exception
            clsLog.LogError(GetType(frmInterviewLite), "ibExitScore_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibNoScoreExit_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibNoScoreExit.Click
        Try
            _Interview.RecordAnswer(Request, InterviewMode, InputMode, UserID, RespondentID, ScriptID, ScriptScreenIndex)
            _Interview.ExitInterview(InputMode, UserID, RespondentID, ScriptID, False)
            UpdateKeyStrokeSession()
            RedirectUser()
        Catch ex As Exception
            clsLog.LogError(GetType(frmInterviewLite), "ibNoScoreExit_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub btnNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNext.Click
        Try
            _Interview.NextScreen(Request, InterviewMode, InputMode, UserID, RespondentID, ScriptID, ScriptScreenIndex)
            UpdateKeyStrokeSession()
            CheckScriptJump()
            If _Interview.ScriptScreenIndex <= 0 Then
                RedirectUser()
            Else
                ReassignViewStateVars()
                SetScreenInfo()
                If InputMode = QMS.qmsInputMode.READ_ONLY Then UpdateScriptStatusTable()
            End If
        Catch ex As Exception
            clsLog.LogError(GetType(frmInterviewLite), "btnNext_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub btnPrev_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPrev.Click
        Try
            _Interview.PreviousScreen(Request, InterviewMode, InputMode, UserID, RespondentID, ScriptID, ScriptScreenIndex)
            CheckScriptJump()
            If _Interview.ScriptScreenIndex <= 0 Then
                RedirectUser()
            Else
                ReassignViewStateVars()
                SetScreenInfo()
                If InputMode = QMS.qmsInputMode.READ_ONLY Then UpdateScriptStatusTable()
            End If
        Catch ex As Exception
            clsLog.LogError(GetType(frmInterviewLite), "btnPrev_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub lbUpdateStatus_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbUpdateStatus.Click
        Try
            UpdateScriptStatusTable()
            SetScreenInfo()
        Catch ex As Exception
            clsLog.LogError(GetType(frmInterviewLite), "lbUpdateStatus_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try
    End Sub

    Private Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If HasKeyStrokeSession() Then
            If Session(KEYSTOKE_COUNT) IsNot Nothing Then
                Me.ltKeyStrokes.Text = "Key Count: " & CStr(Session(KEYSTOKE_COUNT))
            End If
        End If        
    End Sub

#End Region

#Region " Private Methods "
    Private Sub SetupSecurity()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENTEVENTS_EDIT) Then
            ibNoScoreExit.Visible = False
        End If

    End Sub

    Private Sub InitViewStateVars()
        Dim iRespondent As Integer = RespondentID
        Dim iScriptID As Integer = ScriptID
        Dim iScriptScreenIndex As Integer = ScriptScreenIndex
        Dim iInputMode As QMS.qmsInputMode = InputMode
        Dim iInterviewMode As QMS.qmsInterviewMode = InterviewMode

    End Sub

    Private Sub ReassignViewStateVars()
        ScriptScreenIndex = _Interview.ScriptScreenIndex
        InterviewMode = _Interview.InterviewMode

    End Sub

    Private Sub PageCleanUp()
        _Interview = Nothing
        If Not IsNothing(_Connection) Then
            _Connection.Close()
            _Connection.Dispose()
            _Connection = Nothing
        End If

    End Sub

    Private Sub InitScreen()
        ltScriptTitle.Text = _Interview.GetScriptInfo.Name
        ltRespondent.Text = _Interview.GetRespondentDescText
        ltTotalScreenCount.Text = String.Format("&nbsp;of&nbsp;{0}", _Interview.ScriptScreenCount)
        If InputMode = QMS.qmsInputMode.READ_ONLY Then
            ltBackground.Text = "<STYLE type=""text/css"">BODY { background-color: pink }</STYLE>"
            UpdateScriptStatusTable()
        End If
    End Sub

    Private Sub SetScreenInfo()
        Dim dr As QMS.dsInterviewLite.ScriptScreensRow = _Interview.GetScreenInfo

        ltScreenTitle.Text = String.Format("{1} ({0})", dr.ItemOrder, dr.Title)
        ltScreenText.Text = _Interview.ScreenText
        ltCategoryText.Text = _Interview.CategoryText
        ltScreenIndex.Text = _Interview.ScriptScreenIndex.ToString

    End Sub

    Private Sub RedirectUser()
        Dim newURL As String = String.Empty
        Select Case InputMode
            Case QMS.qmsInputMode.CATI, QMS.qmsInputMode.RCALL, QMS.qmsInputMode.INCOMING, QMS.qmsInputMode.VIEW, QMS.qmsInputMode.READ_ONLY
                'CheckMaxCalls()
                RecordKeyStrokeStat()
                newURL = String.Format("../respondents/respondentdetails.aspx?{0}={1}&{2}={3}", _
                frmRespondentDetails.REQUEST_INPUTMODE_ID_KEY, CInt(InputMode), _
                frmRespondentDetails.REQUEST_RESPONDENT_ID_KEY, RespondentID)
                Response.Redirect(newURL, False)

            Case QMS.qmsInputMode.TEST
                newURL = String.Format("../scripts/scriptdetails.aspx?{0}={1}", _
                    frmScriptDetails.REQUEST_SCRIPT_ID_KEY.ToString, ScriptID)
                Response.Redirect(newURL, False)

            Case Else
                RecordKeyStrokeStat()
                newURL = String.Format("../respondents/getrespondent.aspx?{0}={1}", _
                    frmGetRespondent.REQUEST_INPUTMODE_ID_KEY.ToString, CInt(InputMode))
                Response.Redirect(newURL, False)

        End Select

    End Sub

    Private Sub CheckMaxCalls()
        Dim input As QMS.qmsInputMode = InputMode
        If input = QMS.qmsInputMode.CATI OrElse input = QMS.qmsInputMode.RCALL OrElse input = QMS.qmsInputMode.INCOMING Then
            If Not Session(frmCallList.SESSION_PROTOCOLSTEP_ID_KEY) Is Nothing Then
                Dim iProtocolStepId As Integer = frmCallList.ExtractProtocolStepID(Session(frmCallList.SESSION_PROTOCOLSTEP_ID_KEY).ToString())
                QMS.clsRespondents.CheckMaxCall(_Connection, iProtocolStepId, UserID, RespondentID)
            End If
        End If
    End Sub
    Private Sub CheckScriptJump()
        If _Interview.JumpToScriptID > 0 Then
            Dim iScriptID As Integer = _Interview.JumpToScriptID
            PageCleanUp()
            Response.Redirect(String.Format("interviewLite.aspx?{0}={1}&{2}={3}&{4}={5}", _
                                INPUTMODE_ID_KEY, InputMode, _
                                RESPONDENT_ID_KEY, RespondentID, _
                                SCRIPT_ID_KEY, iScriptID))
        End If

    End Sub
    Private Sub UpdateScriptStatusTable()
        _Interview.GoToScreen(CInt(InputMode), UserID, RespondentID, ScriptID, ScriptScreenIndex)
        Dim status As QMS.InterviewStatus
        If InputMode <> QMS.qmsInputMode.READ_ONLY Then
            status = New QMS.InterviewStatus(Me._Connection, RespondentID, ScriptID, UserID)
        Else
            status = New QMS.InterviewStatus(Me._Connection, RespondentID, ScriptID)
        End If

        ltScriptStatus.Text = status.ScriptStatusHTML(RespondentID, CInt(InputMode), ScriptID, ScriptScreenIndex)
        lbUpdateStatus.Visible = False
        status = Nothing

    End Sub

    Private Function CreateKeyStrokeSession()
        If Not HasKeyStrokeSession() Then
            Session(KEYSTOKE_COUNT) = 0
        End If
    End Function

    Private Function HasKeyStrokeSession() As Boolean
        Return IsNumeric(Session(KEYSTOKE_COUNT))
    End Function

    Private Sub UpdateKeyStrokeSession()
        If HasKeyStrokeSession() Then Session(KEYSTOKE_COUNT) += _Interview.KeyCount
    End Sub

    Private Sub RecordKeyStrokeStat()
        If HasKeyStrokeSession() Then _Interview.RecordKeyStrokeCount(CInt(Session(KEYSTOKE_COUNT)))
        Session(KEYSTOKE_COUNT) = Nothing
    End Sub
#End Region

#Region " Properties "
    Public ReadOnly Property RespondentID() As Integer
        Get
            If _RespondentID < 0 Then
                If Not IsNothing(ViewState(RESPONDENT_ID_KEY)) Then
                    _RespondentID = CInt(ViewState(RESPONDENT_ID_KEY))
                ElseIf IsNumeric(Request.QueryString(RESPONDENT_ID_KEY)) Then
                    _RespondentID = CInt(Request.QueryString(RESPONDENT_ID_KEY))
                    ViewState(RESPONDENT_ID_KEY) = _RespondentID
                End If
            End If

            Return _RespondentID

        End Get
    End Property

    Public ReadOnly Property UserID() As Integer
        Get
            If _UserID < 0 Then
                _UserID = CInt(HttpContext.Current.User.Identity.Name)
            End If

            Return _UserID

        End Get
    End Property

    Public ReadOnly Property ScriptID() As Integer
        Get
            If _ScriptID < 0 Then
                If Not IsNothing(ViewState(SCRIPT_ID_KEY)) Then
                    _ScriptID = CInt(ViewState(SCRIPT_ID_KEY))
                ElseIf IsNumeric(Request.QueryString(SCRIPT_ID_KEY)) Then
                    _ScriptID = CInt(Request.QueryString(SCRIPT_ID_KEY))
                    ViewState(SCRIPT_ID_KEY) = _ScriptID
                End If
            End If

            Return _ScriptID

        End Get
    End Property

    Public Property ScriptScreenIndex() As Integer
        Get
            If _ScriptScreenIndex < 0 Then
                If Not IsNothing(ViewState(SCREEN_INDEX_KEY)) Then
                    _ScriptScreenIndex = CInt(ViewState(SCREEN_INDEX_KEY))
                ElseIf IsNumeric(Request.QueryString(SCREEN_INDEX_KEY)) Then
                    _ScriptScreenIndex = CInt(Request.QueryString(SCREEN_INDEX_KEY))
                    ViewState(SCREEN_INDEX_KEY) = _ScriptScreenIndex
                Else
                    _ScriptScreenIndex = 1
                    ViewState(SCREEN_INDEX_KEY) = _ScriptScreenIndex
                End If
            End If
            Return _ScriptScreenIndex
        End Get
        Set(ByVal Value As Integer)
            _ScriptScreenIndex = Value
            ViewState(SCREEN_INDEX_KEY) = _ScriptScreenIndex
        End Set
    End Property

    Public Property InputMode() As QMS.qmsInputMode
        Get
            If CInt(_InputMode) < 0 Then
                If Not IsNothing(ViewState(INPUTMODE_ID_KEY)) Then
                    _InputMode = CType(ViewState(INPUTMODE_ID_KEY), QMS.qmsInputMode)
                ElseIf IsNumeric(Request.QueryString(INPUTMODE_ID_KEY)) Then
                    _InputMode = CType(Request.QueryString(INPUTMODE_ID_KEY), QMS.qmsInputMode)
                    ViewState(INPUTMODE_ID_KEY) = _InputMode
                Else
                    _InputMode = QMS.qmsInputMode.READ_ONLY
                    ViewState(INPUTMODE_ID_KEY) = _InputMode
                End If
            End If
            Return _InputMode
        End Get
        Set(ByVal Value As QMS.qmsInputMode)
            _InputMode = Value
            ViewState(INPUTMODE_ID_KEY) = _InputMode
        End Set
    End Property

    Public Property InterviewMode() As QMS.qmsInterviewMode
        Get
            If CInt(_InterviewMode) < 0 Then
                If Not IsNothing(ViewState(INTERVIEWMODE_ID_KEY)) Then
                    _InterviewMode = CType(ViewState(INTERVIEWMODE_ID_KEY), QMS.qmsInterviewMode)
                Else
                    _InterviewMode = QMS.qmsInterviewMode.InputResponse
                    ViewState(INTERVIEWMODE_ID_KEY) = _InterviewMode
                End If
            End If
            Return _InterviewMode
        End Get
        Set(ByVal Value As QMS.qmsInterviewMode)
            _InterviewMode = Value
            ViewState(INTERVIEWMODE_ID_KEY) = _InterviewMode
        End Set
    End Property
#End Region


End Class
