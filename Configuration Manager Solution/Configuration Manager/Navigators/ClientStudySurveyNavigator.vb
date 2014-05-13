Imports Nrc.Qualisys.Library.Navigation

Public Class ClientStudySurveyNavigator

#Region " Private Members "

    Private mNavigationTree As NavigationTree
    Private mSelectedClientGroup As ClientGroupNavNode
    Private mSelectedClient As ClientNavNode
    Private mSelectedStudy As StudyNavNode
    Private mSelectedSurvey As SurveyNavNode
    Private mSection As Section

#End Region

#Region " Public Properties "

    Public ReadOnly Property SelectedClientGroup() As ClientGroupNavNode
        Get
            Return mSelectedClientGroup
        End Get
    End Property

    Public ReadOnly Property SelectedClient() As ClientNavNode
        Get
            Return mSelectedClient
        End Get
    End Property

    Public ReadOnly Property SelectedStudy() As StudyNavNode
        Get
            Return mSelectedStudy
        End Get
    End Property

    Public ReadOnly Property SelectedSurvey() As SurveyNavNode
        Get
            Return mSelectedSurvey
        End Get
    End Property

    Public ReadOnly Property TreeContextMenu() As ContextMenuStrip
        Get
            Return TreeMenu
        End Get
    End Property

#End Region

#Region " Private Properties "

    Private ReadOnly Property ShowAllClients() As Boolean
        Get
            Return (ClientFilterList.SelectedIndex = 1)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal navigationTree As NavigationTree)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mNavigationTree = navigationTree
        ClientFilterList.SelectedIndex = 0

    End Sub

#End Region

#Region " SelectionChanged Event "

    Public Event SelectionChanged As EventHandler(Of ClientStudySurveySelectionChangedEventArgs)

    Public Overridable Sub OnSelectionChanged(ByVal e As ClientStudySurveySelectionChangedEventArgs)

        RaiseEvent SelectionChanged(Me, e)

    End Sub

#End Region

#Region " Control Event Handlers "

    Private Sub ClientStudySurveyNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ShowClientGroupsTSButton.Checked = My.Settings.ClientStudySurveyNavigatorIncludeGroups
        PopulateTree(mNavigationTree)

    End Sub

    Private Sub ClientStudySurveyTree_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles ClientStudySurveyTree.BeforeSelect

        If mSection.AllowInactivate = False Then
            e.Cancel = True
        End If

    End Sub

    Private Sub ClientStudySurveyTree_SelectionChanged(ByVal sender As Object, ByVal e As TreeViewEventArgs) Handles ClientStudySurveyTree.AfterSelect

        If e.Action <> TreeViewAction.Collapse AndAlso e.Action <> TreeViewAction.Expand Then
            Dim node As NavigationNode = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)

            Select Case node.NodeType
                Case NavigationNodeType.ClientGroup
                    mSelectedClientGroup = DirectCast(node, ClientGroupNavNode)
                    mSelectedClient = Nothing
                    mSelectedStudy = Nothing
                    mSelectedSurvey = Nothing

                Case NavigationNodeType.Client
                    mSelectedClient = DirectCast(node, ClientNavNode)
                    mSelectedClientGroup = mSelectedClient.ClientGroup
                    mSelectedStudy = Nothing
                    mSelectedSurvey = Nothing

                Case NavigationNodeType.Study
                    mSelectedStudy = DirectCast(node, StudyNavNode)
                    mSelectedClient = mSelectedStudy.Client
                    mSelectedClientGroup = mSelectedClient.ClientGroup
                    mSelectedSurvey = Nothing

                Case NavigationNodeType.Survey
                    mSelectedSurvey = DirectCast(node, SurveyNavNode)
                    mSelectedStudy = mSelectedSurvey.Study
                    mSelectedClient = mSelectedStudy.Client
                    mSelectedClientGroup = mSelectedClient.ClientGroup

            End Select

            OnSelectionChanged(New ClientStudySurveySelectionChangedEventArgs(node.NodeType))
        End If

    End Sub

    Private Sub ClientFilterList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClientFilterList.SelectedIndexChanged

        'When the filter list changes then re-populate the tree
        If ClientFilterList.SelectedIndex > -1 Then
            PopulateTree(mNavigationTree)
        End If

    End Sub

    Private Sub TreeMenu_Opening(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles TreeMenu.Opening

        If mSelectedSurvey IsNot Nothing Then
            'Set the menu up for a survey
            DeleteClientGroupToolStripMenuItem.Visible = False
            DeleteClientToolStripMenuItem.Visible = False
            DeleteStudyToolStripMenuItem.Visible = False
            With DeleteSurveyToolStripMenuItem
                .Visible = True
                .Enabled = mSelectedSurvey.AllowDelete
            End With
        ElseIf mSelectedStudy IsNot Nothing Then
            'Set the menu up fo a study
            DeleteClientGroupToolStripMenuItem.Visible = False
            DeleteClientToolStripMenuItem.Visible = False
            DeleteSurveyToolStripMenuItem.Visible = False
            With DeleteStudyToolStripMenuItem
                .Visible = True
                .Enabled = mSelectedStudy.AllowDelete
            End With
        ElseIf mSelectedClient IsNot Nothing Then
            'Set the menu up for a client
            DeleteClientGroupToolStripMenuItem.Visible = False
            DeleteStudyToolStripMenuItem.Visible = False
            DeleteSurveyToolStripMenuItem.Visible = False
            With DeleteClientToolStripMenuItem
                .Visible = True
                .Enabled = mSelectedClient.AllowDelete
            End With
        ElseIf mSelectedClientGroup IsNot Nothing Then
            'Set the menu up for a client group
            DeleteClientToolStripMenuItem.Visible = False
            DeleteStudyToolStripMenuItem.Visible = False
            DeleteSurveyToolStripMenuItem.Visible = False
            With DeleteClientGroupToolStripMenuItem
                .Visible = True
                .Enabled = mSelectedClientGroup.AllowDelete
            End With
        Else
            'Set the menu up fo white space
            DeleteClientGroupToolStripMenuItem.Visible = False
            DeleteClientToolStripMenuItem.Visible = False
            DeleteStudyToolStripMenuItem.Visible = False
            DeleteSurveyToolStripMenuItem.Visible = False
            e.Cancel = True
        End If

    End Sub

    Private Sub ClientStudySurveyTree_MouseClick(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles ClientStudySurveyTree.MouseClick

        'If user right-clicks something we want to automatically select it to make
        'context menu a little easier
        If e.Button = Windows.Forms.MouseButtons.Right Then
            'Get the node clicked and select it
            Dim pt As Point = e.Location
            Dim node As TreeNode = ClientStudySurveyTree.GetNodeAt(pt)
            If node IsNot Nothing Then
                ClientStudySurveyTree.SelectedNode = node
            End If
        End If

    End Sub

    Private Sub DeleteClientGroupToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteClientGroupToolStripMenuItem.Click

        'Prompt the user to make sure they want to delete the selected client group
        If MessageBox.Show("Are you sure you want to delete this client group?", "Confirm Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) <> DialogResult.OK Then
            Exit Sub
        End If

        Try
            Cursor = Cursors.WaitCursor

            If mSelectedClientGroup IsNot Nothing AndAlso mSelectedClientGroup.AllowDelete Then
                'Delete the client group
                Library.ClientGroup.Delete(mSelectedClientGroup.Id)
                mNavigationTree.ClientGroups.Remove(mSelectedClientGroup)

                'Get the old node
                Dim node As TreeNode = ClientStudySurveyTree.SelectedNode

                'Select a different node
                If node.PrevNode IsNot Nothing Then
                    ClientStudySurveyTree.SelectedNode = node.PrevNode
                ElseIf node.NextNode IsNot Nothing Then
                    ClientStudySurveyTree.SelectedNode = node.NextNode
                Else
                    ClientStudySurveyTree.SelectedNode = Nothing
                End If

                'Remove the old node
                node.Remove()
            End If

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

    Private Sub DeleteClientToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteClientToolStripMenuItem.Click

        'Prompt the user to make sure they want to delete the selected client
        If MessageBox.Show("Are you sure you want to delete this client?", "Confirm Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) <> DialogResult.OK Then
            Exit Sub
        End If

        Try
            Cursor = Cursors.WaitCursor

            If mSelectedClient IsNot Nothing AndAlso mSelectedClient.AllowDelete Then
                'Delete the client
                Library.Client.Delete(mSelectedClient.Id)
                If ShowClientGroupsTSButton.Checked Then
                    mSelectedClientGroup.Clients.Remove(mSelectedClient)
                Else
                    mNavigationTree.Clients.Remove(mSelectedClient)
                End If

                'Get the old node
                Dim node As TreeNode = ClientStudySurveyTree.SelectedNode

                'Select a different node
                If node.PrevNode IsNot Nothing Then
                    ClientStudySurveyTree.SelectedNode = node.PrevNode
                ElseIf node.NextNode IsNot Nothing Then
                    ClientStudySurveyTree.SelectedNode = node.NextNode
                Else
                    ClientStudySurveyTree.SelectedNode = Nothing
                End If

                'Remove the old node
                node.Remove()
            End If

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

    Private Sub DeleteStudyToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteStudyToolStripMenuItem.Click

        'Prompt the user to make sure they want to delete the selected study
        If MessageBox.Show("Are you sure you want to delete this study?", "Confirm Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) <> DialogResult.OK Then
            Exit Sub
        End If

        Try
            Cursor = Cursors.WaitCursor

            If mSelectedStudy IsNot Nothing AndAlso mSelectedStudy.AllowDelete Then
                'Delete the study
                Library.Study.Delete(mSelectedStudy.Id)
                mSelectedClient.Studies.Remove(mSelectedStudy)

                'Get the old node
                Dim node As TreeNode = ClientStudySurveyTree.SelectedNode

                'Select the parent node
                ClientStudySurveyTree.SelectedNode = node.Parent

                'Remove the old node
                node.Remove()
            End If

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

    Private Sub DeleteSurveyToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteSurveyToolStripMenuItem.Click

        'Prompt the user to make sure they want to delete the selected survey
        If MessageBox.Show("Are you sure you want to delete this survey?", "Confirm Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) <> DialogResult.OK Then
            Exit Sub
        End If

        Try
            Cursor = Cursors.WaitCursor

            If mSelectedSurvey IsNot Nothing AndAlso mSelectedSurvey.AllowDelete Then
                'Delete the survey
                Library.Survey.Delete(mSelectedSurvey.Id)
                mSelectedStudy.Surveys.Remove(mSelectedSurvey)

                'Get the old node
                Dim node As TreeNode = ClientStudySurveyTree.SelectedNode

                'select the parent
                ClientStudySurveyTree.SelectedNode = node.Parent

                'Remove the old node
                node.Remove()
            End If

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

    Private Sub ShowClientGroupsTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowClientGroupsTSButton.Click

        With ShowClientGroupsTSButton
            'Change the checked state
            .Checked = Not .Checked

            'Capture selected node before tree refresh
            Dim node As NavigationNode = Nothing
            If ClientStudySurveyTree.SelectedNode IsNot Nothing Then
                node = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
            End If

            'Reload the tree and save the state
            My.Settings.ClientStudySurveyNavigatorIncludeGroups = .Checked
            mNavigationTree = NavigationTree.GetByUser(CurrentUser.UserName, InitialPopulationDepth.Survey, .Checked)
            PopulateTree(mNavigationTree)

            'Set the button captions and ToolTip text
            If .Checked Then
                .Text = "Don't Show Client Groups"
                .ToolTipText = "Don't Show Client Groups"
            Else
                .Text = "Show Client Groups"
                .ToolTipText = "Show Client Groups"
            End If

            'If node selected before tree refresh, reselect again
            If node IsNot Nothing Then
                If node.NodeType <> NavigationNodeType.ClientGroup Then
                    Dim treeNode As TreeNode = FindNode(node.Id, node.NodeType)
                    ClientStudySurveyTree.SelectedNode = treeNode
                    treeNode.EnsureVisible()

                ElseIf Not ShowClientGroupsTSButton.Checked Then
                    'Client group was selected node but now not in tree, set to first node
                    ClientStudySurveyTree.SelectedNode = ClientStudySurveyTree.Nodes(0)

                End If
            End If

        End With

    End Sub

    Private Sub ShowAllTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowAllTSButton.Click

        With ShowAllTSButton
            .Checked = Not .Checked
            If .Checked Then
                .Text = "Show Active Only"
                .ToolTipText = "Show Active Only"
            Else
                .Text = "Show All"
                .ToolTipText = "Show All"
            End If
        End With

        mNavigationTree = NavigationTree.GetByUser(CurrentUser.UserName, InitialPopulationDepth.Survey, ShowClientGroupsTSButton.Checked)
        PopulateTree(mNavigationTree)

    End Sub

#End Region

#Region " Public Methods "

    Public Overrides Sub RegisterSectionControl(ByVal sect As Section)

        mSection = sect

    End Sub

    Public Sub AddClientGroup(ByVal group As Library.ClientGroup)

        'If the client group is nothing then we are out of here
        If group Is Nothing Then Return

        'Create a new client group navigation node
        Dim groupNavNode As ClientGroupNavNode = New ClientGroupNavNode(mNavigationTree)

        'Populate the client group node
        With groupNavNode
            .Id = group.Id
            .Name = group.Name
        End With

        'Add the client group node to the collection
        With mNavigationTree.ClientGroups
            .Add(groupNavNode)
            .SortByName()
        End With

        'Add the client group navigation node to treeview
        AddClientGroupToTreeView(groupNavNode)

    End Sub

    Public Sub AddClient(ByVal client As Library.Client)

        Dim clientNavNode As ClientNavNode
        Dim groupTreeNode As TreeNode = Nothing
        Dim groupNavNode As ClientGroupNavNode = Nothing

        'If the client is nothing then we are out of here
        If (client Is Nothing) Then Return

        'Create the client node
        If ShowClientGroupsTSButton.Checked Then
            'This client needs to be added to the Unassigned client group
            groupTreeNode = FindNode(client.ClientGroup.Id, NavigationNodeType.ClientGroup)

            'If we did not find the group tree node then we are out of here
            If groupTreeNode Is Nothing Then Exit Sub

            'Get the client group navigation node
            groupNavNode = DirectCast(groupTreeNode.Tag, ClientGroupNavNode)

            'Create the client navigation node
            clientNavNode = New ClientNavNode(groupNavNode)
        Else
            'Create and client navigation node
            clientNavNode = New ClientNavNode(mNavigationTree)
        End If

        'Populate the client node
        With clientNavNode
            .Id = client.Id
            .Name = client.Name
        End With

        'Add the client node
        If ShowClientGroupsTSButton.Checked Then
            With groupNavNode.Clients
                .Add(clientNavNode)
                .SortByName()
            End With

            'Add the client navigation node to treeview
            AddClientToTreeView(groupTreeNode, clientNavNode)
        Else
            With mNavigationTree.Clients
                .Add(clientNavNode)
                .SortByName()
            End With

            'Add the client navigation node to treeview
            AddClientToTreeView(clientNavNode)
        End If

    End Sub

    Public Sub AddStudy(ByVal study As Library.Study)

        'If study is nothing then we are out of here
        If (study Is Nothing) Then Return

        'Get the client node for this study
        Dim clientTreeNode As TreeNode = FindNode(study.Client.Id, NavigationNodeType.Client)

        'If a client node was found then add the study
        If clientTreeNode IsNot Nothing Then
            'Get the client navigation node
            Dim clientNavNode As ClientNavNode = DirectCast(clientTreeNode.Tag, ClientNavNode)

            'Create and add the study navigation node
            Dim studyNavNode As New StudyNavNode(clientNavNode)
            With studyNavNode
                .Id = study.Id
                .Name = study.Name
            End With
            With clientNavNode.Studies
                .Add(studyNavNode)
                .SortByName()
            End With

            'Add the study navigation node to treeview
            AddStudyToTreeView(clientTreeNode, studyNavNode)
        End If

    End Sub

    Public Sub AddSurvey(ByVal srvy As Library.Survey)

        'If survey is nothing then we are out of here
        If (srvy Is Nothing) Then Return

        'Get the study node for this survey
        Dim studyTreeNode As TreeNode = FindNode(srvy.StudyId, NavigationNodeType.Study)

        'If the study node was found then add the survey
        If studyTreeNode IsNot Nothing Then
            'Get the study navigation node
            Dim studyNavNode As StudyNavNode = DirectCast(studyTreeNode.Tag, StudyNavNode)

            'Create and add the survey navigation node
            Dim surveyNavNode As New SurveyNavNode(studyNavNode)
            With surveyNavNode
                .Id = srvy.Id
                .Name = srvy.Name
                .IsValidated = srvy.IsValidated
                .SurveyType = srvy.SurveyType
            End With
            With studyNavNode.Surveys
                .Add(surveyNavNode)
                .SortByName()
            End With

            'Add to tree view
            AddSurveyToTreeView(studyTreeNode, surveyNavNode)
        End If

    End Sub

    Public Sub RefreshClientGroupNode()

        'We can't refresh the selected client if currently no client is selected
        If ClientStudySurveyTree.SelectedNode IsNot Nothing Then
            'Get the selected navigation node
            Dim navNode As NavigationNode = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
            If navNode.NodeType = NavigationNodeType.ClientGroup Then
                'Refresh navigation node
                Dim groupNavNode As ClientGroupNavNode = DirectCast(navNode, ClientGroupNavNode)
                groupNavNode.Refresh()
                mNavigationTree.ClientGroups.SortByName()

                'Refresh tree node
                If Not ShowAllTSButton.Checked AndAlso Not groupNavNode.IsActive Then
                    ClientStudySurveyTree.SelectedNode.Remove()
                Else
                    ClientStudySurveyTree.SelectedNode.Text = groupNavNode.DisplayLabel
                    SortChildNodesByLabel(ClientStudySurveyTree.SelectedNode.Parent)
                End If
            End If
        End If

        'Set focus to the treeview
        ClientStudySurveyTree.Focus()

    End Sub

    Public Sub RefreshClientNode()

        'We can't refresh the selected client if currently no client is selected
        If ClientStudySurveyTree.SelectedNode IsNot Nothing Then
            'Get the selected navigation node
            Dim navNode As NavigationNode = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
            If navNode.NodeType = NavigationNodeType.Client Then
                'Refresh navigation node
                Dim clientNavNode As ClientNavNode = DirectCast(navNode, ClientNavNode)
                clientNavNode.Refresh()
                If ShowClientGroupsTSButton.Checked Then
                    'Check to see if the Client Group has changed
                    If clientNavNode.ClientGroup.Id <> clientNavNode.ClientGroupID Then
                        'Client group change. Remove node from old group.
                        Dim node As TreeNode = Nothing
                        node = FindNode(clientNavNode.Id, NavigationNodeType.Client)
                        node.Remove()

                        Dim client As Library.Client
                        If clientNavNode.ClientGroupID = -1 Then
                            'Client group is Unassigned, need to manually build up the group.
                            Dim clientGroup As New Library.ClientGroup
                            Dim groupInterface As Library.IClientGroup = clientGroup
                            groupInterface.Id = -1
                            clientGroup.Name = "{Unassigned}"

                            'Create client object inside the Unassigned group.
                            client = New Library.Client(clientGroup)
                            Dim clientInterface As Library.IClient = client
                            clientInterface.Id = clientNavNode.Id
                            client.Name = clientNavNode.Name
                        Else
                            client = clientNavNode.GetClient
                        End If

                        'Add node under new group.
                        AddClient(client)
                    End If
                    clientNavNode.ClientGroup.Clients.SortByName()
                Else
                    mNavigationTree.Clients.SortByName()
                End If

                'Refresh tree node
                If Not ShowAllTSButton.Checked AndAlso Not clientNavNode.IsActive Then
                    ClientStudySurveyTree.SelectedNode.Remove()
                Else
                    ClientStudySurveyTree.SelectedNode.Text = clientNavNode.DisplayLabel
                    SortChildNodesByLabel(ClientStudySurveyTree.SelectedNode.Parent)
                End If
            End If
        End If

        'Set focus to the treeview
        ClientStudySurveyTree.Focus()

    End Sub

    Public Sub RefreshStudyNode()

        'We can't refresh the selected study if currently no study is selected
        If ClientStudySurveyTree.SelectedNode IsNot Nothing Then
            'Get the selected navigation node
            Dim navNode As NavigationNode = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
            If navNode.NodeType = NavigationNodeType.Study Then
                'Refresh navigation node
                Dim studyNavNode As StudyNavNode = DirectCast(navNode, StudyNavNode)
                With studyNavNode
                    .Refresh()
                    .Client.Studies.SortByName()
                End With

                'Refresh tree node
                If Not ShowAllTSButton.Checked AndAlso Not studyNavNode.IsActive Then
                    ClientStudySurveyTree.SelectedNode.Remove()
                Else
                    ClientStudySurveyTree.SelectedNode.Text = studyNavNode.DisplayLabel
                    SortChildNodesByLabel(ClientStudySurveyTree.SelectedNode.Parent)
                End If
            End If
        End If

        'Set focus to the treeview
        ClientStudySurveyTree.Focus()

    End Sub

    Public Sub RefreshSurveyNode()

        'We can't refresh the selected survey if currently no survey is selected
        If ClientStudySurveyTree.SelectedNode IsNot Nothing Then
            'Get the selected navigation node
            Dim navNode As NavigationNode = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
            If navNode.NodeType = NavigationNodeType.Survey Then
                'Refresh navigation node
                Dim surveyNavNode As SurveyNavNode = DirectCast(navNode, SurveyNavNode)
                With surveyNavNode
                    .Refresh()
                    .Study.Surveys.SortByName()
                End With

                'Refresh tree node
                If Not ShowAllTSButton.Checked AndAlso Not surveyNavNode.IsActive Then
                    ClientStudySurveyTree.SelectedNode.Remove()
                Else
                    ClientStudySurveyTree.SelectedNode.Text = surveyNavNode.DisplayLabel
                    SortChildNodesByLabel(ClientStudySurveyTree.SelectedNode.Parent)
                End If
            End If
        End If

        'Set focus to the treeview
        ClientStudySurveyTree.Focus()

    End Sub

    Public Sub ResetTreeMenuItems()

        With TreeMenu.Items
            .Clear()
            .Add(DeleteClientGroupToolStripMenuItem)
            .Add(DeleteClientToolStripMenuItem)
            .Add(DeleteStudyToolStripMenuItem)
            .Add(DeleteSurveyToolStripMenuItem)
            .Add(ToolStripSeparator1)
        End With

    End Sub

#End Region

#Region " Private Methods "

    Private Sub PopulateTree(ByVal navTree As NavigationTree)

        ClientStudySurveyTree.BeginUpdate()
        ClientStudySurveyTree.Nodes.Clear()

        If ShowClientGroupsTSButton.Checked Then
            PopulateTreeFromClientGroup(navTree)
        Else
            PopulateTreeFromClient(navTree)
        End If

        ClientStudySurveyTree.EndUpdate()

    End Sub

    Private Sub PopulateTreeFromClientGroup(ByVal navTree As NavigationTree)

        'Loop through all of the client groups
        mNavigationTree.ClientGroups.SortByName()
        For Each group As ClientGroupNavNode In navTree.ClientGroups
            'Add the client group if the active state is set appropriately
            If ShowAllTSButton.Checked OrElse group.IsActive Then
                Dim groupNode As TreeNode = New TreeNode(group.DisplayLabel)
                groupNode.Tag = group
                groupNode.ForeColor = group.ForeColor
                ClientStudySurveyTree.Nodes.Add(groupNode)

                'Loop through all of the clients
                For Each clnt As ClientNavNode In group.Clients
                    'Add the client if the active state is set appropriately
                    If ShowAllTSButton.Checked OrElse clnt.IsActive Then
                        'Add the client if it has studies or if we are in "show all" mode
                        If clnt.Studies.Count > 0 OrElse ShowAllClients Then
                            Dim clientNode As TreeNode = New TreeNode(clnt.DisplayLabel)
                            clientNode.Tag = clnt
                            clientNode.ForeColor = clnt.ForeColor
                            groupNode.Nodes.Add(clientNode)

                            'Loop through all studies
                            For Each stdy As StudyNavNode In clnt.Studies
                                'Add the study if the active state is set appropriately
                                If ShowAllTSButton.Checked OrElse stdy.IsActive Then
                                    Dim studyNode As TreeNode = New TreeNode(stdy.DisplayLabel)
                                    studyNode.Tag = stdy
                                    studyNode.ForeColor = stdy.ForeColor
                                    clientNode.Nodes.Add(studyNode)

                                    'Loop through all surveys
                                    For Each srvy As SurveyNavNode In stdy.Surveys
                                        'Add the survey if the active state is set appropriately
                                        If ShowAllTSButton.Checked OrElse stdy.IsActive Then
                                            Dim surveyNode As TreeNode = New TreeNode(srvy.DisplayLabel)
                                            surveyNode.Tag = srvy
                                            surveyNode.ForeColor = srvy.ForeColor
                                            studyNode.Nodes.Add(surveyNode)
                                        End If
                                    Next
                                End If
                            Next
                        End If
                    End If
                Next
            End If
        Next

    End Sub

    Private Sub PopulateTreeFromClient(ByVal navTree As NavigationTree)

        'Loop through all of the clients
        For Each clnt As ClientNavNode In navTree.Clients
            'Add the client if the active state is set appropriately
            If ShowAllTSButton.Checked OrElse clnt.IsActive Then
                'Add the client if it has studies or if we are in "show all" mode
                If clnt.Studies.Count > 0 OrElse ShowAllClients Then
                    Dim clientNode As TreeNode = New TreeNode(clnt.DisplayLabel)
                    clientNode.Tag = clnt
                    clientNode.ForeColor = clnt.ForeColor
                    ClientStudySurveyTree.Nodes.Add(clientNode)

                    'Loop through all studies
                    For Each stdy As StudyNavNode In clnt.Studies
                        'Add the study if the active state is set appropriately
                        If ShowAllTSButton.Checked OrElse stdy.IsActive Then
                            Dim studyNode As TreeNode = New TreeNode(stdy.DisplayLabel)
                            studyNode.Tag = stdy
                            studyNode.ForeColor = stdy.ForeColor
                            clientNode.Nodes.Add(studyNode)

                            'Loop through all surveys
                            For Each srvy As SurveyNavNode In stdy.Surveys
                                'Add the survey if the active state is set appropriately
                                If ShowAllTSButton.Checked OrElse stdy.IsActive Then
                                    Dim surveyNode As TreeNode = New TreeNode(srvy.DisplayLabel)
                                    surveyNode.Tag = srvy
                                    surveyNode.ForeColor = srvy.ForeColor
                                    studyNode.Nodes.Add(surveyNode)
                                End If
                            Next
                        End If
                    Next
                End If
            End If
        Next

    End Sub

    Private Function FindNode(ByVal ID As Integer, ByVal nodeType As NavigationNodeType) As TreeNode

        'Hopefully the selected node is the one we are looking for
        If ClientStudySurveyTree.SelectedNode IsNot Nothing Then
            Dim navNode As NavigationNode = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
            If navNode.NodeType = nodeType AndAlso navNode.Id = ID Then
                Return ClientStudySurveyTree.SelectedNode
            End If
        End If

        'If the selected node was not the requested one then look for it
        Return FindNode(ClientStudySurveyTree.Nodes, ID, nodeType)

    End Function

    Private Function FindNode(ByVal nodes As System.Windows.Forms.TreeNodeCollection, ByVal ID As Integer, ByVal nodeType As NavigationNodeType) As TreeNode

        For Each node As TreeNode In nodes
            Dim navNode As NavigationNode = DirectCast(node.Tag, NavigationNode)
            If navNode.NodeType = nodeType AndAlso navNode.Id = ID Then
                Return node
            Else
                Dim tempNode As TreeNode = FindNode(node.Nodes, ID, nodeType)
                If tempNode IsNot Nothing Then
                    Return tempNode
                End If
            End If
        Next

        Return Nothing

    End Function

    Private Sub AddClientGroupToTreeView(ByVal groupNavNode As ClientGroupNavNode)

        Dim groupTreeNode As TreeNode = New TreeNode(groupNavNode.DisplayLabel)
        groupTreeNode.Tag = groupNavNode
        ClientStudySurveyTree.Nodes.Add(groupTreeNode)
        SortChildNodesByLabel(Nothing) 'groupTreeNode)
        ClientStudySurveyTree.SelectedNode = groupTreeNode
        ClientStudySurveyTree.Focus()

    End Sub

    Private Sub AddClientToTreeView(ByVal groupTreeNode As TreeNode, ByVal clientNavNode As ClientNavNode)

        Dim clientTreeNode As TreeNode = New TreeNode(clientNavNode.DisplayLabel)
        clientTreeNode.Tag = clientNavNode
        groupTreeNode.Nodes.Add(clientTreeNode)
        SortChildNodesByLabel(groupTreeNode)
        ClientStudySurveyTree.SelectedNode = clientTreeNode
        ClientStudySurveyTree.Focus()

    End Sub

    Private Sub AddClientToTreeView(ByVal clientNavNode As ClientNavNode)

        Dim clientTreeNode As TreeNode = New TreeNode(clientNavNode.DisplayLabel)
        clientTreeNode.Tag = clientNavNode
        ClientStudySurveyTree.Nodes.Add(clientTreeNode)
        SortChildNodesByLabel(Nothing)
        ClientStudySurveyTree.SelectedNode = clientTreeNode
        ClientStudySurveyTree.Focus()

    End Sub

    Private Sub AddStudyToTreeView(ByVal clientTreeNode As TreeNode, ByVal studyNavNode As StudyNavNode)

        Dim studyTreeNode As TreeNode = New TreeNode(studyNavNode.DisplayLabel)
        studyTreeNode.Tag = studyNavNode
        clientTreeNode.Nodes.Add(studyTreeNode)
        SortChildNodesByLabel(clientTreeNode)
        ClientStudySurveyTree.SelectedNode = studyTreeNode
        ClientStudySurveyTree.Focus()

    End Sub


    Private Sub AddSurveyToTreeView(ByVal studyTreeNode As TreeNode, ByVal surveyNavNode As SurveyNavNode)

        Dim surveyTreeNode As TreeNode = New TreeNode(surveyNavNode.DisplayLabel)
        surveyTreeNode.Tag = surveyNavNode
        studyTreeNode.Nodes.Add(surveyTreeNode)
        SortChildNodesByLabel(studyTreeNode)
        ClientStudySurveyTree.SelectedNode = surveyTreeNode
        ClientStudySurveyTree.Focus()

    End Sub

    Private Sub SortChildNodesByLabel(ByVal rootNode As TreeNode)

        Dim nodeList As New List(Of SortableNode)

        'Add child nodes into a list
        If (rootNode Is Nothing) Then   'Sort client group or client nodes
            For Each node As TreeNode In ClientStudySurveyTree.Nodes
                nodeList.Add(New SortableNode(node))
            Next
        Else    'Sort client or study or survey nodes
            For Each node As TreeNode In rootNode.Nodes
                nodeList.Add(New SortableNode(node))
            Next
        End If

        'Sort nodes by label
        nodeList.Sort()

        'Backup selected node
        Dim selectedNode As TreeNode = ClientStudySurveyTree.SelectedNode

        'Remove all the child nodes under the root node and then
        'attach the sorted nodes to the root node
        ClientStudySurveyTree.BeginUpdate()
        If (rootNode Is Nothing) Then
            ClientStudySurveyTree.Nodes.Clear()
            For Each node As SortableNode In nodeList
                ClientStudySurveyTree.Nodes.Add(node.Node)
            Next
        Else
            rootNode.Nodes.Clear()
            For Each node As SortableNode In nodeList
                rootNode.Nodes.Add(node.Node)
            Next
        End If

        'Restore selected node
        ClientStudySurveyTree.SelectedNode = selectedNode
        ClientStudySurveyTree.EndUpdate()

    End Sub

#End Region

#Region " Sub Classes "

    Private Class SortableNode
        Implements IComparable

        Private mNode As TreeNode

        Public ReadOnly Property Node() As TreeNode
            Get
                Return mNode
            End Get
        End Property

        Public Sub New(ByVal node As TreeNode)

            mNode = node

        End Sub

        Public Function CompareTo(ByVal obj As Object) As Integer Implements System.IComparable.CompareTo

            'Any non-nothing object is greater than nothing
            If obj Is Nothing Then Return 1

            Dim myTaggedObject As Object = mNode.Tag
            Dim myLabel As String

            'Cast to a treenode: error if argument is of a different type
            Dim otherNode As TreeNode = DirectCast(obj, SortableNode).Node
            Dim otherTaggedObject As Object = otherNode.Tag
            Dim otherLabel As String

            If ((TypeOf myTaggedObject Is ClientGroupNavNode AndAlso TypeOf otherTaggedObject Is ClientGroupNavNode) OrElse _
                (TypeOf myTaggedObject Is ClientNavNode AndAlso TypeOf otherTaggedObject Is ClientNavNode) OrElse _
                (TypeOf myTaggedObject Is StudyNavNode AndAlso TypeOf otherTaggedObject Is StudyNavNode) OrElse _
                (TypeOf myTaggedObject Is SurveyNavNode AndAlso TypeOf otherTaggedObject Is SurveyNavNode)) Then
                myLabel = mNode.Text
                otherLabel = otherNode.Text

                'Overwrite CompareTo for Unassigned client group to always be at the bottom of the list
                If TypeOf myTaggedObject Is ClientGroupNavNode AndAlso mNode.Text.ToUpper = "UNASSIGNED" Then
                    Return 1
                End If
                If TypeOf otherTaggedObject Is ClientGroupNavNode AndAlso otherNode.Text.ToUpper = "UNASSIGNED" Then
                    Return -1
                End If

                Return String.Compare(myLabel, otherLabel, True)
            Else
                Throw New ArgumentException("Can not compare tree nodes with different tagged object type")
            End If

        End Function

    End Class

#End Region

#Region " Removed Code "

    'Private Function FindClientGroupNode(ByVal clientGroupId As Integer) As TreeNode

    '    'If we are lucky enough (for most cases we will be lucky), the 
    '    'highlighted tree node is the client group we are looking for
    '    If (ClientStudySurveyTree.SelectedNode IsNot Nothing) Then
    '        Dim navNode As NavigationNode = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
    '        If navNode.NodeType = NavigationNodeType.ClientGroup AndAlso navNode.Id = clientGroupId Then
    '            Return ClientStudySurveyTree.SelectedNode
    '        End If
    '    End If

    '    'If unfortunately the highlighted tree node is not the client group we are
    '    'looking for, we need to lookup all the client group nodes to find out the node
    '    For Each groupNode As TreeNode In ClientStudySurveyTree.Nodes
    '        Dim navNode As NavigationNode = DirectCast(groupNode.Tag, NavigationNode)
    '        If navNode.NodeType = NavigationNodeType.ClientGroup AndAlso navNode.Id = clientGroupId Then
    '            Return groupNode
    '        End If
    '    Next

    '    Return Nothing

    'End Function

    'Private Function FindClientNode(ByVal clientId As Integer) As TreeNode

    '    'If we are lucky enough (for most cases we will be lucky), the 
    '    'highlighted tree node is the client we are looking for
    '    If (ClientStudySurveyTree.SelectedNode IsNot Nothing) Then
    '        Dim navNode As NavigationNode = DirectCast(ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
    '        If navNode.NodeType = NavigationNodeType.Client AndAlso navNode.Id = clientId Then
    '            Return ClientStudySurveyTree.SelectedNode
    '        End If
    '    End If

    '    'If unfortunately the highlighted tree node is not the client we
    '    'are looking for, we need to lookup all the client nodes to find
    '    'out the node
    '    For Each clientNode As TreeNode In ClientStudySurveyTree.Nodes
    '        Dim navNode As NavigationNode = DirectCast(clientNode.Tag, NavigationNode)
    '        If navNode.NodeType = NavigationNodeType.Client AndAlso navNode.Id = clientId Then
    '            Return clientNode
    '        End If
    '    Next

    '    Return Nothing
    'End Function

    'Private Function FindStudyNode(ByVal studyId As Integer) As TreeNode
    '    'If we are lucky enough (for most cases we will be lucky), the 
    '    'highlighted tree node is the study we are looking for
    '    If (Me.ClientStudySurveyTree.SelectedNode IsNot Nothing) Then
    '        Dim navNode As NavigationNode = DirectCast(Me.ClientStudySurveyTree.SelectedNode.Tag, NavigationNode)
    '        If navNode.NodeType = NavigationNodeType.Study AndAlso navNode.Id = studyId Then
    '            Return Me.ClientStudySurveyTree.SelectedNode
    '        End If
    '    End If

    '    'If unfortunately the highlighted tree node is not the study we
    '    'are looking for, we need to lookup all the study nodes to find
    '    'out the node
    '    For Each clientNode As TreeNode In Me.ClientStudySurveyTree.Nodes
    '        For Each studyNode As TreeNode In clientNode.Nodes
    '            Dim navNode As NavigationNode = DirectCast(studyNode.Tag, NavigationNode)
    '            If navNode.NodeType = NavigationNodeType.Study AndAlso navNode.Id = studyId Then
    '                Return studyNode
    '            End If
    '        Next
    '    Next

    '    Return Nothing
    'End Function

#End Region

End Class


