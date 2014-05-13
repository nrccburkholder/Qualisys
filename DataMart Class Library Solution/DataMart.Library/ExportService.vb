Imports System.Threading
Imports System.Net.Mail
Imports Microsoft.Win32

Public Class ExportService

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

#Region " Private Fields "
    Private mIntervalMilliseconds As Integer
    Private mOutputFolderPath As String
    Private mErrorsFolderPath As String
    Private mState As ServiceState = ServiceState.Stopped
    Private mWorkerThread As Thread
    Private mIsWorking As Boolean
    Private mFileExpirationDays As Integer = 14
    Private mErroredFileExpirationDays As Integer = 14
    'Private mLastFolderCleanUp As Date = Date.MinValue
    'Private mLastSummaryMessage As Date = Date.MinValue
#End Region

#Region " Private Properties "
    Private Function OpenAppRegistryKey() As RegistryKey
        Dim key As Microsoft.Win32.RegistryKey
        key = My.Computer.Registry.LocalMachine.OpenSubKey("Software\National Research\DataMart Export Service", True)
        If key Is Nothing Then
            key = My.Computer.Registry.LocalMachine.CreateSubKey("Software\National Research\DataMart Export Service")
        End If

        Return key
    End Function
    Private Property LastFolderCleanUp() As Date
        Get
            Using key As RegistryKey = OpenAppRegistryKey()
                Dim lastCleanUpValue As Object
                lastCleanUpValue = key.GetValue("Last Folder Cleanup")
                If lastCleanUpValue Is Nothing Then
                    key.SetValue("Last Folder Cleanup", Date.MinValue.ToShortDateString, Microsoft.Win32.RegistryValueKind.String)
                    lastCleanUpValue = Date.MinValue.ToShortDateString
                End If

                Dim lastCleanUpDate As Date
                If Date.TryParse(lastCleanUpValue.ToString, lastCleanUpDate) Then
                    Return lastCleanUpDate
                Else
                    Return Date.MinValue
                End If
            End Using
        End Get
        Set(ByVal value As Date)
            Using key As RegistryKey = OpenAppRegistryKey()
                key.SetValue("Last Folder Cleanup", value.ToShortDateString, RegistryValueKind.String)
            End Using
        End Set
    End Property
    Private Property LastErroredFolderCleanUp() As Date
        Get
            Using key As RegistryKey = OpenAppRegistryKey()
                Dim lastCleanUpValue As Object
                lastCleanUpValue = key.GetValue("Last Errored Folder Cleanup")
                If lastCleanUpValue Is Nothing Then
                    key.SetValue("Last Errored Folder Cleanup", Date.MinValue.ToShortDateString, Microsoft.Win32.RegistryValueKind.String)
                    lastCleanUpValue = Date.MinValue.ToShortDateString
                End If

                Dim lastCleanUpDate As Date
                If Date.TryParse(lastCleanUpValue.ToString, lastCleanUpDate) Then
                    Return lastCleanUpDate
                Else
                    Return Date.MinValue
                End If
            End Using
        End Get
        Set(ByVal value As Date)
            Using key As RegistryKey = OpenAppRegistryKey()
                key.SetValue("Last Errored Folder Cleanup", value.ToShortDateString, RegistryValueKind.String)
            End Using
        End Set
    End Property

    Private Property LastSummaryMessage() As Date
        Get
            Using key As RegistryKey = OpenAppRegistryKey()
                Dim lastMessageValue As Object
                lastMessageValue = key.GetValue("Last Summary Message")
                If lastMessageValue Is Nothing Then
                    key.SetValue("Last Summary Message", Date.MinValue.ToShortDateString, Microsoft.Win32.RegistryValueKind.String)
                    lastMessageValue = Date.MinValue.ToShortDateString
                End If

                Dim lastMessageDate As Date
                If Date.TryParse(lastMessageValue.ToString, lastMessageDate) Then
                    Return lastMessageDate
                Else
                    Return Date.MinValue
                End If
            End Using
        End Get
        Set(ByVal value As Date)
            Using key As RegistryKey = OpenAppRegistryKey()
                key.SetValue("Last Summary Message", value.ToShortDateString, RegistryValueKind.String)
            End Using
        End Set
    End Property
#End Region

#Region " Log Message Event "
    Public Class LogMessageEventArgs
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
    Public Event LogMessage As EventHandler(Of LogMessageEventArgs)
    Protected Overridable Sub OnLogMessage(ByVal e As LogMessageEventArgs)
        RaiseEvent LogMessage(Me, e)
    End Sub
#End Region

#Region " Constructors "
    Public Sub New(ByVal timerIntervalSeconds As Integer, ByVal outputFolderPath As String, ByVal ErrorsFolderPath As String, ByVal fileExpirationDays As Integer, ByVal ErroredFileExpirationDays As Integer)
        mIntervalMilliseconds = timerIntervalSeconds * 1000
        mOutputFolderPath = outputFolderPath
        mErrorsFolderPath = ErrorsFolderPath
        mFileExpirationDays = fileExpirationDays
        mErroredFileExpirationDays = ErroredFileExpirationDays
    End Sub
#End Region

#Region " Public Methods "
    Public Sub Start()
        If Not System.IO.Directory.Exists(mOutputFolderPath) Then
            Throw New IO.DirectoryNotFoundException("Output folder '" & mOutputFolderPath & "' does not exist.")
        End If

        If Not System.IO.Directory.Exists(mErrorsFolderPath) Then
            Throw New IO.DirectoryNotFoundException("Errors folder '" & mErrorsFolderPath & "' does not exist.")
        End If

        If Not Me.FileCreateAllowed(Me.mOutputFolderPath) Then
            Throw New UnauthorizedAccessException("Could not write to the folder '" & mOutputFolderPath & "'.")
        End If

        If Not Me.FileCreateAllowed(Me.mErrorsFolderPath) Then
            Throw New UnauthorizedAccessException("Could not write to the folder '" & mErrorsFolderPath & "'.")
        End If

        mState = ServiceState.Started
        LogEventMessage("Service Started")

        mWorkerThread = New Thread(AddressOf RunServiceLoop)
        mWorkerThread.Start()
    End Sub

    Public Sub [Stop]()
        If mState <> ServiceState.Stopped Then
            LogEventMessage("Stopping Service")
            mState = ServiceState.Stopped

            If mIsWorking Then
                mWorkerThread.Join()
            Else
                mWorkerThread.Abort()
            End If

            LogEventMessage("Service Stopped")
        End If
    End Sub

    Public Sub Pause()
        If mState = ServiceState.Started Then
            mState = ServiceState.Paused
            LogEventMessage("Service Paused")
        End If
    End Sub

    Public Sub [Resume]()
        If mState = ServiceState.Paused Then
            mState = ServiceState.Started
            LogEventMessage("Service Resumed")
        End If
    End Sub

    Public Sub CleanUpOutputFolder()
        Dim dir As New IO.DirectoryInfo(Me.mOutputFolderPath)
        Me.CleanUpFolder(dir, False, mFileExpirationDays)
    End Sub

    Public Sub CleanUpErrorsFolder()
        Dim dir As New IO.DirectoryInfo(Me.mErrorsFolderPath)
        Me.CleanUpFolder(dir, False, mErroredFileExpirationDays)
    End Sub

#End Region

#Region " Private Methods "

    Private Function FileCreateAllowed(ByVal path As String) As Boolean
        Try
            path = System.IO.Path.Combine(path, "accesscheck.txt")
            Using fs As New System.IO.FileStream(path, IO.FileMode.Create)
                fs.WriteByte(0)
            End Using
            System.IO.File.Delete(path)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function
    Private Sub LogEventMessage(ByVal msg As String)
        LogEventMessage(msg, LogMessageSeverity.StatusInfo)
    End Sub

    Private Sub LogEventMessage(ByVal msg As String, ByVal severity As LogMessageSeverity)
        OnLogMessage(New LogMessageEventArgs(msg, severity))
    End Sub

    Private Sub RunServiceLoop()
        While mState <> ServiceState.Stopped

            If mState = ServiceState.Started Then
                Try
                    Me.PerformCleanUpIfNeeded()
                    Me.PerformErrorFolderCleanUpIfNeeded()
                    Me.SendSummaryIfNeeded()
                    Me.PerformExports()
                Catch ex As Exception
                    LogEventMessage(ex.ToString, LogMessageSeverity.Error)
                End Try
            End If

            If mState = ServiceState.Started Then
                LogEventMessage("Waiting for work...")
                Thread.Sleep(Me.mIntervalMilliseconds)
            End If
        End While
    End Sub

    Private Sub PerformExports()
        Dim export As ScheduledExport

        export = GetNextScheduledExport()
        While export IsNot Nothing
            mIsWorking = True
            LogEventMessage("Creating Export " & export.Id & "...")

            Try
                Dim srvy As Survey = Survey.GetSurvey(export.ExportSets(0).SurveyId)
                Dim clientId As Integer = srvy.Study.ClientId
                Dim clientName As String = srvy.Study.Client.DisplayLabel

                'Check to see if there is more than 1 client represented
                For Each exportSet As ExportSet In export.ExportSets
                    srvy = Survey.GetSurvey(exportSet.SurveyId)
                    If clientId <> srvy.Study.ClientId Then
                        clientName = "Multiple Clients"
                        Exit For
                    End If
                Next

                Dim clientFolderPath As String = IO.Path.Combine(mOutputFolderPath, clientName)
                If Not IO.Directory.Exists(clientFolderPath) Then
                    IO.Directory.CreateDirectory(clientFolderPath)
                End If

                export.CreateFile(clientFolderPath)
            Catch
                'Swallow up the exception...
            Finally
                ScheduledExport.Delete(export.Id)
            End Try

            'Thread.Sleep(5000)
            LogEventMessage("Export Completed")

            'Now we need to check again to see if we should send a summary
            'This is to avoid the export loop from taking a ton of time without us
            'ever getting around to sending the notification...
            Me.SendSummaryIfNeeded()

            'Done working
            mIsWorking = False

            If mState = ServiceState.Started Then
                export = GetNextScheduledExport()
            Else
                export = Nothing
            End If
        End While
    End Sub

    Private Function GetNextScheduledExport() As ScheduledExport
        LogEventMessage("Checking for work...")

        'Get the next scheduled export
        Dim export As ScheduledExport = ScheduledExport.GetNextScheduledExport

        Return export
    End Function

    Private Sub PerformCleanUpIfNeeded()
        If Date.Today.Subtract(LastFolderCleanUp).Days >= 1 Then
            Me.LogEventMessage("Performing clean up...")
            Me.CleanUpOutputFolder()
            LastFolderCleanUp = Date.Today
        End If
    End Sub

    Private Sub PerformErrorFolderCleanUpIfNeeded()
        If Date.Today.Subtract(LastErroredFolderCleanUp).Days >= 1 Then
            Me.LogEventMessage("Performing Errored Files clean up...")
            Me.CleanUpErrorsFolder()
            LastErroredFolderCleanUp = Date.Today
        End If
    End Sub

    Private Sub SendSummaryIfNeeded()
        If Date.Now.Hour >= 8 Then
            If Date.Today.Subtract(LastSummaryMessage).Days >= 1 Then
                Me.LogEventMessage("Sending summary message...")
                Me.SendSummaryMessage()
                LastSummaryMessage = Date.Today
            End If
        End If
    End Sub

    Private Sub CleanUpFolder(ByVal dir As IO.DirectoryInfo, ByVal deleteIfEmpty As Boolean, ByVal daystoExpiration As Integer)
        For Each subDir As IO.DirectoryInfo In dir.GetDirectories
            CleanUpFolder(subDir, True, daystoExpiration)
        Next

        For Each file As IO.FileInfo In dir.GetFiles
            If Date.Today.Subtract(file.CreationTime.Date).Days >= daystoExpiration Then
                file.Delete()
            End If
        Next

        If deleteIfEmpty AndAlso dir.GetDirectories.Length = 0 AndAlso dir.GetFiles.Length = 0 Then
            dir.Delete()
        End If
    End Sub

    Private Sub SendSummaryMessage()
        Dim smtpServer As New SmtpClient(Config.SmtpServer)
        Dim toAddress As String = Config.ExportNotifcationEmailAddress
        Dim addressList As New List(Of MailAddress)
        For Each addr As String In toAddress.Split(New String() {";", ","}, StringSplitOptions.RemoveEmptyEntries)
            addressList.Add(New MailAddress(addr))
        Next

        ExportFile.GenerateExportNotificationEmail(addressList.ToArray, smtpServer)
    End Sub
#End Region



End Class


