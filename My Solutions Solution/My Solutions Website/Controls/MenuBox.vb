Imports System.ComponentModel
Imports System.ComponentModel.Design
Imports System.Security.Permissions
Imports System.Drawing.Design

<AspNetHostingPermission(SecurityAction.Demand, Level:=AspNetHostingPermissionLevel.Minimal), _
    AspNetHostingPermission(SecurityAction.InheritanceDemand, Level:=AspNetHostingPermissionLevel.Minimal), _
    ParseChildren(False), _
    ToolboxData("<{0}:MenuBox runat=""server""> </{0}:MenuBox>")> _
Public Class MenuBox
    Inherits WebControl

#Region " Public Propeties "

#Region " Styles "
    <Category("Styles"), DefaultValue("MenuBox")> _
    Property ContentCssClass() As String
        Get
            Dim value As String = CStr(ViewState("ContentCssClass"))
            If value Is Nothing Then
                Return "MenuBox"
            Else
                Return value
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("ContentCssClass") = Value
        End Set
    End Property

    <Category("Styles"), DefaultValue("MenuBoxTitle")> _
    Property TitleCssClass() As String
        Get
            Dim value As String = CStr(ViewState("TitleCssClass"))
            If value Is Nothing Then
                Return "MenuBoxTitle"
            Else
                Return value
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("TitleCssClass") = Value
        End Set
    End Property
    <Category("Styles"), DefaultValue("MenuBoxItem")> _
    Property MenuItemCssClass() As String
        Get
            Dim value As String = CStr(ViewState("MenuItemCssClass"))
            If value Is Nothing Then
                Return "MenuBoxItem"
            Else
                Return value
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("MenuItemCssClass") = Value
        End Set
    End Property
#End Region

#Region " Border Images "
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property BackgroundImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("BackgroundImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("BackgroundImageUrl") = Value
        End Set
    End Property
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property TopLeftImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("TopLeftImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("TopLeftImageUrl") = Value
        End Set
    End Property
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property TopRightImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("TopRightImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("TopRightImageUrl") = Value
        End Set
    End Property
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property BottomLeftImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("BottomLeftImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("BottomLeftImageUrl") = Value
        End Set
    End Property
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property BottomRightImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("BottomRightImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("BottomRightImageUrl") = Value
        End Set
    End Property
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property TopImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("TopImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("TopImageUrl") = Value
        End Set
    End Property
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property BottomImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("BottomImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("BottomImageUrl") = Value
        End Set
    End Property
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property LeftImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("LeftImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("LeftImageUrl") = Value
        End Set
    End Property
    <Category("Images"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", GetType(Drawing.Design.UITypeEditor)), UrlProperty()> _
    Property RightImageUrl() As String
        Get
            Dim url As String = CStr(ViewState("RightImageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("RightImageUrl") = Value
        End Set
    End Property
#End Region


#End Region

    Public Overrides Sub RenderBeginTag(ByVal writer As System.Web.UI.HtmlTextWriter)
        Me.RenderBeginShell(writer)
    End Sub

    Public Overrides Sub RenderEndTag(ByVal writer As System.Web.UI.HtmlTextWriter)
        Me.RenderEndShell(writer)
    End Sub

    Protected Overrides Sub RenderContents(ByVal writer As HtmlTextWriter)
        If Not String.IsNullOrEmpty(Me.ContentCssClass) Then
            writer.AddAttribute(HtmlTextWriterAttribute.Class, ContentCssClass)
        End If
        writer.RenderBeginTag(HtmlTextWriterTag.Div)

        Me.RenderChildren(writer)

        writer.RenderEndTag()
    End Sub

#Region " Render Container "
    Protected Overridable Sub RenderBeginShell(ByVal writer As HtmlTextWriter)
        If Me.Width.IsEmpty Then
            Me.Width = Unit.Pixel(200)
        End If
        MyBase.AddAttributesToRender(writer)
        writer.AddAttribute(HtmlTextWriterAttribute.Cellpadding, "0")
        writer.AddAttribute(HtmlTextWriterAttribute.Cellspacing, "0")
        writer.RenderBeginTag(HtmlTextWriterTag.Table)

        '--------------------Top row--------------------
        writer.RenderBeginTag(HtmlTextWriterTag.Tr)

        'TopLeft
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.AddAttribute(HtmlTextWriterAttribute.Src, Me.ResolveClientUrl(TopLeftImageUrl))
        writer.AddAttribute(HtmlTextWriterAttribute.Alt, "")
        writer.RenderBeginTag(HtmlTextWriterTag.Img)
        writer.RenderEndTag()   'End <img>
        writer.RenderEndTag()   'End <td>

        'Top
        writer.AddStyleAttribute(HtmlTextWriterStyle.BackgroundImage, String.Format("url({0})", Me.ResolveClientUrl(TopImageUrl)))
        writer.AddStyleAttribute("background-repeat", "no-repeat")
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.RenderEndTag()   'End <td>

        'TopRight
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.AddAttribute(HtmlTextWriterAttribute.Src, Me.ResolveClientUrl(TopRightImageUrl))
        writer.AddAttribute(HtmlTextWriterAttribute.Alt, "")
        writer.RenderBeginTag(HtmlTextWriterTag.Img)
        writer.RenderEndTag()   'End <img>
        writer.RenderEndTag()   'End <td>

        writer.RenderEndTag()   'End <tr>


        '--------------------Middle row--------------------
        writer.RenderBeginTag(HtmlTextWriterTag.Tr)

        'Left
        writer.AddStyleAttribute(HtmlTextWriterStyle.BackgroundImage, String.Format("url({0})", Me.ResolveClientUrl(LeftImageUrl)))
        writer.AddStyleAttribute("background-repeat", "repeat-y")
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.RenderEndTag()   'End <td>

        'Content
        writer.AddStyleAttribute(HtmlTextWriterStyle.Width, "100%")
        writer.AddStyleAttribute(HtmlTextWriterStyle.BackgroundImage, String.Format("url({0})", Me.ResolveClientUrl(BackgroundImageUrl)))
        writer.AddStyleAttribute("background-repeat", "repeat-y")
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
    End Sub

    Protected Overridable Sub RenderEndShell(ByVal writer As HtmlTextWriter)
        writer.RenderEndTag()   'End <td>

        'Right
        writer.AddStyleAttribute(HtmlTextWriterStyle.BackgroundImage, String.Format("url({0})", Me.ResolveClientUrl(RightImageUrl)))
        writer.AddStyleAttribute("background-repeat", "repeat-y")
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.RenderEndTag()   'End <td>

        writer.RenderEndTag()   'End <tr>

        '--------------------Bottom row--------------------
        writer.RenderBeginTag(HtmlTextWriterTag.Tr)

        'BottomLeft
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.AddAttribute(HtmlTextWriterAttribute.Src, Me.ResolveClientUrl(BottomLeftImageUrl))
        writer.AddAttribute(HtmlTextWriterAttribute.Alt, "")
        writer.RenderBeginTag(HtmlTextWriterTag.Img)
        writer.RenderEndTag()   'End <img>
        writer.RenderEndTag()   'End <td>

        'Bottom
        writer.AddStyleAttribute(HtmlTextWriterStyle.BackgroundImage, String.Format("url({0})", Me.ResolveClientUrl(BottomImageUrl)))
        writer.AddStyleAttribute("background-repeat", "no-repeat")
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.RenderEndTag()   'End <td>

        'BottomRight
        writer.RenderBeginTag(HtmlTextWriterTag.Td)
        writer.AddAttribute(HtmlTextWriterAttribute.Src, Me.ResolveClientUrl(BottomRightImageUrl))
        writer.AddAttribute(HtmlTextWriterAttribute.Alt, "")
        writer.RenderBeginTag(HtmlTextWriterTag.Img)
        writer.RenderEndTag()   'End <img>
        writer.RenderEndTag()   'End <td>

        writer.RenderEndTag()   'End <tr>

        writer.RenderEndTag()   'End <table>
    End Sub

#End Region

End Class