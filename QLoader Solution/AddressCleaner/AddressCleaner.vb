Imports Nrc.Framework.AddressCleaning
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework

Public Class AddressCleaner

#Region " Main Console App "

    Shared Sub Main(ByVal args() As String)

        Dim dataFileID As Integer
        Dim loadDB As LoadDatabases
        Dim dataFile As String = String.Empty
        Dim loadDatabase As String = String.Empty

        'Check to see if the user is requesting the help screen
        If args.Length > 0 AndAlso args(0).ToLower = "/?" Then
            ShowHelp()
            Return
        End If

        'Collect the command line parameters
        If args.Length = 1 Then
            dataFile = args(0)
            loadDatabase = "QP_Load"
        ElseIf args.Length = 2 Then
            dataFile = args(0)
            loadDatabase = args(1)
        Else
            Console.WriteLine("ERROR: Incorrect number of command line parameters supplied!")
            Console.WriteLine()
            ShowHelp()
            Return
        End If

        'Validate dataFile command line parameter
        Try
            dataFileID = Integer.Parse(dataFile)
            If Not dataFileID > 0 Then
                Exit Sub
            End If

        Catch ex As Exception
            Console.WriteLine("ERROR: First command line parameter must be an integer DataFileID!")
            Console.WriteLine()
            ShowHelp()
            Return

        End Try

        'Validate loadDatabase command line parameter
        Select Case loadDatabase.ToUpper
            Case "QP_LOAD"
                loadDB = LoadDatabases.QPLoad

            Case "QP_DATALOAD"
                loadDB = LoadDatabases.QPDataLoad

            Case Else
                Console.WriteLine("ERROR: Second command line parameter must be the database name!")
                Console.WriteLine()
                ShowHelp()
                Return

        End Select

        'Perform the cleaning operation
        Try
            Select Case loadDB
                Case LoadDatabases.QPLoad
                    CleanQPLoad(dataFileID, loadDB)

                Case LoadDatabases.QPDataLoad
                    CleanQPDataLoad(dataFileID, loadDB)

            End Select

        Catch ex As Exception
            LogEvent(dataFileID, loadDB, String.Format("Address Cleaning Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))

        End Try

    End Sub

#End Region

#Region " Private Methods - QP_Load "

    Private Shared Sub CleanQPLoad(ByVal dataFileID As Integer, ByVal loadDB As LoadDatabases)

        Dim file As QLoader.Library.DataFile = Nothing
        Dim package As QLoader.Library.DTSPackage = Nothing
        Dim addrCleaner As Cleaner

        Try
            file = New QLoader.Library.DataFile
            file.LoadFromDB(dataFileID)

            package = New QLoader.Library.DTSPackage(file.PackageID, file.Version)

            'Make sure package is not locked
            If package.LockStatus = QLoader.Library.PackageLockStates.Unlocked Then
                'Write to log
                LogEvent(dataFileID, loadDB, "Begin Address Cleaning")

                'Lock the package
                package.LockPackage()

                'Mark file as Cleaning
                file.ChangeState(QLoader.Library.DataFileStates.AddressCleaning, "")

                'Determine if we need to use a web proxy
                Dim forceProxy As Boolean = ((AppConfig.Params("WebServiceProxyRequiredServer").IntegerValue = 1) OrElse System.Diagnostics.Debugger.IsAttached)

                'BEGIN ADDRESS CLEAN
                addrCleaner = New Cleaner(AppConfig.CountryID, loadDB)
                Dim groups As MetaGroupCollection
                If addrCleaner.IsCleanAddrBitSet(package.Study.StudyID) Then
                    groups = addrCleaner.CleanAll(dataFileID, package.Study.StudyID, AppConfig.Params("BatchSize").IntegerValue, forceProxy)
                    MetaGroup.SaveCounts(dataFileID, groups, loadDB)
                    addrCleaner = Nothing
                End If
                'END CLEAN

                'Set the file state based on the the file type
                If file.IsLoadToLive Then
                    'Mark file as "Awaiting Duplicate Check"
                    file.ChangeState(QLoader.Library.DataFileStates.LoadToLiveAwaitingDupCheck, "")
                Else
                    'Mark file as "Awaiting Validation"
                    file.ChangeState(QLoader.Library.DataFileStates.AwaitingValidation, "")
                End If

                LogEvent(dataFileID, loadDB, "End Address Cleaning")
            End If

        Catch ex As QLoader.Library.PackageLockException
            LogEvent(dataFileID, loadDB, String.Format("Exception: Could not clean DataFile_id: {0}. Package: {1} is already locked.", dataFileID, ex.PackageID))

        Catch ex As Exception
            'Uh oh
            LogEvent(dataFileID, loadDB, String.Format("Exception: Could not clean DataFile_id: {0}{1}{2}{1}{3}", dataFileID, vbCrLf, ex.Message, ex.StackTrace))

            'Mark the file as abandoned
            If Not file Is Nothing Then
                file.ChangeState(QLoader.Library.DataFileStates.Abandoned, String.Format("Address Cleaning Exception: {0}", ex.Message))
            End If

        Finally
            'Unlock the package if we need to...
            If Not package Is Nothing AndAlso package.LockStatus = QLoader.Library.PackageLockStates.LockedByMe Then
                package.UnlockPackage()
            End If

        End Try

    End Sub

#End Region

#Region " Private Methods - QP_DataLoad "

    Private Shared Sub CleanQPDataLoad(ByVal dataFileID As Integer, ByVal loadDB As LoadDatabases)

        Dim file As Pervasive.Library.DataFile = Nothing
        Dim addrCleaner As Cleaner

        Try
            file = Pervasive.Library.DataFile.Get(dataFileID)

            'Write to log
            LogEvent(dataFileID, loadDB, "Begin Address Cleaning")

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

            LogEvent(dataFileID, loadDB, "End Address Cleaning")

        Catch ex As Exception
            'Uh oh
            LogEvent(dataFileID, loadDB, String.Format("Exception: Could not clean DataFile_id: {0}{1}{2}{1}{3}", dataFileID, vbCrLf, ex.Message, ex.StackTrace))

            'Mark the file as abandoned
            If Not file Is Nothing Then
                file.ChangeState(Pervasive.Library.DataFileStates.Abandoned, String.Format("Address Cleaning Exception: {0}", ex.Message))
            End If

        End Try

    End Sub

#End Region

#Region " Private Methods - Common "

    Private Shared Sub LogEvent(ByVal dataFileID As Integer, ByVal loadDB As LoadDatabases, ByVal eventData As String)

        Try
            Select Case loadDB
                Case LoadDatabases.QPLoad
                    QLoader.Library.SqlProvider.PackageDB.LogServiceEvent(dataFileID, eventData, System.Threading.Thread.CurrentThread.ManagedThreadId)

                    Logs.Info(String.Format("FileLoader (QP_Load) - DataFile_id: {0}, EventData: {1}, intThread: {2}", dataFileID, eventData, System.Threading.Thread.CurrentThread.ManagedThreadId))

                Case LoadDatabases.QPDataLoad
                    EventLog.WriteEntry("FileLoader (QP_DataLoad)", eventData, EventLogEntryType.Information)

                    Logs.Info(String.Format("FileLoader (QP_DataLoad) - EventData: {0}", eventData))
            End Select


        Catch ex As Exception

            Select Case loadDB
                Case LoadDatabases.QPLoad

                    EventLog.WriteEntry("FileLoader (QP_Load)", String.Format("{0}{1}{2}", eventData, vbCrLf, ex.StackTrace), EventLogEntryType.Error)

                    Logs.LogException(ex, String.Format("FileLoader (QP_Load) {0}", eventData))

                Case LoadDatabases.QPDataLoad

                    EventLog.WriteEntry("FileLoader (QP_DataLoad)", String.Format("{0}{1}{2}", eventData, vbCrLf, ex.StackTrace), EventLogEntryType.Error)

                    Logs.LogException(ex, String.Format("FileLoader (QP_DataLoad) {0}", eventData))

            End Select



        End Try

    End Sub

    Private Shared Sub ShowHelp()

        Console.WriteLine("Runs Address Cleaning for the specified DataFileID")
        Console.WriteLine()
        Console.WriteLine("AddressCleaner dataFileID [dataBaseName]")
        Console.WriteLine()
        Console.WriteLine("dataFileID      DataFileID of the file to be address cleaned.")
        Console.WriteLine("                Must be an integer.")
        Console.WriteLine("dataBaseName    The name of the database where the DataFileID")
        Console.WriteLine("                is located:")
        Console.WriteLine("                  'QP_Load'     for QLoader Files (Default).")
        Console.WriteLine("                  'QP_DataLoad' for Pervasive Files.")
        Console.WriteLine()

    End Sub

#End Region

End Class
