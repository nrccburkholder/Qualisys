Public Class USNorms
    Inherits System.Windows.Forms.UserControl
    Public Event btnPressed(ByVal SelectedButton As USNormButtons)

    Public Enum USNormButtons
        btnCreateEditNorm = 0
        btnPopulate = 1
        btnUpdate = 2
        btnPromote = 3
        btnBackup = 4
    End Enum


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
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents btnPromote As System.Windows.Forms.Button
    Friend WithEvents btnUpate As System.Windows.Forms.Button
    Friend WithEvents btnPopulate As System.Windows.Forms.Button
    Friend WithEvents btnCreateEditNorms As System.Windows.Forms.Button
    Friend WithEvents btnBackup As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.btnBackup = New System.Windows.Forms.Button
        Me.btnPromote = New System.Windows.Forms.Button
        Me.btnUpate = New System.Windows.Forms.Button
        Me.btnPopulate = New System.Windows.Forms.Button
        Me.btnCreateEditNorms = New System.Windows.Forms.Button
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Panel1
        '
        Me.Panel1.BackColor = System.Drawing.SystemColors.Control
        Me.Panel1.Controls.Add(Me.btnBackup)
        Me.Panel1.Controls.Add(Me.btnPromote)
        Me.Panel1.Controls.Add(Me.btnUpate)
        Me.Panel1.Controls.Add(Me.btnPopulate)
        Me.Panel1.Controls.Add(Me.btnCreateEditNorms)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(152, 304)
        Me.Panel1.TabIndex = 0
        '
        'btnBackup
        '
        Me.btnBackup.Location = New System.Drawing.Point(2, 86)
        Me.btnBackup.Name = "btnBackup"
        Me.btnBackup.Size = New System.Drawing.Size(148, 38)
        Me.btnBackup.TabIndex = 6
        Me.btnBackup.Text = "Backup All Production Norms"
        '
        'btnPromote
        '
        Me.btnPromote.Location = New System.Drawing.Point(3, 236)
        Me.btnPromote.Name = "btnPromote"
        Me.btnPromote.Size = New System.Drawing.Size(148, 23)
        Me.btnPromote.TabIndex = 5
        Me.btnPromote.Text = "Promote to Production"
        '
        'btnUpate
        '
        Me.btnUpate.Location = New System.Drawing.Point(1, 142)
        Me.btnUpate.Name = "btnUpate"
        Me.btnUpate.Size = New System.Drawing.Size(148, 35)
        Me.btnUpate.TabIndex = 4
        Me.btnUpate.Text = "Update Lookup Tables and Data"
        '
        'btnPopulate
        '
        Me.btnPopulate.Location = New System.Drawing.Point(0, 195)
        Me.btnPopulate.Name = "btnPopulate"
        Me.btnPopulate.Size = New System.Drawing.Size(148, 23)
        Me.btnPopulate.TabIndex = 3
        Me.btnPopulate.Text = "Populate norm(s)"
        '
        'btnCreateEditNorms
        '
        Me.btnCreateEditNorms.Location = New System.Drawing.Point(3, 45)
        Me.btnCreateEditNorms.Name = "btnCreateEditNorms"
        Me.btnCreateEditNorms.Size = New System.Drawing.Size(148, 23)
        Me.btnCreateEditNorms.TabIndex = 1
        Me.btnCreateEditNorms.Text = "Create/Edit Norm"
        '
        'USNorms
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.Panel1)
        Me.Name = "USNorms"
        Me.Size = New System.Drawing.Size(152, 304)
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnCreateEditNorms_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCreateEditNorms.Click
        RaiseEvent btnPressed(USNormButtons.btnCreateEditNorm)
    End Sub

    Private Sub btnPopulate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPopulate.Click
        RaiseEvent btnPressed(USNormButtons.btnPopulate)
    End Sub

    Private Sub btnUpate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUpate.Click
        RaiseEvent btnPressed(USNormButtons.btnUpdate)
    End Sub

    Private Sub btnPromote_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPromote.Click
        RaiseEvent btnPressed(USNormButtons.btnPromote)
    End Sub

    Private Sub btnBackup_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBackup.Click
        RaiseEvent btnPressed(USNormButtons.btnBackup)
    End Sub
End Class
