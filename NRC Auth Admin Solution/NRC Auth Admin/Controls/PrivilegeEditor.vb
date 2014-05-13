Imports DevExpress.XtraEditors
Imports DevExpress.XtraTreeList
Imports DevExpress.XtraTreeList.Nodes
Imports Nrc.NRCAuthLib

Public MustInherit Class PrivilegeEditor

#Region " PrivilegeGrant class "
    Protected Structure PrivilegeGrant
        Public PrivilegeId As Integer
        Public RevokeDate As Date
    End Structure
    Protected Class PrivilegeGrantList
        Inherits List(Of PrivilegeGrant)

        Public Function ContainsPrivilege(ByVal privilegeId As Integer) As Boolean
            For Each grant As PrivilegeGrant In Me
                If grant.PrivilegeId = privilegeId Then
                    Return True
                End If
            Next

            Return False
        End Function
    End Class
#End Region

#Region " Private Fields "
    Private Const UNCHECKED As Integer = 0
    Private Const CHECKED As Integer = 1
    Private Const INDETERMINATE As Integer = 2

    Private mReadOnly As Boolean
    Private mIsBulkEdit As Boolean
#End Region

#Region "ReadOnlyChanged Event "
    Public Event ReadOnlyChanged As EventHandler
    Protected Overridable Sub OnReadOnlyChanged(ByVal e As EventArgs)
        RaiseEvent ReadOnlyChanged(Me, e)
    End Sub
#End Region

#Region " Public Properties "
    Public Property WarningMessage() As String
        Get
            Return Me.WarningLabel.Text
        End Get
        Set(ByVal value As String)
            Me.WarningLabel.Text = value
            Me.WarningLabel.Visible = (Me.WarningLabel.Text.Trim.Length > 0)
        End Set
    End Property

    Public Property [ReadOnly]() As Boolean
        Get
            Return mReadOnly
        End Get
        Set(ByVal value As Boolean)
            If mReadOnly <> value Then
                mReadOnly = value
                Me.OnReadOnlyChanged(EventArgs.Empty)
            End If
        End Set
    End Property

    Public Property IsBulkEdit() As Boolean
        Get
            Return mIsBulkEdit
        End Get
        Set(ByVal value As Boolean)
            If mIsBulkEdit <> value Then
                mIsBulkEdit = value
                Me.BulkEditOptionsPanel.Visible = value
            End If
        End Set
    End Property
    Public Overridable ReadOnly Property PrintTitle() As String
        Get
            Return String.Empty
        End Get
    End Property
#End Region

#Region " Public Methods "
    Public Sub SaveChanges()
        If mReadOnly Then
            Throw New InvalidOperationException("Privilege Editor cannot be saved in Read Only mode.")
        End If
        Me.SaveChanges(Me.GetGrantedPrivileges)
    End Sub
#End Region

#Region " Abstract Members "
    Protected MustOverride ReadOnly Property AvailableApplications() As ApplicationCollection
    Protected MustOverride ReadOnly Property GrantedPrivileges() As Dictionary(Of Integer, Privilege)
    Protected MustOverride Function ShowPrivilege(ByVal priv As Privilege) As Boolean
    Protected MustOverride Sub GrantSinglePrivilege(ByVal grant As PrivilegeGrant, ByVal authorMemberId As Integer)
    Protected MustOverride Sub RevokeSinglePrivilege(ByVal privilegeId As Integer, ByVal authorMemberId As Integer)
    Protected Overridable Sub GrantBulkPrivileges(ByVal specifyExact As Boolean, ByVal grantList As PrivilegeGrantList, ByVal authorMemberId As Integer)
    End Sub
#End Region

#Region " Private Methods "

#Region " Control Event Handlers "
    Private Sub PrivilegeTree_GetCustomNodeCellEdit(ByVal sender As Object, ByVal e As DevExpress.XtraTreeList.GetCustomNodeCellEditEventArgs) Handles PrivilegeTree.CustomNodeCellEdit
        Select Case e.Column.FieldName
            Case "DateRevoked"
                If e.Node.HasChildren Then
                    e.RepositoryItem = Nothing
                    e.RepositoryItem.ReadOnly = True
                ElseIf CStr(e.Node("Allow")) <> "" AndAlso CInt(e.Node("Allow")) = UNCHECKED Then
                    e.RepositoryItem = Nothing
                    e.RepositoryItem.ReadOnly = True
                Else
                    e.RepositoryItem = Me.RepositoryItemDateEdit1
                    e.RepositoryItem.ReadOnly = False
                End If
        End Select
    End Sub

    Private Sub RepositoryItemCheckEdit1_EditValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RepositoryItemCheckEdit1.EditValueChanged
        Dim check As CheckEdit = TryCast(sender, DevExpress.XtraEditors.CheckEdit)
        If check IsNot Nothing Then
            Dim pt As Point = check.Bounds.Location
            Dim hInfo As TreeListHitInfo = PrivilegeTree.CalcHitInfo(pt)
            Me.SetCheckedNode(hInfo.Node)
        End If
    End Sub

    Private Sub PrivilegeEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.PopulatePrivilegeTree(Me.AvailableApplications, Me.GrantedPrivileges)
        Me.BulkEditOptionList.SelectedIndex = 0
        Me.RepositoryItemDateEdit1.MinValue = Date.Today.AddDays(1)
    End Sub

    'Private Sub RepositoryItemCheckEdit1_EditValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles RepositoryItemCheckEdit1.EditValueChanging
    '    e.Cancel = Me.ReadOnly
    'End Sub
#End Region

#Region " PopulatePrivilegeTree "
    Private Sub PopulatePrivilegeTree(ByVal apps As ApplicationCollection, ByVal selectedPrivileges As Dictionary(Of Integer, Privilege))
        PrivilegeTree.Nodes.Clear()
        PrivilegeTree.OptionsView.ShowPreview = True
        PrivilegeTree.OptionsView.ShowHorzLines = True
        PrivilegeTree.OptionsView.ShowVertLines = True

        For Each app As Application In apps
            Dim appNode As TreeListNode
            Dim rootNode As TreeListNode = Nothing
            appNode = Me.PrivilegeTree.AppendNode(New Object() {app.Name, ""}, rootNode)
            appNode.Tag = app

            Dim hasChildren As Boolean = False
            Dim hasCheckedChildren As Boolean = False
            Dim hasUncheckedChildren As Boolean = False


            For Each priv As Privilege In app.Privileges
                If Me.ShowPrivilege(priv) Then
                    hasChildren = True
                    Dim privNode As TreeListNode

                    Dim isChecked As Boolean = selectedPrivileges.ContainsKey(priv.PrivilegeId)
                    Dim revokeDate As Date
                    If isChecked Then
                        revokeDate = selectedPrivileges(priv.PrivilegeId).DateRevoked
                    End If
                    Dim childState As Integer
                    If isChecked Then
                        childState = CHECKED
                        hasCheckedChildren = True
                    Else
                        childState = UNCHECKED
                        hasUncheckedChildren = True
                    End If
                    privNode = Me.PrivilegeTree.AppendNode(New Object() {priv.Name, childState}, appNode)
                    If revokeDate <> Date.MinValue Then
                        privNode("DateRevoked") = revokeDate
                    End If
                    privNode.Tag = priv
                End If
            Next

            If hasCheckedChildren AndAlso Not hasUncheckedChildren Then
                appNode("Allow") = CHECKED
            ElseIf hasUncheckedChildren AndAlso Not hasCheckedChildren Then
                appNode("Allow") = UNCHECKED
            Else
                appNode("Allow") = INDETERMINATE
            End If

            If Not hasChildren Then
                Me.PrivilegeTree.Nodes.Remove(appNode)
            End If
        Next
    End Sub
#End Region

#Region " SetCheckedNode "
    Private Sub SetCheckedNode(ByVal node As TreeListNode)
        Dim check As Integer = CType(node("Allow"), Integer)
        If check = CHECKED Then
            check = UNCHECKED
            node("DateRevoked") = Nothing
        Else
            check = CHECKED
        End If
        PrivilegeTree.BeginUpdate()
        node("Allow") = check
        SetCheckedChildNodes(node, check)
        SetCheckedParentNodes(node, check)
        PrivilegeTree.EndUpdate()
    End Sub

    Private Sub SetCheckedChildNodes(ByVal node As TreeListNode, ByVal check As Integer)
        Dim i As Integer
        For i = 0 To node.Nodes.Count - 1
            node.Nodes(i)("Allow") = check
            SetCheckedChildNodes(node.Nodes(i), check)
        Next
    End Sub

    Private Sub SetCheckedParentNodes(ByVal node As TreeListNode, ByVal check As Integer)
        If Not node.ParentNode Is Nothing Then
            Dim b As Boolean = False
            Dim i As Integer
            For i = 0 To node.ParentNode.Nodes.Count - 1
                If Not check.Equals(node.ParentNode.Nodes(i)("Allow")) Then
                    b = Not b
                    Exit For
                End If
            Next
            node.ParentNode("Allow") = IIf(b, INDETERMINATE, check)
            SetCheckedParentNodes(node.ParentNode, check)
        End If
    End Sub
#End Region

    Protected Function GetGrantedPrivileges() As PrivilegeGrantList
        Dim grants As New PrivilegeGrantList
        For Each node As TreeListNode In Me.PrivilegeTree.Nodes
            FillSelectedPrivileges(node, grants)
        Next

        Return grants
    End Function

    Private Sub FillSelectedPrivileges(ByVal node As TreeListNode, ByVal grants As PrivilegeGrantList)
        Dim priv As Privilege = TryCast(node.Tag, Privilege)
        If priv IsNot Nothing Then
            If CType(node("Allow"), Integer) = CHECKED Then
                Dim grant As New PrivilegeGrant
                grant.PrivilegeId = priv.PrivilegeId
                grant.RevokeDate = CType(node("DateRevoked"), Date)
                grants.Add(grant)
            End If
        End If

        For Each childNode As TreeListNode In node.Nodes
            FillSelectedPrivileges(childNode, grants)
        Next
    End Sub

    Protected Function GetPrivileges(ByVal apps As ApplicationCollection) As Dictionary(Of Integer, Privilege)
        Dim privileges As New Dictionary(Of Integer, Privilege)
        For Each app As Application In apps
            For Each priv As Privilege In app.Privileges
                privileges.Add(priv.PrivilegeId, priv)
            Next
        Next

        Return privileges
    End Function


    Private Sub SaveChanges(ByVal selectedPrivileges As PrivilegeGrantList)
        Dim grantList As New PrivilegeGrantList
        Dim revokeList As New List(Of Integer)

        'Check each granted privileges
        For Each grant As PrivilegeGrant In selectedPrivileges
            'Find any newly added privileges
            If Not Me.GrantedPrivileges.ContainsKey(grant.PrivilegeId) Then
                'add to list
                grantList.Add(grant)
            ElseIf Me.GrantedPrivileges(grant.PrivilegeId).DateRevoked <> grant.RevokeDate Then
                grantList.Add(grant)
            End If
        Next

        'Check each of the previously granted privileges for ones that are now revoked
        For Each id As Integer In GrantedPrivileges.Keys
            'Find any privileges that are no longer granted
            If Not selectedPrivileges.ContainsPrivilege(id) Then
                'add to list
                revokeList.Add(id)
            End If
        Next

        Me.SavePrivileges(grantList, revokeList)
    End Sub

    Private Sub SavePrivileges(ByVal grantList As PrivilegeGrantList, ByVal revokeList As List(Of Integer))
        If Me.mIsBulkEdit Then
            Dim specifyExact As Boolean = (Me.BulkEditOptionList.SelectedIndex = 1)
            Me.GrantBulkPrivileges(specifyExact, grantList, CurrentUser.Member.MemberId)
        Else
            For Each grant As PrivilegeGrant In grantList
                'Grant the privilege
                Me.GrantSinglePrivilege(grant, CurrentUser.Member.MemberId)
            Next

            For Each id As Integer In revokeList
                'Revoke the privilege
                Me.RevokeSinglePrivilege(id, CurrentUser.Member.MemberId)
            Next
        End If
    End Sub

#End Region

    Private Sub PrivilegeTree_GetStateImage(ByVal sender As Object, ByVal e As DevExpress.XtraTreeList.GetStateImageEventArgs) Handles PrivilegeTree.GetStateImage
        If TypeOf (e.Node.GetValue("Allow")) Is Integer Then
            Select Case CType(e.Node.GetValue("Allow"), Integer)
                Case UNCHECKED
                    e.NodeImageIndex = 0
                Case CHECKED
                    e.NodeImageIndex = 1
                Case Else
                    e.NodeImageIndex = 2
            End Select
        Else
            e.NodeImageIndex = 2
        End If
    End Sub

    Private Sub PrivilegeTree_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles PrivilegeTree.MouseDown
        If e.Button = Windows.Forms.MouseButtons.Left Then
            Dim hInfo As TreeListHitInfo = PrivilegeTree.CalcHitInfo(New Point(e.X, e.Y))
            If hInfo.HitInfoType = HitInfoType.StateImage Then
                SetCheckedNode(hInfo.Node)
            End If
        End If

    End Sub
End Class