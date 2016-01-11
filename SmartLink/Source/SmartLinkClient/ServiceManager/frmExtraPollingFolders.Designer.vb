<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmExtraPollingFolders
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
        Me.lstExtraPollingFolders = New System.Windows.Forms.ListBox
        Me.cmdAdd = New System.Windows.Forms.Button
        Me.cmdRemove = New System.Windows.Forms.Button
        Me.cmdEdit = New System.Windows.Forms.Button
        Me.fbdFolderBrowserDialog = New System.Windows.Forms.FolderBrowserDialog
        Me.cmdCancel = New System.Windows.Forms.Button
        Me.cmdOK = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'lstExtraPollingFolders
        '
        Me.lstExtraPollingFolders.FormattingEnabled = True
        Me.lstExtraPollingFolders.Location = New System.Drawing.Point(12, 17)
        Me.lstExtraPollingFolders.Name = "lstExtraPollingFolders"
        Me.lstExtraPollingFolders.Size = New System.Drawing.Size(311, 160)
        Me.lstExtraPollingFolders.TabIndex = 0
        '
        'cmdAdd
        '
        Me.cmdAdd.Location = New System.Drawing.Point(329, 17)
        Me.cmdAdd.Name = "cmdAdd"
        Me.cmdAdd.Size = New System.Drawing.Size(75, 23)
        Me.cmdAdd.TabIndex = 1
        Me.cmdAdd.Text = "&Add"
        Me.cmdAdd.UseVisualStyleBackColor = True
        '
        'cmdRemove
        '
        Me.cmdRemove.Location = New System.Drawing.Point(329, 75)
        Me.cmdRemove.Name = "cmdRemove"
        Me.cmdRemove.Size = New System.Drawing.Size(75, 23)
        Me.cmdRemove.TabIndex = 2
        Me.cmdRemove.Text = "&Remove"
        Me.cmdRemove.UseVisualStyleBackColor = True
        '
        'cmdEdit
        '
        Me.cmdEdit.Location = New System.Drawing.Point(329, 46)
        Me.cmdEdit.Name = "cmdEdit"
        Me.cmdEdit.Size = New System.Drawing.Size(75, 23)
        Me.cmdEdit.TabIndex = 3
        Me.cmdEdit.Text = "&Edit"
        Me.cmdEdit.UseVisualStyleBackColor = True
        '
        'cmdCancel
        '
        Me.cmdCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.cmdCancel.Location = New System.Drawing.Point(83, 184)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.Size = New System.Drawing.Size(75, 23)
        Me.cmdCancel.TabIndex = 8
        Me.cmdCancel.Text = "Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'cmdOK
        '
        Me.cmdOK.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.cmdOK.Location = New System.Drawing.Point(180, 184)
        Me.cmdOK.Name = "cmdOK"
        Me.cmdOK.Size = New System.Drawing.Size(77, 23)
        Me.cmdOK.TabIndex = 7
        Me.cmdOK.Text = "OK"
        Me.cmdOK.UseVisualStyleBackColor = True
        '
        'frmExtraPollingFolders
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(415, 219)
        Me.Controls.Add(Me.cmdCancel)
        Me.Controls.Add(Me.cmdOK)
        Me.Controls.Add(Me.cmdEdit)
        Me.Controls.Add(Me.cmdRemove)
        Me.Controls.Add(Me.cmdAdd)
        Me.Controls.Add(Me.lstExtraPollingFolders)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Name = "frmExtraPollingFolders"
        Me.Text = "Extra Polling Folders"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents lstExtraPollingFolders As System.Windows.Forms.ListBox
    Friend WithEvents cmdAdd As System.Windows.Forms.Button
    Friend WithEvents cmdRemove As System.Windows.Forms.Button
    Friend WithEvents cmdEdit As System.Windows.Forms.Button
    Friend WithEvents fbdFolderBrowserDialog As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents cmdCancel As System.Windows.Forms.Button
    Friend WithEvents cmdOK As System.Windows.Forms.Button
End Class
