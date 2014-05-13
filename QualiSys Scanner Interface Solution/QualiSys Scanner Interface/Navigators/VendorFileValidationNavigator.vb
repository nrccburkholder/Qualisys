Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class VendorFileValidationNavigator

#Region " Private Members "

    Private mIsInitializing As Boolean = False
    Private mFilterMode As Integer
    Private mTreeData As VendorFileNavigatorTreeCollection

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

    Private Sub VendorFileFilterComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileFilterComboBox.SelectedIndexChanged

        If mIsInitializing Then Exit Sub

        SetFilterMode(CInt(VendorFileFilterComboBox.SelectedValue))
        PopulateTree(True)

    End Sub

    Private Sub VendorFileFromDateTimePicker_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileFromDateTimePicker.ValueChanged

        If mIsInitializing Then Exit Sub

        PopulateTree(True)

    End Sub

    Private Sub VendorFileRefreshTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileRefreshTSButton.Click

        PopulateTree(True)

    End Sub

    Private Sub VendorFileFontDownTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileFontDownTSButton.Click

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

    Private Sub VendorFileFontUpTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileFontUpTSButton.Click

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

    Private Sub VendorFileHideTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileHideTSButton.Click

        'Get the selected node
        Dim fileNode As VendorFileFileNode = TryCast(VendorFileTreeView.SelectedNode, VendorFileFileNode)
        If fileNode IsNot Nothing Then
            Dim file As VendorFileCreationQueue = VendorFileCreationQueue.Get(fileNode.Source.VendorFileID)
            file.ShowInTree = Not file.ShowInTree
            file.Save()
            PopulateTree(True)
        End If

    End Sub

    Private Sub VendorFileShowTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileShowTSButton.Click

        PopulateTree(False)

    End Sub

    Private Sub VendorFileTreeView_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles VendorFileTreeView.BeforeSelect

        If mIsInitializing Then Exit Sub

        'Create the event arguement object
        Dim eventArgs As New SelectedNodeChangingEventArgs(VendorFileTreeView.SelectedNode, e.Node)

        'Raise the event
        RaiseEvent SelectedNodeChanging(Me, eventArgs)

        'Determine next step
        e.Cancel = eventArgs.Cancel

    End Sub

    Private Sub VendorFileTreeView_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles VendorFileTreeView.AfterSelect

        If mIsInitializing Then Exit Sub

        'Raise the event
        RaiseEvent SelectedNodeChanged(Me, New SelectedNodeChangedEventArgs(e.Node))

        'Setup the hide file button
        If TypeOf e.Node Is VendorFileFileNode Then
            VendorFileHideTSButton.Enabled = True
            Dim node As VendorFileFileNode = DirectCast(e.Node, VendorFileFileNode)
            VendorFileHideTSButton.Checked = (Not node.Source.ShowInTree)
        Else
            VendorFileHideTSButton.Enabled = False
            VendorFileHideTSButton.Checked = False
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
            VendorFileTreeView.Font = My.Settings.NavigatorFont
        End If

    End Sub

#End Region

#Region " Public Methods "

    Public Sub PopulateTree(ByVal refresh As Boolean)

        Dim rootNode As VendorFileRootNode = Nothing
        Dim newRootNode As VendorFileRootNode = Nothing
        Dim clientNode As VendorFileClientNode = Nothing
        Dim newClientNode As VendorFileClientNode = Nothing
        Dim studyNode As VendorFileStudyNode = Nothing
        Dim newStudyNode As VendorFileStudyNode = Nothing
        Dim surveyNode As VendorFileSurveyNode = Nothing
        Dim newSurveyNode As VendorFileSurveyNode = Nothing
        Dim newFileNode As VendorFileFileNode = Nothing
        Dim expandedNodeKeys As New List(Of String)
        Dim selectedNodeKey As String = String.Empty

        'Refresh the tree data if required
        If refresh Then RefreshTreeData()

        'Save the current state of the tree
        SaveTreeState(expandedNodeKeys, selectedNodeKey)

        'Clear the tree
        VendorFileTreeView.Nodes.Clear()

        'Populate the tree
        Dim treeData As VendorFileNavigatorTreeCollection = GetTreeData()
        For Each item As VendorFileNavigatorTree In treeData
            'Check to see if we are adding this one
            If item.ShowInTree OrElse VendorFileShowTSButton.Checked Then
                'Check to see if this root exists
                newRootNode = New VendorFileRootNode(item)
                If Not VendorFileTreeView.Nodes.ContainsKey(newRootNode.Name) Then
                    'Add this node to the tree
                    VendorFileTreeView.Nodes.Add(newRootNode)
                    rootNode = newRootNode
                Else
                    'Get a reference to the existing node
                    rootNode = DirectCast(VendorFileTreeView.Nodes(newRootNode.Name), VendorFileRootNode)
                End If

                'Check to see if this Client exists
                newClientNode = New VendorFileClientNode(item)
                If Not rootNode.Nodes.ContainsKey(newClientNode.Name) Then
                    'Add this node to the tree
                    rootNode.Nodes.Add(newClientNode)
                    clientNode = newClientNode
                Else
                    'Get a reference to the existing node
                    clientNode = DirectCast(rootNode.Nodes(newClientNode.Name), VendorFileClientNode)
                End If

                'Check to see if this Study exists
                newStudyNode = New VendorFileStudyNode(item)
                If Not clientNode.Nodes.ContainsKey(newStudyNode.Name) Then
                    'Add this node to the tree
                    clientNode.Nodes.Add(newStudyNode)
                    studyNode = newStudyNode
                Else
                    'Get a reference to the existing node
                    studyNode = DirectCast(clientNode.Nodes(newStudyNode.Name), VendorFileStudyNode)
                End If

                'Check to see if this Survey exists
                newSurveyNode = New VendorFileSurveyNode(item)
                If Not studyNode.Nodes.ContainsKey(newSurveyNode.Name) Then
                    'Add this node to the tree
                    studyNode.Nodes.Add(newSurveyNode)
                    surveyNode = newSurveyNode
                Else
                    'Get a reference to the existing node
                    surveyNode = DirectCast(studyNode.Nodes(newSurveyNode.Name), VendorFileSurveyNode)
                End If

                'Check to see if this File node exists
                newFileNode = New VendorFileFileNode(item)
                If Not surveyNode.Nodes.ContainsKey(newFileNode.Name) Then
                    'Determine the node font and color
                    If Not item.ShowInTree Then
                        newFileNode.NodeFont = New Font(VendorFileTreeView.Font, FontStyle.Italic)
                        newFileNode.ForeColor = System.Drawing.SystemColors.GrayText
                    End If

                    'Add this node to the tree
                    surveyNode.Nodes.Add(newFileNode)
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
        With VendorFileImageList.Images
            .Add(VendorFileImageKeys.RootPhone, My.Resources.Phone)
            .Add(VendorFileImageKeys.RootWeb, My.Resources.Web)
            .Add(VendorFileImageKeys.RootIVR, My.Resources.IVR)
            .Add(VendorFileImageKeys.RootMailWeb, My.Resources.MailWeb)
            .Add(VendorFileImageKeys.RootLetterWeb, My.Resources.LetterWeb)
            .Add(VendorFileImageKeys.RootBedside, My.Resources.Bedside)
            .Add(VendorFileImageKeys.Client, My.Resources.Member32)
            .Add(VendorFileImageKeys.Study, My.Resources.Study)
            .Add(VendorFileImageKeys.Survey, My.Resources.Survey)
            .Add(VendorFileImageKeys.FileProcessing, My.Resources.DocumentRed16)
            .Add(VendorFileImageKeys.FileProcessingFailed, My.Resources.NoWay16)
            .Add(VendorFileImageKeys.FilePending, My.Resources.DocumentYellow16)
            .Add(VendorFileImageKeys.FileApproved, My.Resources.DocumentGreen16)
            .Add(VendorFileImageKeys.FileTelematching, My.Resources.Document16)
            .Add(VendorFileImageKeys.FileSent, My.Resources.Validation16)
        End With

        'Populate the filter combobox
        SetFilterMode(My.Settings.VendorFileNavigatorFilterMode)
        Dim filterList As New List(Of ListItem(Of Integer))
        With filterList
            .Add(New ListItem(Of Integer)("<All>", 0))
            For Each status As VendorFileStatus In VendorFileStatus.GetAll()
                .Add(New ListItem(Of Integer)(status.Name, status.Id))
            Next
        End With
        With VendorFileFilterComboBox
            .DataSource = filterList
            .DisplayMember = "Label"
            .ValueMember = "Value"
            .SelectedValue = mFilterMode
        End With

        'Set the default date range
        VendorFileFromDateTimePicker.Value = Now.AddDays(0 - AppConfig.Params("QSIVendorFileDefaultDaysToDisplay").IntegerValue)

        'Set the TreeView font
        VendorFileTreeView.Font = My.Settings.NavigatorFont

        'Setup the Legend
        ShowLegend(My.Settings.VendorFileViewTreeLegend)

        'Setup the hide file button
        VendorFileHideTSButton.Enabled = False

        'Setup the show hidden files button
        VendorFileShowTSButton.Checked = False

        mIsInitializing = False

    End Sub

    Private Sub RefreshTreeData()

        mTreeData = Nothing
        mTreeData = VendorFileNavigatorTree.GetAllByDateRange(CInt(VendorFileFilterComboBox.SelectedValue), VendorFileFromDateTimePicker.Value.Date)

    End Sub

    Private Function GetTreeData() As VendorFileNavigatorTreeCollection

        Return mTreeData

    End Function

    Private Sub SaveTreeState(ByVal expandedNodeKeys As List(Of String), ByRef selectedNodeKey As String)

        'Save the current expanded node keys
        For Each vendorNode As TreeNode In VendorFileTreeView.Nodes
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
        If VendorFileTreeView.SelectedNode IsNot Nothing Then
            selectedNodeKey = VendorFileTreeView.SelectedNode.Name
        End If

    End Sub

    Private Sub RestoreTreeState(ByVal expandedNodeKeys As List(Of String), ByVal selectedNodeKey As String)

        If VendorFileTreeView.Nodes.Count = 0 Then Exit Sub

        'Restore the expanded nodes
        If expandedNodeKeys IsNot Nothing Then
            For Each key As String In expandedNodeKeys
                Dim expandedNodes As TreeNode() = VendorFileTreeView.Nodes.Find(key, True)
                If expandedNodes IsNot Nothing AndAlso expandedNodes.Length > 0 Then
                    expandedNodes(0).Expand()
                End If
            Next
        End If

        'Restore the selected node
        Dim selectedNodeFound As Boolean = False
        If Not String.IsNullOrEmpty(selectedNodeKey) Then
            Dim selectedNodes As TreeNode() = VendorFileTreeView.Nodes.Find(selectedNodeKey, True)
            If selectedNodes IsNot Nothing AndAlso selectedNodes.Length > 0 Then
                selectedNodeFound = True
                VendorFileTreeView.SelectedNode = selectedNodes(0)
                VendorFileTreeView.SelectedNode.EnsureVisible()
            End If
        End If

        'If the previously selected node was not found then select the highest root node
        If Not selectedNodeFound Then
            For Each node As TreeNode In VendorFileTreeView.Nodes
                node.Expand()
            Next
            VendorFileTreeView.SelectedNode = VendorFileTreeView.Nodes(0)
        End If

    End Sub

    Private Sub ShowLegend(ByVal visible As Boolean)

        'Setup the legend control
        LegendToolStrip.Visible = visible
        LegendControlShowTSButton.Visible = Not visible
        LegendControlHideTSButton.Visible = visible

        'Save the view setting
        My.Settings.VendorFileViewTreeLegend = visible

    End Sub

    Private Sub SetFilterMode(ByVal filterMode As Integer)

        'Save the setting
        mFilterMode = filterMode
        My.Settings.VendorFileNavigatorFilterMode = filterMode

    End Sub

#End Region

End Class
