<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ScheduleForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
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
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ScheduleForm))
        Me.txtTime = New System.Windows.Forms.TextBox
        Me.btnAdd = New System.Windows.Forms.Button
        Me.ddlStatus = New System.Windows.Forms.ComboBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.cbxSunday = New System.Windows.Forms.CheckBox
        Me.rbDaily = New System.Windows.Forms.RadioButton
        Me.rbWeekdays = New System.Windows.Forms.RadioButton
        Me.rbWeekEnds = New System.Windows.Forms.RadioButton
        Me.rbOther = New System.Windows.Forms.RadioButton
        Me.cbxMonday = New System.Windows.Forms.CheckBox
        Me.cbxTuesday = New System.Windows.Forms.CheckBox
        Me.cbxWednesday = New System.Windows.Forms.CheckBox
        Me.cbxThursday = New System.Windows.Forms.CheckBox
        Me.cbxFriday = New System.Windows.Forms.CheckBox
        Me.cbxSaturday = New System.Windows.Forms.CheckBox
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.lbxEvents = New System.Windows.Forms.ListView
        Me.colFreq = New System.Windows.Forms.ColumnHeader
        Me.colTime = New System.Windows.Forms.ColumnHeader
        Me.colStatus = New System.Windows.Forms.ColumnHeader
        Me.EventsMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.DeleteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.Label2 = New System.Windows.Forms.Label
        Me.ddlTime = New System.Windows.Forms.ComboBox
        Me.GroupBox1.SuspendLayout()
        Me.EventsMenu.SuspendLayout()
        Me.SuspendLayout()
        '
        'txtTime
        '
        Me.txtTime.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.txtTime.Location = New System.Drawing.Point(362, 18)
        Me.txtTime.Name = "txtTime"
        Me.txtTime.Size = New System.Drawing.Size(53, 20)
        Me.txtTime.TabIndex = 20
        Me.txtTime.Text = "1:00 PM"
        '
        'btnAdd
        '
        Me.btnAdd.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnAdd.Location = New System.Drawing.Point(418, 90)
        Me.btnAdd.Name = "btnAdd"
        Me.btnAdd.Size = New System.Drawing.Size(75, 23)
        Me.btnAdd.TabIndex = 19
        Me.btnAdd.Text = "Add"
        '
        'ddlStatus
        '
        Me.ddlStatus.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ddlStatus.Location = New System.Drawing.Point(362, 50)
        Me.ddlStatus.Name = "ddlStatus"
        Me.ddlStatus.Size = New System.Drawing.Size(128, 21)
        Me.ddlStatus.TabIndex = 18
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(322, 18)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(40, 23)
        Me.Label1.TabIndex = 17
        Me.Label1.Text = "Time:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.cbxSunday)
        Me.GroupBox1.Controls.Add(Me.rbDaily)
        Me.GroupBox1.Controls.Add(Me.rbWeekdays)
        Me.GroupBox1.Controls.Add(Me.rbWeekEnds)
        Me.GroupBox1.Controls.Add(Me.rbOther)
        Me.GroupBox1.Controls.Add(Me.cbxMonday)
        Me.GroupBox1.Controls.Add(Me.cbxTuesday)
        Me.GroupBox1.Controls.Add(Me.cbxWednesday)
        Me.GroupBox1.Controls.Add(Me.cbxThursday)
        Me.GroupBox1.Controls.Add(Me.cbxFriday)
        Me.GroupBox1.Controls.Add(Me.cbxSaturday)
        Me.GroupBox1.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.GroupBox1.Location = New System.Drawing.Point(18, 10)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(280, 128)
        Me.GroupBox1.TabIndex = 15
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Frequency"
        '
        'cbxSunday
        '
        Me.cbxSunday.Location = New System.Drawing.Point(104, 24)
        Me.cbxSunday.Name = "cbxSunday"
        Me.cbxSunday.Size = New System.Drawing.Size(64, 24)
        Me.cbxSunday.TabIndex = 1
        Me.cbxSunday.Text = "Sunday"
        '
        'rbDaily
        '
        Me.rbDaily.Checked = True
        Me.rbDaily.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.rbDaily.Location = New System.Drawing.Point(16, 24)
        Me.rbDaily.Name = "rbDaily"
        Me.rbDaily.Size = New System.Drawing.Size(80, 24)
        Me.rbDaily.TabIndex = 0
        Me.rbDaily.TabStop = True
        Me.rbDaily.Text = "Every day"
        '
        'rbWeekdays
        '
        Me.rbWeekdays.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.rbWeekdays.Location = New System.Drawing.Point(16, 48)
        Me.rbWeekdays.Name = "rbWeekdays"
        Me.rbWeekdays.Size = New System.Drawing.Size(80, 24)
        Me.rbWeekdays.TabIndex = 0
        Me.rbWeekdays.Text = "Weekdays"
        '
        'rbWeekEnds
        '
        Me.rbWeekEnds.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.rbWeekEnds.Location = New System.Drawing.Point(16, 72)
        Me.rbWeekEnds.Name = "rbWeekEnds"
        Me.rbWeekEnds.Size = New System.Drawing.Size(80, 24)
        Me.rbWeekEnds.TabIndex = 0
        Me.rbWeekEnds.Text = "Weekends"
        '
        'rbOther
        '
        Me.rbOther.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.rbOther.Location = New System.Drawing.Point(16, 96)
        Me.rbOther.Name = "rbOther"
        Me.rbOther.Size = New System.Drawing.Size(80, 24)
        Me.rbOther.TabIndex = 0
        Me.rbOther.Text = "Other"
        '
        'cbxMonday
        '
        Me.cbxMonday.Location = New System.Drawing.Point(104, 48)
        Me.cbxMonday.Name = "cbxMonday"
        Me.cbxMonday.Size = New System.Drawing.Size(64, 24)
        Me.cbxMonday.TabIndex = 1
        Me.cbxMonday.Text = "Monday"
        '
        'cbxTuesday
        '
        Me.cbxTuesday.Location = New System.Drawing.Point(104, 72)
        Me.cbxTuesday.Name = "cbxTuesday"
        Me.cbxTuesday.Size = New System.Drawing.Size(72, 24)
        Me.cbxTuesday.TabIndex = 1
        Me.cbxTuesday.Text = "Tuesday"
        '
        'cbxWednesday
        '
        Me.cbxWednesday.Location = New System.Drawing.Point(104, 96)
        Me.cbxWednesday.Name = "cbxWednesday"
        Me.cbxWednesday.Size = New System.Drawing.Size(88, 24)
        Me.cbxWednesday.TabIndex = 1
        Me.cbxWednesday.Text = "Wednesday"
        '
        'cbxThursday
        '
        Me.cbxThursday.Location = New System.Drawing.Point(192, 24)
        Me.cbxThursday.Name = "cbxThursday"
        Me.cbxThursday.Size = New System.Drawing.Size(72, 24)
        Me.cbxThursday.TabIndex = 1
        Me.cbxThursday.Text = "Thursday"
        '
        'cbxFriday
        '
        Me.cbxFriday.Location = New System.Drawing.Point(192, 48)
        Me.cbxFriday.Name = "cbxFriday"
        Me.cbxFriday.Size = New System.Drawing.Size(72, 24)
        Me.cbxFriday.TabIndex = 1
        Me.cbxFriday.Text = "Friday"
        '
        'cbxSaturday
        '
        Me.cbxSaturday.Location = New System.Drawing.Point(192, 72)
        Me.cbxSaturday.Name = "cbxSaturday"
        Me.cbxSaturday.Size = New System.Drawing.Size(72, 24)
        Me.cbxSaturday.TabIndex = 1
        Me.cbxSaturday.Text = "Saturday"
        '
        'btnCancel
        '
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Location = New System.Drawing.Point(186, 402)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 14
        Me.btnCancel.Text = "Cancel"
        '
        'btnOK
        '
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Location = New System.Drawing.Point(98, 402)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(75, 23)
        Me.btnOK.TabIndex = 13
        Me.btnOK.Text = "OK"
        '
        'lbxEvents
        '
        Me.lbxEvents.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colFreq, Me.colTime, Me.colStatus})
        Me.lbxEvents.ContextMenuStrip = Me.EventsMenu
        Me.lbxEvents.FullRowSelect = True
        Me.lbxEvents.GridLines = True
        Me.lbxEvents.Location = New System.Drawing.Point(10, 154)
        Me.lbxEvents.Name = "lbxEvents"
        Me.lbxEvents.Size = New System.Drawing.Size(336, 232)
        Me.lbxEvents.TabIndex = 12
        Me.lbxEvents.UseCompatibleStateImageBehavior = False
        Me.lbxEvents.View = System.Windows.Forms.View.Details
        '
        'colFreq
        '
        Me.colFreq.Text = "Frequency"
        Me.colFreq.Width = 102
        '
        'colTime
        '
        Me.colTime.Text = "Time"
        Me.colTime.Width = 76
        '
        'colStatus
        '
        Me.colStatus.Text = "Status"
        Me.colStatus.Width = 152
        '
        'EventsMenu
        '
        Me.EventsMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DeleteToolStripMenuItem})
        Me.EventsMenu.Name = "EventsMenu"
        Me.EventsMenu.Size = New System.Drawing.Size(106, 26)
        '
        'DeleteToolStripMenuItem
        '
        Me.DeleteToolStripMenuItem.Name = "DeleteToolStripMenuItem"
        Me.DeleteToolStripMenuItem.Size = New System.Drawing.Size(105, 22)
        Me.DeleteToolStripMenuItem.Text = "Delete"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(322, 50)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(40, 23)
        Me.Label2.TabIndex = 16
        Me.Label2.Text = "Status:"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ddlTime
        '
        Me.ddlTime.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ddlTime.Items.AddRange(New Object() {"12:00 AM", "12:30 AM", "1:00 AM", "1:30 AM", "2:00 AM", "2:30 AM", "3:00 AM", "3:30 AM", "4:00 AM", "4:30 AM", "5:00 AM", "5:30 AM", "6:00 AM", "6:30 AM", "7:00 AM", "7:30 AM", "8:00 AM", "8:30 AM", "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM", "4:00 PM", "4:30 PM", "5:00 PM", "5:30 PM", "6:00 PM", "6:30 PM", "7:00 PM", "7:30 PM", "8:00 PM", "8:30 PM", "9:00 PM", "9:30 PM", "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM"})
        Me.ddlTime.Location = New System.Drawing.Point(362, 18)
        Me.ddlTime.Name = "ddlTime"
        Me.ddlTime.Size = New System.Drawing.Size(72, 21)
        Me.ddlTime.TabIndex = 21
        Me.ddlTime.TabStop = False
        '
        'ScheduleForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(506, 434)
        Me.Controls.Add(Me.txtTime)
        Me.Controls.Add(Me.btnAdd)
        Me.Controls.Add(Me.ddlStatus)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.lbxEvents)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.ddlTime)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "ScheduleForm"
        Me.Text = "InOut Schedule"
        Me.GroupBox1.ResumeLayout(False)
        Me.EventsMenu.ResumeLayout(False)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents txtTime As System.Windows.Forms.TextBox
    Friend WithEvents btnAdd As System.Windows.Forms.Button
    Friend WithEvents ddlStatus As System.Windows.Forms.ComboBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents cbxSunday As System.Windows.Forms.CheckBox
    Friend WithEvents rbDaily As System.Windows.Forms.RadioButton
    Friend WithEvents rbWeekdays As System.Windows.Forms.RadioButton
    Friend WithEvents rbWeekEnds As System.Windows.Forms.RadioButton
    Friend WithEvents rbOther As System.Windows.Forms.RadioButton
    Friend WithEvents cbxMonday As System.Windows.Forms.CheckBox
    Friend WithEvents cbxTuesday As System.Windows.Forms.CheckBox
    Friend WithEvents cbxWednesday As System.Windows.Forms.CheckBox
    Friend WithEvents cbxThursday As System.Windows.Forms.CheckBox
    Friend WithEvents cbxFriday As System.Windows.Forms.CheckBox
    Friend WithEvents cbxSaturday As System.Windows.Forms.CheckBox
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents lbxEvents As System.Windows.Forms.ListView
    Friend WithEvents colFreq As System.Windows.Forms.ColumnHeader
    Friend WithEvents colTime As System.Windows.Forms.ColumnHeader
    Friend WithEvents colStatus As System.Windows.Forms.ColumnHeader
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents ddlTime As System.Windows.Forms.ComboBox
    Friend WithEvents EventsMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents DeleteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
End Class
