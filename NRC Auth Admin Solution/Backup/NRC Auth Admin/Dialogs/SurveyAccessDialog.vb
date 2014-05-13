Imports Nrc.NRCAuthLib

Public Class SurveyAccessDialog

    Private mEditor As SurveyAccessEditor

    Public Sub New(ByVal org As OrgUnit)
        InitializeComponent()

        'Work around to fix object reference problems with NRCAuth
        Dim editOrg As OrgUnit = OrgUnit.GetOrgUnit(org.OrgUnitId)

        mEditor = New OrgUnitSurveyAccessEditor(editOrg)
    End Sub

    Public Sub New(ByVal grp As Group)
        InitializeComponent()

        'Work around to fix object reference problems with NRCAuth
        Dim editGrp As Group = Group.GetGroup(grp.GroupId)

        mEditor = New GroupSurveyAccessEditor(editGrp)
    End Sub

    Private Sub SurveyAccessDialog_Load(ByVal sender As Object, ByVal e As EventArgs) Handles MyBase.Load
        If mEditor IsNot Nothing Then
            mEditor.Dock = DockStyle.Fill
            Me.EditorPanel.Controls.Clear()
            Me.EditorPanel.Controls.Add(mEditor)
        End If
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Me.mEditor.SaveChanges()
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

End Class
