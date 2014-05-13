Imports Nrc.NRCAuthLib
Imports System.Windows.Forms

Public Class OrgUnitSelectorDialog

    '#Region " SelectedOrgUnitChanged Event "
    '    Public Class SelectedOrgUnitChangedEventArgs
    '        Inherits EventArgs

    '        Private mOrgUnit As OrgUnit
    '        Public ReadOnly Property OrgUnit() As OrgUnit
    '            Get
    '                Return mOrgUnit
    '            End Get
    '        End Property
    '        Public Sub New(ByVal ou As OrgUnit)
    '            mOrgUnit = ou
    '        End Sub
    '    End Class
    '    Public Event SelectedOrgUnitChanged As EventHandler(Of SelectedOrgUnitChangedEventArgs)
    '    Protected Overridable Sub OnSelectedOrgUnitChanged(ByVal e As SelectedOrgUnitChangedEventArgs)
    '        RaiseEvent SelectedOrgUnitChanged(Me, e)
    '    End Sub
    '#End Region

    Private mSelectedOrgUnit As OrgUnit
    Private mAllowSelectMethod As AllowOrgUnitSelectionDelegate

    Public Property AllowOk() As Boolean
        Get
            Return Me.OK_Button.Enabled
        End Get
        Set(ByVal value As Boolean)
            Me.OK_Button.Enabled = value
        End Set
    End Property

    Public ReadOnly Property SelectedOrgUnit() As OrgUnit
        Get
            Return mSelectedOrgUnit
        End Get
    End Property

    Public Delegate Function AllowOrgUnitSelectionDelegate(ByVal ou As OrgUnit, ByRef message As String) As Boolean

    Public Sub New(ByVal allowSelectMethod As AllowOrgUnitSelectionDelegate)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mAllowSelectMethod = allowSelectMethod
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub OrgUnitSelectorDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.InitializeOrgUnitTree()
    End Sub

#Region " Tree Population "
    Private Sub InitializeOrgUnitTree()
        Dim rootOrg As OrgUnit = OrgUnit.GetOrgUnitTree(CurrentUser.Member.OrgUnitId)

        Me.OrgUnitTreeView.BeginUpdate()
        PopulateOrgUnits(Me.OrgUnitTreeView.Nodes, rootOrg)
        For Each node As TreeNode In Me.OrgUnitTreeView.Nodes
            node.Expand()
        Next
        Me.OrgUnitTreeView.EndUpdate()
    End Sub

    Private Sub PopulateOrgUnits(ByVal nodes As TreeNodeCollection, ByVal rootOrg As OrgUnit)
        Dim rootNode As New TreeNode(rootOrg.Name)
        rootNode.Tag = rootOrg
        For Each org As OrgUnit In rootOrg.OrgUnits
            PopulateOrgUnits(rootNode.Nodes, org)
        Next

        nodes.Add(rootNode)
    End Sub

    Private Sub ResortChildNodes(ByVal rootNode As TreeNode)
        Dim list As New SortedList(Of String, TreeNode)

        For Each node As TreeNode In rootNode.Nodes
            list.Add(node.Text, node)
        Next

        rootNode.Nodes.Clear()

        For Each key As String In list.Keys
            rootNode.Nodes.Add(list(key))
        Next
    End Sub

#End Region

#Region " Tree Events "
    Private Sub OrgUnitTreeView_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles OrgUnitTreeView.AfterSelect
        Dim ou As OrgUnit = TryCast(e.Node.Tag, OrgUnit)
        If ou IsNot Nothing Then
            Me.mSelectedOrgUnit = ou

            Dim message As String = ""
            Me.AllowOk = Me.mAllowSelectMethod(ou, message)
            If String.IsNullOrEmpty(message) Then
                Me.MessageLabel.Text = ""
                Me.MessagePanel.Visible = False
            Else
                Me.MessageLabel.Text = message
                Me.MessagePanel.Visible = True
            End If
            'Raise the changed event
            'Me.OnSelectedOrgUnitChanged(New SelectedOrgUnitChangedEventArgs(ou))
        End If
    End Sub

    Private Sub OrgUnitTree_MouseClick(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles OrgUnitTreeView.MouseClick
        If e.Button = Windows.Forms.MouseButtons.Right Then
            Dim node As TreeNode = Me.OrgUnitTreeView.GetNodeAt(e.Location)
            If node IsNot Nothing Then
                Me.OrgUnitTreeView.SelectedNode = node
            End If
        End If
    End Sub

#End Region
End Class
