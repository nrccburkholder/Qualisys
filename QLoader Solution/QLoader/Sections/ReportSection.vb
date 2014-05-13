Imports Nrc.Qualisys.QLoader.Library
Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class ReportViewer
    Inherits Section

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Me.InitializeToolStripItems()
    End Sub

    'UserControl overrides dispose to clean up the component list.
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
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents cmnReports As System.Windows.Forms.ContextMenu
    Friend WithEvents mnuViewReport As System.Windows.Forms.MenuItem
    Friend WithEvents mnuCrossTabs As System.Windows.Forms.MenuItem
    Friend WithEvents browser As System.Windows.Forms.WebBrowser
    Friend WithEvents PaneCaption1 As Nrc.Framework.WinForms.PaneCaption
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnApprove = New System.Windows.Forms.Button
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.PaneCaption1 = New Nrc.Framework.WinForms.PaneCaption
        Me.cmnReports = New System.Windows.Forms.ContextMenu
        Me.mnuViewReport = New System.Windows.Forms.MenuItem
        Me.mnuCrossTabs = New System.Windows.Forms.MenuItem
        Me.browser = New System.Windows.Forms.WebBrowser
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'btnApprove
        '
        Me.btnApprove.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnApprove.Enabled = False
        Me.btnApprove.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnApprove.Location = New System.Drawing.Point(368, 432)
        Me.btnApprove.Name = "btnApprove"
        Me.btnApprove.Size = New System.Drawing.Size(75, 23)
        Me.btnApprove.TabIndex = 1
        Me.btnApprove.Text = "Approve"
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = ""
        Me.SectionPanel1.Controls.Add(Me.browser)
        Me.SectionPanel1.Controls.Add(Me.PaneCaption1)
        Me.SectionPanel1.Controls.Add(Me.btnApprove)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = False
        Me.SectionPanel1.Size = New System.Drawing.Size(464, 472)
        Me.SectionPanel1.TabIndex = 3
        '
        'PaneCaption1
        '
        Me.PaneCaption1.Caption = "Report Viewer"
        Me.PaneCaption1.Dock = System.Windows.Forms.DockStyle.Top
        Me.PaneCaption1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.PaneCaption1.Location = New System.Drawing.Point(1, 1)
        Me.PaneCaption1.Name = "PaneCaption1"
        Me.PaneCaption1.Size = New System.Drawing.Size(462, 26)
        Me.PaneCaption1.TabIndex = 3
        Me.PaneCaption1.Text = "Report Viewer"
        '
        'cmnReports
        '
        Me.cmnReports.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuViewReport, Me.mnuCrossTabs})
        '
        'mnuViewReport
        '
        Me.mnuViewReport.Index = 0
        Me.mnuViewReport.Text = "View Reports"
        '
        'mnuCrossTabs
        '
        Me.mnuCrossTabs.Index = 1
        Me.mnuCrossTabs.Text = "Cross Tabs"
        '
        'browser
        '
        Me.browser.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.browser.Location = New System.Drawing.Point(4, 33)
        Me.browser.MinimumSize = New System.Drawing.Size(20, 20)
        Me.browser.Name = "browser"
        Me.browser.Size = New System.Drawing.Size(456, 393)
        Me.browser.TabIndex = 4
        '
        'ReportViewer
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "ReportViewer"
        Me.Size = New System.Drawing.Size(464, 472)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mDataFileID As Integer
    Private mPackageNavigator As PackageNavigator
    Private mToolStripItems As New List(Of ToolStripItem)
    Private Sub InitializeToolStripItems()
        Dim item As ToolStripItem

        item = New ToolStripButton("Refresh Report List", My.Resources.Refresh32, New EventHandler(AddressOf RefreshReportsButton_Clicked))
        Me.mToolStripItems.Add(item)

        item = New ToolStripButton("Package Reports", My.Resources.Reports32, New EventHandler(AddressOf PackageReportsButton_Clicked))
        Me.mToolStripItems.Add(item)
    End Sub

    Public Sub LoadReport(ByVal dataFileID As Integer)
        Dim URL As String
        Dim file As DataFile
        Me.Cursor = Cursors.WaitCursor

        Try
            Me.mDataFileID = dataFileID
            file = New DataFile
            file.LoadFromDB(dataFileID)
            Me.PaneCaption1.Caption = String.Format("Report Viewer - {0} ({1})", file.OriginalFileName, dataFileID)
            'Set the URL to the Reporting Services web server
            'URL = String.Format("{0}{1}&rs:Command=Render&rc:Parameters=false&DataFile_id={2}", Config.ReportServer, Config.ValidationReport, dataFileID)
            URL = file.ReportURL
            Me.browser.Navigate(URL)

            'Determine if we can show the Approve/Apply button
            Me.btnApprove.Enabled = CanApproveReport()
        Catch ex As Exception
            ReportException(ex, "Report Exception")
            MessageBox.Show(ex.Message, "Report Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Public Sub LoadPackageReport(ByVal packageID As Integer)
        LoadPackageReport(packageID, -1)
    End Sub

    Public Sub LoadPackageReport(ByVal packageID As Integer, ByVal version As Integer)

        Dim URL As String
        Me.Cursor = Cursors.WaitCursor

        Try
            'Set the URL to the Reporting Services web server
            URL = String.Format("{0}{1}&rs:Command=Render&rc:Parameters=false&PackageID={2}&Version={3}", AppConfig.Params("QLReportServer").StringValue, AppConfig.Params("QLPackageReport").StringValue, packageID, version)
            Me.browser.Navigate(URL)

            'Determine if we can show the Approve/Apply button
            Me.btnApprove.Enabled = False
        Catch ex As Exception
            ReportException(ex, "Report Exception")
            MessageBox.Show(ex.Message, "Report Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Public Sub QuickReport(ByVal clientID As Integer, ByVal studyID As Integer, ByVal packageID As Integer, ByVal dataFileID As Integer)
        Dim nodeID As String = clientID & studyID & packageID & dataFileID
        Me.mPackageNavigator.SelectNode(nodeID, "")
        Me.LoadReport(dataFileID)
    End Sub

    ''' <summary>Determins if the user can approve or apply a file</summary>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>08/12/2008 - Arman Mnatsakanyan</term>
    ''' <description>Made it possible to approve and also apply by the same person if
    ''' the Qloader is set to a single person approval mode.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Function CanApproveReport() As Boolean
        Dim file As DataFile
        Dim package As DTSPackage

        'Load the file object
        file = New DataFile
        file.LoadFromDB(mDataFileID)

        'Load the package object
        package = New DTSPackage(file.PackageID)

        'If the file is waiting for FIRST approval and the user is a file loader then button is active
        If file.FileState = DataFileStates.AwaitingFirstApproval Then
            Me.btnApprove.Text = "Approve"

            Return (CurrentUser.IsFileLoader)

            'If the file is waiting for SECOND approval
        ElseIf file.FileState = DataFileStates.AwaitingFinalApproval Then
            Me.btnApprove.Text = "Apply"

            'TODO: Implement logic to retrieve the value from Loading_Params table in QP_Load
            '       and uncomment the following lines:
            'if we're in two person approval mode then approver cannot also apply 
            If Nrc.Qualisys.Library.QualisysParams.ApprovalMode = Nrc.Qualisys.Library.ApprovalModes.Supervised Then
                '  If this is the person who did first approval then return false
                If file.IsApprover(CurrentUser.LoginName) Then
                    Return False
                End If
            End If
            Return CurrentUser.IsAdministrator OrElse CurrentUser.IsLoadApplier
        End If

        Return False
    End Function

    ''' <summary>Handles Approve button click event</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>08/12/08 - Arman Mnatsakanyan</term>
    ''' <description>Changed the parameter of file.Approve from the loginname to the
    ''' actual user object.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub btnApprove_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApprove.Click
        Dim file As DataFile

        'Set the cursor to wait
        Me.Cursor = Cursors.WaitCursor

        Try
            'Load the file object
            file = New DataFile
            file.LoadFromDB(Me.mDataFileID)

            'Disable the button before trying to approve
            Me.btnApprove.Enabled = False

            'Approve the file
            file.Approve(CurrentUser)
        Catch ex As Exception
            ReportException(ex, "Approval Error")
            'MessageBox.Show(ex.Message, "Approval Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Me.Cursor = Cursors.Default    'Restore cursor
        End Try
    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mPackageNavigator = TryCast(navCtrl, PackageNavigator)
        If mPackageNavigator Is Nothing Then
            Throw New ArgumentException("The Report section control expects a navigator of type 'PackageNavigator'")
        End If
    End Sub

    Public Overrides Sub ActivateSection()
        If mPackageNavigator IsNot Nothing Then
            'AddHandler mPackageNavigator.SelectedPackageChanging, AddressOf mPackageNavigator_SelectedPackageChanging
            AddHandler mPackageNavigator.SelectedPackageChanged, AddressOf mPackageNavigator_SelectedPackageChanged
            mPackageNavigator.AllowMultiSelect = False
            mPackageNavigator.RefreshTree(ClientTreeTypes.FilesInQueue)
            mPackageNavigator.TreeContextMenu = Me.cmnReports
        End If
    End Sub

    Public Overrides Sub InactivateSection()
        If mPackageNavigator IsNot Nothing Then
            'RemoveHandler mPackageNavigator.SelectedPackageChanging, AddressOf mPackageNavigator_SelectedPackageChanging
            RemoveHandler mPackageNavigator.SelectedPackageChanged, AddressOf mPackageNavigator_SelectedPackageChanged
            mPackageNavigator.TreeContextMenu = Nothing
        End If

    End Sub

    Public Overrides Function AllowInactivate() As Boolean
        Return True
    End Function

    Public Overrides ReadOnly Property ToolStripItems() As System.Collections.Generic.List(Of System.Windows.Forms.ToolStripItem)
        Get
            Return Me.mToolStripItems
        End Get
    End Property

    Private Sub mPackageNavigator_SelectedPackageChanged(ByVal sender As Object, ByVal e As SelectedPackageChangedEventArgs)
        Me.ViewReportCommand()
    End Sub

    Private Sub RefreshReportsButton_Clicked(ByVal sender As Object, ByVal e As EventArgs)
        Me.mPackageNavigator.RefreshTree(ClientTreeTypes.FilesInQueue)
    End Sub

    Private Sub PackageReportsButton_Clicked(ByVal sender As Object, ByVal e As EventArgs)
        Me.PackageReportsCommand()
    End Sub


#Region " Validation Reports Methods "
    Private Sub cmnReports_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmnReports.Popup
        If Not Me.mPackageNavigator.SelectedNode Is Nothing AndAlso Me.mPackageNavigator.SelectedNode.FileID > 0 Then
            Me.mnuViewReport.Visible = True
            Me.mnuCrossTabs.Visible = True
        Else
            Me.mnuViewReport.Visible = False
            Me.mnuCrossTabs.Visible = False
        End If
    End Sub

    Private Sub mnuViewReport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuViewReport.Click
        ViewReportCommand()
    End Sub
    Private Sub ViewReportCommand()
        If Not Me.mPackageNavigator.SelectedNode Is Nothing AndAlso Me.mPackageNavigator.SelectedNode.FileID > 0 Then
            Me.LoadReport(Me.mPackageNavigator.SelectedNode.FileID)
        End If
    End Sub

    Private Sub mnuCrossTabs_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuCrossTabs.Click
        CrossTabsCommand()
    End Sub
    Private Sub CrossTabsCommand()
        If Not Me.mPackageNavigator.SelectedNode Is Nothing AndAlso Me.mPackageNavigator.SelectedNode.FileID > 0 Then
            Dim fileID As Integer = mPackageNavigator.SelectedNode.FileID
            Dim frmInput As New frmInputDialog(frmInputDialog.InputType.ListBox)
            Dim tbl As DataTable = PackageDB.GetFileMetaFields(fileID)
            Dim row As DataRow
            For Each row In tbl.Rows
                frmInput.Items.Add(row("strTable_nm").ToString & row("strField_nm").ToString)
            Next
            frmInput.Title = "Cross Tab Fields"
            frmInput.Prompt = "Please select the fields to be added to the cross tab report."

            Dim tblResults As DataTable
            Dim field As String
            Dim fields As String = ""

            frmInput.MultiSelect = True

            If frmInput.ShowDialog() = Windows.Forms.DialogResult.OK Then
                If frmInput.SelectedItems.Count > 0 Then
                    For Each field In frmInput.SelectedItems
                        fields &= field & ","
                    Next

                    If fields.Length > 0 Then
                        fields = fields.Substring(0, fields.Length - 1)
                    End If
                    tblResults = PackageDB.GetCrossTabResults(fileID, fields)
                    Dim results As New frmDataGrid(tblResults)
                    results.Caption = "Cross Tab Report"
                    results.Show()
                End If
            End If
        End If

    End Sub

    Public Sub PackageReportsCommand()
        Dim frmPackage As New frmPackageSelect(True)
        If frmPackage.ShowDialog() = Windows.Forms.DialogResult.OK Then
            Me.LoadPackageReport(frmPackage.PackageID, frmPackage.Version)
        End If
    End Sub

#End Region

End Class
