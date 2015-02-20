Public Class ReportNavigator

    Public Enum SamplingReport
        None = 0
        UnscheduledSampleSets = 1
        UpcomingSamples = 2
        SamplingActivity = 3
    End Enum

    Public Class ReportSelectedEventArgs
        Inherits EventArgs

        Private mReportType As SamplingReport

        Public ReadOnly Property ReportType() As SamplingReport
            Get
                Return mReportType
            End Get
        End Property

        Public Sub New(ByVal reportType As SamplingReport)
            mReportType = reportType
        End Sub

    End Class
    Public Event ReportSelected As EventHandler(Of ReportSelectedEventArgs)

    Private Sub UnscheduledSamplesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnscheduledSamplesButton.Click
        Me.OnReportSelected(New ReportSelectedEventArgs(SamplingReport.UnscheduledSampleSets))
    End Sub

    Private Sub UpcomingSamplesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpcomingSamplesButton.Click
        Me.OnReportSelected(New ReportSelectedEventArgs(SamplingReport.UpcomingSamples))
    End Sub

    Private Sub SamplingActivityButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SamplingActivityButton.Click
        Me.OnReportSelected(New ReportSelectedEventArgs(SamplingReport.SamplingActivity))
    End Sub

    Protected Overridable Sub OnReportSelected(ByVal e As ReportSelectedEventArgs)
        RaiseEvent ReportSelected(Me, e)
    End Sub
End Class
