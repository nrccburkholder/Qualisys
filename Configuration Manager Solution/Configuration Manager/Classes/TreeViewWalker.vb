Public Class TreeViewWalker

#Region "Event Handler"

    Public Delegate Sub ProcessNodeEventHandler(ByVal sender As Object, ByVal e As ProcessNodeEventArgs)

#End Region

#Region "private members"

    Private mTreeView As TreeView
    Private stopProcessing As Boolean = False

#End Region

#Region "Public Properties"

    Public Property TreeView As TreeView
        Get
            Return mTreeView
        End Get
        Set(value As TreeView)
            mTreeView = value
        End Set
    End Property

#End Region

#Region "constructors"

    Public Sub New()

    End Sub

    Public Sub New(ByVal treeView As TreeView)

        mTreeView = treeView

    End Sub


#End Region


#Region "Public Events"

    Public Event ProcessNode As ProcessNodeEventHandler

#End Region


#Region "Public methods"

    Public Sub ProcessBranch(ByVal rootNode As TreeNode)

        If rootNode Is Nothing Then
            Throw New ArgumentNullException("rootNode")
        End If

        'Reset the abort flag in case it was previously set.
        Me.stopProcessing = False

        Me.WalkNodes(rootNode)

    End Sub

    Public Sub ProcessTree()

        If TreeView Is Nothing Then
            Throw New InvalidOperationException("The TreeViewWalker must reference a TreeView when ProcessTree is called.")
        End If

        For Each node As TreeNode In TreeView.Nodes
            ProcessBranch(node)
            If stopProcessing Then
                Exit For
            End If
        Next

    End Sub


#End Region

#Region "Protected Methods"

    Protected Overridable Sub OnProcessNode(ByVal e As ProcessNodeEventArgs)

        RaiseEvent ProcessNode(Me, e)

    End Sub

#End Region


#Region "Private methods"

    Private Function WalkNodes(ByVal node As TreeNode) As Boolean

        ' Fire the ProcessNode event
        Dim args As ProcessNodeEventArgs = ProcessNodeEventArgs.CreateInstance(node)
        OnProcessNode(args)

        'cache the value of the ProcessSibling since ProcessNodeEventArgs is a singleton
        Dim processSiblings As Boolean = args.ProcessSiblings

        If args.StopProcessing Then
            stopProcessing = True
        ElseIf args.ProcessDescendants Then
            For i As Integer = 0 To node.Nodes.Count - 1
                If Not WalkNodes(node.Nodes(i)) Or stopProcessing Then
                    Exit For
                End If
            Next
        End If

        Return processSiblings

    End Function


#End Region

End Class

Public Class ProcessNodeEventArgs
    Inherits EventArgs

    Private Shared instance As ProcessNodeEventArgs

    Private tnode As TreeNode
    Private tprocessDescendants As Boolean
    Private tprocessSiblings As Boolean
    Private tstopProcessing As Boolean


#Region "private constructor"

    Private Sub New()

    End Sub

#End Region

#Region "Create Instance"

    Friend Shared Function CreateInstance(ByVal node As TreeNode) As ProcessNodeEventArgs

        If ProcessNodeEventArgs.instance Is Nothing Then
            ProcessNodeEventArgs.instance = New ProcessNodeEventArgs()
        End If

        ProcessNodeEventArgs.instance.Node = node
        ProcessNodeEventArgs.instance.processDescendants = True
        ProcessNodeEventArgs.instance.processSiblings = True
        ProcessNodeEventArgs.instance.stopProcessing = False

        Return ProcessNodeEventArgs.instance

    End Function

#End Region

#Region "Properties"

    Public Property Node() As TreeNode
        Get
            Return Me.tnode
        End Get
        Set(value As TreeNode)
            Me.tnode = value
        End Set
    End Property

    Public Property ProcessDescendants() As Boolean
        Get
            Return tprocessDescendants
        End Get
        Set(value As Boolean)
            tprocessDescendants = value
        End Set
    End Property


    Public Property ProcessSiblings() As Boolean
        Get
            Return tprocessSiblings
        End Get
        Set(value As Boolean)
            tprocessSiblings = value
        End Set
    End Property

    Public Property StopProcessing() As Boolean
        Get
            Return tstopProcessing
        End Get
        Set(value As Boolean)
            tstopProcessing = value
        End Set
    End Property

#End Region



End Class