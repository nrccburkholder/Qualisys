Imports Nrc.SurveyPoint.Library

Public Class ExportDefinitionStatusDialog
#Region " Private Fields "
    Dim WithEvents mExportDef As SPTI_ExportDefinition = Nothing
    Public Event NewMessage As EventHandler(Of ExportMessageArgs)
    Public Event ExportProgress As EventHandler(Of ExportFileProgress)
    Dim mObjectMessages As ExportObjectMessageCollection = New ExportObjectMessageCollection
#End Region
#Region " Constructors "
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
    Public Sub New(ByRef exportDef As SPTI_ExportDefinition)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.mExportDef = exportDef
    End Sub
#End Region
#Region " Private Events "    
    Private Sub ExportDefinitionStatusDialog_Shown(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Shown
        Me.ToolStripStatusLabel1.Text = ""
        Me.mExportDef.RunExport()
    End Sub
    Private Sub cmdClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClose.Click
        Me.Close()
    End Sub
#End Region

#Region " Public Events "
    Public Sub HandleMessage(ByVal sender As Object, ByVal e As ExportMessageArgs) Handles mExportDef.NewMessage
        UpdateMessages(e.ExportObjectMessage)
    End Sub
    Public Sub HandleProgress(ByVal sender As Object, ByVal e As ExportFileProgress) Handles mExportDef.ExportProgress
        UpdateProgressBar(e.ProgressMessage, e.PercentComplete, e.Abort)
    End Sub
#End Region
#Region " Helper Methods "
    Private Sub UpdateMessages(ByVal exportObjectMessage As ExportObjectMessage)
        Me.mObjectMessages.Add(exportObjectMessage)
        Me.bsExportMessages.DataSource = Me.mObjectMessages
        Application.DoEvents()
    End Sub
    Private Sub UpdateProgressBar(ByVal message As String, ByVal percentComplete As Integer, ByVal abort As Boolean)
        If abort Then
            Me.ToolStripProgressBar1.Visible = False
            Me.ToolStripStatusLabel1.Text = ""
        Else
            Me.ToolStripProgressBar1.Visible = True
            ToolStripStatusLabel1.Text = message
            Me.ToolStripProgressBar1.Value = percentComplete
        End If
        Application.DoEvents()
    End Sub
#End Region
    
End Class
