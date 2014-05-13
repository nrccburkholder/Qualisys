<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SpecialUpdatesSection
    Inherits DataMart.ExportManager.Section
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
        Me.SpecialUpdatesSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.SpecialUpdatesToolStrip = New System.Windows.Forms.ToolStrip
        Me.SpecialUpdatesToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.SpecialUpdatesPanel = New System.Windows.Forms.Panel
        Me.SpecialUpdatesFileTextBox = New System.Windows.Forms.TextBox
        Me.QuarterComboBox = New System.Windows.Forms.ComboBox
        Me.YearComboBox = New System.Windows.Forms.ComboBox
        Me.ColumnToUpdateComboBox = New System.Windows.Forms.ComboBox
        Me.QuarterLabel = New System.Windows.Forms.Label
        Me.YearLabel = New System.Windows.Forms.Label
        Me.ColumnToUpdateLabel = New System.Windows.Forms.Label
        Me.LangIdLabel = New System.Windows.Forms.Label
        Me.HDispositionLabel = New System.Windows.Forms.Label
        Me.SamplePopLabel = New System.Windows.Forms.Label
        Me.SpecialUpdatesBrowseButton = New System.Windows.Forms.Button
        Me.UpdateFileLabel = New System.Windows.Forms.Label
        Me.SurveyLabel = New System.Windows.Forms.Label
        Me.OpenUpdateFileDialog = New System.Windows.Forms.OpenFileDialog
        Me.SpecialUpdatesSectionPanel.SuspendLayout()
        Me.SpecialUpdatesToolStrip.SuspendLayout()
        Me.SpecialUpdatesPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'SpecialUpdatesSectionPanel
        '
        Me.SpecialUpdatesSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SpecialUpdatesSectionPanel.Caption = "Special Updates"
        Me.SpecialUpdatesSectionPanel.Controls.Add(Me.SpecialUpdatesToolStrip)
        Me.SpecialUpdatesSectionPanel.Controls.Add(Me.SpecialUpdatesPanel)
        Me.SpecialUpdatesSectionPanel.Controls.Add(Me.SurveyLabel)
        Me.SpecialUpdatesSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SpecialUpdatesSectionPanel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SpecialUpdatesSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.SpecialUpdatesSectionPanel.Name = "SpecialUpdatesSectionPanel"
        Me.SpecialUpdatesSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.SpecialUpdatesSectionPanel.ShowCaption = True
        Me.SpecialUpdatesSectionPanel.Size = New System.Drawing.Size(935, 492)
        Me.SpecialUpdatesSectionPanel.TabIndex = 7
        '
        'SpecialUpdatesToolStrip
        '
        Me.SpecialUpdatesToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SpecialUpdatesToolStripButton})
        Me.SpecialUpdatesToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.SpecialUpdatesToolStrip.Name = "SpecialUpdatesToolStrip"
        Me.SpecialUpdatesToolStrip.Size = New System.Drawing.Size(933, 25)
        Me.SpecialUpdatesToolStrip.TabIndex = 20
        Me.SpecialUpdatesToolStrip.Text = "ToolStrip1"
        '
        'SpecialUpdatesToolStripButton
        '
        Me.SpecialUpdatesToolStripButton.Enabled = False
        Me.SpecialUpdatesToolStripButton.Image = Global.Nrc.DataMart.ExportManager.My.Resources.Resources.GoLtr
        Me.SpecialUpdatesToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SpecialUpdatesToolStripButton.Name = "SpecialUpdatesToolStripButton"
        Me.SpecialUpdatesToolStripButton.Size = New System.Drawing.Size(62, 22)
        Me.SpecialUpdatesToolStripButton.Text = "&Update"
        '
        'SpecialUpdatesPanel
        '
        Me.SpecialUpdatesPanel.Controls.Add(Me.SpecialUpdatesFileTextBox)
        Me.SpecialUpdatesPanel.Controls.Add(Me.QuarterComboBox)
        Me.SpecialUpdatesPanel.Controls.Add(Me.YearComboBox)
        Me.SpecialUpdatesPanel.Controls.Add(Me.ColumnToUpdateComboBox)
        Me.SpecialUpdatesPanel.Controls.Add(Me.QuarterLabel)
        Me.SpecialUpdatesPanel.Controls.Add(Me.YearLabel)
        Me.SpecialUpdatesPanel.Controls.Add(Me.ColumnToUpdateLabel)
        Me.SpecialUpdatesPanel.Controls.Add(Me.LangIdLabel)
        Me.SpecialUpdatesPanel.Controls.Add(Me.HDispositionLabel)
        Me.SpecialUpdatesPanel.Controls.Add(Me.SamplePopLabel)
        Me.SpecialUpdatesPanel.Controls.Add(Me.SpecialUpdatesBrowseButton)
        Me.SpecialUpdatesPanel.Controls.Add(Me.UpdateFileLabel)
        Me.SpecialUpdatesPanel.Enabled = False
        Me.SpecialUpdatesPanel.Location = New System.Drawing.Point(17, 94)
        Me.SpecialUpdatesPanel.Name = "SpecialUpdatesPanel"
        Me.SpecialUpdatesPanel.Size = New System.Drawing.Size(715, 230)
        Me.SpecialUpdatesPanel.TabIndex = 18
        '
        'SpecialUpdatesFileTextBox
        '
        Me.SpecialUpdatesFileTextBox.BackColor = System.Drawing.SystemColors.Control
        Me.SpecialUpdatesFileTextBox.Location = New System.Drawing.Point(142, 6)
        Me.SpecialUpdatesFileTextBox.Name = "SpecialUpdatesFileTextBox"
        Me.SpecialUpdatesFileTextBox.ReadOnly = True
        Me.SpecialUpdatesFileTextBox.Size = New System.Drawing.Size(330, 21)
        Me.SpecialUpdatesFileTextBox.TabIndex = 21
        '
        'QuarterComboBox
        '
        Me.QuarterComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.QuarterComboBox.FormattingEnabled = True
        Me.QuarterComboBox.Items.AddRange(New Object() {"Q1", "Q2", "Q3", "Q4"})
        Me.QuarterComboBox.Location = New System.Drawing.Point(495, 42)
        Me.QuarterComboBox.Name = "QuarterComboBox"
        Me.QuarterComboBox.Size = New System.Drawing.Size(58, 21)
        Me.QuarterComboBox.TabIndex = 20
        '
        'YearComboBox
        '
        Me.YearComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.YearComboBox.FormattingEnabled = True
        Me.YearComboBox.Items.AddRange(New Object() {"2006", "2007", "2008", "2009", "2010", "2011", "2012"})
        Me.YearComboBox.Location = New System.Drawing.Point(360, 42)
        Me.YearComboBox.Name = "YearComboBox"
        Me.YearComboBox.Size = New System.Drawing.Size(65, 21)
        Me.YearComboBox.TabIndex = 20
        '
        'ColumnToUpdateComboBox
        '
        Me.ColumnToUpdateComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ColumnToUpdateComboBox.FormattingEnabled = True
        Me.ColumnToUpdateComboBox.Location = New System.Drawing.Point(140, 42)
        Me.ColumnToUpdateComboBox.Name = "ColumnToUpdateComboBox"
        Me.ColumnToUpdateComboBox.Size = New System.Drawing.Size(167, 21)
        Me.ColumnToUpdateComboBox.TabIndex = 20
        '
        'QuarterLabel
        '
        Me.QuarterLabel.AutoSize = True
        Me.QuarterLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!)
        Me.QuarterLabel.Location = New System.Drawing.Point(435, 46)
        Me.QuarterLabel.Name = "QuarterLabel"
        Me.QuarterLabel.Size = New System.Drawing.Size(55, 16)
        Me.QuarterLabel.TabIndex = 19
        Me.QuarterLabel.Text = "Quarter:"
        '
        'YearLabel
        '
        Me.YearLabel.AutoSize = True
        Me.YearLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!)
        Me.YearLabel.Location = New System.Drawing.Point(316, 45)
        Me.YearLabel.Name = "YearLabel"
        Me.YearLabel.Size = New System.Drawing.Size(40, 16)
        Me.YearLabel.TabIndex = 19
        Me.YearLabel.Text = "Year:"
        '
        'ColumnToUpdateLabel
        '
        Me.ColumnToUpdateLabel.AutoSize = True
        Me.ColumnToUpdateLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!)
        Me.ColumnToUpdateLabel.Location = New System.Drawing.Point(10, 45)
        Me.ColumnToUpdateLabel.Name = "ColumnToUpdateLabel"
        Me.ColumnToUpdateLabel.Size = New System.Drawing.Size(124, 16)
        Me.ColumnToUpdateLabel.TabIndex = 19
        Me.ColumnToUpdateLabel.Text = "Column To Update:"
        '
        'LangIdLabel
        '
        Me.LangIdLabel.AutoSize = True
        Me.LangIdLabel.Font = New System.Drawing.Font("Arial", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LangIdLabel.ForeColor = System.Drawing.Color.Red
        Me.LangIdLabel.Location = New System.Drawing.Point(72, 189)
        Me.LangIdLabel.Name = "LangIdLabel"
        Me.LangIdLabel.Size = New System.Drawing.Size(215, 16)
        Me.LangIdLabel.TabIndex = 18
        Me.LangIdLabel.Text = "...column labeled ""langid"" not found!"
        '
        'HDispositionLabel
        '
        Me.HDispositionLabel.AutoSize = True
        Me.HDispositionLabel.Font = New System.Drawing.Font("Arial", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.HDispositionLabel.ForeColor = System.Drawing.Color.Red
        Me.HDispositionLabel.Location = New System.Drawing.Point(72, 156)
        Me.HDispositionLabel.Name = "HDispositionLabel"
        Me.HDispositionLabel.Size = New System.Drawing.Size(250, 16)
        Me.HDispositionLabel.TabIndex = 17
        Me.HDispositionLabel.Text = "...column labeled ""hdisposition"" not found!"
        '
        'SamplePopLabel
        '
        Me.SamplePopLabel.AutoSize = True
        Me.SamplePopLabel.Font = New System.Drawing.Font("Arial", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SamplePopLabel.ForeColor = System.Drawing.Color.Red
        Me.SamplePopLabel.Location = New System.Drawing.Point(72, 125)
        Me.SamplePopLabel.Name = "SamplePopLabel"
        Me.SamplePopLabel.Size = New System.Drawing.Size(261, 16)
        Me.SamplePopLabel.TabIndex = 16
        Me.SamplePopLabel.Text = "...column labeled ""samplepop_id"" not found!"
        '
        'SpecialUpdatesBrowseButton
        '
        Me.SpecialUpdatesBrowseButton.Location = New System.Drawing.Point(478, 4)
        Me.SpecialUpdatesBrowseButton.Name = "SpecialUpdatesBrowseButton"
        Me.SpecialUpdatesBrowseButton.Size = New System.Drawing.Size(75, 23)
        Me.SpecialUpdatesBrowseButton.TabIndex = 14
        Me.SpecialUpdatesBrowseButton.Text = "Browse..."
        Me.SpecialUpdatesBrowseButton.UseVisualStyleBackColor = True
        '
        'UpdateFileLabel
        '
        Me.UpdateFileLabel.AutoSize = True
        Me.UpdateFileLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.UpdateFileLabel.Location = New System.Drawing.Point(10, 8)
        Me.UpdateFileLabel.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.UpdateFileLabel.Name = "UpdateFileLabel"
        Me.UpdateFileLabel.Size = New System.Drawing.Size(131, 16)
        Me.UpdateFileLabel.TabIndex = 11
        Me.UpdateFileLabel.Text = "Choose Update File:"
        '
        'SurveyLabel
        '
        Me.SurveyLabel.AutoSize = True
        Me.SurveyLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 20.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SurveyLabel.Location = New System.Drawing.Point(11, 56)
        Me.SurveyLabel.Margin = New System.Windows.Forms.Padding(4, 0, 4, 0)
        Me.SurveyLabel.Name = "SurveyLabel"
        Me.SurveyLabel.Size = New System.Drawing.Size(336, 31)
        Me.SurveyLabel.TabIndex = 6
        Me.SurveyLabel.Text = "No Single Survey Selected"
        '
        'OpenUpdateFileDialog
        '
        Me.OpenUpdateFileDialog.Filter = "Excel File (*.xls)|*.xls"
        '
        'SpecialUpdatesSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SpecialUpdatesSectionPanel)
        Me.Name = "SpecialUpdatesSection"
        Me.Size = New System.Drawing.Size(935, 492)
        Me.SpecialUpdatesSectionPanel.ResumeLayout(False)
        Me.SpecialUpdatesSectionPanel.PerformLayout()
        Me.SpecialUpdatesToolStrip.ResumeLayout(False)
        Me.SpecialUpdatesToolStrip.PerformLayout()
        Me.SpecialUpdatesPanel.ResumeLayout(False)
        Me.SpecialUpdatesPanel.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SpecialUpdatesSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SpecialUpdatesBrowseButton As System.Windows.Forms.Button
    Friend WithEvents UpdateFileLabel As System.Windows.Forms.Label
    Friend WithEvents SurveyLabel As System.Windows.Forms.Label
    Friend WithEvents OpenUpdateFileDialog As System.Windows.Forms.OpenFileDialog
    Friend WithEvents SpecialUpdatesPanel As System.Windows.Forms.Panel
    Friend WithEvents LangIdLabel As System.Windows.Forms.Label
    Friend WithEvents HDispositionLabel As System.Windows.Forms.Label
    Friend WithEvents SamplePopLabel As System.Windows.Forms.Label
    Friend WithEvents SpecialUpdatesToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents SpecialUpdatesToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ColumnToUpdateComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents ColumnToUpdateLabel As System.Windows.Forms.Label
    Friend WithEvents SpecialUpdatesFileTextBox As System.Windows.Forms.TextBox
    Friend WithEvents YearLabel As System.Windows.Forms.Label
    Friend WithEvents QuarterComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents YearComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents QuarterLabel As System.Windows.Forms.Label

End Class
