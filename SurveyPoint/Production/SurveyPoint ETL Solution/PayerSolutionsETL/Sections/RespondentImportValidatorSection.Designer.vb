<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class RespondentImportValidatorSection
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
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.cmdLoadFile = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.cboFileIndex = New System.Windows.Forms.ComboBox
        Me.txtRespondentFile = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.cmdGetFile = New System.Windows.Forms.Button
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.TabControl1 = New System.Windows.Forms.TabControl
        Me.TabPage1 = New System.Windows.Forms.TabPage
        Me.Label10 = New System.Windows.Forms.Label
        Me.txtResults = New System.Windows.Forms.TextBox
        Me.grdRespondentData = New DevExpress.XtraGrid.GridControl
        Me.GridView2 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.txtRespondent = New System.Windows.Forms.TextBox
        Me.txtClient = New System.Windows.Forms.TextBox
        Me.txtSurveyInstance = New System.Windows.Forms.TextBox
        Me.txtTemplate = New System.Windows.Forms.TextBox
        Me.txtScript = New System.Windows.Forms.TextBox
        Me.txtFileDef = New System.Windows.Forms.TextBox
        Me.txtSurvey = New System.Windows.Forms.TextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.TabPage2 = New System.Windows.Forms.TabPage
        Me.grdFileDef = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.TabPage3 = New System.Windows.Forms.TabPage
        Me.grdRespProperties = New DevExpress.XtraGrid.GridControl
        Me.GridView4 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.grdEventLog = New DevExpress.XtraGrid.GridControl
        Me.GridView3 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.HeaderStrip1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.TabControl1.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        CType(Me.grdRespondentData, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView2, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage2.SuspendLayout()
        CType(Me.grdFileDef, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPage3.SuspendLayout()
        CType(Me.grdRespProperties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView4, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdEventLog, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView3, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(832, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(247, 22)
        Me.ToolStripLabel1.Text = "Respondent Import Validator"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.cmdLoadFile)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.cboFileIndex)
        Me.GroupBox1.Controls.Add(Me.txtRespondentFile)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.cmdGetFile)
        Me.GroupBox1.Location = New System.Drawing.Point(3, 28)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(826, 72)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Selection Criteria"
        '
        'cmdLoadFile
        '
        Me.cmdLoadFile.Location = New System.Drawing.Point(744, 44)
        Me.cmdLoadFile.Name = "cmdLoadFile"
        Me.cmdLoadFile.Size = New System.Drawing.Size(75, 23)
        Me.cmdLoadFile.TabIndex = 5
        Me.cmdLoadFile.Text = "Load File"
        Me.cmdLoadFile.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(6, 44)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(55, 13)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "File Index:"
        '
        'cboFileIndex
        '
        Me.cboFileIndex.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboFileIndex.FormattingEnabled = True
        Me.cboFileIndex.Location = New System.Drawing.Point(145, 43)
        Me.cboFileIndex.Name = "cboFileIndex"
        Me.cboFileIndex.Size = New System.Drawing.Size(593, 21)
        Me.cboFileIndex.TabIndex = 3
        '
        'txtRespondentFile
        '
        Me.txtRespondentFile.Enabled = False
        Me.txtRespondentFile.Location = New System.Drawing.Point(145, 17)
        Me.txtRespondentFile.Name = "txtRespondentFile"
        Me.txtRespondentFile.Size = New System.Drawing.Size(642, 20)
        Me.txtRespondentFile.TabIndex = 2
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(6, 20)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(133, 13)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Enter the Respondent File:"
        '
        'cmdGetFile
        '
        Me.cmdGetFile.Location = New System.Drawing.Point(793, 15)
        Me.cmdGetFile.Name = "cmdGetFile"
        Me.cmdGetFile.Size = New System.Drawing.Size(27, 23)
        Me.cmdGetFile.TabIndex = 0
        Me.cmdGetFile.Text = "..."
        Me.cmdGetFile.UseVisualStyleBackColor = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox2.Controls.Add(Me.TabControl1)
        Me.GroupBox2.Location = New System.Drawing.Point(3, 106)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(826, 538)
        Me.GroupBox2.TabIndex = 2
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Summary Information"
        '
        'TabControl1
        '
        Me.TabControl1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TabControl1.Controls.Add(Me.TabPage1)
        Me.TabControl1.Controls.Add(Me.TabPage2)
        Me.TabControl1.Controls.Add(Me.TabPage3)
        Me.TabControl1.Location = New System.Drawing.Point(6, 19)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(813, 513)
        Me.TabControl1.TabIndex = 0
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.Label10)
        Me.TabPage1.Controls.Add(Me.txtResults)
        Me.TabPage1.Controls.Add(Me.grdRespondentData)
        Me.TabPage1.Controls.Add(Me.txtRespondent)
        Me.TabPage1.Controls.Add(Me.txtClient)
        Me.TabPage1.Controls.Add(Me.txtSurveyInstance)
        Me.TabPage1.Controls.Add(Me.txtTemplate)
        Me.TabPage1.Controls.Add(Me.txtScript)
        Me.TabPage1.Controls.Add(Me.txtFileDef)
        Me.TabPage1.Controls.Add(Me.txtSurvey)
        Me.TabPage1.Controls.Add(Me.Label4)
        Me.TabPage1.Controls.Add(Me.Label9)
        Me.TabPage1.Controls.Add(Me.Label8)
        Me.TabPage1.Controls.Add(Me.Label7)
        Me.TabPage1.Controls.Add(Me.Label6)
        Me.TabPage1.Controls.Add(Me.Label5)
        Me.TabPage1.Controls.Add(Me.Label3)
        Me.TabPage1.Location = New System.Drawing.Point(4, 22)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(805, 487)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "Base Information"
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(6, 14)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(45, 13)
        Me.Label10.TabIndex = 17
        Me.Label10.Text = "Results:"
        '
        'txtResults
        '
        Me.txtResults.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtResults.Enabled = False
        Me.txtResults.Location = New System.Drawing.Point(3, 30)
        Me.txtResults.Multiline = True
        Me.txtResults.Name = "txtResults"
        Me.txtResults.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtResults.Size = New System.Drawing.Size(799, 121)
        Me.txtResults.TabIndex = 16
        '
        'grdRespondentData
        '
        Me.grdRespondentData.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdRespondentData.EmbeddedNavigator.Name = ""
        Me.grdRespondentData.Location = New System.Drawing.Point(6, 343)
        Me.grdRespondentData.MainView = Me.GridView2
        Me.grdRespondentData.Name = "grdRespondentData"
        Me.grdRespondentData.Size = New System.Drawing.Size(793, 138)
        Me.grdRespondentData.TabIndex = 15
        Me.grdRespondentData.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView2})
        '
        'GridView2
        '
        Me.GridView2.GridControl = Me.grdRespondentData
        Me.GridView2.Name = "GridView2"
        Me.GridView2.OptionsBehavior.Editable = False
        Me.GridView2.OptionsCustomization.AllowColumnMoving = False
        Me.GridView2.OptionsCustomization.AllowFilter = False
        Me.GridView2.OptionsCustomization.AllowGroup = False
        Me.GridView2.OptionsFilter.AllowColumnMRUFilterList = False
        Me.GridView2.OptionsFilter.AllowFilterEditor = False
        Me.GridView2.OptionsFilter.AllowMRUFilterList = False
        Me.GridView2.OptionsView.ShowGroupPanel = False
        '
        'txtRespondent
        '
        Me.txtRespondent.Enabled = False
        Me.txtRespondent.Location = New System.Drawing.Point(116, 307)
        Me.txtRespondent.Name = "txtRespondent"
        Me.txtRespondent.Size = New System.Drawing.Size(674, 20)
        Me.txtRespondent.TabIndex = 14
        '
        'txtClient
        '
        Me.txtClient.Enabled = False
        Me.txtClient.Location = New System.Drawing.Point(116, 181)
        Me.txtClient.Name = "txtClient"
        Me.txtClient.Size = New System.Drawing.Size(674, 20)
        Me.txtClient.TabIndex = 13
        '
        'txtSurveyInstance
        '
        Me.txtSurveyInstance.Enabled = False
        Me.txtSurveyInstance.Location = New System.Drawing.Point(116, 207)
        Me.txtSurveyInstance.Name = "txtSurveyInstance"
        Me.txtSurveyInstance.Size = New System.Drawing.Size(674, 20)
        Me.txtSurveyInstance.TabIndex = 12
        '
        'txtTemplate
        '
        Me.txtTemplate.Enabled = False
        Me.txtTemplate.Location = New System.Drawing.Point(116, 230)
        Me.txtTemplate.Name = "txtTemplate"
        Me.txtTemplate.Size = New System.Drawing.Size(674, 20)
        Me.txtTemplate.TabIndex = 11
        '
        'txtScript
        '
        Me.txtScript.Enabled = False
        Me.txtScript.Location = New System.Drawing.Point(116, 256)
        Me.txtScript.Name = "txtScript"
        Me.txtScript.Size = New System.Drawing.Size(674, 20)
        Me.txtScript.TabIndex = 10
        '
        'txtFileDef
        '
        Me.txtFileDef.Enabled = False
        Me.txtFileDef.Location = New System.Drawing.Point(116, 281)
        Me.txtFileDef.Name = "txtFileDef"
        Me.txtFileDef.Size = New System.Drawing.Size(674, 20)
        Me.txtFileDef.TabIndex = 9
        '
        'txtSurvey
        '
        Me.txtSurvey.Enabled = False
        Me.txtSurvey.Location = New System.Drawing.Point(116, 157)
        Me.txtSurvey.Name = "txtSurvey"
        Me.txtSurvey.Size = New System.Drawing.Size(674, 20)
        Me.txtSurvey.TabIndex = 8
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(6, 310)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(68, 13)
        Me.Label4.TabIndex = 7
        Me.Label4.Text = "Respondent:"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(6, 184)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(36, 13)
        Me.Label9.TabIndex = 6
        Me.Label9.Text = "Client:"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(6, 284)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(46, 13)
        Me.Label8.TabIndex = 5
        Me.Label8.Text = "File Def:"
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(6, 259)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(37, 13)
        Me.Label7.TabIndex = 4
        Me.Label7.Text = "Script:"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(6, 207)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(87, 13)
        Me.Label6.TabIndex = 3
        Me.Label6.Text = "Survey Instance:"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(6, 233)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(57, 13)
        Me.Label5.TabIndex = 2
        Me.Label5.Text = "Template: "
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(6, 157)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(46, 13)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "Survey: "
        '
        'TabPage2
        '
        Me.TabPage2.Controls.Add(Me.grdFileDef)
        Me.TabPage2.Location = New System.Drawing.Point(4, 22)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(805, 487)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "File Def Information"
        Me.TabPage2.UseVisualStyleBackColor = True
        '
        'grdFileDef
        '
        Me.grdFileDef.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdFileDef.EmbeddedNavigator.Name = ""
        Me.grdFileDef.Location = New System.Drawing.Point(6, 6)
        Me.grdFileDef.MainView = Me.GridView1
        Me.grdFileDef.Name = "grdFileDef"
        Me.grdFileDef.Size = New System.Drawing.Size(793, 475)
        Me.grdFileDef.TabIndex = 0
        Me.grdFileDef.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.GridControl = Me.grdFileDef
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsBehavior.Editable = False
        Me.GridView1.OptionsCustomization.AllowColumnMoving = False
        Me.GridView1.OptionsCustomization.AllowFilter = False
        Me.GridView1.OptionsCustomization.AllowGroup = False
        Me.GridView1.OptionsFilter.AllowFilterEditor = False
        Me.GridView1.OptionsView.ShowGroupPanel = False
        '
        'TabPage3
        '
        Me.TabPage3.Controls.Add(Me.grdRespProperties)
        Me.TabPage3.Controls.Add(Me.grdEventLog)
        Me.TabPage3.Location = New System.Drawing.Point(4, 22)
        Me.TabPage3.Name = "TabPage3"
        Me.TabPage3.Size = New System.Drawing.Size(805, 487)
        Me.TabPage3.TabIndex = 2
        Me.TabPage3.Text = "Respondent Information"
        Me.TabPage3.UseVisualStyleBackColor = True
        '
        'grdRespProperties
        '
        Me.grdRespProperties.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdRespProperties.EmbeddedNavigator.Name = ""
        Me.grdRespProperties.Location = New System.Drawing.Point(3, 209)
        Me.grdRespProperties.MainView = Me.GridView4
        Me.grdRespProperties.Name = "grdRespProperties"
        Me.grdRespProperties.Size = New System.Drawing.Size(799, 275)
        Me.grdRespProperties.TabIndex = 1
        Me.grdRespProperties.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView4})
        '
        'GridView4
        '
        Me.GridView4.GridControl = Me.grdRespProperties
        Me.GridView4.Name = "GridView4"
        Me.GridView4.OptionsBehavior.Editable = False
        Me.GridView4.OptionsCustomization.AllowColumnMoving = False
        Me.GridView4.OptionsCustomization.AllowFilter = False
        Me.GridView4.OptionsCustomization.AllowGroup = False
        Me.GridView4.OptionsFilter.AllowColumnMRUFilterList = False
        Me.GridView4.OptionsFilter.AllowFilterEditor = False
        Me.GridView4.OptionsFilter.AllowMRUFilterList = False
        Me.GridView4.OptionsView.ShowGroupPanel = False
        '
        'grdEventLog
        '
        Me.grdEventLog.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdEventLog.EmbeddedNavigator.Name = ""
        Me.grdEventLog.Location = New System.Drawing.Point(3, 3)
        Me.grdEventLog.MainView = Me.GridView3
        Me.grdEventLog.Name = "grdEventLog"
        Me.grdEventLog.Size = New System.Drawing.Size(799, 200)
        Me.grdEventLog.TabIndex = 0
        Me.grdEventLog.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView3})
        '
        'GridView3
        '
        Me.GridView3.GridControl = Me.grdEventLog
        Me.GridView3.Name = "GridView3"
        Me.GridView3.OptionsBehavior.Editable = False
        Me.GridView3.OptionsCustomization.AllowColumnMoving = False
        Me.GridView3.OptionsCustomization.AllowFilter = False
        Me.GridView3.OptionsCustomization.AllowGroup = False
        Me.GridView3.OptionsFilter.AllowColumnMRUFilterList = False
        Me.GridView3.OptionsFilter.AllowFilterEditor = False
        Me.GridView3.OptionsFilter.AllowMRUFilterList = False
        Me.GridView3.OptionsView.ShowGroupPanel = False
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'RespondentImportValidatorSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "RespondentImportValidatorSection"
        Me.Size = New System.Drawing.Size(832, 647)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.TabControl1.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.TabPage1.PerformLayout()
        CType(Me.grdRespondentData, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView2, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage2.ResumeLayout(False)
        CType(Me.grdFileDef, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPage3.ResumeLayout(False)
        CType(Me.grdRespProperties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView4, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdEventLog, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView3, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents cboFileIndex As System.Windows.Forms.ComboBox
    Friend WithEvents txtRespondentFile As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents cmdGetFile As System.Windows.Forms.Button
    Friend WithEvents cmdLoadFile As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents TabControl1 As System.Windows.Forms.TabControl
    Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage3 As System.Windows.Forms.TabPage
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents txtRespondent As System.Windows.Forms.TextBox
    Friend WithEvents txtClient As System.Windows.Forms.TextBox
    Friend WithEvents txtSurveyInstance As System.Windows.Forms.TextBox
    Friend WithEvents txtTemplate As System.Windows.Forms.TextBox
    Friend WithEvents txtScript As System.Windows.Forms.TextBox
    Friend WithEvents txtFileDef As System.Windows.Forms.TextBox
    Friend WithEvents txtSurvey As System.Windows.Forms.TextBox
    Friend WithEvents grdFileDef As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents grdRespondentData As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView2 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents grdEventLog As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView3 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents grdRespProperties As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView4 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents txtResults As System.Windows.Forms.TextBox

End Class
