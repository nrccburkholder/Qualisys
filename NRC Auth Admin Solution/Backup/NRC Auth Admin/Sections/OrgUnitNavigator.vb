Imports Nrc.NRCAuthLib

Public Class OrgUnitNavigator

    Private mSelectedOrgUnit As OrgUnit
    Private mSelectedGroup As Group
    Private mShowGroupSelector As Boolean = True
    Private mIgnoreFocusedRowChange As Boolean


#Region " SelectedOrgUnitChanging Event "
    Public Class SelectedOrgUnitChangingEventArgs
        Inherits System.ComponentModel.CancelEventArgs

        Public Sub New()
        End Sub
    End Class
    Public Event SelectedOrgUnitChanging As EventHandler(Of SelectedOrgUnitChangingEventArgs)
    Protected Sub OnSelectedOrgUnitChanging(ByVal e As SelectedOrgUnitChangingEventArgs)
        RaiseEvent SelectedOrgUnitChanging(Me, e)

        If mShowGroupSelector Then
            Dim cancelArgs As New SelectedGroupChangingEventArgs
            Me.OnSelectedGroupChanging(cancelArgs)
            e.Cancel = cancelArgs.Cancel
        End If
    End Sub
#End Region

#Region " SelectedOrgUnitChanged Event "
    Public Class SelectedOrgUnitChangedEventArgs
        Inherits EventArgs

        Private mOrgUnit As OrgUnit
        Public ReadOnly Property OrgUnit() As OrgUnit
            Get
                Return mOrgUnit
            End Get
        End Property
        Public Sub New(ByVal ou As OrgUnit)
            mOrgUnit = ou
        End Sub
    End Class
    Public Event SelectedOrgUnitChanged As EventHandler(Of SelectedOrgUnitChangedEventArgs)
    Protected Overridable Sub OnSelectedOrgUnitChanged(ByVal e As SelectedOrgUnitChangedEventArgs)
        RaiseEvent SelectedOrgUnitChanged(Me, e)
    End Sub
#End Region

#Region " SelectedGroupChanging Event "
    Public Class SelectedGroupChangingEventArgs
        Inherits System.ComponentModel.CancelEventArgs

        Public Sub New()
        End Sub
    End Class
    Public Event SelectedGroupChanging As EventHandler(Of SelectedGroupChangingEventArgs)
    Protected Sub OnSelectedGroupChanging(ByVal e As SelectedGroupChangingEventArgs)
        RaiseEvent SelectedGroupChanging(Me, e)
    End Sub
#End Region

#Region " SelectedGroupChanged Event "
    Public Class SelectedGroupChangedEventArgs
        Inherits EventArgs

        Private mGroup As Group
        Public ReadOnly Property Group() As Group
            Get
                Return mGroup
            End Get
        End Property

        Public Sub New(ByVal selectedGroup As Group)
            mGroup = selectedGroup
        End Sub
    End Class
    Public Event SelectedGroupChanged As EventHandler(Of SelectedGroupChangedEventArgs)
    Protected Sub OnSelectedGroupChanged(ByVal e As SelectedGroupChangedEventArgs)
        RaiseEvent SelectedGroupChanged(Me, e)
    End Sub
#End Region

#Region " Public Properties "
    Public Property ShowGroupSelector() As Boolean
        Get
            Return mShowGroupSelector
        End Get
        Set(ByVal value As Boolean)
            If mShowGroupSelector <> value Then
                mShowGroupSelector = value
                Me.ShowGroupsChanged()
            End If
        End Set
    End Property
    Public ReadOnly Property SelectedGroup() As Group
        Get
            Return mSelectedGroup
        End Get
    End Property
    Public ReadOnly Property SelectedGroupId() As Integer
        Get
            If mSelectedGroup Is Nothing Then
                Return 0
            Else
                Return mSelectedGroup.GroupId
            End If
        End Get
    End Property

    Public ReadOnly Property SelectedOrgUnit() As OrgUnit
        Get
            Return mSelectedOrgUnit
        End Get
    End Property
    Public ReadOnly Property SelectedOrgUnitId() As Integer
        Get
            If mSelectedOrgUnit Is Nothing Then
                Return 0
            Else
                Return mSelectedOrgUnit.OrgUnitId
            End If
        End Get
    End Property

#End Region

    Private Sub GroupNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.InitializeOrgUnitTree()

        'Enable/Disable privleged operations
        Me.EditPropertiesMenuItem.Enabled = CurrentUser.AllowEditOrgUnit
        Me.OrgUnitPropertiesButton.Enabled = CurrentUser.AllowEditOrgUnit

        Me.EditPrivilegesMenuItem.Enabled = CurrentUser.AllowEditOrgUnit
        Me.OrgUnitPrivilegesButton.Enabled = CurrentUser.AllowEditOrgUnit

        Me.EditSurveyAccessMenuItem.Enabled = CurrentUser.AllowEditOrgUnit
        Me.SurveyAccessButton.Enabled = CurrentUser.AllowEditOrgUnit

        Me.NewOrganizationMenuItem.Enabled = CurrentUser.AllowCreateOrgUnit
        Me.NewOrgUnitButton.Enabled = CurrentUser.AllowCreateOrgUnit

        Me.DeleteOrgUnitButton.Enabled = CurrentUser.AllowDeleteOrgUnit
        Me.DeleteOrganizationMenuItem.Enabled = CurrentUser.AllowDeleteOrgUnit
    End Sub
    Private Function ConvertIntegerToString(ByVal int As Integer) As String
        Return int.ToString
    End Function

#Region " Control Event Handlers "

#Region " Tree Events "
    Private Sub OrgUnitTree_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles OrgUnitTree.AfterSelect
        Dim ou As OrgUnit = TryCast(e.Node.Tag, OrgUnit)
        If ou IsNot Nothing Then
            Me.mSelectedOrgUnit = ou

            'Raise the changed event
            Me.OnSelectedOrgUnitChanged(New SelectedOrgUnitChangedEventArgs(ou))

            'Populate the group list if needed
            If mShowGroupSelector Then
                Me.PopulateGroupList()
            End If
        End If
    End Sub

    Private Sub OrgUnitTree_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles OrgUnitTree.BeforeSelect
        If e.Action = TreeViewAction.Collapse OrElse e.Action = TreeViewAction.Expand Then
            Exit Sub
        End If

        Dim ou As OrgUnit = TryCast(e.Node.Tag, OrgUnit)
        If ou IsNot Nothing Then
            'Fire the Changing event 
            Dim cancelArgs As New SelectedOrgUnitChangingEventArgs
            Me.OnSelectedOrgUnitChanging(cancelArgs)
            e.Cancel = cancelArgs.Cancel
        End If
    End Sub

    Private Sub OrgUnitTree_MouseClick(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles OrgUnitTree.MouseClick
        If e.Button = Windows.Forms.MouseButtons.Right Then
            Dim node As TreeNode = Me.OrgUnitTree.GetNodeAt(e.Location)
            If node IsNot Nothing Then
                Me.OrgUnitTree.SelectedNode = node
            End If
        End If
    End Sub

#End Region

#Region " Search Events "
    Private Sub SearchButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        If Me.OrgUnitTree.Nodes.Count = 0 Then
            Exit Sub
        End If

        Dim searchText As String = Me.SearchTextbox.Text.Trim
        Dim startNode As TreeNode

        If Me.OrgUnitTree.SelectedNode IsNot Nothing AndAlso SearchTextMatch(searchText, Me.OrgUnitTree.SelectedNode) Then
            startNode = FindNextNode(Me.OrgUnitTree.SelectedNode)
        Else
            startNode = Me.OrgUnitTree.Nodes(0)
        End If

        Dim result As TreeNode = FindNode(startNode, Me.SearchTextbox.Text)
        If result IsNot Nothing Then
            Me.OrgUnitTree.SelectedNode = result
        End If

    End Sub

    Private Sub SearchTextbox_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles SearchTextbox.KeyDown
        If e.KeyCode = Keys.Enter Then
            Me.SearchButton.PerformClick()
            e.SuppressKeyPress = True
            e.Handled = True

        End If
    End Sub

    Private Sub SearchTextbox_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchTextbox.TextChanged
        Me.SearchButton.Enabled = (Me.SearchTextbox.Text.Trim.Length > 0)
    End Sub

#End Region

#Region " GroupGridView Events "

    Private Sub GroupGridView_FocusedRowChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.FocusedRowChangedEventArgs) Handles GroupGridView.FocusedRowChanged
        If mIgnoreFocusedRowChange Then
            Exit Sub
        End If

        If mShowGroupSelector Then
            Dim grp As Group = TryCast(Me.GroupBindingSource.Current, Group)

            If grp IsNot mSelectedGroup Then
                'Set back to previous
                mIgnoreFocusedRowChange = True
                Me.GroupGridView.FocusedRowHandle = e.PrevFocusedRowHandle
                mIgnoreFocusedRowChange = False

                Dim cancelArgs As New SelectedGroupChangingEventArgs
                Me.OnSelectedGroupChanging(cancelArgs)
                If Not cancelArgs.Cancel Then
                    mIgnoreFocusedRowChange = True
                    Me.GroupGridView.FocusedRowHandle = e.FocusedRowHandle
                    mIgnoreFocusedRowChange = False

                    SetSelectedGroup(grp)
                End If
            End If
        End If
    End Sub

#End Region

#Region " Menu / ToolStrip Events "
    Private Sub EditPropertiesMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditPropertiesMenuItem.Click
        Me.EditPropertiesCommand()
    End Sub

    Private Sub OrgUnitPropertiesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OrgUnitPropertiesButton.Click
        Me.EditPropertiesCommand()
    End Sub

    Private Sub EditPrivilegesMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditPrivilegesMenuItem.Click
        Me.EditPrivilegesCommand()
    End Sub

    Private Sub OrgUnitPrivilegesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OrgUnitPrivilegesButton.Click
        Me.EditPrivilegesCommand()
    End Sub

    Private Sub SurveyAccessButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SurveyAccessButton.Click
        Me.EditSurveyAccessCommand()
    End Sub

    Private Sub EditSurveyAccessMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditSurveyAccessMenuItem.Click
        Me.EditSurveyAccessCommand()
    End Sub

    Private Sub NewOrgUnitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewOrgUnitButton.Click
        Me.NewOrgUnitCommand()
    End Sub

    Private Sub NewOrganizationMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewOrganizationMenuItem.Click
        Me.NewOrgUnitCommand()
    End Sub

    Private Sub DeleteOrgUnitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteOrgUnitButton.Click
        Me.DeleteOrgUnitCommand()
    End Sub

    Private Sub DeleteOrganizationMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteOrganizationMenuItem.Click
        Me.DeleteOrgUnitCommand()
    End Sub

    Private Sub MoveOrganizationMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveOrganizationMenuItem.Click
        MoveOrganizationCommand()
    End Sub

#End Region

#End Region

#Region " Private Methods "

#Region " Tree Population "
    Private Sub InitializeOrgUnitTree()
        Me.OrgUnitTree.Nodes.Clear()
        Dim rootOrg As OrgUnit = OrgUnit.GetOrgUnitTree(CurrentUser.Member.OrgUnitId)

        Me.OrgUnitTree.BeginUpdate()
        PopulateOrgUnits(Me.OrgUnitTree.Nodes, rootOrg)
        For Each node As TreeNode In Me.OrgUnitTree.Nodes
            node.Expand()
        Next
        Me.OrgUnitTree.EndUpdate()
        If Me.OrgUnitTree.Nodes.Count > 0 Then
            Me.OrgUnitTree.SelectedNode = Me.OrgUnitTree.Nodes(0)
        End If
    End Sub

    Private Sub PopulateOrgUnits(ByVal nodes As TreeNodeCollection, ByVal rootOrg As OrgUnit)
        Dim rootNode As New TreeNode(rootOrg.Name)
        rootNode.Tag = rootOrg
        For Each org As OrgUnit In rootOrg.OrgUnits
            PopulateOrgUnits(rootNode.Nodes, org)
        Next

        nodes.Add(rootNode)
    End Sub

    Private Sub ResortChildNodes(ByVal rootNode As TreeNode)
        Dim list As New SortedList(Of String, TreeNode)

        For Each node As TreeNode In rootNode.Nodes
            list.Add(node.Text, node)
        Next

        rootNode.Nodes.Clear()

        For Each key As String In list.Keys
            rootNode.Nodes.Add(list(key))
        Next
    End Sub

#End Region

#Region " OrgUnit Commands "
    Private Sub NewOrgUnitCommand()
        If Me.SelectedOrgUnit IsNot Nothing Then
            Dim frm As New OrgUnitPropertiesDialog(Me.SelectedOrgUnit)
            If frm.ShowDialog() = DialogResult.OK Then
                'Make the new node
                Dim newNode As New TreeNode
                newNode.Text = frm.OrgUnit.Name
                newNode.Tag = frm.OrgUnit
                Me.OrgUnitTree.SelectedNode.Nodes.Add(newNode)

                'Resort the child nodes
                Me.ResortChildNodes(Me.OrgUnitTree.SelectedNode)

                'Select the new node
                Me.OrgUnitTree.SelectedNode = newNode
            End If
        End If
    End Sub

    Private Sub DeleteOrgUnitCommand()
        If Me.SelectedOrgUnit IsNot Nothing Then
            If MessageBox.Show("Deleting an organization will delete all child organizations, groups and members that belong to it!  Are you sure you want to delete this organization?", "Confirm Delete", MessageBoxButtons.YesNo) = DialogResult.Yes Then
                Me.SelectedOrgUnit.DeleteOrgUnit(CurrentUser.Member.MemberId)
                Me.OrgUnitTree.Nodes.Remove(OrgUnitTree.SelectedNode)
            End If
        End If
    End Sub

    Private Sub EditPropertiesCommand()
        If Me.SelectedOrgUnit IsNot Nothing Then
            Dim frm As New OrgUnitPropertiesDialog(Me.SelectedOrgUnit.ParentOrgUnit, Me.SelectedOrgUnit)
            If frm.ShowDialog() = DialogResult.OK Then
                Me.OrgUnitTree.SelectedNode.Text = frm.OrgUnit.Name

                'Resort the nodes
                If Me.OrgUnitTree.SelectedNode.Parent IsNot Nothing Then
                    'Store the selected node
                    Dim node As TreeNode = Me.OrgUnitTree.SelectedNode

                    Me.ResortChildNodes(Me.OrgUnitTree.SelectedNode.Parent)

                    'Select the proper node
                    Me.OrgUnitTree.SelectedNode = node
                End If
            End If
        End If
    End Sub

    Private Sub EditPrivilegesCommand()
        If Me.SelectedOrgUnit IsNot Nothing Then
            Dim frm As New PrivilegeEditorDialog(Me.SelectedOrgUnit)
            frm.ShowDialog()
        End If
    End Sub

    Private Sub EditSurveyAccessCommand()
        If Me.SelectedOrgUnit IsNot Nothing Then
            Dim frm As New SurveyAccessDialog(Me.SelectedOrgUnit)
            frm.ShowDialog()
        End If
    End Sub

    Private Sub MoveOrganizationCommand()
        If Me.mSelectedOrgUnit Is Nothing Then
            Exit Sub
        End If

        Dim frm As New OrgUnitSelectorDialog(AddressOf AllowOrgUnitMove)
        If frm.ShowDialog = DialogResult.OK Then
            Me.mSelectedOrgUnit.MoveOrgUnit(frm.SelectedOrgUnit.OrgUnitId, CurrentUser.Member.MemberId)
            Me.InitializeOrgUnitTree()
        End If
    End Sub

    Private Function AllowOrgUnitMove(ByVal newParentOu As OrgUnit, ByRef message As String) As Boolean
        If Me.mSelectedOrgUnit.ParentOrgUnitId = newParentOu.OrgUnitId Then
            message = "You must select a new parent organization"
            Return False
        ElseIf Not Me.mSelectedOrgUnit.HasPrivilegeSubset(newParentOu.OrgUnitId) Then
            message = "This organization does not have sufficient privileges granted."
            Return False
        Else
            message = ""
            Return True
        End If
    End Function

#End Region

    Private Sub PopulateGroupList()
        'Suppress the FocusedRowChanged event handler
        mIgnoreFocusedRowChange = True

        'Get the list of groups for the selected orgunit
        If mSelectedOrgUnit IsNot Nothing Then
            Dim groups As GroupCollection = GroupCollection.GetOrgUnitGroups(mSelectedOrgUnit.OrgUnitId)
            Me.GroupBindingSource.DataSource = groups
            Me.GroupGridView.FocusedRowHandle = 0
        Else
            Me.GroupBindingSource.DataSource = Nothing
        End If

        'Re-enable event handler
        mIgnoreFocusedRowChange = False

        'Now set the selected group and raise the SelectedGroupChanged event
        Me.SetSelectedGroup()
    End Sub

    Private Sub ShowGroupsChanged()
        If mShowGroupSelector Then
            Me.PopulateGroupList()

            Me.ToolStrip1.Visible = False
            Me.OrgUnitHeaderStrip.Visible = True
            Me.OrgUnitTree.ContextMenuStrip = Nothing
            Me.MainPanel.Panel2Collapsed = False
        Else
            Me.ToolStrip1.Visible = True
            Me.OrgUnitHeaderStrip.Visible = False
            Me.OrgUnitTree.ContextMenuStrip = OrgUnitMenu
            Me.MainPanel.Panel2Collapsed = True
        End If
    End Sub

    Private Sub SetSelectedGroup()
        Dim grp As Group = Nothing
        If Me.GroupBindingSource.Current IsNot Nothing Then
            grp = TryCast(Me.GroupBindingSource.Current, Group)
        End If
        SetSelectedGroup(grp)
    End Sub

    Private Sub SetSelectedGroup(ByVal grp As Group)
        Me.mSelectedGroup = grp
        Me.OnSelectedGroupChanged(New SelectedGroupChangedEventArgs(grp))
    End Sub

#Region " Tree Search Methods "
    Private Function SearchTextMatch(ByVal searchText As String, ByVal node As TreeNode) As Boolean
        Return node.Text.ToUpper.Contains(searchText.ToUpper)
    End Function

    Private Function FindNode(ByVal startNode As TreeNode, ByVal text As String) As TreeNode
        If SearchTextMatch(text, startNode) Then
            Return startNode
        Else

            Dim currentNode As TreeNode = FindNextNode(startNode)
            While currentNode IsNot startNode
                If SearchTextMatch(text, currentNode) Then
                    Return currentNode
                End If

                currentNode = FindNextNode(currentNode)
            End While

            Return Nothing
        End If
    End Function

    Private Function FindNextNode(ByVal node As TreeNode) As TreeNode
        Return FindNextNode(node, False)
    End Function
    Private Function FindNextNode(ByVal node As TreeNode, ByVal childrenSearched As Boolean) As TreeNode
        If Not childrenSearched Then
            If node.Nodes.Count > 0 Then
                Return node.Nodes(0)
            End If
        End If

        If node.NextNode IsNot Nothing Then
            Return node.NextNode
        End If

        If node.Parent IsNot Nothing Then
            Return FindNextNode(node.Parent, True)
        End If

        Return node.TreeView.Nodes(0)
    End Function

#End Region

#End Region

End Class
