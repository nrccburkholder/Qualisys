Imports Nrc.Framework.BusinessLogic
Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_UserControls_ViewEditor
    Inherits System.Web.UI.UserControl

#Region " Private/Protected Properties "

    Public Property ServiceTypeId() As Integer
        Get
            If ViewState("ServiceTypeId") Is Nothing Then
                Return 0
            Else
                Return CInt(ViewState("ServiceTypeId"))
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("ServiceTypeId") = value
        End Set
    End Property
#End Region

#Region " ViewsChanged Event "

    Public Event ViewsChanged As EventHandler

    Protected Overridable Sub OnViewsChanged(ByVal e As EventArgs)
        RaiseEvent ViewsChanged(Me, e)
    End Sub

    Public Event ViewSelected As EventHandler(Of ViewSelectedEventArgs)
    Public Class ViewSelectedEventArgs
        Inherits EventArgs

        Private mViewId As Integer
        Public ReadOnly Property ViewId() As Integer
            Get
                Return mViewId
            End Get
        End Property
        Public Sub New(ByVal ViewId As Integer)
            mViewId = ViewId
        End Sub
    End Class

    Protected Overridable Sub OnViewSelected(ByVal e As ViewSelectedEventArgs)
        RaiseEvent ViewSelected(Me, e)
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

#Region " Public/protected Methods "

    Public Sub Populate()
        Me.ViewGrid.EditIndex = -1
        Me.BindViewGrid()
    End Sub

    Protected Sub GridItemClicked(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As LinkButton = TryCast(sender, LinkButton)
        If btn IsNot Nothing Then
            Dim id As Integer = CInt(btn.CommandArgument)
            Me.OnViewSelected(New ViewSelectedEventArgs(id))
        End If
    End Sub

#End Region

#Region " Page Initialization "
    Private Sub BindViewGrid()
        Dim st As ServiceType = AppCache.AllServiceTypes.FindServiceType(Me.ServiceTypeId)

        If st IsNot Nothing Then
            Dim sortedList As New SortedBindingList(Of View)(st.Views)
            sortedList.ApplySort("Name", ComponentModel.ListSortDirection.Ascending)
            Me.ViewGrid.DataSource = sortedList
            Me.ViewGrid.DataBind()
        End If
    End Sub

    Private Sub InitCheckBoxJavascript()
        For Each row As GridViewRow In Me.ViewGrid.Rows
            Dim cbx As CheckBox = DirectCast(row.FindControl("DeleteCheckBox"), CheckBox)
            Page.ClientScript.RegisterArrayDeclaration("ViewCheckBoxIDs", String.Concat("'", cbx.ClientID, "'"))
        Next
    End Sub
#End Region

#Region " Control Event Handlers "

    Private Sub ViewGrid_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles ViewGrid.RowCancelingEdit
        Me.ViewGrid.EditIndex = -1
        Me.BindViewGrid()
    End Sub

    Private Sub ViewGrid_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles ViewGrid.RowEditing
        Me.ViewGrid.EditIndex = e.NewEditIndex
        Me.BindViewGrid()
    End Sub

    Private Sub ViewGrid_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles ViewGrid.RowUpdating
        Dim viewId As Integer = CInt(Me.ViewGrid.DataKeys(e.RowIndex).Value)
        Dim v As View = AppCache.AllServiceTypes.FindView(viewId)
        If v IsNot Nothing Then
            Try
                Dim txt As TextBox = CType(Me.ViewGrid.Rows(e.RowIndex).Cells(2).Controls(1), TextBox)
                Dim chk As CheckBox = CType(Me.ViewGrid.Rows(e.RowIndex).Cells(3).Controls(0), CheckBox)
                v.Name = txt.Text
                v.IsHcahps = chk.Checked
                v.Save()
                Me.ViewGrid.EditIndex = -1
                Me.BindViewGrid()
                Me.OnViewsChanged(EventArgs.Empty)

            Catch ex As Exception
                GridErrorMessages.Text = String.Format("View '{0}': {1}", v.Name, ex.Message)
            End Try
        End If

    End Sub

    Protected Sub AddViewButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddViewButton.Click
        Dim st As ServiceType = AppCache.AllServiceTypes.FindServiceType(Me.ServiceTypeId)
        If st IsNot Nothing Then
            Try
                Dim newView As View = View.NewView(st.Id)
                newView.Name = Me.NewViewName.Text
                newView.IsHcahps = Me.HcahpsCheckBox.Checked
                newView.Save()
                st.Views.Add(newView)
                Me.BindViewGrid()
                Me.NewViewName.Text = ""
                Me.HcahpsCheckBox.Checked = False
                Me.OnViewsChanged(EventArgs.Empty)

            Catch ex As Exception
                GridErrorMessages.Text = String.Format("Add view: {0}", ex.Message)
            End Try
        End If
    End Sub

    Protected Sub DeleteCheckedButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteCheckedButton.Click
        Dim st As ServiceType = AppCache.AllServiceTypes.FindServiceType(Me.ServiceTypeId)
        Dim errorMessages As New List(Of String)

        For i As Integer = 0 To Me.ViewGrid.Rows.Count - 1
            Dim cbx As CheckBox = TryCast(ViewGrid.Rows(i).Cells(0).FindControl("DeleteCheckBox"), CheckBox)
            If cbx IsNot Nothing Then
                If cbx.Checked Then
                    Dim viewId As Integer = CInt(Me.ViewGrid.DataKeys(i).Value)
                    Dim v As View = st.FindView(viewId)
                    If st IsNot Nothing AndAlso v IsNot Nothing Then
                        Try
                            st.Views.Remove(v)
                            v.Save()
                        Catch ex As Exception
                            errorMessages.Add(String.Format("View '{0}': {1}", v.Name, ex.Message))
                            st.Views.Add(v)
                        End Try
                    End If
                End If
            End If
        Next

        If errorMessages.Count > 0 Then
            GridErrorMessages.Text = String.Join("<br />", errorMessages.ToArray)
        End If

        Me.BindViewGrid()
        Me.OnViewsChanged(EventArgs.Empty)
    End Sub

#End Region

End Class