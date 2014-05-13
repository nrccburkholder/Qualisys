Imports Nrc.NRCAuthLib

Public Class GroupPrivilegeEditor
    Inherits PrivilegeEditor

    Private mAvailableApps As ApplicationCollection
    'Private mGrantedApps As ApplicationCollection
    Private mAvailablePrivileges As Dictionary(Of Integer, Privilege)
    Private mGrantedPrivileges As Dictionary(Of Integer, Privilege)

    Private mGroup As Group
    Private mGroups As GroupCollection

    Protected Overrides ReadOnly Property AvailableApplications() As NRCAuthLib.ApplicationCollection
        Get
            Return Me.mAvailableApps
        End Get
    End Property

    Protected Overrides ReadOnly Property GrantedPrivileges() As System.Collections.Generic.Dictionary(Of Integer, NRCAuthLib.Privilege)
        Get
            Return Me.mGrantedPrivileges
        End Get
    End Property
    Public Overrides ReadOnly Property PrintTitle() As String
        Get
            Return String.Format("Organization: {0}     Group: {1}", mGroup.OrgUnit.Name, mGroup.Name)
        End Get
    End Property

    Public Sub New(ByVal grp As Group)
        mGroup = grp
        mAvailableApps = grp.OrgUnit.Applications
        mAvailablePrivileges = GetPrivileges(mAvailableApps)

        mGrantedPrivileges = GetPrivileges(grp.Applications)
    End Sub

    Public Sub New(ByVal groups As GroupCollection)
        mGroups = groups
        mAvailableApps = groups(0).OrgUnit.Applications
        mAvailablePrivileges = GetPrivileges(mAvailableApps)

        mGrantedPrivileges = New Dictionary(Of Integer, Privilege)

        Me.IsBulkEdit = True
    End Sub

    Protected Overrides Function ShowPrivilege(ByVal priv As NRCAuthLib.Privilege) As Boolean
        Return (priv.PrivilegeLevel = Privilege.PrivilegeLevelEnum.Group)
    End Function

    Protected Overrides Sub GrantBulkPrivileges(ByVal specifyExact As Boolean, ByVal grantList As PrivilegeGrantList, ByVal authorMemberId As Integer)
        For Each grp As Group In Me.mGroups
            'Get the privileges that the target group already has
            Dim grantedGroupPrivileges As New List(Of Privilege)
            For Each app As Application In grp.Applications
                For Each priv As Privilege In app.Privileges
                    grantedGroupPrivileges.Add(priv)
                Next
            Next

            If specifyExact Then
                'Revoke any privileges that were not selected
                For Each priv As Privilege In grantedGroupPrivileges
                    If Not grantList.ContainsPrivilege(priv.PrivilegeId) Then
                        grp.RevokeGroupPrivilege(priv.GroupPrivilegeId, authorMemberId)
                    End If
                Next
            End If

            'Grant all privileges from source group
            For Each grant As PrivilegeGrant In grantList
                Dim priv As Privilege = mAvailablePrivileges(grant.PrivilegeId)
                If grant.RevokeDate = Date.MinValue Then
                    grp.GrantGroupPrivilege(priv.OrgUnitPrivilegeId, authorMemberId)
                Else
                    grp.GrantGroupPrivilege(priv.OrgUnitPrivilegeId, grant.RevokeDate, authorMemberId)
                End If
            Next
        Next
    End Sub

    Protected Overrides Sub GrantSinglePrivilege(ByVal grant As PrivilegeGrant, ByVal authorMemberId As Integer)
        Dim priv As Privilege = mAvailablePrivileges(grant.PrivilegeId)
        If grant.RevokeDate = Date.MinValue Then
            mGroup.GrantGroupPrivilege(priv.OrgUnitPrivilegeId, authorMemberId)
        Else
            mGroup.GrantGroupPrivilege(priv.OrgUnitPrivilegeId, grant.RevokeDate, authorMemberId)
        End If
    End Sub

    Protected Overrides Sub RevokeSinglePrivilege(ByVal privilegeId As Integer, ByVal authorMemberId As Integer)
        Dim priv As Privilege = mGrantedPrivileges(privilegeId)
        mGroup.RevokeGroupPrivilege(priv.GroupPrivilegeId, authorMemberId)
    End Sub
End Class