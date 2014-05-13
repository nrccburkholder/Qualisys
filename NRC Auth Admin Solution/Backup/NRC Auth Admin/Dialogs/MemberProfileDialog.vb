Imports Nrc.NRCAuthLib

Public Class MemberProfileDialog

    Private WithEvents mProfileEditor As MemberProfileEditor

    Public Sub New(ByVal org As OrgUnit, ByVal mbr As Member)
        ' This call is required by the Windows Form Designer.
        Me.InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Init(org, mbr)
    End Sub

    Public Sub New(ByVal org As OrgUnit)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Init(org, Nothing)
    End Sub

    Private Sub Init(ByVal org As OrgUnit, ByVal mbr As Member)
        If mbr Is Nothing Then
            Me.Caption = "Create New Member"
            Me.mProfileEditor = New MemberProfileEditor(org)
        Else
            Me.Caption = "Member Profile for " & mbr.DisplayLabel
            Me.mProfileEditor = New MemberProfileEditor(org, mbr)
        End If

        Me.ProfilePanel.AutoSize = True
        Me.ProfilePanel.AutoSizeMode = Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.mProfileEditor.Dock = DockStyle.Fill
        Me.ProfilePanel.Controls.Add(Me.mProfileEditor)
        Me.OK_Button.Enabled = Me.mProfileEditor.AllowSave()
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Try
            Me.mProfileEditor.SaveProfile()
            Me.DialogResult = System.Windows.Forms.DialogResult.OK
            Me.Close()
        Catch ex As Exception
            MessageBox.Show(ex.ToString, "Error Saving Member Profile", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub mProfileEditor_AllowSaveChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mProfileEditor.AllowSaveChanged
        Me.OK_Button.Enabled = Me.mProfileEditor.AllowSave
    End Sub

End Class
