Imports System.Threading
Imports System.Net.Mail
Imports Microsoft.Win32
Imports PS.ResponseImport.Library

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
    Private mRespImportController As RespondentImportController = Nothing
    Private mIsNetworkDown As Boolean = False
    Private mIsSqlDown As Boolean = False
    Private mRecoveredText As String = "The ResponseImport service has successfully recovered from the {0}."
#End Region
    Private Sub TimerLoop(ByVal sender As System.Object, ByVal e As System.Timers.ElapsedEventArgs)
        Try
            'TODO:  Make sure this is thread safe for stop, start, pause....events.
            mTimer.Enabled = False            
            mWorkerThread = New Thread(AddressOf ProcessImports)
            mWorkerThread.Start()            
        Catch ex As Exception
            Stop        
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
    Private Sub ProcessImports()
        Try
            mIsWorking = True
            If mRespImportController Is Nothing Then
                mRespImportController = New RespondentImportController()
            End If
            mRespImportController.ProcessRespondentFiles()                        
            mTimer.Enabled = True
            If (mIsNetworkDown AndAlso mIsSqlDown) Then
                RespondentImportController.ErrorNotify(String.Format(mRecoveredText, "IOException and SqlException"))
                mIsNetworkDown = False
                mIsSqlDown = False
            ElseIf (mIsNetworkDown) Then
                RespondentImportController.ErrorNotify(String.Format(mRecoveredText, "IOException"))
                mIsNetworkDown = False
            ElseIf (mIsSqlDown) Then
                RespondentImportController.ErrorNotify(String.Format(mRecoveredText, "SqlException"))
                mIsSqlDown = False
            End If
        Catch iox As IO.IOException 'Reoccuring IOException due to loss of connection to the file location
            mTimer.Enabled = True
            If (Not mIsNetworkDown) Then
                RespondentImportController.ErrorNotify(iox)
            End If
            mIsNetworkDown = True
            Me.RaiseMessageLog(New EventLogArgs("Service has encountered IOException:" & iox.Message & " | " & iox.StackTrace, LogMessageSeverity.Error))
        Catch sqlx As SqlClient.SqlException 'Reoccuring SqlException due to loss of connection to the database
            mTimer.Enabled = True
            If (Not mIsSqlDown) Then
                RespondentImportController.ErrorNotify(sqlx)
            End If
            mIsSqlDown = True
            Me.RaiseMessageLog(New EventLogArgs("Service has encountered SqlException:" & sqlx.Message & " | " & sqlx.StackTrace, LogMessageSeverity.Error))
        Catch ex As Exception
            mTimer.Enabled = False 'If an error reaches here, you don't want to continue until someone looks at the service. 
            RespondentImportController.ErrorNotify(ex)
            Me.RaiseMessageLog(New EventLogArgs("Service has stopped:" & ex.Message & " | " & ex.StackTrace, LogMessageSeverity.Error))
        Finally
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
            mRespImportController = Nothing
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
