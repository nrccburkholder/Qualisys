Imports System.Xml
Imports System.Xml.XPath
Imports System.Net.Mail
Imports System.ServiceProcess
Imports System.IO
Imports System.Diagnostics

Imports NRC.SmartLink.AutoUpdater
Imports NRC.SmartLink.Common

Public Class frmConfig

#Region "Private Variables"

    Private _dlInstance As MSDASC.DataLinksClass = New MSDASC.DataLinksClass
    Private _ADODBConnection As New ADODB.ConnectionClass
    Private _SMTPClient As New SmtpClient()

    Private _bExtractorSvcSettingsChanged As Boolean
    Private _bTransferSvcSettingsChanged As Boolean
    Private _bGeneralSettingsChanged As Boolean ' <-- NOTE: Used by both the "General" and "Application Updates" tab pages

    Private _processServicesOnFormClosing As Boolean = True

    Private _webService As WebService = Nothing

    Private _bEnablingEdit As Boolean
    Private _sExtraPollingFolders(0) As String
    Private _refreshWebService As Boolean = False

    'Private _frmWait As frmWait = New frmWait()

    Declare Function OpenIcon Lib "user32" (ByVal hwnd As Long) As Long
    Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long
#End Region

#Region "Generic code - Applies to all services being managed"
    Private Sub frmConfig_KeyDown(ByVal sender As System.Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles MyBase.KeyDown
        If e.Control Then
            _bEnablingEdit = True
        End If
    End Sub

    Private Sub frmConfig_KeyUp(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles Me.KeyUp
        If Not e.Control Then
            _bEnablingEdit = False
        End If
    End Sub

    Private Sub frmConfig_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        ' Set the ProcessName setting on load which is used by the
        ' autoupdater service to determine which process to kill when neccessary.
        Settings.SetGeneralSetting("ProcessName", My.Application.Info.AssemblyName & ".exe")

        Log.LogTrace(Settings.ConvertToBool(Settings.GetGeneralSetting("TraceFlag")))

        If UBound(System.Diagnostics.Process.GetProcessesByName(
                  System.Diagnostics.Process.GetCurrentProcess.ProcessName)) > 0 Then
            ''Send opening form's TEXT property as a parameter 
            ''to the function "ActivatePrevInstance" 
            ''This works well with an MDI form or a non-MDI form 
            ''It is advised that you give a Unique name to your Form 
            ''so that it doe not conflict with other applications 
            ActivatePrevInstance(Me.Text)
        End If

        ' Resolve the application's config/log/definition file(s) ROOT folder.
        ' NOTE: Settings.ConfigRootDirPath resolves the default or custom root dir path 
        ' using the SL_Paths.xml file in the application execution directory and its value
        ' is expected to be in synch with the registry setting.
        Dim cfgRoot As String = Settings.ConfigRootDirPath

#If CONFIG = "Debug" Then
        Log.WriteTrace("Using configuration settings values from the following file: " & Settings.ConfigFileAbsolutePath)
        Log.WriteTrace("Config/Log/Definition file(s) Root Directory: " & cfgRoot)
#End If

        txtSmartLinkUploadedFileLog.Text = Settings.GetFilePath2TransferServiceSubmittedFilesLogFile()
        txtSmartLinkErrorLogFile.Text = Settings.GetLogFilePath(Settings.TRANSFER_SVC_NAME)

        Log.WriteTrace("Service Manager - Loading Main Form - Config Root Folder: " & cfgRoot)
        cmdGeneralTestEmail.Enabled = False

        ReadGeneralSettings()

        ShowGeneralPasswordStatusMessage()

        ReadSmartLinkSettings()

        'Show service status for both services
        ServiceStatusMessage(Settings.TRANSFER_SVC_NAME, lblSmartLinkServiceStatus, lblSmartLinkStatusColor, cmdSmartLinkStopStart)

        lblGeneralWebServiceStatus.Text = "Connecting"
        lblGeneralWebServiceStatusColor.ImageIndex = 0
        _refreshWebService = True

        ' We're loading the application so reset any settings 
        ' changed flags to their default values.
        _bExtractorSvcSettingsChanged = False
        _bTransferSvcSettingsChanged = False
        _bGeneralSettingsChanged = False

        UpdateVersionText()

        cmdSmartLinkPath.Focus()
    End Sub

    Private Sub ActivatePrevInstance(ByVal argStrAppToFind As String)
        Dim PrevHndl As Long
        Dim result As Long

        Dim objProcess As New Process 'Variable to hold individual Process
        Dim objProcesses() As Process 'Collection of all the Processes running on local machine
        objProcesses = Process.GetProcesses() ''Get all processes into the collection()

        For Each objProcess In objProcesses
            ''Check and exit if we have SMS running already
            If UCase(objProcess.MainWindowTitle) = UCase(argStrAppToFind) Then
                MsgBox("Another instance of " & argStrAppToFind & vbCrLf &
                        "is already running on this machine. It is recommended " & vbCrLf &
                        "that you only run one instances at a time." & vbCrLf &
                        "Please use the existing instance.")
                PrevHndl = objProcess.MainWindowHandle.ToInt32()
                Exit For
            End If
        Next

        If PrevHndl = 0 Then Exit Sub 'if No previous instance found exit the application.
        ''If found
        result = OpenIcon(PrevHndl) 'Restore the program.
        result = SetForegroundWindow(PrevHndl) 'Activate the application.

        End 'End the current instance of the application.
    End Sub

    Private Sub ActivateTextBox(ByRef TextBoxObject As TextBox)
        If _bEnablingEdit Then
            TextBoxObject.ReadOnly = False
            TextBoxObject.SelectAll()
        End If
    End Sub

    Private Sub cmdHelp_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdHelp.Click
        Dim sBodyText As String
        sBodyText = "NRC prides itself on its quick and outstanding service. Our goal is to address all issues within"
        sBodyText &= vbCrLf & "24 hours. Call us or email us and we will help you get any issue resolved."
        sBodyText &= vbCrLf & vbCrLf & "Client Operations:"
        sBodyText &= vbCrLf & "Phone: 866.641.8324"
        sBodyText &= vbCrLf & "e-mail: support@nationalresearch.com"
        sBodyText &= vbCrLf & vbCrLf & "Web: http://www.nationalresearch.com/contact/"

        MessageBox.Show(sBodyText, "NRC Service Manager")
    End Sub

    Private Sub cmdSaveSettings_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSaveSettings.Click

        Try
            Me.Cursor = Cursors.WaitCursor

            If ValidateSettings() Then
                SaveSettings()
            End If
        Finally
            Me.Cursor = Cursors.Arrow
        End Try

    End Sub

    Private Sub tabSettings_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tabSettings.SelectedIndexChanged
        Select Case tabSettings.SelectedTab.Name
            Case "tabSmartLink"
                cmdSmartLinkPath.Focus()
            Case "tabUpdate"
                cmdCheck4Update.Enabled = True
                cmdCheck4Update.Focus()
            Case Else
        End Select
    End Sub

    Private Sub cmdClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClose.Click
        Me.Close()
        'Application.Exit()
    End Sub

    Private Sub frmConfig_FormClosing(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles MyBase.FormClosing

        Try

            Me.Cursor = Cursors.WaitCursor

            Log.WriteTrace("Service Manager - Closing Application")

            If PromptSaveSettings() Then
                If ValidateSettings() Then
                    SaveSettings()
                Else
                    e.Cancel = True
                End If
            End If

            If _processServicesOnFormClosing Then
                StartServices()
            End If

        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    'This Method lets the user select a folder and applies the result to the text box
    Private Sub SelectDirectory(ByRef txtPATH As TextBox)
        Dim sMsg As String
        Dim bValidFolder As Boolean

        'Set default path to current address if there is a valid path
        If System.IO.Directory.Exists(txtPATH.Text) Then
            fbdFolderBrowserDialog.SelectedPath = txtPATH.Text
        End If

        'Loops until the user selects a valid path
        bValidFolder = False
        Do While Not bValidFolder
            If fbdFolderBrowserDialog.ShowDialog() <> Windows.Forms.DialogResult.OK Then
                Exit Do
            End If

            If fbdFolderBrowserDialog.SelectedPath.Length = 3 Then
                'Makes sure the user does not chose the root of any of the Drives
                sMsg = "Selected folder can not be " & fbdFolderBrowserDialog.SelectedPath _
                    & vbCrLf & vbCrLf & "Please select a subfolder in the drive"
                MsgBox(sMsg, MsgBoxStyle.Information, "Invalid Path")


            ElseIf (fbdFolderBrowserDialog.SelectedPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.ProgramFiles) _
                Or fbdFolderBrowserDialog.SelectedPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.System) _
                Or fbdFolderBrowserDialog.SelectedPath.ToUpper Like "*WINDOWS*" _
                Or fbdFolderBrowserDialog.SelectedPath.ToUpper Like "*WINNT*") _
                Or fbdFolderBrowserDialog.SelectedPath Like System.Environment.SystemDirectory & "*" Then

                'Makes sure the user does not chose any of the system folders

                sMsg = "Selected folder can not be " & fbdFolderBrowserDialog.SelectedPath _
                    & vbCrLf & vbCrLf & "Please select a folder that is not restricted by the Operating System"
                MsgBox(sMsg, MsgBoxStyle.Information, "Invalid Path")

            Else
                bValidFolder = True
            End If

        Loop

        If bValidFolder Then
            txtPATH.Text = fbdFolderBrowserDialog.SelectedPath
        End If

    End Sub

    Private Sub TestEmail(ByVal ServerName As String, ByVal EmailAddress As String)
        Dim mail As New MailMessage()
        Try
            _SMTPClient.Host = ServerName
            mail.Subject = "NRC Service Manager Email Testing"
            mail.To.Add(EmailAddress)
            mail.From = New MailAddress("NRC_SrvManager@" & mail.To(0).Host)
            mail.Body = "This is a test of the NRC SLT emailer function."
            mail.Priority = MailPriority.High
            _SMTPClient.Send(mail)
            MessageBox.Show("An email has been sent to " & EmailAddress & ".")
        Catch ex As Exception
            Log.WriteError("Error: SendEmail " & ex.Message, ex)
            MessageBox.Show("Error: SendEmail " & ex.Message, "NRC Service Manager", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Function PromptSaveSettings() As Boolean
        PromptSaveSettings = False
        If _bGeneralSettingsChanged OrElse _bExtractorSvcSettingsChanged OrElse _bTransferSvcSettingsChanged Then
            If MessageBox.Show("Do you want to save the settings before closing?", "Closing Manager", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = Windows.Forms.DialogResult.Yes Then
                PromptSaveSettings = True
            End If
        End If
    End Function

    Private Function PromptSaveSettings(ByVal ServiceName As String) As Boolean
        Dim displayMsg As String = String.Format(
            "There are some settings for {0} that have not been saved. Do you want to save these settings?", ServiceName)

        If MessageBox.Show(displayMsg, "Save settings", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = Windows.Forms.DialogResult.Yes Then
            Return True
        Else
            Return False
        End If
    End Function

    Private Sub SaveSettings(ByVal ServiceName As String)
        If ServiceName = Settings.TRANSFER_SVC_NAME Then
            If _bTransferSvcSettingsChanged Then
                WriteSmartLinkSettings()
            End If
        End If

        If _bGeneralSettingsChanged Then
            WriteGeneralSettings()
            RestartService(Settings.TRANSFER_SVC_NAME)
        End If
    End Sub

    Private Sub SaveSettings()
        Dim bRestartSmartLink As Boolean = False
        Dim bRestartAU As Boolean = False

        If _bTransferSvcSettingsChanged Then
            WriteSmartLinkSettings()

            ' Since the transfer service settings changed, if the service is
            ' configured as activated, flag it for restart.
            bRestartSmartLink = chkActivateTransferService.Checked
        End If

        If _bGeneralSettingsChanged Then
            WriteGeneralSettings()

            ' Since the general settings changed, flag for restart all services that
            ' are configured as activated.
            bRestartSmartLink = chkActivateTransferService.Checked
            bRestartAU = chkDownloadAndInstallUpdates.Checked
        End If

        If bRestartSmartLink Then
            RestartService(Settings.TRANSFER_SVC_NAME)
        End If
        If bRestartAU Then
            RestartService(Settings.AUTOUPDATE_SVC_NAME)
        End If

        ' All settings have been saved. Do one last check to make sure 
        ' any services that aren't configured to run aren't currently running.
        StopServicesThatShouldNotBeRunning()

        MessageBox.Show("All the settings have been successfully saved.", "Service Manager Message", MessageBoxButtons.OK)
    End Sub

    ''' <summary>
    ''' Stop all running services that are not currently 
    ''' configured to be running.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub StopServicesThatShouldNotBeRunning()
        Dim numberOfServicesVerified As Integer = 0
        Dim stopThisService As Boolean = False

        Try
            Me.Cursor = Cursors.WaitCursor

            For Each sc As ServiceController In ServiceController.GetServices()
                stopThisService = False
                Select Case sc.ServiceName
                    Case Settings.TRANSFER_SVC_NAME
                        If Not chkActivateTransferService.Checked Then
                            stopThisService = True
                        End If
                        numberOfServicesVerified += 1
                    Case Settings.AUTOUPDATE_SVC_NAME
                        If Not chkDownloadAndInstallUpdates.Checked Then
                            stopThisService = True
                        End If
                        numberOfServicesVerified += 1
                End Select
                If stopThisService Then
                    StopService(sc.ServiceName)
                End If
                ' If we've verified all 3 services then our work is done.
                If numberOfServicesVerified = 3 Then
                    ' No need to loop through any remaining
                    ' services on the local system.
                    Exit Sub
                End If
            Next

        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub StartServices()

        ' Is the transfer service configured as "activated"?
        If chkActivateTransferService.Checked Then
            If Not tabSettings.TabPages.Item("tabSmartLink") Is Nothing Then
                If SmartLinkSettingsValidator(True) Then
                    StartService(Settings.TRANSFER_SVC_NAME)
                End If
            End If
        End If

        ' Is the auto updater service configured to do work?
        If chkDownloadAndInstallUpdates.Checked Then
            If AppUpdateSchedSettingsValidator(True) Then
                StartService(Settings.AUTOUPDATE_SVC_NAME)
            End If
        End If
    End Sub

    Private Function ValidateSettings() As Boolean
        ValidateSettings = True

        If Not tabSettings.TabPages.Item("tabSmartLink") Is Nothing Then
            If Not SmartLinkSettingsValidator() Then
                ValidateSettings = False
            End If
        End If

        If Not tabSettings.TabPages.Item("tabGeneral") Is Nothing Then
            If Not GeneralSettingsValidator() Then
                ValidateSettings = False
            End If
        End If

        If Not tabSettings.TabPages.Item("tabUpdate") Is Nothing Then
            If Not AppUpdateSchedSettingsValidator() Then
                ValidateSettings = False
            End If
        End If
    End Function

    'This method will start the service if the service is not running
    Private Sub StartService(ByVal ServiceName As String, Optional ByVal Silent As Boolean = False)
        Try
            Log.WriteTrace("Starting " & ServiceName & " Service")
            If VerifyService(ServiceName) Then
                Dim sc As New ServiceController(ServiceName, "nbefaust81")
                If sc.Status <> ServiceControllerStatus.Running Then
                    'Asks the user to see if the service should be started
                    If Silent OrElse MessageBox.Show("The " & ServiceName & " is not running." _
                        & vbCrLf & vbCrLf & "Do you want to start the service?",
                        ServiceName & " Service Message",
                        MessageBoxButtons.YesNo,
                        MessageBoxIcon.Question) = Windows.Forms.DialogResult.Yes Then
                        sc.Start()
                        sc.Refresh()

                        Dim secondsWaited As Integer = 0
                        While (sc.Status = ServiceControllerStatus.StartPending AndAlso secondsWaited < 5 * 60)
                            'wait for service to start
                            System.Threading.Thread.Sleep(1000)
                            secondsWaited += 1
                            sc.Refresh()
                        End While

                        If sc.Status <> ServiceControllerStatus.Running Then
                            MessageBox.Show("The " & ServiceName & " could not be started." & vbCrLf & vbCrLf & "Please check the error log for more details", "Error starting Service", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                        End If

                    End If
                End If
            End If
        Catch ex As Exception
            Log.WriteError("Error starting the " & ServiceName & " service.", ex)
            MessageBox.Show("The " & ServiceName & " could not be started." & vbCrLf & vbCrLf & "Please check the error log for more details", "Error starting Service", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
        End Try
    End Sub

    ''' <summary>
    ''' This method restarts the service if the service exists, 
    ''' is activated, and is currently running.
    ''' </summary>
    ''' <param name="ServiceName"></param>
    ''' <remarks></remarks>
    Private Sub RestartService(ByVal serviceName As String)

        Try
            Log.WriteTrace("ServiceManager: Restarting service " & serviceName)

            If Not VerifyService(serviceName) Then
                Log.WriteError("ServiceManager: Service " & serviceName & " does not exist.")
                Return
            End If

            ' 
            Dim isServiceActivated As Boolean = False

            Select Case serviceName
                Case Settings.TRANSFER_SVC_NAME
                    isServiceActivated = chkActivateTransferService.Checked
                Case Settings.AUTOUPDATE_SVC_NAME
                    isServiceActivated = chkDownloadAndInstallUpdates.Checked
            End Select

            If Not isServiceActivated Then
                Log.WriteError("ServiceManager: Service " & serviceName &
                                     " has not been activated - restart cancelled.")
                Return
            End If

            Dim sc As New ServiceController(serviceName)
            If sc.Status = ServiceControllerStatus.Running Then
                sc.Stop()

                ' Consider integrating a call to the following method in your Do loop. 
                ' You() 'll need to handle timeouts in the loop.
                'sc.WaitForStatus(ServiceControllerStatus.Stopped, New TimeSpan(0, 0, 5))

                Do
                    Application.DoEvents()
                    System.Threading.Thread.Sleep(100)
                    sc.Refresh()
                Loop While sc.Status <> ServiceControllerStatus.Stopped

                sc.Start()
                'System.Threading.Thread.Sleep(500)
            Else
                Log.WriteError("ServiceManager: Service " & serviceName & " currently not running. Restart skipped.")
            End If

            sc.Refresh()
        Catch ex As Exception
            Log.WriteError("Error restarting service", ex)
        End Try
    End Sub

    ''' <summary>
    ''' This method Stops the specified service if it is currently running.
    ''' </summary>
    ''' <param name="serviceName">The name of the service to stop.</param>
    ''' <remarks></remarks>
    Private Sub StopService(ByVal serviceName As String)

        Try

            Log.WriteTrace("ServiceManager: Attempting to stop the " & serviceName & " service.")
            If VerifyService(serviceName) Then
                Dim sc As New ServiceController(serviceName)
                If sc.Status = ServiceControllerStatus.Running Then
                    sc.Stop()

                    'Consider integrating a call to the following method in your Do loop.  You'll need to handle timeouts in the loop.
                    'sc.WaitForStatus(ServiceControllerStatus.Stopped, New TimeSpan(0, 0, 5))

                    Do
                        Application.DoEvents()
                        System.Threading.Thread.Sleep(100)
                        sc.Refresh()
                    Loop While sc.Status <> ServiceControllerStatus.Stopped
                Else
                    Log.WriteTrace("ServiceManager: The " & serviceName & " service is not currently running - nothing to do.")
                End If
                sc.Refresh()
            Else
                Log.WriteError("ServiceManager: The " & serviceName & " service does not exist - nothing to do.")
            End If
        Catch ex As Exception
            Log.WriteError("ServiceManager: An error occurred attempting to stop the " & serviceName & " service.", ex)

        End Try
    End Sub

    ''' <summary>
    ''' Checks if the service exists and is valid.
    ''' </summary>
    ''' <param name="serviceName"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function VerifyService(ByVal serviceName As String) As Boolean
        'get all services installed on the local computer and
        'check one by one if the NRC_SLT service exists 
        'when the service is found, stop for/each loop and return True
        'otherwise return False
        For Each scTemp As ServiceController In ServiceController.GetServices()
            If scTemp.ServiceName = serviceName Then
                Return True ' Service Exists!
            End If
        Next scTemp
        Return False ' Service Does Not Exist!
    End Function

    'Writes the status of the service to the labels
    Private Sub ServiceStatusMessage(ByVal ServiceName As String, ByRef LabelStatus As Label, ByRef LabelColor As Label, ByRef ButtonStartStop As Button)
        Try
            If VerifyService(ServiceName) Then
                Dim sc As New ServiceController(ServiceName)
                If sc.Status = ServiceControllerStatus.Running Then
                    LabelColor.ImageIndex = 1
                    LabelStatus.Text = "The " & ServiceName & " Service is currently " & sc.Status.ToString
                    ButtonStartStop.Text = "Stop"
                ElseIf sc.Status <> ServiceControllerStatus.Running Then
                    LabelColor.ImageIndex = 0
                    LabelStatus.Text = "The " & ServiceName & " Service is currently not running"
                    ButtonStartStop.Text = "Start"
                End If
                Exit Sub
            End If
        Catch ex As Exception
            Log.WriteError("Error getting status message for service " & ServiceName, ex)
        End Try
        LabelStatus.Text = "The " & ServiceName & " Service has not been installed"
        LabelColor.ImageIndex = 0
    End Sub

    'Refresh service status
    Private Sub CheckServiceStatus_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckServiceStatus.Tick
        CheckServiceStatus.Enabled = False

        'Update Service status messages
        ServiceStatusMessage(Settings.TRANSFER_SVC_NAME, lblSmartLinkServiceStatus, lblSmartLinkStatusColor, cmdSmartLinkStopStart)

        If Not System.IO.File.Exists(txtSmartLinkErrorLogFile.Text) Then
            cmdSmartLinkViewUploadedFileLog.Enabled = False
        Else
            cmdSmartLinkViewUploadedFileLog.Enabled = True
        End If

        If Not System.IO.File.Exists(txtSmartLinkUploadedFileLog.Text) Then
            cmdSmartLinkViewErrorLog.Enabled = False
        Else
            cmdSmartLinkViewErrorLog.Enabled = True
        End If

        If _refreshWebService And Not txtGeneralSmartLinkWS.Focused Then
            Try
                _webService = New WebService()

                If _webService.ValidateConnection() Then
                    lblGeneralWebServiceStatus.Text = "Web service Connected"
                    lblGeneralWebServiceStatusColor.ImageIndex = 1
                Else
                    lblGeneralWebServiceStatus.Text = "Can't connect to the URL provided; please check the log"
                    lblGeneralWebServiceStatusColor.ImageIndex = 0
                End If

                _refreshWebService = False
            Catch ex As Exception
                Log.WriteError("Error initializing the web service: " + ex.Message)
                lblGeneralWebServiceStatus.Text = "Can't connect to the URL provided; please check the log"
                lblGeneralWebServiceStatusColor.ImageIndex = 0
            End Try
        End If

        CheckServiceStatus.Enabled = True
    End Sub

    'This Function Generates the an unique InstallKey for the SmartLink installation
    Private Function GenerateInstallKey() As String
        Dim sResult As String = String.Empty

        Dim mc As System.Management.ManagementClass =
            New System.Management.ManagementClass("Win32_NetworkAdapterConfiguration")

        For Each mo As System.Management.ManagementObject In mc.GetInstances()
            'Will try to grab the first Mac Address that has both IPEnabled and DHCPEnabled
            If mo.Item("IPEnabled") = True And mo.Item("DHCPEnabled") = True Then
                Dim sAddress() As String = mo.Item("MacAddress").ToString().Split(":")
                Dim i As Integer

                sResult = String.Empty

                For i = 0 To 5
                    Dim nrandom As New System.Random(Convert.ToInt32(sAddress(i), 16))
                    sResult = sResult & convertToBase36(nrandom.Next(0, 35))
                    sResult = sResult & convertToBase36(nrandom.Next(0, 35))
                Next
                Return sResult
            ElseIf mo.Item("IPEnabled") = True And sResult = String.Empty Then
                Dim sAddress() As String = mo.Item("MacAddress").ToString().Split(":")
                Dim i As Integer

                For i = 0 To 5
                    Dim nrandom As New System.Random(Convert.ToInt32(sAddress(i), 16))
                    sResult = sResult & convertToBase36(nrandom.Next(0, 35))
                    sResult = sResult & convertToBase36(nrandom.Next(0, 35))
                Next
            End If
        Next

        Return sResult
    End Function

    Private Function convertToBase36(ByVal Number As Integer) As String
        Dim strDigits As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Dim cDigit() As Char = strDigits.ToCharArray()
        Dim strBase36number As String = String.Empty
        Dim intBase10number, intTemp As Integer

        intBase10number = Number

        While intBase10number <> 0
            intTemp = CType(Fix(intBase10number / 36), Integer)
            strBase36number = cDigit(CType(intBase10number Mod 36, Integer)) & strBase36number
            intBase10number = intTemp
        End While

        Return strBase36number
    End Function

    Private Function convertFromBase36(ByVal strNumber As String) As String

        Dim strDigits As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Dim intI As Integer = 0
        Dim lngDate As Long
        Dim cNumber() As Char

        cNumber = strNumber.Trim().ToCharArray()
        While intI < strNumber.Length()
            lngDate += strDigits.IndexOf(cNumber(intI)) * CType(Math.Pow(36, (strNumber.Length - 1) - intI), Integer)
            intI += 1
        End While

        Return "" & lngDate
    End Function

#End Region

#Region "SmartLink Transfer Code"

    'This Method reads all the settings from SLT Config File
    Private Sub ReadSmartLinkSettings()
        Try
            Log.WriteTrace("Reading SmartLink Transfer Service Settings from " & Settings.ConfigFileAbsolutePath)

            Dim uploadPath As String = Settings.GetTransferServiceSetting("Path")
            If uploadPath = String.Empty Or
                Not My.Computer.FileSystem.DirectoryExists(uploadPath) Then
                uploadPath = Path.Combine(Settings.ConfigRootDirPath, "FileUpload\Upload")
                Settings.SetTransferServiceSetting("Path", uploadPath)
            End If
            txtSmartLinkPath.Text = uploadPath

            txtSmartLinkPollingFolder1.Text = Settings.GetTransferServiceSetting("PollingFolder1")
            txtSmartLinkPollingFolder2.Text = Settings.GetTransferServiceSetting("PollingFolder2")

            cmbSmartLinkBackupFiles.Text = Settings.GetTransferServiceSetting("BackupFiles")
            txtSmartLinkBackupDirectory.Text = Settings.GetTransferServiceSetting("BackupDir")
            cmbSmartLinkLogWSFiles.Text = Settings.GetTransferServiceSetting("LogWSFiles")

            txtSmartLinkErrorLogFile.Text = Settings.GetLogFilePath(Settings.TRANSFER_SVC_NAME)
            cmdSmartLinkViewErrorLog.Enabled = True

            txtSmartLinkUploadedFileLog.Text = Settings.GetFilePath2TransferServiceSubmittedFilesLogFile()
            cmdSmartLinkViewUploadedFileLog.Enabled = True

            cmbSmartLinkTrxfrDelay.Text = Settings.GetTransferServiceSetting("TransferDelayInterval")
            cmbSmartLinkAllowFileRename.Text = Settings.GetTransferServiceSetting("AllowFileRename")

            ' Get a list of the extra polling folders
            _sExtraPollingFolders = Settings.GetTransferServicePollingFolders()

            ' Set this "Checked" property last so the event handler method disables the 
            ' controls after they have been set with their values.
            chkActivateTransferService.Checked = Settings.ConvertToBool(
                Settings.GetTransferServiceSetting("IsActivated", "False"))

        Catch ex As Exception
            Log.WriteError("Error reading " + Settings.TRANSFER_SVC_NAME + " Settings" _
                & vbCrLf & vbCrLf & ex.Message, ex)
            MessageBox.Show(ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' This Method writes all the settings for SmartLink "Transfer" service.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub WriteSmartLinkSettings()

        Try
            Log.WriteTrace("ServiceManager: Saving SmartLink Transfer Settings")

            Dim isActivated As String = "No"
            If chkActivateTransferService.Checked = True Then
                isActivated = "Yes"
            End If
            Dim theSettings As New Hashtable()

            theSettings.Add("IsActivated", isActivated)
            theSettings.Add("Path", txtSmartLinkPath.Text)
            theSettings.Add("PollingFolder1", txtSmartLinkPollingFolder1.Text)
            theSettings.Add("PollingFolder2", txtSmartLinkPollingFolder2.Text)
            theSettings.Add("BackupFiles", cmbSmartLinkBackupFiles.Text)
            theSettings.Add("BackupDir", txtSmartLinkBackupDirectory.Text)
            theSettings.Add("LogWSFiles", cmbSmartLinkLogWSFiles.Text)
            theSettings.Add("AllowFileRename", cmbSmartLinkAllowFileRename.Text)
            theSettings.Add("TransferDelayInterval", cmbSmartLinkTrxfrDelay.Text)

            ' Persist the transfer service settings to the general config file.
            Settings.SetTransferServiceSettings(theSettings)

            ' Persist the "extra polling folders" collection to the config file.
            Settings.SetTransferServicePollingFolders(_sExtraPollingFolders)

            _bTransferSvcSettingsChanged = False

            Log.WriteTrace("ServiceManager: SmartLink Transfer Settings Saved")

        Catch ex As Exception
            Log.WriteError("ServiceManager: Error Saving SLT Settings" & vbCrLf & vbCrLf & ex.Message, ex)
            MsgBox("ERROR::Saving configuration settings - " & ex.Message, MsgBoxStyle.Critical + MsgBoxStyle.Exclamation, "Error!!")
        End Try

    End Sub

    Private Sub cmdSmartLinkPath_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkPath.Click
        SelectDirectory(txtSmartLinkPath)
        ' If a new upload folder is selected, once it is persisted to the config settings,
        ' the shortcut link on the users' desktops and program menus should be updated to 
        ' reflect the new location.

        ' TODO: Update "Upload" folder shortcuts on the startmenu and desktop when applicable.

        ' The following VB script is provided as a starting point but there may be 
        ' other better ways to acheive the same result.  This functionality should be 
        ' moved ultimately to the location where settings are committed.
        ' '' VBScript.
        ''Shell = CreateObject("WScript.Shell")
        ''DesktopPath = Shell.SpecialFolders("Desktop")
        ''link = Shell.CreateShortcut(DesktopPath & "\test.lnk")
        ''link.Arguments = "1 2 3"
        ''link.Description = "test shortcut"
        ''link.HotKey = "CTRL+ALT+SHIFT+X"
        ''link.IconLocation = "app.exe,1"
        ''link.TargetPath = "c:\blah\app.exe"
        ''link.WindowStyle = 3
        ''link.WorkingDirectory = "c:\blah"
        ''link.Save()
    End Sub

    Private Sub cmdSmartLinkStopStart_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkStopStart.TextChanged
        If cmdSmartLinkStopStart.Text.ToUpper() = "START" Then
            cmdSmartLinkRestart.Enabled = False
        Else
            cmdSmartLinkRestart.Enabled = True
        End If
    End Sub

    Private Sub cmdSmartLinkPollingFolder1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkPollingFolder1.Click
        SelectDirectory(txtSmartLinkPollingFolder1)
    End Sub

    Private Sub cmdSmartLinkPollingFolder2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkPollingFolder2.Click
        SelectDirectory(txtSmartLinkPollingFolder2)
    End Sub

    Private Sub cmdSmartLinkBackupDirectory_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkBackupDirectory.Click
        SelectDirectory(txtSmartLinkBackupDirectory)
    End Sub

    Private Sub cmdSmartLinkClearPolling1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkClearPolling1.Click
        txtSmartLinkPollingFolder1.Text = ""
    End Sub

    Private Sub cmdClearPolling2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClearPolling2.Click
        txtSmartLinkPollingFolder2.Text = ""
    End Sub

    Private Sub cmdSmartLinkViewUploadedFileLog_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkViewUploadedFileLog.Click
        If System.IO.File.Exists(txtSmartLinkUploadedFileLog.Text) Then
            Dim frmSL As New frmShowLogs
            frmSL.strFile = New System.IO.StreamReader(txtSmartLinkUploadedFileLog.Text)
            frmSL.sKindofFile = "Uploaded File Log"
            frmSL.Show()
        Else
            MessageBox.Show("Uploaded File Log has not been created", "Log does not exists", MessageBoxButtons.OK, MessageBoxIcon.Information)
            cmdSmartLinkViewUploadedFileLog.Enabled = False
        End If
    End Sub

    Private Sub cmdSmartLinkViewErrorLog_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkViewErrorLog.Click
        If System.IO.File.Exists(txtSmartLinkErrorLogFile.Text) Then
            Dim frmSL As New frmShowLogs
            frmSL.strFile = New System.IO.StreamReader(txtSmartLinkErrorLogFile.Text)
            frmSL.sKindofFile = "Error Log"
            frmSL.Show()
        Else
            MessageBox.Show("Error Log has not been created", "This log does not exists", MessageBoxButtons.OK, MessageBoxIcon.Information)
            cmdSmartLinkViewErrorLog.Enabled = False
        End If
    End Sub


    Private Sub txtSmartLinkPath_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtSmartLinkPath.DoubleClick
        ActivateTextBox(sender)
    End Sub

    Private Sub txtSmartLinkPath_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSmartLinkPath.TextChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub txtSmartLinkPollingFolder1_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtSmartLinkPollingFolder1.DoubleClick
        ActivateTextBox(sender)
    End Sub

    Private Sub txtSmartLinkPollingFolder1_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSmartLinkPollingFolder1.TextChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub txtSmartLinkPollingFolder2_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtSmartLinkPollingFolder2.DoubleClick
        ActivateTextBox(sender)
    End Sub

    Private Sub txtSmartLinkPollingFolder2_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSmartLinkPollingFolder2.TextChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub cmbSmartLinkAllowFileRename_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmbSmartLinkAllowFileRename.SelectedIndexChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub cmbSmartLinkBackupFiles_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmbSmartLinkBackupFiles.SelectedIndexChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub txtSmartLinkBackupDirectory_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSmartLinkBackupDirectory.TextChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub cmbSmartLinkLogWSFiles_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmbSmartLinkLogWSFiles.SelectedIndexChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub txtSmartLinkUploadedFileLog_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSmartLinkUploadedFileLog.TextChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub txtSmartLinkErrorLogFile_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSmartLinkErrorLogFile.TextChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    Private Sub cmbSmartLinkTrxfrDelay_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbSmartLinkTrxfrDelay.TextChanged
        _bTransferSvcSettingsChanged = True
    End Sub

    'This Function Validates all the SmartLink Settings (Code pulled from old SmartLink Config Manager)
    Private Function SmartLinkSettingsValidator(Optional ByVal Silent As Boolean = False) As Boolean

        ' If the transfer service is not activated skip validation and return success.
        If Not chkActivateTransferService.Checked Then
            ' NOTE: If the service hasn't been activated we don't care whether the settings
            ' pass validation - they won't be used by the service. Assume validation passed and exit.
            Return True
        End If

        Dim sPath As String
        Dim sAppPath As String = My.Application.Info.DirectoryPath & "\FileUpload"
        Dim SettingsAreValid As Boolean

        SettingsAreValid = True

        sPath = Me.txtSmartLinkPath.Text

        Log.WriteTrace("Validating " + Settings.TRANSFER_SVC_NAME + " Settings")

        If sPath = String.Empty Or
            sPath.ToUpper = Me.txtSmartLinkBackupDirectory.Text.ToUpper Or
            sPath.ToUpper = Me.txtSmartLinkPollingFolder1.Text.ToUpper Or
            sPath.ToUpper = Me.txtSmartLinkPollingFolder2.Text.ToUpper Or
            sPath.ToUpper = UCase(sAppPath & "\Errors") Or
            sPath.ToUpper = UCase(sAppPath & "\Work") Or
            (InStr(sPath, "\\") > 0) Or
            sPath.ToUpper Like "?:\" Then


            If Not Silent Then
                MessageBox.Show("The main polling folder location should be local, not a network path " & vbCrLf &
                    "and should not be the same as one of the other NRC SLT application folders.",
                    "NRC SLT Config", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            End If
            SettingsAreValid = False
        End If


        sPath = Me.txtSmartLinkBackupDirectory.Text

        If cmbSmartLinkBackupFiles.Text.ToUpper = "YES" And (sPath = String.Empty Or
            sPath.ToUpper = Me.txtSmartLinkPath.Text.ToUpper Or
            sPath.ToUpper = Me.txtSmartLinkPollingFolder1.Text.ToUpper Or
            sPath.ToUpper = Me.txtSmartLinkPollingFolder2.Text.ToUpper Or
            sPath.ToUpper = UCase(sAppPath & "\Errors") Or
            sPath.ToUpper = UCase(sAppPath & "\Work") Or
            (InStr(sPath, "\\") > 0) Or
            sPath.ToUpper Like "?:\") Then

            If Not Silent Then
                MessageBox.Show("The backup folder location should be local, not a network path " & vbCrLf &
                                "and should not be the same as one of the other " + Settings.TRANSFER_SVC_NAME + " application folders.",
                                "NRC SLT Config", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            End If
            SettingsAreValid = False
        End If

        sPath = Me.txtSmartLinkPollingFolder1.Text

        If sPath.Length > 0 And
            (sPath.ToUpper = Me.txtSmartLinkBackupDirectory.Text.ToUpper Or
            sPath.ToUpper = Me.txtSmartLinkPath.Text.ToUpper Or
            sPath.ToUpper = Me.txtSmartLinkPollingFolder2.Text.ToUpper Or
            sPath.ToUpper = UCase(sAppPath & "\Errors") Or
            sPath.ToUpper = UCase(sAppPath & "\Work") Or
            sPath.ToUpper Like "?:\") Then

            If Not Silent Then
                MessageBox.Show("PollingFolder1 location should not be the same " & vbCrLf &
                                "as one of the other SmartLink application folders.",
                                "NRC " + Settings.TRANSFER_SVC_NAME + " Config", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            End If
            SettingsAreValid = False
        End If

        sPath = Me.txtSmartLinkPollingFolder2.Text

        If sPath.Length > 0 And
            (sPath.ToUpper = Me.txtSmartLinkBackupDirectory.Text.ToUpper Or
            sPath.ToUpper = Me.txtSmartLinkPollingFolder1.Text.ToUpper Or
            sPath.ToUpper = Me.txtSmartLinkPath.Text.ToUpper Or
            sPath.ToUpper = UCase(sAppPath & "\Errors") Or
            sPath.ToUpper = UCase(sAppPath & "\Work") Or
            sPath.ToUpper Like "?:\") Then

            If Not Silent Then
                MessageBox.Show("PollingFolder2 location should not be the same " & vbCrLf &
                                "as one of the other " + Settings.TRANSFER_SVC_NAME + " application folders.",
                                "NRC SLT Config", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            End If
            SettingsAreValid = False
        End If

        If _sExtraPollingFolders.Length > 0 Then
            Dim iCounter As Integer
            For iCounter = 0 To _sExtraPollingFolders.Length - 1
                sPath = _sExtraPollingFolders(iCounter)

                If sPath.Length > 0 And
                    (sPath.ToUpper = Me.txtSmartLinkBackupDirectory.Text.ToUpper Or
                    sPath.ToUpper = Me.txtSmartLinkPollingFolder1.Text.ToUpper Or
                    sPath.ToUpper = Me.txtSmartLinkPollingFolder2.Text.ToUpper Or
                    sPath.ToUpper = Me.txtSmartLinkPath.Text.ToUpper Or
                    sPath.ToUpper = UCase(sAppPath & "\Errors") Or
                    sPath.ToUpper = UCase(sAppPath & "\Work") Or
                    sPath.ToUpper Like "?:\") Then
                    If Not Silent Then
                        MessageBox.Show("The extra polling folder '" & sPath & "' should not be the same as one of the other " + Settings.TRANSFER_SVC_NAME + " application folders.",
                            "NRC SLT Config", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                    End If
                    SettingsAreValid = False
                    Exit For
                End If
            Next
        End If

        Try
            If SettingsAreValid Then
                'Be sure the selected directories exists and create them if needed
                If txtSmartLinkBackupDirectory.Text.Length > 0 Then
                    If Not My.Computer.FileSystem.DirectoryExists(txtSmartLinkBackupDirectory.Text) Then
                        My.Computer.FileSystem.CreateDirectory(txtSmartLinkBackupDirectory.Text)
                    End If
                End If

                If txtSmartLinkPath.Text.Length > 0 Then
                    If Not My.Computer.FileSystem.DirectoryExists(txtSmartLinkPath.Text) Then
                        My.Computer.FileSystem.CreateDirectory(txtSmartLinkPath.Text)
                    End If
                End If

                If txtSmartLinkPollingFolder1.Text.Length > 0 Then
                    If Not My.Computer.FileSystem.DirectoryExists(txtSmartLinkPollingFolder1.Text) Then
                        My.Computer.FileSystem.CreateDirectory(txtSmartLinkPollingFolder1.Text)
                    End If
                End If

                If txtSmartLinkPollingFolder2.Text.Length > 0 Then
                    If Not My.Computer.FileSystem.DirectoryExists(txtSmartLinkPollingFolder2.Text) Then
                        My.Computer.FileSystem.CreateDirectory(txtSmartLinkPollingFolder2.Text)
                    End If
                End If
            End If

        Catch ex As Exception
            If Not Silent Then
                MessageBox.Show("Validating Settings - ERROR: 1100 - " & ex.Message, "NRC SLT", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
            SettingsAreValid = False
        End Try

        Return SettingsAreValid

    End Function

    Private Sub cmdSmartLinkExtraPollingFolders_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkExtraPollingFolders.Click
        frmExtraPollingFolders.ExtraPollingFolders = _sExtraPollingFolders
        If frmExtraPollingFolders.ShowDialog() = Windows.Forms.DialogResult.OK Then
            _sExtraPollingFolders = frmExtraPollingFolders.ExtraPollingFolders
            _bTransferSvcSettingsChanged = True
        End If
    End Sub

    Private Sub cmdSmartLinkStopStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkStopStart.Click
        cmdSmartLinkStopStart.Enabled = False
        Application.DoEvents()

        If cmdSmartLinkStopStart.Text.ToUpper() = "STOP" Then
            StopService(Settings.TRANSFER_SVC_NAME)
        Else
            If SmartLinkSettingsValidator() And GeneralSettingsValidator() Then
                If (_bTransferSvcSettingsChanged Or _bGeneralSettingsChanged) AndAlso PromptSaveSettings(Settings.TRANSFER_SVC_NAME) Then
                    SaveSettings(Settings.TRANSFER_SVC_NAME)
                End If

                StartService(Settings.TRANSFER_SVC_NAME, True)
            End If
        End If

        cmdSmartLinkStopStart.Enabled = True
    End Sub

    Private Sub cmdSmartLinkRestart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSmartLinkRestart.Click
        If SmartLinkSettingsValidator() And GeneralSettingsValidator() Then
            If (_bTransferSvcSettingsChanged Or _bGeneralSettingsChanged) AndAlso PromptSaveSettings(Settings.TRANSFER_SVC_NAME) Then
                SaveSettings(Settings.TRANSFER_SVC_NAME)
            End If

            RestartService(Settings.TRANSFER_SVC_NAME)
        End If
    End Sub
#End Region

#Region "NRC_General Settings"
    ''' <summary>
    ''' Reads the "general" and "auto update" functionality settings from the general 
    ''' config and loads the values into the appropriate user controls.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ReadGeneralSettings()
        txtConfigRootPath.Text = Settings.ConfigRootDirPath

        txtGeneralSmartLinkWS.Text = Settings.GetGeneralSetting("SmartLinkWS", "http://localhost:1619/SmartLinkWS.asmx")
        txtGeneralProxyUsername.Text = Settings.GetGeneralSetting("ProxyUser", "")
        txtGeneralProxyPassword.Text = Settings.GetGeneralSetting("ProxyPswrd", "")
        txtGeneralProxyDomain.Text = Settings.GetGeneralSetting("ProxyDomain", "")
        txtGeneralProxyPort.Text = Settings.GetGeneralSetting("ProxyPort", "")
        txtGeneralProxyIPAddress.Text = Settings.GetGeneralSetting("ProxyIP", "")

        Dim proxyEnabled As String =
            Settings.GetGeneralSetting("ProxyEnabled", "No").ToUpper()

        If proxyEnabled <> "NO" And proxyEnabled <> "FALSE" Then
            chkGeneralProxy.Checked = True
        Else
            chkGeneralProxy.Checked = False
            grpGeneralProxySettings.Enabled = False
        End If

        txtGeneralSMTPServer.Text = Settings.GetGeneralSetting("SMTPServer", "")
        txtGeneralOperatorEmail.Text = Settings.GetGeneralSetting("OperatorEmail", "")
        txtGeneralProviderNumber.Text = Settings.GetGeneralSetting("ProviderNumber", "")
        txtGeneralInstallKey.Text = Settings.GetGeneralSetting("InstallKey", "")
        txtGeneralAgencyID.Text = Settings.GetGeneralSetting("AgencyID", "")

        If txtGeneralInstallKey.Text.Trim = String.Empty Then
            txtGeneralInstallKey.Text = GenerateInstallKey()
        End If

        ' SmartLink application suite "auto download/install" settings.
        chkDownloadAndInstallUpdates.Checked = Settings.GetGeneralSetting("AutoDownloadAndInstallUpdates", "False")
        cmbAppUpdateScheduleType.SelectedItem = Settings.GetGeneralSetting("AutoUpdateInterval", "Daily")
        txtAppUpdateScheduleInterval.Text = Settings.GetGeneralSetting("AutoUpdateIntervalModifier", "")
        dpAppUpdateTime.Value = DateTime.Parse("2010-01-01 " & Settings.GetGeneralSetting("AutoUpdateTime", "1:00 AM"))
        txtAppUpdateScheduleWeeklyDays.Text = Settings.GetGeneralSetting("AutoUpdateWeeklyDays", "")

        ' Need to ensure the HasChanges flag is set to its default value of False
        _bGeneralSettingsChanged = False

        Try
            _webService = New WebService()
        Catch ex As Exception
            Log.WriteError("Error initializing the web service: " + ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' Writes/persists the "general" and "auto update" functionality 
    ''' settings into the general config file.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub WriteGeneralSettings()
        Try
            Dim theSettings As New Hashtable()

            theSettings.Add("SmartLinkWS", txtGeneralSmartLinkWS.Text)
            theSettings.Add("ProxyUser", txtGeneralProxyUsername.Text)
            theSettings.Add("ProxyPswrd", txtGeneralProxyPassword.Text)
            theSettings.Add("ProxyDomain", txtGeneralProxyDomain.Text)
            theSettings.Add("ProxyPort", txtGeneralProxyPort.Text)
            theSettings.Add("ProxyIP", txtGeneralProxyIPAddress.Text)
            If chkGeneralProxy.Checked = True Then
                theSettings.Add("ProxyEnabled", "Yes")
            Else
                theSettings.Add("ProxyEnabled", "No")
            End If

            theSettings.Add("SMTPServer", txtGeneralSMTPServer.Text)
            theSettings.Add("OperatorEmail", txtGeneralOperatorEmail.Text)
            theSettings.Add("ProviderNumber", txtGeneralProviderNumber.Text)
            theSettings.Add("InstallKey", txtGeneralInstallKey.Text)
            theSettings.Add("AgencyID", txtGeneralAgencyID.Text)

            theSettings.Add("AutoDownloadAndInstallUpdates", chkDownloadAndInstallUpdates.Checked.ToString())
            theSettings.Add("AutoUpdateInterval", cmbAppUpdateScheduleType.SelectedItem)
            theSettings.Add("AutoUpdateIntervalModifier", txtAppUpdateScheduleInterval.Text)
            theSettings.Add("AutoUpdateTime", dpAppUpdateTime.Value.ToString("h:mm tt"))
            theSettings.Add("AutoUpdateWeeklyDays", txtAppUpdateScheduleWeeklyDays.Text)

            Settings.SetGeneralSettings(theSettings)

            _bGeneralSettingsChanged = False

        Catch ex As Exception
            Log.WriteError("ServiceManager: Error Saving General Settings" & vbCrLf & vbCrLf & ex.Message, ex)
            MsgBox("ERROR::Saving configuration settings - " & ex.Message,
                   MsgBoxStyle.Critical + MsgBoxStyle.Exclamation, "Error!!")
        End Try

        Try
            ' Check if the end-user has specified a new config folder location.
            ' NOTE: Using Path.GetDirectoryName() to ensure both paths are consistant with their path end caps (i.e. the "\" at the end)
            If Path.GetDirectoryName(Settings.ConfigRootDirPath) <> Path.GetDirectoryName(txtConfigRootPath.Text) Then
                ' If so, move all the files and subfolders in the current location 
                ' to the new location and update the config root dir path in the 
                ' registry and SL_Paths.xml file.
                Settings.MoveConfigRootDirAndContentsToNewLocation(txtConfigRootPath.Text)
            End If
        Catch ex As Exception
            Log.WriteError("ServiceManager: Error relocating the application's root config folder" & Environment.NewLine & Environment.NewLine & ex.Message, ex)
            MsgBox("ERROR::Updating Config Root Path - " & ex.Message,
                   MsgBoxStyle.Critical + MsgBoxStyle.Exclamation, "Error!!")
        End Try
    End Sub


    Private Function GeneralSettingsValidator(Optional ByVal Silent As Boolean = False) As Boolean

        GeneralSettingsValidator = True

        Log.WriteTrace("Validating General Settings")

        'Validating txtDBXProviderNumber value
        If Not txtGeneralProviderNumber.ReadOnly Then
            If Me.txtGeneralProviderNumber.Text.Length = 0 Or Me.txtGeneralProviderNumber.Text = "1234567" Then
                If Not Silent Then
                    MessageBox.Show("Please enter a unique identifier that does not equal '1234567' " & vbCrLf &
                                    "and is not blank. This will help us trouble shoot potential problems",
                                    "General Config", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                End If
                GeneralSettingsValidator = False
            End If
        End If

        'Validating txtDBXAgencyID value
        If Not txtGeneralAgencyID.ReadOnly Then
            If Me.txtGeneralAgencyID.Text.Length <> 6 Then
                If Not Silent Then
                    MessageBox.Show("Please enter your 6 digit Agency ID (OASIS Item M0010). " & vbCrLf &
                                    "This will help us trouble shoot potential problems",
                                    "General Config", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                End If
                GeneralSettingsValidator = False
            End If
        End If

        'Validating txtDBXAgencyID value
        If Not txtGeneralAgencyID.ReadOnly Then
            If Not IsNumeric(Me.txtGeneralAgencyID.Text) Then
                If Not Silent Then
                    MessageBox.Show("Agency ID must be numeric.", "General Config", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                End If
                GeneralSettingsValidator = False
            End If
        End If

        'Validating txtGeneralOperatorEmail value
        If txtGeneralOperatorEmail.Text.Trim <> "" Then
            Dim iEmailCount As Integer = 0
            Try
                Dim maTest As MailAddress
                Dim sEmails(0) As String
                If txtGeneralOperatorEmail.Text <> String.Empty Then
                    If txtGeneralOperatorEmail.Text.IndexOf(",") >= 0 Then
                        sEmails = txtGeneralOperatorEmail.Text.Split(",")
                    Else
                        Array.Resize(sEmails, 1)
                        sEmails(0) = txtGeneralOperatorEmail.Text
                    End If
                    For iEmailCount = 0 To sEmails.Length - 1
                        maTest = New MailAddress(sEmails(iEmailCount))
                    Next

                End If
            Catch ex As Exception
                If Not Silent Then
                    MessageBox.Show("Invalid value for setting 'Send Email to'" _
                        & vbCrLf & vbCrLf & "Please use a valid email address", "General tab settings", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
                GeneralSettingsValidator = False
            End Try
        End If
    End Function

    Private Sub txtGeneralSmartLinkWS_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtGeneralSmartLinkWS.DoubleClick
        txtGeneralSmartLinkWS.ReadOnly = False
    End Sub

    Private Sub txtGeneralSmartLinkWS_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralSmartLinkWS.TextChanged
        Settings.SetGeneralSetting("SmartLinkWS", txtGeneralSmartLinkWS.Text)
        _bGeneralSettingsChanged = True
        _refreshWebService = True
    End Sub

    Private Sub chkSharedProxy_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkGeneralProxy.CheckedChanged
        If chkGeneralProxy.Checked Then
            grpGeneralProxySettings.Enabled = True
            Settings.SetGeneralSetting("ProxyEnabled", "Yes")
        Else
            grpGeneralProxySettings.Enabled = False
            Settings.SetGeneralSetting("ProxyEnabled", "No")
        End If
        _refreshWebService = True
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtSharedProxyIPAddress_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralProxyIPAddress.TextChanged
        Settings.SetGeneralSetting("ProxyIP", txtGeneralProxyIPAddress.Text)
        _refreshWebService = True
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtSharedProxyPort_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralProxyPort.TextChanged
        Settings.SetGeneralSetting("ProxyPort", txtGeneralProxyPort.Text)
        _refreshWebService = True
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtSharedProxyDomain_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralProxyDomain.TextChanged
        Settings.SetGeneralSetting("ProxyDomain", txtGeneralProxyDomain.Text)
        _refreshWebService = True
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtSharedProxyUsername_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralProxyUsername.TextChanged
        Settings.SetGeneralSetting("ProxyUser", txtGeneralProxyUsername.Text)
        _refreshWebService = True
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtSharedProxyPassword_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralProxyPassword.TextChanged
        Settings.SetGeneralSetting("ProxyPswrd", txtGeneralProxyPassword.Text)
        ShowGeneralPasswordStatusMessage()
        If txtGeneralProxyPassword2.Visible = False Then
            txtGeneralProxyPassword2.Text = Settings.GetGeneralSetting("ProxyPswrd", "")
            txtGeneralProxyPassword2.Visible = True
            lblGeneralRetryPassword.Visible = True
        End If
        _refreshWebService = True
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtSharedProxyPassword2_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralProxyPassword2.TextChanged
        ShowGeneralPasswordStatusMessage()
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub ShowGeneralPasswordStatusMessage()
        If txtGeneralProxyPassword.Text = "" Or txtGeneralProxyPassword2.Text = "" Then
            lblGeneralPasswordMessage.Text = ""
            lblGeneralPasswordStatusColor.Visible = False
            Exit Sub
        Else
            lblGeneralPasswordStatusColor.Visible = True
        End If

        If txtGeneralProxyPassword2.Text <> txtGeneralProxyPassword.Text Then
            lblGeneralPasswordMessage.Text = "Passwords don't match"
            lblGeneralPasswordStatusColor.ImageIndex = 0
        Else
            lblGeneralPasswordMessage.Text = "Matching Passwords"
            lblGeneralPasswordStatusColor.ImageIndex = 1
        End If
    End Sub

    Private Sub txtGeneralSMTPServer_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralSMTPServer.TextChanged
        If txtGeneralSMTPServer.Text <> String.Empty And txtGeneralOperatorEmail.Text <> String.Empty And txtGeneralOperatorEmail.ReadOnly = False Then
            cmdGeneralTestEmail.Enabled = True
        Else
            cmdGeneralTestEmail.Enabled = False
        End If
        Settings.SetGeneralSetting("SMTPServer", txtGeneralSMTPServer.Text)
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtGeneralOperatorEmail_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralOperatorEmail.TextChanged
        If txtGeneralSMTPServer.Text <> String.Empty And txtGeneralOperatorEmail.Text <> String.Empty And txtGeneralOperatorEmail.ReadOnly = False Then
            cmdGeneralTestEmail.Enabled = True
        Else
            cmdGeneralTestEmail.Enabled = False
        End If
        Settings.SetGeneralSetting("OperatorEmail", txtGeneralOperatorEmail.Text.Trim)
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub cmdGeneralTestEmail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdGeneralTestEmail.Click
        TestEmail(txtGeneralSMTPServer.Text, txtGeneralOperatorEmail.Text)
    End Sub

    Private Sub txtGeneralProviderNumber_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralProviderNumber.TextChanged
        Settings.SetGeneralSetting("ProviderNumber", txtGeneralProviderNumber.Text)
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtGeneralAgencyID_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralAgencyID.TextChanged
        Settings.SetGeneralSetting("AgencyID", txtGeneralAgencyID.Text)
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtGeneralInstallKey_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGeneralInstallKey.TextChanged
        Settings.SetGeneralSetting("InstallKey", txtGeneralInstallKey.Text)
        _bGeneralSettingsChanged = True
    End Sub

#End Region

#Region "Automatic Application Update"

    Private Sub AppUpdateIntervalChanges()

        If cmbAppUpdateScheduleType.Text = "Daily" Then

            'Hides Weekly options
            lblAppUpdateScheduleWeeklyDays.Visible = False
            txtAppUpdateScheduleWeeklyDays.Visible = False
            cmdAppUpdateWeekdaysDetails.Visible = False

            Try
                If Convert.ToInt32("0" & txtAppUpdateScheduleInterval.Text) <> 1 Then
                    lblAppUpdateScheduleType.Text = "Days"
                Else
                    lblAppUpdateScheduleType.Text = "Day"
                End If

            Catch ex As Exception
                lblAppUpdateScheduleType.Text = "Days"
            End Try

        Else
            'Unhides Weekly options
            lblAppUpdateScheduleWeeklyDays.Visible = True
            txtAppUpdateScheduleWeeklyDays.Visible = True
            cmdAppUpdateWeekdaysDetails.Visible = True

            Try
                If Convert.ToInt32("0" & txtAppUpdateScheduleInterval.Text) <> 1 Then
                    lblAppUpdateScheduleType.Text = "Weeks"
                Else
                    lblAppUpdateScheduleType.Text = "Week"
                End If
            Catch ex As Exception
                lblAppUpdateScheduleType.Text = "Weeks"
            End Try

        End If

        ' General settings have changed; services will be restarted 
        ' if necessary when settings are persisted.
        _bGeneralSettingsChanged = True

    End Sub

    Private Sub ClearAppUpdateSchedCtls()

        chkDownloadAndInstallUpdates.Checked = False

        cmbAppUpdateScheduleType.Text = "Daily"
        txtAppUpdateScheduleInterval.Text = String.Empty
        txtAppUpdateScheduleWeeklyDays.Text = String.Empty
        'dpAppUpdateTime.Value() ' use the time portion of the selected DateTime value. 

        AppUpdateIntervalChanges()
    End Sub

    Private Sub cmbAppUpdateScheduleType_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmbAppUpdateScheduleType.SelectedIndexChanged
        AppUpdateIntervalChanges()
    End Sub

    Private Sub txtAppUpdateScheduleInterval_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtAppUpdateScheduleInterval.TextChanged
        AppUpdateIntervalChanges()
    End Sub

    Private Sub cmdAppUpdateWeekdaysDetails_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdAppUpdateWeekdaysDetails.Click
        frmWeekdaysDetails.WeekDays = txtAppUpdateScheduleWeeklyDays.Text
        If frmWeekdaysDetails.ShowDialog = Windows.Forms.DialogResult.OK Then
            txtAppUpdateScheduleWeeklyDays.Text = frmWeekdaysDetails.WeekDays
        End If
    End Sub

    Private Sub txtConfigRootPath_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtConfigRootPath.TextChanged
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub txtAppUpdateScheduleWeeklyDays_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtAppUpdateScheduleWeeklyDays.TextChanged
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub dpAppUpdateTime_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles dpAppUpdateTime.ValueChanged
        _bGeneralSettingsChanged = True
    End Sub

    Private Sub chkDownloadAndInstallUpdates_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkDownloadAndInstallUpdates.CheckedChanged
        _bGeneralSettingsChanged = True

        ' TODO: Stop autoupdater service
        ' TODO: Restart autoupdater service to reload configuration settings.

        ' Enable/disable the update scheduling settings appropriately
        ' according to whether or not "auto check/download" is checked.
        grpUpdateSchedule.Enabled = chkDownloadAndInstallUpdates.Checked

        ' If auto-check/download is not enabled then clear the settings.
        If Not chkDownloadAndInstallUpdates.Checked Then
            ClearAppUpdateSchedCtls()
        End If
    End Sub

    Private Function AppUpdateSchedSettingsValidator(Optional ByVal validateSilently As Boolean = False) As Boolean
        Dim isValid As Boolean = True

        If chkDownloadAndInstallUpdates.Checked Then
            If txtAppUpdateScheduleInterval.Text.Length = 0 Then
                isValid = False
            ElseIf Not IsNumeric(txtAppUpdateScheduleInterval.Text) Then
                isValid = False
            End If

            If txtAppUpdateScheduleWeeklyDays.Visible Then
                If txtAppUpdateScheduleWeeklyDays.Text = "" Then
                    isValid = False
                End If
            End If

            If Not isValid And Not validateSilently Then
                Dim intAnswer As Integer = MessageBox.Show(
                    "The application update schedule is incomplete. " & vbCrLf & vbCrLf &
                    "If you do not finish entering the schedule parameters " & vbCrLf &
                    "then automatic application updates will be turned off." & vbCrLf & vbCrLf &
                    "Do you wish to continue entering the schedule parameters?",
                    "Application Update Schedule Validation",
                    MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1)

                If intAnswer = vbYes Then
                    tabSettings.SelectedTab = tabUpdate
                    cmbAppUpdateScheduleType.Show()
                    isValid = False
                Else
                    ' The end-user answered "no" - they don't want to continued entering the schedule.
                    ' Reset the auto check/download updates checkbox to unchecked.
                    chkDownloadAndInstallUpdates.Checked = False
                    ' With update checks turned off the settings are 
                    ' reset and consequently pass validation.
                    isValid = True
                End If
            End If
        End If

        Return isValid
    End Function

#End Region

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub

    ''' <summary>
    ''' This method should check for and download the latest auto-updater application update.
    ''' </summary>
    ''' <remarks>The auto updater application service should change infrequently but needs to be updated when appropriate.</remarks>
    Private Sub CheckForUpdaterAppUpdate()

    End Sub

    Private Sub cmdCheck4Update_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCheck4Update.Click
        cmdCheck4Update.Enabled = False

        UpdateProgressStatus("Contacting the server to check for any application updates.")

        Dim clientId As String = Settings.GetGeneralSetting("ProviderNumber")
        Dim currentVersion As String = Settings.GetGeneralSetting("InstalledSmartLinkVersion")
        Dim newVersion As String = Nothing
        Dim url As String = Nothing
        Dim fileName As String = Nothing
        Dim checksum As String = Nothing
        Dim isUpdateAvailable As Boolean

        If _webService Is Nothing Then
            Log.WriteError("Unable to check for application updates because web service has not been initialized properly")
            UpdateProgressStatus("Unable to check for application updates because web service has not been initialized properly")
            Return
        End If

        Try
            isUpdateAvailable = _webService.CheckForNewVersion(clientId, currentVersion, newVersion, url, fileName, checksum)
        Catch ex As Exception
            UpdateProgressStatus(ex.Message)
        End Try

        If isUpdateAvailable Then
            UpdateProgressStatus("An update is available.")

            Dim result As DialogResult = MessageBox.Show(
                "An update is available.  Would you like to download and install it now?",
                "SmartLink Update", MessageBoxButtons.YesNo)

            If result = Windows.Forms.DialogResult.Yes Then
                UpdateProgressStatus("Download and installation beginning.")
                Try
                    AutoUpdaterService.DownloadInstallUpdate(newVersion, url, fileName, checksum, False)
                Catch ex As Exception
                    UpdateProgressStatus(ex.Message)
                End Try
                UpdateProgressStatus("Installation is in progress ...")
            Else
                ' No?
                UpdateProgressStatus("The update can be installed manually later, or will be installed next time the autoupdater runs.")
            End If
        Else
            UpdateProgressStatus("No updates available at this time.")
        End If

        cmdCheck4Update.Enabled = True
        UpdateVersionText()
    End Sub

    Private Function ConfirmSmartLinkUpdateIsNewerVersion(ByVal updateVersion As String)
        Dim isNewerVersion As Boolean = False
        If Not String.IsNullOrEmpty(updateVersion) Then
            Dim currentVersion As String = Settings.GetGeneralSetting("InstalledSmartLinkVersion")
            If String.IsNullOrEmpty(currentVersion) Then
                Log.WriteError("Unable to confirm if the SmartLink application update is a newer version: <InstalledSmartLinkVersion> = Nothing")
            Else

                Try
                    ' Is the update a newer version than the currently installed version?
                    isNewerVersion = (New Version(updateVersion) > New Version(currentVersion))
                Catch ex As Exception
                    ' http://msdn.microsoft.com/en-us/library/y0hf9t2e(VS.90).aspx
                    Log.WriteError("Unable to confirm if the SmartLink application update is a newer version:  The version is in a format that cannot be parsed properly.", ex)
                End Try
            End If
        Else
            Log.WriteError("Unable to confirm if the SmartLink application update is a newer version: [updateVersion = Nothing]")
        End If
        Return isNewerVersion
    End Function

    Private Sub UpdateProgressStatus(ByVal msg As String)
        If txtBoxCheckUpdateProgress.TextLength > 0 Then
            txtBoxCheckUpdateProgress.AppendText(vbCrLf)
        End If
        txtBoxCheckUpdateProgress.AppendText(msg)
        Dim MAX_PROGRESS_SIZE As Integer = 100
        If txtBoxCheckUpdateProgress.Lines.Length > MAX_PROGRESS_SIZE Then
            Dim trunc(0 To MAX_PROGRESS_SIZE - 1) As String
            Array.Copy(txtBoxCheckUpdateProgress.Lines, (txtBoxCheckUpdateProgress.Lines.Length - MAX_PROGRESS_SIZE), trunc, 0, MAX_PROGRESS_SIZE)
            txtBoxCheckUpdateProgress.Lines = trunc
        End If
        txtBoxCheckUpdateProgress.Refresh()

        Log.WriteTrace(msg)
    End Sub

    Private Sub UpdateSmartLinkApplication(ByVal installer As String)

        Dim systemFolderPath As String = String.Empty

        Try
            ' Resolve the full path to the msiexec.exe application on the 
            ' current system (i.e. NT, XP, Vista all may have different paths to the exe).
            systemFolderPath = Environment.GetFolderPath(Environment.SpecialFolder.System)

            ' We may have had the credentials to make the previous call but 
            ' it may not have returned the appropriate value, throw the exception
            ' manually so the trace event will get logged and this subroutine exits.
            If String.IsNullOrEmpty(systemFolderPath) Then
                Throw New DirectoryNotFoundException("Unable to resolve the system folder path.")
            End If
        Catch ex As Exception
            Dim exMsg As String = "Unable to continue with upgrade of the SmartLink application. " &
                "An exception occurred while attempting to resolve the location of the system folder."

            Log.WriteError(exMsg & Environment.NewLine & Environment.NewLine & ex.Message)

            MessageBox.Show(exMsg, "SmartLink Update Cancelled", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End Try

        Dim p As New System.Diagnostics.Process()
        p.StartInfo = New ProcessStartInfo()

        With p.StartInfo
            .FileName = Path.Combine(systemFolderPath, "msiexec.exe")

            '' Construct the msiexec.exe command line parameter string appropriately.
            ' http://msdn.microsoft.com/en-us/library/aa367988(VS.85).aspx
            .Arguments = "/i """ & installer & """ /passive TARGETDIR=""" & My.Application.Info.DirectoryPath & """"

            ' If you want to automatically create a install log file for troubleshooting then
            ' comment out the .Arguments line above and construct the installer log full file
            ' name/path and incorporate it into the new command line arguments (see below).
            'Dim installLogFilePath As String = _
            '    Path.Combine(Path.GetDirectoryName(installer), "install.log")
            '.Arguments = "/i """ & installer & """ /passive /l*vx """ & installLogFilePath & """ TARGETDIR=""" & My.Application.Info.DirectoryPath & """"

            .UseShellExecute = True
            '.WindowStyle = ProcessWindowStyle.Hidden
        End With

        ' If the user is applying the update clear any settings changed flag.
        ' Too late to validate and persist changes now. 
        'TODO: Add settings validation and persistance UI workflow as a pre-update event.
        _bGeneralSettingsChanged = False
        _bExtractorSvcSettingsChanged = False
        _bTransferSvcSettingsChanged = False

        ' Applying update to application so no need to process service state 
        ' (i.e. Don't ask the user if they want to start services that should
        ' be running if they are installing a new version of SmartLink).
        _processServicesOnFormClosing = False

        Log.WriteTrace("Running application update installer package; Service Manager shutting down for application update.")
        p.Start()
        Me.Close()
    End Sub

    Private Sub chkActivateExtractorService_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
        _bExtractorSvcSettingsChanged = True
        'NOTE when unchecked and persisted the services should be stopped if running!
    End Sub

    Private Sub chkActivateTransferService_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkActivateTransferService.CheckedChanged
        _bTransferSvcSettingsChanged = True
        pnlTransferSvc.Enabled = chkActivateTransferService.Checked
        'NOTE when unchecked and persisted the services should be stopped if running!
    End Sub

    Private Sub cmdConfigRootPath_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdConfigRootPath.Click
        SelectDirectory(txtConfigRootPath)
    End Sub

    Private Sub UpdateVersionText()
        Dim ver As String = Settings.GetGeneralSetting("InstalledSmartLinkVersion")
        If String.IsNullOrEmpty(ver) Then
            ver = "<unknown>"
        End If
        Dim lastChecked As String = Settings.GetGeneralSetting("AutoUpdateLastCheck")
        If String.IsNullOrEmpty(lastChecked) Then
            lastChecked = "<unknown>"
        End If
        lblVersionInfo.Text = "Currently installed version: " + ver + vbCrLf + "Last checked: " + lastChecked

    End Sub

End Class
