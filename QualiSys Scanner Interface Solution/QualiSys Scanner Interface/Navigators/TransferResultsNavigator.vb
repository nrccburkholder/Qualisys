Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class TransferResultsNavigator

#Region " Private Members "

    Private mIsInitializing As Boolean = False
    Private mSortMode As TransferSortModes
    Private mFilterMode As TransferResultsFilterModes
    Private mTreeData As TransferResultsNavigatorTreeCollection

    Public Event SelectedNodeChanging As EventHandler(Of SelectedNodeChangingEventArgs)
    Public Event SelectedNodeChanged As EventHandler(Of SelectedNodeChangedEventArgs)

    Private WithEvents mSettings As My.MySettings = My.Settings

#End Region

#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeNavigator()

    End Sub

#End Region

#Region " Events "

    Private Sub TransferResultsFilterComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TransferResultsFilterComboBox.SelectedIndexChanged

        If mIsInitializing Then Exit Sub

        SetFilterMode(DirectCast(TransferResultsFilterComboBox.SelectedValue, TransferResultsFilterModes))
        PopulateTree(False)

    End Sub

    Private Sub TransferResultsFromDateTimePicker_ValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TransferResultsFromDateTimePicker.ValueChanged

        If mIsInitializing Then Exit Sub

        PopulateTree(True)

    End Sub

    Private Sub TransferResultsRefreshTSButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles TransferResultsRefreshTSButton.Click

        PopulateTree(True)

    End Sub

    Private Sub TransferResultsFontDownTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TransferResultsFontDownTSButton.Click

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

    Private Sub TransferResultsFontUpTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TransferResultsFontUpTSButton.Click

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

    Private Sub TransferResultsSortIDTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TransferResultsSortIDTSButton.Click

        SetSortMode(TransferSortModes.ByDataFileIDDesc, True)

    End Sub

    Private Sub TransferResultsSortNameTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TransferResultsSortNameTSButton.Click

        SetSortMode(TransferSortModes.ByDataFileNameAsc, True)

    End Sub

    Private Sub TransferResultsHideTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TransferResultsHideTSButton.Click

        'Get the selected node
        Dim fileNode As TransferResultsFileNode = TryCast(TransferResultsTreeView.SelectedNode, TransferResultsFileNode)
        If fileNode IsNot Nothing Then
            Dim file As DataLoad = DataLoad.Get(fileNode.Source.DataLoadID)
            file.ShowInTree = Not file.ShowInTree
            file.Save()
            PopulateTree(True)
        End If

    End Sub

    Private Sub TransferResultsShowTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TransferResultsShowTSButton.Click

        PopulateTree(False)

    End Sub

    Private Sub TransferResultsTreeView_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles TransferResultsTreeView.BeforeSelect

        If mIsInitializing Then Exit Sub

        'Create the event arguement object
        Dim eventArgs As New SelectedNodeChangingEventArgs(TransferResultsTreeView.SelectedNode, e.Node)

        'Raise the event
        RaiseEvent SelectedNodeChanging(Me, eventArgs)

        'Determine next step
        e.Cancel = eventArgs.Cancel

    End Sub

    Private Sub TransferResultsTreeView_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles TransferResultsTreeView.AfterSelect

        If mIsInitializing Then Exit Sub

        'Raise the event
        RaiseEvent SelectedNodeChanged(Me, New SelectedNodeChangedEventArgs(e.Node))

        'Setup the hide file button
        If TypeOf e.Node Is TransferResultsFileNode Then
            TransferResultsHideTSButton.Enabled = True
            Dim node As TransferResultsFileNode = DirectCast(e.Node, TransferResultsFileNode)
            TransferResultsHideTSButton.Checked = (Not node.Source.ShowInTree)
        Else
            TransferResultsHideTSButton.Enabled = False
            TransferResultsHideTSButton.Checked = False
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
            TransferResultsTreeView.Font = My.Settings.NavigatorFont
        End If

    End Sub

#End Region

#Region " Public Methods "

    Public Sub PopulateTree(ByVal refresh As Boolean)

        Dim vendorNode As TransferResultsVendorNode = Nothing
        Dim fileNode As TransferResultsFileNode = Nothing
        Dim newVendorNode As TransferResultsVendorNode = Nothing
        Dim newFileNode As TransferResultsFileNode = Nothing
        Dim newSurveyNode As TransferResultsSurveyNode = Nothing
        Dim expandedNodeKeys As New List(Of String)
        Dim selectedNodeKey As String = String.Empty

        'Refresh the tree data if required
        If refresh Then RefreshTreeData()

        'Save the current state of the tree
        SaveTreeState(expandedNodeKeys, selectedNodeKey)

        'Clear the tree
        TransferResultsTreeView.Nodes.Clear()

        'Populate the tree
        Dim treeData As TransferResultsNavigatorTreeCollection = GetTreeData()
        For Each item As TransferResultsNavigatorTree In treeData
            'Check to see if we are adding this one
            If item.ShowInTree OrElse TransferResultsShowTSButton.Checked Then
                'Check to see if this vendor exists
                newVendorNode = New TransferResultsVendorNode(item)
                If Not TransferResultsTreeView.Nodes.ContainsKey(newVendorNode.Name) Then
                    'Add this node to the tree
                    TransferResultsTreeView.Nodes.Add(newVendorNode)
                    vendorNode = newVendorNode
                Else
                    'Get a reference to the existing node
                    vendorNode = DirectCast(TransferResultsTreeView.Nodes(newVendorNode.Name), TransferResultsVendorNode)
                End If

                'Check to see if this file node exists
                newFileNode = New TransferResultsFileNode(item)
                If Not vendorNode.Nodes.ContainsKey(newFileNode.Name) Then
                    'Determine the node font and color
                    If Not item.ShowInTree Then
                        newFileNode.NodeFont = New Font(TransferResultsTreeView.Font, FontStyle.Italic)
                        newFileNode.ForeColor = System.Drawing.SystemColors.GrayText
                    End If

                    'Add this node to the tree
                    vendorNode.Nodes.Add(newFileNode)
                    fileNode = newFileNode
                Else
                    'Get a reference to the existing node
                    fileNode = DirectCast(vendorNode.Nodes(newFileNode.Name), TransferResultsFileNode)
                End If

                'Check to see if this survey node exists
                newSurveyNode = New TransferResultsSurveyNode(item)
                If Not fileNode.Nodes.ContainsKey(newSurveyNode.Name) Then
                    'Determine the node font and color
                    If Not item.ShowInTree Then
                        newSurveyNode.NodeFont = New Font(TransferResultsTreeView.Font, FontStyle.Italic)
                        newSurveyNode.ForeColor = System.Drawing.SystemColors.GrayText
                    End If

                    'Add this node to the tree
                    fileNode.Nodes.Add(newSurveyNode)
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

        'Populate the image list for the tree
        With TransferResultsImageList.Images
            .Add(TransferResultsImageKeys.Vendor, My.Resources.Member32)
            .Add(TransferResultsImageKeys.DataLoad, My.Resources.DocumentGreen16)
            .Add(TransferResultsImageKeys.DataLoadBadLithos, My.Resources.Document16)
            .Add(TransferResultsImageKeys.DataLoadBadSurveys, My.Resources.DocumentYellow16)
            .Add(TransferResultsImageKeys.DataLoadBadLithosAndSurveys, My.Resources.DocumentRed16)
            .Add(TransferResultsImageKeys.SurveyDataLoad, My.Resources.Validation16)
            .Add(TransferResultsImageKeys.SurveyDataLoadError, My.Resources.NoWay16)
        End With

        'Populate the filter combobox
        SetFilterMode(DirectCast(My.Settings.TransferResultsNavigatorFilterMode, TransferResultsFilterModes))
        Dim filterList As New List(Of ListItem(Of TransferResultsFilterModes))
        With filterList
            .Add(New ListItem(Of TransferResultsFilterModes)("<All>", TransferResultsFilterModes.All))
            .Add(New ListItem(Of TransferResultsFilterModes)("Errors", TransferResultsFilterModes.Errors))
        End With
        With TransferResultsFilterComboBox
            .DataSource = filterList
            .DisplayMember = "Label"
            .ValueMember = "Value"
            .SelectedValue = mFilterMode
        End With

        'Set the default date range
        TransferResultsFromDateTimePicker.Value = Now.AddDays(0 - AppConfig.Params("QSITransferDefaultDaysToDisplay").IntegerValue)

        'Set the TreeView font
        TransferResultsTreeView.Font = My.Settings.NavigatorFont

        'Setup the Legend
        ShowLegend(My.Settings.TransferResultsViewTreeLegend)

        'Set the sort mode
        SetSortMode(DirectCast(My.Settings.TransferResultsSortMode, TransferSortModes), False)

        'Setup the hide file button
        TransferResultsHideTSButton.Enabled = False

        'Setup the show hidden files button
        TransferResultsShowTSButton.Checked = False

        mIsInitializing = False

    End Sub

    Private Sub RefreshTreeData()

        mTreeData = Nothing
        mTreeData = TransferResultsNavigatorTree.GetAllByDateRange(TransferResultsFromDateTimePicker.Value, Date.Now, mSortMode)

    End Sub

    Private Function GetTreeData() As TransferResultsNavigatorTreeCollection

        Dim treeData As TransferResultsNavigatorTreeCollection

        Select Case mFilterMode
            Case TransferResultsFilterModes.Errors
                treeData = mTreeData.GetErrorsOnly

            Case Else
                treeData = mTreeData

        End Select

        Return treeData

    End Function

    Private Sub SaveTreeState(ByVal expandedNodeKeys As List(Of String), ByRef selectedNodeKey As String)

        'Save the current expanded node keys
        For Each vendorNode As TreeNode In TransferResultsTreeView.Nodes
            If vendorNode.IsExpanded AndAlso vendorNode.Nodes.Count > 0 Then
                expandedNodeKeys.Add(vendorNode.Name)
                For Each fileNode As TreeNode In vendorNode.Nodes
                    If fileNode.IsExpanded AndAlso fileNode.Nodes.Count > 0 Then
                        expandedNodeKeys.Add(fileNode.Name)
                    End If
                Next
            End If
        Next

        'Save the current selected node key
        If TransferResultsTreeView.SelectedNode IsNot Nothing Then
            selectedNodeKey = TransferResultsTreeView.SelectedNode.Name
        End If

    End Sub

    Private Sub RestoreTreeState(ByVal expandedNodeKeys As List(Of String), ByVal selectedNodeKey As String)

        If TransferResultsTreeView.Nodes.Count = 0 Then Exit Sub

        'Restore the expanded nodes
        If expandedNodeKeys IsNot Nothing Then
            For Each key As String In expandedNodeKeys
                Dim expandedNodes As TreeNode() = TransferResultsTreeView.Nodes.Find(key, True)
                If expandedNodes IsNot Nothing AndAlso expandedNodes.Length > 0 Then
                    expandedNodes(0).Expand()
                End If
            Next
        End If

        'Restore the selected node
        Dim selectedNodeFound As Boolean = False
        If Not String.IsNullOrEmpty(selectedNodeKey) Then
            Dim selectedNodes As TreeNode() = TransferResultsTreeView.Nodes.Find(selectedNodeKey, True)
            If selectedNodes IsNot Nothing AndAlso selectedNodes.Length > 0 Then
                selectedNodeFound = True
                TransferResultsTreeView.SelectedNode = selectedNodes(0)
                TransferResultsTreeView.SelectedNode.EnsureVisible()
            End If
        End If

        'If the previously selected node was not found then select the highest root node
        If Not selectedNodeFound Then
            For Each node As TreeNode In TransferResultsTreeView.Nodes
                node.Expand()
            Next
            TransferResultsTreeView.SelectedNode = TransferResultsTreeView.Nodes(0)
        End If

    End Sub

    Private Sub ShowLegend(ByVal visible As Boolean)

        'Setup the legend control
        LegendToolStrip.Visible = visible
        LegendControlShowTSButton.Visible = Not visible
        LegendControlHideTSButton.Visible = visible

        'Save the view setting
        My.Settings.TransferResultsViewTreeLegend = visible

    End Sub

    Private Sub SetSortMode(ByVal sortMode As TransferSortModes, ByVal refresh As Boolean)

        'Save the setting
        mSortMode = sortMode
        My.Settings.TransferResultsSortMode = CInt(sortMode)

        'Set the sort buttons
        Select Case sortMode
            Case TransferSortModes.ByDataFileIDDesc
                TransferResultsSortIDTSButton.Checked = True
                TransferResultsSortNameTSButton.Checked = False

            Case TransferSortModes.ByDataFileNameAsc
                TransferResultsSortIDTSButton.Checked = False
                TransferResultsSortNameTSButton.Checked = True

        End Select

        'Populate the tree
        If refresh Then PopulateTree(True)

    End Sub

    Private Sub SetFilterMode(ByVal filterMode As TransferResultsFilterModes)

        'Save the setting
        mFilterMode = filterMode
        My.Settings.TransferResultsNavigatorFilterMode = CInt(filterMode)

    End Sub

#End Region

End Class
