Imports Nrc.DataMart.Library
Imports Nrc.DataMart.Library.ORYX

Public Class ExportOryxDialog

    Dim ExportSets As Collection(Of ExportSet)
    Dim Exporter As OryxExporter

    Public Sub New(ByVal exportSets As Collection(Of ExportSet))
        InitializeComponent()
        Me.ExportSets = exportSets
        ProgressBar.Style = ProgressBarStyle.Blocks
    End Sub
    Private Sub ExportOryxDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        PopulateControlText()
        Exporter = New OryxExporter()
        txtOutput.Text = Exporter.OutputPath 'TODO: remember last used path, not default
    End Sub
    Private Sub PopulateControlText()
        PopulateYear()
        'PopulateMonth() this gets triggered by cbYear's SelectedIndexChanged event

        llExports.Text = ExportSets.Count.ToString() + " Export item(s)"
    End Sub
    Private Sub PopulateYear()
        Dim minDate As Date = GetMinDate()
        Dim maxDate As Date = GetMaxDate()

        For i As Int32 = Year(minDate) To Year(maxDate)
            cbYear.Items.Add(i)
        Next
        If cbYear.Items.Count > 0 Then
            cbYear.SelectedIndex = 0
        End If
    End Sub
    Private Sub PopulateMonth()

        Dim minDate As Date = GetMinDate()
        Dim maxDate As Date = GetMaxDate()

        Dim FirstQ As Int32 = Convert.ToInt32(Math.Ceiling(Month(minDate) / 3))
        Dim LastQ As Int32 = Convert.ToInt32(Math.Ceiling(Month(maxDate) / 3))

        If Year(minDate) < Year(maxDate) Then
            If Convert.ToInt32(cbYear.SelectedItem) = Year(minDate) Then
                LastQ = 4
            Else
                FirstQ = 1
            End If
        End If

        cbQuarter.Items.Clear()
        For i As Int32 = FirstQ To LastQ
            cbQuarter.Items.Add(i)
        Next
        If cbQuarter.Items.Count > 0 Then
            cbQuarter.SelectedIndex = 0
        End If

    End Sub
    Private Function GetMinDate() As Date
        Dim result As Date = Date.MaxValue

        For Each e As ExportSet In ExportSets
            If e.StartDate < result Then
                result = e.StartDate
            End If
        Next

        Return result
    End Function
    Private Function GetMaxDate() As Date
        Dim result As Date = Date.MinValue

        For Each e As ExportSet In ExportSets
            If e.StartDate > result Then
                result = e.StartDate
            End If
        Next

        Return result
    End Function

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        If ExportActive Then
            Exporter.StopExport()
        End If
        Close()
    End Sub
    Private Sub btnBrowseOutput_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBrowseOutput.Click
        Dim browse As New FolderBrowserDialog()
        browse.SelectedPath = Exporter.OutputPath
        browse.ShowNewFolderButton = True
        browse.ShowDialog()
        txtOutput.Text = browse.SelectedPath
    End Sub
    Private Sub btnExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExport.Click
        Enable(False)
        ProgressBar.Show()
        ExportActive = True
        Exporter.CreateExportAsync(ExportSets, txtOutput.Text, Convert.ToInt32(cbQuarter.SelectedItem), Convert.ToInt32(cbYear.SelectedItem), AddressOf ReportProgress, AddressOf ExportError, AddressOf ExportComplete)
    End Sub
    Private Sub Enable(ByVal Enabled As Boolean)
        gbOutput.Enabled = Enabled
        cbQuarter.Enabled = Enabled
        cbYear.Enabled = Enabled
        btnExport.Enabled = Enabled
        llExports.Enabled = Enabled
    End Sub

    Private lockObj As New Object()
    Private Delegate Sub InternalDelegate()
    Private Delegate Sub ExceptionDelegate(ByVal ex As Exception, ByVal msg As String)
    Private _StatusMessage As String
    Private Property StatusMessage() As String
        Get
            SyncLock (lockObj)
                Return _StatusMessage
            End SyncLock
        End Get
        Set(ByVal value As String)
            SyncLock (lockObj)
                _StatusMessage = value
            End SyncLock
        End Set
    End Property
    Private _StatusPercent As Int32
    Private Property StatusPercent() As Int32
        Get
            SyncLock (lockObj)
                Return _StatusPercent
            End SyncLock
        End Get
        Set(ByVal value As Int32)
            SyncLock (lockObj)
                _StatusPercent = value
            End SyncLock
        End Set
    End Property
    Private _ExportActive As Boolean
    Private Property ExportActive() As Boolean
        Get
            SyncLock (lockObj)
                Return _ExportActive
            End SyncLock
        End Get
        Set(ByVal value As Boolean)
            SyncLock (lockObj)
                _ExportActive = value
            End SyncLock
        End Set
    End Property
    Public Sub ReportProgress(ByVal PercentDone As Int32, ByVal Msg As String)
        StatusPercent = PercentDone
        StatusMessage = Msg
        If InvokeRequired And Not Disposing Then
            Invoke(New InternalDelegate(AddressOf InternalProgress))
        End If
    End Sub
    Private Sub InternalProgress()
        If StatusPercent > 0 Then
            ProgressBar.Visible = True
            lblStatus.Visible = True
            ProgressBar.Value = StatusPercent
            lblStatus.Text = StatusMessage
        Else
            lblStatus.Visible = False
            ProgressBar.Visible = False
        End If
    End Sub
    Public Sub ExportError(ByVal ex As Exception)
        If InvokeRequired AndAlso Not Disposing Then
            Invoke(New ExceptionDelegate(AddressOf Globals.ReportException), New Object() {ex, "ORYX export failed!"})
            ExportComplete()
        ElseIf Not Disposing Then
            Globals.ReportException(ex)
            ExportComplete()
        End If
    End Sub
    Public Sub ExportComplete()
        If InvokeRequired AndAlso Not Disposing Then
            Invoke(New InternalDelegate(AddressOf ExportComplete))
            Return
        End If
        Close()
    End Sub

    Private Sub cbYear_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbYear.SelectedIndexChanged
        PopulateMonth()
    End Sub

    Private Sub llExports_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles llExports.LinkClicked
        Dim xpts As New System.Text.StringBuilder()
        For Each x As ExportSet In ExportSets
            xpts.Append(DataProvider.Instance.SelectClient(DataProvider.Instance.SelectClientIDByExportSetID(x.Id)).Name)
            xpts.Append(" - ")
            xpts.AppendLine(x.Name)
        Next
        MessageBox.Show(String.Format("     The following export sets were chosen:      {0}{1}{2}", _
            Environment.NewLine, Environment.NewLine, xpts.ToString()), "Selected ORYX Export Sets")
    End Sub
End Class