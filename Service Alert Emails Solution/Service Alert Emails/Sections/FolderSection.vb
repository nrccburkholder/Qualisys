Public Class FolderSection
    Inherits Section

    Private mFolderNavigator As FolderNavigator
    Private mCurrentDirectory As System.IO.DirectoryInfo

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mFolderNavigator = TryCast(navCtrl, FolderNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Private Sub mFolderNavigator_FolderChanged(ByVal sender As Object, ByVal e As FolderChangedEventArgs)
        UpdateFolderContents(e.FolderPath)
    End Sub

    Private Sub UpdateFolderContents(ByVal folderPath As String)
        Me.ContentsListView.Items.Clear()
        mCurrentDirectory = New System.IO.DirectoryInfo(folderPath)

        Dim folderCount As Integer = 0
        For Each folder As System.IO.DirectoryInfo In mCurrentDirectory.GetDirectories
            Me.ContentsListView.Items.Add(folder.Name, "Folder")
            folderCount += 1
        Next

        Dim fileCount As Integer = 0
        For Each file As System.IO.FileInfo In mCurrentDirectory.GetFiles
            Me.ContentsListView.Items.Add(file.Name, "File")
            fileCount += 1
        Next

        mCurrentDirectory = mCurrentDirectory
        Me.PathLabel.Text = String.Format("Full Path: {0}", mCurrentDirectory.FullName)
        Me.CreationDateLabel.Text = String.Format("Creation Date: {0}", mCurrentDirectory.CreationTime.ToString)
        Me.FolderCountLabel.Text = String.Format("Folder Count: {0}", folderCount)
        Me.FileCountLabel.Text = String.Format("File Count: {0}", fileCount)
    End Sub

    ''' <summary>
    ''' If a folder is selected, we want to update the selected node in the navigator control.
    ''' If a file is selected, we want to open it.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks>This method detects when a user double clicks an item in the contents list of the section control.  
    ''' If the item is a folder, we will update the selected node in the navigator control.  Updating the 
    ''' selected node causes the contents of the folder section to update automatically.  If the user double 
    ''' clicks a file, we will open the file.
    ''' </remarks>
    Private Sub ContentsListView_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles ContentsListView.DoubleClick
        Dim selectedItem As String
        Dim PriorDirectory As System.IO.DirectoryInfo
        Dim fullPath As String
        Dim PriorSelectedNode As TreeNode

        PriorDirectory = mCurrentDirectory
        PriorSelectedNode = mFolderNavigator.FolderTree.SelectedNode

        For Each item As ListViewItem In ContentsListView.SelectedItems
            selectedItem = item.Text
            fullPath = PriorDirectory.FullName + "\" + selectedItem

            If PriorDirectory.GetDirectories(selectedItem).Length > 0 Then
                mFolderNavigator.FolderTree.SelectedNode = PriorSelectedNode.Nodes.Item(fullPath)
            ElseIf PriorDirectory.GetFiles(selectedItem).Length > 0 Then
                Try
                    System.Diagnostics.Process.Start(fullPath)
                Catch ex As Exception
                    MessageBox.Show(ex.Message.ToString, "Error Opening File " + selectedItem, MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        Next

    End Sub


End Class
