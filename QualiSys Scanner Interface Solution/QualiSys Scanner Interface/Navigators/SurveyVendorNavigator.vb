Imports Nrc.Qualisys.Library.Navigation

Public Class SurveyVendorNavigator

    Public Event SelectedNodeChanging As EventHandler(Of SelectedNodeChangingEventArgs)
    Public Event SelectedNodeChanged As EventHandler(Of SelectedNodeChangedEventArgs)


#Region " Private Members "
    Private mNavigationTree As NavigationTree
    Private mFormLoading As Boolean
#End Region

#Region " Private Properties "
    Private ReadOnly Property ShowAllClients() As Boolean
        Get
            Return (Me.ClientFilterList.SelectedIndex = 1)
        End Get
    End Property
#End Region

#Region " Public Methods "
    Public Sub PopulateTree(ByVal navTree As NavigationTree)

        Dim newClientNode As TreeNode
        SurveyTreeView.BeginUpdate()
        SurveyTreeView.Nodes.Clear()

        For Each clnt As ClientNavNode In navTree.Clients
            'Add the client if it has studies or if we are in "show all" mode
            If clnt.Studies.Count > 0 OrElse Me.ShowAllClients Then
                newClientNode = New TreeNode(clnt.DisplayLabel)
                newClientNode.Tag = clnt
                SurveyTreeView.Nodes.Add(newClientNode)

                Dim newStudyNode As TreeNode
                For Each stdy As StudyNavNode In clnt.Studies
                    newStudyNode = New TreeNode(stdy.DisplayLabel)
                    newStudyNode.Tag = stdy
                    newClientNode.Nodes.Add(newStudyNode)

                    Dim newSurveyNode As TreeNode
                    For Each srvy As SurveyNavNode In stdy.Surveys
                        newSurveyNode = New TreeNode(srvy.DisplayLabel)
                        newSurveyNode.Tag = srvy
                        newStudyNode.Nodes.Add(newSurveyNode)
                    Next
                Next
            End If
        Next
        SurveyTreeView.EndUpdate()

    End Sub

    Private Sub VendorMaintenanceNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ClientFilterList.SelectedIndex = 0
        mNavigationTree = NavigationTree.GetByUser(CurrentUser.UserName, InitialPopulationDepth.Survey, False)
        Me.PopulateTree(mNavigationTree)
        mFormLoading = False

    End Sub
#End Region

#Region "Events"
    Private Sub ClientFilterList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClientFilterList.SelectedIndexChanged
        'When the filter list changes then re-populate the tree
        If Not mFormLoading And Me.ClientFilterList.SelectedIndex > -1 Then
            Me.PopulateTree(Me.mNavigationTree)
        End If
    End Sub

    Private Sub SurveyTreeView_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles SurveyTreeView.BeforeSelect

        'Create the event arguement object
        Dim eventArgs As New SelectedNodeChangingEventArgs(SurveyTreeView.SelectedNode, e.Node)

        'Raise the event
        RaiseEvent SelectedNodeChanging(Me, eventArgs)

        'Determine next step
        e.Cancel = eventArgs.Cancel

    End Sub

    Private Sub SurveyTreeView_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles SurveyTreeView.AfterSelect

        If e.Action <> TreeViewAction.Collapse AndAlso e.Action <> TreeViewAction.Expand Then
            Dim node As NavigationNode = DirectCast(Me.SurveyTreeView.SelectedNode.Tag, NavigationNode)

            Select Case node.NodeType
                Case NavigationNodeType.Survey
                    RaiseEvent SelectedNodeChanged(Me, New SelectedNodeChangedEventArgs(e.Node))
            End Select

        End If

    End Sub
#End Region

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mFormLoading = True

    End Sub
End Class
