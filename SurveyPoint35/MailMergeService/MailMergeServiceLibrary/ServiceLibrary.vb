Imports System.Threading
Imports System.Net.Mail
Imports Microsoft.Win32
Imports MailMergeQueue.Library
Imports System.Diagnostics
Imports PS.Notification.Library
Imports System.Text
Imports Aspose.Words

Public Class ServiceLibrary
#Region " Enums "
    Private Enum ServiceState
        None = 0
        Started = 1
        Stopped = 2
        Paused = 3
    End Enum
    Public Enum LogMessageSeverity
        None = 0
        StatusInfo = 1
        Warning = 2
        [Error] = 3
        DebugInfo = 4
    End Enum
#End Region
#Region " Event LogArgs "
    Public Class EventLogArgs
        Inherits EventArgs

        Private mMessage As String
        Private mSeverity As LogMessageSeverity

        Public ReadOnly Property Message() As String
            Get
                Return mMessage
            End Get
        End Property

        Public ReadOnly Property Severity() As LogMessageSeverity
            Get
                Return mSeverity
            End Get
        End Property

        Public Sub New(ByVal message As String, ByVal severity As LogMessageSeverity)
            mMessage = message
            mSeverity = severity
        End Sub
    End Class
    Public Event LogMessage As EventHandler(Of EventLogArgs)
    Friend Overridable Sub RaiseMessageLog(ByVal e As EventLogArgs)
        RaiseEvent LogMessage(Me, e)
    End Sub
#End Region
#Region " Private Fields "
    Private mState As ServiceState = ServiceState.Stopped
    Private mWorkerThread As Thread
    Private mIsWorking As Boolean
    Private mTimer As System.Timers.Timer
    Private mMMQueueController As MailMergeQueueController = Nothing
    Private mLicenseSet As Boolean = False
#End Region
    Private Sub SetLicense()
        Dim license As Aspose.Words.License = New Aspose.Words.License
        license.SetLicense("Aspose.Words.lic")
        mLicenseSet = True
    End Sub
    
    ''' <summary>
    ''' Event loop that call the thread to do the acutal processing for the service.    
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub TimerLoop(ByVal sender As System.Object, ByVal e As System.Timers.ElapsedEventArgs)
        Try
            'Check that LAN exists and that you can hit the DB prior to starting process.
            'IF not, wait 2 minutes and try again.  Else, continue as normal.  
            If Not mLicenseSet Then
                SetLicense()
            End If
            mTimer.Enabled = False
            If MailMergeQueueController.PingMailMergeDB AndAlso System.IO.Directory.Exists(MailMergeQueue.Library.Config.MergePath) Then
                'Make sure no word apps are hung in memory.
                KillWordApps()
                mTimer.Interval = 2000
                mTimer.Enabled = False
                mWorkerThread = New Thread(AddressOf ProcessQueue)
                mWorkerThread.Start()
            Else
                'DB or LAN is down wait an extended prior of time and try again.
                mTimer.Interval = 300000
                Me.RaiseMessageLog(New EventLogArgs("Mail Merge service can not access LAN and/or DB.  Will try again in 5 minutes.", LogMessageSeverity.Warning))
                mIsWorking = False
                mTimer.Enabled = True
            End If
        Catch ex As Exception
            'Report the error and get a little more time (hopefully) recoverable.
            Me.RaiseMessageLog(New EventLogArgs("Mail Merge service error: " & ex.Message, LogMessageSeverity.Warning))
            mTimer.Interval = 20000
            mTimer.Enabled = True
            mIsWorking = False
        End Try
    End Sub
    Private Sub KillWordApps()
        Dim myProcess() As Process = Nothing
        myProcess = Process.GetProcessesByName("WINWORD")
        If myProcess IsNot Nothing AndAlso myProcess.Length > 0 Then
            For Each proc As Process In myProcess
                proc.Kill()
            Next
        End If
    End Sub
    Private Sub TestThreading()
        Try
            mIsWorking = True
            For i As Integer = 1 To 60
                Threading.Thread.Sleep(2000)
                Me.RaiseMessageLog(New EventLogArgs("Process of TimerEvent: " & CStr(i), LogMessageSeverity.StatusInfo))
            Next
        Catch ex As Exception
            Me.RaiseMessageLog(New EventLogArgs(ex.Message, LogMessageSeverity.Error))
            mTimer.Enabled = False 'If an error reaches here, you don't want to continue until someone looks at the service.
        Finally
            mIsWorking = False

            Me.RaiseMessageLog(New EventLogArgs("Timer Reenabled.", LogMessageSeverity.StatusInfo))
        End Try
    End Sub
    Private Sub ProcessQueue()
        Try
            mIsWorking = True
            mMMQueueController = MailMergeQueueController.GetTop1PendingFromQueue()
            If mMMQueueController IsNot Nothing Then
                mMMQueueController.CopyLocal()
                If mMMQueueController.ValidationMessages.ErrorsExist Then
                    mMMQueueController.CompleteMergeJob(MergeStatuses.Errored)
                    TryErrorNotify(mMMQueueController.ValidationMessages.GetErrorString() & "|" & CommonMethods.Get1stStackTrace(mMMQueueController.ValidationMessages))
                Else
                    mMMQueueController.Validate()
                    If Not mMMQueueController.ValidationMessages.ErrorsExist AndAlso mMMQueueController.Validated Then
                        mMMQueueController.Merge()
                        If mMMQueueController.ValidationMessages.ErrorsExist Then
                            mMMQueueController.CompleteMergeJob(MergeStatuses.Errored)
                            TryErrorNotify(mMMQueueController.ValidationMessages.GetErrorString() & "|" & CommonMethods.Get1stStackTrace(mMMQueueController.ValidationMessages))
                        Else
                            mMMQueueController.CopyNetwork()
                            If mMMQueueController.ValidationMessages.ErrorsExist Then
                                mMMQueueController.CompleteMergeJob(MergeStatuses.Errored)
                                TryErrorNotify(mMMQueueController.ValidationMessages.GetErrorString() & "|" & CommonMethods.Get1stStackTrace(mMMQueueController.ValidationMessages))
                            Else
                                mMMQueueController.CompleteMergeJob(MergeStatuses.Completed)
                                If mMMQueueController.ValidationMessages.ErrorsExist Then
                                    TryErrorNotify(mMMQueueController.ValidationMessages.GetErrorString() & "|" & CommonMethods.Get1stStackTrace(mMMQueueController.ValidationMessages))
                                End If
                            End If
                        End If
                    Else
                        mMMQueueController.CompleteMergeJob(MergeStatuses.Errored)
                        TryErrorNotify("Handled Error: " & mMMQueueController.ValidationMessages.GetErrorString() & "|" & CommonMethods.Get1stStackTrace(mMMQueueController.ValidationMessages))
                    End If
                End If
            End If
        Catch ex As Exception
            Try
                mMMQueueController.CompleteMergeJob(MergeStatuses.Errored)
            Catch ex1 As Exception
                'Do nothing if this doesn't work, it will log in the email notify.
            End Try
            TryErrorNotify(Left(ex.Message & "-" & ex.StackTrace, 7500))
            Me.RaiseMessageLog(New EventLogArgs("Process Queue Error:" & ex.Message & "-" & ex.StackTrace, LogMessageSeverity.Error))
        Finally
            mMMQueueController = Nothing
            mTimer.Enabled = True
            mIsWorking = False
            GC.Collect()
        End Try
    End Sub
    Private Sub TryErrorNotify(ByVal message As String)
        Try
            Dim em As Email = PS.Notification.Library.Email.NewEmail("Service", True)
            Dim pippedEmails As String = Config.EmailTo
            Dim strArray() As String = pippedEmails.Split("|"c)
            For Each item As String In strArray
                em.AddTo(item)
            Next
            em.FromEmailAddress = Config.EmailFrom
            em.Subject = "Survey Merge Service Error."
            em.EmailType = EmailType.HTML
            Dim sb As New StringBuilder
            sb.Append("<h1>Survey Merge encountered the following error(s)</h1>")
            If InStr(message, vbCrLf) > 0 Then
                message = Replace(message, vbCrLf, Chr(223))
                Dim msgArray As String() = message.Split(Chr(223))
                For Each item As String In msgArray
                    sb.Append("<p>" & item & "</p>")
                Next
            Else
                sb.Append("<p>" & message & "</p>")
            End If
            em.Body = sb.ToString()
            em.ValidateAndSendToQueue()
            If em.ObjectValidations.ErrorsExist Then
                Throw New System.Exception(em.ObjectValidations.GetErrorString)
            End If
        Catch ex As Exception
            Me.RaiseMessageLog(New EventLogArgs("Can't raise notification:" & ex.Message, LogMessageSeverity.Error))
        End Try
    End Sub
#Region " Service Controller Methods "
    Public Sub [Stop]()
        If mState <> ServiceState.Stopped Then
            Me.RaiseMessageLog(New EventLogArgs("Attempting Service Stop", LogMessageSeverity.StatusInfo))
            mState = ServiceState.Stopped
            mTimer.Enabled = False
            If mWorkerThread IsNot Nothing AndAlso mWorkerThread.IsAlive Then
                If mIsWorking Then
                    mWorkerThread.Join()
                Else
                    mWorkerThread.Abort()
                End If
            End If
            mMMQueueController = Nothing
            Me.RaiseMessageLog(New EventLogArgs("Service Stopped", LogMessageSeverity.StatusInfo))
        End If
        mTimer.Enabled = False
        Me.RaiseMessageLog(New EventLogArgs("Service Stopped", LogMessageSeverity.StatusInfo))
    End Sub
    Public Sub [Resume]()
        If mState = ServiceState.Paused Then
            mState = ServiceState.Started
            mTimer.Enabled = True
            Me.RaiseMessageLog(New EventLogArgs("Service Resumed.", LogMessageSeverity.StatusInfo))
        End If
    End Sub
    Public Sub [Pause]()
        If mState = ServiceState.Started Then
            mState = ServiceState.Paused
            mTimer.Enabled = False
            Me.RaiseMessageLog(New EventLogArgs("Service Paused.", LogMessageSeverity.StatusInfo))
        End If
    End Sub
    Public Sub [Start]()
        'If mState = ServiceState.Stopped Then
        mTimer = New System.Timers.Timer(2000)
        'End If
        mState = ServiceState.Started
        AddHandler mTimer.Elapsed, AddressOf TimerLoop
        mTimer.Enabled = True
        mTimer.Start()
        Me.RaiseMessageLog(New EventLogArgs("Service Paused.", LogMessageSeverity.StatusInfo))
        ' If the timer is declared in a long-running method, use
        ' KeepAlive to prevent garbage collection from occurring
        ' before the method ends.
        GC.KeepAlive(mTimer)
    End Sub
#End Region
End Class
