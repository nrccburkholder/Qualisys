Public Class TreeViewEx
    Inherits System.Web.UI.WebControls.TreeView
    Implements IPostBackEventHandler

    Protected Overrides Sub RaisePostBackEvent(ByVal eventArgument As String)
        MyBase.RaisePostBackEvent(eventArgument)
    End Sub

    Protected Overrides Sub Render(ByVal writer As System.Web.UI.HtmlTextWriter)
        MyBase.Render(writer)
        Page.ClientScript.RegisterForEventValidation(Me.UniqueID)
    End Sub

End Class
