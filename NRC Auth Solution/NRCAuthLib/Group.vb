Imports NRC.Data

<AutoPopulate(), Serializable()> _
Public Class Group

#Region " Private Members "
    <SQLField("Group_id")> Private mGroupId As Integer
    <SQLField("OrgUnit_id")> Private mOrgUnitId As Integer
    <SQLField("CreatorMember_id")> Private mCreatorMemberId As Integer
    <SQLField("datCreated")> Private mDateCreated As DateTime
    <SQLField("strGroup_nm")> Private mName As String
    <SQLField("strGroup_dsc")> Private mDescription As String
    <SQLField("strEmail")> Private mEmail As String
    '<SQLField("strPassword")> Private mPasswordHash As String
    '<SQLField("SaltValue")> Private mPasswordSalt As String

    Private mApplications As ApplicationCollection
    Private mOrgUnit As OrgUnit
#End Region

#Region " Public Properties "
    Public ReadOnly Property GroupId() As Integer
        Get
            Return mGroupId
        End Get
    End Property
    Public ReadOnly Property OrgUnitId() As Integer
        Get
            Return mOrgUnitId
        End Get
    End Property
    Public ReadOnly Property CreatorMemberId() As Integer
        Get
            Return mCreatorMemberId
        End Get
    End Property
    Public ReadOnly Property DateCreated() As DateTime
        Get
            Return mDateCreated
        End Get
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal Value As String)
            mName = Value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal Value As String)
            mDescription = Value
        End Set
    End Property
    Public Property Email() As String
        Get
            Return mEmail
        End Get
        Set(ByVal Value As String)
            mEmail = Value
        End Set
    End Property

    Public ReadOnly Property ApplicationList() As String
        Get
            Dim apps As String = ""
            For Each app As Application In Applications
                apps &= app.Name & ","
            Next
            If apps.Length > 0 Then
                apps = apps.Substring(0, apps.Length - 1)
            End If

            Return apps
        End Get
    End Property

    Public ReadOnly Property Applications() As ApplicationCollection
        Get
            If mApplications Is Nothing Then
                mApplications = ApplicationCollection.GetGroupApplications(mGroupId)
            End If
            Return mApplications
        End Get
    End Property
    Public ReadOnly Property OrgUnit() As OrgUnit
        Get
            If mOrgUnit Is Nothing Then
                mOrgUnit = OrgUnit.GetOrgUnit(mOrgUnitId)
            End If
            Return mOrgUnit
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
#End Region

#Region " Public Shared Methods "
    Public Shared Function GetGroup(ByVal groupId As Integer) As Group
        Dim rdr As IDataReader = DAL.SelectGroup(groupId)
        Dim grp As Group = DirectCast(Populator.FillObject(rdr, GetType(Group)), Group)
        Return grp
    End Function

    Public Shared Function GetGroup(ByVal groupName As String, ByVal orgUnitID As Integer) As Group
        Dim rdr As IDataReader = DAL.SelectGroup(groupName, orgUnitID)
        Dim grp As Group = DirectCast(Populator.FillObject(rdr, GetType(Group)), Group)
        Return grp
    End Function

    Public Shared Function CreateNewGroup(ByVal orgUnitId As Integer, ByVal groupName As String, ByVal description As String, ByVal email As String, ByVal authorMemberId As Integer) As Group
        For Each grp As Group In NRCAuthLib.OrgUnit.GetOrgUnit(orgUnitId).Groups
            If grp.Name.ToLower = groupName.ToLower Then
                Throw New Exception("The group cannot be created because the group name already exists for this OrgUnit.")
            End If
        Next
        'If Not Member.IsUserNameAvailable(groupName) Then
        '    Throw New Exception("The group cannot be created because the group name is not unique.")
        'End If
        Dim newID As Integer = DAL.InsertGroup(orgUnitId, groupName, description, email, authorMemberId)
        Return Group.GetGroup(newID)
    End Function

    Public Shared Sub DeleteGroup(ByVal groupId As Integer, ByVal authorMemberId As Integer)
        DAL.DeleteGroup(groupId, authorMemberId)
    End Sub

    Friend Sub AddMemberToGroup(ByVal memberId As Integer, ByVal authorMemberId As Integer)
        DAL.InsertGroupMember(mGroupId, memberId, authorMemberId)
    End Sub
    Public Sub RemoveMemberFromGroup(ByVal memberId As Integer, ByVal authorMemberId As Integer)
        DAL.DeleteGroupMember(mGroupId, memberId, authorMemberId)
    End Sub


#End Region

#Region " Public Methods "

    ''' <summary>
    ''' Returns true if the user has access to any privileges within the specified application
    ''' </summary>
    ''' <param name="applicationName">The name of the application</param>
    Public Function HasPrivilege(ByVal applicationName As String) As Boolean
        Return (Not Applications(applicationName) Is Nothing)
    End Function

    ''' <summary>
    ''' Return true if the user has been granted a particular privilege to a given application
    ''' </summary>
    ''' <param name="applicationName">The name of the application</param>
    ''' <param name="privilegeName">The name of the privilege</param>
    Public Function HasPrivilege(ByVal applicationName As String, ByVal privilegeName As String) As Boolean
        Dim app As Application = Applications(applicationName)
        If app Is Nothing Then
            Return False
        Else
            If Not app.Privileges(privilegeName) Is Nothing Then
                Return True
            End If
        End If

        Return False
    End Function

    Public Sub GrantGroupPrivilege(ByVal orgUnitPrivilegeId As Integer, ByVal dateRevoked As Date, ByVal authorMemberId As Integer)
        'Grant the privilege
        Privilege.GrantPrivilegeToGroup(orgUnitPrivilegeId, mGroupId, dateRevoked, authorMemberId)

        'Refresh the application list
        Me.mApplications = Nothing
    End Sub

    Public Sub GrantGroupPrivilege(ByVal orgUnitPrivilegeId As Integer, ByVal authorMemberId As Integer)
        'Grant the privilege
        Privilege.GrantPrivilegeToGroup(orgUnitPrivilegeId, mGroupId, authorMemberId)

        'Refresh the application list
        Me.mApplications = Nothing
    End Sub

    Public Sub RevokeGroupPrivilege(ByVal groupPrivilegeId As Integer, ByVal authorMemberId As Integer)
        'Revoke the privilege
        Privilege.RevokePrivilegeFromGroup(groupPrivilegeId, authorMemberId)

        'Refresh the application list
        Me.mApplications = Nothing
    End Sub

    Public Sub UpdateGroup(ByVal authorMemberId As Integer)
        DAL.UpdateGroup(mGroupId, mName, mDescription, mEmail, authorMemberId)
    End Sub
#End Region

#Region " Private Methods "

#End Region


End Class
