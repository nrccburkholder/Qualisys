Imports System
Imports System.ComponentModel
Imports System.Drawing.Design
Imports System.Web.UI
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls

Namespace Web
    <ToolboxData("<{0}:CollapsePanel runat=server></{0}:CollapsePanel>")> _
    Public Class CollapsePanel
        Inherits System.Web.UI.WebControls.Panel
        Implements INamingContainer

        Private vbCrLf As String = Environment.NewLine


#Region " Private Members "
        Private collapseBtn As ImageButton
        Private headerLabel As Label
        Private Const scriptKey As String = "CollpasePanel"
        Private tracker As HtmlInputHidden

        Private headerPanel As Panel
        Private contentPanel As Panel
#End Region

#Region " Public Properties "
        <DefaultValue("True")> _
        Public Overridable Property AllowCollapse() As Boolean
            Get
                Dim allow As Object = Me.ViewState.Item("AllowCollapse")
                If Not allow Is Nothing Then
                    Return CType(allow, Boolean)
                End If
                Return True
            End Get
            Set(ByVal Value As Boolean)
                Me.ViewState.Item("AllowCollapse") = Value
            End Set
        End Property
        <DefaultValue("")> _
        Public Overridable Property ContentCssClass() As String
            Get
                Dim css As Object = Me.ViewState.Item("ContentCssClass")
                If (Not css Is Nothing) Then
                    Return CType(css, String)
                End If
                Return ""
            End Get
            Set(ByVal value As String)
                Me.ViewState.Item("ContentCssClass") = value
            End Set
        End Property

        <DefaultValue("")> _
        Public Overridable Property HeaderCssClass() As String
            Get
                Dim css As Object = Me.ViewState.Item("HeaderCssClass")
                If (Not css Is Nothing) Then
                    Return CType(css, String)
                End If
                Return ""
            End Get
            Set(ByVal value As String)
                Me.ViewState.Item("HeaderCssClass") = value
            End Set
        End Property

        <DefaultValue("")> _
        Public Overridable Property ButtonCssClass() As String
            Get
                Dim css As Object = Me.ViewState.Item("ButtonCssClass")
                If (Not css Is Nothing) Then
                    Return CType(css, String)
                End If
                Return ""
            End Get
            Set(ByVal value As String)
                Me.ViewState.Item("ButtonCssClass") = value
            End Set
        End Property

        <DefaultValue(""), Description("Collapse link image URL"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
        Public Overridable Property ButtonImage() As String
            Get
                Dim imgPath As Object = Me.ViewState.Item("ButtonImage")
                If (Not imgPath Is Nothing) Then
                    Return CType(imgPath, String)
                End If
                Return ""
            End Get
            Set(ByVal value As String)
                Me.ViewState.Item("ButtonImage") = value
            End Set
        End Property

        <Description("Collapse link image URL"), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor)), DefaultValue("")> _
        Public Overridable Property ButtonImageCollapsed() As String
            Get
                Dim imgPath As Object = Me.ViewState.Item("ButtonImageCollapsed")
                If (Not imgPath Is Nothing) Then
                    Return CType(imgPath, String)
                End If
                Return ""
            End Get
            Set(ByVal value As String)
                Me.ViewState.Item("ButtonImageCollapsed") = value
            End Set
        End Property

        <DefaultValue(False)> _
        Public Overridable Property Collapsed() As Boolean
            Get
                Dim isCollapsed As Object = Me.ViewState.Item("Collapsed")
                If (Not isCollapsed Is Nothing) Then
                    Return CType(isCollapsed, Boolean)
                End If
                Return False
            End Get
            Set(ByVal value As Boolean)
                Me.ViewState.Item("Collapsed") = value
            End Set
        End Property

        Public Overrides ReadOnly Property Controls() As ControlCollection
            Get
                Me.EnsureChildControls()
                Return MyBase.Controls
                'Return Me.contentPanel.Controls
            End Get
        End Property
        Private ReadOnly Property OriginalControls() As ControlCollection
            Get
                Return MyBase.Controls
            End Get
        End Property

        Protected Overrides ReadOnly Property TagKey() As HtmlTextWriterTag
            Get
                Return HtmlTextWriterTag.Div
            End Get
        End Property

        <DefaultValue("Caption")> _
        Public Overridable Property [Text]() As String
            Get
                Dim txt As Object = Me.ViewState.Item("Text")
                If (Not txt Is Nothing) Then
                    Return CType(txt, String)
                End If
                Return "Caption"
            End Get
            Set(ByVal value As String)
                Me.ViewState.Item("Text") = value
            End Set
        End Property

        <DefaultValue(1)> _
        Public Overridable Property TextAlign() As TextAlign
            Get
                Dim align As Object = Me.ViewState.Item("TextAlign")
                If (Not align Is Nothing) Then
                    Return CType(align, TextAlign)
                End If
                Return TextAlign.Left
            End Get
            Set(ByVal value As TextAlign)
                Me.ViewState.Item("TextAlign") = value
            End Set
        End Property

        <DefaultValue("")> _
        Public Overridable Property TextCssClass() As String
            Get
                Dim css As Object = Me.ViewState.Item("TextCssClass")
                If (Not css Is Nothing) Then
                    Return CType(css, String)
                End If
                Return ""
            End Get
            Set(ByVal value As String)
                Me.ViewState.Item("TextCssClass") = value
            End Set
        End Property

        Private ReadOnly Property ClientScript() As String
            Get
                Dim js As New System.Text.StringBuilder
                js.Append("<script type='text/javascript' language='javascript'>") : js.Append(vbCrLf)
                js.Append("function ExpanderPanel_Toggle( targetID, buttonID, trackerID, imageUrl, collapsedImageUrl ) {") : js.Append(vbCrLf)
                js.Append("	if ( document.getElementById ) {") : js.Append(vbCrLf)
                js.Append("		var target = document.getElementById( targetID );") : js.Append(vbCrLf)
                js.Append("		if ( target != null ) {") : js.Append(vbCrLf)
                js.Append("			target.style.display = ( target.style.display != ""none"" ) ? ""none"" : """";") : js.Append(vbCrLf)
                js.Append("		}") : js.Append(vbCrLf)
                js.Append("		if ( collapsedImageUrl != """" ) {") : js.Append(vbCrLf)
                js.Append("			var imageButton = document.getElementById( buttonID );") : js.Append(vbCrLf)
                js.Append("			if ( imageButton != null ) {") : js.Append(vbCrLf)
                js.Append("				imageButton.src = ( target.style.display != ""none"" ) ? collapsedImageUrl : imageUrl;") : js.Append(vbCrLf)
                js.Append("			}") : js.Append(vbCrLf)
                js.Append("		}") : js.Append(vbCrLf)
                js.Append("		var tracker = document.getElementById( trackerID );") : js.Append(vbCrLf)
                js.Append("		if ( tracker != null ) {") : js.Append(vbCrLf)
                js.Append("			tracker.value = ( target.style.display == ""none"" ) ? ""True"" : ""False"";") : js.Append(vbCrLf)
                js.Append("		}") : js.Append(vbCrLf)
                js.Append("		return false;") : js.Append(vbCrLf)
                js.Append("	}") : js.Append(vbCrLf)
                js.Append("	return true;") : js.Append(vbCrLf)
                js.Append("}") : js.Append(vbCrLf)
                js.Append("</script>")
                Return js.ToString
            End Get
        End Property
#End Region

        Public Sub New()
            Me.headerPanel = New Panel
            Me.headerPanel.ID = "headerPanel"

            Me.contentPanel = New Panel
            Me.contentPanel.ID = "contentPanel"
            Me.contentPanel.EnableViewState = True
        End Sub

#Region " Overriding Methods "
        Protected Overrides Sub CreateChildControls()
            Me.headerPanel.CssClass = Me.HeaderCssClass
            Me.contentPanel.CssClass = Me.ContentCssClass

            Me.tracker = New HtmlInputHidden
            Me.tracker.Name = "tracker"
            Me.tracker.ID = "tracker"
            AddHandler Me.tracker.ServerChange, New EventHandler(AddressOf Me.ClientExpanedStateChanged)
            Me.headerPanel.Controls.Add(Me.tracker)

            Me.headerLabel = New Label
            Me.headerLabel.ID = "label"

            Me.collapseBtn = New ImageButton
            Me.collapseBtn.CausesValidation = False
            Me.collapseBtn.ID = "clicker"
            AddHandler Me.collapseBtn.Click, New ImageClickEventHandler(AddressOf Me.button_Click)

            If Me.TextAlign = TextAlign.Left Then
                Me.headerPanel.Controls.Add(Me.headerLabel)
                Me.headerPanel.Controls.Add(Me.collapseBtn)
            Else
                Me.headerPanel.Controls.Add(Me.collapseBtn)
                Me.headerPanel.Controls.Add(Me.headerLabel)
            End If


            Me.OriginalControls.Add(headerPanel)
            Me.headerPanel.Controls.Add(contentPanel)
        End Sub

        Protected Overrides Sub OnPreRender(ByVal e As EventArgs)
            Me.EnsureChildControls()
            MyBase.OnPreRender(e)
            'If Not Me.csContext.User.EnableCollapsingPanels Then
            'Me.Collapsed = False
            'End If

            'If Me.AllowCollapse Then
            If Not Me.Page.IsClientScriptBlockRegistered(CollapsePanel.scriptKey) Then
                Me.Page.RegisterClientScriptBlock(CollapsePanel.scriptKey, Me.ClientScript)
            End If

            Me.tracker.Value = Me.Collapsed.ToString
            If Me.Collapsed Then
                Me.contentPanel.Style.Item("display") = "none"
            Else
                If (Not Me.contentPanel.Style.Item("display") Is Nothing) Then
                    Me.contentPanel.Style.Remove("display")
                End If
            End If
            'End If
        End Sub

        Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)
            If (Not Me.Page Is Nothing) Then
                Me.Page.VerifyRenderingInServerForm(Me)
            End If
            Me.ApplyPropertiesToChildren()
            MyBase.Render(writer)
        End Sub
#End Region


        Private Sub button_Click(ByVal sender As Object, ByVal e As ImageClickEventArgs)
            Me.Collapsed = Not Me.Collapsed
        End Sub

        Private Sub ClientExpanedStateChanged(ByVal sender As Object, ByVal e As EventArgs)
            Try
                Dim isCollapsed As Boolean = Boolean.Parse(Me.tracker.Value)
                Me.Collapsed = isCollapsed
            Catch ex As Exception
            End Try
        End Sub

        Private Sub ApplyPropertiesToChildren()
            Me.EnsureChildControls()

            Dim objArray1 As Object() = New Object() {Me.contentPanel.ClientID, Me.collapseBtn.ClientID, Me.tracker.ClientID, MyBase.ResolveUrl(Me.ButtonImage), MyBase.ResolveUrl(Me.ButtonImageCollapsed)}
            Me.collapseBtn.Attributes.Item("onclick") = String.Format("return ExpanderPanel_Toggle('{0}','{1}','{2}','{3}','{4}');", objArray1)
            Me.collapseBtn.CssClass = Me.ButtonCssClass
            Me.headerLabel.Text = Me.Text
            Me.headerLabel.CssClass = Me.TextCssClass
            If Me.Collapsed Then
                Me.collapseBtn.ImageUrl = Me.ButtonImage
            Else
                Me.collapseBtn.ImageUrl = Me.ButtonImageCollapsed
            End If

            Me.collapseBtn.Visible = Me.AllowCollapse
        End Sub

        Protected Overrides Sub AddParsedSubObject(ByVal obj As Object)
            Dim ctrl As Control = CType(obj, Control)
            Me.EnsureChildControls()
            Me.contentPanel.Controls.Add(ctrl)
        End Sub

        Public Sub AddInnerControl(ByVal ctrl As Control)
            Me.EnsureChildControls()
            Me.contentPanel.Controls.Add(ctrl)
        End Sub

        Protected Overrides Sub LoadViewState(ByVal savedState As Object)
            MyBase.LoadViewState(savedState)
        End Sub
    End Class

End Namespace
