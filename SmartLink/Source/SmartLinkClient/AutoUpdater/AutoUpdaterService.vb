Imports System.IO
Imports System.Text

Imports NRC.SmartLink.Common
Imports NRC.Miscellaneous.TaskScheduler

Public Class AutoUpdaterService

    Private _autoUpdateLastCheckedDtm As Nullable(Of DateTime) = Nothing
    Private _autoDownloadAndInstallUpdates As Boolean = False
    Private _autoUpdateInterval As String
    Private _autoUpdateIntervalModifier As Nullable(Of Integer) = Nothing
    Private _autoUpdateTime As String
    Private _autoUpdateWeeklyDays As String

    Private _providerNumber As String
    Private _vendorName As String

    Private _scheduler As Scheduler


    Protected Overrides Sub OnStart(ByVal args() As String)
        Log.LogTrace(Settings.ConvertToBool(Settings.GetGeneralSetting("TraceFlag", "False")))
        Settings.CurrentServiceName = Settings.AUTOUPDATE_SVC_NAME

#If DEBUG Then
        'System.Diagnostics.Debugger.Break()
#End If

        Try
            PrepareAutoUpdateEnvironmentAndScheduler()
        Catch ex As Exception
            _autoDownloadAndInstallUpdates = False
            Log.WriteError("The following exception was thrown while attempting to access auto-update config info - " + ex.Message, ex)
        End Try
    End Sub

    Protected Overrides Sub OnStop()
        _autoUpdateLastCheckedDtm = Nothing
        _autoDownloadAndInstallUpdates = False

        If _scheduler IsNot Nothing Then
            ' Make sure we un-wire any event handlers so resources can be
            ' released and processed by the GC
            RemoveHandler _scheduler.RunTask, AddressOf ProcessAutoUpdateEvent

            _scheduler.Dispose()
            _scheduler = Nothing
        End If
    End Sub

    ''' <summary>
    ''' Processes auto update check, download, and install requests.
    ''' Generally called by a scheduler instance or a TimerElapsed event.
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub ProcessAutoUpdateEvent()
        If Not _autoDownloadAndInstallUpdates Then
            Log.WriteInfo("The auto updater is not configured to automatically download and install updates. Shutting down service.")
            Me.Stop()
            Exit Sub
        End If

        Dim msiInstallerFilePath As String = String.Empty

        Try
            Dim webService As WebService = New WebService()
            Dim clientId As String = Settings.GetGeneralSetting("ProviderNumber")
            Dim currentVersion As String = Settings.GetGeneralSetting("InstalledSmartLinkVersion")

            Log.WriteTrace("Starting to check for update (current version is " + currentVersion + ") ...")

            Dim newVersion As String = Nothing
            Dim url As String = Nothing
            Dim fileName As String = Nothing
            Dim checksum As String = Nothing
            Dim isUpdateAvailable As Boolean =
                webService.CheckForNewVersion(clientId, currentVersion, newVersion, url, fileName, checksum)

            If Not isUpdateAvailable Then
                Log.WriteTrace("No new version found, done.")
                Return
            End If

            DownloadInstallUpdate(newVersion, url, fileName, checksum, True)
        Catch ex As Exception
            Log.WriteError("An exception was thrown while checking for or downloading SmartLink updates: " + ex.Message)
        End Try

        Me.Stop()
    End Sub

    ' Throws an exception if there's an issue; you can catch the exception and display the message
    Public Shared Sub DownloadInstallUpdate(ByVal newVersion As String, ByVal url As String, ByVal fileName As String, ByVal expectedChecksum As String,
                                            ByVal quiet As Boolean)
        Dim updateDir As String = Path.Combine(Settings.ApplicationUpdatesRootDirPath, "SL" & newVersion)

        If Not Directory.Exists(updateDir) Then
            Directory.CreateDirectory(updateDir)
        End If

        Dim saveFileName As String = Path.Combine(updateDir, fileName)

        Dim alreadyDownloaded As Boolean = False

        If File.Exists(saveFileName) Then
            Dim localChecksum = Utils.CheckFileHash(saveFileName)

            If localChecksum <> expectedChecksum Then
                Log.WriteInfo("Update was already downloaded, but checksum didn't match (got " + localChecksum +
                                    ", expected " + expectedChecksum + "); deleting local copy and re-downloading")
                File.Delete(saveFileName)
            Else
                Log.WriteInfo("Update was already downloaded, proceeding")
                alreadyDownloaded = True
            End If
        End If

        If Not alreadyDownloaded Then
            Dim webClient As New System.Net.WebClient()

            Log.WriteInfo("Downloading update from server: url=" + url)
            Try
                webClient.DownloadFile(url, saveFileName)

                Dim localChecksum = Utils.CheckFileHash(saveFileName)
                If localChecksum <> expectedChecksum Then
                    ' throw, which gets caught immediately, just to put the error handling in one place
                    Throw New Exception("Checksum didn't match in downloaded file (got " + localChecksum +
                                        ", expected " + expectedChecksum + ")")
                End If
            Catch ex As System.Exception
                Log.WriteError("Error downloading file: " + ex.Message)
                Throw
            End Try
        End If

        ' We need to explicitly kill the NRC Service Manager Windows Forms application because 
        ' it may be launched by an end-user and running at the time we want to uprade it.
        Dim procs As Process() = Process.GetProcessesByName(Settings.GetGeneralSetting("ProcessName", Nothing))

        If procs IsNot Nothing AndAlso procs.Count() > 0 Then
            Log.WriteInfo("Killing all running instances of the NRC Service Manager windows forms application.")
            Dim p As Process
            For Each p In procs
                p.Kill()
            Next
        End If

        If quiet Then
            InstallMSI(saveFileName, My.Application.Info.DirectoryPath)
        Else
            InstallMSI(saveFileName, Nothing)
        End If
    End Sub

    Private Shared Sub InstallMSI(ByVal msiFilePath As String, ByVal targetDir As String)
        Dim systemFolderPath As String = String.Empty

        Try
            systemFolderPath = Environment.GetFolderPath(Environment.SpecialFolder.System)
            If String.IsNullOrEmpty(systemFolderPath) Then
                ' Gets caught immediately, but convenient for centralizing error handling
                Throw New DirectoryNotFoundException("Unable to resolve the system folder path.")
            End If
        Catch ex As Exception
            Log.WriteError("An exception occurred while attempting to resolve the location of " &
                "the system folder.  Unable to continue with automatic upgrade of the SmartLink application.")
        End Try

        ' Construct a path to an installer log file for troubleshooting and such.
        ' This file will be placed in the same folder as the msi installer exe.
        Dim installerLogFilePath As String = Path.Combine(Path.GetDirectoryName(msiFilePath), "installer.log")

        If File.Exists(installerLogFilePath) Then
            File.Delete(installerLogFilePath)
        End If

        Dim msiProc As New System.Diagnostics.Process()
        msiProc.StartInfo = New ProcessStartInfo()

        'If we are using an MSI installer package that doesn't properly 
        'uninstall the old application before installing the new version 
        'then we need to consider using msiexec.exe explicitly with the 
        'following(Arguments)

        ' Command line info on arguments and switches can be found 
        ' http://msdn.microsoft.com/en-us/library/aa367988(VS.85).aspx

        ' If your installer project is configured correctly then using /i here 
        ' should uninstall and reinstall appropriately.  The /l*vx switch determines
        ' what is logged to the install/uninstall log.  v = verbose, x= extra debugging info.  Add vx to l* if necessary (i.e. /l*vx)
        Dim args As String = Nothing
        If targetDir = Nothing Then
            args = String.Format("/i ""{0}"" /l* ""{1}""", msiFilePath, installerLogFilePath)
        Else
            args = String.Format("/i ""{0}"" /quiet /l* ""{1}"" TARGETDIR=""{2}"" CONFIGDIR=""{3}""", msiFilePath, installerLogFilePath, targetDir, Settings.ConfigRootDirPath)
        End If

        ' Left for reference; see url above for more info/options.
        '.Arguments = "/x C:\setupfile.msi /quiet" ''Uninstall quietly!

        With msiProc.StartInfo
            .UseShellExecute = False
            .CreateNoWindow = True
            .WindowStyle = ProcessWindowStyle.Hidden

            ' This must be an absolute path to the executable in order 
            ' to spawn an individual, unique thread (i.e. C:\WINDOWS\System32\msiexec.exe").
            .FileName = Path.Combine(systemFolderPath, "msiexec.exe")
            .Arguments = args
        End With

        Log.WriteInfo("Beginning upgrade of application: executing " + msiProc.StartInfo.FileName + " " + msiProc.StartInfo.Arguments)

        msiProc.Start()
    End Sub

    ''' <summary>
    ''' Reads autoupdater settings from the config file and initializes any 
    ''' applicable scheduler instances or trace logs.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub PrepareAutoUpdateEnvironmentAndScheduler()
        Log.WriteInfo("Setting up auto updater service environment configuration and task scheduling.")
        Log.WriteInfo("Loading auto update settings from the config file.")

        _autoDownloadAndInstallUpdates = Settings.ConvertToBool(Settings.GetGeneralSetting("AutoDownloadAndInstallUpdates", "False"))

        If _autoDownloadAndInstallUpdates = False Then
            Log.WriteInfo("The auto updater service is not configured to perform any actions. " &
                                "The service may have started but it will not do any work.")
            Exit Sub
        End If

        _autoUpdateInterval = Settings.GetGeneralSetting("AutoUpdateInterval")

        If _autoUpdateInterval = "" Then
            _autoDownloadAndInstallUpdates = False
            Log.WriteError("The auto update interval is not valid (expected Daily or Weekly).")
            Exit Sub
        End If

        Dim intMod As Integer = 1
        Dim sIntMod As String = Settings.GetGeneralSetting("AutoUpdateIntervalModifier")

        If sIntMod <> "" AndAlso Integer.TryParse(sIntMod, intMod) Then
            _autoUpdateIntervalModifier = intMod
        End If

        _autoUpdateTime = Settings.GetGeneralSetting("AutoUpdateTime", "1:00 AM")

        _autoUpdateWeeklyDays = Settings.GetGeneralSetting("AutoUpdateWeeklyDays")

        ' When was the last time we checked for an update?
        Dim dtLastCheck As DateTime
        Dim sLastCheck As String = Settings.GetGeneralSetting("AutoUpdateLastCheck")

        If sLastCheck <> "" AndAlso DateTime.TryParse(sLastCheck, dtLastCheck) Then
            _autoUpdateLastCheckedDtm = dtLastCheck
        End If

        ' Get the provider number/id.
        _providerNumber = Settings.GetGeneralSetting("ProviderNumber")

        ' Get the vendor name from the extractor service settings category.
        _vendorName = Settings.GetExtractorServiceSetting("VendorName")

        ' Setup the autoupdate scheduler instance.
        PrepareScheduler()
    End Sub

    ''' <summary>
    ''' Configures and enables/starts the applicable task scheduler 
    ''' for checking, downloading, and install application updates from SmartLink
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub PrepareScheduler()
        Try
            If _scheduler IsNot Nothing Then
                ' Make sure we un-wire any event handlers so resources can be
                ' released and processed by the GC
                RemoveHandler _scheduler.RunTask, AddressOf ProcessAutoUpdateEvent

                _scheduler.Dispose()
                _scheduler = Nothing
            End If

            ' Construct auto-update scheduler settings string.
            Dim traceMsg As String = String.Format("Initializing auto updater scheduler instance using the following settings:" & Environment.NewLine &
                                                   "    Interval: {0}" & Environment.NewLine &
                                                   "    Interval Modifier: {1}" & Environment.NewLine &
                                                   "    Time: {2}" & Environment.NewLine,
                                                   _autoUpdateInterval,
                                                   _autoUpdateIntervalModifier.Value.ToString(),
                                                   _autoUpdateTime)
            If _autoUpdateInterval.ToUpper() = "WEEKLY" Then
                traceMsg &= "    Weekdays: " & _autoUpdateWeeklyDays
            End If

            ' Log auto-update scheduler settings.
            Log.WriteInfo(traceMsg)

            'Prepare Auto-Update Scheduler
            Select Case _autoUpdateInterval.ToUpper()
                Case "DAILY"
                    Dim dailyScheduler As New DailyScheduler()
                    dailyScheduler.Interval = _autoUpdateIntervalModifier.Value
                    dailyScheduler.Time = _autoUpdateTime

                    _scheduler = dailyScheduler
                Case "WEEKLY"
                    Dim weeklyScheduler As New WeeklyScheduler()
                    weeklyScheduler.Interval = _autoUpdateIntervalModifier.Value
                    weeklyScheduler.Time = _autoUpdateTime
                    weeklyScheduler.WeekDays = _autoUpdateWeeklyDays

                    _scheduler = weeklyScheduler
                Case Else
                    Log.WriteError("The supplied auto update interval (" & _autoUpdateInterval & ") is not valid or supported!")
            End Select

            If _scheduler IsNot Nothing Then
                AddHandler _scheduler.RunTask, AddressOf ProcessAutoUpdateEvent
                _scheduler.Enabled = True
                Log.WriteTrace("Scheduler's Next Run: " & _scheduler.NextRun)
            End If

        Catch ex As Exception
            Log.WriteError("The following error occurred while initializing the scheduler: " & Environment.NewLine & Environment.NewLine &
                                 ex.Message, ex)
            Me.Stop()
        End Try
    End Sub

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
End Class
