Imports Nrc.NRCAuthLib

Public Class GroupSurveyAccessEditor
    Inherits SurveyAccessEditor

    Private mGroup As Group
    Private mPrivilegeTree As DataMartPrivilegeTree

    Public Sub New(ByVal grp As Group)
        Me.mGroup = grp

        'Only load for a group in a Client OrgUnit
        If mGroup.OrgUnit.OrgUnitType = OrgUnit.OrgUnitTypeEnum.ClientOu Then
            'Get the privilege tree and load it
            Me.mPrivilegeTree = DataMartPrivilegeTree.GetGroupTree(grp)
            Me.PopulatePrivilegeTree(Me.mPrivilegeTree)
        End If
    End Sub

    Protected Overloads Overrides Sub SaveChanges(ByVal grantedNodes As DataMartPrivilegeTree.DataMartPrivilegeNodeCollection)
        'Create a comma delimited list
        Dim idList As New List(Of String)
        For Each node As DataMartPrivilegeTree.DataMartPrivilegeNode In grantedNodes
            idList.Add(node.NodeId)
        Next

        Dim selectedIds As String = String.Join(",", idList.ToArray())

        'Store the Survey Access settings
        DataMartPrivilegeTree.UpdateGroupAccess(Me.mGroup.GroupId, Me.mGroup.OrgUnitId, selectedIds, CurrentUser.Member.MemberId)
    End Sub
End Class
