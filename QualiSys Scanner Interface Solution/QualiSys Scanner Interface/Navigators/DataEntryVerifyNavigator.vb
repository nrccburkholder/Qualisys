Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class DataEntryVerifyNavigator

#Region " Private Members "

    Private mIsInitializing As Boolean
    Private mDataEntryMode As DataEntryModes
    Private mTreeData As DataEntryNavigatorTreeCollection

    Public Event BeginEditingTemplate As EventHandler(Of SelectedNodeChangedEventArgs)
    Public Event SelectedNodeChanging As EventHandler(Of SelectedNodeChangingEventArgs)

    Private WithEvents mSettings As My.MySettings = My.Settings

#End Region

#Region " Constructors "

    Public Sub New(ByVal dataEntryMode As DataEntryModes)

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Save parameters
        mDataEntryMode = dataEntryMode

        'Add any initialization after the InitializeComponent() call.
        InitializeNavigator()

    End Sub

#End Region

#Region " Events "

    Private Sub DataEntryNewBatchTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataEntryNewBatchTSButton.Click

        Using addBatchDialog As New DataEntryBatchAddDialog()
            'Display the dialog
            If addBatchDialog.ShowDialog() = DialogResult.Cancel Then
                'The user hit the cancel button so we are out of here
                Exit Sub
            End If

            'Refresh the tree
            PopulateTree(True)

            'Select the new batch
            SelectNode("DB" & addBatchDialog.BatchName)
        End Using

    End Sub

    Private Sub DataEntryUnlockTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataEntryUnlockTSButton.Click

        'Ask the user if they are sure they want to unlock the batch

        Dim node As DataEntryBatchNode

        If DataEntryTreeView.SelectedNode IsNot Nothing AndAlso TryCast(DataEntryTreeView.SelectedNode, DataEntryBatchNode) IsNot Nothing Then
            'Get the selected template node
            node = DirectCast(DataEntryTreeView.SelectedNode, DataEntryBatchNode)

            'Check to see if the batch is locked by another user
            Dim batch As QSIDataBatch = QSIDataBatch.Get(node.Source.BatchID)
            If batch.Locked Then
                'Ask the user if they are sure they want to unlock the batch
                If MessageBox.Show(String.Format("Batch {0} is locked by another user!.  Are you sure you want to unlock the batch?", batch.BatchName), "Unlock Batch", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
                    'They want to unlock the batch
                    With batch
                        .Locked = False
                        .Save()
                    End With

                    'Refresh the tree
                    PopulateTree(True)
                End If
            Else
                'Tell the user that the batch is not locked and refresh the tree
                MessageBox.Show(String.Format("Batch {0} is currently not locked!  The tree will now be refreshed.", batch.BatchName), "Batch Not Locked", MessageBoxButtons.OK, MessageBoxIcon.Information)

                'Refresh the tree
                PopulateTree(True)
            End If
        End If

    End Sub

    Private Sub DataEntryFinalizeTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataEntryFinalizeTSButton.Click

        'TODO: Add finalize code

    End Sub

    Private Sub DataEntryRefreshTSButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles DataEntryRefreshTSButton.Click

        PopulateTree(True)

    End Sub

    Private Sub DataEntryFontDownTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataEntryFontDownTSButton.Click

        'Decrease the font size by the specified step
        Dim newSize As Single = My.Settings.NavigatorFont.Size - AppConfig.Params("QSINavigatorFontSizeStep").IntegerValue

        'Check to see if the font is smaller than the specified minimum
        If newSize < AppConfig.Params("QSINavigatorFontSizeMin").IntegerValue Then
            'Decreasing the font makes it smaller than the minimum so set it to the minimum
            newSize = AppConfig.Params("QSINavigatorFontSizeMin").IntegerValue
        End If

        'Now set the font for the treeview
        My.Settings.NavigatorFont = New Font(My.Settings.NavigatorFont.FontFamily, newSize, My.Settings.NavigatorFont.Style)

    End Sub

    Private Sub DataEntryFontUpTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataEntryFontUpTSButton.Click

        'Increase the font size by the specified step
        Dim newSize As Single = My.Settings.NavigatorFont.Size + AppConfig.Params("QSINavigatorFontSizeStep").IntegerValue

        'Check to see if the font is larger than the specified maximum
        If newSize > AppConfig.Params("QSINavigatorFontSizeMax").IntegerValue Then
            'Increasing the font makes it larger than the maximum so set it to the maximum
            newSize = AppConfig.Params("QSINavigatorFontSizeMax").IntegerValue
        End If

        'Now set the font for the treeview
        My.Settings.NavigatorFont = New Font(My.Settings.NavigatorFont.FontFamily, newSize, My.Settings.NavigatorFont.Style)

    End Sub

    Private Sub DataEntryDeleteTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataEntryDeleteTSButton.Click

        Dim node As DataEntryBatchNode

        If DataEntryTreeView.SelectedNode IsNot Nothing AndAlso TryCast(DataEntryTreeView.SelectedNode, DataEntryBatchNode) IsNot Nothing Then
            'Get the selected template node
            node = DirectCast(DataEntryTreeView.SelectedNode, DataEntryBatchNode)

            'Check to see if the batch is locked by another user
            Dim batch As QSIDataBatch = QSIDataBatch.Get(node.Source.BatchID)
            If batch.Locked Then
                'The batch is locked so tell the user
                MessageBox.Show("Batch {0} is locked by another user!", "Batch Locked", MessageBoxButtons.OK, MessageBoxIcon.Information)

                'Refresh the tree
                PopulateTree(True)
            Else
                'Ask the user to make sure this is what they want to do
                If MessageBox.Show("Are you sure you want to delete the selected batch?", "Delete Batch", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
                    'Delete the batch
                    batch.DeleteBatch()

                    'Refresh the tree
                    PopulateTree(True)
                End If
            End If
        End If

    End Sub

    Private Sub DataEntryBeginTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataEntryBeginTSButton.Click

        Dim node As DataEntryTemplateNode

        If DataEntryTreeView.SelectedNode IsNot Nothing AndAlso TryCast(DataEntryTreeView.SelectedNode, DataEntryTemplateNode) IsNot Nothing Then
            'Get the selected template node
            node = DirectCast(DataEntryTreeView.SelectedNode, DataEntryTemplateNode)

            'Check to see if the batch is locked by another user
            Dim batch As QSIDataBatch = QSIDataBatch.Get(node.Source.BatchID)
            If batch.Locked Then
                'The batch is locked so tell the user
                MessageBox.Show("Batch {0} is locked by another user!", "Batch Locked", MessageBoxButtons.OK, MessageBoxIcon.Information)

                'Refresh the tree
                PopulateTree(True)
            Else
                'Lock the batch
                With batch
                    .Locked = True
                    .Save()
                End With

                'Refresh the tree
                PopulateTree(True)

                'Raise the event
                RaiseEvent BeginEditingTemplate(Me, New SelectedNodeChangedEventArgs(node))
            End If
        End If

    End Sub

    Private Sub DataEntryTreeView_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles DataEntryTreeView.BeforeSelect

        If mIsInitializing Then Exit Sub

        'Create the event arguement object
        Dim eventArgs As New SelectedNodeChangingEventArgs(DataEntryTreeView.SelectedNode, e.Node)

        'Raise the event
        RaiseEvent SelectedNodeChanging(Me, eventArgs)

        'Determine next step
        e.Cancel = eventArgs.Cancel

    End Sub

    Private Sub DataEntryTreeView_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles DataEntryTreeView.AfterSelect

        If mIsInitializing Then Exit Sub

        'Setup the toolbar
        If TypeOf e.Node Is DataEntryBatchNode Then
            Dim node As DataEntryBatchNode = DirectCast(e.Node, DataEntryBatchNode)
            If node.Source.Locked Then
                DataEntryDeleteTSButton.Enabled = False
                DataEntryUnlockTSButton.Enabled = True
            Else
                DataEntryDeleteTSButton.Enabled = True
                DataEntryUnlockTSButton.Enabled = False
            End If
            DataEntryBeginTSButton.Enabled = False
            DataEntryUnlockTSButton.Visible = CurrentUser.IsDataEntryAdministrator
            DataEntryFinalizeTSButton.Visible = False   'TODO: Deal with Finalize Button - CurrentUser.IsDataEntryAdministrator
        Else
            Dim node As DataEntryTemplateNode = DirectCast(e.Node, DataEntryTemplateNode)
            If node.Source.Locked Then
                DataEntryBeginTSButton.Enabled = False
            Else
                DataEntryBeginTSButton.Enabled = True
            End If
            DataEntryDeleteTSButton.Enabled = False
            DataEntryUnlockTSButton.Visible = False
            DataEntryFinalizeTSButton.Visible = False
        End If

    End Sub

    Private Sub LegendControlShowTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LegendControlShowTSButton.Click

        ShowLegend(True)

    End Sub

    Private Sub LegendControlHideTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LegendControlHideTSButton.Click

        ShowLegend(False)

    End Sub

    Private Sub mSettings_PropertyChanged(ByVal sender As Object, ByVal e As System.ComponentModel.PropertyChangedEventArgs) Handles mSettings.PropertyChanged

        If e.PropertyName = "NavigatorFont" Then
            'Set the TreeView font
            DataEntryTreeView.Font = My.Settings.NavigatorFont
        End If

    End Sub

#End Region

#Region " Public Methods "

    Public Sub PopulateTree(ByVal refresh As Boolean)

        Dim batchNode As DataEntryBatchNode = Nothing
        Dim newBatchNode As DataEntryBatchNode = Nothing
        Dim newTemplateNode As DataEntryTemplateNode = Nothing
        Dim expandedNodeKeys As New List(Of String)
        Dim selectedNodeKey As String = String.Empty

        'Refresh the tree data if required
        If refresh Then RefreshTreeData()

        'Save the current state of the tree
        SaveTreeState(expandedNodeKeys, selectedNodeKey)

        'Clear the tree
        DataEntryTreeView.Nodes.Clear()

        'Populate the tree
        Dim treeData As DataEntryNavigatorTreeCollection = GetTreeData()
        For Each item As DataEntryNavigatorTree In treeData
            'Check to see if we are adding this one
            If item.DataEntryMode = mDataEntryMode AndAlso item.QuantityRemaining > 0 Then
                'Check to see if this batch exists
                newBatchNode = New DataEntryBatchNode(item)
                If Not DataEntryTreeView.Nodes.ContainsKey(newBatchNode.Name) Then
                    'Determine the node font and color
                    If item.Locked Then
                        newBatchNode.NodeFont = New Font(DataEntryTreeView.Font, FontStyle.Italic)
                        newBatchNode.ForeColor = System.Drawing.SystemColors.GrayText
                    End If

                    'Add this node to the tree
                    DataEntryTreeView.Nodes.Add(newBatchNode)
                    batchNode = newBatchNode
                Else
                    'Get a reference to the existing node
                    batchNode = DirectCast(DataEntryTreeView.Nodes(newBatchNode.Name), DataEntryBatchNode)
                End If

                'Check to see if this template node exists
                newTemplateNode = New DataEntryTemplateNode(item)
                If Not batchNode.Nodes.ContainsKey(newTemplateNode.Name) Then
                    'Determine the node font and color
                    If item.Locked Then
                        newTemplateNode.NodeFont = New Font(DataEntryTreeView.Font, FontStyle.Italic)
                        newTemplateNode.ForeColor = System.Drawing.SystemColors.GrayText
                    End If

                    'Add this node to the tree
                    batchNode.Nodes.Add(newTemplateNode)
                End If
            End If
        Next

        'Restore the state of the tree
        RestoreTreeState(expandedNodeKeys, selectedNodeKey)

    End Sub

#End Region

#Region " Private Methods "

    Private Sub InitializeNavigator()

        mIsInitializing = True

        'Setup the toolbar
        Select Case mDataEntryMode
            Case DataEntryModes.Entry
                DataEntryNewBatchTSButton.Visible = True

            Case DataEntryModes.Verify
                DataEntryNewBatchTSButton.Visible = False

        End Select

        'Populate the image list for the tree
        With DataEntryImageList.Images
            .Add(DataEntryImageKeys.Batch, My.Resources.Batch)
            .Add(DataEntryImageKeys.Survey, My.Resources.Survey)
        End With

        'Set the TreeView font
        DataEntryTreeView.Font = My.Settings.NavigatorFont

        'Setup the Legend
        ShowLegend(My.Settings.DataEntryViewTreeLegend)

        mIsInitializing = False

    End Sub

    Private Sub RefreshTreeData()

        mTreeData = Nothing
        mTreeData = DataEntryNavigatorTree.GetAll(CurrentUser.UserName)

    End Sub

    Private Function GetTreeData() As DataEntryNavigatorTreeCollection

        Return mTreeData

    End Function

    Private Sub SaveTreeState(ByVal expandedNodeKeys As List(Of String), ByRef selectedNodeKey As String)

        'Save the current expanded node keys
        For Each batchNode As TreeNode In DataEntryTreeView.Nodes
            If batchNode.IsExpanded AndAlso batchNode.Nodes.Count > 0 Then
                expandedNodeKeys.Add(batchNode.Name)
            End If
        Next

        'Save the current selected node key
        If DataEntryTreeView.SelectedNode IsNot Nothing Then
            selectedNodeKey = DataEntryTreeView.SelectedNode.Name
        End If

    End Sub

    Private Sub RestoreTreeState(ByVal expandedNodeKeys As List(Of String), ByVal selectedNodeKey As String)

        If DataEntryTreeView.Nodes.Count = 0 Then Exit Sub

        'Restore the expanded nodes
        If expandedNodeKeys IsNot Nothing Then
            For Each key As String In expandedNodeKeys
                ExpandNode(key)
            Next
        End If

        'Restore the selected node
        Dim selectedNodeFound As Boolean = SelectNode(selectedNodeKey)

        'If the previously selected node was not found then select the highest root node
        If Not selectedNodeFound Then
            For Each node As TreeNode In DataEntryTreeView.Nodes
                node.Expand()
            Next
            DataEntryTreeView.SelectedNode = DataEntryTreeView.Nodes(0)
        End If

    End Sub

    Private Sub ShowLegend(ByVal visible As Boolean)

        'Setup the legend control
        LegendToolStrip.Visible = visible
        LegendControlShowTSButton.Visible = Not visible
        LegendControlHideTSButton.Visible = visible

        'Save the view setting
        My.Settings.DataEntryViewTreeLegend = visible

    End Sub

    Private Sub ExpandNode(ByVal key As String)

        Dim expandedNodes As TreeNode() = DataEntryTreeView.Nodes.Find(key, True)
        If expandedNodes IsNot Nothing AndAlso expandedNodes.Length > 0 Then
            expandedNodes(0).Expand()
        End If

    End Sub

    Private Function SelectNode(ByVal key As String) As Boolean

        Dim selectedNodeFound As Boolean = False

        If Not String.IsNullOrEmpty(key) Then
            Dim selectedNodes As TreeNode() = DataEntryTreeView.Nodes.Find(key, True)
            If selectedNodes IsNot Nothing AndAlso selectedNodes.Length > 0 Then
                selectedNodeFound = True
                DataEntryTreeView.SelectedNode = selectedNodes(0)
                DataEntryTreeView.SelectedNode.EnsureVisible()
            End If
        End If

        Return selectedNodeFound

    End Function

#End Region

End Class
