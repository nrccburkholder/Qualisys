Public Class ReportSelectedEventArgs
    Inherits EventArgs

    Private mReportLabel As String
    Private mReportUri As Uri

    Public ReadOnly Property ReportLabel() As String
        Get
            Return mReportLabel
        End Get
    End Property
    Public ReadOnly Property ReportUri() As Uri
        Get
            Return mReportUri
        End Get
    End Property

    Public Sub New(ByVal label As String, ByVal uri As Uri)
        mReportLabel = label
        mReportUri = uri
    End Sub

End Class
