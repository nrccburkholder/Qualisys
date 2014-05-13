Public Class frmUserSettings
    Inherits Nrc.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New()
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
    Friend WithEvents pgdProps As System.Windows.Forms.PropertyGrid
    Friend WithEvents btnOK As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.pgdProps = New System.Windows.Forms.PropertyGrid
        Me.btnOK = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "User Settings"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(398, 26)
        '
        'pgdProps
        '
        Me.pgdProps.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pgdProps.CommandsVisibleIfAvailable = True
        Me.pgdProps.LargeButtons = False
        Me.pgdProps.LineColor = System.Drawing.SystemColors.ScrollBar
        Me.pgdProps.Location = New System.Drawing.Point(16, 40)
        Me.pgdProps.Name = "pgdProps"
        Me.pgdProps.Size = New System.Drawing.Size(372, 340)
        Me.pgdProps.TabIndex = 1
        Me.pgdProps.Text = "User Settings"
        Me.pgdProps.ViewBackColor = System.Drawing.SystemColors.Window
        Me.pgdProps.ViewForeColor = System.Drawing.SystemColors.WindowText
        '
        'btnOK
        '
        Me.btnOK.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Location = New System.Drawing.Point(152, 404)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 2
        Me.btnOK.Text = "OK"
        '
        'frmUserSettings
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.Caption = "User Settings"
        Me.ClientSize = New System.Drawing.Size(400, 448)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.pgdProps)
        Me.DockPadding.All = 1
        Me.Name = "frmUserSettings"
        Me.Text = "User Settings"
        Me.Controls.SetChildIndex(Me.pgdProps, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mSettings As UserSettings = Settings

    Private Sub frmUserSettings_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        pgdProps.SelectedObject = mSettings
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        mSettings.Serialize()
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub
End Class
