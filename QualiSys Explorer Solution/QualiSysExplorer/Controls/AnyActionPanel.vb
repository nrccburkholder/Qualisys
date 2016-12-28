Public Class AnyActionPanel
    Inherits ActionPanel

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
    Friend WithEvents ActionLabel As System.Windows.Forms.Label
    Friend WithEvents AnyActionButton As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ActionLabel = New System.Windows.Forms.Label()
        Me.AnyActionButton = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'ActionLabel
        '
        Me.ActionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ActionLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ActionLabel.Location = New System.Drawing.Point(8, 8)
        Me.ActionLabel.Name = "ActionLabel"
        Me.ActionLabel.Size = New System.Drawing.Size(328, 64)
        Me.ActionLabel.TabIndex = 2
        Me.ActionLabel.Text = "The selected disposition will be logged."
        '
        'AnyActionButton
        '
        Me.AnyActionButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AnyActionButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.AnyActionButton.Location = New System.Drawing.Point(232, 224)
        Me.AnyActionButton.Name = "AnyActionButton"
        Me.AnyActionButton.Size = New System.Drawing.Size(104, 23)
        Me.AnyActionButton.TabIndex = 3
        Me.AnyActionButton.Text = "OK"
        '
        'AnyActionPanel
        '
        Me.Controls.Add(Me.AnyActionButton)
        Me.Controls.Add(Me.ActionLabel)
        Me.Name = "AnyActionPanel"
        Me.Size = New System.Drawing.Size(344, 256)
        Me.ResumeLayout(False)

    End Sub

#End Region


    Private Sub AnyActionButton_Click(sender As Object, e As EventArgs) Handles AnyActionButton.Click
        If Me.Disposition.Id.Equals(35) Then 'Proxy
            Me.Mailing.LogDispositionByLitho(Me.Disposition.Id, Me.ReceiptType.Id, CurrentUser.UserName)
            MyBase.OnActionTaken(New ActionTakenEventArgs("The Selected Disposition Has Been Logged"))
        End If
    End Sub
End Class
