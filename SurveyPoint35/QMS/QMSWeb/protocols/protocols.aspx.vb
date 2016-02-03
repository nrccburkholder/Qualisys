Partial Class frmProtocols
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

    Private m_oProtocols As QMS.clsProtocols
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oProtocols = New QMS.clsProtocols(m_oConn)
        m_sDSName = Request.Url.AbsolutePath

        'Determine whether page setup is required:
        'user has posted back to same page
        If Not Page.IsPostBack Then PageLoad()

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.PROTOCOL_VIEWER) Then
            'run page setup
            PageSetup()
            'set data source and bind grid
            ProtocolsGridBind("Name")
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanup()

        Else
            'user does not have user viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        'setup sort variable
        Viewstate("LastSort") = ""
        'format datagrid
        dgProtocols.DataKeyField = "ProtocolID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgProtocols)
        'fill main table
        BuildSearch()
        LoadDataSet()

    End Sub

    Private Sub PageCleanup()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oProtocols) Then
            m_oProtocols.Close()
            m_oProtocols = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        drCriteria = m_oProtocols.RestoreSearch(ViewState("search").ToString, m_sDSName)
        m_oProtocols.FillUsers()
        m_oProtocols.FillMain(drCriteria)

    End Sub

    Private Sub SecuritySetup()

        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.PROTOCOL_DESIGNER) Then
            'must be protocol designer to add and delete protocols
            hlAdd.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub ProtocolsGridBind(Optional ByVal sSortBy As String = "")
        Dim iRowCount As Integer

        ViewState("LastSort") = sSortBy
        iRowCount = m_oProtocols.DataGridBind(dgProtocols, sSortBy)
        ltResultsFound.Text = String.Format("{0} Protocols", iRowCount)

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsProtocols.SearchRow

        dr = CType(m_oProtocols.NewSearchRow, QMS.dsProtocols.SearchRow)

        If tbProtocolID.Text.Length > 0 Then dr.ProtocolID = CInt(tbProtocolID.Text)
        If tbKeyword.Text.Length > 0 Then dr.Keyword = String.Format("%{0}%", tbKeyword.Text)

        ViewState("search") = m_oProtocols.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub QueryStringSearch()
        Dim bSearch As Boolean = False

        If IsNumeric(Request.QueryString("pid")) Then
            tbProtocolID.Text = Request.QueryString("pid")
            bSearch = True

        End If

    End Sub

    Private Sub dgProtocols_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgProtocols.SortCommand
        LoadDataSet()
        Viewstate("LastSort") = m_oProtocols.DataGridSort(dgProtocols, e, Viewstate("LastSort").ToString)
        PageCleanup()

    End Sub

    Private Sub dgProtocols_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgProtocols.PageIndexChanged
        LoadDataSet()
        m_oProtocols.DataGridPageChange(dgProtocols, e, viewstate("LastSort").ToString)
        PageCleanup()

    End Sub

    Private Sub btSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btSearch.Click
        If Page.IsValid Then
            dgProtocols.CurrentPageIndex = 0
            BuildSearch()

        End If

        LoadDataSet()
        ProtocolsGridBind()

    End Sub

    Private Sub dgProtocols_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgProtocols.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            'set Protocol name column
            CType(e.Item.FindControl("ltProtocolName"), Literal).Text = String.Format("<b>{0}</b><br>{1}", drv.Item("Name"), drv.Item("Description"))

            'set author name column
            CType(e.Item.FindControl("ltAuthorName"), Literal).Text = drv.Row.GetParentRow("UsersProtocols").Item("Username")

        End If

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        LoadDataSet()
        m_oProtocols.DataGridDelete(dgProtocols, viewstate("LastSort").ToString)
        PageCleanup()

    End Sub

End Class
