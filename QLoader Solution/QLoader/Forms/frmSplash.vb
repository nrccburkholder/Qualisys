Option Strict Off

Imports Nrc.Framework.BusinessLogic.Configuration

Public Class frmSplash
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal autoClose As Boolean)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mAutoClose = autoClose
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
    Friend WithEvents lblVersion As System.Windows.Forms.Label
    Friend WithEvents tmrTimer As System.Windows.Forms.Timer
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents SectionHeader1 As SectionHeader
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmSplash))
        Me.lblVersion = New System.Windows.Forms.Label
        Me.tmrTimer = New System.Windows.Forms.Timer(Me.components)
        Me.PictureBox1 = New System.Windows.Forms.PictureBox
        Me.SectionHeader1 = New SectionHeader
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.SectionHeader1.SuspendLayout()
        Me.SuspendLayout()
        '
        'lblVersion
        '
        Me.lblVersion.BackColor = System.Drawing.Color.Transparent
        Me.lblVersion.Font = New System.Drawing.Font("Tahoma", 12.0!, CType((System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Italic), System.Drawing.FontStyle), System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblVersion.Location = New System.Drawing.Point(8, 232)
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Size = New System.Drawing.Size(424, 16)
        Me.lblVersion.TabIndex = 0
        Me.lblVersion.Text = "Version 1.1"
        Me.lblVersion.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'tmrTimer
        '
        '
        'PictureBox1
        '
        Me.PictureBox1.BackColor = System.Drawing.Color.Transparent
        Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
        Me.PictureBox1.Location = New System.Drawing.Point(72, 32)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(280, 200)
        Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.PictureBox1.TabIndex = 1
        Me.PictureBox1.TabStop = False
        '
        'SectionHeader1
        '
        Me.SectionHeader1.Controls.Add(Me.Label1)
        Me.SectionHeader1.Controls.Add(Me.lblVersion)
        Me.SectionHeader1.Controls.Add(Me.PictureBox1)
        Me.SectionHeader1.Controls.Add(Me.Label2)
        Me.SectionHeader1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionHeader1.Location = New System.Drawing.Point(1, 1)
        Me.SectionHeader1.Name = "SectionHeader1"
        Me.SectionHeader1.Size = New System.Drawing.Size(438, 270)
        Me.SectionHeader1.TabIndex = 2
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.Color.Transparent
        Me.Label1.Font = New System.Drawing.Font("Verdana", 18.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(0, 0)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(440, 32)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "QLoader"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.Color.Transparent
        Me.Label2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(8, 248)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(424, 16)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Copyright © 2004 - National Research Corporation "
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'frmSplash
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(440, 272)
        Me.Controls.Add(Me.SectionHeader1)
        Me.DockPadding.All = 1
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.Name = "frmSplash"
        Me.Opacity = 0.4
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "frmSplash"
        Me.SectionHeader1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mAutoClose As Boolean = False
    Private mTickCount As Integer = 0
    'Private WithEvents mUpdater As Microsoft.Samples.AppUpdater.AppUpdater = modMain.Updater

    Private Sub frmSplash_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'AddHandler mUpdater.OnUpdateComplete, AddressOf Updater_OnUpdateComplete
        Me.Label1.Text = Application.ProductName
        Me.lblVersion.Text = "Version " & Application.ProductVersion

        If Not AppConfig.EnvironmentType = Framework.BusinessLogic.Configuration.EnvironmentTypes.Production Then
            PictureBox1.Image = CreateWaterMark(PictureBox1.Image, AppConfig.EnvironmentName)
        End If

        Me.tmrTimer.Interval = 100
        Me.tmrTimer.Start()

    End Sub

    Private Sub tmrTimer_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tmrTimer.Tick

        Me.mTickCount += 1
        'Me.lblVersion.Text = Me.mTickCount
        'Me.lblVersion.Refresh()

        Select Case Me.mTickCount
            Case 1
                Me.Opacity = 0.2
            Case 2
                Me.Opacity = 0.3
            Case 3
                Me.Opacity = 0.4
            Case 4
                Me.Opacity = 0.5
            Case 5
                Me.Opacity = 0.6
            Case 6
                Me.Opacity = 0.7
            Case 7
                Me.Opacity = 0.8
            Case 8
                Me.Opacity = 0.85
            Case 9
                Me.Opacity = 0.9
            Case 10
                Me.Opacity = 0.95
            Case 11
                Me.Opacity = 1
            Case 25
                Me.tmrTimer.Stop()
                If mAutoClose Then
                    Me.Close()
                End If
        End Select

        Me.Refresh()
    End Sub

    'When an update has been downloaded, display a message to the user
    'Private Sub Updater_OnUpdateComplete(ByVal sender As System.Object, ByVal e As Microsoft.Samples.AppUpdater.UpdateCompleteEventArgs)

    '    'if the download was successfull then ask if the user wants to restart now
    '    If e.UpdateSucceeded Then
    '        MessageBox.Show("A new version of " & Application.ProductName & " is available.  " & Application.ProductName & " will automatically restart now.", "Update Detected", MessageBoxButtons.OK, MessageBoxIcon.Information)
    '        'Restart the app and close this one
    '        Updater.RestartApp()
    '        Me.Close()
    '    Else
    '        'Display error message
    '        Dim ex As New Exception(e.ErrorMessage, e.FailureException)
    '        ReportException(ex, "Auto Update Error")
    '        'MessageBox.Show("Auto Update Exception: " & e.ErrorMessage, "error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    '    End If
    'End Sub

    Private Function CreateWaterMark(ByVal img As Image, ByVal waterMarkText As String) As Bitmap
        Dim bmp As New Bitmap(img.Width, img.Height, CreateGraphics)
        Dim g As Graphics = Graphics.FromImage(bmp)
        Dim rect As New RectangleF(0, 0, img.Width, img.Height)
        Dim format As New StringFormat(StringFormatFlags.NoClip)
        Dim fontSize As Integer = 28
        Dim fnt As Font = New Font("Tahoma", fontSize, FontStyle.Bold)
        Dim brsh As Brush = Brushes.DarkRed

        format.Alignment = StringAlignment.Center
        format.LineAlignment = StringAlignment.Center

        g.DrawImage(img, 0, 0)

        Dim mtrx As New Drawing2D.Matrix
        mtrx.RotateAt(315, New PointF(img.Width / 2, img.Height / 2))
        g.Transform = mtrx

        g.DrawString(waterMarkText, fnt, brsh, rect, format)

        g.Flush()
        g.Dispose()

        Return bmp
    End Function

    'Private Sub frmSplash_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
    '    RemoveHandler mUpdater.OnUpdateComplete, AddressOf Updater_OnUpdateComplete
    'End Sub
End Class
