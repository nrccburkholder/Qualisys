Partial  Class HtmlEditor
    Inherits System.Web.UI.UserControl
    Protected tbEditText As String
    Protected EditText As String
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

    Public Property Text() As String
        Get
            Dim oEditText As String = HttpUtility.HtmlDecode(Request.Params("tbEditTextName"))
            If oEditText = "<p>&nbsp;</p>" Then oEditText = ""
            Return oEditText

        End Get
        Set(ByVal Value As String)
            EditText = Value
            tbEditText = HttpUtility.HtmlEncode(Value)
        End Set
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Me.IsPostBack Then
            EditText = HttpUtility.HtmlDecode(Request.Params("tbEditTextName"))
            tbEditText = HttpUtility.HtmlEncode(Request.Params("tbEditTextName"))
        End If
    End Sub

End Class