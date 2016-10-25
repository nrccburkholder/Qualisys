Public Class Privacy
    Inherits System.Web.UI.Page
    Protected WithEvents imgLogoLeft As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents datCopyRight As System.Web.UI.WebControls.Label

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

    Protected ReadOnly Property BrandName() As String
        Get
            Return AppConfig.Instance.BrandName
        End Get
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            Select Case AppConfig.Instance.Locale
                Case AppConfig.LocaleEnum.USA
                    Me.imgLogoLeft.Src = "Img/NRCPicker/HeaderLeftUS.gif"
                Case AppConfig.LocaleEnum.Canada
                    Me.imgLogoLeft.Src = "Img/NRCPicker/HeaderLeftCA.gif"
            End Select

            datCopyRight.Text = returnCopyRightYear()
        End If
    End Sub

    ' used in footers to generate the current year for the copyright
    Public Function returnCopyRightYear() As String
        Dim myYear As Integer
        Dim myNow As Date
        myNow = Date.Now
        myYear = Year(myNow)
        Return myYear
    End Function

    ' used in footers to create a day of week, month, day, year string
    Public Function returnDayString() As String
        Dim myNow As Date
        myNow = Date.Now
        Return Format(myNow, "dddd, MMMM d,  yyyy")
    End Function

End Class
