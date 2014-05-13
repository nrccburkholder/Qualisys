<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ConfigTest
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
        Me.components = New System.ComponentModel.Container
        Me.Label1 = New System.Windows.Forms.Label
        Me.ConfigConnectionTextBox = New System.Windows.Forms.TextBox
        Me.SQLTimeoutTextBox = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.SMTPServerTextBox = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.EnvironmentNameTextBox = New System.Windows.Forms.TextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.CountryNameTextBox = New System.Windows.Forms.TextBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.QualiSysConnectionTextBox = New System.Windows.Forms.TextBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.QLoaderConnectionTextBox = New System.Windows.Forms.TextBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.DatamartConnectionTextBox = New System.Windows.Forms.TextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.NotificationConnectionTextBox = New System.Windows.Forms.TextBox
        Me.Label9 = New System.Windows.Forms.Label
        Me.EnvironmentTypeTextBox = New System.Windows.Forms.TextBox
        Me.CountryIDTextBox = New System.Windows.Forms.TextBox
        Me.NRCAuthConnectionTextBox = New System.Windows.Forms.TextBox
        Me.Label11 = New System.Windows.Forms.Label
        Me.ParamBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.Button1 = New System.Windows.Forms.Button
        Me.GridControl1 = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colParamID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colType = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colGroup = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStringValue = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIntegerValue = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateValue = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colComment = New DevExpress.XtraGrid.Columns.GridColumn
        Me.WorkflowConnectionTextBox = New System.Windows.Forms.TextBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.QueueConnectionTextBox = New System.Windows.Forms.TextBox
        Me.Label12 = New System.Windows.Forms.Label
        Me.ScanConnectionTextBox = New System.Windows.Forms.TextBox
        Me.Label13 = New System.Windows.Forms.Label
        Me.ResetButton = New System.Windows.Forms.Button
        CType(Me.ParamBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridControl1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(13, 13)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(94, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "ConfigConnection:"
        '
        'ConfigConnectionTextBox
        '
        Me.ConfigConnectionTextBox.Location = New System.Drawing.Point(133, 10)
        Me.ConfigConnectionTextBox.Name = "ConfigConnectionTextBox"
        Me.ConfigConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.ConfigConnectionTextBox.TabIndex = 1
        '
        'SQLTimeoutTextBox
        '
        Me.SQLTimeoutTextBox.Location = New System.Drawing.Point(133, 36)
        Me.SQLTimeoutTextBox.Name = "SQLTimeoutTextBox"
        Me.SQLTimeoutTextBox.Size = New System.Drawing.Size(333, 20)
        Me.SQLTimeoutTextBox.TabIndex = 3
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(13, 39)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(69, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "SQLTimeout:"
        '
        'SMTPServerTextBox
        '
        Me.SMTPServerTextBox.Location = New System.Drawing.Point(133, 62)
        Me.SMTPServerTextBox.Name = "SMTPServerTextBox"
        Me.SMTPServerTextBox.Size = New System.Drawing.Size(333, 20)
        Me.SMTPServerTextBox.TabIndex = 5
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(13, 65)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(71, 13)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "SMTPServer:"
        '
        'EnvironmentNameTextBox
        '
        Me.EnvironmentNameTextBox.Location = New System.Drawing.Point(133, 88)
        Me.EnvironmentNameTextBox.Name = "EnvironmentNameTextBox"
        Me.EnvironmentNameTextBox.Size = New System.Drawing.Size(261, 20)
        Me.EnvironmentNameTextBox.TabIndex = 7
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(13, 91)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(66, 13)
        Me.Label4.TabIndex = 6
        Me.Label4.Text = "Environment"
        '
        'CountryNameTextBox
        '
        Me.CountryNameTextBox.Location = New System.Drawing.Point(133, 114)
        Me.CountryNameTextBox.Name = "CountryNameTextBox"
        Me.CountryNameTextBox.Size = New System.Drawing.Size(261, 20)
        Me.CountryNameTextBox.TabIndex = 9
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(13, 117)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(43, 13)
        Me.Label5.TabIndex = 8
        Me.Label5.Text = "Country"
        '
        'QualiSysConnectionTextBox
        '
        Me.QualiSysConnectionTextBox.Location = New System.Drawing.Point(133, 140)
        Me.QualiSysConnectionTextBox.Name = "QualiSysConnectionTextBox"
        Me.QualiSysConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.QualiSysConnectionTextBox.TabIndex = 11
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(13, 143)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(102, 13)
        Me.Label6.TabIndex = 10
        Me.Label6.Text = "QualiSysConnection"
        '
        'QLoaderConnectionTextBox
        '
        Me.QLoaderConnectionTextBox.Location = New System.Drawing.Point(133, 166)
        Me.QLoaderConnectionTextBox.Name = "QLoaderConnectionTextBox"
        Me.QLoaderConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.QLoaderConnectionTextBox.TabIndex = 13
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(13, 169)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(102, 13)
        Me.Label7.TabIndex = 12
        Me.Label7.Text = "QLoaderConnection"
        '
        'DatamartConnectionTextBox
        '
        Me.DatamartConnectionTextBox.Location = New System.Drawing.Point(133, 192)
        Me.DatamartConnectionTextBox.Name = "DatamartConnectionTextBox"
        Me.DatamartConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.DatamartConnectionTextBox.TabIndex = 15
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(13, 195)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(104, 13)
        Me.Label8.TabIndex = 14
        Me.Label8.Text = "DatamartConnection"
        '
        'NotificationConnectionTextBox
        '
        Me.NotificationConnectionTextBox.Location = New System.Drawing.Point(133, 218)
        Me.NotificationConnectionTextBox.Name = "NotificationConnectionTextBox"
        Me.NotificationConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.NotificationConnectionTextBox.TabIndex = 17
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(13, 221)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(114, 13)
        Me.Label9.TabIndex = 16
        Me.Label9.Text = "NotificationConnection"
        '
        'EnvironmentTypeTextBox
        '
        Me.EnvironmentTypeTextBox.Location = New System.Drawing.Point(400, 88)
        Me.EnvironmentTypeTextBox.Name = "EnvironmentTypeTextBox"
        Me.EnvironmentTypeTextBox.Size = New System.Drawing.Size(66, 20)
        Me.EnvironmentTypeTextBox.TabIndex = 18
        '
        'CountryIDTextBox
        '
        Me.CountryIDTextBox.Location = New System.Drawing.Point(400, 114)
        Me.CountryIDTextBox.Name = "CountryIDTextBox"
        Me.CountryIDTextBox.Size = New System.Drawing.Size(66, 20)
        Me.CountryIDTextBox.TabIndex = 19
        '
        'NRCAuthConnectionTextBox
        '
        Me.NRCAuthConnectionTextBox.Location = New System.Drawing.Point(133, 244)
        Me.NRCAuthConnectionTextBox.Name = "NRCAuthConnectionTextBox"
        Me.NRCAuthConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.NRCAuthConnectionTextBox.TabIndex = 23
        '
        'Label11
        '
        Me.Label11.AutoSize = True
        Me.Label11.Location = New System.Drawing.Point(13, 247)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(106, 13)
        Me.Label11.TabIndex = 22
        Me.Label11.Text = "NRCAuthConnection"
        '
        'ParamBindingSource
        '
        Me.ParamBindingSource.DataSource = GetType(Nrc.Framework.BusinessLogic.Configuration.Param)
        '
        'Button1
        '
        Me.Button1.Location = New System.Drawing.Point(391, 535)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(75, 23)
        Me.Button1.TabIndex = 25
        Me.Button1.Text = "Populate"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'GridControl1
        '
        Me.GridControl1.DataSource = Me.ParamBindingSource
        Me.GridControl1.EmbeddedNavigator.Name = ""
        Me.GridControl1.Location = New System.Drawing.Point(16, 348)
        Me.GridControl1.MainView = Me.GridView1
        Me.GridControl1.Name = "GridControl1"
        Me.GridControl1.Size = New System.Drawing.Size(450, 148)
        Me.GridControl1.TabIndex = 26
        Me.GridControl1.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colParamID, Me.colName, Me.colType, Me.colGroup, Me.colStringValue, Me.colIntegerValue, Me.colDateValue, Me.colComment})
        Me.GridView1.GridControl = Me.GridControl1
        Me.GridView1.Name = "GridView1"
        '
        'colParamID
        '
        Me.colParamID.Caption = "ParamID"
        Me.colParamID.FieldName = "ParamID"
        Me.colParamID.Name = "colParamID"
        Me.colParamID.OptionsColumn.ReadOnly = True
        Me.colParamID.Visible = True
        Me.colParamID.VisibleIndex = 0
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 1
        '
        'colType
        '
        Me.colType.Caption = "Type"
        Me.colType.FieldName = "Type"
        Me.colType.Name = "colType"
        Me.colType.Visible = True
        Me.colType.VisibleIndex = 2
        '
        'colGroup
        '
        Me.colGroup.Caption = "Group"
        Me.colGroup.FieldName = "Group"
        Me.colGroup.Name = "colGroup"
        Me.colGroup.Visible = True
        Me.colGroup.VisibleIndex = 3
        '
        'colStringValue
        '
        Me.colStringValue.Caption = "StringValue"
        Me.colStringValue.FieldName = "StringValue"
        Me.colStringValue.Name = "colStringValue"
        Me.colStringValue.Visible = True
        Me.colStringValue.VisibleIndex = 4
        '
        'colIntegerValue
        '
        Me.colIntegerValue.Caption = "IntegerValue"
        Me.colIntegerValue.FieldName = "IntegerValue"
        Me.colIntegerValue.Name = "colIntegerValue"
        Me.colIntegerValue.Visible = True
        Me.colIntegerValue.VisibleIndex = 5
        '
        'colDateValue
        '
        Me.colDateValue.Caption = "DateValue"
        Me.colDateValue.FieldName = "DateValue"
        Me.colDateValue.Name = "colDateValue"
        Me.colDateValue.Visible = True
        Me.colDateValue.VisibleIndex = 6
        '
        'colComment
        '
        Me.colComment.Caption = "Comment"
        Me.colComment.FieldName = "Comment"
        Me.colComment.Name = "colComment"
        Me.colComment.Visible = True
        Me.colComment.VisibleIndex = 7
        '
        'WorkflowConnectionTextBox
        '
        Me.WorkflowConnectionTextBox.Location = New System.Drawing.Point(133, 322)
        Me.WorkflowConnectionTextBox.Name = "WorkflowConnectionTextBox"
        Me.WorkflowConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.WorkflowConnectionTextBox.TabIndex = 32
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(13, 325)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(106, 13)
        Me.Label10.TabIndex = 31
        Me.Label10.Text = "WorkflowConnection"
        '
        'QueueConnectionTextBox
        '
        Me.QueueConnectionTextBox.Location = New System.Drawing.Point(133, 296)
        Me.QueueConnectionTextBox.Name = "QueueConnectionTextBox"
        Me.QueueConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.QueueConnectionTextBox.TabIndex = 30
        '
        'Label12
        '
        Me.Label12.AutoSize = True
        Me.Label12.Location = New System.Drawing.Point(13, 299)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(93, 13)
        Me.Label12.TabIndex = 29
        Me.Label12.Text = "QueueConnection"
        '
        'ScanConnectionTextBox
        '
        Me.ScanConnectionTextBox.Location = New System.Drawing.Point(133, 270)
        Me.ScanConnectionTextBox.Name = "ScanConnectionTextBox"
        Me.ScanConnectionTextBox.Size = New System.Drawing.Size(333, 20)
        Me.ScanConnectionTextBox.TabIndex = 28
        '
        'Label13
        '
        Me.Label13.AutoSize = True
        Me.Label13.Location = New System.Drawing.Point(13, 273)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(86, 13)
        Me.Label13.TabIndex = 27
        Me.Label13.Text = "ScanConnection"
        '
        'ResetButton
        '
        Me.ResetButton.Location = New System.Drawing.Point(297, 535)
        Me.ResetButton.Name = "ResetButton"
        Me.ResetButton.Size = New System.Drawing.Size(75, 23)
        Me.ResetButton.TabIndex = 33
        Me.ResetButton.Text = "Reset"
        Me.ResetButton.UseVisualStyleBackColor = True
        '
        'ConfigTest
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(478, 573)
        Me.Controls.Add(Me.ResetButton)
        Me.Controls.Add(Me.WorkflowConnectionTextBox)
        Me.Controls.Add(Me.Label10)
        Me.Controls.Add(Me.QueueConnectionTextBox)
        Me.Controls.Add(Me.Label12)
        Me.Controls.Add(Me.ScanConnectionTextBox)
        Me.Controls.Add(Me.Label13)
        Me.Controls.Add(Me.GridControl1)
        Me.Controls.Add(Me.Button1)
        Me.Controls.Add(Me.NRCAuthConnectionTextBox)
        Me.Controls.Add(Me.Label11)
        Me.Controls.Add(Me.CountryIDTextBox)
        Me.Controls.Add(Me.EnvironmentTypeTextBox)
        Me.Controls.Add(Me.NotificationConnectionTextBox)
        Me.Controls.Add(Me.Label9)
        Me.Controls.Add(Me.DatamartConnectionTextBox)
        Me.Controls.Add(Me.Label8)
        Me.Controls.Add(Me.QLoaderConnectionTextBox)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.QualiSysConnectionTextBox)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.CountryNameTextBox)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.EnvironmentNameTextBox)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.SMTPServerTextBox)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.SQLTimeoutTextBox)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.ConfigConnectionTextBox)
        Me.Controls.Add(Me.Label1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Name = "ConfigTest"
        Me.Text = "ConfigTest"
        CType(Me.ParamBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridControl1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ConfigConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents SQLTimeoutTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents SMTPServerTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents EnvironmentNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents CountryNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents QualiSysConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents QLoaderConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents DatamartConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents NotificationConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents EnvironmentTypeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents CountryIDTextBox As System.Windows.Forms.TextBox
    Friend WithEvents NRCAuthConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents ParamBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents GridControl1 As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colParamID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colType As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colGroup As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStringValue As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIntegerValue As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateValue As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colComment As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents WorkflowConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents QueueConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents ScanConnectionTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents ResetButton As System.Windows.Forms.Button
End Class
