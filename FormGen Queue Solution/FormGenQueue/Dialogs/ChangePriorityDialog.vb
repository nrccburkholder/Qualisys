Imports System.Windows.Forms

Public Class ChangePriorityDialog

    Public Property PriorityValue() As Integer
        Get
            Return CType(Me.Priority.Value, Integer)
        End Get
        Set(ByVal value As Integer)
            If value > 10 Then value = 10
            If value < 1 Then value = 1
            Me.Priority.Value = value
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

    Private Sub ChangePriorityDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.Priority.Focus()
        Me.Priority.Select(0, Me.Priority.Value.ToString.Length)
    End Sub
End Class
