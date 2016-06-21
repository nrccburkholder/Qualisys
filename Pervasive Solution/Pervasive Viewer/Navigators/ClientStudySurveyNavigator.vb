Imports Nrc.QualiSys.Pervasive.Library.Navigation
Imports Nrc.QualiSys.Pervasive.Library

Public Class ClientStudySurveyNavigator

#Region " Private Members "

    Private mNavigationTree As NavigationTree
    Private mSelectedClientGroup As ClientGroupNavNode
    Private mSelectedClient As ClientNavNode
    Private mSelectedStudy As StudyNavNode
    Private mSelectedSurvey As SurveyNavNode
    Private mSelectedDataFile As DataFileNavNode
    Private mDataFileState As DataFileStates
    Private mLoading As Boolean
    Private mDataFileStates As List(Of DataFileStates)

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

    Public ReadOnly Property SelectedDataFile() As DataFileNavNode
        Get
            Return mSelectedDataFile
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

    'Public Sub New(ByVal dataFileState As DataFileStates)

    '    ' This call is required by the Windows Form Designer.
    '    InitializeComponent()

    '    ' Add any initialization after the InitializeComponent() call.
    '    mLoading = True
    '    ClientFilterList.SelectedIndex = 0
    '    mDataFileState = dataFileState
    '    mLoading = False

    'End Sub

    Public Sub New(ByVal dataFileStates As List(Of DataFileStates))

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mLoading = True
        ClientFilterList.SelectedIndex = 0
        mDataFileStates = dataFileStates
        mLoading = False

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
        PopulateTree()

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

                Case NavigationNodeType.DataFile
                    mSelectedDataFile = DirectCast(node, DataFileNavNode)
                    mSelectedSurvey = mSelectedDataFile.Survey
                    mSelectedStudy = mSelectedSurvey.Study
                    mSelectedClient = mSelectedStudy.Client
                    mSelectedClientGroup = mSelectedClient.ClientGroup
                    OnSelectionChanged(New ClientStudySurveySelectionChangedEventArgs(node.NodeType))

            End Select

            'OnSelectionChanged(New ClientStudySurveySelectionChangedEventArgs(node.NodeType))
        End If

    End Sub

    Private Sub ClientFilterList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClientFilterList.SelectedIndexChanged

        'When the filter list changes then re-populate the tree
        If ClientFilterList.SelectedIndex > -1 Then
            PopulateTree()
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

        PopulateTree()

    End Sub

#End Region

#Region " Public Methods "
    Public Sub PopulateTree()

        If Not mLoading Then
            mNavigationTree = NavigationTree.GetByUser(CurrentUser.UserName, InitialPopulationDepth.Survey, ShowClientGroupsTSButton.Checked, mDataFileStates)

            ClientStudySurveyTree.BeginUpdate()
            ClientStudySurveyTree.Nodes.Clear()

            If ShowClientGroupsTSButton.Checked Then
                PopulateTreeFromClientGroup(mNavigationTree)
            Else
                PopulateTreeFromClient(mNavigationTree)
            End If

            ClientStudySurveyTree.EndUpdate()
        End If

    End Sub


#End Region

#Region " Private Methods "
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

                                            'Loop through all datafiles
                                            For Each df As DataFileNavNode In srvy.DataFiles
                                                'Add the datafile if the active state is set appropriately
                                                If ShowAllTSButton.Checked OrElse srvy.IsActive Then
                                                    Dim dfNode As TreeNode = New TreeNode(df.DisplayLabel)
                                                    dfNode.Tag = df
                                                    dfNode.ForeColor = df.ForeColor
                                                    surveyNode.Nodes.Add(dfNode)
                                                End If
                                            Next
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

                                    'Loop through all datafiles
                                    For Each df As DataFileNavNode In srvy.DataFiles
                                        'Add the datafile if the active state is set appropriately
                                        If ShowAllTSButton.Checked OrElse srvy.IsActive Then
                                            Dim dfNode As TreeNode = New TreeNode(df.DisplayLabel)
                                            dfNode.Tag = df
                                            dfNode.ForeColor = df.ForeColor
                                            surveyNode.Nodes.Add(dfNode)
                                        End If
                                    Next
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

#End Region

End Class


