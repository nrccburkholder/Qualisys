Partial Class frmUserGroupDetails
    Inherits System.Web.UI.Page
    Protected WithEvents btnUpdateUser As System.Web.UI.WebControls.Button

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

    Private m_oUserGroup As QMS.clsUserGroups
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
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.USERGROUP_VIEWER) Then
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
        'identify entity id
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")

        Else
            'save viewstate for future id
            viewstate("id") = ""

        End If

        'get user data
        LoadDataSet()

        'setup privledge list control
        PrivledgesListSetup()

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oUserGroup) Then
            m_oUserGroup.Close()
            m_oUserGroup = Nothing
        End If

    End Sub

    Private Sub PrivledgesListSetup()
        Dim dr As SqlClient.SqlDataReader

        'get datareader for privledge list
        dr = m_oUserGroup.GetDRPrivledgesList(m_oConn)

        'add list to checkbox list control
        Do Until Not dr.Read
            cblGroupPrivledges.Items.Add(New ListItem(String.Format("<span class=""label"">{0}</span>: <span class=""privledge_desc"">{1}</span>", dr.Item("Name"), dr.Item("Description")), dr.Item("EventID")))

        Loop

        'clean up
        dr.Close()
        dr = Nothing

    End Sub

    Private Sub LoadDataSet()
        m_oUserGroup = New QMS.clsUserGroups(m_oConn)

        If IsNumeric(viewstate("id")) Then
            m_oUserGroup.FillAll(CInt(viewstate("id")), True)

        Else
            'new row
            m_oUserGroup.AddMainRow()


        End If
    End Sub

    Private Sub LoadDetailsForm()
        Dim drUserGroup As QMS.dsUserGroups.UserGroupsRow

        drUserGroup = CType(m_oUserGroup.MainDataTable.Rows(0), QMS.dsUserGroups.UserGroupsRow)

        'set user group id
        If drUserGroup.RowState = DataRowState.Added Then
            'new user, no user id
            lblUserGroupID.Text = "NEW"
        Else
            'existing user, display user id
            lblUserGroupID.Text = drUserGroup.GroupID
        End If

        tbGroupName.Text = drUserGroup.Name
        tbGroupDesc.Text = drUserGroup.Description
        tbVerificationRate.Text = drUserGroup.VerificationRate

        DMI.WebFormTools.SetListControl(cblGroupPrivledges, _
                    Me.m_oUserGroup.PrivledgesTable, "EventID")

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.USERGROUP_ADMIN) Then
            'must be user group administrator to edit users
            ibSave.Enabled = False

        End If

    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim drUserGroup As QMS.dsUserGroups.UserGroupsRow
        Dim li As ListItem

        If Page.IsValid Then
            drUserGroup = CType(m_oUserGroup.MainDataTable.Rows(0), QMS.dsUserGroups.UserGroupsRow)

            'copy form values to datarow
            drUserGroup.Name = tbGroupName.Text
            drUserGroup.Description = tbGroupDesc.Text
            drUserGroup.VerificationRate = CInt(tbVerificationRate.Text)
            drUserGroup.KeyMonitorRate = 100

            'commit changes to database
            m_oUserGroup.Save()

            If m_oUserGroup.ErrMsg.Length = 0 Then
                'update user id display and search row
                lblUserGroupID.Text = drUserGroup.GroupID.ToString
                viewstate("id") = drUserGroup.GroupID

                'loop thru privledge list and set privledges
                For Each li In cblGroupPrivledges.Items
                    m_oUserGroup.Privledges(CInt(li.Value)) = li.Selected

                Next
                'commit privledges changes to database
                m_oUserGroup.SavePrivledges()

            End If
            If m_oUserGroup.ErrMsg.Length > 0 Then
                'display error
                DMI.WebFormTools.Msgbox(Page, m_oUserGroup.ErrMsg)

            End If

        End If

        PageCleanUp()

    End Sub

End Class
