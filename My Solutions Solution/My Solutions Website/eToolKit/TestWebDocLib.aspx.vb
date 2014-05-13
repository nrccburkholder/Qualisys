Imports Nrc.NRCWebDocumentManagerLibrary
Imports System.io

Partial Public Class TestWebDocLib
    Inherits ToolKitPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not Me.IsPostBack) Then
            Dim docTree As DocumentTree

            Try
                'Get the document tree
                docTree = DocumentTree.GetApbDocumentTree(CurrentUser.SelectedGroup.GroupId, CurrentUser.Member.MemberId, 4)

                'Add each root folder to the tree
                Me.TreeView1.Nodes.Clear()
                For Each docNode As DocumentNode In docTree.Nodes
                    LoadFolder(docNode, TreeView1.Nodes)
                Next

            Catch ex As Exception
                Throw
            End Try

        End If
    End Sub

    Private Sub LoadFolder(ByVal docNode As DocumentNode, ByVal nodes As TreeNodeCollection)
        Dim treeNode As New TreeNode

        'Set the properties for this folder node
        treeNode.Text = docNode.Name
        treeNode.ToolTip = docNode.Name
        treeNode.SelectAction = TreeNodeSelectAction.None
        If (docNode.Expanded) Then treeNode.Expand()

        'Load up each of the documents in this folder
        For Each doc As Document In docNode.Documents
            LoadDocument(treeNode, doc)
        Next

        'Now recursively load up each sub folder
        For Each childNode As DocumentNode In docNode.Nodes
            LoadFolder(childNode, treeNode.ChildNodes)
        Next

        'Add this node to the parent node collection
        nodes.Add(treeNode)

    End Sub

    Private Sub LoadDocument(ByVal folderNode As TreeNode, ByVal doc As Document)
        Dim treeNode As New TreeNode

        'Set the properties for this document node
        treeNode.Text = doc.Name
        treeNode.NavigateUrl = "~/Shared/DownloadDocument.aspx?id=" & doc.DocumentNodeId
        treeNode.Target = "_Blank"

        'Add document to the parent node collection
        folderNode.ChildNodes.Add(treeNode)

    End Sub

End Class