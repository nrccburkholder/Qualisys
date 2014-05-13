Public Class InformationBar
    Public Property Information() As String
        Get
            Return Me.InfoLabel.Text
        End Get
        Set(ByVal value As String)
            Me.InfoLabel.Text = value
            If value Is Nothing OrElse value.Trim = "" Then
                Me.Hide()
            Else
                Me.Show()
            End If
        End Set
    End Property

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Hide()
    End Sub

    Private Sub CloseButton_MouseHover(ByVal sender As Object, ByVal e As System.EventArgs) Handles CloseButton.MouseEnter, CloseButton.MouseHover, InfoLabel.MouseEnter, InfoLabel.MouseHover
        Me.BackColor = System.Drawing.SystemColors.Highlight
        InfoLabel.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
    End Sub

    Private Sub CloseButton_MouseLeave(ByVal sender As Object, ByVal e As System.EventArgs) Handles CloseButton.MouseLeave, InfoLabel.MouseLeave
        Me.BackColor = System.Drawing.SystemColors.Info
        InfoLabel.ForeColor = System.Drawing.SystemColors.ControlText
    End Sub

    'Private Sub InformationBar_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles Me.Paint
    '    Dim rect As Rectangle = Me.Bounds
    '    rect.Width -= 1
    '    rect.Height -= 1
    '    Using borderPen As New Pen(ProfessionalColors.ToolStripBorder)
    '        e.Graphics.DrawRectangle(borderPen, rect)
    '    End Using
    'End Sub

End Class
