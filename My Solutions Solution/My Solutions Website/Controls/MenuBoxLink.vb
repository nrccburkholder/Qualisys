Imports System.ComponentModel

Public Class MenuBoxLink
    Inherits MenuBoxItem
    Implements IPostBackEventHandler

#Region " Click Event "
    Public Event Click As EventHandler
    Protected Overridable Sub OnClick(ByVal e As EventArgs)
        RaiseEvent Click(Me, e)
    End Sub
#End Region

#Region " Public Properties "
    <Category("Appearance")> _
    Property Text() As String
        Get
            Dim txt As String = CStr(ViewState("Text"))
            If txt Is Nothing Then
                Return String.Empty
            Else
                Return txt
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("Text") = Value
        End Set
    End Property

    <Category("Appearance"), UrlProperty()> _
    Property NavigateUrl() As String
        Get
            Dim url As String = CStr(ViewState("NavigateUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("NavigateUrl") = Value
        End Set
    End Property

    <Category("Behavior"), DefaultValue(False)> _
    Property OpenInNewWindow() As Boolean
        Get
            If ViewState("OpenInNewWindow") Is Nothing Then
                Return False
            Else
                Return CBool(ViewState("OpenInNewWindow"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("OpenInNewWindow") = Value
        End Set
    End Property

#End Region

    Protected Overrides ReadOnly Property TagKey() As HtmlTextWriterTag
        Get
            Return HtmlTextWriterTag.Div
        End Get
    End Property

    Protected Overrides Sub AddAttributesToRender(ByVal writer As System.Web.UI.HtmlTextWriter)
        Dim resetCss As Boolean = False
        If String.IsNullOrEmpty(Me.ControlStyle.CssClass) Then
            Dim mb As MenuBox = GetMenuBox() 'TryCast(Me.Parent, MenuBox)
            If Not String.IsNullOrEmpty(mb.MenuItemCssClass) Then
                Me.ControlStyle.CssClass = mb.MenuItemCssClass
                resetCss = True
            End If
        End If
        MyBase.AddAttributesToRender(writer)
        If resetCss Then
            Me.ControlStyle.CssClass = ""
        End If
    End Sub

    Protected Overrides Sub RenderContents(ByVal writer As HtmlTextWriter)
        If Enabled Then
            If Not String.IsNullOrEmpty(Me.NavigateUrl) Then
                writer.AddAttribute(HtmlTextWriterAttribute.Href, Me.Page.ResolveClientUrl(NavigateUrl))
                If Me.OpenInNewWindow Then
                    writer.AddAttribute("onclick", "window.open(this.href);return false;")
                    writer.AddAttribute("onkeypress", "window.open(this.href);return false;")
                End If
            Else
                writer.AddAttribute(HtmlTextWriterAttribute.Href, Me.Page.ClientScript.GetPostBackClientHyperlink(Me, "Click"))
            End If
        End If
        writer.RenderBeginTag(HtmlTextWriterTag.A)
        writer.Write(Me.Text)
        writer.RenderEndTag()
    End Sub

    Public Sub RaisePostBackEvent(ByVal eventArgument As String) Implements System.Web.UI.IPostBackEventHandler.RaisePostBackEvent
        If eventArgument = "Click" Then
            Me.OnClick(EventArgs.Empty)
        End If
    End Sub

End Class