Imports Nrc.NRCAuthLib

Public Class MemberPrivilegeEditor
    Inherits PrivilegeEditor

    Private mAvailableApps As ApplicationCollection
    'Private mGrantedApps As ApplicationCollection
    Private mAvailablePrivileges As Dictionary(Of Integer, Privilege)
    Private mGrantedPrivileges As Dictionary(Of Integer, Privilege)

    Private mMember As Member
    Private mMembers As MemberCollection

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
            If Not mMember Is Nothing Then
                Return String.Format("Organization: {0}     Member: {1}", mMember.OrgUnit.Name, mMember.Name)
            Else
                Return "Multiple Users Selected"
            End If
        End Get
    End Property

    Public Sub New(ByVal mbr As Member)
        mMember = mbr
        mAvailableApps = mbr.OrgUnit.Applications
        mAvailablePrivileges = GetPrivileges(mAvailableApps)

        'mGrantedApps = org.Applications
        mGrantedPrivileges = GetPrivileges(mbr.MemberApplications)

        If mbr.MemberId = CurrentUser.Member.MemberId AndAlso Not CurrentUser.Member.MemberType = Member.MemberTypeEnum.NRC_Admin Then
            Me.WarningMessage = "You do not have access to edit your own privileges"
            Me.ReadOnly = True
        End If
    End Sub

    Public Sub New(ByVal members As MemberCollection)
        mMembers = members
        mAvailableApps = members(0).OrgUnit.Applications
        mAvailablePrivileges = GetPrivileges(mAvailableApps)

        mGrantedPrivileges = New Dictionary(Of Integer, Privilege)

        Me.IsBulkEdit = True

        For Each mbr As Member In members
            If mbr.MemberId = CurrentUser.Member.MemberId AndAlso Not CurrentUser.Member.MemberType = Member.MemberTypeEnum.NRC_Admin Then
                Me.WarningMessage = "You do not have access to edit your own privileges"
                Me.ReadOnly = True
            End If
        Next
    End Sub

    Protected Overrides Function ShowPrivilege(ByVal priv As NRCAuthLib.Privilege) As Boolean
        Return (priv.PrivilegeLevel = Privilege.PrivilegeLevelEnum.Member)
    End Function

    Protected Overrides Sub GrantBulkPrivileges(ByVal specifyExact As Boolean, ByVal grantList As PrivilegeGrantList, ByVal authorMemberId As Integer)
        For Each mbr As Member In Me.mMembers
            'Get the privileges that the target member already has
            Dim grantedPrivileges As New List(Of Privilege)
            For Each app As Application In mbr.MemberApplications
                For Each priv As Privilege In app.Privileges
                    grantedPrivileges.Add(priv)
                Next
            Next

            If specifyExact Then
                'Revoke any privileges that were not selected
                For Each priv As Privilege In grantedPrivileges
                    If Not grantList.ContainsPrivilege(priv.PrivilegeId) Then
                        mbr.RevokeMemberPrivilege(priv.MemberPrivilegeId, authorMemberId)
                    End If
                Next
            End If

            'Grant all privileges
            For Each grant As PrivilegeGrant In grantList
                Dim priv As Privilege = mAvailablePrivileges(grant.PrivilegeId)
                If grant.RevokeDate = Date.MinValue Then
                    mbr.GrantMemberPrivilege(priv.OrgUnitPrivilegeId, authorMemberId)
                Else
                    mbr.GrantMemberPrivilege(priv.OrgUnitPrivilegeId, grant.RevokeDate, authorMemberId)
                End If
            Next
        Next
    End Sub

    Protected Overrides Sub GrantSinglePrivilege(ByVal grant As PrivilegeGrant, ByVal authorMemberId As Integer)
        Dim priv As Privilege = mAvailablePrivileges(grant.PrivilegeId)
        If grant.RevokeDate = Date.MinValue Then
            mMember.GrantMemberPrivilege(priv.OrgUnitPrivilegeId, authormemberId)
        Else
            mMember.GrantMemberPrivilege(priv.OrgUnitPrivilegeId, grant.RevokeDate, authorMemberId)
        End If

    End Sub

    Protected Overrides Sub RevokeSinglePrivilege(ByVal privilegeId As Integer, ByVal memberId As Integer)
        Dim priv As Privilege = mGrantedPrivileges(privilegeId)
        mMember.RevokeMemberPrivilege(priv.MemberPrivilegeId, memberId)
    End Sub

End Class
