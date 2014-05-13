Imports Nrc.NRCAuthLib

Public Class MemberGrid

    Private mShowToolStrip As Boolean = True
    Private mAllowNewMember As Boolean = True
    Private mIsAbbreviated As Boolean
    Public Event SelectionChanged As EventHandler
    Public Event CreateNewMemberButtonClicked As EventHandler
    Public Event DeleteMemberButtonClicked As EventHandler

#Region " Public Properties "
    <System.ComponentModel.Category("Appearance")> _
       Public Property IsAbbreviated() As Boolean
        Get
            Return mIsAbbreviated
        End Get
        Set(ByVal value As Boolean)
            Me.mIsAbbreviated = value
            Me.colOccupationalTitle.Visible = (Not mIsAbbreviated)
            Me.colEmailAddress.Visible = (Not mIsAbbreviated)
            Me.colDateCreated.Visible = (Not mIsAbbreviated)
            Me.colLastLoginDate.Visible = (Not mIsAbbreviated)
            Me.colFacility.Visible = (Not mIsAbbreviated)

            Me.GridView1.OptionsView.ShowGroupPanel = (Not mIsAbbreviated)

            If mIsAbbreviated Then
                Me.MemberGridControl.ContextMenuStrip = Nothing
            Else
                Me.MemberGridControl.ContextMenuStrip = Me.MemberMenu
            End If
        End Set
    End Property

    <System.ComponentModel.Category("Behavior")> _
    Public Property MultiSelect() As Boolean
        Get
            'Return Me.MemberGridView.MultiSelect
            Return Me.GridView1.OptionsSelection.MultiSelect
        End Get
        Set(ByVal value As Boolean)
            'Me.MemberGridView.MultiSelect = value
            Me.GridView1.OptionsSelection.MultiSelect = value
        End Set
    End Property

    <System.ComponentModel.Category("Appearance")> _
    Public Property ShowToolStrip() As Boolean
        Get
            Return Me.mShowToolStrip
        End Get
        Set(ByVal value As Boolean)
            Me.mShowToolStrip = value

            Me.MemberTools.Visible = mShowToolStrip
        End Set
    End Property

    <System.ComponentModel.Category("Behavior")> _
    Public Property AllowCreateNewMember() As Boolean
        Get
            Return Me.mAllowNewMember
        End Get
        Set(ByVal value As Boolean)
            Me.mAllowNewMember = value

            Me.NewMemberButton.Visible = mAllowNewMember
            Me.ToolStripSeparator1.Visible = mAllowNewMember
        End Set
    End Property

    <System.ComponentModel.Browsable(False)> _
    Public ReadOnly Property SelectedMembers() As MemberCollection
        Get
            Dim list As New MemberCollection
            Dim selectedRows() As Integer = Me.GridView1.GetSelectedRows

            For Each i As Integer In selectedRows
                If i >= 0 Then
                    Dim mbr As Member = DirectCast(Me.GridView1.GetRow(i), Member)
                    If mbr IsNot Nothing Then
                        list.Add(mbr)
                    End If
                End If
            Next

            Return list
        End Get
    End Property
    <System.ComponentModel.Category("Appearance")> _
    Public Property ShowGroupingFilter() As Boolean
        Get
            Return GridView1.OptionsView.ShowGroupPanel Or GridView1.OptionsView.ShowAutoFilterRow
        End Get
        Set(ByVal value As Boolean)
            GridView1.OptionsView.ShowGroupPanel = value
            GridView1.OptionsView.ShowAutoFilterRow = value
        End Set
    End Property
#End Region

#Region " Private Properties "
    Private ReadOnly Property SelectedMember() As Member
        Get
            If Me.SelectedMembers.Count = 1 Then
                Return Me.SelectedMembers(0)
            Else
                Return Nothing
            End If
        End Get
    End Property

#Region " Command Enabled Properties "
    Private Property IsEditProfileEnabled() As Boolean
        Get
            Return Me.EditProfileButton.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.EditProfileButton.Enabled = value
            Me.EditProfileMenuItem.Enabled = value
        End Set
    End Property

    Private Property IsEditPrivilegesEnabled() As Boolean
        Get
            Return Me.EditPrivilegesButton.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.EditPrivilegesButton.Enabled = value
            Me.EditPrivilegesMenuItem.Enabled = value
        End Set
    End Property

    Private Property IsDeleteMemberEnabled() As Boolean
        Get
            Return Me.DeleteMemberButton.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.DeleteMemberButton.Enabled = value
            Me.DeleteMemberMenuItem.Enabled = value
        End Set
    End Property

    Private Property IsResetPasswordEnabled() As Boolean
        Get
            Return Me.ResetPasswordMenuItem.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.ResetPasswordMenuItem.Enabled = value
        End Set
    End Property
#End Region

#End Region

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.RepositoryItemDateEdit1.NullDate = DateTime.MinValue
    End Sub


#Region " Public Methods "
    Public Sub Populate(ByVal members As MemberCollection)
        Me.MemberBindingSource.DataSource = members
        ResetRowSelections()
    End Sub
    Public Sub ClearSelection()
        GridView1.ClearSelection()
    End Sub
    Public Sub SelectMember(ByVal MemberToSelect As Member)
        For i As Integer = 0 To GridView1.RowCount - 1
            If DirectCast(Me.GridView1.GetRow(i), Member).MemberId = MemberToSelect.MemberId Then
                GridView1.SelectRow(i)
                Exit Sub
            End If
        Next
    End Sub
#End Region

#Region " Control Event Handlers "

    Private Sub GridView1_SelectionChanged(ByVal sender As Object, ByVal e As DevExpress.Data.SelectionChangedEventArgs) Handles GridView1.SelectionChanged
        Me.ToggleEnabledCommands()
        RaiseEvent SelectionChanged(sender, e)
    End Sub

    Private Sub EditPrivilegesMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditPrivilegesMenuItem.Click
        Me.EditPrivilegesCommand()
    End Sub

    Private Sub EditProfileMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditProfileMenuItem.Click
        Me.EditProfileCommand()
    End Sub

    Private Sub MemberMenu_Opening(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MemberMenu.Opening
        If Me.GridView1.FocusedRowHandle < 0 Then
            e.Cancel = True
        End If
    End Sub

    Private Sub EditProfileButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditProfileButton.Click
        Me.EditProfileCommand()
    End Sub

    Private Sub EditPrivilegesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditPrivilegesButton.Click
        Me.EditPrivilegesCommand()
    End Sub

    Private Sub NewMemberButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewMemberButton.Click
        RaiseEvent CreateNewMemberButtonClicked(Me, EventArgs.Empty)
    End Sub

    Private Sub ResetPasswordMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResetPasswordMenuItem.Click
        Me.ResetPasswordCommand()
    End Sub

    Private Sub DeleteMemberMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteMemberMenuItem.Click
        Me.DeleteMemberCommand()
    End Sub

    Private Sub DeleteMemberButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteMemberButton.Click
        Me.DeleteMemberCommand()
    End Sub

    Private Sub ExportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportButton.Click
        FileDialog.FileName = ""
        If FileDialog.ShowDialog = DialogResult.OK Then
            Me.colIsAccountLocked.Visible = False
            Select Case FileDialog.FilterIndex
                Case 1
                    Me.GridView1.ExportToXls(FileDialog.FileName)
                Case 2
                    Me.GridView1.ExportToHtml(FileDialog.FileName)
                Case 3
                    Me.GridView1.ExportToText(FileDialog.FileName)
            End Select
            Me.colIsAccountLocked.Visible = True
            System.Diagnostics.Process.Start(FileDialog.FileName)
        End If
    End Sub
#End Region

#Region " Private Methods "
    Private Sub EditPrivilegesCommand()
        If Me.GridView1.SelectedRowsCount > 1 Then
            Dim frm As New PrivilegeEditorDialog(Me.SelectedMembers)
            frm.ShowDialog()
        Else
            If Me.SelectedMember IsNot Nothing Then
                Dim frm As New PrivilegeEditorDialog(Me.SelectedMember)
                frm.ShowDialog()
            End If
        End If
    End Sub

    Private Sub EditProfileCommand()
        If Me.SelectedMember IsNot Nothing Then
            Dim frm As New MemberProfileDialog(Me.SelectedMember.OrgUnit, Me.SelectedMember)
            frm.ShowDialog()
        End If
    End Sub

    Private Sub ResetPasswordCommand()
        If Me.SelectedMember IsNot Nothing Then
            Dim frm As New ResetPasswordDialog(Me.SelectedMember)
            frm.ShowDialog()
        End If
    End Sub

    Private Sub DeleteMemberCommand()
        RaiseEvent DeleteMemberButtonClicked(Me, EventArgs.Empty)
    End Sub

    Private Sub ResetRowSelections()
        Dim selectedRows() As Integer = Me.GridView1.GetSelectedRows()
        For Each row As Integer In selectedRows
            Me.GridView1.UnselectRow(row)
        Next
        'Me.GridView1.SelectRows(0, 0)
        Me.GridView1.FocusedRowHandle = 0
        Me.GridView1.SelectRow(0)
    End Sub

    Private Sub ToggleEnabledCommands()
        Dim rowCount As Integer = Me.GridView1.SelectedRowsCount

        Me.IsEditProfileEnabled = (rowCount = 1)
        Me.IsEditPrivilegesEnabled = (rowCount > 0)
        Me.IsDeleteMemberEnabled = (rowCount >= 1)
        Me.IsResetPasswordEnabled = (rowCount = 1)
    End Sub

#End Region

End Class
