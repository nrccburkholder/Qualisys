Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library

Public Class VendorMaintenanceNavigator

    Public Event SelectedNodeChanging As EventHandler(Of SelectedNodeChangingEventArgs)
    Public Event VendorChanged As EventHandler(Of VendorChangedEventArgs)


#Region " Public Methods "

    Public Sub PopulateTree()

        Dim vendorNode As TreeNode

        'Clear the tree
        VendorTreeView.Nodes.Clear()

        'Populate the tree
        Dim treeData As VendorCollection = Vendor.GetAll
        For Each item As Vendor In treeData
            'Add this node to the tree
            vendorNode = New TreeNode(String.Concat(item.VendorName, " [", item.VendorCode, "]"))
            vendorNode.ImageIndex = 0
            vendorNode.SelectedImageIndex = 0
            vendorNode.Tag = item.VendorId
            VendorTreeView.Nodes.Add(vendorNode)
        Next

    End Sub

    Private Sub VendorMaintenanceNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Populate the image list for the tree
        With VendorTreeImageList.Images
            .Add("Vendor", My.Resources.Member32)
        End With

        Me.PopulateTree()

    End Sub
#End Region

#Region "Events"

    Private Sub VendorTreeView_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles VendorTreeView.BeforeSelect

        'Create the event arguement object
        Dim eventArgs As New SelectedNodeChangingEventArgs(VendorTreeView.SelectedNode, e.Node)

        'Raise the event
        RaiseEvent SelectedNodeChanging(Me, eventArgs)

        'Determine next step
        e.Cancel = eventArgs.Cancel

    End Sub

    Private Sub VendorTreeView_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles VendorTreeView.AfterSelect

        'Get a reference to the existing node
        Dim vendorNode As Vendor = Vendor.Get(DirectCast(e.Node.Tag, Integer))

        'Raise the event
        RaiseEvent VendorChanged(Me, New VendorChangedEventArgs(vendorNode))

    End Sub

    Private Sub btnNewVendor_Click1(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNewVendor.Click

        'Get a reference empty vendor object
        Dim vendorNode As Vendor = Vendor.NewVendor
        vendorNode.DateCreated = Now
        vendorNode.AcceptFilesFromVendor = True

        'Raise the event
        RaiseEvent VendorChanged(Me, New VendorChangedEventArgs(vendorNode))

    End Sub
#End Region
End Class
