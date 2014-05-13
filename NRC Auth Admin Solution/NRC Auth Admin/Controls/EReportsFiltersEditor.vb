Imports Nrc.DataMart.MySolutions.Library
Imports System.Collections.ObjectModel
Public Class EReportsFiltersEditor

    Private mStudyId As Integer = 0
    Private WithEvents mColumnList As StudyTableColumnList

    Public ReadOnly Property ColumnList() As StudyTableColumnList
        Get
            Return mColumnList
        End Get
    End Property

    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            mStudyId = value
        End Set
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            If mColumnList IsNot Nothing Then
                Return (mColumnList.IsDirty)
            Else
                Return False
            End If
        End Get
    End Property

#Region " Public Methods "
    Public Sub Populate(ByVal columns As StudyTableColumnList, ByVal studyId As Integer)
        mStudyId = studyId
        mColumnList = columns

        'Take a snapshot of the object
        mColumnList.BeginEdit()
        Me.StudyTableColumnBindingSource.DataSource = mColumnList

        'Ensure that first row is selected
        'colName.SortOrder = DevExpress.Data.ColumnSortOrder.Ascending
        Me.EReportsFiltersGridView.FocusedRowHandle = 0
        Me.EReportsFiltersGridView.BestFitColumns()

        ResetToStartingState()
    End Sub

    Public Sub Clear()
        mStudyId = Nothing
        mColumnList = Nothing
        Me.StudyTableColumnBindingSource.DataSource = Nothing
    End Sub

    Public Sub Save()
        If Me.EReportsFiltersGridView.IsEditing Then
            If Me.EReportsFiltersGridView.ValidateEditor Then
                Me.EReportsFiltersGridView.CloseEditor()
            Else
                MessageBox.Show("You cannot save until all errors are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Exit Sub
            End If
        End If

        Me.Cursor = Cursors.WaitCursor
        Try
            Me.StudyTableColumnBindingSource.RaiseListChangedEvents = False
            mColumnList.ApplyEdit()
            mColumnList.Save()

            ResetToStartingState()
        Catch ex As Exception
            Globals.ReportException(ex, "Error Saving Changes")
        Finally
            Me.StudyTableColumnBindingSource.RaiseListChangedEvents = True
            Me.StudyTableColumnBindingSource.ResetBindings(False)
            Me.Cursor = Cursors.Default
        End Try
    End Sub
#End Region

#Region "Private Methods"

    Private Sub ToggleButtons()
        'Toggle the Save button based on the validation value
        Me.SaveButton.Enabled = Me.mColumnList.IsSavable
        Me.CancelChangesButton.Enabled = Me.mColumnList.IsDirty
    End Sub

    Private Sub ResetToStartingState()
        'Reset to starting state
        Me.SaveButton.Enabled = False
    End Sub

    Private Sub SaveGridLayoutProperties()
        Using ms As New IO.MemoryStream
            EReportsFiltersGridView.SaveLayoutToStream(ms)
            Dim data() As Byte = ms.ToArray
            My.Settings.eReportsFilterGridSettings = data
        End Using
    End Sub

    Private Sub RestoreGridLayoutProperties()
        Dim data As Byte() = DirectCast(My.Settings.eReportsFilterGridSettings, Byte())
        If data IsNot Nothing Then
            Using ms As New IO.MemoryStream(data)
                EReportsFiltersGridView.RestoreLayoutFromStream(ms)
            End Using
        End If
    End Sub

    Private Sub ParentFormClosing(ByVal sender As Object, ByVal e As System.EventArgs)
        SaveGridLayoutProperties()
    End Sub
#End Region

#Region "private events"
    Private Sub EReportsFiltersEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RestoreGridLayoutProperties()
        If CurrentUser.AllowEReportsCalculatedFieldsAdditions = False Then Me.AddCalculatedColumnButton.Visible = False
        AddHandler Globals.MainFormClosing, AddressOf ParentFormClosing
    End Sub

    Private Sub CancelChangesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelChangesButton.Click
        Me.mColumnList.CancelEdit()
        Me.mColumnList.BeginEdit()
    End Sub

    Private Sub SaveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveButton.Click
        Save()
    End Sub

    Private Sub mColumnList_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles mColumnList.ListChanged
        ToggleButtons()
    End Sub

    Private Sub StudyTableColumnBindingSource_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles StudyTableColumnBindingSource.ListChanged
        If mColumnList IsNot Nothing Then ToggleButtons()
    End Sub

    Private Sub CheckEditRepositoryItem_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles CheckEditRepositoryItem.CheckedChanged
        With EReportsFiltersGridView
            If .IsEditing Then
                If .ValidateEditor Then
                    .CloseEditor()
                End If
            End If
        End With
    End Sub

    Private Sub EReportsFiltersGridView_FocusedRowChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.FocusedRowChangedEventArgs) Handles EReportsFiltersGridView.FocusedRowChanged
        If CBool(Me.EReportsFiltersGridView.GetRowCellValue(e.FocusedRowHandle, Me.colIsCalculated.FieldName)) AndAlso CurrentUser.AllowEReportsCalculatedFieldsAdditions Then
            colFormula.OptionsColumn.ReadOnly = False
        Else
            Try
                colFormula.OptionsColumn.ReadOnly = True
            Catch argException As ArgumentOutOfRangeException
                'Do Nothing.  Grid throws this error when reloading the grid sometimes, and
                'I haven't been able to determine why.
            Catch ex As Exception
                Throw
            End Try
        End If
    End Sub

    Private Sub ExportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportButton.Click
        FileDialog.FileName = ""
        If FileDialog.ShowDialog = DialogResult.OK Then
            Select Case FileDialog.FilterIndex
                Case 1
                    Me.EReportsFiltersGridView.ExportToXls(FileDialog.FileName)
                Case 2
                    Me.EReportsFiltersGridView.ExportToHtml(FileDialog.FileName)
                Case 3
                    Me.EReportsFiltersGridView.ExportToText(FileDialog.FileName)
            End Select
            System.Diagnostics.Process.Start(FileDialog.FileName)
        End If
    End Sub

    Private Sub AddCalculatedColumnButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles AddCalculatedColumnButton.Click
        Dim calcColumnDialog As New AddCalculatedColumnDialog(Me.StudyId)
        If calcColumnDialog.ShowDialog() = DialogResult.OK Then
            mColumnList.Add(calcColumnDialog.NewColumn)
            'Me.EReportsGridView.RefreshData()
        End If

    End Sub
#End Region

End Class
