Public Class AddressDialog

    Public Property EmailAddress() As String
        Get
            Return EmailTextBox.Text.Trim
        End Get
        Set(ByVal value As String)
            EmailTextBox.Text = value
        End Set
    End Property

    Public Property EmailName() As String
        Get
            Return NameTextBox.Text.Trim
        End Get
        Set(ByVal value As String)
            NameTextBox.Text = value
        End Set
    End Property

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click

        If Not IsValid() Then Exit Sub

        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()

    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()

    End Sub

    Private Function IsValid() As Boolean

        Dim msg As String = String.Empty

        If String.IsNullOrEmpty(EmailTextBox.Text.Trim) Then
            msg = "You must provide an email address!"
            EmailTextBox.Focus()
        End If

        If Not String.IsNullOrEmpty(msg) Then
            MessageBox.Show(msg, "Address Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            Return True
        End If

    End Function

End Class
