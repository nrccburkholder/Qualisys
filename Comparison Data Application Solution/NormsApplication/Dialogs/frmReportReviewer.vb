Option Explicit On 
Option Strict On

Imports System.Web

Public Class frmReportReviewer
    Inherits NRC.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents btnApprove As System.Windows.Forms.Button
    Friend WithEvents btnDisapprove As System.Windows.Forms.Button
    Friend WithEvents btnClose As System.Windows.Forms.Button
    Friend WithEvents Browser As AxSHDocVw.AxWebBrowser
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents chkShowAddrBar As System.Windows.Forms.CheckBox
    Friend WithEvents txtAddrBar As System.Windows.Forms.TextBox
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmReportReviewer))
        Me.btnApprove = New System.Windows.Forms.Button
        Me.btnDisapprove = New System.Windows.Forms.Button
        Me.btnClose = New System.Windows.Forms.Button
        Me.Browser = New AxSHDocVw.AxWebBrowser
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.txtAddrBar = New System.Windows.Forms.TextBox
        Me.chkShowAddrBar = New System.Windows.Forms.CheckBox
        CType(Me.Browser, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel1.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(670, 26)
        '
        'btnApprove
        '
        Me.btnApprove.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnApprove.Location = New System.Drawing.Point(390, 388)
        Me.btnApprove.Name = "btnApprove"
        Me.btnApprove.Size = New System.Drawing.Size(80, 23)
        Me.btnApprove.TabIndex = 2
        Me.btnApprove.Text = "Approve"
        '
        'btnDisapprove
        '
        Me.btnDisapprove.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnDisapprove.Location = New System.Drawing.Point(478, 388)
        Me.btnDisapprove.Name = "btnDisapprove"
        Me.btnDisapprove.Size = New System.Drawing.Size(80, 23)
        Me.btnDisapprove.TabIndex = 3
        Me.btnDisapprove.Text = "Disapprove"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.Location = New System.Drawing.Point(566, 388)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(80, 23)
        Me.btnClose.TabIndex = 4
        Me.btnClose.Text = "Close"
        '
        'Browser
        '
        Me.Browser.ContainingControl = Me
        Me.Browser.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Browser.Enabled = True
        Me.Browser.Location = New System.Drawing.Point(0, 0)
        Me.Browser.OcxState = CType(resources.GetObject("Browser.OcxState"), System.Windows.Forms.AxHost.State)
        Me.Browser.Size = New System.Drawing.Size(622, 296)
        Me.Browser.TabIndex = 0
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.Panel2)
        Me.Panel1.Controls.Add(Me.txtAddrBar)
        Me.Panel1.Controls.Add(Me.chkShowAddrBar)
        Me.Panel1.Controls.Add(Me.btnClose)
        Me.Panel1.Controls.Add(Me.btnApprove)
        Me.Panel1.Controls.Add(Me.btnDisapprove)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(1, 1)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(670, 428)
        Me.Panel1.TabIndex = 0
        '
        'Panel2
        '
        Me.Panel2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel2.Controls.Add(Me.Browser)
        Me.Panel2.Location = New System.Drawing.Point(24, 72)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(622, 296)
        Me.Panel2.TabIndex = 6
        '
        'txtAddrBar
        '
        Me.txtAddrBar.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtAddrBar.BackColor = System.Drawing.Color.White
        Me.txtAddrBar.Location = New System.Drawing.Point(144, 40)
        Me.txtAddrBar.Name = "txtAddrBar"
        Me.txtAddrBar.ReadOnly = True
        Me.txtAddrBar.Size = New System.Drawing.Size(502, 20)
        Me.txtAddrBar.TabIndex = 1
        Me.txtAddrBar.Text = ""
        '
        'chkShowAddrBar
        '
        Me.chkShowAddrBar.Appearance = System.Windows.Forms.Appearance.Button
        Me.chkShowAddrBar.Checked = True
        Me.chkShowAddrBar.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkShowAddrBar.Location = New System.Drawing.Point(24, 40)
        Me.chkShowAddrBar.Name = "chkShowAddrBar"
        Me.chkShowAddrBar.Size = New System.Drawing.Size(112, 24)
        Me.chkShowAddrBar.TabIndex = 0
        Me.chkShowAddrBar.Text = "Hide Address Bar"
        Me.chkShowAddrBar.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'frmReportReviewer
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(672, 430)
        Me.Controls.Add(Me.Panel1)
        Me.DockPadding.All = 1
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimizeBox = False
        Me.Name = "frmReportReviewer"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.Controls.SetChildIndex(Me.Panel1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        CType(Me.Browser, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel1.ResumeLayout(False)
        Me.Panel2.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Sub LoadGeneralSettingReport(ByVal norm As CanadaNormSetting)
        Dim url As String
        Me.Caption = String.Format("Report Viewer - {0} ({1})", norm.NormLabel, norm.NormID)
        url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false", Config.ReportServer, Config.CanadaNormGeneralSettingReport)
        url += "&Norm_ID=" & norm.NormID
        url += "&NormLabel=" & HttpUtility.UrlEncode(norm.NormLabel)
        url += "&NormDescription=" & HttpUtility.UrlEncode(norm.NormDescription)
        url += "&CriteriaStmt=" & HttpUtility.UrlEncode(norm.CriteriaStmt)
        url += "&WeightingType=" & CStr(IIf(norm.Weighted, "Yes", "No"))
        url += "&ReportDateBegin=" & norm.ReportDateBegin.ToShortDateString
        url += "&ReportDateEnd=" & norm.ReportDateEnd.ToShortDateString
        url += "&ReturnDateMax=" & norm.ReturnDateMax.ToShortDateString
        ShowReport(url)
    End Sub

    Public Sub LoadSurveySelectionReport(ByVal norm As CanadaNormSetting)
        Dim url As String
        Me.Caption = String.Format("Report Viewer - {0} ({1})", norm.NormLabel, norm.NormID)
        url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false&Norm_ID={2}", Config.ReportServer, Config.CanadaNormSurveySelectionReport, norm.NormID)
        ShowReport(url)
    End Sub

    Public Sub LoadRollupSelectionReport(ByVal norm As CanadaNormSetting)
        Dim url As String
        Me.Caption = String.Format("Report Viewer - {0} ({1})", norm.NormLabel, norm.NormID)
        url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false&Norm_ID={2}", Config.ReportServer, Config.CanadaNormRollupSelectionReport, norm.NormID)
        ShowReport(url)
    End Sub

    Public Sub LoadNormQuestionScoreReport(ByVal normID As Integer, ByVal normLabel As String)
        Dim url As String
        Me.Caption = String.Format("Report Viewer - {0}", normLabel)
        url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false&Norm_ID={2}", Config.ReportServer, Config.CanadaNormQuestionScoreReport, normID)
        ShowReport(url)
    End Sub

    Public Sub LoadQuestionBenchmarkPerformerReport(ByVal compTypeID As Integer)
        Dim url As String
        Me.Caption = "Report Viewer - Benchmark Performer Report"
        url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false&CompType_ID={2}", Config.ReportServer, Config.CanadaNormQuestionScoreReport, compTypeID)
        ShowReport(url)
    End Sub

    Public Sub LoadCanadaQuestionBenchmarkPerformerReport(ByVal compTypeID As Integer)
        Dim url As String
        Me.btnApprove.Visible = False
        Me.btnDisapprove.Visible = False
        Me.Caption = "Report Viewer - Benchmark Performer Report"
        url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false&CompType_ID={2}", Config.ReportServer, Config.CanadaQuestionBenchmarkPerformerReport, compTypeID)
        ShowReport(url)
    End Sub

    Public Sub LoadCanadaDimensionBenchmarkPerformerReport(ByVal compTypeID As Integer, ByVal dimensions As String)
        Dim url As String
        Me.btnApprove.Visible = False
        Me.btnDisapprove.Visible = False
        Me.Caption = "Report Viewer - Benchmark Performer Report"
        url = String.Format("{0}{1}&rs:Command=Render&rs:ClearSession=true&rc:Parameters=false&CompType_ID={2}&Dimensions={3}", Config.ReportServer, Config.CanadaDimensionBenchmarkPerformerReport, compTypeID, dimensions)
        ShowReport(url)
    End Sub

    Private Sub btnApprove_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApprove.Click
        DialogResult = DialogResult.Yes
    End Sub

    Private Sub btnDisapprove_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDisapprove.Click
        DialogResult = DialogResult.No
    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        DialogResult = DialogResult.Cancel
    End Sub

    Private Sub frmReportReviewer_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        Browser.Dispose()
        Browser = Nothing
        GC.Collect()
    End Sub

    Private Sub frmReportReviewer_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        EnableThemes(Me)
    End Sub

    Private Sub chkShowAddrBar_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkShowAddrBar.CheckedChanged
        txtAddrBar.Visible = chkShowAddrBar.Checked
        chkShowAddrBar.Text = CStr(IIf(chkShowAddrBar.Checked, "Hide Address Bar", "Show Address Bar"))
    End Sub

    'Private Sub txtAddrBar_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtAddrBar.GotFocus
    '    txtAddrBar.SelectAll()
    '    txtAddrBar.HideSelection = False
    'End Sub

    Private Sub txtAddrBar_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtAddrBar.Enter
        txtAddrBar.SelectAll()
        txtAddrBar.HideSelection = False
    End Sub

    Private Sub ShowReport(ByVal url As String)
        Try
            Cursor.Current = Cursors.WaitCursor
            txtAddrBar.Text = url
            Me.Browser.Navigate(url)
        Catch ex As Exception
            ReportException(ex, "Report Exception")
            MessageBox.Show(ex.Message, "Report Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Cursor.Current = Cursors.Default
        End Try
    End Sub

End Class
