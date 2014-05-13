Imports WebSupergoo.ABCUpload6
Partial Public Class progressbar
    Inherits System.Web.UI.Page

    Protected State As String
    Protected Meta As String
    Protected Percent As String
    Protected Kbps As String
    Protected Note As String
    Protected FileName As String

    Protected Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim theProgress As Progress = New Progress(Request.QueryString("ProgressID"))
        Dim theID As String = theProgress.ID.ToString()
        Dim theMins As String = CInt(theProgress.SecondsLeft / 60).ToString()
        Dim theSecs As String = (CInt(theProgress.SecondsLeft) Mod 60).ToString()
        Meta = "<meta http-equiv=""refresh"" content=""2,progressbar.aspx?ProgressID=" + theID + """>"
        Percent = theProgress.PercentDone.ToString()
        Kbps = Math.Round(theProgress.BytesPerSecondCurrent / 1024, 1).ToString()
        Dim theKbdone As String = Math.Round(CDbl(theProgress.BytesDone) / 1024, 1).ToString()
        Dim theKbtotal As String = Math.Round(CDbl(theProgress.BytesTotal) / 1024, 1).ToString()
        Note = theProgress.Note
        FileName = theProgress.FileName
        If theProgress.Finished = True Then Meta = ""
        State = theMins + " min " + theSecs + " secs (" + theKbdone + " KB of " + theKbtotal + " KB uploaded)"
    End Sub


End Class