Public Class MassPosterSection
    Inherits System.Windows.Forms.UserControl
    Public Enum PressedButton
        OpenSpreadsheet = 1
        RollbackBatches = 2
    End Enum

    Public Event btnPressed(ByVal button As PressedButton)

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
    Friend WithEvents RollBackBatchesButton As System.Windows.Forms.Button

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents OpenSpreadSheetButton As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.OpenSpreadSheetButton = New System.Windows.Forms.Button
        Me.RollBackBatchesButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'OpenSpreadSheetButton
        '
        Me.OpenSpreadSheetButton.Location = New System.Drawing.Point(24, 80)
        Me.OpenSpreadSheetButton.Name = "OpenSpreadSheetButton"
        Me.OpenSpreadSheetButton.Size = New System.Drawing.Size(120, 23)
        Me.OpenSpreadSheetButton.TabIndex = 0
        Me.OpenSpreadSheetButton.Text = "Open Spreadsheet"
        '
        'RollBackBatchesButton
        '
        Me.RollBackBatchesButton.Location = New System.Drawing.Point(24, 125)
        Me.RollBackBatchesButton.Name = "RollBackBatchesButton"
        Me.RollBackBatchesButton.Size = New System.Drawing.Size(120, 23)
        Me.RollBackBatchesButton.TabIndex = 1
        Me.RollBackBatchesButton.Text = "Rollback Batches"
        '
        'MassPosterSection
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.RollBackBatchesButton)
        Me.Controls.Add(Me.OpenSpreadSheetButton)
        Me.Name = "MassPosterSection"
        Me.Size = New System.Drawing.Size(160, 552)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub OpenSpreadSheetButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenSpreadSheetButton.Click
        RaiseEvent btnPressed(PressedButton.OpenSpreadsheet)
    End Sub

    Private Sub RollBackBatchesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RollBackBatchesButton.Click
        RaiseEvent btnPressed(PressedButton.RollbackBatches)
    End Sub

End Class
