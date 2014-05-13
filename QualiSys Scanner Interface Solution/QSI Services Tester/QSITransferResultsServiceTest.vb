Imports System.IO
Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class QSITransferResultsServiceTest

#Region "Private Members"

    Private mTransferQueue As QueuedTransferFileCollection

#End Region

#Region "Run As Service Button Events"

    Private Sub StartButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartButton.Click

        Try
            'Instatiate the timer and start it
            ServiceTimer.Interval = 10000
            'ServiceTimer.Interval = AppConfig.Params("QSIServiceInterval").IntegerValue
            ServiceTimer.Enabled = True

            'Lock buttons
            StartButton.Enabled = False
            PauseButton.Enabled = True
            ContinueButton.Enabled = False
            StopButton.Enabled = True

            'Display a message
            ServiceTextBox.Text = String.Format("Service Started at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)
            ServiceStatusLabel.Text = "Running"

        Catch ex As Exception
            'Log the error in the event log
            LogEvent("The service was unable to start!", ex, EventLogEntryType.Error)

            'Lock buttons
            StartButton.Enabled = True
            PauseButton.Enabled = False
            ContinueButton.Enabled = False
            StopButton.Enabled = False
            ServiceStatusLabel.Text = "Stopped"

        End Try

    End Sub

    Private Sub StopButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StopButton.Click

        'Pause the timer
        ServiceTimer.Enabled = False

        'Lock buttons
        StartButton.Enabled = True
        PauseButton.Enabled = False
        ContinueButton.Enabled = False
        StopButton.Enabled = False

        'Display a message
        ServiceTextBox.Text = String.Format("Service Stopped at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)
        ServiceStatusLabel.Text = "Stopped"

    End Sub

    Private Sub ContinueButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ContinueButton.Click

        'Start the timer
        ServiceTimer.Enabled = True

        'Lock buttons
        StartButton.Enabled = False
        PauseButton.Enabled = True
        ContinueButton.Enabled = False
        StopButton.Enabled = True

        'Display a message
        ServiceTextBox.Text = String.Format("Service Continued at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)
        ServiceStatusLabel.Text = "Running"

    End Sub

    Private Sub PauseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PauseButton.Click

        'Pause the timer
        ServiceTimer.Enabled = False

        'Lock buttons
        StartButton.Enabled = False
        PauseButton.Enabled = False
        ContinueButton.Enabled = True
        StopButton.Enabled = True

        'Display a message
        ServiceTextBox.Text = String.Format("Service Paused at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)
        ServiceStatusLabel.Text = "Paused"

    End Sub

#End Region

#Region "Timer Events"

    Private Sub ServiceTimer_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ServiceTimer.Tick

        'Check to see if there are any files to process
        ServiceTimer.Enabled = False

        'Check to see if we are within operating hours
        If Now.Hour >= AppConfig.Params("ServicesDownTimeStartHour").IntegerValue AndAlso Now.Hour < AppConfig.Params("ServicesDownTimeEndHour").IntegerValue Then
            'Check to see if there are any files to process
            CheckForWork()

            'Cleanup the temp folder
            DirectoryCleanUp(AppConfig.Params("QSITransferTempFolder").StringValue, 14)
        End If

        'When processing it complete restart the timer
        ServiceTimer.Enabled = True

    End Sub

#End Region

#Region "Private Methods"

    Private Sub CheckForWork()

        'Display a message
        ServiceTextBox.Text = String.Format("CheckForWork at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)

        Try
            'Populate the queue with all files ready to be loaded
            PopulateTransferQueue()

            'Loop through all of the files in the queue and load them
            For Each file As QueuedTransferFile In mTransferQueue
                'Display a message
                ServiceTextBox.Text = String.Format("Starting Transfer at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)

                'Execute the transfer
                ExecuteTransfer(file)
            Next

        Catch ex As System.OutOfMemoryException
            'We seem to have used up all of the memory so let's log the problem and clean things up a bit.
            LogEvent("Error encountered while checking for work (Out of Memory).  Attempting to do garbage collection", ex, EventLogEntryType.Error)
            GC.Collect()

        Catch ex As Exception
            'Houston, we have a problem!
            LogEvent("Error encountered, unable to check for work", ex, EventLogEntryType.Error)

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
                                Using temp As FileStream = New FileStream(file.FullName, FileMode.Open, FileAccess.ReadWrite, FileShare.None)
                                    'We are good so close the file stream
                                    temp.Close()
                                End Using

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

    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        MessageBox.Show(eventData, My.Application.Info.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)

    End Sub

    Private Sub LogEvent(ByVal message As String, ByVal ex As Exception, ByVal entryType As EventLogEntryType)

        LogEvent(String.Format("{0}{1}{1}{2}{1}{1}Source: {3}{1}{1}Stack Trace:{1}{4}", message, vbCrLf, ex.Message, ex.Source, ex.StackTrace), entryType)

    End Sub

#End Region

End Class
