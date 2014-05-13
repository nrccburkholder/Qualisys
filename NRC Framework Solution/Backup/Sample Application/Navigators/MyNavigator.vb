Public Class MyNavigator

    Public Event TreeSelected As EventHandler(Of NotificationEventArgs)
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Private Sub TreeView1_AfterSelect(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles TreeView1.AfterSelect
        Dim nodeValue As String = TryCast(e.Node.Tag, System.String)
        If Not nodeValue Is Nothing AndAlso nodeValue.Length > 0 Then
            RaiseEvent TreeSelected(Me, New NotificationEventArgs(nodeValue))
        End If
    End Sub
End Class
