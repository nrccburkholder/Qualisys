Imports System.Collections.ObjectModel
Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_Admin_ThemeManager
    Inherits System.Web.UI.Page

#Region " Page Events "

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.InitModelTree()
        End If
    End Sub

#End Region

#Region " Page Initialization "

    Private Sub InitModelTree()
        Me.InitModelTree("")
    End Sub

    Private Sub InitModelTree(ByVal selectedValuePath As String)
        Dim serviceTypes As ServiceTypeCollection = ServiceType.GetAll
        Me.ModelTreeView.Nodes.Clear()

        Dim root As New TreeNode("Improvement Model", "0")
        Me.ModelTreeView.Nodes.Add(root)

        For Each st As ServiceType In serviceTypes
            Dim serviceNode As New TreeNode(st.Name, st.Id.ToString)
            root.ChildNodes.Add(serviceNode)

            For Each v As View In st.Views
                Dim viewNode As New TreeNode(v.Name, v.Id.ToString)
                serviceNode.ChildNodes.Add(viewNode)

                For Each t As Theme In v.Themes
                    Dim themeNode As New TreeNode(t.Name, t.Id.ToString)
                    viewNode.ChildNodes.Add(themeNode)
                Next
            Next
        Next

        root.Expanded = True
        If String.IsNullOrEmpty(selectedValuePath) Then
            root.Select()
        Else
            Dim selectedNode As TreeNode = Me.ModelTreeView.FindNode(selectedValuePath)
            If selectedNode IsNot Nothing Then
                selectedNode.Select()
                selectedNode = selectedNode.Parent
                While selectedNode IsNot Nothing
                    selectedNode.Expanded = True
                    selectedNode = selectedNode.Parent
                End While
            End If
        End If
    End Sub

    Private Sub InitEditorControls()
        Select Case Me.ModelTreeView.SelectedNode.Depth
            Case 0
                Me.ServiceTypeEditor1.Visible = True
                Me.ViewEditor1.Visible = False
                Me.ThemeEditor1.Visible = False
                Me.ThemeQuestionEditor1.Visible = False

                Me.ServiceTypeEditor1.Populate()
            Case 1
                Me.ServiceTypeEditor1.Visible = False
                Me.ViewEditor1.Visible = True
                Me.ThemeEditor1.Visible = False
                Me.ThemeQuestionEditor1.Visible = False

                'Load ViewEditor control
                Dim serviceTypeId As Integer = CInt(Me.ModelTreeView.SelectedValue)
                Me.ViewEditor1.ServiceTypeId = serviceTypeId
                Me.ViewEditor1.Populate()

            Case 2
                Me.ServiceTypeEditor1.Visible = False
                Me.ViewEditor1.Visible = False
                Me.ThemeEditor1.Visible = True
                Me.ThemeQuestionEditor1.Visible = False

                'Load ThemeEditor control
                Dim viewId As Integer = CInt(Me.ModelTreeView.SelectedValue)
                Me.ThemeEditor1.ViewId = viewId
                Me.ThemeEditor1.Populate()

            Case 3
                Me.ServiceTypeEditor1.Visible = False
                Me.ViewEditor1.Visible = False
                Me.ThemeEditor1.Visible = False
                Me.ThemeQuestionEditor1.Visible = True

                'Load ThemeQuestionEditor control
                Dim themeId As Integer = CInt(Me.ModelTreeView.SelectedValue)
                Me.ThemeQuestionEditor1.ThemeId = themeId
                Me.ThemeQuestionEditor1.Populate()
        End Select
    End Sub

#End Region

#Region " Control Event Handlers "

    Protected Sub ModelTreeView_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ModelTreeView.SelectedNodeChanged
        Me.InitEditorControls()
    End Sub

    Private Sub ServiceTypeEditor1_ServiceTypesChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ServiceTypeEditor1.ServiceTypesChanged
        Me.RefreshModelTree()
    End Sub

    Private Sub ThemeEditor1_ThemesChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ThemeEditor1.ThemesChanged
        Me.RefreshModelTree()
    End Sub

    Private Sub ViewEditor1_ViewsChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ViewEditor1.ViewsChanged
        Me.RefreshModelTree()
    End Sub

    Private Sub ServiceTypeEditor1_ServiceTypeSelected(ByVal sender As Object, ByVal e As eToolKit_UserControls_ServiceTypeEditor.ServiceTypeSelectedEventArgs) Handles ServiceTypeEditor1.ServiceTypeSelected
        Dim valuePath As String = "0/" & e.ServiceTypeId.ToString
        Me.InitModelTree(valuePath)
        Me.InitEditorControls()
    End Sub

    Private Sub ViewEditor1_ViewSelected(ByVal sender As Object, ByVal e As eToolKit_UserControls_ViewEditor.ViewSelectedEventArgs) Handles ViewEditor1.ViewSelected
        Dim viewId As Integer = e.ViewId
        Dim selectedView As View = AppCache.AllServiceTypes.FindView(viewId)
        If (selectedView IsNot Nothing) Then
            Dim serviceTypeId As Integer = selectedView.ServiceTypeId
            Dim valuePath As String = String.Format("0/{0}/{1}", serviceTypeId, viewId)
            Me.InitModelTree(valuePath)
            Me.InitEditorControls()
        End If
    End Sub

    Private Sub ThemeEditor1_ThemeSelected(ByVal sender As Object, ByVal e As eToolKit_UserControls_ThemeEditor.ThemeSelectedEventArgs) Handles ThemeEditor1.ThemeSelected
        Dim t As Theme = AppCache.AllServiceTypes.FindTheme(e.ThemeId)
        Dim v As View = AppCache.AllServiceTypes.FindView(t.ViewId)
        Dim valuePath As String = String.Format("0/{0}/{1}/{2}", v.ServiceTypeId, v.Id, t.Id)
        Me.InitModelTree(valuePath)
        Me.InitEditorControls()
    End Sub

#End Region

    Private Sub RefreshModelTree()
        Dim node As TreeNode = Me.ModelTreeView.SelectedNode
        If node IsNot Nothing Then
            Me.InitModelTree(node.ValuePath)
        End If
    End Sub



End Class

