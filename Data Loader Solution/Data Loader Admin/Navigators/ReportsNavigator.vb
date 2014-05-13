Public Class ReportsNavigator
    Public Event SelectionChanged As EventHandler(Of ReportsEventArgs)
    Public Event NavigateBackClicked As EventHandler
    Public Event NavigateForwardClicked As EventHandler
    Private mSelectedReport As SSRSReport
    Private mSSRSReports As New List(Of SSRSReport)


    ''' <summary>Currently selected report </summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property SelectedReport() As SSRSReport
        Get
            Return mSelectedReport
        End Get
    End Property
    ''' <summary>Keeps the list of available reports </summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property SSRSReports() As List(Of SSRSReport)
        Get
            Return mSSRSReports
        End Get
        Set(ByVal value As List(Of SSRSReport))
            mSSRSReports = value
        End Set
    End Property
    ''' <summary>Notifies the Section control about the selection change and passes the 
    ''' new selected report</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub lbxReports_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
        If lbxReports.SelectedIndex >= 0 Then
            mSelectedReport = SSRSReports(lbxReports.SelectedIndex)
            RaiseEvent SelectionChanged(Me, New ReportsEventArgs(SelectedReport))
        End If
    End Sub

    Private Sub ReportsNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'add a reports to the collection to bind to the list.
        If SSRSReports.Count = 0 Then
            SSRSReports.Add(New SSRSReport(SSRSReport.UploadedFileReport))
            Me.lbxReports.DataSource = SSRSReports
            Me.lbxReports.DisplayMember = "ReportDisplayName"
            Me.lbxReports.ValueMember = "ReportName"
            Me.lbxReports.SelectedIndex = 0
            lbxReports_SelectedIndexChanged(Me, EventArgs.Empty)
        End If
    End Sub

    ''' <summary>Tell the Section control that the user clicked on Back button</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub btnBack_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBack.Click
        RaiseEvent NavigateBackClicked(Me, ReportsEventArgs.Empty)
    End Sub

    Private Sub btnForward_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnForward.Click
        RaiseEvent NavigateForwardClicked(Me, EventArgs.Empty)
    End Sub

    'Private Sub lbxReports_MouseClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lbxReports.MouseClick
    '    RaiseEvent SelectionChanged(Me, New ReportsEventArgs(SelectedReport))
    'End Sub


End Class