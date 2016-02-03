<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportFileSection
    Inherits Nrc.SurveyPointUtilities.Section

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
        Me.Label3 = New System.Windows.Forms.Label()
        Me.BtnExport = New System.Windows.Forms.Button()
        Me.CmbDate = New System.Windows.Forms.ComboBox()
        Me.LstViewClients = New System.Windows.Forms.ListView()
        Me.ColumnHeader1 = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Label6 = New System.Windows.Forms.Label()
        Me.BtnClear = New System.Windows.Forms.Button()
        Me.CmbConfiguration = New System.Windows.Forms.ComboBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(28, 112)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(38, 13)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "Clients"
        '
        'BtnExport
        '
        Me.BtnExport.Location = New System.Drawing.Point(223, 393)
        Me.BtnExport.Name = "BtnExport"
        Me.BtnExport.Size = New System.Drawing.Size(75, 23)
        Me.BtnExport.TabIndex = 8
        Me.BtnExport.Text = "Export"
        Me.BtnExport.UseVisualStyleBackColor = True
        '
        'CmbDate
        '
        Me.CmbDate.FormatString = "d"
        Me.CmbDate.FormattingEnabled = True
        Me.CmbDate.Location = New System.Drawing.Point(31, 75)
        Me.CmbDate.MaxLength = 10
        Me.CmbDate.Name = "CmbDate"
        Me.CmbDate.Size = New System.Drawing.Size(213, 21)
        Me.CmbDate.TabIndex = 9
        '
        'LstViewClients
        '
        Me.LstViewClients.CheckBoxes = True
        Me.LstViewClients.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader1})
        Me.LstViewClients.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.None
        Me.LstViewClients.Location = New System.Drawing.Point(29, 128)
        Me.LstViewClients.Name = "LstViewClients"
        Me.LstViewClients.Size = New System.Drawing.Size(369, 257)
        Me.LstViewClients.TabIndex = 10
        Me.LstViewClients.UseCompatibleStateImageBehavior = False
        Me.LstViewClients.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Width = 350
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(28, 59)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(30, 13)
        Me.Label6.TabIndex = 14
        Me.Label6.Text = "Date"
        '
        'BtnClear
        '
        Me.BtnClear.Location = New System.Drawing.Point(323, 393)
        Me.BtnClear.Name = "BtnClear"
        Me.BtnClear.Size = New System.Drawing.Size(75, 23)
        Me.BtnClear.TabIndex = 15
        Me.BtnClear.Text = "Clear"
        Me.BtnClear.UseVisualStyleBackColor = True
        '
        'CmbConfiguration
        '
        Me.CmbConfiguration.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.CmbConfiguration.FormattingEnabled = True
        Me.CmbConfiguration.Location = New System.Drawing.Point(29, 24)
        Me.CmbConfiguration.Name = "CmbConfiguration"
        Me.CmbConfiguration.Size = New System.Drawing.Size(215, 21)
        Me.CmbConfiguration.TabIndex = 16
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(29, 5)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(69, 13)
        Me.Label1.TabIndex = 17
        Me.Label1.Text = "Configuration"
        '
        'ExportFileSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.CmbConfiguration)
        Me.Controls.Add(Me.BtnClear)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.LstViewClients)
        Me.Controls.Add(Me.CmbDate)
        Me.Controls.Add(Me.BtnExport)
        Me.Controls.Add(Me.Label3)
        Me.Name = "ExportFileSection"
        Me.Size = New System.Drawing.Size(439, 429)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents BtnExport As System.Windows.Forms.Button
    Friend WithEvents CmbDate As System.Windows.Forms.ComboBox
    Friend WithEvents LstViewClients As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents BtnClear As System.Windows.Forms.Button
    Friend WithEvents CmbConfiguration As System.Windows.Forms.ComboBox
    Friend WithEvents Label1 As System.Windows.Forms.Label

End Class
