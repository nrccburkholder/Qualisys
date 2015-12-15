Imports System.ComponentModel
Imports System.Configuration.Install

Imports NRC.SmartLink.Common

Public Class ProjectInstaller

    Public Sub New()
        MyBase.New()

        'This call is required by the Component Designer.
        InitializeComponent()

        'Add initialization code after the call to InitializeComponent

    End Sub

    Protected Overrides Sub OnBeforeUninstall(ByVal savedState As System.Collections.IDictionary)
        MyBase.OnBeforeUninstall(savedState)

        'For Each de As DictionaryEntry In Me.Context.Parameters()
        '    WriteEventLogEntry("OnBeforeUninstall() Me.Context.Parameters() ~~ " & de.Key & " : " & de.Value)
        'Next

        ' If this is an upgrade, do some work to backup the config settings and log files.
        ' NOTE: If this is a straight uninstall (not upgrade) it is assumed the end-user will backup up their files manually if necessary.
        If Not String.IsNullOrEmpty(Me.Context.Parameters("Upgrading")) Then
            BackupConfigFiles()
        End If
    End Sub

    Protected Overrides Sub OnBeforeInstall(ByVal savedState As System.Collections.IDictionary)
        MyBase.OnBeforeInstall(savedState)

        'Dim contextParamsMsg As String = String.Empty
        'For Each de As DictionaryEntry In Me.Context.Parameters()
        '    contextParamsMsg &= "[OnBeforeInstall()] Me.Context.Parameters(""" & de.Key & """) = " & de.Value & Environment.NewLine
        'Next
        'If Not String.IsNullOrEmpty(contextParamsMsg) Then
        '    WriteEventLogEntry(contextParamsMsg)
        'Else
        '    WriteEventLogEntry("No context parameters in the current install context.")
        'End If
    End Sub

    Protected Overrides Sub OnAfterInstall(ByVal savedState As System.Collections.IDictionary)
        MyBase.OnAfterInstall(savedState)

        'The following code is used for installer troubleshooting purposes.
        'Dim contextParamsMsg As String = String.Empty
        'For Each de As DictionaryEntry In Me.Context.Parameters()
        '    contextParamsMsg &= "[OnAfterInstall()] Me.Context.Parameters(""" & de.Key & """) = " & de.Value & Environment.NewLine
        'Next
        'If Not String.IsNullOrEmpty(contextParamsMsg) Then
        '    WriteEventLogEntry(contextParamsMsg)
        'Else
        '    WriteEventLogEntry("No context parameters in the current install context.")
        'End If

    End Sub

    Protected Overrides Sub OnCommitted(ByVal savedState As System.Collections.IDictionary)
        MyBase.OnCommitted(savedState)

        ' We've committed the installation...

        ''Do some work to put the config/log files back in place and merged.        
        RestoreAndMergeConfigFilesFromBackup()

        If Me.Context IsNot Nothing _
            AndAlso Me.Context.Parameters IsNot Nothing _
            AndAlso Me.Context.Parameters.Count > 0 _
            AndAlso Not String.IsNullOrEmpty(Me.Context.Parameters("version")) Then

            ' Set this value for the convenience of the Auto Updater service.
            Settings.SetGeneralSetting("InstalledSmartLinkVersion", Me.Context.Parameters("version"))
        End If

        If _restoredConfigFromBackup Then
            Try
                ' If we restored a backup config directory then it can be
                ' assumed we are upgrading and we can try to automatically
                ' restart the activated services.
                RestartActivatedServicesAfterApplicationUpgrade()

            Catch ex As Exception
                WriteEventLogEntry("Unable to auto restart activated services during SmartLink upgrade: " & ex.GetBaseException().Message)
                ' NOTE: Every custom action in this method "RestoreAndMergeConfigFilesFromBackup" 
                ' should be wrapped in this outer try/catch block to prevent an exception from
                ' rolling back the installation.
            End Try
        End If

        If Me.Context IsNot Nothing _
            AndAlso Me.Context.Parameters IsNot Nothing _
            AndAlso Me.Context.Parameters.Count > 0 Then

            ' Try to write the uninstall script to the Application Directory.
            If Not String.IsNullOrEmpty(Me.Context.Parameters("pcode")) Then
                Dim uninstallFilePath As String = Path.Combine( _
                    My.Application.Info.DirectoryPath, "uninstall.vbs")
                Try
                    If My.Computer.FileSystem.FileExists(uninstallFilePath) Then
                        My.Computer.FileSystem.DeleteFile(uninstallFilePath)
                    End If
                    Dim winScript As String = _
                        "Set WshShell = CreateObject(""WScript.Shell"")" & Environment.NewLine & _
                        "WshShell.Run ""msiexec.exe /x " & Me.Context.Parameters("pcode") & """,1,False" & Environment.NewLine & _
                        "Set WshShell = Nothing"
                    My.Computer.FileSystem.WriteAllText(uninstallFilePath, winScript, False, New System.Text.ASCIIEncoding())
                Catch ex As Exception
                    WriteEventLogEntry("The following exception occurred while writing the uninstall script to the application directory - " & _
                                       ex.Message & Environment.NewLine & Environment.NewLine & ex.StackTrace)

                End Try

            End If

            ' Do we need to restart the NRC SmartLink Service Manager application?
            If Not String.IsNullOrEmpty(Me.Context.Parameters("userinterfacelevel")) Then
                ' userinterfacelevel is a CustomActionData value populated by the
                ' Windows Installer property [UILevel]. http://msdn.microsoft.com/en-us/library/aa372096(VS.85).aspx
                Dim uiLevel As String = Me.Context.Parameters("userinterfacelevel")
                If IsNumeric(uiLevel) Then
                    If Convert.ToInt32(uiLevel) <> 2 Then
                        'WriteEventLogEntry("[UILevel] = " & uiLevel)

                        ' INSTALLUILEVEL_NONE = 2 = Completely silent installation.
                        ' We install autoupdates silently, so for any other UILevel we
                        ' want to launch the NRC SmartLink Service Manager after install.
                        Dim smartLinkPath As String = Path.Combine( _
                            My.Application.Info.DirectoryPath, My.Application.Info.AssemblyName & ".exe")

                        Dim p As Process = New Process()
                        p.StartInfo = New ProcessStartInfo()
                        With p.StartInfo
                            .FileName = smartLinkPath
                            .WindowStyle = ProcessWindowStyle.Normal
                        End With

                        Try
                            p.Start()
                        Catch ex As Exception
                            WriteEventLogEntry("The following exception occurred while attempting to auto-start the NRC SmartLink Service Manager application after install/upgrade - " & _
                                               ex.Message & Environment.NewLine & Environment.NewLine & ex.StackTrace)
                        End Try
                    End If
                End If
            End If
        End If
    End Sub

    Private Const REGKEY_NAME = "SOFTWARE\NRC\SmartLink"
    Private Const APP_DIR_REGKEYVALUE_NAME = "AppDir"
    Private Const CONFIG_DIR_REGKEYVALUE_NAME = "ConfigFileDir"
    Private Const CONFIG_DIR_PREV_REGKEYVALUE_NAME = "ConfigFileDirPrevious"
    Private Const LOG_DIR_REGKEYVALUE_NAME = "LogFileDir"
    Private Const LOG_DIR_PREV_REGKEYVALUE_NAME = "LogFileDirPrevious"

    Private Const CONFIG_BACKUP_DIR_NAME = "ConfigBackup"
    Private Const LOG_BACKUP_DIR_NAME = "LogBackup"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub BackupConfigFiles()
        'System.Diagnostics.Debugger.Launch()
        ' Save the next line in case we need to change how we evaluate the application root directory.
        ' Currently we are reading it from the Registry.
        'Dim appRoot = System.IO.Path.GetDirectoryName(Me.Context.Parameters("AssemblyPath"))
        Dim backupWasSuccessful = True
        WriteEventLogEntry("Beginning config file backup as a result of product upgrade.")

        Try
            ' Open the SmartLink registry key for read/write.
            Dim regKey = Registry.LocalMachine.OpenSubKey(REGKEY_NAME, True)
            If regKey IsNot Nothing Then

                Dim appDir As String = _
                    Convert.ToString(regKey.GetValue(APP_DIR_REGKEYVALUE_NAME))

                ' Get the config settings root folder path from the registry
                Dim configSettingsDir As String = _
                    Convert.ToString(regKey.GetValue(CONFIG_DIR_REGKEYVALUE_NAME))

                ' Only proceed to backup files if the registry key value exists.
                If Not String.IsNullOrEmpty(configSettingsDir) AndAlso _
                    My.Computer.FileSystem.DirectoryExists(configSettingsDir) Then

                    ' During upgrade (uninstall/reinstall) persist the previous/original
                    ' config settings folder path to the registry for use after reinstall
                    regKey.SetValue(CONFIG_DIR_PREV_REGKEYVALUE_NAME, configSettingsDir, RegistryValueKind.String)
                    regKey.Close()

                    If String.IsNullOrEmpty(appDir) Then
                        WriteEventLogEntry("The application root could not be determined. Cannot backup previous config settings and logs!")
                        Return
                    End If

                    ' Create the path to the config settings and log files BACKUP folder.
                    Dim backupDirPath = System.IO.Path.Combine(appDir, CONFIG_BACKUP_DIR_NAME)

                    ' Check if a previous operation forgot to delete the BACKUP folder.
                    If My.Computer.FileSystem.DirectoryExists(backupDirPath) Then
                        ' Delete the existing folder!
                        My.Computer.FileSystem.DeleteDirectory( _
                            backupDirPath, FileIO.DeleteDirectoryOption.DeleteAllContents)
                    End If

                    ' During upgrade (uninstall/reinstall) persist the previous/original config settings and 
                    ' log files for use after reinstall.  Backup all the files to a temporary location.
                    My.Computer.FileSystem.CopyDirectory(configSettingsDir, backupDirPath)
                End If
            End If
        Catch ex As Exception
            WriteEventLogEntry("The config file backup failed." & Environment.NewLine & Environment.NewLine & _
                               ex.GetBaseException().Message)
            backupWasSuccessful = False
        End Try

        If backupWasSuccessful Then
            WriteEventLogEntry("The config file backup completed successfully.")
        End If
    End Sub

    Dim _restoredConfigFromBackup As Boolean = False

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub RestoreAndMergeConfigFilesFromBackup()

        _restoredConfigFromBackup = False ' No work performed, yet.

        Try
            Dim regKey = Registry.LocalMachine.OpenSubKey("SOFTWARE\NRC\SmartLink", True)

            If regKey IsNot Nothing Then
                ' Get the application root folder path from the registry
                Dim appDir As String = _
                    Convert.ToString(regKey.GetValue(APP_DIR_REGKEYVALUE_NAME))

                ' Do we have a config backup folder to process?
                If Not String.IsNullOrEmpty(appDir) AndAlso _
                    My.Computer.FileSystem.DirectoryExists(appDir) AndAlso _
                    My.Computer.FileSystem.DirectoryExists(Path.Combine(appDir, CONFIG_BACKUP_DIR_NAME)) Then
                    'YES! Let's attempt to restore the original configuration state.

                    Dim configPath As String
                    Dim configBackupPath As String = Path.Combine(appDir, CONFIG_BACKUP_DIR_NAME)

                    Dim prevConfigPath As String = _
                        Convert.ToString(regKey.GetValue(CONFIG_DIR_PREV_REGKEYVALUE_NAME))

                    Dim defaultConfigPath As String = _
                        Convert.ToString(regKey.GetValue(CONFIG_DIR_REGKEYVALUE_NAME))

                    If Not String.IsNullOrEmpty(prevConfigPath) AndAlso _
                        Not String.IsNullOrEmpty(defaultConfigPath) AndAlso _
                        My.Computer.FileSystem.DirectoryExists(defaultConfigPath) AndAlso _
                        prevConfigPath <> defaultConfigPath Then

                        ' Recreate the empty config directory.
                        If Not My.Computer.FileSystem.DirectoryExists(prevConfigPath) Then
                            My.Computer.FileSystem.CreateDirectory(prevConfigPath)
                        End If

                        ' Copy the default configuration files to the previously configured config settings folder.
                        ' Essentially, we are setting everything back to the installation defaults and then we will 
                        ' restore the correct files/values from the versions in the ConfigBackup folder.
                        ' NOTE: This is done to handle non-default config settings file locations.
                        My.Computer.FileSystem.CopyDirectory(defaultConfigPath, prevConfigPath, True)

                        configPath = prevConfigPath
                    Else
                        configPath = defaultConfigPath
                    End If

                    Settings.RestoreAndMergeConfiguration(configBackupPath, configPath)

                    _restoredConfigFromBackup = True

                    ' Success! Reset the registry defaults and cleanup.
                    If regKey.GetValueNames().Contains(CONFIG_DIR_PREV_REGKEYVALUE_NAME) Then
                        regKey.DeleteValue(CONFIG_DIR_PREV_REGKEYVALUE_NAME)
                    End If
                    regKey.SetValue(CONFIG_DIR_REGKEYVALUE_NAME, configPath, RegistryValueKind.String)
                    regKey.Close()
                End If
            End If
        Catch secEx As System.Security.SecurityException
            WriteEventLogEntry("Unable to auto restore configuration backup files during SmartLink upgrade:  The user does not have the permissions required to read the registry key.")
            _restoredConfigFromBackup = False ' reset this value to false on exception.
        Catch ex As Exception
            WriteEventLogEntry("Unable to auto restore configuration backup files during SmartLink upgrade: " & ex.GetBaseException().Message)
            ' NOTE: Every custom action in this method "RestoreAndMergeConfigFilesFromBackup" 
            ' should be wrapped in this outer try/catch block to prevent an exception from
            ' rolling back the installation.

            _restoredConfigFromBackup = False ' reset this value to false on exception.
        End Try
    End Sub

    Private Sub RestartActivatedServicesAfterApplicationUpgrade()
        Dim serviceFound As Boolean = False

        For Each sc As System.ServiceProcess.ServiceController In System.ServiceProcess.ServiceController.GetServices()
            serviceFound = False
            Select Case sc.ServiceName
                Case Settings.TRANSFER_SVC_NAME
                    If Settings.ConvertToBool(Settings.GetTransferServiceSetting("IsActivated", "False")) Then
                        serviceFound = True
                    End If
                Case Settings.AUTOUPDATE_SVC_NAME
                    If Settings.ConvertToBool(Settings.GetGeneralSetting("AutoDownloadAndInstallUpdates", "False")) Then
                        serviceFound = True
                    End If
            End Select
            If serviceFound AndAlso sc.Status <> ServiceProcess.ServiceControllerStatus.Running Then
                sc.Start()
            End If
        Next
    End Sub

    Private Sub WriteEventLogEntry(ByVal message As String)
        If Not String.IsNullOrEmpty(message) Then

            If Not EventLog.SourceExists("NRC SmartLink Service Manager") Then
                EventLog.CreateEventSource("NRC SmartLink Service Manager", "Application")
            End If

            EventLog.WriteEntry("NRC SmartLink Service Manager", message, EventLogEntryType.Information)
        End If
    End Sub
End Class

'// Get username from context

'var userName = this.Context.Parameters["userName"];

'// Context contains assemblypath by default

'var assemblyPath = this.Context.Parameters["assemblypath"];

'// Get UserName setting in app.config

'var config = ConfigurationManager.OpenExeConfiguration(assemblyPath);

'var sectionGroup = config.GetSectionGroup("applicationSettings");

'var section = sectionGroup.Sections["MyCalcWin.Properties.Settings"] 

'              as ClientSettingsSection;
'var settingElement = section.Settings.Get("UserName");

'// Create new value node

'var doc = new XmlDocument();

'var newValue = doc.CreateElement("value");

'newValue.InnerText = userName;

'// Set new UserName value

'settingElement.Value.ValueXml = newValue;

'// Save changes

'section.SectionInformation.ForceSave = true;

'config.Save(ConfigurationSaveMode.Modified);