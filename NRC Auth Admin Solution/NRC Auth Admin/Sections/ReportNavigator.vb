Imports Nrc.NrcAuthAdmin.ReportService

Public Class ReportNavigator

    Private mSelectedButton As ToolStripButton

#Region " ReportSelected Event "
    Public Class ReportSelectedEventArgs
        Inherits System.EventArgs

        Private mReport As CatalogItem
        Public ReadOnly Property Report() As CatalogItem
            Get
                Return mReport
            End Get
        End Property

        Public Sub New(ByVal report As CatalogItem)
            mReport = report
        End Sub
    End Class
    Public Event ReportSelected As EventHandler(Of ReportSelectedEventArgs)
    Protected Overridable Sub OnReportSelected(ByVal e As ReportSelectedEventArgs)
        RaiseEvent ReportSelected(Me, e)
    End Sub
#End Region

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
    End Sub

    Private Sub ReportNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.LoadWaitingMessage()
        Me.BackgroundReportLoader.RunWorkerAsync()
    End Sub

    Private Sub LoadWaitingMessage()
        Me.ReportsToolStrip.Visible = False
        Me.LoadingLabel.Visible = True
    End Sub

    Private Function GetReportButtons() As ToolStripButton()
        Dim buttons As New List(Of ToolStripButton)
        Dim rs As New ReportingService
        rs.Url = String.Format("http://{0}/ReportServer/ReportService.asmx", Config.ReportServer)
        Dim reportPath As String = Config.ReportFolder

        rs.Credentials = System.Net.CredentialCache.DefaultCredentials
        Dim catalogItems() As ReportService.CatalogItem
        catalogItems = rs.ListChildren(reportPath, True)

        For Each item As CatalogItem In catalogItems
            If item.Type = ItemTypeEnum.Report Then

                Dim button As New ToolStripButton(item.Name, My.Resources.Document16, AddressOf ReportButtonClick)
                button.Tag = item
                button.ImageAlign = ContentAlignment.MiddleLeft
                buttons.Add(button)
            End If
        Next

        Return buttons.ToArray
    End Function

    Private Sub ReportButtonClick(ByVal sender As Object, ByVal e As EventArgs)
        Dim button As ToolStripButton = TryCast(sender, ToolStripButton)
        If button IsNot Nothing Then
            If button Is mSelectedButton Then
                Exit Sub
            End If
            If mSelectedButton IsNot Nothing Then
                mSelectedButton.Checked = False
            End If
            mSelectedButton = button
            mSelectedButton.Checked = True

            Dim reportItem As CatalogItem = TryCast(mSelectedButton.Tag, CatalogItem)
            If reportItem IsNot Nothing Then
                Me.OnReportSelected(New ReportSelectedEventArgs(reportItem))
            End If
        End If
    End Sub

    Private Sub BackgroundReportLoader_DoWork(ByVal sender As System.Object, ByVal e As System.ComponentModel.DoWorkEventArgs) Handles BackgroundReportLoader.DoWork
        Dim buttons() As ToolStripButton = Me.GetReportButtons()
        e.Result = buttons
    End Sub

    Private Sub BackgroundReportLoader_RunWorkerCompleted(ByVal sender As Object, ByVal e As System.ComponentModel.RunWorkerCompletedEventArgs) Handles BackgroundReportLoader.RunWorkerCompleted
        If e.Error IsNot Nothing Then
            Me.LoadingLabel.Text = "Error loading report:" & Environment.NewLine & e.Error.Message
        Else
            Dim buttons() As ToolStripButton = TryCast(e.Result, ToolStripButton())
            If buttons IsNot Nothing Then
                For Each button As ToolStripButton In buttons
                    Me.ReportsToolStrip.Items.Add(button)
                Next
            End If

            Me.LoadingLabel.Visible = False
            Me.ReportsToolStrip.Visible = True
        End If
    End Sub
End Class

