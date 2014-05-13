Imports Nrc.Qualisys.QLoader.Library.SqlProvider

Public Class FunctionTreeView
    Inherits System.Windows.Forms.TreeView

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal clientID As Integer, ByVal showCustom As Boolean, ByVal showSystem As Boolean)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        mClientID = clientID
        mShowCustom = showCustom
        mShowSystem = showSystem

        Me.HideSelection = False
        Me.ShowNodeToolTips = False
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        'Add any initialization after the InitializeComponent() call
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
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(FunctionTreeView))
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        '
        'ImageList1
        '
        Me.ImageList1.ImageSize = New System.Drawing.Size(16, 16)
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        '
        'FunctionTreeView
        '
        Me.ImageIndex = 0
        Me.ImageList = Me.ImageList1
        Me.SelectedImageIndex = 0

    End Sub

#End Region

#Region " Private Members "
    Private mClientID As Integer
    Private mShowCustom As Boolean
    Private mShowSystem As Boolean
    Private mFunctionTable As DataTable
    Private mCurrNodeIndex As Integer

#End Region

#Region " Public Properties "

    Public Shadows Property SelectedNode() As FunctionNode
        Get
            Return DirectCast(MyBase.SelectedNode, FunctionNode)
        End Get
        Set(ByVal Value As FunctionNode)
            MyBase.SelectedNode = Value
        End Set
    End Property

#End Region

#Region " Public Methods "
    'Used by the interface to re-populate the tree from the DB
    Public Sub RefreshTree()
        'Call the population method
        LoadTreeNodes()
    End Sub

#End Region

#Region " Private Methods "

#Region " Populate Tree Methods "
    Private Sub LoadTreeNodes()
        'Recursively load the tree nodes from the DB

        Me.Nodes.Clear() ' Clear current function nodes

        'Get the datatable
        mFunctionTable = PackageDB.GetFunctionTree(mClientID, mShowCustom, mShowSystem)

        'Get the root nodes to this controls collection of nodes
        'Load nodes without a parent node
        GetFunctionNode(0, Me.Nodes)

        'Expand all the root nodes
        Dim node As FunctionNode
        For Each node In Me.Nodes
            node.Expand()
        Next
    End Sub

    Private Sub GetFunctionNode(ByVal parentID As Integer, ByVal nodes As TreeNodeCollection)
        'Recursive function to add nodes with a certain parentID to the nodes collection
        Dim filter As String = "ParentNode_id "
        Dim view As New DataView(mFunctionTable)
        Dim row As DataRowView
        Dim node As FunctionNode

        'Create the filter statement
        If parentID = 0 Then
            filter &= "IS NULL"
        Else
            filter &= "= " & parentID
        End If

        'Filter the datatable to get only records whose parent = parentID
        view.RowFilter = filter

        'For each of the resulting records
        For Each row In view
            'Create a new node and populate it
            node = New FunctionNode

            If IsDBNull(row("Function_id")) Then
                node.FunctionID = 0
            Else
                node.FunctionID = CType(row("Function_id"), Integer)
            End If

            If IsDBNull(row("Client_id")) Then
                node.ClientID = -1
            Else
                node.ClientID = CType(row("Client_id"), Integer)
            End If

            node.Text = row("strNode_nm").ToString
            node.ToolTip = row("strToolTip").ToString
            node.NodeID = CType(row("Node_id"), Integer)

            'If this node is not a function then populate its children also
            If node.FunctionID = 0 Then
                GetFunctionNode(node.NodeID, node.Nodes)
            End If

            'Add this node to the collection
            nodes.Add(node)
        Next
    End Sub

#End Region

#Region " Tree Events "

    Private Sub FunctionTreeView_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles MyBase.MouseDown
        'Set the selected item when the right click happens
        If e.Button = Windows.Forms.MouseButtons.Right Then
            Dim pt As New System.Drawing.Point(e.X, e.Y)
            Dim node As TreeNode = Me.GetNodeAt(pt)

            If Not node Is Nothing Then
                Me.SelectedNode = DirectCast(node, FunctionNode)
            End If
        End If
    End Sub
#End Region

#End Region

#Region " FunctionNode Class "
    Public Class FunctionNode
        Inherits TreeNode

#Region " Private Members "
        Private mFunctionID As Integer = 0
        Private mClientID As Integer = 0
        Private mNodeID As Integer
        Private mToolTip As String
#End Region

#Region " Public Properties "
        Public Property FunctionID() As Integer
            Get
                Return mFunctionID
            End Get
            Set(ByVal Value As Integer)
                mFunctionID = Value
            End Set
        End Property
        Public Property ClientID() As Integer
            Get
                Return mClientID
            End Get
            Set(ByVal Value As Integer)
                mClientID = Value
            End Set
        End Property
        Public Property NodeID() As Integer
            Get
                Return mNodeID
            End Get
            Set(ByVal Value As Integer)
                mNodeID = Value
            End Set
        End Property
        Public Property ToolTip() As String
            Get
                Return mToolTip
            End Get
            Set(ByVal Value As String)
                mToolTip = Value
            End Set
        End Property
#End Region

        Public Sub New()
            MyBase.New()
        End Sub

        Public Sub New(ByVal text As String)
            MyBase.New(text)
        End Sub

    End Class
#End Region

End Class
