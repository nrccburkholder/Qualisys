Public Class FolderChangedEventArgs
    Inherits EventArgs

    Private mFolderPath As String
    Public ReadOnly Property FolderPath() As String
        Get
            Return mFolderPath
        End Get
    End Property

    Public Sub New(ByVal folderPath As String)
        mFolderPath = folderPath
    End Sub
End Class