Imports Nrc.NRCAuthLib

Public Class MemberGroupEditor


#Region " Private Members "
    Private mOrgUnit As OrgUnit
    Private mMember As Member

    Private mOrgUnitGroups As GroupCollection
    Private mMemberGroups As GroupCollection
#End Region

#Region " Private Properties "
    Private ReadOnly Property OrgUnit() As OrgUnit
        Get
            Return Me.mOrgUnit
        End Get
    End Property

    Private ReadOnly Property Member() As Member
        Get
            Return mMember
        End Get
    End Property
#End Region

    Public Sub Populate(ByVal selectedOrgUnit As OrgUnit, ByVal selectedMember As Member)
        Me.mOrgUnit = selectedOrgUnit
        Me.mMember = selectedMember

        If Me.OrgUnit Is Nothing OrElse Me.Member Is Nothing Then
            Me.Enabled = False
            Me.SectionPanel2.Caption = "Member's Groups"
            Me.OrgUnitGroups.Populate(Nothing)
            Me.MemberGroups.Populate(Nothing)
            Exit Sub
        Else
            Me.SectionPanel2.Caption = selectedMember.Name & "'s Groups"
            Me.Enabled = True
        End If

        Me.mOrgUnitGroups = New GroupCollection
        Me.mMemberGroups = New GroupCollection

        Dim orgUnitGroupsDictionary As New Dictionary(Of Integer, Group)
        For Each grp As Group In Me.OrgUnit.Groups
            orgUnitGroupsDictionary.Add(grp.GroupId, grp)
        Next

        For Each grp As Group In Me.Member.Groups
            Me.mMemberGroups.Add(grp)
            orgUnitGroupsDictionary.Remove(grp.GroupId)
        Next

        For Each grp As Group In orgUnitGroupsDictionary.Values
            Me.mOrgUnitGroups.Add(grp)
        Next

        Me.OrgUnitGroups.Populate(Me.mOrgUnitGroups)
        Me.MemberGroups.Populate(Me.mMemberGroups)
    End Sub

    Private Sub AddButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddButton.Click
        If Me.OrgUnitGroups.SelectedGroups.Count > 0 Then
            For Each grp As Group In Me.OrgUnitGroups.SelectedGroups
                Me.Member.AddToGroup(grp.GroupId, CurrentUser.Member.MemberId)
            Next

            'Refresh lists
            Me.Populate(Me.OrgUnit, Me.Member)
        End If
    End Sub

    Private Sub RemoveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoveButton.Click
        If Me.MemberGroups.SelectedGroups.Count > 0 Then
            For Each grp As Group In Me.MemberGroups.SelectedGroups
                grp.RemoveMemberFromGroup(Me.Member.MemberId, CurrentUser.Member.MemberId)

                'Manualy remove the group from the member object
                For i As Integer = 0 To Me.Member.Groups.Count - 1
                    If Me.Member.Groups(i).GroupId = grp.GroupId Then
                        Me.Member.Groups.RemoveAt(i)
                        Exit For
                    End If
                Next
            Next

            'Refresh the lists
            Me.Populate(Me.OrgUnit, Me.Member)
        End If
    End Sub
End Class
