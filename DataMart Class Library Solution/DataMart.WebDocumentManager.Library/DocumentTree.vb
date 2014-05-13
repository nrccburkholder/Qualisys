Public Class DocumentTree

    Private mNodes As New DocumentNodeCollection

    Public ReadOnly Property Nodes() As DocumentNodeCollection
        Get
            Return mNodes
        End Get
    End Property

    Public Shared Function GetDocumentTree(ByVal groupId As Integer, ByVal memberId As Integer, ByVal showOnlyPosted As Boolean) As DocumentTree
        Dim tree As New DocumentTree
        Dim ds As DataSet = DAL.SelectDocumentTree(groupId, memberId, showOnlyPosted)
        ds.Relations.Add("ParentNodeChildNode", ds.Tables(0).Columns("Node_id"), ds.Tables(0).Columns("ParentNode_id"))
        ds.Relations.Add("NodeDocument", ds.Tables(0).Columns("Node_id"), ds.Tables(1).Columns("Node_id"))

        Dim node As DocumentNode
        For Each row As DataRow In ds.Tables(0).Select("ParentNode_id IS NULL")
            node = GetNode(row)
            tree.Nodes.Add(node)
        Next

        Return tree
    End Function

    Public Shared Function GetApbDocumentTree(ByVal groupId As Integer, ByVal memberId As Integer, ByVal periodNum As Integer) As DocumentTree
        Dim tree As New DocumentTree
        Dim ds As DataSet = DAL.SelectApbDocumentTree(groupId, memberId, periodNum)
        ds.Relations.Add("ParentNodeChildNode", ds.Tables(0).Columns("Node_id"), ds.Tables(0).Columns("ParentNode_id"))
        ds.Relations.Add("NodeDocument", ds.Tables(0).Columns("Node_id"), ds.Tables(1).Columns("Node_id"))

        Dim node As DocumentNode
        For Each row As DataRow In ds.Tables(0).Select("ParentNode_id IS NULL")
            node = GetNode(row)
            tree.Nodes.Add(node)
        Next

        Return tree
    End Function

    Private Shared Function GetNode(ByVal row As DataRow) As DocumentNode
        Dim node As DocumentNode = DocumentNode.GetNodeFromDataRow(row)

        For Each childRow As DataRow In row.GetChildRows("ParentNodeChildNode")
            node.Nodes.Add(GetNode(childRow))
        Next

        For Each docRow As DataRow In row.GetChildRows("NodeDocument")
            node.Documents.Add(Document.GetDocumentFromRow(docRow))
        Next

        Return node
    End Function
End Class
