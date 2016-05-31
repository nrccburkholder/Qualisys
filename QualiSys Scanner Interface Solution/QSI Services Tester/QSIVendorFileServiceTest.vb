Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class QSIVendorFileServiceTest

#Region "Private Members"

    Private mSendTelematchQueue As QueuedVendorFileCollection
    Private mSendFileQueue As QueuedVendorFileCollection
    Private mRetrieveTelematchQueue As QueuedVendorFileCollection

#End Region

#Region "Run As Service Button Events"

    Private Sub StartButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartButton.Click

        Try
            'Instatiate the timer and start it
            'ServiceTimer.Interval = AppConfig.Params("QSIVendorFileInterval").IntegerValue
            ServiceTimer.Interval = 10000
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
            LogEvent("The QSI Vendor File Service was unable to start!", ex, EventLogEntryType.Error)

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

    Private Sub TelematchSendButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TelematchSendButton.Click

        Dim vendorFile As VendorFileCreationQueue = VendorFileCreationQueue.Get(CInt(VendorFileIDTextBox.Text))
        If vendorFile Is Nothing Then
            MessageBox.Show("Invalid Vendor File ID", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        Dim methStep As MethodologyStep = MethodologyStep.Get(vendorFile.MailingStepId)
        If methStep Is Nothing Then
            MessageBox.Show("The Mailing Step ID associated with the Vendor File ID is invalid", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        ElseIf Not methStep.VendorID.HasValue Then
            MessageBox.Show("The Vendor has not been selected for the associated Methodology Step.", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        Dim vendor As Vendor = vendor.Get(methStep.VendorID.Value)
        If vendor Is Nothing Then
            MessageBox.Show("The Vendor ID associated with the Methodology Step is invalid", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        Dim test As QueuedVendorFile = New QueuedVendorFile(vendorFile, vendor, methStep)
        test.SendCSVFileToTelematch()

    End Sub

    Private Sub TelematchReceiveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TelematchReceiveButton.Click

        Dim log As VendorFileTelematchLog = VendorFileTelematchLog.Get(CInt(VendorFileTelematchLogIDTextBox.Text))
        If log Is Nothing Then
            MessageBox.Show("Invalid Vendor File Telematch Log ID", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        ElseIf log.VendorFileId <> CInt(VendorFileIDTextBox.Text) Then
            MessageBox.Show("The supplied Vendor File ID does not match the one associated with the specified Vendor File Telematch Log ID.  We are going to use the one that matches :)", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            VendorFileIDTextBox.Text = log.VendorFileId.ToString
        End If

        Dim vendorFile As VendorFileCreationQueue = VendorFileCreationQueue.Get(log.VendorFileId)
        If vendorFile Is Nothing Then
            MessageBox.Show("Invalid Vendor File ID", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        Dim methStep As MethodologyStep = MethodologyStep.Get(vendorFile.MailingStepId)
        If methStep Is Nothing Then
            MessageBox.Show("The Mailing Step ID associated with the Vendor File ID is invalid", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        ElseIf Not methStep.VendorID.HasValue Then
            MessageBox.Show("The Vendor has not been selected for the associated Methodology Step.", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        Dim vendor As Vendor = vendor.Get(methStep.VendorID.Value)
        If vendor Is Nothing Then
            MessageBox.Show("The Vendor ID associated with the Methodology Step is invalid", "Telematch Test", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        Dim test As QueuedVendorFile = New QueuedVendorFile(vendorFile, vendor, methStep, log)
        test.SendTelematchedFileToVendor(vendor.VendorFileOutgoTypeId = 2)

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
            LogEvent("Error encountered, unable to check for work", ex, EventLogEntryType.Error)

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

        'Get the files that are out being telematched
        mRetrieveTelematchQueue = New QueuedVendorFileCollection

        ' Only need to check for telematch files if NOT Canada
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

    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        MessageBox.Show(eventData, My.Application.Info.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)

    End Sub

    Private Sub LogEvent(ByVal message As String, ByVal ex As Exception, ByVal entryType As EventLogEntryType)

        LogEvent(String.Format("{0}{1}{1}{2}{1}{1}Source: {3}{1}{1}Stack Trace:{1}{4}", message, vbCrLf, ex.Message, ex.Source, ex.StackTrace), entryType)

    End Sub

#End Region

End Class