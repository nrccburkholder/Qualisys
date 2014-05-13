Imports Nrc.Qualisys.Library
Imports DevExpress.XtraGrid.Views.Grid

Public Class MedicareMngrNavigator

#Region "Private Members"

    Private mIsLoading As Boolean = False
    Private mTrackChanges As Boolean = True
    Private mIsDeleting As Boolean = False

#End Region

#Region "Public Events"

    Public Event MedicareSelectionChanging As EventHandler(Of MedicareSelectionChangingEventArgs)
    Public Event MedicareSelectionChanged As EventHandler(Of MedicareSelectionChangedEventArgs)

#End Region

#Region "Events"

#Region "Navigator Events"

    Private Sub MedicareMngrNavigator_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

#End Region

#Region "MedicareNavGrid Events"

    Private Sub MedicareNavGridView_CustomDrawRowIndicator(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Grid.RowIndicatorCustomDrawEventArgs) Handles MedicareNavGridView.CustomDrawRowIndicator

        Dim view As GridView = CType(sender, GridView)
        Dim medNum As MedicareNumber = DirectCast(view.GetRow(e.RowHandle), MedicareNumber)

        'Check whether the indicator cell belongs to a data row
        If e.Info.IsRowIndicator And e.RowHandle >= 0 Then
            e.Painter.DrawObject(e.Info)
            e.Info.Graphics.DrawImage(medNum.SamplingLockedImage, e.Bounds.Left + 15, e.Bounds.Top + 2)
            e.Handled = True
        End If

    End Sub

    Private Sub MedicareNavGridView_FocusedRowChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.FocusedRowChangedEventArgs) Handles MedicareNavGridView.FocusedRowChanged

        'If Not mIsLoading AndAlso mTrackChanges AndAlso Not mIsDeleting AndAlso e.FocusedRowHandle >= 0 Then
        If Not mIsLoading AndAlso mTrackChanges AndAlso Not mIsDeleting Then
            OnFocusedRowChanged(e.FocusedRowHandle, e.PrevFocusedRowHandle)
        End If

    End Sub

#End Region

#Region "Menu/Toolbar Events"

    Private Sub MedicareNavNewTSMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MedicareNavNewTSMenuItem.Click

        OnMedicareNumberNew()

    End Sub

    Private Sub MedicareNavDeleteTSMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MedicareNavDeleteTSMenuItem.Click

        OnMedicareNumberDelete()

    End Sub

    Private Sub MedicareNavNewTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MedicareNavNewTSButton.Click

        OnMedicareNumberNew()

    End Sub

    Private Sub MedicareNavDeleteTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MedicareNavDeleteTSButton.Click

        OnMedicareNumberDelete()

    End Sub

    Private Sub MedicareNavRefreshTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MedicareNavRefreshTSButton.Click

        'Get the selected medicare number object
        Dim rowHandle As Integer = MedicareNavGridView.FocusedRowHandle
        Dim medNum As MedicareNumber = TryCast(MedicareNavGridView.GetRow(rowHandle), MedicareNumber)

        'Determine if we can execute the refresh
        If OnMedicareSelectionChanging(medNum, rowHandle) Then
            RefreshMedicareNumbers()
        End If

    End Sub

#End Region

#End Region

#Region "Public Methods"

    Public Sub RefreshMedicareNumbers()

        'Refresh the data source
        MedicareNumberBindingSource.DataSource = Nothing
        MedicareNumberBindingSource.DataSource = MedicareNumber.GetAll

        'Reselect the first item in the grid
        '  This is done because if there is a filter on the grid it still selects the first item in the
        '  data source and not the first visible item in the grid.
        MedicareNavGridView.FocusedRowHandle = -999997  'Sets focused row to the filter row
        MedicareNavGridView.FocusedRowHandle = 0        'Sets focused row to the first visible row in the grid

    End Sub

#End Region

#Region "Private Methods"

    Private Sub OnFocusedRowChanged(ByVal newRowHandle As Integer, ByVal previousRowHandle As Integer)

        'Get the selected medicare number object
        Dim medNum As MedicareNumber = TryCast(MedicareNavGridView.GetRow(newRowHandle), MedicareNumber)

        'Determine if we can change rows
        If OnMedicareSelectionChanging(medNum, previousRowHandle) Then
            OnMedicareSelectionChanged(medNum)
        End If

    End Sub

    Private Function OnMedicareSelectionChanging(ByVal medicareNum As MedicareNumber, ByVal previousRowHandle As Integer) As Boolean

        Dim changingArgs As New MedicareSelectionChangingEventArgs(medicareNum)
        RaiseEvent MedicareSelectionChanging(Me, changingArgs)

        If changingArgs.Cancel Then
            'We cannot proceed so set the focused row back to the previously focused row
            mTrackChanges = False
            MedicareNavGridView.FocusedRowHandle = previousRowHandle
            mTrackChanges = True
        Else
            'Get the previously selected medicare number object
            Dim prevMedNum As MedicareNumber = TryCast(MedicareNavGridView.GetRow(previousRowHandle), MedicareNumber)
            If prevMedNum IsNot Nothing AndAlso prevMedNum.IsNew Then
                'Set the deleting flag so we do not prompt the user to save changes
                mIsDeleting = True

                'Now delete the row from the grid
                MedicareNavGridView.DeleteRow(previousRowHandle)

                'Reset the deleting flag so we can change to the newly selected medicare number
                mIsDeleting = False
            End If
        End If

        Return Not changingArgs.Cancel

    End Function

    Private Sub OnMedicareSelectionChanged(ByVal medicareNum As MedicareNumber)

        'Change the focused row
        Dim changedArgs As New MedicareSelectionChangedEventArgs(medicareNum)
        RaiseEvent MedicareSelectionChanged(Me, changedArgs)

        'Setup the menu
        MedicareNavDeleteTSButton.Enabled = (MedicareNavGridView.FocusedRowHandle >= 0)
        MedicareNavDeleteTSMenuItem.Enabled = (MedicareNavGridView.FocusedRowHandle >= 0)

    End Sub

    Private Sub OnMedicareNumberDelete()

        'Get the selected medicare number object
        Dim medNum As MedicareNumber = TryCast(MedicareNavGridView.GetRow(MedicareNavGridView.FocusedRowHandle), MedicareNumber)

        'Determine if something is selected
        If medNum Is Nothing Then
            'Nothing is selected so we are out of here
            MessageBox.Show("You must select a medicare number to delete!", "Medicare Number Delete Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

        'Let's ask the user what to do
        Dim message As String = String.Format("You have selected to delete the following Medicare Number:{0}{0}Number:{1}{2}{0}Name:{1}{3}{0}{0}Do you wish to continue?", vbCrLf, vbTab, medNum.MedicareNumber, medNum.Name)
        If MessageBox.Show(message, "Delete Medicare Number", MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
            'Determine if we can delete this medicare number
            If CanMedicareNavGridDeleteRow(medNum) Then
                'Set the deleting flag so we do not prompt the user to save changes
                mIsDeleting = True

                'Cancel any current edits on the medicare number
                medNum.CancelEdit()

                'Let's delete the row from the database
                MedicareNumber.DeleteNow(medNum.MedicareNumber)

                'Now delete the row from the grid
                MedicareNavGridView.DeleteRow(MedicareNavGridView.FocusedRowHandle)

                'Reset the deleting flag so we can change to the newly selected medicare number
                mIsDeleting = False

                'Set the focus to the newly selected medicare number
                Dim newMedNum As MedicareNumber = TryCast(MedicareNavGridView.GetRow(MedicareNavGridView.FocusedRowHandle), MedicareNumber)
                OnMedicareSelectionChanged(newMedNum)
            End If
        End If

    End Sub

    Private Sub OnMedicareNumberNew()

        'Clear filtering on the grid
        MedicareNavGridView.ClearColumnsFilter()

        'Create the new medicare number
        Dim medNum As MedicareNumber = MedicareNumber.NewMedicareNumber()
        'medNum.MedicareNumber = "New"
        'medNum.Name = "Medicare Number"

        'Add the new medicare number to the grid and highlight it
        Dim newSourceIndex As Integer = MedicareNumberBindingSource.Add(medNum)
        MedicareNumberBindingSource.ResetBindings(False)
        MedicareNavGridView.FocusedRowHandle = MedicareNavGridView.GetRowHandle(newSourceIndex)

    End Sub

    Private Function CanMedicareNavGridDeleteRow(ByVal medicareNum As MedicareNumber) As Boolean

        Dim retValue As Boolean = False

        'Set the wait cursor
        Me.Cursor = Cursors.WaitCursor

        'If the medicare number being deleted is not a "New" medicare number then we need to store
        'it in our list of deleted medicare numbers
        If medicareNum.IsNew Then

            'Set the return value
            retValue = True
        Else
            'Verify that this medicare number can be deleted
            If MedicareNumber.AllowDelete(medicareNum.MedicareNumber) Then
                'Set the return value
                retValue = True
            Else
                'If it can't be deleted then display an error and cancel delete
                MessageBox.Show("Medicare Number " & medicareNum.DisplayLabel & " cannot be deleted because it is still associated with at least one facility!", "Medicare Number Delete Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
        End If

        'Reset the wait cursor
        Me.Cursor = Me.DefaultCursor

        'Return
        Return retValue

    End Function

#End Region

End Class
