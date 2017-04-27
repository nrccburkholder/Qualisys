Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports System.IO
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class QSIVendorFileService

#Region " Private Members "

    Private mSendTelematchQueue As QueuedVendorFileCollection
    Private mSendFileQueue As QueuedVendorFileCollection
    Private mRetrieveTelematchQueue As QueuedVendorFileCollection

    Private WithEvents mTimer As Timers.Timer

#End Region

#Region " Service Events (Start, Stop, Pause, Continue) "

    Protected Overrides Sub OnStart(ByVal args() As String)

        Try
            'Instatiate the timer and start it
            mTimer = New Timers.Timer(AppConfig.Params("QSIVendorFileInterval").IntegerValue)
            mTimer.AutoReset = False
            mTimer.Enabled = True

        Catch ex As Exception
            'Send the notification
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIVendorFileService, "The service was unable to start!", ex, True), EventLogEntryType.Error)

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
            DirectoryCleanUp(AppConfig.Params("QSIVendorFileInProcessFolder").StringValue, 14)
        End If

        'When processing it complete restart the timer
        mTimer.Enabled = True

    End Sub

#End Region

#Region " Private Methods "

    Private Sub CheckForWork()

        Try
            'Populate the queue with all files ready to be loaded
            PopulateQueues()

            'Let's send files to telelmatch first
            For Each file As QueuedVendorFile In mSendTelematchQueue
                'Create the file as a CSV
                file.SendCSVFileToTelematch()
            Next

            'Next we will send files to the vendor
            For Each file As QueuedVendorFile In mSendFileQueue
                'Determine the file type to be sent
                Dim outgoType As VendorFileOutgoType = VendorFileOutgoType.Get(file.Vendor.VendorFileOutgoTypeId)
                If outgoType Is Nothing Then
                    'The specified OutgoType is invalid
                    Throw New Exception(String.Format("Invalid VendorFileOutgoType ({0}) specified for VendorFileID ({1}) and Vendor {2} ({3})", file.Vendor.VendorFileOutgoTypeId, file.VendorFile.VendorFileId, file.Vendor.VendorName, file.Vendor.VendorId))
                End If

                'Get the file extension
                Dim extension As String = outgoType.FileExtension.ToLower
                If extension = ".csv" Then
                    'We are sending a CSV file to the vendor
                    file.SendCSVFileToVendor()
                Else
                    'We are sending an XLS file to the vendor
                    file.SendXLSFileToVendor()
                End If
            Next

            'And last but not least, let's deal with the files coming back from telematch
            For Each file As QueuedVendorFile In mRetrieveTelematchQueue
                'Determine the file type to be sent
                Dim outgoType As VendorFileOutgoType = VendorFileOutgoType.Get(file.Vendor.VendorFileOutgoTypeId)
                If outgoType Is Nothing Then
                    'The specified OutgoType is invalid
                    Throw New Exception(String.Format("Invalid VendorFileOutgoType ({0}) specified for VendorFileID ({1}) and Vendor {2} ({3})", file.Vendor.VendorFileOutgoTypeId, file.VendorFile.VendorFileId, file.Vendor.VendorName, file.Vendor.VendorId))
                End If

                'Get the file extension
                Dim extension As String = outgoType.FileExtension.ToLower
                If extension = ".csv" Then
                    'We are sending a CSV file to the vendor so just send the returned file
                    file.SendTelematchedFileToVendor(False)
                Else
                    'We are sending an XLS file to the vendor so convert it to XLS and send it
                    file.SendTelematchedFileToVendor(True)
                End If
            Next

            'Send notification
            LogEvent(QueuedVendorFile.SendNotification(mSendTelematchQueue, mSendFileQueue, mRetrieveTelematchQueue), EventLogEntryType.Information)

        Catch ex As Exception
            'Houston, we have a problem!
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIVendorFileService, "Error encountered, unable to check for work", ex, False), EventLogEntryType.Error)

        End Try

    End Sub

    Private Sub PopulateQueues()

        Dim skipTelematch As Boolean = QualisysParams.CountryCode = CountryCode.Canada

        'Get all of the approved files
        mSendTelematchQueue = New QueuedVendorFileCollection
        mSendFileQueue = New QueuedVendorFileCollection
        Dim sendFiles As VendorFileCreationQueueCollection = VendorFileCreationQueue.GetByVendorFileStatusId(VendorFileStatusCodes.Approved)

        'Populate the send queues
        For Each file As VendorFileCreationQueue In sendFiles
            'Get the methodology step
            Dim methStep As MethodologyStep = MethodologyStep.Get(file.MailingStepId)

            'Determine if we have a vendor set
            If methStep.VendorID.HasValue AndAlso _
               methStep.VendorID.Value <> AppConfig.Params("QSIVerint-US-VendorID").IntegerValue AndAlso _
               methStep.VendorID.Value <> AppConfig.Params("QSIVerint-CA-VendorID").IntegerValue AndAlso _
               methStep.VendorID.Value <> AppConfig.Params("QSIBedsideVendorID").IntegerValue Then
                'Get the vendor
                Dim vendor As Vendor = vendor.Get(methStep.VendorID.Value)

                'Determine if we are sending this for telematching.  This will only happen if we are NOT Canada.
                If methStep.StepMethodId = MailingStepMethodCodes.Phone And Not skipTelematch Then
                    'This needs to go to telematch
                    mSendTelematchQueue.Add(New QueuedVendorFile(file, vendor, methStep))
                Else
                    'This just goes to the vendor
                    mSendFileQueue.Add(New QueuedVendorFile(file, vendor, methStep))
                End If
            End If
        Next

        'Get the files that are out being telematched, but only if NOT Canada
        mRetrieveTelematchQueue = New QueuedVendorFileCollection
        If Not skipTelematch Then

            Dim retrieveLogs As VendorFileTelematchLogCollection = VendorFileTelematchLog.GetByNotReturned()

            'Populate the retrieve queue
            For Each log As VendorFileTelematchLog In retrieveLogs
                'Get the vendor file
                Dim file As VendorFileCreationQueue = VendorFileCreationQueue.Get(log.VendorFileId)

                'Determine if the VendorFile is still in Telematching state
                If file.VendorFileStatusId = VendorFileStatusCodes.Telematching Then
                    'Get the methodology step
                    Dim methStep As MethodologyStep = MethodologyStep.Get(file.MailingStepId)

                    'Get the vendor
                    Dim vendor As Vendor = vendor.Get(methStep.VendorID.Value)

                    'Add the file to the queue
                    mRetrieveTelematchQueue.Add(New QueuedVendorFile(file, vendor, methStep, log))
                End If
            Next
        End If

    End Sub

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
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIVendorFileService, "Error encountered, unable to clean up directories.", ex, False), EventLogEntryType.Error)

        End Try

    End Sub

#End Region

#Region " Notification And Event Logging "

    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        'Check the length of the eventData
        If eventData.Length > AppConfig.Params("QSIEventLogMessageLengthMax").IntegerValue Then
            eventData = eventData.Substring(0, AppConfig.Params("QSIEventLogMessageLengthMax").IntegerValue)
        End If

        'Write the log entry
        EventLog.WriteEntry(eventData, entryType)

    End Sub

#End Region


End Class
