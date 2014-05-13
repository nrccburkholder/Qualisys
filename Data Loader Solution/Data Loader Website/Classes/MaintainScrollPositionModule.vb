Imports System
Imports System.Data
Imports System.Configuration
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls

''' <summary>This class is a custom HTTPModule.  With using AJAX in this site.  You can not set the maintainScrollPositionOnPostBack attribute on the page element of the web config.  This module will allow us to still set the maintainscrollpositionOnPostBack for non web service calls and non ajax baxed pages. </summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class MaintainScrollPositionModule
    Implements IHttpModule


    Public Sub Dispose() Implements System.Web.IHttpModule.Dispose

    End Sub

    Public Sub Init(ByVal context As System.Web.HttpApplication) Implements System.Web.IHttpModule.Init
        AddHandler context.PreRequestHandlerExecute, New EventHandler(AddressOf Me.ContextPreRequestHandlerExecute)
    End Sub

    Private Sub ContextPreRequestHandlerExecute(ByVal sender As Object, ByVal e As EventArgs)
        Dim page As Page = TryCast(HttpContext.Current.CurrentHandler, Page)
        If (Not page Is Nothing AndAlso Not page.Form Is Nothing) Then
            AddHandler page.PreInit, New EventHandler(AddressOf Me.PagePreInit)
        End If
    End Sub


    Private Sub PagePreInit(ByVal sender As Object, ByVal e As EventArgs)
        Dim page As Page = TryCast(sender, Page)
        If (Not page Is Nothing AndAlso page.Form Is Nothing) Then
            page.MaintainScrollPositionOnPostBack = True
        End If
    End Sub


End Class
