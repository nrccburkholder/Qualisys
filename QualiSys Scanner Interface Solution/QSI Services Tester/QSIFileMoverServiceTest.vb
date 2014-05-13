Imports System.Data
Imports System.IO
Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration
Imports System.Threading

Public Class QSIFileMoverServiceTest

#Region "Private Members"

    Private mTransferQueue As QueuedTransferFileCollection

#End Region

#Region "Run As Service Button Events"

    Private Sub StartButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartButton.Click

        Try
            'Instatiate the timer and start it
            ServiceTimer.Interval = AppConfig.Params("QSIFileMoverInterval").IntegerValue
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
            LogEvent("The QSI File Mover Service was unable to start!", ex, EventLogEntryType.Error)

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
        CheckForWork()

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
                ServiceTextBox.Text = String.Format("Starting File Move at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)

                'Send an email notification that this file has been recieved
                LogEvent(file.SendFileReceivedNotification, EventLogEntryType.Information)

                'Move the file
                ExecuteMove(file)
            Next

        Catch ex As Exception
            'Houston, we have a problem!
            LogEvent("Error encountered, unable to check for work", ex, EventLogEntryType.Error)

        End Try

    End Sub

    Private Sub PopulateTransferQueue()

        Dim ftpPath As String = String.Empty

        'Create a new collection
        mTransferQueue = New QueuedTransferFileCollection

        'Loop through all of the vendors
        Dim vendors As VendorCollection = Vendor.GetAll
        For Each vend As Vendor In vendors
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
                            mTransferQueue.Add(New QueuedTransferFile(vend, translator, file))

                        Catch ex As Exception
                            'This file must still be open by another process

                        End Try
                    Next
                End If
            Next
        Next

    End Sub

    Private Sub ExecuteMove(ByVal file As QueuedTransferFile)

        Try
            'Move the file
            file.MoveToInbound()

        Catch ex As Exception
            Dim msg As String = "Exception Encountered While Attempting to Move File!"
            Dim errEx As New InvalidFileException(msg, file.File.FullName, ex)
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIFileMoverService, msg, errEx, True), EventLogEntryType.Error)

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