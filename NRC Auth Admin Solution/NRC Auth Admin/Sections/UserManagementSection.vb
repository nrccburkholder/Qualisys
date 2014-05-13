Imports Nrc.NRCAuthLib

Public Class UserManagementSection

#Region " Private Members "
    Private Enum DisplayMode
        MemberMode = 1
        GroupMode = 2
    End Enum

    Private mOrgUnitNavigator As OrgUnitNavigator
    Private mDisplayMode As DisplayMode = DisplayMode.MemberMode
    Private Event DisplayModeChanged As EventHandler
    Private WithEvents mGroupMemberEditor As New GroupMemberEditor
    Private WithEvents mMemberGroupEditor As New MemberGroupEditor
    Private mSelectedOrgUnit As OrgUnit
#End Region

#Region " Private Properties "
    Private ReadOnly Property SelectedGroup() As Group
        Get
            If Me.GroupGrid.SelectedGroups.Count = 1 Then
                Return Me.GroupGrid.SelectedGroups(0)
            Else
                Return Nothing
            End If
        End Get
    End Property

    Private ReadOnly Property SelectedMember() As Member
        Get
            If Me.MemberGrid.SelectedMembers.Count = 1 Then
                Return Me.MemberGrid.SelectedMembers(0)
            Else
                Return Nothing
            End If
        End Get
    End Property
#End Region

#Region " Control Event Handlers "
    Private Sub UserManagementSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.ToggleMode(DisplayMode.MemberMode)
        Me.Enabled = (Me.mSelectedOrgUnit IsNot Nothing)
    End Sub

    Private Sub MemberModeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MemberModeButton.Click
        If Not Me.MemberModeButton.Checked Then
            Me.ToggleMode(DisplayMode.MemberMode)
        End If
    End Sub

    Private Sub GroupModeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GroupModeButton.Click
        If Not Me.GroupModeButton.Checked Then
            Me.ToggleMode(DisplayMode.GroupMode)
        End If
    End Sub

    Private Sub UserManagement_DisplayModeChanged(ByVal sender As Object, ByVal e As EventArgs) Handles Me.DisplayModeChanged
        Select Case mDisplayMode
            Case DisplayMode.MemberMode
                Me.TopPanelLabel.Text = "Members"
            Case DisplayMode.GroupMode
                Me.TopPanelLabel.Text = "Groups"
        End Select

        Me.MemberGrid.Visible = (Me.mDisplayMode = DisplayMode.MemberMode)
        Me.GroupGrid.Visible = (Me.mDisplayMode = DisplayMode.GroupMode)
        Me.MemberGrid.Dock = DockStyle.Fill
        Me.GroupGrid.Dock = DockStyle.Fill

        If Me.mSelectedOrgUnit IsNot Nothing Then
            Me.Populate()
        End If
    End Sub

    Private Sub mOrgUnitNavigator_SelectedOrgUnitChanged(ByVal sender As Object, ByVal e As OrgUnitNavigator.SelectedOrgUnitChangedEventArgs)
        Me.GetSelectedOrgUnit()
        Me.Enabled = (Me.mSelectedOrgUnit IsNot Nothing)
        Me.Populate()
    End Sub

    Private Sub MemberGrid_CreateNewMemberButtonClicked(ByVal sender As Object, ByVal e As System.EventArgs) Handles MemberGrid.CreateNewMemberButtonClicked
        Dim frm As New MemberProfileDialog(Me.mSelectedOrgUnit)
        If frm.ShowDialog = DialogResult.OK Then
            Me.GetSelectedOrgUnit()
            Me.Populate()
        End If
    End Sub

    Private Sub MemberGrid_DeleteMemberButtonClicked(ByVal sender As Object, ByVal e As System.EventArgs) Handles MemberGrid.DeleteMemberButtonClicked
        If MessageBox.Show("Do you want to delete the selected member(s)?", "Confirm Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
            'Delete the members
            For Each selMember As Member In Me.MemberGrid.SelectedMembers
                Member.DeleteMember(selMember.MemberId, CurrentUser.Member.MemberId)
            Next

            'Refresh the form
            Me.GetSelectedOrgUnit()
            Me.Populate()
        End If
    End Sub

    Private Sub MemberGrid_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles MemberGrid.SelectionChanged
        Me.mMemberGroupEditor.Populate(Me.mSelectedOrgUnit, Me.SelectedMember)
    End Sub

    Private Sub GroupGrid_CreateGroupButtonClicked(ByVal sender As Object, ByVal e As System.EventArgs) Handles GroupGrid.CreateGroupButtonClicked
        Dim frm As New GroupPropertiesDialog(Me.mSelectedOrgUnit)
        If frm.ShowDialog = DialogResult.OK Then
            Me.GetSelectedOrgUnit()
            Me.Populate()
        End If
    End Sub

    Private Sub GroupGrid_DeleteGroupButtonClicked(ByVal sender As Object, ByVal e As System.EventArgs) Handles GroupGrid.DeleteGroupButtonClicked
        If MessageBox.Show("Are you sure you want to delete this group?", "Confirm Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
            'Delete the group
            Group.DeleteGroup(Me.SelectedGroup.GroupId, CurrentUser.Member.MemberId)

            'Refresh the form
            Me.GetSelectedOrgUnit()
            Me.Populate()
        End If
    End Sub

    Private Sub GroupGrid_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GroupGrid.SelectionChanged
        Me.mGroupMemberEditor.Populate(Me.mSelectedOrgUnit, Me.SelectedGroup)
    End Sub


#End Region

#Region " Base Class Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        Me.mOrgUnitNavigator = TryCast(navCtrl, OrgUnitNavigator)
        If Me.mOrgUnitNavigator Is Nothing Then
            Throw New Exception("The UserManagementSection control expects a Navigation control of type GroupNavigator.")
        End If
    End Sub

    Public Overrides Function AllowInactivate() As Boolean
        Return True
    End Function

    Public Overrides Sub ActivateSection()
        AddHandler mOrgUnitNavigator.SelectedOrgUnitChanged, AddressOf mOrgUnitNavigator_SelectedOrgUnitChanged
        mOrgUnitNavigator.ShowGroupSelector = False
    End Sub

    Public Overrides Sub InactivateSection()
        RemoveHandler mOrgUnitNavigator.SelectedOrgUnitChanged, AddressOf mOrgUnitNavigator_SelectedOrgUnitChanged
    End Sub

#End Region

#Region " Private Methods "
    Private Sub GetSelectedOrgUnit()
        If Me.mOrgUnitNavigator.SelectedOrgUnitId > 0 Then
            Me.mSelectedOrgUnit = OrgUnit.GetOrgUnit(Me.mOrgUnitNavigator.SelectedOrgUnitId)
        Else
            Me.mSelectedOrgUnit = Nothing
        End If
    End Sub


    Private Sub ToggleMode(ByVal mode As DisplayMode)
        Me.mDisplayMode = mode
        Me.MemberModeButton.Checked = (mode = DisplayMode.MemberMode)
        Me.GroupModeButton.Checked = (mode = DisplayMode.GroupMode)

        Select Case mode
            Case DisplayMode.MemberMode
                Me.MemberModeButton.ForeColor = Color.Black
                Me.GroupModeButton.ForeColor = Color.White
            Case DisplayMode.GroupMode
                Me.MemberModeButton.ForeColor = Color.White
                Me.GroupModeButton.ForeColor = Color.Black
        End Select

        RaiseEvent DisplayModeChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub Populate()
        Dim ctrl As Control
        Me.MainSplitPanel.Panel2.Controls.Clear()

        Select Case Me.mDisplayMode
            Case DisplayMode.MemberMode
                Me.MemberGrid.Populate(Me.mSelectedOrgUnit.Members)
                Me.mMemberGroupEditor.Populate(Me.mSelectedOrgUnit, Me.SelectedMember)
                ctrl = Me.mMemberGroupEditor
            Case DisplayMode.GroupMode
                Me.GroupGrid.Populate(Me.mSelectedOrgUnit.Groups)
                Me.mGroupMemberEditor.Populate(Me.mSelectedOrgUnit, Me.SelectedGroup)
                ctrl = Me.mGroupMemberEditor
            Case Else
                Throw New Exception("Unknown display mode in UserManagementSection control.")
        End Select

        ctrl.Dock = DockStyle.Fill
        Me.MainSplitPanel.Panel2.Controls.Add(ctrl)
    End Sub

#End Region

End Class
