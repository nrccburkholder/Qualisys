Imports System.IO

Public Class Download
    Inherits System.Web.UI.Page
    Protected WithEvents litJScript As System.Web.UI.WebControls.Literal
    Protected WithEvents tblFileInfo As System.Web.UI.WebControls.Table

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
        Dim objUploadServer As UploadServer = Session("UpLoadServer")
        Dim fileName As String = objUploadServer.FileToDownload.FileNameNew
        Dim upLoadPath As String = objUploadServer.FileToDownload.FilePath
        Dim filePath As String = upLoadPath & fileName

        Dim strContent As String

        If File.Exists(filePath) Then
            Dim qContents As Queue = New Queue()
            Dim lastDownload As Object
            Dim daysRemaining As Integer
            daysRemaining = DateDiff(DateInterval.Day, Now, objUploadServer.FileToDownload.DateExpires)
            With qContents
                .Enqueue("Here is the file you requested. Select the file name to download or view the file.")
                .Enqueue("<li>File Name: <a href='openfile.aspx' onclick='return incrementdl();'>" & objUploadServer.FileToDownload.FileNameNew & "</a>")
                .Enqueue("<li>Description: " & objUploadServer.FileToDownload.Description)
                .Enqueue("<li>Date Uploaded: " & Format(objUploadServer.FileToDownload.DatePosted, "Short Date"))
                If objUploadServer.FileToDownload.DownloadCount = 0 Then
                    lastDownload = "Never"
                Else
                    lastDownload = Format(objUploadServer.FileToDownload.DateLastDownload, "Short Date")
                End If
                .Enqueue("<li>Last Downloaded: " & lastDownload)
                .Enqueue("<li>Removal Date: " & Format(objUploadServer.FileToDownload.DateExpires, "Short Date") & " (" & daysRemaining & " days remaining)")
                .Enqueue("<li>Number of Downloads: <span id='fcounter'>" & objUploadServer.FileToDownload.DownloadCount & "</span>")
            End With

            ' build a javascript alert if the max downloads or date expires has been reached
            Dim msg As String
            If (objUploadServer.FileToDownload.DownloadCount + 1) = objUploadServer.FileToDownload.MaxDownloads Then
                msg = "This file can be downloaded a maximum of " & objUploadServer.FileToDownload.MaxDownloads & " times.\r\r"
                msg += "This will be the last time you can download this information."
            ElseIf daysRemaining = 0 Then
                msg = "The file you have requested expires today.\r\r"
                msg += "After today this file will no longer be available for download."
           End If

            ' if an expires message was built activate the javascript block
            If Not msg Is Nothing Then
                litJScript.Text = "window.alert('" & msg & "')"
                litJScript.Visible = True
            End If

            ' build a table row to display the file information
            For Each strContent In qContents
                createCellRow(strContent, tblFileInfo)
            Next
        Else
            strContent = "Sorry, the file you requested, <b>" & objUploadServer.FileToDownload.FileNameNew & "</b>, is not available."
            createCellRow(strContent, tblFileInfo)
        End If
    End Sub

    ' builds table rows and cells
    Private Function createCellRow(ByVal cellContents As String, ByRef tb As Table)
        Dim tr As TableRow = New TableRow()
        Dim td As TableCell = New TableCell()
        td.Text = cellContents
        tr.Cells.Add(td)
        tb.Rows.Add(tr)
    End Function

End Class
