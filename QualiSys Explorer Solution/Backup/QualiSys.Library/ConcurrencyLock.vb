''' <summary>
''' Represents a lock on an abstract entity to prevent multiple concurrent access
''' </summary>
Public Class ConcurrencyLock

#Region " Private Instance Fields "

#Region " Persisted Fields "
    Private mId As Integer
    Private mLockCategory As ConcurrencyLockCategory
    Private mLockValueId As Integer
    Private mUserName As String
    Private mMachineName As String
    Private mProcessName As String
    Private mAcquisitionTime As DateTime
    Private mExpirationTime As DateTime
#End Region

#End Region

#Region " Public Properties "

#Region " Persisted Properties "
    ''' <summary>
    ''' The unique Id of the lock
    ''' </summary>
    Public ReadOnly Property Id() As Integer
        Get
            Return mId
        End Get
    End Property

    ''' <summary>
    ''' The category of the lock
    ''' </summary>
    Public ReadOnly Property LockCategory() As ConcurrencyLockCategory
        Get
            Return mLockCategory
        End Get
    End Property

    ''' <summary>
    ''' The id value of the entity that is locked
    ''' </summary>
    Public ReadOnly Property LockValueId() As Integer
        Get
            Return mLockValueId
        End Get
    End Property

    ''' <summary>
    ''' The name of the user that has the lock
    ''' </summary>
    Public ReadOnly Property UserName() As String
        Get
            Return mUserName
        End Get
    End Property

    ''' <summary>
    ''' The name of the machine where the lock was acquired
    ''' </summary>
    Public ReadOnly Property MachineName() As String
        Get
            Return mMachineName
        End Get
    End Property

    ''' <summary>
    ''' The name of the process that acquired the lock
    ''' </summary>
    Public ReadOnly Property ProcessName() As String
        Get
            Return mProcessName
        End Get
    End Property

    ''' <summary>
    ''' The time that the lock was acquired
    ''' </summary>
    Public ReadOnly Property AcquisitionTime() As DateTime
        Get
            Return mAcquisitionTime
        End Get
    End Property

    ''' <summary>
    ''' The time that the lock will expire if not renewed.
    ''' </summary>
    Public Property ExpirationTime() As DateTime
        Get
            Return mExpirationTime
        End Get
        Set(ByVal value As DateTime)
            mExpirationTime = value
        End Set
    End Property
#End Region

#End Region

#Region " Constructors "
    Friend Sub New(ByVal id As Integer, ByVal category As ConcurrencyLockCategory, ByVal lockValueId As Integer, ByVal userName As String, ByVal machineName As String, ByVal processName As String, ByVal acquisitionTime As Date, ByVal expirationTime As Date)
        Me.mId = id
        Me.mLockCategory = category
        Me.mLockValueId = lockValueId
        Me.mUserName = userName
        Me.mMachineName = machineName
        Me.mProcessName = processName
        Me.mAcquisitionTime = acquisitionTime
        Me.mExpirationTime = expirationTime
    End Sub
#End Region

End Class
