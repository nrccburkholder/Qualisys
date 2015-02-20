Imports System.Threading
Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' The ConcurrencyManager class is used to acquire and release <see cref="ConcurrencyLock">ConcurrencyLocks</see>
''' on any abstract entity to prevent multiple concurrent access.
''' </summary>
''' <remarks>
''' This is a singleton class and cannot be directly instantiated.  All functionality of this
''' clas is exposed through shared methods.
''' </remarks>
Public NotInheritable Class ConcurrencyManager
    Implements IDisposable


#Region " Shared Fields "
    '''<summary>The singleton instance</summary> 
    Private Shared mInstance As ConcurrencyManager

    ''' <summary>The interval in minutes between the timer that checks for needed lock renewals</summary>
    Private Const mRenewalIntervalMinutes As Integer = 1

    ''' <summary>The amount of time to acquire a lock before it needs to be renewed</summary>
    Private Const mLockExpirationMinutes As Integer = 5
#End Region

#Region " Private Instance Fields "
    Private mServerTime As ServerTime
    Private mLocks As List(Of ConcurrencyLock)
    Private mRenewalTimer As System.Threading.Timer
#End Region

#Region " Private Properties "
    ''' <summary>Provides access to the singleton instance</summary>
    Private Shared ReadOnly Property Manager() As ConcurrencyManager
        Get
            If mInstance Is Nothing Then
                mInstance = New ConcurrencyManager
            End If
            Return mInstance
        End Get
    End Property
#End Region

#Region " Events "
    Public Shared Event LockRenewalFailed As EventHandler(Of LockRenewalFailedEventArgs)
#End Region

#Region " Constructors "
    ''' <summary>Constructor is private for singleton class</summary>
    Private Sub New()
        mLocks = New List(Of ConcurrencyLock)

        'Synchronize with the server time
        mServerTime = ServerTime.GetServerTime

        'Setup the timer to call the RenewalCheck method every x minutes
        Dim renewalCallback As New TimerCallback(AddressOf RenewalCheck)
        mRenewalTimer = New System.Threading.Timer(renewalCallback, Nothing, New TimeSpan(0, mRenewalIntervalMinutes, 0), New TimeSpan(0, mRenewalIntervalMinutes, 0))
    End Sub
#End Region

#Region " Public Shared Methods "

    ''' <summary>
    ''' Attempts to acquire a lock on the specified category and value
    ''' </summary>
    ''' <param name="lockCategory">The lock category for which to aquire the lock</param>
    ''' <param name="lockValueId">The unique identifier for the entity being locked</param>
    ''' <param name="userName">The name of the user acquiring the lock</param>
    ''' <param name="machineName">The name of the machine used to acquire the lock</param>
    ''' <param name="processName">The name of the process used to acquire the lock</param>
    ''' <returns>Return True if the lock was acquired, otherwise False</returns>
    Public Shared Function AcquireLock(ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer, ByVal userName As String, ByVal machineName As String, ByVal processName As String) As Boolean
        'Get the expiration time by adding the ExpirationMinutes to the server time
        Dim expirationTime As DateTime = Manager.mServerTime.CurrentTime.AddMinutes(mLockExpirationMinutes)

        'Try to acquire the lock
        Dim lock As ConcurrencyLock
        lock = ConcurrencyLockProvider.Instance.Insert(lockCategory, lockValueId, userName, machineName, processName, expirationTime)

        'If a value was returned then add it to the lock collection
        If lock IsNot Nothing Then
            Manager.mLocks.Add(lock)
            Return True
        Else
            Return False
        End If
    End Function

    ''' <summary>
    ''' Releases a lock held by this ConcurrencyManager
    ''' </summary>
    ''' <param name="lockCategory">The category of the lock to release</param>
    ''' <param name="lockValueId">The unique identifier for the entity that is locked</param>
    Public Shared Sub ReleaseLock(ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer)
        'Get the lock from our current lock collection
        Dim lock As ConcurrencyLock = FindLock(lockCategory, lockValueId)

        'Throw if we don't have the lock
        If lock Is Nothing Then
            Throw New ConcurrencyLockException("Conncurrency lock release failed because the lock has not been acquired.")
        End If

        'Remove the lock from the current lock collection
        Manager.mLocks.Remove(lock)

        'Release the lock
        ConcurrencyLockProvider.Instance.Delete(lock.Id)
    End Sub

    ''' <summary>
    ''' Releases any locks currently held by the ConcurrencyManager
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared Sub ReleaseAllLocks()
        'Release each lock
        For Each lock As ConcurrencyLock In Manager.mLocks
            ConcurrencyLockProvider.Instance.Delete(lock.Id)
        Next

        'Clear out the collection
        Manager.mLocks.Clear()
    End Sub

    ''' <summary>
    ''' Retrieves a <see cref="ConcurrencyLock">ConcurrencyLock</see> object for the specified category and value if it is locked
    ''' </summary>
    ''' <param name="lockCategory">The category of the lock to retrieve</param>
    ''' <param name="lockValueId">The unique identifier for the entity that is locked</param>
    ''' <returns>Returns a reference to the <see cref="ConcurrencyLock">ConcurrencyLock</see> object if the 
    ''' entity is locked, otherwise returns NULL</returns>
    Public Shared Function ViewLock(ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer) As ConcurrencyLock
        Return ConcurrencyLockProvider.Instance.[Select](lockCategory, lockValueId)
    End Function

    ''' <summary>
    ''' Retrieves a collection of all the <see cref="ConcurrencyLock">ConcurrencyLock</see> objects that currently exist in the datastore
    ''' </summary>
    Public Shared Function ViewAllLocks() As Collection(Of ConcurrencyLock)
        Return ConcurrencyLockProvider.Instance.SelectAll
    End Function

    ''' <summary>
    ''' Retrieves a collection of all the <see cref="ConcurrencyLock">ConcurrencyLock</see> objects that currently 
    ''' exist in the datastore for the specified lock category
    ''' </summary>
    Public Shared Function ViewAllLocks(ByVal lockCategory As ConcurrencyLockCategory) As Collection(Of ConcurrencyLock)
        Return ConcurrencyLockProvider.Instance.SelectByCategory(lockCategory)
    End Function

    ''' <summary>
    ''' Returns True if the entity specified by the lock category and the value identifier is currently locked
    ''' </summary>
    Public Shared Function IsLocked(ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer) As Boolean
        Dim lock As ConcurrencyLock = ViewLock(lockCategory, lockValueId)
        Return (lock IsNot Nothing)
    End Function

#End Region

#Region " Private Methods "

    ''' <summary>
    ''' Checks all locks currently held by the ConcurrencyManager and renews them if needed
    ''' </summary>
    ''' <param name="state"></param>
    ''' <remarks>This method is called periodically by the timer that tracks lock renewals</remarks>
    Private Sub RenewalCheck(ByVal state As Object)
        Try
            'Don't do any work if there are no locks held
            If mLocks IsNot Nothing AndAlso mLocks.Count > 0 Then

                'Resynchronize our clocks every thirty minutes
                If mServerTime.TimeSinceSync.Minutes > 30 Then
                    mServerTime.Synchronize()
                End If

                'For each lock held, check if it needs to be renewed, and if so renew it
                For Each lock As ConcurrencyLock In Me.mLocks
                    If lock.ExpirationTime < mServerTime.CurrentTime.AddMinutes(mRenewalIntervalMinutes + 1) Then
                        RenewLock(lock)
                    End If
                Next
            End If

            'Report all exceptions through the shared event
        Catch ex As ConcurrencyLockException
            RaiseEvent LockRenewalFailed(Me, New LockRenewalFailedEventArgs(ex))
        Catch ex As Exception
            RaiseEvent LockRenewalFailed(Me, New LockRenewalFailedEventArgs(New ConcurrencyLockException("Concurrency lock renewal failed.", ex)))
        End Try
    End Sub

    ''' <summary>
    ''' Renews the lock specified
    ''' </summary>
    ''' <param name="lock">The lock object to be renewed</param>
    Private Sub RenewLock(ByVal lock As ConcurrencyLock)
        'Verify that somehow this lock hasn't already expired (if so, we do not know if it is safe to renew)
        'Not sure how this could occur (time synchronization gets off??) but just in case... :)
        If lock.ExpirationTime < mServerTime.CurrentTime Then
            Throw New ConcurrencyLockException("Concurrency lock renewal failed.  This lock has already expired.")
        End If

        'Set the new expiration time
        Dim expirationTime As DateTime = mServerTime.CurrentTime.AddMinutes(mLockExpirationMinutes)
        Try
            'Update the expiration time on the lock
            ConcurrencyLockProvider.Instance.Update(lock.Id, expirationTime)
            lock.ExpirationTime = expirationTime
        Catch ex As Exception
            Throw New ConcurrencyLockException("Concurrency lock renewal failed.", ex)
        End Try
    End Sub


    ''' <summary>
    ''' Searches the current list of locks held by the ConcurrencyManager for a specific lock
    ''' </summary>
    ''' <param name="lockCategory">The category of the lock to look for</param>
    ''' <param name="lockValueId">The value of the lock to look for</param>
    ''' <returns>Returns the lock object if it exists, otherwise returns NULL</returns>
    Private Shared Function FindLock(ByVal lockCategory As ConcurrencyLockCategory, ByVal lockValueId As Integer) As ConcurrencyLock
        For Each lock As ConcurrencyLock In Manager.mLocks
            If lock.LockCategory = lockCategory AndAlso lock.LockValueId = lockValueId Then
                Return lock
            End If
        Next

        Return Nothing
    End Function

#End Region

#Region " ServerTime Class "

    ''' <summary>
    ''' A class for synchronizing the local system time with a database server time.
    ''' </summary>
    ''' <remarks>This class is important if multiple, independent client machines need to be working
    ''' on the same schedule</remarks>
    Private Class ServerTime

        Private mInitialServerTime As DateTime
        Private mSyncTime As DateTime

        ''' <summary>
        ''' The current time on the server
        ''' </summary>
        Public ReadOnly Property CurrentTime() As DateTime
            Get
                Return mInitialServerTime.Add(DateTime.Now.Subtract(mSyncTime))
            End Get
        End Property

        ''' <summary>
        ''' The amount of time that has passed since synchronization
        ''' </summary>
        Public ReadOnly Property TimeSinceSync() As TimeSpan
            Get
                Return DateTime.Now.Subtract(mSyncTime)
            End Get
        End Property

        ''' <summary>Private constructor for factory class</summary>
        Private Sub New()
            Me.Synchronize()
        End Sub

        ''' <summary>
        ''' Synchronizes the ServerTime object with the current time on the server
        ''' </summary>
        ''' <remarks></remarks>
        Public Sub Synchronize()
            mSyncTime = DateTime.Now
            mInitialServerTime = ConcurrencyLockProvider.Instance.SelectServerTime
        End Sub


        ''' <summary>
        ''' Factory method for creating an instance.  This is used mainly so users can understand
        ''' that the constructor requires some computation and I/O
        ''' </summary>
        Public Shared Function GetServerTime() As ServerTime
            Return New ServerTime()
        End Function

        'Public Function AnalyzeTime() As String
        '    Dim msg As String = "Initial Server Time: " & mInitialServerTime & vbCrLf
        '    msg &= "SyncTime: " & mSyncTime & vbCrLf
        '    msg &= "Differential: " & mInitialServerTime.Subtract(mSyncTime).ToString & vbCrLf
        '    msg &= "Current Local Time: " & DateTime.Now & vbCrLf
        '    msg &= "Time Passed: " & DateTime.Now.Subtract(mSyncTime).ToString & vbCrLf
        '    Dim calcTime As DateTime = mInitialServerTime.Add(DateTime.Now.Subtract(mSyncTime))
        '    Dim realTime As DateTime = DataProvider.Instance.SelectServerTime
        '    msg &= "Calculated Server Time: " & calcTime & vbCrLf
        '    msg &= "Real Server Time: " & realTime & vbCrLf
        '    msg &= "Error: " & calcTime.Subtract(realTime).ToString & vbCrLf
        '    msg &= "Differential Now: " & realTime.Subtract(DateTime.Now).ToString
        '    Return msg

        'End Function

    End Class
#End Region




    Private disposedValue As Boolean        ' To detect redundant calls

    ' IDisposable
    <System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1063:ImplementIDisposableCorrectly")> <System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1047:DoNotDeclareProtectedMembersInSealedTypes")> _
    Protected Sub Dispose(ByVal disposing As Boolean)
        If Not Me.disposedValue Then
            If disposing Then
                Me.mRenewalTimer.Dispose()
            End If

        End If
        Me.disposedValue = True
    End Sub

#Region " IDisposable Support "
    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose
        ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub
#End Region

End Class