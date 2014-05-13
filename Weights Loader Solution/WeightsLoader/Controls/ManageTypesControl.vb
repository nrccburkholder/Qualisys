Imports NRC.DataMart.Library
Public Class ManageTypesControl
#Region "private Fields"
    Private mWeightTypes As Collection(Of WeightType)

#End Region

#Region "Public Constructors"
    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        MyBase.Title = "Manage Weight Types"
    End Sub
#End Region

#Region "Private Methods"
    Private Sub PopulateCategoriesGrid()
        Dim newRowNumber As Integer
        Me.TypesDataGrid.Rows.Clear()
        mWeightTypes = WeightType.GetWeightTypes
        For Each type As WeightType In mWeightTypes
            newRowNumber = Me.TypesDataGrid.Rows.Add(type.Name, type.ExportColumnName)
            Me.TypesDataGrid.Rows(newRowNumber).Tag = type
        Next
        Me.UpdateRowNumbers()
    End Sub

    Private Sub AddTypeRows()
        Dim newType As WeightType
        Dim NewCategories As New Collection(Of WeightType)
        Dim newRowNumber As Integer

        newType = New WeightType()
        mWeightTypes.Add(newType)
        newRowNumber = Me.TypesDataGrid.Rows.Add(newType.Name, newType.ExportColumnName)
        Me.TypesDataGrid.Rows(newRowNumber).Tag = newType

        Me.TypesDataGrid.CurrentCell = Me.TypesDataGrid.Rows(newRowNumber).Cells(0)
        Me.TypesDataGrid.BeginEdit(True)
        UpdateRowNumbers()
        ValidateRow(Me.TypesDataGrid.Rows(newRowNumber))
    End Sub

    Private Sub ToggleRenameEnabled()
        Me.RenameTypeButton.Enabled = (Me.TypesDataGrid.SelectedRows.Count = 1)
        Me.RenameTypeToolContextMenuItem.Enabled = (Me.TypesDataGrid.SelectedRows.Count = 1)
    End Sub

    Private Sub ToggleDeleteEnabled()
        Me.DeleteTypeButton.Enabled = (Me.TypesDataGrid.SelectedRows.Count > 0)
        Me.DeleteTypeToolStripMenuItem.Enabled = (Me.TypesDataGrid.SelectedRows.Count > 0)
    End Sub

    Private Sub UpdateRowNumbers()
        For Each row As DataGridViewRow In Me.TypesDataGrid.Rows
            row.HeaderCell.Value = CStr(row.Index + 1)
        Next
    End Sub

    Private Sub DeleteType()
        Dim message As String = ""
        For Each row As DataGridViewRow In Me.TypesDataGrid.SelectedRows
            Dim type As WeightType = DirectCast(row.Tag, WeightType)
            If type.IsDeletable Then
                type.NeedsDelete = True
                Me.TypesDataGrid.Rows.Remove(row)
            Else
                message += type.Name + " could not be deleted because weights were previously loaded for it" + vbCrLf
            End If
        Next

        If message.Length > 0 Then MessageBox.Show(message, "Cannot Delete", MessageBoxButtons.OK, MessageBoxIcon.Information)

        UpdateRowNumbers()
        ToggleDeleteEnabled()
    End Sub

    Private Sub RenameTypeGridCell(ByVal column As DataGridViewColumn)
        Dim row As DataGridViewRow = Me.TypesDataGrid.SelectedRows(0)
        Me.TypesDataGrid.CurrentCell = row.Cells(column.Name)
        Me.TypesDataGrid.BeginEdit(True)
    End Sub

    Private Sub Initialize()
        PopulateCategoriesGrid()
        ToggleRenameEnabled()
        ToggleDeleteEnabled()
    End Sub

    Private Sub UpdateTypeValues(ByVal e As System.Windows.Forms.DataGridViewCellEventArgs)
        If e.RowIndex = -1 OrElse e.ColumnIndex = -1 Then Exit Sub

        Dim changedRow As DataGridViewRow = TypesDataGrid.Rows(e.RowIndex)
        Dim changedCell As DataGridViewCell = changedRow.Cells(e.ColumnIndex)
        Dim type As WeightType = DirectCast(changedRow.Tag, WeightType)

        If changedCell.Value IsNot Nothing Then
            Select Case e.ColumnIndex
                Case Me.TypeNameDataGridViewColumn.Index
                    type.Name = changedCell.Value.ToString.Trim
                Case Me.ExportcolumnNameDataGridViewColumn.Index
                    type.ExportColumnName = changedCell.Value.ToString.Trim
            End Select
        End If

    End Sub

    Private Sub ValidateRow(ByVal row As DataGridViewRow)
        Dim errorMessage As String = ""
        Dim type As WeightType = DirectCast(row.Tag, WeightType)

        If type.IsValid = False Then
            For Each message As String In type.ValidationErrors.Values
                errorMessage += message + vbCrLf
            Next
            'Remove last vbcrlf
            errorMessage = errorMessage.Substring(0, errorMessage.Length - 2)
        End If

        row.ErrorText = errorMessage
    End Sub

    Private Sub SetRowNeedsDeleteFlag(ByVal e As System.Windows.Forms.DataGridViewRowCancelEventArgs)
        DirectCast(e.Row.Tag, WeightType).NeedsDelete = True
    End Sub

    Private Sub Save()
        If TypesDataGrid.CurrentCell IsNot Nothing AndAlso TypesDataGrid.CurrentCell.IsInEditMode Then TypesDataGrid.CommitEdit(DataGridViewDataErrorContexts.Commit)

        For Each row As DataGridViewRow In Me.TypesDataGrid.Rows
            If row.ErrorText <> "" Then
                MessageBox.Show("All validation errors must be fixed before you can save.", "Validation Errors.", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Exit Sub
            End If
        Next

        Try
            WeightType.UpdateWeightTypesCollection(mWeightTypes)
        Catch ex As Exception
            Main.ReportException(ex)
        End Try
    End Sub
#End Region

#Region "Event Handlers"

    Private Sub NewTypeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewTypeButton.Click
        AddTypeRows()
    End Sub

    Private Sub NewTypeToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewTypeToolStripMenuItem.Click
        AddTypeRows()
    End Sub

    Private Sub DeleteTypeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteTypeButton.Click
        DeleteType()
    End Sub

    Private Sub DeleteTypeToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles DeleteTypeToolStripMenuItem.Click
        DeleteType()
    End Sub

    Private Sub TypesDataGrid_CellValueChanged(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles TypesDataGrid.CellValueChanged
        If e.RowIndex <> -1 AndAlso e.ColumnIndex <> -1 Then
            UpdateTypeValues(e)
            ValidateRow(Me.TypesDataGrid.Rows(e.RowIndex))
        End If
    End Sub

    Private Sub TypesDataGrid_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TypesDataGrid.SelectionChanged
        ToggleRenameEnabled()
        ToggleDeleteEnabled()
    End Sub

    Private Sub TypesDataGrid_UserDeletingRow(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowCancelEventArgs) Handles TypesDataGrid.UserDeletingRow
        SetRowNeedsDeleteFlag(e)
        UpdateRowNumbers()
        ToggleDeleteEnabled()
    End Sub

    Private Sub RenameTypeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RenameTypeButton.ButtonClick
        RenameTypeGridCell(Me.TypeNameDataGridViewColumn)
    End Sub

    Private Sub RenameTypeNameMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RenameTypeNameMenuItem.Click
        RenameTypeGridCell(Me.TypeNameDataGridViewColumn)
    End Sub

    Private Sub RenameExportColumnNameMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RenameExportColumnNameMenuItem.Click
        RenameTypeGridCell(Me.ExportcolumnNameDataGridViewColumn)
    End Sub

    Private Sub RenameTypeContextMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RenameTypeToolContextMenuItem.Click
        RenameTypeGridCell(Me.TypeNameDataGridViewColumn)
    End Sub

    Private Sub RenameExportColumnNameContextMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RenameExportColumnNameContextMenuItem.Click
        RenameTypeGridCell(Me.ExportcolumnNameDataGridViewColumn)
    End Sub

    Private Sub RenameTypeNameContextMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RenameTypeNameContextMenuItem.Click
        RenameTypeGridCell(Me.TypeNameDataGridViewColumn)
    End Sub

    Private Sub SaveTypesToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveTypesButton.Click
        Save()
    End Sub

    Private Sub TypesDataGrid_Sorted(ByVal sender As Object, ByVal e As System.EventArgs) Handles TypesDataGrid.Sorted
        Me.UpdateRowNumbers()
    End Sub

    Private Sub ManageTypesControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub

    Private Sub UndoButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UndoButton.Click
        Initialize()
    End Sub
#End Region

End Class
