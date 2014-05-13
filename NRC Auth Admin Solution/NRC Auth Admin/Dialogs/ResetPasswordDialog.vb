Imports Nrc.NRCAuthLib

Public Class ResetPasswordDialog

    Private mMember As Member
    Private mAllowSave As Boolean
    Private Event AllowSaveChanged As EventHandler

    Public Property AllowSave() As Boolean
        Get
            Return Me.mAllowSave
        End Get
        Private Set(ByVal value As Boolean)
            If mAllowSave <> value Then
                mAllowSave = value
                Me.OK_Button.Enabled = mAllowSave
            End If
        End Set
    End Property

    Public Sub New(ByVal mbr As Member)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mMember = mbr
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        If ValidateForm() Then
            Try
                If Me.AutoGenPassword.Checked Then
                    mMember.ResetPassword(Me.SendEmailNotification.Checked, CurrentUser.Member.MemberId)
                Else
                    mMember.ResetPassword(Me.SendEmailNotification.Checked, CurrentUser.Member.MemberId, Me.Password.Text)
                End If
                Me.DialogResult = System.Windows.Forms.DialogResult.OK
            Catch ex As Exception
                Globals.ReportException(ex)
            Finally
                Me.Close()
            End Try
        End If
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub AutoGenPassword_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AutoGenPassword.CheckedChanged
        Me.TogglePasswordEnabled()
        If Not Me.AutoGenPassword.Checked Then
            Me.Password.Focus()
        End If
    End Sub

    Private Sub TogglePasswordEnabled()
        Me.PasswordLabel.Enabled = (Not Me.AutoGenPassword.Checked)
        Me.Password.Enabled = (Not Me.AutoGenPassword.Checked)
        If Me.AutoGenPassword.Checked Then
            Me.Password.Text = ""
        End If
    End Sub

    Private Function ValidatePassword(ByRef errorMessage As String) As Boolean
        If Not Me.AutoGenPassword.Checked Then
            If Me.Password.Text.Trim.Length = 0 Then
                errorMessage = "You must enter a password"
                Return False
            End If

            If Not Member.IsStrongPassword(Me.Password.Text) Then
                errorMessage = "You must enter an alphanumeric password that is at least 8 characters long"
                Return False
            End If
        End If

        Return True
    End Function

    Private Function ValidateForm() As Boolean
        Dim result As Boolean = True
        Dim errorMessage As String = ""

        If Not Me.ValidatePassword(errorMessage) Then
            Me.ErrorProvider.SetError(Me.Password, errorMessage)
            result = False
        Else
            Me.ErrorProvider.SetError(Me.Password, "")
        End If

        Me.AllowSave = result
        Return result
    End Function

    Private Sub AutoGenPassword_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles AutoGenPassword.Validating
        Me.ValidateForm()
    End Sub

    Private Sub Password_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles Password.Validating
        Me.ValidateForm()
    End Sub
End Class
