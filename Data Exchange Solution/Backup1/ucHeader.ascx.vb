Imports System.ComponentModel
Imports System.Web.Security

Public MustInherit Class ucHeader
    Inherits System.Web.UI.UserControl
    Protected WithEvents tblLogout As System.Web.UI.HtmlControls.HtmlTable
    Protected WithEvents homeLink As System.Web.UI.HtmlControls.HtmlGenericControl
    Protected WithEvents lnkNRCPicker As System.Web.UI.HtmlControls.HtmlAnchor
    Protected WithEvents imgHeaderLeft As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents Img2 As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents Img3 As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents Img4 As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents Img5 As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents Img6 As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents Img7 As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents lnkHome As System.Web.UI.HtmlControls.HtmlAnchor
    Protected WithEvents spnLN As System.Web.UI.HtmlControls.HtmlGenericControl
    Protected WithEvents spnSolutions As System.Web.UI.HtmlControls.HtmlGenericControl
    Protected WithEvents lnkSolutions As System.Web.UI.HtmlControls.HtmlAnchor
    Protected WithEvents imgSolutions As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents spneReports As System.Web.UI.HtmlControls.HtmlGenericControl
    Protected WithEvents lnkeReports As System.Web.UI.HtmlControls.HtmlAnchor
    Protected WithEvents spneComments As System.Web.UI.HtmlControls.HtmlGenericControl
    Protected WithEvents lnkeComments As System.Web.UI.HtmlControls.HtmlAnchor
    Protected WithEvents spneToolKit As System.Web.UI.HtmlControls.HtmlGenericControl
    Protected WithEvents lnkeToolKit As System.Web.UI.HtmlControls.HtmlAnchor
    Protected WithEvents lnkAccount As System.Web.UI.HtmlControls.HtmlAnchor
    Protected WithEvents spnAccount As System.Web.UI.HtmlControls.HtmlGenericControl
    Protected WithEvents spnHCAHPS As System.Web.UI.HtmlControls.HtmlGenericControl
    Protected WithEvents Img1 As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents Img8 As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents password As System.Web.UI.HtmlControls.HtmlGenericControl

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region


    Protected ReadOnly Property ImgPath() As String
        Get
            Return Me.ResolveUrl("~/Img/NRCPicker/")
        End Get
    End Property

    Protected ReadOnly Property NRCPickerUrl() As String
        Get
            Return AppConfig.Instance.NRCPickerUrl.ToString
        End Get
    End Property
    Protected ReadOnly Property WWWNRCPickerUrl() As String
        Get
            Return AppConfig.Instance.WWWNRCPickerUrl.ToString
        End Get
    End Property

    Private bolLogin As Boolean = False
    Private bolChangePassword As Boolean = False

    <Bindable(True), Category("Misc"), Description("Determines if control is on login page.")> _
    Public Property LoginPage() As Boolean
        Get
            Return bolLogin
        End Get
        Set(ByVal Value As Boolean)
            bolLogin = Value
        End Set
    End Property

    <Bindable(True), Category("Password"), Description("Determines if control is on the page.")> _
    Public Property showPassword() As Boolean
        Get
            Return bolChangePassword
        End Get
        Set(ByVal Value As Boolean)
            bolChangePassword = Value
        End Set
    End Property

    Private Function getPageName() As String
        'Determine what page we are on...
        Dim strURL As String = Request.Url.AbsoluteUri.ToString
        Dim astrURL() As String = Split(strURL, "/")
        Dim strThisPageTemp As String = astrURL(UBound(astrURL))
        Dim astrThisPage() As String = Split(strThisPageTemp, ".")
        Dim strThisPage As String = astrThisPage(0)
        Return strThisPage
    End Function

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim isAuthenticated As Boolean = Context.User.Identity.IsAuthenticated

        If Not Page.IsPostBack Then
            Select Case AppConfig.Instance.Locale
                Case AppConfig.LocaleEnum.USA
                    Me.imgHeaderLeft.Src = "Img/NRCPicker/HeaderLeftUS.gif"
                    'Me.spnHCAHPS.Visible = True
                Case AppConfig.LocaleEnum.Canada
                    Me.imgHeaderLeft.Src = "Img/NRCPicker/HeaderLeftCA.gif"
                    'Me.spnHCAHPS.Visible = False
            End Select
        End If
        If Not isAuthenticated Then
            'If anonymous then hide sign out 
            tblLogout.Visible = False
        End If

        If LoginPage() Then
            homeLink.Visible = False
        End If

        password.Visible = bolChangePassword

        'Set all of the hyperlink urls
        Me.lnkNRCPicker.HRef = Me.ResolveUrl(WWWNRCPickerUrl)
        Me.lnkHome.HRef = Me.ResolveUrl(WWWNRCPickerUrl)
        'Me.lnkSiteMap.HRef = Me.ResolveUrl(WWWNRCPickerUrl & "Pages/SiteMap.aspx")
        'Me.lnkAbout.HRef = Me.ResolveUrl(NRCPickerUrl & "Default.aspx?DN=2,1,Documents")
        'Me.lnkProducts.HRef = Me.ResolveUrl(NRCPickerUrl & "Default.aspx?DN=3,1,Documents")
        Me.lnkSolutions.HRef = Me.ResolveUrl(WWWNRCPickerUrl & "products-and-solutions/patient-and-family-experience/my-solutions/")
        Me.lnkeReports.HRef = Me.ResolveUrl(NRCPickerUrl & "eReports")
        Me.lnkeComments.HRef = Me.ResolveUrl(NRCPickerUrl & "eComments")
        'Me.lnkeToolKit.HRef = Me.ResolveUrl(NRCPickerUrl & "eToolKit")
        Me.lnkAccount.HRef = Me.ResolveUrl(NRCPickerUrl & "MyAccount")
        'Me.lnkHCAHPS.HRef = Me.ResolveUrl(NRCPickerUrl & "Default.aspx?DN=574,1,Documents")
        'Me.lnkLN.HRef = Me.ResolveUrl(WWWNRCPickerUrl & "PCC%20Institute/Pages/Default.aspx")
    End Sub


    Private Sub ibtSignOut_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Cookies("ASP.NET_SessionId").Value = ""
        FormsAuthentication.SignOut()
        Response.Redirect(Request.ApplicationPath)
    End Sub
End Class
