Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Security

Public Class openFile
    Inherits System.Web.UI.Page

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
        'instantiate variables and create full file path
        Dim objUploadServer As UploadServer = Session("UploadServer")
        Dim fileName As String = objUploadServer.FileToDownload.FileNameNew
        Dim upLoadPath As String = objUploadServer.FileToDownload.FilePath
        Dim filePath As String = upLoadPath & fileName

        ' open the file
        Open_File(objUploadServer, filePath)
    End Sub

    Private Sub Page_Unload(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Unload
        ' log out user
        FormsAuthentication.SignOut()
        Session.Abandon()
    End Sub

    Private Sub Open_File(ByRef objUploadServer As UploadServer, ByVal filePath As String)
        Dim MyFileStream As FileStream
        Dim FileSize As Long
        Dim maxDownloads As Integer = objUploadServer.FileToDownload.MaxDownloads
        Dim timesDownLoaded As Integer = objUploadServer.FileToDownload.DownloadCount
        Dim thisFileID As Integer = objUploadServer.FileToDownload.PostedFileID

        ' open the file and send the stream to the browser
            ' start dev code
            ' get the file name
            Dim thisFileName As String = Path.GetFileName(filePath)
            ' get the document mime type based upon the file extension
            Dim mType As String = getMimeType(Path.GetFileName(filePath))
            ' end dev code

            ' set the content type
            With Response
                .ClearHeaders()
                If Not mType Is "Other" Then
                    .ContentType = mType
                    ' the Content-Disposition header will set the file name in the save dialog
                    .AddHeader("Content-Disposition", "inline; filename=" & thisFileName)
                Else     ' we don't know the mime-type
                    .ContentType = "unknown/unknown"
                    ' the Content-Disposition header will set the file name in the save dialog
                    .AddHeader("Content-Disposition", "Attachment; filename=" & thisFileName)
                    .AddHeader("Content-Description", "Unknown content type")
                End If
            End With

            ' open a filestream
            MyFileStream = New FileStream(filePath, FileMode.Open)
            ' length of filestream
            FileSize = MyFileStream.Length
            Dim Buffer(CInt(FileSize)) As Byte
            With MyFileStream
                ' read the filestream and put it in the buffer
                .Read(Buffer, 0, CInt(FileSize))
                ' close the filestream
                .Close()
            End With

            ' write the buffer to the page
            Response.BinaryWrite(Buffer)

            'increment the number of times downloaded
            timesDownLoaded = timesDownLoaded + 1

            ' record the download in the database
            objUploadServer.RecordUserDownload(thisFileID)

            ' delete the file and flag the database if we've reached the maximum number of downloads
            If timesDownLoaded >= maxDownloads Then
                File.Delete(filePath)
                objUploadServer.DeleteFile(thisFileID)
            End If

    End Sub

    ' returns the mime-type for the document
    Private Function getMimeType(ByVal fileName As String)
        ' start development code, this will be a routine later
        ' Hashtable of mime-types we'll handle
        Dim hashMimes As New Hashtable()
        Dim thisFileInfo As FileInfo
        Dim strFileExt As String

        ' supported mime-types
        With hashMimes
            .Add(".doc", "application/msword")
            .Add(".xls", "application/vnd.ms-excel")
            .Add(".pdf", "application/pdf")
            .Add(".rft", "application/rtf")
            .Add(".zip", "application/zip")
            .Add(".sit", "application/x-stuffit")
            .Add(".txt", "text/plain")
            .Add(".html", "text/html")
            .Add(".htm", "text/html")
            .Add(".tsv", "text/tab-separated-values")
        End With

        ' get the file extention from the passed-in path
        thisFileInfo = New FileInfo(fileName)
        strFileExt = thisFileInfo.Extension

        ' return the mime-type if supported, otherwise return "Other"
        If hashMimes.ContainsKey(strFileExt) Then
            Return hashMimes.Item(strFileExt)
        Else
            Return "Other"
        End If
    End Function

End Class
