''' <summary>To View reports user has to have "Report Viewer" or "Administrator" permission.</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ReportSection
    Inherits Section

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
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
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents browser As System.Windows.Forms.WebBrowser
    Friend WithEvents PaneCaption1 As Nrc.Framework.WinForms.PaneCaption
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.browser = New System.Windows.Forms.WebBrowser
        Me.PaneCaption1 = New Nrc.Framework.WinForms.PaneCaption
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = ""
        Me.SectionPanel1.Controls.Add(Me.browser)
        Me.SectionPanel1.Controls.Add(Me.PaneCaption1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = False
        Me.SectionPanel1.Size = New System.Drawing.Size(464, 472)
        Me.SectionPanel1.TabIndex = 3
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
        'ReportViewer
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "ReportViewer"
        Me.Size = New System.Drawing.Size(464, 472)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private WithEvents mNavigator As ReportsNavigator
    Public Sub LoadReport(ByVal report As SSRSReport)

        Dim URL As String
        Me.Cursor = Cursors.WaitCursor

        Try
            'Set the URL to the Reporting Services web server
            URL = String.Format("{0}{1}", Config.ReportServer, report.ReportName)
            Me.browser.Navigate(URL)

        Catch ex As Exception
            Globals.ReportException(ex, "Report Exception")
            MessageBox.Show(ex.Message, "Report Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mNavigator = TryCast(navCtrl, ReportsNavigator)
        If mNavigator Is Nothing Then
            Throw New ArgumentException("The Report section control expects a navigator of type 'PackageNavigator'")
        End If
    End Sub

    Public Overrides Sub ActivateSection()
        If mNavigator IsNot Nothing Then
        End If
    End Sub

    Public Overrides Sub InactivateSection()
        If mNavigator IsNot Nothing Then
            'Cleanup or check for a change
        End If

    End Sub

    Public Overrides Function AllowInactivate() As Boolean
        Return True
    End Function

    Private mSelectedReport As SSRSReport
    ''' <summary>Keeps the currently selected report for future use.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property SelectedReport() As SSRSReport
        Get
            Return mSelectedReport
        End Get
        Set(ByVal value As SSRSReport)
            mSelectedReport = value
        End Set
    End Property

    ''' <summary>To give users a chance to go back from subreports to the main report.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mNavigator_NavigateBackClicked(ByVal sender As Object, ByVal e As EventArgs) Handles mNavigator.NavigateBackClicked
        Me.browser.GoBack()
    End Sub

    Private Sub mNavigator_NavigateForwardClicked(ByVal sender As Object, ByVal e As EventArgs) Handles mNavigator.NavigateForwardClicked
        Me.browser.GoForward()
    End Sub

    ''' <summary>Reacts on a change of a selected report on the listbox on the reportsnavigator
    ''' and loads the selected report. </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As ReportsEventArgs) Handles mNavigator.SelectionChanged
        If e.Report IsNot Nothing Then
            SelectedReport = e.Report
            Me.LoadReport(SelectedReport)
        End If
    End Sub
End Class
