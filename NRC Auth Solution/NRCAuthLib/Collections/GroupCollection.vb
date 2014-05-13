Imports NRC.Data

<Serializable()> _
Public Class GroupCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Group
        Get
            Return DirectCast(MyBase.List(index), Group)
        End Get
    End Property

    Public Function Add(ByVal grp As Group) As Integer
        Return MyBase.List.Add(grp)
    End Function

    Public Shared Function GetOrgUnitGroups(ByVal orgUnitId As Integer) As GroupCollection
        Dim groups As New GroupCollection
        Dim list As IList = groups
        Dim rdr As IDataReader = DAL.SelectOrgUnitGroups(orgUnitId)

        Populator.FillCollection(rdr, GetType(Group), list)
        Return groups
    End Function

    Public Shared Function GetMemberGroups(ByVal memberId As Integer) As GroupCollection
        Dim groups As New GroupCollection
        Dim list As IList = groups
        Dim rdr As IDataReader = DAL.SelectMemberGroups(memberId)

        Populator.FillCollection(rdr, GetType(Group), list)
        Return groups
    End Function

    Public Function FindByGroupId(ByVal groupId As Integer) As Group
        For Each grp As Group In MyBase.List
            If grp.GroupId = groupId Then
                Return grp
            End If
        Next

        Return Nothing
    End Function

    Public Function FindByName(ByVal groupName As String) As Group
        For Each grp As Group In MyBase.List
            If grp.Name = groupName Then
                Return grp
            End If
        Next

        Return Nothing
    End Function


End Class
