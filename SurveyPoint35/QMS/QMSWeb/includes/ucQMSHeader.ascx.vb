Partial  Class ucQMSHeader
    Inherits System.Web.UI.UserControl
    Protected WithEvents hlMenuDataInput As System.Web.UI.WebControls.HyperLink
    Protected WithEvents hlMenuDesign As System.Web.UI.WebControls.HyperLink
    Protected WithEvents hlMenuAdmin As System.Web.UI.WebControls.HyperLink

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
    Private m_sAppPath As String
    Private m_sIncludesPath As String
    Public m_sImagesPath As String
    Private sbMainMenu As StringBuilder
    Private sbSubMenus As StringBuilder
    Private sbSubMenuDataInput As StringBuilder
    Private sbSubMenuDesign As StringBuilder
    Private sbSubMenuAdmin As StringBuilder
    Private Const DATAINPUT_MENUID As String = "QMSMenu_1"
    Private Const DESIGN_MENUID As String = "QMSMenu_2"
    Private Const ADMIN_MENUID As String = "QMSMenu_3"
    Public mstrHideMenusStyle As String = "block"

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_sAppPath = Page.Request.ApplicationPath()
        If (m_sAppPath.Length > 0 AndAlso m_sAppPath.EndsWith("/")) Then
            m_sAppPath = m_sAppPath.Substring(0, m_sAppPath.Length - 1)
        End If
        m_sIncludesPath = String.Format("{0}/includes", m_sAppPath)
        m_sImagesPath = String.Format("{0}/images", m_sAppPath)
        'TP 20090921
        Dim arl As ArrayList
        arl = CType(Session(frmLogin.PRIVLEDGES_SESSION_KEY), ArrayList)
        If LCase(Page.Request.CurrentExecutionFilePath).IndexOf("respondentdetails.aspx") >= 0 AndAlso QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.RESPONDENT_ADMIN) = False Then
            mstrHideMenusStyle = "none"
        End If

        If Not Page.IsPostBack Then
            InitStringBuilders()
            SetHeader()
            SetSubMenus()
            FinalizeStringBuilders()

        End If


    End Sub

    Private Sub InitStringBuilders()
        sbMainMenu = New StringBuilder()
        sbSubMenus = New StringBuilder()
        sbSubMenuDataInput = New StringBuilder()
        sbSubMenuDesign = New StringBuilder()
        sbSubMenuAdmin = New StringBuilder()

    End Sub

    Private Sub FinalizeStringBuilders()
        sbMainMenu = Nothing
        sbSubMenus = Nothing
        sbSubMenuDataInput = Nothing
        sbSubMenuDesign = Nothing
        sbSubMenuAdmin = Nothing

    End Sub

    Private Sub SetHeader()
        Dim arl As ArrayList 'holds privledges array

        'set javascript src file
        ltMenuScriptSrc.Text = String.Format("<script language=""JavaScript"" src=""{0}/ig_webmenu2.js""></script>", m_sIncludesPath)

        'check privledges arraylist from sign in
        If Not IsNothing(Session(frmLogin.PRIVLEDGES_SESSION_KEY)) Then
            arl = CType(Session(frmLogin.PRIVLEDGES_SESSION_KEY), ArrayList)

            If arl.Count > 0 Then
                'Data Input Menu
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.DATA_ENTRY) Then
                    AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "1", "Data&nbsp;Entry", "/respondents/getrespondent.aspx?input=1")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.VERIFICATION) Then
                    AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "2", "Verification", "/respondents/getrespondent.aspx?input=2")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.CATI) Then
                    AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "3", "Reminder&nbsp;Calls", "/operations/calllist.aspx?input=4")
                    AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "4", "CATI", "/operations/calllist.aspx?input=3")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.BATCHER) Then
                    AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "5", "Batching", "/batching/batchlogging.aspx")
                    AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "6", "Batch&nbsp;Search", "/batching/batches.aspx")

                End If

                AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "7", "Respondent Search", "/respondents/respondents.aspx")
                AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "8", "View&nbsp;Respondent", "/respondents/getrespondent.aspx?input=0")
                AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "9", "Appointments", "/operations/appointments.aspx")

                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.EXPORT_ACCESS) Then
                    AddMenuItem(sbSubMenuDataInput, DATAINPUT_MENUID, "11", "Set Template Info", "/operations/settemplateinfo.aspx")
                End If

                'Design Menu
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.SURVEY_VIEWER) Then
                    AddMenuItem(sbSubMenuDesign, DESIGN_MENUID, "1", "Questions", "/questionbank/questionbank.aspx")
                    AddMenuItem(sbSubMenuDesign, DESIGN_MENUID, "2", "Surveys", "/surveys/surveys.aspx")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.SCRIPT_VIEWER) Then
                    AddMenuItem(sbSubMenuDesign, DESIGN_MENUID, "3", "Scripts", "/scripts/scripts.aspx")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.PROTOCOL_VIEWER) Then
                    AddMenuItem(sbSubMenuDesign, DESIGN_MENUID, "4", "Protocols", "/protocols/protocols.aspx")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.EVENT_VIEWER) Then
                    AddMenuItem(sbSubMenuDesign, DESIGN_MENUID, "5", "Events", "/events/events.aspx")
                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.EXPORT_ACCESS) Then
                    AddMenuItem(sbSubMenuDesign, DESIGN_MENUID, "6", "Import/Export", "/filedefinitions/filedefinitions.aspx")
                    AddMenuItem(sbSubMenuDesign, DESIGN_MENUID, "7", "Templates", "/filedefinitions/templates.aspx")
                    'TP 20090910 Take out for now as nobody is using.
                    'AddMenuItem(sbSubMenuDesign, DESIGN_MENUID, "8", "Triggers", "/operations/triggers.aspx")
                End If

                'Admin Menu
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.CLIENT_VIEWER) Then
                    AddMenuItem(sbSubMenuAdmin, ADMIN_MENUID, "1", "Clients", "/clients/clients.aspx")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.INSTANCE_VIEWER) Then
                    AddMenuItem(sbSubMenuAdmin, ADMIN_MENUID, "2", "Survey Instances", "/surveyinstances/surveyinstances.aspx")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.USER_VIEWER) Then
                    AddMenuItem(sbSubMenuAdmin, ADMIN_MENUID, "3", "Users", "/users/users.aspx")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.USERGROUP_VIEWER) Then
                    AddMenuItem(sbSubMenuAdmin, ADMIN_MENUID, "4", "User Groups", "/users/usergroups.aspx")

                End If
                If QMS.clsQMSSecurity.CheckPrivledge(arl, QMS.qmsSecurity.EVENTLOG_VIEWER) Then
                    AddMenuItem(sbSubMenuAdmin, ADMIN_MENUID, "5", "Event Log", "/events/eventlog.aspx")

                End If

                SetTopMenu()

                Exit Sub

            End If

        End If

        'User has no privledges, sign out of system
        SignOutUser()

    End Sub

    Private Sub SetTopMenu()

        sbMainMenu.AppendFormat("<table border='0' cellpadding='0' cellspacing='0' id='QMSMenu_MainM' onselectstart=""igmenu_selectStart();"" onmouseover=""igmenu_mouseover(this, event);"" onmouseout=""igmenu_mouseout(this, event);"" onmousedown=""igmenu_mousedown(this, event);"" onmouseup=""igmenu_mouseup(this, event);"">{0}", vbCrLf)

        'determine which top menu items to display
        If sbSubMenuDataInput.Length > 0 Then AddTopMenuItem(DATAINPUT_MENUID, "operations-button.gif")
        If sbSubMenuDesign.Length > 0 Then AddTopMenuItem(DESIGN_MENUID, "design-button.gif")
        If sbSubMenuAdmin.Length > 0 Then AddTopMenuItem(ADMIN_MENUID, "admin-button.gif")

        sbMainMenu.Append("</tr></table>")

        ltMainMenu.Text = sbMainMenu.ToString

    End Sub

    Private Sub SetSubMenus()
        'determine which submenus to display
        If sbSubMenuDataInput.Length > 0 Then AddSubMenu(DATAINPUT_MENUID, sbSubMenuDataInput)
        If sbSubMenuDesign.Length > 0 Then AddSubMenu(DESIGN_MENUID, sbSubMenuDesign)
        If sbSubMenuAdmin.Length > 0 Then AddSubMenu(ADMIN_MENUID, sbSubMenuAdmin)

        ltSubMenus.Text = sbSubMenus.ToString

    End Sub

    Private Sub AddTopMenuItem(ByVal sName As String, ByVal sImageFile As String)

        sbMainMenu.AppendFormat("<td align='left' id='{0}' igTag='' igChildId='{0}M' igTop='1'><IMG id='img{0}' height='22' src='{2}/{1}'></td>", sName, sImageFile, m_sImagesPath, vbCrLf)
    End Sub

    Private Sub AddSubMenu(ByVal sName As String, ByVal sbMenuContents As StringBuilder)

        sbSubMenus.AppendFormat("<table border='0' cellpadding='2' cellspacing='0' id='{0}M' class='SubMenus' style='position:absolute; z-index:10000; visibility:hidden; display:none;' onselectstart='igmenu_selectStart();' onmouseover='igmenu_mouseover(this, event);' onmouseout='igmenu_mouseout(this, event);' onmousedown='igmenu_mousedown(this, event);' onmouseup='igmenu_mouseup(this, event);' igLevel='1'>", sName)
        sbSubMenus.Append(sbMenuContents.ToString)
        sbSubMenus.Append("</table>")

    End Sub

    Private Sub AddMenuItem(ByVal sb As StringBuilder, ByVal sMenuID As String, ByVal sMenuItemID As String, ByVal sName As String, ByVal sURL As String)

        sb.AppendFormat("<tr id='{0}_{1}' igTag='' igHov='MenuRollover' igUrl='{2}{3}'><td>&nbsp;</td><td>{4}</td><td>&nbsp;</td></tr>{5}", sMenuID, sMenuItemID, m_sAppPath, sURL, sName, vbCrLf)

    End Sub

    Private Sub SignOutUser()
        'check if user id is numeric
        If IsNumeric(HttpContext.Current.User.Identity.Name) Then
            'log sign out
            QMS.clsUsers.LogUserEvent(CInt(HttpContext.Current.User.Identity.Name), QMS.qmsEvents.USER_LOGOFF, Session.SessionID)

        End If

        'sign out user
        System.Web.Security.FormsAuthentication.SignOut()
        Session.Abandon()

        'bounce user back to page to force redirect to sign in page
        Response.Redirect(Request.Url.PathAndQuery)

    End Sub

    Private Sub lbSignOut_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbSignOut.Click
        SignOutUser()

    End Sub

End Class
