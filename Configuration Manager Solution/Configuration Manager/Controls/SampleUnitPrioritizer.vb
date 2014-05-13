Imports System.Collections.ObjectModel
Imports Nrc.QualiSys.Library

Public Class SampleUnitPrioritizer

    Public Event ViewModeChanged(ByVal sender As Object, ByVal e As PrioritierViewModeChangedEventArgs)

#Region " Enum "

    Public Enum DataViewMode
        TreeOnly = 1
        ListOnly = 2
        TreeAndList = 3
    End Enum

    Public Enum DataTypes
        Text = 1
        Numeric = 2
        DateTime = 3
    End Enum

    Private Enum SortOrderIcon
        Ascending = 0
        Descending = 1
        None = 2
    End Enum

#End Region

#Region " Private Fields "

    Private mEnable As Boolean = True
    Private mViewMode As DataViewMode = DataViewMode.TreeAndList
    Private mSampleUnits As Collection(Of SampleUnit)
    Private mSelectedGroup As PriorityGroupButton

#End Region

#Region " Public Properties "

    Public Property SampleUnits() As Collection(Of SampleUnit)
        Get
            Return mSampleUnits
        End Get
        Set(ByVal value As Collection(Of SampleUnit))
            mSampleUnits = value
            'Initialize the control for this set of sample units
            Me.Initialize(mSampleUnits)
        End Set
    End Property

    Public Property ViewMode() As DataViewMode
        Get
            Return mViewMode
        End Get
        Set(ByVal value As DataViewMode)
            If (mViewMode = value) Then Return
            mViewMode = value

            'Collapse or expand panels
            Select Case mViewMode
                Case DataViewMode.TreeOnly
                    PrioritySampleUnitPanel.Panel1Collapsed = False
                    PrioritySampleUnitPanel.Panel2Collapsed = True
                Case DataViewMode.ListOnly
                    PrioritySampleUnitPanel.Panel1Collapsed = True
                    PrioritySampleUnitPanel.Panel2Collapsed = False
                Case DataViewMode.TreeAndList
                    PrioritySampleUnitPanel.Panel1Collapsed = False
                    PrioritySampleUnitPanel.Panel2Collapsed = False
            End Select

            'Set radio buttons
            Select Case mViewMode
                Case DataViewMode.TreeOnly
                    TreeOnlyOption.Checked = True
                Case DataViewMode.ListOnly
                    ListOnlyOption.Checked = True
                Case DataViewMode.TreeAndList
                    TreeAndListOption.Checked = True
            End Select

            'Trigger event to notify the view mode change
            RaiseEvent ViewModeChanged(Me, New PrioritierViewModeChangedEventArgs(Me.ViewMode))
        End Set
    End Property

    Public Property Enable() As Boolean
        Get
            Return mEnable
        End Get
        Set(ByVal value As Boolean)
            mEnable = value
            CommandPanel.Enabled = mEnable
            SampleUnitTree.Enabled = mEnable
            SampleUnitList.Enabled = mEnable
        End Set
    End Property

#End Region

#Region " Private Properties "

    ''' <summary>
    ''' Keeps track of the currently selected Priority Group
    ''' </summary>
    Private Property SelectedGroup() As PriorityGroupButton
        Get
            Return mSelectedGroup
        End Get
        Set(ByVal value As PriorityGroupButton)
            'Deselect previous group
            If mSelectedGroup IsNot Nothing Then
                mSelectedGroup.IsSelected = False
                mSelectedGroup.Invalidate()
            End If

            'Select new group
            mSelectedGroup = value
            mSelectedGroup.IsSelected = True
            mSelectedGroup.Invalidate()
        End Set
    End Property

#End Region

#Region " Event Handlers "

#Region " Drag-Drop Event Handlers "

    ''' <summary>
    ''' Fires when a tree node begins to be dragged
    ''' </summary>
    Private Sub SampleUnitTree_ItemDrag(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemDragEventArgs) Handles SampleUnitTree.ItemDrag
        If e.Button = Windows.Forms.MouseButtons.Left Then
            'Get the node
            'Dim node As TreeNode = Me.SampleUnitTree.GetNodeAt(Me.PointToClient(System.Windows.Forms.Cursor.Position))
            Dim node As TreeNode = TryCast(e.Item, TreeNode)
            If node IsNot Nothing Then
                'Get the unit for the node
                Dim unit As SampleUnit = TryCast(node.Tag, SampleUnit)
                If unit IsNot Nothing Then
                    'Make sure that the node is one that actually belongs to the current priority group
                    'just would be more difficult if we support dragging nodes
                    'that are not in the current priority grup
                    If Me.SelectedGroup.SampleUnits.Contains(unit) Then
                        'Start the drag
                        Me.SampleUnitTree.DoDragDrop(unit, DragDropEffects.Move)
                    End If
                End If
            End If
        End If
    End Sub

    Private Sub SampleUnitList_ItemDrag(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemDragEventArgs) Handles SampleUnitList.ItemDrag
        'If no item is selected, do nothing
        If (SampleUnitList.SelectedItems Is Nothing OrElse _
            SampleUnitList.SelectedItems.Count = 0) Then
            Return
        End If

        'Populate selected sample unit collection
        Dim units As New Collection(Of SampleUnit)
        For Each item As ListViewItem In SampleUnitList.SelectedItems
            Dim unit As SampleUnit = TryCast(item.Tag, SampleUnit)
            If (unit IsNot Nothing) Then
                units.Add(unit)
            End If
        Next

        'Call DoDragDrop
        If (units.Count > 0) Then
            SampleUnitList.DoDragDrop(units, DragDropEffects.Move)
        End If

    End Sub

    ''' <summary>
    ''' Fires when a something is dragged into a priority group
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub PriorityGroup_DragEnter(ByVal sender As Object, ByVal e As DragEventArgs)
        'Get the group that it is being dropped onto
        Dim newGroup As PriorityGroupButton = TryCast(sender, PriorityGroupButton)
        'If the new group is the current group then do nothing
        If newGroup Is Nothing OrElse newGroup Is Me.SelectedGroup Then
            e.Effect = DragDropEffects.None
        Else
            e.Effect = DragDropEffects.Move
        End If
    End Sub

    ''' <summary>
    ''' Fires when a something is dropped over a priority group
    ''' </summary>
    Private Sub PriorityGroup_DragDrop(ByVal sender As Object, ByVal e As DragEventArgs)
        'Try to get out SampleUnit or SampleUnit collection
        Dim units As Collection(Of SampleUnit)
        units = TryCast(e.Data.GetData(GetType(Collection(Of SampleUnit))), Collection(Of SampleUnit))

        'Try to get out a SampleUnit if it's not SampleUnit collection
        If (units Is Nothing) Then
            Dim unit As SampleUnit = TryCast(e.Data.GetData(GetType(SampleUnit)), SampleUnit)
            If (unit Is Nothing) Then Return
            units = New Collection(Of SampleUnit)
            units.Add(unit)
        End If

        'Get the group that it is being dropped onto
        Dim destGroup As PriorityGroupButton = TryCast(sender, PriorityGroupButton)

        'If the new group is the current group then do nothing
        If destGroup Is Nothing OrElse destGroup Is Me.SelectedGroup Then Return

        MoveUnitsToGroup(units, destGroup)
    End Sub

#End Region

#Region " Paint Event Handlers "

    ''' <summary>
    ''' Fires when the Priority Group panel is painted to give it a right border
    ''' </summary>
    Private Sub PriorityGroupPanel_Paint(ByVal sender As System.Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles PriorityGroupPanel.Paint
        Dim rect As Rectangle = Me.PriorityGroupPanel.Bounds
        'Draw a right border
        Using borderPen As New Pen(ProfessionalColors.ToolStripBorder)
            e.Graphics.DrawLine(borderPen, rect.Width - 1, 0, rect.Width - 1, rect.Height)
        End Using
    End Sub

    ''' <summary>
    ''' Fires when the Command panel is painted to give it a right border
    ''' </summary>
    Private Sub CommandPanel_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles CommandPanel.Paint
        Dim rect As Rectangle = Me.CommandPanel.Bounds
        'Draw a right border
        Using borderPen As New Pen(ProfessionalColors.ToolStripBorder)
            e.Graphics.DrawLine(borderPen, rect.Width - 1, 0, rect.Width - 1, rect.Height)
        End Using
    End Sub

    ''' <summary>
    ''' Fires when the bottom panel is painted to give it a top border
    ''' </summary>
    Private Sub BottomPanel_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles BottomPanel.Paint
        Dim rect As Rectangle = Me.BottomPanel.Bounds
        'Draw a top border
        Using borderPen As New Pen(ProfessionalColors.ToolStripBorder)
            e.Graphics.DrawLine(borderPen, 0, 0, rect.Width, 0)
        End Using
    End Sub

#End Region

#Region " Command Button & Context Menu Event Handlers "

    Private Sub MoveUpButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveUpButton.Click
        MoveUp()
    End Sub

    Private Sub MoveDownButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveDownButton.Click
        MoveDown()
    End Sub

    Private Sub AddAboveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddAboveButton.Click
        AddAbove()
    End Sub

    Private Sub AddBelowButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddBelowButton.Click
        AddBelow()
    End Sub

    Private Sub DeleteGroupButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteGroupButton.Click
        DeleteGroup()
    End Sub

    Private Sub CleanupButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanupButton.Click
        Cleanup()
    End Sub

    Private Sub PriorityGroupContextMenu_Opening(ByVal sender As System.Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles PriorityGroupContextMenu.Opening
        Dim group As PriorityGroupButton = TryCast(PriorityGroupContextMenu.SourceControl, PriorityGroupButton)
        If (group Is Nothing) Then
            e.Cancel = True
            Return
        End If

        SelectCurrentPriorityGroup(group)

        MoveUpMenuItem.Enabled = MoveUpButton.Enabled
        MoveDownMenuItem.Enabled = MoveDownButton.Enabled
        AddAboveMenuItem.Enabled = AddAboveButton.Enabled
        AddBelowMenuItem.Enabled = AddBelowButton.Enabled
        DeleteGroupMenuItem.Enabled = DeleteGroupButton.Enabled
        CleanupMenuItem.Enabled = CleanupButton.Enabled
    End Sub

    Private Sub MoveUpMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveUpMenuItem.Click
        MoveUp()
    End Sub

    Private Sub MoveDownMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveDownMenuItem.Click
        MoveDown()
    End Sub

    Private Sub AddAboveMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddAboveMenuItem.Click
        AddAbove()
    End Sub

    Private Sub AddBelowMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddBelowMenuItem.Click
        AddBelow()
    End Sub

    Private Sub DeleteGroupMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteGroupMenuItem.Click
        DeleteGroup()
    End Sub

    Private Sub CleanupMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanupMenuItem.Click
        Cleanup()
    End Sub

#End Region

#Region " Other Event Handlers "

    ''' <summary>
    ''' Fires when a Priority Group is clicked
    ''' </summary>
    Private Sub PriorityGroup_Clicked(ByVal sender As Object, ByVal e As EventArgs)
        'Get the group 
        Dim group As PriorityGroupButton = TryCast(sender, PriorityGroupButton)
        If group Is Nothing Then Return

        'if is selected group, do nothing
        If group Is Me.SelectedGroup Then Return

        'Set selected priority group
        SelectCurrentPriorityGroup(group)
    End Sub

    ''' <summary>
    ''' Fires when before a node is selected in tree view
    ''' </summary>
    Private Sub SampleUnitTree_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles SampleUnitTree.BeforeSelect
        'Don't allow nodes to be selected
        'It will just interfere with our highlighting...
        e.Cancel = True
    End Sub

    ''' <summary>
    ''' Fired when the size of sample unit list control changed
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub SampleUnitList_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SampleUnitList.SizeChanged
        'resize "unit name" column to fill the rest of list view
        Dim colWidth As Integer
        colWidth = SampleUnitList.Width - SampleUnitList.Columns(0).Width - 25
        If (colWidth < 100) Then colWidth = 100
        SampleUnitList.Columns(1).Width = colWidth
    End Sub

    ''' <summary>
    ''' Fired when view mode radio buttons clicked
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub ViewMode_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TreeOnlyOption.CheckedChanged, ListOnlyOption.CheckedChanged, TreeAndListOption.CheckedChanged
        If (TreeOnlyOption.Checked) Then
            Me.ViewMode = DataViewMode.TreeOnly
        ElseIf (ListOnlyOption.Checked) Then
            Me.ViewMode = DataViewMode.ListOnly
        ElseIf (TreeAndListOption.Checked) Then
            Me.ViewMode = DataViewMode.TreeAndList
        End If
    End Sub

    ''' <summary>
    ''' Fired when sample unit context menu pops up
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub SampleUnitContextMenu_Opening(ByVal sender As System.Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles SampleUnitContextMenu.Opening
        'Check from which control the context menu pops up
        Dim ctrl As Control = SampleUnitContextMenu.SourceControl
        If (ctrl Is SampleUnitTree) Then
            SampleUnitTreeContextMenu_Opening(sender, e)
        ElseIf (ctrl Is SampleUnitList) Then
            SampleUnitListContextMenu_Opening(sender, e)
        End If
    End Sub

    ''' <summary>
    ''' Fired when an item in sample unit context menu clicked
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub SampleUnitMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim menuItem As ToolStripMenuItem = DirectCast(sender, ToolStripMenuItem)
        Dim profile As SampleUnitContextMenuProfile = TryCast(menuItem.Tag, SampleUnitContextMenuProfile)
        If (profile Is Nothing) Then Return

        Dim destGroup As PriorityGroupButton = SearchGroupByPriority(profile.MoveToPriority)
        If (destGroup Is Nothing) Then Return

        MoveUnitsToGroup(profile.SelectedUnits, destGroup)
    End Sub

    ''' <summary>
    ''' Fired when list view column header is clicked.
    ''' Sorting of data items by clicked column
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub SampleUnitList_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles SampleUnitList.ColumnClick
        Dim dataType As DataTypes

        Select Case e.Column
            Case 0
                dataType = DataTypes.Numeric
            Case 1
                dataType = DataTypes.Text
            Case Else
                Return
        End Select

        Dim sorter As ListViewItemComparer = TryCast(SampleUnitList.ListViewItemSorter, ListViewItemComparer)

        If (sorter Is Nothing) Then
            sorter = New ListViewItemComparer(e.Column, dataType, SortOrder.Ascending)
        ElseIf (sorter.Column <> e.Column) Then
            sorter = New ListViewItemComparer(e.Column, dataType, SortOrder.Ascending)
        Else
            sorter.ToggleSortOrder()
        End If

        'Keep the listview.Sorting property synchronized, just for tidiness
        SampleUnitList.Sorting = sorter.SortOrder

        'Begin to update listview
        SampleUnitList.BeginUpdate()

        'Remove original sorter
        RemoveListSorter()

        'Perform the sort
        SampleUnitList.ListViewItemSorter = sorter
        SampleUnitList.Sort()

        'Show sort order icon in the column header
        For Each header As ColumnHeader In SampleUnitList.Columns
            If header.Index = sorter.Column Then
                If (sorter.SortOrder = SortOrder.Ascending) Then
                    header.ImageIndex = SortOrderIcon.Ascending
                ElseIf (sorter.SortOrder = SortOrder.Descending) Then
                    header.ImageIndex = SortOrderIcon.Descending
                Else
                    header.ImageIndex = SortOrderIcon.None
                End If
                Exit For
            End If
        Next

        SampleUnitList.EndUpdate()
    End Sub

#End Region

#End Region

#Region " Public Methods "

    'Rrfresh me to reflect for the sample unit updates
    Public Sub RefreshContent()
        RefreshContent(Me.mSampleUnits)
    End Sub

#End Region

#Region " Private Methods "

#Region " Priority Group Methods "

    ''' <summary>
    ''' Populate all the priority group buttons
    ''' </summary>
    ''' <param name="units"></param>
    ''' <remarks></remarks>
    Private Sub InitializePriorityGroups(ByVal units As Collection(Of SampleUnit))
        'Clear any existing groups
        Me.RemovePriorityGroups()

        'Create a new list of priority groups
        Dim groupList As New SortedDictionary(Of Integer, PriorityGroupButton)

        'Examine all of the units we have and create a group for each distinct 
        'priority found.  Add each unit the correct priority group
        If units IsNot Nothing Then
            Me.FillGroups(units, groupList)
        End If

        'Now add all the priority groups to the panel in order of priority
        Dim isFirst As Boolean = True
        For Each group As PriorityGroupButton In groupList.Values
            'Add to panel
            Me.PriorityGroupPanel.Controls.Add(group)

            'If this is our first one then auto-select and load up its units
            If isFirst Then
                Me.SelectedGroup = group
                isFirst = False
            End If
        Next
        SelectCurrentPriorityGroup(Me.SelectedGroup)
    End Sub

    ''' <summary>
    ''' Check the sample unit collection to see if there is any new priority.
    ''' If yes, create priority button for the new priority
    ''' </summary>
    ''' <param name="units"></param>
    ''' <remarks></remarks>
    Private Sub RefreshPriorityGroups(ByVal units As Collection(Of SampleUnit))
        'Create a new list of priority groups
        Dim groupList As New SortedDictionary(Of Integer, PriorityGroupButton)

        'Restore existing groups
        Me.BackupExistGroup(groupList)

        'Remove any existing groups from panel
        Me.PriorityGroupPanel.Controls.Clear()

        'Examine all of the units we have and create a group for each distinct 
        'priority found.  Add each unit the correct priority group
        If units IsNot Nothing Then
            Me.FillGroups(units, groupList)
        End If

        'Now add all the priority groups to the panel in order of priority
        For Each group As PriorityGroupButton In groupList.Values
            'Add to panel
            Me.PriorityGroupPanel.Controls.Add(group)
        Next

        SelectCurrentPriorityGroup(Me.SelectedGroup)
    End Sub

    ''' <summary>
    ''' Copy all the priority buttons in the panel to the priority button dictionary
    ''' </summary>
    ''' <param name="groupList"></param>
    ''' <remarks></remarks>
    Private Sub BackupExistGroup(ByVal groupList As SortedDictionary(Of Integer, PriorityGroupButton))
        For Each group As PriorityGroupButton In Me.PriorityGroupPanel.Controls
            groupList.Add(group.Priority, group)
            group.SampleUnits = New Collection(Of SampleUnit)
        Next
    End Sub

    ''' <summary>
    ''' Recursive method to examine all sample units and split them into priority groups
    ''' </summary>
    Private Sub FillGroups(ByVal units As Collection(Of SampleUnit), ByVal groupList As SortedDictionary(Of Integer, PriorityGroupButton))
        If units IsNot Nothing Then
            For Each unit As SampleUnit In units
                If unit.NeedsDelete Then Continue For

                'If we don't yet have a group for this priority then create one
                If Not groupList.ContainsKey(unit.Priority) Then
                    Dim group As New PriorityGroupButton
                    'Set the group priority & context menu
                    group.Priority = unit.Priority
                    group.ContextMenuStrip = PriorityGroupContextMenu

                    'Attach event handlers
                    AddHandler group.Click, AddressOf PriorityGroup_Clicked
                    AddHandler group.DragDrop, AddressOf PriorityGroup_DragDrop
                    AddHandler group.DragEnter, AddressOf PriorityGroup_DragEnter

                    'Add this group to our list
                    groupList.Add(unit.Priority, group)
                End If

                'Add the sampleunit to the appropriate group
                groupList(unit.Priority).SampleUnits.Add(unit)

                'If the unit has children then recursively call 
                If unit.ChildUnits IsNot Nothing AndAlso unit.ChildUnits.Count > 0 Then
                    Me.FillGroups(unit.ChildUnits, groupList)
                End If
            Next
        End If
    End Sub

    ''' <summary>
    ''' Dispose all the groups and remove them from the panel
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub RemovePriorityGroups()
        'Before clearing the groups from the panel we should properly remove any
        'event handlers we have dynamicaly attached
        For Each group As PriorityGroupButton In Me.PriorityGroupPanel.Controls
            RemoveHandler group.Click, AddressOf PriorityGroup_Clicked
            RemoveHandler group.DragDrop, AddressOf PriorityGroup_DragDrop
            RemoveHandler group.DragEnter, AddressOf PriorityGroup_DragEnter
        Next

        'Now clear them all
        Me.PriorityGroupPanel.Controls.Clear()
    End Sub

    ''' <summary>
    ''' Set current selected priority group
    ''' </summary>
    ''' <param name="group"></param>
    ''' <remarks></remarks>
    Private Sub SelectCurrentPriorityGroup(ByVal group As PriorityGroupButton)
        If group IsNot Nothing Then
            'Set this as the selected group
            Me.SelectedGroup = group

            'Load the group
            Me.LoadPriorityGroup(group)

            'Enable/disable command buttons
            EnableCommandButtons()
        End If
    End Sub

    ''' <summary>
    ''' Get priority groups shown in the panel
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetPriorityGroups() As Collection(Of PriorityGroupButton)
        Dim groups As New Collection(Of PriorityGroupButton)
        For Each group As PriorityGroupButton In Me.PriorityGroupPanel.Controls
            groups.Add(group)
        Next
        Return groups
    End Function

    ''' <summary>
    ''' Get the index number for a specified priority group
    ''' </summary>
    ''' <param name="groups"></param>
    ''' <param name="group"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function IndexOfGroup(ByVal groups As Collection(Of PriorityGroupButton), ByVal group As PriorityGroupButton) As Integer
        If (groups Is Nothing) Then Return -1
        If (group Is Nothing) Then Return -1
        Dim id As Integer = 0
        For Each item As PriorityGroupButton In groups
            If (item Is group) Then Return (id)
            id += 1
        Next
        Return -1
    End Function

    ''' <summary>
    ''' Search priority group by priority value
    ''' </summary>
    ''' <param name="priority"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function SearchGroupByPriority(ByVal priority As Integer) As PriorityGroupButton
        For Each group As PriorityGroupButton In Me.PriorityGroupPanel.Controls
            If (group.Priority = priority) Then Return group
        Next
        Return Nothing
    End Function

    ''' <summary>
    ''' Move sample units from selected priority group to a specified group
    ''' </summary>
    ''' <param name="units"></param>
    ''' <param name="destGroup"></param>
    ''' <remarks></remarks>
    Private Sub MoveUnitsToGroup(ByVal units As Collection(Of SampleUnit), ByVal destGroup As PriorityGroupButton)
        'If the new group is the current group then do nothing
        If destGroup Is Nothing OrElse destGroup Is Me.SelectedGroup Then Return

        For Each unit As SampleUnit In units
            'Remove the sample unit from the current group
            Me.SelectedGroup.SampleUnits.Remove(unit)
            'Add sample unit to new group
            destGroup.SampleUnits.Add(unit)
            'Set the sample unit's new priority
            unit.Priority = destGroup.Priority
        Next

        'Go through the tree ad highlight the nodes in the current group
        Me.DehighlightUnits(units)

        'Remove from ListView
        RemoveUnitsFromList(units)

        'Refresh selected group & destination group to update the sample unit count
        destGroup.Invalidate()
        Me.SelectedGroup.Invalidate()
    End Sub

#End Region

#Region " Sample Unit Tree Methods "

    ''' <summary>
    ''' Initializes the sample unit tree
    ''' </summary>
    ''' <param name="units"></param>
    ''' <remarks></remarks>
    Private Sub InitializeSampleUnitTree(ByVal units As Collection(Of SampleUnit))
        'Pause UI updates
        Me.SampleUnitTree.BeginUpdate()

        'Clear out any tree nodes
        Me.SampleUnitTree.Nodes.Clear()

        'Recursively traverse the sampleunit tree and create nodes for each unit
        Me.PopulateTreeNodes(units, Me.SampleUnitTree.Nodes)

        'Expand all 
        Me.SampleUnitTree.ExpandAll()

        'Make the first node visible
        If (Me.SampleUnitTree.Nodes.Count > 0) Then
            Me.SampleUnitTree.Nodes(0).EnsureVisible()
        End If

        'Resume UI updates
        Me.SampleUnitTree.EndUpdate()
    End Sub

    ''' <summary>
    ''' Populate sample unit tree nodes
    ''' </summary>
    ''' <param name="untis"></param>
    ''' <param name="nodes"></param>
    ''' <remarks></remarks>
    Private Sub PopulateTreeNodes(ByVal untis As Collection(Of SampleUnit), ByVal nodes As TreeNodeCollection)
        If untis IsNot Nothing Then
            For Each unit As SampleUnit In untis
                If unit.NeedsDelete Then Continue For

                'Create a tree node for each unit
                Dim node As New TreeNode(String.Format("{0} ({1})", unit.Name, unit.Priority))
                node.Tag = unit
                nodes.Add(node)

                'If the unit has children then recursively fill out the nodes
                If unit.ChildUnits IsNot Nothing AndAlso unit.ChildUnits.Count > 0 Then
                    Me.PopulateTreeNodes(unit.ChildUnits, node.Nodes)
                End If
            Next
        End If
    End Sub

    ''' <summary>
    ''' Highlight specified sample units in the tree and dehighlight the others.
    ''' Refresh text for all the nodes
    ''' </summary>
    ''' <param name="units"></param>
    ''' <remarks></remarks>
    Private Sub RefreshSampleUnitTree(ByVal units As Collection(Of SampleUnit))
        If (units Is Nothing) Then units = New Collection(Of SampleUnit)

        Me.SampleUnitTree.BeginUpdate()
        RefreshSampleUnitTree(Me.SampleUnitTree.Nodes, units)
        Me.SampleUnitTree.EndUpdate()
    End Sub

    ''' <summary>
    ''' Highlight specified sample units for the nodes and dehighlight the others.
    ''' Refresh text for all the nodes
    ''' </summary>
    ''' <param name="nodes"></param>
    ''' <param name="selectedUnits"></param>
    ''' <remarks></remarks>
    Private Sub RefreshSampleUnitTree(ByVal nodes As TreeNodeCollection, ByVal selectedUnits As Collection(Of SampleUnit))
        If (selectedUnits Is Nothing) Then selectedUnits = New Collection(Of SampleUnit)

        'Go through each node and check if it is in the currently selected group
        For Each node As TreeNode In nodes
            'Get the unit
            Dim unit As SampleUnit = TryCast(node.Tag, SampleUnit)
            If unit Is Nothing Then Continue For

            'If current group contains this unit then highlight
            If selectedUnits.Contains(unit) Then
                'node.BackColor = Color.LemonChiffon
                node.ForeColor = SystemColors.ControlText
            Else
                'node.BackColor = Me.SampleUnitTree.BackColor
                node.ForeColor = SystemColors.GrayText
            End If

            'Reset the text to make sure the priority value is correct
            node.Text = String.Format("{0} ({1})", unit.Name, unit.Priority)

            'Recursively call for children
            If (node.Nodes.Count > 0) Then Me.RefreshSampleUnitTree(node.Nodes, selectedUnits)
        Next

    End Sub

    ''' <summary>
    ''' Dehighlight specified sample units in the tree.
    ''' Refresh text for all the nodes
    ''' </summary>
    ''' <param name="units"></param>
    ''' <remarks></remarks>
    Private Sub DehighlightUnits(ByVal units As Collection(Of SampleUnit))
        If (units Is Nothing) Then units = New Collection(Of SampleUnit)

        Me.SampleUnitTree.BeginUpdate()
        DehighlightUnits(Me.SampleUnitTree.Nodes, units)
        Me.SampleUnitTree.EndUpdate()
    End Sub

    ''' <summary>
    ''' Dehighlight specified sample units for the nodes.
    ''' Refresh text for all the nodes
    ''' </summary>
    ''' <param name="nodes"></param>
    ''' <param name="selectedUnits"></param>
    ''' <remarks></remarks>
    Private Sub DehighlightUnits(ByVal nodes As TreeNodeCollection, ByVal selectedUnits As Collection(Of SampleUnit))
        If (selectedUnits Is Nothing) Then Return

        'Go through each node and check if it is in the currently selected group
        For Each node As TreeNode In nodes
            'Get the unit
            Dim unit As SampleUnit = TryCast(node.Tag, SampleUnit)
            If unit Is Nothing Then Continue For

            'If unit collection contains this unit then dehighlight
            If selectedUnits.Contains(unit) Then
                node.ForeColor = SystemColors.GrayText
            End If

            'Reset the text to make sure the priority value is correct
            node.Text = String.Format("{0} ({1})", unit.Name, unit.Priority)

            'Recursively call for children
            If (node.Nodes.Count > 0) Then Me.DehighlightUnits(node.Nodes, selectedUnits)
        Next

    End Sub

    ''' <summary>
    ''' Refresh text for all the tree nodes
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub RefreshUnitTreeNodeText()
        Me.SampleUnitTree.BeginUpdate()
        RefreshUnitTreeNodeText(Me.SampleUnitTree.Nodes)
        Me.SampleUnitTree.EndUpdate()
    End Sub

    ''' <summary>
    ''' Refresh text for the specified nodes
    ''' </summary>
    ''' <param name="nodes"></param>
    ''' <remarks></remarks>
    Private Sub RefreshUnitTreeNodeText(ByVal nodes As TreeNodeCollection)
        For Each node As TreeNode In nodes
            'Get the unit
            Dim unit As SampleUnit = TryCast(node.Tag, SampleUnit)
            If unit Is Nothing Then Continue For

            'Reset the text to make sure the priority value is correct
            node.Text = String.Format("{0} ({1})", unit.Name, unit.Priority)

            'Recursively call for children
            If (node.Nodes.Count > 0) Then RefreshUnitTreeNodeText(node.Nodes)
        Next
    End Sub

    ''' <summary>
    ''' Fired when context menu pops up from sample unit tree
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub SampleUnitTreeContextMenu_Opening(ByVal sender As System.Object, ByVal e As System.ComponentModel.CancelEventArgs)
        'Check which tree node is clicked. If not click on node, do nothing
        Dim pt As Point = Me.SampleUnitTree.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim node As TreeNode = SampleUnitTree.GetNodeAt(pt)
        If (node Is Nothing) Then
            e.Cancel = True
            Return
        End If

        Dim unit As SampleUnit = TryCast(node.Tag, SampleUnit)
        If unit Is Nothing Then
            e.Cancel = True
            node = Nothing
            Return
        End If

        'Populate context menu items
        Dim units As New Collection(Of SampleUnit)
        units.Add(unit)

        PopulateSampleUnitContextMenuItems(units)

    End Sub

#End Region

#Region " Sample Unit List Methods "

    ''' <summary>
    ''' Populate sample units in the list for a specified priority group
    ''' </summary>
    ''' <param name="selectedUnits"></param>
    ''' <remarks></remarks>
    Private Sub PopulateUnitList(ByVal selectedUnits As Collection(Of SampleUnit))
        SampleUnitList.BeginUpdate()
        'Remove items
        SampleUnitList.Items.Clear()

        'Remove sorter
        RemoveListSorter()

        'Populate items
        If (selectedUnits Is Nothing) Then Return
        Dim item As ListViewItem
        For Each unit As SampleUnit In selectedUnits
            item = New ListViewItem(unit.Id.ToString)
            item.Tag = unit
            item.SubItems.Add(unit.Name)
            SampleUnitList.Items.Add(item)
        Next
        SampleUnitList.EndUpdate()
    End Sub

    ''' <summary>
    ''' Remove sorter provider and clear all sort order icon
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub RemoveListSorter()
        SampleUnitList.ListViewItemSorter = Nothing
        For Each header As ColumnHeader In SampleUnitList.Columns
            header.ImageIndex = SortOrderIcon.None
        Next
    End Sub

    ''' <summary>
    ''' Remove sample units from list
    ''' </summary>
    ''' <param name="selectedUnits"></param>
    ''' <remarks></remarks>
    Private Sub RemoveUnitsFromList(ByVal selectedUnits As Collection(Of SampleUnit))
        Dim unit As SampleUnit
        Dim removedCount As Integer = 0

        SampleUnitList.BeginUpdate()
        For Each item As ListViewItem In SampleUnitList.Items
            unit = TryCast(item.Tag, SampleUnit)
            If (unit Is Nothing) Then Continue For
            If (selectedUnits.Contains(unit)) Then
                item.Remove()
                removedCount += 1
            End If
            'If all the specified units are removed, stop here
            If (removedCount = selectedUnits.Count) Then Exit For
        Next
        SampleUnitList.EndUpdate()
    End Sub

    ''' <summary>
    ''' Fired when context menu pops up from sample unit list
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub SampleUnitListContextMenu_Opening(ByVal sender As System.Object, ByVal e As System.ComponentModel.CancelEventArgs)
        'If no item is selected, do nothing
        If (SampleUnitList.SelectedItems.Count = 0) Then
            e.Cancel = True
            Return
        End If

        Dim units As New Collection(Of SampleUnit)
        For Each item As ListViewItem In SampleUnitList.SelectedItems
            Dim unit As SampleUnit = TryCast(item.Tag, SampleUnit)
            If (unit IsNot Nothing) Then
                units.Add(unit)
            End If
        Next

        PopulateSampleUnitContextMenuItems(units)

    End Sub

#End Region

#Region " Command Methods "

    ''' <summary>
    ''' Move priority button up
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub MoveUp()
        Try
            Me.Cursor = Cursors.WaitCursor

            If (Me.SelectedGroup Is Nothing) Then Return

            Dim groups As Collection(Of PriorityGroupButton) = GetPriorityGroups()
            Dim id As Integer = IndexOfGroup(groups, Me.SelectedGroup)

            If (id = 0) Then Return

            Dim prevGroup As PriorityGroupButton = groups(id - 1)
            Dim units As Collection(Of SampleUnit) = prevGroup.SampleUnits
            prevGroup.SampleUnits = Me.SelectedGroup.SampleUnits
            Me.SelectedGroup.SampleUnits = units

            'The group above the selected one will be the selected group
            Me.SelectedGroup = prevGroup

            'Refresh unit tree node's text 
            RefreshUnitTreeNodeText()

            'Enable/disable command buttons
            EnableCommandButtons()

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    ''' <summary>
    ''' Move priority button down
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub MoveDown()
        Try
            Me.Cursor = Cursors.WaitCursor

            If (Me.SelectedGroup Is Nothing) Then Return

            Dim groups As Collection(Of PriorityGroupButton) = GetPriorityGroups()
            Dim lastGroupIsSelected As Boolean = (Me.SelectedGroup Is groups(groups.Count - 1))
            Dim id As Integer = IndexOfGroup(groups, Me.SelectedGroup)

            If (lastGroupIsSelected) Then Return

            Dim nextGroup As PriorityGroupButton = groups(id + 1)
            Dim units As Collection(Of SampleUnit) = nextGroup.SampleUnits
            nextGroup.SampleUnits = Me.SelectedGroup.SampleUnits
            Me.SelectedGroup.SampleUnits = units

            'The group after the selected one will be the selected group
            Me.SelectedGroup = nextGroup

            'Refresh unit tree node's text 
            RefreshUnitTreeNodeText()

            'Enable/disable command buttons
            EnableCommandButtons()

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    ''' <summary>
    ''' Add a priority button above the selected one
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub AddAbove()
        Try
            Me.Cursor = Cursors.WaitCursor

            If (Me.SelectedGroup Is Nothing) Then Return

            Dim groups As Collection(Of PriorityGroupButton) = GetPriorityGroups()
            Dim selectedGroupId As Integer = IndexOfGroup(groups, Me.SelectedGroup)

            'Create a new group and append to the last.
            'Note that the new group is not necessary the inserted group
            Dim newGroup As New PriorityGroupButton
            newGroup.ContextMenuStrip = PriorityGroupContextMenu
            AddHandler newGroup.Click, AddressOf PriorityGroup_Clicked
            AddHandler newGroup.DragDrop, AddressOf PriorityGroup_DragDrop
            AddHandler newGroup.DragEnter, AddressOf PriorityGroup_DragEnter
            groups.Add(newGroup)
            Me.PriorityGroupPanel.Controls.Add(newGroup)

            'for the groups after the selected group,
            'move sample unit collection and priority from group(n) to group(n+1)
            For i As Integer = groups.Count - 2 To selectedGroupId Step -1
                groups(i + 1).SampleUnits = groups(i).SampleUnits
                groups(i + 1).Priority = groups(i).Priority
            Next

            'Set the sample units and priority for the inserted group
            groups(selectedGroupId).SampleUnits = New Collection(Of SampleUnit)
            groups(selectedGroupId).Priority = groups(selectedGroupId + 1).Priority - 1

            'Reset priority for the groups after the inserted group
            For i As Integer = selectedGroupId To groups.Count - 1
                If (i = 0) Then
                    If (groups(i).Priority <= 0) Then groups(i).Priority = 1
                ElseIf (groups(i).Priority > groups(i - 1).Priority) Then
                    Exit For
                Else
                    groups(i).Priority = groups(i - 1).Priority + 1
                End If
                groups(i).Invalidate()
            Next

            'Now the group next to the original selected group should become the selected group
            Me.SelectedGroup = groups(selectedGroupId + 1)

            'Refresh unit tree node's text 
            RefreshUnitTreeNodeText()

            'Enable/disable command buttons
            EnableCommandButtons()

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    ''' <summary>
    ''' Add a priority button below the selected one
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub AddBelow()
        Try
            Me.Cursor = Cursors.WaitCursor

            If (Me.SelectedGroup Is Nothing) Then Return

            Dim groups As Collection(Of PriorityGroupButton) = GetPriorityGroups()
            Dim selectedGroupId As Integer = IndexOfGroup(groups, Me.SelectedGroup)

            'Create a new group and append to the last.
            'Note that the new group is not necessary the inserted group
            Dim newGroup As New PriorityGroupButton
            newGroup.ContextMenuStrip = PriorityGroupContextMenu
            AddHandler newGroup.Click, AddressOf PriorityGroup_Clicked
            AddHandler newGroup.DragDrop, AddressOf PriorityGroup_DragDrop
            AddHandler newGroup.DragEnter, AddressOf PriorityGroup_DragEnter
            groups.Add(newGroup)
            Me.PriorityGroupPanel.Controls.Add(newGroup)

            'for the groups after the selected group,
            'move sample unit collection from group(n) to group(n+1)
            For i As Integer = groups.Count - 2 To selectedGroupId + 1 Step -1
                groups(i + 1).SampleUnits = groups(i).SampleUnits
                groups(i + 1).Priority = groups(i).Priority
            Next

            'Set the sample units and priority for the inserted group
            groups(selectedGroupId + 1).SampleUnits = New Collection(Of SampleUnit)
            groups(selectedGroupId + 1).Priority = groups(selectedGroupId).Priority + 1
            groups(selectedGroupId + 1).Invalidate()

            'Reset priority for the groups after the inserted group
            For i As Integer = selectedGroupId + 2 To groups.Count - 1
                If (groups(i).Priority > groups(i - 1).Priority) Then
                    Exit For
                Else
                    groups(i).Priority = groups(i - 1).Priority + 1
                End If
                groups(i).Invalidate()
            Next

            'Refresh the text for unit tree nodes
            RefreshUnitTreeNodeText()

            'Enable/disable command buttons
            EnableCommandButtons()

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    ''' <summary>
    ''' Delete the selected priority button
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub DeleteGroup()
        Try
            Me.Cursor = Cursors.WaitCursor

            If (Me.SelectedGroup Is Nothing) Then Return

            'Check if group is deletable
            If (Not Me.SelectedGroup.IsDeletable()) Then
                MessageBox.Show("This priority group is not deletable", "Sample Unit Property Editor", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            'Find a group to be selected when current group is deleted.
            '  if current selected group is the last group,
            '      select the group prior to the current selected group
            '  if current selected group is not the last group,
            '      select the group next to the current selected group
            Dim groups As Collection(Of PriorityGroupButton) = GetPriorityGroups()
            Dim lastGroupIsSelected As Boolean = (Me.SelectedGroup Is groups(groups.Count - 1))
            Dim id As Integer = IndexOfGroup(groups, Me.SelectedGroup)
            Dim nextSelectedGroup As PriorityGroupButton
            If (lastGroupIsSelected) Then
                nextSelectedGroup = groups(id - 1)
            Else
                nextSelectedGroup = groups(id + 1)
            End If

            'Delete selected group
            Me.PriorityGroupPanel.Controls.Remove(Me.SelectedGroup)

            'Set new selected group
            SelectCurrentPriorityGroup(nextSelectedGroup)

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    ''' <summary>
    ''' Delete all the empty priority groups and reorder the rest groups
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub Cleanup()
        Try
            Me.Cursor = Cursors.WaitCursor

            SampleUnit.ReorderPriority(Me.mSampleUnits)
            Me.Initialize(Me.mSampleUnits)

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    ''' <summary>
    ''' Enable/disable each command buttons
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub EnableCommandButtons()
        'If no group is selected, disable 
        If (Me.SelectedGroup Is Nothing) Then
            MoveUpButton.Enabled = False
            MoveDownButton.Enabled = False
            AddAboveButton.Enabled = False
            DeleteGroupButton.Enabled = False
            Return
        End If

        Dim groups As Collection(Of PriorityGroupButton) = GetPriorityGroups()
        Dim lastGroupIsSelected As Boolean = (Me.SelectedGroup Is groups(groups.Count - 1))
        Dim id As Integer = IndexOfGroup(groups, Me.SelectedGroup)

        MoveUpButton.Enabled = (id > 0)
        MoveDownButton.Enabled = Not lastGroupIsSelected
        AddAboveButton.Enabled = True
        DeleteGroupButton.Enabled = Me.SelectedGroup.IsDeletable()
    End Sub

#End Region

#Region " Other Methods "

    ''' <summary>
    ''' Initializes the control to prioritize the specified set of sample units
    ''' </summary>
    Private Sub Initialize(ByVal units As Collection(Of SampleUnit))
        'Initialize the Tree
        Me.InitializeSampleUnitTree(units)

        'Initialize the Priority Groups
        Me.InitializePriorityGroups(units)
    End Sub

    ''' <summary>
    ''' Initializes the control to prioritize the specified set of sample units
    ''' </summary>
    Private Sub RefreshContent(ByVal units As Collection(Of SampleUnit))
        'Initialize the Tree
        Me.InitializeSampleUnitTree(units)

        'Refresh the Priority Groups
        Me.RefreshPriorityGroups(units)
    End Sub

    ''' <summary>
    ''' Populate sample units in the tree and list for a specified priority group
    ''' </summary>
    ''' <param name="group"></param>
    ''' <remarks></remarks>
    Private Sub LoadPriorityGroup(ByVal group As PriorityGroupButton)
        'Go through the tree ad highlight the nodes in the current group
        RefreshSampleUnitTree(group.SampleUnits)

        'Populate the ListView
        PopulateUnitList(group.SampleUnits)
    End Sub

    ''' <summary>
    ''' Populate menu items to sample unit context menu
    ''' </summary>
    ''' <param name="selectedUnits"></param>
    ''' <remarks></remarks>
    Private Sub PopulateSampleUnitContextMenuItems(ByVal selectedUnits As Collection(Of SampleUnit))
        Dim menuItem As ToolStripMenuItem
        Dim profile As SampleUnitContextMenuProfile

        Me.MoveToMenuItem.DropDownItems.Clear()
        For Each group As PriorityGroupButton In Me.PriorityGroupPanel.Controls
            menuItem = New ToolStripMenuItem
            menuItem.Text = "Group " & group.Priority
            menuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.Folder16
            If (group Is Me.SelectedGroup) Then
                menuItem.Enabled = False
            Else
                profile = New SampleUnitContextMenuProfile(selectedUnits, group.Priority)
                menuItem.Tag = profile
                AddHandler menuItem.Click, AddressOf SampleUnitMenuItem_Click
            End If
            Me.MoveToMenuItem.DropDownItems.Add(menuItem)
        Next
    End Sub

#End Region

#End Region

#Region " Sub Classes "

    ''' <summary>
    ''' Used for sample unit context menu to save the data for menu item event
    ''' </summary>
    ''' <remarks></remarks>
    Private Class SampleUnitContextMenuProfile
        Private mSelectedUnits As Collection(Of SampleUnit)
        Public ReadOnly Property SelectedUnits() As Collection(Of SampleUnit)
            Get
                Return mSelectedUnits
            End Get
        End Property

        Private mMoveToPriority As Integer
        Public ReadOnly Property MoveToPriority() As Integer
            Get
                Return mMoveToPriority
            End Get
        End Property

        Public Sub New(ByVal selectedUnits As Collection(Of SampleUnit), ByVal moveToPriority As Integer)
            Me.mSelectedUnits = selectedUnits
            Me.mMoveToPriority = moveToPriority
        End Sub

    End Class

    ''' <summary>
    ''' Implements the manual sorting of data items by columns
    ''' </summary>
    ''' <remarks></remarks>
    Private Class ListViewItemComparer
        Implements IComparer

        Private mColumn As Integer
        Public Property Column() As Integer
            Get
                Return mColumn
            End Get
            Set(ByVal value As Integer)
                mColumn = value
            End Set
        End Property

        Private mDataType As DataTypes
        Public Property DataType() As DataTypes
            Get
                Return mDataType
            End Get
            Set(ByVal value As DataTypes)
                mDataType = value
            End Set
        End Property

        Private mSortOrder As SortOrder
        Public Property SortOrder() As SortOrder
            Get
                Return mSortOrder
            End Get
            Set(ByVal value As SortOrder)
                mSortOrder = value
            End Set
        End Property

        Public Sub New()
            mColumn = 0
            mDataType = DataTypes.Text
            mSortOrder = Windows.Forms.SortOrder.Ascending
        End Sub

        Public Sub New(ByVal column As Integer, ByVal dataType As DataTypes, ByVal sortOrder As SortOrder)
            mColumn = column
            mDataType = dataType
            mSortOrder = sortOrder
        End Sub

        Public Function Compare(ByVal x As Object, ByVal y As Object) As Integer _
           Implements IComparer.Compare

            If (mSortOrder = Windows.Forms.SortOrder.None) Then Return 0

            Dim listX As ListViewItem = Nothing
            Dim listY As ListViewItem = Nothing
            Select Case Me.SortOrder
                Case Windows.Forms.SortOrder.Ascending
                    listX = TryCast(x, ListViewItem)
                    listY = TryCast(y, ListViewItem)
                Case Windows.Forms.SortOrder.Descending
                    listX = TryCast(y, ListViewItem)
                    listY = TryCast(x, ListViewItem)
                Case Windows.Forms.SortOrder.None
                    Return 0
            End Select

            If (listX Is Nothing) Then Return -1
            If (listY Is Nothing) Then Return 1

            Select Case Me.DataType
                Case DataTypes.Text
                    Return String.Compare(listX.SubItems(Me.mColumn).Text, listY.SubItems(Me.mColumn).Text)
                Case DataTypes.Numeric
                    Dim valX, valY As Decimal
                    Decimal.TryParse(listX.SubItems(Me.mColumn).Text, valX)
                    Decimal.TryParse(listY.SubItems(Me.mColumn).Text, valY)
                    Return Decimal.Compare(valX, valY)
                Case DataTypes.DateTime
                    Dim valX, valY As Date
                    Date.TryParse(listX.SubItems(Me.mColumn).Text, valX)
                    Date.TryParse(listY.SubItems(Me.mColumn).Text, valY)
                    Return Date.Compare(valX, valY)
            End Select
        End Function

        Public Sub ToggleSortOrder()
            Select Case Me.mSortOrder
                Case Windows.Forms.SortOrder.Ascending
                    Me.mSortOrder = Windows.Forms.SortOrder.Descending
                Case Windows.Forms.SortOrder.Descending
                    Me.mSortOrder = Windows.Forms.SortOrder.Ascending
            End Select
        End Sub

    End Class


#End Region

End Class