Option Strict On
Option Explicit On 

Partial Class frmSurveyInstances
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

    Private m_oSurveyInstances As QMS.clsSurveyInstances
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oSurveyInstances = New QMS.clsSurveyInstances(m_oConn)
        m_sDSName = Request.Url.AbsolutePath

        'Determine whether page setup is required:
        'SurveyInstance has posted back to same page
        If Not Page.IsPostBack Then PageLoad()

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.INSTANCE_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanUp()

        Else
            'SurveyInstance does not have SurveyInstance viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'setup sort variable
        ViewState("LastSort") = "Active DESC, SurveyInstanceID"
        ViewState("search") = ""

        'setup page controls
        sqlDR = QMS.clsClients.GetClientList(m_oConn)
        ddlClientIDSearch.DataSource = sqlDR
        ddlClientIDSearch.DataTextField = "Name"
        ddlClientIDSearch.DataValueField = "ClientID"
        ddlClientIDSearch.DataBind()
        ddlClientIDSearch.Items.Insert(0, New ListItem("Select Client", "0"))
        sqlDR.Close()

        sqlDR = QMS.clsSurveys.GetSurveyList(m_oConn)
        ddlSurveyIDSearch.DataSource = sqlDR
        ddlSurveyIDSearch.DataTextField = "Name"
        ddlSurveyIDSearch.DataValueField = "SurveyID"
        ddlSurveyIDSearch.DataBind()
        ddlSurveyIDSearch.Items.Insert(0, New ListItem("Select Survey", "0"))
        sqlDR.Close()
        sqlDR = Nothing

        'format datagrid
        dgSurveyInstances.DataKeyField = "SurveyInstanceID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgSurveyInstances)

        QueryStringSearch()

        'fill main table
        BuildSearch()
        LoadDataSet()
        SurveyInstancesGridBind()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oSurveyInstances) Then
            m_oSurveyInstances.Close()
            m_oSurveyInstances = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        drCriteria = m_oSurveyInstances.RestoreSearch(ViewState("search").ToString, m_sDSName)
        m_oSurveyInstances.FillMain(drCriteria)

    End Sub

    Private Sub QueryStringSearch()
        Dim iClientID As Integer
        Dim iSurveyID As Integer
        Dim bSearch As Boolean = False

        If IsNumeric(Request.QueryString("sid")) Then
            iSurveyID = Integer.Parse(Request.QueryString("sid"))
            ddlSurveyIDSearch.SelectedIndex = ddlSurveyIDSearch.Items.IndexOf(ddlSurveyIDSearch.Items.FindByValue(iSurveyID.ToString))
            bSearch = True

        End If

        If IsNumeric(Request.QueryString("cid")) Then
            iClientID = Integer.Parse(Request.QueryString("cid"))
            ddlClientIDSearch.SelectedIndex = ddlClientIDSearch.Items.IndexOf(ddlClientIDSearch.Items.FindByValue(iSurveyID.ToString))
            bSearch = True

        End If

        If bSearch Then dgSurveyInstances.CurrentPageIndex = 0

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.INSTANCE_ADMIN) Then
            'must be instance administrator to edit instance events
            hlAdd.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsSurveyInstances.SearchRow

        dr = CType(m_oSurveyInstances.NewSearchRow, QMS.dsSurveyInstances.SearchRow)

        If IsNumeric(tbSurveyInstanceID.Text) Then dr.SurveyInstanceID = CInt(tbSurveyInstanceID.Text)
        If ddlClientIDSearch.SelectedIndex > 0 Then dr.ClientID = CInt(ddlClientIDSearch.SelectedItem.Value)
        If ddlSurveyIDSearch.SelectedIndex > 0 Then dr.SurveyID = CInt(ddlSurveyIDSearch.SelectedItem.Value)
        If tbKeywordSearch.Text <> "" Then dr.Name = String.Format("%{0}%", tbKeywordSearch.Text)
        If ddlActive.SelectedIndex > 0 Then dr.Active = CByte(ddlActive.SelectedValue)

        ViewState("search") = m_oSurveyInstances.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub SurveyInstancesGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oSurveyInstances.DataGridBind(dgSurveyInstances, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} SurveyInstances", iRowCount)

    End Sub

    Private Sub dgSurveyInstances_PageIndexChanged(ByVal source As System.Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgSurveyInstances.PageIndexChanged
        LoadDataSet()
        m_oSurveyInstances.DataGridPageChange(dgSurveyInstances, e, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgSurveyInstances_SortCommand(ByVal source As System.Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgSurveyInstances.SortCommand
        LoadDataSet()
        Viewstate("LastSort") = m_oSurveyInstances.DataGridSort(dgSurveyInstances, e, Viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub btnSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        BuildSearch()
        LoadDataSet()
        dgSurveyInstances.CurrentPageIndex = 0
        SurveyInstancesGridBind()
        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        LoadDataSet()
        m_oSurveyInstances.DataGridDelete(dgSurveyInstances, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgSurveyInstances_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgSurveyInstances.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)
            'set survey name column
            CType(e.Item.FindControl("ltActive"), Literal).Text = IIf(CByte(drv.Item("Active")) = 1, "Yes", "No").ToString

        End If

    End Sub
End Class
