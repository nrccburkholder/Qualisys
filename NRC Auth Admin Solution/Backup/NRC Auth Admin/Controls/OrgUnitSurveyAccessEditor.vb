Imports Nrc.NRCAuthLib

Public Class OrgUnitSurveyAccessEditor
    Inherits SurveyAccessEditor

    Private mOrgUnit As OrgUnit
    Private mPrivilegeTree As DataMartPrivilegeTree

    Public Sub New(ByVal org As OrgUnit)
        Me.mOrgUnit = org

        'Only load for a Client OrgUnit
        If mOrgUnit.OrgUnitType = OrgUnit.OrgUnitTypeEnum.ClientOu Then
            'Get the privilege tree and load it
            Me.mPrivilegeTree = DataMartPrivilegeTree.GetOrgUnitTree(org)
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
        DataMartPrivilegeTree.UpdateOrgUnitAccess(Me.mOrgUnit.OrgUnitId, selectedIds, CurrentUser.Member.MemberId)
    End Sub
End Class
