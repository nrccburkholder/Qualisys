Partial Class frmUsers
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

    Private m_oUsers As QMS.clsUsers
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oUsers = New QMS.clsUsers(m_oConn)
        m_sDSName = Request.Url.AbsolutePath
        'Determine whether page setup is required:
        'user has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()

        Else
            LoadDataSet()

        End If

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.USER_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanUp()

        Else
            'user does not have user viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        'setup sort variable
        ViewState("LastSort") = "Active DESC, Username"
        ViewState("search") = ""
        BuildSearch()
        'fill main table
        LoadDataSet()
        'setup datagrid
        dgUsers.DataKeyField = "UserID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgUsers)
        UsersGridBind()

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsUsers.SearchRow
        dr = CType(m_oUsers.NewSearchRow, QMS.dsUsers.SearchRow)
        If cbActive.Checked Then dr.Active = 1
        ViewState("search") = m_oUsers.SaveSearch(dr, m_sDSName)
    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oUsers) Then
            m_oUsers.Close()
            m_oUsers = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        drCriteria = m_oUsers.RestoreSearch(ViewState("search").ToString, m_sDSName)

        'm_oUsers = New QMS.clsUsers(m_oConn)
        m_oUsers.FillMain(drCriteria)

    End Sub

    Private Sub UsersGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oUsers.DataGridBind(dgUsers, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} Users", iRowCount)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.USER_ADMIN) Then
            'must be user administrator to add or delete users
            hlAddUser.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub dgUsers_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgUsers.SortCommand
        LoadDataSet()
        ViewState("LastSort") = m_oUsers.DataGridSort(dgUsers, e, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgUsers_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgUsers.PageIndexChanged
        LoadDataSet()
        m_oUsers.DataGridPageChange(dgUsers, e, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        LoadDataSet()
        m_oUsers.DataGridDelete(dgUsers, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSearch.Click
        BuildSearch()
        LoadDataSet()
        dgUsers.CurrentPageIndex = 0
        UsersGridBind()
        PageCleanUp()
    End Sub
End Class
