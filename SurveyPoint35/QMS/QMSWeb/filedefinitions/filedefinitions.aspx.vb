Option Strict On

Partial Class frmFileDefinitions
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

    Private m_oFileDefs As QMS.clsFileDefs
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String
    Public m_iProtocolStepID As Integer

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_oFileDefs = New QMS.clsFileDefs(m_oConn)
            m_sDSName = Request.Url.AbsolutePath
            Session.Remove("ds")

            'Determine whether page setup is required:
            'FileDef has posted back to same page
            If Not Page.IsPostBack Then PageLoad()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitions), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.IMPORT_ACCESS) Or _
            QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EXPORT_ACCESS) Then
            'run page setup
            PageSetup()
            'check for querystring search settings
            QueryStringSearch()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanUp()

        Else
            'FileDef does not have FileDef viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'setup sort variable
        ViewState("LastSort") = "SurveyID, ClientID, FileDefTypeID, FileTypeID, FileDefName"
        ViewState("search") = ""

        'fill main table
        BuildSearch()
        LoadDataSet()

        'format datagrid
        dgFileDefs.DataKeyField = "FileDefID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgFileDefs)
        FileDefsGridBind()

        'setup client dropdownlists
        sqlDR = QMS.clsClients.GetClientList(m_oConn)
        ddlSearchClientID.DataSource = sqlDR
        ddlSearchClientID.DataTextField = "Name"
        ddlSearchClientID.DataValueField = "ClientID"
        ddlSearchClientID.DataBind()
        ddlSearchClientID.Items.Insert(0, New ListItem("All Clients", "0"))
        sqlDR.Close()

        'setup survey dropdownlists
        sqlDR = QMS.clsSurveys.GetSurveyList(m_oConn)
        ddlSearchSurveyID.DataSource = sqlDR
        ddlSearchSurveyID.DataTextField = "Name"
        ddlSearchSurveyID.DataValueField = "SurveyID"
        ddlSearchSurveyID.DataBind()
        ddlSearchSurveyID.Items.Insert(0, New ListItem("All Surveys", "0"))
        sqlDR.Close()

        'setup file def type dropdownlists
        sqlDR = QMS.clsFileDefs.GetFileDefTypeList(m_oConn)
        ddlSearchFileDefTypeID.DataSource = sqlDR
        ddlSearchFileDefTypeID.DataBind()
        ddlSearchFileDefTypeID.Items.Insert(0, New ListItem("All Types", "0"))
        sqlDR.Close()

        'setup file type dropdownlists
        sqlDR = QMS.clsFileDefs.GetFileTypeList(m_oConn)
        ddlSearchFileTypeID.DataSource = sqlDR
        ddlSearchFileTypeID.DataBind()
        ddlSearchFileTypeID.Items.Insert(0, New ListItem("All File Formats", "0"))
        sqlDR.Close()
        sqlDR = Nothing

        'format datagrid
        QMS.clsQMSTools.FormatQMSDataGrid(dgFileDefs)

    End Sub

    Private Sub QueryStringSearch()
        If IsNumeric(Request.QueryString("sid")) Then ddlSearchSurveyID.SelectedIndex = ddlSearchSurveyID.Items.IndexOf(ddlSearchSurveyID.Items.FindByValue(Request.QueryString("sid").ToString))
        If IsNumeric(Request.QueryString("cid")) Then ddlSearchClientID.SelectedIndex = ddlSearchClientID.Items.IndexOf(ddlSearchClientID.Items.FindByValue(Request.QueryString("cid").ToString))
        If IsNumeric(Request.QueryString("fdtid")) Then ddlSearchFileDefTypeID.SelectedIndex = ddlSearchFileDefTypeID.Items.IndexOf(ddlSearchFileDefTypeID.Items.FindByValue(Request.QueryString("fdtid").ToString))
        If IsNumeric(Request.QueryString("ftid")) Then ddlSearchFileTypeID.SelectedIndex = ddlSearchFileDefTypeID.Items.IndexOf(ddlSearchFileTypeID.Items.FindByValue(Request.QueryString("ftid").ToString))
        If IsNumeric(Request.QueryString("psid")) Then m_iProtocolStepID = CInt(Request.QueryString("psid").ToString)

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oFileDefs) Then
            m_oFileDefs.Close()
            m_oFileDefs = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        drCriteria = m_oFileDefs.RestoreSearch(ViewState("search").ToString, m_sDSName)
        m_oFileDefs.FillFileDefTypes()
        m_oFileDefs.FillFileTypes()
        m_oFileDefs.FillClients(drCriteria)
        m_oFileDefs.FillSurveys(drCriteria)
        m_oFileDefs.FillMain(drCriteria)

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsFileDefs.SearchRow = CType(m_oFileDefs.NewSearchRow, QMS.dsFileDefs.SearchRow)

        If ddlSearchSurveyID.SelectedIndex > 0 Then dr.SurveyID = CInt(ddlSearchSurveyID.SelectedItem.Value)
        If ddlSearchClientID.SelectedIndex > 0 Then dr.ClientID = CInt(ddlSearchClientID.SelectedItem.Value)
        If ddlSearchFileDefTypeID.SelectedIndex > 0 Then dr.FileDefTypeID = CInt(ddlSearchFileDefTypeID.SelectedItem.Value)
        If ddlSearchFileTypeID.SelectedIndex > 0 Then dr.FileTypeID = CInt(ddlSearchFileTypeID.SelectedItem.Value)
        If tbSearchFileDefID.Text.Length > 0 Then dr.FileDefID = CInt(tbSearchFileDefID.Text)
        If tbSearchKeyword.Text.Length > 0 Then dr.Keyword = String.Format("%{0}%", tbSearchKeyword.Text)

        ViewState("search") = m_oFileDefs.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.IMPORT_ACCESS) And _
            Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.IMPORT_ACCESS) Then
            hlAdd.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub FileDefsGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oFileDefs.DataGridBind(dgFileDefs, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} File Definitions", iRowCount)

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        Try
            LoadDataSet()
            m_oFileDefs.DataGridDelete(dgFileDefs, ViewState("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitions), "ibDelete_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgFileDefs_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgFileDefs.SortCommand
        Try
            LoadDataSet()
            ViewState("LastSort") = m_oFileDefs.DataGridSort(dgFileDefs, e, ViewState("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitions), "dgFileDefs_SortCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgFileDefs_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgFileDefs.PageIndexChanged
        Try
            LoadDataSet()
            m_oFileDefs.DataGridPageChange(dgFileDefs, e, ViewState("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitions), "dgFileDefs_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Try
            If Page.IsValid Then
                BuildSearch()
                LoadDataSet()
                dgFileDefs.CurrentPageIndex = 0
                FileDefsGridBind()
                PageCleanUp()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitions), "btnSearch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgFileDefs_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgFileDefs.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            If IsNothing(drv.Row.GetParentRow("SurveysFileDefs")) Then
                CType(e.Item.FindControl("ltSurveyName"), Literal).Text = "NONE"
            Else
                CType(e.Item.FindControl("ltSurveyName"), Literal).Text = drv.Row.GetParentRow("SurveysFileDefs").Item("Name").ToString
            End If

            If IsNothing(drv.Row.GetParentRow("ClientsFileDefs")) Then
                CType(e.Item.FindControl("ltClientName"), Literal).Text = "NONE"
            Else
                CType(e.Item.FindControl("ltClientName"), Literal).Text = drv.Row.GetParentRow("ClientsFileDefs").Item("Name").ToString
            End If

            CType(e.Item.FindControl("ltTypeName"), Literal).Text = drv.Row.GetParentRow("FileDefTypesFileDefs").Item("FileDefTypeName").ToString
            CType(e.Item.FindControl("ltFormatName"), Literal).Text = drv.Row.GetParentRow("FileTypesFileDefs").Item("FileTypeName").ToString

        End If

    End Sub

End Class
