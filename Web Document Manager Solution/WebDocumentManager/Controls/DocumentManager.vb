Imports NRC.DataMart.WebDocumentManager.Library
Imports NRC.NRCAuthLib
Imports NRC.WinForms

Public Class DocumentManager
    Inherits System.Windows.Forms.UserControl

#Region "Private Members"
    Private ts As DataGridTableStyle
    Private mOrgUnit As OrgUnit
    Private mMember As Member
    Private mGroups As New GroupCollection
    Private WithEvents mTreeViewContextMenu As New ContextMenu
    Private WithEvents mListViewContextMenu As New ContextMenu
    Private mSelectedGroup As Group
    Private mTreeGroups As TreeGroupCollection = TreeGroupCollection.GetTreeGroups
    Private mCopiedDocuments As New DocumentCollection
    Private pasteMenuItem As New MenuItem
    Private boolCut As Boolean = False
#End Region

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        AddHandler lvwDocuments.ColumnClick, AddressOf ColumnClick

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents lvwDocuments As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader4 As System.Windows.Forms.ColumnHeader
    Friend WithEvents cmbGroups As System.Windows.Forms.ComboBox
    Friend WithEvents btnMoveUp As System.Windows.Forms.Button
    Friend WithEvents btnMoveDown As System.Windows.Forms.Button
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents ColumnHeader5 As System.Windows.Forms.ColumnHeader
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents SectionPanel2 As NRC.WinForms.SectionPanel
    Friend WithEvents SectionPanel3 As NRC.WinForms.SectionPanel
    Friend WithEvents trvGroupNodes As NRCWebDocumentManager.NRCAuthTreeView
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lvwDocuments = New System.Windows.Forms.ListView
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader5 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader4 = New System.Windows.Forms.ColumnHeader
        Me.cmbGroups = New System.Windows.Forms.ComboBox
        Me.btnMoveUp = New System.Windows.Forms.Button
        Me.btnMoveDown = New System.Windows.Forms.Button
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.Label1 = New System.Windows.Forms.Label
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.SectionPanel2 = New NRC.WinForms.SectionPanel
        Me.trvGroupNodes = New NRCWebDocumentManager.NRCAuthTreeView
        Me.SectionPanel3 = New NRC.WinForms.SectionPanel
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SectionPanel3.SuspendLayout()
        Me.SuspendLayout()
        '
        'lvwDocuments
        '
        Me.lvwDocuments.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwDocuments.BackColor = System.Drawing.SystemColors.Window
        Me.lvwDocuments.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader2, Me.ColumnHeader1, Me.ColumnHeader5, Me.ColumnHeader3, Me.ColumnHeader4})
        Me.lvwDocuments.FullRowSelect = True
        Me.lvwDocuments.LabelEdit = True
        Me.lvwDocuments.Location = New System.Drawing.Point(8, 32)
        Me.lvwDocuments.Name = "lvwDocuments"
        Me.lvwDocuments.Size = New System.Drawing.Size(568, 536)
        Me.lvwDocuments.TabIndex = 3
        Me.lvwDocuments.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Name"
        Me.ColumnHeader2.Width = 154
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "Document ID"
        Me.ColumnHeader1.Width = 83
        '
        'ColumnHeader5
        '
        Me.ColumnHeader5.Text = "Type"
        Me.ColumnHeader5.Width = 64
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Date Posted"
        Me.ColumnHeader3.Width = 153
        '
        'ColumnHeader4
        '
        Me.ColumnHeader4.Text = "Grouping Type"
        Me.ColumnHeader4.Width = 102
        '
        'cmbGroups
        '
        Me.cmbGroups.Location = New System.Drawing.Point(8, 32)
        Me.cmbGroups.Name = "cmbGroups"
        Me.cmbGroups.Size = New System.Drawing.Size(448, 21)
        Me.cmbGroups.TabIndex = 5
        '
        'btnMoveUp
        '
        Me.btnMoveUp.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnMoveUp.Location = New System.Drawing.Point(80, 576)
        Me.btnMoveUp.Name = "btnMoveUp"
        Me.btnMoveUp.TabIndex = 7
        Me.btnMoveUp.Text = "Move Up"
        '
        'btnMoveDown
        '
        Me.btnMoveDown.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnMoveDown.Location = New System.Drawing.Point(176, 576)
        Me.btnMoveDown.Name = "btnMoveDown"
        Me.btnMoveDown.TabIndex = 8
        Me.btnMoveDown.Text = "Move Down"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.Filter = "All files (*.*)|*.*|excel (*.xls)|*.xls|dbf (*.dbf)|*.dbf|text (*.txt)|*txt|csv (" & _
        "*.csv)|*.csv"
        Me.OpenFileDialog1.Multiselect = True
        '
        'Label1
        '
        Me.Label1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label1.Location = New System.Drawing.Point(8, 574)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(560, 24)
        Me.Label1.TabIndex = 10
        Me.Label1.Text = "*Documents highlighted in yellow are not currently available on the web."
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Select Group"
        Me.SectionPanel1.Controls.Add(Me.cmbGroups)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(920, 64)
        Me.SectionPanel1.TabIndex = 11
        '
        'SectionPanel2
        '
        Me.SectionPanel2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel2.Caption = "eReports Folders"
        Me.SectionPanel2.Controls.Add(Me.trvGroupNodes)
        Me.SectionPanel2.Controls.Add(Me.btnMoveUp)
        Me.SectionPanel2.Controls.Add(Me.btnMoveDown)
        Me.SectionPanel2.DockPadding.All = 1
        Me.SectionPanel2.Location = New System.Drawing.Point(0, 72)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(328, 608)
        Me.SectionPanel2.TabIndex = 12
        '
        'trvGroupNodes
        '
        Me.trvGroupNodes.AllowDrop = True
        Me.trvGroupNodes.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.trvGroupNodes.ImageIndex = -1
        Me.trvGroupNodes.LabelEdit = True
        Me.trvGroupNodes.Location = New System.Drawing.Point(13, 32)
        Me.trvGroupNodes.Name = "trvGroupNodes"
        Me.trvGroupNodes.SelectedImageIndex = -1
        Me.trvGroupNodes.Size = New System.Drawing.Size(304, 536)
        Me.trvGroupNodes.TabIndex = 10
        '
        'SectionPanel3
        '
        Me.SectionPanel3.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel3.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel3.Caption = "Documents List"
        Me.SectionPanel3.Controls.Add(Me.lvwDocuments)
        Me.SectionPanel3.Controls.Add(Me.Label1)
        Me.SectionPanel3.DockPadding.All = 1
        Me.SectionPanel3.Location = New System.Drawing.Point(336, 72)
        Me.SectionPanel3.Name = "SectionPanel3"
        Me.SectionPanel3.ShowCaption = True
        Me.SectionPanel3.Size = New System.Drawing.Size(584, 608)
        Me.SectionPanel3.TabIndex = 13
        '
        'DocumentManager
        '
        Me.Controls.Add(Me.SectionPanel3)
        Me.Controls.Add(Me.SectionPanel2)
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "DocumentManager"
        Me.Size = New System.Drawing.Size(920, 680)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.SectionPanel3.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Public Properties"
    Public ReadOnly Property OrgUnit() As OrgUnit
        Get
            Return mOrgUnit
        End Get
    End Property

    Public ReadOnly Property Member() As Member
        Get
            Return mMember
        End Get
    End Property
#End Region

#Region "Public Methods"
    Public Sub OrgUnitChange(ByVal pOrgUnit As OrgUnit, ByVal pMember As Member)
        cmbGroups.DataSource = mGroups
        cmbGroups.DisplayMember = "Name"
        lvwDocuments.Items.Clear()
        trvGroupNodes.Nodes.Clear()

        mOrgUnit = pOrgUnit
        mMember = pMember
        populateGroups()
    End Sub

    Public Sub TreeView_ItemDrag(ByVal sender As Object, _
                                ByVal e As ItemDragEventArgs) _
                                Handles trvGroupNodes.ItemDrag
        DoDragDrop(e.Item, DragDropEffects.Move)
    End Sub


    Public Sub TreeView_DragEnter(ByVal sender As Object, _
                               ByVal e As DragEventArgs) _
                               Handles trvGroupNodes.DragEnter
        e.Effect = DragDropEffects.Move
    End Sub

    Public Sub TreeView1_DragOver(ByVal sender As System.Object, ByVal e As DragEventArgs) _
          Handles trvGroupNodes.DragOver

        'Check that there is a TreeNode being dragged 
        If e.Data.GetDataPresent("System.Windows.Forms.TreeNode", _
               True) = False Then Exit Sub

        'Get the TreeView raising the event (incase multiple on form)
        Dim selectedTreeview As TreeView = CType(sender, TreeView)

        'As the mouse moves over nodes, provide feedback to 
        'the user by highlighting the node that is the 
        'current drop target
        Dim pt As Point = _
            CType(sender, TreeView).PointToClient(New Point(e.X, e.Y))
        Dim targetNode As TreeNode = selectedTreeview.GetNodeAt(pt)

        'See if the targetNode is currently selected, 
        'if so no need to validate again
        If Not (selectedTreeview.SelectedNode Is targetNode) Then
            'Select the    node currently under the cursor
            selectedTreeview.SelectedNode = targetNode

            'Check that the selected node is not the dropNode and
            'also that it is not a child of the dropNode and 
            'therefore an invalid target
            Dim dropNode As TreeNode = _
                CType(e.Data.GetData("System.Windows.Forms.TreeNode"), _
                TreeNode)

            Do Until targetNode Is Nothing
                If targetNode Is dropNode Then
                    e.Effect = DragDropEffects.None
                    Exit Sub
                End If
                targetNode = targetNode.Parent
            Loop

            'Currently selected node is a suitable target
            e.Effect = DragDropEffects.Move
        End If

    End Sub

    Public Sub TreeView1_DragDrop(ByVal sender As System.Object, _
        ByVal e As System.Windows.Forms.DragEventArgs) _
        Handles trvGroupNodes.DragDrop

        'Check that there is a TreeNode being dragged
        If e.Data.GetDataPresent("System.Windows.Forms.TreeNode", _
              True) = False Then Exit Sub

        'Get the TreeView raising the event (incase multiple on form)
        Dim selectedTreeview As TreeView = CType(sender, TreeView)

        'Get the TreeNode being dragged
        Dim dropNode As TreeNode = _
              CType(e.Data.GetData("System.Windows.Forms.TreeNode"), _
              TreeNode)

        'The target node should be selected from the DragOver event
        Dim targetNode As TreeNode = selectedTreeview.SelectedNode


        'Don't allow drop of a node onto itself
        If dropNode Is targetNode Then Return

        'Check for a node with the same name as the dropnode under the new parent
        If NodeNameNotAvailable(DirectCast(targetNode.Tag, DocumentNode), DirectCast(dropNode.Tag, DocumentNode).Name) Then
            MessageBox.Show("A node already exists with this name for this parent.  Move Cancelled.", "Move Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            Try
                Dim lastDocChild As DocumentNode = Nothing
                If Not targetNode.LastNode Is Nothing Then
                    lastDocChild = DirectCast(targetNode.LastNode.Tag, DocumentNode)
                End If
                moveNodetoNewParent(DirectCast(dropNode.Tag, DocumentNode), DirectCast(dropNode.Parent.Tag, DocumentNode), DirectCast(targetNode.Tag, DocumentNode), lastDocChild)
            Catch ex As Exception
                MessageBox.Show(ex.Message, "Error Moving Node", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Exit Sub
            End Try
            'Remove the drop node from its current location
            dropNode.Remove()

            'If there is no targetNode add dropNode to the bottom of
            'the TreeView root nodes, otherwise add it to the end of
            'the dropNode child nodes
            If targetNode Is Nothing Then
                selectedTreeview.Nodes.Add(dropNode)
            Else
                targetNode.Nodes.Add(dropNode)
            End If

            'Ensure the newly created node is visible to
            'the user and select it
            dropNode.EnsureVisible()
            selectedTreeview.SelectedNode = dropNode

            RefreshTreeandDocs(DirectCast(dropNode.Tag, DocumentNode).NodeId)

        End If
    End Sub

#End Region

#Region "Private Methods"
    Private Sub RefreshTreeandDocs(ByVal previouslySelectedDocNodeID As Integer)
        lvwDocuments.Items.Clear()
        trvGroupNodes.Nodes.Clear()
        populateTree()
        'Select previously Selected Node
        If DirectCast(trvGroupNodes.Nodes.Item(0).Tag, DocumentNode).NodeId = previouslySelectedDocNodeID Then
            trvGroupNodes.SelectedNode = trvGroupNodes.Nodes.Item(0)
        Else
            trvGroupNodes.SelectedNode = findTreeNode(trvGroupNodes.Nodes.Item(0), previouslySelectedDocNodeID)
        End If
        If Not trvGroupNodes.SelectedNode Is Nothing Then trvGroupNodes.SelectedNode.Expand()
        trvGroupNodes.Focus()
    End Sub

    Private Function findTreeNode(ByVal node As TreeNode, ByVal previouslySelectedDocNodeID As Integer) As TreeNode
        Dim FoundNode As TreeNode = Nothing
        For Each tmpNode As TreeNode In node.Nodes
            If DirectCast(tmpNode.Tag, DocumentNode).NodeId = previouslySelectedDocNodeID Then
                Return tmpNode
            Else
                FoundNode = findTreeNode(tmpNode, previouslySelectedDocNodeID)
                If Not FoundNode Is Nothing Then Return FoundNode
            End If
        Next
        Return FoundNode
    End Function

    Private Sub moveNodetoNewParent(ByVal node As DocumentNode, ByVal oldParent As DocumentNode, ByVal newParent As DocumentNode, ByVal lastChild As DocumentNode)
        'update the order numbers for nodes that came after this node
        For Each treNode As DocumentNode In oldParent.Nodes
            If treNode.Order > node.Order Then
                treNode.Order = treNode.Order - 1
                treNode.UpdateNode(mMember.MemberId)
            End If
        Next

        If Not lastChild Is Nothing Then
            node = DocumentNode.UpdateNode(node.NodeId, mSelectedGroup.GroupId, newParent.NodeId, node.Name, False, lastChild.Order + 1, mMember.MemberId)
        Else
            node = DocumentNode.UpdateNode(node.NodeId, mSelectedGroup.GroupId, newParent.NodeId, node.Name, False, 1, mMember.MemberId)
        End If

    End Sub

    Private Sub DocumentManager_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        AddTreeViewContextMenuItems()
        AddListViewContextMenuItems()
    End Sub

    Private Sub AddTreeViewContextMenuItems()
        Dim objMenuItem As MenuItem
        trvGroupNodes.ContextMenu = mTreeViewContextMenu

        objMenuItem = New MenuItem
        objMenuItem.Text = "Add Folder"
        mTreeViewContextMenu.MenuItems.Add(objMenuItem)
        AddHandler objMenuItem.Click, AddressOf AddNodeClick

        objMenuItem = New MenuItem
        objMenuItem.Text = "Delete Folder"
        mTreeViewContextMenu.MenuItems.Add(objMenuItem)
        AddHandler objMenuItem.Click, AddressOf DeleteNodeClick

        objMenuItem = New MenuItem
        objMenuItem.Text = "Add Document(s)"
        mTreeViewContextMenu.MenuItems.Add(objMenuItem)
        AddHandler objMenuItem.Click, AddressOf AddDocumentClick

        pasteMenuItem.Text = "Paste Document(s)            ctrl+v"
        pasteMenuItem.Enabled = False
        mTreeViewContextMenu.MenuItems.Add(pasteMenuItem)
        AddHandler pasteMenuItem.Click, AddressOf PasteDocumentClick
    End Sub

    Private Sub AddListViewContextMenuItems()
        Dim objMenuItem As MenuItem
        lvwDocuments.ContextMenu = mListViewContextMenu

        objMenuItem = New MenuItem
        objMenuItem.Text = "Copy Document(s)             ctrl+c"
        mListViewContextMenu.MenuItems.Add(objMenuItem)
        AddHandler objMenuItem.Click, AddressOf CopyDocumentClick

        objMenuItem = New MenuItem
        objMenuItem.Text = "Cut Document(s)                ctrl+x"
        mListViewContextMenu.MenuItems.Add(objMenuItem)
        AddHandler objMenuItem.Click, AddressOf CutDocumentClick

        objMenuItem = New MenuItem
        objMenuItem.Text = "Delete Document(s)"
        mListViewContextMenu.MenuItems.Add(objMenuItem)
        AddHandler objMenuItem.Click, AddressOf DeleteDocumentClick

        'objMenuItem = New MenuItem
        'objMenuItem.Text = "Replace Document"
        'mListViewContextMenu.MenuItems.Add(objMenuItem)
        'AddHandler objMenuItem.Click, AddressOf ReplaceDocumentClick

        objMenuItem = New MenuItem
        objMenuItem.Text = "Change Grouping Type"
        mListViewContextMenu.MenuItems.Add(objMenuItem)
        AddHandler objMenuItem.Click, AddressOf ChangeGroupingClick
    End Sub

    Private Function getTreeGroupID(ByVal treeGroupName As String) As Integer
        For Each tmpTreeGroup As TreeGroup In mTreeGroups
            If tmpTreeGroup.Name = treeGroupName Then
                Return tmpTreeGroup.TreeGroupID
            End If
        Next
    End Function

    Private Function getTreeGroupName(ByVal treeGroupID As Integer) As String
        For Each tmpTreeGroup As TreeGroup In mTreeGroups
            If tmpTreeGroup.TreeGroupID = treeGroupID Then
                Return tmpTreeGroup.Name
            End If
        Next
        Return Nothing
    End Function

    Private Sub ChangeGroupingClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim frmInputTreeGroup As New InputDialog(InputDialog.InputType.ListBox)
        Dim grouping As Integer
        Dim selectedDocument As Document
        Dim nodeID As Integer = trvGroupNodes.SelectedDocumentNode.NodeId
        Dim DocumentNodeID As Integer
        Dim selectedNode As TreeNode = trvGroupNodes.SelectedNode

        frmInputTreeGroup.Title = "Please select a Grouping Type."
        For Each tmpTreeGroup As TreeGroup In mTreeGroups
            frmInputTreeGroup.Items.Add(tmpTreeGroup.Name)
        Next
        If Not frmInputTreeGroup.ShowDialog() = DialogResult.Cancel Then
            grouping = getTreeGroupID(CStr(frmInputTreeGroup.SelectedItems().Item(0)))
            For Each selecteditem As Document In SelectedDocs()
                DocumentNodeID = selecteditem.DocumentNodeId
                selectedDocument = document.GetDocument(DocumentNodeID)
                selectedDocument.TreeGroupId = grouping
                selectedDocument.UpdateDocument(mMember.MemberId)
                'Update the document Collection of the node
                For Each document As Document In trvGroupNodes.SelectedDocumentNode.Documents
                    If document.DocumentId = DocumentNodeID Then
                        document.TreeGroupId = grouping
                    End If
                Next
            Next
            'Force a refresh of the list of Documents
            'RemoveHandler trvGroupNodes.AfterSelect, AddressOf trvGroupNodes_AfterSelect
            'trvGroupNodes.SelectedNode = trvGroupNodes.Nodes.Item(0)
            'AddHandler trvGroupNodes.AfterSelect, AddressOf trvGroupNodes_AfterSelect
            'trvGroupNodes.SelectedNode = selectedNode

            RefreshTreeandDocs(nodeID)
        End If

    End Sub

    Private Sub AddNodeClick(ByVal sender As Object, ByVal e As System.EventArgs)
        'Determine which node was selected
        Dim frmInputDialog As New InputDialog(InputDialog.InputType.TextBox)
        Dim nodeName As String = Nothing
        Dim selectedNode As TreeNode = trvGroupNodes.SelectedNode
        Dim selectedDocumentNode As DocumentNode
        Dim lastChild As New DocumentNode
        Dim order As Integer
        Dim newTreeNode As New TreeNode
        Dim newDocumentNode As New DocumentNode
        If Not selectedNode Is Nothing Then
            selectedDocumentNode = trvGroupNodes.SelectedDocumentNode()
            If Not trvGroupNodes.SelectedNode.LastNode Is Nothing Then
                lastChild = DirectCast(trvGroupNodes.SelectedNode.LastNode.Tag, DocumentNode)
                order = lastChild.Order + 1
            Else
                order = 1
            End If
            frmInputDialog.Title = "Specify Name"
            frmInputDialog.Prompt = "Please specify a name for the new Node"
            While nodeName = ""
                If Not frmInputDialog.ShowDialog() = DialogResult.Cancel Then
                    nodeName = frmInputDialog.Input
                    If nodeName <> "" Then
                        Try
                            newDocumentNode = DocumentNode.CreateNode(selectedDocumentNode.GroupId, selectedDocumentNode.NodeId, nodeName, lastChild.Order + 1, mMember.MemberId)
                            newTreeNode.Tag = newDocumentNode
                            newTreeNode.Text = newDocumentNode.Name
                            selectedNode.Nodes.Add(newTreeNode)
                            selectedDocumentNode.Nodes.Add(newDocumentNode)
                        Catch ex As Exception
                            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                            Return
                        End Try
                    End If
                Else
                    Return
                End If
            End While
        End If
    End Sub

    Private Sub DeleteNodeClick(ByVal sender As Object, ByVal e As System.EventArgs)
        DeleteNode()
    End Sub

    Private Sub DeleteNode()
        Dim selectedDocumentNode As DocumentNode = trvGroupNodes.SelectedDocumentNode()
        Dim parentNode As DocumentNode
        Dim group As New Group

        If Not selectedDocumentNode Is Nothing Then
            If selectedDocumentNode.Nodes.Count > 0 Then
                MessageBox.Show("You cannot delete this node because it has child nodes.", "Cannot Delete Node", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            If selectedDocumentNode.Documents.Count > 0 Then
                MessageBox.Show("You cannot delete this node because it has Documents.", "Cannot Delete Node", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            Try
                selectedDocumentNode.DeleteNode(mMember.MemberId)
                parentNode = DirectCast(trvGroupNodes.SelectedNode.Parent().Tag, DocumentNode)
                lvwDocuments.Items.Clear()
                RefreshTreeandDocs(parentNode.NodeId)
            Catch ex As Exception
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End Try
        End If
    End Sub

    Private Function NodeNameNotAvailable(ByVal docNode As DocumentNode, ByVal name As String) As Boolean
        For Each doc As DocumentNode In docNode.Nodes
            If doc.Name.ToUpper = name.ToUpper Then Return True
        Next
        Return False
    End Function

    Private Function DocNameNotAvailable(ByVal docNode As DocumentNode, ByVal name As String) As Integer
        For Each doc As Document In docNode.Documents
            If doc.Name.ToUpper = name.ToUpper Then Return doc.DocumentNodeId
        Next
        Return 0
    End Function

    Private Sub AddDocumentClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim strfilename As String
        Dim strShortName As String
        Dim selectedDocumentNode As DocumentNode = trvGroupNodes.SelectedDocumentNode()
        Dim frmInput As New AddNewDocument
        Dim grouping As Integer
        Dim fileInfo As IO.FileInfo

        Dim DocumentName As String = ""
        Dim NewDocument As Document

        If Not selectedDocumentNode Is Nothing Then
            Try
                If OpenFileDialog1.ShowDialog = DialogResult.OK Then
                    For Each strfilename In OpenFileDialog1.FileNames()
                        fileInfo = New IO.FileInfo(strfilename)
                        If CType(fileInfo.Length / 1024, Integer) > Config.FileSizeLimitkB Then
                            MessageBox.Show("This file excedes the maximum size limit of " + CStr(Config.FileSizeLimitkB) + " KB", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                        Else
                            strShortName = fileInfo.Name.Replace(fileInfo.Extension, "")
                            frmInput.Prompt = "Please specify a name for '" + strShortName + "'."
                            frmInput.DocumentName = strShortName
                            If Not frmInput.ShowDialog() = DialogResult.Cancel Then
                                DocumentName = frmInput.DocumentName
                                While DocNameNotAvailable(selectedDocumentNode, DocumentName) > 0
                                    MessageBox.Show("That name is already in Use.  Please specify a different name.", "Duplicate Name", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                    If frmInput.ShowDialog() = DialogResult.Cancel Then Exit For
                                    DocumentName = frmInput.DocumentName
                                End While
                                grouping = getTreeGroupID(frmInput.TreeGroupingType)
                                NewDocument = Document.CreateDocument(DocumentName, strfilename, selectedDocumentNode.NodeId, Document.documentTypes.docTypeOther, grouping, mMember.MemberId)
                                selectedDocumentNode.Documents.Add(NewDocument)
                            End If
                        End If
                        DocumentName = ""
                    Next
                    RefreshTreeandDocs(trvGroupNodes.SelectedDocumentNode.NodeId)
                End If
            Catch ex As Exception
                MessageBox.Show(ex.InnerException.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If

    End Sub

    Private Sub PasteDocumentClick(ByVal sender As Object, ByVal e As System.EventArgs)
        pasteDoc()
    End Sub

    Private Function SelectedDocs() As DocumentCollection
        Dim DocsCollection As New DocumentCollection
        For Each item As ListViewItem In lvwDocuments.SelectedItems
            DocsCollection.Add(DirectCast(item.Tag, Document))
        Next
        Return DocsCollection
    End Function

    Private Sub pasteDoc()
        Dim selectedDocumentNode As DocumentNode = trvGroupNodes.SelectedDocumentNode()
        Dim replaceDoc As Integer
        Dim messageResult As System.Windows.Forms.DialogResult
        Dim newDocNodeID As Integer
        Dim deleteableDocs As New DocumentCollection
        If Not selectedDocumentNode Is Nothing Then
            For Each doc As Document In mCopiedDocuments
                Try
                    replaceDoc = DocNameNotAvailable(selectedDocumentNode, doc.Name)
                    If replaceDoc > 0 Then
                        messageResult = MessageBox.Show("A document already exists in this folder named '" + doc.Name + "'.  Do you want to replace it?", "Confirm Replace", MessageBoxButtons.YesNo, MessageBoxIcon.Warning)
                        If messageResult = DialogResult.Yes Then
                            Document.Post(trvGroupNodes.SelectedDocumentNode.NodeId, doc.DocumentId, doc.Name, mMember.MemberId, doc.TreeGroupId, replaceDoc, newDocNodeID)
                            deleteableDocs.Add(doc)
                        End If
                    Else
                        Document.Post(trvGroupNodes.SelectedDocumentNode.NodeId, doc.DocumentId, doc.Name, mMember.MemberId, doc.TreeGroupId, replaceDoc, newDocNodeID)
                        deleteableDocs.Add(doc)
                    End If
                Catch ex As Exception
                    MessageBox.Show(ex.Message, "Error Copying '" + doc.Name + "'", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
                newDocNodeID = 0
            Next
            If boolCut Then DeleteDocs(deleteableDocs, False)
            RefreshTreeandDocs(trvGroupNodes.SelectedDocumentNode.NodeId)
        End If
    End Sub

    Private Sub CutDocumentClick(ByVal sender As Object, ByVal e As System.EventArgs)
        boolCut = True
        copydocs()
    End Sub

    Private Sub CopyDocumentClick(ByVal sender As Object, ByVal e As System.EventArgs)
        boolCut = False
        copydocs()
    End Sub

    Private Sub copydocs()
        mCopiedDocuments = SelectedDocs()
        If mCopiedDocuments.Count > 0 Then pasteMenuItem.Enabled = True
    End Sub

    Private Sub DeleteDocumentClick(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim deleteDocsCollection As DocumentCollection
        deleteDocsCollection = SelectedDocs()
        DeleteDocs(deleteDocsCollection)
    End Sub

    Private Sub DeleteDocs(ByVal deleteDocsCollection As DocumentCollection, Optional ByVal confirm As Boolean = True)
        Dim deleteConfirm As ConfirmDeleteDialog
        Dim SelectedDocNode As Integer

        SelectedDocNode = trvGroupNodes.SelectedDocumentNode.NodeId

        For Each doc As Document In deleteDocsCollection
            If confirm Then
                deleteConfirm = New ConfirmDeleteDialog
                deleteConfirm.Label1.Text = "'" + doc.Name + "' may be posted to other groups.  Do you want to delete all instances of this document?"
                deleteConfirm.ShowDialog()
                If deleteConfirm.Result() = ConfirmDeleteDialog.DeleteConfirmResult.Cancel Then
                    'do nothing with this document
                ElseIf deleteConfirm.Result() = ConfirmDeleteDialog.DeleteConfirmResult.DeleteAll Then
                    doc.DeleteDocument(mMember.MemberId, True)
                ElseIf deleteConfirm.Result = ConfirmDeleteDialog.DeleteConfirmResult.DeleteInstance Then
                    doc.DeleteDocument(mMember.MemberId, False)
                End If
            Else
                doc.DeleteDocument(mMember.MemberId, False)
            End If
        Next
        RefreshTreeandDocs(SelectedDocNode)
    End Sub

    Private Sub populateGroups()
        mGroups.Clear()
        If Not mOrgUnit.Groups Is Nothing Then
            For Each tmpGroup As Group In mOrgUnit.Groups
                mGroups.Add(tmpGroup)
            Next
        End If
        RefreshGroups(mGroups)
    End Sub

    Private Sub RefreshGroups(ByVal dataSource As Object)
        Dim myCurrencyManager As CurrencyManager = CType(Me.BindingContext(dataSource), CurrencyManager)
        myCurrencyManager.Refresh()
        SelectedGroupChanged()
    End Sub 'RefreshGrid

    Private Sub populateTree()
        Dim groupTreeNode As New TreeNode
        Dim documentTree As New DocumentTree
        trvGroupNodes.Nodes.Clear()
        documentTree = documentTree.GetDocumentTree(mSelectedGroup.GroupId, mMember.MemberId, False)

        For Each node As DocumentNode In documentTree.Nodes
            groupTreeNode.Tag = node
            groupTreeNode.Text = node.Name
            trvGroupNodes.Visible = False
            trvGroupNodes.Nodes.Add(GetNode(groupTreeNode))
            trvGroupNodes.Nodes.Item(0).Expand()
            trvGroupNodes.Visible = True
        Next

    End Sub

    Private Function GetNode(ByVal Node As TreeNode) As TreeNode
        Dim tmpDocNode As DocumentNode = DirectCast(Node.Tag, DocumentNode)
        Dim tmpTreeNode As TreeNode
        For Each childNode As DocumentNode In tmpDocNode.Nodes
            tmpTreeNode = New TreeNode
            tmpTreeNode.Tag = childNode
            tmpTreeNode.Text = childNode.Name
            Node.Nodes.Add(GetNode(tmpTreeNode))
        Next
        Return Node
    End Function

    ' ColumnClick event handler to add sorting capability.
    Private Sub ColumnClick(ByVal o As Object, ByVal e As ColumnClickEventArgs)
        ' Set the ListViewItemSorter property to a new ListViewItemComparer 
        ' object. Setting this property immediately sorts the 
        ' ListView using the ListViewItemComparer object.
        lvwDocuments.ListViewItemSorter = New ListViewItemComparer(e.Column)
    End Sub

    Private Sub populateDocumentsList()
        Dim tmpDocumentNode As DocumentNode = DirectCast(trvGroupNodes.SelectedNode.Tag, DocumentNode)
        lvwDocuments.Items.Clear()

        If tmpDocumentNode.Documents.Count > 0 Then
            For Each tmpDocument As Document In tmpDocumentNode.Documents
                Dim tmpListView As New Windows.Forms.ListViewItem(tmpDocument.Name)
                tmpListView.Tag = tmpDocument
                tmpListView.SubItems.Add(CStr(tmpDocument.DocumentId))
                tmpListView.SubItems.Add(New IO.FileInfo(tmpDocument.FilePath).Extension)
                tmpListView.SubItems.Add(CStr(tmpDocument.DateAdded))
                tmpListView.SubItems.Add(getTreeGroupName(tmpDocument.TreeGroupId))
                If tmpDocument.Posted = False Then tmpListView.BackColor = System.Drawing.SystemColors.Info
                lvwDocuments.Items.Add(tmpListView)
            Next
        End If
    End Sub

    Private Sub trvGroupNodes_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles trvGroupNodes.AfterSelect
        populateDocumentsList()
    End Sub

    Private Sub updateTree()
        Dim group As New Group
        lvwDocuments.Items.Clear()
        If cmbGroups.SelectedIndex <> -1 Then
            populateTree()
        End If
    End Sub

    Private Sub SelectedGroupChanged()
        If cmbGroups.SelectedIndex <> -1 Then
            mSelectedGroup = DirectCast(cmbGroups.SelectedItem, Group)
        Else
            mSelectedGroup = Nothing
        End If

        updateTree()
    End Sub

    Private Sub cmbGroups_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbGroups.SelectedIndexChanged
        SelectedGroupChanged()
    End Sub

    Private Sub trvGroupNodes_AfterLabelEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.NodeLabelEditEventArgs) Handles trvGroupNodes.AfterLabelEdit
        Dim selectedNode As DocumentNode = DirectCast(e.Node.Tag, DocumentNode)
        If e.Label = "" Then
            e.CancelEdit() = True
            Return
        End If

        selectedNode.Name = e.Label
        selectedNode.UpdateNode(mMember.MemberId)
    End Sub

    Private Sub MoveNode(ByVal moveUp As Boolean)
        Dim selectedTreeNode As TreeNode = trvGroupNodes.SelectedNode
        Dim parentTreeNode As TreeNode = selectedTreeNode.Parent
        Dim selectedDocumentNode As DocumentNode = DirectCast(selectedTreeNode.Tag, DocumentNode)
        Dim replaceDocumentNode As DocumentNode
        Dim nodeIndex As Integer = parentTreeNode.Nodes.IndexOf(selectedTreeNode)

        Try
            If moveUp Then
                If selectedTreeNode.PrevNode Is Nothing Then Return
                replaceDocumentNode = DirectCast(selectedTreeNode.PrevNode().Tag, DocumentNode)
                selectedDocumentNode.Order = selectedDocumentNode.Order - 1
                replaceDocumentNode.Order = replaceDocumentNode.Order + 1
            Else
                If selectedTreeNode.NextNode Is Nothing Then Return
                replaceDocumentNode = DirectCast(selectedTreeNode.NextNode().Tag, DocumentNode)
                selectedDocumentNode.Order = selectedDocumentNode.Order + 1
                replaceDocumentNode.Order = replaceDocumentNode.Order - 1
            End If
            selectedDocumentNode.UpdateNode(mMember.MemberId)
            replaceDocumentNode.UpdateNode(mMember.MemberId)

        Catch ex As Exception
            MessageBox.Show(ex.Message, "Error Moving Node", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return
        End Try

        If moveUp Then
            parentTreeNode.Nodes.Remove(selectedTreeNode)
            parentTreeNode.Nodes.Insert(nodeIndex - 1, selectedTreeNode)
        Else
            parentTreeNode.Nodes.Remove(selectedTreeNode)
            parentTreeNode.Nodes.Insert(nodeIndex + 1, selectedTreeNode)
        End If

        trvGroupNodes.SelectedNode = selectedTreeNode
        trvGroupNodes.Focus()
    End Sub

    Private Sub btnMoveUp_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMoveUp.Click
        MoveNode(True)
    End Sub

    Private Sub btnMoveDown_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnMoveDown.Click
        MoveNode(False)
    End Sub

    Private Sub lvwDocuments_AfterLabelEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.LabelEditEventArgs) Handles lvwDocuments.AfterLabelEdit
        Dim selectedDocument As Document = Document.GetDocument(DirectCast(lvwDocuments.Items.Item(e.Item).Tag, Document).DocumentNodeId)
        If e.Label = "" Then
            e.CancelEdit() = True
            Return
        End If

        selectedDocument.Name = e.Label

        'Steve Kennedy - 03/26/2008 Also Update the name of the item in the trvGroupNodes
        Me.trvGroupNodes.SelectedDocumentNode.Documents(e.Item).Name = e.Label

        selectedDocument.UpdateDocument(mMember.MemberId)
    End Sub

    Private Function getMenuItem(ByVal itemText As String) As MenuItem
        For Each item As MenuItem In mTreeViewContextMenu.MenuItems
            If item.Text = "Paste Document(s)" Then
                Return item
            End If
        Next
        Return Nothing
    End Function

    Private Sub lvwDocuments_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles lvwDocuments.KeyDown
        If e.Control And e.KeyCode = Keys.C Then
            copydocs()
        End If
        If e.KeyCode = Keys.Delete Then
            DeleteDocs(SelectedDocs())
        End If
    End Sub

    Private Sub trvGroupNodes_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles trvGroupNodes.KeyDown
        If e.Control And e.KeyCode = Keys.V Then
            pasteDoc()
        End If
        If e.KeyCode = Keys.Delete Then
            DeleteNode()
        End If
    End Sub

    Private Sub mListViewContextMenu_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles mListViewContextMenu.Popup
        For Each mnuItem As MenuItem In mListViewContextMenu.MenuItems
            If lvwDocuments.Items.Count = 0 Then
                mnuItem.Visible = False
            Else
                mnuItem.Visible = True
            End If
        Next
    End Sub

    Private Sub lvwDocuments_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwDocuments.DoubleClick
        If lvwDocuments.SelectedItems.Count > 1 Then
            MessageBox.Show("You can only open 1 file at a time.", "Open File Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        DirectCast(lvwDocuments.SelectedItems(0).Tag, Document).DisplayFile()
    End Sub
#End Region

End Class

' Implements the manual sorting of items by columns.
Class ListViewItemComparer
    Implements IComparer

    Private col As Integer

    Public Sub New()
        col = 0
    End Sub

    Public Sub New(ByVal column As Integer)
        col = column
    End Sub

    Public Function Compare(ByVal x As Object, ByVal y As Object) As Integer _
       Implements IComparer.Compare
        Return [String].Compare(CType(x, ListViewItem).SubItems(col).Text, CType(y, ListViewItem).SubItems(col).Text)
    End Function
End Class
