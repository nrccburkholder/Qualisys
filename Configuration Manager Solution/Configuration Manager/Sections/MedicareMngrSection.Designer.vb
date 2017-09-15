<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class MedicareMngrSection
    Inherits Qualisys.ConfigurationManager.Section

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.MedicareManagementSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.CAHPSTabControl = New System.Windows.Forms.TabControl()
        Me.HCAHPS = New System.Windows.Forms.TabPage()
        Me.HCAHPS_CancelButton = New System.Windows.Forms.Button()
        Me.HCAHPS_ApplyButton = New System.Windows.Forms.Button()
        Me.MedicareCalcHistoryButton = New System.Windows.Forms.Button()
        Me.MedicareUnlockSamplingButton = New System.Windows.Forms.Button()
        Me.MedicareReCalcButton = New System.Windows.Forms.Button()
        Me.NonSubmittingCheckbox = New System.Windows.Forms.CheckBox()
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel()
        Me.LastCalculatedPanel = New System.Windows.Forms.Panel()
        Me.LastCalcDateLabel = New System.Windows.Forms.Label()
        Me.LastCalcDateTextBox = New System.Windows.Forms.TextBox()
        Me.CalculatedProportionPanel = New System.Windows.Forms.Panel()
        Me.CalcProportionLabel = New System.Windows.Forms.Label()
        Me.CalcProportionNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.SamplingLockStatusPanel = New System.Windows.Forms.Panel()
        Me.SampleLockLabel = New System.Windows.Forms.Label()
        Me.SamplingLockTextBox = New System.Windows.Forms.TextBox()
        Me.LastCalcTypePanel = New System.Windows.Forms.Panel()
        Me.LastCalcTypeLabel = New System.Windows.Forms.Label()
        Me.LastCalcTypeTextBox = New System.Windows.Forms.TextBox()
        Me.ProportionUsedPanel = New System.Windows.Forms.Panel()
        Me.ProportionUsedLabel = New System.Windows.Forms.Label()
        Me.ProportionUsedNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.InactiveCheckBox = New System.Windows.Forms.CheckBox()
        Me.NextCalcGroupBox = New System.Windows.Forms.GroupBox()
        Me.NextCalcTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel()
        Me.HistoricPanel = New System.Windows.Forms.Panel()
        Me.HistoricGroupBox = New System.Windows.Forms.GroupBox()
        Me.HistoricWarningPictureBox = New System.Windows.Forms.PictureBox()
        Me.HistoricWarningLabel = New System.Windows.Forms.Label()
        Me.HistoricResponseRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.AnnualEligibleVolumeNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HistoricResponseRateLabel = New System.Windows.Forms.Label()
        Me.AnnualEligibleVolumeLabel = New System.Windows.Forms.Label()
        Me.HistoricRadioButton = New System.Windows.Forms.RadioButton()
        Me.EstimatedPanel = New System.Windows.Forms.Panel()
        Me.EstimatedGroupBox = New System.Windows.Forms.GroupBox()
        Me.SwitchToCalcOnDateEdit = New DevExpress.XtraEditors.DateEdit()
        Me.EstimatedRadioButton = New System.Windows.Forms.RadioButton()
        Me.SwitchToCalcOnLabel = New System.Windows.Forms.Label()
        Me.EstimatedIneligibleRateLabel = New System.Windows.Forms.Label()
        Me.EstimatedIneligibleRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.EstimatedResponseRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.EstimatedResponseRateLabel = New System.Windows.Forms.Label()
        Me.EstimatedAnnualVolumeNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.EstimatedAnnualVolumeLabel = New System.Windows.Forms.Label()
        Me.ChangeThresholdPanel = New System.Windows.Forms.Panel()
        Me.ChangeThresholdNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.ChangeThresholdLabel = New System.Windows.Forms.Label()
        Me.AnnualReturnTargetPanel = New System.Windows.Forms.Panel()
        Me.ForceCensusSampleCheckBox = New System.Windows.Forms.CheckBox()
        Me.AnnualReturnTargetNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.AnnualReturnTargetLabel = New System.Windows.Forms.Label()
        Me.TabPage1 = New System.Windows.Forms.TabPage()
        Me.HHCAHPS_CancelButton = New System.Windows.Forms.Button()
        Me.HHCAHPS_ApplyButton = New System.Windows.Forms.Button()
        Me.TableLayoutPanel2 = New System.Windows.Forms.TableLayoutPanel()
        Me.Panel24 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_MedicareCalcHistoryButton = New System.Windows.Forms.Button()
        Me.Panel23 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_NonSubmittingCheckbox = New System.Windows.Forms.CheckBox()
        Me.Panel22 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_ProportionUsedNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPS_ProportionUsedLabel = New System.Windows.Forms.Label()
        Me.Panel25 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_InactiveCheckBox = New System.Windows.Forms.CheckBox()
        Me.Panel20 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_CalcProportionNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPS_CalcProportionLabel = New System.Windows.Forms.Label()
        Me.Panel19 = New System.Windows.Forms.Panel()
        Me.Panel18 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_LastCalcTypeTextBox = New System.Windows.Forms.TextBox()
        Me.HHCAHPS_LastCalcTypeLabel = New System.Windows.Forms.Label()
        Me.Panel17 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_MedicareReCalcButton = New System.Windows.Forms.Button()
        Me.Panel16 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_LastCalcDateTextBox = New System.Windows.Forms.TextBox()
        Me.HHCAHPS_LastCalcDateLabel = New System.Windows.Forms.Label()
        Me.Panel15 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_SamplingRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPS_SamplingRateLabel = New System.Windows.Forms.Label()
        Me.Panel14 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_LastCalculationLabel = New System.Windows.Forms.Label()
        Me.Panel13 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker = New System.Windows.Forms.DateTimePicker()
        Me.HHCAHPS_SwitchFromOverrideDateLabel = New System.Windows.Forms.Label()
        Me.Panel12 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_HistoricResponseRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPA_HistoricResponseRateLabel = New System.Windows.Forms.Label()
        Me.Panel11 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_SamplingRateOverrideLabel = New System.Windows.Forms.Label()
        Me.Panel10 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPS_AnnualEligibleVolumeLabel = New System.Windows.Forms.Label()
        Me.Panel9 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_EstimatedResponseRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPS_EstimatedResponseRateLabel = New System.Windows.Forms.Label()
        Me.Panel8 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_HistoricValuesLabel = New System.Windows.Forms.Label()
        Me.Panel7 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPS_EstimatedAnnualVolumeLabel = New System.Windows.Forms.Label()
        Me.Panel6 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_MedicareUnlockSamplingButton = New System.Windows.Forms.Button()
        Me.Panel5 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker = New System.Windows.Forms.DateTimePicker()
        Me.HHCAHPS_SwtichFromEstimatedDateLabel = New System.Windows.Forms.Label()
        Me.Panel4 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_SamplingLockTextBox = New System.Windows.Forms.TextBox()
        Me.HHCAHPS_SampleLockLabel = New System.Windows.Forms.Label()
        Me.Panel3 = New System.Windows.Forms.Panel()
        Me.HHCAHPS_EstimatedValuesLabel = New System.Windows.Forms.Label()
        Me.Panel2 = New System.Windows.Forms.Panel()
        Me.Label13 = New System.Windows.Forms.Label()
        Me.HHCAHPS_ChangeThresholdNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPS_ChangeThresholdLabel = New System.Windows.Forms.Label()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.HHCAHPS_AnnualReturnTargetNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.HHCAHPS_AnnualReturnTargetLabel = New System.Windows.Forms.Label()
        Me.OASCAHPS = New System.Windows.Forms.TabPage()
        Me.OASCAHPS_CancelButton = New System.Windows.Forms.Button()
        Me.OASCAHPS_ApplyButton = New System.Windows.Forms.Button()
        Me.TableLayoutPanel3 = New System.Windows.Forms.TableLayoutPanel()
        Me.Panel21 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_MedicareCalcHistoryButton = New System.Windows.Forms.Button()
        Me.Panel26 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_NonSubmittingCheckbox = New System.Windows.Forms.CheckBox()
        Me.Panel27 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_ProportionUsedNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPS_ProportionUsedLabel = New System.Windows.Forms.Label()
        Me.Panel28 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_InactiveCheckBox = New System.Windows.Forms.CheckBox()
        Me.Panel29 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_CalcProportionNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPS_CalcProportionLabel = New System.Windows.Forms.Label()
        Me.Panel30 = New System.Windows.Forms.Panel()
        Me.Panel31 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_LastCalcTypeTextBox = New System.Windows.Forms.TextBox()
        Me.OASCAHPS_LastCalcTypeLabel = New System.Windows.Forms.Label()
        Me.Panel32 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_MedicareReCalcButton = New System.Windows.Forms.Button()
        Me.Panel33 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_LastCalcDateTextBox = New System.Windows.Forms.TextBox()
        Me.OASCAHPS_LastCalcDateLabel = New System.Windows.Forms.Label()
        Me.Panel34 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_SamplingRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPS_SamplingRateLabel = New System.Windows.Forms.Label()
        Me.Panel35 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_LastCalculationLabel = New System.Windows.Forms.Label()
        Me.Panel36 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker = New System.Windows.Forms.DateTimePicker()
        Me.OASCAHPS_SwitchFromOverrideDateLabel = New System.Windows.Forms.Label()
        Me.Panel37 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_HistoricResponseRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPA_HistoricResponseRateLabel = New System.Windows.Forms.Label()
        Me.Panel38 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_SamplingRateOverrideLabel = New System.Windows.Forms.Label()
        Me.Panel39 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPS_AnnualEligibleVolumeLabel = New System.Windows.Forms.Label()
        Me.Panel40 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_EstimatedResponseRateNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPS_EstimatedResponseRateLabel = New System.Windows.Forms.Label()
        Me.Panel49 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_HistoricValuesLabel = New System.Windows.Forms.Label()
        Me.Panel42 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPS_EstimatedAnnualVolumeLabel = New System.Windows.Forms.Label()
        Me.Panel43 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_MedicareUnlockSamplingButton = New System.Windows.Forms.Button()
        Me.Panel44 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker = New System.Windows.Forms.DateTimePicker()
        Me.OASCAHPS_SwtichFromEstimatedDateLabel = New System.Windows.Forms.Label()
        Me.Panel45 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_SamplingLockTextBox = New System.Windows.Forms.TextBox()
        Me.OASCAHPS_SampleLockLabel = New System.Windows.Forms.Label()
        Me.Panel46 = New System.Windows.Forms.Panel()
        Me.OASCAHPS_EstimatedValuesLabel = New System.Windows.Forms.Label()
        Me.Panel47 = New System.Windows.Forms.Panel()
        Me.Label14 = New System.Windows.Forms.Label()
        Me.OASCAHPS_ChangeThresholdNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPS_ChangeThresholdLabel = New System.Windows.Forms.Label()
        Me.Panel48 = New System.Windows.Forms.Panel()
        Me.Label11 = New System.Windows.Forms.Label()
        Me.OASCAHPS_AnnualReturnTargetNumericUpDown = New System.Windows.Forms.NumericUpDown()
        Me.OASCAHPS_AnnualReturnTargetLabel = New System.Windows.Forms.Label()
        Me.CurrentTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel()
        Me.MedicareNumberPanel = New System.Windows.Forms.Panel()
        Me.MedicareNumberTextBox = New System.Windows.Forms.TextBox()
        Me.MedicareNumberLabel = New System.Windows.Forms.Label()
        Me.SampleLockPanel = New System.Windows.Forms.Panel()
        Me.MedicareNamePanel = New System.Windows.Forms.Panel()
        Me.MedicareNameTextBox = New System.Windows.Forms.TextBox()
        Me.MedicareNameLabel = New System.Windows.Forms.Label()
        Me.MedicareErrorProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.MedicareManagementSectionPanel.SuspendLayout()
        Me.CAHPSTabControl.SuspendLayout()
        Me.HCAHPS.SuspendLayout()
        Me.TableLayoutPanel1.SuspendLayout()
        Me.LastCalculatedPanel.SuspendLayout()
        Me.CalculatedProportionPanel.SuspendLayout()
        CType(Me.CalcProportionNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SamplingLockStatusPanel.SuspendLayout()
        Me.LastCalcTypePanel.SuspendLayout()
        Me.ProportionUsedPanel.SuspendLayout()
        CType(Me.ProportionUsedNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.NextCalcGroupBox.SuspendLayout()
        Me.NextCalcTableLayoutPanel.SuspendLayout()
        Me.HistoricPanel.SuspendLayout()
        Me.HistoricGroupBox.SuspendLayout()
        CType(Me.HistoricWarningPictureBox, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.HistoricResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.AnnualEligibleVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.EstimatedPanel.SuspendLayout()
        Me.EstimatedGroupBox.SuspendLayout()
        CType(Me.SwitchToCalcOnDateEdit.Properties.VistaTimeProperties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SwitchToCalcOnDateEdit.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EstimatedIneligibleRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EstimatedResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EstimatedAnnualVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ChangeThresholdPanel.SuspendLayout()
        CType(Me.ChangeThresholdNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.AnnualReturnTargetPanel.SuspendLayout()
        CType(Me.AnnualReturnTargetNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage1.SuspendLayout()
        Me.TableLayoutPanel2.SuspendLayout()
        Me.Panel24.SuspendLayout()
        Me.Panel23.SuspendLayout()
        Me.Panel22.SuspendLayout()
        CType(Me.HHCAHPS_ProportionUsedNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel25.SuspendLayout()
        Me.Panel20.SuspendLayout()
        CType(Me.HHCAHPS_CalcProportionNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel18.SuspendLayout()
        Me.Panel17.SuspendLayout()
        Me.Panel16.SuspendLayout()
        Me.Panel15.SuspendLayout()
        CType(Me.HHCAHPS_SamplingRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel14.SuspendLayout()
        Me.Panel13.SuspendLayout()
        Me.Panel12.SuspendLayout()
        CType(Me.HHCAHPS_HistoricResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel11.SuspendLayout()
        Me.Panel10.SuspendLayout()
        CType(Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel9.SuspendLayout()
        CType(Me.HHCAHPS_EstimatedResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel8.SuspendLayout()
        Me.Panel7.SuspendLayout()
        CType(Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel6.SuspendLayout()
        Me.Panel5.SuspendLayout()
        Me.Panel4.SuspendLayout()
        Me.Panel3.SuspendLayout()
        Me.Panel2.SuspendLayout()
        CType(Me.HHCAHPS_ChangeThresholdNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel1.SuspendLayout()
        CType(Me.HHCAHPS_AnnualReturnTargetNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.OASCAHPS.SuspendLayout()
        Me.TableLayoutPanel3.SuspendLayout()
        Me.Panel21.SuspendLayout()
        Me.Panel26.SuspendLayout()
        Me.Panel27.SuspendLayout()
        CType(Me.OASCAHPS_ProportionUsedNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel28.SuspendLayout()
        Me.Panel29.SuspendLayout()
        CType(Me.OASCAHPS_CalcProportionNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel31.SuspendLayout()
        Me.Panel32.SuspendLayout()
        Me.Panel33.SuspendLayout()
        Me.Panel34.SuspendLayout()
        CType(Me.OASCAHPS_SamplingRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel35.SuspendLayout()
        Me.Panel36.SuspendLayout()
        Me.Panel37.SuspendLayout()
        CType(Me.OASCAHPS_HistoricResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel38.SuspendLayout()
        Me.Panel39.SuspendLayout()
        CType(Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel40.SuspendLayout()
        CType(Me.OASCAHPS_EstimatedResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel49.SuspendLayout()
        Me.Panel42.SuspendLayout()
        CType(Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel43.SuspendLayout()
        Me.Panel44.SuspendLayout()
        Me.Panel45.SuspendLayout()
        Me.Panel46.SuspendLayout()
        Me.Panel47.SuspendLayout()
        CType(Me.OASCAHPS_ChangeThresholdNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel48.SuspendLayout()
        CType(Me.OASCAHPS_AnnualReturnTargetNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.CurrentTableLayoutPanel.SuspendLayout()
        Me.MedicareNumberPanel.SuspendLayout()
        Me.MedicareNamePanel.SuspendLayout()
        CType(Me.MedicareErrorProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MedicareManagementSectionPanel
        '
        Me.MedicareManagementSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MedicareManagementSectionPanel.Caption = "Medicare Management: 010002 (Kern Medical Center)"
        Me.MedicareManagementSectionPanel.Controls.Add(Me.CAHPSTabControl)
        Me.MedicareManagementSectionPanel.Controls.Add(Me.CurrentTableLayoutPanel)
        Me.MedicareManagementSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MedicareManagementSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.MedicareManagementSectionPanel.Name = "MedicareManagementSectionPanel"
        Me.MedicareManagementSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MedicareManagementSectionPanel.ShowCaption = True
        Me.MedicareManagementSectionPanel.Size = New System.Drawing.Size(1393, 653)
        Me.MedicareManagementSectionPanel.TabIndex = 0
        Me.MedicareManagementSectionPanel.Tag = "Medicare Number: "
        '
        'CAHPSTabControl
        '
        Me.CAHPSTabControl.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CAHPSTabControl.Controls.Add(Me.HCAHPS)
        Me.CAHPSTabControl.Controls.Add(Me.TabPage1)
        Me.CAHPSTabControl.Controls.Add(Me.OASCAHPS)
        Me.CAHPSTabControl.Location = New System.Drawing.Point(11, 146)
        Me.CAHPSTabControl.Name = "CAHPSTabControl"
        Me.CAHPSTabControl.SelectedIndex = 0
        Me.CAHPSTabControl.Size = New System.Drawing.Size(1363, 494)
        Me.CAHPSTabControl.TabIndex = 12
        '
        'HCAHPS
        '
        Me.HCAHPS.Controls.Add(Me.HCAHPS_CancelButton)
        Me.HCAHPS.Controls.Add(Me.HCAHPS_ApplyButton)
        Me.HCAHPS.Controls.Add(Me.MedicareCalcHistoryButton)
        Me.HCAHPS.Controls.Add(Me.MedicareUnlockSamplingButton)
        Me.HCAHPS.Controls.Add(Me.MedicareReCalcButton)
        Me.HCAHPS.Controls.Add(Me.NonSubmittingCheckbox)
        Me.HCAHPS.Controls.Add(Me.TableLayoutPanel1)
        Me.HCAHPS.Controls.Add(Me.InactiveCheckBox)
        Me.HCAHPS.Controls.Add(Me.NextCalcGroupBox)
        Me.HCAHPS.Location = New System.Drawing.Point(4, 30)
        Me.HCAHPS.Name = "HCAHPS"
        Me.HCAHPS.Padding = New System.Windows.Forms.Padding(3)
        Me.HCAHPS.Size = New System.Drawing.Size(1355, 460)
        Me.HCAHPS.TabIndex = 0
        Me.HCAHPS.Text = "HCAHPS"
        Me.HCAHPS.UseVisualStyleBackColor = True
        '
        'HCAHPS_CancelButton
        '
        Me.HCAHPS_CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HCAHPS_CancelButton.Location = New System.Drawing.Point(1274, 415)
        Me.HCAHPS_CancelButton.Name = "HCAHPS_CancelButton"
        Me.HCAHPS_CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.HCAHPS_CancelButton.TabIndex = 37
        Me.HCAHPS_CancelButton.Text = "Cancel"
        Me.HCAHPS_CancelButton.UseVisualStyleBackColor = True
        '
        'HCAHPS_ApplyButton
        '
        Me.HCAHPS_ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HCAHPS_ApplyButton.Location = New System.Drawing.Point(1193, 415)
        Me.HCAHPS_ApplyButton.Name = "HCAHPS_ApplyButton"
        Me.HCAHPS_ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.HCAHPS_ApplyButton.TabIndex = 36
        Me.HCAHPS_ApplyButton.Text = "Apply"
        Me.HCAHPS_ApplyButton.UseVisualStyleBackColor = True
        '
        'MedicareCalcHistoryButton
        '
        Me.MedicareCalcHistoryButton.Location = New System.Drawing.Point(182, 359)
        Me.MedicareCalcHistoryButton.Name = "MedicareCalcHistoryButton"
        Me.MedicareCalcHistoryButton.Size = New System.Drawing.Size(113, 23)
        Me.MedicareCalcHistoryButton.TabIndex = 35
        Me.MedicareCalcHistoryButton.Text = "View Recalc History"
        Me.MedicareCalcHistoryButton.UseVisualStyleBackColor = True
        '
        'MedicareUnlockSamplingButton
        '
        Me.MedicareUnlockSamplingButton.Location = New System.Drawing.Point(350, 359)
        Me.MedicareUnlockSamplingButton.Name = "MedicareUnlockSamplingButton"
        Me.MedicareUnlockSamplingButton.Size = New System.Drawing.Size(113, 23)
        Me.MedicareUnlockSamplingButton.TabIndex = 34
        Me.MedicareUnlockSamplingButton.Text = "Unlock Sampling"
        Me.MedicareUnlockSamplingButton.UseVisualStyleBackColor = True
        '
        'MedicareReCalcButton
        '
        Me.MedicareReCalcButton.Location = New System.Drawing.Point(9, 359)
        Me.MedicareReCalcButton.Name = "MedicareReCalcButton"
        Me.MedicareReCalcButton.Size = New System.Drawing.Size(115, 23)
        Me.MedicareReCalcButton.TabIndex = 33
        Me.MedicareReCalcButton.Text = "Force Recalc"
        Me.MedicareReCalcButton.UseVisualStyleBackColor = True
        '
        'NonSubmittingCheckbox
        '
        Me.NonSubmittingCheckbox.AutoSize = True
        Me.NonSubmittingCheckbox.Location = New System.Drawing.Point(182, 400)
        Me.NonSubmittingCheckbox.Name = "NonSubmittingCheckbox"
        Me.NonSubmittingCheckbox.Size = New System.Drawing.Size(144, 25)
        Me.NonSubmittingCheckbox.TabIndex = 1
        Me.NonSubmittingCheckbox.Text = "Do Not Submit"
        Me.NonSubmittingCheckbox.UseVisualStyleBackColor = True
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel1.ColumnCount = 2
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.81845!))
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 49.18155!))
        Me.TableLayoutPanel1.Controls.Add(Me.LastCalculatedPanel, 0, 1)
        Me.TableLayoutPanel1.Controls.Add(Me.CalculatedProportionPanel, 0, 2)
        Me.TableLayoutPanel1.Controls.Add(Me.SamplingLockStatusPanel, 1, 0)
        Me.TableLayoutPanel1.Controls.Add(Me.LastCalcTypePanel, 1, 1)
        Me.TableLayoutPanel1.Controls.Add(Me.ProportionUsedPanel, 1, 2)
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(6, 0)
        Me.TableLayoutPanel1.Name = "TableLayoutPanel1"
        Me.TableLayoutPanel1.RowCount = 3
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33.33333!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33.33333!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33.33333!))
        Me.TableLayoutPanel1.Size = New System.Drawing.Size(1353, 114)
        Me.TableLayoutPanel1.TabIndex = 2
        '
        'LastCalculatedPanel
        '
        Me.LastCalculatedPanel.Controls.Add(Me.LastCalcDateLabel)
        Me.LastCalculatedPanel.Controls.Add(Me.LastCalcDateTextBox)
        Me.LastCalculatedPanel.Location = New System.Drawing.Point(3, 41)
        Me.LastCalculatedPanel.Name = "LastCalculatedPanel"
        Me.LastCalculatedPanel.Size = New System.Drawing.Size(679, 27)
        Me.LastCalculatedPanel.TabIndex = 0
        '
        'LastCalcDateLabel
        '
        Me.LastCalcDateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LastCalcDateLabel.AutoSize = True
        Me.LastCalcDateLabel.Location = New System.Drawing.Point(2, 3)
        Me.LastCalcDateLabel.Name = "LastCalcDateLabel"
        Me.LastCalcDateLabel.Size = New System.Drawing.Size(155, 21)
        Me.LastCalcDateLabel.TabIndex = 0
        Me.LastCalcDateLabel.Text = "Last Calculated On:"
        '
        'LastCalcDateTextBox
        '
        Me.LastCalcDateTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MedicareErrorProvider.SetIconAlignment(Me.LastCalcDateTextBox, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.LastCalcDateTextBox.Location = New System.Drawing.Point(127, 0)
        Me.LastCalcDateTextBox.Name = "LastCalcDateTextBox"
        Me.LastCalcDateTextBox.ReadOnly = True
        Me.LastCalcDateTextBox.Size = New System.Drawing.Size(530, 27)
        Me.LastCalcDateTextBox.TabIndex = 1
        '
        'CalculatedProportionPanel
        '
        Me.CalculatedProportionPanel.Controls.Add(Me.CalcProportionLabel)
        Me.CalculatedProportionPanel.Controls.Add(Me.CalcProportionNumericUpDown)
        Me.CalculatedProportionPanel.Location = New System.Drawing.Point(3, 79)
        Me.CalculatedProportionPanel.Name = "CalculatedProportionPanel"
        Me.CalculatedProportionPanel.Size = New System.Drawing.Size(679, 28)
        Me.CalculatedProportionPanel.TabIndex = 1
        '
        'CalcProportionLabel
        '
        Me.CalcProportionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CalcProportionLabel.AutoSize = True
        Me.CalcProportionLabel.Location = New System.Drawing.Point(2, 2)
        Me.CalcProportionLabel.Name = "CalcProportionLabel"
        Me.CalcProportionLabel.Size = New System.Drawing.Size(174, 21)
        Me.CalcProportionLabel.TabIndex = 0
        Me.CalcProportionLabel.Text = "Calculated Proportion:"
        '
        'CalcProportionNumericUpDown
        '
        Me.CalcProportionNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CalcProportionNumericUpDown.DecimalPlaces = 4
        Me.CalcProportionNumericUpDown.Enabled = False
        Me.MedicareErrorProvider.SetIconAlignment(Me.CalcProportionNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.CalcProportionNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.CalcProportionNumericUpDown.Location = New System.Drawing.Point(127, 0)
        Me.CalcProportionNumericUpDown.Name = "CalcProportionNumericUpDown"
        Me.CalcProportionNumericUpDown.ReadOnly = True
        Me.CalcProportionNumericUpDown.Size = New System.Drawing.Size(530, 27)
        Me.CalcProportionNumericUpDown.TabIndex = 1
        '
        'SamplingLockStatusPanel
        '
        Me.SamplingLockStatusPanel.Controls.Add(Me.SampleLockLabel)
        Me.SamplingLockStatusPanel.Controls.Add(Me.SamplingLockTextBox)
        Me.SamplingLockStatusPanel.Location = New System.Drawing.Point(690, 3)
        Me.SamplingLockStatusPanel.Name = "SamplingLockStatusPanel"
        Me.SamplingLockStatusPanel.Size = New System.Drawing.Size(656, 27)
        Me.SamplingLockStatusPanel.TabIndex = 2
        '
        'SampleLockLabel
        '
        Me.SampleLockLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SampleLockLabel.AutoSize = True
        Me.SampleLockLabel.Location = New System.Drawing.Point(-1, 6)
        Me.SampleLockLabel.Name = "SampleLockLabel"
        Me.SampleLockLabel.Size = New System.Drawing.Size(173, 21)
        Me.SampleLockLabel.TabIndex = 0
        Me.SampleLockLabel.Text = "Sampling Lock Status:"
        '
        'SamplingLockTextBox
        '
        Me.SamplingLockTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MedicareErrorProvider.SetIconAlignment(Me.SamplingLockTextBox, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.SamplingLockTextBox.Location = New System.Drawing.Point(119, 3)
        Me.SamplingLockTextBox.Name = "SamplingLockTextBox"
        Me.SamplingLockTextBox.ReadOnly = True
        Me.SamplingLockTextBox.Size = New System.Drawing.Size(523, 27)
        Me.SamplingLockTextBox.TabIndex = 1
        '
        'LastCalcTypePanel
        '
        Me.LastCalcTypePanel.Controls.Add(Me.LastCalcTypeLabel)
        Me.LastCalcTypePanel.Controls.Add(Me.LastCalcTypeTextBox)
        Me.LastCalcTypePanel.Location = New System.Drawing.Point(690, 41)
        Me.LastCalcTypePanel.Name = "LastCalcTypePanel"
        Me.LastCalcTypePanel.Size = New System.Drawing.Size(656, 27)
        Me.LastCalcTypePanel.TabIndex = 3
        '
        'LastCalcTypeLabel
        '
        Me.LastCalcTypeLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LastCalcTypeLabel.AutoSize = True
        Me.LastCalcTypeLabel.Location = New System.Drawing.Point(-1, 3)
        Me.LastCalcTypeLabel.Name = "LastCalcTypeLabel"
        Me.LastCalcTypeLabel.Size = New System.Drawing.Size(174, 21)
        Me.LastCalcTypeLabel.TabIndex = 0
        Me.LastCalcTypeLabel.Text = "Last Calculation Type:"
        '
        'LastCalcTypeTextBox
        '
        Me.LastCalcTypeTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MedicareErrorProvider.SetIconAlignment(Me.LastCalcTypeTextBox, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.LastCalcTypeTextBox.Location = New System.Drawing.Point(119, 3)
        Me.LastCalcTypeTextBox.Name = "LastCalcTypeTextBox"
        Me.LastCalcTypeTextBox.ReadOnly = True
        Me.LastCalcTypeTextBox.Size = New System.Drawing.Size(523, 27)
        Me.LastCalcTypeTextBox.TabIndex = 1
        '
        'ProportionUsedPanel
        '
        Me.ProportionUsedPanel.Controls.Add(Me.ProportionUsedLabel)
        Me.ProportionUsedPanel.Controls.Add(Me.ProportionUsedNumericUpDown)
        Me.ProportionUsedPanel.Location = New System.Drawing.Point(690, 79)
        Me.ProportionUsedPanel.Name = "ProportionUsedPanel"
        Me.ProportionUsedPanel.Size = New System.Drawing.Size(656, 28)
        Me.ProportionUsedPanel.TabIndex = 4
        '
        'ProportionUsedLabel
        '
        Me.ProportionUsedLabel.AutoSize = True
        Me.ProportionUsedLabel.Location = New System.Drawing.Point(-1, 2)
        Me.ProportionUsedLabel.Name = "ProportionUsedLabel"
        Me.ProportionUsedLabel.Size = New System.Drawing.Size(134, 21)
        Me.ProportionUsedLabel.TabIndex = 0
        Me.ProportionUsedLabel.Text = "Proportion Used:"
        '
        'ProportionUsedNumericUpDown
        '
        Me.ProportionUsedNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProportionUsedNumericUpDown.DecimalPlaces = 4
        Me.ProportionUsedNumericUpDown.Enabled = False
        Me.MedicareErrorProvider.SetIconAlignment(Me.ProportionUsedNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.ProportionUsedNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.ProportionUsedNumericUpDown.Location = New System.Drawing.Point(119, 0)
        Me.ProportionUsedNumericUpDown.Name = "ProportionUsedNumericUpDown"
        Me.ProportionUsedNumericUpDown.ReadOnly = True
        Me.ProportionUsedNumericUpDown.Size = New System.Drawing.Size(523, 27)
        Me.ProportionUsedNumericUpDown.TabIndex = 1
        '
        'InactiveCheckBox
        '
        Me.InactiveCheckBox.AutoSize = True
        Me.InactiveCheckBox.Location = New System.Drawing.Point(9, 400)
        Me.InactiveCheckBox.Name = "InactiveCheckBox"
        Me.InactiveCheckBox.Size = New System.Drawing.Size(245, 25)
        Me.InactiveCheckBox.TabIndex = 0
        Me.InactiveCheckBox.Text = "Inactivate Medicare Number"
        Me.InactiveCheckBox.UseVisualStyleBackColor = True
        '
        'NextCalcGroupBox
        '
        Me.NextCalcGroupBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NextCalcGroupBox.Controls.Add(Me.NextCalcTableLayoutPanel)
        Me.NextCalcGroupBox.Location = New System.Drawing.Point(3, 112)
        Me.NextCalcGroupBox.Name = "NextCalcGroupBox"
        Me.NextCalcGroupBox.Size = New System.Drawing.Size(1347, 229)
        Me.NextCalcGroupBox.TabIndex = 0
        Me.NextCalcGroupBox.TabStop = False
        Me.NextCalcGroupBox.Text = "Values To Be Used For Next Calculation"
        '
        'NextCalcTableLayoutPanel
        '
        Me.NextCalcTableLayoutPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NextCalcTableLayoutPanel.ColumnCount = 2
        Me.NextCalcTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.NextCalcTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.NextCalcTableLayoutPanel.Controls.Add(Me.HistoricPanel, 1, 1)
        Me.NextCalcTableLayoutPanel.Controls.Add(Me.EstimatedPanel, 0, 1)
        Me.NextCalcTableLayoutPanel.Controls.Add(Me.ChangeThresholdPanel, 1, 0)
        Me.NextCalcTableLayoutPanel.Controls.Add(Me.AnnualReturnTargetPanel, 0, 0)
        Me.NextCalcTableLayoutPanel.Location = New System.Drawing.Point(6, 19)
        Me.NextCalcTableLayoutPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.NextCalcTableLayoutPanel.Name = "NextCalcTableLayoutPanel"
        Me.NextCalcTableLayoutPanel.RowCount = 2
        Me.NextCalcTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 52.0!))
        Me.NextCalcTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.NextCalcTableLayoutPanel.Size = New System.Drawing.Size(1335, 204)
        Me.NextCalcTableLayoutPanel.TabIndex = 0
        '
        'HistoricPanel
        '
        Me.HistoricPanel.Controls.Add(Me.HistoricGroupBox)
        Me.HistoricPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.HistoricPanel.Location = New System.Drawing.Point(667, 52)
        Me.HistoricPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.HistoricPanel.Name = "HistoricPanel"
        Me.HistoricPanel.Size = New System.Drawing.Size(668, 152)
        Me.HistoricPanel.TabIndex = 3
        '
        'HistoricGroupBox
        '
        Me.HistoricGroupBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HistoricGroupBox.Controls.Add(Me.HistoricWarningPictureBox)
        Me.HistoricGroupBox.Controls.Add(Me.HistoricWarningLabel)
        Me.HistoricGroupBox.Controls.Add(Me.HistoricResponseRateNumericUpDown)
        Me.HistoricGroupBox.Controls.Add(Me.AnnualEligibleVolumeNumericUpDown)
        Me.HistoricGroupBox.Controls.Add(Me.HistoricResponseRateLabel)
        Me.HistoricGroupBox.Controls.Add(Me.AnnualEligibleVolumeLabel)
        Me.HistoricGroupBox.Controls.Add(Me.HistoricRadioButton)
        Me.HistoricGroupBox.Location = New System.Drawing.Point(6, 13)
        Me.HistoricGroupBox.Name = "HistoricGroupBox"
        Me.HistoricGroupBox.Size = New System.Drawing.Size(659, 136)
        Me.HistoricGroupBox.TabIndex = 0
        Me.HistoricGroupBox.TabStop = False
        '
        'HistoricWarningPictureBox
        '
        Me.HistoricWarningPictureBox.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.Caution16
        Me.HistoricWarningPictureBox.Location = New System.Drawing.Point(10, 72)
        Me.HistoricWarningPictureBox.Name = "HistoricWarningPictureBox"
        Me.HistoricWarningPictureBox.Size = New System.Drawing.Size(20, 20)
        Me.HistoricWarningPictureBox.TabIndex = 36
        Me.HistoricWarningPictureBox.TabStop = False
        '
        'HistoricWarningLabel
        '
        Me.HistoricWarningLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HistoricWarningLabel.Location = New System.Drawing.Point(30, 72)
        Me.HistoricWarningLabel.Name = "HistoricWarningLabel"
        Me.HistoricWarningLabel.Size = New System.Drawing.Size(620, 61)
        Me.HistoricWarningLabel.TabIndex = 5
        Me.HistoricWarningLabel.Text = "There is insufficient data available.  Selecting this option will force the syste" &
    "m to evaluate data availability at each calculation."
        '
        'HistoricResponseRateNumericUpDown
        '
        Me.HistoricResponseRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HistoricResponseRateNumericUpDown.DecimalPlaces = 4
        Me.HistoricResponseRateNumericUpDown.Enabled = False
        Me.MedicareErrorProvider.SetIconAlignment(Me.HistoricResponseRateNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.HistoricResponseRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.HistoricResponseRateNumericUpDown.Location = New System.Drawing.Point(136, 48)
        Me.HistoricResponseRateNumericUpDown.Name = "HistoricResponseRateNumericUpDown"
        Me.HistoricResponseRateNumericUpDown.ReadOnly = True
        Me.HistoricResponseRateNumericUpDown.Size = New System.Drawing.Size(509, 27)
        Me.HistoricResponseRateNumericUpDown.TabIndex = 4
        '
        'AnnualEligibleVolumeNumericUpDown
        '
        Me.AnnualEligibleVolumeNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AnnualEligibleVolumeNumericUpDown.Enabled = False
        Me.MedicareErrorProvider.SetIconAlignment(Me.AnnualEligibleVolumeNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.AnnualEligibleVolumeNumericUpDown.Location = New System.Drawing.Point(136, 21)
        Me.AnnualEligibleVolumeNumericUpDown.Maximum = New Decimal(New Integer() {999999999, 0, 0, 0})
        Me.AnnualEligibleVolumeNumericUpDown.Name = "AnnualEligibleVolumeNumericUpDown"
        Me.AnnualEligibleVolumeNumericUpDown.ReadOnly = True
        Me.AnnualEligibleVolumeNumericUpDown.Size = New System.Drawing.Size(509, 27)
        Me.AnnualEligibleVolumeNumericUpDown.TabIndex = 2
        '
        'HistoricResponseRateLabel
        '
        Me.HistoricResponseRateLabel.AutoSize = True
        Me.HistoricResponseRateLabel.Location = New System.Drawing.Point(8, 51)
        Me.HistoricResponseRateLabel.Name = "HistoricResponseRateLabel"
        Me.HistoricResponseRateLabel.Size = New System.Drawing.Size(189, 21)
        Me.HistoricResponseRateLabel.TabIndex = 3
        Me.HistoricResponseRateLabel.Text = "Historic Response Rate:"
        '
        'AnnualEligibleVolumeLabel
        '
        Me.AnnualEligibleVolumeLabel.AutoSize = True
        Me.AnnualEligibleVolumeLabel.Location = New System.Drawing.Point(8, 24)
        Me.AnnualEligibleVolumeLabel.Name = "AnnualEligibleVolumeLabel"
        Me.AnnualEligibleVolumeLabel.Size = New System.Drawing.Size(185, 21)
        Me.AnnualEligibleVolumeLabel.TabIndex = 1
        Me.AnnualEligibleVolumeLabel.Text = "Annual Eligible Volume:"
        '
        'HistoricRadioButton
        '
        Me.HistoricRadioButton.AutoSize = True
        Me.HistoricRadioButton.Location = New System.Drawing.Point(10, -1)
        Me.HistoricRadioButton.Name = "HistoricRadioButton"
        Me.HistoricRadioButton.Size = New System.Drawing.Size(178, 25)
        Me.HistoricRadioButton.TabIndex = 0
        Me.HistoricRadioButton.TabStop = True
        Me.HistoricRadioButton.Text = "Use Historic Values"
        Me.HistoricRadioButton.UseVisualStyleBackColor = True
        '
        'EstimatedPanel
        '
        Me.EstimatedPanel.Controls.Add(Me.EstimatedGroupBox)
        Me.EstimatedPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.EstimatedPanel.Location = New System.Drawing.Point(0, 52)
        Me.EstimatedPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.EstimatedPanel.Name = "EstimatedPanel"
        Me.EstimatedPanel.Size = New System.Drawing.Size(667, 152)
        Me.EstimatedPanel.TabIndex = 2
        '
        'EstimatedGroupBox
        '
        Me.EstimatedGroupBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EstimatedGroupBox.Controls.Add(Me.SwitchToCalcOnDateEdit)
        Me.EstimatedGroupBox.Controls.Add(Me.EstimatedRadioButton)
        Me.EstimatedGroupBox.Controls.Add(Me.SwitchToCalcOnLabel)
        Me.EstimatedGroupBox.Controls.Add(Me.EstimatedIneligibleRateLabel)
        Me.EstimatedGroupBox.Controls.Add(Me.EstimatedIneligibleRateNumericUpDown)
        Me.EstimatedGroupBox.Controls.Add(Me.EstimatedResponseRateNumericUpDown)
        Me.EstimatedGroupBox.Controls.Add(Me.EstimatedResponseRateLabel)
        Me.EstimatedGroupBox.Controls.Add(Me.EstimatedAnnualVolumeNumericUpDown)
        Me.EstimatedGroupBox.Controls.Add(Me.EstimatedAnnualVolumeLabel)
        Me.EstimatedGroupBox.Location = New System.Drawing.Point(3, 13)
        Me.EstimatedGroupBox.Name = "EstimatedGroupBox"
        Me.EstimatedGroupBox.Size = New System.Drawing.Size(658, 136)
        Me.EstimatedGroupBox.TabIndex = 0
        Me.EstimatedGroupBox.TabStop = False
        '
        'SwitchToCalcOnDateEdit
        '
        Me.SwitchToCalcOnDateEdit.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SwitchToCalcOnDateEdit.EditValue = Nothing
        Me.MedicareErrorProvider.SetIconAlignment(Me.SwitchToCalcOnDateEdit, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.SwitchToCalcOnDateEdit.Location = New System.Drawing.Point(121, 102)
        Me.SwitchToCalcOnDateEdit.Name = "SwitchToCalcOnDateEdit"
        Me.SwitchToCalcOnDateEdit.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.SwitchToCalcOnDateEdit.Properties.LookAndFeel.UseDefaultLookAndFeel = False
        Me.SwitchToCalcOnDateEdit.Properties.LookAndFeel.UseWindowsXPTheme = True
        Me.SwitchToCalcOnDateEdit.Properties.TextEditStyle = DevExpress.XtraEditors.Controls.TextEditStyles.DisableTextEditor
        Me.SwitchToCalcOnDateEdit.Properties.VistaTimeProperties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton()})
        Me.SwitchToCalcOnDateEdit.Size = New System.Drawing.Size(528, 26)
        Me.SwitchToCalcOnDateEdit.TabIndex = 8
        '
        'EstimatedRadioButton
        '
        Me.EstimatedRadioButton.AutoSize = True
        Me.EstimatedRadioButton.Location = New System.Drawing.Point(10, -1)
        Me.EstimatedRadioButton.Name = "EstimatedRadioButton"
        Me.EstimatedRadioButton.Size = New System.Drawing.Size(197, 25)
        Me.EstimatedRadioButton.TabIndex = 0
        Me.EstimatedRadioButton.TabStop = True
        Me.EstimatedRadioButton.Text = "Use Estimated Values"
        Me.EstimatedRadioButton.UseVisualStyleBackColor = True
        '
        'SwitchToCalcOnLabel
        '
        Me.SwitchToCalcOnLabel.AutoSize = True
        Me.SwitchToCalcOnLabel.Location = New System.Drawing.Point(8, 107)
        Me.SwitchToCalcOnLabel.Name = "SwitchToCalcOnLabel"
        Me.SwitchToCalcOnLabel.Size = New System.Drawing.Size(151, 21)
        Me.SwitchToCalcOnLabel.TabIndex = 7
        Me.SwitchToCalcOnLabel.Text = "Switch To Calc On:"
        '
        'EstimatedIneligibleRateLabel
        '
        Me.EstimatedIneligibleRateLabel.AutoSize = True
        Me.EstimatedIneligibleRateLabel.Location = New System.Drawing.Point(8, 78)
        Me.EstimatedIneligibleRateLabel.Name = "EstimatedIneligibleRateLabel"
        Me.EstimatedIneligibleRateLabel.Size = New System.Drawing.Size(123, 21)
        Me.EstimatedIneligibleRateLabel.TabIndex = 5
        Me.EstimatedIneligibleRateLabel.Text = "Ineligible Rate:"
        '
        'EstimatedIneligibleRateNumericUpDown
        '
        Me.EstimatedIneligibleRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EstimatedIneligibleRateNumericUpDown.DecimalPlaces = 4
        Me.MedicareErrorProvider.SetIconAlignment(Me.EstimatedIneligibleRateNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.EstimatedIneligibleRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.EstimatedIneligibleRateNumericUpDown.Location = New System.Drawing.Point(121, 75)
        Me.EstimatedIneligibleRateNumericUpDown.Maximum = New Decimal(New Integer() {99, 0, 0, 0})
        Me.EstimatedIneligibleRateNumericUpDown.Name = "EstimatedIneligibleRateNumericUpDown"
        Me.EstimatedIneligibleRateNumericUpDown.Size = New System.Drawing.Size(528, 27)
        Me.EstimatedIneligibleRateNumericUpDown.TabIndex = 6
        '
        'EstimatedResponseRateNumericUpDown
        '
        Me.EstimatedResponseRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EstimatedResponseRateNumericUpDown.DecimalPlaces = 4
        Me.MedicareErrorProvider.SetIconAlignment(Me.EstimatedResponseRateNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.EstimatedResponseRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.EstimatedResponseRateNumericUpDown.Location = New System.Drawing.Point(121, 48)
        Me.EstimatedResponseRateNumericUpDown.Name = "EstimatedResponseRateNumericUpDown"
        Me.EstimatedResponseRateNumericUpDown.Size = New System.Drawing.Size(528, 27)
        Me.EstimatedResponseRateNumericUpDown.TabIndex = 4
        '
        'EstimatedResponseRateLabel
        '
        Me.EstimatedResponseRateLabel.AutoSize = True
        Me.EstimatedResponseRateLabel.Location = New System.Drawing.Point(8, 51)
        Me.EstimatedResponseRateLabel.Name = "EstimatedResponseRateLabel"
        Me.EstimatedResponseRateLabel.Size = New System.Drawing.Size(128, 21)
        Me.EstimatedResponseRateLabel.TabIndex = 3
        Me.EstimatedResponseRateLabel.Text = "Response Rate:"
        '
        'EstimatedAnnualVolumeNumericUpDown
        '
        Me.EstimatedAnnualVolumeNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MedicareErrorProvider.SetIconAlignment(Me.EstimatedAnnualVolumeNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.EstimatedAnnualVolumeNumericUpDown.Location = New System.Drawing.Point(121, 21)
        Me.EstimatedAnnualVolumeNumericUpDown.Maximum = New Decimal(New Integer() {999999999, 0, 0, 0})
        Me.EstimatedAnnualVolumeNumericUpDown.Name = "EstimatedAnnualVolumeNumericUpDown"
        Me.EstimatedAnnualVolumeNumericUpDown.Size = New System.Drawing.Size(528, 27)
        Me.EstimatedAnnualVolumeNumericUpDown.TabIndex = 2
        '
        'EstimatedAnnualVolumeLabel
        '
        Me.EstimatedAnnualVolumeLabel.AutoSize = True
        Me.EstimatedAnnualVolumeLabel.Location = New System.Drawing.Point(8, 24)
        Me.EstimatedAnnualVolumeLabel.Name = "EstimatedAnnualVolumeLabel"
        Me.EstimatedAnnualVolumeLabel.Size = New System.Drawing.Size(127, 21)
        Me.EstimatedAnnualVolumeLabel.TabIndex = 1
        Me.EstimatedAnnualVolumeLabel.Text = "Annual Volume:"
        '
        'ChangeThresholdPanel
        '
        Me.ChangeThresholdPanel.Controls.Add(Me.ChangeThresholdNumericUpDown)
        Me.ChangeThresholdPanel.Controls.Add(Me.ChangeThresholdLabel)
        Me.ChangeThresholdPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ChangeThresholdPanel.Location = New System.Drawing.Point(667, 0)
        Me.ChangeThresholdPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.ChangeThresholdPanel.Name = "ChangeThresholdPanel"
        Me.ChangeThresholdPanel.Size = New System.Drawing.Size(668, 52)
        Me.ChangeThresholdPanel.TabIndex = 1
        '
        'ChangeThresholdNumericUpDown
        '
        Me.ChangeThresholdNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ChangeThresholdNumericUpDown.DecimalPlaces = 4
        Me.MedicareErrorProvider.SetIconAlignment(Me.ChangeThresholdNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.ChangeThresholdNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.ChangeThresholdNumericUpDown.Location = New System.Drawing.Point(165, 5)
        Me.ChangeThresholdNumericUpDown.Name = "ChangeThresholdNumericUpDown"
        Me.ChangeThresholdNumericUpDown.Size = New System.Drawing.Size(486, 27)
        Me.ChangeThresholdNumericUpDown.TabIndex = 1
        '
        'ChangeThresholdLabel
        '
        Me.ChangeThresholdLabel.AutoSize = True
        Me.ChangeThresholdLabel.Location = New System.Drawing.Point(8, 8)
        Me.ChangeThresholdLabel.Name = "ChangeThresholdLabel"
        Me.ChangeThresholdLabel.Size = New System.Drawing.Size(230, 21)
        Me.ChangeThresholdLabel.TabIndex = 0
        Me.ChangeThresholdLabel.Text = "Proportion Change Threshold:"
        '
        'AnnualReturnTargetPanel
        '
        Me.AnnualReturnTargetPanel.Controls.Add(Me.ForceCensusSampleCheckBox)
        Me.AnnualReturnTargetPanel.Controls.Add(Me.AnnualReturnTargetNumericUpDown)
        Me.AnnualReturnTargetPanel.Controls.Add(Me.AnnualReturnTargetLabel)
        Me.AnnualReturnTargetPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AnnualReturnTargetPanel.Location = New System.Drawing.Point(0, 0)
        Me.AnnualReturnTargetPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.AnnualReturnTargetPanel.Name = "AnnualReturnTargetPanel"
        Me.AnnualReturnTargetPanel.Size = New System.Drawing.Size(667, 52)
        Me.AnnualReturnTargetPanel.TabIndex = 0
        '
        'ForceCensusSampleCheckBox
        '
        Me.ForceCensusSampleCheckBox.AutoSize = True
        Me.ForceCensusSampleCheckBox.Location = New System.Drawing.Point(6, 33)
        Me.ForceCensusSampleCheckBox.Name = "ForceCensusSampleCheckBox"
        Me.ForceCensusSampleCheckBox.Size = New System.Drawing.Size(207, 25)
        Me.ForceCensusSampleCheckBox.TabIndex = 2
        Me.ForceCensusSampleCheckBox.Text = "Force Census Sampling"
        Me.ForceCensusSampleCheckBox.UseVisualStyleBackColor = True
        '
        'AnnualReturnTargetNumericUpDown
        '
        Me.AnnualReturnTargetNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MedicareErrorProvider.SetIconAlignment(Me.AnnualReturnTargetNumericUpDown, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.AnnualReturnTargetNumericUpDown.Location = New System.Drawing.Point(127, 5)
        Me.AnnualReturnTargetNumericUpDown.Maximum = New Decimal(New Integer() {99999, 0, 0, 0})
        Me.AnnualReturnTargetNumericUpDown.Name = "AnnualReturnTargetNumericUpDown"
        Me.AnnualReturnTargetNumericUpDown.Size = New System.Drawing.Size(531, 27)
        Me.AnnualReturnTargetNumericUpDown.TabIndex = 1
        '
        'AnnualReturnTargetLabel
        '
        Me.AnnualReturnTargetLabel.AutoSize = True
        Me.AnnualReturnTargetLabel.Location = New System.Drawing.Point(3, 8)
        Me.AnnualReturnTargetLabel.Name = "AnnualReturnTargetLabel"
        Me.AnnualReturnTargetLabel.Size = New System.Drawing.Size(176, 21)
        Me.AnnualReturnTargetLabel.TabIndex = 0
        Me.AnnualReturnTargetLabel.Text = "Annual Return Target:"
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.HHCAHPS_CancelButton)
        Me.TabPage1.Controls.Add(Me.HHCAHPS_ApplyButton)
        Me.TabPage1.Controls.Add(Me.TableLayoutPanel2)
        Me.TabPage1.Location = New System.Drawing.Point(4, 30)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(1355, 460)
        Me.TabPage1.TabIndex = 3
        Me.TabPage1.Text = "HHCAHPS"
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'HHCAHPS_CancelButton
        '
        Me.HHCAHPS_CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_CancelButton.Location = New System.Drawing.Point(1273, 416)
        Me.HHCAHPS_CancelButton.Name = "HHCAHPS_CancelButton"
        Me.HHCAHPS_CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.HHCAHPS_CancelButton.TabIndex = 39
        Me.HHCAHPS_CancelButton.Text = "Cancel"
        Me.HHCAHPS_CancelButton.UseVisualStyleBackColor = True
        '
        'HHCAHPS_ApplyButton
        '
        Me.HHCAHPS_ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_ApplyButton.Location = New System.Drawing.Point(1192, 416)
        Me.HHCAHPS_ApplyButton.Name = "HHCAHPS_ApplyButton"
        Me.HHCAHPS_ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.HHCAHPS_ApplyButton.TabIndex = 38
        Me.HHCAHPS_ApplyButton.Text = "Apply"
        Me.HHCAHPS_ApplyButton.UseVisualStyleBackColor = True
        '
        'TableLayoutPanel2
        '
        Me.TableLayoutPanel2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel2.ColumnCount = 2
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.Controls.Add(Me.Panel24, 1, 11)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel23, 0, 11)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel22, 1, 10)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel25, 0, 10)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel20, 1, 9)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel19, 0, 9)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel18, 1, 8)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel17, 0, 8)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel16, 1, 7)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel15, 0, 7)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel14, 1, 6)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel13, 0, 6)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel12, 1, 5)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel11, 0, 5)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel10, 1, 4)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel9, 0, 4)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel8, 1, 3)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel7, 0, 3)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel6, 1, 2)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel5, 0, 2)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel4, 1, 1)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel3, 0, 1)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel2, 1, 0)
        Me.TableLayoutPanel2.Controls.Add(Me.Panel1, 0, 0)
        Me.TableLayoutPanel2.Location = New System.Drawing.Point(6, 0)
        Me.TableLayoutPanel2.Name = "TableLayoutPanel2"
        Me.TableLayoutPanel2.RowCount = 12
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 47.88733!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 52.11267!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 37.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 37.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 37.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 34.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 47.0!))
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel2.Size = New System.Drawing.Size(1353, 442)
        Me.TableLayoutPanel2.TabIndex = 0
        '
        'Panel24
        '
        Me.Panel24.Controls.Add(Me.HHCAHPS_MedicareCalcHistoryButton)
        Me.Panel24.Location = New System.Drawing.Point(679, 397)
        Me.Panel24.Name = "Panel24"
        Me.Panel24.Size = New System.Drawing.Size(669, 27)
        Me.Panel24.TabIndex = 23
        '
        'HHCAHPS_MedicareCalcHistoryButton
        '
        Me.HHCAHPS_MedicareCalcHistoryButton.Location = New System.Drawing.Point(174, 1)
        Me.HHCAHPS_MedicareCalcHistoryButton.Name = "HHCAHPS_MedicareCalcHistoryButton"
        Me.HHCAHPS_MedicareCalcHistoryButton.Size = New System.Drawing.Size(113, 23)
        Me.HHCAHPS_MedicareCalcHistoryButton.TabIndex = 32
        Me.HHCAHPS_MedicareCalcHistoryButton.Text = "View Recalc History"
        Me.HHCAHPS_MedicareCalcHistoryButton.UseVisualStyleBackColor = True
        '
        'Panel23
        '
        Me.Panel23.Controls.Add(Me.HHCAHPS_NonSubmittingCheckbox)
        Me.Panel23.Location = New System.Drawing.Point(3, 397)
        Me.Panel23.Name = "Panel23"
        Me.Panel23.Size = New System.Drawing.Size(668, 27)
        Me.Panel23.TabIndex = 22
        '
        'HHCAHPS_NonSubmittingCheckbox
        '
        Me.HHCAHPS_NonSubmittingCheckbox.AutoSize = True
        Me.HHCAHPS_NonSubmittingCheckbox.Location = New System.Drawing.Point(8, 5)
        Me.HHCAHPS_NonSubmittingCheckbox.Name = "HHCAHPS_NonSubmittingCheckbox"
        Me.HHCAHPS_NonSubmittingCheckbox.Size = New System.Drawing.Size(144, 25)
        Me.HHCAHPS_NonSubmittingCheckbox.TabIndex = 35
        Me.HHCAHPS_NonSubmittingCheckbox.Text = "Do Not Submit"
        Me.HHCAHPS_NonSubmittingCheckbox.UseVisualStyleBackColor = True
        '
        'Panel22
        '
        Me.Panel22.Controls.Add(Me.HHCAHPS_ProportionUsedNumericUpDown)
        Me.Panel22.Controls.Add(Me.HHCAHPS_ProportionUsedLabel)
        Me.Panel22.Location = New System.Drawing.Point(679, 363)
        Me.Panel22.Name = "Panel22"
        Me.Panel22.Size = New System.Drawing.Size(669, 27)
        Me.Panel22.TabIndex = 21
        '
        'HHCAHPS_ProportionUsedNumericUpDown
        '
        Me.HHCAHPS_ProportionUsedNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_ProportionUsedNumericUpDown.DecimalPlaces = 4
        Me.HHCAHPS_ProportionUsedNumericUpDown.Enabled = False
        Me.HHCAHPS_ProportionUsedNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.HHCAHPS_ProportionUsedNumericUpDown.Location = New System.Drawing.Point(174, 0)
        Me.HHCAHPS_ProportionUsedNumericUpDown.Name = "HHCAHPS_ProportionUsedNumericUpDown"
        Me.HHCAHPS_ProportionUsedNumericUpDown.ReadOnly = True
        Me.HHCAHPS_ProportionUsedNumericUpDown.Size = New System.Drawing.Size(489, 27)
        Me.HHCAHPS_ProportionUsedNumericUpDown.TabIndex = 40
        '
        'HHCAHPS_ProportionUsedLabel
        '
        Me.HHCAHPS_ProportionUsedLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_ProportionUsedLabel.AutoSize = True
        Me.HHCAHPS_ProportionUsedLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_ProportionUsedLabel.Name = "HHCAHPS_ProportionUsedLabel"
        Me.HHCAHPS_ProportionUsedLabel.Size = New System.Drawing.Size(134, 21)
        Me.HHCAHPS_ProportionUsedLabel.TabIndex = 39
        Me.HHCAHPS_ProportionUsedLabel.Text = "Proportion Used:"
        '
        'Panel25
        '
        Me.Panel25.Controls.Add(Me.HHCAHPS_InactiveCheckBox)
        Me.Panel25.Location = New System.Drawing.Point(3, 363)
        Me.Panel25.Name = "Panel25"
        Me.Panel25.Size = New System.Drawing.Size(668, 27)
        Me.Panel25.TabIndex = 20
        '
        'HHCAHPS_InactiveCheckBox
        '
        Me.HHCAHPS_InactiveCheckBox.AutoSize = True
        Me.HHCAHPS_InactiveCheckBox.Location = New System.Drawing.Point(8, 7)
        Me.HHCAHPS_InactiveCheckBox.Name = "HHCAHPS_InactiveCheckBox"
        Me.HHCAHPS_InactiveCheckBox.Size = New System.Drawing.Size(146, 25)
        Me.HHCAHPS_InactiveCheckBox.TabIndex = 34
        Me.HHCAHPS_InactiveCheckBox.Text = "Inactivate CCN"
        Me.HHCAHPS_InactiveCheckBox.UseVisualStyleBackColor = True
        '
        'Panel20
        '
        Me.Panel20.Controls.Add(Me.HHCAHPS_CalcProportionNumericUpDown)
        Me.Panel20.Controls.Add(Me.HHCAHPS_CalcProportionLabel)
        Me.Panel20.Location = New System.Drawing.Point(679, 327)
        Me.Panel20.Name = "Panel20"
        Me.Panel20.Size = New System.Drawing.Size(669, 27)
        Me.Panel20.TabIndex = 19
        '
        'HHCAHPS_CalcProportionNumericUpDown
        '
        Me.HHCAHPS_CalcProportionNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_CalcProportionNumericUpDown.DecimalPlaces = 4
        Me.HHCAHPS_CalcProportionNumericUpDown.Enabled = False
        Me.HHCAHPS_CalcProportionNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.HHCAHPS_CalcProportionNumericUpDown.Location = New System.Drawing.Point(174, 0)
        Me.HHCAHPS_CalcProportionNumericUpDown.Name = "HHCAHPS_CalcProportionNumericUpDown"
        Me.HHCAHPS_CalcProportionNumericUpDown.ReadOnly = True
        Me.HHCAHPS_CalcProportionNumericUpDown.Size = New System.Drawing.Size(507, 27)
        Me.HHCAHPS_CalcProportionNumericUpDown.TabIndex = 39
        '
        'HHCAHPS_CalcProportionLabel
        '
        Me.HHCAHPS_CalcProportionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_CalcProportionLabel.AutoSize = True
        Me.HHCAHPS_CalcProportionLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_CalcProportionLabel.Name = "HHCAHPS_CalcProportionLabel"
        Me.HHCAHPS_CalcProportionLabel.Size = New System.Drawing.Size(174, 21)
        Me.HHCAHPS_CalcProportionLabel.TabIndex = 38
        Me.HHCAHPS_CalcProportionLabel.Text = "Calculated Proportion:"
        '
        'Panel19
        '
        Me.Panel19.Location = New System.Drawing.Point(3, 327)
        Me.Panel19.Name = "Panel19"
        Me.Panel19.Size = New System.Drawing.Size(668, 27)
        Me.Panel19.TabIndex = 18
        '
        'Panel18
        '
        Me.Panel18.Controls.Add(Me.HHCAHPS_LastCalcTypeTextBox)
        Me.Panel18.Controls.Add(Me.HHCAHPS_LastCalcTypeLabel)
        Me.Panel18.Location = New System.Drawing.Point(679, 291)
        Me.Panel18.Name = "Panel18"
        Me.Panel18.Size = New System.Drawing.Size(669, 27)
        Me.Panel18.TabIndex = 17
        '
        'HHCAHPS_LastCalcTypeTextBox
        '
        Me.HHCAHPS_LastCalcTypeTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_LastCalcTypeTextBox.Location = New System.Drawing.Point(174, 3)
        Me.HHCAHPS_LastCalcTypeTextBox.Name = "HHCAHPS_LastCalcTypeTextBox"
        Me.HHCAHPS_LastCalcTypeTextBox.ReadOnly = True
        Me.HHCAHPS_LastCalcTypeTextBox.Size = New System.Drawing.Size(489, 27)
        Me.HHCAHPS_LastCalcTypeTextBox.TabIndex = 28
        '
        'HHCAHPS_LastCalcTypeLabel
        '
        Me.HHCAHPS_LastCalcTypeLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_LastCalcTypeLabel.AutoSize = True
        Me.HHCAHPS_LastCalcTypeLabel.Location = New System.Drawing.Point(3, 6)
        Me.HHCAHPS_LastCalcTypeLabel.Name = "HHCAHPS_LastCalcTypeLabel"
        Me.HHCAHPS_LastCalcTypeLabel.Size = New System.Drawing.Size(174, 21)
        Me.HHCAHPS_LastCalcTypeLabel.TabIndex = 27
        Me.HHCAHPS_LastCalcTypeLabel.Text = "Last Calculation Type:"
        '
        'Panel17
        '
        Me.Panel17.Controls.Add(Me.HHCAHPS_MedicareReCalcButton)
        Me.Panel17.Location = New System.Drawing.Point(3, 291)
        Me.Panel17.Name = "Panel17"
        Me.Panel17.Size = New System.Drawing.Size(668, 27)
        Me.Panel17.TabIndex = 16
        '
        'HHCAHPS_MedicareReCalcButton
        '
        Me.HHCAHPS_MedicareReCalcButton.Location = New System.Drawing.Point(171, 1)
        Me.HHCAHPS_MedicareReCalcButton.Name = "HHCAHPS_MedicareReCalcButton"
        Me.HHCAHPS_MedicareReCalcButton.Size = New System.Drawing.Size(115, 23)
        Me.HHCAHPS_MedicareReCalcButton.TabIndex = 33
        Me.HHCAHPS_MedicareReCalcButton.Text = "Force Recalc"
        Me.HHCAHPS_MedicareReCalcButton.UseVisualStyleBackColor = True
        '
        'Panel16
        '
        Me.Panel16.Controls.Add(Me.HHCAHPS_LastCalcDateTextBox)
        Me.Panel16.Controls.Add(Me.HHCAHPS_LastCalcDateLabel)
        Me.Panel16.Location = New System.Drawing.Point(679, 255)
        Me.Panel16.Name = "Panel16"
        Me.Panel16.Size = New System.Drawing.Size(669, 27)
        Me.Panel16.TabIndex = 15
        '
        'HHCAHPS_LastCalcDateTextBox
        '
        Me.HHCAHPS_LastCalcDateTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_LastCalcDateTextBox.Location = New System.Drawing.Point(174, 5)
        Me.HHCAHPS_LastCalcDateTextBox.Name = "HHCAHPS_LastCalcDateTextBox"
        Me.HHCAHPS_LastCalcDateTextBox.ReadOnly = True
        Me.HHCAHPS_LastCalcDateTextBox.Size = New System.Drawing.Size(489, 27)
        Me.HHCAHPS_LastCalcDateTextBox.TabIndex = 27
        '
        'HHCAHPS_LastCalcDateLabel
        '
        Me.HHCAHPS_LastCalcDateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_LastCalcDateLabel.AutoSize = True
        Me.HHCAHPS_LastCalcDateLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_LastCalcDateLabel.Name = "HHCAHPS_LastCalcDateLabel"
        Me.HHCAHPS_LastCalcDateLabel.Size = New System.Drawing.Size(155, 21)
        Me.HHCAHPS_LastCalcDateLabel.TabIndex = 26
        Me.HHCAHPS_LastCalcDateLabel.Text = "Last Calculated On:"
        '
        'Panel15
        '
        Me.Panel15.Controls.Add(Me.HHCAHPS_SamplingRateNumericUpDown)
        Me.Panel15.Controls.Add(Me.HHCAHPS_SamplingRateLabel)
        Me.Panel15.Location = New System.Drawing.Point(3, 255)
        Me.Panel15.Name = "Panel15"
        Me.Panel15.Size = New System.Drawing.Size(668, 27)
        Me.Panel15.TabIndex = 14
        '
        'HHCAHPS_SamplingRateNumericUpDown
        '
        Me.HHCAHPS_SamplingRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SamplingRateNumericUpDown.DecimalPlaces = 4
        Me.HHCAHPS_SamplingRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.HHCAHPS_SamplingRateNumericUpDown.Location = New System.Drawing.Point(171, 0)
        Me.HHCAHPS_SamplingRateNumericUpDown.Name = "HHCAHPS_SamplingRateNumericUpDown"
        Me.HHCAHPS_SamplingRateNumericUpDown.Size = New System.Drawing.Size(494, 27)
        Me.HHCAHPS_SamplingRateNumericUpDown.TabIndex = 13
        '
        'HHCAHPS_SamplingRateLabel
        '
        Me.HHCAHPS_SamplingRateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SamplingRateLabel.AutoSize = True
        Me.HHCAHPS_SamplingRateLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_SamplingRateLabel.Name = "HHCAHPS_SamplingRateLabel"
        Me.HHCAHPS_SamplingRateLabel.Size = New System.Drawing.Size(123, 21)
        Me.HHCAHPS_SamplingRateLabel.TabIndex = 12
        Me.HHCAHPS_SamplingRateLabel.Text = "Sampling Rate:"
        '
        'Panel14
        '
        Me.Panel14.Controls.Add(Me.HHCAHPS_LastCalculationLabel)
        Me.Panel14.Location = New System.Drawing.Point(679, 219)
        Me.Panel14.Name = "Panel14"
        Me.Panel14.Size = New System.Drawing.Size(669, 27)
        Me.Panel14.TabIndex = 13
        '
        'HHCAHPS_LastCalculationLabel
        '
        Me.HHCAHPS_LastCalculationLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_LastCalculationLabel.AutoSize = True
        Me.HHCAHPS_LastCalculationLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_LastCalculationLabel.Name = "HHCAHPS_LastCalculationLabel"
        Me.HHCAHPS_LastCalculationLabel.Size = New System.Drawing.Size(127, 21)
        Me.HHCAHPS_LastCalculationLabel.TabIndex = 43
        Me.HHCAHPS_LastCalculationLabel.Text = "Last Calculation"
        '
        'Panel13
        '
        Me.Panel13.Controls.Add(Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker)
        Me.Panel13.Controls.Add(Me.HHCAHPS_SwitchFromOverrideDateLabel)
        Me.Panel13.Location = New System.Drawing.Point(3, 219)
        Me.Panel13.Name = "Panel13"
        Me.Panel13.Size = New System.Drawing.Size(668, 27)
        Me.Panel13.TabIndex = 12
        '
        'HHCAHPS_SwitchFromOverrideDateDateTimePicker
        '
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker.Location = New System.Drawing.Point(171, 0)
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker.Name = "HHCAHPS_SwitchFromOverrideDateDateTimePicker"
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker.Size = New System.Drawing.Size(494, 27)
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker.TabIndex = 42
        Me.HHCAHPS_SwitchFromOverrideDateDateTimePicker.Value = New Date(1900, 1, 1, 0, 0, 0, 0)
        '
        'HHCAHPS_SwitchFromOverrideDateLabel
        '
        Me.HHCAHPS_SwitchFromOverrideDateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SwitchFromOverrideDateLabel.AutoSize = True
        Me.HHCAHPS_SwitchFromOverrideDateLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_SwitchFromOverrideDateLabel.Name = "HHCAHPS_SwitchFromOverrideDateLabel"
        Me.HHCAHPS_SwitchFromOverrideDateLabel.Size = New System.Drawing.Size(213, 21)
        Me.HHCAHPS_SwitchFromOverrideDateLabel.TabIndex = 41
        Me.HHCAHPS_SwitchFromOverrideDateLabel.Text = "Switch from Override Date:"
        '
        'Panel12
        '
        Me.Panel12.Controls.Add(Me.HHCAHPS_HistoricResponseRateNumericUpDown)
        Me.Panel12.Controls.Add(Me.HHCAHPA_HistoricResponseRateLabel)
        Me.Panel12.Location = New System.Drawing.Point(679, 183)
        Me.Panel12.Name = "Panel12"
        Me.Panel12.Size = New System.Drawing.Size(669, 27)
        Me.Panel12.TabIndex = 11
        '
        'HHCAHPS_HistoricResponseRateNumericUpDown
        '
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.DecimalPlaces = 4
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.Enabled = False
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.Location = New System.Drawing.Point(174, 3)
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.Name = "HHCAHPS_HistoricResponseRateNumericUpDown"
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.ReadOnly = True
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.Size = New System.Drawing.Size(489, 27)
        Me.HHCAHPS_HistoricResponseRateNumericUpDown.TabIndex = 38
        '
        'HHCAHPA_HistoricResponseRateLabel
        '
        Me.HHCAHPA_HistoricResponseRateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPA_HistoricResponseRateLabel.AutoSize = True
        Me.HHCAHPA_HistoricResponseRateLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPA_HistoricResponseRateLabel.Name = "HHCAHPA_HistoricResponseRateLabel"
        Me.HHCAHPA_HistoricResponseRateLabel.Size = New System.Drawing.Size(189, 21)
        Me.HHCAHPA_HistoricResponseRateLabel.TabIndex = 37
        Me.HHCAHPA_HistoricResponseRateLabel.Text = "Historic Response Rate:"
        '
        'Panel11
        '
        Me.Panel11.Controls.Add(Me.HHCAHPS_SamplingRateOverrideLabel)
        Me.Panel11.Location = New System.Drawing.Point(3, 183)
        Me.Panel11.Name = "Panel11"
        Me.Panel11.Size = New System.Drawing.Size(668, 27)
        Me.Panel11.TabIndex = 10
        '
        'HHCAHPS_SamplingRateOverrideLabel
        '
        Me.HHCAHPS_SamplingRateOverrideLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SamplingRateOverrideLabel.AutoSize = True
        Me.HHCAHPS_SamplingRateOverrideLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_SamplingRateOverrideLabel.Name = "HHCAHPS_SamplingRateOverrideLabel"
        Me.HHCAHPS_SamplingRateOverrideLabel.Size = New System.Drawing.Size(185, 21)
        Me.HHCAHPS_SamplingRateOverrideLabel.TabIndex = 9
        Me.HHCAHPS_SamplingRateOverrideLabel.Text = "Sampling Rate Override"
        '
        'Panel10
        '
        Me.Panel10.Controls.Add(Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown)
        Me.Panel10.Controls.Add(Me.HHCAHPS_AnnualEligibleVolumeLabel)
        Me.Panel10.Location = New System.Drawing.Point(679, 146)
        Me.Panel10.Name = "Panel10"
        Me.Panel10.Size = New System.Drawing.Size(669, 27)
        Me.Panel10.TabIndex = 9
        '
        'HHCAHPS_AnnualEligibleVolumeNumericUpDown
        '
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown.Enabled = False
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown.Location = New System.Drawing.Point(174, 0)
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown.Maximum = New Decimal(New Integer() {999999999, 0, 0, 0})
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown.Name = "HHCAHPS_AnnualEligibleVolumeNumericUpDown"
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown.ReadOnly = True
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown.Size = New System.Drawing.Size(489, 27)
        Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown.TabIndex = 37
        '
        'HHCAHPS_AnnualEligibleVolumeLabel
        '
        Me.HHCAHPS_AnnualEligibleVolumeLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_AnnualEligibleVolumeLabel.AutoSize = True
        Me.HHCAHPS_AnnualEligibleVolumeLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_AnnualEligibleVolumeLabel.Name = "HHCAHPS_AnnualEligibleVolumeLabel"
        Me.HHCAHPS_AnnualEligibleVolumeLabel.Size = New System.Drawing.Size(188, 21)
        Me.HHCAHPS_AnnualEligibleVolumeLabel.TabIndex = 36
        Me.HHCAHPS_AnnualEligibleVolumeLabel.Text = "Historic Annual Volume:"
        '
        'Panel9
        '
        Me.Panel9.Controls.Add(Me.HHCAHPS_EstimatedResponseRateNumericUpDown)
        Me.Panel9.Controls.Add(Me.HHCAHPS_EstimatedResponseRateLabel)
        Me.Panel9.Location = New System.Drawing.Point(3, 146)
        Me.Panel9.Name = "Panel9"
        Me.Panel9.Size = New System.Drawing.Size(668, 27)
        Me.Panel9.TabIndex = 8
        '
        'HHCAHPS_EstimatedResponseRateNumericUpDown
        '
        Me.HHCAHPS_EstimatedResponseRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_EstimatedResponseRateNumericUpDown.DecimalPlaces = 4
        Me.HHCAHPS_EstimatedResponseRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.HHCAHPS_EstimatedResponseRateNumericUpDown.Location = New System.Drawing.Point(171, 5)
        Me.HHCAHPS_EstimatedResponseRateNumericUpDown.Name = "HHCAHPS_EstimatedResponseRateNumericUpDown"
        Me.HHCAHPS_EstimatedResponseRateNumericUpDown.Size = New System.Drawing.Size(494, 27)
        Me.HHCAHPS_EstimatedResponseRateNumericUpDown.TabIndex = 9
        '
        'HHCAHPS_EstimatedResponseRateLabel
        '
        Me.HHCAHPS_EstimatedResponseRateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_EstimatedResponseRateLabel.AutoSize = True
        Me.HHCAHPS_EstimatedResponseRateLabel.Location = New System.Drawing.Point(3, 8)
        Me.HHCAHPS_EstimatedResponseRateLabel.Name = "HHCAHPS_EstimatedResponseRateLabel"
        Me.HHCAHPS_EstimatedResponseRateLabel.Size = New System.Drawing.Size(208, 21)
        Me.HHCAHPS_EstimatedResponseRateLabel.TabIndex = 8
        Me.HHCAHPS_EstimatedResponseRateLabel.Text = "Estimated Response Rate:"
        '
        'Panel8
        '
        Me.Panel8.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel8.Controls.Add(Me.HHCAHPS_HistoricValuesLabel)
        Me.Panel8.Location = New System.Drawing.Point(679, 109)
        Me.Panel8.Name = "Panel8"
        Me.Panel8.Size = New System.Drawing.Size(671, 27)
        Me.Panel8.TabIndex = 7
        '
        'HHCAHPS_HistoricValuesLabel
        '
        Me.HHCAHPS_HistoricValuesLabel.AutoSize = True
        Me.HHCAHPS_HistoricValuesLabel.Location = New System.Drawing.Point(3, 14)
        Me.HHCAHPS_HistoricValuesLabel.Name = "HHCAHPS_HistoricValuesLabel"
        Me.HHCAHPS_HistoricValuesLabel.Size = New System.Drawing.Size(120, 21)
        Me.HHCAHPS_HistoricValuesLabel.TabIndex = 17
        Me.HHCAHPS_HistoricValuesLabel.Text = "Historic Values"
        '
        'Panel7
        '
        Me.Panel7.Controls.Add(Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown)
        Me.Panel7.Controls.Add(Me.HHCAHPS_EstimatedAnnualVolumeLabel)
        Me.Panel7.Location = New System.Drawing.Point(3, 109)
        Me.Panel7.Name = "Panel7"
        Me.Panel7.Size = New System.Drawing.Size(668, 27)
        Me.Panel7.TabIndex = 6
        '
        'HHCAHPS_EstimatedAnnualVolumeNumericUpDown
        '
        Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown.Location = New System.Drawing.Point(171, 3)
        Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown.Maximum = New Decimal(New Integer() {999999999, 0, 0, 0})
        Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown.Name = "HHCAHPS_EstimatedAnnualVolumeNumericUpDown"
        Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown.Size = New System.Drawing.Size(494, 27)
        Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown.TabIndex = 7
        '
        'HHCAHPS_EstimatedAnnualVolumeLabel
        '
        Me.HHCAHPS_EstimatedAnnualVolumeLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_EstimatedAnnualVolumeLabel.AutoSize = True
        Me.HHCAHPS_EstimatedAnnualVolumeLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_EstimatedAnnualVolumeLabel.Name = "HHCAHPS_EstimatedAnnualVolumeLabel"
        Me.HHCAHPS_EstimatedAnnualVolumeLabel.Size = New System.Drawing.Size(207, 21)
        Me.HHCAHPS_EstimatedAnnualVolumeLabel.TabIndex = 6
        Me.HHCAHPS_EstimatedAnnualVolumeLabel.Text = "Estimated Annual Volume:"
        '
        'Panel6
        '
        Me.Panel6.Controls.Add(Me.HHCAHPS_MedicareUnlockSamplingButton)
        Me.Panel6.Location = New System.Drawing.Point(679, 72)
        Me.Panel6.Name = "Panel6"
        Me.Panel6.Size = New System.Drawing.Size(669, 27)
        Me.Panel6.TabIndex = 5
        '
        'HHCAHPS_MedicareUnlockSamplingButton
        '
        Me.HHCAHPS_MedicareUnlockSamplingButton.Location = New System.Drawing.Point(174, 4)
        Me.HHCAHPS_MedicareUnlockSamplingButton.Name = "HHCAHPS_MedicareUnlockSamplingButton"
        Me.HHCAHPS_MedicareUnlockSamplingButton.Size = New System.Drawing.Size(113, 23)
        Me.HHCAHPS_MedicareUnlockSamplingButton.TabIndex = 1
        Me.HHCAHPS_MedicareUnlockSamplingButton.Text = "Unlock Sampling"
        Me.HHCAHPS_MedicareUnlockSamplingButton.UseVisualStyleBackColor = True
        '
        'Panel5
        '
        Me.Panel5.Controls.Add(Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker)
        Me.Panel5.Controls.Add(Me.HHCAHPS_SwtichFromEstimatedDateLabel)
        Me.Panel5.Location = New System.Drawing.Point(3, 72)
        Me.Panel5.Name = "Panel5"
        Me.Panel5.Size = New System.Drawing.Size(668, 27)
        Me.Panel5.TabIndex = 4
        '
        'HHCAHPS_SwtichFromEstimatedDateDateTimePicker
        '
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker.Location = New System.Drawing.Point(171, 4)
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker.Name = "HHCAHPS_SwtichFromEstimatedDateDateTimePicker"
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker.Size = New System.Drawing.Size(494, 27)
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker.TabIndex = 41
        Me.HHCAHPS_SwtichFromEstimatedDateDateTimePicker.Value = New Date(1900, 1, 1, 0, 0, 0, 0)
        '
        'HHCAHPS_SwtichFromEstimatedDateLabel
        '
        Me.HHCAHPS_SwtichFromEstimatedDateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SwtichFromEstimatedDateLabel.AutoSize = True
        Me.HHCAHPS_SwtichFromEstimatedDateLabel.Location = New System.Drawing.Point(3, 4)
        Me.HHCAHPS_SwtichFromEstimatedDateLabel.Name = "HHCAHPS_SwtichFromEstimatedDateLabel"
        Me.HHCAHPS_SwtichFromEstimatedDateLabel.Size = New System.Drawing.Size(225, 21)
        Me.HHCAHPS_SwtichFromEstimatedDateLabel.TabIndex = 40
        Me.HHCAHPS_SwtichFromEstimatedDateLabel.Text = "Swtich from Estimated Date:"
        '
        'Panel4
        '
        Me.Panel4.Controls.Add(Me.HHCAHPS_SamplingLockTextBox)
        Me.Panel4.Controls.Add(Me.HHCAHPS_SampleLockLabel)
        Me.Panel4.Location = New System.Drawing.Point(679, 36)
        Me.Panel4.Name = "Panel4"
        Me.Panel4.Size = New System.Drawing.Size(669, 27)
        Me.Panel4.TabIndex = 3
        '
        'HHCAHPS_SamplingLockTextBox
        '
        Me.HHCAHPS_SamplingLockTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SamplingLockTextBox.BackColor = System.Drawing.SystemColors.Control
        Me.HHCAHPS_SamplingLockTextBox.Location = New System.Drawing.Point(174, 0)
        Me.HHCAHPS_SamplingLockTextBox.Name = "HHCAHPS_SamplingLockTextBox"
        Me.HHCAHPS_SamplingLockTextBox.ReadOnly = True
        Me.HHCAHPS_SamplingLockTextBox.Size = New System.Drawing.Size(489, 27)
        Me.HHCAHPS_SamplingLockTextBox.TabIndex = 17
        '
        'HHCAHPS_SampleLockLabel
        '
        Me.HHCAHPS_SampleLockLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_SampleLockLabel.AutoSize = True
        Me.HHCAHPS_SampleLockLabel.Location = New System.Drawing.Point(3, 6)
        Me.HHCAHPS_SampleLockLabel.Name = "HHCAHPS_SampleLockLabel"
        Me.HHCAHPS_SampleLockLabel.Size = New System.Drawing.Size(173, 21)
        Me.HHCAHPS_SampleLockLabel.TabIndex = 16
        Me.HHCAHPS_SampleLockLabel.Text = "Sampling Lock Status:"
        '
        'Panel3
        '
        Me.Panel3.Controls.Add(Me.HHCAHPS_EstimatedValuesLabel)
        Me.Panel3.Location = New System.Drawing.Point(3, 36)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(668, 27)
        Me.Panel3.TabIndex = 2
        '
        'HHCAHPS_EstimatedValuesLabel
        '
        Me.HHCAHPS_EstimatedValuesLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_EstimatedValuesLabel.AutoSize = True
        Me.HHCAHPS_EstimatedValuesLabel.Location = New System.Drawing.Point(3, 14)
        Me.HHCAHPS_EstimatedValuesLabel.Name = "HHCAHPS_EstimatedValuesLabel"
        Me.HHCAHPS_EstimatedValuesLabel.Size = New System.Drawing.Size(139, 21)
        Me.HHCAHPS_EstimatedValuesLabel.TabIndex = 3
        Me.HHCAHPS_EstimatedValuesLabel.Text = "Estimated Values"
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.Label13)
        Me.Panel2.Controls.Add(Me.HHCAHPS_ChangeThresholdNumericUpDown)
        Me.Panel2.Controls.Add(Me.HHCAHPS_ChangeThresholdLabel)
        Me.Panel2.Location = New System.Drawing.Point(679, 3)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(669, 27)
        Me.Panel2.TabIndex = 1
        '
        'Label13
        '
        Me.Label13.AutoSize = True
        Me.Label13.ForeColor = System.Drawing.Color.Red
        Me.Label13.ImageAlign = System.Drawing.ContentAlignment.TopRight
        Me.Label13.Location = New System.Drawing.Point(145, 3)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(19, 21)
        Me.Label13.TabIndex = 16
        Me.Label13.Text = "*"
        '
        'HHCAHPS_ChangeThresholdNumericUpDown
        '
        Me.HHCAHPS_ChangeThresholdNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_ChangeThresholdNumericUpDown.DecimalPlaces = 4
        Me.HHCAHPS_ChangeThresholdNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.HHCAHPS_ChangeThresholdNumericUpDown.Location = New System.Drawing.Point(174, 3)
        Me.HHCAHPS_ChangeThresholdNumericUpDown.Name = "HHCAHPS_ChangeThresholdNumericUpDown"
        Me.HHCAHPS_ChangeThresholdNumericUpDown.Size = New System.Drawing.Size(489, 27)
        Me.HHCAHPS_ChangeThresholdNumericUpDown.TabIndex = 15
        '
        'HHCAHPS_ChangeThresholdLabel
        '
        Me.HHCAHPS_ChangeThresholdLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_ChangeThresholdLabel.AutoSize = True
        Me.HHCAHPS_ChangeThresholdLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_ChangeThresholdLabel.Name = "HHCAHPS_ChangeThresholdLabel"
        Me.HHCAHPS_ChangeThresholdLabel.Size = New System.Drawing.Size(224, 21)
        Me.HHCAHPS_ChangeThresholdLabel.TabIndex = 14
        Me.HHCAHPS_ChangeThresholdLabel.Text = "Proportion Change Theshold:"
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.Label2)
        Me.Panel1.Controls.Add(Me.HHCAHPS_AnnualReturnTargetNumericUpDown)
        Me.Panel1.Controls.Add(Me.HHCAHPS_AnnualReturnTargetLabel)
        Me.Panel1.Location = New System.Drawing.Point(3, 3)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(668, 27)
        Me.Panel1.TabIndex = 0
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.ForeColor = System.Drawing.Color.Red
        Me.Label2.Location = New System.Drawing.Point(78, 3)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(19, 21)
        Me.Label2.TabIndex = 15
        Me.Label2.Text = "*"
        '
        'HHCAHPS_AnnualReturnTargetNumericUpDown
        '
        Me.HHCAHPS_AnnualReturnTargetNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_AnnualReturnTargetNumericUpDown.Location = New System.Drawing.Point(171, 3)
        Me.HHCAHPS_AnnualReturnTargetNumericUpDown.Maximum = New Decimal(New Integer() {99999, 0, 0, 0})
        Me.HHCAHPS_AnnualReturnTargetNumericUpDown.Name = "HHCAHPS_AnnualReturnTargetNumericUpDown"
        Me.HHCAHPS_AnnualReturnTargetNumericUpDown.Size = New System.Drawing.Size(494, 27)
        Me.HHCAHPS_AnnualReturnTargetNumericUpDown.TabIndex = 3
        '
        'HHCAHPS_AnnualReturnTargetLabel
        '
        Me.HHCAHPS_AnnualReturnTargetLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HHCAHPS_AnnualReturnTargetLabel.AutoSize = True
        Me.HHCAHPS_AnnualReturnTargetLabel.Location = New System.Drawing.Point(3, 5)
        Me.HHCAHPS_AnnualReturnTargetLabel.Name = "HHCAHPS_AnnualReturnTargetLabel"
        Me.HHCAHPS_AnnualReturnTargetLabel.Size = New System.Drawing.Size(121, 21)
        Me.HHCAHPS_AnnualReturnTargetLabel.TabIndex = 2
        Me.HHCAHPS_AnnualReturnTargetLabel.Text = "Annual Target:"
        '
        'OASCAHPS
        '
        Me.OASCAHPS.Controls.Add(Me.OASCAHPS_CancelButton)
        Me.OASCAHPS.Controls.Add(Me.OASCAHPS_ApplyButton)
        Me.OASCAHPS.Controls.Add(Me.TableLayoutPanel3)
        Me.OASCAHPS.Location = New System.Drawing.Point(4, 30)
        Me.OASCAHPS.Name = "OASCAHPS"
        Me.OASCAHPS.Padding = New System.Windows.Forms.Padding(3)
        Me.OASCAHPS.Size = New System.Drawing.Size(1355, 460)
        Me.OASCAHPS.TabIndex = 1
        Me.OASCAHPS.Text = "OASCAHPS"
        Me.OASCAHPS.UseVisualStyleBackColor = True
        '
        'OASCAHPS_CancelButton
        '
        Me.OASCAHPS_CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_CancelButton.Location = New System.Drawing.Point(1273, 416)
        Me.OASCAHPS_CancelButton.Name = "OASCAHPS_CancelButton"
        Me.OASCAHPS_CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.OASCAHPS_CancelButton.TabIndex = 39
        Me.OASCAHPS_CancelButton.Text = "Cancel"
        Me.OASCAHPS_CancelButton.UseVisualStyleBackColor = True
        '
        'OASCAHPS_ApplyButton
        '
        Me.OASCAHPS_ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_ApplyButton.Location = New System.Drawing.Point(1192, 416)
        Me.OASCAHPS_ApplyButton.Name = "OASCAHPS_ApplyButton"
        Me.OASCAHPS_ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.OASCAHPS_ApplyButton.TabIndex = 38
        Me.OASCAHPS_ApplyButton.Text = "Apply"
        Me.OASCAHPS_ApplyButton.UseVisualStyleBackColor = True
        '
        'TableLayoutPanel3
        '
        Me.TableLayoutPanel3.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel3.ColumnCount = 2
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.Controls.Add(Me.Panel21, 1, 11)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel26, 0, 11)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel27, 1, 10)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel28, 0, 10)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel29, 1, 9)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel30, 0, 9)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel31, 1, 8)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel32, 0, 8)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel33, 1, 7)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel34, 0, 7)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel35, 1, 6)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel36, 0, 6)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel37, 1, 5)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel38, 0, 5)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel39, 1, 4)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel40, 0, 4)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel49, 1, 3)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel42, 0, 3)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel43, 1, 2)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel44, 0, 2)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel45, 1, 1)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel46, 0, 1)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel47, 1, 0)
        Me.TableLayoutPanel3.Controls.Add(Me.Panel48, 0, 0)
        Me.TableLayoutPanel3.Location = New System.Drawing.Point(6, 0)
        Me.TableLayoutPanel3.Name = "TableLayoutPanel3"
        Me.TableLayoutPanel3.RowCount = 12
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 47.88733!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 52.11267!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 37.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 37.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 37.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 34.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 47.0!))
        Me.TableLayoutPanel3.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel3.Size = New System.Drawing.Size(1353, 442)
        Me.TableLayoutPanel3.TabIndex = 1
        '
        'Panel21
        '
        Me.Panel21.Controls.Add(Me.OASCAHPS_MedicareCalcHistoryButton)
        Me.Panel21.Location = New System.Drawing.Point(679, 397)
        Me.Panel21.Name = "Panel21"
        Me.Panel21.Size = New System.Drawing.Size(669, 27)
        Me.Panel21.TabIndex = 23
        '
        'OASCAHPS_MedicareCalcHistoryButton
        '
        Me.OASCAHPS_MedicareCalcHistoryButton.Location = New System.Drawing.Point(173, 0)
        Me.OASCAHPS_MedicareCalcHistoryButton.Name = "OASCAHPS_MedicareCalcHistoryButton"
        Me.OASCAHPS_MedicareCalcHistoryButton.Size = New System.Drawing.Size(113, 23)
        Me.OASCAHPS_MedicareCalcHistoryButton.TabIndex = 32
        Me.OASCAHPS_MedicareCalcHistoryButton.Text = "View Recalc History"
        Me.OASCAHPS_MedicareCalcHistoryButton.UseVisualStyleBackColor = True
        '
        'Panel26
        '
        Me.Panel26.Controls.Add(Me.OASCAHPS_NonSubmittingCheckbox)
        Me.Panel26.Location = New System.Drawing.Point(3, 397)
        Me.Panel26.Name = "Panel26"
        Me.Panel26.Size = New System.Drawing.Size(668, 27)
        Me.Panel26.TabIndex = 22
        '
        'OASCAHPS_NonSubmittingCheckbox
        '
        Me.OASCAHPS_NonSubmittingCheckbox.AutoSize = True
        Me.OASCAHPS_NonSubmittingCheckbox.Location = New System.Drawing.Point(8, 5)
        Me.OASCAHPS_NonSubmittingCheckbox.Name = "OASCAHPS_NonSubmittingCheckbox"
        Me.OASCAHPS_NonSubmittingCheckbox.Size = New System.Drawing.Size(144, 25)
        Me.OASCAHPS_NonSubmittingCheckbox.TabIndex = 35
        Me.OASCAHPS_NonSubmittingCheckbox.Text = "Do Not Submit"
        Me.OASCAHPS_NonSubmittingCheckbox.UseVisualStyleBackColor = True
        '
        'Panel27
        '
        Me.Panel27.Controls.Add(Me.OASCAHPS_ProportionUsedNumericUpDown)
        Me.Panel27.Controls.Add(Me.OASCAHPS_ProportionUsedLabel)
        Me.Panel27.Location = New System.Drawing.Point(679, 363)
        Me.Panel27.Name = "Panel27"
        Me.Panel27.Size = New System.Drawing.Size(669, 27)
        Me.Panel27.TabIndex = 21
        '
        'OASCAHPS_ProportionUsedNumericUpDown
        '
        Me.OASCAHPS_ProportionUsedNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_ProportionUsedNumericUpDown.DecimalPlaces = 4
        Me.OASCAHPS_ProportionUsedNumericUpDown.Enabled = False
        Me.OASCAHPS_ProportionUsedNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.OASCAHPS_ProportionUsedNumericUpDown.Location = New System.Drawing.Point(173, 0)
        Me.OASCAHPS_ProportionUsedNumericUpDown.Name = "OASCAHPS_ProportionUsedNumericUpDown"
        Me.OASCAHPS_ProportionUsedNumericUpDown.ReadOnly = True
        Me.OASCAHPS_ProportionUsedNumericUpDown.Size = New System.Drawing.Size(490, 27)
        Me.OASCAHPS_ProportionUsedNumericUpDown.TabIndex = 40
        '
        'OASCAHPS_ProportionUsedLabel
        '
        Me.OASCAHPS_ProportionUsedLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_ProportionUsedLabel.AutoSize = True
        Me.OASCAHPS_ProportionUsedLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_ProportionUsedLabel.Name = "OASCAHPS_ProportionUsedLabel"
        Me.OASCAHPS_ProportionUsedLabel.Size = New System.Drawing.Size(134, 21)
        Me.OASCAHPS_ProportionUsedLabel.TabIndex = 39
        Me.OASCAHPS_ProportionUsedLabel.Text = "Proportion Used:"
        '
        'Panel28
        '
        Me.Panel28.Controls.Add(Me.OASCAHPS_InactiveCheckBox)
        Me.Panel28.Location = New System.Drawing.Point(3, 363)
        Me.Panel28.Name = "Panel28"
        Me.Panel28.Size = New System.Drawing.Size(668, 27)
        Me.Panel28.TabIndex = 20
        '
        'OASCAHPS_InactiveCheckBox
        '
        Me.OASCAHPS_InactiveCheckBox.AutoSize = True
        Me.OASCAHPS_InactiveCheckBox.Location = New System.Drawing.Point(8, 7)
        Me.OASCAHPS_InactiveCheckBox.Name = "OASCAHPS_InactiveCheckBox"
        Me.OASCAHPS_InactiveCheckBox.Size = New System.Drawing.Size(146, 25)
        Me.OASCAHPS_InactiveCheckBox.TabIndex = 34
        Me.OASCAHPS_InactiveCheckBox.Text = "Inactivate CCN"
        Me.OASCAHPS_InactiveCheckBox.UseVisualStyleBackColor = True
        '
        'Panel29
        '
        Me.Panel29.Controls.Add(Me.OASCAHPS_CalcProportionNumericUpDown)
        Me.Panel29.Controls.Add(Me.OASCAHPS_CalcProportionLabel)
        Me.Panel29.Location = New System.Drawing.Point(679, 327)
        Me.Panel29.Name = "Panel29"
        Me.Panel29.Size = New System.Drawing.Size(669, 27)
        Me.Panel29.TabIndex = 19
        '
        'OASCAHPS_CalcProportionNumericUpDown
        '
        Me.OASCAHPS_CalcProportionNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_CalcProportionNumericUpDown.DecimalPlaces = 4
        Me.OASCAHPS_CalcProportionNumericUpDown.Enabled = False
        Me.OASCAHPS_CalcProportionNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.OASCAHPS_CalcProportionNumericUpDown.Location = New System.Drawing.Point(173, 0)
        Me.OASCAHPS_CalcProportionNumericUpDown.Name = "OASCAHPS_CalcProportionNumericUpDown"
        Me.OASCAHPS_CalcProportionNumericUpDown.ReadOnly = True
        Me.OASCAHPS_CalcProportionNumericUpDown.Size = New System.Drawing.Size(490, 27)
        Me.OASCAHPS_CalcProportionNumericUpDown.TabIndex = 39
        '
        'OASCAHPS_CalcProportionLabel
        '
        Me.OASCAHPS_CalcProportionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_CalcProportionLabel.AutoSize = True
        Me.OASCAHPS_CalcProportionLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_CalcProportionLabel.Name = "OASCAHPS_CalcProportionLabel"
        Me.OASCAHPS_CalcProportionLabel.Size = New System.Drawing.Size(174, 21)
        Me.OASCAHPS_CalcProportionLabel.TabIndex = 38
        Me.OASCAHPS_CalcProportionLabel.Text = "Calculated Proportion:"
        '
        'Panel30
        '
        Me.Panel30.Location = New System.Drawing.Point(3, 327)
        Me.Panel30.Name = "Panel30"
        Me.Panel30.Size = New System.Drawing.Size(668, 27)
        Me.Panel30.TabIndex = 18
        '
        'Panel31
        '
        Me.Panel31.Controls.Add(Me.OASCAHPS_LastCalcTypeTextBox)
        Me.Panel31.Controls.Add(Me.OASCAHPS_LastCalcTypeLabel)
        Me.Panel31.Location = New System.Drawing.Point(679, 291)
        Me.Panel31.Name = "Panel31"
        Me.Panel31.Size = New System.Drawing.Size(669, 27)
        Me.Panel31.TabIndex = 17
        '
        'OASCAHPS_LastCalcTypeTextBox
        '
        Me.OASCAHPS_LastCalcTypeTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_LastCalcTypeTextBox.Location = New System.Drawing.Point(173, 3)
        Me.OASCAHPS_LastCalcTypeTextBox.Name = "OASCAHPS_LastCalcTypeTextBox"
        Me.OASCAHPS_LastCalcTypeTextBox.ReadOnly = True
        Me.OASCAHPS_LastCalcTypeTextBox.Size = New System.Drawing.Size(490, 27)
        Me.OASCAHPS_LastCalcTypeTextBox.TabIndex = 28
        '
        'OASCAHPS_LastCalcTypeLabel
        '
        Me.OASCAHPS_LastCalcTypeLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_LastCalcTypeLabel.AutoSize = True
        Me.OASCAHPS_LastCalcTypeLabel.Location = New System.Drawing.Point(3, 6)
        Me.OASCAHPS_LastCalcTypeLabel.Name = "OASCAHPS_LastCalcTypeLabel"
        Me.OASCAHPS_LastCalcTypeLabel.Size = New System.Drawing.Size(174, 21)
        Me.OASCAHPS_LastCalcTypeLabel.TabIndex = 27
        Me.OASCAHPS_LastCalcTypeLabel.Text = "Last Calculation Type:"
        '
        'Panel32
        '
        Me.Panel32.Controls.Add(Me.OASCAHPS_MedicareReCalcButton)
        Me.Panel32.Location = New System.Drawing.Point(3, 291)
        Me.Panel32.Name = "Panel32"
        Me.Panel32.Size = New System.Drawing.Size(668, 27)
        Me.Panel32.TabIndex = 16
        '
        'OASCAHPS_MedicareReCalcButton
        '
        Me.OASCAHPS_MedicareReCalcButton.Location = New System.Drawing.Point(172, 1)
        Me.OASCAHPS_MedicareReCalcButton.Name = "OASCAHPS_MedicareReCalcButton"
        Me.OASCAHPS_MedicareReCalcButton.Size = New System.Drawing.Size(115, 23)
        Me.OASCAHPS_MedicareReCalcButton.TabIndex = 33
        Me.OASCAHPS_MedicareReCalcButton.Text = "Force Recalc"
        Me.OASCAHPS_MedicareReCalcButton.UseVisualStyleBackColor = True
        '
        'Panel33
        '
        Me.Panel33.Controls.Add(Me.OASCAHPS_LastCalcDateTextBox)
        Me.Panel33.Controls.Add(Me.OASCAHPS_LastCalcDateLabel)
        Me.Panel33.Location = New System.Drawing.Point(679, 255)
        Me.Panel33.Name = "Panel33"
        Me.Panel33.Size = New System.Drawing.Size(669, 27)
        Me.Panel33.TabIndex = 15
        '
        'OASCAHPS_LastCalcDateTextBox
        '
        Me.OASCAHPS_LastCalcDateTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_LastCalcDateTextBox.Location = New System.Drawing.Point(173, 5)
        Me.OASCAHPS_LastCalcDateTextBox.Name = "OASCAHPS_LastCalcDateTextBox"
        Me.OASCAHPS_LastCalcDateTextBox.ReadOnly = True
        Me.OASCAHPS_LastCalcDateTextBox.Size = New System.Drawing.Size(490, 27)
        Me.OASCAHPS_LastCalcDateTextBox.TabIndex = 27
        '
        'OASCAHPS_LastCalcDateLabel
        '
        Me.OASCAHPS_LastCalcDateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_LastCalcDateLabel.AutoSize = True
        Me.OASCAHPS_LastCalcDateLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_LastCalcDateLabel.Name = "OASCAHPS_LastCalcDateLabel"
        Me.OASCAHPS_LastCalcDateLabel.Size = New System.Drawing.Size(155, 21)
        Me.OASCAHPS_LastCalcDateLabel.TabIndex = 26
        Me.OASCAHPS_LastCalcDateLabel.Text = "Last Calculated On:"
        '
        'Panel34
        '
        Me.Panel34.Controls.Add(Me.OASCAHPS_SamplingRateNumericUpDown)
        Me.Panel34.Controls.Add(Me.OASCAHPS_SamplingRateLabel)
        Me.Panel34.Location = New System.Drawing.Point(3, 255)
        Me.Panel34.Name = "Panel34"
        Me.Panel34.Size = New System.Drawing.Size(668, 27)
        Me.Panel34.TabIndex = 14
        '
        'OASCAHPS_SamplingRateNumericUpDown
        '
        Me.OASCAHPS_SamplingRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SamplingRateNumericUpDown.DecimalPlaces = 4
        Me.OASCAHPS_SamplingRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.OASCAHPS_SamplingRateNumericUpDown.Location = New System.Drawing.Point(172, 0)
        Me.OASCAHPS_SamplingRateNumericUpDown.Name = "OASCAHPS_SamplingRateNumericUpDown"
        Me.OASCAHPS_SamplingRateNumericUpDown.Size = New System.Drawing.Size(493, 27)
        Me.OASCAHPS_SamplingRateNumericUpDown.TabIndex = 13
        '
        'OASCAHPS_SamplingRateLabel
        '
        Me.OASCAHPS_SamplingRateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SamplingRateLabel.AutoSize = True
        Me.OASCAHPS_SamplingRateLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_SamplingRateLabel.Name = "OASCAHPS_SamplingRateLabel"
        Me.OASCAHPS_SamplingRateLabel.Size = New System.Drawing.Size(123, 21)
        Me.OASCAHPS_SamplingRateLabel.TabIndex = 12
        Me.OASCAHPS_SamplingRateLabel.Text = "Sampling Rate:"
        '
        'Panel35
        '
        Me.Panel35.Controls.Add(Me.OASCAHPS_LastCalculationLabel)
        Me.Panel35.Location = New System.Drawing.Point(679, 219)
        Me.Panel35.Name = "Panel35"
        Me.Panel35.Size = New System.Drawing.Size(669, 27)
        Me.Panel35.TabIndex = 13
        '
        'OASCAHPS_LastCalculationLabel
        '
        Me.OASCAHPS_LastCalculationLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_LastCalculationLabel.AutoSize = True
        Me.OASCAHPS_LastCalculationLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_LastCalculationLabel.Name = "OASCAHPS_LastCalculationLabel"
        Me.OASCAHPS_LastCalculationLabel.Size = New System.Drawing.Size(127, 21)
        Me.OASCAHPS_LastCalculationLabel.TabIndex = 43
        Me.OASCAHPS_LastCalculationLabel.Text = "Last Calculation"
        '
        'Panel36
        '
        Me.Panel36.Controls.Add(Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker)
        Me.Panel36.Controls.Add(Me.OASCAHPS_SwitchFromOverrideDateLabel)
        Me.Panel36.Location = New System.Drawing.Point(3, 219)
        Me.Panel36.Name = "Panel36"
        Me.Panel36.Size = New System.Drawing.Size(668, 27)
        Me.Panel36.TabIndex = 12
        '
        'OASCAHPS_SwitchFromOverrideDateDateTimePicker
        '
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker.Location = New System.Drawing.Point(172, 0)
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker.Name = "OASCAHPS_SwitchFromOverrideDateDateTimePicker"
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker.Size = New System.Drawing.Size(493, 27)
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker.TabIndex = 42
        Me.OASCAHPS_SwitchFromOverrideDateDateTimePicker.Value = New Date(1900, 1, 1, 0, 0, 0, 0)
        '
        'OASCAHPS_SwitchFromOverrideDateLabel
        '
        Me.OASCAHPS_SwitchFromOverrideDateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SwitchFromOverrideDateLabel.AutoSize = True
        Me.OASCAHPS_SwitchFromOverrideDateLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_SwitchFromOverrideDateLabel.Name = "OASCAHPS_SwitchFromOverrideDateLabel"
        Me.OASCAHPS_SwitchFromOverrideDateLabel.Size = New System.Drawing.Size(213, 21)
        Me.OASCAHPS_SwitchFromOverrideDateLabel.TabIndex = 41
        Me.OASCAHPS_SwitchFromOverrideDateLabel.Text = "Switch from Override Date:"
        '
        'Panel37
        '
        Me.Panel37.Controls.Add(Me.OASCAHPS_HistoricResponseRateNumericUpDown)
        Me.Panel37.Controls.Add(Me.OASCAHPA_HistoricResponseRateLabel)
        Me.Panel37.Location = New System.Drawing.Point(679, 183)
        Me.Panel37.Name = "Panel37"
        Me.Panel37.Size = New System.Drawing.Size(669, 27)
        Me.Panel37.TabIndex = 11
        '
        'OASCAHPS_HistoricResponseRateNumericUpDown
        '
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.DecimalPlaces = 4
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.Enabled = False
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.Location = New System.Drawing.Point(173, 3)
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.Name = "OASCAHPS_HistoricResponseRateNumericUpDown"
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.ReadOnly = True
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.Size = New System.Drawing.Size(490, 27)
        Me.OASCAHPS_HistoricResponseRateNumericUpDown.TabIndex = 38
        '
        'OASCAHPA_HistoricResponseRateLabel
        '
        Me.OASCAHPA_HistoricResponseRateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPA_HistoricResponseRateLabel.AutoSize = True
        Me.OASCAHPA_HistoricResponseRateLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPA_HistoricResponseRateLabel.Name = "OASCAHPA_HistoricResponseRateLabel"
        Me.OASCAHPA_HistoricResponseRateLabel.Size = New System.Drawing.Size(189, 21)
        Me.OASCAHPA_HistoricResponseRateLabel.TabIndex = 37
        Me.OASCAHPA_HistoricResponseRateLabel.Text = "Historic Response Rate:"
        '
        'Panel38
        '
        Me.Panel38.Controls.Add(Me.OASCAHPS_SamplingRateOverrideLabel)
        Me.Panel38.Location = New System.Drawing.Point(3, 183)
        Me.Panel38.Name = "Panel38"
        Me.Panel38.Size = New System.Drawing.Size(668, 27)
        Me.Panel38.TabIndex = 10
        '
        'OASCAHPS_SamplingRateOverrideLabel
        '
        Me.OASCAHPS_SamplingRateOverrideLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SamplingRateOverrideLabel.AutoSize = True
        Me.OASCAHPS_SamplingRateOverrideLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_SamplingRateOverrideLabel.Name = "OASCAHPS_SamplingRateOverrideLabel"
        Me.OASCAHPS_SamplingRateOverrideLabel.Size = New System.Drawing.Size(185, 21)
        Me.OASCAHPS_SamplingRateOverrideLabel.TabIndex = 9
        Me.OASCAHPS_SamplingRateOverrideLabel.Text = "Sampling Rate Override"
        '
        'Panel39
        '
        Me.Panel39.Controls.Add(Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown)
        Me.Panel39.Controls.Add(Me.OASCAHPS_AnnualEligibleVolumeLabel)
        Me.Panel39.Location = New System.Drawing.Point(679, 146)
        Me.Panel39.Name = "Panel39"
        Me.Panel39.Size = New System.Drawing.Size(669, 27)
        Me.Panel39.TabIndex = 9
        '
        'OASCAHPS_AnnualEligibleVolumeNumericUpDown
        '
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown.Enabled = False
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown.Location = New System.Drawing.Point(173, 0)
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown.Maximum = New Decimal(New Integer() {999999999, 0, 0, 0})
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown.Name = "OASCAHPS_AnnualEligibleVolumeNumericUpDown"
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown.ReadOnly = True
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown.Size = New System.Drawing.Size(490, 27)
        Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown.TabIndex = 37
        '
        'OASCAHPS_AnnualEligibleVolumeLabel
        '
        Me.OASCAHPS_AnnualEligibleVolumeLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_AnnualEligibleVolumeLabel.AutoSize = True
        Me.OASCAHPS_AnnualEligibleVolumeLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_AnnualEligibleVolumeLabel.Name = "OASCAHPS_AnnualEligibleVolumeLabel"
        Me.OASCAHPS_AnnualEligibleVolumeLabel.Size = New System.Drawing.Size(188, 21)
        Me.OASCAHPS_AnnualEligibleVolumeLabel.TabIndex = 36
        Me.OASCAHPS_AnnualEligibleVolumeLabel.Text = "Historic Annual Volume:"
        '
        'Panel40
        '
        Me.Panel40.Controls.Add(Me.OASCAHPS_EstimatedResponseRateNumericUpDown)
        Me.Panel40.Controls.Add(Me.OASCAHPS_EstimatedResponseRateLabel)
        Me.Panel40.Location = New System.Drawing.Point(3, 146)
        Me.Panel40.Name = "Panel40"
        Me.Panel40.Size = New System.Drawing.Size(668, 27)
        Me.Panel40.TabIndex = 8
        '
        'OASCAHPS_EstimatedResponseRateNumericUpDown
        '
        Me.OASCAHPS_EstimatedResponseRateNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_EstimatedResponseRateNumericUpDown.DecimalPlaces = 4
        Me.OASCAHPS_EstimatedResponseRateNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.OASCAHPS_EstimatedResponseRateNumericUpDown.Location = New System.Drawing.Point(172, 5)
        Me.OASCAHPS_EstimatedResponseRateNumericUpDown.Name = "OASCAHPS_EstimatedResponseRateNumericUpDown"
        Me.OASCAHPS_EstimatedResponseRateNumericUpDown.Size = New System.Drawing.Size(493, 27)
        Me.OASCAHPS_EstimatedResponseRateNumericUpDown.TabIndex = 9
        '
        'OASCAHPS_EstimatedResponseRateLabel
        '
        Me.OASCAHPS_EstimatedResponseRateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_EstimatedResponseRateLabel.AutoSize = True
        Me.OASCAHPS_EstimatedResponseRateLabel.Location = New System.Drawing.Point(3, 8)
        Me.OASCAHPS_EstimatedResponseRateLabel.Name = "OASCAHPS_EstimatedResponseRateLabel"
        Me.OASCAHPS_EstimatedResponseRateLabel.Size = New System.Drawing.Size(208, 21)
        Me.OASCAHPS_EstimatedResponseRateLabel.TabIndex = 8
        Me.OASCAHPS_EstimatedResponseRateLabel.Text = "Estimated Response Rate:"
        '
        'Panel49
        '
        Me.Panel49.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel49.Controls.Add(Me.OASCAHPS_HistoricValuesLabel)
        Me.Panel49.Location = New System.Drawing.Point(679, 109)
        Me.Panel49.Name = "Panel49"
        Me.Panel49.Size = New System.Drawing.Size(671, 27)
        Me.Panel49.TabIndex = 7
        '
        'OASCAHPS_HistoricValuesLabel
        '
        Me.OASCAHPS_HistoricValuesLabel.AutoSize = True
        Me.OASCAHPS_HistoricValuesLabel.Location = New System.Drawing.Point(3, 14)
        Me.OASCAHPS_HistoricValuesLabel.Name = "OASCAHPS_HistoricValuesLabel"
        Me.OASCAHPS_HistoricValuesLabel.Size = New System.Drawing.Size(120, 21)
        Me.OASCAHPS_HistoricValuesLabel.TabIndex = 17
        Me.OASCAHPS_HistoricValuesLabel.Text = "Historic Values"
        '
        'Panel42
        '
        Me.Panel42.Controls.Add(Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown)
        Me.Panel42.Controls.Add(Me.OASCAHPS_EstimatedAnnualVolumeLabel)
        Me.Panel42.Location = New System.Drawing.Point(3, 109)
        Me.Panel42.Name = "Panel42"
        Me.Panel42.Size = New System.Drawing.Size(668, 27)
        Me.Panel42.TabIndex = 6
        '
        'OASCAHPS_EstimatedAnnualVolumeNumericUpDown
        '
        Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown.Location = New System.Drawing.Point(172, 3)
        Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown.Maximum = New Decimal(New Integer() {999999999, 0, 0, 0})
        Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown.Name = "OASCAHPS_EstimatedAnnualVolumeNumericUpDown"
        Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown.Size = New System.Drawing.Size(493, 27)
        Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown.TabIndex = 7
        '
        'OASCAHPS_EstimatedAnnualVolumeLabel
        '
        Me.OASCAHPS_EstimatedAnnualVolumeLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_EstimatedAnnualVolumeLabel.AutoSize = True
        Me.OASCAHPS_EstimatedAnnualVolumeLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_EstimatedAnnualVolumeLabel.Name = "OASCAHPS_EstimatedAnnualVolumeLabel"
        Me.OASCAHPS_EstimatedAnnualVolumeLabel.Size = New System.Drawing.Size(207, 21)
        Me.OASCAHPS_EstimatedAnnualVolumeLabel.TabIndex = 6
        Me.OASCAHPS_EstimatedAnnualVolumeLabel.Text = "Estimated Annual Volume:"
        '
        'Panel43
        '
        Me.Panel43.Controls.Add(Me.OASCAHPS_MedicareUnlockSamplingButton)
        Me.Panel43.Location = New System.Drawing.Point(679, 72)
        Me.Panel43.Name = "Panel43"
        Me.Panel43.Size = New System.Drawing.Size(669, 27)
        Me.Panel43.TabIndex = 5
        '
        'OASCAHPS_MedicareUnlockSamplingButton
        '
        Me.OASCAHPS_MedicareUnlockSamplingButton.Location = New System.Drawing.Point(173, 4)
        Me.OASCAHPS_MedicareUnlockSamplingButton.Name = "OASCAHPS_MedicareUnlockSamplingButton"
        Me.OASCAHPS_MedicareUnlockSamplingButton.Size = New System.Drawing.Size(113, 23)
        Me.OASCAHPS_MedicareUnlockSamplingButton.TabIndex = 1
        Me.OASCAHPS_MedicareUnlockSamplingButton.Text = "Unlock Sampling"
        Me.OASCAHPS_MedicareUnlockSamplingButton.UseVisualStyleBackColor = True
        '
        'Panel44
        '
        Me.Panel44.Controls.Add(Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker)
        Me.Panel44.Controls.Add(Me.OASCAHPS_SwtichFromEstimatedDateLabel)
        Me.Panel44.Location = New System.Drawing.Point(3, 72)
        Me.Panel44.Name = "Panel44"
        Me.Panel44.Size = New System.Drawing.Size(668, 27)
        Me.Panel44.TabIndex = 4
        '
        'OASCAHPS_SwtichFromEstimatedDateDateTimePicker
        '
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker.Location = New System.Drawing.Point(172, 4)
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker.Name = "OASCAHPS_SwtichFromEstimatedDateDateTimePicker"
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker.Size = New System.Drawing.Size(493, 27)
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker.TabIndex = 41
        Me.OASCAHPS_SwtichFromEstimatedDateDateTimePicker.Value = New Date(1900, 1, 1, 0, 0, 0, 0)
        '
        'OASCAHPS_SwtichFromEstimatedDateLabel
        '
        Me.OASCAHPS_SwtichFromEstimatedDateLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SwtichFromEstimatedDateLabel.AutoSize = True
        Me.OASCAHPS_SwtichFromEstimatedDateLabel.Location = New System.Drawing.Point(3, 4)
        Me.OASCAHPS_SwtichFromEstimatedDateLabel.Name = "OASCAHPS_SwtichFromEstimatedDateLabel"
        Me.OASCAHPS_SwtichFromEstimatedDateLabel.Size = New System.Drawing.Size(225, 21)
        Me.OASCAHPS_SwtichFromEstimatedDateLabel.TabIndex = 40
        Me.OASCAHPS_SwtichFromEstimatedDateLabel.Text = "Swtich from Estimated Date:"
        '
        'Panel45
        '
        Me.Panel45.Controls.Add(Me.OASCAHPS_SamplingLockTextBox)
        Me.Panel45.Controls.Add(Me.OASCAHPS_SampleLockLabel)
        Me.Panel45.Location = New System.Drawing.Point(679, 36)
        Me.Panel45.Name = "Panel45"
        Me.Panel45.Size = New System.Drawing.Size(669, 27)
        Me.Panel45.TabIndex = 3
        '
        'OASCAHPS_SamplingLockTextBox
        '
        Me.OASCAHPS_SamplingLockTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SamplingLockTextBox.BackColor = System.Drawing.SystemColors.Control
        Me.OASCAHPS_SamplingLockTextBox.Location = New System.Drawing.Point(173, 0)
        Me.OASCAHPS_SamplingLockTextBox.Name = "OASCAHPS_SamplingLockTextBox"
        Me.OASCAHPS_SamplingLockTextBox.ReadOnly = True
        Me.OASCAHPS_SamplingLockTextBox.Size = New System.Drawing.Size(507, 27)
        Me.OASCAHPS_SamplingLockTextBox.TabIndex = 17
        '
        'OASCAHPS_SampleLockLabel
        '
        Me.OASCAHPS_SampleLockLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_SampleLockLabel.AutoSize = True
        Me.OASCAHPS_SampleLockLabel.Location = New System.Drawing.Point(3, 6)
        Me.OASCAHPS_SampleLockLabel.Name = "OASCAHPS_SampleLockLabel"
        Me.OASCAHPS_SampleLockLabel.Size = New System.Drawing.Size(173, 21)
        Me.OASCAHPS_SampleLockLabel.TabIndex = 16
        Me.OASCAHPS_SampleLockLabel.Text = "Sampling Lock Status:"
        '
        'Panel46
        '
        Me.Panel46.Controls.Add(Me.OASCAHPS_EstimatedValuesLabel)
        Me.Panel46.Location = New System.Drawing.Point(3, 36)
        Me.Panel46.Name = "Panel46"
        Me.Panel46.Size = New System.Drawing.Size(668, 27)
        Me.Panel46.TabIndex = 2
        '
        'OASCAHPS_EstimatedValuesLabel
        '
        Me.OASCAHPS_EstimatedValuesLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_EstimatedValuesLabel.AutoSize = True
        Me.OASCAHPS_EstimatedValuesLabel.Location = New System.Drawing.Point(3, 14)
        Me.OASCAHPS_EstimatedValuesLabel.Name = "OASCAHPS_EstimatedValuesLabel"
        Me.OASCAHPS_EstimatedValuesLabel.Size = New System.Drawing.Size(139, 21)
        Me.OASCAHPS_EstimatedValuesLabel.TabIndex = 3
        Me.OASCAHPS_EstimatedValuesLabel.Text = "Estimated Values"
        '
        'Panel47
        '
        Me.Panel47.Controls.Add(Me.Label14)
        Me.Panel47.Controls.Add(Me.OASCAHPS_ChangeThresholdNumericUpDown)
        Me.Panel47.Controls.Add(Me.OASCAHPS_ChangeThresholdLabel)
        Me.Panel47.Location = New System.Drawing.Point(679, 3)
        Me.Panel47.Name = "Panel47"
        Me.Panel47.Size = New System.Drawing.Size(669, 27)
        Me.Panel47.TabIndex = 1
        '
        'Label14
        '
        Me.Label14.AutoSize = True
        Me.Label14.ForeColor = System.Drawing.Color.Red
        Me.Label14.ImageAlign = System.Drawing.ContentAlignment.TopRight
        Me.Label14.Location = New System.Drawing.Point(146, 3)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(19, 21)
        Me.Label14.TabIndex = 16
        Me.Label14.Text = "*"
        '
        'OASCAHPS_ChangeThresholdNumericUpDown
        '
        Me.OASCAHPS_ChangeThresholdNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_ChangeThresholdNumericUpDown.DecimalPlaces = 4
        Me.OASCAHPS_ChangeThresholdNumericUpDown.Increment = New Decimal(New Integer() {1, 0, 0, 262144})
        Me.OASCAHPS_ChangeThresholdNumericUpDown.Location = New System.Drawing.Point(173, 3)
        Me.OASCAHPS_ChangeThresholdNumericUpDown.Name = "OASCAHPS_ChangeThresholdNumericUpDown"
        Me.OASCAHPS_ChangeThresholdNumericUpDown.Size = New System.Drawing.Size(490, 27)
        Me.OASCAHPS_ChangeThresholdNumericUpDown.TabIndex = 15
        '
        'OASCAHPS_ChangeThresholdLabel
        '
        Me.OASCAHPS_ChangeThresholdLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_ChangeThresholdLabel.AutoSize = True
        Me.OASCAHPS_ChangeThresholdLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_ChangeThresholdLabel.Name = "OASCAHPS_ChangeThresholdLabel"
        Me.OASCAHPS_ChangeThresholdLabel.Size = New System.Drawing.Size(224, 21)
        Me.OASCAHPS_ChangeThresholdLabel.TabIndex = 14
        Me.OASCAHPS_ChangeThresholdLabel.Text = "Proportion Change Theshold:"
        '
        'Panel48
        '
        Me.Panel48.Controls.Add(Me.Label11)
        Me.Panel48.Controls.Add(Me.OASCAHPS_AnnualReturnTargetNumericUpDown)
        Me.Panel48.Controls.Add(Me.OASCAHPS_AnnualReturnTargetLabel)
        Me.Panel48.Location = New System.Drawing.Point(3, 3)
        Me.Panel48.Name = "Panel48"
        Me.Panel48.Size = New System.Drawing.Size(668, 27)
        Me.Panel48.TabIndex = 0
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.ForeColor = System.Drawing.Color.Red
        Me.Label11.ImageAlign = System.Drawing.ContentAlignment.TopRight
        Me.Label11.Location = New System.Drawing.Point(78, 5)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(19, 21)
        Me.Label11.TabIndex = 16
        Me.Label11.Text = "*"
        '
        'OASCAHPS_AnnualReturnTargetNumericUpDown
        '
        Me.OASCAHPS_AnnualReturnTargetNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_AnnualReturnTargetNumericUpDown.Location = New System.Drawing.Point(172, 3)
        Me.OASCAHPS_AnnualReturnTargetNumericUpDown.Maximum = New Decimal(New Integer() {99999, 0, 0, 0})
        Me.OASCAHPS_AnnualReturnTargetNumericUpDown.Name = "OASCAHPS_AnnualReturnTargetNumericUpDown"
        Me.OASCAHPS_AnnualReturnTargetNumericUpDown.Size = New System.Drawing.Size(493, 27)
        Me.OASCAHPS_AnnualReturnTargetNumericUpDown.TabIndex = 3
        '
        'OASCAHPS_AnnualReturnTargetLabel
        '
        Me.OASCAHPS_AnnualReturnTargetLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OASCAHPS_AnnualReturnTargetLabel.AutoSize = True
        Me.OASCAHPS_AnnualReturnTargetLabel.Location = New System.Drawing.Point(3, 5)
        Me.OASCAHPS_AnnualReturnTargetLabel.Name = "OASCAHPS_AnnualReturnTargetLabel"
        Me.OASCAHPS_AnnualReturnTargetLabel.Size = New System.Drawing.Size(121, 21)
        Me.OASCAHPS_AnnualReturnTargetLabel.TabIndex = 2
        Me.OASCAHPS_AnnualReturnTargetLabel.Text = "Annual Target:"
        '
        'CurrentTableLayoutPanel
        '
        Me.CurrentTableLayoutPanel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CurrentTableLayoutPanel.ColumnCount = 2
        Me.CurrentTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.CurrentTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.CurrentTableLayoutPanel.Controls.Add(Me.MedicareNumberPanel, 0, 0)
        Me.CurrentTableLayoutPanel.Controls.Add(Me.SampleLockPanel, 1, 0)
        Me.CurrentTableLayoutPanel.Controls.Add(Me.MedicareNamePanel, 0, 1)
        Me.CurrentTableLayoutPanel.Location = New System.Drawing.Point(11, 63)
        Me.CurrentTableLayoutPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.CurrentTableLayoutPanel.Name = "CurrentTableLayoutPanel"
        Me.CurrentTableLayoutPanel.RowCount = 2
        Me.CurrentTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 20.0!))
        Me.CurrentTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 20.0!))
        Me.CurrentTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.CurrentTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.CurrentTableLayoutPanel.Size = New System.Drawing.Size(1370, 75)
        Me.CurrentTableLayoutPanel.TabIndex = 0
        '
        'MedicareNumberPanel
        '
        Me.MedicareNumberPanel.Controls.Add(Me.MedicareNumberTextBox)
        Me.MedicareNumberPanel.Controls.Add(Me.MedicareNumberLabel)
        Me.MedicareNumberPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MedicareNumberPanel.Location = New System.Drawing.Point(0, 0)
        Me.MedicareNumberPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.MedicareNumberPanel.Name = "MedicareNumberPanel"
        Me.MedicareNumberPanel.Size = New System.Drawing.Size(685, 37)
        Me.MedicareNumberPanel.TabIndex = 0
        '
        'MedicareNumberTextBox
        '
        Me.MedicareNumberTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MedicareErrorProvider.SetIconAlignment(Me.MedicareNumberTextBox, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.MedicareNumberTextBox.Location = New System.Drawing.Point(123, 4)
        Me.MedicareNumberTextBox.Name = "MedicareNumberTextBox"
        Me.MedicareNumberTextBox.Size = New System.Drawing.Size(553, 27)
        Me.MedicareNumberTextBox.TabIndex = 1
        '
        'MedicareNumberLabel
        '
        Me.MedicareNumberLabel.AutoSize = True
        Me.MedicareNumberLabel.Location = New System.Drawing.Point(3, 7)
        Me.MedicareNumberLabel.Name = "MedicareNumberLabel"
        Me.MedicareNumberLabel.Size = New System.Drawing.Size(146, 21)
        Me.MedicareNumberLabel.TabIndex = 0
        Me.MedicareNumberLabel.Text = "Medicare Number:"
        '
        'SampleLockPanel
        '
        Me.SampleLockPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SampleLockPanel.Location = New System.Drawing.Point(685, 0)
        Me.SampleLockPanel.Margin = New System.Windows.Forms.Padding(0)
        Me.SampleLockPanel.Name = "SampleLockPanel"
        Me.SampleLockPanel.Size = New System.Drawing.Size(685, 37)
        Me.SampleLockPanel.TabIndex = 1
        '
        'MedicareNamePanel
        '
        Me.CurrentTableLayoutPanel.SetColumnSpan(Me.MedicareNamePanel, 2)
        Me.MedicareNamePanel.Controls.Add(Me.MedicareNameTextBox)
        Me.MedicareNamePanel.Controls.Add(Me.MedicareNameLabel)
        Me.MedicareNamePanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MedicareNamePanel.Location = New System.Drawing.Point(0, 37)
        Me.MedicareNamePanel.Margin = New System.Windows.Forms.Padding(0)
        Me.MedicareNamePanel.Name = "MedicareNamePanel"
        Me.MedicareNamePanel.Size = New System.Drawing.Size(1370, 38)
        Me.MedicareNamePanel.TabIndex = 2
        '
        'MedicareNameTextBox
        '
        Me.MedicareNameTextBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MedicareErrorProvider.SetIconAlignment(Me.MedicareNameTextBox, System.Windows.Forms.ErrorIconAlignment.MiddleLeft)
        Me.MedicareNameTextBox.Location = New System.Drawing.Point(123, 4)
        Me.MedicareNameTextBox.Name = "MedicareNameTextBox"
        Me.MedicareNameTextBox.Size = New System.Drawing.Size(1240, 27)
        Me.MedicareNameTextBox.TabIndex = 1
        '
        'MedicareNameLabel
        '
        Me.MedicareNameLabel.AutoSize = True
        Me.MedicareNameLabel.Location = New System.Drawing.Point(3, 7)
        Me.MedicareNameLabel.Name = "MedicareNameLabel"
        Me.MedicareNameLabel.Size = New System.Drawing.Size(131, 21)
        Me.MedicareNameLabel.TabIndex = 0
        Me.MedicareNameLabel.Text = "Medicare Name:"
        '
        'MedicareErrorProvider
        '
        Me.MedicareErrorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink
        Me.MedicareErrorProvider.ContainerControl = Me
        '
        'MedicareMngrSection
        '
        Me.Controls.Add(Me.MedicareManagementSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "MedicareMngrSection"
        Me.Size = New System.Drawing.Size(1393, 653)
        Me.MedicareManagementSectionPanel.ResumeLayout(False)
        Me.CAHPSTabControl.ResumeLayout(False)
        Me.HCAHPS.ResumeLayout(False)
        Me.HCAHPS.PerformLayout()
        Me.TableLayoutPanel1.ResumeLayout(False)
        Me.LastCalculatedPanel.ResumeLayout(False)
        Me.LastCalculatedPanel.PerformLayout()
        Me.CalculatedProportionPanel.ResumeLayout(False)
        Me.CalculatedProportionPanel.PerformLayout()
        CType(Me.CalcProportionNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SamplingLockStatusPanel.ResumeLayout(False)
        Me.SamplingLockStatusPanel.PerformLayout()
        Me.LastCalcTypePanel.ResumeLayout(False)
        Me.LastCalcTypePanel.PerformLayout()
        Me.ProportionUsedPanel.ResumeLayout(False)
        Me.ProportionUsedPanel.PerformLayout()
        CType(Me.ProportionUsedNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.NextCalcGroupBox.ResumeLayout(False)
        Me.NextCalcTableLayoutPanel.ResumeLayout(False)
        Me.HistoricPanel.ResumeLayout(False)
        Me.HistoricGroupBox.ResumeLayout(False)
        Me.HistoricGroupBox.PerformLayout()
        CType(Me.HistoricWarningPictureBox, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.HistoricResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.AnnualEligibleVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.EstimatedPanel.ResumeLayout(False)
        Me.EstimatedGroupBox.ResumeLayout(False)
        Me.EstimatedGroupBox.PerformLayout()
        CType(Me.SwitchToCalcOnDateEdit.Properties.VistaTimeProperties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SwitchToCalcOnDateEdit.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EstimatedIneligibleRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EstimatedResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EstimatedAnnualVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ChangeThresholdPanel.ResumeLayout(False)
        Me.ChangeThresholdPanel.PerformLayout()
        CType(Me.ChangeThresholdNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.AnnualReturnTargetPanel.ResumeLayout(False)
        Me.AnnualReturnTargetPanel.PerformLayout()
        CType(Me.AnnualReturnTargetNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage1.ResumeLayout(False)
        Me.TableLayoutPanel2.ResumeLayout(False)
        Me.Panel24.ResumeLayout(False)
        Me.Panel23.ResumeLayout(False)
        Me.Panel23.PerformLayout()
        Me.Panel22.ResumeLayout(False)
        Me.Panel22.PerformLayout()
        CType(Me.HHCAHPS_ProportionUsedNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel25.ResumeLayout(False)
        Me.Panel25.PerformLayout()
        Me.Panel20.ResumeLayout(False)
        Me.Panel20.PerformLayout()
        CType(Me.HHCAHPS_CalcProportionNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel18.ResumeLayout(False)
        Me.Panel18.PerformLayout()
        Me.Panel17.ResumeLayout(False)
        Me.Panel16.ResumeLayout(False)
        Me.Panel16.PerformLayout()
        Me.Panel15.ResumeLayout(False)
        Me.Panel15.PerformLayout()
        CType(Me.HHCAHPS_SamplingRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel14.ResumeLayout(False)
        Me.Panel14.PerformLayout()
        Me.Panel13.ResumeLayout(False)
        Me.Panel13.PerformLayout()
        Me.Panel12.ResumeLayout(False)
        Me.Panel12.PerformLayout()
        CType(Me.HHCAHPS_HistoricResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel11.ResumeLayout(False)
        Me.Panel11.PerformLayout()
        Me.Panel10.ResumeLayout(False)
        Me.Panel10.PerformLayout()
        CType(Me.HHCAHPS_AnnualEligibleVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel9.ResumeLayout(False)
        Me.Panel9.PerformLayout()
        CType(Me.HHCAHPS_EstimatedResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel8.ResumeLayout(False)
        Me.Panel8.PerformLayout()
        Me.Panel7.ResumeLayout(False)
        Me.Panel7.PerformLayout()
        CType(Me.HHCAHPS_EstimatedAnnualVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel6.ResumeLayout(False)
        Me.Panel5.ResumeLayout(False)
        Me.Panel5.PerformLayout()
        Me.Panel4.ResumeLayout(False)
        Me.Panel4.PerformLayout()
        Me.Panel3.ResumeLayout(False)
        Me.Panel3.PerformLayout()
        Me.Panel2.ResumeLayout(False)
        Me.Panel2.PerformLayout()
        CType(Me.HHCAHPS_ChangeThresholdNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        CType(Me.HHCAHPS_AnnualReturnTargetNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.OASCAHPS.ResumeLayout(False)
        Me.TableLayoutPanel3.ResumeLayout(False)
        Me.Panel21.ResumeLayout(False)
        Me.Panel26.ResumeLayout(False)
        Me.Panel26.PerformLayout()
        Me.Panel27.ResumeLayout(False)
        Me.Panel27.PerformLayout()
        CType(Me.OASCAHPS_ProportionUsedNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel28.ResumeLayout(False)
        Me.Panel28.PerformLayout()
        Me.Panel29.ResumeLayout(False)
        Me.Panel29.PerformLayout()
        CType(Me.OASCAHPS_CalcProportionNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel31.ResumeLayout(False)
        Me.Panel31.PerformLayout()
        Me.Panel32.ResumeLayout(False)
        Me.Panel33.ResumeLayout(False)
        Me.Panel33.PerformLayout()
        Me.Panel34.ResumeLayout(False)
        Me.Panel34.PerformLayout()
        CType(Me.OASCAHPS_SamplingRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel35.ResumeLayout(False)
        Me.Panel35.PerformLayout()
        Me.Panel36.ResumeLayout(False)
        Me.Panel36.PerformLayout()
        Me.Panel37.ResumeLayout(False)
        Me.Panel37.PerformLayout()
        CType(Me.OASCAHPS_HistoricResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel38.ResumeLayout(False)
        Me.Panel38.PerformLayout()
        Me.Panel39.ResumeLayout(False)
        Me.Panel39.PerformLayout()
        CType(Me.OASCAHPS_AnnualEligibleVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel40.ResumeLayout(False)
        Me.Panel40.PerformLayout()
        CType(Me.OASCAHPS_EstimatedResponseRateNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel49.ResumeLayout(False)
        Me.Panel49.PerformLayout()
        Me.Panel42.ResumeLayout(False)
        Me.Panel42.PerformLayout()
        CType(Me.OASCAHPS_EstimatedAnnualVolumeNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel43.ResumeLayout(False)
        Me.Panel44.ResumeLayout(False)
        Me.Panel44.PerformLayout()
        Me.Panel45.ResumeLayout(False)
        Me.Panel45.PerformLayout()
        Me.Panel46.ResumeLayout(False)
        Me.Panel46.PerformLayout()
        Me.Panel47.ResumeLayout(False)
        Me.Panel47.PerformLayout()
        CType(Me.OASCAHPS_ChangeThresholdNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel48.ResumeLayout(False)
        Me.Panel48.PerformLayout()
        CType(Me.OASCAHPS_AnnualReturnTargetNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.CurrentTableLayoutPanel.ResumeLayout(False)
        Me.MedicareNumberPanel.ResumeLayout(False)
        Me.MedicareNumberPanel.PerformLayout()
        Me.MedicareNamePanel.ResumeLayout(False)
        Me.MedicareNamePanel.PerformLayout()
        CType(Me.MedicareErrorProvider, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MedicareManagementSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents CurrentTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents MedicareNumberPanel As System.Windows.Forms.Panel
    Friend WithEvents SampleLockPanel As System.Windows.Forms.Panel
    Friend WithEvents MedicareNumberLabel As System.Windows.Forms.Label
    Friend WithEvents MedicareNameLabel As System.Windows.Forms.Label
    Friend WithEvents MedicareNumberTextBox As System.Windows.Forms.TextBox
    Friend WithEvents MedicareNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents MedicareErrorProvider As System.Windows.Forms.ErrorProvider
    Friend WithEvents MedicareNamePanel As Panel
    Friend WithEvents CAHPSTabControl As TabControl
    Friend WithEvents HCAHPS As TabPage
    Friend WithEvents MedicareCalcHistoryButton As Button
    Friend WithEvents MedicareUnlockSamplingButton As Button
    Friend WithEvents MedicareReCalcButton As Button
    Friend WithEvents NonSubmittingCheckbox As CheckBox
    Friend WithEvents TableLayoutPanel1 As TableLayoutPanel
    Friend WithEvents LastCalculatedPanel As Panel
    Friend WithEvents LastCalcDateLabel As Label
    Friend WithEvents LastCalcDateTextBox As TextBox
    Friend WithEvents CalculatedProportionPanel As Panel
    Friend WithEvents CalcProportionLabel As Label
    Friend WithEvents CalcProportionNumericUpDown As NumericUpDown
    Friend WithEvents SamplingLockStatusPanel As Panel
    Friend WithEvents SampleLockLabel As Label
    Friend WithEvents SamplingLockTextBox As TextBox
    Friend WithEvents LastCalcTypePanel As Panel
    Friend WithEvents LastCalcTypeLabel As Label
    Friend WithEvents LastCalcTypeTextBox As TextBox
    Friend WithEvents ProportionUsedPanel As Panel
    Friend WithEvents ProportionUsedLabel As Label
    Friend WithEvents ProportionUsedNumericUpDown As NumericUpDown
    Friend WithEvents InactiveCheckBox As CheckBox
    Friend WithEvents NextCalcGroupBox As GroupBox
    Friend WithEvents NextCalcTableLayoutPanel As TableLayoutPanel
    Friend WithEvents HistoricPanel As Panel
    Friend WithEvents HistoricGroupBox As GroupBox
    Friend WithEvents HistoricWarningPictureBox As PictureBox
    Friend WithEvents HistoricWarningLabel As Label
    Friend WithEvents HistoricResponseRateNumericUpDown As NumericUpDown
    Friend WithEvents AnnualEligibleVolumeNumericUpDown As NumericUpDown
    Friend WithEvents HistoricResponseRateLabel As Label
    Friend WithEvents AnnualEligibleVolumeLabel As Label
    Friend WithEvents HistoricRadioButton As RadioButton
    Friend WithEvents EstimatedPanel As Panel
    Friend WithEvents EstimatedGroupBox As GroupBox
    Friend WithEvents SwitchToCalcOnDateEdit As DevExpress.XtraEditors.DateEdit
    Friend WithEvents EstimatedRadioButton As RadioButton
    Friend WithEvents SwitchToCalcOnLabel As Label
    Friend WithEvents EstimatedIneligibleRateLabel As Label
    Friend WithEvents EstimatedIneligibleRateNumericUpDown As NumericUpDown
    Friend WithEvents EstimatedResponseRateNumericUpDown As NumericUpDown
    Friend WithEvents EstimatedResponseRateLabel As Label
    Friend WithEvents EstimatedAnnualVolumeNumericUpDown As NumericUpDown
    Friend WithEvents EstimatedAnnualVolumeLabel As Label
    Friend WithEvents ChangeThresholdPanel As Panel
    Friend WithEvents ChangeThresholdNumericUpDown As NumericUpDown
    Friend WithEvents ChangeThresholdLabel As Label
    Friend WithEvents AnnualReturnTargetPanel As Panel
    Friend WithEvents ForceCensusSampleCheckBox As CheckBox
    Friend WithEvents AnnualReturnTargetNumericUpDown As NumericUpDown
    Friend WithEvents AnnualReturnTargetLabel As Label
    Friend WithEvents TabPage1 As TabPage
    Friend WithEvents TableLayoutPanel2 As TableLayoutPanel
    Friend WithEvents Panel24 As Panel
    Friend WithEvents HHCAHPS_MedicareCalcHistoryButton As Button
    Friend WithEvents Panel23 As Panel
    Friend WithEvents HHCAHPS_NonSubmittingCheckbox As CheckBox
    Friend WithEvents Panel22 As Panel
    Friend WithEvents HHCAHPS_ProportionUsedNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPS_ProportionUsedLabel As Label
    Friend WithEvents Panel25 As Panel
    Friend WithEvents HHCAHPS_InactiveCheckBox As CheckBox
    Friend WithEvents Panel20 As Panel
    Friend WithEvents HHCAHPS_CalcProportionNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPS_CalcProportionLabel As Label
    Friend WithEvents Panel19 As Panel
    Friend WithEvents Panel18 As Panel
    Friend WithEvents HHCAHPS_LastCalcTypeTextBox As TextBox
    Friend WithEvents HHCAHPS_LastCalcTypeLabel As Label
    Friend WithEvents Panel17 As Panel
    Friend WithEvents HHCAHPS_MedicareReCalcButton As Button
    Friend WithEvents Panel16 As Panel
    Friend WithEvents HHCAHPS_LastCalcDateTextBox As TextBox
    Friend WithEvents HHCAHPS_LastCalcDateLabel As Label
    Friend WithEvents Panel15 As Panel
    Friend WithEvents HHCAHPS_SamplingRateNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPS_SamplingRateLabel As Label
    Friend WithEvents Panel14 As Panel
    Friend WithEvents HHCAHPS_LastCalculationLabel As Label
    Friend WithEvents Panel13 As Panel
    Friend WithEvents HHCAHPS_SwitchFromOverrideDateDateTimePicker As DateTimePicker
    Friend WithEvents HHCAHPS_SwitchFromOverrideDateLabel As Label
    Friend WithEvents Panel12 As Panel
    Friend WithEvents HHCAHPS_HistoricResponseRateNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPA_HistoricResponseRateLabel As Label
    Friend WithEvents Panel11 As Panel
    Friend WithEvents HHCAHPS_SamplingRateOverrideLabel As Label
    Friend WithEvents Panel10 As Panel
    Friend WithEvents HHCAHPS_AnnualEligibleVolumeNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPS_AnnualEligibleVolumeLabel As Label
    Friend WithEvents Panel8 As Panel
    Friend WithEvents HHCAHPS_HistoricValuesLabel As Label
    Friend WithEvents Panel7 As Panel
    Friend WithEvents HHCAHPS_EstimatedAnnualVolumeNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPS_EstimatedAnnualVolumeLabel As Label
    Friend WithEvents Panel6 As Panel
    Friend WithEvents HHCAHPS_MedicareUnlockSamplingButton As Button
    Friend WithEvents Panel5 As Panel
    Friend WithEvents HHCAHPS_SwtichFromEstimatedDateDateTimePicker As DateTimePicker
    Friend WithEvents HHCAHPS_SwtichFromEstimatedDateLabel As Label
    Friend WithEvents Panel4 As Panel
    Friend WithEvents HHCAHPS_SamplingLockTextBox As TextBox
    Friend WithEvents HHCAHPS_SampleLockLabel As Label
    Friend WithEvents Panel3 As Panel
    Friend WithEvents HHCAHPS_EstimatedValuesLabel As Label
    Friend WithEvents Panel2 As Panel
    Friend WithEvents HHCAHPS_ChangeThresholdNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPS_ChangeThresholdLabel As Label
    Friend WithEvents Panel1 As Panel
    Friend WithEvents HHCAHPS_AnnualReturnTargetNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPS_AnnualReturnTargetLabel As Label
    Friend WithEvents OASCAHPS As TabPage
    Friend WithEvents TableLayoutPanel3 As TableLayoutPanel
    Friend WithEvents Panel21 As Panel
    Friend WithEvents OASCAHPS_MedicareCalcHistoryButton As Button
    Friend WithEvents Panel26 As Panel
    Friend WithEvents OASCAHPS_NonSubmittingCheckbox As CheckBox
    Friend WithEvents Panel27 As Panel
    Friend WithEvents OASCAHPS_ProportionUsedNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPS_ProportionUsedLabel As Label
    Friend WithEvents Panel28 As Panel
    Friend WithEvents OASCAHPS_InactiveCheckBox As CheckBox
    Friend WithEvents Panel29 As Panel
    Friend WithEvents OASCAHPS_CalcProportionNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPS_CalcProportionLabel As Label
    Friend WithEvents Panel30 As Panel
    Friend WithEvents Panel31 As Panel
    Friend WithEvents OASCAHPS_LastCalcTypeTextBox As TextBox
    Friend WithEvents OASCAHPS_LastCalcTypeLabel As Label
    Friend WithEvents Panel32 As Panel
    Friend WithEvents OASCAHPS_MedicareReCalcButton As Button
    Friend WithEvents Panel33 As Panel
    Friend WithEvents OASCAHPS_LastCalcDateTextBox As TextBox
    Friend WithEvents OASCAHPS_LastCalcDateLabel As Label
    Friend WithEvents Panel34 As Panel
    Friend WithEvents OASCAHPS_SamplingRateNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPS_SamplingRateLabel As Label
    Friend WithEvents Panel35 As Panel
    Friend WithEvents OASCAHPS_LastCalculationLabel As Label
    Friend WithEvents Panel36 As Panel
    Friend WithEvents OASCAHPS_SwitchFromOverrideDateDateTimePicker As DateTimePicker
    Friend WithEvents OASCAHPS_SwitchFromOverrideDateLabel As Label
    Friend WithEvents Panel37 As Panel
    Friend WithEvents OASCAHPS_HistoricResponseRateNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPA_HistoricResponseRateLabel As Label
    Friend WithEvents Panel38 As Panel
    Friend WithEvents OASCAHPS_SamplingRateOverrideLabel As Label
    Friend WithEvents Panel39 As Panel
    Friend WithEvents OASCAHPS_AnnualEligibleVolumeNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPS_AnnualEligibleVolumeLabel As Label
    Friend WithEvents Panel40 As Panel
    Friend WithEvents OASCAHPS_EstimatedResponseRateNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPS_EstimatedResponseRateLabel As Label
    Friend WithEvents Panel49 As Panel
    Friend WithEvents OASCAHPS_HistoricValuesLabel As Label
    Friend WithEvents Panel42 As Panel
    Friend WithEvents OASCAHPS_EstimatedAnnualVolumeNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPS_EstimatedAnnualVolumeLabel As Label
    Friend WithEvents Panel43 As Panel
    Friend WithEvents OASCAHPS_MedicareUnlockSamplingButton As Button
    Friend WithEvents Panel44 As Panel
    Friend WithEvents OASCAHPS_SwtichFromEstimatedDateDateTimePicker As DateTimePicker
    Friend WithEvents OASCAHPS_SwtichFromEstimatedDateLabel As Label
    Friend WithEvents Panel45 As Panel
    Friend WithEvents OASCAHPS_SamplingLockTextBox As TextBox
    Friend WithEvents OASCAHPS_SampleLockLabel As Label
    Friend WithEvents Panel46 As Panel
    Friend WithEvents OASCAHPS_EstimatedValuesLabel As Label
    Friend WithEvents Panel47 As Panel
    Friend WithEvents OASCAHPS_ChangeThresholdNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPS_ChangeThresholdLabel As Label
    Friend WithEvents Panel48 As Panel
    Friend WithEvents OASCAHPS_AnnualReturnTargetNumericUpDown As NumericUpDown
    Friend WithEvents OASCAHPS_AnnualReturnTargetLabel As Label
    Friend WithEvents HCAHPS_CancelButton As Button
    Friend WithEvents HCAHPS_ApplyButton As Button
    Friend WithEvents HHCAHPS_CancelButton As Button
    Friend WithEvents HHCAHPS_ApplyButton As Button
    Friend WithEvents OASCAHPS_CancelButton As Button
    Friend WithEvents OASCAHPS_ApplyButton As Button
    Friend WithEvents Label2 As Label
    Friend WithEvents Label11 As Label
    Friend WithEvents Label13 As Label
    Friend WithEvents Label14 As Label
    Friend WithEvents Panel9 As Panel
    Friend WithEvents HHCAHPS_EstimatedResponseRateNumericUpDown As NumericUpDown
    Friend WithEvents HHCAHPS_EstimatedResponseRateLabel As Label
End Class
