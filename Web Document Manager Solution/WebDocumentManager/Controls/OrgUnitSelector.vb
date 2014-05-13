Imports NRC.NRCAuthLib
Public Class OrgUnitSelector
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents trvOrgUnits As System.Windows.Forms.TreeView
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.trvOrgUnits = New System.Windows.Forms.TreeView
        Me.SuspendLayout()
        '
        'trvOrgUnits
        '
        Me.trvOrgUnits.BackColor = System.Drawing.SystemColors.Window
        Me.trvOrgUnits.Dock = System.Windows.Forms.DockStyle.Fill
        Me.trvOrgUnits.ImageIndex = -1
        Me.trvOrgUnits.Location = New System.Drawing.Point(0, 0)
        Me.trvOrgUnits.Name = "trvOrgUnits"
        Me.trvOrgUnits.SelectedImageIndex = -1
        Me.trvOrgUnits.Size = New System.Drawing.Size(150, 368)
        Me.trvOrgUnits.TabIndex = 0
        '
        'OrgUnitSelector
        '
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.trvOrgUnits)
        Me.Name = "OrgUnitSelector"
        Me.Size = New System.Drawing.Size(150, 368)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Sub New(ByVal LoginName As String)
        MyBase.new()
        InitializeComponent()
        Dim currentMember As New Member
        Dim OrgTreeNode As New TreeNode
        Dim ou As OrgUnit
        currentMember = Member.GetNTLoginMember(LoginName)
        ou = OrgUnit.GetOrgUnitTree(currentMember.OrgUnitId)
        OrgTreeNode.Tag = ou
        OrgTreeNode.Text = ou.Name
        trvOrgUnits.Nodes.Add(GetOrgUnitNode(OrgTreeNode))
        trvOrgUnits.Nodes.Item(0).Expand()
    End Sub

    Private Function GetOrgUnitNode(ByVal Node As TreeNode) As TreeNode
        Dim tmpOrgUnit As OrgUnit = DirectCast(Node.Tag, OrgUnit)
        Dim tmpTreeNode As TreeNode
        For Each childNode As OrgUnit In tmpOrgUnit.OrgUnits
            tmpTreeNode = New TreeNode
            tmpTreeNode.Tag = childNode
            tmpTreeNode.Text = childNode.Name
            Node.Nodes.Add(GetOrgUnitNode(tmpTreeNode))
        Next
        Return Node
    End Function

    Public Event nodeSelected(ByVal SelectedOrgUnit As OrgUnit)

    Private Sub trvOrgUnits_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles trvOrgUnits.AfterSelect
        Dim tmpOrgUnit As OrgUnit = DirectCast(e.Node.Tag, OrgUnit)
        RaiseEvent nodeSelected(tmpOrgUnit)
    End Sub
End Class
