Public Class ReportSection

    Private mReportNavigator As ReportNavigator

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mReportNavigator = TryCast(navCtrl, ReportNavigator)
    End Sub

    Public Overrides Sub ActivateSection()
        AddHandler mReportNavigator.ReportSelected, AddressOf mReportNavigator_ReportSelected
    End Sub

    Public Overrides Sub InactivateSection()
        RemoveHandler mReportNavigator.ReportSelected, AddressOf mReportNavigator_ReportSelected
    End Sub

    Private Sub GoButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GoButton.Click
        Me.NavigateBrowser()
    End Sub

    Private Sub ReportSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.NavigateBrowser()
    End Sub

    Private Sub WebAddress_KeyDown(ByVal sender As System.Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles WebAddress.KeyDown
        If e.KeyCode = Keys.Enter Then
            Me.NavigateBrowser()
        End If
    End Sub

    Private Sub NavigateBrowser()
        Me.WebBrowser.Navigate(Me.WebAddress.Text)
    End Sub

    Private Sub mReportNavigator_ReportSelected(ByVal sender As Object, ByVal e As ReportSelectedEventArgs)
        Me.WebAddress.Text = e.ReportUri.ToString
        Me.NavigateBrowser()
    End Sub
End Class
