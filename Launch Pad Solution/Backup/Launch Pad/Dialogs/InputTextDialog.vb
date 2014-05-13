Imports System.Windows.Forms

Public Class InputTextDialog

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Public Property Prompt() As String
        Get
            Return promptLabel.Text
        End Get
        Set(ByVal value As String)
            promptLabel.Text = value
        End Set
    End Property

    Public Property userSpecifiedInput() As String
        Get
            Return userInput.Text
        End Get
        Set(ByVal value As String)
            userInput.Text = value
        End Set
    End Property


End Class
