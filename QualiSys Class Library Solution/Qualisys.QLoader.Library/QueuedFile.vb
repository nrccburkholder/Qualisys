Public Class QueuedFile

#Region " Private Members "

    Private mDataFileID As Integer
    Private mPackageID As Integer
    Private mVersion As Integer
    Private mState As DataFileStates

#End Region

#Region " Public Properties "

    Public Property DataFileID() As Integer
        Get
            Return mDataFileID
        End Get
        Set(ByVal Value As Integer)
            mDataFileID = Value
        End Set
    End Property

    Public Property PackageID() As Integer
        Get
            Return mPackageID
        End Get
        Set(ByVal Value As Integer)
            mPackageID = Value
        End Set
    End Property

    Public Property Version() As Integer
        Get
            Return mVersion
        End Get
        Set(ByVal Value As Integer)
            mVersion = Value
        End Set
    End Property

    Public Property State() As DataFileStates
        Get
            Return mState
        End Get
        Set(ByVal Value As DataFileStates)
            mState = Value
        End Set
    End Property

#End Region

End Class
