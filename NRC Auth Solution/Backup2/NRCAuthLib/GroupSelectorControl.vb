Imports System.ComponentModel
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Drawing.Design
Imports Microsoft.Web.UI.WebControls

<Obsolete("This class was never tested and put into use.", True), ToolboxData("<{0}:GroupSelectorControl runat=server></{0}:GroupSelectorControl>")> _
Public Class GroupSelectorControl
    Inherits System.Web.UI.WebControls.WebControl
    Implements INamingContainer

#Region " Private/Protected Members "
    Protected WithEvents OrgUnitTree As Microsoft.Web.UI.WebControls.TreeView
    Protected WithEvents SelectorTable As Table
    Protected WithEvents GroupListHolder As PlaceHolder
    Protected WithEvents SelectedOU As HtmlControls.HtmlInputHidden
    Protected WithEvents GroupList As RadioButtonList
    Private mUser As Member
    Private mApplicationName As String = "My Account"
    Private mNodeImageUrl As String
    Private mInstructionText As String = "Please select the group that you would like to use during your session."

#End Region

#Region " GroupSelected Event "
    Public Class GroupSelectedEventArgs
        Private mGroupId As Integer
        Public ReadOnly Property GroupId() As Integer
            Get
                Return mGroupId
            End Get
        End Property
        Public Sub New(ByVal selectedGroupId As Integer)
            mGroupId = selectedGroupId
        End Sub
    End Class
    Public Delegate Sub GroupSelectedEventHandler(ByVal sender As Object, ByVal e As GroupSelectedEventArgs)
    Public Event GroupSelected As GroupSelectedEventHandler
#End Region

#Region " Public Properties "
    <Bindable(True), Category("Behavior")> _
      Public Property ApplicationName() As String
        Get
            Return mApplicationName
        End Get
        Set(ByVal Value As String)
            mApplicationName = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance")> _
    Public Property NodeImageUrl() As String
        Get
            Return mNodeImageUrl
        End Get
        Set(ByVal Value As String)
            mNodeImageUrl = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance")> _
    Public Property InstructionText() As String
        Get
            Return mInstructionText
        End Get
        Set(ByVal Value As String)
            mInstructionText = Value
        End Set
    End Property
#End Region

#Region " Private Properties "
    Private ReadOnly Property ShowOrgUnitTree() As Boolean
        Get
            If (mUser.MemberType = Member.MemberTypeEnum.NRC_Admin OrElse mUser.MemberType = Member.MemberTypeEnum.Administrator OrElse mUser.MemberType = Member.MemberTypeEnum.Super_User) AndAlso mUser.OrgUnit.HasChildren Then
                Return True
            Else
                Return False
            End If
        End Get
    End Property

    Private ReadOnly Property IsIE6() As Boolean
        Get
            If Page.Request.Browser.Browser.ToUpper = "IE" AndAlso CType(Page.Request.Browser.Version, Decimal) >= 6 Then
                Return True
            Else
                Return False
            End If
        End Get
    End Property

#End Region

#Region " Control Events "
    Private Sub GroupSelectorControl_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Init
        If Page.User.Identity.IsAuthenticated Then
            'Initialize the dynamic child controls 
            InitializeControls(Me.Controls)
        End If
    End Sub

    Private Sub GroupSelectorControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'The first time we load...
        If Not Page.IsPostBack Then
            'If a member has access to many orgunits then build an org unit tree.
            If ShowOrgUnitTree Then
                'Build the inital org tree and populate groups for the root
                BuildOrgUnitTree()
                Dim node As Microsoft.Web.UI.WebControls.TreeNode = Me.OrgUnitTree.GetNodeFromIndex(Me.OrgUnitTree.SelectedNodeIndex)
                Dim orgUnitId As Integer = Integer.Parse(node.NodeData)
                PopulateOrgUnitGroups(orgUnitId)
            Else
                'Just populate groups that this member has access to
                PopulateMemberGroups()
            End If
        End If
    End Sub

    Private Sub LinkClick(ByVal sender As Object, ByVal e As EventArgs)
        Dim lnk As LinkButton
        Dim groupId As Integer

        If TypeOf sender Is LinkButton Then
            'Get the link button and the group id
            lnk = DirectCast(sender, LinkButton)
            groupId = CType(lnk.CommandArgument, Integer)

            'Set the selected group cookie
            'FormsAuth.SessionUserData = New FormsAuth.UserData(Me.mUser.GetWebRoles(groupId), groupId)
            'FormsAuth.ResetAuthCookie(groupId, mUser.GetWebRoles(groupId))
        End If

        'Notify subscribers that the selected group has been changed
        RaiseEvent GroupSelected(Me, New GroupSelectedEventArgs(CType(lnk.CommandArgument, Integer)))
    End Sub

    Private Sub OrgUnitTree_Expand(ByVal sender As Object, ByVal e As Microsoft.Web.UI.WebControls.TreeViewClickEventArgs) Handles OrgUnitTree.Expand
        'We will populate sub nodes only as the parents are expanded.  This should 
        'save a little in performance (?)
        Dim node As Microsoft.Web.UI.WebControls.TreeNode = Me.OrgUnitTree.GetNodeFromIndex(e.Node)

        node.Nodes.Clear()
        Dim ouId As Integer = Integer.Parse(node.NodeData)
        PopulateTree(node, OrgUnitCollection.GetOrgUnitChildren(ouId), 2)
    End Sub

    Private Sub OrgUnitTree_SelectedIndexChange(ByVal sender As Object, ByVal e As Microsoft.Web.UI.WebControls.TreeViewSelectEventArgs) Handles OrgUnitTree.SelectedIndexChange
        'Every time the selected tree node changes we need to repopulate the 
        'org unit group list for the new org unit
        Dim node As Microsoft.Web.UI.WebControls.TreeNode = Me.OrgUnitTree.GetNodeFromIndex(e.NewNode)
        Dim orgUnitId As Integer = Integer.Parse(node.NodeData)

        PopulateOrgUnitGroups(orgUnitId)
    End Sub

#End Region

#Region " Render Methods "
    Protected Overrides Sub Render(ByVal writer As System.Web.UI.HtmlTextWriter)
        Me.EnsureChildControls()

        'Render special content at design time...
        If System.Web.HttpContext.Current Is Nothing Then
            RenderDesignHtml(writer)
        Else
            MyBase.Render(writer)
        End If
    End Sub

    Private Sub RenderDesignHtml(ByVal writer As HtmlTextWriter)
        Me.Controls.Clear()
        Dim html As New System.Text.StringBuilder
        html.Append("<TABLE>")
        html.AppendFormat("<TR><TD>{0}</TD></TR>", mInstructionText)
        html.Append("<TR><TD><a href=''>Group 1</a></TD></TR>")
        html.Append("<TR><TD><a href=''>Group 2</a></TD></TR>")
        html.Append("<TR><TD><a href=''>Group 3</a></TD></TR>")
        html.Append("<TR><TD><a href=''>Group 4</a></TD></TR>")
        html.Append("</TABLE>")
        Me.Controls.Add(New LiteralControl(html.ToString))
        MyBase.Render(writer)
    End Sub
#End Region

#Region " Private Methods "
    Private Sub InitializeControls(ByVal ctrls As ControlCollection)
        'Initializes all of the controls and adds them to the control collection
        If mUser Is Nothing Then
            mUser = Member.GetMember(Page.User.Identity.Name)
        End If

        Dim td As TableCell
        Dim tr As TableRow

        SelectorTable = New Table
        SelectorTable.ID = "tblGroupSelector"
        SelectorTable.Width = Unit.Percentage(100)
        SelectorTable.BorderStyle = BorderStyle.None
        ctrls.Add(SelectorTable)

        tr = New TableRow
        td = New TableCell
        td.ColumnSpan = 2
        td.Controls.Add(New LiteralControl(mInstructionText))
        tr.Cells.Add(td)
        SelectorTable.Rows.Add(tr)

        tr = New TableRow
        td = New TableCell
        td.VerticalAlign = VerticalAlign.Top

        'Add the org tree only when appropriate
        If ShowOrgUnitTree Then
            td.Controls.Add(New LiteralControl("<STRONG>Organizational Units</STRONG><BR>"))
            OrgUnitTree = New Microsoft.Web.UI.WebControls.TreeView
            If IsIE6 Then
                OrgUnitTree.Width = Unit.Percentage(100)
            Else
                OrgUnitTree.Width = Unit.Pixel(350)
            End If
            OrgUnitTree.ImageUrl = mNodeImageUrl
            OrgUnitTree.DefaultStyle.Add("font-family", "Verdana, Arial, San Serif")
            OrgUnitTree.DefaultStyle.Add("font-size", "xx-small")
            OrgUnitTree.AutoPostBack = True
            OrgUnitTree.SelectExpands = True
            td.Controls.Add(OrgUnitTree)
        End If
        tr.Cells.Add(td)

        td = New TableCell
        td.VerticalAlign = VerticalAlign.Top
        td.Wrap = False
        td.Width = Unit.Percentage(100)
        If ShowOrgUnitTree Then
            td.Controls.Add(New LiteralControl("<STRONG>Available Groups</STRONG><BR>"))
        End If
        'GroupListHolder = New PlaceHolder
        'td.Controls.Add(GroupListHolder)
        GroupList = New RadioButtonList
        GroupList.ID = "GroupList"
        td.Controls.Add(GroupList)
        tr.Cells.Add(td)
        SelectorTable.Rows.Add(tr)

        'We need to add the group link buttons here or else the postbacks won't work
        'The hidden form input is used to store across requests which org unit is selected
        If ShowOrgUnitTree Then
            SelectedOU = New HtmlControls.HtmlInputHidden
            SelectedOU.ID = "SelectedOU"
            ctrls.Add(SelectedOU)

            If Page.IsPostBack Then
                If Not Page.Request.Form(SelectedOU.UniqueID) Is Nothing AndAlso Not Page.Request.Form(SelectedOU.UniqueID) = "" Then
                    Dim id As Integer = CType(Page.Request.Form(SelectedOU.UniqueID), Integer)
                    Me.PopulateOrgUnitGroups(id)
                End If
            End If
        Else
            If Page.IsPostBack Then
                PopulateMemberGroups()
            End If
        End If
    End Sub

#Region " Build Tree Methods "
    Private Sub BuildOrgUnitTree()
        Me.OrgUnitTree.Nodes.Clear()
        Dim root As New Microsoft.Web.UI.WebControls.TreeNode
        root.Text = mUser.OrgUnit.Name
        root.NodeData = mUser.OrgUnit.OrgUnitId.ToString
        PopulateTree(root, mUser.OrgUnit.OrgUnits, 2)
        root.Expanded = True
        Me.OrgUnitTree.Nodes.Add(root)
    End Sub

    Private Sub PopulateTree(ByVal root As Microsoft.Web.UI.WebControls.TreeNode, ByVal units As OrgUnitCollection, ByVal depth As Integer)
        Dim node As Microsoft.Web.UI.WebControls.TreeNode
        For Each ou As OrgUnit In units
            node = New Microsoft.Web.UI.WebControls.TreeNode

            node.Text = ou.Name
            node.NodeData = ou.OrgUnitId.ToString

            If ou.HasChildren AndAlso depth > 1 Then
                PopulateTree(node, ou.OrgUnits, depth - 1)
            End If

            root.Nodes.Add(node)
        Next

    End Sub

#End Region

#Region " Populate Groups Methods "
    'Private Sub PopulateOrgUnitGroups(ByVal orgUnitId As Integer)
    '    GroupListHolder.Controls.Clear()
    '    Dim groups As GroupCollection = GroupCollection.GetOrgUnitGroups(orgUnitId)
    '    Dim link As LinkButton
    '    Dim lit As LiteralControl

    '    For Each grp As Group In groups
    '        link = New LinkButton
    '        link.Text = grp.Name
    '        If Not grp.HasPrivilege(Me.mApplicationName) Then
    '            link.Enabled = False
    '            link.ToolTip = String.Format("This group does not have access to the {0} application", mApplicationName)
    '            link.Style.Add("Cursor", "hand")
    '        End If
    '        link.CommandArgument = grp.GroupId.ToString
    '        AddHandler link.Click, AddressOf LinkClick
    '        Me.GroupListHolder.Controls.Add(link)
    '        lit = New LiteralControl("<BR>")
    '        Me.GroupListHolder.Controls.Add(lit)
    '    Next

    '    SelectedOU.Value = orgUnitId.ToString
    'End Sub
    Private Sub PopulateOrgUnitGroups(ByVal orgUnitId As Integer)
        GroupListHolder.Controls.Clear()
        Dim groups As GroupCollection = GroupCollection.GetOrgUnitGroups(orgUnitId)
        Dim link As LinkButton
        Dim lit As LiteralControl

        For Each grp As Group In groups
            link = New LinkButton
            link.Text = grp.Name
            If Not grp.HasPrivilege(Me.mApplicationName) Then
                link.Enabled = False
                link.ToolTip = String.Format("This group does not have access to the {0} application", mApplicationName)
                link.Style.Add("Cursor", "hand")
            End If
            link.CommandArgument = grp.GroupId.ToString
            AddHandler link.Click, AddressOf LinkClick
            Me.GroupListHolder.Controls.Add(link)
            lit = New LiteralControl("<BR>")
            Me.GroupListHolder.Controls.Add(lit)
        Next

        SelectedOU.Value = orgUnitId.ToString
    End Sub
    Private Sub PopulateMemberGroups()
        GroupListHolder.Controls.Clear()
        Dim groups As GroupCollection = Me.mUser.Groups
        Dim link As LinkButton
        Dim lit As LiteralControl

        For Each grp As Group In groups
            link = New LinkButton
            link.Text = grp.Name
            If Not grp.HasPrivilege(Me.mApplicationName) Then
                link.Enabled = False
                link.ToolTip = String.Format("This group does not have access to the {0} application", mApplicationName)
                link.Style.Add("Cursor", "hand")
            End If

            link.CommandArgument = grp.GroupId.ToString
            AddHandler link.Click, AddressOf LinkClick
            Me.GroupListHolder.Controls.Add(link)
            lit = New LiteralControl("<BR>")
            Me.GroupListHolder.Controls.Add(lit)
        Next
    End Sub
#End Region

#End Region

End Class
