''' <summary>This is used when firing SelectionChanged event in ReportsNavigator. ReportSection handles
''' the event</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ReportsEventArgs
    Inherits EventArgs
    Private mReport As SSRSReport
    Public Sub New(ByVal Report As SSRSReport)
        mReport = Report
    End Sub
    Public ReadOnly Property Report() As SSRSReport
        Get
            Return mReport
        End Get
    End Property
End Class
