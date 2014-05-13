Public Class PackageNavigator

#Region " Private Members "

    Private mSelectedPackageId As Integer
    Private mFiltersDataSource As DataTable
    Private WithEvents mPackageTree As ClientTreeView

    Public Const Active As String = "Active"
    Public Const InActive As String = "Inactive"
    Public Const All As String = "All"

#End Region

#Region " Event Declarations "

    Public Event SelectedPackageChanging As EventHandler(Of SelectedPackageChangingEventArgs)
    Public Event SelectedPackageChanged As EventHandler(Of SelectedPackageChangedEventArgs)
    Public Event PackageFilterChanged As EventHandler
    Public Event SelectedNodeChanged As EventHandler(Of SelectedNodeChangedEventArgs)

#End Region

#Region " Event Initiators "

    Protected Sub OnSelectedPackageChanging(ByVal e As SelectedPackageChangingEventArgs)

        RaiseEvent SelectedPackageChanging(Me, e)

    End Sub

    Protected Sub OnSelectedPackageChanged(ByVal e As SelectedPackageChangedEventArgs)

        RaiseEvent SelectedPackageChanged(Me, e)

    End Sub

    Protected Sub OnSelectedNodeChanged(ByVal e As SelectedNodeChangedEventArgs)

        RaiseEvent SelectedNodeChanged(Me, e)

    End Sub

#End Region

#Region " Public Properties "

    Public Property FiltersDataSource() As DataTable
        Get
            If mFiltersDataSource Is Nothing Then
                CreateComboItems()
            End If

            Return mFiltersDataSource
        End Get
        Set(ByVal value As DataTable)
            mFiltersDataSource = value
        End Set
    End Property

    Public Property TreeContextMenu() As ContextMenu
        Get
            Return mPackageTree.ContextMenu
        End Get
        Set(ByVal value As ContextMenu)
            mPackageTree.ContextMenu = value
        End Set
    End Property

    Public Property AllowMultiSelect() As Boolean
        Get
            Return mPackageTree.AllowMultiSelect
        End Get
        Set(ByVal value As Boolean)
            mPackageTree.AllowMultiSelect = value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property SelectedPackageFilter() As PackageFilterTypes
        Get
            Dim selectedrow As DataRow = FiltersDataSource.Rows(cboPackageFilter.SelectedIndex)
            Return CType(selectedrow("Value"), PackageFilterTypes)
        End Get
    End Property

    Public ReadOnly Property SelectedPackageId() As Integer
        Get
            Return mSelectedPackageId
        End Get
    End Property

    Public ReadOnly Property SelectedNode() As PackageNode
        Get
            Return mPackageTree.SelectedNode
        End Get
    End Property

    Public ReadOnly Property SelectedNodes() As ArrayList
        Get
            Return mPackageTree.SelectedNodes
        End Get
    End Property

#End Region

#Region " Constructors "

    Sub New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call.
        mPackageTree = New ClientTreeView(ClientTreeTypes.AllStudiesAndPackages)
        mPackageTree.Dock = DockStyle.Fill
        tlpNavigator.Controls.Add(mPackageTree)
        cboPackageFilter.SelectedIndex = PackageFilterTypes.Active

    End Sub

#End Region

#Region " Events "

    Private Sub mPackageTree_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles mPackageTree.AfterSelect

        If e.Action = TreeViewAction.ByKeyboard OrElse e.Action = TreeViewAction.ByMouse Then
            OnSelectedNodeChanged(New SelectedNodeChangedEventArgs(TryCast(e.Node, PackageNode)))
        End If

    End Sub

    Private Sub PackageTree_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles mPackageTree.DoubleClick

        If Not SelectedPackageFilter = PackageFilterTypes.Deleted Then
            SelectPackage(mPackageTree.SelectedNode)
        End If

    End Sub

    Private Sub PackageTree_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles mPackageTree.KeyDown

        Select Case e.KeyCode
            Case Keys.Enter
                SelectPackage(mPackageTree.SelectedNode)
                e.Handled = True
        End Select

    End Sub

    Private Sub cboPackageFilter_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboPackageFilter.SelectedIndexChanged

        RefreshTree()
        RaiseEvent PackageFilterChanged(Me, New System.EventArgs)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub RefreshTree()

        mPackageTree.RefreshTree(SelectedPackageFilter)

    End Sub

    Public Sub RefreshTree(ByVal treeType As ClientTreeTypes)

        mPackageTree.RefreshTree(treeType, SelectedPackageFilter)

    End Sub

    Public Sub SelectNode(ByVal nodeId As String, ByVal parentId As String)

        mPackageTree.SelectNode(nodeId, parentId)

    End Sub

    Public Sub SelectPackage()

        SelectPackage(mPackageTree.SelectedNode)

    End Sub

#End Region

#Region " Private Methods "

    Private Sub SelectPackage(ByVal node As PackageNode)

        If node IsNot Nothing AndAlso node.PackageID > 0 Then
            Dim oldPackageId As Integer = mSelectedPackageId
            Dim newPackageID As Integer = node.PackageID
            Dim e As New SelectedPackageChangingEventArgs(oldPackageId, newPackageID)

            OnSelectedPackageChanging(e)

            If Not e.Cancel Then
                mSelectedPackageId = newPackageID
                OnSelectedPackageChanged(New SelectedPackageChangedEventArgs(oldPackageId, newPackageID))
            End If
        End If

    End Sub

    Private Sub CreateComboItems()

        mFiltersDataSource = New DataTable("ComboItems")
        mFiltersDataSource.Columns.Add(New DataColumn("Name", GetType(String)))
        mFiltersDataSource.Columns.Add(New DataColumn("Value", GetType(PackageFilterTypes)))
        mFiltersDataSource.Rows.Add("Active", PackageFilterTypes.Active)
        mFiltersDataSource.Rows.Add("Inactive", PackageFilterTypes.Inactive)
        mFiltersDataSource.Rows.Add("Active\Inactive", PackageFilterTypes.All)

        cboPackageFilter.ComboBox.DataSource = mFiltersDataSource
        cboPackageFilter.ComboBox.DisplayMember = "Name"
        cboPackageFilter.ComboBox.ValueMember = "Value"

    End Sub

#End Region

End Class
