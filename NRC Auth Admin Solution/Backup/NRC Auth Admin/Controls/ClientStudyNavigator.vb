Imports Nrc.DataMart.Library
Imports System.Collections.ObjectModel

Public Class ClientStudyNavigator

    Public Event SelectionChanged As EventHandler
    Public Event BeforeSelection As EventHandler

#Region " Private Instance Fields "
    Private mSelectedClient As Client
    Private mSelectedStudy As Study
    Private mSelectedClientId As Integer
    Private mSelectedStudyId As Integer
#End Region

#Region " Public Properties "
    Public ReadOnly Property SelectedClient() As Client
        Get
            Return Me.mSelectedClient
        End Get
    End Property

    Public ReadOnly Property SelectedStudy() As Study
        Get
            Return Me.mSelectedStudy
        End Get
    End Property

    Public ReadOnly Property SelectedClientId() As Integer
        Get
            Return Me.mSelectedClientId
        End Get
    End Property

    Public ReadOnly Property SelectedStudyId() As Integer
        Get
            Return Me.mSelectedStudyId
        End Get
    End Property
#End Region

    Private Sub ClientStudyNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim clientList As Collection(Of Client)
        clientList = Client.GetClientsByUser(Environment.UserName, Client.PopulateDepth.Study)

        Me.PopulateTree(clientList)
        Me.ClientStudyTree.Visible = True
    End Sub

    Private Sub PopulateTree(ByVal clientList As Collection(Of Client))
        Dim newClientNode As TreeNode
        For Each clnt As Client In clientList
            newClientNode = New TreeNode(clnt.DisplayLabel)
            newClientNode.Tag = clnt
            ClientStudyTree.Nodes.Add(newClientNode)

            Dim newStudyNode As TreeNode
            For Each stdy As Study In clnt.Studies
                newStudyNode = New TreeNode(stdy.DisplayLabel)
                newStudyNode.Tag = stdy
                newClientNode.Nodes.Add(newStudyNode)
            Next
        Next
    End Sub

    Private Sub ClearLists()
        Me.mSelectedClient = Nothing
        Me.mSelectedClientId = Nothing
        Me.mSelectedStudy = Nothing
        Me.mSelectedStudyId = Nothing
    End Sub

    Private Sub BuildSelectionLists()
        Dim node As TreeNode = Me.ClientStudyTree.SelectedNode

        ClearLists()
        If TypeOf (node.Tag) Is Client Then
            Me.mSelectedClient = DirectCast(node.Tag, Client)
            Me.mSelectedClientId = mSelectedClient.Id
        ElseIf TypeOf (node.Tag) Is Study Then
            Me.mSelectedStudy = DirectCast(node.Tag, Study)
            Me.mSelectedStudyId = mSelectedStudy.Id
        End If

        'Check to see if a client node is selected and short circuit
        If Me.mSelectedClient IsNot Nothing Then
            ClearLists()
            Exit Sub
        End If
    End Sub

    Private Sub ClientStudyTree_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles ClientStudyTree.BeforeSelect
        RaiseEvent BeforeSelection(Me, EventArgs.Empty)
    End Sub

    Private Sub ClientStudyTree_SelectionChanged(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles ClientStudyTree.AfterSelect
        Me.BuildSelectionLists()
        RaiseEvent SelectionChanged(Me, EventArgs.Empty)
    End Sub

End Class
