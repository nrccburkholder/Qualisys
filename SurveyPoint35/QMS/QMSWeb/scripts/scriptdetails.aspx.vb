Partial Class frmScriptDetails
    Inherits System.Web.UI.Page
    Protected WithEvents uctTemplates As ucTemplates

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

	Private Const LAST_SORT_KEY As String = "LastSort"
    Private Const SCRIPT_ID_KEY As String = "ScriptID"
    Public Const REQUEST_SCRIPT_ID_KEY As String = "id"
    Public Const REQUEST_COPY_ID_KEY As String = "copy"
    Public Const REQUEST_AUTO_ID_KEY As String = "auto"

	Private m_oScripts As QMS.clsScripts
	Private m_oScriptScreens As QMS.clsScriptScreens
	Private m_oConn As SqlClient.SqlConnection
	Private m_sDSName As String

	Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
		m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
		m_oScripts = New QMS.clsScripts(m_oConn)
        m_oScriptScreens = m_oScripts.ScriptScreens
		m_sDSName = Request.Url.AbsolutePath
        Session.Remove("ds")

		'Determine whether page setup is required:
		'user has posted back to same page
		If Not Page.IsPostBack Then
			PageLoad()
		Else
			'retrieve search row
			LoadDataSet()
		End If

	End Sub

	Private Sub PageLoad()
		'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_VIEWER) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()
        Else
            'Survey does not have Survey viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))
        End If
    End Sub

    Private Sub PageSetup()
        Dim newScriptID As Integer

        'setup view state variables
        ViewState(LAST_SORT_KEY) = "ItemOrder"
        ViewState(SCRIPT_ID_KEY) = ""

        If IsNumeric(Request.QueryString(REQUEST_COPY_ID_KEY)) Then
            'Copy script
            newScriptID = m_oScripts.Copy(CInt(Request.QueryString(REQUEST_COPY_ID_KEY)))
            Response.Redirect(String.Format("scriptdetails.aspx?id={0}", newScriptID), True)

        ElseIf IsNumeric(Request.QueryString(REQUEST_AUTO_ID_KEY)) Then
            'Auto-generate script
            newScriptID = m_oScripts.GenerateScript(CInt(Request.QueryString(REQUEST_AUTO_ID_KEY)))
            Response.Redirect(String.Format("scriptdetails.aspx?id={0}", newScriptID), True)

        End If

        If IsNumeric(Request.QueryString(REQUEST_SCRIPT_ID_KEY)) Then ViewState(SCRIPT_ID_KEY) = CInt(Request.QueryString(REQUEST_SCRIPT_ID_KEY))

        'get datset
        LoadDataSet()

        'setup form
        LoadDetailsForm()

        'setup datagrid
        dgScriptScreens.DataKeyField = "ScriptScreenID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgScriptScreens)
        ScriptScreensGridBind()
    End Sub

    Private Sub LoadDataSet()
        Dim newScriptDR As QMS.dsScripts.ScriptsRow
        Dim mainDR As QMS.dsScripts.SearchRow = CType(m_oScripts.NewSearchRow, QMS.dsScripts.SearchRow)

        m_oScripts.AuthorUserID = CInt(HttpContext.Current.User.Identity.Name)

        'fill the simple tables
        m_oScripts.FillLookups(mainDR)
        m_oScripts.FillCalculationTypes()

        'get row for script
        If IsNumeric(ViewState(SCRIPT_ID_KEY)) Then
            'existing script
            mainDR.ScriptID = CInt(ViewState(SCRIPT_ID_KEY))
            m_oScripts.FillMain(mainDR)
            m_oScripts.FillScriptScreens(mainDR)

        Else
            'new script
            m_oScripts.SurveyID = CInt(m_oScripts.SurveysTable.Rows(0).Item("SurveyID"))
            m_oScripts.AddMainRow()

        End If
        mainDR = Nothing

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oScriptScreens) Then
            m_oScriptScreens.Close()
            m_oScriptScreens = Nothing
        End If
        If Not IsNothing(m_oScripts) Then
            m_oScripts.Close()
            m_oScripts = Nothing
        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim dr As QMS.dsScripts.ScriptsRow = CType(m_oScripts.MainDataTable.Rows(0), QMS.dsScripts.ScriptsRow)

        'set id
        If dr.RowState = DataRowState.Added Then
            'new script, no id
            lblScriptID.Text = "NEW"
            DisplayScriptScreenActions = False

            ddlSurveyID.Visible = True
            ddlSurveyID.DataSource = m_oScripts.SurveysTable
            ddlSurveyID.DataTextField = "Name"
            ddlSurveyID.DataValueField = "SurveyID"
            ddlSurveyID.DataBind()
            ddlSurveyID.Items.Insert(0, New ListItem("Select Survey", ""))
            rfvSurveyID.Enabled = True
            lblSurveyName.Visible = False
            hlTestScript.Visible = False
            hlScriptTriggers.Visible = False
            hlPrint.Visible = False
            uctTemplates.Visible = False

        Else
            'existing script, display id
            lblScriptID.Text = dr.ScriptID
            DisplayScriptScreenActions = True
            ddlSurveyID.Visible = False
            rfvSurveyID.Enabled = False
            lblSurveyName.Visible = True

            uctTemplates.ScriptID = dr.ScriptID
            uctTemplates.fillGrid()

        End If

        'DMI.WebFormTools.SetReferingURL(Request, hlCancel, "[(.*/scripts/scriptdetails\.aspx)(scriptscreen\.aspx)]", Session)

        ddlScriptTypeID.DataSource = m_oScripts.ScriptTypesTable
        ddlScriptTypeID.DataValueField = "ScriptTypeID"
        ddlScriptTypeID.DataTextField = "Name"
        ddlScriptTypeID.DataBind()

        lblSurveyName.Text = dr.GetParentRow("SurveysScripts").Item("Name").ToString
        tbName.Text = dr.Name
        tbDescription.Text = dr.Description

        ddlScriptTypeID.SelectedIndex = ddlScriptTypeID.Items.IndexOf(ddlScriptTypeID.Items.FindByValue(dr.ScriptTypeID))
        tbCompletenessLevel.Text = dr.CompletenessLevel.ToString
        cbFollowSkips.Checked = CBool(dr.FollowSkips)
        cbCalcCompleteness.Checked = CBool(dr.CalcCompleteness)
        cbDefaultScript.Checked = CBool(dr.DefaultScript)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_DESIGNER) Then
            'must be script designer to edit or update script details and script screens
            ibSave.Enabled = False
            hlAdd.Enabled = False
            ibUpdateOrder.Enabled = False
            ibDelete.Enabled = False
        End If
    End Sub

    Sub ScriptScreensGridBind()
        Dim iRowCount As Integer
        iRowCount = m_oScriptScreens.DataGridBind(dgScriptScreens, ViewState(LAST_SORT_KEY).ToString)
    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim dr As QMS.dsScripts.ScriptsRow
        Dim bNewScript As Boolean = False
        Dim sMessage As String

        If dgScriptScreens.EditItemIndex = -1 Then
            If Page.IsValid Then
                System.Diagnostics.Debug.Assert(m_oScripts.MainDataTable.Rows.Count = 1)
                dr = CType(m_oScripts.MainDataTable.Rows(0), QMS.dsScripts.ScriptsRow)
                If dr.RowState = DataRowState.Added Then
                    dr.SurveyID = CInt(ddlSurveyID.SelectedItem.Value)
                    bNewScript = True
                End If

                dr.Name = tbName.Text
                dr.Description = tbDescription.Text
                dr.ScriptTypeID = ddlScriptTypeID.SelectedItem.Value
                dr.CompletenessLevel = CDec(tbCompletenessLevel.Text)
                dr.DefaultScript = CByte(IIf(cbDefaultScript.Checked, 1, 0))
                dr.CalcCompleteness = CByte(IIf(cbCalcCompleteness.Checked, 1, 0))
                dr.FollowSkips = CByte(IIf(cbFollowSkips.Checked, 1, 0))

                m_oScripts.Save()

                If m_oScripts.ErrMsg.Length > 0 Then
                    DMI.WebFormTools.Msgbox(Page, m_oScripts.ErrMsg)
                End If

                If bNewScript Then
                    Response.Redirect(String.Format("scriptdetails.aspx?id={0}", dr.ScriptID), True)
                End If

            End If
        End If

        ScriptScreensGridBind()
        PageCleanUp()

    End Sub

    Private Sub ibUpdateOrder_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibUpdateOrder.Click
        m_oScriptScreens.DataGridUpdateOrder(dgScriptScreens, Viewstate(LAST_SORT_KEY).ToString)
        PageCleanUp()
    End Sub

    Private Sub dgScriptScreens_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgScriptScreens.SortCommand
        Viewstate(LAST_SORT_KEY) = m_oScriptScreens.DataGridSort(dgScriptScreens, e, Viewstate(LAST_SORT_KEY).ToString)
        PageCleanUp()
    End Sub

    Private Property DisplayScriptScreenActions() As Boolean
        Get
            Return pnlScriptScreenActions.Visible
        End Get

        Set(ByVal Value As Boolean)
            pnlScriptScreenActions.Visible = Value
            If Value Then
                hlAdd.NavigateUrl = String.Format("scriptscreendetails.aspx?{1}={0}", ViewState(SCRIPT_ID_KEY), frmScriptScreenScreenDetails.REQUEST_SCRIPT_ID_KEY)
                hlTestScript.NavigateUrl = String.Format("../operations/interviewLite.aspx?{0}={1}&{2}={3}", frmInterview.SCRIPT_ID_KEY, ViewState(SCRIPT_ID_KEY), frmInterview.INPUTMODE_ID_KEY, CInt(QMS.qmsInputMode.TEST))
                hlScriptTriggers.NavigateUrl = String.Format("scripttriggers.aspx?{0}={1}", frmScriptTriggers.SCRIPT_ID_KEY, ViewState(SCRIPT_ID_KEY))
                hlPrint.NavigateUrl = String.Format("printscript.aspx?{0}={1}", frmPrintScript.SCRIPT_ID_KEY, ViewState(SCRIPT_ID_KEY))

            End If
        End Set
    End Property

    Private Sub dgScriptScreens_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgScriptScreens.ItemDataBound
        Dim drv As DataRowView
        Dim hl As HyperLink
        Dim ddl As DropDownList
        Dim ddlValue As Integer

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            'set calculation type column
            CType(e.Item.FindControl("ltCalculationTypeName"), Literal).Text = drv.Row.GetParentRow("CalculationTypesScriptScreens").Item("Name")

            'set screen title
            CType(e.Item.FindControl("ltScreenTitle"), Literal).Text = String.Format("<b>{0}</b><br><i>{1}</i>", drv.Item("Title"), drv.Item("Text"))

            'set item order column
            ddl = CType(e.Item.FindControl("ddlItemOrder"), DropDownList)
            ddlValue = drv("ItemOrder")
            DMI.WebFormTools.GetSortOrderList(ddl, ddlValue, m_oScripts.ScriptScreensTable.Rows.Count)

            'set detail hyperlink
            hl = CType(e.Item.FindControl("hlNavigateDetails"), HyperLink)
            hl.NavigateUrl = String.Format("scriptscreendetails.aspx?{0}={1}&{2}={3}", frmScriptScreenScreenDetails.REQUEST_SCRIPT_SCREEN_ID_KEY, drv.Item("ScriptScreenID"), frmScriptScreenScreenDetails.REQUEST_SCRIPT_ID_KEY, ViewState(SCRIPT_ID_KEY))
        End If
    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        m_oScriptScreens.DataGridDelete(dgScriptScreens, ViewState(LAST_SORT_KEY).ToString)
        PageCleanUp()
    End Sub

End Class
