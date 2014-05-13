Imports Nrc.Qualisys.Library

Public Class FacilitySection

#Region " Private Members "

    Private WithEvents mClientNavigator As ClientNavigator
    Private mViewMode As DataViewMode
    Private mAllFacilityGridIsPopulated As Boolean
    Private mAllFacilityList As FacilityList
    Private mMedicareList As MedicareNumberList

#End Region

#Region " Enums "

    Public Enum DataViewMode
        ClientFacilities = 1
        AllFacilities = 2
    End Enum

#End Region

#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

    End Sub

#End Region

#Region " Base Class Overrides "

    Public Overrides Sub ActivateSection()

        'Set the view mode (this reinitializes the screen each time it is activated)
        PopulateMedicareList()
        SetViewMode(mViewMode)

    End Sub

    Public Overrides Sub InactivateSection()

        'Cleanup all memory collections and grid data sources
        Me.AllFacilityGrid.ClearDataSources()
        Me.ClientFacilityGrid.ClearDataSources()
        mAllFacilityGridIsPopulated = False

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Select Case mViewMode
            Case DataViewMode.AllFacilities
                Return VerifyOKToInactivateAllFacilities()

            Case DataViewMode.ClientFacilities
                'We can always unload here because database updates are immediate
                Return True

            Case Else
                'No current view mode exists
                Return True
        End Select

    End Function

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        Me.mClientNavigator = TryCast(navCtrl, ClientNavigator)
        If mClientNavigator Is Nothing Then
            Throw New ArgumentException("The FacilitySection control expects a navigation control of type ClientNavigator")
        End If

    End Sub

#End Region

#Region " Event Handlers "

#Region " Event Handlers - Form "

    Private Sub ApplyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ApplyButton.Click

        Select Case mViewMode
            Case DataViewMode.AllFacilities
                SaveAllFacilityGrid()

            Case DataViewMode.ClientFacilities
                'Do Nothing

        End Select

    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        Select Case mViewMode
            Case DataViewMode.AllFacilities
                Me.Cursor = Cursors.WaitCursor
                Me.PopulateAllFacilityList()
                Me.PopulateAllFacilityGrid()
                ApplyButton.Enabled = True
                Cancel_Button.Enabled = True
                Me.Cursor = Me.DefaultCursor

            Case DataViewMode.ClientFacilities
                ApplyButton.Enabled = False
                Cancel_Button.Enabled = False

        End Select

    End Sub

    Private Sub mClientNavigator_FacilityViewModeChanged(ByVal sender As Object, ByVal e As FacilityViewModeChangedEventArgs) Handles mClientNavigator.FacilityViewModeChanged
        SetViewMode(e.ViewMode)
    End Sub

#End Region

#Region " Event Handlers - AllFacilityToolStrip "

    Private Sub AllFacilityDeleteTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AllFacilityDeleteTSButton.Click
        If MessageBox.Show("Are you sure you want to delete the selected rows?", "Confirm Delete", MessageBoxButtons.YesNo) = DialogResult.Yes Then
            AllFacilityGrid.DeleteSelectedRows()
        End If
    End Sub

#End Region

#Region " Event Handlers - ClientFacilityGrid "

    Private Sub AddClientFacilityButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddClientFacilityButton.Click
        Dim selectedRows() As Integer = Me.AllFacilityGrid.FacilityGridView.GetSelectedRows
        Dim facilityAlreadyAssociatedWithClient As Boolean
        Dim clientFacilityList As New FacilityList

        If Me.ClientFacilityGrid.FacilityBindingSource.DataSource IsNot Nothing Then clientFacilityList = DirectCast(Me.ClientFacilityGrid.FacilityBindingSource.DataSource, FacilityList)

        For Each i As Integer In selectedRows
            facilityAlreadyAssociatedWithClient = False

            Dim fac As Facility = TryCast(Me.AllFacilityGrid.FacilityGridView.GetRow(i), Facility)
            If fac IsNot Nothing Then
                'Assign this facility to the selected client if it is not already assigned
                For Each assignedFac As Facility In clientFacilityList
                    If fac.Equals(assignedFac) Then
                        facilityAlreadyAssociatedWithClient = True
                        Exit For
                    End If
                Next
                If Not facilityAlreadyAssociatedWithClient Then
                    fac.AssignToClient(mClientNavigator.SelectedClient.Id)
                    clientFacilityList.Add(fac)
                End If
            End If
        Next
        Me.AllFacilityGrid.FacilityGridView.ClearSelection()
    End Sub

    Private Sub RemoveClientFacilityButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoveClientFacilityButton.Click
        'Remove all of the selected facilities from the selected client
        Dim selectedRows() As Integer = Me.ClientFacilityGrid.FacilityGridView.GetSelectedRows

        'Reverse the order so we delete the highest ordered rows first, otherwise 
        'the row handles will change each time we delete a row.
        Array.Reverse(selectedRows)

        For Each i As Integer In selectedRows
            Dim fac As Facility = TryCast(Me.ClientFacilityGrid.FacilityGridView.GetRow(i), Facility)
            If fac IsNot Nothing Then
                'UnAssign this facility to the selected client
                If fac.AllowUnassignment(mClientNavigator.SelectedClient.Id) Then
                    fac.UnassignFromClient(mClientNavigator.SelectedClient.Id)
                    Me.ClientFacilityGrid.FacilityGridView.DeleteRow(i)
                Else
                    MessageBox.Show(fac.Name & " cannot not be unassigned because it is still mapped to 1 or more sample units for " & mClientNavigator.SelectedClient.Name, "Cannot Unassign Facility", MessageBoxButtons.OK)
                End If
            End If
        Next

    End Sub
#End Region

#End Region

#Region " Private Methods "

#Region " Private Methods - General "

    Private Sub SetViewMode(ByVal viewMode As DataViewMode)

        If mMedicareList Is Nothing Then
            PopulateMedicareList()
        End If
        If mAllFacilityList Is Nothing Then
            PopulateAllFacilityList
        End If

        'Setup the screen based on the mode selected
        Select Case viewMode
            Case DataViewMode.AllFacilities

                'Setup the screen
                SetupAllFacility()

                'Populate the screen if we haven't already populated the allfacilitygrid
                If Not mAllFacilityGridIsPopulated Then PopulateAllFacilityGrid()

                'reset the appearance
                ResetAllFacilityGridAppearance()

            Case DataViewMode.ClientFacilities
                'Setup the screen
                SetupClientFacility()

                'If the view mode has changed then repopulate the all facility grid
                If Not mAllFacilityGridIsPopulated Then PopulateAllFacilityGrid()

                'Populate the client facility grid
                PopulateClientFacilityGrid()

                'reset the appearance
                ResetAllFacilityGridAppearance()
                ResetClientFacilityGridAppearance()

        End Select

        'Save the mode
        mViewMode = viewMode
    End Sub


#End Region

#Region " Private Methods - AllFacility "

    Private Sub PopulateAllFacilityList()
        mAllFacilityList = Facility.GetAll
        mAllFacilityList.AllowNew = True
        Me.mAllFacilityGridIsPopulated = False
    End Sub

    Private Sub SetupAllFacility()

        'Setup the splitters so only the AllFacilityGrid is visible
        FacilitySplitContainer.Panel1Collapsed = False
        FacilitySplitContainer.Panel2Collapsed = True
        With Me.AllFacilityTableLayoutPanel.ColumnStyles(1)
            .SizeType = SizeType.Absolute
            .Width = 0
        End With
        AddRemovePanel.Visible = False

        ButtonPanel.Enabled = True

        'Setup the AllFacility Tool Strip
        AllFacilityCaptionTSLabel.Visible = False
        AllFacilityDeleteTSButton.Visible = True

        With AllFacilityGrid.FacilityGridView
            .OptionsBehavior.Editable = True
            .OptionsSelection.MultiSelect = True
            .OptionsView.ShowAutoFilterRow = True
            .OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.Top
        End With

        ResetAllFacilityGridAppearance()

        'Set the AllFacility grid to show all columns
        Me.AllFacilityGrid.ShowIdentifierColumnsOnly = False

        'Set the section caption
        MainPanel.Caption = "All Facilities"

    End Sub

    Private Sub ResetAllFacilityGridAppearance()
        AllFacilityGrid.FacilitiesGrid.SuspendLayout()
        With AllFacilityGrid.FacilityGridView
            .ClearColumnsFilter()
            .ClearSorting()
        End With
        AllFacilityGrid.colFacilityName.SortOrder = DevExpress.Data.ColumnSortOrder.Ascending
        AllFacilityGrid.colFacilityName.SortIndex = 0
        Me.AllFacilityGrid.FacilityGridView.ClearSelection()
        Me.AllFacilityGrid.FacilityGridView.SelectRow(0)
        Me.AllFacilityGrid.FacilityGridView.MoveFirst()
        AllFacilityGrid.FacilitiesGrid.ResumeLayout()
    End Sub

    Private Sub PopulateAllFacilityGrid()
        'Repopulate the grid
        Me.AllFacilityGrid.PopulateFacilityGrid(mAllFacilityList, mMedicareList)

        mAllFacilityGridIsPopulated = True
    End Sub

    Private Sub SaveAllFacilityGrid()

        'Commit any uncommitted changes
        If Me.AllFacilityGrid.FacilityGridView.IsEditing Then
            If Me.AllFacilityGrid.FacilityGridView.ValidateEditor Then
                Me.AllFacilityGrid.FacilityGridView.CloseEditor()
            End If
        End If

        'Set the wait cursor
        Me.Cursor = Cursors.WaitCursor

        'Save
        If Me.mAllFacilityList.IsValid Then
            Me.mAllFacilityList.Save()
        Else
            MessageBox.Show("You cannot save until all errors are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

        'Reset the wait cursor
        Me.Cursor = Me.DefaultCursor

    End Sub

    Private Function VerifyOKToInactivateAllFacilities() As Boolean

        'Commit any uncommitted changes
        If Me.AllFacilityGrid.FacilityGridView.IsEditing Then
            If Me.AllFacilityGrid.FacilityGridView.ValidateEditor Then
                Me.AllFacilityGrid.FacilityGridView.CloseEditor()
            End If
        End If

        If Me.mAllFacilityList.IsDirty Then
            'Prompt the user to save changes
            Dim result As DialogResult = MessageBox.Show("You have made changes to the facility information." & vbCrLf & vbCrLf & "Do you want to save your changes?", "Save Changes?", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning)

            If result = DialogResult.Yes Then
                If Not Me.mAllFacilityList.IsValid Then
                    MessageBox.Show("You cannot save until all errors are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return False
                End If
            End If

            'Do as the user requested
            If result = DialogResult.Cancel Then
                'The user has canceled so we are out of here
                Return False
            ElseIf result = DialogResult.Yes Then
                'Save the changes
                SaveAllFacilityGrid()
                Return True
            ElseIf result = DialogResult.No Then
                Me.mAllFacilityList = Nothing
                Return True
            End If
        Else
            'We are good to go
            Return True
        End If

    End Function

#End Region

#Region " Private Methods - ClientFacility "

    Private Sub SetupClientFacility()

        'Setup the splitters so the AllFacilityGrid and ClientFacilityGrid are visible
        FacilitySplitContainer.Panel1Collapsed = False
        FacilitySplitContainer.Panel2Collapsed = False
        With Me.AllFacilityTableLayoutPanel.ColumnStyles(1)
            .SizeType = SizeType.Absolute
            .Width = 62
        End With
        AddRemovePanel.Visible = True
        ButtonPanel.Enabled = False

        'Setup the AllFacility Tool Strip
        AllFacilityCaptionTSLabel.Visible = True
        AllFacilityDeleteTSButton.Visible = False

        'Set the AllFacility grid so we cannot add, delete, and edit records
        With AllFacilityGrid.FacilityGridView
            .OptionsSelection.MultiSelect = True
            .OptionsBehavior.Editable = False
            .OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.None
        End With

        'Set the AllFacility grid to only show identifier columns
        Me.AllFacilityGrid.ShowIdentifierColumnsOnly = True

        'Set the ClientFacility grid so we cannot add, delete, and edit records
        With ClientFacilityGrid.FacilityGridView
            .OptionsSelection.MultiSelect = True
            .OptionsBehavior.Editable = False
            .OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.None
        End With

        'Set the client grid to only show identifier columns
        Me.ClientFacilityGrid.ShowIdentifierColumnsOnly = True

        'Set the section caption
        MainPanel.Caption = mClientNavigator.SelectedClient.Name & " Facilities"
    End Sub

    Private Sub ResetClientFacilityGridAppearance()
        ClientFacilityGrid.FacilitiesGrid.SuspendLayout()
        With ClientFacilityGrid.FacilityGridView
            .ClearColumnsFilter()
            .ClearSorting()
        End With
        ClientFacilityGrid.colFacilityName.SortOrder = DevExpress.Data.ColumnSortOrder.Ascending
        ClientFacilityGrid.colFacilityName.SortIndex = 0
        Me.ClientFacilityGrid.FacilityGridView.ClearSelection()
        Me.ClientFacilityGrid.FacilityGridView.SelectRow(0)
        Me.ClientFacilityGrid.FacilityGridView.MoveFirst()
        ClientFacilityGrid.FacilitiesGrid.ResumeLayout()
    End Sub
    Private Sub PopulateClientFacilityGrid()
        Dim clientFacilityList As FacilityList

        'Repopulate the grid
        clientFacilityList = Facility.GetByClientId(mClientNavigator.SelectedClient.Id)
        ClientFacilityGrid.PopulateFacilityGrid(clientFacilityList, Me.mMedicareList)
    End Sub

#End Region

#Region " Private Methods - MedicareNumber "

    Private Sub PopulateMedicareList()

        mMedicareList = MedicareNumber.GetAll
        mMedicareList.AllowNew = True

        'Update the bindings in the FacilityGrid so it isn't referencing the previous
        'version of the collection
        Me.AllFacilityGrid.RefreshMedicareBindings(Me.mMedicareList)
        Me.ClientFacilityGrid.RefreshMedicareBindings(Me.mMedicareList)

    End Sub

#End Region

#End Region


#Region "Medicare Number stuff"

    'Private Sub MedicareNumberDeleteTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
    '    If MessageBox.Show("Are you sure you want to delete the selected rows?", "Confirm Delete", MessageBoxButtons.YesNo) = DialogResult.Yes Then
    '        Dim selectedRows() As Integer = Me.MedicareNumberGridView.GetSelectedRows
    '        'Reverse the items so we delete in reverse order.  This avoids problems with index numbers
    '        'Changing each time we delete an item.
    '        Array.Reverse(selectedRows)

    '        For Each i As Integer In selectedRows
    '            If i >= 0 Then
    '                Dim medicareNum As MedicareNumber = DirectCast(Me.MedicareNumberGridView.GetRow(i), MedicareNumber)
    '                If medicareNum IsNot Nothing Then
    '                    If CanMedicareNumberGridDeleteRow(medicareNum) Then
    '                        MedicareNumberGridView.DeleteRow(i)
    '                    End If
    '                End If
    '            End If
    '        Next
    '        'UpdateMedicareNumberStatus()
    '    End If
    'End Sub

    'Private Sub MedicareNumberGridView_FocusedRowChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.FocusedRowChangedEventArgs)
    '    'The medicareNumber column cannot be edited for Old medicare Numbers.
    '    If e.FocusedRowHandle >= 0 AndAlso DirectCast(Me.MedicareNumberGridView.GetRow(e.FocusedRowHandle), MedicareNumber).IsNew = False Then
    '        colMedicareNumber.OptionsColumn.ReadOnly = True
    '    Else
    '        colMedicareNumber.OptionsColumn.ReadOnly = False
    '    End If
    'End Sub

    'Private Sub SetupMedicareNumbers()

    '    'Setup the splitters so only the MedicareNumberGrid is visible
    '    MainSplitContainer.Panel1Collapsed = False
    '    MainSplitContainer.Panel2Collapsed = True
    '    FacilitySplitContainer.Panel1Collapsed = True
    '    FacilitySplitContainer.Panel2Collapsed = True
    '    ButtonPanel.Enabled = True

    '    'Set the section caption 
    '    MainPanel.Caption = "All Medicare Numbers"

    'End Sub

    'Private Sub ResetMedicareNumberGridAppearance()
    '    Me.MedicareNumberGrid.SuspendLayout()
    '    With Me.MedicareNumberGridView
    '        .ClearColumnsFilter()
    '        .ClearSorting()
    '    End With
    '    colMedicareNumber.SortOrder = DevExpress.Data.ColumnSortOrder.Ascending
    '    colMedicareNumber.SortIndex = 0
    '    Me.MedicareNumberGridView.ClearSelection()
    '    Me.MedicareNumberGridView.SelectRow(0)
    '    Me.MedicareNumberGridView.MoveFirst()
    '    'Me.MedicareNumberGridView.BestFitMaxRowCount = 25
    '    Me.MedicareNumberGridView.BestFitColumns()
    '    Me.MedicareNumberGrid.ResumeLayout()
    'End Sub

    'Private Sub PopulateMedicareNumberGrid()
    '    'Repopulate the grid
    '    MedicareNumberBindingSource.DataSource = mMedicareList

    '    'Set the flag to indicate that the grid is populated
    '    mMedicareNumberGridIsPopulated = True
    'End Sub

    'Private Sub SaveMedicareNumberGrid()

    '    If Me.MedicareNumberGridView.IsEditing Then
    '        If Me.MedicareNumberGridView.ValidateEditor Then
    '            Me.MedicareNumberGridView.CloseEditor()
    '        End If
    '    End If

    '    'Set the wait cursor
    '    Me.Cursor = Cursors.WaitCursor

    '    'Save the changes
    '    If Me.mMedicareList.IsValid Then
    '        Me.mMedicareList.Save()
    '    Else
    '        MessageBox.Show("You cannot save until all errors are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    '    End If

    '    'Reset the wait cursor
    '    Me.Cursor = Me.DefaultCursor

    'End Sub

    'Private Function CanMedicareNumberGridDeleteRow(ByVal medicareNum As MedicareNumber) As Boolean

    '    Dim retValue As Boolean = False

    '    'Set the wait cursor
    '    Me.Cursor = Cursors.WaitCursor

    '    'If the medicare number being deleted is not a "New" medicare number then we need to store
    '    'it in our list of deleted medicare numbers
    '    If medicareNum.IsNew Then

    '        'Set the return value
    '        retValue = True
    '    Else
    '        'Verify that this medicare number can be deleted
    '        If MedicareNumber.AllowDelete(medicareNum.MedicareNumber) Then
    '            'Set the return value
    '            retValue = True
    '        Else
    '            'If it can't be deleted then display an error and cancel delete
    '            MessageBox.Show("Medicare Number " & medicareNum.DisplayLabel & " cannot be deleted because it is still associated with at least one facility!", "Medicare Number Delete Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    '        End If
    '    End If

    '    'Reset the wait cursor
    '    Me.Cursor = Me.DefaultCursor

    '    'Return
    '    Return retValue

    'End Function

    'Private Function VerifyOKToInactivateMedicareNumbers() As Boolean
    '    'Commit any uncommitted changes
    '    If Me.MedicareNumberGridView.IsEditing Then
    '        If Me.MedicareNumberGridView.ValidateEditor Then
    '            Me.MedicareNumberGridView.CloseEditor()
    '        End If
    '    End If

    '    If Me.mMedicareList.IsDirty Then
    '        'Prompt the user to save changes
    '        Dim result As DialogResult = MessageBox.Show("You have made changes to the medicare number information." & vbCrLf & vbCrLf & "Do you want to save your changes?", "Save Changes?", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning)

    '        If result = DialogResult.Yes Then
    '            If Not Me.mMedicareList.IsValid Then
    '                MessageBox.Show("You cannot save until all errors are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    '                Return False
    '            End If
    '        End If

    '        'Do as the user requested
    '        If result = DialogResult.Cancel Then
    '            'The user has canceled so we are out of here
    '            Return False
    '        ElseIf result = DialogResult.Yes Then
    '            'Save the changes
    '            SaveMedicareNumberGrid()
    '            Return True
    '        ElseIf result = DialogResult.No Then
    '            Me.mMedicareList = Nothing
    '            Return True
    '        End If
    '    Else
    '        'We are good to go
    '        Return True
    '    End If

    'End Function

#End Region

End Class
