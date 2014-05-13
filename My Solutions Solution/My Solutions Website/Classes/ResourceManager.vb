
Public NotInheritable Class ResourceManager

    Private Sub New()

    End Sub

    Public Shared Function GetMemberResourcePath(ByVal parent As IUrlResolutionService, ByVal id As Object) As String
        Dim relativeUrl As String = String.Format("~/Shared/DownloadDocument.aspx?id={0}&type=mr", id)
        Return parent.ResolveClientUrl(relativeUrl)
    End Function

End Class
