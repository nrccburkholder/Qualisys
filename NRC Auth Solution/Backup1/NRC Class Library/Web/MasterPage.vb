'//**************************************************************//
'// Paul Wilson -- www.WilsonDotNet.com -- Paul@WilsonDotNet.com // 
'// Feel free to use and modify -- just leave these credit lines // 
'// I also always appreciate any other public credit you provide // 
'//**************************************************************//
Imports System.ComponentModel
Imports System.Web.UI
Imports System.Web.UI.Design

Namespace Web
    <ToolboxData("<{0}:MasterPage runat=server></{0}:MasterPage>"), ToolboxItem(GetType(WebControlToolboxItem)), Designer(GetType(ReadWriteControlDesigner))> _
    Public Class MasterPage
        Inherits System.Web.UI.HtmlControls.HtmlContainerControl

        Private mTemplateFile As String
        'Private mDefaultContent As String
        Private mTemplate As Control = Nothing
        'Private mDefaults As New ContentRegion
        Private mContents As New ArrayList

        <Category("MasterPage"), Description("Path of Template User Control")> _
        Public Property TemplateFile() As String
            Get
                Return mTemplateFile
            End Get
            Set(ByVal Value As String)
                mTemplateFile = Value
            End Set
        End Property

        '<Category("MasterPage"), Description("Control ID for Default Content")> _
        'Public Property DefaultContent() As String
        '    Get
        '        Return mDefaultContent
        '    End Get
        '    Set(ByVal Value As String)
        '        mDefaultContent = Value
        '    End Set
        'End Property

        Public Sub New()
            'If mDefaultContent Is Nothing OrElse mDefaultContent = "" Then
            '    mDefaultContent = "Content"
            'End If
        End Sub

        Protected Overrides Sub AddParsedSubObject(ByVal obj As Object)
            'If any control that is not a ContentRegion is added to this MasterPage
            'Then we will add it to the default ContentRegion
            If obj.GetType Is GetType(ContentRegion) Then
                Me.mContents.Add(obj)
                'Else
                '    Me.mDefaults.Controls.Add(obj)
            End If
        End Sub

        Protected Overrides Sub OnInit(ByVal e As System.EventArgs)
            Me.BuildMasterPage()
            Me.BuildContents()
            MyBase.OnInit(e)
        End Sub

        Private Sub BuildMasterPage()
            If mTemplateFile Is Nothing OrElse mTemplateFile = "" Then
                Throw New Exception("TemplateFile Property for MasterPage must be Defined")
            End If

            'Load the master page
            mTemplate = Page.LoadControl(mTemplateFile)
            mTemplate.ID = Me.ID & "_Template"

            Dim ctrl As Control
            'Take each control off of the master page and add it to this one
            For i As Integer = 0 To Me.mTemplate.Controls.Count - 1
                ctrl = Me.mTemplate.Controls(0)
                Me.mTemplate.Controls.Remove(ctrl)
                If ctrl.Visible Then
                    Me.Controls.Add(ctrl)
                End If
            Next
            Me.Controls.AddAt(0, Me.mTemplate)
        End Sub

        Private Sub BuildContents()
            'If there were default controls added then add the default ContentRegion
            'to our list of content regions
            'If mDefaults.HasControls Then
            '    mDefaults.ID = Me.mDefaultContent
            '    mContents.Add(mDefaults)
            'End If

            Dim region As Control
            Dim ctrl As Control

            'For each content region that we have on this page
            For Each content As ContentRegion In mContents
                'Find the control loaded from the template with a matching ID
                region = Me.FindControl(content.ID)

                'If we can't find one then throw ex
                If region Is Nothing OrElse Not region.GetType Is GetType(ContentRegion) Then
                    Throw New Exception("ContentRegion with ID '" & content.ID & "' must be Defined")
                End If
                'Clear out anything that was added to the region on the template
                region.Controls.Clear()

                'Add each of the controls from the page into the region from the template
                For i As Integer = 0 To content.Controls.Count - 1
                    ctrl = content.Controls(0)
                    content.Controls.Remove(ctrl)
                    region.Controls.Add(ctrl)
                Next
            Next
        End Sub

        Protected Overrides Sub RenderBeginTag(ByVal writer As System.Web.UI.HtmlTextWriter)
        End Sub

        Protected Overrides Sub RenderEndTag(ByVal writer As System.Web.UI.HtmlTextWriter)
        End Sub
    End Class

End Namespace
