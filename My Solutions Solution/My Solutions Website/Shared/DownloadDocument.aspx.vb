Imports Nrc.NRCWebDocumentManagerLibrary
Imports Nrc.DataMart.MySolutions.Library
Imports System.io
Imports Log = NRC.NRCAuthLib.SecurityLog

Partial Public Class DownloadDocument
    Inherits ToolKitPage

    Private ReadOnly Property DocumentNodeId() As Integer
        Get
            Return CType(Request.QueryString("id"), Integer)
        End Get
    End Property

    Private ReadOnly Property DocumentType() As String
        Get
            Return Request.QueryString("type")
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Select Case DocumentType
            Case "mr"
                Dim resource As MemberResource = MemberResource.GetMemberResource(DocumentNodeId)
                If resource IsNot Nothing Then
                    DownloadDocument(resource)
                End If

            Case Else
                'Look up the document
                Dim doc As Document = Document.GetDocument(DocumentNodeId)

                'Make sure the requesting user is authorized for this document 
                'so people can't query string hack
                If CurrentUser.SelectedGroup IsNot Nothing AndAlso doc.AuthorizeMemberDownload(CurrentUser.SelectedGroup.GroupId) Then
                    'Give it to them
                    LogDownloadSuccess(doc.DocumentId, doc.DocumentNodeId)
                    DownloadDocument(doc)
                Else
                    LogDownloadFailure(doc.DocumentId)
                End If
        End Select

    End Sub

    Private Sub DownloadDocument(ByVal doc As MemberResource)
        'Build out the real path
        Dim docPath As String = Path.Combine(Config.MemberResourcePath, doc.FilePath)
        DownloadDocument(doc.Title, docPath)
    End Sub

    Private Sub DownloadDocument(ByVal doc As Document)
        'Build out the real path
        'Dim docPath As String = Config.WebDocumentPath & doc.FilePath
        Dim docPath As String = Path.Combine(Config.WebDocumentPath, doc.FilePath)
        DownloadDocument(doc.Name, docPath)
    End Sub

    Private Sub DownloadDocument(ByVal docName As String, ByVal docPath As String)

        'Verify file exists
        If Not File.Exists(docPath) Then
            Throw New System.IO.FileNotFoundException(String.Format("Web document '{0}' not found.", docPath), docPath)
        End If

        'Build the file name for the user
        Dim downloadFile As New FileInfo(docPath)
        Dim fileName As String = BuildFileName(docName, downloadFile.Extension)
        Dim mimeType As String = GetMIMEType(downloadFile.Extension)

        'Write the file on the response
        Response.Clear()
        Response.ContentType = mimeType
        Response.AddHeader("Content-Disposition", "attachment; filename=" & fileName)
        Response.WriteFile(docPath)
        Response.End()
    End Sub

    'Log document downloads but never log the same one twice in a row.
    Private Sub LogDownloadSuccess(ByVal documentId As Integer, ByVal documentNodeId As Integer)
        If Not documentId = SessionInfo.LastDocumentDownload Then
            Log.LogWebEvent(CurrentUser.Member.Name, Session.SessionID, "eToolkit", NRCAuthLib.FormsAuth.PageName, "Document Download", String.Format("DocumentId={0},DocumentNodeId={1}", documentId, documentNodeId))
            Log.LogDocumentDownload(CurrentUser.Member.MemberId, documentId, documentNodeId)
            SessionInfo.LastDocumentDownload = documentId
        End If
    End Sub

    Private Sub LogDownloadFailure(ByVal documentId As Integer)
        Log.LogWebEvent(CurrentUser.Member.Name, Session.SessionID, "eToolkit", NRCAuthLib.FormsAuth.PageName, "Document Access Denied", "DocumentId=" & documentId.ToString)
    End Sub


    Private Function BuildFileName(ByVal fileName As String, ByVal extension As String) As String
        'Clean invalid characters from the file name and add on the extension
        Dim badChars As Char() = "~!@#$%^&*()+=./\{}""'".ToCharArray
        fileName = fileName.Replace(" ", "_")
        For Each badChar As Char In badChars
            fileName = fileName.Replace(badChar, "")
        Next
        If Not extension.StartsWith(".") Then
            extension = "." & extension
        End If

        Return fileName & extension
    End Function

    Private Function GetMIMEType(ByVal extension As String) As String
        Select Case extension.ToLower
            Case ".doc"
                Return "application/msword"
            Case ".xls"
                Return "application/vnd.ms-excel"
            Case ".pdf"
                Return "application/pdf"
            Case ".rtf"
                Return "application/rtf"
            Case ".zip"
                Return "application/zip"
            Case ".sit"
                Return "application/x-stuffit"
            Case ".txt"
                Return "text/plain"
            Case ".html"
                Return "text/html"
            Case ".htm"
                Return "text/html"
            Case ".tsv"
                Return "text/tab-separated-values"
            Case Else
                Return "unknown/unknown"
        End Select

    End Function

End Class