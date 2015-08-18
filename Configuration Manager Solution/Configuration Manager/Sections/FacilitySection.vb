Imports Nrc.Qualisys.Library

Public Class FacilitySection

#Region " Private Members "


    Private mViewMode As FacilityAdminSection.DataViewMode
    Private mAllFacilityGridIsPopulated As Boolean
    Private mAllFacilityList As FacilityList
    Private mMedicareList As MedicareNumberList
    Private mClientNavigator As ClientNavigator

#End Region


#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

    End Sub

#End Region

#Region " Event Handlers "

#Region " Event Handlers - Form "

    Private Sub ApplyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ApplyButton.Click

        Select Case mViewMode
            Case FacilityAdminSection.DataViewMode.AllFacilities
                SaveAllFacilityGrid()

            Case FacilityAdminSection.DataViewMode.ClientFacilities
                'Do Nothing

        End Select

    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        Select Case mViewMode
            Case FacilityAdminSection.DataViewMode.AllFacilities
                Me.Cursor = Cursors.WaitCursor
                Me.PopulateAllFacilityList(False)
                Me.PopulateAllFacilityGrid()
                ApplyButton.Enabled = True
                Cancel_Button.Enabled = True
                Me.Cursor = Me.DefaultCursor

            Case FacilityAdminSection.DataViewMode.ClientFacilities
                Me.PopulateAllFacilityList(True)

                ApplyButton.Enabled = False
                Cancel_Button.Enabled = False

        End Select

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

    Public Sub SetViewMode(ByVal viewMode As FacilityAdminSection.DataViewMode, ClientNav As ClientNavigator)

        mClientNavigator = ClientNav

        If mMedicareList Is Nothing Then
            PopulateMedicareList()
        End If
        'If mAllFacilityList Is Nothing Then
        '    PopulateAllFacilityList()
        'End If

        'Setup the screen based on the mode selected
        Select Case viewMode
            Case FacilityAdminSection.DataViewMode.AllFacilities

                PopulateAllFacilityList(False)

                'Setup the screen
                SetupAllFacility()

                'Populate the screen if we haven't already populated the allfacilitygrid
                If Not mAllFacilityGridIsPopulated Then
                    PopulateAllFacilityGrid()
                End If

                'reset the appearance
                ResetAllFacilityGridAppearance()

            Case FacilityAdminSection.DataViewMode.ClientFacilities

                PopulateAllFacilityList(True)

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

    Private Sub PopulateAllFacilityList(includePracticeSites As Boolean)
        mAllFacilityList = Facility.GetAll(includePracticeSites)
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

    Public Sub ResetClientFacilityGridAppearance()
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

End Class
