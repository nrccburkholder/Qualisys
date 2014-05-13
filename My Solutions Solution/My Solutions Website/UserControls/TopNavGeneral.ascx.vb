Imports System.ComponentModel

Partial Public Class UserControls_TopNavGeneral
    Inherits System.Web.UI.UserControl

#Region " Public Properties "
    <Bindable(True), Category("Appearance"), DefaultValue(True)> _
    Property ShowAboutUs() As Boolean
        Get
            If ViewState("ShowAboutUs") Is Nothing Then
                Return True
            Else
                Return CBool(ViewState("ShowAboutUs"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowAboutUs") = Value
        End Set
    End Property

    <Bindable(True), Category("Appearance"), DefaultValue(True)> _
    Property ShowProducts() As Boolean
        Get
            If ViewState("ShowProducts") Is Nothing Then
                Return True
            Else
                Return CBool(ViewState("ShowProducts"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowProducts") = Value
        End Set
    End Property

    <Bindable(True), Category("Appearance"), DefaultValue(True)> _
    Property ShowMySolutions() As Boolean
        Get
            If ViewState("ShowMySolutions") Is Nothing Then
                Return True
            Else
                Return CBool(ViewState("ShowMySolutions"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowMySolutions") = Value
        End Set
    End Property

    <Bindable(True), Category("Appearance"), DefaultValue(True)> _
    Property ShowHcahps() As Boolean
        Get
            If ViewState("ShowHcahps") Is Nothing Then
                Return True
            Else
                Return CBool(ViewState("ShowHcahps"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowHcahps") = Value
        End Set
    End Property

    <Bindable(True), Category("Appearance"), DefaultValue(True)> _
    Property ShowLearningNetwork() As Boolean
        Get
            If ViewState("ShowLearningNetwork") Is Nothing Then
                Return True
            Else
                Return CBool(ViewState("ShowLearningNetwork"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowLearningNetwork") = Value
        End Set
    End Property

    <Bindable(True), Category("Appearance"), DefaultValue(False)> _
    Property ShowEReports() As Boolean
        Get
            If ViewState("ShowEReports") Is Nothing Then
                Return False
            Else
                Return CBool(ViewState("ShowEReports"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowEReports") = Value
        End Set
    End Property

    <Bindable(True), Category("Appearance"), DefaultValue(False)> _
    Property ShowEComments() As Boolean
        Get
            If ViewState("ShowEComments") Is Nothing Then
                Return False
            Else
                Return CBool(ViewState("ShowEComments"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowEComments") = Value
        End Set
    End Property

    <Bindable(True), Category("Appearance"), DefaultValue(False)> _
    Property ShowEToolKit() As Boolean
        Get
            If ViewState("ShowEToolKit") Is Nothing Then
                Return False
            Else
                Return CBool(ViewState("ShowEToolKit"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowEToolKit") = Value
        End Set
    End Property

    <Bindable(True), Category("Appearance"), DefaultValue(False)> _
    Property ShowMyAccount() As Boolean
        Get
            If ViewState("ShowMyAccount") Is Nothing Then
                Return False
            Else
                Return CBool(ViewState("ShowMyAccount"))
            End If
        End Get

        Set(ByVal Value As Boolean)
            ViewState("ShowMyAccount") = Value
        End Set
    End Property

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Me.SetLinkVisibility()
    End Sub

    ''' <summary>
    '''  
    ''' </summary>
    ''' <remarks>2008-04-07 - Steve Kennedy - Changed MySolutions Link to WWWNrcPickerURl and URL provided by Ted on 4/7</remarks>
    Private Sub SetLinkVisibility()
        Dim needSpacer As Boolean = False
        Me.AboutUsLink.Visible = Me.ShowAboutUs
        needSpacer = (needSpacer OrElse Me.ShowAboutUs)
        If Me.ShowAboutUs Then Me.AboutUsLink.NavigateUrl = Config.NrcPickerUrl & "/Default.aspx?DN=2,1,Documents&l=English"

        Me.ProductsSpacer.Visible = (Me.ShowProducts AndAlso needSpacer)
        Me.ProductsLink.Visible = Me.ShowProducts
        needSpacer = (needSpacer OrElse Me.ShowProducts)
        If Me.ShowProducts Then Me.ProductsLink.NavigateUrl = Config.NrcPickerUrl & "/Default.aspx?DN=3,1,Documents&l=English"

        Me.MySolutionsSpacer.Visible = (Me.ShowMySolutions AndAlso needSpacer)
        Me.MySolutionsLink.Visible = Me.ShowMySolutions
        needSpacer = (needSpacer OrElse Me.ShowMySolutions)
        If Me.ShowMySolutions Then Me.MySolutionsLink.NavigateUrl = Config.WWWNrcPickerUrl & "/Pages/MySolutions.aspx"

        Me.HcahpsSpacer.Visible = (Me.ShowHcahps AndAlso needSpacer)
        Me.HcahpsLink.Visible = Me.ShowHcahps
        needSpacer = (needSpacer OrElse Me.ShowHcahps)
        If Me.ShowHcahps Then Me.HcahpsLink.NavigateUrl = Config.NrcPickerUrl & "/Default.aspx?DN=333,1,Documents&amp;l=English"

        Me.LearningNetworkSpacer.Visible = (Me.ShowLearningNetwork AndAlso needSpacer)
        Me.LearningNetworkLink.Visible = Me.ShowLearningNetwork
        needSpacer = (needSpacer OrElse Me.ShowLearningNetwork)
        If Me.ShowLearningNetwork Then Me.LearningNetworkLink.NavigateUrl = Config.NrcPickerUrl & "/Default.aspx?DN=888,1,Documents"

        Me.EReportsSpacer.Visible = (Me.ShowEReports AndAlso needSpacer)
        Me.EReportsLink.Visible = Me.ShowEReports
        needSpacer = (needSpacer OrElse Me.ShowEReports)
        If Me.ShowEReports Then Me.EReportsLink.NavigateUrl = Config.eReportsUrl

        Me.ECommentsSpacer.Visible = (Me.ShowEComments AndAlso needSpacer)
        Me.ECommentsLink.Visible = Me.ShowEComments
        needSpacer = (needSpacer OrElse Me.ShowEComments)
        If Me.ShowEComments Then Me.ECommentsLink.NavigateUrl = Config.eCommentsUrl

        Me.EToolKitSpacer.Visible = (Me.ShowEToolKit AndAlso needSpacer)
        Me.EToolKitLink.Visible = Me.ShowEToolKit
        needSpacer = (needSpacer OrElse Me.ShowEToolKit)

        Me.MyAccountSpacer.Visible = (Me.ShowMyAccount AndAlso needSpacer)
        Me.MyAccountLink.Visible = Me.ShowMyAccount
        needSpacer = (needSpacer OrElse Me.ShowMyAccount)
        If Me.ShowMyAccount Then Me.MyAccountLink.NavigateUrl = Config.GroupSelectorUrl(Me.Page)
    End Sub

    Private Sub LoginStatus1_LoggedOut(ByVal sender As Object, ByVal e As System.EventArgs) Handles LoginStatus1.LoggedOut
        Nrc.NRCAuthLib.FormsAuth.SignOut("~/eToolKit/")
        'Response.Cookies("ASP.NET_SessionId").Value = ""
    End Sub

End Class