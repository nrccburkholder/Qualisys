Imports System.text
Imports NRC.Data

''' <summary>
''' Stores a collection of Member objects
''' </summary>
<Serializable()> _
Public Class MemberCollection
    Inherits CollectionBase

#Region " Public Properties "

    Default Public ReadOnly Property Item(ByVal index As Integer) As Member
        Get
            Return DirectCast(MyBase.List(index), Member)
        End Get
    End Property

#End Region

#Region " Public Methods "

    Public Function Add(ByVal mbr As Member) As Integer
        Return MyBase.List.Add(mbr)
    End Function

    Public Shared Function GetOrgUnitMembers(ByVal orgUnitId As Integer) As MemberCollection
        'Dim rdr As IDataReader = DAL.SelectOrgUnitMembers(orgUnitId)
        'Dim members As IList = New MemberCollection
        'Return DirectCast(Populator.FillCollection(rdr, GetType(Member), members), MemberCollection)
        Dim rdr As IDataReader = DAL.SelectOrgUnitMembers(orgUnitId)
        Dim list As New MemberCollection

        Try
            While rdr.Read
                list.Add(New Member(rdr))
            End While
        Finally
            If Not rdr Is Nothing AndAlso Not rdr.IsClosed Then
                rdr.Dispose()
            End If
        End Try

        Return list
    End Function

    Public Shared Function GetGroupMembers(ByVal groupId As Integer) As MemberCollection
        'Dim rdr As IDataReader = DAL.SelectGroupMembers(groupId)
        'Dim members As IList = New MemberCollection
        'Return DirectCast(Populator.FillCollection(rdr, GetType(Member), members), MemberCollection)
        Dim rdr As IDataReader = DAL.SelectGroupMembers(groupId)
        Dim list As New MemberCollection

        Try
            While rdr.Read
                list.Add(New Member(rdr))
            End While
        Finally
            If Not rdr Is Nothing AndAlso Not rdr.IsClosed Then
                rdr.Dispose()
            End If
        End Try

        Return list
    End Function

    Public Shared Function GetMembersByIds(ByVal memberIds() As Integer) As MemberCollection
        If (memberIds Is Nothing) Then Return Nothing

        Dim ids As New StringBuilder
        Dim list As New MemberCollection

        For i As Integer = 0 To memberIds.Length - 1
            If (ids.Length >= 7950) Then
                GetMembersByIds(list, ids)
                ids.Remove(0, ids.Length)
            End If
            If (ids.Length > 0) Then ids.Append(",")
            ids.Append(memberIds(i))
        Next

        If (ids.Length > 0) Then
            GetMembersByIds(list, ids)
        End If

        Return list
    End Function

    ''' <summary>Gets a collection of usernames associated with the provided email
    ''' address</summary>
    ''' <author>Steve Kennedy</author>
    ''' <revision>SK - Initial Creation</revision>
    Public Shared Function GetMembersByEmailAddress(ByVal emailAddress As String) As MemberCollection

        Dim rdr As IDataReader = DAL.SelectMembersByEmailAddress(emailAddress)
        Dim list As New MemberCollection

        Try
            While rdr.Read
                list.Add(New Member(rdr))
            End While
        Finally
            If Not rdr Is Nothing AndAlso Not rdr.IsClosed Then
                rdr.Dispose()
            End If
        End Try

        Return list


    End Function

#End Region

#Region " Private Methods"

    Private Shared Sub GetMembersByIds(ByVal list As MemberCollection, ByVal ids As StringBuilder)
        Dim rdr As IDataReader = DAL.SelectMembers(ids.ToString)
        Try
            While rdr.Read
                list.Add(New Member(rdr))
            End While
        Finally
            If Not rdr Is Nothing AndAlso Not rdr.IsClosed Then
                rdr.Dispose()
            End If
        End Try
    End Sub



#End Region

End Class
