Imports System.ComponentModel

<DefaultProperty("Text")> _
<ParseChildren(False)> _
Public Class MenuBoxTitle
    Inherits MenuBoxItem

#Region " Public Properties "
    <Category("Appearance"), NotifyParentProperty(True)> _
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
#End Region

    Protected Overrides ReadOnly Property TagKey() As HtmlTextWriterTag
        Get
            Return HtmlTextWriterTag.Div
        End Get
    End Property

    Protected Overrides Sub AddAttributesToRender(ByVal writer As System.Web.UI.HtmlTextWriter)
        Dim resetCss As Boolean = False
        If String.IsNullOrEmpty(Me.ControlStyle.CssClass) Then
            Dim mb As MenuBox = TryCast(Me.Parent, MenuBox)
            If Not String.IsNullOrEmpty(mb.TitleCssClass) Then
                Me.ControlStyle.CssClass = mb.TitleCssClass
                resetCss = True
            End If
        End If
        MyBase.AddAttributesToRender(writer)
        If resetCss Then
            Me.ControlStyle.CssClass = ""
        End If
    End Sub

    Protected Overrides Sub RenderContents(ByVal writer As HtmlTextWriter)
        writer.Write(Me.Text)
    End Sub

End Class
