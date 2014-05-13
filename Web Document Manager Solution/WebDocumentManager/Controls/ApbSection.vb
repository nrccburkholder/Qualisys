Public Class ApbSection
    Inherits System.Windows.Forms.UserControl

    Public Event btnPressed(ByVal SelectedButton As ApbButtons)

    Public Enum ApbButtons
        Post = 1
        Rollback = 2
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
    Friend WithEvents btnApbPost As System.Windows.Forms.Button
    Friend WithEvents btnApbRollback As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.btnApbRollback = New System.Windows.Forms.Button
        Me.btnApbPost = New System.Windows.Forms.Button
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Panel1
        '
        Me.Panel1.BackColor = System.Drawing.SystemColors.Control
        Me.Panel1.Controls.Add(Me.btnApbRollback)
        Me.Panel1.Controls.Add(Me.btnApbPost)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(152, 304)
        Me.Panel1.TabIndex = 0
        '
        'btnApbRollback
        '
        Me.btnApbRollback.Location = New System.Drawing.Point(32, 64)
        Me.btnApbRollback.Name = "btnApbRollback"
        Me.btnApbRollback.Size = New System.Drawing.Size(96, 23)
        Me.btnApbRollback.TabIndex = 1
        Me.btnApbRollback.Text = "APB Rollback"
        '
        'btnApbPost
        '
        Me.btnApbPost.Location = New System.Drawing.Point(32, 24)
        Me.btnApbPost.Name = "btnApbPost"
        Me.btnApbPost.Size = New System.Drawing.Size(96, 23)
        Me.btnApbPost.TabIndex = 0
        Me.btnApbPost.Text = "APB Post"
        '
        'ApbSection
        '
        Me.Controls.Add(Me.Panel1)
        Me.Name = "ApbSection"
        Me.Size = New System.Drawing.Size(152, 304)
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnApbPost_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApbPost.Click
        RaiseEvent btnPressed(ApbButtons.Post)
    End Sub

    Private Sub btnApbRollback_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApbRollback.Click
        RaiseEvent btnPressed(ApbButtons.Rollback)
    End Sub

End Class
