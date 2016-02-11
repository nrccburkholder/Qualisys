Partial Class frmUserGroups
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

    Private m_oUserGroups As QMS.clsUserGroups
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

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
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.USERGROUP_VIEWER) Then
            'run page setup
            PageSetup()
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
        Viewstate("LastSort") = "Name"
        'fill main table
        LoadDataSet()
        'setup datagrid
        dgUserGroups.DataKeyField = "GroupID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgUserGroups)
        UserGroupsGridBind()

    End Sub

    Private Sub PageCleanup()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oUserGroups) Then
            m_oUserGroups.Close()
            m_oUserGroups = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        m_oUserGroups = New QMS.clsUserGroups(m_oConn)
        m_oUserGroups.FillMain()

    End Sub

    Sub UserGroupsGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oUserGroups.DataGridBind(dgUserGroups, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} User Groups", iRowCount)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.USERGROUP_ADMIN) Then
            'must be user group administrator to add or delete user groups
            hlAddUserGroup.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub dgUserGroups_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgUserGroups.SortCommand
        Viewstate("LastSort") = m_oUserGroups.DataGridSort(dgUserGroups, e, Viewstate("LastSort").ToString)
        PageCleanup()

    End Sub

    Private Sub dgUserGroups_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgUserGroups.PageIndexChanged
        m_oUserGroups.DataGridPageChange(dgUserGroups, e, viewstate("LastSort").ToString)
        PageCleanup()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        m_oUserGroups.DataGridDelete(dgUserGroups, viewstate("LastSort").ToString)
        PageCleanup()

    End Sub

End Class
