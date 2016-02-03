Partial Class frmGetRespondentBYCRID
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
            clsLog.LogError(GetType(frmGetRespondentBYCRID), "Page_Load", ex)
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
            hlByRespondentID.NavigateUrl = String.Format("getrespondent.aspx?{0}={1}", frmGetRespondent.REQUEST_INPUTMODE_ID_KEY, ViewState(VIEWSTATE_INPUTMODE_KEY))

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

            If Page.IsValid Then
                'do nothing

            End If

            'clear text box
            tbClientRespondentID.Text = ""

        Catch ex As Exception
            clsLog.LogError(GetType(frmGetRespondentBYCRID), "btnSubmit_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub RedirectToDetailsPage(ByVal respondentID As Integer)
        Dim iInputMode As QMS.qmsInputMode
        iInputMode = CInt(ViewState(VIEWSTATE_INPUTMODE_KEY))
        PageCleanUp()
        Response.Redirect(String.Format("respondentdetails.aspx?rid={0}&input={1}", respondentID, CInt(ViewState("InputMode"))))

    End Sub

    Public Sub ValidateRespondentID(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        args.IsValid = True

        Try
            Dim clientRespondentID As String

            'get respondent data
            clientRespondentID = tbClientRespondentID.Text.Trim
            GetRespondentByCRID(clientRespondentID)

            'run checks
            CheckNoRespondentsFound(clientRespondentID)
            CheckOneRespondentFound(clientRespondentID)
            CheckMultiRespondentsFound(clientRespondentID)

        Catch ex As Exception
            cuvClientRespondentID.ErrorMessage = ex.Message
            args.IsValid = False

        End Try

    End Sub

    Private Sub ValidateRespondentForInputMode(ByVal respondentID As Integer)
        Dim iInputMode As Integer = CInt(ViewState(VIEWSTATE_INPUTMODE_KEY))

        If Not m_oRespondent.SelectForInput(iInputMode, respondentID, CInt(HttpContext.Current.User.Identity.Name)) Then
            Throw New ApplicationException(m_oRespondent.ErrMsg)

        End If

    End Sub
    Private Sub CheckNoRespondentsFound(ByVal clientRespondentID As String)
        If m_oRespondent.MainDataTable.Rows.Count = 0 Then
            Throw New ApplicationException(String.Format("No respondents found with CRID {0}", clientRespondentID))

        End If

    End Sub

    Private Sub CheckOneRespondentFound(ByVal clientRespondentID As String)
        If m_oRespondent.MainDataTable.Rows.Count = 1 Then
            Dim respondentID As Integer = CInt(m_oRespondent.MainDataTable.Rows(0).Item("RespondentID"))
            ValidateRespondentForInputMode(respondentID)
            RedirectToDetailsPage(respondentID)

        End If

    End Sub

    Private Sub CheckMultiRespondentsFound(ByVal clientRespondentID As String)
        If m_oRespondent.MainDataTable.Rows.Count > 1 Then
            'display respondents in datagrid
            DisplayRespondents()

            Throw New ApplicationException(String.Format("More than one respondent found with CRID {0}", clientRespondentID))

        End If

    End Sub

    Private Function GetRespondentByCRID(ByVal clientRespondentID As String)
        Dim dr As QMS.dsRespondents.SearchRow = GetSearchFilter(clientRespondentID)
        m_oRespondent.FillMain(dr)

    End Function

    Private Function GetSearchFilter(ByVal clientRespondentID As String) As QMS.dsRespondents.SearchRow
        Dim dr As QMS.dsRespondents.SearchRow = CType(m_oRespondent.NewSearchRow, QMS.dsRespondents.SearchRow)
        dr.ClientRespondentID = clientRespondentID

        Return dr

    End Function

    Private Sub DisplayRespondents()
        Dim respondentCount As Integer = 0

        QMS.clsQMSTools.FormatQMSDataGrid(dgRespondents)
        dgRespondents.DataKeyField = "RespondentID"
        respondentCount = m_oRespondent.DataGridBind(dgRespondents, "LastName, FirstName")

    End Sub

    Private Sub dgRespondents_SelectedIndexChanged1(ByVal sender As Object, ByVal e As System.EventArgs) Handles dgRespondents.SelectedIndexChanged
        Try
            Dim respondentID As Integer
            respondentID = CInt(dgRespondents.DataKeys(dgRespondents.SelectedIndex))
            ValidateRespondentForInputMode(respondentID)
            RedirectToDetailsPage(respondentID)

        Catch ex As Exception
            clsLog.LogError(GetType(frmGetRespondentBYCRID), "dgRespondents_SelectedIndexChanged1", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        Finally
            PageCleanUp()

        End Try

    End Sub

    Private Sub dgRespondents_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgRespondents.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim drv As DataRowView
            drv = CType(e.Item.DataItem, DataRowView)
            'set name column
            CType(e.Item.FindControl("ltRespondentName"), Literal).Text = String.Format("{0}, {1}", drv.Item("FirstName"), drv.Item("LastName"))
            'set address column
            CType(e.Item.FindControl("ltAddress"), Literal).Text = DMI.clsUtil.FormatHTMLAddress(drv.Item("Address1"), drv.Item("Address2"), drv.Item("City"), drv.Item("State"), drv.Item("PostalCode"))
            'set survey instance column
            CType(e.Item.FindControl("ltSurveyInstanceName"), Literal).Text = String.Format("{0}: {1}: {2}", drv.Item("SurveyName"), drv.Item("ClientName"), drv.Item("SurveyInstanceName"))

        End If

    End Sub
End Class
