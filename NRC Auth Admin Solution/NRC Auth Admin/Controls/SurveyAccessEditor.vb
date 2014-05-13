Imports NRC.NRCAuthLib

Public MustInherit Class SurveyAccessEditor

#Region " Private Fields/Properties/Enums "
    Private mSelectedNodeCount As Integer
#End Region

#Region " Private Properties "
    Private Property SelectedNodeCount() As Integer
        Get
            Return mSelectedNodeCount
        End Get
        Set(ByVal value As Integer)
            mSelectedNodeCount = value
            Me.SelectedNodesLabel.Text = mSelectedNodeCount & " item(s) are selected"
        End Set
    End Property
#End Region

#Region " Public Methods "
    Public Sub SaveChanges()
        Dim grantedNodes As New DataMartPrivilegeTree.DataMartPrivilegeNodeCollection

        Me.GetGrantedNodes(Me.TreeView.Nodes, grantedNodes)

        'Call the derived class's Save method
        Me.SaveChanges(grantedNodes)
    End Sub

#End Region

#Region " Private Methods "

    Protected Sub PopulatePrivilegeTree(ByVal privilegeTree As DataMartPrivilegeTree)
        Dim node As TreeNode

        Me.TreeView.BeginUpdate()
        Me.TreeView.Nodes.Clear()
        For Each root As DataMartPrivilegeTree.DataMartPrivilegeNode In privilegeTree.Nodes
            node = GetNode(root)
            Me.TreeView.Nodes.Add(node)
        Next
        Me.TreeView.EndUpdate()
    End Sub

    Private Function GetNode(ByVal root As DataMartPrivilegeTree.DataMartPrivilegeNode) As TreeNode
        Dim rootNode As New TreeNode

        rootNode.Text = root.Label
        rootNode.Tag = root
        rootNode.Checked = root.IsGranted
        If rootNode.Checked Then
            Me.SelectedNodeCount += 1
        End If

        Dim childNode As TreeNode

        For Each child As DataMartPrivilegeTree.DataMartPrivilegeNode In root.Nodes
            childNode = GetNode(child)
            If childNode.Checked OrElse childNode.IsExpanded Then
                rootNode.Expand()
            End If
            rootNode.Nodes.Add(childNode)
        Next

        Return rootNode
    End Function

    Private Sub GetGrantedNodes(ByVal nodes As TreeNodeCollection, ByVal grantedNodes As DataMartPrivilegeTree.DataMartPrivilegeNodeCollection)
        Dim dmNode As DataMartPrivilegeTree.DataMartPrivilegeNode

        'For every tree node in the collection
        For Each node As TreeNode In nodes

            'If the node is checked then...
            If node.Checked Then
                'Try to get the DataMartPrivilegeNode from the tag
                dmNode = TryCast(node.Tag, DataMartPrivilegeTree.DataMartPrivilegeNode)

                If dmNode IsNot Nothing Then
                    'Add the node to the granted list
                    grantedNodes.Add(dmNode)
                End If

            End If

            'Now get changes for all children
            GetGrantedNodes(node.Nodes, grantedNodes)
        Next
    End Sub

#End Region

    Protected MustOverride Sub SaveChanges(ByVal grantedNodes As DataMartPrivilegeTree.DataMartPrivilegeNodeCollection)

    Private Sub TreeView_AfterCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles TreeView.AfterCheck
        If e.Node.Checked Then
            Me.SelectedNodeCount += 1
        Else
            Me.SelectedNodeCount -= 1
        End If
    End Sub
End Class
