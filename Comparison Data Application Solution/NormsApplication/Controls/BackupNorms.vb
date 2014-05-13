Imports NormsApplicationBusinessObjectsLibrary
Public Class BackupNorms
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents btnBackup As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents txtArchiveExtension As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnBackup = New System.Windows.Forms.Button
        Me.txtArchiveExtension = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.Label2 = New System.Windows.Forms.Label
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'btnBackup
        '
        Me.btnBackup.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnBackup.Location = New System.Drawing.Point(120, 88)
        Me.btnBackup.Name = "btnBackup"
        Me.btnBackup.Size = New System.Drawing.Size(96, 23)
        Me.btnBackup.TabIndex = 0
        Me.btnBackup.Text = "Start Backup"
        '
        'txtArchiveExtension
        '
        Me.txtArchiveExtension.Location = New System.Drawing.Point(112, 40)
        Me.txtArchiveExtension.Name = "txtArchiveExtension"
        Me.txtArchiveExtension.Size = New System.Drawing.Size(72, 20)
        Me.txtArchiveExtension.TabIndex = 1
        Me.txtArchiveExtension.Text = ""
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(8, 40)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(104, 24)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Archive Extension*"
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Backup Norms"
        Me.SectionPanel1.Controls.Add(Me.Label2)
        Me.SectionPanel1.Controls.Add(Me.Label1)
        Me.SectionPanel1.Controls.Add(Me.txtArchiveExtension)
        Me.SectionPanel1.Controls.Add(Me.btnBackup)
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(400, 120)
        Me.SectionPanel1.TabIndex = 3
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(232, 98)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(160, 16)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "* Format like Q404, Q105, etc."
        '
        'BackupNorms
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "BackupNorms"
        Me.Size = New System.Drawing.Size(440, 224)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region


    Private Function Validation() As Boolean
        Dim success As Boolean

        If txtArchiveExtension.Text.Length <> 4 Then
            'First character must be a 'Q'
        ElseIf txtArchiveExtension.Text.Substring(0, 1) <> "Q" Then
            'Second Character must be the quarter number
        ElseIf txtArchiveExtension.Text.Substring(1, 1) <> "1" AndAlso txtArchiveExtension.Text.Substring(1, 1) <> "2" AndAlso txtArchiveExtension.Text.Substring(1, 1) <> "3" AndAlso txtArchiveExtension.Text.Substring(1, 1) <> "4" Then
            'Third character is the first digit of a 2 digit year
        ElseIf Not IsNumeric(txtArchiveExtension.Text.Substring(2, 1)) Then
            'Third character is the second digit of a 2 digit year
        ElseIf Not IsNumeric(txtArchiveExtension.Text.Substring(3, 1)) Then
        Else
            success = True
        End If

        If success = False Then
            MessageBox.Show("Archive Extension must be formatted like 'Q404', 'Q105', etc.", "Error in Archive Extension", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

        Return success
    End Function

    Private Sub btnBackup_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBackup.Click
        If Validation() Then
            Try
                Cursor.Current = Cursors.WaitCursor
                DataAccess.BackupNorms(txtArchiveExtension.Text)
                Cursor.Current = Cursors.Default
                MessageBox.Show("Backup Successful", "Backup", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Catch ex As Exception
                ReportException(ex, "Error Backing Up")
            End Try
        End If
    End Sub
End Class
