Imports System.Linq
Imports System.Collections.Generic
Imports System.Windows.Forms
Imports System.Linq.Expressions
Imports System.Configuration

Namespace OUH
    ' Provide Repository-style accessors to our EF model
    Partial Public Class OUHModel

#Region "Class Constants"
        ' The default (no client selected) value for the Client filter
        Private Shared ReadOnly _clientFilterID As Integer = -1
        ' The default (no category selected) value for the Category filter
        Private Shared ReadOnly _categoryFilterString As String = "--select all categories--"
        ' Use String.Format with a database connection string
        Private Shared ReadOnly _connectionStringFormat As String = "metadata=res://*/OUH.OUHModel.csdl|res://*/OUH.OUHModel.ssdl|res://*/OUH.OUHModel.msl;provider=System.Data.SqlClient;provider connection string='{0}'"
#End Region

#Region "Static Constructor"
        Public Shared Property ConnectionString As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("US_CatalystStar")

        ' Retrieve a context to work with
        Private Shared Function GetModel() As OUHModel
            Return New OUHModel(String.Format(_connectionStringFormat, ConnectionString))
        End Function
#End Region

#Region "OUH Accessor Methods"
        ' Get a list of clients
        Public Shared Function GetClients() As List(Of Client)
            Using ctx As OUHModel = OUHModel.GetModel()
                'Create a dummy client for open filter
                Dim dummyClient As New Client
                dummyClient.ClientID = _clientFilterID
                dummyClient.ClientName = "--select all clients--"

                Dim clients As New List(Of Client)
                clients.Add(dummyClient)
                clients.AddRange(ctx.Client.OrderBy(Function(c) c.ClientName).ToList())
                Return clients
            End Using
        End Function

        ' Get a list of categories
        Public Shared Function GetCategories() As List(Of String)
            Using ctx As OUHModel = OUHModel.GetModel()
                Dim categories As New List(Of String)
                categories.Add(_categoryFilterString)
                categories.AddRange(ctx.OrganizationUnitSet _
                                       .Select(Function(ou) ou.OrganizationCategoryName) _
                                       .Distinct() _
                                       .OrderBy(Function(c) c) _
                                       .ToList())
                Return categories
            End Using
        End Function

        ' Get a list of all organizations
        Public Shared Function GetOrganizations() As List(Of Organization)
            Return GetOrganizations(_clientFilterID, _categoryFilterString)
        End Function

        ' Get a list of organizations filtered by client and category
        Public Shared Function GetOrganizations(ByVal clientID As Integer, ByVal category As String) _
                               As List(Of Organization)
            Using ctx As OUHModel = OUHModel.GetModel()
                Return ctx.OrganizationSet.Include("ClientOrganization") _
                          .Where(Function(o) (clientID = _clientFilterID) Or (o.ClientOrganization.Any(Function(oc) oc.ClientID = clientID))) _
                          .Where(Function(o) (category = _categoryFilterString) Or _
                                     (ctx.OrganizationUnitSet _
                                         .Where(Function(ou) ou.Organization.OrganizationID = o.OrganizationID) _
                                         .Where(Function(ou) ou.OrganizationCategoryName = category) _
                                         .Any())) _
                          .OrderBy(Function(o) o.OrganizationName) _
                          .ToList()
            End Using
        End Function

        ' Get a list of the organizations corresponding to a set of OU ids
        Public Shared Function GetOrganizationsForOUs(ByVal orgUnitIDs As Integer()) As List(Of Organization)
            Using ctx As OUHModel = OUHModel.GetModel()
                Return ctx.OrganizationUnitSet.Include("Organization") _
                                              .Where(BuildContainsExpression(Of OrganizationUnit, Integer)(Function(ou) ou.OrganizationUnitID, orgUnitIDs)) _
                                              .Select(Function(ou) ou.Organization) _
                                              .Distinct() _
                                              .OrderBy(Function(o) o.OrganizationName) _
                                              .ToList()
            End Using
        End Function

        ' Get a list of all the OUs for an organization
        Public Shared Function GetOUsForOrganization(ByVal organization As Organization) As List(Of vw_OrganizationUnit)
            Using ctx As OUHModel = OUHModel.GetModel()
                Return ctx.vw_OrganizationUnit _
                          .Where(Function(ou) ou.OrganizationID = organization.OrganizationID) _
                          .ToList()
            End Using
        End Function
#End Region

#Region "Authentication Methods"
        ' Get a list of the OUs for a given member
        Public Shared Function GetMemberOUs(ByVal member As Member) As Integer()
            Using ctx As OUHModel = OUHModel.GetModel()
                Return ctx.MemberOrganizationUnit _
                          .Where(Function(mou) mou.Member = member.UserName) _
                          .Select(Function(mou) mou.OrganizationUnitID) _
                          .ToArray()
            End Using
        End Function

        ' Set the list of OUs for a given member
        Public Shared Sub SetMemberOUs(ByVal member As Member, ByVal orgUnitIDs As Integer())
            Using ctx As OUHModel = OUHModel.GetModel()
                ' clear current member ous
                Dim memberOrgUnits As List(Of MemberOrganizationUnit)
                memberOrgUnits = ctx.MemberOrganizationUnit _
                                    .Where(Function(mou) mou.Member = member.UserName) _
                                    .ToList()
                For Each memberOrgUnit As MemberOrganizationUnit In memberOrgUnits
                    ctx.DeleteObject(memberOrgUnit)
                Next
                ctx.SaveChanges()

                ' save new member ous
                For Each orgUnitID As Integer In orgUnitIDs
                    Dim memberOrgUnit As New MemberOrganizationUnit
                    memberOrgUnit.MemberID = member.MemberId
                    memberOrgUnit.Member = member.UserName
                    memberOrgUnit.OrganizationUnit = ctx.OrganizationUnitSet _
                                                        .First(Function(ou) ou.OrganizationUnitID = orgUnitID)
                    ctx.AddToMemberOrganizationUnit(memberOrgUnit)
                Next
                ctx.SaveChanges()
            End Using
        End Sub

        ' Get a list of OUs for a given group
        Public Shared Function GetGroupOUs(ByVal group As Group) As Integer()
            Using ctx As OUHModel = OUHModel.GetModel()
                Return ctx.GroupOrganizationUnit _
                          .Where(Function(gou) gou.GroupID = group.GroupId) _
                          .Select(Function(gou) gou.OrganizationUnitID) _
                          .ToArray()
            End Using
        End Function

        ' Set the list of OUs for a given group
        Public Shared Sub SetGroupOUs(ByVal group As Group, ByVal orgUnitIDs As Integer())
            Using ctx As OUHModel = OUHModel.GetModel()
                ' clear current group ous
                Dim groupOrgUnits As List(Of GroupOrganizationUnit)
                groupOrgUnits = ctx.GroupOrganizationUnit _
                                .Where(Function(gou) gou.GroupID = group.GroupId) _
                                .ToList()
                For Each groupOrgUnit As GroupOrganizationUnit In groupOrgUnits
                    ctx.DeleteObject(groupOrgUnit)
                Next
                ctx.SaveChanges()

                'save new member ous
                For Each orgUnitID As Integer In orgUnitIDs
                    Dim groupOrgUnit As New GroupOrganizationUnit
                    groupOrgUnit.GroupID = group.GroupId
                    groupOrgUnit.OrganizationUnit = ctx.OrganizationUnitSet _
                                                        .First(Function(ou) ou.OrganizationUnitID = orgUnitID)
                    ctx.AddToGroupOrganizationUnit(groupOrgUnit)
                Next
                ctx.SaveChanges()
            End Using
        End Sub
#End Region

#Region "Private Methods"

        ' This is necessary in order to do "Contains" in EF1.
        ' See http://stackoverflow.com/questions/1554663/composing-linq-to-entity-query-from-multiple-parameters
        ' TODO - upgrade EF and ditch this
        Private Shared Function BuildContainsExpression(Of TElement, TValue)( _
                                    ByVal valueSelector As Expression(Of Func(Of TElement, TValue)), _
                                    ByVal values As IEnumerable(Of TValue) _
                                    ) As Expression(Of Func(Of TElement, Boolean))
            Dim p As ParameterExpression = valueSelector.Parameters.Single()
            If Not values.Any Then
                Return _
                    Function(e) False
            End If

            Dim equals As IEnumerable(Of BinaryExpression) = values.Select( _
                Function(v) _
                    Expression.Equal(valueSelector.Body, Expression.Constant(v, GetType(TValue))) _
            )

            Dim body As BinaryExpression = equals.Aggregate( _
                Function(accumulate, equal) _
                    Expression.Or(accumulate, equal) _
            )

            Return Expression.Lambda(Of Func(Of TElement, Boolean))(body, p)
        End Function

#End Region

    End Class
End Namespace