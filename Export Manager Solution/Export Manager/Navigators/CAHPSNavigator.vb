Imports Nrc.DataMart.Library

Public Class CAHPSNavigator

    Public Event ExportSetTypeSelectionChanged As EventHandler(Of ExportSetTypeSelectionChangedEventArgs)
    Public Event SelectedNodeChanging As EventHandler(Of SelectedNodeChangingEventArgs)


    Private Sub CAHPSNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim node As TreeNode = New TreeNode("Home Health CAHPS")
        node.Tag = ExportSetType.CmsHHcahps
        CAHPSTreeView.Nodes.Add(node)
        CAHPSTreeView.SelectedNode = node

        node = New TreeNode("OCS")
        node.Tag = ExportSetType.OCSClient
        CAHPSTreeView.Nodes.Add(node)

        'node = New TreeNode("Health CAHPS")
        'node.Tag = ExportSetType.CmsHcahps
        'CAHPSTreeView.Nodes.Add(node)

        'node = New TreeNode("CHART")
        'node.Tag = ExportSetType.CmsChart
        'CAHPSTreeView.Nodes.Add(node)


    End Sub

    Private Sub CAHPSTreeView_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles CAHPSTreeView.BeforeSelect

        'Create the event arguement object
        Dim eventArgs As New SelectedNodeChangingEventArgs(CAHPSTreeView.SelectedNode, e.Node)

        'Raise the event
        RaiseEvent SelectedNodeChanging(Me, eventArgs)

        'Determine next step
        e.Cancel = eventArgs.Cancel

    End Sub

    Private Sub CAHPSTreeView_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles CAHPSTreeView.AfterSelect

        'Get a reference to the existing node
        Dim changingArgs As New ExportSetTypeSelectionChangedEventArgs(CType(e.Node.Tag, ExportSetType))

        'Raise the event
        RaiseEvent ExportSetTypeSelectionChanged(Me, changingArgs)

    End Sub

End Class
