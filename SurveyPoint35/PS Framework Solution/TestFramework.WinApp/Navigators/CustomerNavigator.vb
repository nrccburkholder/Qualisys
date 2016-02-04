Imports TestFramework.Library
Public Class CustomerNavigator
    Dim mCustomers As Customers = Nothing
    Public Event CustomerSelected As EventHandler(Of CustomerSelectedEventArgs)

    Private Sub CustomerNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'mCustomers = Customer.GetCustomers()
        'tv1.Nodes.Clear()
        'For Each item As Customer In mCustomers
        '    Dim tn As New TreeNode(item.ContactName)
        '    tn.Tag = item
        '    tv1.Nodes.Add(tn)
        'Next
    End Sub

    Private Sub tv1_NodeMouseClick(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeNodeMouseClickEventArgs) Handles tv1.NodeMouseClick
        'If e.Node IsNot Nothing Then
        '    Dim cust As Customer = TryCast(e.Node.Tag, Customer)
        '    If cust IsNot Nothing Then
        '        RaiseEvent CustomerSelected(Me, New CustomerSelectedEventArgs(cust.CustomerID))
        '    End If
        'End If
    End Sub
End Class
