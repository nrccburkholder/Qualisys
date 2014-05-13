Public Class PackageNode
    Inherits TreeNode

#Region " Private Members "

    Private mClientName As String = String.Empty
    Private mClientID As Integer
    Private mStudyName As String = String.Empty
    Private mStudyID As Integer
    Private mPackageName As String = String.Empty
    Private mPackageID As Integer
    Private mVersion As Integer
    Private mFileName As String = String.Empty
    Private mFileID As Integer
    Private mIsGrouped As Boolean
    Private mGroupList As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property ClientName() As String
        Get
            Return mClientName
        End Get
        Set(ByVal value As String)
            mClientName = value
        End Set
    End Property

    Public Property ClientID() As Integer
        Get
            Return mClientID
        End Get
        Set(ByVal value As Integer)
            mClientID = value
        End Set
    End Property

    Public Property StudyName() As String
        Get
            Return mStudyName
        End Get
        Set(ByVal value As String)
            mStudyName = value
        End Set
    End Property

    Public Property StudyID() As Integer
        Get
            Return mStudyID
        End Get
        Set(ByVal value As Integer)
            mStudyID = value
        End Set
    End Property

    Public Property PackageName() As String
        Get
            Return mPackageName
        End Get
        Set(ByVal value As String)
            mPackageName = value
        End Set
    End Property

    Public Property PackageID() As Integer
        Get
            Return mPackageID
        End Get
        Set(ByVal value As Integer)
            mPackageID = value
        End Set
    End Property

    Public Property Version() As Integer
        Get
            Return mVersion
        End Get
        Set(ByVal value As Integer)
            mVersion = value
        End Set
    End Property

    Public Property FileName() As String
        Get
            Return mFileName
        End Get
        Set(ByVal value As String)
            mFileName = value
        End Set
    End Property

    Public Property FileID() As Integer
        Get
            Return mFileID
        End Get
        Set(ByVal value As Integer)
            mFileID = value
        End Set
    End Property

    Public Property IsGrouped() As Boolean
        Get
            Return mIsGrouped
        End Get
        Set(ByVal value As Boolean)
            mIsGrouped = value
        End Set
    End Property

    Public Property GroupList() As String
        Get
            Return mGroupList
        End Get
        Set(ByVal value As String)
            mGroupList = value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public Shadows ReadOnly Property IsSelected() As Boolean
        Get
            Return (Me.BackColor.Equals(SystemColors.Highlight))
        End Get
    End Property

    Public ReadOnly Property NodeID() As String
        Get
            Return String.Format("{0}{1}{2}{3}", ClientID, StudyID, PackageID, FileID)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

        MyBase.New()

    End Sub

    Public Sub New(ByVal text As String)

        MyBase.New(text)

    End Sub

#End Region

End Class
