Public Class BarcodeFileSearchBeginEventArgs
    Inherits EventArgs

    Private mCurrentBarcodeFile As String
    Private mCancel As Boolean = False

    Public ReadOnly Property CurrentBarcodeFile() As String
        Get
            Return mCurrentBarcodeFile
        End Get
    End Property

    Public Property Cancel() As Boolean
        Get
            Return mCancel
        End Get
        Set(ByVal value As Boolean)
            mCancel = value
        End Set
    End Property

    Public Sub New(ByVal currentBarcodeFile As String)

        mCurrentBarcodeFile = currentBarcodeFile

    End Sub

End Class
