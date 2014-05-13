Imports Microsoft.Web.Services2
Imports Microsoft.Web.Services2.Dime
Imports System.IO
Imports System.Web.Services


Namespace WebDocumentPoster


<System.Web.Services.WebService(Namespace := "http://tempuri.org/WebDocumentPoster/FileManager")> _
Public Class FileManager
    Inherits System.Web.Services.WebService

#Region " Web Services Designer Generated Code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Web Services Designer.
        InitializeComponent()

        'Add your own initialization code after the InitializeComponent() call

    End Sub

    'Required by the Web Services Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Web Services Designer
    'It can be modified using the Web Services Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        components = New System.ComponentModel.Container()
    End Sub

    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        'CODEGEN: This procedure is required by the Web Services Designer
        'Do not modify it using the code editor.
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

#End Region

    ' WEB SERVICE EXAMPLE
    ' The HelloWorld() example service returns the string Hello World.
    ' To build, uncomment the following lines then save and build the project.
    ' To test this web service, ensure that the .asmx file is the start page
    ' and press F5.
    '
    '<WebMethod()> _
    'Public Function HelloWorld() As String
    '   Return "Hello World"
    'End Function

    Private ReadOnly Property PathRoot() As String
        Get
                Dim path As String = System.Configuration.ConfigurationManager.AppSettings("WebDocumentPath")
            If Not path.EndsWith("\") Then
                path = path & "\"
            End If

            Return path
        End Get
    End Property


    <WebMethod()> _
    Public Sub UploadDocument(ByVal relativePath As String)
        'Make sure precisely one attachment was sent
        If RequestSoapContext.Current.Attachments.Count <> 1 Then
            Throw New ArgumentException("Please upload one file at a time.")
        End If

        Dim path As String = PathRoot & relativePath
        Dim newFile As New FileInfo(path)
        If Not newFile.Directory.Exists Then
            newFile.Directory.Create()
        End If

        If newFile.Exists Then
            Throw New ArgumentException("The specified file already exists.")
        End If

        Dim fs As FileStream = File.Create(path)
        Dim fileLength As Integer = CType(RequestSoapContext.Current.Attachments(0).Stream.Length, Integer)

        Dim buffer(fileLength) As Byte
        RequestSoapContext.Current.Attachments(0).Stream.Read(buffer, 0, fileLength)
        fs.Write(buffer, 0, fileLength)
        fs.Close()
    End Sub

    <WebMethod()> _
    Public Sub DownloadDocument(ByVal relativePath As String)
        Dim path As String = PathRoot & relativePath
        Dim downloadFile As New FileInfo(path)

        If Not downloadFile.Exists Then
            Throw New ArgumentException("File not found.")
        End If

        Dim attach As New DimeAttachment("Document", TypeFormat.MediaType, downloadFile.OpenRead)
        ResponseSoapContext.Current.Attachments.Add(attach)
    End Sub
End Class

End Namespace
