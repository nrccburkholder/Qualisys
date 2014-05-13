Imports Nrc.NRCAuthLib

Public Class OrgUnitPrivilegeEditor
    Inherits PrivilegeEditor

    Private mAvailableApps As ApplicationCollection
    'Private mGrantedApps As ApplicationCollection
    Private mAvailablePrivileges As Dictionary(Of Integer, Privilege)
    Private mGrantedPrivileges As Dictionary(Of Integer, Privilege)

    Private mOrgUnit As OrgUnit

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
            Return "Organization: " + mOrgUnit.Name
        End Get
    End Property

    Public Sub New(ByVal org As OrgUnit)
        mOrgUnit = org

        If org.ParentOrgUnit Is Nothing Then
            mAvailableApps = ApplicationCollection.GetAllApplications
        Else
            mAvailableApps = org.ParentOrgUnit.Applications
        End If
        mAvailablePrivileges = GetPrivileges(mAvailableApps)

        'mGrantedApps = org.Applications
        mGrantedPrivileges = GetPrivileges(org.Applications)
    End Sub

    Protected Overrides Function ShowPrivilege(ByVal priv As NRCAuthLib.Privilege) As Boolean
        Return True
    End Function

    Protected Overrides Sub GrantSinglePrivilege(ByVal grant As PrivilegeGrant, ByVal memberId As Integer)
        'Get this privilege from the available privileges list
        Dim priv As Privilege = mAvailablePrivileges(grant.PrivilegeId)

        'Grant the privilege
        If grant.RevokeDate = Date.MinValue Then
            mOrgUnit.GrantOrgUnitPrivilege(priv.PrivilegeId, memberId)
        Else
            mOrgUnit.GrantOrgUnitPrivilege(priv.PrivilegeId, grant.RevokeDate, memberId)
        End If
    End Sub

    Protected Overrides Sub RevokeSinglePrivilege(ByVal privilegeId As Integer, ByVal memberId As Integer)
        'Get this privilege from the previously granted list
        Dim priv As Privilege = mGrantedPrivileges(privilegeId)

        'Revoke the privilege
        mOrgUnit.RevokeOrgUnitPrivilege(priv.OrgUnitPrivilegeId, memberId)
    End Sub

End Class