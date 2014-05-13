Imports Nrc.NRCAuthLib

Public Class GroupGrid

#Region " Private Members "
    Private mShowToolStrip As Boolean = True
    Private mAllowNewGroup As Boolean = True
    Private mIsAbbreviated As Boolean
#End Region

#Region " Public Events "
    Public Event SelectionChanged As EventHandler
    Public Event CreateGroupButtonClicked As EventHandler
    Public Event DeleteGroupButtonClicked As EventHandler
#End Region

#Region " Public Properties "
    <System.ComponentModel.Category("Appearance")> _
    Public Property IsAbbreviated() As Boolean
        Get
            Return mIsAbbreviated
        End Get
        Set(ByVal value As Boolean)
            Me.mIsAbbreviated = value
            Me.colDateCreated.Visible = (Not mIsAbbreviated)
            Me.colEmail.Visible = (Not mIsAbbreviated)

            If mIsAbbreviated Then
                Me.GroupGridControl.ContextMenuStrip = Nothing
            Else
                Me.GroupGridControl.ContextMenuStrip = Me.GroupMenu
            End If
        End Set
    End Property

    <System.ComponentModel.Category("Appearance")> _
    Public Property ShowToolStrip() As Boolean
        Get
            Return Me.mShowToolStrip
        End Get
        Set(ByVal value As Boolean)
            Me.mShowToolStrip = value

            Me.GroupTools.Visible = mShowToolStrip
        End Set
    End Property

    <System.ComponentModel.Category("Behavior")> _
    Public Property AllowCreateNewGroup() As Boolean
        Get
            Return Me.mAllowNewGroup
        End Get
        Set(ByVal value As Boolean)
            Me.mAllowNewGroup = value

            Me.CreateGroupButton.Visible = mAllowNewGroup
            Me.ToolStripSeparator1.Visible = mAllowNewGroup
        End Set
    End Property

    <System.ComponentModel.Category("Behavior")> _
    Public Property MultiSelect() As Boolean
        Get
            Return Me.GridView1.OptionsSelection.MultiSelect
        End Get
        Set(ByVal value As Boolean)
            Me.GridView1.OptionsSelection.MultiSelect = value
        End Set
    End Property

    <System.ComponentModel.Browsable(False)> _
    Public ReadOnly Property SelectedGroups() As GroupCollection
        Get
            Dim list As New GroupCollection
            Dim selectedRows() As Integer = Me.GridView1.GetSelectedRows

            For Each i As Integer In selectedRows
                If i >= 0 Then
                    Dim grp As Group = DirectCast(Me.GridView1.GetRow(i), Group)
                    If grp IsNot Nothing Then
                        list.Add(grp)
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
    Private ReadOnly Property SelectedGroup() As Group
        Get
            If Me.SelectedGroups.Count = 1 Then
                Return Me.SelectedGroups(0)
            Else
                Return Nothing
            End If
        End Get
    End Property

#Region " Command Enabled Properties "
    Private Property IsEditPropertiesEnabled() As Boolean
        Get
            Return Me.GroupPropertiesButton.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.GroupPropertiesButton.Enabled = value
            Me.EditPropertiesToolStripMenuItem.Enabled = value
        End Set
    End Property

    Private Property IsEditPrivilegesEnabled() As Boolean
        Get
            Return Me.GroupPrivilegesButton.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.GroupPrivilegesButton.Enabled = value
            Me.EditPrivilegesMenuItem.Enabled = value
        End Set
    End Property

    Private Property IsEditSurveyAccesEnabled() As Boolean
        Get
            Return Me.SurveyAccessButton.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.SurveyAccessButton.Enabled = value
            Me.EditSurveyAccessToolStripMenuItem.Enabled = value
        End Set
    End Property

    Private Property IsDeleteGroupEnabled() As Boolean
        Get
            Return Me.DeleteGroupButton.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.DeleteGroupButton.Enabled = value
            Me.DeleteGroupToolStripMenuItem.Enabled = value
        End Set
    End Property
#End Region
#End Region

#Region " Public Methods "
    Public Sub Populate(ByVal groups As GroupCollection)
        Me.GroupBindingSource.DataSource = groups
        Me.ResetRowSelections()
    End Sub
    Public Sub ClearSelection()
        GridView1.ClearSelection()
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

    Private Sub GroupMenu_Opening(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles GroupMenu.Opening
        If Me.GridView1.FocusedRowHandle < 0 Then
            e.Cancel = True
        End If
    End Sub

    Private Sub CreateGroupButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateGroupButton.Click
        'Bubble the event up to the calling control since we don't have OrgUnit context 
        RaiseEvent CreateGroupButtonClicked(Me, EventArgs.Empty)
    End Sub

    Private Sub DeleteGroupButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteGroupButton.Click
        'Bubble the event up to the calling control since we don't have OrgUnit context 
        RaiseEvent DeleteGroupButtonClicked(Me, EventArgs.Empty)
    End Sub

    Private Sub DeleteGroupToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteGroupToolStripMenuItem.Click
        'Bubble the event up to the calling control since we don't have OrgUnit context 
        RaiseEvent DeleteGroupButtonClicked(Me, EventArgs.Empty)
    End Sub

    Private Sub GroupPropertiesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GroupPropertiesButton.Click
        Me.EditPropertiesCommand()
    End Sub

    Private Sub GroupPrivilegesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GroupPrivilegesButton.Click
        Me.EditPrivilegesCommand()
    End Sub

    Private Sub SurveyAccessButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SurveyAccessButton.Click
        Me.EditSurveyAccessCommand()
    End Sub

    Private Sub EditPropertiesToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditPropertiesToolStripMenuItem.Click
        Me.EditPropertiesCommand()
    End Sub

    Private Sub EditSurveyAccessToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditSurveyAccessToolStripMenuItem.Click
        Me.EditSurveyAccessCommand()
    End Sub

    Private Sub ExportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportButton.Click
        FileDialog.FileName = ""
        If FileDialog.ShowDialog = DialogResult.OK Then
            Select Case FileDialog.FilterIndex
                Case 1
                    Me.GridView1.ExportToXls(FileDialog.FileName)
                Case 2
                    Me.GridView1.ExportToHtml(FileDialog.FileName)
                Case 3
                    Me.GridView1.ExportToText(FileDialog.FileName)
            End Select
            System.Diagnostics.Process.Start(FileDialog.FileName)
        End If
    End Sub
#End Region

#Region " Private Methods "
    Private Sub EditPrivilegesCommand()
        If Me.GridView1.SelectedRowsCount > 1 Then
            Dim frm As New PrivilegeEditorDialog(Me.SelectedGroups)
            frm.ShowDialog()
        Else
            If Me.SelectedGroup IsNot Nothing Then
                Dim frm As New PrivilegeEditorDialog(Me.SelectedGroup)
                frm.ShowDialog()
            End If
        End If
    End Sub

    Private Sub EditPropertiesCommand()
        If Me.SelectedGroup IsNot Nothing Then
            Dim frm As New GroupPropertiesDialog(Me.SelectedGroup.OrgUnit, Me.SelectedGroup)
            frm.ShowDialog()
        End If
    End Sub

    Private Sub EditSurveyAccessCommand()
        If Me.SelectedGroup IsNot Nothing Then
            Dim frm As New SurveyAccessDialog(Me.SelectedGroup)
            frm.ShowDialog()
        End If
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

        Me.IsEditPropertiesEnabled = (rowCount = 1)
        Me.IsEditPrivilegesEnabled = (rowCount > 0)
        Me.IsEditSurveyAccesEnabled = (rowCount = 1)
        Me.IsDeleteGroupEnabled = (rowCount = 1)
    End Sub
#End Region

End Class