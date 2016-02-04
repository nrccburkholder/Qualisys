Imports System.Threading
Imports System.Net.Mail
Imports Microsoft.Win32
Imports PS.Notification.Library
Imports PS.Framework.BusinessLogic.Validation
Imports System.Diagnostics
Imports System.IO

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
    Private mEmails As Emails = Nothing
#End Region
    Private Sub TimerLoop(ByVal sender As System.Object, ByVal e As System.Timers.ElapsedEventArgs)
        Try
            'Check that LAN exists and that you can hit the DB prior to starting process.
            'IF not, wait 2 minutes and try again.  Else, continue as normal.  
            mTimer.Enabled = False
            If Email.PingEmailDB AndAlso Directory.Exists(Config.EmailLANPath) Then
                mTimer.Interval = 10000
                mTimer.Enabled = False
                mWorkerThread = New Thread(AddressOf ProcessQueue)
                mWorkerThread.Start()
            Else
                'DB or LAN is down wait an extended prior of time and try again.
                mTimer.Interval = 300000
                Me.RaiseMessageLog(New EventLogArgs("PS Email service can not access LAN and/or DB.  Will try again in 5 minutes.", LogMessageSeverity.Warning))
                mIsWorking = False
                mTimer.Enabled = True
            End If
        Catch ex As Exception
            'Report the error and get a little more time (hopefully) recoverable.
            Me.RaiseMessageLog(New EventLogArgs("PS Email service error: " & ex.Message, LogMessageSeverity.Warning))
            mTimer.Interval = 200000
            mTimer.Enabled = True
            mIsWorking = False
        End Try
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
            mEmails = Email.GetTop50EmailsToSend()
            If mEmails IsNot Nothing Then
                For Each em As Email In Me.mEmails
                    em.SendEmail()
                    If em.ObjectValidations.ErrorsExist Then
                        Me.RaiseMessageLog(New EventLogArgs(em.ObjectValidations.Get8KString, LogMessageSeverity.Error))
                    End If
                Next                
            End If
        Catch ex As Exception            
            Me.RaiseMessageLog(New EventLogArgs("Process Queue Error:" & ex.Message, LogMessageSeverity.Error))
        Finally
            mEmails = Nothing
            mTimer.Enabled = True
            mIsWorking = False            
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
            mEmails = Nothing
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
