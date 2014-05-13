Public Class TreeGroup

    Private mTreeGroupId As Integer
    Private mTreeGroupName As String
    Private mSortOrder As Integer

#Region " Public Properties "
    Public ReadOnly Property TreeGroupID() As Integer
        Get
            Return mTreeGroupId
        End Get
    End Property

    Public ReadOnly Property Name() As String
        Get
            Return mTreeGroupName
        End Get
    End Property

    Public ReadOnly Property SortOrder() As Integer
        Get
            Return mSortOrder
        End Get
    End Property
#End Region

    Public Shared Function GetTreeGroup(ByVal treeGroupId As Integer) As TreeGroup

        Dim row As DataRow = DAL.SelectTreeGroup(treeGroupId)
        Return GetTreeGroupFromRow(row)

    End Function

    Friend Shared Function GetTreeGroupFromRow(ByVal row As DataRow) As TreeGroup

        Dim treeGrp As New TreeGroup

        treeGrp.mTreeGroupId = CInt(row("TreeGroup_id"))
        treeGrp.mTreeGroupName = CStr(row("strTreeGroup_Nm"))
        treeGrp.mSortOrder = CInt(row("SortOrder"))

        Return treeGrp

    End Function

    Public Shared Function GetTreeGroupID(ByVal treeGroupName As String) As Integer
        For Each treGroup As TreeGroup In TreeGroupCollection.GetTreeGroups
            If treGroup.Name.ToUpper = treeGroupName.ToUpper Then
                Return treGroup.TreeGroupID
            End If
        Next
        Return Nothing
    End Function

    Public Shared Function GetTreeGroupName(ByVal treeGroupID As Integer) As String
        For Each treGroup As TreeGroup In TreeGroupCollection.GetTreeGroups
            If treGroup.TreeGroupID = treeGroupID Then
                Return treGroup.Name
            End If
        Next
        Return Nothing
    End Function
End Class
