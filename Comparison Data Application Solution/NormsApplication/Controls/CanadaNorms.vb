Public Class CanadaNorms
    Inherits System.Windows.Forms.UserControl
    Public Event btnPressed(ByVal SelectedButton As CanadaNormButtons)

    Public Enum CanadaNormButtons
        SetupNorm = 1
        ScheduleNorm = 2
        NormQueue = 3
        SetupRollup = 4
        BenchmarkPerformer = 5
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
    Friend WithEvents btnNormQueue As System.Windows.Forms.Button
    Friend WithEvents btnSetupNorm As System.Windows.Forms.Button
    Friend WithEvents btnSchedule As System.Windows.Forms.Button
    Friend WithEvents btnRollup As System.Windows.Forms.Button
    Friend WithEvents pnlBack As System.Windows.Forms.Panel
    Friend WithEvents btnBenchmarkPerformer As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnSetupNorm = New System.Windows.Forms.Button
        Me.btnNormQueue = New System.Windows.Forms.Button
        Me.pnlBack = New System.Windows.Forms.Panel
        Me.btnBenchmarkPerformer = New System.Windows.Forms.Button
        Me.btnRollup = New System.Windows.Forms.Button
        Me.btnSchedule = New System.Windows.Forms.Button
        Me.pnlBack.SuspendLayout()
        Me.SuspendLayout()
        '
        'btnSetupNorm
        '
        Me.btnSetupNorm.Location = New System.Drawing.Point(8, 24)
        Me.btnSetupNorm.Name = "btnSetupNorm"
        Me.btnSetupNorm.Size = New System.Drawing.Size(136, 23)
        Me.btnSetupNorm.TabIndex = 0
        Me.btnSetupNorm.Text = "&Create/Edit Norm"
        '
        'btnNormQueue
        '
        Me.btnNormQueue.Location = New System.Drawing.Point(8, 104)
        Me.btnNormQueue.Name = "btnNormQueue"
        Me.btnNormQueue.Size = New System.Drawing.Size(136, 23)
        Me.btnNormQueue.TabIndex = 2
        Me.btnNormQueue.Text = "Check &Queue"
        '
        'pnlBack
        '
        Me.pnlBack.BackColor = System.Drawing.SystemColors.Control
        Me.pnlBack.Controls.Add(Me.btnBenchmarkPerformer)
        Me.pnlBack.Controls.Add(Me.btnRollup)
        Me.pnlBack.Controls.Add(Me.btnSchedule)
        Me.pnlBack.Controls.Add(Me.btnSetupNorm)
        Me.pnlBack.Controls.Add(Me.btnNormQueue)
        Me.pnlBack.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlBack.Location = New System.Drawing.Point(0, 0)
        Me.pnlBack.Name = "pnlBack"
        Me.pnlBack.Size = New System.Drawing.Size(152, 304)
        Me.pnlBack.TabIndex = 3
        '
        'btnBenchmarkPerformer
        '
        Me.btnBenchmarkPerformer.Location = New System.Drawing.Point(8, 184)
        Me.btnBenchmarkPerformer.Name = "btnBenchmarkPerformer"
        Me.btnBenchmarkPerformer.Size = New System.Drawing.Size(136, 23)
        Me.btnBenchmarkPerformer.TabIndex = 5
        Me.btnBenchmarkPerformer.Text = "Benchmark Performer"
        '
        'btnRollup
        '
        Me.btnRollup.Location = New System.Drawing.Point(8, 144)
        Me.btnRollup.Name = "btnRollup"
        Me.btnRollup.Size = New System.Drawing.Size(136, 23)
        Me.btnRollup.TabIndex = 4
        Me.btnRollup.Text = "Create/&Edit Rollup"
        '
        'btnSchedule
        '
        Me.btnSchedule.Location = New System.Drawing.Point(8, 64)
        Me.btnSchedule.Name = "btnSchedule"
        Me.btnSchedule.Size = New System.Drawing.Size(136, 23)
        Me.btnSchedule.TabIndex = 3
        Me.btnSchedule.Text = "&Schedule Update"
        '
        'CanadaNorms
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.pnlBack)
        Me.Name = "CanadaNorms"
        Me.Size = New System.Drawing.Size(152, 304)
        Me.pnlBack.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnSetupNorm_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSetupNorm.Click
        RaiseEvent btnPressed(CanadaNormButtons.SetupNorm)
    End Sub

    Private Sub btnSchedule_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSchedule.Click
        RaiseEvent btnPressed(CanadaNormButtons.ScheduleNorm)
    End Sub

    Private Sub btnNormQueue_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNormQueue.Click
        RaiseEvent btnPressed(CanadaNormButtons.NormQueue)
    End Sub

    Private Sub btnRollup_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRollup.Click
        RaiseEvent btnPressed(CanadaNormButtons.SetupRollup)
    End Sub

    Private Sub btnBenchmarkPerformer_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBenchmarkPerformer.Click
        RaiseEvent btnPressed(CanadaNormButtons.BenchmarkPerformer)
    End Sub

    Private Sub pnlBack_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles pnlBack.SizeChanged
        Dim control As Control
        For Each control In pnlBack.Controls
            If (control.GetType Is GetType(Button)) Then
                control.Left = (pnlBack.Width - control.Width) \ 2
            End If
        Next
    End Sub

End Class
