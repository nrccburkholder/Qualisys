Imports System.ComponentModel

Partial Public Class eToolKit_UserControls_PageLogo
    Inherits System.Web.UI.UserControl

    Private mTitle As String = ""

    <Category("Appearance")> _
    Public Property Title() As String
        Get
            Return mTitle
        End Get
        Set(ByVal Value As String)
            mTitle = Value
        End Set
    End Property

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        TitleText.Text = " - " & mTitle
        TitleText.Visible = (Not String.IsNullOrEmpty(mTitle))
    End Sub
End Class