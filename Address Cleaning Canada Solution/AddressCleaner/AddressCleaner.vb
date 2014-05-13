Imports NRC.DataLoadingClasses
Imports NRC.DataLoadingDB
Imports Nrc.Framework.AddressCleaning

Public Class AddressCleaner

    Shared Sub Main(ByVal args() As String)

        Dim dataFileID As Integer

        'Make sure we have exactly 1 argument
        If Not args.Length = 1 Then
            Exit Sub
        End If

        'Chaeck to see if we are to prompt for the dataFileID
        If args(0).ToLower() = "/p" Then
            args(0) = InputBox("Enter a Data File ID")
        End If

        'Convert the argument into an integer dataFileID
        Try
            dataFileID = Integer.Parse(args(0))
            If Not dataFileID > 0 Then
                Exit Sub
            End If

        Catch ex As Exception
            Exit Sub

        End Try

        'Perform the cleaning operation
        Try
            Clean(dataFileID)

        Catch ex As Exception
            LogEvent(dataFileID, String.Format("Address Cleaning Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))

        End Try

    End Sub

    Private Shared Sub Clean(ByVal dataFileID As Integer)

        Dim file As DataFile = Nothing
        Dim package As DTSPackage = Nothing
        Dim addCleaner As Cleaner

        Try
            file = New DataFile
            file.LoadFromDB(dataFileID)

            package = New DTSPackage(file.PackageID, file.Version)

            'Make sure package is not locked
            If package.LockStatus = DTSPackage.LockState.Unlocked Then

                'Write to log
                LogEvent(dataFileID, "Begin Address Cleaning")

                'Lock the package
                package.LockPackage()

                'Mark file as Cleaning
                file.ChangeState(DataFile.State.AddressCleaning, "")

                'Determine if we need to use a web proxy
                Dim forceProxy As Boolean = ((Nrc.Framework.BusinessLogic.Configuration.AppConfig.Params("WebServiceProxyRequiredServer").IntegerValue = 1) OrElse System.Diagnostics.Debugger.IsAttached)

                'BEGIN ADDRESS CLEAN
                addCleaner = New Cleaner(Nrc.Framework.BusinessLogic.Configuration.AppConfig.CountryID, LoadDatabases.QPLoad)
                Dim groups As MetaGroupCollection
                If addCleaner.IsCleanAddrBitSet(package.Study.StudyID) Then
                    groups = addCleaner.CleanAll(dataFileID, package.Study.StudyID, Nrc.Framework.BusinessLogic.Configuration.AppConfig.Params("BatchSize").IntegerValue, forceProxy)
                    MetaGroup.SaveCounts(dataFileID, groups, LoadDatabases.QPLoad)
                    addCleaner = Nothing
                End If
                'END CLEAN

                'Mark file as "Awaiting Validation"
                file.ChangeState(DataFile.State.AwaitingValidation, "")

                LogEvent(dataFileID, "End Address Cleaning")
            End If

        Catch ex As PackageLockException
            LogEvent(dataFileID, String.Format("Exception: Could not clean DataFile_id {0}: Package {1} is already locked.", dataFileID, ex.PackageID))

        Catch ex As Exception
            'Uh oh
            LogEvent(dataFileID, String.Format("Exception: Could not clean DataFile_id {0}: {1}{2}{3}", dataFileID, ex.Message, vbCrLf, ex.StackTrace))

            'Mark the file as abandoned
            If Not file Is Nothing Then
                file.ChangeState(DataFile.State.Abandoned, "Address Cleaning Exception: " & ex.Message)
            End If

        Finally
            'Unlock the package if we need to...
            If Not package Is Nothing AndAlso package.LockStatus = DTSPackage.LockState.LockedByMe Then
                package.UnlockPackage()
            End If

        End Try

    End Sub

    Private Shared Sub LogEvent(ByVal dataFileID As Integer, ByVal eventData As String)

        Try
            PackageDB.LogServiceEvent(Nrc.Framework.BusinessLogic.Configuration.AppConfig.QLoaderConnection, dataFileID, eventData, System.Threading.Thread.CurrentThread.ManagedThreadId)

        Catch ex As Exception
            EventLog.WriteEntry("FileLoader", eventData & vbCrLf & ex.StackTrace, EventLogEntryType.Error)

        End Try

    End Sub

End Class
