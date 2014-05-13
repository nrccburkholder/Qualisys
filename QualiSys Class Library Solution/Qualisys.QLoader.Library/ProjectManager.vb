Imports Nrc.Framework.BusinessLogic
Imports Nrc.NRCAuthLib

''' <summary>This class is populated with members of "Project Managers" group in NRCAuth.</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ProjectManager
    Inherits BusinessBase(Of ProjectManager)
    Private Const ROOTORGUNIT As Integer = 1
    Private Const PROJECTMANAGERS As String = "Project Managers"
    Private Const NRCGENERAL As String = "NRC General"

    Private mFirstName As String
    Private mLastName As String
    Private mFullName As String
    Private mMemberID As Integer
#Region "Public Properties"
    ''' <summary>Exposes member.Firstname</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property FirstName() As String
        Get
            Return mFirstName
        End Get
    End Property
    ''' <summary>Exposes member.LastName</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property LastName() As String
        Get
            Return mLastName
        End Get
    End Property
    ''' <summary>Exposes Member.MemberID</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property MemberID() As Integer
        Get
            Return mMemberID
        End Get
    End Property
    Public ReadOnly Property FullName() As String
        Get
            Return mFullName
        End Get
    End Property
#End Region
    ''' <summary>Takes a member object and populates its own public properties</summary>
    ''' <param name="PMMember"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub New(ByVal PMMember As Member)
        If PMMember IsNot Nothing Then
            Me.mFirstName = PMMember.FirstName
            Me.mLastName = PMMember.LastName
            Me.mMemberID = PMMember.MemberId
            Me.mFullName = PMMember.FullName
        End If
    End Sub
    Private Sub New()
    End Sub
#Region " Factory Methods "
    ''' <summary>Gives an access to the constructor as a shared factory method.</summary>
    ''' <param name="PMMember"></param>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewProjectManager(ByVal PMMember As Member) As ProjectManager
        Return New ProjectManager(PMMember)
    End Function
    Public Shared Function NewProjectManager() As ProjectManager
        Return New ProjectManager
    End Function

    ''' <summary>Populates the new instance with the member information</summary>
    ''' <param name="MemberID"></param>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetByMemberID(ByVal MemberID As Integer) As ProjectManager
        Return New ProjectManager(Member.GetMember(MemberID))
    End Function
    ''' <summary>Returns all of the project managers as ProjectManagerCollection</summary>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As ProjectManagerCollection
        Dim PMGroup As NRCAuthLib.Group = Group.GetGroup(PROJECTMANAGERS, GetPMOrgUnitID().Value)
        Dim ProjectManagerMembers As NRCAuthLib.MemberCollection = _
        MemberCollection.GetGroupMembers(PMGroup.GroupId)
        Return New ProjectManagerCollection(ProjectManagerMembers)
    End Function
#End Region
    ''' <summary>There is only one group in NRCAuth that keeps the list of project managers.
    ''' The name of that group is "Project Managers". The returned value is used to get the list
    ''' of project managers.</summary>
    ''' <returns>the ID of "Project Managers" group.</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Shared Function GetPMOrgUnitID() As Nullable(Of Integer)
        Dim neworg As New NRC.NRCAuthLib.OrgUnit
        For Each orgUnit As OrgUnit In NRC.NRCAuthLib.OrgUnit.GetOrgUnitTree(ROOTORGUNIT).OrgUnits
            If orgUnit.Name = NRCGENERAL Then
                Return orgUnit.OrgUnitId
            End If
        Next
        Throw New Exception("Measurement Services Manager OrgUnit is not found")
        Return Nothing
    End Function
    Protected Overrides Function GetIdValue() As Object
        Return MemberID()
    End Function
End Class
