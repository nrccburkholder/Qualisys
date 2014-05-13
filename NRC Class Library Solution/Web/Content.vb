Option Strict On

Imports System.ComponentModel
Imports System.Web.UI
Imports System.Web

Namespace Web
    <DefaultProperty("Category"), ToolboxData("<{0}:Content runat=server></{0}:Content>")> _
    Public Class Content
        Inherits System.Web.UI.WebControls.WebControl

#Region " Private Members "
        Private mCategory As String
        Private mKey As String
#End Region

#Region " Public Properties "
        <Bindable(True), Category("Data")> _
        Property Category() As String
            Get
                Return mCategory
            End Get

            Set(ByVal Value As String)
                mCategory = Value
            End Set
        End Property

        <Bindable(True), Category("Data")> _
        Public Property Key() As String
            Get
                Return mKey
            End Get
            Set(ByVal Value As String)
                mKey = Value
            End Set
        End Property

#End Region

        Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)
            If HttpContext.Current Is Nothing Then
                output.Write(GetDesignHtml())
            Else
                output.Write(GetHtml())
            End If

        End Sub

        Public Function GetDesignHtml() As String
            Return "<font face='Verdana' size='1'>RSCM Placeholder</font>"
        End Function

        Public Function GetHtml() As String
            If mCategory Is Nothing OrElse mCategory.Length = 0 Then
                Return "Error rendering control:  Category is null."
            End If
            If mKey Is Nothing OrElse mKey.Length = 0 Then
                Return "Error rendering control:  Key is null."
            End If

            Dim content As ManagedContent = ManagedContent.SelectFromDB(mCategory, mKey, False, ManagedContent.SelectOrder.Alpha)
            If content Is Nothing Then
                Return "Error rendering control:  Content not found."
            End If

            Return content.Content
        End Function


    End Class
End Namespace