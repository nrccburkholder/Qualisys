Public Class ImportUpdateSection

#Region " Private Variables "
    Private mImportUpdateNavigator As ImportUpdateNavigator    
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mImportUpdateNavigator = TryCast(navCtrl, ImportUpdateNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region

#Region " Event Handlers "
    Private Sub cmdSelectImportFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSelectImportFile.Click
        OpenFileDialog1.Filter = "STR Files|*.STR"
        If OpenFileDialog1.ShowDialog() = DialogResult.OK Then
            Me.txtImportFile.Text = OpenFileDialog1.FileName
        End If
    End Sub
    Private Sub cmdImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdImport.Click

    End Sub
#End Region
    
    
End Class
