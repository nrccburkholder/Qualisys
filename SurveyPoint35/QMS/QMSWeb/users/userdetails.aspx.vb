Partial Class frmUserDetails
    Inherits System.Web.UI.Page
    Protected WithEvents cuvUsername As System.Web.UI.WebControls.CustomValidator

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

    Private m_oUser As QMS.clsUsers
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

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
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.USER_VIEWER) Then
            PageSetup()
            LoadDetailsForm()
            SecuritySetup()
            PageCleanUp()

        Else
            'user does not have user viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'set up search row
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")

        Else
            'save viewstate for future id
            viewstate("id") = ""

        End If

        'get user data
        LoadDataSet()

        'set up user group dropdown list
        sqlDR = QMS.clsUserGroups.GetUserGroupsDataSource(m_oConn)
        ddlUserGroups.DataSource = sqlDR
        ddlUserGroups.DataTextField = "Name"
        ddlUserGroups.DataValueField = "GroupID"
        ddlUserGroups.DataBind()
        ddlUserGroups.Items.Insert(0, New ListItem("Select a Group", "0"))
        sqlDR.Close()
        sqlDR = Nothing

    End Sub

    Private Sub LoadDataSet()
        m_oUser = New QMS.clsUsers(m_oConn)

        If IsNumeric(viewstate("id")) Then
            m_oUser.FillAll(CInt(viewstate("id")), False)

        Else

            m_oUser.AddMainRow()

        End If

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oUser) Then
            m_oUser.Close()
            m_oUser = Nothing
        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim drUser As QMS.dsUsers.UsersRow

        drUser = CType(m_oUser.MainDataTable.Rows(0), QMS.dsUsers.UsersRow)

        'set user id
        If drUser.RowState = DataRowState.Added Then
            'new user, no user id
            lblUserID.Text = "NEW"
            rfvPassword.Enabled = True
        Else
            'existing user, display user id
            lblUserID.Text = drUser.UserID
            rfvPassword.Enabled = False
        End If

        'set other fields
        tbUsername.Text = drUser.Username
        tbFirstName.Text = drUser.FirstName
        tbLastName.Text = drUser.LastName
        tbPassword.Text = ""
        ddlUserGroups.SelectedIndex = _
            ddlUserGroups.Items.IndexOf(ddlUserGroups.Items.FindByValue(drUser.GroupID))
        tbEmail.Text = drUser.Email
        cbActive.Checked = CBool(IIf(drUser.Active = 1, True, False))
        If Not drUser.IsVerificationRateNull Then tbVerificationRate.Text = drUser.VerificationRate

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.USER_ADMIN) Then
            'must be user administrator to edit users
            ibSave.Enabled = False

        End If

    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim drUser As QMS.dsUsers.UsersRow

        If Page.IsValid Then

            drUser = CType(m_oUser.MainDataTable.Rows(0), QMS.dsUsers.UsersRow)

            'set other fields
            drUser.Username = tbUsername.Text
            drUser.FirstName = tbFirstName.Text
            drUser.LastName = tbLastName.Text
            If tbPassword.Text.Length > 0 Then drUser.Password = m_oUser.EncryptPassword(tbPassword.Text)
            drUser.GroupID = CInt(ddlUserGroups.SelectedItem.Value)
            drUser.Email = tbEmail.Text
            drUser.Active = CInt(IIf(cbActive.Checked, 1, 0))
            If tbVerificationRate.Text.Length > 0 Then
                drUser.VerificationRate = CInt(tbVerificationRate.Text)
            Else
                drUser.SetVerificationRateNull()
            End If
            drUser.SetKeyMonitorRateNull()

            'commit changes to database
            m_oUser.Save()

            If m_oUser.ErrMsg.Length = 0 Then
                'update user id display and search row
                lblUserID.Text = drUser.UserID
                viewstate("id") = drUser.UserID

                'clear password fields, and turn off password requirement
                tbPassword.Text = ""
                tbVerify.Text = ""
                rfvPassword.Enabled = False

            Else
                'display error
                DMI.WebFormTools.Msgbox(Page, m_oUser.ErrMsg)

            End If

        End If

        PageCleanUp()

    End Sub

End Class
