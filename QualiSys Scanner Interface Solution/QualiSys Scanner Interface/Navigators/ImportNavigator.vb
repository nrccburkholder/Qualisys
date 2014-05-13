Public Class ImportNavigator

    Public Event FolderChanged As EventHandler(Of FolderChangedEventArgs)


    Private Sub MainExpTree_ExpTreeNodeSelected(ByVal SelPath As String, ByVal Item As ExpTreeLib.CShItem) Handles MainExpTree.ExpTreeNodeSelected

        'Fire the FolderChanged event to whatever might be listening
        RaiseEvent FolderChanged(Me, New FolderChangedEventArgs(SelPath, Item))

    End Sub

End Class
