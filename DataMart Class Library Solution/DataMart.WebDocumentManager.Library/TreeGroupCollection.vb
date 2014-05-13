Public Class TreeGroupCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As TreeGroup
        Get
            Return DirectCast(MyBase.List(index), TreeGroup)
        End Get
    End Property

    Private Function Add(ByVal treeGrp As TreeGroup) As Integer

        Return MyBase.List.Add(treeGrp)

    End Function

    Public Shared Function GetTreeGroups() As TreeGroupCollection

        Dim treeGroups As New TreeGroupCollection
        Dim ds As DataSet = DAL.SelectTreeGroups()

        Dim treeGrp As TreeGroup
        For Each row As DataRow In ds.Tables(0).Rows
            treeGrp = TreeGroup.GetTreeGroupFromRow(row)
            treeGroups.Add(treeGrp)
        Next

        Return treeGroups

    End Function
End Class
