Public Class SelectedNodeChangedEventArgs
    Inherits EventArgs

#Region " Private Members "

    Private mNode As TreeNode

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property Node() As TreeNode
        Get
            Return mNode
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal node As TreeNode)

        mNode = node

    End Sub

#End Region

End Class
