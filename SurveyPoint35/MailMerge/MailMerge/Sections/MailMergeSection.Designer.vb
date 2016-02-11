<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MailMergeSection
    Inherits Section

    'UserControl overrides dispose to clean up the component list.
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
        Me.components = New System.ComponentModel.Container
        Me.HeaderStrip1 = New PS.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.FolderBrowserDialog1 = New System.Windows.Forms.FolderBrowserDialog
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog
        Me.bsDataErrors = New System.Windows.Forms.BindingSource(Me.components)
        Me.bsValidationErrors = New System.Windows.Forms.BindingSource(Me.components)
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.Label11 = New System.Windows.Forms.Label
        Me.txtInstructions = New System.Windows.Forms.TextBox
        Me.txtSpecialInstructions = New System.Windows.Forms.TextBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.cmdTemplateDirectory = New System.Windows.Forms.Button
        Me.cmdSurveyDateFile = New System.Windows.Forms.Button
        Me.txtMergeName = New System.Windows.Forms.TextBox
        Me.txtTemplateDirectory = New System.Windows.Forms.TextBox
        Me.txtSurveyDataFile = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.tabValidation = New System.Windows.Forms.TabControl
        Me.tabDefault = New System.Windows.Forms.TabPage
        Me.lblDefaultMsg = New System.Windows.Forms.Label
        Me.grpDataErrors = New System.Windows.Forms.GroupBox
        Me.SplitContainer2 = New System.Windows.Forms.SplitContainer
        Me.cmdReValidate = New System.Windows.Forms.Button
        Me.cmdReMerge = New System.Windows.Forms.Button
        Me.dgErrors = New System.Windows.Forms.DataGridView
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.cmdSaveCorrected = New System.Windows.Forms.Button
        Me.cmdCorrectedFile = New System.Windows.Forms.Button
        Me.txtCorrectFile = New System.Windows.Forms.TextBox
        Me.Label9 = New System.Windows.Forms.Label
        Me.dgDataCorrections = New System.Windows.Forms.DataGridView
        Me.Label8 = New System.Windows.Forms.Label
        Me.grpInformation = New System.Windows.Forms.GroupBox
        Me.lblPreviewMerge = New System.Windows.Forms.Label
        Me.cboPreview = New System.Windows.Forms.ComboBox
        Me.cmdShowPreview = New System.Windows.Forms.Button
        Me.dgInformation = New System.Windows.Forms.DataGridView
        Me.Label5 = New System.Windows.Forms.Label
        Me.lblMessageType = New System.Windows.Forms.Label
        Me.cmdSetInstructions = New System.Windows.Forms.Button
        Me.cmdValidate = New System.Windows.Forms.Button
        Me.cmdMailMerge = New System.Windows.Forms.Button
        Me.HeaderStrip1.SuspendLayout()
        CType(Me.bsDataErrors, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsValidationErrors, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.tabValidation.SuspendLayout()
        Me.tabDefault.SuspendLayout()
        Me.grpDataErrors.SuspendLayout()
        Me.SplitContainer2.Panel1.SuspendLayout()
        Me.SplitContainer2.Panel2.SuspendLayout()
        Me.SplitContainer2.SuspendLayout()
        CType(Me.dgErrors, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgDataCorrections, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpInformation.SuspendLayout()
        CType(Me.dgInformation, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = PS.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(800, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(163, 22)
        Me.ToolStripLabel1.Text = "Survey Merge Prep"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        Me.OpenFileDialog1.Filter = "Text Files|*.txt|CSV Files|*.csv"
        '
        'FolderBrowserDialog1
        '
        Me.FolderBrowserDialog1.RootFolder = System.Environment.SpecialFolder.MyComputer
        '
        'SaveFileDialog1
        '
        Me.SaveFileDialog1.Filter = "Text Files|*.txt|CSV Files|*.csv"
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 25)
        Me.SplitContainer1.Name = "SplitContainer1"
        Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.GroupBox1)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.tabValidation)
        Me.SplitContainer1.Panel2.Controls.Add(Me.cmdSetInstructions)
        Me.SplitContainer1.Panel2.Controls.Add(Me.cmdValidate)
        Me.SplitContainer1.Panel2.Controls.Add(Me.cmdMailMerge)
        Me.SplitContainer1.Size = New System.Drawing.Size(800, 619)
        Me.SplitContainer1.SplitterDistance = 180
        Me.SplitContainer1.TabIndex = 8
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.Label11)
        Me.GroupBox1.Controls.Add(Me.txtInstructions)
        Me.GroupBox1.Controls.Add(Me.txtSpecialInstructions)
        Me.GroupBox1.Controls.Add(Me.Label10)
        Me.GroupBox1.Controls.Add(Me.cmdTemplateDirectory)
        Me.GroupBox1.Controls.Add(Me.cmdSurveyDateFile)
        Me.GroupBox1.Controls.Add(Me.txtMergeName)
        Me.GroupBox1.Controls.Add(Me.txtTemplateDirectory)
        Me.GroupBox1.Controls.Add(Me.txtSurveyDataFile)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GroupBox1.Location = New System.Drawing.Point(0, 0)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(800, 180)
        Me.GroupBox1.TabIndex = 3
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "File && Directory Settings"
        Me.GroupBox1.UseCompatibleTextRendering = True
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Location = New System.Drawing.Point(17, 101)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(64, 13)
        Me.Label11.TabIndex = 12
        Me.Label11.Text = "Instructions:"
        '
        'txtInstructions
        '
        Me.txtInstructions.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtInstructions.Location = New System.Drawing.Point(15, 117)
        Me.txtInstructions.MinimumSize = New System.Drawing.Size(5, 10)
        Me.txtInstructions.Multiline = True
        Me.txtInstructions.Name = "txtInstructions"
        Me.txtInstructions.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtInstructions.Size = New System.Drawing.Size(348, 57)
        Me.txtInstructions.TabIndex = 11
        '
        'txtSpecialInstructions
        '
        Me.txtSpecialInstructions.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtSpecialInstructions.Location = New System.Drawing.Point(377, 117)
        Me.txtSpecialInstructions.MinimumSize = New System.Drawing.Size(5, 10)
        Me.txtSpecialInstructions.Multiline = True
        Me.txtSpecialInstructions.Name = "txtSpecialInstructions"
        Me.txtSpecialInstructions.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtSpecialInstructions.Size = New System.Drawing.Size(352, 57)
        Me.txtSpecialInstructions.TabIndex = 7
        '
        'Label10
        '
        Me.Label10.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(374, 101)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(102, 13)
        Me.Label10.TabIndex = 10
        Me.Label10.Text = "Special Instructions:"
        '
        'cmdTemplateDirectory
        '
        Me.cmdTemplateDirectory.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdTemplateDirectory.Location = New System.Drawing.Point(740, 43)
        Me.cmdTemplateDirectory.Name = "cmdTemplateDirectory"
        Me.cmdTemplateDirectory.Size = New System.Drawing.Size(29, 23)
        Me.cmdTemplateDirectory.TabIndex = 4
        Me.cmdTemplateDirectory.Text = "..."
        Me.cmdTemplateDirectory.UseVisualStyleBackColor = True
        '
        'cmdSurveyDateFile
        '
        Me.cmdSurveyDateFile.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdSurveyDateFile.Location = New System.Drawing.Point(741, 19)
        Me.cmdSurveyDateFile.Name = "cmdSurveyDateFile"
        Me.cmdSurveyDateFile.Size = New System.Drawing.Size(29, 23)
        Me.cmdSurveyDateFile.TabIndex = 2
        Me.cmdSurveyDateFile.Text = "..."
        Me.cmdSurveyDateFile.UseVisualStyleBackColor = True
        '
        'txtMergeName
        '
        Me.txtMergeName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtMergeName.Location = New System.Drawing.Point(125, 71)
        Me.txtMergeName.Name = "txtMergeName"
        Me.txtMergeName.Size = New System.Drawing.Size(609, 20)
        Me.txtMergeName.TabIndex = 5
        '
        'txtTemplateDirectory
        '
        Me.txtTemplateDirectory.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtTemplateDirectory.Enabled = False
        Me.txtTemplateDirectory.Location = New System.Drawing.Point(125, 45)
        Me.txtTemplateDirectory.Name = "txtTemplateDirectory"
        Me.txtTemplateDirectory.Size = New System.Drawing.Size(609, 20)
        Me.txtTemplateDirectory.TabIndex = 3
        '
        'txtSurveyDataFile
        '
        Me.txtSurveyDataFile.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtSurveyDataFile.Enabled = False
        Me.txtSurveyDataFile.Location = New System.Drawing.Point(125, 19)
        Me.txtSurveyDataFile.Name = "txtSurveyDataFile"
        Me.txtSurveyDataFile.Size = New System.Drawing.Size(609, 20)
        Me.txtSurveyDataFile.TabIndex = 1
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(12, 74)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(71, 13)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Merge Name:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(11, 48)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(99, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Template Directory:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(11, 22)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(88, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Survey Data File:"
        '
        'tabValidation
        '
        Me.tabValidation.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabValidation.Controls.Add(Me.tabDefault)
        Me.tabValidation.Location = New System.Drawing.Point(5, 42)
        Me.tabValidation.Name = "tabValidation"
        Me.tabValidation.SelectedIndex = 0
        Me.tabValidation.Size = New System.Drawing.Size(791, 390)
        Me.tabValidation.TabIndex = 11
        '
        'tabDefault
        '
        Me.tabDefault.Controls.Add(Me.lblDefaultMsg)
        Me.tabDefault.Controls.Add(Me.grpDataErrors)
        Me.tabDefault.Controls.Add(Me.grpInformation)
        Me.tabDefault.Location = New System.Drawing.Point(4, 22)
        Me.tabDefault.Name = "tabDefault"
        Me.tabDefault.Padding = New System.Windows.Forms.Padding(3)
        Me.tabDefault.Size = New System.Drawing.Size(783, 364)
        Me.tabDefault.TabIndex = 0
        Me.tabDefault.Text = "Validation Messages"
        Me.tabDefault.UseVisualStyleBackColor = True
        '
        'lblDefaultMsg
        '
        Me.lblDefaultMsg.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblDefaultMsg.AutoSize = True
        Me.lblDefaultMsg.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblDefaultMsg.Location = New System.Drawing.Point(2, 3)
        Me.lblDefaultMsg.Name = "lblDefaultMsg"
        Me.lblDefaultMsg.Size = New System.Drawing.Size(634, 20)
        Me.lblDefaultMsg.TabIndex = 0
        Me.lblDefaultMsg.Text = "Informational and Error Messages when validating or merging will display here."
        '
        'grpDataErrors
        '
        Me.grpDataErrors.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpDataErrors.Controls.Add(Me.SplitContainer2)
        Me.grpDataErrors.Location = New System.Drawing.Point(9, 46)
        Me.grpDataErrors.Name = "grpDataErrors"
        Me.grpDataErrors.Size = New System.Drawing.Size(771, 312)
        Me.grpDataErrors.TabIndex = 2
        Me.grpDataErrors.TabStop = False
        Me.grpDataErrors.Text = "Validation Errors"
        '
        'SplitContainer2
        '
        Me.SplitContainer2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer2.Location = New System.Drawing.Point(3, 16)
        Me.SplitContainer2.Name = "SplitContainer2"
        Me.SplitContainer2.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer2.Panel1
        '
        Me.SplitContainer2.Panel1.Controls.Add(Me.cmdReValidate)
        Me.SplitContainer2.Panel1.Controls.Add(Me.cmdReMerge)
        Me.SplitContainer2.Panel1.Controls.Add(Me.dgErrors)
        Me.SplitContainer2.Panel1.Controls.Add(Me.Label7)
        Me.SplitContainer2.Panel1.Controls.Add(Me.Label6)
        Me.SplitContainer2.Panel1.Controls.Add(Me.Label4)
        '
        'SplitContainer2.Panel2
        '
        Me.SplitContainer2.Panel2.Controls.Add(Me.cmdSaveCorrected)
        Me.SplitContainer2.Panel2.Controls.Add(Me.cmdCorrectedFile)
        Me.SplitContainer2.Panel2.Controls.Add(Me.txtCorrectFile)
        Me.SplitContainer2.Panel2.Controls.Add(Me.Label9)
        Me.SplitContainer2.Panel2.Controls.Add(Me.dgDataCorrections)
        Me.SplitContainer2.Panel2.Controls.Add(Me.Label8)
        Me.SplitContainer2.Size = New System.Drawing.Size(765, 293)
        Me.SplitContainer2.SplitterDistance = 113
        Me.SplitContainer2.TabIndex = 13
        '
        'cmdReValidate
        '
        Me.cmdReValidate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdReValidate.Location = New System.Drawing.Point(598, 5)
        Me.cmdReValidate.Name = "cmdReValidate"
        Me.cmdReValidate.Size = New System.Drawing.Size(75, 23)
        Me.cmdReValidate.TabIndex = 4
        Me.cmdReValidate.Text = "Re-Validate"
        Me.cmdReValidate.UseVisualStyleBackColor = True
        '
        'cmdReMerge
        '
        Me.cmdReMerge.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdReMerge.Location = New System.Drawing.Point(679, 5)
        Me.cmdReMerge.Name = "cmdReMerge"
        Me.cmdReMerge.Size = New System.Drawing.Size(75, 23)
        Me.cmdReMerge.TabIndex = 6
        Me.cmdReMerge.Text = "Re-Merge"
        Me.cmdReMerge.UseVisualStyleBackColor = True
        '
        'dgErrors
        '
        Me.dgErrors.AllowUserToAddRows = False
        Me.dgErrors.AllowUserToDeleteRows = False
        Me.dgErrors.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgErrors.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgErrors.Location = New System.Drawing.Point(4, 47)
        Me.dgErrors.Name = "dgErrors"
        Me.dgErrors.ReadOnly = True
        Me.dgErrors.Size = New System.Drawing.Size(758, 63)
        Me.dgErrors.TabIndex = 7
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(1, 32)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(37, 13)
        Me.Label7.TabIndex = 8
        Me.Label7.Text = "Errors:"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.Location = New System.Drawing.Point(167, 22)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(419, 13)
        Me.Label6.TabIndex = 5
        Me.Label6.Text = "The seond grid will let you correct any data that was found to be invalid."
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.Location = New System.Drawing.Point(167, 8)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(398, 13)
        Me.Label4.TabIndex = 3
        Me.Label4.Text = "The 1st grid will display errors that occured while validating/merging."
        '
        'cmdSaveCorrected
        '
        Me.cmdSaveCorrected.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdSaveCorrected.Location = New System.Drawing.Point(679, 7)
        Me.cmdSaveCorrected.Name = "cmdSaveCorrected"
        Me.cmdSaveCorrected.Size = New System.Drawing.Size(75, 23)
        Me.cmdSaveCorrected.TabIndex = 12
        Me.cmdSaveCorrected.Text = "Save"
        Me.cmdSaveCorrected.UseVisualStyleBackColor = True
        '
        'cmdCorrectedFile
        '
        Me.cmdCorrectedFile.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdCorrectedFile.Location = New System.Drawing.Point(647, 7)
        Me.cmdCorrectedFile.Name = "cmdCorrectedFile"
        Me.cmdCorrectedFile.Size = New System.Drawing.Size(26, 23)
        Me.cmdCorrectedFile.TabIndex = 11
        Me.cmdCorrectedFile.Text = "..."
        Me.cmdCorrectedFile.UseVisualStyleBackColor = True
        '
        'txtCorrectFile
        '
        Me.txtCorrectFile.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtCorrectFile.Enabled = False
        Me.txtCorrectFile.Location = New System.Drawing.Point(118, 9)
        Me.txtCorrectFile.Name = "txtCorrectFile"
        Me.txtCorrectFile.Size = New System.Drawing.Size(523, 20)
        Me.txtCorrectFile.TabIndex = 10
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(9, 12)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(103, 13)
        Me.Label9.TabIndex = 14
        Me.Label9.Text = "Save Corrected File:"
        '
        'dgDataCorrections
        '
        Me.dgDataCorrections.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgDataCorrections.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgDataCorrections.Location = New System.Drawing.Point(0, 50)
        Me.dgDataCorrections.Name = "dgDataCorrections"
        Me.dgDataCorrections.Size = New System.Drawing.Size(762, 123)
        Me.dgDataCorrections.TabIndex = 13
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(1, 34)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(89, 13)
        Me.Label8.TabIndex = 9
        Me.Label8.Text = "Data Corrections:"
        '
        'grpInformation
        '
        Me.grpInformation.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpInformation.Controls.Add(Me.lblPreviewMerge)
        Me.grpInformation.Controls.Add(Me.cboPreview)
        Me.grpInformation.Controls.Add(Me.cmdShowPreview)
        Me.grpInformation.Controls.Add(Me.dgInformation)
        Me.grpInformation.Controls.Add(Me.Label5)
        Me.grpInformation.Controls.Add(Me.lblMessageType)
        Me.grpInformation.Location = New System.Drawing.Point(6, 26)
        Me.grpInformation.Name = "grpInformation"
        Me.grpInformation.Size = New System.Drawing.Size(771, 332)
        Me.grpInformation.TabIndex = 1
        Me.grpInformation.TabStop = False
        Me.grpInformation.Text = "Informational Messages"
        '
        'lblPreviewMerge
        '
        Me.lblPreviewMerge.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblPreviewMerge.AutoSize = True
        Me.lblPreviewMerge.Location = New System.Drawing.Point(290, 18)
        Me.lblPreviewMerge.Name = "lblPreviewMerge"
        Me.lblPreviewMerge.Size = New System.Drawing.Size(100, 13)
        Me.lblPreviewMerge.TabIndex = 5
        Me.lblPreviewMerge.Text = "Preview Merge File:"
        Me.lblPreviewMerge.Visible = False
        '
        'cboPreview
        '
        Me.cboPreview.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cboPreview.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboPreview.FormattingEnabled = True
        Me.cboPreview.Location = New System.Drawing.Point(396, 15)
        Me.cboPreview.Name = "cboPreview"
        Me.cboPreview.Size = New System.Drawing.Size(258, 21)
        Me.cboPreview.TabIndex = 0
        Me.cboPreview.Visible = False
        '
        'cmdShowPreview
        '
        Me.cmdShowPreview.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdShowPreview.Location = New System.Drawing.Point(660, 13)
        Me.cmdShowPreview.Name = "cmdShowPreview"
        Me.cmdShowPreview.Size = New System.Drawing.Size(105, 23)
        Me.cmdShowPreview.TabIndex = 1
        Me.cmdShowPreview.Text = "Show Preview"
        Me.cmdShowPreview.UseVisualStyleBackColor = True
        Me.cmdShowPreview.Visible = False
        '
        'dgInformation
        '
        Me.dgInformation.AllowUserToAddRows = False
        Me.dgInformation.AllowUserToDeleteRows = False
        Me.dgInformation.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgInformation.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgInformation.Location = New System.Drawing.Point(10, 58)
        Me.dgInformation.Name = "dgInformation"
        Me.dgInformation.ReadOnly = True
        Me.dgInformation.Size = New System.Drawing.Size(750, 256)
        Me.dgInformation.TabIndex = 2
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(7, 42)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(45, 13)
        Me.Label5.TabIndex = 1
        Me.Label5.Text = "Results:"
        '
        'lblMessageType
        '
        Me.lblMessageType.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblMessageType.AutoSize = True
        Me.lblMessageType.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblMessageType.Location = New System.Drawing.Point(6, 16)
        Me.lblMessageType.Name = "lblMessageType"
        Me.lblMessageType.Size = New System.Drawing.Size(237, 20)
        Me.lblMessageType.TabIndex = 0
        Me.lblMessageType.Text = "Validation/Merge Successful"
        '
        'cmdSetInstructions
        '
        Me.cmdSetInstructions.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdSetInstructions.Location = New System.Drawing.Point(494, 13)
        Me.cmdSetInstructions.Name = "cmdSetInstructions"
        Me.cmdSetInstructions.Size = New System.Drawing.Size(103, 23)
        Me.cmdSetInstructions.TabIndex = 10
        Me.cmdSetInstructions.Text = "Set Instructions"
        Me.cmdSetInstructions.UseVisualStyleBackColor = True
        '
        'cmdValidate
        '
        Me.cmdValidate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdValidate.Location = New System.Drawing.Point(603, 13)
        Me.cmdValidate.Name = "cmdValidate"
        Me.cmdValidate.Size = New System.Drawing.Size(75, 23)
        Me.cmdValidate.TabIndex = 8
        Me.cmdValidate.Text = "Validate"
        Me.cmdValidate.UseVisualStyleBackColor = True
        '
        'cmdMailMerge
        '
        Me.cmdMailMerge.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdMailMerge.Location = New System.Drawing.Point(684, 13)
        Me.cmdMailMerge.Name = "cmdMailMerge"
        Me.cmdMailMerge.Size = New System.Drawing.Size(100, 23)
        Me.cmdMailMerge.TabIndex = 9
        Me.cmdMailMerge.Text = "Merge Surveys"
        Me.cmdMailMerge.UseVisualStyleBackColor = True
        '
        'MailMergeSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SplitContainer1)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "MailMergeSection"
        Me.Size = New System.Drawing.Size(800, 644)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        CType(Me.bsDataErrors, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsValidationErrors, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.tabValidation.ResumeLayout(False)
        Me.tabDefault.ResumeLayout(False)
        Me.tabDefault.PerformLayout()
        Me.grpDataErrors.ResumeLayout(False)
        Me.SplitContainer2.Panel1.ResumeLayout(False)
        Me.SplitContainer2.Panel1.PerformLayout()
        Me.SplitContainer2.Panel2.ResumeLayout(False)
        Me.SplitContainer2.Panel2.PerformLayout()
        Me.SplitContainer2.ResumeLayout(False)
        CType(Me.dgErrors, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dgDataCorrections, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpInformation.ResumeLayout(False)
        Me.grpInformation.PerformLayout()
        CType(Me.dgInformation, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As PS.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents FolderBrowserDialog1 As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents bsDataErrors As System.Windows.Forms.BindingSource
    Friend WithEvents bsValidationErrors As System.Windows.Forms.BindingSource
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents txtInstructions As System.Windows.Forms.TextBox
    Friend WithEvents txtSpecialInstructions As System.Windows.Forms.TextBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents cmdTemplateDirectory As System.Windows.Forms.Button
    Friend WithEvents cmdSurveyDateFile As System.Windows.Forms.Button
    Friend WithEvents txtMergeName As System.Windows.Forms.TextBox
    Friend WithEvents txtTemplateDirectory As System.Windows.Forms.TextBox
    Friend WithEvents txtSurveyDataFile As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents tabValidation As System.Windows.Forms.TabControl
    Friend WithEvents tabDefault As System.Windows.Forms.TabPage
    Friend WithEvents lblDefaultMsg As System.Windows.Forms.Label
    Friend WithEvents grpDataErrors As System.Windows.Forms.GroupBox
    Friend WithEvents cmdSetInstructions As System.Windows.Forms.Button
    Friend WithEvents cmdValidate As System.Windows.Forms.Button
    Friend WithEvents cmdMailMerge As System.Windows.Forms.Button
    Friend WithEvents grpInformation As System.Windows.Forms.GroupBox
    Friend WithEvents lblPreviewMerge As System.Windows.Forms.Label
    Friend WithEvents cboPreview As System.Windows.Forms.ComboBox
    Friend WithEvents cmdShowPreview As System.Windows.Forms.Button
    Friend WithEvents dgInformation As System.Windows.Forms.DataGridView
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents lblMessageType As System.Windows.Forms.Label
    Friend WithEvents SplitContainer2 As System.Windows.Forms.SplitContainer
    Friend WithEvents cmdReValidate As System.Windows.Forms.Button
    Friend WithEvents cmdReMerge As System.Windows.Forms.Button
    Friend WithEvents dgErrors As System.Windows.Forms.DataGridView
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents cmdSaveCorrected As System.Windows.Forms.Button
    Friend WithEvents cmdCorrectedFile As System.Windows.Forms.Button
    Friend WithEvents txtCorrectFile As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents dgDataCorrections As System.Windows.Forms.DataGridView
    Friend WithEvents Label8 As System.Windows.Forms.Label

End Class
