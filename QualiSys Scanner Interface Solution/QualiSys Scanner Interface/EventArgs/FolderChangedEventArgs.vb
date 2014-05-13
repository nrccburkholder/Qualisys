Public Class FolderChangedEventArgs
    Inherits EventArgs

    Private mFolderPath As String
    Private mFolderItem As ExpTreeLib.CShItem

    Public ReadOnly Property FolderPath() As String
        Get
            Return mFolderPath
        End Get
    End Property

    Public ReadOnly Property FolderItem() As ExpTreeLib.CShItem
        Get
            Return mFolderItem
        End Get
    End Property

    Public Sub New(ByVal folderPath As String, ByVal folderItem As ExpTreeLib.CShItem)

        mFolderPath = folderPath
        mFolderItem = folderItem

    End Sub
End Class