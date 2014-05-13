Imports NRC.Qualisys.QualisysDataEntry.Library

Public Class ucFinalize
    Inherits System.Windows.Forms.UserControl

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
    Friend WithEvents spnFinalize As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents lblBatches As System.Windows.Forms.Label
    Friend WithEvents btnFinalize As System.Windows.Forms.Button
    Friend WithEvents cblBatches As System.Windows.Forms.CheckedListBox
    Friend WithEvents fbdFolders As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents btnRefresh As System.Windows.Forms.Button
    Friend WithEvents pbProgress As System.Windows.Forms.ProgressBar
    Friend WithEvents btnDelete As System.Windows.Forms.Button
    Friend WithEvents lblStatus As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.spnFinalize = New Nrc.Framework.WinForms.SectionPanel
        Me.lblStatus = New System.Windows.Forms.Label
        Me.pbProgress = New System.Windows.Forms.ProgressBar
        Me.btnDelete = New System.Windows.Forms.Button
        Me.btnFinalize = New System.Windows.Forms.Button
        Me.lblBatches = New System.Windows.Forms.Label
        Me.cblBatches = New System.Windows.Forms.CheckedListBox
        Me.btnRefresh = New System.Windows.Forms.Button
        Me.fbdFolders = New System.Windows.Forms.FolderBrowserDialog
        Me.spnFinalize.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnFinalize
        '
        Me.spnFinalize.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.spnFinalize.Caption = "Finalization"
        Me.spnFinalize.Controls.Add(Me.lblStatus)
        Me.spnFinalize.Controls.Add(Me.pbProgress)
        Me.spnFinalize.Controls.Add(Me.btnDelete)
        Me.spnFinalize.Controls.Add(Me.btnFinalize)
        Me.spnFinalize.Controls.Add(Me.lblBatches)
        Me.spnFinalize.Controls.Add(Me.cblBatches)
        Me.spnFinalize.Controls.Add(Me.btnRefresh)
        Me.spnFinalize.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnFinalize.Location = New System.Drawing.Point(0, 0)
        Me.spnFinalize.Name = "spnFinalize"
        Me.spnFinalize.Padding = New System.Windows.Forms.Padding(1)
        Me.spnFinalize.ShowCaption = True
        Me.spnFinalize.Size = New System.Drawing.Size(560, 552)
        Me.spnFinalize.TabIndex = 0
        '
        'lblStatus
        '
        Me.lblStatus.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblStatus.Enabled = False
        Me.lblStatus.Location = New System.Drawing.Point(32, 424)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(496, 56)
        Me.lblStatus.TabIndex = 6
        '
        'pbProgress
        '
        Me.pbProgress.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pbProgress.Enabled = False
        Me.pbProgress.Location = New System.Drawing.Point(32, 384)
        Me.pbProgress.Name = "pbProgress"
        Me.pbProgress.Size = New System.Drawing.Size(496, 23)
        Me.pbProgress.TabIndex = 5
        '
        'btnDelete
        '
        Me.btnDelete.Location = New System.Drawing.Point(202, 328)
        Me.btnDelete.Name = "btnDelete"
        Me.btnDelete.Size = New System.Drawing.Size(75, 23)
        Me.btnDelete.TabIndex = 3
        Me.btnDelete.Text = "Delete"
        '
        'btnFinalize
        '
        Me.btnFinalize.Location = New System.Drawing.Point(113, 328)
        Me.btnFinalize.Name = "btnFinalize"
        Me.btnFinalize.Size = New System.Drawing.Size(75, 23)
        Me.btnFinalize.TabIndex = 3
        Me.btnFinalize.Text = "Finalize..."
        '
        'lblBatches
        '
        Me.lblBatches.Location = New System.Drawing.Point(16, 56)
        Me.lblBatches.Name = "lblBatches"
        Me.lblBatches.Size = New System.Drawing.Size(176, 23)
        Me.lblBatches.TabIndex = 2
        Me.lblBatches.Text = "Batches Ready for Finalization:"
        '
        'cblBatches
        '
        Me.cblBatches.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cblBatches.CheckOnClick = True
        Me.cblBatches.ColumnWidth = 400
        Me.cblBatches.Location = New System.Drawing.Point(16, 80)
        Me.cblBatches.MultiColumn = True
        Me.cblBatches.Name = "cblBatches"
        Me.cblBatches.Size = New System.Drawing.Size(528, 228)
        Me.cblBatches.TabIndex = 1
        '
        'btnRefresh
        '
        Me.btnRefresh.Location = New System.Drawing.Point(24, 328)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(75, 23)
        Me.btnRefresh.TabIndex = 3
        Me.btnRefresh.Text = "Refresh List"
        '
        'ucFinalize
        '
        Me.Controls.Add(Me.spnFinalize)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ucFinalize"
        Me.Size = New System.Drawing.Size(560, 552)
        Me.spnFinalize.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Event Hanlders "
    Private Sub ucFinalize_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        PopulateBatches()
    End Sub

    Private Sub btnRefresh_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        PopulateBatches()
    End Sub

    Private Sub btnFinalize_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFinalize.Click
        FinalizeBatches()
    End Sub

    Private Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        DeleteBatches()
    End Sub
#End Region

#Region " Private Methods "
    'Populate the check box list of batches that are ready for finalization
    Private Sub PopulateBatches()
        'Get the batch list
        Dim tblBatches As DataTable = Batch.GetBatchesToFinalize
        Dim row As DataRow
        Dim b As Batch

        cblBatches.Items.Clear()
        cblBatches.DisplayMember = "BatchName"

        'Add each batch to the list
        For Each row In tblBatches.Rows
            b = Batch.LoadFromDB(CInt(row("Batch_id")))
            cblBatches.Items.Add(b, False)
        Next

        tblBatches.Dispose()
    End Sub

    'Finalize the selected batches
    Private Sub FinalizeBatches()
        Dim b As Batch

        'If no batches are selected then exit out
        If cblBatches.CheckedItems.Count = 0 Then Exit Sub

        'Show the folder selection dialog
        fbdFolders.Description = "Select a folder where the finalized data will be stored."
        fbdFolders.SelectedPath = Batch.DefaultFinalizeFolder
        If fbdFolders.ShowDialog = DialogResult.OK Then
            Try
                'Show wait cursor and initialize controls
                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                lblStatus.Enabled = True
                pbProgress.Enabled = True
                pbProgress.Maximum = cblBatches.CheckedItems.Count

                'For each batch, finalize it to the specified path
                For Each b In cblBatches.CheckedItems
                    b.FinalizeBatch(fbdFolders.SelectedPath & "\" & b.FinalizedFileName, CurrentUser.LoginName)
                    pbProgress.Value += 1
                Next

                'Show the batch count just to give confirmation that everything finished
                lblStatus.Text = cblBatches.CheckedItems.Count & " batches finalized successfully."

                'Repopulate the list
                PopulateBatches()
            Catch ex As Exception
                'Display message and user exception report
                lblStatus.Text = "Finalization Exception:  " & ex.Message
                ReportException(ex, "Finalization Exception")
            Finally
                'clean up
                Windows.Forms.Cursor.Current = Cursors.Default
                lblStatus.Enabled = False
                pbProgress.Enabled = False
                pbProgress.Value = 0
            End Try
        End If
    End Sub

    Private Sub DeleteBatches()
        Dim b As Batch

        'If no batches are selected then exit out
        If cblBatches.CheckedItems.Count = 0 Then Exit Sub

        If MessageBox.Show("Are you sure you want to delete the selected batches?", "Confirm Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
            Try
                'Show wait cursor and initialize controls
                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                lblStatus.Enabled = True
                pbProgress.Enabled = True
                pbProgress.Maximum = cblBatches.CheckedItems.Count

                'For each batch, delete it
                For Each b In cblBatches.CheckedItems
                    Batch.DeleteBatch(b.BatchID)
                    pbProgress.Value += 1
                Next

                'Show the batch count just to give confirmation that everything finished
                lblStatus.Text = cblBatches.CheckedItems.Count & " batches deleted."

                'Repopulate the list
                PopulateBatches()
            Catch ex As Exception
                'Display message and user exception report
                lblStatus.Text = "Delete Batch Error:  " & ex.Message
                ReportException(ex, "Delete Batch Error")
            Finally
                'clean up
                Windows.Forms.Cursor.Current = Cursors.Default
                lblStatus.Enabled = False
                pbProgress.Enabled = False
                pbProgress.Value = 0
            End Try
        End If

    End Sub

#End Region


End Class
