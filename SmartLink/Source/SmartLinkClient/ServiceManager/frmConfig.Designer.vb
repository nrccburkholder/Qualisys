<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmConfig
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmConfig))
        Me.ttInfo = New System.Windows.Forms.ToolTip(Me.components)
        Me.cmdSmartLinkPath = New System.Windows.Forms.Button()
        Me.cmdSmartLinkPollingFolder1 = New System.Windows.Forms.Button()
        Me.cmdSmartLinkPollingFolder2 = New System.Windows.Forms.Button()
        Me.cmdSmartLinkBackupDirectory = New System.Windows.Forms.Button()
        Me.cmdSmartLinkViewUploadedFileLog = New System.Windows.Forms.Button()
        Me.cmdSmartLinkViewErrorLog = New System.Windows.Forms.Button()
        Me.cmbSmartLinkBackupFiles = New System.Windows.Forms.ComboBox()
        Me.cmbSmartLinkLogWSFiles = New System.Windows.Forms.ComboBox()
        Me.cmbSmartLinkAllowFileRename = New System.Windows.Forms.ComboBox()
        Me.cmdSmartLinkClearPolling1 = New System.Windows.Forms.Button()
        Me.cmdClearPolling2 = New System.Windows.Forms.Button()
        Me.txtSmartLinkBackupDirectory = New System.Windows.Forms.TextBox()
        Me.Label23 = New System.Windows.Forms.Label()
        Me.Label19 = New System.Windows.Forms.Label()
        Me.Label18 = New System.Windows.Forms.Label()
        Me.Label13 = New System.Windows.Forms.Label()
        Me.txtSmartLinkPollingFolder2 = New System.Windows.Forms.TextBox()
        Me.Label14 = New System.Windows.Forms.Label()
        Me.txtSmartLinkPollingFolder1 = New System.Windows.Forms.TextBox()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.txtSmartLinkPath = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.lblTrxfrDelay = New System.Windows.Forms.Label()
        Me.lblAppUpdateScheduleType = New System.Windows.Forms.Label()
        Me.cmdAppUpdateWeekdaysDetails = New System.Windows.Forms.Button()
        Me.cmbAppUpdateScheduleType = New System.Windows.Forms.ComboBox()
        Me.txtAppUpdateScheduleWeeklyDays = New System.Windows.Forms.TextBox()
        Me.Label30 = New System.Windows.Forms.Label()
        Me.lblAppUpdateScheduleWeeklyDays = New System.Windows.Forms.Label()
        Me.txtAppUpdateScheduleInterval = New System.Windows.Forms.TextBox()
        Me.Label32 = New System.Windows.Forms.Label()
        Me.Label33 = New System.Windows.Forms.Label()
        Me.cmdGeneralTestEmail = New System.Windows.Forms.Button()
        Me.txtGeneralOperatorEmail = New System.Windows.Forms.TextBox()
        Me.Label25 = New System.Windows.Forms.Label()
        Me.txtGeneralSMTPServer = New System.Windows.Forms.TextBox()
        Me.Label24 = New System.Windows.Forms.Label()
        Me.dpAppUpdateTime = New System.Windows.Forms.DateTimePicker()
        Me.txtConfigRootPath = New System.Windows.Forms.TextBox()
        Me.cmdConfigRootPath = New System.Windows.Forms.Button()
        Me.Label15 = New System.Windows.Forms.Label()
        Me.tabSettings = New System.Windows.Forms.TabControl()
        Me.tabGeneral = New System.Windows.Forms.TabPage()
        Me.txtGeneralAgencyID = New System.Windows.Forms.TextBox()
        Me.lblGeneralWebServiceStatusColor = New System.Windows.Forms.Label()
        Me.CircleImages = New System.Windows.Forms.ImageList(Me.components)
        Me.lblGeneralWebServiceStatus = New System.Windows.Forms.Label()
        Me.txtGeneralInstallKey = New System.Windows.Forms.TextBox()
        Me.Label29 = New System.Windows.Forms.Label()
        Me.Label27 = New System.Windows.Forms.Label()
        Me.txtGeneralProviderNumber = New System.Windows.Forms.TextBox()
        Me.Label28 = New System.Windows.Forms.Label()
        Me.txtGeneralSmartLinkWS = New System.Windows.Forms.TextBox()
        Me.Label37 = New System.Windows.Forms.Label()
        Me.grpGeneralProxySettings = New System.Windows.Forms.GroupBox()
        Me.lblGeneralPasswordStatusColor = New System.Windows.Forms.Label()
        Me.lblGeneralPasswordMessage = New System.Windows.Forms.Label()
        Me.txtGeneralProxyPassword2 = New System.Windows.Forms.TextBox()
        Me.lblGeneralRetryPassword = New System.Windows.Forms.Label()
        Me.txtGeneralProxyPort = New System.Windows.Forms.TextBox()
        Me.Label35 = New System.Windows.Forms.Label()
        Me.txtGeneralProxyIPAddress = New System.Windows.Forms.TextBox()
        Me.Label31 = New System.Windows.Forms.Label()
        Me.txtGeneralProxyDomain = New System.Windows.Forms.TextBox()
        Me.Label34 = New System.Windows.Forms.Label()
        Me.txtGeneralProxyPassword = New System.Windows.Forms.TextBox()
        Me.Label17 = New System.Windows.Forms.Label()
        Me.txtGeneralProxyUsername = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.chkGeneralProxy = New System.Windows.Forms.CheckBox()
        Me.tabSmartLink = New System.Windows.Forms.TabPage()
        Me.pnlTransferSvc = New System.Windows.Forms.Panel()
        Me.lblSmartLinkStatusColor = New System.Windows.Forms.Label()
        Me.cmdSmartLinkRestart = New System.Windows.Forms.Button()
        Me.cmbSmartLinkTrxfrDelay = New System.Windows.Forms.ComboBox()
        Me.lblSmartLinkServiceStatus = New System.Windows.Forms.Label()
        Me.lblMinutes = New System.Windows.Forms.Label()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.cmdSmartLinkExtraPollingFolders = New System.Windows.Forms.Button()
        Me.cmdSmartLinkStopStart = New System.Windows.Forms.Button()
        Me.txtSmartLinkUploadedFileLog = New System.Windows.Forms.TextBox()
        Me.Label16 = New System.Windows.Forms.Label()
        Me.txtSmartLinkErrorLogFile = New System.Windows.Forms.TextBox()
        Me.chkActivateTransferService = New System.Windows.Forms.CheckBox()
        Me.tabUpdate = New System.Windows.Forms.TabPage()
        Me.lblVersionInfo = New System.Windows.Forms.Label()
        Me.chkDownloadAndInstallUpdates = New System.Windows.Forms.CheckBox()
        Me.grpGroupBox3 = New System.Windows.Forms.GroupBox()
        Me.txtBoxCheckUpdateProgress = New System.Windows.Forms.TextBox()
        Me.cmdCheck4Update = New System.Windows.Forms.Button()
        Me.lblChkUpdatesNow = New System.Windows.Forms.Label()
        Me.lblUpdateDesc = New System.Windows.Forms.Label()
        Me.grpUpdateSchedule = New System.Windows.Forms.GroupBox()
        Me.cmdSaveSettings = New System.Windows.Forms.Button()
        Me.cmdClose = New System.Windows.Forms.Button()
        Me.fbdFolderBrowserDialog = New System.Windows.Forms.FolderBrowserDialog()
        Me.CheckServiceStatus = New System.Windows.Forms.Timer(Me.components)
        Me.cmdHelp = New System.Windows.Forms.Button()
        Me.tabSettings.SuspendLayout()
        Me.tabGeneral.SuspendLayout()
        Me.grpGeneralProxySettings.SuspendLayout()
        Me.tabSmartLink.SuspendLayout()
        Me.pnlTransferSvc.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.tabUpdate.SuspendLayout()
        Me.grpGroupBox3.SuspendLayout()
        Me.grpUpdateSchedule.SuspendLayout()
        Me.SuspendLayout()
        '
        'cmdSmartLinkPath
        '
        Me.cmdSmartLinkPath.Location = New System.Drawing.Point(565, 16)
        Me.cmdSmartLinkPath.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkPath.Name = "cmdSmartLinkPath"
        Me.cmdSmartLinkPath.Size = New System.Drawing.Size(37, 28)
        Me.cmdSmartLinkPath.TabIndex = 54
        Me.cmdSmartLinkPath.Text = "..."
        Me.ttInfo.SetToolTip(Me.cmdSmartLinkPath, "Click here to select the Main Polling Path")
        Me.cmdSmartLinkPath.UseVisualStyleBackColor = True
        '
        'cmdSmartLinkPollingFolder1
        '
        Me.cmdSmartLinkPollingFolder1.Location = New System.Drawing.Point(565, 48)
        Me.cmdSmartLinkPollingFolder1.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkPollingFolder1.Name = "cmdSmartLinkPollingFolder1"
        Me.cmdSmartLinkPollingFolder1.Size = New System.Drawing.Size(37, 28)
        Me.cmdSmartLinkPollingFolder1.TabIndex = 57
        Me.cmdSmartLinkPollingFolder1.Text = "..."
        Me.ttInfo.SetToolTip(Me.cmdSmartLinkPollingFolder1, "Click here to select the Polling Path 1")
        Me.cmdSmartLinkPollingFolder1.UseVisualStyleBackColor = True
        '
        'cmdSmartLinkPollingFolder2
        '
        Me.cmdSmartLinkPollingFolder2.Location = New System.Drawing.Point(565, 80)
        Me.cmdSmartLinkPollingFolder2.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkPollingFolder2.Name = "cmdSmartLinkPollingFolder2"
        Me.cmdSmartLinkPollingFolder2.Size = New System.Drawing.Size(37, 28)
        Me.cmdSmartLinkPollingFolder2.TabIndex = 60
        Me.cmdSmartLinkPollingFolder2.Text = "..."
        Me.ttInfo.SetToolTip(Me.cmdSmartLinkPollingFolder2, "Click here to select the Polling Path 2")
        Me.cmdSmartLinkPollingFolder2.UseVisualStyleBackColor = True
        '
        'cmdSmartLinkBackupDirectory
        '
        Me.cmdSmartLinkBackupDirectory.Location = New System.Drawing.Point(565, 310)
        Me.cmdSmartLinkBackupDirectory.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkBackupDirectory.Name = "cmdSmartLinkBackupDirectory"
        Me.cmdSmartLinkBackupDirectory.Size = New System.Drawing.Size(37, 28)
        Me.cmdSmartLinkBackupDirectory.TabIndex = 66
        Me.cmdSmartLinkBackupDirectory.Text = "..."
        Me.ttInfo.SetToolTip(Me.cmdSmartLinkBackupDirectory, "Click here to select the Backup Directory Path")
        Me.cmdSmartLinkBackupDirectory.UseVisualStyleBackColor = True
        '
        'cmdSmartLinkViewUploadedFileLog
        '
        Me.cmdSmartLinkViewUploadedFileLog.Location = New System.Drawing.Point(327, 345)
        Me.cmdSmartLinkViewUploadedFileLog.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkViewUploadedFileLog.Name = "cmdSmartLinkViewUploadedFileLog"
        Me.cmdSmartLinkViewUploadedFileLog.Size = New System.Drawing.Size(88, 28)
        Me.cmdSmartLinkViewUploadedFileLog.TabIndex = 69
        Me.cmdSmartLinkViewUploadedFileLog.Text = "View Log"
        Me.ttInfo.SetToolTip(Me.cmdSmartLinkViewUploadedFileLog, "Click here to view the uploaded file log")
        Me.cmdSmartLinkViewUploadedFileLog.UseVisualStyleBackColor = True
        '
        'cmdSmartLinkViewErrorLog
        '
        Me.cmdSmartLinkViewErrorLog.Location = New System.Drawing.Point(535, 378)
        Me.cmdSmartLinkViewErrorLog.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkViewErrorLog.Name = "cmdSmartLinkViewErrorLog"
        Me.cmdSmartLinkViewErrorLog.Size = New System.Drawing.Size(88, 28)
        Me.cmdSmartLinkViewErrorLog.TabIndex = 71
        Me.cmdSmartLinkViewErrorLog.Text = "View Log"
        Me.ttInfo.SetToolTip(Me.cmdSmartLinkViewErrorLog, "Click here to view the error log")
        Me.cmdSmartLinkViewErrorLog.UseVisualStyleBackColor = True
        '
        'cmbSmartLinkBackupFiles
        '
        Me.cmbSmartLinkBackupFiles.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend
        Me.cmbSmartLinkBackupFiles.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems
        Me.cmbSmartLinkBackupFiles.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbSmartLinkBackupFiles.FormattingEnabled = True
        Me.cmbSmartLinkBackupFiles.Items.AddRange(New Object() {"Yes", "No"})
        Me.cmbSmartLinkBackupFiles.Location = New System.Drawing.Point(187, 279)
        Me.cmbSmartLinkBackupFiles.Margin = New System.Windows.Forms.Padding(4)
        Me.cmbSmartLinkBackupFiles.Name = "cmbSmartLinkBackupFiles"
        Me.cmbSmartLinkBackupFiles.Size = New System.Drawing.Size(128, 24)
        Me.cmbSmartLinkBackupFiles.TabIndex = 64
        Me.ttInfo.SetToolTip(Me.cmbSmartLinkBackupFiles, "Creates a duplicate copy of files uploaded to NRC")
        '
        'cmbSmartLinkLogWSFiles
        '
        Me.cmbSmartLinkLogWSFiles.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend
        Me.cmbSmartLinkLogWSFiles.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems
        Me.cmbSmartLinkLogWSFiles.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbSmartLinkLogWSFiles.FormattingEnabled = True
        Me.cmbSmartLinkLogWSFiles.Items.AddRange(New Object() {"Yes", "No"})
        Me.cmbSmartLinkLogWSFiles.Location = New System.Drawing.Point(187, 345)
        Me.cmbSmartLinkLogWSFiles.Margin = New System.Windows.Forms.Padding(4)
        Me.cmbSmartLinkLogWSFiles.Name = "cmbSmartLinkLogWSFiles"
        Me.cmbSmartLinkLogWSFiles.Size = New System.Drawing.Size(128, 24)
        Me.cmbSmartLinkLogWSFiles.TabIndex = 67
        Me.ttInfo.SetToolTip(Me.cmbSmartLinkLogWSFiles, "This can be used when working with NRC technical support")
        '
        'cmbSmartLinkAllowFileRename
        '
        Me.cmbSmartLinkAllowFileRename.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend
        Me.cmbSmartLinkAllowFileRename.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems
        Me.cmbSmartLinkAllowFileRename.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbSmartLinkAllowFileRename.FormattingEnabled = True
        Me.cmbSmartLinkAllowFileRename.Items.AddRange(New Object() {"Yes", "No"})
        Me.cmbSmartLinkAllowFileRename.Location = New System.Drawing.Point(464, 279)
        Me.cmbSmartLinkAllowFileRename.Margin = New System.Windows.Forms.Padding(4)
        Me.cmbSmartLinkAllowFileRename.Name = "cmbSmartLinkAllowFileRename"
        Me.cmbSmartLinkAllowFileRename.Size = New System.Drawing.Size(92, 24)
        Me.cmbSmartLinkAllowFileRename.TabIndex = 63
        Me.ttInfo.SetToolTip(Me.cmbSmartLinkAllowFileRename, "Select No if you do not want original file names changed")
        '
        'cmdSmartLinkClearPolling1
        '
        Me.cmdSmartLinkClearPolling1.Location = New System.Drawing.Point(469, 48)
        Me.cmdSmartLinkClearPolling1.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkClearPolling1.Name = "cmdSmartLinkClearPolling1"
        Me.cmdSmartLinkClearPolling1.Size = New System.Drawing.Size(88, 28)
        Me.cmdSmartLinkClearPolling1.TabIndex = 56
        Me.cmdSmartLinkClearPolling1.Text = "Clear Path"
        Me.ttInfo.SetToolTip(Me.cmdSmartLinkClearPolling1, "Click here to clear the path for polling folder 1")
        Me.cmdSmartLinkClearPolling1.UseVisualStyleBackColor = True
        '
        'cmdClearPolling2
        '
        Me.cmdClearPolling2.Location = New System.Drawing.Point(469, 80)
        Me.cmdClearPolling2.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdClearPolling2.Name = "cmdClearPolling2"
        Me.cmdClearPolling2.Size = New System.Drawing.Size(88, 28)
        Me.cmdClearPolling2.TabIndex = 59
        Me.cmdClearPolling2.Text = "Clear Path"
        Me.ttInfo.SetToolTip(Me.cmdClearPolling2, "Click here to clear the path for polling folder 2")
        Me.cmdClearPolling2.UseVisualStyleBackColor = True
        '
        'txtSmartLinkBackupDirectory
        '
        Me.txtSmartLinkBackupDirectory.Location = New System.Drawing.Point(187, 313)
        Me.txtSmartLinkBackupDirectory.Margin = New System.Windows.Forms.Padding(4)
        Me.txtSmartLinkBackupDirectory.Name = "txtSmartLinkBackupDirectory"
        Me.txtSmartLinkBackupDirectory.ReadOnly = True
        Me.txtSmartLinkBackupDirectory.Size = New System.Drawing.Size(369, 22)
        Me.txtSmartLinkBackupDirectory.TabIndex = 65
        Me.ttInfo.SetToolTip(Me.txtSmartLinkBackupDirectory, "If backup files flag is set to yes a backup of each file will be kept in this dir" &
        "ectory")
        '
        'Label23
        '
        Me.Label23.AutoSize = True
        Me.Label23.Location = New System.Drawing.Point(19, 316)
        Me.Label23.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label23.Name = "Label23"
        Me.Label23.Size = New System.Drawing.Size(120, 17)
        Me.Label23.TabIndex = 84
        Me.Label23.Text = "Backup Directory:"
        Me.ttInfo.SetToolTip(Me.Label23, "If backup files flag is set to yes a backup of each file will be kept in this dir" &
        "ectory")
        '
        'Label19
        '
        Me.Label19.AutoSize = True
        Me.Label19.Location = New System.Drawing.Point(323, 283)
        Me.Label19.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label19.Name = "Label19"
        Me.Label19.Size = New System.Drawing.Size(127, 17)
        Me.Label19.TabIndex = 82
        Me.Label19.Text = "Allow File Rename:"
        Me.ttInfo.SetToolTip(Me.Label19, "Select No if you do not want original file names changed")
        '
        'Label18
        '
        Me.Label18.AutoSize = True
        Me.Label18.Location = New System.Drawing.Point(19, 348)
        Me.Label18.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label18.Name = "Label18"
        Me.Label18.Size = New System.Drawing.Size(162, 17)
        Me.Label18.TabIndex = 85
        Me.Label18.Text = "Keep uploaded File Log:"
        Me.ttInfo.SetToolTip(Me.Label18, "This can be used when working with NRC technical support")
        '
        'Label13
        '
        Me.Label13.AutoSize = True
        Me.Label13.Location = New System.Drawing.Point(19, 283)
        Me.Label13.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(92, 17)
        Me.Label13.TabIndex = 83
        Me.Label13.Text = "Backup Files:"
        Me.ttInfo.SetToolTip(Me.Label13, "Creates a duplicate copy of files uploaded to NRC")
        '
        'txtSmartLinkPollingFolder2
        '
        Me.txtSmartLinkPollingFolder2.Location = New System.Drawing.Point(187, 82)
        Me.txtSmartLinkPollingFolder2.Margin = New System.Windows.Forms.Padding(4)
        Me.txtSmartLinkPollingFolder2.Name = "txtSmartLinkPollingFolder2"
        Me.txtSmartLinkPollingFolder2.ReadOnly = True
        Me.txtSmartLinkPollingFolder2.Size = New System.Drawing.Size(273, 22)
        Me.txtSmartLinkPollingFolder2.TabIndex = 58
        Me.ttInfo.SetToolTip(Me.txtSmartLinkPollingFolder2, "Files droped to this location will be copied to Main Polling Path and then upload" &
        "ed to NRC")
        '
        'Label14
        '
        Me.Label14.AutoSize = True
        Me.Label14.Location = New System.Drawing.Point(19, 86)
        Me.Label14.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(99, 17)
        Me.Label14.TabIndex = 79
        Me.Label14.Text = "Polling Path 2:"
        Me.ttInfo.SetToolTip(Me.Label14, "Files droped to this location will be copied to Main Polling Path and then upload" &
        "ed to NRC")
        '
        'txtSmartLinkPollingFolder1
        '
        Me.txtSmartLinkPollingFolder1.Location = New System.Drawing.Point(187, 50)
        Me.txtSmartLinkPollingFolder1.Margin = New System.Windows.Forms.Padding(4)
        Me.txtSmartLinkPollingFolder1.Name = "txtSmartLinkPollingFolder1"
        Me.txtSmartLinkPollingFolder1.ReadOnly = True
        Me.txtSmartLinkPollingFolder1.Size = New System.Drawing.Size(273, 22)
        Me.txtSmartLinkPollingFolder1.TabIndex = 55
        Me.ttInfo.SetToolTip(Me.txtSmartLinkPollingFolder1, "Electronic Billing files not dropped in upload folder")
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(19, 54)
        Me.Label9.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(99, 17)
        Me.Label9.TabIndex = 78
        Me.Label9.Text = "Polling Path 1:"
        Me.ttInfo.SetToolTip(Me.Label9, "Electronic Billing files not dropped in upload folder")
        '
        'txtSmartLinkPath
        '
        Me.txtSmartLinkPath.Location = New System.Drawing.Point(187, 18)
        Me.txtSmartLinkPath.Margin = New System.Windows.Forms.Padding(4)
        Me.txtSmartLinkPath.Name = "txtSmartLinkPath"
        Me.txtSmartLinkPath.ReadOnly = True
        Me.txtSmartLinkPath.Size = New System.Drawing.Size(369, 22)
        Me.txtSmartLinkPath.TabIndex = 53
        Me.ttInfo.SetToolTip(Me.txtSmartLinkPath, "Files droped to this location will be uploaded to NRC")
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(19, 22)
        Me.Label1.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(121, 17)
        Me.Label1.TabIndex = 77
        Me.Label1.Text = "Main Polling Path:"
        Me.ttInfo.SetToolTip(Me.Label1, "Files droped to this location will be uploaded to NRC")
        '
        'lblTrxfrDelay
        '
        Me.lblTrxfrDelay.AutoSize = True
        Me.lblTrxfrDelay.Location = New System.Drawing.Point(19, 252)
        Me.lblTrxfrDelay.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblTrxfrDelay.Name = "lblTrxfrDelay"
        Me.lblTrxfrDelay.Size = New System.Drawing.Size(152, 17)
        Me.lblTrxfrDelay.TabIndex = 80
        Me.lblTrxfrDelay.Text = "Transfer Delay Interval"
        Me.ttInfo.SetToolTip(Me.lblTrxfrDelay, "The server name or IP address for the SMTP Server")
        '
        'lblAppUpdateScheduleType
        '
        Me.lblAppUpdateScheduleType.AutoSize = True
        Me.lblAppUpdateScheduleType.Location = New System.Drawing.Point(433, 31)
        Me.lblAppUpdateScheduleType.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblAppUpdateScheduleType.Name = "lblAppUpdateScheduleType"
        Me.lblAppUpdateScheduleType.Size = New System.Drawing.Size(40, 17)
        Me.lblAppUpdateScheduleType.TabIndex = 109
        Me.lblAppUpdateScheduleType.Text = "Days"
        Me.lblAppUpdateScheduleType.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.ttInfo.SetToolTip(Me.lblAppUpdateScheduleType, "Define appropiated interval for schedule")
        '
        'cmdAppUpdateWeekdaysDetails
        '
        Me.cmdAppUpdateWeekdaysDetails.Location = New System.Drawing.Point(547, 90)
        Me.cmdAppUpdateWeekdaysDetails.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdAppUpdateWeekdaysDetails.Name = "cmdAppUpdateWeekdaysDetails"
        Me.cmdAppUpdateWeekdaysDetails.Size = New System.Drawing.Size(37, 28)
        Me.cmdAppUpdateWeekdaysDetails.TabIndex = 100
        Me.cmdAppUpdateWeekdaysDetails.Text = "..."
        Me.ttInfo.SetToolTip(Me.cmdAppUpdateWeekdaysDetails, "Click here to set the Weekdays")
        Me.cmdAppUpdateWeekdaysDetails.UseVisualStyleBackColor = True
        '
        'cmbAppUpdateScheduleType
        '
        Me.cmbAppUpdateScheduleType.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend
        Me.cmbAppUpdateScheduleType.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems
        Me.cmbAppUpdateScheduleType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbAppUpdateScheduleType.FormattingEnabled = True
        Me.cmbAppUpdateScheduleType.Items.AddRange(New Object() {"Daily", "Weekly"})
        Me.cmbAppUpdateScheduleType.Location = New System.Drawing.Point(187, 27)
        Me.cmbAppUpdateScheduleType.Margin = New System.Windows.Forms.Padding(4)
        Me.cmbAppUpdateScheduleType.Name = "cmbAppUpdateScheduleType"
        Me.cmbAppUpdateScheduleType.Size = New System.Drawing.Size(92, 24)
        Me.cmbAppUpdateScheduleType.TabIndex = 95
        Me.ttInfo.SetToolTip(Me.cmbAppUpdateScheduleType, "Select the appropiated Schedule Type")
        '
        'txtAppUpdateScheduleWeeklyDays
        '
        Me.txtAppUpdateScheduleWeeklyDays.Location = New System.Drawing.Point(187, 94)
        Me.txtAppUpdateScheduleWeeklyDays.Margin = New System.Windows.Forms.Padding(4)
        Me.txtAppUpdateScheduleWeeklyDays.Name = "txtAppUpdateScheduleWeeklyDays"
        Me.txtAppUpdateScheduleWeeklyDays.ReadOnly = True
        Me.txtAppUpdateScheduleWeeklyDays.Size = New System.Drawing.Size(355, 22)
        Me.txtAppUpdateScheduleWeeklyDays.TabIndex = 99
        Me.ttInfo.SetToolTip(Me.txtAppUpdateScheduleWeeklyDays, "Days of the week when the service should pull the data")
        '
        'Label30
        '
        Me.Label30.AutoSize = True
        Me.Label30.Location = New System.Drawing.Point(56, 64)
        Me.Label30.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label30.Name = "Label30"
        Me.Label30.Size = New System.Drawing.Size(106, 17)
        Me.Label30.TabIndex = 110
        Me.Label30.Text = "Schedule Time:"
        Me.Label30.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.ttInfo.SetToolTip(Me.Label30, "Time during the day when the service should pull the data")
        '
        'lblAppUpdateScheduleWeeklyDays
        '
        Me.lblAppUpdateScheduleWeeklyDays.AutoSize = True
        Me.lblAppUpdateScheduleWeeklyDays.Location = New System.Drawing.Point(19, 96)
        Me.lblAppUpdateScheduleWeeklyDays.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblAppUpdateScheduleWeeklyDays.Name = "lblAppUpdateScheduleWeeklyDays"
        Me.lblAppUpdateScheduleWeeklyDays.Size = New System.Drawing.Size(141, 17)
        Me.lblAppUpdateScheduleWeeklyDays.TabIndex = 111
        Me.lblAppUpdateScheduleWeeklyDays.Text = "Schedule Weekdays:"
        Me.lblAppUpdateScheduleWeeklyDays.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.ttInfo.SetToolTip(Me.lblAppUpdateScheduleWeeklyDays, "Days of the week when the service should pull the data")
        '
        'txtAppUpdateScheduleInterval
        '
        Me.txtAppUpdateScheduleInterval.AcceptsReturn = True
        Me.txtAppUpdateScheduleInterval.Location = New System.Drawing.Point(387, 27)
        Me.txtAppUpdateScheduleInterval.Margin = New System.Windows.Forms.Padding(4)
        Me.txtAppUpdateScheduleInterval.Name = "txtAppUpdateScheduleInterval"
        Me.txtAppUpdateScheduleInterval.Size = New System.Drawing.Size(39, 22)
        Me.txtAppUpdateScheduleInterval.TabIndex = 96
        Me.ttInfo.SetToolTip(Me.txtAppUpdateScheduleInterval, "Define appropiated interval for schedule")
        '
        'Label32
        '
        Me.Label32.AutoSize = True
        Me.Label32.Location = New System.Drawing.Point(337, 31)
        Me.Label32.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label32.Name = "Label32"
        Me.Label32.Size = New System.Drawing.Size(44, 17)
        Me.Label32.TabIndex = 108
        Me.Label32.Text = "Every"
        Me.Label32.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.ttInfo.SetToolTip(Me.Label32, "Define appropiated interval for schedule")
        '
        'Label33
        '
        Me.Label33.AutoSize = True
        Me.Label33.Location = New System.Drawing.Point(35, 31)
        Me.Label33.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label33.Name = "Label33"
        Me.Label33.Size = New System.Drawing.Size(127, 17)
        Me.Label33.TabIndex = 107
        Me.Label33.Text = "Check for updates:"
        Me.Label33.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.ttInfo.SetToolTip(Me.Label33, "Select the appropiated Schedule Type")
        '
        'cmdGeneralTestEmail
        '
        Me.cmdGeneralTestEmail.Location = New System.Drawing.Point(475, 130)
        Me.cmdGeneralTestEmail.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdGeneralTestEmail.Name = "cmdGeneralTestEmail"
        Me.cmdGeneralTestEmail.Size = New System.Drawing.Size(88, 28)
        Me.cmdGeneralTestEmail.TabIndex = 117
        Me.cmdGeneralTestEmail.Text = "Test Email"
        Me.ttInfo.SetToolTip(Me.cmdGeneralTestEmail, "Click here to test the Email Settings")
        Me.cmdGeneralTestEmail.UseVisualStyleBackColor = True
        '
        'txtGeneralOperatorEmail
        '
        Me.txtGeneralOperatorEmail.Location = New System.Drawing.Point(204, 133)
        Me.txtGeneralOperatorEmail.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralOperatorEmail.Name = "txtGeneralOperatorEmail"
        Me.txtGeneralOperatorEmail.Size = New System.Drawing.Size(232, 22)
        Me.txtGeneralOperatorEmail.TabIndex = 116
        Me.ttInfo.SetToolTip(Me.txtGeneralOperatorEmail, "Email address for operator of this service")
        '
        'Label25
        '
        Me.Label25.AutoSize = True
        Me.Label25.Location = New System.Drawing.Point(39, 139)
        Me.Label25.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label25.Name = "Label25"
        Me.Label25.Size = New System.Drawing.Size(99, 17)
        Me.Label25.TabIndex = 112
        Me.Label25.Text = "Send Email to:"
        Me.ttInfo.SetToolTip(Me.Label25, "email address for operator of this service")
        '
        'txtGeneralSMTPServer
        '
        Me.txtGeneralSMTPServer.Location = New System.Drawing.Point(204, 101)
        Me.txtGeneralSMTPServer.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralSMTPServer.Name = "txtGeneralSMTPServer"
        Me.txtGeneralSMTPServer.Size = New System.Drawing.Size(232, 22)
        Me.txtGeneralSMTPServer.TabIndex = 115
        Me.ttInfo.SetToolTip(Me.txtGeneralSMTPServer, "The server name or IP address for the SMTP Server")
        '
        'Label24
        '
        Me.Label24.AutoSize = True
        Me.Label24.Location = New System.Drawing.Point(39, 107)
        Me.Label24.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label24.Name = "Label24"
        Me.Label24.Size = New System.Drawing.Size(150, 17)
        Me.Label24.TabIndex = 111
        Me.Label24.Text = "Email Server Location:"
        Me.ttInfo.SetToolTip(Me.Label24, "The server name or IP address for the SMTP Server")
        '
        'dpAppUpdateTime
        '
        Me.dpAppUpdateTime.CustomFormat = "h:mm tt"
        Me.dpAppUpdateTime.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.dpAppUpdateTime.Location = New System.Drawing.Point(187, 59)
        Me.dpAppUpdateTime.Margin = New System.Windows.Forms.Padding(4)
        Me.dpAppUpdateTime.Name = "dpAppUpdateTime"
        Me.dpAppUpdateTime.ShowUpDown = True
        Me.dpAppUpdateTime.Size = New System.Drawing.Size(96, 22)
        Me.dpAppUpdateTime.TabIndex = 112
        Me.ttInfo.SetToolTip(Me.dpAppUpdateTime, "Specifies the time of day at which SmartLink should check for, download, and inst" &
        "all (if applicable) application updates.")
        Me.dpAppUpdateTime.Value = New Date(2010, 3, 23, 0, 0, 0, 0)
        '
        'txtConfigRootPath
        '
        Me.txtConfigRootPath.Location = New System.Drawing.Point(204, 41)
        Me.txtConfigRootPath.Margin = New System.Windows.Forms.Padding(4)
        Me.txtConfigRootPath.Name = "txtConfigRootPath"
        Me.txtConfigRootPath.ReadOnly = True
        Me.txtConfigRootPath.Size = New System.Drawing.Size(388, 22)
        Me.txtConfigRootPath.TabIndex = 134
        Me.ttInfo.SetToolTip(Me.txtConfigRootPath, "The absolute path to the configuration files and logs root folder.")
        '
        'cmdConfigRootPath
        '
        Me.cmdConfigRootPath.Location = New System.Drawing.Point(601, 39)
        Me.cmdConfigRootPath.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdConfigRootPath.Name = "cmdConfigRootPath"
        Me.cmdConfigRootPath.Size = New System.Drawing.Size(37, 28)
        Me.cmdConfigRootPath.TabIndex = 135
        Me.cmdConfigRootPath.Text = "..."
        Me.ttInfo.SetToolTip(Me.cmdConfigRootPath, "Click here to select the configuration root folder.")
        Me.cmdConfigRootPath.UseVisualStyleBackColor = True
        '
        'Label15
        '
        Me.Label15.AutoSize = True
        Me.Label15.Location = New System.Drawing.Point(39, 43)
        Me.Label15.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label15.Name = "Label15"
        Me.Label15.Size = New System.Drawing.Size(130, 17)
        Me.Label15.TabIndex = 136
        Me.Label15.Text = "Config Root Folder:"
        Me.ttInfo.SetToolTip(Me.Label15, "The configuration settings files and log root folder location.  It can be left at" &
        " the default location or a custom folder path can be selected.")
        '
        'tabSettings
        '
        Me.tabSettings.Controls.Add(Me.tabGeneral)
        Me.tabSettings.Controls.Add(Me.tabSmartLink)
        Me.tabSettings.Controls.Add(Me.tabUpdate)
        Me.tabSettings.Cursor = System.Windows.Forms.Cursors.Default
        Me.tabSettings.Location = New System.Drawing.Point(16, 15)
        Me.tabSettings.Margin = New System.Windows.Forms.Padding(4)
        Me.tabSettings.Name = "tabSettings"
        Me.tabSettings.SelectedIndex = 0
        Me.tabSettings.Size = New System.Drawing.Size(685, 593)
        Me.tabSettings.TabIndex = 0
        Me.tabSettings.TabStop = False
        '
        'tabGeneral
        '
        Me.tabGeneral.Controls.Add(Me.txtGeneralAgencyID)
        Me.tabGeneral.Controls.Add(Me.Label15)
        Me.tabGeneral.Controls.Add(Me.cmdConfigRootPath)
        Me.tabGeneral.Controls.Add(Me.txtConfigRootPath)
        Me.tabGeneral.Controls.Add(Me.lblGeneralWebServiceStatusColor)
        Me.tabGeneral.Controls.Add(Me.lblGeneralWebServiceStatus)
        Me.tabGeneral.Controls.Add(Me.txtGeneralInstallKey)
        Me.tabGeneral.Controls.Add(Me.Label29)
        Me.tabGeneral.Controls.Add(Me.Label27)
        Me.tabGeneral.Controls.Add(Me.txtGeneralProviderNumber)
        Me.tabGeneral.Controls.Add(Me.Label28)
        Me.tabGeneral.Controls.Add(Me.cmdGeneralTestEmail)
        Me.tabGeneral.Controls.Add(Me.txtGeneralOperatorEmail)
        Me.tabGeneral.Controls.Add(Me.Label25)
        Me.tabGeneral.Controls.Add(Me.txtGeneralSMTPServer)
        Me.tabGeneral.Controls.Add(Me.Label24)
        Me.tabGeneral.Controls.Add(Me.txtGeneralSmartLinkWS)
        Me.tabGeneral.Controls.Add(Me.Label37)
        Me.tabGeneral.Controls.Add(Me.grpGeneralProxySettings)
        Me.tabGeneral.Controls.Add(Me.chkGeneralProxy)
        Me.tabGeneral.Location = New System.Drawing.Point(4, 25)
        Me.tabGeneral.Margin = New System.Windows.Forms.Padding(4)
        Me.tabGeneral.Name = "tabGeneral"
        Me.tabGeneral.Padding = New System.Windows.Forms.Padding(4)
        Me.tabGeneral.Size = New System.Drawing.Size(677, 564)
        Me.tabGeneral.TabIndex = 3
        Me.tabGeneral.Text = "General"
        Me.tabGeneral.UseVisualStyleBackColor = True
        '
        'txtGeneralAgencyID
        '
        Me.txtGeneralAgencyID.Location = New System.Drawing.Point(204, 203)
        Me.txtGeneralAgencyID.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralAgencyID.MaxLength = 6
        Me.txtGeneralAgencyID.Name = "txtGeneralAgencyID"
        Me.txtGeneralAgencyID.Size = New System.Drawing.Size(357, 22)
        Me.txtGeneralAgencyID.TabIndex = 120
        '
        'lblGeneralWebServiceStatusColor
        '
        Me.lblGeneralWebServiceStatusColor.ImageIndex = 1
        Me.lblGeneralWebServiceStatusColor.ImageList = Me.CircleImages
        Me.lblGeneralWebServiceStatusColor.Location = New System.Drawing.Point(205, 300)
        Me.lblGeneralWebServiceStatusColor.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblGeneralWebServiceStatusColor.Name = "lblGeneralWebServiceStatusColor"
        Me.lblGeneralWebServiceStatusColor.Size = New System.Drawing.Size(35, 32)
        Me.lblGeneralWebServiceStatusColor.TabIndex = 133
        Me.lblGeneralWebServiceStatusColor.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'CircleImages
        '
        Me.CircleImages.ImageStream = CType(resources.GetObject("CircleImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.CircleImages.TransparentColor = System.Drawing.Color.Transparent
        Me.CircleImages.Images.SetKeyName(0, "Red.png")
        Me.CircleImages.Images.SetKeyName(1, "Green.png")
        '
        'lblGeneralWebServiceStatus
        '
        Me.lblGeneralWebServiceStatus.AutoSize = True
        Me.lblGeneralWebServiceStatus.Location = New System.Drawing.Point(248, 311)
        Me.lblGeneralWebServiceStatus.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblGeneralWebServiceStatus.Name = "lblGeneralWebServiceStatus"
        Me.lblGeneralWebServiceStatus.Size = New System.Drawing.Size(189, 17)
        Me.lblGeneralWebServiceStatus.TabIndex = 132
        Me.lblGeneralWebServiceStatus.Text = "lblGeneralWebServiceStatus"
        '
        'txtGeneralInstallKey
        '
        Me.txtGeneralInstallKey.Location = New System.Drawing.Point(393, 165)
        Me.txtGeneralInstallKey.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralInstallKey.MaxLength = 7
        Me.txtGeneralInstallKey.Name = "txtGeneralInstallKey"
        Me.txtGeneralInstallKey.ReadOnly = True
        Me.txtGeneralInstallKey.Size = New System.Drawing.Size(168, 22)
        Me.txtGeneralInstallKey.TabIndex = 119
        '
        'Label29
        '
        Me.Label29.AutoSize = True
        Me.Label29.Location = New System.Drawing.Point(308, 169)
        Me.Label29.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label29.Name = "Label29"
        Me.Label29.Size = New System.Drawing.Size(76, 17)
        Me.Label29.TabIndex = 114
        Me.Label29.Text = "Install Key:"
        '
        'Label27
        '
        Me.Label27.AutoSize = True
        Me.Label27.Location = New System.Drawing.Point(39, 203)
        Me.Label27.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label27.Name = "Label27"
        Me.Label27.Size = New System.Drawing.Size(76, 17)
        Me.Label27.TabIndex = 115
        Me.Label27.Text = "Agency ID:"
        '
        'txtGeneralProviderNumber
        '
        Me.txtGeneralProviderNumber.Location = New System.Drawing.Point(204, 165)
        Me.txtGeneralProviderNumber.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralProviderNumber.MaxLength = 7
        Me.txtGeneralProviderNumber.Name = "txtGeneralProviderNumber"
        Me.txtGeneralProviderNumber.Size = New System.Drawing.Size(95, 22)
        Me.txtGeneralProviderNumber.TabIndex = 118
        '
        'Label28
        '
        Me.Label28.AutoSize = True
        Me.Label28.Location = New System.Drawing.Point(39, 171)
        Me.Label28.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label28.Name = "Label28"
        Me.Label28.Size = New System.Drawing.Size(115, 17)
        Me.Label28.TabIndex = 113
        Me.Label28.Text = "Unique Identifier:"
        '
        'txtGeneralSmartLinkWS
        '
        Me.txtGeneralSmartLinkWS.Location = New System.Drawing.Point(204, 258)
        Me.txtGeneralSmartLinkWS.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralSmartLinkWS.Name = "txtGeneralSmartLinkWS"
        Me.txtGeneralSmartLinkWS.ReadOnly = True
        Me.txtGeneralSmartLinkWS.Size = New System.Drawing.Size(388, 22)
        Me.txtGeneralSmartLinkWS.TabIndex = 121
        '
        'Label37
        '
        Me.Label37.AutoSize = True
        Me.Label37.Location = New System.Drawing.Point(36, 262)
        Me.Label37.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label37.Name = "Label37"
        Me.Label37.Size = New System.Drawing.Size(155, 17)
        Me.Label37.TabIndex = 104
        Me.Label37.Text = "NRC Web service URL:"
        '
        'grpGeneralProxySettings
        '
        Me.grpGeneralProxySettings.Controls.Add(Me.lblGeneralPasswordStatusColor)
        Me.grpGeneralProxySettings.Controls.Add(Me.lblGeneralPasswordMessage)
        Me.grpGeneralProxySettings.Controls.Add(Me.txtGeneralProxyPassword2)
        Me.grpGeneralProxySettings.Controls.Add(Me.lblGeneralRetryPassword)
        Me.grpGeneralProxySettings.Controls.Add(Me.txtGeneralProxyPort)
        Me.grpGeneralProxySettings.Controls.Add(Me.Label35)
        Me.grpGeneralProxySettings.Controls.Add(Me.txtGeneralProxyIPAddress)
        Me.grpGeneralProxySettings.Controls.Add(Me.Label31)
        Me.grpGeneralProxySettings.Controls.Add(Me.txtGeneralProxyDomain)
        Me.grpGeneralProxySettings.Controls.Add(Me.Label34)
        Me.grpGeneralProxySettings.Controls.Add(Me.txtGeneralProxyPassword)
        Me.grpGeneralProxySettings.Controls.Add(Me.Label17)
        Me.grpGeneralProxySettings.Controls.Add(Me.txtGeneralProxyUsername)
        Me.grpGeneralProxySettings.Controls.Add(Me.Label6)
        Me.grpGeneralProxySettings.Location = New System.Drawing.Point(16, 340)
        Me.grpGeneralProxySettings.Margin = New System.Windows.Forms.Padding(4)
        Me.grpGeneralProxySettings.Name = "grpGeneralProxySettings"
        Me.grpGeneralProxySettings.Padding = New System.Windows.Forms.Padding(4)
        Me.grpGeneralProxySettings.Size = New System.Drawing.Size(640, 192)
        Me.grpGeneralProxySettings.TabIndex = 97
        Me.grpGeneralProxySettings.TabStop = False
        Me.grpGeneralProxySettings.Text = "Proxy Settings"
        '
        'lblGeneralPasswordStatusColor
        '
        Me.lblGeneralPasswordStatusColor.ImageIndex = 1
        Me.lblGeneralPasswordStatusColor.ImageList = Me.CircleImages
        Me.lblGeneralPasswordStatusColor.Location = New System.Drawing.Point(367, 114)
        Me.lblGeneralPasswordStatusColor.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblGeneralPasswordStatusColor.Name = "lblGeneralPasswordStatusColor"
        Me.lblGeneralPasswordStatusColor.Size = New System.Drawing.Size(35, 32)
        Me.lblGeneralPasswordStatusColor.TabIndex = 131
        Me.lblGeneralPasswordStatusColor.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblGeneralPasswordMessage
        '
        Me.lblGeneralPasswordMessage.AutoSize = True
        Me.lblGeneralPasswordMessage.Location = New System.Drawing.Point(409, 123)
        Me.lblGeneralPasswordMessage.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblGeneralPasswordMessage.Name = "lblGeneralPasswordMessage"
        Me.lblGeneralPasswordMessage.Size = New System.Drawing.Size(191, 17)
        Me.lblGeneralPasswordMessage.TabIndex = 130
        Me.lblGeneralPasswordMessage.Text = "lblGeneralPasswordMessage"
        '
        'txtGeneralProxyPassword2
        '
        Me.txtGeneralProxyPassword2.Location = New System.Drawing.Point(133, 151)
        Me.txtGeneralProxyPassword2.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralProxyPassword2.Name = "txtGeneralProxyPassword2"
        Me.txtGeneralProxyPassword2.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
        Me.txtGeneralProxyPassword2.Size = New System.Drawing.Size(225, 22)
        Me.txtGeneralProxyPassword2.TabIndex = 129
        Me.txtGeneralProxyPassword2.Visible = False
        '
        'lblGeneralRetryPassword
        '
        Me.lblGeneralRetryPassword.AutoSize = True
        Me.lblGeneralRetryPassword.Location = New System.Drawing.Point(7, 155)
        Me.lblGeneralRetryPassword.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblGeneralRetryPassword.Name = "lblGeneralRetryPassword"
        Me.lblGeneralRetryPassword.Size = New System.Drawing.Size(125, 17)
        Me.lblGeneralRetryPassword.TabIndex = 106
        Me.lblGeneralRetryPassword.Text = "Confirm Password:"
        Me.lblGeneralRetryPassword.Visible = False
        '
        'txtGeneralProxyPort
        '
        Me.txtGeneralProxyPort.Location = New System.Drawing.Point(451, 23)
        Me.txtGeneralProxyPort.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralProxyPort.Name = "txtGeneralProxyPort"
        Me.txtGeneralProxyPort.Size = New System.Drawing.Size(132, 22)
        Me.txtGeneralProxyPort.TabIndex = 125
        '
        'Label35
        '
        Me.Label35.AutoSize = True
        Me.Label35.Location = New System.Drawing.Point(368, 27)
        Me.Label35.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label35.Name = "Label35"
        Me.Label35.Size = New System.Drawing.Size(38, 17)
        Me.Label35.TabIndex = 104
        Me.Label35.Text = "Port:"
        '
        'txtGeneralProxyIPAddress
        '
        Me.txtGeneralProxyIPAddress.Location = New System.Drawing.Point(133, 23)
        Me.txtGeneralProxyIPAddress.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralProxyIPAddress.Name = "txtGeneralProxyIPAddress"
        Me.txtGeneralProxyIPAddress.Size = New System.Drawing.Size(225, 22)
        Me.txtGeneralProxyIPAddress.TabIndex = 124
        '
        'Label31
        '
        Me.Label31.AutoSize = True
        Me.Label31.Location = New System.Drawing.Point(51, 27)
        Me.Label31.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label31.Name = "Label31"
        Me.Label31.Size = New System.Drawing.Size(80, 17)
        Me.Label31.TabIndex = 102
        Me.Label31.Text = "IP Address:"
        '
        'txtGeneralProxyDomain
        '
        Me.txtGeneralProxyDomain.Location = New System.Drawing.Point(133, 55)
        Me.txtGeneralProxyDomain.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralProxyDomain.Name = "txtGeneralProxyDomain"
        Me.txtGeneralProxyDomain.Size = New System.Drawing.Size(225, 22)
        Me.txtGeneralProxyDomain.TabIndex = 126
        '
        'Label34
        '
        Me.Label34.AutoSize = True
        Me.Label34.Location = New System.Drawing.Point(71, 59)
        Me.Label34.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label34.Name = "Label34"
        Me.Label34.Size = New System.Drawing.Size(60, 17)
        Me.Label34.TabIndex = 100
        Me.Label34.Text = "Domain:"
        '
        'txtGeneralProxyPassword
        '
        Me.txtGeneralProxyPassword.Location = New System.Drawing.Point(133, 119)
        Me.txtGeneralProxyPassword.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralProxyPassword.Name = "txtGeneralProxyPassword"
        Me.txtGeneralProxyPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
        Me.txtGeneralProxyPassword.Size = New System.Drawing.Size(225, 22)
        Me.txtGeneralProxyPassword.TabIndex = 128
        '
        'Label17
        '
        Me.Label17.AutoSize = True
        Me.Label17.Location = New System.Drawing.Point(57, 123)
        Me.Label17.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(73, 17)
        Me.Label17.TabIndex = 98
        Me.Label17.Text = "Password:"
        '
        'txtGeneralProxyUsername
        '
        Me.txtGeneralProxyUsername.Location = New System.Drawing.Point(133, 87)
        Me.txtGeneralProxyUsername.Margin = New System.Windows.Forms.Padding(4)
        Me.txtGeneralProxyUsername.Name = "txtGeneralProxyUsername"
        Me.txtGeneralProxyUsername.Size = New System.Drawing.Size(225, 22)
        Me.txtGeneralProxyUsername.TabIndex = 127
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(55, 91)
        Me.Label6.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(77, 17)
        Me.Label6.TabIndex = 94
        Me.Label6.Text = "Username:"
        '
        'chkGeneralProxy
        '
        Me.chkGeneralProxy.AutoSize = True
        Me.chkGeneralProxy.Location = New System.Drawing.Point(16, 311)
        Me.chkGeneralProxy.Margin = New System.Windows.Forms.Padding(4)
        Me.chkGeneralProxy.Name = "chkGeneralProxy"
        Me.chkGeneralProxy.Size = New System.Drawing.Size(168, 21)
        Me.chkGeneralProxy.TabIndex = 123
        Me.chkGeneralProxy.Text = "Enable Proxy Settings"
        Me.chkGeneralProxy.UseVisualStyleBackColor = True
        '
        'tabSmartLink
        '
        Me.tabSmartLink.Controls.Add(Me.pnlTransferSvc)
        Me.tabSmartLink.Controls.Add(Me.chkActivateTransferService)
        Me.tabSmartLink.Location = New System.Drawing.Point(4, 25)
        Me.tabSmartLink.Margin = New System.Windows.Forms.Padding(4)
        Me.tabSmartLink.Name = "tabSmartLink"
        Me.tabSmartLink.Padding = New System.Windows.Forms.Padding(4)
        Me.tabSmartLink.Size = New System.Drawing.Size(677, 564)
        Me.tabSmartLink.TabIndex = 1
        Me.tabSmartLink.Text = "SL Transfer"
        Me.tabSmartLink.UseVisualStyleBackColor = True
        '
        'pnlTransferSvc
        '
        Me.pnlTransferSvc.Controls.Add(Me.lblSmartLinkStatusColor)
        Me.pnlTransferSvc.Controls.Add(Me.cmdSmartLinkRestart)
        Me.pnlTransferSvc.Controls.Add(Me.cmbSmartLinkTrxfrDelay)
        Me.pnlTransferSvc.Controls.Add(Me.lblSmartLinkServiceStatus)
        Me.pnlTransferSvc.Controls.Add(Me.lblMinutes)
        Me.pnlTransferSvc.Controls.Add(Me.GroupBox1)
        Me.pnlTransferSvc.Controls.Add(Me.lblTrxfrDelay)
        Me.pnlTransferSvc.Controls.Add(Me.cmbSmartLinkAllowFileRename)
        Me.pnlTransferSvc.Controls.Add(Me.cmdSmartLinkStopStart)
        Me.pnlTransferSvc.Controls.Add(Me.cmbSmartLinkLogWSFiles)
        Me.pnlTransferSvc.Controls.Add(Me.Label13)
        Me.pnlTransferSvc.Controls.Add(Me.cmbSmartLinkBackupFiles)
        Me.pnlTransferSvc.Controls.Add(Me.Label18)
        Me.pnlTransferSvc.Controls.Add(Me.cmdSmartLinkViewErrorLog)
        Me.pnlTransferSvc.Controls.Add(Me.txtSmartLinkUploadedFileLog)
        Me.pnlTransferSvc.Controls.Add(Me.cmdSmartLinkViewUploadedFileLog)
        Me.pnlTransferSvc.Controls.Add(Me.Label16)
        Me.pnlTransferSvc.Controls.Add(Me.cmdSmartLinkBackupDirectory)
        Me.pnlTransferSvc.Controls.Add(Me.txtSmartLinkErrorLogFile)
        Me.pnlTransferSvc.Controls.Add(Me.txtSmartLinkBackupDirectory)
        Me.pnlTransferSvc.Controls.Add(Me.Label19)
        Me.pnlTransferSvc.Controls.Add(Me.Label23)
        Me.pnlTransferSvc.Enabled = False
        Me.pnlTransferSvc.Location = New System.Drawing.Point(8, 65)
        Me.pnlTransferSvc.Margin = New System.Windows.Forms.Padding(4)
        Me.pnlTransferSvc.Name = "pnlTransferSvc"
        Me.pnlTransferSvc.Size = New System.Drawing.Size(649, 446)
        Me.pnlTransferSvc.TabIndex = 91
        '
        'lblSmartLinkStatusColor
        '
        Me.lblSmartLinkStatusColor.ImageIndex = 1
        Me.lblSmartLinkStatusColor.ImageList = Me.CircleImages
        Me.lblSmartLinkStatusColor.Location = New System.Drawing.Point(19, 11)
        Me.lblSmartLinkStatusColor.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblSmartLinkStatusColor.Name = "lblSmartLinkStatusColor"
        Me.lblSmartLinkStatusColor.Size = New System.Drawing.Size(35, 32)
        Me.lblSmartLinkStatusColor.TabIndex = 50
        Me.lblSmartLinkStatusColor.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'cmdSmartLinkRestart
        '
        Me.cmdSmartLinkRestart.Location = New System.Drawing.Point(528, 14)
        Me.cmdSmartLinkRestart.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkRestart.Name = "cmdSmartLinkRestart"
        Me.cmdSmartLinkRestart.Size = New System.Drawing.Size(73, 28)
        Me.cmdSmartLinkRestart.TabIndex = 88
        Me.cmdSmartLinkRestart.Text = "Restart"
        Me.cmdSmartLinkRestart.UseVisualStyleBackColor = True
        '
        'cmbSmartLinkTrxfrDelay
        '
        Me.cmbSmartLinkTrxfrDelay.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbSmartLinkTrxfrDelay.FormattingEnabled = True
        Me.cmbSmartLinkTrxfrDelay.Items.AddRange(New Object() {"0", "2", "4", "6", "8", "10", "15", "20"})
        Me.cmbSmartLinkTrxfrDelay.Location = New System.Drawing.Point(187, 249)
        Me.cmbSmartLinkTrxfrDelay.Margin = New System.Windows.Forms.Padding(4)
        Me.cmbSmartLinkTrxfrDelay.Name = "cmbSmartLinkTrxfrDelay"
        Me.cmbSmartLinkTrxfrDelay.Size = New System.Drawing.Size(175, 24)
        Me.cmbSmartLinkTrxfrDelay.TabIndex = 62
        '
        'lblSmartLinkServiceStatus
        '
        Me.lblSmartLinkServiceStatus.AutoSize = True
        Me.lblSmartLinkServiceStatus.Location = New System.Drawing.Point(51, 20)
        Me.lblSmartLinkServiceStatus.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblSmartLinkServiceStatus.Name = "lblSmartLinkServiceStatus"
        Me.lblSmartLinkServiceStatus.Size = New System.Drawing.Size(172, 17)
        Me.lblSmartLinkServiceStatus.TabIndex = 51
        Me.lblSmartLinkServiceStatus.Text = "lblSmartLinkServiceStatus"
        Me.lblSmartLinkServiceStatus.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblMinutes
        '
        Me.lblMinutes.AutoSize = True
        Me.lblMinutes.Location = New System.Drawing.Point(373, 252)
        Me.lblMinutes.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblMinutes.Name = "lblMinutes"
        Me.lblMinutes.Size = New System.Drawing.Size(57, 17)
        Me.lblMinutes.TabIndex = 81
        Me.lblMinutes.Text = "minutes"
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.cmdSmartLinkExtraPollingFolders)
        Me.GroupBox1.Controls.Add(Me.cmdClearPolling2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.txtSmartLinkPath)
        Me.GroupBox1.Controls.Add(Me.Label9)
        Me.GroupBox1.Controls.Add(Me.txtSmartLinkPollingFolder1)
        Me.GroupBox1.Controls.Add(Me.cmdSmartLinkClearPolling1)
        Me.GroupBox1.Controls.Add(Me.Label14)
        Me.GroupBox1.Controls.Add(Me.txtSmartLinkPollingFolder2)
        Me.GroupBox1.Controls.Add(Me.cmdSmartLinkPath)
        Me.GroupBox1.Controls.Add(Me.cmdSmartLinkPollingFolder1)
        Me.GroupBox1.Controls.Add(Me.cmdSmartLinkPollingFolder2)
        Me.GroupBox1.Location = New System.Drawing.Point(21, 60)
        Me.GroupBox1.Margin = New System.Windows.Forms.Padding(4)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Padding = New System.Windows.Forms.Padding(4)
        Me.GroupBox1.Size = New System.Drawing.Size(617, 153)
        Me.GroupBox1.TabIndex = 52
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Polling Folders"
        '
        'cmdSmartLinkExtraPollingFolders
        '
        Me.cmdSmartLinkExtraPollingFolders.Location = New System.Drawing.Point(187, 114)
        Me.cmdSmartLinkExtraPollingFolders.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkExtraPollingFolders.Name = "cmdSmartLinkExtraPollingFolders"
        Me.cmdSmartLinkExtraPollingFolders.Size = New System.Drawing.Size(275, 28)
        Me.cmdSmartLinkExtraPollingFolders.TabIndex = 61
        Me.cmdSmartLinkExtraPollingFolders.Text = "Extra Polling Folders"
        Me.cmdSmartLinkExtraPollingFolders.UseVisualStyleBackColor = True
        '
        'cmdSmartLinkStopStart
        '
        Me.cmdSmartLinkStopStart.Location = New System.Drawing.Point(447, 14)
        Me.cmdSmartLinkStopStart.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSmartLinkStopStart.Name = "cmdSmartLinkStopStart"
        Me.cmdSmartLinkStopStart.Size = New System.Drawing.Size(73, 28)
        Me.cmdSmartLinkStopStart.TabIndex = 89
        Me.cmdSmartLinkStopStart.Text = "Stop"
        Me.cmdSmartLinkStopStart.UseVisualStyleBackColor = True
        '
        'txtSmartLinkUploadedFileLog
        '
        Me.txtSmartLinkUploadedFileLog.Location = New System.Drawing.Point(423, 345)
        Me.txtSmartLinkUploadedFileLog.Margin = New System.Windows.Forms.Padding(4)
        Me.txtSmartLinkUploadedFileLog.Name = "txtSmartLinkUploadedFileLog"
        Me.txtSmartLinkUploadedFileLog.ReadOnly = True
        Me.txtSmartLinkUploadedFileLog.Size = New System.Drawing.Size(31, 22)
        Me.txtSmartLinkUploadedFileLog.TabIndex = 68
        Me.txtSmartLinkUploadedFileLog.Visible = False
        '
        'Label16
        '
        Me.Label16.AutoSize = True
        Me.Label16.Location = New System.Drawing.Point(19, 384)
        Me.Label16.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(72, 17)
        Me.Label16.TabIndex = 87
        Me.Label16.Text = "Error Log:"
        '
        'txtSmartLinkErrorLogFile
        '
        Me.txtSmartLinkErrorLogFile.Location = New System.Drawing.Point(187, 380)
        Me.txtSmartLinkErrorLogFile.Margin = New System.Windows.Forms.Padding(4)
        Me.txtSmartLinkErrorLogFile.Name = "txtSmartLinkErrorLogFile"
        Me.txtSmartLinkErrorLogFile.ReadOnly = True
        Me.txtSmartLinkErrorLogFile.Size = New System.Drawing.Size(339, 22)
        Me.txtSmartLinkErrorLogFile.TabIndex = 70
        '
        'chkActivateTransferService
        '
        Me.chkActivateTransferService.AutoSize = True
        Me.chkActivateTransferService.Location = New System.Drawing.Point(31, 18)
        Me.chkActivateTransferService.Margin = New System.Windows.Forms.Padding(4)
        Me.chkActivateTransferService.Name = "chkActivateTransferService"
        Me.chkActivateTransferService.Size = New System.Drawing.Size(256, 21)
        Me.chkActivateTransferService.TabIndex = 90
        Me.chkActivateTransferService.Text = "Activate SmartLink Transfer Service"
        Me.chkActivateTransferService.UseVisualStyleBackColor = True
        '
        'tabUpdate
        '
        Me.tabUpdate.Controls.Add(Me.lblVersionInfo)
        Me.tabUpdate.Controls.Add(Me.chkDownloadAndInstallUpdates)
        Me.tabUpdate.Controls.Add(Me.grpGroupBox3)
        Me.tabUpdate.Controls.Add(Me.lblUpdateDesc)
        Me.tabUpdate.Controls.Add(Me.grpUpdateSchedule)
        Me.tabUpdate.Location = New System.Drawing.Point(4, 25)
        Me.tabUpdate.Margin = New System.Windows.Forms.Padding(4)
        Me.tabUpdate.Name = "tabUpdate"
        Me.tabUpdate.Padding = New System.Windows.Forms.Padding(4)
        Me.tabUpdate.Size = New System.Drawing.Size(677, 564)
        Me.tabUpdate.TabIndex = 2
        Me.tabUpdate.Text = "Application Updates"
        Me.tabUpdate.UseVisualStyleBackColor = True
        '
        'lblVersionInfo
        '
        Me.lblVersionInfo.AutoSize = True
        Me.lblVersionInfo.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblVersionInfo.Location = New System.Drawing.Point(31, 15)
        Me.lblVersionInfo.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblVersionInfo.Name = "lblVersionInfo"
        Me.lblVersionInfo.Size = New System.Drawing.Size(188, 17)
        Me.lblVersionInfo.TabIndex = 119
        Me.lblVersionInfo.Text = "<version text goes here>"
        '
        'chkDownloadAndInstallUpdates
        '
        Me.chkDownloadAndInstallUpdates.AutoSize = True
        Me.chkDownloadAndInstallUpdates.Location = New System.Drawing.Point(35, 154)
        Me.chkDownloadAndInstallUpdates.Margin = New System.Windows.Forms.Padding(4)
        Me.chkDownloadAndInstallUpdates.Name = "chkDownloadAndInstallUpdates"
        Me.chkDownloadAndInstallUpdates.Size = New System.Drawing.Size(374, 21)
        Me.chkDownloadAndInstallUpdates.TabIndex = 118
        Me.chkDownloadAndInstallUpdates.Text = "Automatically check for and install application updates."
        Me.chkDownloadAndInstallUpdates.UseVisualStyleBackColor = True
        '
        'grpGroupBox3
        '
        Me.grpGroupBox3.Controls.Add(Me.txtBoxCheckUpdateProgress)
        Me.grpGroupBox3.Controls.Add(Me.cmdCheck4Update)
        Me.grpGroupBox3.Controls.Add(Me.lblChkUpdatesNow)
        Me.grpGroupBox3.Location = New System.Drawing.Point(35, 356)
        Me.grpGroupBox3.Margin = New System.Windows.Forms.Padding(4)
        Me.grpGroupBox3.Name = "grpGroupBox3"
        Me.grpGroupBox3.Padding = New System.Windows.Forms.Padding(4)
        Me.grpGroupBox3.Size = New System.Drawing.Size(592, 166)
        Me.grpGroupBox3.TabIndex = 112
        Me.grpGroupBox3.TabStop = False
        Me.grpGroupBox3.Text = "Perform Update"
        '
        'txtBoxCheckUpdateProgress
        '
        Me.txtBoxCheckUpdateProgress.Location = New System.Drawing.Point(12, 52)
        Me.txtBoxCheckUpdateProgress.Margin = New System.Windows.Forms.Padding(4)
        Me.txtBoxCheckUpdateProgress.Multiline = True
        Me.txtBoxCheckUpdateProgress.Name = "txtBoxCheckUpdateProgress"
        Me.txtBoxCheckUpdateProgress.ReadOnly = True
        Me.txtBoxCheckUpdateProgress.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtBoxCheckUpdateProgress.Size = New System.Drawing.Size(571, 106)
        Me.txtBoxCheckUpdateProgress.TabIndex = 114
        '
        'cmdCheck4Update
        '
        Me.cmdCheck4Update.Location = New System.Drawing.Point(435, 20)
        Me.cmdCheck4Update.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdCheck4Update.Name = "cmdCheck4Update"
        Me.cmdCheck4Update.Size = New System.Drawing.Size(149, 28)
        Me.cmdCheck4Update.TabIndex = 113
        Me.cmdCheck4Update.Text = "Check for Updates"
        Me.cmdCheck4Update.UseVisualStyleBackColor = True
        '
        'lblChkUpdatesNow
        '
        Me.lblChkUpdatesNow.Location = New System.Drawing.Point(8, 26)
        Me.lblChkUpdatesNow.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblChkUpdatesNow.Name = "lblChkUpdatesNow"
        Me.lblChkUpdatesNow.Size = New System.Drawing.Size(441, 22)
        Me.lblChkUpdatesNow.TabIndex = 113
        Me.lblChkUpdatesNow.Text = "Clicking the button on the right will immediately check for updates."
        '
        'lblUpdateDesc
        '
        Me.lblUpdateDesc.AutoEllipsis = True
        Me.lblUpdateDesc.Location = New System.Drawing.Point(31, 71)
        Me.lblUpdateDesc.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.lblUpdateDesc.Name = "lblUpdateDesc"
        Me.lblUpdateDesc.Size = New System.Drawing.Size(588, 55)
        Me.lblUpdateDesc.TabIndex = 103
        Me.lblUpdateDesc.Text = resources.GetString("lblUpdateDesc.Text")
        '
        'grpUpdateSchedule
        '
        Me.grpUpdateSchedule.Controls.Add(Me.dpAppUpdateTime)
        Me.grpUpdateSchedule.Controls.Add(Me.lblAppUpdateScheduleType)
        Me.grpUpdateSchedule.Controls.Add(Me.cmdAppUpdateWeekdaysDetails)
        Me.grpUpdateSchedule.Controls.Add(Me.cmbAppUpdateScheduleType)
        Me.grpUpdateSchedule.Controls.Add(Me.txtAppUpdateScheduleWeeklyDays)
        Me.grpUpdateSchedule.Controls.Add(Me.Label30)
        Me.grpUpdateSchedule.Controls.Add(Me.lblAppUpdateScheduleWeeklyDays)
        Me.grpUpdateSchedule.Controls.Add(Me.txtAppUpdateScheduleInterval)
        Me.grpUpdateSchedule.Controls.Add(Me.Label32)
        Me.grpUpdateSchedule.Controls.Add(Me.Label33)
        Me.grpUpdateSchedule.Enabled = False
        Me.grpUpdateSchedule.Location = New System.Drawing.Point(35, 196)
        Me.grpUpdateSchedule.Margin = New System.Windows.Forms.Padding(4)
        Me.grpUpdateSchedule.Name = "grpUpdateSchedule"
        Me.grpUpdateSchedule.Padding = New System.Windows.Forms.Padding(4)
        Me.grpUpdateSchedule.Size = New System.Drawing.Size(592, 135)
        Me.grpUpdateSchedule.TabIndex = 104
        Me.grpUpdateSchedule.TabStop = False
        Me.grpUpdateSchedule.Text = "Schedule Details"
        '
        'cmdSaveSettings
        '
        Me.cmdSaveSettings.Location = New System.Drawing.Point(456, 615)
        Me.cmdSaveSettings.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdSaveSettings.Name = "cmdSaveSettings"
        Me.cmdSaveSettings.Size = New System.Drawing.Size(100, 28)
        Me.cmdSaveSettings.TabIndex = 216
        Me.cmdSaveSettings.Text = "Save"
        Me.cmdSaveSettings.UseVisualStyleBackColor = True
        '
        'cmdClose
        '
        Me.cmdClose.Location = New System.Drawing.Point(304, 615)
        Me.cmdClose.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdClose.Name = "cmdClose"
        Me.cmdClose.Size = New System.Drawing.Size(100, 28)
        Me.cmdClose.TabIndex = 215
        Me.cmdClose.Text = "Close"
        Me.cmdClose.UseVisualStyleBackColor = True
        '
        'CheckServiceStatus
        '
        Me.CheckServiceStatus.Enabled = True
        Me.CheckServiceStatus.Interval = 500
        '
        'cmdHelp
        '
        Me.cmdHelp.Location = New System.Drawing.Point(148, 615)
        Me.cmdHelp.Margin = New System.Windows.Forms.Padding(4)
        Me.cmdHelp.Name = "cmdHelp"
        Me.cmdHelp.Size = New System.Drawing.Size(100, 28)
        Me.cmdHelp.TabIndex = 214
        Me.cmdHelp.Text = "Help"
        Me.cmdHelp.UseVisualStyleBackColor = True
        '
        'frmConfig
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(8.0!, 16.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(715, 658)
        Me.Controls.Add(Me.cmdHelp)
        Me.Controls.Add(Me.cmdClose)
        Me.Controls.Add(Me.cmdSaveSettings)
        Me.Controls.Add(Me.tabSettings)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.HelpButton = True
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.KeyPreview = True
        Me.Margin = New System.Windows.Forms.Padding(4)
        Me.MaximizeBox = False
        Me.Name = "frmConfig"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "NRC Service Manager"
        Me.tabSettings.ResumeLayout(False)
        Me.tabGeneral.ResumeLayout(False)
        Me.tabGeneral.PerformLayout()
        Me.grpGeneralProxySettings.ResumeLayout(False)
        Me.grpGeneralProxySettings.PerformLayout()
        Me.tabSmartLink.ResumeLayout(False)
        Me.tabSmartLink.PerformLayout()
        Me.pnlTransferSvc.ResumeLayout(False)
        Me.pnlTransferSvc.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.tabUpdate.ResumeLayout(False)
        Me.tabUpdate.PerformLayout()
        Me.grpGroupBox3.ResumeLayout(False)
        Me.grpGroupBox3.PerformLayout()
        Me.grpUpdateSchedule.ResumeLayout(False)
        Me.grpUpdateSchedule.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ttInfo As System.Windows.Forms.ToolTip
    Friend WithEvents tabSettings As System.Windows.Forms.TabControl
    Friend WithEvents tabSmartLink As System.Windows.Forms.TabPage
    Friend WithEvents cmdSaveSettings As System.Windows.Forms.Button
    Friend WithEvents cmdClose As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label19 As System.Windows.Forms.Label
    Friend WithEvents txtSmartLinkErrorLogFile As System.Windows.Forms.TextBox
    Friend WithEvents Label16 As System.Windows.Forms.Label
    Friend WithEvents txtSmartLinkUploadedFileLog As System.Windows.Forms.TextBox
    Friend WithEvents Label18 As System.Windows.Forms.Label
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents txtSmartLinkPollingFolder2 As System.Windows.Forms.TextBox
    Friend WithEvents Label14 As System.Windows.Forms.Label
    Friend WithEvents txtSmartLinkPollingFolder1 As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents txtSmartLinkPath As System.Windows.Forms.TextBox
    Friend WithEvents txtSmartLinkBackupDirectory As System.Windows.Forms.TextBox
    Friend WithEvents Label23 As System.Windows.Forms.Label
    Friend WithEvents cmdSmartLinkViewErrorLog As System.Windows.Forms.Button
    Friend WithEvents cmdSmartLinkViewUploadedFileLog As System.Windows.Forms.Button
    Friend WithEvents cmdSmartLinkBackupDirectory As System.Windows.Forms.Button
    Friend WithEvents cmdSmartLinkPollingFolder2 As System.Windows.Forms.Button
    Friend WithEvents cmdSmartLinkPollingFolder1 As System.Windows.Forms.Button
    Friend WithEvents cmdSmartLinkPath As System.Windows.Forms.Button
    Friend WithEvents cmbSmartLinkAllowFileRename As System.Windows.Forms.ComboBox
    Friend WithEvents cmbSmartLinkLogWSFiles As System.Windows.Forms.ComboBox
    Friend WithEvents cmbSmartLinkBackupFiles As System.Windows.Forms.ComboBox
    Friend WithEvents fbdFolderBrowserDialog As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents cmdClearPolling2 As System.Windows.Forms.Button
    Friend WithEvents cmdSmartLinkClearPolling1 As System.Windows.Forms.Button
    Friend WithEvents CheckServiceStatus As System.Windows.Forms.Timer
    Friend WithEvents CircleImages As System.Windows.Forms.ImageList
    Friend WithEvents lblSmartLinkStatusColor As System.Windows.Forms.Label
    Friend WithEvents lblSmartLinkServiceStatus As System.Windows.Forms.Label
    Friend WithEvents cmdHelp As System.Windows.Forms.Button
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents cmdSmartLinkExtraPollingFolders As System.Windows.Forms.Button
    Friend WithEvents lblTrxfrDelay As System.Windows.Forms.Label
    Friend WithEvents lblMinutes As System.Windows.Forms.Label
    Friend WithEvents cmbSmartLinkTrxfrDelay As System.Windows.Forms.ComboBox
    Friend WithEvents tabUpdate As System.Windows.Forms.TabPage
    Friend WithEvents grpUpdateSchedule As System.Windows.Forms.GroupBox
    Friend WithEvents lblAppUpdateScheduleType As System.Windows.Forms.Label
    Friend WithEvents cmdAppUpdateWeekdaysDetails As System.Windows.Forms.Button
    Friend WithEvents cmbAppUpdateScheduleType As System.Windows.Forms.ComboBox
    Friend WithEvents txtAppUpdateScheduleWeeklyDays As System.Windows.Forms.TextBox
    Friend WithEvents Label30 As System.Windows.Forms.Label
    Friend WithEvents lblAppUpdateScheduleWeeklyDays As System.Windows.Forms.Label
    Friend WithEvents txtAppUpdateScheduleInterval As System.Windows.Forms.TextBox
    Friend WithEvents Label32 As System.Windows.Forms.Label
    Friend WithEvents Label33 As System.Windows.Forms.Label
    Friend WithEvents lblUpdateDesc As System.Windows.Forms.Label
    Friend WithEvents grpGroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents lblChkUpdatesNow As System.Windows.Forms.Label
    Friend WithEvents tabGeneral As System.Windows.Forms.TabPage
    Friend WithEvents grpGeneralProxySettings As System.Windows.Forms.GroupBox
    Friend WithEvents txtGeneralProxyPort As System.Windows.Forms.TextBox
    Friend WithEvents Label35 As System.Windows.Forms.Label
    Friend WithEvents txtGeneralProxyIPAddress As System.Windows.Forms.TextBox
    Friend WithEvents Label31 As System.Windows.Forms.Label
    Friend WithEvents txtGeneralProxyDomain As System.Windows.Forms.TextBox
    Friend WithEvents Label34 As System.Windows.Forms.Label
    Friend WithEvents txtGeneralProxyPassword As System.Windows.Forms.TextBox
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents chkGeneralProxy As System.Windows.Forms.CheckBox
    Friend WithEvents txtGeneralProxyUsername As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents txtGeneralProxyPassword2 As System.Windows.Forms.TextBox
    Friend WithEvents lblGeneralRetryPassword As System.Windows.Forms.Label
    Friend WithEvents txtGeneralSmartLinkWS As System.Windows.Forms.TextBox
    Friend WithEvents Label37 As System.Windows.Forms.Label
    Friend WithEvents txtGeneralInstallKey As System.Windows.Forms.TextBox
    Friend WithEvents Label29 As System.Windows.Forms.Label
    Friend WithEvents Label27 As System.Windows.Forms.Label
    Friend WithEvents txtGeneralProviderNumber As System.Windows.Forms.TextBox
    Friend WithEvents Label28 As System.Windows.Forms.Label
    Friend WithEvents cmdGeneralTestEmail As System.Windows.Forms.Button
    Friend WithEvents txtGeneralOperatorEmail As System.Windows.Forms.TextBox
    Friend WithEvents Label25 As System.Windows.Forms.Label
    Friend WithEvents txtGeneralSMTPServer As System.Windows.Forms.TextBox
    Friend WithEvents Label24 As System.Windows.Forms.Label
    Friend WithEvents lblGeneralPasswordMessage As System.Windows.Forms.Label
    Friend WithEvents lblGeneralPasswordStatusColor As System.Windows.Forms.Label
    Friend WithEvents lblGeneralWebServiceStatusColor As System.Windows.Forms.Label
    Friend WithEvents lblGeneralWebServiceStatus As System.Windows.Forms.Label
    Friend WithEvents cmdSmartLinkStopStart As System.Windows.Forms.Button
    Friend WithEvents cmdSmartLinkRestart As System.Windows.Forms.Button
    Friend WithEvents chkDownloadAndInstallUpdates As System.Windows.Forms.CheckBox
    Friend WithEvents cmdCheck4Update As System.Windows.Forms.Button
    Friend WithEvents dpAppUpdateTime As System.Windows.Forms.DateTimePicker
    Friend WithEvents chkActivateTransferService As System.Windows.Forms.CheckBox
    Friend WithEvents pnlTransferSvc As System.Windows.Forms.Panel
    Friend WithEvents txtConfigRootPath As System.Windows.Forms.TextBox
    Friend WithEvents cmdConfigRootPath As System.Windows.Forms.Button
    Friend WithEvents Label15 As System.Windows.Forms.Label
    Friend WithEvents lblVersionInfo As System.Windows.Forms.Label
    Friend WithEvents txtBoxCheckUpdateProgress As System.Windows.Forms.TextBox
    Friend WithEvents txtGeneralAgencyID As System.Windows.Forms.TextBox

End Class
