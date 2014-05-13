Public Class UploadProgress
    Inherits System.Web.UI.Page
    Protected WithEvents ltlMeta As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlScript As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlMin As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlSec As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlTheKbDone As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlKbTotal As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlTheKbps As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlNote As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlFileName As System.Web.UI.WebControls.Literal
    Protected WithEvents tdProgress As System.Web.UI.HtmlControls.HtmlTable

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

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
        Dim theProgress As New WebSupergoo.ABCUpload5.Progress(Request.QueryString("ProgressID"))
        Dim theID As String = theProgress.ID.ToString
        Dim theMins As String = CInt(theProgress.SecondsLeft / 60).ToString
        Dim theSecs As String = CInt(theProgress.SecondsLeft Mod 60).ToString
        Dim theMeta As String = "<meta http-equiv=""refresh"" content=""2,UploadProgress.aspx?ProgressID=" & theID & """>"
        Dim thePercent As String = theProgress.PercentDone.ToString
        Dim theKbps As String = Math.Round(theProgress.BytesPerSecondCurrent / 1024, 1).ToString
        Dim theKbdone As String = Math.Round(CDbl(theProgress.BytesDone / 1024), 1).ToString
        Dim theKBtotal As String = Math.Round(CDbl(theProgress.BytesTotal / 1024), 1).ToString
        Dim theNote As String = theProgress.Note
        Dim theFileName As String = theProgress.FileName
        If theProgress.Finished Then theMeta = ""

        ltlMeta.Text = theMeta & vbCrLf
        tdProgress.Width = thePercent & "%"
        ltlMin.Text = theMins
        ltlSec.Text = theSecs
        ltlKbTotal.Text = theKBtotal
        ltlTheKbDone.Text = theKbdone
        ltlTheKbps.Text = theKbps
        ltlNote.Text = theNote
        ltlFileName.Text = theFileName
        ltlScript.Text = "<script language=""javascript"">" & vbCrLf
        ltlScript.Text &= "if (" & thePercent & " >= 100) top.close();" & vbCrLf
        ltlScript.Text &= "</script>" & vbCrLf
    End Sub

End Class
