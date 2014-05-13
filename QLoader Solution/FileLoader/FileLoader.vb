Imports Nrc.Qualisys.QLoader.Library
Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class FileLoader

#Region " Main Console App "

    Shared Sub Main(ByVal args() As String)

        Dim dataFileID As Integer

        If Not args.Length = 1 Then
            Exit Sub
        End If

        If args(0).ToLower() = "/p" Then
            args(0) = InputBox("Enter a Data File ID")
        End If

        Try
            dataFileID = Integer.Parse(args(0))
            If Not dataFileID > 0 Then
                Exit Sub
            End If

        Catch ex As Exception
            Exit Sub

        End Try

        Try
            SetupNrcAuthSettings()
            LoadFile(dataFileID)

        Catch ex As Exception
            LogEvent(dataFileID, String.Format("DTS Execution Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace))

        End Try

    End Sub

#End Region

#Region " Private Methods "

    Private Shared Sub LoadFile(ByVal dataFileID As Integer)

        Dim file As DataFile = Nothing
        Dim package As DTSPackage = Nothing

        Try
            'Get the file
            file = New DataFile
            file.LoadFromDB(dataFileID)

            'Get the package
            package = New DTSPackage(file.PackageID, file.Version)

            'Make sure package is not locked
            If package.LockStatus = PackageLockStates.Unlocked Then
                'Write to log
                LogEvent(dataFileID, "Begin DTS Execution")

                package.LockPackage()       'Lock the package

                'Mark file as "Loading"
                file.ChangeState(DataFileStates.FileLoading, "")

                'Execute the package
                package.ExecutePackage(file, False)

                'Check if this file is marked as DRGUpdate
                If file.IsDRGUpdate Then
                    'Log end of DTS exec.
                    LogEvent(file.DataFileID, "End DTS Execution")

                    'Log start of drg update
                    LogEvent(dataFileID, "Begin DRG Update Execution")

                    'Change state to 'drg updating'
                    file.ChangeState(DataFileStates.DRGUpdating, "")

                    'call to actual update
                    file.UpdateDRG()

                    'done. mark as drg applied
                    file.ChangeState(DataFileStates.DRGApplied, "")

                    'log end of drg
                    LogEvent(dataFileID, "End DRG Update Execution")
                Else
                    'Mark file as "Awaiting Address Cleaning"
                    file.ChangeState(DataFileStates.AwaitingAddressClean, "")

                    'log end of dts
                    LogEvent(file.DataFileID, "End DTS Execution")
                End If
            End If

        Catch ex As PackageLockException
            LogEvent(dataFileID, String.Format("Exception: Could not load DataFile_id {0}: Package {1} is already locked.", dataFileID, ex.PackageID))

        Catch ex As Exception
            'Uh oh
            LogEvent(dataFileID, String.Format("Exception: Could not load DataFile_id {0}: {1}{2}{3}", dataFileID, ex.Message, vbCrLf, ex.StackTrace))

            'Mark the file as abandoned
            If Not file Is Nothing Then
                file.ChangeState(DataFileStates.Abandoned, "DTS Exception: " & ex.Message)
            End If

        Finally
            'Unlock the package if we need to...
            If Not package Is Nothing AndAlso package.LockStatus = PackageLockStates.LockedByMe Then
                package.UnlockPackage()
            End If

            file = Nothing
            package = Nothing
        End Try

    End Sub

#End Region

#Region " Private Shared Methods "

    Private Shared Sub LogEvent(ByVal dataFileID As Integer, ByVal eventData As String)

        Try
            PackageDB.LogServiceEvent(dataFileID, eventData, Threading.Thread.CurrentThread.ManagedThreadId)

        Catch ex As Exception
            EventLog.WriteEntry("FileLoader", eventData & vbCrLf & ex.StackTrace, EventLogEntryType.Error)

        End Try

    End Sub

    Private Shared Sub SetupNrcAuthSettings()

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
