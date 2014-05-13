Public Class ViewCommentForm
    Private mContent As String
    Public Property Content() As String
        Get
            Return CommentTextBox.Text
        End Get
        Set(ByVal value As String)
            CommentTextBox.Text = value
        End Set
    End Property

    Public Sub New(ByVal contentText As String)
        InitializeComponent()
        Content = contentText
    End Sub
#Region "Private Methods"
    Private Sub ExportToPDF()
        Dim SaveFileDialog As New SaveFileDialog()
        SaveFileDialog.Filter = "PDF files (*.pdf)|*.pdf|All files (*.*)|*.*"
        SaveFileDialog.FilterIndex = 1
        SaveFileDialog.RestoreDirectory = True
        If SaveFileDialog.ShowDialog() = DialogResult.OK Then
            Me.CommentTextBoxLink.CreateDocument()
            Me.CommentTextBoxLink.PrintingSystem.ExportToPdf(SaveFileDialog.FileName)
        End If
    End Sub
#End Region
#Region "Event Handlers"

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub ExportToPDFToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportToPDFToolStripButton.Click
        ExportToPDF()
    End Sub

#End Region

    Private Sub PrintToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PrintToolStripButton.Click
        CommentTextBoxLink.ShowPreview()
    End Sub
End Class
