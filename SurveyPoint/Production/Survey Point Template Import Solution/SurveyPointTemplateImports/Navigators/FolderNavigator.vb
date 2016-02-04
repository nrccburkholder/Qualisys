Public Class FolderNavigator
    Inherits Navigator


    Public Event FolderChanged As EventHandler(Of FolderChangedEventArgs)

    Private Sub FolderNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GetTreeNodes(FolderTree.Nodes, New System.IO.DirectoryInfo(My.Computer.FileSystem.SpecialDirectories.MyDocuments))
    End Sub

    Private Sub GetTreeNodes(ByVal nodes As TreeNodeCollection, ByVal rootDirectory As System.IO.DirectoryInfo)
        Dim newNode As TreeNode = nodes.Add(rootDirectory.FullName, rootDirectory.Name)

        For Each subDirectory As System.IO.DirectoryInfo In rootDirectory.GetDirectories
            GetTreeNodes(newNode.Nodes, subDirectory)
        Next
    End Sub

    Private Sub FolderTree_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles FolderTree.AfterSelect
        RaiseEvent FolderChanged(Me, New FolderChangedEventArgs(e.Node.Name))
    End Sub
End Class

