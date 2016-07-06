Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Notification
Imports Nrc.Qualisys.Pervasive.Library
Imports System.Threading


Public Class PervasiveTestForm

#Region " Private Members "

    Private mValidateQueue As Queue = Queue.Synchronized(New Queue)
    Private mApplyQueue As Queue = Queue.Synchronized(New Queue)
    Private mValidationCount As Integer
    Private mApplyCount As Integer

#End Region

#Region " Run As Service Button Events "

    Private Sub StartButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartButton.Click

        Try
            'Instatiate the timer and start it
            ServiceTimer.Interval = AppConfig.Params("TimerInterval").IntegerValue
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
            LogEvent("The Pervasive Service was unable to start!", ex, EventLogEntryType.Error)

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

    Private Sub RunNowButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunNowButton.Click

        'Display a message
        ServiceTextBox.Text = String.Format("RunNow Button at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)

        'Stop the timer
        ServiceTimer.Enabled = False

        'Check to see if there are any files to process
        CheckForWork()

        'Lock buttons
        StartButton.Enabled = True
        PauseButton.Enabled = False
        ContinueButton.Enabled = False
        StopButton.Enabled = False

    End Sub

#End Region

#Region " Timer Events "

    Private Sub ServiceTimer_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ServiceTimer.Tick

        ServiceTimer.Enabled = False

        If Now.Hour >= AppConfig.Params("PrevServiceBeginHour").IntegerValue AndAlso Now.Hour < AppConfig.Params("PrevServiceStopHour").IntegerValue Then
            CheckForWork()
        End If

        'When processing it complete restart the timer
        ServiceTimer.Enabled = True

    End Sub

#End Region

#Region " Private Methods "
    Public Sub CheckForWork()

        Dim files As DataFileStateCollection
        Dim file As DataFileState

        Try
            If mValidationCount < Config.MaxConcurrentValidations OrElse mApplyCount < Config.MaxConcurrentApplies Then
                mValidateQueue.Clear()
                mApplyQueue.Clear()

                'Get all datafiles in AwaitingValidation State
                files = DataFileState.GetByStateId(DataFileStates.AwaitingValidation)
                For Each file In files
                    If mValidationCount < Config.MaxConcurrentValidations Then
                        mValidateQueue.Enqueue(file)
                        ExecuteValidation()

                        'Dim t As New Thread(AddressOf ExecuteValidation)
                        't.TrySetApartmentState(ApartmentState.MTA)
                        'mValidationCount += 1
                        't.Start()
                    End If
                Next

                'Get all datafiles in AwaitingApply State
                files = DataFileState.GetByStateId(DataFileStates.AwaitingApply)
                For Each file In files
                    If mApplyCount < Config.MaxConcurrentApplies Then
                        mApplyQueue.Enqueue(file)
                        ExecuteApply()

                        'Dim t As New Thread(AddressOf ExecuteApply)
                        't.TrySetApartmentState(ApartmentState.MTA)
                        'mApplyCount += 1
                        't.Start()
                    End If
                Next
            End If

        Catch ex As System.OutOfMemoryException
            LogEvent(SendNotification("Exception checking for work (Out of Memory)!", "N/A", ex, True), EventLogEntryType.Error)
            GC.Collect()

        Catch ex As Exception
            LogEvent(SendNotification("Exception: Could not check for work!", "N/A", ex, True), EventLogEntryType.Error)
        End Try

    End Sub

#End Region

#Region " Execute Validation "

    Private Sub ExecuteValidation()

        Dim queueFile As DataFileState = Nothing
        Dim loadFile As DataFile = Nothing
        Dim passValidation As Boolean

        Try
            queueFile = DirectCast(mValidateQueue.Dequeue, DataFileState)
            LogEvent(String.Format("Begin Validation {0}", queueFile.DataFileId), EventLogEntryType.Information)

            loadFile = DataFile.Get(queueFile.DataFileId)

            'Change state
            With queueFile
                .StateId = DataFileStates.Validating
                .datOccurred = Now
                .Save()
            End With


            passValidation = loadFile.Validate()

            loadFile.CheckForDuplicateCCNInSampleMonth() ' HasDuplicateCCNInSampleMonth property defaults to false


            'Change state
            With queueFile
                If passValidation And Not loadFile.HasDuplicateCCNInSampleMonth Then
                    .StateId = DataFileStates.AwaitingApply
                ElseIf loadFile.HasDuplicateCCNInSampleMonth Then ' pass validation will be true if HasDuplicateCCNInSampleMonth is true
                    .StateId = DataFileStates.DuplicateCCNInSampleMonth
                Else
                    .StateId = DataFileStates.AwaitingFirstApproval
                End If
                .datOccurred = Now
                .Save()
            End With

            If loadFile.HasDuplicateCCNInSampleMonth Then

                'Here we reach across to QP_PROD and set Study.bitAutoSample = 0
                loadFile.DisableAutoSampling()
                ' Next, we unschedule the sampleset if it has not already been generated.
                loadFile.UnscheduleSampleSet()

            End If

            LogEvent(String.Format("End Validation {0}", queueFile.DataFileId), EventLogEntryType.Information)

        Catch ex As Exception
            'Mark the file as abandoned
            Dim filename As String = "N/A"
            If Not loadFile Is Nothing Then
                With queueFile
                    .StateId = DataFileStates.Abandoned
                    .StateParameter = String.Format("Validation Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace)
                    .datOccurred = Now
                    .Save()
                End With
                filename = String.Format("{0} ({1})", loadFile.FileName, loadFile.Id)
            End If
            LogEvent(SendNotification(String.Format("Validation Exception Datafile ({0})!", queueFile.DataFileId), filename, ex, False), EventLogEntryType.Error)
        Finally
            mValidationCount -= 1
        End Try

    End Sub

#End Region

#Region " Execute Apply "

    Private Sub ExecuteApply()

        Dim queueFile As DataFileState = Nothing
        Dim loadFile As DataFile = Nothing

        Try
            queueFile = DirectCast(mApplyQueue.Dequeue, DataFileState)
            loadFile = DataFile.Get(queueFile.DataFileId)

            LogEvent(String.Format("Begin Apply {0}", queueFile.DataFileId), EventLogEntryType.Information)

            'Change state
            With queueFile
                .StateId = DataFileStates.Applying
                .datOccurred = Now
                .Save()
            End With

            'Run the apply
            loadFile.Apply()

            'Change state
            With queueFile
                .StateId = DataFileStates.Applied
                .datOccurred = Now
                .Save()
            End With

            LogEvent(String.Format("End Apply {0}", queueFile.DataFileId), EventLogEntryType.Information)

        Catch ex As Exception
            'Mark the file as abandoned
            Dim filename As String = "N/A"
            If Not loadFile Is Nothing Then
                With queueFile
                    .StateId = DataFileStates.Abandoned
                    .StateParameter = String.Format("Apply Exception: {0}{1}{2}", ex.Message, vbCrLf, ex.StackTrace)
                    .datOccurred = Now
                    .Save()
                End With
                filename = String.Format("{0} ({1})", loadFile.FileName, loadFile.Id)
            End If
            LogEvent(SendNotification(String.Format("Apply Exception Datafile ({0})!", queueFile.DataFileId), filename, ex, False), EventLogEntryType.Error)
        Finally
            mApplyCount -= 1
        End Try

    End Sub

#End Region

#Region " Notification And Event Logging "
    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        'MessageBox.Show(eventData, My.Application.Info.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)
        ServiceTextBox.Text = String.Format("{0}{1}{2}", eventData, vbCrLf, ServiceTextBox.Text)

    End Sub

    Private Sub LogEvent(ByVal message As String, ByVal ex As Exception, ByVal entryType As EventLogEntryType)

        LogEvent(String.Format("{0}{1}{1}{2}{1}{1}Source: {3}{1}{1}Stack Trace:{1}{4}", message, vbCrLf, ex.Message, ex.Source, ex.StackTrace), entryType)

    End Sub

    Public Shared Function SendNotification(ByVal errMessage As String, ByVal fileName As String, ByVal errEx As Exception, ByVal logOnly As Boolean) As String

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environmentName As String = String.Empty
        Dim exceptionText As String = String.Empty
        Dim exceptionHtml As String = String.Empty
        Dim sqlCommand As String = String.Empty
        Dim stackHtml As String = String.Empty
        Dim stackText As String = String.Empty
        Dim innerStackHtml As String = String.Empty
        Dim innerStackText As String = String.Empty

        Try
            'Determine who the recipients are going to be
            toList.Add("MeasurementServicesDataTechnology@NRCPicker.com")
            ccList.Add("MDIQualisys@NRCPicker.com")

            'Determine recipients bases on the environment
            If AppConfig.EnvironmentType <> EnvironmentTypes.Production OrElse logOnly Then
                'We are not in production
                'Add the real recipients to the note
                recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
                For Each email As String In toList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
                For Each email As String In ccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production BCC:{0}", vbCrLf)
                For Each email As String In bccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR>")

                'Clear the lists
                toList.Clear()
                ccList.Clear()
                bccList.Clear()

                'Populate the toList with the Testing group only
                toList.Add("Testing@NRCPicker.com")

                'Set teh environment string
                environmentName = String.Format("({0})", AppConfig.EnvironmentName)
            End If

            'Build Exception Message
            exceptionText = errEx.Message
            exceptionHtml = errEx.Message.Replace(vbCrLf, "<BR>")

            'Build the SQL Command string
            If TypeOf errEx Is Nrc.Framework.Data.SqlCommandException Then
                sqlCommand = DirectCast(errEx, Nrc.Framework.Data.SqlCommandException).CommandText
            Else
                sqlCommand = "N/A"
            End If

            'Build the stack trace strings
            If errEx.StackTrace IsNot Nothing Then
                stackText = errEx.StackTrace

                stackHtml = errEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at")
                If (stackHtml.StartsWith("<BR>&nbsp;&nbsp;at")) Then
                    stackHtml = stackHtml.Substring("<BR>".Length)
                End If
            Else
                stackText = "N/A"
                stackHtml = "N/A"
            End If

            'Build the inner exception strings
            If errEx.InnerException IsNot Nothing Then
                Dim innerEx As Exception = errEx.InnerException
                Do While innerEx IsNot Nothing
                    'Text version

                    'HTML version
                    If innerStackText.Length > 0 Then
                        innerStackText &= vbCrLf
                        innerStackHtml &= "<BR>"
                    End If

                    If innerEx.Message IsNot Nothing OrElse innerEx.StackTrace IsNot Nothing Then
                        innerStackText &= "--------Inner Exception--------" & vbCrLf
                        innerStackHtml &= "--------Inner Exception--------" & "<BR>"

                        If innerEx.Message IsNot Nothing Then
                            innerStackText &= innerEx.Message & vbCrLf
                            innerStackHtml &= innerEx.Message.Replace(vbCrLf, "<BR>") & "<BR>"
                        End If

                        If innerEx.StackTrace IsNot Nothing Then
                            innerStackText &= innerEx.StackTrace & vbCrLf
                            innerStackHtml &= innerEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at") & "<BR>"
                        End If
                    End If

                    'Prepare for next pass
                    innerEx = innerEx.InnerException
                Loop
            Else
                innerStackText = "N/A"
                innerStackHtml = "--------Inner Exception--------<BR>N/A<BR>-------------------------------"
            End If

            'Create the message object
            Dim msg As Message = New Message("PervasiveServiceException", AppConfig.SMTPServer)

            'Set the message properties
            With msg
                'To recipient
                For Each email As String In toList
                    .To.Add(email)
                Next

                'Cc recipient
                For Each email As String In ccList
                    .Cc.Add(email)
                Next

                'Bcc recipient
                For Each email As String In bccList
                    .Bcc.Add(email)
                Next

                'Add the replacement values
                With .ReplacementValues
                    .Add("Environment", environmentName)
                    .Add("Message", errMessage)
                    .Add("DateOccurred", DateTime.Now.ToString)
                    .Add("MachineName", Environment.MachineName)
                    .Add("FileName", fileName)
                    .Add("ExceptionText", exceptionText)
                    .Add("ExceptionHtml", exceptionHtml)
                    .Add("Source", errEx.Source)
                    .Add("SQLCommand", sqlCommand)
                    .Add("StackTraceHtml", stackHtml)
                    .Add("StackTraceText", stackText)
                    .Add("InnerExceptionHtml", innerStackHtml & recipientNoteHtml)
                    .Add("InnerExceptionText", innerStackText & recipientNoteText)
                End With
            End With

            'Merge the template
            msg.MergeTemplate()

            'Get the body text
            Dim bodyText As String = msg.BodyText

            'Send the message
            If Not logOnly Then msg.Send()

            'Return the body text
            Return bodyText

        Catch ex As Exception
            'Return this exception
            Return String.Format("Exception encountered while attempting to send Exception Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}{0}{0}Original Exception{0}{0}{4}{0}{0}Source: {5}{0}{0}Stack Trace:{0}{6}", vbCrLf, ex.Message, ex.Source, ex.StackTrace, errEx.Message, errEx.Source, errEx.StackTrace)

        End Try

    End Function

#End Region

End Class

#Region " Config Class "
Friend Class Config

    Public Shared ReadOnly Property MaxConcurrentValidations() As Integer
        Get
            If Not AppConfig.Params("RunValidationReports").StringValue.Equals("true", StringComparison.CurrentCultureIgnoreCase) Then
                Return 0
            Else
                Return AppConfig.Params("MaxConcurrentValidations").IntegerValue
            End If
        End Get
    End Property

    Public Shared ReadOnly Property MaxConcurrentApplies() As Integer
        Get
            If Not AppConfig.Params("RunApplies").StringValue.Equals("true", StringComparison.CurrentCultureIgnoreCase) Then
                Return 0
            Else
                Return AppConfig.Params("MaxConcurrentApplies").IntegerValue
            End If
        End Get
    End Property
End Class
#End Region


