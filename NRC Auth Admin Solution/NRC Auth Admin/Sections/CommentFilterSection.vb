Imports System.Collections.ObjectModel
Imports Nrc.DataMart.MySolutions.Library
Imports Nrc.NRCAuthLib
Imports Nrc.NRCAuthLib.DataMartPrivilegeTree

Public Class CommentFilterSection

#Region " Private Fields "
    Private mOrgUnitNavigator As OrgUnitNavigator
    Private mSelectedGroup As Group
    Private WithEvents mFilterList As CommentFilterCollection

    Private mAvailableFieldList As Dictionary(Of Integer, StudyTableColumn)
    Private mUsedFieldList As Dictionary(Of Integer, StudyTableColumn)
#End Region

#Region " Overrides "

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mOrgUnitNavigator = TryCast(navCtrl, OrgUnitNavigator)
        If mOrgUnitNavigator Is Nothing Then
            Throw New ArgumentException("The CommentFilterSection control expects a navigation control of type GroupNavigator")
        End If
    End Sub

    ''' <summary>
    ''' Returns True if it is okay for the user to navigate away from this section
    ''' </summary>
    Public Overrides Function AllowInactivate() As Boolean
        'If the data has changed then prompt user
        If Me.mFilterList IsNot Nothing AndAlso Me.mFilterList.IsDirty Then
            'Ask user if they want to save
            Dim result As DialogResult
            result = MessageBox.Show("Do you want to save your changes?", "Save Changes?", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning)

            'If yes, save changes then return TRUE
            'If no, just return TRUE without saving
            'If cancel, return FALSE
            If result = DialogResult.Yes Then
                Me.SaveChangesCommand()
                Return True
            ElseIf result = DialogResult.No Then
                Return True
            Else
                Return False
            End If
        Else
            'If data has not changed just return TRUE
            Return True
        End If
    End Function

    Public Overrides Sub ActivateSection()
        'Register the event handlers
        AddHandler mOrgUnitNavigator.SelectedGroupChanging, AddressOf mOrgUnitNavigator_SelectedGroupChanging
        AddHandler mOrgUnitNavigator.SelectedGroupChanged, AddressOf mOrgUnitNavigator_SelectedGroupChanged
        mOrgUnitNavigator.ShowGroupSelector = True
        If mOrgUnitNavigator.SelectedGroup IsNot Nothing Then
            Me.mSelectedGroup = mOrgUnitNavigator.SelectedGroup
            Me.LoadSection()
        End If
    End Sub

    Public Overrides Sub InactivateSection()
        'Unregister the event handlers
        RemoveHandler mOrgUnitNavigator.SelectedGroupChanging, AddressOf mOrgUnitNavigator_SelectedGroupChanging
        RemoveHandler mOrgUnitNavigator.SelectedGroupChanged, AddressOf mOrgUnitNavigator_SelectedGroupChanged
        Me.UnloadSection()
    End Sub

#End Region

#Region " Control Event Handlers "

    Private Sub CommentFilterSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.RestoreGridLayoutProperties()
        AddHandler Globals.MainFormClosing, AddressOf MainFormClosing
    End Sub

#Region " Navigator Events "
    Private Sub mOrgUnitNavigator_SelectedGroupChanging(ByVal sender As Object, ByVal e As OrgUnitNavigator.SelectedGroupChangingEventArgs)
        'Cancel the group change if we are not allowing the user to navigate away
        'This enables the user to cancel if they have unsaved data
        e.Cancel = (Not Me.AllowInactivate)
    End Sub

    Private Sub mOrgUnitNavigator_SelectedGroupChanged(ByVal sender As Object, ByVal e As OrgUnitNavigator.SelectedGroupChangedEventArgs)
        Try
            Me.ParentForm.Cursor = Cursors.WaitCursor
            If e.Group Is Nothing Then
                Me.UnloadSection()
            Else
                'Make sure the selected group is actually different
                If mSelectedGroup Is Nothing OrElse mSelectedGroup.GroupId <> e.Group.GroupId Then
                    mSelectedGroup = e.Group
                    Me.LoadSection()
                End If
            End If
        Finally
            Me.ParentForm.Cursor = Cursors.Default
        End Try
    End Sub
#End Region

#Region " BindingSource Events "
    Private Sub CommentFilterBindingSource_AddingNew(ByVal sender As Object, ByVal e As System.ComponentModel.AddingNewEventArgs) Handles CommentFilterBindingSource.AddingNew
        'Get the field that was selected to be added as a filter
        Dim field As StudyTableColumn = DirectCast(Me.AvailableFieldList.SelectedItem, StudyTableColumn)

        'Create a new filter object and set the defaults
        Dim filter As CommentFilter = CommentFilter.NewCommentFilter
        filter.StudyTableColumnId = field.FieldId
        filter.GroupId = mSelectedGroup.GroupId
        filter.Name = field.Name.Replace(" ", "")
        filter.AllowGroupBy = True
        e.NewObject = filter

        'Remove the field from the list of available fields
        mAvailableFieldList.Remove(field.FieldId)
        mUsedFieldList.Add(field.FieldId, field)
        Me.AvailableFieldList.Items.Remove(field)

        'Reset the add buttons
        Me.ResetAddButton()
    End Sub

    Private Sub CommentFilterBindingSource_CurrentChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles CommentFilterBindingSource.CurrentChanged
        'Enable/Disable the delete button
        Me.DeleteFilterButton.Enabled = (Me.CommentFilterBindingSource.Current IsNot Nothing)
    End Sub

    Private Sub CommentFilterBindingSource_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles CommentFilterBindingSource.ListChanged
        If mFilterList IsNot Nothing Then
            Me.SaveChangesButton.Enabled = (Me.mFilterList.IsSavable)
            Me.CancelChangesButton.Enabled = (Me.mFilterList.IsDirty)
        End If
    End Sub
#End Region

#Region " BindingNavigator Events "
    Private Sub DeleteFilterButon_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteFilterButton.Click
        'Get the current filter
        Dim filter As CommentFilter = TryCast(Me.CommentFilterBindingSource.Current, CommentFilter)

        If filter IsNot Nothing Then
            'Remove the filter from the bound list
            Me.CommentFilterBindingSource.RemoveCurrent()

            'Remove the filter from the available list
            If mUsedFieldList.ContainsKey(filter.StudyTableColumnId) Then
                Dim field As StudyTableColumn = mUsedFieldList(filter.StudyTableColumnId)
                mUsedFieldList.Remove(field.FieldId)
                mAvailableFieldList.Add(field.FieldId, field)
                Me.AvailableFieldList.Items.Add(field)
            End If

            'Reset the add buttons
            Me.ResetAddButton()
        End If
    End Sub

    Private Sub AddFilterButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddFilterButton.Click
        'Add a new object to the BindingSource
        If Me.AvailableFieldList.Items.Count > 0 Then
            Me.CommentFilterBindingSource.AddNew()
        End If
    End Sub

    Private Sub SaveChangesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveChangesButton.Click
        'Save the changes
        Me.SaveChangesCommand()
    End Sub

    Private Sub CancelChangesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelChangesButton.Click
        Me.CancelChangesCommand()
    End Sub
#End Region


    Private Sub CheckEdit1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles CheckEdit1.CheckedChanged
        'If the grid is editing then finish the editing
        If Me.CommentFilterGridView.IsEditing Then
            If Me.CommentFilterGridView.ValidateEditor Then
                Me.CommentFilterGridView.CloseEditor()
            End If
        End If

    End Sub

#End Region

#Region " Private Methods "

    Private Sub LoadSection()
        'Get the list of comment filters for this group
        mFilterList = CommentFilter.GetByGroupId(mSelectedGroup.GroupId)
        mFilterList.BeginEdit()

        'Get the list of StudyTableColumn objects that this group has access to
        mAvailableFieldList = Me.GetStudyFields(mSelectedGroup)
        mUsedFieldList = New Dictionary(Of Integer, StudyTableColumn)

        'Populate the field lists
        Me.PopulateFieldLists()

        'Populate the main data grid
        Me.CommentFilterBindingSource.DataSource = mFilterList
        Me.CommentFilterGridView.FocusedRowHandle = 0

        'Enable the section and reset DataChanged flag
        Me.Enabled = True
    End Sub

    Private Sub UnloadSection()
        'Disable the section
        Me.mFilterList = Nothing
        Me.CommentFilterBindingSource.DataSource = Nothing
        Me.Enabled = False
        Me.mSelectedGroup = Nothing
    End Sub

#Region " Field Lists "
    ''' <summary>
    ''' Populates the field lookup list in the grid and the combo box of available fields
    ''' </summary>
    Private Sub PopulateFieldLists()
        'Reset lists
        Me.AvailableFieldList.Items.Clear()
        Me.FieldColumnLookupEdit.DataSource = Nothing

        'Set the list of fields for the grid look-up control
        Dim lookupList As New List(Of StudyTableColumn)
        For Each field As StudyTableColumn In mAvailableFieldList.Values
            lookupList.Add(field)
        Next
        Me.FieldColumnLookupEdit.DataSource = lookupList

        'Figure out which fields are used and which are available
        For Each filter As CommentFilter In mFilterList
            If mAvailableFieldList.ContainsKey(filter.StudyTableColumnId) Then
                mUsedFieldList.Add(filter.StudyTableColumnId, mAvailableFieldList(filter.StudyTableColumnId))
                mAvailableFieldList.Remove(filter.StudyTableColumnId)
            End If
        Next

        'Add the available fields to the list for adding new filters
        For Each field As StudyTableColumn In mAvailableFieldList.Values
            Me.AvailableFieldList.Items.Add(field)
        Next

        'Reset the add buttons
        Me.ResetAddButton()
    End Sub


    ''' <summary>
    ''' Loads all the unique fields for any studies that the groups has access to
    ''' </summary>
    Private Function GetStudyFields(ByVal grp As Group) As Dictionary(Of Integer, StudyTableColumn)
        If grp Is Nothing Then
            Throw New ArgumentNullException("grp")
        End If

        'Get the privileges from the datamart
        Dim privTree As DataMartPrivilegeTree = DataMartPrivilegeTree.GetGroupTree(grp)

        'Determine which study nodes the group will have access to
        Dim selectedStudies As List(Of DataMartPrivilegeNode) = GetSelectedStudies(privTree.Nodes, False)
        'Get the IDs
        Dim studyIds As New List(Of Integer)
        For Each node As DataMartPrivilegeNode In selectedStudies
            studyIds.Add(Integer.Parse(node.NodeId.Replace("ST", "")))
        Next

        'Get all of the unique study tables we will be needing
        Dim tables As New Dictionary(Of Integer, StudyTable)
        For Each studyId As Integer In studyIds
            'Get the study tables
            For Each tbl As StudyTable In StudyTable.GetAllStudyTables(studyId)
                'Add the table to our list if it is not already there
                If Not tables.ContainsKey(tbl.Id) Then
                    tables.Add(tbl.Id, tbl)
                End If
            Next
        Next

        'Get all of the unique fields for the studies
        Dim colIds As New List(Of Integer)
        Dim cols As New Dictionary(Of Integer, StudyTableColumn)
        For Each tbl As StudyTable In tables.Values
            For Each col As StudyTableColumn In tbl.Columns
                If Not colIds.Contains(col.FieldId) Then
                    colIds.Add(col.FieldId)
                    cols.Add(col.FieldId, col)
                End If
            Next
        Next

        'Add in the two special fields SampleUnit/Question
        'MH 20090803 commenting this code because if sample unit gets used it causes the website to throw errors.
        'Dim unitCol As IStudyTableColumn = New StudyTableColumn
        'unitCol.Id = -1
        'unitCol.Name = "Sample Unit"
        'cols.Add(-1, DirectCast(unitCol, StudyTableColumn))

        Dim questionCol As IStudyTableColumn = New StudyTableColumn
        questionCol.Id = -2
        questionCol.Name = "Question"
        cols.Add(-2, DirectCast(questionCol, StudyTableColumn))

        'Return the list of fields
        Return cols
    End Function

    ''' <summary>
    ''' Determies which studies the group will have access to
    ''' </summary>
    Private Function GetSelectedStudies(ByVal nodes As DataMartPrivilegeNodeCollection, ByVal isAncestorSelected As Boolean) As List(Of DataMartPrivilegeNode)
        Dim studyNodes As New List(Of DataMartPrivilegeNode)

        'Check each of the nodes
        For Each node As DataMartPrivilegeTree.DataMartPrivilegeNode In nodes
            'If this is a study node
            If node.PrivilegeLevel = PrivilegeLevelEnum.Study Then
                'If it is granted or if one of its ancestors is granted then add it to the list
                If node.IsGranted OrElse isAncestorSelected Then
                    studyNodes.Add(node)
                Else
                    'If it has children that are granted then also add it to the list
                    If node.HasChildren AndAlso HasChildrenGranted(node.Nodes) Then
                        studyNodes.Add(node)
                    End If
                End If
            ElseIf node.HasChildren Then
                'If it is not a study node but has children, then check to see
                'what selected are in the children and add them to our list
                studyNodes.AddRange(GetSelectedStudies(node.Nodes, node.IsGranted))
            End If
        Next

        'Return the list
        Return studyNodes
    End Function

    ''' <summary>
    ''' Determines if the nodes have any children that are "granted"
    ''' </summary>
    Private Function HasChildrenGranted(ByVal nodes As DataMartPrivilegeNodeCollection) As Boolean
        Dim childrenGranted As Boolean = False

        'Check all the nodes and child nodes for a granted node
        For Each node As DataMartPrivilegeNode In nodes
            If node.IsGranted Then
                Return True
            ElseIf node.HasChildren AndAlso HasChildrenGranted(node.Nodes) Then
                Return True
            End If
        Next

        Return False
    End Function
#End Region

    ''' <summary>
    ''' Sets the add button enabled/disabled
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ResetAddButton()
        If Me.AvailableFieldList.Items.Count > 0 Then
            Me.AvailableFieldList.SelectedIndex = 0
            Me.AddFilterButton.Enabled = True
            Me.AvailableFieldList.Enabled = True
            Me.AddFilterLabel.Enabled = True
        Else
            Me.AddFilterButton.Enabled = False
            Me.AvailableFieldList.Enabled = False
            Me.AddFilterLabel.Enabled = False
        End If
    End Sub

    ''' <summary>
    ''' Saves the changes
    ''' </summary>
    Private Sub SaveChangesCommand()
        'If the grid is editing then finish the editing
        If Me.CommentFilterGridView.IsEditing Then
            If Me.CommentFilterGridView.ValidateEditor Then
                Me.CommentFilterGridView.CloseEditor()
            Else
                MessageBox.Show("You cannot save until the errors on the current filter are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Exit Sub
            End If
        End If

        If mFilterList.IsSavable Then
            Me.CommentFilterBindingSource.RaiseListChangedEvents = False
            Me.mFilterList.ApplyEdit()
            Me.mFilterList.Save()
            Me.mFilterList.BeginEdit()
            Me.SaveChangesButton.Enabled = (Me.mFilterList.IsSavable)
            Me.CancelChangesButton.Enabled = (Me.mFilterList.IsDirty)
            Me.CommentFilterBindingSource.RaiseListChangedEvents = True
            Me.CommentFilterBindingSource.ResetBindings(False)
        Else
            MessageBox.Show("You cannot save until all errors have been resolved")
        End If
    End Sub

    Private Sub CancelChangesCommand()
        Me.CommentFilterBindingSource.RaiseListChangedEvents = False
        Me.mFilterList.CancelEdit()
        Me.mFilterList.BeginEdit()
        Me.CommentFilterBindingSource.RaiseListChangedEvents = True
        Me.CommentFilterBindingSource.ResetBindings(False)
    End Sub

#Region " Main Form Closing Methods "
    Private Sub MainFormClosing(ByVal sender As Object, ByVal e As System.EventArgs)
        SaveGridLayoutProperties()
    End Sub

    Private Sub SaveGridLayoutProperties()
        Using ms As New IO.MemoryStream
            CommentFilterGridView.SaveLayoutToStream(ms)
            Dim data() As Byte = ms.ToArray
            My.Settings.CommentFilterGridSettings = data
        End Using
    End Sub

    Private Sub RestoreGridLayoutProperties()
        Dim data As Byte() = DirectCast(My.Settings.CommentFilterGridSettings, Byte())
        If data IsNot Nothing Then
            Using ms As New IO.MemoryStream(data)
                CommentFilterGridView.RestoreLayoutFromStream(ms)
            End Using
        End If
    End Sub
#End Region

#End Region


   
End Class