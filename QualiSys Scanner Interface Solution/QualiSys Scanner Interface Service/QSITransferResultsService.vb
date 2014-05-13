Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.QualiSys.Scanning.Library
Imports System.IO

Public Class QSITransferResultsService

#Region " Private Members "

    Private mTransferQueue As QueuedTransferFileCollection

    Private WithEvents mTimer As Timers.Timer

#End Region

#Region " Service Events (Start, Stop, Pause, Continue) "

    Protected Overrides Sub OnStart(ByVal args() As String)

        Try
            'Instatiate the timer and start it
            mTimer = New Timers.Timer(AppConfig.Params("QSIServiceInterval").IntegerValue)
            mTimer.AutoReset = False
            mTimer.Enabled = True

        Catch ex As Exception
            'Send the notification
            LogEvent(Translator.SendNotification(QSIServiceNames.QSITransferResultsService, "The service was unable to start!", ex, True), EventLogEntryType.Error)

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

            'Cleanup the temp folder
            DirectoryCleanUp(AppConfig.Params("QSITransferTempFolder").StringValue, 14)
        End If

        'When processing it complete restart the timer
        mTimer.Enabled = True

    End Sub

#End Region

#Region " Private Methods "

    Private Sub CheckForWork()

        Try
            'Populate the queue with all files ready to be loaded
            PopulateTransferQueue()

            'Loop through all of the files in the queue and load them
            For Each file As QueuedTransferFile In mTransferQueue
                'Execute the transfer
                ExecuteTransfer(file)
            Next

        Catch ex As System.OutOfMemoryException
            'We seem to have used up all of the memory so let's log the problem and clean things up a bit.
            LogEvent(Translator.SendNotification(QSIServiceNames.QSITransferResultsService, "Error encountered while checking for work (Out of Memory).  Attempting to do garbage collection", ex, True), EventLogEntryType.Error)
            GC.Collect()

        Catch ex As Exception
            'Houston, we have a problem!
            LogEvent(Translator.SendNotification(QSIServiceNames.QSITransferResultsService, "Error encountered, unable to check for work", ex, False), EventLogEntryType.Error)

        End Try

    End Sub

    Private Sub PopulateTransferQueue()

        'Create a new collection
        mTransferQueue = New QueuedTransferFileCollection

        'Loop through all of the vendors
        Dim vendors As VendorCollection = Vendor.GetAll
        For Each vend As Vendor In vendors
            'Are we accepting files from this vendor
            If vend.AcceptFilesFromVendor Then
                'Loop through all of the translation modules for this vendor
                Dim translators As TranslationModuleCollection = TranslationModule.GetByVendorId(vend.VendorId)
                For Each translator As TranslationModule In translators
                    'Check the translation module drop point to see if there are any files to be loaded
                    Dim folder As New DirectoryInfo(translator.WatchedFolderPath)
                    If folder.Exists Then
                        For Each file As FileInfo In folder.GetFiles(translator.FileType)
                            Try
                                'Attempt to get a file lock
                                Dim temp As FileStream = New FileStream(file.FullName, FileMode.Open, FileAccess.ReadWrite, FileShare.None)

                                'We are good so close the file stream
                                temp.Close()

                                'Load this file into the collection
                                mTransferQueue.Add(New QueuedTransferFile(vend, translator, file))

                            Catch ex As Exception
                                'This file must still be open by another process

                            End Try
                        Next
                    End If
                Next
            End If
        Next

    End Sub

    Private Sub ExecuteTransfer(ByVal file As QueuedTransferFile)

        Dim loadFile As DataLoad = Nothing
        Dim translateEngine As Translator = Nothing

        Try
            'Get the appropriate translator object
            Select Case file.Translator.ModuleName
                Case "TranslatorCSV"
                    translateEngine = New TranslatorCSV

                Case "TranslatorCSVHorz"
                    translateEngine = New TranslatorCSVHorz

                Case "TranslatorCSVBedside"
                    translateEngine = New TranslatorCSVBedside

                Case "TranslatorTABHorz"
                    translateEngine = New TranslatorTABHorz

            End Select

            'Read and translate the file into a DataLoad object
            loadFile = translateEngine.Translate(file)
            translateEngine = Nothing

        Catch invalidFileEx As InvalidFileException
            LogEvent(Translator.SendNotification(QSIServiceNames.QSITransferResultsService, "Exception Encountered While Attempting to Transfer File!", invalidFileEx, False), EventLogEntryType.Error)

        Catch ex As Exception
            Dim msg As String = "Exception Encountered While Attempting to Transfer File!"
            Dim errEx As New InvalidFileException(msg, file.File.FullName, ex)
            LogEvent(Translator.SendNotification(QSIServiceNames.QSITransferResultsService, msg, errEx, False), EventLogEntryType.Error)

        End Try

    End Sub

    ''' <summary>
    ''' Remove sub directories and their files older then {days}.
    ''' </summary>
    ''' <param name="path">The base directory path</param>
    ''' <param name="days">Number of days to retain items</param>
    ''' <remarks>Remove items where last write time was {days} days ago.</remarks>
    Private Sub DirectoryCleanUp(ByVal path As String, ByVal days As Integer)

        Try
            'Loop through all folders in the specified root folder
            For Each dir As String In Directory.GetDirectories(path)
                'Get a reference to this folder
                Dim dirInfo As New DirectoryInfo(dir)

                'Check to see if the folder is older than the specified # of days
                If dirInfo.LastWriteTime < Now.AddDays(-1 * days) Then
                    'The folder is older than the specified # days so remove it and it's contents
                    dirInfo.Delete(True)
                End If
            Next

            'Loop through all files in the specified root folder
            For Each file As String In Directory.GetFiles(path)
                'Get a reference to this file
                Dim filInfo As New FileInfo(file)

                'Check to see if the file is older than the specified # of days
                If filInfo.LastWriteTime < Date.Now.AddDays(-1 * days) Then
                    'The file is older than the specified # days so remove it
                    filInfo.Delete()
                End If
            Next

        Catch ex As Exception
            LogEvent(Translator.SendNotification(QSIServiceNames.QSITransferResultsService, "Error encountered, unable to clean up directories.", ex, False), EventLogEntryType.Error)

        End Try

    End Sub
#End Region

#Region " Notification And Event Logging "

    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        'Check the length of the eventData. Cannot be longer than 32766 bytes.
        'Originally this was capping the length at 32000, but even that was causing the dreaded 'The parameter is incorrect' failure in the event log.
        'Reducing the cap to 31000.  TSB 05/09/2014
        If eventData.Length > 31000 Then
            eventData = eventData.Substring(0, 31000)
        End If

        'Write the log entry
        EventLog.WriteEntry(eventData, entryType)

    End Sub

#End Region

End Class
