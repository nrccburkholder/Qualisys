Imports NRC.Data
<AutoPopulate(), Serializable()> _
Public Class Privilege
    Public Enum PrivilegeLevelEnum
        Group = 0
        Member = 1
    End Enum

#Region " Private Members "
    <SQLField("Privilege_id")> Private mPrivilegeId As Integer
    <SQLField("OrgUnitPrivilege_id")> Private mOrgUnitPrivilegeId As Integer
    <SQLField("GroupPrivilege_id")> Private mGroupPrivilegeId As Integer
    <SQLField("MemberPrivilege_id")> Private mMemberPrivilegeId As Integer
    <SQLField("strPrivilege_nm")> Private mName As String
    <SQLField("strPrivilege_dsc")> Private mDescription As String
    <SQLField("PrivilegeLevel_id")> Private mPrivilegeLevel As PrivilegeLevelEnum
    <SQLField("datRevoked")> Private mDateRevoked As Date

    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "
    Public ReadOnly Property PrivilegeId() As Integer
        Get
            Return mPrivilegeId
        End Get
    End Property
    Public ReadOnly Property OrgUnitPrivilegeId() As Integer
        Get
            Return mOrgUnitPrivilegeId
        End Get
    End Property
    Public ReadOnly Property GroupPrivilegeId() As Integer
        Get
            Return mGroupPrivilegeId
        End Get
    End Property
    Public ReadOnly Property MemberPrivilegeId() As Integer
        Get
            Return mMemberPrivilegeId
        End Get
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If mDescription <> value Then
                mDescription = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public ReadOnly Property PrivilegeLevel() As PrivilegeLevelEnum
        Get
            Return mPrivilegeLevel
        End Get
    End Property

    Public ReadOnly Property DateRevoked() As Date
        Get
            Return mDateRevoked
        End Get
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

#End Region

#Region " Constructors "
    Public Sub New()
    End Sub
    Public Sub New(ByVal privilegeLevel As PrivilegeLevelEnum)
        Me.mPrivilegeLevel = privilegeLevel
    End Sub
#End Region

    Public Shared Function CreateNewPrivilege(ByVal applicationId As Integer, ByVal name As String, ByVal description As String, ByVal privilegeLevel As PrivilegeLevelEnum, ByVal authorMemberId As Integer) As Integer
        Return DAL.InsertPrivilege(applicationId, name, description, privilegeLevel, authorMemberId)
    End Function

    Public Sub Insert(ByVal applicationId As Integer, ByVal authorMemberId As Integer)
        mPrivilegeId = CreateNewPrivilege(applicationId, mName, mDescription, mPrivilegeLevel, authorMemberId)
        Me.mIsDirty = False
    End Sub

    Public Sub UpdatePrivilege(ByVal authorMemberId As Integer)
        If mPrivilegeId > 0 Then
            DAL.UpdatePrivilege(mPrivilegeId, mName, mDescription, authorMemberId)
            mIsDirty = False
        End If
    End Sub

    Public Shared Sub GrantPrivilegeToMember(ByVal OrgUnitPrivilegeId As Integer, ByVal memberId As Integer, ByVal dateRevoked As Date, ByVal authorMemberId As Integer)
        DAL.InsertMemberPrivilege(memberId, OrgUnitPrivilegeId, dateRevoked, authorMemberId)
    End Sub
    Public Shared Sub GrantPrivilegeToMember(ByVal OrgUnitPrivilegeId As Integer, ByVal memberId As Integer, ByVal authorMemberId As Integer)
        DAL.InsertMemberPrivilege(memberId, OrgUnitPrivilegeId, authorMemberId)
    End Sub
    Public Shared Sub GrantPrivilegeToGroup(ByVal OrgUnitPrivilegeId As Integer, ByVal groupId As Integer, ByVal dateRevoked As Date, ByVal authorMemberId As Integer)
        DAL.InsertGroupPrivilege(groupId, OrgUnitPrivilegeId, dateRevoked, authorMemberId)
    End Sub
    Public Shared Sub GrantPrivilegeToGroup(ByVal OrgUnitPrivilegeId As Integer, ByVal groupId As Integer, ByVal authorMemberId As Integer)
        DAL.InsertGroupPrivilege(groupId, OrgUnitPrivilegeId, authorMemberId)
    End Sub
    Public Shared Sub GrantPrivilegeToOrgUnit(ByVal privilegeId As Integer, ByVal orgUnitId As Integer, ByVal dateRevoked As Date, ByVal authorMemberId As Integer)
        DAL.InsertOrgUnitPrivilege(orgUnitId, privilegeId, dateRevoked, authorMemberId)
    End Sub
    Public Shared Sub GrantPrivilegeToOrgUnit(ByVal privilegeId As Integer, ByVal orgUnitId As Integer, ByVal authorMemberId As Integer)
        DAL.InsertOrgUnitPrivilege(orgUnitId, privilegeId, authorMemberId)
    End Sub
    'Public Sub GrantPrivilegeToOrgUnit(ByVal orgUnitId As Integer, ByVal authorMemberId As Integer)
    '    GrantPrivilegeToOrgUnit(mPrivilegeId, orgUnitId, authorMemberId)
    'End Sub

    Public Shared Sub RevokePrivilegeFromMember(ByVal memberPrivilegeId As Integer, ByVal authorMemberId As Integer)
        DAL.DeleteMemberPrivilege(memberPrivilegeId, authorMemberId)
    End Sub

    Public Shared Sub RevokePrivilegeFromGroup(ByVal groupPrivilegeId As Integer, ByVal authorMemberId As Integer)
        DAL.DeleteGroupPrivilege(groupPrivilegeId, authorMemberId)
    End Sub

    Public Shared Sub RevokePrivilegeFromOrgUnit(ByVal orgUnitPrivilegeId As Integer, ByVal authorMemberId As Integer)
        DAL.DeleteOrgUnitPrivilege(orgUnitPrivilegeId, authorMemberId)
    End Sub

End Class
