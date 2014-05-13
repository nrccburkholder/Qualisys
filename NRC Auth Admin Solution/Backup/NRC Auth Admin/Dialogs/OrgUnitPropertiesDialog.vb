Imports Nrc.NRCAuthLib

Public Class OrgUnitPropertiesDialog

    Private WithEvents mPropertiesEditor As OrgUnitPropertiesEditor

    Public ReadOnly Property OrgUnit() As OrgUnit
        Get
            Return mPropertiesEditor.OrgUnit
        End Get
    End Property

    Public Sub New(ByVal parentOrgUnit As OrgUnit, ByVal org As OrgUnit)
        ' This call is required by the Windows Form Designer.
        Me.InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Init(parentOrgUnit, org)
    End Sub

    Public Sub New(ByVal parentOrgUnit As OrgUnit)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Init(parentOrgUnit, Nothing)
    End Sub

    Private Sub Init(ByVal parentOrgUnit As OrgUnit, ByVal org As OrgUnit)
        If org Is Nothing Then
            Me.Caption = "Create New Organizational Unit"
            Me.mPropertiesEditor = New OrgUnitPropertiesEditor(parentOrgUnit)
        Else
            Me.Caption = org.Name & " Properties"
            Me.mPropertiesEditor = New OrgUnitPropertiesEditor(parentOrgUnit, org)
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
            MessageBox.Show(ex.ToString, "Error Saving Organizational Unit Properties", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
