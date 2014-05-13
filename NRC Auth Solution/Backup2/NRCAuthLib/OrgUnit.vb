Imports NRC.Data
''' <summary>
''' Represents an Organizational Unit that contains member accounts and certain privileges
''' </summary>
<AutoPopulate(), Serializable()> _
Public Class OrgUnit
    Implements IComparable


#Region " Enums / Constants "
    Public Enum OrgUnitTypeEnum
        NrcOU = 1
        TeamOU = 2
        ClientOu = 3
    End Enum
#End Region

#Region " Private Members "
    <SQLField("OrgUnit_id")> Private mOrgUnitId As Integer
    <SQLField("QPClient_id")> Private mQPClientId As Integer
    <SQLField("strOrgUnit_nm")> Private mName As String
    <SQLField("strOrgUnit_dsc")> Private mDescription As String
    <SQLField("ParentOrgUnit_id")> Private mParentOrgUnitId As Integer
    <SQLField("OrgUnitType_id")> Private mOrgUnitType As OrgUnitTypeEnum
    Private mCreator As String
    <SQLField("datCreated")> Private mDateCreated As DateTime
    <SQLField("IPAddressFilter")> Private mIPAddressFilter As String
    <SQLField("HasChildren")> Private mHasChildren As Boolean
    <SQLField("TermsOfUse")> Private mTermsOfUse As String

    Private mParent As OrgUnit
    Private mOrgUnits As OrgUnitCollection
    Private mMembers As MemberCollection
    Private mApplications As ApplicationCollection
    Private mGroups As GroupCollection
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' The database ID of the Organizational Unit
    ''' </summary>
    Public ReadOnly Property OrgUnitId() As Integer
        Get
            Return mOrgUnitId
        End Get
    End Property
    ''' <summary>
    ''' The name of the Organizational Unit
    ''' </summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            mName = value
        End Set
    End Property
    ''' <summary>
    ''' A description of the Organizational Unit
    ''' </summary>
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            mDescription = value
        End Set
    End Property

    Public ReadOnly Property ParentOrgUnitId() As Integer
        Get
            Return Me.mParentOrgUnitId
        End Get
    End Property
    Public ReadOnly Property ParentOrgUnit() As OrgUnit
        Get
            If mParent Is Nothing Then
                If mParentOrgUnitId = 0 Then
                    Return Nothing
                End If
                mParent = OrgUnit.GetOrgUnit(mParentOrgUnitId)
            End If
            Return mParent
        End Get
    End Property
    ''' <summary>
    ''' The Organizational Unit type
    ''' </summary>
    Public Property OrgUnitType() As OrgUnitTypeEnum
        Get
            Return mOrgUnitType
        End Get
        Set(ByVal value As OrgUnitTypeEnum)
            mOrgUnitType = value
        End Set
    End Property

    Public Property QPClientId() As Integer
        Get
            Return mQPClientId
        End Get
        Set(ByVal Value As Integer)
            mQPClientId = Value
        End Set
    End Property
    ''' <summary>
    ''' The date on which this Organizational Unit was created
    ''' </summary>
    Public ReadOnly Property DateCreated() As DateTime
        Get
            Return mDateCreated
        End Get
    End Property
    ''' <summary>
    ''' The list of valid IP addresses for this Organizational Unit
    ''' </summary>
    Public Property IPAddressFilter() As String
        Get
            Return mIPAddressFilter
        End Get
        Set(ByVal value As String)
            mIPAddressFilter = value
        End Set
    End Property

    Public Property TermsOfUse() As String
        Get
            Return mTermsOfUse
        End Get
        Set(ByVal Value As String)
            mTermsOfUse = Value
        End Set
    End Property

    ''' <summary>
    ''' Indicates if this Organizational Unit has child units
    ''' </summary>
    Public ReadOnly Property HasChildren() As Boolean
        Get
            Return mHasChildren
        End Get
    End Property

    ''' <summary>
    ''' The collection of child Organizational Units
    ''' </summary>
    Public ReadOnly Property OrgUnits() As OrgUnitCollection
        Get
            If mOrgUnits Is Nothing Then
                mOrgUnits = OrgUnitCollection.GetOrgUnitChildren(mOrgUnitId)
            End If
            Return mOrgUnits
        End Get
    End Property
    ''' <summary>
    ''' The collection of members in this Organizational Unit
    ''' </summary>
    Public ReadOnly Property Members() As MemberCollection
        Get
            If mMembers Is Nothing Then
                mMembers = MemberCollection.GetOrgUnitMembers(mOrgUnitId)
            End If
            Return mMembers
        End Get
    End Property
    ''' <summary>
    ''' The collection of applications that have been granted to the Organizational Unit
    ''' </summary>
    Public ReadOnly Property Applications() As ApplicationCollection
        Get
            If mApplications Is Nothing Then
                mApplications = ApplicationCollection.GetOrgUnitApplications(mOrgUnitId)
            End If
            Return mApplications
        End Get
    End Property

    Public ReadOnly Property Groups() As GroupCollection
        Get
            If mGroups Is Nothing Then
                mGroups = GroupCollection.GetOrgUnitGroups(mOrgUnitId)
            End If
            Return mGroups
        End Get
    End Property

#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
#End Region

#Region " Public Shared Members "
    ''' <summary>
    ''' Returns an instance of OrgUnit for the specified OrgUnitId
    ''' </summary>
    ''' <param name="orgUnitId">The database ID of the OrgUnit to be retrieved</param>
    Public Shared Function GetOrgUnit(ByVal orgUnitId As Integer) As OrgUnit
        Dim rdr As IDataReader = DAL.SelectOrgUnit(orgUnitId)
        Return DirectCast(Populator.FillObject(rdr, GetType(OrgUnit)), OrgUnit)
        'Return DirectCast(NRC.Data.CBO.FillObject(rdr, GetType(OrgUnit)), OrgUnit)
    End Function

    Public Shared Function GetOrgUnitTree(ByVal orgUnitId As Integer) As OrgUnit
        Dim ds As DataSet = DAL.SelectOrgUnitTree(orgUnitId)
        ds.Relations.Add("ParentChild", ds.Tables(0).Columns("OrgUnit_id"), ds.Tables(0).Columns("ParentOrgUnit_id"))

        Dim root As DataRow = ds.Tables(0).Select("ParentOrgUnit_id IS NULL")(0)
        Return GetOUNode(root)
    End Function
    Private Shared Function GetOUNode(ByVal root As DataRow) As OrgUnit
        Dim ou As OrgUnit = GetOrgUnitFromRow(root)
        ou.Name = root(2).ToString
        Dim childOU As OrgUnit
        ou.mOrgUnits = New OrgUnitCollection

        For Each child As DataRow In root.GetChildRows("ParentChild")
            childOU = GetOUNode(child)
            ou.mOrgUnits.Add(childOU)
        Next
        Return ou
    End Function

    Public Shared Function CreateNewOrgUnit(ByVal name As String, ByVal description As String, ByVal orgType As OrgUnitTypeEnum, ByVal parentOrgUnitId As Integer, ByVal QPClientId As Integer, ByVal authorMemberId As Integer) As OrgUnit
        Dim newID As Integer = DAL.InsertOrgUnit(name, description, orgType, parentOrgUnitId, QPClientId, authorMemberId)
        Return OrgUnit.GetOrgUnit(newID)
    End Function

    Private Shared Function GetOrgUnitFromRow(ByVal row As DataRow) As OrgUnit
        Dim ou As New OrgUnit

        ou.mOrgUnitId = CType(row("OrgUnit_id"), Integer)
        If Not row.IsNull("QPClient_id") Then
            ou.mQPClientId = CType(row("QPClient_id"), Integer)
        End If
        ou.mName = row("strOrgUnit_nm").ToString
        ou.mDescription = row("strOrgUnit_dsc").ToString
        If Not row.IsNull("ParentOrgUnit_id") Then
            ou.mParentOrgUnitId = CType(row("ParentOrgUnit_id"), Integer)
        End If
        ou.mOrgUnitType = CType(row("OrgUnitType_id"), OrgUnitTypeEnum)
        ou.mDateCreated = CType(row("datCreated"), DateTime)
        ou.mHasChildren = CType(row("HasChildren"), Boolean)
        Return ou
    End Function

#End Region

#Region " Public Members "
    ''' <summary>
    ''' Returns true if the Organizational Unit has access to any privileges within the specified application
    ''' </summary>
    ''' <param name="applicationName">The name of the application</param>
    Public Function HasPrivilege(ByVal applicationName As String) As Boolean
        Return (Not Applications(applicationName) Is Nothing)
    End Function

    ''' <summary>
    ''' Return true if the Organizational Unit has been granted a particular privilege to a given application
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

    Public Sub GrantOrgUnitPrivilege(ByVal privilegeId As Integer, ByVal dateRevoked As Date, ByVal authorMemberId As Integer)
        'Grant the privilege
        Privilege.GrantPrivilegeToOrgUnit(privilegeId, mOrgUnitId, dateRevoked, authorMemberId)

        'Refresh application list
        Me.mApplications = Nothing
    End Sub

    Public Sub GrantOrgUnitPrivilege(ByVal privilegeId As Integer, ByVal authorMemberId As Integer)
        'Grant the privilege
        Privilege.GrantPrivilegeToOrgUnit(privilegeId, mOrgUnitId, authorMemberId)

        'Refresh application list
        Me.mApplications = Nothing
    End Sub

    Public Sub RevokeOrgUnitPrivilege(ByVal orgUnitPrivilegeId As Integer, ByVal authorMemberId As Integer)
        'Revoke the privilege
        Privilege.RevokePrivilegeFromOrgUnit(orgUnitPrivilegeId, authorMemberId)

        'Refresh the application list
        Me.mApplications = Nothing
    End Sub


    Public Sub UpdateOrgUnit(ByVal authorMemberId As Integer)
        DAL.UpdateOrgUnit(mOrgUnitId, mName, mDescription, mOrgUnitType, mParentOrgUnitId, True, authorMemberId)
    End Sub

    Public Sub DeleteOrgUnit(ByVal authorMemberId As Integer)
        DAL.UpdateOrgUnit(mOrgUnitId, mName, mDescription, mOrgUnitType, mParentOrgUnitId, False, authorMemberId)
    End Sub

    Public Sub MoveOrgUnit(ByVal newParentOrgUnitId As Integer, ByVal authorMemberId As Integer)
        If Not HasPrivilegeSubset(newParentOrgUnitId) Then
            Throw New Exception("The OrgUnit cannot be moved because the new parent OrgUnit does not have all the necessary privileges")
        End If
        Me.mParent = Nothing
        Me.mApplications = Nothing
        Me.mParentOrgUnitId = newParentOrgUnitId

        Me.UpdateOrgUnit(authorMemberId)
    End Sub

    Public Function HasPrivilegeSubset(ByVal compareToOrgUnitId As Integer) As Boolean
        'Determines if this orgunit has a subset of all the privileges granted to another orgunit
        Dim myApps As ApplicationCollection
        Dim compareApps As ApplicationCollection

        'Get the apps of this OU and the apps of the OU we are comparing to 
        myApps = ApplicationCollection.GetOrgUnitApplications(mOrgUnitId)
        compareApps = ApplicationCollection.GetOrgUnitApplications(compareToOrgUnitId)

        'Create a privilege list for this OU
        Dim myPrivileges As New ArrayList
        For Each app As Application In myApps
            For Each priv As Privilege In app.Privileges
                myPrivileges.Add(priv.PrivilegeId)
            Next
        Next

        'Create a privilege list for the OU we are comparing to
        Dim comparePrivileges As New Hashtable
        For Each app As Application In compareApps
            For Each priv As Privilege In app.Privileges
                comparePrivileges.Add(priv.PrivilegeId, priv.PrivilegeId)
            Next
        Next

        'If any of the privileges from this OU are not in the other privilege list then return FALSE
        For Each privId As Integer In myPrivileges
            If Not comparePrivileges.ContainsKey(privId) Then
                Return False
            End If
        Next

        'Must be a subset
        Return True
    End Function
#End Region



    Public Function CompareTo(ByVal obj As Object) As Integer Implements System.IComparable.CompareTo
        If Not TypeOf obj Is OrgUnit Then
            Throw New ArgumentException("Can only compare OrgUnit objects with other OrgUnit objects.")
        End If
        Return String.Compare(mName, DirectCast(obj, OrgUnit).mName)
    End Function
End Class
