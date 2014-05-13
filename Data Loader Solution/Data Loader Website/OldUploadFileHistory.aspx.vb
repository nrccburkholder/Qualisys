Imports System.Data.SqlClient
Partial Public Class UploadFileHistory
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ASPxGridView1.DataSource = NRC.DataLoader.UploadFileHistory.GetHistory(CurrentUser.SelectedGroup.GroupId)
        ASPxGridView1.DataBind()
    End Sub

    Private Sub ReturnToUploadPage(ByVal sender As Object, ByVal e As EventArgs) Handles [return].Click, return1.Click
        Response.Redirect("Upload.aspx")
    End Sub

End Class