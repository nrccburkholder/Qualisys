Imports System.ComponentModel
Imports System.Configuration.Install

Public Class Installer1

    Public Sub New()
        MyBase.New()

        'This call is required by the Component Designer.
        InitializeComponent()

        'Add initialization code after the call to InitializeComponent
    End Sub

    Protected Overrides Sub OnBeforeUninstall(ByVal savedState As System.Collections.IDictionary)
        MyBase.OnBeforeUninstall(savedState)

        For Each de As DictionaryEntry In Me.Context.Parameters()
            EventLog.WriteEntry("MsiInstaller", "UNINSTALL Me.Context.Parameters() ~~ " & de.Key & " : " & de.Value)
        Next

        ' If this is an upgrade, do some work to backup the config settings and log files.
        ' NOTE: If this is a straight uninstall (not upgrade) it is assumed the end-user will backup up their files manually if necessary.
        If Not String.IsNullOrEmpty(Me.Context.Parameters("Upgrading")) Then
            BackupConfigFiles()
        End If
    End Sub

    Protected Overrides Sub OnBeforeInstall(ByVal savedState As System.Collections.IDictionary)
        MyBase.OnBeforeInstall(savedState)

        For Each de As DictionaryEntry In Me.Context.Parameters()
            EventLog.WriteEntry("MsiInstaller", "INSTALL Me.Context.Parameters() ~~ " & de.Key & " : " & de.Value)
        Next
    End Sub

    Protected Overrides Sub OnAfterInstall(ByVal savedState As System.Collections.IDictionary)
        MyBase.OnAfterInstall(savedState)

        ''Do some work to put the config/log files back in place and merged.        
        RestoreAndMergeConfigFilesFromBackup()
    End Sub

    Private Const REGKEY_NAME = "SOFTWARE\NRC, Inc.\SmartLink"
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
                        EventLog.WriteEntry("MsiInstaller", _
                                            "The application root could not be determined. Cannot backup previous config settings and logs!")
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

                    'Microsoft.VisualBasic.FileIO.FileSystem.CopyDirectory(configSettingsDir, System.IO.Path.Combine(appRootPath, "ConfigBackup"))
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

    Private Sub BackupLogFiles()
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
                        EventLog.WriteEntry("MsiInstaller", _
                                            "The application root could not be determined. Cannot backup previous config settings and logs!")
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

                    'Microsoft.VisualBasic.FileIO.FileSystem.CopyDirectory(configSettingsDir, System.IO.Path.Combine(appRootPath, "ConfigBackup"))
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

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub RestoreAndMergeConfigFilesFromBackup()

        Try
            Dim regKey = Registry.LocalMachine.OpenSubKey("SOFTWARE\NRC, Inc.\SmartLink", True)

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

                    NRC.Miscellaneous.Settings.RestoreAndMergeConfiguration(configBackupPath, configPath)

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
        Catch ex As Exception
            WriteEventLogEntry("Unable to auto restore configuration backup files during SmartLink upgrade: " & ex.GetBaseException().Message)
            ' NOTE: Every custom action in this method "RestoreAndMergeConfigFilesFromBackup" 
            ' should be wrapped in this outer try/catch block to prevent an exception from
            ' rolling back the installation.
        End Try
    End Sub

    Private Sub WriteEventLogEntry(ByVal message As String)
        If Not String.IsNullOrEmpty(message) Then
            EventLog.WriteEntry("MsiInstaller", message)
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