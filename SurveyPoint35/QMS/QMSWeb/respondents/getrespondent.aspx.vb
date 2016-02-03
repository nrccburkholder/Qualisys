Partial Class frmGetRespondent
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
    Private Const VIEWSTATE_INPUTMODE_KEY As String = "InputMode"
    Public Const REQUEST_INPUTMODE_ID_KEY As String = "input"
    Private Const EXTRACT_RESPONDENTID_REGEX As String = "(\d+)(!?)"

    Private m_oRespondent As QMS.clsRespondents
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_oRespondent = New QMS.clsRespondents(m_oConn)
            Session.Remove("ds")
            Session.Remove(frmCallList.SESSION_PROTOCOLSTEP_ID_KEY)

            If Not Page.IsPostBack Then
                PageSetup()
                PageCleanUp()
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmGetRespondent), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageSetup()
        Dim oInputMode As QMS.IInputMode

        If IsNumeric(Request.QueryString(REQUEST_INPUTMODE_ID_KEY)) Then
            ViewState(VIEWSTATE_INPUTMODE_KEY) = CInt(Request.QueryString(REQUEST_INPUTMODE_ID_KEY))
        Else
            ViewState(VIEWSTATE_INPUTMODE_KEY) = 0
        End If
        oInputMode = QMS.clsInputMode.Create(ViewState(VIEWSTATE_INPUTMODE_KEY))

        If oInputMode.AllowUser(CType(Session("Privledges"), ArrayList)) Then
            lblFormTitle.Text = String.Format("Get Respondent For {0}", oInputMode.InputModeName)
            'force enter keypress to trigger submit button event
            Page.RegisterHiddenField("__EVENTTARGET", "btnSubmit")
            hlByCRID.NavigateUrl = String.Format("getrespondent_byCRID.aspx?{0}={1}", frmGetRespondentBYCRID.REQUEST_INPUTMODE_ID_KEY, ViewState(VIEWSTATE_INPUTMODE_KEY))

        Else
            'User cannot access this page in current input mode, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oRespondent) Then
            m_oRespondent.Close()
            m_oRespondent = Nothing
        End If
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If

    End Sub

    Private Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Try
            Dim iRespondentID As Integer
            Dim iInputMode As QMS.qmsInputMode

            If Page.IsValid Then
                'get redirect parameters
                iRespondentID = CleanRespondentID(tbRespondentID.Text)
                iInputMode = CInt(ViewState(VIEWSTATE_INPUTMODE_KEY))

                'redirect to details page
                PageCleanUp()
                Response.Redirect(String.Format("respondentdetails.aspx?rid={0}&input={1}", iRespondentID, CInt(ViewState("InputMode"))))

            End If

            'clear text box
            tbRespondentID.Text = ""

        Catch ex As Exception
            clsLog.LogError(GetType(frmGetRespondent), "btnSubmit_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Public Sub ValidateRespondentID(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Dim iInputMode As Integer = CInt(ViewState(VIEWSTATE_INPUTMODE_KEY))
        Dim iRespondentID As Integer

        args.IsValid = True

        'get respondent data
        iRespondentID = CleanRespondentID(tbRespondentID.Text)
        If Not m_oRespondent.SelectForInput(iInputMode, iRespondentID, CInt(HttpContext.Current.User.Identity.Name)) Then
            If Not OverrideRespondentID(tbRespondentID.Text) Then
                cuvRespondentID.ErrorMessage = m_oRespondent.ErrMsg
                args.IsValid = False

            Else

            End If

        End If

    End Sub

    Private Function CleanRespondentID(ByVal respondentID As String) As Integer
        Dim rx As RegularExpressions.Regex

        If rx.IsMatch(respondentID, Me.EXTRACT_RESPONDENTID_REGEX) Then
            Dim respondentIdMatch As RegularExpressions.Match
            respondentIdMatch = rx.Match(respondentID, Me.EXTRACT_RESPONDENTID_REGEX)

            If IsNumeric(respondentIdMatch.Groups(1).ToString) Then
                Return CInt(respondentIdMatch.Groups(1).ToString)
            End If

        End If

        Throw New ApplicationException("CleanRespondentID: Respondent ID is not numeric")

    End Function

    Private Function OverrideRespondentID(ByVal respondentID As String) As Boolean
        Dim rx As RegularExpressions.Regex

        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session(frmLogin.PRIVLEDGES_SESSION_KEY), ArrayList), QMS.qmsSecurity.OVERRIDE_DE_CHECK) Then
            If rx.IsMatch(respondentID, Me.EXTRACT_RESPONDENTID_REGEX) Then
                Dim respondentIdMatch As RegularExpressions.Match
                respondentIdMatch = rx.Match(respondentID, Me.EXTRACT_RESPONDENTID_REGEX)

                If respondentIdMatch.Groups(2).ToString = "!" Then Return True

            End If

        End If

        Return False

    End Function

End Class
