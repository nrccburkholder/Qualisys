Imports Nrc.DataMart.Library

Public Class ClientStudySurveyNavigator

    Public Event SelectionChanged As EventHandler
    Public Event BeforeSelection As EventHandler

#Region " Private Instance Fields "
    Private mSelectedClients As New Collection(Of Client)
    Private mSelectedStudies As New Collection(Of Study)
    Private mSelectedSurveys As New Collection(Of Survey)
    Private mSelectedClientIds As New List(Of Integer)
    Private mSelectedStudyIds As New List(Of Integer)
    Private mSelectedSurveyIds As New List(Of Integer)
    Private mSurveyIndex As New Dictionary(Of Integer, Survey)

#End Region

#Region " Public Properties "
    Public ReadOnly Property SelectedClients() As Collection(Of Client)
        Get
            Return Me.mSelectedClients
        End Get
    End Property

    Public ReadOnly Property SelectedStudies() As Collection(Of Study)
        Get
            Return Me.mSelectedStudies
        End Get
    End Property

    Public ReadOnly Property SelectedSurveys() As Collection(Of Survey)
        Get
            Return Me.mSelectedSurveys
        End Get
    End Property

    Public ReadOnly Property SelectedClientIds() As List(Of Integer)
        Get
            Return Me.mSelectedClientIds
        End Get
    End Property

    Public ReadOnly Property SelectedStudyIds() As List(Of Integer)
        Get
            Return Me.mSelectedStudyIds
        End Get
    End Property

    Public ReadOnly Property SelectedSurveyIds() As List(Of Integer)
        Get
            Return Me.mSelectedSurveyIds
        End Get
    End Property
#End Region

    Private Sub ClientStudySurveyNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim clientList As Collection(Of Client)
        clientList = Client.GetClientsByUser(Environment.UserName, Client.PopulateDepth.Study)

        Me.PopulateTree(clientList)
    End Sub

    Private Sub PopulateTree(ByVal clientList As Collection(Of Client))
        Dim newClientNode As TreeNode
        For Each clnt As Client In clientList
            newClientNode = New TreeNode(clnt.DisplayLabel)
            newClientNode.Tag = clnt
            ClientStudySurveyTree.Nodes.Add(newClientNode)

            Dim newStudyNode As TreeNode
            For Each stdy As Study In clnt.Studies
                newStudyNode = New TreeNode(stdy.DisplayLabel)
                newStudyNode.Tag = stdy
                newClientNode.Nodes.Add(newStudyNode)
            Next
        Next
    End Sub

    Private Sub ClearLists()
        Me.mSelectedClients.Clear()
        Me.mSelectedClientIds.Clear()
        Me.mSelectedStudies.Clear()
        Me.mSelectedStudyIds.Clear()
        Me.mSelectedSurveys.Clear()
        Me.mSelectedSurveyIds.Clear()
    End Sub

    Private Sub BuildSelectionLists()
        Dim node As TreeNode

        ClearLists()
        For Each node In Me.ClientStudySurveyTree.SelectedNodes
            If TypeOf (node.Tag) Is Client Then
                Dim clnt As Client = DirectCast(node.Tag, Client)
                Me.mSelectedClients.Add(clnt)
                Me.mSelectedClientIds.Add(clnt.Id)
            ElseIf TypeOf (node.Tag) Is Study Then
                Dim stdy As Study = DirectCast(node.Tag, Study)
                Me.mSelectedStudies.Add(stdy)
                Me.mSelectedStudyIds.Add(stdy.Id)
            ElseIf TypeOf (node.Tag) Is Survey Then
                Dim srvy As Survey = DirectCast(node.Tag, Survey)
                Me.mSelectedSurveys.Add(srvy)
                Me.mSelectedSurveyIds.Add(srvy.Id)
            End If

            'Check to see if a client node is selected and short circuit
            If Me.mSelectedClients.Count > 0 Then
                ClearLists()
                Exit Sub
            End If
        Next

    End Sub

    Private Sub ClientStudySurveyTree_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles ClientStudySurveyTree.BeforeSelect
        RaiseEvent BeforeSelection(Me, EventArgs.Empty)
    End Sub

    Private Sub ClientStudySurveyTree_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClientStudySurveyTree.SelectionChanged
        Me.BuildSelectionLists()
        RaiseEvent SelectionChanged(Me, EventArgs.Empty)
    End Sub

    Public Function FindSurvey(ByVal surveyId As Integer) As Survey
        Dim srvy As Survey = Nothing
        Me.mSurveyIndex.TryGetValue(surveyId, srvy)
        Return srvy
    End Function
End Class
