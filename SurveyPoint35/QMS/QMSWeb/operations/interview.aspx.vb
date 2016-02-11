Partial Class frmInterview
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
    Private m_sDSName As String
    Private m_oInterview As QMS.clsInterview
    Private m_oConn As SqlClient.SqlConnection
    Private m_bStartInterview As Boolean = False

    Public Const SCRIPT_ID_KEY As String = QMS.clsInterview.SCRIPT_ID_KEY
    Public Const RESPONDENT_ID_KEY As String = QMS.clsInterview.RESPONDENT_ID_KEY
    Public Const INPUTMODE_ID_KEY As String = QMS.clsInterview.INPUTMODE_ID_KEY
    Public Const SCREEN_INDEX_KEY As String = QMS.clsInterview.SCREEN_INDEX_KEY
    Public Const INTERVIEWMODE_ID_KEY As String = "interview"
    Private Const DATASET_KEY As String = "ds"

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        'first time on page, setup viewstate vars
        If Not Page.IsPostBack Then SetPageVars()
        'check if dataset stored in session, if not load dataset
        'setup interview object
        InterviewSetup()
        If Not m_oInterview.DSVerify(Session(DATASET_KEY)) Then LoadDataSet()
        m_oInterview.ScreenIndex = CInt(ViewState(SCREEN_INDEX_KEY))

        'first time on page
        If Not Page.IsPostBack Then
            'setup page
            DisplayScreen()
            'cleanp objects
            PageCleanUp()

        End If

    End Sub

    Private Sub SetPageVars()
        'script is required
        If IsNumeric(Request.QueryString(SCRIPT_ID_KEY)) Then
            ViewState(SCRIPT_ID_KEY) = CInt(Request.QueryString(SCRIPT_ID_KEY))

        End If

        'respondent is required
        'If IsNumeric(Session("rid")) Then
        '   ViewState(RESPONDENT_ID_KEY) = Session("rid")

        If IsNumeric(Request.QueryString(RESPONDENT_ID_KEY)) Then
            ViewState(RESPONDENT_ID_KEY) = CInt(Request.QueryString(RESPONDENT_ID_KEY))

        End If

        'get input mode, set to view by default
        If IsNumeric(Request.QueryString(INPUTMODE_ID_KEY)) Then
            ViewState(INPUTMODE_ID_KEY) = CInt(Request.QueryString(INPUTMODE_ID_KEY))

        Else
            ViewState(INPUTMODE_ID_KEY) = CInt(QMS.qmsInputMode.VIEW)

        End If

        'get screen screen index, set to first screen by default
        If IsNumeric(Request.QueryString(SCREEN_INDEX_KEY)) Then
            ViewState(SCREEN_INDEX_KEY) = CInt(Request.QueryString(SCREEN_INDEX_KEY))

        Else
            ViewState(SCREEN_INDEX_KEY) = 1
            m_bStartInterview = True

        End If

        ViewState(INTERVIEWMODE_ID_KEY) = QMS.qmsInterviewMode.InputResponse

        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENTEVENTS_EDIT) Then
            ibNoScoreExit.Visible = False
        End If

    End Sub

    Private Sub InterviewSetup()
        m_oInterview = New QMS.clsInterview(m_oConn)
        m_oInterview.DSName = Request.Url.AbsolutePath
        m_oInterview.RespondentID = CInt(ViewState(RESPONDENT_ID_KEY))
        m_oInterview.ScriptID = CInt(ViewState(SCRIPT_ID_KEY))
        m_oInterview.InputMode = CType(ViewState(INPUTMODE_ID_KEY), QMS.qmsInputMode)
        m_oInterview.UserID = CInt(HttpContext.Current.User.Identity.Name)
        m_oInterview.InterviewMode = CType(ViewState(INTERVIEWMODE_ID_KEY), QMS.qmsInterviewMode)

    End Sub

    Private Sub LoadDataSet()
        Dim dr As DataRow = m_oInterview.Respondent.NewSearchRow
        dr.Item("RespondentID") = CInt(ViewState(RESPONDENT_ID_KEY))
        m_oInterview.Fill(dr)
        ViewState(RESPONDENT_ID_KEY) = m_oInterview.RespondentID
        If m_bStartInterview Then m_oInterview.StartInterview()

    End Sub

    Private Sub PageCleanUp()
        Session(DATASET_KEY) = m_oInterview.DataSet
        m_oInterview.Close()
        m_oConn.Close()
        m_oConn = Nothing

    End Sub

    Private Sub DisplayScreen()
        ltScriptTitle.Text = m_oInterview.Script.MainDataTable.Rows(0).Item("Name").ToString
        ltSummaryTable.Text = m_oInterview.ScriptStatusHTML
        SetRespondentInfo()
        SetScreenInfo()

    End Sub

    Private Sub SetRespondentInfo()
        Dim dr As DataRow = m_oInterview.Respondent.MainDataTable.Rows(0)
        Dim sb As New System.Text.StringBuilder()

        'Set respondent info
        sb.AppendFormat("RID {0}", dr.Item("RespondentID"))
        If Not IsDBNull(dr.Item("FirstName")) Then
            sb.AppendFormat(", {0} {1}", dr.Item("FirstName"), dr.Item("LastName"))
        Else
            sb.AppendFormat(", {0}", dr.Item("LastName"))
        End If
        If Not IsDBNull(dr.Item("City")) Then sb.AppendFormat(", {0}", dr.Item("City"))
        If Not IsDBNull(dr.Item("State")) Then sb.AppendFormat(", {0}", dr.Item("State"))
        If Not IsDBNull(dr.Item("TelephoneDay")) Then sb.AppendFormat(", {0}", DMI.clsUtil.FormatTelephone(dr.Item("TelephoneDay").ToString))
        If Not IsDBNull(dr.Item("TelephoneEvening")) Then sb.AppendFormat(", {0}", DMI.clsUtil.FormatTelephone(dr.Item("TelephoneEvening").ToString))

        ltRespondent.Text = sb.ToString
        sb = Nothing

    End Sub

    Private Sub SetScreenInfo()
        Dim dr As DataRow = m_oInterview.CurrentScreen

        ltScreenTitle.Text = String.Format("{1} ({0})", dr.Item("ItemOrder"), dr.Item("Title"))
        ltScreenText.Text = m_oInterview.ScreenText
        ltCategoryText.Text = m_oInterview.CategoryHTML

        'set sound tag to alert for error
        If m_oInterview.ErrorMsg.Length > 0 Then
            ltSoundTag.Text = "<EMBED SRC=""../includes/batch.wav"" AUTOSTART=""True"" HIDDEN=""True""><bgsound src=""../includes/batch.wav"">"

        End If

    End Sub


    Private Sub ExitInterview(ByVal Score As Boolean)
        If Score Then m_oInterview.Score()

        If CType(ViewState(INPUTMODE_ID_KEY), QMS.qmsInputMode) = QMS.qmsInputMode.TEST Then
            m_oInterview.CleanUpTestMode()
        Else
            m_oInterview.EndInterview()
        End If
        PageCleanUp()
        Session.Remove(DATASET_KEY)
        RedirectUser()

    End Sub

    Private Sub RedirectUser()
        Select Case CType(ViewState(INPUTMODE_ID_KEY), QMS.qmsInputMode)
            Case QMS.qmsInputMode.CATI, QMS.qmsInputMode.RCALL, QMS.qmsInputMode.INCOMING, QMS.qmsInputMode.VIEW
                Response.Redirect(String.Format("../respondents/respondentdetails.aspx?{0}={1}&{2}={3}", frmRespondentDetails.REQUEST_INPUTMODE_ID_KEY, ViewState(INPUTMODE_ID_KEY), _
                    frmRespondentDetails.REQUEST_RESPONDENT_ID_KEY, ViewState(RESPONDENT_ID_KEY)))

            Case QMS.qmsInputMode.TEST
                Response.Redirect(String.Format("../scripts/scriptdetails.aspx?{0}={1}", frmScriptDetails.REQUEST_SCRIPT_ID_KEY, ViewState(SCRIPT_ID_KEY)))

            Case Else
                Response.Redirect(String.Format("../respondents/getrespondent.aspx?{0}={1}", frmGetRespondent.REQUEST_INPUTMODE_ID_KEY, ViewState(INPUTMODE_ID_KEY)))

        End Select

    End Sub

    Private Sub ibExitScore_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibExitScore.Click
        Try
            ExitInterview(True)

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Me, ex.Message)
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibNoScoreExit_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibNoScoreExit.Click
        Try
            ExitInterview(False)

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Me, ex.Message)
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub btnNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNext.Click
        Try
            Dim iScreenIndex As Integer

            If m_oInterview.ReadWebResponse(Request) Then
                m_oInterview.Save()
                iScreenIndex = m_oInterview.NextScreen()
                CheckScriptJump()
                If iScreenIndex <= 0 Then ExitInterview(True)
                ViewState(SCREEN_INDEX_KEY) = m_oInterview.ScreenIndex

            End If
            ViewState(INTERVIEWMODE_ID_KEY) = m_oInterview.InterviewMode
            DisplayScreen()

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Page, ex.Message)

        Finally
            PageCleanUp()

        End Try

    End Sub

    Private Sub btnPrev_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnPrev.Click
        Try
            Dim iScreenIndex As Integer

            If m_oInterview.ReadWebResponse(Request) Then
                m_oInterview.Save()
                iScreenIndex = m_oInterview.PreviousScreen()
                CheckScriptJump()
                If iScreenIndex <= 0 Then ExitInterview(True)
                ViewState(SCREEN_INDEX_KEY) = m_oInterview.ScreenIndex

            End If
            ViewState(INTERVIEWMODE_ID_KEY) = m_oInterview.InterviewMode
            DisplayScreen()

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Page, ex.Message)

        Finally
            PageCleanUp()

        End Try

    End Sub

    Private Sub CheckScriptJump()
        If m_oInterview.JumpToScriptID > 0 Then
            Dim scriptID As Integer = m_oInterview.JumpToScriptID
            PageCleanUp()
            Session(DATASET_KEY) = Nothing
            Response.Redirect(String.Format("interview.aspx?{0}={1}&{2}={3}&{4}={5}", _
                                INPUTMODE_ID_KEY, ViewState(INPUTMODE_ID_KEY), _
                                RESPONDENT_ID_KEY, ViewState(RESPONDENT_ID_KEY), _
                                SCRIPT_ID_KEY, scriptID))
        End If

    End Sub

End Class
