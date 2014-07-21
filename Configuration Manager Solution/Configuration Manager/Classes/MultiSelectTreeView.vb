Imports System.ComponentModel

Public Class MultiSelectTreeView
    Inherits System.Windows.Forms.TreeView

#Region " Private Members "
    Private mSelectedNodes As List(Of TreeNode)
    Private mSelectionMode As SelectionMode = Windows.Forms.SelectionMode.One
    Private mFirstSelection As TreeNode
#End Region

#Region " Constructors "
    Public Sub New()
        mSelectedNodes = New List(Of TreeNode)
    End Sub

#End Region

#Region " Properties "
    <Category("Behavior")> _
    Public Property SelectionMode() As SelectionMode
        Get
            Return Me.mSelectionMode
        End Get
        Set(ByVal value As SelectionMode)
            Me.mSelectionMode = value
        End Set
    End Property

    <Browsable(False)> _
    Public ReadOnly Property SelectedNodes() As List(Of TreeNode)
        Get
            Return mSelectedNodes
        End Get
    End Property
#End Region

    Public Event SelectionChanged As EventHandler

#Region " Base Class Overrides "
    Protected Overrides Sub OnKeyUp(ByVal e As System.Windows.Forms.KeyEventArgs)
        MyBase.OnKeyUp(e)

        If Me.mSelectionMode = Windows.Forms.SelectionMode.MultiExtended Then
            Dim isCtrlPressed As Boolean = e.Control
            Dim isAPressed As Boolean = ((e.KeyData And Keys.A) = Keys.A)
            If isCtrlPressed And isAPressed Then
                Me.SelectAllNodes()
                Me.OnSelectionChange(EventArgs.Empty)
            End If
        End If
    End Sub
    Protected Overrides Sub OnBeforeSelect(ByVal e As System.Windows.Forms.TreeViewCancelEventArgs)
        MyBase.OnBeforeSelect(e)

        If e.Cancel = True Then
            Exit Sub
        End If
        If Me.mSelectionMode = Windows.Forms.SelectionMode.None Then
            e.Cancel = True
            Exit Sub
        End If

        If e.Action = TreeViewAction.ByKeyboard OrElse e.Action = TreeViewAction.ByMouse Then
            Dim allowCtrl As Boolean = (Me.mSelectionMode = SelectionMode.MultiSimple OrElse Me.mSelectionMode = SelectionMode.MultiExtended)
            Dim allowShift As Boolean = Me.mSelectionMode = SelectionMode.MultiExtended
            Dim isCtrlPressed As Boolean = (ModifierKeys = Keys.Control)
            Dim isShiftPressed As Boolean = (ModifierKeys = Keys.Shift)

            If allowCtrl AndAlso isCtrlPressed Then
                If Me.mSelectedNodes.Contains(e.Node) Then
                    Me.DeselectNode(e.Node)
                    Me.OnSelectionChange(EventArgs.Empty)
                    e.Cancel = True
                Else
                    Me.SelectNode(e.Node)
                    Me.OnSelectionChange(EventArgs.Empty)
                End If
                Me.mFirstSelection = e.Node
            ElseIf allowShift AndAlso isShiftPressed AndAlso Me.mFirstSelection IsNot Nothing Then
                Me.DeselectAllSelectedNodes()
                If Me.DoesNodeComeFirst(Me.mFirstSelection, e.Node) Then
                    Me.SelectNodesBetween(Me.mFirstSelection, e.Node)
                Else
                    Me.SelectNodesBetween(e.Node, Me.mFirstSelection)
                End If
                Me.OnSelectionChange(EventArgs.Empty)
            Else
                Me.DeselectAllSelectedNodes()
                Me.SelectNode(e.Node)
                Me.mFirstSelection = e.Node
                Me.OnSelectionChange(EventArgs.Empty)
            End If
        End If
    End Sub

    ''' <summary>
    ''' When a user clicks we need to check to see if they are clicking on the selected node
    ''' if so, then we will select a different node so that the normal BeforeSelect event will
    ''' still fire and handle everything the way we want
    ''' </summary>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Overrides Sub OnMouseClick(ByVal e As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseClick(e)

        'If it is a left click
        If e.Button = Windows.Forms.MouseButtons.Left Then
            Dim allowMultiSelect As Boolean = (Me.mSelectionMode = SelectionMode.MultiSimple OrElse Me.mSelectionMode = SelectionMode.MultiExtended)

            'If we allow multi select
            If allowMultiSelect Then
                'Try and get the node clickded
                Dim clickedNode As TreeNode = Me.GetNodeAt(e.Location)
                'If a node was clicked and it was the selected node
                If clickedNode IsNot Nothing AndAlso Me.SelectedNode Is clickedNode Then
                    'Then if there are other nodes selected (other than the one clicked)
                    If Me.mSelectedNodes.Count > 1 Then
                        'Select the next to last selected node
                        Me.SelectedNode = Me.mSelectedNodes(Me.mSelectedNodes.Count - 2)
                    Else
                        'Select nothing
                        Me.SelectedNode = Nothing
                    End If
                End If
            End If
        End If
    End Sub

    Protected Overrides Sub OnLostFocus(ByVal e As System.EventArgs)
        MyBase.OnLostFocus(e)

        If Me.HideSelection Then
            For Each node As TreeNode In Me.mSelectedNodes
                node.BackColor = Me.BackColor
                node.ForeColor = Me.ForeColor
            Next
        Else
            For Each node As TreeNode In Me.mSelectedNodes
                node.BackColor = SystemColors.InactiveCaption
                node.ForeColor = SystemColors.InactiveCaptionText
            Next
        End If
    End Sub

    Protected Overrides Sub OnGotFocus(ByVal e As System.EventArgs)
        MyBase.OnGotFocus(e)
        For Each node As TreeNode In Me.mSelectedNodes
            node.BackColor = SystemColors.Highlight
            node.ForeColor = SystemColors.HighlightText
        Next
    End Sub

#End Region

#Region " Protected Methods "
    Protected Overridable Sub OnSelectionChange(ByVal e As EventArgs)
        RaiseEvent SelectionChanged(Me, e)
    End Sub
#End Region

#Region " Private Methods "
    ''' <summary>Selects a single node</summary>
    ''' <param name="node">The node to select</param>
    Private Sub SelectNode(ByVal node As TreeNode)
        Me.mSelectedNodes.Add(node)
        node.BackColor = SystemColors.Highlight
        node.ForeColor = SystemColors.HighlightText
    End Sub
    ''' <summary>Deselects a single node</summary>
    ''' <param name="node">The node to deselect</param>
    Private Sub DeselectNode(ByVal node As TreeNode)
        If Me.mSelectedNodes.Contains(node) Then
            Me.mSelectedNodes.Remove(node)
            node.BackColor = Me.BackColor
            node.ForeColor = Me.ForeColor
        End If
    End Sub

    ''' <summary>Deselects any nodes that are selected</summary>
    Private Sub DeselectAllSelectedNodes()
        Dim deselectList As New List(Of TreeNode)

        For Each node As TreeNode In Me.mSelectedNodes
            deselectList.Add(node)
        Next

        For Each node As TreeNode In deselectList
            Me.DeselectNode(node)
        Next
    End Sub

    ''' <summary>Selects all the nodes in the tree</summary>
    Private Sub SelectAllNodes()
        Me.DeselectAllSelectedNodes()
        For Each node As TreeNode In Me.Nodes
            Me.SelectEntireNode(node)
        Next
    End Sub

    ''' <summary>Selects a node and all of its children</summary>
    ''' <param name="node">The node to select</param>
    Private Sub SelectEntireNode(ByVal node As TreeNode)
        Me.SelectNode(node)
        For Each childNode As TreeNode In node.Nodes
            SelectEntireNode(childNode)
        Next
    End Sub

    ''' <summary>Returns a list of nodes in a node path</summary>
    Private Function GetNodePath(ByVal node As TreeNode) As List(Of TreeNode)
        Dim path As New List(Of TreeNode)
        While node IsNot Nothing
            path.Insert(0, node)
            node = node.Parent
        End While

        Return path
    End Function

    ''' <summary>Finds the common ancestor node of two nodes or returns NULL if they are both root nodes</summary>
    Private Function FindCommonRoot(ByVal nodeA As TreeNode, ByVal nodeB As TreeNode) As TreeNode
        Dim root As TreeNode = Nothing

        'Get the path lists of the two nodes
        Dim pathA As List(Of TreeNode) = Me.GetNodePath(nodeA)
        Dim pathB As List(Of TreeNode) = Me.GetNodePath(nodeB)

        'Compare the paths and find the lowest common root
        Dim i As Integer = 0
        While i < pathA.Count AndAlso i < pathB.Count AndAlso pathA(i) Is pathB(i)
            root = pathA(i)
            i += 1
        End While

        Return root
    End Function

    ''' <summary>Determines if a node comes before another in a presort tree traversal</summary>
    ''' <returns>Returns True, if firstNode in fact comes before secondNode</returns>
    Private Function DoesNodeComeFirst(ByVal firstNode As TreeNode, ByVal secondNode As TreeNode) As Boolean
        Dim commonRoot As TreeNode = Me.FindCommonRoot(firstNode, secondNode)
        If commonRoot IsNot Nothing Then

            'If either node is the common root than it must be first
            If commonRoot Is firstNode Then
                Return True
            ElseIf commonRoot Is secondNode Then
                Return False
            End If

            'traverse both nodes paths until they are siblings
            While firstNode.Level > (commonRoot.Level + 1)
                firstNode = firstNode.Parent
            End While
            While secondNode.Level > (commonRoot.Level + 1)
                secondNode = secondNode.Parent
            End While

        Else
            'traverse both nodes paths until they are siblings which is at highest ancestor
            While firstNode.Level > 0
                firstNode = firstNode.Parent
            End While
            While secondNode.Level > 0
                secondNode = secondNode.Parent
            End While
        End If



        'At this point we are guaranteed that first and second are siblings
        While firstNode IsNot Nothing
            If firstNode.PrevNode Is secondNode Then
                'The first node does not come before the second node
                Return False
            Else
                firstNode = firstNode.PrevNode
            End If
        End While

        'We could not find the second node before the first
        Return True
    End Function

    ''' <summary>Selects all the nodes between two nodes</summary>
    Private Sub SelectNodesBetween(ByVal startNode As TreeNode, ByVal endNode As TreeNode)
        'Traverse the tree selecting each node until we have reached the end node
        While startNode IsNot endNode
            If startNode Is Nothing Then
                Throw New Exception("Tree traversal has unexpectedly ended.")
            End If
            'Select the node
            Me.SelectNode(startNode)

            'Move the the next node in the traversal
            startNode = Me.GetNextNode(startNode)
        End While

        'Finally, select the end node
        Me.SelectNode(endNode)
    End Sub

    ''' <summary>
    ''' This function will return the next node in a tree preorder traversal
    ''' </summary>
    ''' <param name="node">The current node in the traversal</param>
    ''' <param name="ignoreChildren">If True, the nodes children will be ignored</param>
    ''' <returns>Returns the next node in the traversal or NULL if there are no more nodes</returns>
    Private Function GetNextNode(ByVal node As TreeNode, ByVal ignoreChildren As Boolean) As TreeNode
        If Not ignoreChildren AndAlso node.Nodes.Count > 0 Then
            Return node.FirstNode
        ElseIf node.NextNode IsNot Nothing Then
            Return node.NextNode
        ElseIf node.Parent IsNot Nothing Then
            Return GetNextNode(node.Parent, True)
        End If

        Return Nothing
    End Function

    ''' <param name="node">The current node in the traversal</param>
    ''' <returns>Returns the next node in the traversal or NULL if there are no more nodes</returns>
    Private Function GetNextNode(ByVal node As TreeNode) As TreeNode
        Return GetNextNode(node, False)
    End Function
#End Region


#Region "Public Methods"
    Public Sub ClearSelections()
        Me.SelectedNode = Nothing
        Me.DeselectAllSelectedNodes()
    End Sub
#End Region
End Class