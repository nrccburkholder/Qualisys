Imports System.Windows.Forms
Imports Nrc.NRCAuthLib
Imports DevExpress.XtraPrinting

Public Class PrivilegeEditorDialog

    Private WithEvents mEditor As PrivilegeEditor

    Public Sub New(ByVal org As OrgUnit)
        InitializeComponent()

        'Work around to fix object reference problems with NRCAuth
        Dim editOrg As OrgUnit = OrgUnit.GetOrgUnit(org.OrgUnitId)

        mEditor = New OrgUnitPrivilegeEditor(editOrg)
    End Sub

    Public Sub New(ByVal grp As Group)
        InitializeComponent()

        'Work around to fix object reference problems with NRCAuth
        Dim editGroup As Group = Group.GetGroup(grp.GroupId)

        mEditor = New GroupPrivilegeEditor(editGroup)
    End Sub

    Public Sub New(ByVal groups As GroupCollection)
        InitializeComponent()

        'Work around to fix object reference problems with NRCAuth
        'Dim editGroup As Group = Group.GetGroup(grp.GroupId)

        mEditor = New GroupPrivilegeEditor(groups)
    End Sub

    Public Sub New(ByVal mbr As Member)
        InitializeComponent()

        'Work around to fix object reference problems with NRCAuth
        Dim editMember As Member = Member.GetMember(mbr.UserName)

        mEditor = New MemberPrivilegeEditor(editMember)
    End Sub

    Public Sub New(ByVal members As MemberCollection)
        InitializeComponent()

        'Work around to fix object reference problems with NRCAuth
        'Dim editMember As Member = Member.GetMember(mbr.UserName)

        mEditor = New MemberPrivilegeEditor(members)
    End Sub

    Private Sub PrivilegeEditorDialog_Load(ByVal sender As Object, ByVal e As EventArgs) Handles MyBase.Load
        If mEditor IsNot Nothing Then
            mEditor.Dock = DockStyle.Fill
            Me.Text = mEditor.PrintTitle
            Me.PrivilegeEditorPanel.Controls.Clear()
            Me.PrivilegeEditorPanel.Controls.Add(mEditor)
            Me.OK_Button.Enabled = (Not mEditor.ReadOnly)
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

    Private Sub mEditor_ReadOnlyChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mEditor.ReadOnlyChanged
        Me.OK_Button.Enabled = (Not Me.mEditor.ReadOnly)
    End Sub

    Private Sub btnPrint_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPrint.Click

        mEditor.PrivilegeTree.OptionsPrint.PrintAllNodes = False
        mEditor.PrivilegeTree.OptionsPrint.PrintVertLines = False
        mEditor.PrivilegeTree.OptionsPrint.PrintHorzLines = False

        Dim link As New PrintableComponentLink(New PrintingSystem())
        link.Component = mEditor.PrivilegeTree
        AddHandler link.CreateMarginalHeaderArea, AddressOf PrintHeaderCallback
        link.CreateDocument()
        link.ShowPreview()
    End Sub
    Public Sub PrintHeaderCallback(ByVal sender As Object, ByVal e As CreateAreaEventArgs)
        Dim info As PageInfoBrick = e.Graph.DrawPageInfo(PageInfo.Number, "", Color.Black, New RectangleF(301, 0, 15, 15), BorderSide.None)
        info.Alignment = BrickAlignment.Far
        Dim title As TextBrick = e.Graph.DrawString(mEditor.PrintTitle, Color.Black, New RectangleF(0, 18, 600, 15), BorderSide.None)
        title.Font = New Font(title.Font, FontStyle.Bold)

    End Sub

    Private Sub btnExpand_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExpand.Click
        If Convert.ToInt32(btnExpand.Tag) = 0 Then
            mEditor.PrivilegeTree.ExpandAll()
            btnExpand.Image = My.Resources.GroupCollapse15
            btnExpand.Text = "Collapse All"
            btnExpand.Tag = 1
        Else
            mEditor.PrivilegeTree.CollapseAll()
            btnExpand.Image = My.Resources.GroupExpand15
            btnExpand.Text = "Expand All"
            btnExpand.Tag = 0
        End If
    End Sub
End Class
