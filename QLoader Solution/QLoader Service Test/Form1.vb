Imports Nrc.Qualisys.QLoader.Library
Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports System.Threading
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.AddressCleaning
Imports Nrc.Qualisys.QLoader.Library20

Public Class Form1

#Region " Private Members "

    'Work queues
    Private mLoadQueue As Queue = Queue.Synchronized(New Queue)
    Private mCleanQueue As Queue = Queue.Synchronized(New Queue)
    Private mValidateQueue As Queue = Queue.Synchronized(New Queue)
    Private mApplyQueue As Queue = Queue.Synchronized(New Queue)
    Private mLoadToLiveDupCheckQueue As Queue = Queue.Synchronized(New Queue)
    Private mLoadToLiveUpdateQueue As Queue = Queue.Synchronized(New Queue)

    Private WithEvents mTimer As Timers.Timer       'Check for work timer

    'Current process counts
    Private mDTSExecutionCount As Integer
    Private mAddressCleanCount As Integer
    Private mValidationCount As Integer
    Private mApplyCount As Integer
    Private mLoadToLiveDupCheckCount As Integer
    Private mLoadToLiveUpdateCount As Integer

#End Region

#Region " Service Methods "

    <MTAThread()> _
    Public Shared Sub Main(ByVal args() As String)

        System.Threading.Thread.CurrentThread.TrySetApartmentState(Threading.ApartmentState.STA)
        Dim currentDomain As AppDomain = AppDomain.CurrentDomain
        AddHandler currentDomain.UnhandledException, AddressOf UnhandledExceptionHandler

        AddHandler Application.ThreadException, AddressOf ThreadExceptionHandler

        Application.Run(New Form1)

    End Sub

    Private Shared Sub ThreadExceptionHandler(ByVal sender As Object, ByVal args As ThreadExceptionEventArgs)

        EventLog.WriteEntry("DTSService", args.Exception.Message, EventLogEntryType.Error)

    End Sub

    Private Shared Sub UnhandledExceptionHandler(ByVal sender As Object, ByVal args As UnhandledExceptionEventArgs)

        EventLog.WriteEntry("DTSService", DirectCast(args.ExceptionObject, Exception).Message, EventLogEntryType.Error)

    End Sub

    Private Delegate Sub WriteMessage(ByVal dataFileID As Integer, ByVal message As String)

    Public Sub WriteEvent(ByVal dataFileID As Integer, ByVal message As String)

        TextBox1.Text = String.Format("{0}{1}DataFile={2}{1}{3}{4}{5}", DateTime.Now, vbTab, dataFileID, message, vbCrLf, TextBox1.Text)
        Refresh()

    End Sub

#End Region

#Region " Form Events "

    Private Sub Form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        SetupNrcAuthSettings()

    End Sub

    Private Sub StartButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartButton.Click

        'Initialize counters
        mDTSExecutionCount = 0
        mAddressCleanCount = 0
        mValidationCount = 0
        mApplyCount = 0
        mLoadToLiveDupCheckCount = 0
        mLoadToLiveUpdateCount = 0

        'Instatiate the timer and start it
        mTimer = New Timers.Timer(AppConfig.Params("TimerInterval").IntegerValue)

        mTimer.AutoReset = True
        mTimer.Enabled = True

    End Sub

    Private Sub StopButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StopButton.Click

        'Pause the timer
        mTimer.Enabled = False

    End Sub

    Private Sub FileLoaderButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FileLoaderButton.Click

        Try
            Dim dataFileID As Integer = CType(InputBox("Data File ID"), Integer)
            Dim p As System.Diagnostics.Process

            p = System.Diagnostics.Process.Start(String.Format("{0}FileLoader.exe", AppDomain.CurrentDomain.BaseDirectory), dataFileID.ToString)
            p.WaitForExit()

        Catch ex As Exception
            MessageBox.Show(ex.Message, "error", MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

    End Sub

    Private Sub PervasiveAddressCleaningButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PervasiveAddressCleaningButton.Click

        Dim dataFileID As Integer = 8
        Dim loadDB As LoadDatabases = LoadDatabases.QPDataLoad

        Dim file As Pervasive.Library.DataFile = Nothing
        Dim addrCleaner As Cleaner

        Try
            file = Pervasive.Library.DataFile.Get(dataFileID)

            'Mark file as Cleaning
            file.ChangeState(Pervasive.Library.DataFileStates.AddressCleaning, "")

            'Determine if we need to use a web proxy
            Dim forceProxy As Boolean = ((AppConfig.Params("WebServiceProxyRequiredServer").IntegerValue = 1) OrElse System.Diagnostics.Debugger.IsAttached)

            'BEGIN ADDRESS CLEAN
            addrCleaner = New Cleaner(AppConfig.CountryID, loadDB)
            Dim groups As MetaGroupCollection
            If addrCleaner.IsCleanAddrBitSet(file.StudyId) Then
                groups = addrCleaner.CleanAll(dataFileID, file.StudyId, AppConfig.Params("BatchSize").IntegerValue, forceProxy)
                MetaGroup.SaveCounts(dataFileID, groups, loadDB)
                addrCleaner = Nothing
            End If
            'END CLEAN

            'Mark file as "Awaiting Validation"
            file.ChangeState(Pervasive.Library.DataFileStates.AwaitingValidation, "")

        Catch ex As Exception
            'Mark the file as abandoned
            If Not file Is Nothing Then
                file.ChangeState(Pervasive.Library.DataFileStates.Abandoned, String.Format("Address Cleaning Exception: {0}", ex.Message))
            End If

        End Try

    End Sub

    Private Sub CheckForWorkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckForWorkButton.Click

        CheckForWork()

    End Sub

#End Region

#Region " Checking for Work Methods "

    'Each time the timer ticks then check for work
    Private Sub mTimer_Elapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs) Handles mTimer.Elapsed

        'System.Threading.Thread.CurrentThread.ApartmentState = Threading.ApartmentState.STA
        CheckForWork()

    End Sub

    Public Sub CheckForWork()

        Dim files As QueuedFileCollection
        Dim file As QueuedFile

        Try
            If mDTSExecutionCount < Config.MaxConcurrentLoads OrElse mAddressCleanCount < Config.MaxConcurrentCleaning OrElse _
               mValidationCount < Config.MaxConcurrentValidations OrElse mApplyCount < Config.MaxConcurrentApplies OrElse _
               mLoadToLiveDupCheckCount < Config.MaxConcurrentLoadToLiveDupChecks OrElse mLoadToLiveUpdateCount < Config.MaxConcurrentLoadToLiveUpdates Then

                mLoadQueue.Clear()
                mCleanQueue.Clear()
                mValidateQueue.Clear()
                mApplyQueue.Clear()
                mLoadToLiveDupCheckQueue.Clear()
                mLoadToLiveUpdateQueue.Clear()

                files = GetQueuedFiles()
                For Each file In files
                    Select Case file.State
                        Case DataFileStates.FileQueued
                            If mDTSExecutionCount < Config.MaxConcurrentLoads Then
                                mLoadQueue.Enqueue(file)

                                Dim t As New Thread(AddressOf ExecuteDTS)
                                t.TrySetApartmentState(ApartmentState.STA)
                                mDTSExecutionCount += 1     'Increment count
                                t.Start()
                            End If

                        Case DataFileStates.AwaitingAddressClean
                            If mAddressCleanCount < Config.MaxConcurrentCleaning Then
                                mCleanQueue.Enqueue(file)

                                Dim t As New Thread(AddressOf ExecuteAddressClean)
                                t.TrySetApartmentState(ApartmentState.STA)
                                mAddressCleanCount += 1     'Increment count
                                t.Start()
                            End If

                        Case DataFileStates.AwaitingValidation
                            If mValidationCount < Config.MaxConcurrentValidations Then
                                mValidateQueue.Enqueue(file)

                                Dim t As New Thread(AddressOf ExecuteValidation)
                                t.TrySetApartmentState(ApartmentState.MTA)
                                mValidationCount += 1
                                t.Start()
                            End If

                        Case DataFileStates.AwaitingApply
                            If mApplyCount < Config.MaxConcurrentApplies Then
                                mApplyQueue.Enqueue(file)

                                Dim t As New Thread(AddressOf ExecuteApply)
                                t.TrySetApartmentState(ApartmentState.MTA)
                                mApplyCount += 1
                                t.Start()
                            End If

                        Case DataFileStates.LoadToLiveAwaitingDupCheck
                            If mLoadToLiveDupCheckCount < Config.MaxConcurrentLoadToLiveDupChecks Then
                                mLoadToLiveDupCheckQueue.Enqueue(file)

                                Dim t As New Thread(AddressOf ExecuteLoadToLiveDupCheck)
                                t.TrySetApartmentState(ApartmentState.MTA)
                                mLoadToLiveDupCheckCount += 1
                                t.Start()
                            End If

                        Case DataFileStates.LoadToLiveAwaitingUpdate
                            If mLoadToLiveUpdateCount < Config.MaxConcurrentLoadToLiveUpdates Then
                                mLoadToLiveUpdateQueue.Enqueue(file)

                                Dim t As New Thread(AddressOf ExecuteLoadToLiveUpdate)
                                t.TrySetApartmentState(ApartmentState.MTA)
                                mLoadToLiveUpdateCount += 1
                                t.Start()
                            End If

                    End Select
                Next

            End If

        Catch ex As System.OutOfMemoryException
            LogEvent(0, String.Format("Exception checking for work (Out of Memory): {0}{1}{2}{1}{3}", ex.Message, vbCrLf, ex.Source, ex.StackTrace))
            GC.Collect()

        Catch ex As Exception
            LogEvent(0, String.Format("Exception: Could not check for work: {0}", ex.Message))

        End Try

    End Sub

    'Check to see if any files need to be Loaded OR Address Cleaned OR Validated OR Applied
    'Run them if config file is says to
    Private Function GetQueuedFiles() As QueuedFileCollection

        Dim reader As IDataReader = Nothing
        Dim files As New QueuedFileCollection
        Dim queuedfile As QueuedFile = Nothing

        Try
            reader = PackageDB.CheckForWork()
            While reader.Read
                queuedfile = New QueuedFile
                queuedfile.DataFileID = reader.GetInt32(0)
                queuedfile.State = CType(reader.GetInt32(1), DataFileStates)
                queuedfile.Version = reader.GetInt32(4)
                queuedfile.PackageID = reader.GetInt32(5)

                files.Add(queuedfile)
            End While

            Return files

        Catch ex As Exception
            LogEvent(0, String.Format("Exception getting queued files: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))
            Throw ex

        Finally
            If Not reader Is Nothing Then
                reader.Close()
            End If

        End Try

    End Function

#End Region

#Region " ExecuteDTS "

    'Load a file with DTS
    Private Sub ExecuteDTS()

        Dim file As QueuedFile = Nothing

        Try
            file = DirectCast(mLoadQueue.Dequeue, QueuedFile)
            Dim p As System.Diagnostics.Process

            p = System.Diagnostics.Process.Start(String.Format("{0}FileLoader.exe", AppDomain.CurrentDomain.BaseDirectory), file.DataFileID.ToString)
            p.WaitForExit()

        Catch ex As Exception
            LogEvent(file.DataFileID, String.Format("Exception: Could not load DataFile_id {0}: {1}{2}{3}", file.DataFileID, ex.Message, vbCrLf, ex.StackTrace))

        Finally
            mDTSExecutionCount -= 1

        End Try

    End Sub

#End Region

#Region " Execute AddressClean "

    Private Sub ExecuteAddressClean()

        Dim file As QueuedFile = Nothing

        Try
            file = DirectCast(mCleanQueue.Dequeue, QueuedFile)
            Dim p As System.Diagnostics.Process

            p = System.Diagnostics.Process.Start(String.Format("{0}AddressCleaner.exe", AppDomain.CurrentDomain.BaseDirectory), file.DataFileID.ToString)
            p.WaitForExit()

        Catch ex As Exception
            LogEvent(file.DataFileID, String.Format("Exception: Could not clean DataFile_id {0}: {1}{2}{3}", file.DataFileID, ex.Message, vbCrLf, ex.StackTrace))

        Finally
            mAddressCleanCount -= 1

        End Try

    End Sub

#End Region

#Region " Execute Validation "

    Private Sub ExecuteValidation()

        Dim queueFile As QueuedFile = Nothing
        Dim loadFile As DataFile = Nothing

        Try
            queueFile = DirectCast(mValidateQueue.Dequeue, QueuedFile)
            LogEvent(queueFile.DataFileID, "Begin Validation")

            loadFile = New DataFile

            loadFile.LoadFromDB(queueFile.DataFileID)
            loadFile.ChangeState(DataFileStates.Validating, "")
            PackageDB.RunValidationReports(queueFile.DataFileID)
            loadFile.ChangeState(DataFileStates.AwaitingFirstApproval, "")

            LogEvent(queueFile.DataFileID, "End Validation")

        Catch ex As Exception
            If Not loadFile Is Nothing Then
                loadFile.ChangeState(DataFileStates.Abandoned, String.Format("Validation Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))
            End If
            LogEvent(queueFile.DataFileID, String.Format("Validation Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))

        Finally
            mValidationCount -= 1

        End Try

    End Sub

#End Region

#Region " Execute Apply "

    Private Sub ExecuteApply()

        Dim queueFile As QueuedFile = Nothing
        Dim loadFile As DataFile = Nothing
        Dim package As DTSPackage = Nothing

        Try
            queueFile = DirectCast(mApplyQueue.Dequeue, QueuedFile)
            loadFile = New DataFile
            loadFile.LoadFromDB(queueFile.DataFileID)

            package = New DTSPackage(loadFile.PackageID, loadFile.Version)

            'Make sure package is not locked
            If package.LockStatus = PackageLockStates.Unlocked Then
                LogEvent(queueFile.DataFileID, "Begin Apply")

                'Lock the package
                package.LockPackage()

                'Change state
                loadFile.ChangeState(DataFileStates.Applying, "")
                'Run the apply
                loadFile.Apply()
                'Change state
                loadFile.ChangeState(DataFileStates.Applied, "")

                LogEvent(queueFile.DataFileID, "End Apply")
            End If

        Catch ex As Exception
            'Mark the file as abandoned
            If Not loadFile Is Nothing Then
                loadFile.ChangeState(DataFileStates.Abandoned, String.Format("Apply Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))
            End If
            LogEvent(queueFile.DataFileID, String.Format("Apply Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))

        Finally
            mApplyCount -= 1

            'Unlock the package if we need to...
            If Not package Is Nothing AndAlso package.LockStatus = PackageLockStates.LockedByMe Then
                package.UnlockPackage()
            End If

        End Try

    End Sub

#End Region

#Region " Execute LoadToLive Dup Check "

    Private Sub ExecuteLoadToLiveDupCheck()

        Dim queueFile As QueuedFile = Nothing
        Dim loadFile As DataFile = Nothing
        Dim package As DTSPackage = Nothing

        Try
            'Get the DataFile
            queueFile = DirectCast(mLoadToLiveDupCheckQueue.Dequeue, QueuedFile)
            loadFile = New DataFile
            loadFile.LoadFromDB(queueFile.DataFileID)

            'Get the DTSPackage
            package = New DTSPackage(loadFile.PackageID, loadFile.Version)

            'Make sure the package is not locked
            If package.LockStatus = PackageLockStates.Unlocked Then
                'Log the beginning of the dup check
                LogEvent(queueFile.DataFileID, "Begin Load to Live Dup Check")

                'Lock the package
                package.LockPackage()

                'Change state
                loadFile.ChangeState(DataFileStates.LoadToLiveCheckingDups, "")

                'Check for duplicates
                If LoadToLiveDefinition.LoadToLiveDuplicateCheckAllTables(queueFile.DataFileID, package) Then
                    'There are no dups so change the state to awaiting update
                    loadFile.ChangeState(DataFileStates.LoadToLiveAwaitingUpdate, "")
                Else
                    'Dups were found so change the state to awaiting approval
                    loadFile.ChangeState(DataFileStates.LoadToLiveAwaitingDupApproval, "")
                End If

                'Log the end of the dup check
                LogEvent(queueFile.DataFileID, "End Load to Live Dup Check")
            End If

        Catch ex As Exception
            'Mark the file as abandoned
            If Not loadFile Is Nothing Then
                loadFile.ChangeState(DataFileStates.Abandoned, String.Format("Load to Live Dup Check Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))
            End If
            LogEvent(queueFile.DataFileID, String.Format("Load to Live Dup Check Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))

        Finally
            'Decrement the process counter
            mLoadToLiveDupCheckCount -= 1

            'Unlock the package if we need to...
            If Not package Is Nothing AndAlso package.LockStatus = PackageLockStates.LockedByMe Then
                package.UnlockPackage()
            End If

        End Try

    End Sub

#End Region

#Region " Execute Load to Live Update "

    Private Sub ExecuteLoadToLiveUpdate()

        Dim queueFile As QueuedFile = Nothing
        Dim loadFile As DataFile = Nothing
        Dim package As DTSPackage = Nothing

        Try
            'Get the DataFile
            queueFile = DirectCast(mLoadToLiveUpdateQueue.Dequeue, QueuedFile)
            loadFile = New DataFile
            loadFile.LoadFromDB(queueFile.DataFileID)

            'Get the DTSPackage
            package = New DTSPackage(loadFile.PackageID, loadFile.Version)

            'Make sure the package is not locked
            If package.LockStatus = PackageLockStates.Unlocked Then
                'Log the beginning of the dup check
                LogEvent(queueFile.DataFileID, "Begin Load to Live Update")

                'Lock the package
                package.LockPackage()

                'Change state
                loadFile.ChangeState(DataFileStates.LoadToLiveUpdating, "")

                'Perform the update
                LoadToLiveDefinition.LoadToLiveUpdate(queueFile.DataFileID, package)

                'Change state
                loadFile.ChangeState(DataFileStates.LoadToLiveApplied, "")

                'Log the end of the update
                LogEvent(queueFile.DataFileID, "End Load to Live Update")
            End If

        Catch ex As Exception
            'Mark the file as abandoned
            If Not loadFile Is Nothing Then
                loadFile.ChangeState(DataFileStates.Abandoned, String.Format("Load to Live Update Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))
            End If
            LogEvent(queueFile.DataFileID, String.Format("Load to Live Update Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))

        Finally
            'Decrement the process counter
            mLoadToLiveUpdateCount -= 1

            'Unlock the package if we need to...
            If Not package Is Nothing AndAlso package.LockStatus = PackageLockStates.LockedByMe Then
                package.UnlockPackage()
            End If

        End Try

    End Sub

#End Region

#Region " Private Methods "

    'This for now is used for debugging and to record unexpected behavior
    Private Shared Sub LogEvent(ByVal dataFileID As Integer, ByVal eventData As String)

        Try
            PackageDB.LogServiceEvent(dataFileID, eventData, System.Threading.Thread.CurrentThread.ManagedThreadId)

        Catch ex As Exception
            EventLog.WriteEntry("QLoader Service", eventData, EventLogEntryType.Error)

        End Try

    End Sub

    Private Sub SetupNrcAuthSettings()

        Nrc.NRCAuthLib.StaticConfig.NRCAuthConnection = AppConfig.NrcAuthConnection
        Select Case AppConfig.EnvironmentType
            Case EnvironmentTypes.Testing, EnvironmentTypes.Staging
                Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Testing

            Case EnvironmentTypes.Production
                Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Production

        End Select

    End Sub

#End Region

End Class