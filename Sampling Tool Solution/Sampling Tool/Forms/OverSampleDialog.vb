''' <summary>This dialog form is to give user a chance to confirm oversampling 
''' and HCAPS unit oversampling. The user has to check the checkboxes next to the surveys 
''' where oversampling is intentional.</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class OverSampleDialog
    Dim mOverSampleRows As New Collection(Of SampleDefinition)

    ''' <summary>Extract Oversampled objects and store it in mOverSampleRows collection to 
    ''' display in the grid for editing.</summary>
    ''' <param name="OverSamples"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal OverSamples As Collection(Of SampleDefinition))

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        For Each item As SampleDefinition In OverSamples
            If item.IsOverSample Then
                mOverSampleRows.Add(item)
            End If
        Next
        Me.bsOverSampleData.DataSource = mOverSampleRows
        Me.colHCAPSOverSample.ReadOnly = Not CurrentUser.CanOversampleHCAHPS
    End Sub

    ''' <summary>  If this is a checkbox cell then commit changes right away so we can handle. 
    '''   call the checkChanged sub
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub dgvOverSample_CurrentCellDirtyStateChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles dgvOverSample.CurrentCellDirtyStateChanged
        Dim checkBoxCell As DataGridViewCheckBoxCell = TryCast(Me.dgvOverSample.CurrentCell, DataGridViewCheckBoxCell)
        If checkBoxCell IsNot Nothing Then
            Me.dgvOverSample.CommitEdit(DataGridViewDataErrorContexts.Commit)
            Me.DataGridViewCheckBox_CheckedChanged(checkBoxCell)
        End If
    End Sub
    ''' <summary>if OverSample checkbox is checked then allow Editing "HCAPS Oversample" checkbox.
    ''' if Oversample checkbox is unchecked then "HCAPS Oversample" 
    ''' is not an option (should be unchecked also).
    ''' </summary>
    ''' <param name="cell"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub DataGridViewCheckBox_CheckedChanged(ByVal cell As DataGridViewCheckBoxCell)
        'Handle the SpecifyDates column 
        If cell.ColumnIndex = Me.colOverSample.Index Then
            Dim row As DataGridViewRow = dgvOverSample.CurrentRow
            Dim currentOversample As SampleDefinition = TryCast(row.DataBoundItem, SampleDefinition)
            Dim HCAPSOverSampleCell As DataGridViewCell = row.Cells("colHCAPSOverSample")
            Dim isOversample As Boolean = DirectCast(cell.Value, Boolean)
            HCAPSOverSampleCell.ReadOnly = (Not CurrentUser.CanOversampleHCAHPS) Or (Not isOversample) Or (Not currentOversample.Survey.AllowOverSample) 'IsHCAHPS Then 'Possible TODO: create separate property for AllowDoOverSample CJB 7/3/2014
            If Not isOversample Then
                HCAPSOverSampleCell.Value = False
            End If
        End If
    End Sub

    ''' <summary>Selection is made and it's ok to proceed. The dialog user can use the same 
    ''' collection of SampleDefinition objects to retrieve oversample confirmation information.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub btnOK_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

End Class