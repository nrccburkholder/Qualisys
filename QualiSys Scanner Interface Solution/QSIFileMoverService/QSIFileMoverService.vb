Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.QualiSys.Scanning.Library
Imports System.IO

Public Class QSIFileMoverService

#Region " Private Members "

    Private mMoveQueue As QueuedTransferFileCollection

    Private WithEvents mTimer As Timers.Timer

#End Region

#Region " Service Events (Start, Stop, Pause, Continue) "

    Protected Overrides Sub OnStart(ByVal args() As String)

        Try
            'Instatiate the timer and start it
            mTimer = New Timers.Timer(AppConfig.Params("QSIFileMoverInterval").IntegerValue)
            mTimer.AutoReset = False
            mTimer.Enabled = True

        Catch ex As Exception
            'Send the notification
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIFileMoverService, "The service was unable to start!", ex, True), EventLogEntryType.Error)

        End Try

    End Sub

    Protected Overrides Sub OnStop()

        'Pause the timer
        mTimer.Enabled = False

    End Sub

    Protected Overrides Sub OnContinue()

        'Pause the timer
        mTimer.Enabled = True

    End Sub

    Protected Overrides Sub OnPause()

        'Pause the timer
        mTimer.Enabled = False

    End Sub

#End Region

#Region " Timer Events "

    Private Sub mTimer_Elapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs) Handles mTimer.Elapsed

        'Check to see if we are within operating hours
        If Now.Hour >= AppConfig.Params("ServicesDownTimeStartHour").IntegerValue AndAlso Now.Hour < AppConfig.Params("ServicesDownTimeEndHour").IntegerValue Then
            'Check to see if there are any files to process
            CheckForWork()
        End If

        'When processing it complete restart the timer
        mTimer.Enabled = True

    End Sub

#End Region

#Region " Private Methods "

    Private Sub CheckForWork()

        Try
            'Populate the queue with all files ready to be loaded
            PopulateMoveQueue()

            'Loop through all of the files in the queue and load them
            For Each file As QueuedTransferFile In mMoveQueue
                'Send an email notification that this file has been recieved
                LogEvent(file.SendFileReceivedNotification, EventLogEntryType.Information)

                'Move the file
                ExecuteMove(file)
            Next

        Catch ex As Exception
            'Houston, we have a problem!
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIFileMoverService, "Error encountered, unable to check for work", ex, False), EventLogEntryType.Error)

        End Try

    End Sub

    Private Sub PopulateMoveQueue()

        Dim ftpPath As String = String.Empty

        'Create a new collection
        mMoveQueue = New QueuedTransferFileCollection

        'Loop through all of the vendors
        Dim vendors As VendorCollection = Vendor.GetAll
        For Each vend As Vendor In vendors
            If Not String.IsNullOrEmpty(vend.LocalFTPLoginName) Then
                'Loop through all of the translation modules for this vendor
                Dim translators As TranslationModuleCollection = TranslationModule.GetByVendorId(vend.VendorId)
                For Each translator As TranslationModule In translators
                    'Check the FTP drop point to see if there are any files to be moved
                    ftpPath = Path.Combine(AppConfig.Params("QSIFileMoverRootPath").StringValue, vend.LocalFTPLoginName)
                    ftpPath = Path.Combine(ftpPath, "uploads")
                    Dim folder As New DirectoryInfo(ftpPath)
                    If folder.Exists Then
                        For Each file As FileInfo In folder.GetFiles(translator.FileType)
                            Try
                                'Attempt to get a file lock
                                Dim temp As FileStream = New FileStream(file.FullName, FileMode.Open, FileAccess.ReadWrite, FileShare.None)

                                'We are good so close the file stream
                                temp.Close()

                                'Load this file into the collection
                                mMoveQueue.Add(New QueuedTransferFile(vend, translator, file))

                            Catch ex As Exception
                                'This file must still be open by another process

                            End Try
                        Next
                    End If
                Next
            End If
        Next

    End Sub

    Private Sub ExecuteMove(ByVal file As QueuedTransferFile)

        Try
            'Move the file
            file.MoveToInbound()

        Catch ex As Exception
            Dim msg As String = "Exception Encountered While Attempting to Move File!"
            Dim errEx As New InvalidFileException(msg, file.File.FullName, ex)
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIFileMoverService, msg, errEx, False), EventLogEntryType.Error)

        End Try

    End Sub

#End Region

#Region " Notification And Event Logging "

    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        'Check the length of the eventData
        If eventData.Length > 32000 Then
            eventData = eventData.Substring(0, 32000)
        End If

        'Write the log entry
        EventLog.WriteEntry(eventData, entryType)

    End Sub

#End Region

End Class
