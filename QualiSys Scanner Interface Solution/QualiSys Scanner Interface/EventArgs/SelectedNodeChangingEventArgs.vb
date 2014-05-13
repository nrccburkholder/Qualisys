Public Class SelectedNodeChangingEventArgs
    Inherits EventArgs

#Region " Private Members "

    Private mPreviousNode As TreeNode
    Private mSelectedNode As TreeNode
    Private mCancel As Boolean

#End Region

#Region " Public Properties "

    Public Property Cancel() As Boolean
        Get
            Return mCancel
        End Get
        Set(ByVal value As Boolean)
            mCancel = value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property PreviousNode() As TreeNode
        Get
            Return mPreviousNode
        End Get
    End Property

    Public ReadOnly Property SelectedNode() As TreeNode
        Get
            Return mSelectedNode
        End Get
    End Property
#End Region

#Region " Constructors "

    Public Sub New(ByVal prevNode As TreeNode, ByVal selNode As TreeNode)

        mPreviousNode = prevNode
        mSelectedNode = selNode

    End Sub

#End Region

End Class
