Imports Nrc.Qualisys.QLoader.Library.SqlProvider

Public Class ClientTreeView
    Inherits System.Windows.Forms.TreeView

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal treeType As ClientTreeTypes)

        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mSelectedNodes = New ArrayList
        mTreeType = treeType
        HideSelection = False
        Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        'Load the tree
        LoadTreeNodes()

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
    Friend WithEvents mImages As System.Windows.Forms.ImageList
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ClientTreeView))
        Me.mImages = New System.Windows.Forms.ImageList(Me.components)
        Me.SuspendLayout()
        '
        'mImages
        '
        Me.mImages.ImageStream = CType(resources.GetObject("mImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.mImages.TransparentColor = System.Drawing.Color.Transparent
        Me.mImages.Images.SetKeyName(0, "")
        Me.mImages.Images.SetKeyName(1, "")
        Me.mImages.Images.SetKeyName(2, "")
        Me.mImages.Images.SetKeyName(3, "Inactive")
        Me.mImages.Images.SetKeyName(4, "Active")
        Me.mImages.Images.SetKeyName(5, "Deleted")
        '
        'ClientTreeView
        '
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Size = New System.Drawing.Size(312, 296)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members "

    Private mTreeType As ClientTreeTypes
    Private mPackageFilterType As PackageFilterTypes = PackageFilterTypes.Active
    Private mCurrentNode As String
    Private mCurrentParent As String

    'Multi-Selection Support
    Private mAllowMultiSelect As Boolean
    Private mSelectedNodes As ArrayList

    Private Const ACTIVE As String = "Active"
    Private Const INACTIVE As String = "Inactive"
    Private Const DELETED As String = "Deleted"

#End Region

#Region " Public Properties "

    Public Property PackageFilterType() As PackageFilterTypes
        Get
            Return mPackageFilterType
        End Get
        Set(ByVal value As PackageFilterTypes)
            mPackageFilterType = value
        End Set
    End Property

    Public Shadows Property SelectedNode() As PackageNode
        Get
            If mSelectedNodes.Count > 0 Then
                Return DirectCast(mSelectedNodes(0), PackageNode)
            Else
                Return Nothing
            End If
        End Get
        Set(ByVal value As PackageNode)
            MyBase.SelectedNode = value
        End Set
    End Property

    Public Property SelectedNodes() As ArrayList
        Get
            Return mSelectedNodes
        End Get
        Set(ByVal Value As ArrayList)
            DeselectNodes()
            mSelectedNodes.Clear()
            mSelectedNodes = Value
            SelectNodes()
        End Set
    End Property

    Public Property AllowMultiSelect() As Boolean
        Get
            Return mAllowMultiSelect
        End Get
        Set(ByVal value As Boolean)
            mAllowMultiSelect = value
        End Set
    End Property

#End Region

#Region " Public Methods "

    Public Sub RefreshTree(ByVal SelectedPackageFilterType As PackageFilterTypes)

        RefreshTree(mTreeType, SelectedPackageFilterType)

    End Sub

    Public Sub RefreshTree()

        RefreshTree(mTreeType, PackageFilterType)

    End Sub

    Public Sub RefreshTree(ByVal treeType As ClientTreeTypes, ByVal SelectedPackageFilterType As PackageFilterTypes)

        Visible = False

        If Not SelectedNode Is Nothing Then
            mCurrentNode = SelectedNode.NodeID
            If Not SelectedNode.Parent Is Nothing Then
                mCurrentParent = DirectCast(SelectedNode.Parent, PackageNode).NodeID
            Else
                mCurrentParent = String.Empty
            End If
        End If

        mTreeType = treeType
        PackageFilterType = SelectedPackageFilterType
        LoadTreeNodes()
        mSelectedNodes.Clear()
        SelectNode(mCurrentNode, mCurrentParent)
        Visible = True

    End Sub

    Public Sub SelectNode(ByVal nodeID As String, ByVal parentID As String)

        Dim node As PackageNode = FindNode(Nodes, nodeID)

        If node Is Nothing Then
            node = FindNode(Nodes, parentID)
        End If

        If Not node Is Nothing Then
            SelectedNode = node
            node.Expand()
            node.EnsureVisible()
        End If

    End Sub

#End Region

#Region " Protected Methods "

    Protected Overrides Sub OnMouseDown(ByVal e As MouseEventArgs)

        'Override the MouseDown method so that we can select on a right-click
        If e.Button = Windows.Forms.MouseButtons.Right Then
            Dim pt As New System.Drawing.Point(e.X, e.Y)
            Dim node As PackageNode = DirectCast(GetNodeAt(pt), PackageNode)

            If Not node Is Nothing Then
                If Not node.IsSelected Then
                    SelectedNode = node
                End If
            End If
        End If

    End Sub

#End Region

#Region " Private Methods "

    Private Function FindNode(ByVal nodes As TreeNodeCollection, ByVal nodeID As String) As PackageNode

        Dim found As PackageNode

        For Each node As PackageNode In nodes
            If node.NodeID = nodeID Then Return node
        Next

        For Each node As PackageNode In nodes
            found = FindNode(node.Nodes, nodeID)
            If found IsNot Nothing Then
                Return found
            End If
        Next

        Return Nothing

    End Function

    Private Sub LoadTreeNodes()

        Dim root As TreeNode
        Dim roots As New ArrayList

        ImageList = Nothing

        Select Case mTreeType
            Case ClientTreeTypes.AllStudiesAndPackages
                roots = GetPackageTreeNodes()
                ImageList = mImages

            Case ClientTreeTypes.DefinedPackages
                roots = GetPackageTreeNodes()
                ImageList = mImages

            Case ClientTreeTypes.FilesInQueue
                roots = GetFileQueueNodes()
                ImageList = mImages

            Case ClientTreeTypes.AllStudiesNoPackages
                roots = GetPackageTreeNodes()
                ImageList = mImages

        End Select

        Nodes.Clear()

        For Each root In roots
            Nodes.Add(root)
        Next

    End Sub

    Private Function GetFileQueueNodes() As ArrayList

        Dim table As DataTable = PackageDB.GetFileQueueTree(CurrentUser.LoginName)
        Dim row As DataRow
        Dim roots As New ArrayList

        Dim clientNode As PackageNode = Nothing
        Dim studyNode As PackageNode = Nothing
        Dim packNode As PackageNode = Nothing
        Dim fileNode As PackageNode = Nothing

        Dim clientID As Integer = 0
        Dim studyID As Integer = 0
        Dim packageID As Integer = 0
        Dim fileID As Integer = 0

        For Each row In table.Rows
            If Not MeetsThePackageFilter(row) Then
                Continue For
            End If

            If Not CType(row("Client_id"), Integer) = clientID Then
                clientNode = GetClientNode(row)
                clientID = clientNode.ClientID
                roots.Add(clientNode)
            End If

            If Not CType(row("Study_id"), Integer) = studyID Then
                studyNode = GetStudyNode(row, clientNode)
                studyID = studyNode.StudyID
                clientNode.Nodes.Add(studyNode)
            End If

            If Not CType(row("Package_id"), Integer) = packageID Then
                packNode = GetPackageNode(row, studyNode)
                packageID = packNode.PackageID
                studyNode.Nodes.Add(packNode)
            End If

            If Not CType(row("DataFile_id"), Integer) = fileID Then
                fileID = CType(row("DataFile_id"), Integer)
                fileNode = New PackageNode
                fileNode.ClientID = packNode.ClientID
                fileNode.ClientName = packNode.ClientName
                fileNode.StudyName = packNode.StudyName
                fileNode.StudyID = packNode.StudyID
                fileNode.PackageName = packNode.PackageName
                fileNode.PackageID = packNode.PackageID
                packNode.Version = CType(row("intVersion"), Integer)
                fileNode.FileName = row("FileName").ToString.Trim
                fileNode.FileID = fileID
                fileNode.Text = String.Format("{0} ({1})", fileNode.FileName, fileNode.FileID)
                fileNode.GroupList = row("AssocDataFiles").ToString
                fileNode.IsGrouped = (fileNode.GroupList.IndexOf(",") >= 0)
                If fileNode.IsGrouped Then
                    fileNode.ImageIndex = 1
                    fileNode.SelectedImageIndex = 1
                    fileNode.ForeColor = Color.SteelBlue
                Else
                    fileNode.ImageIndex = 2
                    fileNode.SelectedImageIndex = 2
                End If

                packNode.Nodes.Add(fileNode)
            End If
        Next

        Return roots

    End Function

    Private Function MeetsThePackageFilter(ByVal row As DataRow) As Boolean

        'Show deleted only in Deleted mode
        If PackageFilterType <> PackageFilterTypes.Deleted AndAlso CType(row("bitDeleted"), Boolean) Then
            Return False
        End If

        Return MeetsActiveInactive(row) Or MeetsActive(row) Or MeetsInactive(row) Or MeetsDeleted(row)

    End Function

    Private Function MeetsInactive(ByVal row As DataRow) As Boolean

        Return (Not CType(row("bitActive"), Boolean) And PackageFilterType = PackageFilterTypes.Inactive)

    End Function

    Private Function MeetsActive(ByVal row As DataRow) As Boolean

        Return (CType(row("bitActive"), Boolean) And PackageFilterType = PackageFilterTypes.Active)

    End Function

    Private Function MeetsDeleted(ByVal row As DataRow) As Boolean

        'We get all the deleted records from a stored proc already filtered.  Won't hurt to double check though
        Return (CType(row("bitDeleted"), Boolean) And PackageFilterType = PackageFilterTypes.Deleted)

    End Function

    Private Function MeetsActiveInactive(ByVal row As DataRow) As Boolean

        Return (PackageFilterType = PackageFilterTypes.All)

    End Function

    Private Shared Function GetClientNode(ByVal PackageRow As DataRow) As PackageNode

        Dim clientNode As New PackageNode

        clientNode.ClientID = CType(PackageRow("Client_id"), Integer)
        clientNode.ClientName = PackageRow("strClient_nm").ToString.Trim
        clientNode.Text = String.Format("{0} ({1})", clientNode.ClientName, clientNode.ClientID)

        Return clientNode

    End Function

    Private Shared Function GetStudyNode(ByVal PackageRow As DataRow, ByVal ClientNode As PackageNode) As PackageNode

        Dim studyNode As New PackageNode

        studyNode.ClientID = ClientNode.ClientID
        studyNode.ClientName = ClientNode.ClientName
        studyNode.StudyName = PackageRow("strStudy_nm").ToString.Trim
        studyNode.StudyID = CType(PackageRow("Study_id"), Integer)
        studyNode.Text = String.Format("{0} ({1})", studyNode.StudyName, studyNode.StudyID)

        Return studyNode

    End Function

    Private Shared Function GetImageKey(ByVal PackageRow As DataRow) As String

        If CBool(PackageRow("BitDeleted")) Then
            Return DELETED
        End If

        If CBool(PackageRow("BitActive")) Then
            Return ACTIVE
        Else
            Return INACTIVE
        End If

    End Function

    Private Shared Function GetPackageNode(ByVal PackageRow As DataRow, ByVal studyNode As PackageNode) As PackageNode

        Dim packNode As New PackageNode

        packNode.ClientID = studyNode.ClientID
        packNode.ClientName = studyNode.ClientName
        packNode.StudyName = studyNode.StudyName
        packNode.StudyID = studyNode.StudyID
        packNode.PackageName = PackageRow("strPackage_nm").ToString.Trim
        packNode.PackageID = CType(PackageRow("Package_id"), Integer)
        packNode.Version = CType(PackageRow("intVersion"), Integer)
        packNode.Text = String.Format("{0} ({1})", packNode.PackageName, packNode.PackageID)
        packNode.ImageKey = GetImageKey(PackageRow)
        packNode.SelectedImageKey = packNode.ImageKey

        Return packNode

    End Function

    Private Function FillTheTree(ByVal table As DataTable) As ArrayList

        Dim roots As New ArrayList

        Dim clientNode As PackageNode = Nothing
        Dim studyNode As PackageNode = Nothing
        Dim packNode As PackageNode = Nothing

        Dim clientID As Integer = 0
        Dim studyID As Integer = 0
        Dim packageID As Integer = 0

        For Each row As DataRow In table.Rows
            If Not CType(row("Client_id"), Integer) = clientID Then
                clientNode = GetClientNode(row)
                clientID = clientNode.ClientID
                roots.Add(clientNode)
            End If

            If Not CType(row("Study_id"), Integer) = studyID Then
                studyNode = GetStudyNode(row, clientNode)
                studyID = studyNode.StudyID
                clientNode.Nodes.Add(studyNode)
            End If

            If Not mTreeType = ClientTreeTypes.AllStudiesNoPackages Then
                If Not IsDBNull(row("Package_id")) Then
                    If Not CType(row("Package_id"), Integer) = packageID Then
                        If MeetsThePackageFilter(row) Then
                            packNode = GetPackageNode(row, studyNode)
                            packageID = packNode.PackageID
                            studyNode.Nodes.Add(packNode)
                        End If
                    End If
                End If
            End If
        Next

        Return roots

    End Function

    Private Function GetPackageTreeNodes() As ArrayList

        'Data table contains:
        'Client ID, Client Name, Study ID, Study Name.
        'If showPackage, it also contains Package ID and Package Name.
        If PackageFilterType = PackageFilterTypes.Deleted Then
            Return GetDeletedPackageTreeNodes()
        Else
            Dim showPackage As Boolean = (mTreeType = ClientTreeTypes.AllStudiesAndPackages OrElse mTreeType = ClientTreeTypes.AllStudiesNoPackages)
            Dim table As DataTable = PackageDB.GetPackageList(CurrentUser.LoginName, showPackage)

            Return FillTheTree(table)
        End If

    End Function

    Private Function GetDeletedPackageTreeNodes() As ArrayList

        Dim table As DataTable = DTSPackage.GetDeletedPackages(CurrentUser.LoginName)

        Return FillTheTree(table)

    End Function

#End Region

#Region " Overrides for Multi-Selection "

    'This Function starts the multiple selection.
    Protected Overrides Sub OnBeforeSelect(ByVal e As TreeViewCancelEventArgs)

        MyBase.OnBeforeSelect(e)

        Dim controlPressed As Boolean = (ModifierKeys = Keys.Control)

        If controlPressed AndAlso mSelectedNodes.Contains(e.Node) AndAlso mAllowMultiSelect Then
            DeselectNodes()
            mSelectedNodes.Remove(e.Node)
            SelectNodes()
            e.Cancel = True
            Exit Sub
        End If

    End Sub

    'This function ends the multi selection. Also adds and removes the node to
    'the selectedNodes depending upon the keys prssed.
    Protected Overrides Sub OnAfterSelect(ByVal e As TreeViewEventArgs)

        MyBase.OnAfterSelect(e)

        Dim node As PackageNode = DirectCast(e.Node, PackageNode)
        Dim controlPressed As Boolean = (ModifierKeys = Keys.Control)

        If controlPressed AndAlso mAllowMultiSelect Then
            If Not mSelectedNodes.Contains(e.Node) Then
                mSelectedNodes.Add(e.Node)
            Else
                DeselectNodes()
                mSelectedNodes.Remove(e.Node)
            End If

            SelectNodes()
        Else
            If (Not mSelectedNodes Is Nothing AndAlso mSelectedNodes.Count > 0) Then
                DeselectNodes()
                mSelectedNodes.Clear()
            End If

            If node.IsGrouped Then
                SelectStudyNodes(node)
            Else
                mSelectedNodes.Add(e.Node)
            End If

            SelectNodes()
        End If

    End Sub

    Private Sub SelectStudyNodes(ByVal node As PackageNode)

        Dim groupList As String
        Dim groups As New ArrayList
        Dim studyNode As PackageNode
        Dim packNode As PackageNode

        If Not node Is Nothing Then
            groupList = node.GroupList
            groups.AddRange(groupList.Split(Char.Parse(",")))

            packNode = DirectCast(node.Parent, PackageNode)
            If packNode Is Nothing Then Exit Sub

            studyNode = DirectCast(packNode.Parent, PackageNode)
            If studyNode Is Nothing Then Exit Sub

            For Each packNode In studyNode.Nodes
                For Each node In packNode.Nodes
                    If groups.Contains(node.FileID.ToString) Then
                        mSelectedNodes.Add(node)
                    End If
                Next
            Next
        End If

    End Sub

    'Overriden OnGotFocus to mimic TreeView's behavior of selecting nodes.
    Protected Overrides Sub OnGotFocus(ByVal e As EventArgs)

        MyBase.OnGotFocus(e)

        SelectNodes()

    End Sub

    'Overriden OnLostFocus to mimic TreeView's behavior of de-selecting nodes.
    Protected Overrides Sub OnLostFocus(ByVal e As EventArgs)

        MyBase.OnLostFocus(e)

        DeselectNodes()

    End Sub

#End Region

#Region " Multi-Selection Private Methods "

    'This function provides the user feedback that the node is selected
    'Basically the BackColor and the ForeColor is changed for all
    'the nodes in the selectedNodes collection.
    Private Sub SelectNodes()

        Dim n As PackageNode
        Dim parent As PackageNode

        For Each n In mSelectedNodes
            n.BackColor = SystemColors.Highlight
            n.ForeColor = SystemColors.HighlightText

            parent = DirectCast(n.Parent, PackageNode)

            While Not parent Is Nothing
                If Not parent.IsExpanded Then
                    parent.Expand()
                End If

                parent = DirectCast(parent.Parent, PackageNode)
            End While
        Next

    End Sub

    'This function provides the user feedback that the node is de-selected
    'Basically the BackColor and the ForeColor is changed for all
    'the nodes in the selectedNodes collection.
    Private Sub DeselectNodes()

        If mSelectedNodes.Count = 0 Then
            Exit Sub
        End If

        Dim node As PackageNode = DirectCast(mSelectedNodes(0), PackageNode)
        Dim backColor As Color = Me.BackColor
        Dim foreColor As Color

        If node.IsGrouped Then
            foreColor = Color.SteelBlue
        Else
            foreColor = Me.ForeColor
        End If

        For Each n As TreeNode In mSelectedNodes
            n.BackColor = backColor
            n.ForeColor = foreColor
        Next
    End Sub

    'This function selects all the Nodes in the MultiSelectTreeView..
    Private Sub SelectAllNodes(ByVal nodes As TreeNodeCollection)

        For Each n As TreeNode In nodes
            mSelectedNodes.Add(n)

            If n.Nodes.Count > 1 Then
                SelectAllNodes(n.Nodes)
            End If
        Next

    End Sub

#End Region

End Class
