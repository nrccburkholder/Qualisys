Imports NRC.DataMart.WebDocumentManager.Library
Public Class RollbackMassPosts
    Private WithEvents mDataSetFilterStartDate As ToolStripDateTimePicker
    Private WithEvents mDataSetFilterEndDate As ToolStripDateTimePicker
    Private mSelectedBatch As DocumentBatch
    Private mBatches As DocumentBatchCollection

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeBatchesToolStrip()
    End Sub

#Region "Private Methods"
    ''' <summary>
    ''' Adds the date filters for datasets to the newSampleset tool strip
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub InitializeBatchesToolStrip()
        Dim endDate As Date = Date.Today
        Dim startDate As Date = endDate.AddDays(-14)
        Dim lbl As ToolStripLabel

        'First remove the datasets filter button.  We will readd at the end
        Me.BatchesToolStrip.Items.Clear()

        lbl = New ToolStripLabel("Batches created between")
        lbl.Alignment = ToolStripItemAlignment.Left
        lbl.Overflow = ToolStripItemOverflow.Never
        Me.BatchesToolStrip.Items.Add(lbl)

        mDataSetFilterStartDate = New ToolStripDateTimePicker
        mDataSetFilterStartDate.Format = DateTimePickerFormat.Short
        mDataSetFilterStartDate.Alignment = ToolStripItemAlignment.Left
        mDataSetFilterStartDate.Overflow = ToolStripItemOverflow.Never
        mDataSetFilterStartDate.ToolTipText = "From Date"
        mDataSetFilterStartDate.Value = startDate
        Me.BatchesToolStrip.Items.Add(mDataSetFilterStartDate)

        lbl = New ToolStripLabel("and")
        lbl.Alignment = ToolStripItemAlignment.Left
        lbl.Overflow = ToolStripItemOverflow.Never
        Me.BatchesToolStrip.Items.Add(lbl)

        mDataSetFilterEndDate = New ToolStripDateTimePicker
        mDataSetFilterEndDate.Format = DateTimePickerFormat.Short
        mDataSetFilterEndDate.Alignment = ToolStripItemAlignment.Left
        mDataSetFilterEndDate.Overflow = ToolStripItemOverflow.Never
        mDataSetFilterEndDate.ToolTipText = "To Date"
        mDataSetFilterEndDate.Value = endDate
        Me.BatchesToolStrip.Items.Add(mDataSetFilterEndDate)

        'Readd the filter button
        Me.BatchesToolStrip.Items.Add(Me.FilterButton)
        Me.BatchesToolStrip.Items.Add(Me.ToolStripSeparator1)
        Me.BatchesToolStrip.Items.Add(Me.ShowDocumentsButton)

    End Sub

    Private Sub PopulateBatchesGrid()
        'Add 1 day to the end of the filter so we get batches for the entire end date
        mBatches = DocumentBatch.GetByDateRange(Me.mDataSetFilterStartDate.Value, Me.mDataSetFilterEndDate.Value.AddDays(1))
        Me.NoBatchesLabel.Visible = (mBatches.Count = 0)
        Me.DocumentBatchBindingSource.DataSource = mBatches
    End Sub

    Private Sub PopulateDocumentsGrid()
        Dim massPostList As MassPostDocumentCollection = MassPostDocument.FindAccessibleDocuments(mSelectedBatch.Id, CurrentUser.OrgUnitsList, CurrentUser.Member)
        If massPostList.Count > 0 Then
            'Get all of the documents that this user is authorized to delete
            Me.MassPostDocumentBindingSource.DataSource = massPostList
        Else
            Me.MassPostDocumentBindingSource.DataSource = Nothing
            MessageBox.Show("There are no documents posted for the selected batch or you do not" & vbCrLf & "have permission to rollback the documents in the selected batch.", "No Documents", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub
#End Region

#Region "Event Handlers"

    Private Sub FilterButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterButton.Click
        PopulateBatchesGrid()
    End Sub

    Private Sub ShowDocumentsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowDocumentsButton.Click
        If Me.BatchesGridView.FocusedRowHandle >= 0 Then
            mSelectedBatch = DirectCast(Me.BatchesGridView.GetRow(Me.BatchesGridView.FocusedRowHandle), DocumentBatch)
            PopulateDocumentsGrid()
            If Me.DocumentsGridView.RowCount > 0 Then
                RollBackButton.Enabled = True
            Else
                RollBackButton.Enabled = False
            End If
        End If
    End Sub

    Private Sub RollBackButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RollBackButton.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            'Delete all selected documents
            Dim document As MassPostDocument
            For Each i As Integer In Me.DocumentsGridView.GetSelectedRows
                document = DirectCast(Me.DocumentsGridView.GetRow(i), MassPostDocument)
                NRC.DataMart.WebDocumentManager.Library.Document.DeleteDocument(document.DocumentNodeId, CurrentUser.Member.MemberId, False)
            Next

            'Check to see if the batch has any more documents left;  If not, delete the batch
            If MassPostDocument.GetDocumentsByBatchId(mSelectedBatch.Id, CurrentUser.Member).Count = 0 Then
                mBatches.Remove(mSelectedBatch)
                mBatches.Save()
                PopulateBatchesGrid()
                Me.MassPostDocumentBindingSource.DataSource = Nothing
                Me.RollBackButton.Enabled = False
                mSelectedBatch = Nothing
            Else
                'Refresh the list to remove deleted items
                Me.PopulateDocumentsGrid()
            End If

        Catch ex As Exception
            Throw ex
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub
#End Region
End Class
