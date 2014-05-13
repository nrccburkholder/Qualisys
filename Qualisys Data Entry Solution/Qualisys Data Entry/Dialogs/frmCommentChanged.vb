Public Class frmCommentChanged
    Inherits Nrc.Framework.WinForms.DialogForm


#Region " Windows Form Designer generated code "

    Private mScreenShot As Bitmap

    Public Sub New(ByVal caption As String, ByVal message As String, ByVal screenShot As Bitmap)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Me.Caption = caption
        Me.lblMessage.Text = message
        Me.mScreenShot = screenShot
    End Sub

    'Form overrides dispose to clean up the component list.
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
    Friend WithEvents lblMessage As System.Windows.Forms.Label
    Friend WithEvents btnYes As System.Windows.Forms.Button
    Friend WithEvents btnNo As System.Windows.Forms.Button
    Friend WithEvents btnCapture As System.Windows.Forms.LinkLabel
    Friend WithEvents imgWarning As System.Windows.Forms.PictureBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmCommentChanged))
        Me.lblMessage = New System.Windows.Forms.Label
        Me.btnYes = New System.Windows.Forms.Button
        Me.btnNo = New System.Windows.Forms.Button
        Me.btnCapture = New System.Windows.Forms.LinkLabel
        Me.imgWarning = New System.Windows.Forms.PictureBox
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Verification Warning"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(438, 26)
        '
        'lblMessage
        '
        Me.lblMessage.Location = New System.Drawing.Point(56, 40)
        Me.lblMessage.Name = "lblMessage"
        Me.lblMessage.Size = New System.Drawing.Size(368, 48)
        Me.lblMessage.TabIndex = 10
        '
        'btnYes
        '
        Me.btnYes.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnYes.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnYes.Location = New System.Drawing.Point(56, 96)
        Me.btnYes.Name = "btnYes"
        Me.btnYes.TabIndex = 2
        Me.btnYes.Text = "Yes"
        '
        'btnNo
        '
        Me.btnNo.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnNo.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnNo.Location = New System.Drawing.Point(144, 96)
        Me.btnNo.Name = "btnNo"
        Me.btnNo.TabIndex = 1
        Me.btnNo.Text = "No"
        '
        'btnCapture
        '
        Me.btnCapture.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCapture.Location = New System.Drawing.Point(304, 96)
        Me.btnCapture.Name = "btnCapture"
        Me.btnCapture.Size = New System.Drawing.Size(120, 23)
        Me.btnCapture.TabIndex = 3
        Me.btnCapture.TabStop = True
        Me.btnCapture.Text = "Capture Screen Image"
        '
        'imgWarning
        '
        Me.imgWarning.Image = CType(resources.GetObject("imgWarning.Image"), System.Drawing.Image)
        Me.imgWarning.Location = New System.Drawing.Point(16, 40)
        Me.imgWarning.Name = "imgWarning"
        Me.imgWarning.Size = New System.Drawing.Size(32, 32)
        Me.imgWarning.TabIndex = 4
        Me.imgWarning.TabStop = False
        '
        'frmCommentChanged
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.Caption = "Verification Warning"
        Me.ClientSize = New System.Drawing.Size(440, 136)
        Me.Controls.Add(Me.imgWarning)
        Me.Controls.Add(Me.btnCapture)
        Me.Controls.Add(Me.btnYes)
        Me.Controls.Add(Me.lblMessage)
        Me.Controls.Add(Me.btnNo)
        Me.DockPadding.All = 1
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "frmCommentChanged"
        Me.Text = "frmCommentChanged"
        Me.Controls.SetChildIndex(Me.btnNo, 0)
        Me.Controls.SetChildIndex(Me.lblMessage, 0)
        Me.Controls.SetChildIndex(Me.btnYes, 0)
        Me.Controls.SetChildIndex(Me.btnCapture, 0)
        Me.Controls.SetChildIndex(Me.imgWarning, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnYes_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnYes.Click
        Me.DialogResult = Windows.Forms.DialogResult.Yes
    End Sub

    Private Sub btnNo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNo.Click
        Me.DialogResult = Windows.Forms.DialogResult.No
    End Sub

    Private Sub btnCapture_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnCapture.LinkClicked
        Clipboard.SetDataObject(mScreenShot, True)
        btnCapture.Enabled = False
    End Sub

    Private Sub frmCommentChanged_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        btnNo.Focus()
    End Sub
End Class
