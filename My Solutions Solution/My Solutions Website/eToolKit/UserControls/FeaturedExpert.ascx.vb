Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_UserControls_FeaturedExpert
    Inherits System.Web.UI.UserControl

    Private Shared mRand As Random
    Private Shared ReadOnly Property Rand() As Random
        Get
            If mRand Is Nothing Then
                mRand = New Random
            End If
            Return mRand
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If String.IsNullOrEmpty(SessionInfo.FeaturedExpertKey) Then
                Dim keys As List(Of String) = ManagedContent.GetKeyList("Experts")
                Dim i As Integer = Rand.Next(0, keys.Count)
                SessionInfo.FeaturedExpertKey = keys(i)
            End If

            Me.ExpertsTeaser.ContentKey = SessionInfo.FeaturedExpertKey

            'Set URL for dimension experts link
            Me.ExpertsTeaser.DetailPageUrl = Config.NrcPickerUrl & "Default.aspx?DN=882,22,2,1,Documents#{1}"
        End If
    End Sub

End Class