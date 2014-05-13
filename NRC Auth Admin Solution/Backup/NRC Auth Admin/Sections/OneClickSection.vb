Imports System.Collections.ObjectModel
Imports Nrc.DataMart.MySolutions.Library

Public Class OneClickSection

#Region " Private Members "

    Private mOrgUnitNavigator As OrgUnitNavigator
    Private mSelectedGroup As Nrc.NRCAuthLib.Group
    Private mHasDataChanged As Boolean

    Private mDeletedOneClicks As Dictionary(Of Integer, OneClickReport) = New Dictionary(Of Integer, Nrc.DataMart.MySolutions.Library.OneClickReport)

#End Region

#Region " Private Properties "

    Private Property HasDataChanged() As Boolean
        Get
            Return mHasDataChanged
        End Get
        Set(ByVal value As Boolean)
            mHasDataChanged = value
            OneClickNavigatorSaveTSButton.Enabled = value
        End Set
    End Property

#End Region

#Region " Overrides "

    Public Overrides Sub ActivateSection()

        AddHandler mOrgUnitNavigator.SelectedGroupChanging, AddressOf mOrgUnitNavigator_SelectedGroupChanging
        AddHandler mOrgUnitNavigator.SelectedGroupChanged, AddressOf mOrgUnitNavigator_SelectedGroupChanged

        InitializeAddGroup()
        HasDataChanged = False

        mOrgUnitNavigator.ShowGroupSelector = True

        'Save the selected group
        mSelectedGroup = mOrgUnitNavigator.SelectedGroup

        'Populate the OneClickGrid with data for the specified group
        PopulateOneClickGrid()

    End Sub


    Public Overrides Function AllowInactivate() As Boolean

        Return PromptUserToSaveOneClicks()

    End Function


    Public Overrides Sub InactivateSection()

        RemoveHandler mOrgUnitNavigator.SelectedGroupChanging, AddressOf mOrgUnitNavigator_SelectedGroupChanging
        RemoveHandler mOrgUnitNavigator.SelectedGroupChanged, AddressOf mOrgUnitNavigator_SelectedGroupChanged

        'Cleanup all memory collections and grid data sources

        'Clear the grids
        OneClickBindingSource.DataSource = Nothing

        'Clear the selected group
        mSelectedGroup = Nothing

        'Clear the deleted OneClicks collection
        mDeletedOneClicks = New Dictionary(Of Integer, OneClickReport)

        'Reset data changed
        HasDataChanged = False

    End Sub


    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        MyBase.RegisterNavControl(navCtrl)

        mOrgUnitNavigator = TryCast(navCtrl, OrgUnitNavigator)
        If mOrgUnitNavigator Is Nothing Then
            Throw New ArgumentException("The OneClickSection control expects a navigation control of type GroupNavigator")
        End If

    End Sub

#End Region

#Region " Private Methods "

    Private Sub InitializeAddGroup()

        'Get a collection of One Click Types
        Dim oneClickTypes As Collection(Of DataMart.MySolutions.Library.OneClickType) = OneClickType.GetAll()

        'Clear the menu
        OneClickNavigatorAddGroupTSDropDownButton.DropDownItems.Clear()

        'Populate the AddGroup menus
        For Each type As OneClickType In oneClickTypes
            'Add this type to the menu
            Dim typeItem As ToolStripMenuItem = New ToolStripMenuItem(type.OneClickTypeName, My.Resources.OneClickGroup16)
            OneClickNavigatorAddGroupTSDropDownButton.DropDownItems.Add(typeItem)

            'Add the all option to this menu
            Dim allItem As ToolStripMenuItem = New ToolStripMenuItem("Add All Reports In Group", My.Resources.OneClickGroup16, AddressOf OneClickNavigatorAddGroupItem_Click)
            With allItem
                .Tag = type.Definitions
                .ToolTipText = "Add all one click reports in this group"
            End With
            typeItem.DropDownItems.Add(allItem)

            'Add a seperator
            typeItem.DropDownItems.Add(New ToolStripSeparator())

            'Populate the definitions for this item
            For Each definition As OneClickDefinition In type.Definitions
                'Create the menuitem for this definition
                Dim defItem As ToolStripMenuItem = New ToolStripMenuItem(definition.OneClickReportName, My.Resources.Document16, AddressOf OneClickNavigatorAddGroupItem_Click)

                'Set the properties of this menuitem
                With defItem
                    .Tag = definition
                    .ToolTipText = definition.OneClickReportDescription
                End With

                'Add this definition to the menu
                typeItem.DropDownItems.Add(defItem)
            Next
        Next

    End Sub


    Private Sub PopulateOneClickGrid()

        'Clear the deleted OneClicks collection
        mDeletedOneClicks = New Dictionary(Of Integer, OneClickReport)()

        If mSelectedGroup IsNot Nothing Then
            'Set the panel caption
            OneClickSectionPanel.Caption = mSelectedGroup.Name & " - One Click Reports"

            'Set the data source for the grid to the data for the selected group
            OneClickBindingSource.DataSource = OneClickReport.GetByClientUserId(mSelectedGroup.GroupId)

            'Adjust the column widths
            OneClickGridView.BestFitColumns()
        Else
            'Set the panel Caption
            OneClickSectionPanel.Caption = "One Click Reports"

            'Set the data source for the grid to nothing
            OneClickBindingSource.DataSource = Nothing
        End If

        'Reset data changed
        HasDataChanged = False

    End Sub


    Private Sub OneClickDeleteRow()

        'Prompt the user to see if they are sure
        If MessageBox.Show("Do you wish to delete the selected One Click Report?", "Delete One Click Report", MessageBoxButtons.YesNo) <> DialogResult.Yes Then Return

        'If we made it to here then we need to delete the row
        'First add this one click report to the deleted collection
        Dim oneClick As OneClickReport = TryCast(OneClickGridView.GetRow(OneClickGridView.FocusedRowHandle), OneClickReport)
        If Not oneClick.IsNew Then
            mDeletedOneClicks.Add(oneClick.Id, oneClick)
        End If

        'Now delete the row from the grid
        OneClickGridView.DeleteRow(OneClickGridView.FocusedRowHandle)

    End Sub


    Private Function OneClickSaveAll() As Boolean

        'Set the wait cursor
        Me.Cursor = Cursors.WaitCursor

        Try
            'Delete any OneClicks that have been deleted
            For Each oneClick As OneClickReport In mDeletedOneClicks.Values
                If Not oneClick.IsNew Then
                    OneClickReport.Delete(oneClick.Id)
                End If
            Next

            'Reset OneClicks deleted list
            mDeletedOneClicks.Clear()

            'Now check each row and see if it is new or dirty
            'If so then insert/update new OneClick
            Dim oneClicks As Collection(Of OneClickReport) = DirectCast(OneClickBindingSource.DataSource, Collection(Of OneClickReport))
            For Each oneClick As OneClickReport In oneClicks
                'Determine what to do
                If oneClick.IsNew Then
                    'This is a new row so insert it into the database
                    oneClick.Insert()
                ElseIf oneClick.IsDirty Then
                    'This report is dirty so update the database
                    oneClick.Update()
                End If
            Next

            'If we made it to here then all is well
            HasDataChanged = False
            Return True

        Catch ex As Exception
            'We have encountered an error
            Globals.ReportException(ex, "Error Saving OneClick Reports")
            Return False

        Finally
            'Reset the wait cursor
            Me.Cursor = Me.DefaultCursor

        End Try

    End Function


    Private Function PromptUserToSaveOneClicks() As Boolean

        If Not IsOneClickGridValid() Then
            'Notify the user that errors exist
            'MessageBox.Show("Errors exist in the One Click Reports." & vbCrLf & vbCrLf & "Please correct and try again.", "Errors Exist!", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False

        ElseIf IsOneClickGridDirty() Then
            'Prompt the user to save changes
            Dim result As DialogResult = MessageBox.Show("You have made changes to the OneClick Report information." & vbCrLf & vbCrLf & "Do you want to save your changes?", "Save Changes?", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning)

            'Do as the user requested
            If result = DialogResult.Cancel Then
                'The user has canceled so we are out of here
                Return False
            ElseIf result = DialogResult.Yes Then
                'Save the changes
                Return OneClickSaveAll()
            ElseIf result = DialogResult.No Then
                'The user does not want to save the changes so refresh the grid from the database
                PopulateOneClickGrid()
                Return IsOneClickGridValid()
            End If
        Else
            'We are good to go
            Return True
        End If

    End Function


    Private Function GetNextOneClickOrderValue() As Integer

        'Initialize the next available order value
        Dim nextOrder As Integer = 1

        'Get a reference to the OneClickReport collection
        Dim oneClicks As Collection(Of OneClickReport) = DirectCast(OneClickBindingSource.DataSource, Collection(Of OneClickReport))

        'Loop through all the OneClick reports looking for the greatest value
        For Each oneClick As OneClickReport In oneClicks
            'Check to see if this order value is equal to or greater than the our next value
            If oneClick.Order >= nextOrder Then
                nextOrder = oneClick.Order + 1
            End If
        Next

        'Return the next value
        Return nextOrder

    End Function


    Private Sub AddOneClickDefinition(ByVal definition As OneClickDefinition)

        'Create the new OneClick report
        Dim oneClick As OneClickReport = New OneClickReport(mSelectedGroup.GroupId)

        'Set the properties of the new OneClick report
        With oneClick
            .CategoryName = definition.CategoryName
            .Description = definition.OneClickReportDescription
            .Name = definition.OneClickReportName
            .Order = GetNextOneClickOrderValue()
            .ReportId = definition.ReportId
        End With

        'Add the new report to the collection
        OneClickBindingSource.Add(oneClick)

    End Sub


    Private Sub SaveOneClickSectionProperties()

        Using ms As New IO.MemoryStream
            OneClickGridView.SaveLayoutToStream(ms)
            Dim data() As Byte = ms.ToArray
            My.Settings.OneClickSectionGridLayout = data
        End Using

    End Sub


    Private Sub RestoreOneClickSectionProperties()

        Dim data As Byte() = DirectCast(My.Settings.OneClickSectionGridLayout, Byte())

        If data IsNot Nothing Then
            Using ms As New IO.MemoryStream(data)
                OneClickGridView.RestoreLayoutFromStream(ms)
            End Using
        End If

    End Sub


    Private Sub MainFormClosing(ByVal sender As Object, ByVal e As System.EventArgs)

        SaveOneClickSectionProperties()

    End Sub

#Region " Private Methods - Validation "

    Private Function IsOneClickGridDirty() As Boolean

        Dim foundDirty As Boolean = False

        'Set the wait cursor
        Me.Cursor = Cursors.WaitCursor

        'Check to see if anything has been deleted
        If mDeletedOneClicks.Count > 0 Then
            'The delete collection contains at least one OneClick
            foundDirty = True
        End If

        If Not foundDirty Then
            'Check to see if anything in the grid is dirty
            Dim oneClicks As Collection(Of OneClickReport) = TryCast(OneClickBindingSource.DataSource, Collection(Of OneClickReport))
            If oneClicks IsNot Nothing Then
                For Each oneClick As OneClickReport In oneClicks
                    If oneClick.IsNew OrElse oneClick.IsDirty Then
                        'We have a new or dirty OnClick
                        foundDirty = True
                        Exit For
                    End If
                Next
            End If
        End If

        'Reset the wait cursor
        Me.Cursor = Me.DefaultCursor

        Return foundDirty

    End Function


    Private Function IsOneClickGridValid() As Boolean

        With OneClickGridView
            If .IsEditing Then
                If .ValidateEditor Then
                    .CloseEditor()
                    Return Not .HasColumnErrors
                Else
                    Return False
                End If
            Else
                Return Not .HasColumnErrors
            End If
        End With

    End Function


    Private Function IsOneClickOrderValid(ByVal value As Object, ByRef errorText As String) As Boolean

        Dim testInteger As Integer

        If value Is Nothing Then
            errorText = "You must provide a Display Order!"
            Return False
        ElseIf Not Integer.TryParse(value.ToString, testInteger) Then
            errorText = "The Display Order must be an integer!"
            Return False
        ElseIf Not testInteger > 0 Then
            errorText = "The Display Order must be greater than 0!"
            Return False
        Else
            'Get a reference to the OneClickReport collection and the focused row handle
            Dim oneClicks As Collection(Of OneClickReport) = TryCast(OneClickBindingSource.DataSource, Collection(Of OneClickReport))
            Dim focusedRow As Integer = OneClickGridView.FocusedRowHandle

            'Check all row to see if this order value already exists
            Dim objCnt As Integer = -1
            For Each oneClick As OneClickReport In oneClicks
                objCnt += 1
                If focusedRow <> OneClickGridView.GetRowHandle(objCnt) AndAlso oneClick.Order = testInteger Then
                    errorText = "You cannot have duplicate Display Order values!"
                    Return False
                End If
            Next
        End If

        'If we made it to here all is well
        Return True

    End Function


    Private Function IsOneClickCategoryValid(ByVal value As Object, ByRef errorText As String) As Boolean

        If value Is Nothing OrElse String.IsNullOrEmpty(value.ToString) Then
            errorText = "You must provide a Category Name!"
            Return False
        End If

        'If we made it to here all is well
        Return True

    End Function


    Private Function IsOneClickNameValid(ByVal value As Object, ByRef errorText As String) As Boolean

        If value Is Nothing OrElse String.IsNullOrEmpty(value.ToString) Then
            errorText = "You must provide a Report Name!"
            Return False
        End If

        'If we made it to here all is well
        Return True

    End Function


    Private Function IsOneClickDescriptionValid(ByVal value As Object, ByRef errorText As String) As Boolean

        If value Is Nothing OrElse String.IsNullOrEmpty(value.ToString) Then
            errorText = "You must provide a Report Description!"
            Return False
        End If

        'If we made it to here all is well
        Return True

    End Function


    Private Function IsOneClickReportIdValid(ByVal value As Object, ByRef errorText As String) As Boolean

        Dim testInteger As Integer

        If value Is Nothing Then
            errorText = "You must provide a Report ID!"
            Return False
        ElseIf Not Integer.TryParse(value.ToString, testInteger) Then
            errorText = "The Report ID must be an integer!"
            Return False
        ElseIf Not testInteger > 0 Then
            errorText = "The Report ID must be greater than 0!"
            Return False
        End If

        'If we made it to here all is well
        Return True

    End Function

#End Region

#End Region

#Region " Control Events "

#Region " Control Events - Form "

    Private Sub OneClickSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        RestoreOneClickSectionProperties()

        AddHandler Globals.MainFormClosing, AddressOf MainFormClosing

    End Sub

#End Region

#Region " Control Events - GroupNavigator "

    Private Sub mOrgUnitNavigator_SelectedGroupChanging(ByVal sender As Object, ByVal e As OrgUnitNavigator.SelectedGroupChangingEventArgs)

        'Check to see if we can change groups
        e.Cancel = Not PromptUserToSaveOneClicks()

    End Sub


    Private Sub mOrgUnitNavigator_SelectedGroupChanged(ByVal sender As Object, ByVal e As OrgUnitNavigator.SelectedGroupChangedEventArgs)

        'Save the selected group
        mSelectedGroup = e.Group

        'Populate the OneClickGrid with data for the specified group
        PopulateOneClickGrid()

    End Sub

#End Region

#Region " Control Events - OneClickNavigator "

    Private Sub OneClickNavigatorAddNewTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OneClickNavigatorAddNewTSButton.Click

        OneClickBindingSource.AddNew()

    End Sub


    Private Sub OneClickNavigatorAddGroupItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

        Dim definition As OneClickDefinition

        'Get a reference to the menu item that was clicked
        Dim menuItem As ToolStripMenuItem = DirectCast(sender, ToolStripMenuItem)

        'Determine what we are adding
        If TypeOf menuItem.Tag Is OneClickDefinition Then
            'We are adding a single report
            definition = DirectCast(menuItem.Tag, OneClickDefinition)
            AddOneClickDefinition(definition)
        Else
            'We are adding a collection of reports
            Dim definitions As Collection(Of OneClickDefinition) = DirectCast(menuItem.Tag, Collection(Of OneClickDefinition))
            For Each definition In definitions
                AddOneClickDefinition(definition)
            Next
        End If
    End Sub


    Private Sub OneClickNavigatorDeleteTSButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles OneClickNavigatorDeleteTSButton.Click

        OneClickDeleteRow()

    End Sub


    Private Sub OneClickNavigatorSaveTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OneClickNavigatorSaveTSButton.Click

        If Not IsOneClickGridValid() Then
            MessageBox.Show("Errors exist within the grid!" & vbCrLf & vbCrLf & "Please correct the errors and try again.", "Errors Exist", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        'If there is nothing to save then we are out of here
        If Not IsOneClickGridDirty() Then Exit Sub

        'If we made it to here then save the grid
        OneClickSaveAll()

    End Sub


    Private Sub OneClickNavigatorEditStandardTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OneClickNavigatorEditStandardTSButton.Click

        Dim editDialog As StandardOneClickDialog = New StandardOneClickDialog()

        editDialog.ShowDialog()

    End Sub

#End Region

#Region " Control Events - OneClickBindingSource "

    Private Sub OneClickBindingSource_AddingNew(ByVal sender As Object, ByVal e As System.ComponentModel.AddingNewEventArgs) Handles OneClickBindingSource.AddingNew

        'Create the new OneClickReport object
        Dim oneClick As OneClickReport = New OneClickReport(mSelectedGroup.GroupId)

        'Set the Order value to the next available
        oneClick.Order = GetNextOneClickOrderValue()

        'Set the new object
        e.NewObject = oneClick

    End Sub


    Private Sub OneClickBindingSource_CurrentChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OneClickBindingSource.CurrentChanged

        OneClickNavigatorDeleteTSButton.Enabled = (OneClickBindingSource.Current IsNot Nothing)

    End Sub


    Private Sub OneClickBindingSource_DataSourceChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OneClickBindingSource.DataSourceChanged

        'Determine whether enable or disable
        Dim enabled As Boolean = (OneClickBindingSource.DataSource IsNot Nothing)

        'Enable the grid and navigator add buttons
        OneClickGrid.Enabled = enabled
        OneClickNavigatorAddNewTSButton.Enabled = enabled
        OneClickNavigatorAddGroupTSDropDownButton.Enabled = enabled

    End Sub


    Private Sub OneClickBindingSource_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles OneClickBindingSource.ListChanged

        HasDataChanged = (OneClickBindingSource.List IsNot Nothing)

    End Sub

#End Region

#Region " Control Events - OneClickGridView "

    Private Sub OneClickGridView_CellValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.CellValueChangedEventArgs) Handles OneClickGridView.CellValueChanging

        HasDataChanged = True

    End Sub


    Private Sub OneClickGridView_InvalidRowException(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.InvalidRowExceptionEventArgs) Handles OneClickGridView.InvalidRowException

        'Suppress displaying the error message box
        e.ExceptionMode = DevExpress.XtraEditors.Controls.ExceptionMode.NoAction

    End Sub


    Private Sub OneClickGridView_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles OneClickGridView.KeyDown

        'If the user pressed the delete key then delete the selected row
        If (e.KeyCode = Keys.Delete) Then
            OneClickDeleteRow()
        End If

    End Sub


    Private Sub OneClickGridView_ValidatingEditor(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.BaseContainerValidateEditorEventArgs) Handles OneClickGridView.ValidatingEditor

        Select Case OneClickGridView.FocusedColumn.AbsoluteIndex
            Case OneClickOrderColumn.AbsoluteIndex
                e.Valid = IsOneClickOrderValid(e.Value, e.ErrorText)

            Case OneClickCategoryColumn.AbsoluteIndex
                e.Valid = IsOneClickCategoryValid(e.Value, e.ErrorText)

            Case OneClickNameColumn.AbsoluteIndex
                e.Valid = IsOneClickNameValid(e.Value, e.ErrorText)

            Case OneClickDescriptionColumn.AbsoluteIndex
                e.Valid = IsOneClickDescriptionValid(e.Value, e.ErrorText)

            Case OneClickReportIdColumn.AbsoluteIndex
                e.Valid = IsOneClickReportIdValid(e.Value, e.ErrorText)

        End Select

    End Sub

#End Region

#End Region
End Class
