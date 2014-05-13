Public Class ReportSection


    Private WithEvents mReportNavigator As ReportNavigator

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mReportNavigator = TryCast(navCtrl, ReportNavigator)

        If mReportNavigator Is Nothing Then
            Throw New ArgumentException("The ReportSection control expects a navigator of type ReportNavigator")
        End If
    End Sub

    Private Sub mReportNavigator_ReportSelected(ByVal sender As Object, ByVal e As ReportNavigator.ReportSelectedEventArgs) Handles mReportNavigator.ReportSelected
        Dim reportServer As String = Config.ReportServer
        Dim reportPath As String = e.Report.Path
        Dim url As String = String.Format("http://{0}/reportserver?{1}&rs:Command=Render", reportServer, reportPath)
        url = Uri.EscapeUriString(url)
        Me.SectionPanel1.Caption = e.Report.Name
        Me.WebBrowser1.Navigate(url)

    End Sub
End Class
