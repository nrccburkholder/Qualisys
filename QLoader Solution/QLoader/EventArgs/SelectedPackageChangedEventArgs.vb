Public Class SelectedPackageChangedEventArgs
    Inherits EventArgs

    Private mOldPackageId As Integer
    Private mNewPackageId As Integer

    Public ReadOnly Property OldPackageId() As Integer
        Get
            Return mOldPackageId
        End Get
    End Property

    Public ReadOnly Property NewPackageId() As Integer
        Get
            Return mNewPackageId
        End Get
    End Property

    Public Sub New(ByVal oldPackageId As Integer, ByVal newPackageId As Integer)

        mOldPackageId = oldPackageId
        mNewPackageId = newPackageId

    End Sub

End Class
