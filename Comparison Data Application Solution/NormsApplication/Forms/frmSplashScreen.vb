Public Class frmSplashScreen
    Inherits NRC.WinForms.SplashScreen

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal autoClose As Boolean)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

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
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        CType(Me.imgSplashImage, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'lblTitle
        '
        Me.lblTitle.ForeColor = System.Drawing.SystemColors.InactiveCaptionText
        Me.lblTitle.Text = "Comparison Data Application"
        '
        'lblCopyright
        '
        Me.lblCopyright.ForeColor = System.Drawing.SystemColors.InactiveCaptionText
        '
        'imgSplashImage
        '
        Me.imgSplashImage.Image = Global.NormsApplication.My.Resources.Resources.smiley2
        Me.imgSplashImage.Location = New System.Drawing.Point(56, 27)
        Me.imgSplashImage.Size = New System.Drawing.Size(320, 320)
        '
        'lblVersion
        '
        Me.lblVersion.ForeColor = System.Drawing.SystemColors.InactiveCaptionText
        '
        'frmSplashScreen
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.SystemColors.Desktop
        Me.ClientSize = New System.Drawing.Size(432, 400)
        Me.Name = "frmSplashScreen"
        Me.Text = "frmSplashScreen"
        CType(Me.imgSplashImage, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

#End Region

    'Private WithEvents mUpdater As Microsoft.Samples.AppUpdater.AppUpdater = modMain.Updater

    'When an update has been downloaded, display a message to the user
    'Private Sub mUpdater_OnUpdateComplete(ByVal sender As Object, ByVal e As Microsoft.Samples.AppUpdater.UpdateCompleteEventArgs)
        ''if the download was successfull then ask if the user wants to restart now
        'If e.UpdateSucceeded Then
        '    MessageBox.Show("A new version of " & AppName & " is available.  " & AppName & " will automatically restart now.", "Update Detected", MessageBoxButtons.OK, MessageBoxIcon.Information)
        '    'Restart the app and close this one
        '    Updater.RestartApp()
        '    Me.Close()
        'Else
        '    'Display error message
        '    Dim ex As New Exception(e.ErrorMessage, e.FailureException)
        '    ReportException(ex, "Auto Update Error")
        '    'MessageBox.Show("Auto Update Exception: " & e.ErrorMessage, "error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        'End If
    'End Sub

    'Private Sub frmSplashScreen_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
    '    AddHandler mUpdater.OnUpdateComplete, AddressOf mUpdater_OnUpdateComplete
    '    lblVersion.Text = "Version " + Application.ProductVersion
    '    lblTitle.Text = "Web Document Manager"
    'End Sub

    'Private Sub frmSplashScreen_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
    '    RemoveHandler mUpdater.OnUpdateComplete, AddressOf mUpdater_OnUpdateComplete
    'End Sub
End Class
