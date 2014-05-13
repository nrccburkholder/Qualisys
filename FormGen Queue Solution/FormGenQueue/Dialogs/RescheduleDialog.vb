Imports System.Windows.Forms

Public Class RescheduleDialog

    Private Const GENERATION_FUTURE_DAYS_WARNING As Integer = 5

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.WarningPanel.Visible = False
    End Sub

    Public Property GenerationDate() As Date
        Get
            Return Me.SelectedDate.Value
        End Get
        Set(ByVal value As Date)
            Me.SelectedDate.Value = value
        End Set
    End Property

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub SelectedDate_ValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SelectedDate.ValueChanged
        If SelectedDate.Value < Date.Today Then
            Me.WarningMessage.Text = "You have selected a date in the past."
            Me.WarningPanel.Visible = True
        ElseIf SelectedDate.Value > Date.Today.AddDays(GENERATION_FUTURE_DAYS_WARNING) Then
            Me.WarningMessage.Text = String.Format("The generation will not occur for {0} days!", SelectedDate.Value.Subtract(Date.Today).Days)
            Me.WarningPanel.Visible = True
        Else
            Me.WarningPanel.Visible = False
        End If
    End Sub

    Private Sub RescheduleDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.SelectedDate.Focus()
    End Sub
End Class
