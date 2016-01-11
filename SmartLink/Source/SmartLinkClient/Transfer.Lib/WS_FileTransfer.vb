Imports System.IO

Imports ComponentAce.Compression.ZipForge
Imports ComponentAce.Compression.Archiver

Imports NRC.SmartLink.Common

Public Class WS_FileTransfer

    Private _webService As WebService
    Private _AppKey As String = ""
    Private _zipForge As ZipForge
    Private _sWorkingPath As String = ""
    Private _iRetryCount As Integer = 12

    Public Function TransmitData(ByVal sFileName As String) As Boolean
        Dim iRetryCount As Integer = _iRetryCount
        Static iEndingNumber As Integer

        Do
            Dim zipFileName As String = Nothing
            Try
                If _webService Is Nothing Then
                    Dim MAX_TIMEOUT_SECS As Integer = 10000
                    _webService = New WebService(MAX_TIMEOUT_SECS)
                End If

                If iEndingNumber < 10000 Then
                    iEndingNumber += 1
                Else
                    iEndingNumber = 1
                End If

                Dim path As String = My.Computer.FileSystem.GetParentPath(sFileName)
                Dim file As String = My.Computer.FileSystem.GetName(sFileName)
                Dim index As Integer = file.LastIndexOf(".")

                If file.ToUpper.Contains("_DBX") Then
                    zipFileName = "EFILE_" & file.Remove(index) & ".zip"
                Else
                    zipFileName = "EFILE_" & file.Remove(index) & Now.ToString("_yyyyMMddHHmmssff") & iEndingNumber.ToString("00000") & ".zip"
                End If

                If _sWorkingPath <> "" Then
                    zipFileName = _sWorkingPath & "\" & zipFileName
                Else
                    zipFileName = path & "\" & zipFileName
                End If

                ZipFile(sFileName, zipFileName, True)

                If _webService.UploadFile(zipFileName) Then
                    Return True
                End If
            Catch ex As Exception
                iRetryCount = iRetryCount - 1
                If iRetryCount <= 0 Then
                    Throw
                End If
            Finally
                If iRetryCount <> _iRetryCount Then
                    _webService = Nothing
                End If
                If zipFileName IsNot Nothing AndAlso System.IO.File.Exists(zipFileName) Then
                    File.Delete(zipFileName)
                End If
            End Try

            System.Threading.Thread.Sleep(New TimeSpan(0, 0, 15))
        Loop While True

        Log.WriteError("Failed every time, no more retries for now")
        Return False
    End Function

    Public Sub New(ByVal appKey As String, ByVal workingDirectory As String)
        _AppKey = appKey
        _sWorkingPath = workingDirectory
        Me.InitializeZipProgram()
    End Sub

    Private Sub InitializeZipProgram()
        _zipForge = New ZipForge
        With _zipForge
            .Zip64Mode = Zip64Mode.Auto
            .CompressionMethod = CompressionMethod.Deflate
        End With

    End Sub


    Private Function ZipFile(ByVal FileNameIN As String, ByVal zipFileNameOut As String, ByVal blnEncryptFlag As Boolean) As Boolean
        Dim strReturnCode As String = String.Empty

        Try
            ' The name of the ZIP file to be created
            '_zipForge.FileName = zipFileNameOut.Substring(zipFileNameOut.LastIndexOf("\") + 1)
            _zipForge.FileName = zipFileNameOut
            ' Specify FileMode.Create to create a new ZIP file
            ' or FileMode.Open to open an existing archive
            _zipForge.OpenArchive(System.IO.FileMode.Create)

            ' TODO: Should this path be hardcoded like this??  Probably not.  GMM

            ' Default path for all operations                
            _zipForge.BaseDir = "C:\Documents and Settings\thymyr\My VS projects\NRC_Config_files\Services\SLT\FileUpload\Work\"

            ' Add file C:\file.txt the archive; wildcards can be used as well                
            _zipForge.Options.StorePath = StorePathMode.NoPath

            'Encryption
            If blnEncryptFlag Then
                _zipForge.EncryptionAlgorithm = EncryptionAlgorithm.Aes256
                _zipForge.Password = _AppKey

            End If

            _zipForge.AddFiles(FileNameIN)

            ' Close archive - you must close archive or else zip file will be corrupt.
            _zipForge.CloseArchive()
            ' Catch all exceptions of the ArchiverException type
            ZipFile = True

        Catch ae As ArchiverException
            ZipFile = False
            Throw

        End Try
    End Function

    Public Function GetAssemblyVersion() As System.Version
        Try
            Return System.Reflection.Assembly.GetExecutingAssembly.GetName().Version
        Catch ex As Exception
            Return Nothing
        End Try
    End Function
End Class
