Imports Nrc.SurveyPoint.Library

Public Class ImportExportNavigator
    Public Event ExportDefintionUserAction As EventHandler(Of ExportDefintionSelectedEventArgs)
#Region " Fields "
    Private mExportDefintions As SPTI_ExportDefinitionCollection = Nothing
    Private mExportDefintionID As Integer = 0
#End Region
#Region " Event Handlers "
    Private Sub cmdTSNewImportExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdTSNewImportExport.Click
        Dim dlg As New ExportDefintionDialog(0, "")
        If dlg.ShowDialog() = DialogResult.OK Then
            LoadDefinitions()
        End If
    End Sub

    Private Sub cmdTSDeleteImportExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdTSDeleteImportExport.Click
        If MessageBox.Show("Are you sure you wish to delete the selected export definition", "Warning", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
            Dim def As SPTI_ExportDefinition
            Dim rowHandle As Integer = 0
            For Each i As Integer In Me.grdViewImportExport.GetSelectedRows
                rowHandle = i
                def = TryCast(Me.grdViewImportExport.GetRow(rowHandle), SPTI_ExportDefinition)
                If Not def Is Nothing Then
                    SPTI_ExportDefinition.DeleteExportDefIncludingChildren(def.ExportDefinitionID)
                End If
            Next
            LoadDefinitions()
        End If
    End Sub

    Private Sub cmdTSCopyImportExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdTSCopyImportExport.Click
        Dim oldDef As SPTI_ExportDefinition
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdViewImportExport.GetSelectedRows
            rowHandle = i
        Next
        oldDef = TryCast(Me.grdImportExport.DefaultView.GetRow(rowHandle), SPTI_ExportDefinition)
        If Not oldDef Is Nothing Then
            Dim dlg As New ExportDefintionDialog(oldDef.ExportDefinitionID, oldDef.Name)
            If dlg.ShowDialog = DialogResult.OK Then
                LoadDefinitions()
            End If
        End If
    End Sub

    Private Sub ImportExportNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        LoadDefinitions()
    End Sub
    Private Sub bsExportDefintions_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles bsExportDefintions.CurrentChanged
        Dim def As SPTI_ExportDefinition = TryCast(Me.bsExportDefintions.Current, SPTI_ExportDefinition)
        If Not def Is Nothing Then
            RaiseEvent ExportDefintionUserAction(Me, New ExportDefintionSelectedEventArgs(def.ExportDefinitionID, ExportDefinitionActions.Selected))
        End If
    End Sub
#End Region
#Region " Private Methods "
    Friend Sub LoadDefinitions()
        Me.mExportDefintions = Nrc.SurveyPoint.Library.SPTI_ExportDefinition.GetAll()
        Me.bsExportDefintions.DataSource = Me.mExportDefintions
        Dim def As SPTI_ExportDefinition = Nothing
        def = TryCast(Me.bsExportDefintions.Current, SPTI_ExportDefinition)
        If Not def Is Nothing Then
            RaiseEvent ExportDefintionUserAction(Me, New ExportDefintionSelectedEventArgs(def.ExportDefinitionID, ExportDefinitionActions.Selected))
        End If
    End Sub
#End Region
End Class
