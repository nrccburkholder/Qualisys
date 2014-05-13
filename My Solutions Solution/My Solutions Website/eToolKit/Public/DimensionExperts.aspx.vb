Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_DimensionExperts
    Inherits ToolKitPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim experts As ManagedContentCollection = ManagedContent.GetByCategory("Experts", False)
        For Each content As ManagedContent In experts
            litExperts.Text &= "<a name='" & content.Key & "' />" & content.Content & "<br /><hr/>"
        Next
    End Sub

End Class