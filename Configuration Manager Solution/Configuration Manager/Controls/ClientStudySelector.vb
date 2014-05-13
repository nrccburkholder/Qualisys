Imports Nrc.Qualisys.Library.Navigation

Public Class ClientStudySelector

#Region " Private Members "

    Private mNavigationTree As NavigationTree
    Private mSelectedClientGroup As ClientGroupNavNode
    Private mSelectedClient As ClientNavNode
    Private mSelectedStudy As StudyNavNode
    Private mInitializing As Boolean = False

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

#End Region

#Region " Private Properties "

    Private ReadOnly Property ShowAllClients() As Boolean
        Get
            Return (ClientFilterList.SelectedIndex = 1)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

    End Sub

#End Region

#Region " SelectionChanged Event "

    Public Event SelectionChanged As EventHandler(Of ClientStudySurveySelectionChangedEventArgs)

    Public Overridable Sub OnSelectionChanged(ByVal e As ClientStudySurveySelectionChangedEventArgs)

        RaiseEvent SelectionChanged(Me, e)

    End Sub

#End Region

#Region " Control Event Handlers "

    Private Sub ClientStudyNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Private Sub ClientStudyTree_SelectionChanged(ByVal sender As Object, ByVal e As TreeViewEventArgs) Handles ClientStudyTree.AfterSelect

        If e.Action <> TreeViewAction.Collapse AndAlso e.Action <> TreeViewAction.Expand Then
            Dim node As NavigationNode = DirectCast(ClientStudyTree.SelectedNode.Tag, NavigationNode)

            Select Case node.NodeType
                Case NavigationNodeType.ClientGroup
                    mSelectedClientGroup = DirectCast(node, ClientGroupNavNode)
                    mSelectedClient = Nothing
                    mSelectedStudy = Nothing

                Case NavigationNodeType.Client
                    mSelectedClient = DirectCast(node, ClientNavNode)
                    mSelectedClientGroup = mSelectedClient.ClientGroup
                    mSelectedStudy = Nothing

                Case NavigationNodeType.Study
                    mSelectedStudy = DirectCast(node, StudyNavNode)
                    mSelectedClient = mSelectedStudy.Client
                    mSelectedClientGroup = mSelectedClient.ClientGroup

            End Select

            If Not mInitializing Then OnSelectionChanged(New ClientStudySurveySelectionChangedEventArgs(node.NodeType))
        End If

    End Sub

    Private Sub ClientFilterList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClientFilterList.SelectedIndexChanged

        If mInitializing Then Exit Sub

        'When the filter list changes then re-populate the tree
        If ClientFilterList.SelectedIndex > -1 Then
            PopulateTree()
        End If

    End Sub

    Private Sub ShowClientGroupsTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowClientGroupsTSButton.Click

        If mInitializing Then Exit Sub

        With ShowClientGroupsTSButton
            'Change the checked state
            .Checked = Not .Checked

            'Capture selected node before tree refresh
            Dim node As NavigationNode = Nothing
            If ClientStudyTree.SelectedNode IsNot Nothing Then
                node = DirectCast(ClientStudyTree.SelectedNode.Tag, NavigationNode)
            End If

            'Reload the tree and save the state
            My.Settings.ClientStudySurveyNavigatorIncludeGroups = .Checked
            mNavigationTree = NavigationTree.GetByUser(CurrentUser.UserName, InitialPopulationDepth.Study, .Checked)
            PopulateTree()

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
                    ClientStudyTree.SelectedNode = treeNode
                    treeNode.EnsureVisible()

                ElseIf Not ShowClientGroupsTSButton.Checked Then
                    'Client group was selected node but now not in tree, set to first node
                    ClientStudyTree.SelectedNode = ClientStudyTree.Nodes(0)

                End If
            End If

        End With

    End Sub

    Private Sub ShowAllTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowAllTSButton.Click

        If mInitializing Then Exit Sub

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

        mNavigationTree = NavigationTree.GetByUser(CurrentUser.UserName, InitialPopulationDepth.Study, ShowClientGroupsTSButton.Checked)
        PopulateTree()

    End Sub

#End Region

#Region " Public Methods "

    Public Sub InitializeTree(ByVal clientFilterIndex As Integer, ByVal showAll As Boolean, ByVal showClientGroups As Boolean, ByVal selectedStudyID As Integer)

        mInitializing = True

        ClientFilterList.SelectedIndex = clientFilterIndex
        ShowAllTSButton.Checked = showAll
        ShowClientGroupsTSButton.Checked = showClientGroups

        mInitializing = False

        mNavigationTree = NavigationTree.GetByUser(CurrentUser.UserName, InitialPopulationDepth.Study, ShowClientGroupsTSButton.Checked)
        PopulateTree()

        If selectedStudyID > 0 Then
            Dim treeNode As TreeNode = FindNode(selectedStudyID, NavigationNodeType.Study)
            If treeNode IsNot Nothing Then
                ClientStudyTree.SelectedNode = treeNode
                treeNode.EnsureVisible()
            End If
        End If

    End Sub

#End Region

#Region " Private Methods "

    Private Sub PopulateTree()

        If mNavigationTree Is Nothing Then Exit Sub

        ClientStudyTree.BeginUpdate()
        ClientStudyTree.Nodes.Clear()

        If ShowClientGroupsTSButton.Checked Then
            PopulateTreeFromClientGroup()
        Else
            PopulateTreeFromClient()
        End If

        ClientStudyTree.EndUpdate()

    End Sub

    Private Sub PopulateTreeFromClientGroup()

        'Loop through all of the client groups
        mNavigationTree.ClientGroups.SortByName()
        For Each group As ClientGroupNavNode In mNavigationTree.ClientGroups
            'Add the client group if the active state is set appropriately
            If ShowAllTSButton.Checked OrElse group.IsActive Then
                Dim groupNode As TreeNode = New TreeNode(group.DisplayLabel)
                groupNode.Tag = group
                groupNode.ForeColor = group.ForeColor
                ClientStudyTree.Nodes.Add(groupNode)

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
                                End If
                            Next
                        End If
                    End If
                Next
            End If
        Next

    End Sub

    Private Sub PopulateTreeFromClient()

        'Loop through all of the clients
        For Each clnt As ClientNavNode In mNavigationTree.Clients
            'Add the client if the active state is set appropriately
            If ShowAllTSButton.Checked OrElse clnt.IsActive Then
                'Add the client if it has studies or if we are in "show all" mode
                If clnt.Studies.Count > 0 OrElse ShowAllClients Then
                    Dim clientNode As TreeNode = New TreeNode(clnt.DisplayLabel)
                    clientNode.Tag = clnt
                    clientNode.ForeColor = clnt.ForeColor
                    ClientStudyTree.Nodes.Add(clientNode)

                    'Loop through all studies
                    For Each stdy As StudyNavNode In clnt.Studies
                        'Add the study if the active state is set appropriately
                        If ShowAllTSButton.Checked OrElse stdy.IsActive Then
                            Dim studyNode As TreeNode = New TreeNode(stdy.DisplayLabel)
                            studyNode.Tag = stdy
                            studyNode.ForeColor = stdy.ForeColor
                            clientNode.Nodes.Add(studyNode)
                        End If
                    Next
                End If
            End If
        Next

    End Sub

    Private Function FindNode(ByVal ID As Integer, ByVal nodeType As NavigationNodeType) As TreeNode

        'Hopefully the selected node is the one we are looking for
        If ClientStudyTree.SelectedNode IsNot Nothing Then
            Dim navNode As NavigationNode = DirectCast(ClientStudyTree.SelectedNode.Tag, NavigationNode)
            If navNode.NodeType = nodeType AndAlso navNode.Id = ID Then
                Return ClientStudyTree.SelectedNode
            End If
        End If

        'If the selected node was not the requested one then look for it
        Return FindNode(ClientStudyTree.Nodes, ID, nodeType)

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

#End Region

End Class


