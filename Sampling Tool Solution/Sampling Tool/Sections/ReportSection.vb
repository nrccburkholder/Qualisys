Public Class ReportSection

    Private WithEvents mReportNavigator As ReportNavigator

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        If Not TypeOf navCtrl Is ReportNavigator Then
            Throw New ArgumentException("The ReportSection control expects a NavControl of type 'ReportNavigator'")
        End If

        mReportNavigator = DirectCast(navCtrl, ReportNavigator)

    End Sub

    Private Sub mReportNavigator_ReportSelected(ByVal sender As Object, ByVal e As ReportNavigator.ReportSelectedEventArgs) Handles mReportNavigator.ReportSelected
        'Select Case e.ReportType
        '    Case ReportNavigator.SamplingReport.UnscheduledSampleSets
        '        Me.DataGridView1.DataSource = Nrc.Qualisys.Library.SampleSet.GetUnscheduledSampleSetData
        '        Me.DataGridView1.AutoGenerateColumns = True
        '    Case Else
        '        Me.DataGridView1.DataSource = Nothing
        'End Select
    End Sub

End Class
