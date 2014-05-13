'//**************************************************************//
'// Paul Wilson -- www.WilsonDotNet.com -- Paul@WilsonDotNet.com // 
'// Feel free to use and modify -- just leave these credit lines // 
'// I also always appreciate any other public credit you provide // 
'//**************************************************************//
Imports System.ComponentModel
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Drawing

Namespace Web

    <ToolboxData("<{0}:ContentRegion runat=server></{0}:ContentRegion>")> _
    Public Class ContentRegion
        Inherits System.Web.UI.WebControls.Panel

        Public Sub New()
            MyBase.BackColor = Color.WhiteSmoke
            MyBase.Width = New Unit("100%")
        End Sub

        Public Overrides Sub RenderBeginTag(ByVal writer As System.Web.UI.HtmlTextWriter)
        End Sub

        Public Overrides Sub RenderEndTag(ByVal writer As System.Web.UI.HtmlTextWriter)
        End Sub
    End Class

End Namespace
