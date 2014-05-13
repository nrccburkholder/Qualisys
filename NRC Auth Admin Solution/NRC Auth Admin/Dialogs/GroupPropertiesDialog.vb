Imports Nrc.NRCAuthLib

Public Class GroupPropertiesDialog

    Private WithEvents mPropertiesEditor As GroupPropertiesEditor

    Public Sub New(ByVal org As OrgUnit, ByVal grp As Group)
        ' This call is required by the Windows Form Designer.
        Me.InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Init(org, grp)
    End Sub

    Public Sub New(ByVal org As OrgUnit)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Init(org, Nothing)
    End Sub

    Private Sub Init(ByVal org As OrgUnit, ByVal grp As Group)
        If grp Is Nothing Then
            Me.Caption = "Create New Group"
            Me.mPropertiesEditor = New GroupPropertiesEditor(org)
        Else
            Me.Caption = grp.Name & " Group Properties"
            Me.mPropertiesEditor = New GroupPropertiesEditor(org, grp)
        End If

        Me.mPropertiesEditor.Dock = DockStyle.Fill

        Me.FlowLayoutPanel1.Controls.Clear()
        Me.FlowLayoutPanel1.Controls.Add(Me.mPropertiesEditor)
        Me.FlowLayoutPanel1.Controls.Add(Me.TableLayoutPanel2)

        Me.OK_Button.Enabled = Me.mPropertiesEditor.AllowSave()
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Try
            Me.mPropertiesEditor.SaveProperties()
            Me.DialogResult = System.Windows.Forms.DialogResult.OK
            Me.Close()
        Catch ex As Exception
            MessageBox.Show(ex.ToString, "Error Saving Group Properties", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub mPropertyEditor_AllowSaveChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mPropertiesEditor.AllowSaveChanged
        Me.OK_Button.Enabled = Me.mPropertiesEditor.AllowSave
    End Sub

End Class
