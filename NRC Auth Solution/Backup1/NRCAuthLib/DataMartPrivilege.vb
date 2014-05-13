Public Class DataMartPrivilegeTree

    Public Enum PrivilegeLevelEnum
        Client = 1
        Study = 2
        Survey = 3
        Unit = 4
    End Enum

    Private mNodes As New DataMartPrivilegeNodeCollection

    Public ReadOnly Property Nodes() As DataMartPrivilegeNodeCollection
        Get
            Return mNodes
        End Get
    End Property

    Public Shared Function GetGroupTree(ByVal grp As Group) As DataMartPrivilegeTree
        Dim orgUnitId As Integer = grp.OrgUnitId
        Dim parentOrgUnitId As Integer = grp.OrgUnit.ParentOrgUnitId
        Dim groupId As Integer = grp.GroupId
        Dim ds As DataSet = DAL.SelectGroupSurveyResultsAccessTree(orgUnitId, parentOrgUnitId, groupId)
        Return GetTreeFromDataSet(ds)
    End Function

    Public Shared Function GetOrgUnitTree(ByVal ou As OrgUnit) As DataMartPrivilegeTree
        Dim orgUnitId As Integer = ou.OrgUnitId
        Dim parentOrgUnitId As Integer
        If Not ou.ParentOrgUnit.OrgUnitType = OrgUnit.OrgUnitTypeEnum.ClientOu Then
            parentOrgUnitId = -1
        Else
            parentOrgUnitId = ou.ParentOrgUnitId
        End If
        Dim ds As DataSet = DAL.SelectOrgUnitSurveyResultsAccessTree(orgUnitId, parentOrgUnitId)
        Return GetTreeFromDataSet(ds)
    End Function

    Public Shared Sub UpdateOrgUnitAccess(ByVal orgUnitId As Integer, ByVal selectedNodes As String, ByVal authorMemberId As Integer)
        DAL.UpdateOrgUnitSurveyResultsAccess(orgUnitId, selectedNodes, authorMemberId)
    End Sub

    Public Shared Sub UpdateGroupAccess(ByVal groupId As Integer, ByVal orgUnitId As Integer, ByVal selectedNodes As String, ByVal authorMemberId As Integer)
        DAL.UpdateGroupSurveyResultsAccess(groupId, orgUnitId, selectedNodes, authorMemberId)
    End Sub

    Private Shared Function GetTreeFromDataSet(ByVal ds As DataSet) As DataMartPrivilegeTree
        ds.Relations.Add("ParentChild", ds.Tables(0).Columns("strRights_id"), ds.Tables(0).Columns("strParentRights_id"))
        Dim roots As DataRow() = ds.Tables(0).Select("strParentRights_id IS NULL", "strRights_nm")
        Dim tree As New DataMartPrivilegeTree
        For Each rootRow As DataRow In roots
            tree.Nodes.Add(GetNode(ds.Tables(0), rootRow))
        Next

        Return tree
    End Function

    Private Shared Function GetNode(ByVal table As DataTable, ByVal rootRow As DataRow) As DataMartPrivilegeNode
        Dim rootNode As DataMartPrivilegeNode = DataMartPrivilegeNode.GetNodeFromRow(rootRow)
        Dim childNode As DataMartPrivilegeNode
        Dim children As DataRow() = rootRow.GetChildRows("ParentChild")
        Dim filter As String = String.Format("strParentRights_id = '{0}'", rootRow("strRights_id").ToString)
        For Each childRow As DataRow In table.Select(filter, "strRights_nm")
            childNode = GetNode(table, childRow)
            rootNode.Nodes.Add(childNode)
        Next

        Return rootNode
    End Function

#Region " DataMartPrivilegeNode Class "
    Public Class DataMartPrivilegeNode
        Private mNodeId As String
        Private mLabel As String
        Private mIsGranted As Boolean
        Private mIsCheckable As Boolean
        Private mNodes As New DataMartPrivilegeNodeCollection

        Public ReadOnly Property PrivilegeLevel() As PrivilegeLevelEnum
            Get
                If mNodeId.StartsWith("C") Then
                    Return PrivilegeLevelEnum.Client
                ElseIf mNodeId.StartsWith("ST") Then
                    Return PrivilegeLevelEnum.Study
                ElseIf mNodeId.StartsWith("SVY") Then
                    Return PrivilegeLevelEnum.Survey
                ElseIf mNodeId.StartsWith("SU") Then
                    Return PrivilegeLevelEnum.Unit
                End If
            End Get
        End Property
        Public ReadOnly Property NodeId() As String
            Get
                Return mNodeId
            End Get
        End Property
        Public ReadOnly Property Label() As String
            Get
                Return mLabel
            End Get
        End Property
        Public ReadOnly Property IsGranted() As Boolean
            Get
                Return mIsGranted
            End Get
        End Property
        Public ReadOnly Property IsCheckable() As Boolean
            Get
                Return mIsCheckable
            End Get
        End Property
        Public ReadOnly Property Nodes() As DataMartPrivilegeNodeCollection
            Get
                Return mNodes
            End Get
        End Property
        Public ReadOnly Property HasChildren() As Boolean
            Get
                Return (mNodes.Count > 0)
            End Get
        End Property

        Friend Shared Function GetNodeFromRow(ByVal row As DataRow) As DataMartPrivilegeNode
            Dim node As New DataMartPrivilegeNode
            node.mLabel = row("strRights_nm").ToString
            node.mNodeId = row("strRights_id").ToString
            node.mIsCheckable = CType(row("Checkable"), Boolean)
            node.mIsGranted = CType(row("isChecked"), Boolean)

            Return node
        End Function
    End Class

    Public Class DataMartPrivilegeNodeCollection
        Inherits CollectionBase

        Default Public ReadOnly Property Item(ByVal index As Integer) As DataMartPrivilegeNode
            Get
                Return DirectCast(MyBase.List(index), DataMartPrivilegeNode)
            End Get
        End Property

        Public Function Add(ByVal node As DataMartPrivilegeNode) As Integer
            Return MyBase.List.Add(node)
        End Function
    End Class

#End Region

End Class

