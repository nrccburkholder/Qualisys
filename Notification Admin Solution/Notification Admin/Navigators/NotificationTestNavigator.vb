Imports Nrc.NotificationAdmin.Library

Public Class NotificationTestNavigator
    Public Event NotificationNavigatorChanged As EventHandler(Of NotificationNavigatorChangedEventArgs)

    Private mTemplateCollection As TemplateCollection

    Private Sub NotificationTestNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        mTemplateCollection = Template.GetAll()
        Dim root As TreeNode = tvTemplates.Nodes.Add("Templates")
        root.Tag = 0    'Root node is not selectable.
        GetTreeNodes(root)
        root.Expand()

    End Sub

    Private Sub GetTreeNodes(ByVal rootNode As TreeNode)

        For Each template As Template In Me.mTemplateCollection
            Dim node As TreeNode = rootNode.Nodes.Add(template.Name)
            node.Tag = template.Id
        Next

    End Sub

    Private Sub NotificationTestNavigator_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles tvTemplates.AfterSelect

        If CInt(e.Node.Tag) > 0 Then
            RaiseEvent NotificationNavigatorChanged(Me, New NotificationNavigatorChangedEventArgs(e.Node.Name, CInt(e.Node.Tag)))
        End If

    End Sub
End Class
