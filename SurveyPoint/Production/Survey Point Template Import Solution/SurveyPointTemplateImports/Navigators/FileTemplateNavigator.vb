Imports Nrc.SurveyPoint.Library

Public Class FileTemplateNavigator

    Public Event FileTemplateUserAction As EventHandler(Of FileTemplateSelectedEventArgs)
#Region " Fields "
    Private mFileTemplates As SPTI_FileTemplateCollection = Nothing
    Private mFileTemplateID As Integer = 0
#End Region
#Region " Event Handlers "
    ''' <summary>bind the data grid and fire event to the section.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub FileTemplateNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        LoadTemplates()
    End Sub
    ''' <summary>Delete the selected file template.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdFileTemplateDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdFileTemplateDelete.Click
        If MessageBox.Show("Are you sure you wish to delete the selected file templates?", "Warning", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
            Dim fileTemplate As SPTI_FileTemplate
            Dim rowHandle As Integer = 0
            For Each i As Integer In Me.grdFileTemplatesView.GetSelectedRows
                rowHandle = i
                fileTemplate = TryCast(Me.grdFileTemplatesView.GetRow(rowHandle), SPTI_FileTemplate)
                If Not fileTemplate Is Nothing Then
                    If SPTI_FileTemplate.CheckIfFileTemplateExistsInExportDefinition(fileTemplate.FileTemplateID) Then
                        MessageBox.Show("Unable to delete file template.  It is current being used by one or more export definitions.", "Delete Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Exit Sub
                    End If
                    SPTI_FileTemplate.DeleteTemplateIncludingChildren(fileTemplate.FileTemplateID)
                End If
            Next
            LoadTemplates()
        End If
    End Sub
    ''' <summary>Create a new file template</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdFileTemplateAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdFileTemplateAdd.Click
        Dim dlg As New FileTemplateAdd(0, "")
        If dlg.ShowDialog() = DialogResult.OK Then
            LoadTemplates()
        End If
    End Sub
    Private Sub bsFileTemplates_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles bsFileTemplates.CurrentChanged
        Dim template As SPTI_FileTemplate = TryCast(Me.bsFileTemplates.Current, SPTI_FileTemplate)
        If Not template Is Nothing Then
            RaiseEvent FileTemplateUserAction(Me, New FileTemplateSelectedEventArgs(template.FileTemplateID, FileTemplateActions.Selected))
        End If
    End Sub
    ''' <summary>Copies the existing template into a new template</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmdFileTemplateCopy_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdFileTemplateCopy.Click
        Dim oldTemplate As SPTI_FileTemplate
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdFileTemplatesView.GetSelectedRows
            rowHandle = i
        Next
        oldTemplate = TryCast(Me.grdFileTemplates.DefaultView.GetRow(rowHandle), SPTI_FileTemplate)
        If Not oldTemplate Is Nothing Then
            Dim dlg As New FileTemplateAdd(oldTemplate.FileTemplateID, oldTemplate.Name)
            If dlg.ShowDialog = DialogResult.OK Then
                LoadTemplates()
            End If
        End If
    End Sub
#End Region
#Region " Private Methods "
    ''' <summary>Resets the file template grid and fires event to the section.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub LoadTemplates()
        Me.mFileTemplates = Nrc.SurveyPoint.Library.SPTI_FileTemplate.GetAll()
        Me.bsFileTemplates.DataSource = Me.mFileTemplates
        Dim fileTemplate As SPTI_FileTemplate = Nothing
        fileTemplate = TryCast(Me.bsFileTemplates.Current, SPTI_FileTemplate)
        If Not fileTemplate Is Nothing Then
            RaiseEvent FileTemplateUserAction(Me, New FileTemplateSelectedEventArgs(fileTemplate.FileTemplateID, FileTemplateActions.Selected))
        End If
    End Sub
#End Region

End Class
