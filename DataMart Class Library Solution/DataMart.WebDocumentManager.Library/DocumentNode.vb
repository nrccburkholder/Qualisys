Public Class DocumentNode

#Region "Private Members"
    Private mOrgUnitId As Integer
    Private mNodeId As Integer
    Private mName As String
    Private mGroupId As Integer
    Private mGroupName As String
    Private mIsExpanded As Boolean
    Private mOrder As Integer
    Private mDateOccurred As DateTime
    Private mTreePath As String = ""
    Private mParentNodeId As Integer
    Private mViewed As Boolean

    Private mDocuments As New DocumentCollection
    Private mNodes As New DocumentNodeCollection
#End Region

#Region "Public Properties"
    Public Property OrgUnitId() As Integer
        Get
            Return mOrgUnitId
        End Get
        Set(ByVal Value As Integer)
            mOrgUnitId = Value
        End Set
    End Property

    Public Property NodeId() As Integer
        Get
            Return mNodeId
        End Get
        Set(ByVal Value As Integer)
            mNodeId = Value
        End Set
    End Property

    Public Property GroupId() As Integer
        Get
            Return mGroupId
        End Get
        Set(ByVal Value As Integer)
            mGroupId = Value
        End Set
    End Property

    Public Property GroupName() As String
        Get
            Return mGroupName
        End Get
        Set(ByVal Value As String)
            mGroupName = Value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal Value As String)
            mName = Value
        End Set
    End Property

    Public Property Expanded() As Boolean
        Get
            Return mIsExpanded
        End Get
        Set(ByVal Value As Boolean)
            mIsExpanded = Value
        End Set
    End Property

    Public Property Order() As Integer
        Get
            Return mOrder
        End Get
        Set(ByVal Value As Integer)
            mOrder = Value
        End Set
    End Property

    Public Property DateofOccurrence() As DateTime
        Get
            Return mDateOccurred
        End Get
        Set(ByVal Value As DateTime)
            mDateOccurred = Value
        End Set
    End Property

    Public ReadOnly Property TreePath() As String
        Get
            Return mTreePath
        End Get
    End Property

    Public ReadOnly Property ParentNodeId() As Integer
        Get
            Return mParentNodeId
        End Get
    End Property

    Public ReadOnly Property Viewed() As Boolean
        Get
            Return mViewed
        End Get
    End Property

    Public ReadOnly Property Documents() As DocumentCollection
        Get
            Return mDocuments
        End Get
    End Property

    Public ReadOnly Property Nodes() As DocumentNodeCollection
        Get
            Return mNodes
        End Get
    End Property

#End Region

    Public Shared Function GetNode(ByVal nodeId As Integer) As DocumentNode
        Dim row As DataRow = DAL.SelectNode(nodeId)
        Return GetNodeFromDataRow(row)
    End Function


    Public Shared Function GetGroupRootNodeID(ByVal groupId As Integer) As Integer
        Return DAL.SelectGroupRootNodeID(groupId)
    End Function

    Friend Shared Function GetNodeFromDataRow(ByVal row As DataRow) As DocumentNode

        Dim node As New DocumentNode

        node.mOrgUnitId = CInt(row("OrgUnit_id"))
        node.mNodeId = CInt(row("Node_id"))
        node.mName = row("strNode_nm").ToString
        node.mGroupId = CInt(row("Group_id"))
        node.mGroupName = row("strGroup_Nm").ToString
        node.mDateOccurred = CDate(row("datOccurred"))
        node.mViewed = Not CBool(row("DocumentNotViewed"))

        If Not row.IsNull("intOrder") Then
            node.mOrder = CInt(row("intOrder"))
        End If

        If Not row.IsNull("bitExpanded") Then
            node.mIsExpanded = CBool(row("bitExpanded"))
        End If

        If Not row.IsNull("strPath") Then
            node.mTreePath = CStr(row("strPath"))
        End If

        If Not row.IsNull("ParentNode_id") Then
            node.mParentNodeId = CInt(row("ParentNode_id"))
        Else
            node.mParentNodeId = -1
        End If

        Return node

    End Function

    Public Shared Function CreateNode(ByVal groupId As Integer, _
                                      ByVal parentNodeId As Integer, _
                                      ByVal nodeName As String, _
                                      ByVal order As Integer, _
                                      ByVal authorMemberId As Integer, _
                                      Optional ByVal expanded As Boolean = False _
                                     ) As DocumentNode

        'Create the node
        Dim nodeId As Integer = DAL.InsertNode(groupId, parentNodeId, nodeName, expanded, order, authorMemberId)

        'Return the new node object
        Return GetNode(nodeId)

    End Function

    Public Sub UpdateNode(ByVal authorMemberId As Integer)

        DAL.UpdateNode(mNodeId, mGroupId, mParentNodeId, mName, mIsExpanded, mOrder, authorMemberId)

    End Sub

    Public Shared Function UpdateNode(ByVal nodeId As Integer, _
                                      ByVal groupId As Integer, _
                                      ByVal parentNodeId As Integer, _
                                      ByVal nodeName As String, _
                                      ByVal expanded As Boolean, _
                                      ByVal order As Integer, _
                                      ByVal authorMemberId As Integer _
                                     ) As DocumentNode

        'Update the node
        DAL.UpdateNode(nodeId, groupId, parentNodeId, nodeName, expanded, order, authorMemberId)

        'Return a reference to the updated node
        Return GetNode(nodeId)

    End Function

    Public Sub DeleteNode(ByVal authorMemberId As Integer)

        DeleteNode(mNodeId, authorMemberId)

    End Sub

    Public Shared Sub DeleteNode(ByVal nodeId As Integer, ByVal authorMemberId As Integer)

        DAL.DeleteNode(nodeId, authorMemberId)
        DAL.DeleteNodeInApb(nodeId)

    End Sub

    Public Shared Function InsertMissingNodes(ByVal startNodeId As Integer, _
                              ByVal subNodePath As String, _
                              ByVal authorMemberId As Integer) As Integer
        Dim nodeID As Integer

        nodeID = DAL.InsertMissingNodes(startNodeId, subNodePath, authorMemberId)
        Return nodeID
    End Function

End Class
