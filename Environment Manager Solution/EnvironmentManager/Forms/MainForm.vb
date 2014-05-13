Imports Microsoft.Win32
Imports System.Security.Permissions
Imports EnvironmentManager.Library
Imports Nrc.Framework.BusinessLogic.Configuration
<Assembly: RegistryPermissionAttribute(SecurityAction.RequestMinimum, _
 Read:="HKEY_LOCAL_MACHINE\Software\NRCPicker"), _
Assembly: RegistryPermissionAttribute(SecurityAction.RequestMinimum, _
 Write:="HKEY_LOCAL_MACHINE\Software\NRCPicker"), _
 Assembly: UIPermission(SecurityAction.RequestMinimum)> 

Public Class MainForm
#Region "Private Fields"
    Private WithEvents controller As New EnvironmentController
    Private mCanExit As Boolean
    Private mLastSetting As QualproParams
    Private changeEnvironmentEventHandler As New EventHandler(AddressOf ToolStripMenuItem_Click)

#End Region
#Region "Private Properties"
    Private ReadOnly Property CurSetting() As library.QualproParams
        Get
            Return CType(Me.bsSettingsRow.Current, library.QualproParams)
        End Get
    End Property
#End Region
#Region "Event handlers"
    Private Sub EnvironmentToolStripComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EnvironmentToolStripComboBox.SelectedIndexChanged
        SetEnvironmentTo(EnvironmentToolStripComboBox.Text)
    End Sub
    Private Sub ExportToSQLToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportToSQLToolStripButton.Click
        Dim filter As DevExpress.XtraGrid.Views.Base.ViewFilter = ParamGridView.ActiveFilter
        Dim FilterExpression As String = String.Empty
        If Not filter.IsEmpty Then
            FilterExpression = filter.Expression
        End If
        Dim ExportForm As New ExportToSQLForm(EnvironmentController.ConfigConnectionValue, FilterExpression)
        ExportForm.ShowDialog()
    End Sub
#Region "Controls on Environment Settings tab"



    Private Sub btnEditXML_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEditXML.Click
        Dim frm As New Form()
        Dim XMLEditorForm As New EditXMLForm
        XMLEditorForm.ShowDialog()
    End Sub

    Private Sub btnNew_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNew.Click
        If Config.EnvironmentExists(cboCurrentEnvironment.Text) Then
            MessageBox.Show("Please, enter a name for your new environment in the dropdown box.")
        Else
            'Create the new environment. It will be saved to the xml file.
            Dim NewEnvironment As New Nrc.Framework.Configuration.Environment
            NewEnvironment.Name = cboCurrentEnvironment.Text
            NewEnvironment.Settings.Add(New Nrc.Framework.Configuration.Setting("ConfigurationConnection", Me.txtConnectionString.Text))
            NewEnvironment.Settings.Add(New Nrc.Framework.Configuration.Setting("NrcAuthConnection", Me.txtNrcAuthConnectionString.Text))
            NewEnvironment.Settings.Add(New Nrc.Framework.Configuration.Setting("SMTPServer", Me.txtSMTPServer.Text))
            NewEnvironment.Settings.Add(New Nrc.Framework.Configuration.Setting("SQLTimeOutValue", Me.txtSQLTimeOut.Text))
            Config.EnvironmentSettings.Environments.Add(NewEnvironment)
            Config.CurrentEnvironmentName = NewEnvironment.Name
            Config.Save()
            'Refresh comboboxes to show the new environment name.
            BindComboBoxes()
            'Set the environment to the newly created environment
            SetEnvironmentTo(NewEnvironment.Name)
        End If
    End Sub
    'Saves the entered connection string to the registry and if chkSaveAsDefault is checked then also to the xml file
    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Not EnvironmentController.Save(Me.txtConnectionString.Text, Me.txtSMTPServer.Text, Me.txtSQLTimeOut.Text) Then
            MessageBox.Show(EnvironmentController.Message.ToString)
        Else
            If chkSaveAsDefault.Checked Then
                Config.SetSettingValue("ConfigurationConnection", Me.txtConnectionString.Text)
                Config.SetSettingValue("SMTPServer", Me.txtSMTPServer.Text)
                Config.SetSettingValue("SQLTimeOutValue", Me.txtSQLTimeOut.Text)
                Config.SetSettingValue("NrcAuthConnection", Me.txtNrcAuthConnectionString.Text)
                Config.Save()
            End If
        End If
    End Sub
    Private Sub btnBuildConnection_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuildQualisysConnection.Click
        Dim ConnectionBuilder As New ConnectionBuilderForm()
        If ConnectionBuilder.ShowDialog() = Windows.Forms.DialogResult.OK Then
            Me.txtConnectionString.Text = ConnectionBuilder.ConnectionString
            Me.txtConnectionString.Refresh()
        End If
    End Sub
    Private Sub btnBuildNrcAuthConnection_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuildNrcAuthConnection.Click
        Dim ConnectionBuilder As New ConnectionBuilderForm()
        If ConnectionBuilder.ShowDialog() = Windows.Forms.DialogResult.OK Then
            Me.txtNrcAuthConnectionString.Text = ConnectionBuilder.ConnectionString
            Me.txtNrcAuthConnectionString.Refresh()
        End If
    End Sub
    Private Sub btnReset_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnReset.Click
        EnvironmentController.Reset()
        RefreshDisplay()
    End Sub
    Private Sub SetEnvironmentTo(ByVal selectedEnvironment As String)
        If Not String.Equals(EnvironmentController.CurrentEnvironmentName, selectedEnvironment, StringComparison.CurrentCultureIgnoreCase) Then
            EnvironmentController.SetEnvironmentTo(ToProperCase(selectedEnvironment))
            'EnvironmentController.CurrentEnvironmentName = ToProperCase(selectedEnvironment)
            SetupContextMenu()
        End If
    End Sub
    Private Sub cboCurrentEnvironment_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboCurrentEnvironment.SelectedIndexChanged
        SetEnvironmentTo(cboCurrentEnvironment.Text)
    End Sub
#End Region
#Region "BindingNavigators and their controls event handlers"
    Private Sub SaveAdminsToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveAdminsToolStripButton.Click
        Config.SetSettingValue("SuperAdminUsers", GetCommaSeparatedListOfAdmins())
        Config.Save()
    End Sub

    Private Sub BindingNavigatorAddNewAdmin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BindingNavigatorAddNewAdmin.Click
        bsAdmins.AddNew()
    End Sub
    Private Sub RefreshToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefreshToolStripButton.Click
        Me.RefreshSettings()
    End Sub
    Private Sub SaveAllToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveAllToolStripButton.Click
        If MessageBox.Show("Do you want to save all changes?", "Save All", MessageBoxButtons.YesNo) = Windows.Forms.DialogResult.Yes Then
            Dim UnsavableSettings As New QUALPRO_PARAMSCollection
            For Each setting As QualproParams In CType(Me.bsSettingsRow.List, QUALPRO_PARAMSCollection)
                If setting.IsSavable Then
                    setting.Save()
                Else
                    If setting.IsDirty Then
                        UnsavableSettings.Add(setting)
                    End If
                End If
            Next
            If UnsavableSettings.Count > 0 Then
                Dim msg As New System.Text.StringBuilder
                msg.AppendLine("Cannot save the following settings")
                For Each setting As QualproParams In UnsavableSettings
                    msg.AppendLine(String.Format("ID={0} , Name = {1}", setting.PARAM_ID, setting.STRPARAM_NM))
                Next
                MessageBox.Show(msg.ToString, "Cannot Save All", MessageBoxButtons.OK)
            End If
        End If
    End Sub
    Private Sub SaveToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveToolStripButton.Click
        If CurSetting.IsSavable Then
            If MessageBox.Show("Do you want to save the setting?", CurSetting.STRPARAM_NM, MessageBoxButtons.YesNo) = Windows.Forms.DialogResult.Yes Then
                CurSetting.Save()
            End If
        End If
    End Sub
    Private Sub ExportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportButton.Click
        Me.ExportButtonClick()
    End Sub
    Private Sub BindingNavigatorDeleteItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BindingNavigatorDeleteItem.Click
        If MessageBox.Show("Are you sure you want to delete the setting?", "You are about to delete the setting from Qualpro_Params table.", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) = Windows.Forms.DialogResult.Yes Then
            If CurSetting IsNot Nothing Then
                CurSetting.Delete()
                Me.RefreshSettings()
            End If
        End If
    End Sub
#End Region
#Region "Context Menue Event Handlers"
    Private Sub EditToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowToolStripMenuItem.Click
        ShowForm()
    End Sub
    'Restores the original connection string for the selected environment
    Private Sub RefreshToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResetToolStripMenuItem.Click
        EnvironmentController.Reset()
        RefreshDisplay()
    End Sub
    Private Sub ToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim itemText As String = CType(sender, ToolStripMenuItem).Text
        If String.Equals(itemText, "Exit", StringComparison.CurrentCultureIgnoreCase) Then
            controller.StopRegistryMonitor()
            mCanExit = True
            Me.Close()
        ElseIf String.Equals(itemText, "Show", StringComparison.CurrentCultureIgnoreCase) Then
            ShowForm()
        Else
            SetEnvironmentTo(CType(sender, ToolStripMenuItem).Text)
        End If
    End Sub
    Private Sub NotifyIcon1_MouseDoubleClick(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles NotifyIcon1.MouseDoubleClick
        ShowForm()
    End Sub
#End Region
#Region "Form Event Handlers"
    Private Sub Form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not EnvironmentController.IsRegistrySetUP OrElse (Not EnvironmentController.IsCurrentEnvironmentSynched) Then
            Dim InitialSetupForm As New SelectInitialEnvironmentForm(controller)
            If InitialSetupForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                If EnvironmentController.IsRegistrySetUP Then
                    Start()
                End If
            End If
        Else
            Start()
        End If
    End Sub

    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If Not mCanExit Then
            e.Cancel = True
            Me.Hide()
        End If
    End Sub
    'This is necessary to allow Windows Log Off and Shut Down
    Protected Overrides Sub WndProc(ByRef m As System.Windows.Forms.Message)
        Const WM_QUERYENDSESSION As Integer = &H11
        If m.Msg = WM_QUERYENDSESSION Then
            mCanExit = True
        End If
        MyBase.WndProc(m)
    End Sub
#End Region
#Region "controller Event Handlers"
    Private Sub controller_ErrorOccurred(ByVal sender As Object, ByVal e As IO.ErrorEventArgs) Handles controller.ErrorOccurred
        If InvokeRequired Then
            BeginInvoke(New IO.ErrorEventHandler(AddressOf controller_ErrorOccurred), New Object() {sender, e})
            Exit Sub
        End If

        Me.NotifyIcon1.BalloonTipText = String.Format("ERROR: {0}", e.GetException().Message)
        Me.NotifyIcon1.BalloonTipIcon = ToolTipIcon.Error
        Me.NotifyIcon1.ShowBalloonTip(300)
    End Sub
    Private Sub controller_EnvironmentChanged(ByVal sender As Object, ByVal e As EventArgs) Handles controller.EnvironmentChanged
        If InvokeRequired Then
            BeginInvoke(New EventHandler(AddressOf controller_EnvironmentChanged), New Object() {sender, e})
            Exit Sub
        End If
        'Reset()
        Me.NotifyIcon1.BalloonTipText = String.Format("Environment has changed to {0}.", ToProperCase(EnvironmentController.CurrentEnvironmentName))
        Me.NotifyIcon1.BalloonTipIcon = ToolTipIcon.Info
        Me.NotifyIcon1.ShowBalloonTip(300)

        RefreshDisplay()
        CheckPermissions()
    End Sub

#End Region
#Region "ParamGridView Event handlers"
#End Region
#Region "bsSettingsRow Event Handlers"
    Private Sub bsSettingsRow_CurrentItemChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles bsSettingsRow.CurrentItemChanged
        If CurSetting IsNot Nothing Then
            Me.SaveToolStripButton.Enabled = CurSetting.IsSavable
        Else
            Me.SaveAllToolStripButton.Enabled = False
        End If
    End Sub
#End Region
#End Region
#Region "Private Methods"

    Private Sub BindComboBoxes()
        Me.cboCurrentEnvironment.Items.Clear()
        Me.EnvironmentToolStripComboBox.ComboBox.Items.Clear()
        For Each key As String In Config.EnvironmentSettings.Environments.Keys
            Me.cboCurrentEnvironment.Items.Add(key)
            Me.EnvironmentToolStripComboBox.ComboBox.Items.Add(key)
        Next
        'Config.CurrentEnvironmentName = ""
    End Sub
    Private Function GetCommaSeparatedListOfAdmins() As String
        If bsAdmins.Count <= 0 Then Return String.Empty

        Dim AdminList As New System.Text.StringBuilder
        For Each Stdy As SuperAdmin In bsAdmins.List
            AdminList.Append(Stdy.SuperAdminUserName)
            AdminList.Append(",")
        Next
        Dim CommaSeparatedList As String = AdminList.ToString
        If Not String.IsNullOrEmpty(CommaSeparatedList) Then
            CommaSeparatedList = CommaSeparatedList.Remove(CommaSeparatedList.LastIndexOf(","c))
        End If
        Return CommaSeparatedList
    End Function
    Private Sub Start()
        controller.StartMonitoring()
        RefreshDisplay()
        CheckPermissions()
    End Sub
    Private Sub RefreshSettings()
        Me.bsSettingsRow.DataSource = GetSettingValues()
    End Sub
    Private Sub ExportButtonClick()
        Dim SaveFileDialog As New SaveFileDialog()
        With SaveFileDialog
            .Title = "Export To Excel"
            .DefaultExt = "xls"
            .FileName = String.Empty
            .Filter = "Excel Files (*.xls)|*.xls"
            If .ShowDialog() = DialogResult.OK Then
                Me.Cursor = Cursors.WaitCursor
                Dim ExportOptions As New DevExpress.XtraPrinting.XlsExportOptions(True)
                ParamGridView.ExportToXls(.FileName, ExportOptions)
                Me.Cursor = Cursors.Default
            End If
        End With
    End Sub


    Private Sub CheckPermissions()
        If Not CurrentUser.HasApplicationAccess Then
            controller.StopRegistryMonitor()
            MessageBox.Show( _
            String.Format("You don't have access to this application in {0} environment.", Config.CurrentEnvironmentName))
            Me.mCanExit = True
            Me.Close()
            Exit Sub
        End If

        Dim IsAdmin As Boolean = CurrentUser.CanEditSettings

        Me.ParamGridView.OptionsBehavior.Editable = IsAdmin
        Me.BindingNavigatorDeleteItem.Visible = IsAdmin
        Me.BindingNavigatorAddNewItem.Visible = IsAdmin
        Me.SaveToolStripButton.Visible = IsAdmin
        Me.SaveAllToolStripButton.Visible = IsAdmin
        Me.ExportToSQLToolStripButton.Visible = IsAdmin
        If Not IsAdmin AndAlso Not CurrentUser.IsSuperAdmin Then
            Me.TabControlEnvManager.TabPages.Remove(TabEnvEditor)
            Me.cboCurrentEnvironment.Enabled = False
        End If
        If Not CurrentUser.IsSuperAdmin Then
            Me.TabControlEnvManager.TabPages.Remove(TabAdministration)
        Else
            bsAdmins.DataSource = Config.SuperAdminUsers
            bsAdmins.AllowNew = True
            grdAdminUsers.DataSource = bsAdmins
        End If
        ExitToolStripMenuItem.Visible = True
        ShowToolStripMenuItem.Visible = True
    End Sub
    Private Sub ShowForm()
        Me.Visible = True
        Me.WindowState = FormWindowState.Normal
        Me.Show()
        Me.Focus()
    End Sub
    Private Sub SetupContextMenu()
        Me.cmsEnvironments.Items.Clear()
        Dim CurrentEnvironmentName As String = EnvironmentController.CurrentEnvironmentName
        For Each name As String In Config.EnvironmentSettings.Environments.Keys
            'Dim ProperName As String = name.Replace(name.Substring(0, 1), UCase(name.Substring(0, 1)))
            Dim newItem As New ToolStripMenuItem(ToProperCase(name), Nothing, changeEnvironmentEventHandler)
            If String.Equals(name, CurrentEnvironmentName, StringComparison.CurrentCultureIgnoreCase) Then
                newItem.Checked = True
            End If
            Me.cmsEnvironments.Items.Add(newItem)
        Next
        Dim separator As New ToolStripSeparator()

        Me.cmsEnvironments.Items.Add(separator)
        Me.cmsEnvironments.Items.Add("Show", Nothing, changeEnvironmentEventHandler)
        Me.cmsEnvironments.Items.Add("Exit", Nothing, changeEnvironmentEventHandler)
    End Sub
    Private Shared Function ToProperCase(ByVal TextValue As String) As String
        TextValue = LCase(TextValue)
        Dim ProperCaseValue As String = Char.ToUpper(TextValue.Chars(0)) & TextValue.Substring(1, TextValue.Length - 1)
        Return ProperCaseValue
    End Function
    Private Sub RefreshDisplay()
        If EnvironmentController.EnvironmentCountChanged Then
            SetupContextMenu()
            EnvironmentController.EnvironmentCountChanged = False
        End If
        Dim currentEnvironmentName As String = EnvironmentController.CurrentEnvironmentName
        TestingToolStripMenuItem.Checked = False
        StagingToolStripMenuItem.Checked = False
        ProductionToolStripMenuItem.Checked = False
        DevelopmentToolStripMenuItem.Checked = False
        Me.NotifyIcon1.Text = currentEnvironmentName
        Me.cboCurrentEnvironment.Text = currentEnvironmentName
        Me.EnvironmentToolStripComboBox.Text = currentEnvironmentName
        Me.bsSettingsRow.DataSource = GetSettingValues()
        Me.txtConnectionString.Text = Config.ConfigurationConnection
        Me.txtNrcAuthConnectionString.Text = Config.NrcAuthConnection()
        Me.txtSMTPServer.Text = EnvironmentController.SMTPServerValue
        If EnvironmentController.SQLTimeOutValue.HasValue Then
            Me.txtSQLTimeOut.Text = EnvironmentController.SQLTimeOutValue.ToString
        End If

        '' if a user pastes encrypted conn string in the textbox then he\she should check the checkbox
        ''controller always encrypts before saving and decripts before returning the registry value
        ''unless you check the checkbox saying that you pasted encrypted string, controller will encrypt.
        Select Case UCase(currentEnvironmentName)
            Case "TESTING"
                Me.NotifyIcon1.Icon = My.Resources.HouseGreen
                TestingToolStripMenuItem.Checked = True
            Case "STAGING"
                Me.NotifyIcon1.Icon = My.Resources.HouseYellow
                StagingToolStripMenuItem.Checked = True
            Case "PRODUCTION"
                Me.NotifyIcon1.Icon = My.Resources.HouseRed
                ProductionToolStripMenuItem.Checked = True
            Case "DEVELOPMENT"
                Me.NotifyIcon1.Icon = My.Resources.Green_light
                DevelopmentToolStripMenuItem.Checked = True
            Case Else
                Me.NotifyIcon1.Icon = My.Resources.Red_light
        End Select
    End Sub
    Private Function GetSettingValues() As EnvironmentManager.library.QUALPRO_PARAMSCollection
        Try
            QualproParamsProvider.Instance.QualisysConnectionString = Config.ConfigurationConnection
            Return QualproParams.GetAll
        Catch ex As Exception
            MessageBox.Show(ex.InnerException.Message, "Couldn't load settings from QualPro_Params table", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return Nothing
        End Try
    End Function
    Private Function BuildDebugMessageShowLastSetting(Optional ByVal CallerName As String = "") As String
        Dim Message As String = String.Empty
        If mLastSetting IsNot Nothing Then
            Message = String.Format("{0}. ParamID={1} Param_Type={2} ", CallerName, CurSetting.PARAM_ID.ToString, CurSetting.STRPARAM_TYPE)
        End If
        Return Message
    End Function
#End Region
#Region "Public Methods"
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        'Dim EnvironmentList As New List(Of Nrc.Framework.Configuration.Environment)
        'For I As Integer = 0 To Config.EnvironmentSettings.Environments.Count - 1
        '    EnvironmentList.Add(Config.EnvironmentSettings.Environments.Item(I))
        'Next
        BindComboBoxes()
    End Sub
#End Region
End Class
