Public Class ValidationDialog
    Private mValidationList As List(Of String) = Nothing

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.Close()
    End Sub
    Public Sub New(ByVal validationErrors As List(Of String))
        InitializeComponent()
        Me.mValidationList = validationErrors
        Me.grdValidationErrors.DataSource = Me.mValidationList        
    End Sub

End Class
