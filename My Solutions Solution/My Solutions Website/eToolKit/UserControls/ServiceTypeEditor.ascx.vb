Imports Nrc.Framework.BusinessLogic
Imports Nrc.DataMart.MySolutions.Library
Imports Nrc.NRCAuthLib

Partial Public Class eToolKit_UserControls_ServiceTypeEditor
    Inherits System.Web.UI.UserControl

#Region " Private Properties "
    Private mPrivilegeLookup As Dictionary(Of Integer, String)
    Private ReadOnly Property PrivilegeLookup() As Dictionary(Of Integer, String)
        Get
            If mPrivilegeLookup Is Nothing Then
                mPrivilegeLookup = New Dictionary(Of Integer, String)
                For Each priv As Privilege In AppCache.ServiceTypePrivileges
                    mPrivilegeLookup.Add(priv.PrivilegeId, priv.Name)
                Next
            End If

            Return mPrivilegeLookup
        End Get
    End Property
#End Region

#Region " ServiceTypesChanged Event "
    Public Event ServiceTypesChanged As EventHandler
    Protected Overridable Sub OnServiceTypesChanged(ByVal e As EventArgs)
        RaiseEvent ServiceTypesChanged(Me, e)
    End Sub
#End Region

#Region " ServiceTypeSelected Event "

    Public Event ServiceTypeSelected As EventHandler(Of ServiceTypeSelectedEventArgs)
    Public Class ServiceTypeSelectedEventArgs
        Inherits EventArgs

        Private mServiceTypeId As Integer
        Public ReadOnly Property ServiceTypeId() As Integer
            Get
                Return mServiceTypeId
            End Get
        End Property
        Public Sub New(ByVal serviceTypeId As Integer)
            mServiceTypeId = serviceTypeId
        End Sub
    End Class
    Protected Overridable Sub OnServiceTypeSelected(ByVal e As ServiceTypeSelectedEventArgs)
        RaiseEvent ServiceTypeSelected(Me, e)
    End Sub

#End Region

#Region " Page Events "

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.InitNrcAuthPrivilegeList()

            Me.ServiceTypeGrid.EditIndex = -1
            Me.BindServiceTypeGrid()
        End If
    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Me.InitCheckBoxJavascript()
    End Sub
#End Region

#Region " Page Initialization "
    Private Sub BindServiceTypeGrid()
        Dim serviceTypes As ServiceTypeCollection = AppCache.AllServiceTypes

        Dim sortedList As New SortedBindingList(Of ServiceType)(serviceTypes)
        sortedList.ApplySort("Name", ComponentModel.ListSortDirection.Ascending)
        Me.ServiceTypeGrid.DataSource = sortedList
        Me.ServiceTypeGrid.DataBind()
    End Sub

    Private Sub InitCheckBoxJavascript()
        For Each row As GridViewRow In Me.ServiceTypeGrid.Rows
            Dim cbx As CheckBox = DirectCast(row.FindControl("DeleteCheckBox"), CheckBox)
            Page.ClientScript.RegisterArrayDeclaration("ServiceTypeCheckBoxIDs", String.Concat("'", cbx.ClientID, "'"))
        Next
    End Sub

    Private Sub InitNrcAuthPrivilegeList()
        If AppCache.ServiceTypePrivileges IsNot Nothing Then
            Me.PrivilegeDropDown.DataSource = AppCache.ServiceTypePrivileges
            Me.PrivilegeDropDown.DataTextField = "Name"
            Me.PrivilegeDropDown.DataValueField = "PrivilegeId"
            Me.PrivilegeDropDown.DataBind()
        End If
    End Sub
#End Region

    Public Sub Populate()
        Me.BindServiceTypeGrid()
    End Sub

    Private Sub ServiceTypeGrid_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles ServiceTypeGrid.RowCancelingEdit
        Me.ServiceTypeGrid.EditIndex = -1
        Me.BindServiceTypeGrid()
    End Sub

    Private Sub ServiceTypeGrid_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles ServiceTypeGrid.RowDataBound
        Dim st As ServiceType = TryCast(e.Row.DataItem, ServiceType)
        If st IsNot Nothing Then
            If e.Row.RowIndex = Me.ServiceTypeGrid.EditIndex Then
                Dim ddl As DropDownList = DirectCast(e.Row.Cells(3).Controls(1), DropDownList)
                ddl.DataSource = AppCache.ServiceTypePrivileges
                ddl.DataTextField = "Name"
                ddl.DataValueField = "PrivilegeId"
                ddl.DataBind()
                ddl.SelectedValue = st.PrivilegeId.ToString
            Else
                e.Row.Cells(3).Text = Me.PrivilegeLookup(st.PrivilegeId)
            End If
        End If

    End Sub

    Private Sub ServiceTypeGrid_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles ServiceTypeGrid.RowEditing
        Me.ServiceTypeGrid.EditIndex = e.NewEditIndex
        Me.BindServiceTypeGrid()
    End Sub

    Private Sub ServiceTypeGrid_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles ServiceTypeGrid.RowUpdating
        Dim serviceTypeId As Integer = CInt(Me.ServiceTypeGrid.DataKeys(e.RowIndex).Value)
        Dim st As ServiceType = AppCache.AllServiceTypes.FindServiceType(serviceTypeId)
        If st IsNot Nothing Then
            'The following line doesn't work because asp.net 2.0 sucks
            'so we have to go through the actual cells, and controls to get the value
            'st.Name = e.NewValues("Name").ToString
            Dim txt As TextBox = DirectCast(Me.ServiceTypeGrid.Rows(e.RowIndex).Cells(2).Controls(1), TextBox)
            st.Name = txt.Text

            Dim ddl As DropDownList = DirectCast(Me.ServiceTypeGrid.Rows(e.RowIndex).Cells(3).Controls(1), DropDownList)
            st.PrivilegeId = CInt(ddl.SelectedValue)

            st.Save()
            Me.ServiceTypeGrid.EditIndex = -1
            Me.BindServiceTypeGrid()
            Me.OnServiceTypesChanged(EventArgs.Empty)
        End If

    End Sub

    Protected Sub AddServiceTypeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddServiceTypeButton.Click
        Dim newService As ServiceType = ServiceType.NewServiceType
        newService.Name = Me.NewServiceTypeName.Text
        newService.PrivilegeId = CInt(Me.PrivilegeDropDown.SelectedValue)
        newService.Save()
        AppCache.AllServiceTypes.Add(newService)
        Me.BindServiceTypeGrid()
        Me.NewServiceTypeName.Text = ""
        Me.PrivilegeDropDown.SelectedIndex = 0
        Me.OnServiceTypesChanged(EventArgs.Empty)
    End Sub

    Protected Sub DeleteCheckedButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteCheckedButton.Click
        Dim errorMessages As New List(Of String)

        For i As Integer = 0 To Me.ServiceTypeGrid.Rows.Count - 1
            Dim cbx As CheckBox = TryCast(ServiceTypeGrid.Rows(i).Cells(0).FindControl("DeleteCheckBox"), CheckBox)
            If cbx IsNot Nothing Then
                If cbx.Checked Then
                    Dim serviceTypeId As Integer = CInt(Me.ServiceTypeGrid.DataKeys(i).Value)
                    Dim st As ServiceType = AppCache.AllServiceTypes.FindServiceType(serviceTypeId)
                    If st IsNot Nothing Then
                        Try
                            AppCache.AllServiceTypes.Remove(st)
                            st.Save()
                        Catch ex As Exception
                            AppCache.AllServiceTypes.Add(st)
                            errorMessages.Add(String.Format("'{0}': {1}", st.Name, ex.Message))
                        End Try
                    End If
                End If
            End If
        Next

        If errorMessages.Count > 0 Then
            GridErrorMessages.Text = String.Join("<br />", errorMessages.ToArray)
        End If

        Me.BindServiceTypeGrid()
        Me.OnServiceTypesChanged(EventArgs.Empty)
    End Sub

    Protected Sub GridItemClicked(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As LinkButton = TryCast(sender, LinkButton)
        If btn IsNot Nothing Then
            Dim id As Integer = CInt(btn.CommandArgument)
            Me.OnServiceTypeSelected(New ServiceTypeSelectedEventArgs(id))
        End If
    End Sub

  
End Class