Public Partial Class ucFooter1
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        datCopyRight.Text = Now.Year.ToString
    End Sub

    Protected Sub DataloaderVersionLabelLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles DataLoaderVersionNumber.Load
        DataLoaderVersionNumber.Text = System.Reflection.Assembly.GetExecutingAssembly.GetName.Version.ToString
    End Sub

End Class