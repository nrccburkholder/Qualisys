Imports Nrc.NRCAuthLib

Public Class GroupMemberEditor

#Region " Private Members "
    Private mOrgUnit As OrgUnit
    Private mGroup As Group

    Private mOrgUnitMembers As MemberCollection
    Private mGroupMembers As MemberCollection
#End Region

#Region " Private Properties "
    Private ReadOnly Property OrgUnit() As OrgUnit
        Get
            Return Me.mOrgUnit
        End Get
    End Property

    Private ReadOnly Property Group() As Group
        Get
            Return mGroup
        End Get
    End Property
#End Region

    Public Sub Populate(ByVal selectedOrgUnit As OrgUnit, ByVal selectedGroup As Group)
        Me.mOrgUnit = selectedOrgUnit
        Me.mGroup = selectedGroup

        If Me.OrgUnit Is Nothing OrElse Me.Group Is Nothing Then
            Me.Enabled = False
            Me.OrgUnitMembers.Populate(Nothing)
            Me.GroupMembers.Populate(Nothing)
            Exit Sub
        Else
            Me.Enabled = True
        End If

        Me.mOrgUnitMembers = New MemberCollection
        Me.mGroupMembers = New MemberCollection

        Dim orgUnitMembersDictionary As New Dictionary(Of Integer, Member)
        For Each mbr As Member In Me.OrgUnit.Members
            orgUnitMembersDictionary.Add(mbr.MemberId, mbr)
        Next

        Dim grpMembers As MemberCollection = MemberCollection.GetGroupMembers(Me.Group.GroupId)
        For Each mbr As Member In grpMembers
            Me.mGroupMembers.Add(mbr)
            orgUnitMembersDictionary.Remove(mbr.MemberId)
        Next

        'For Each mbr As Member In Me.OrgUnit.Members
        '    If mbr.IsInGroup(Me.Group.Name) Then
        '        Me.mGroupMembers.Add(mbr)

        '        orgUnitMembersDictionary.Remove(mbr.MemberId)
        '    End If
        'Next

        For Each mbr As Member In orgUnitMembersDictionary.Values
            Me.mOrgUnitMembers.Add(mbr)
        Next

        Me.OrgUnitMembers.Populate(Me.mOrgUnitMembers)
        Me.GroupMembers.Populate(Me.mGroupMembers)
    End Sub

    Private Sub AddButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddButton.Click
        If Me.OrgUnitMembers.SelectedMembers.Count > 0 Then
            For Each mbr As Member In Me.OrgUnitMembers.SelectedMembers
                mbr.AddToGroup(Me.Group.GroupId, CurrentUser.Member.MemberId)
            Next

            'Refresh lists
            Me.Populate(Me.OrgUnit, Me.Group)
        End If

    End Sub

    Private Sub RemoveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoveButton.Click
        If Me.GroupMembers.SelectedMembers.Count > 0 Then
            For Each mbr As Member In Me.GroupMembers.SelectedMembers
                Me.Group.RemoveMemberFromGroup(mbr.MemberId, CurrentUser.Member.MemberId)

                'Manualy remove the group from the member object
                For i As Integer = 0 To mbr.Groups.Count - 1
                    If mbr.Groups(i).GroupId = Me.Group.GroupId Then
                        mbr.Groups.RemoveAt(i)
                        Exit For
                    End If
                Next
            Next

            'Refresh lists
            Me.Populate(Me.OrgUnit, Me.Group)
        End If

    End Sub
End Class
