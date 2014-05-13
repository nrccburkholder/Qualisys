Imports Nrc.Framework.BusinessLogic
Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_UserControls_ThemeEditor
    Inherits System.Web.UI.UserControl


#Region " Private/Protected Properties "

    Public Property ViewId() As Integer
        Get
            If ViewState("ViewId") Is Nothing Then
                Return 0
            Else
                Return CInt(ViewState("ViewId"))
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("ViewId") = value
        End Set
    End Property
#End Region

#Region " ThemesChanged Event "
    Public Event ThemesChanged As EventHandler
    Protected Overridable Sub OnThemesChanged(ByVal e As EventArgs)
        RaiseEvent ThemesChanged(Me, e)
    End Sub
#End Region

#Region " ThemeSelected Event "

    Public Event ThemeSelected As EventHandler(Of ThemeSelectedEventArgs)
    Public Class ThemeSelectedEventArgs
        Inherits EventArgs

        Private mThemeId As Integer
        Public ReadOnly Property ThemeId() As Integer
            Get
                Return mThemeId
            End Get
        End Property
        Public Sub New(ByVal themeId As Integer)
            mThemeId = themeId
        End Sub
    End Class
    Protected Overridable Sub OnThemeSelected(ByVal e As ThemeSelectedEventArgs)
        RaiseEvent ThemeSelected(Me, e)
    End Sub

#End Region

#Region " Page Events "

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GridErrorMessages.Text = ""
    End Sub
    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Me.InitCheckBoxJavascript()
    End Sub
#End Region

    Public Sub Populate()
        Me.ThemeGrid.EditIndex = -1
        Me.BindThemeGrid()
    End Sub

#Region " Page Initialization "
    Private Sub BindThemeGrid()
        Dim serviceTypes As ServiceTypeCollection = AppCache.AllServiceTypes
        Dim selectedView As View = serviceTypes.FindView(Me.ViewId)

        If selectedView IsNot Nothing Then
            Dim sortedList As New SortedBindingList(Of Theme)(selectedView.Themes)
            sortedList.ApplySort("Name", ComponentModel.ListSortDirection.Ascending)
            Me.ThemeGrid.DataSource = sortedList
            Me.ThemeGrid.DataBind()
        End If
    End Sub

    Private Sub InitCheckBoxJavascript()
        For Each row As GridViewRow In Me.ThemeGrid.Rows
            Dim cbx As CheckBox = DirectCast(row.FindControl("DeleteCheckBox"), CheckBox)
            Page.ClientScript.RegisterArrayDeclaration("ThemeCheckBoxIDs", String.Concat("'", cbx.ClientID, "'"))
        Next
    End Sub
#End Region

    Private Sub ThemeGrid_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles ThemeGrid.RowCancelingEdit
        Me.ThemeGrid.EditIndex = -1
        Me.BindThemeGrid()
    End Sub

    Private Sub ThemeGrid_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles ThemeGrid.RowEditing
        Me.ThemeGrid.EditIndex = e.NewEditIndex
        Me.BindThemeGrid()
    End Sub

    Private Sub ThemeGrid_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles ThemeGrid.RowUpdating
        Dim themeId As Integer = CInt(Me.ThemeGrid.DataKeys(e.RowIndex).Value)
        Dim t As Theme = AppCache.AllServiceTypes.FindTheme(themeId)
        If t IsNot Nothing Then
            'The following line doesn't work because asp.net 2.0 sucks
            'so we have to go through the actual cells, and controls to get the value
            't.Name = e.NewValues("Name").ToString
            Dim txt As TextBox = CType(Me.ThemeGrid.Rows(e.RowIndex).Cells(2).Controls(1), TextBox)
            t.Name = txt.Text
            t.Save()
            Me.ThemeGrid.EditIndex = -1
            Me.BindThemeGrid()
            Me.OnThemesChanged(EventArgs.Empty)
        End If
    End Sub

    Protected Sub AddThemeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddThemeButton.Click
        Dim v As View = AppCache.AllServiceTypes.FindView(Me.ViewId)
        If v IsNot Nothing Then
            Dim newTheme As Theme = Theme.NewTheme(v.Id)
            newTheme.Name = Me.NewThemeName.Text
            newTheme.Save()
            v.Themes.Add(newTheme)
            Me.BindThemeGrid()
            Me.NewThemeName.Text = ""
            Me.OnThemesChanged(EventArgs.Empty)
        End If
    End Sub

    Protected Sub DeleteCheckedButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteCheckedButton.Click
        Dim v As View = AppCache.AllServiceTypes.FindView(Me.ViewId)
        Dim errorMessages As New List(Of String)

        For i As Integer = 0 To Me.ThemeGrid.Rows.Count - 1
            Dim cbx As CheckBox = TryCast(ThemeGrid.Rows(i).Cells(0).FindControl("DeleteCheckBox"), CheckBox)
            If cbx IsNot Nothing Then
                If cbx.Checked Then
                    Dim themeId As Integer = CInt(Me.ThemeGrid.DataKeys(i).Value)
                    Dim t As Theme = v.FindTheme(themeId)
                    If v IsNot Nothing AndAlso t IsNot Nothing Then
                        Try
                            v.Themes.Remove(t)
                            t.Save()
                        Catch ex As Exception
                            v.Themes.Add(t)
                            errorMessages.Add(String.Format("Theme '{0}': {1}", t.Name, ex.Message))
                        End Try
                    End If
                End If
            End If
        Next

        If errorMessages.Count > 0 Then
            GridErrorMessages.Text = String.Join("<br />", errorMessages.ToArray)
        End If

        Me.BindThemeGrid()
        Me.OnThemesChanged(EventArgs.Empty)
    End Sub

    Protected Sub GridItemClicked(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As LinkButton = TryCast(sender, LinkButton)
        If btn IsNot Nothing Then
            Dim id As Integer = CInt(btn.CommandArgument)
            Me.OnThemeSelected(New ThemeSelectedEventArgs(id))
        End If
    End Sub

End Class