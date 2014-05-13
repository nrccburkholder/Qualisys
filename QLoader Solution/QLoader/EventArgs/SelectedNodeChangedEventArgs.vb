Public Class SelectedNodeChangedEventArgs
    Inherits EventArgs

    Private mSelectedNode As PackageNode

    Public ReadOnly Property SelectedNode() As PackageNode
        Get
            Return mSelectedNode
        End Get
    End Property

    Public Sub New(ByVal selectedNode As PackageNode)

        mSelectedNode = selectedNode

    End Sub

End Class
