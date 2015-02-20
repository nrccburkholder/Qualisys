Imports Nrc.Qualisys.Library

Public Class ClientStudySurveyNavigator

    Private mSelectedSurveys As New Collection(Of Survey)
    Private mSection As Section

    Public Event SelectionChanged As EventHandler

    Public Overrides Sub RegisterSectionControl(ByVal sect As Section)
        mSection = sect
    End Sub

    Public ReadOnly Property SelectedSurveys() As Collection(Of Survey)
        Get
            Return mSelectedSurveys
        End Get
    End Property

    Private Sub ClientStudySurveyNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim clients As Collection(Of Client) = Client.GetClientsByUser(CurrentUser.UserName, PopulateDepth.Survey)
        Me.PopulateTree(clients)
    End Sub

    Private Sub PopulateTree(ByVal clients As Collection(Of Client))
        Dim newClientNode As TreeNode

        For Each clnt As Client In clients
            newClientNode = New TreeNode(clnt.DisplayLabel)
            newClientNode.ImageIndex = 3
            newClientNode.SelectedImageIndex = 3
            newClientNode.Tag = clnt
            SurveyTree.Nodes.Add(newClientNode)

            Dim newStudyNode As TreeNode
            For Each stdy As Study In clnt.Studies
                newStudyNode = New TreeNode(stdy.DisplayLabel)
                newStudyNode.ImageIndex = 2
                newStudyNode.SelectedImageIndex = 2
                newStudyNode.Tag = stdy
                newClientNode.Nodes.Add(newStudyNode)

                Dim newSurveyNode As TreeNode
                For Each srvy As Survey In stdy.Surveys
                    newSurveyNode = New TreeNode(srvy.DisplayLabel)
                    newSurveyNode.Tag = srvy
                    newSurveyNode.SelectedImageIndex = 0
                    If srvy.IsValidated Then
                        newSurveyNode.ImageIndex = 1
                        newSurveyNode.SelectedImageIndex = 1
                    End If
                    newStudyNode.Nodes.Add(newSurveyNode)
                Next
            Next
        Next
    End Sub

    Private Sub SurveyTree_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles SurveyTree.BeforeSelect
        If mSection.AllowUnload = False Then
            e.Cancel = True
        End If
    End Sub

    Private Sub SurveyTree_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SurveyTree.SelectionChanged
        Me.BuildSelectedSurveyList()
        RaiseEvent SelectionChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub BuildSelectedSurveyList()
        Me.mSelectedSurveys = New Collection(Of Survey)
        Dim srvy As Survey
        Dim studyId As Integer = -1

        For Each node As TreeNode In Me.SurveyTree.SelectedNodes
            If TypeOf node.Tag Is Survey Then
                srvy = DirectCast(node.Tag, Survey)
                If (studyId <> -1 AndAlso studyId <> srvy.StudyId) OrElse (srvy.IsValidated = False) Then
                    Me.mSelectedSurveys.Clear()
                    Exit Sub
                End If
                Me.mSelectedSurveys.Add(srvy)
                studyId = srvy.StudyId
            Else
                Me.mSelectedSurveys.Clear()
                Exit Sub
            End If
        Next
    End Sub
    Private Sub DeselectNonSurveyNodes()
        Dim illegalNodes As New List(Of TreeNode)
        For Each node As TreeNode In Me.SurveyTree.SelectedNodes
            If Not TypeOf node.Tag Is Survey Then
                illegalNodes.Add(node)
            End If
        Next
        For Each node As TreeNode In illegalNodes
            Me.SurveyTree.DeselectNode(node)
        Next
    End Sub

#Region "Refresh Methods"
    Private Function BuildSelectedNodesLists() As Collection(Of Collection(Of Integer))
        Dim selectedSurveys As New Collection(Of Integer)
        Dim selectedStudies As New Collection(Of Integer)
        Dim selectedClients As New Collection(Of Integer)
        Dim selectedClientStudiesSurveys As New Collection(Of Collection(Of Integer))

        selectedClientStudiesSurveys.Add(selectedClients)
        selectedClientStudiesSurveys.Add(selectedStudies)
        selectedClientStudiesSurveys.Add(selectedSurveys)

        For Each node As TreeNode In Me.SurveyTree.SelectedNodes
            If TypeOf node.Tag Is Client Then
                selectedClients.Add(DirectCast(node.Tag, Client).Id)
            ElseIf TypeOf node.Tag Is Study Then
                selectedStudies.Add(DirectCast(node.Tag, Study).Id)
            Else
                selectedSurveys.Add(DirectCast(node.Tag, Survey).Id)
            End If
        Next

        Return selectedClientStudiesSurveys
    End Function

    Private Sub RefreshButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefreshButton.Click
        Dim selectedClientStudiesSurveys As New Collection(Of Collection(Of Integer))

        'get all of the selected surveys so we can reselect the correct nodes
        selectedClientStudiesSurveys = BuildSelectedNodesLists()

        Dim clients As Collection(Of Client) = Client.GetClientsByUser(CurrentUser.UserName, PopulateDepth.Survey)
        Me.SurveyTree.Nodes.Clear()
        Me.SurveyTree.SelectedNodes.Clear()
        Me.PopulateTree(clients)

        'Reselect the previously selected surveys
        For Each clientNode As TreeNode In SurveyTree.Nodes
            ReSelectNodesAfterRefresh(clientNode, selectedClientStudiesSurveys)
            For Each studyNode As TreeNode In clientNode.Nodes
                ReSelectNodesAfterRefresh(studyNode, selectedClientStudiesSurveys)
                For Each surveyNode As TreeNode In studyNode.Nodes
                    ReSelectNodesAfterRefresh(surveyNode, selectedClientStudiesSurveys)
                    If AllPreviouslySelectedNodesReselected(selectedClientStudiesSurveys) Then Exit Sub
                Next
                If AllPreviouslySelectedNodesReselected(selectedClientStudiesSurveys) Then Exit Sub
            Next
            If AllPreviouslySelectedNodesReselected(selectedClientStudiesSurveys) Then Exit Sub
        Next

        'Force an update of the new sample control
        Me.BuildSelectedSurveyList()
        RaiseEvent SelectionChanged(Me, EventArgs.Empty)
    End Sub

    Private Function AllPreviouslySelectedNodesReselected(ByVal selectedClientStudiesSurveys As Collection(Of Collection(Of Integer))) As Boolean
        Return selectedClientStudiesSurveys(0).Count = 0 AndAlso selectedClientStudiesSurveys(1).Count = 0 AndAlso selectedClientStudiesSurveys(2).Count = 0
    End Function

    Private Sub ReSelectNodesAfterRefresh(ByVal node As TreeNode, ByVal selectedClientStudiesSurveys As Collection(Of Collection(Of Integer)))
        If TypeOf node.Tag Is Client Then
            If selectedClientStudiesSurveys(0).Contains(DirectCast(node.Tag, Client).Id) Then
                Me.SurveyTree.SelectNode(node)
                node.Expand()
            End If
        ElseIf TypeOf node.Tag Is Study Then
            If selectedClientStudiesSurveys(1).Contains(DirectCast(node.Tag, Study).Id) Then
                Me.SurveyTree.SelectNode(node)
                node.Expand()
                ExpandParentNode(node.Parent)
            End If
        Else
            If selectedClientStudiesSurveys(2).Contains(DirectCast(node.Tag, Survey).Id) Then
                Me.SurveyTree.SelectNode(node)
                node.Expand()
                ExpandParentNode(node.Parent)
            End If
        End If
    End Sub

    Private Sub ExpandParentNode(ByVal parentNode As TreeNode)
        parentNode.Expand()
        If parentNode.Parent IsNot Nothing Then
            ExpandParentNode(parentNode.Parent)
        End If
    End Sub
#End Region
End Class
