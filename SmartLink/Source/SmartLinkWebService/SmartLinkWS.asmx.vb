Imports Microsoft.VisualBasic
Imports System
Imports System.Collections.Generic
Imports System.IO
Imports System.Security.Cryptography
Imports System.Text
Imports System.Web.Configuration
Imports System.Web.Services
Imports System.Xml

Imports NLog
Imports NLog.Targets
Imports NLog.Config

<WebService(Description:="Upload Data to NRC for Processing",
    Namespace:="http://NRCWebService/SmartLinkWS")>
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
Public Class SmartLinkWS
    Inherits System.Web.Services.WebService

    Private Shared _initialized As Boolean = False
    Private Shared _logger As NLog.Logger = Nothing

    Private Shared _uploadDir As String = Nothing
    Private Shared _workingDir As String = Nothing
    Private Shared _excludedFilesDir As String = Nothing

    Private Shared _excludeList As List(Of String) = Nothing

    Private Const PRIVATE_KEY As String = "GO3@^DNiZm$u@xJ%nO*7vJ@w#sz^%eUpQ6e"

    <WebMethod()>
    Public Function FileUpload(ByVal sKey As String, ByVal sFileName As String, ByVal buffer() As Byte, ByVal Offset As Long, ByVal BytesRead As Integer) As Boolean
        ValidateKey(sKey)

        _logger.Trace("Request Received")
        AppendChunk(_uploadDir, sFileName, buffer, Offset, BytesRead)
    End Function


    'WebMethod added by REBSAN 08/04/08
    'Provides support for the Interim Web Service (P#0301)
    'StartFileTransmission initializes the transmission by authenticating the key, receiving basic data points,
    'and generating a unique ID that is sent back to ID actual transmission

    <WebMethod()>
    Public Function StartFileTransmission(ByVal sKey As String, ByVal sFileName As String, ByVal FileSize As Long, ByVal StartCheckSum As String) As String
        ValidateKey(sKey)

        Using dbi As DBInterface = New DBInterface()

            Dim place As Integer = sFileName.LastIndexOf("\")
            Dim sFile As String = sFileName.Substring(place + 1)

            If dbi.FileExists(sFile, StartCheckSum) Then
                _logger.Trace("File Already Exists in Database")
                CustomSoapException("Invalid Transfer Request.", "This file has already been uploaded.")
                Return Nothing
            End If

            'StartTime = Now.ToString("yyyy-MM-dd HH:mm:ss")

            Dim ID As String = String.Empty
            Do
                ID = IDHelper.IDGenerator.GenerateID()
            Loop Until dbi.IsInDB(ID) = False

            _logger.Trace("Request Received")
            dbi.StoreStartTransmission(ID, sFile, FileSize, StartCheckSum) ', StartTime)
            File.Create(_workingDir & "\" & ID & ".nrc").Close()

            Return ID
        End Using

    End Function

    'WebMethod added by REBSAN 08/04/08
    'DoFileTransmission receives the transmission information and checks for a valid ID number before calling AppendChunk
    <WebMethod()>
    Public Function DoFileTransmission(ByVal ID As String, ByVal buffer() As Byte, ByVal Offset As Long, ByVal BytesRead As Integer) As Boolean

        If File.Exists(_workingDir & "\" & ID & ".nrc") Then
            AppendChunk(_workingDir, ID & ".nrc", buffer, Offset, BytesRead)
        Else
            _logger.Trace("Invalid Transfer Request. ID not valid.")
            CustomSoapException("Invalid Transfer Request.", "ID not valid.")
        End If
    End Function

    'WebMethod added by REBSAN 08/04/08
    'EndFileTransmission provides the receipt of transmission for P#0301 - Smartlink: Interim Web Services Modification
    <WebMethod()>
    Public Function EndFileTransmission(ByVal ID As String) As XmlNode
        Using dbi As DBInterface = New DBInterface()

            Dim StartCheckSum As String = Nothing
            Dim FileName As String = Nothing
            dbi.FetchFileData(ID, StartCheckSum, FileName)
            Dim EndCheckSum As String = CheckFileHash(_workingDir & "\" & ID & ".nrc")

            If (EndCheckSum = StartCheckSum) Then
                dbi.StoreEndTransmission(ID, True, EndCheckSum)
                If File.Exists(_uploadDir & "\" & FileName) Then
                    File.Delete(_uploadDir & "\" & FileName)
                End If
                File.Move(_workingDir & "\" & ID & ".nrc", _uploadDir & "\" & FileName)

                Return dbi.BuildReceipt(ID)
            Else
                dbi.StoreEndTransmission(ID, False, EndCheckSum)
                If System.IO.File.Exists(_workingDir & "\" & ID & ".nrc") Then
                    System.IO.File.Delete(_workingDir & "\" & ID & ".nrc")
                End If

                _logger.Trace(String.Format("Invalid Transfer Request. Checksum Failed: remote {0}, local {1}",
                    StartCheckSum, EndCheckSum))
                CustomSoapException("Invalid Transfer Request.", "Checksum Failed -- data not valid.")

                Dim Receipt As XmlDocument = New XmlDocument
                Return Receipt.CreateElement("TransmissionFailed")
            End If
        End Using

    End Function

    <WebMethod()>
    Public Function Ping() As String
        Return "Welcome to the Data Retrieval Web Service"
    End Function

    Public Structure Version
        Public VersionId As String
        Public Url As String
        Public FileName As String
        Public Checksum As String
    End Structure

    <WebMethod()>
    Public Function CheckForSmartLinkAppUpdate(ByVal sKey As String, ByVal clientId As String, ByVal clientVersion As String) As Version
        ValidateKey(sKey)

        Using dbi As DBInterface = New DBInterface()

            Try
                Dim version As Version = New Version()

                dbi.FindLatestVersion(version.VersionId, version.Url, version.FileName, version.Checksum)
                If Not version.Url.StartsWith("http") Then
                    Dim tempUrl As String = WebConfigurationManager.AppSettings("BaseDownloadURL")
                    If Not tempUrl.EndsWith("/") Then
                        tempUrl = tempUrl & "/"
                    End If
                    version.Url = tempUrl & version.Url
                End If
                dbi.StoreUpdateRequest(clientId, clientVersion, version.VersionId)
                Return version
            Catch ex As Exception
                _logger.Error("Exception received: " + ex.Message)
                CustomSoapException("Error retrieving version information", "An internal error has occurred retrieving the version information.")
                Return Nothing
            End Try
        End Using

    End Function

    Private Sub ValidateKey(ByVal Key As String)
        If Key = PRIVATE_KEY Then
            _logger.Trace("Request Received")
        Else
            _logger.Trace("Invalid Transfer Request. Security Keys do not match")
            CustomSoapException("Invalid Transfer Request.", "Security Keys do not match")
        End If
    End Sub

    Public Shared Function CheckFileHash(ByVal FileName As String) As String
        Dim FilePath As String = FileName
        Dim hash() As Byte
        Dim SHA1 As SHA1CryptoServiceProvider = New SHA1CryptoServiceProvider

        Using fs As FileStream = New FileStream(FilePath, FileMode.Open, FileAccess.Read, FileShare.Read, 4096)
            hash = SHA1.ComputeHash(fs)
            Return BitConverter.ToString(hash)
        End Using
    End Function

    Private Sub AppendChunk(ByVal DirectoryName As String, ByVal FileName As String, ByVal buffer() As Byte, ByVal Offset As Long, ByVal BytesRead As Integer)
        Dim FilePath As String = String.Empty
        Dim fs As FileStream = Nothing
        Dim intCtr As Integer = 0
        Dim blnExclude As Boolean = False

        Try
            '### auggur 04/30/2007 added code to intercept incoming rougue files.
            For Each strExclude As String In _excludeList
                If InStr(FileName, strExclude) > 0 Then
                    blnExclude = True
                    Exit For
                End If
            Next
            If blnExclude Then
                FilePath = _excludedFilesDir + "\" + FileName
            Else
                FilePath = DirectoryName + "\" + FileName
            End If

            fs = New FileStream(FilePath, FileMode.Append)

            ' make sure that the file exists, except in the case where the file already exists and offset=0, i.e. a new upload, 
            ' in this case create a new file to overwrite the old one.
            ' TODO: implement this functionality -- right now it just errors out in the transfer corrupted check
            ' if you resend a file with offset=0
            Dim FileExists As Boolean = File.Exists(FilePath)
            If Not File.Exists(FilePath) And Offset = 0 Then
                _logger.Trace("Creating new file: " + FileName)
                File.Create(FilePath).Close()
            End If
            Dim FileSize As Long = New FileInfo(FilePath).Length

            ' if the file size is not the same as the offset then something went wrong....
            If FileSize <> Offset Then
                _logger.Trace("Transfer Corrupted:" + String.Format("The file size is {0}, expected {1} bytes", FileSize, Offset))
                CustomSoapException("Transfer Corrupted", String.Format("The file size is {0}, expected {1} bytes", FileSize, Offset))
            Else
                ' offset matches the filesize, so the chunk is to be inserted at the end of the file.
                Using (fs)
                    _logger.Trace("Appending to file: " + FileName)
                    fs.Write(buffer, 0, BytesRead)
                End Using
            End If
        Catch ex As Exception
            Throw
        Finally
            If fs IsNot Nothing Then
                fs.Close()
            End If
        End Try

    End Sub

    Private Sub CustomSoapException(ByVal exceptionName As String, ByVal message As String)
        Throw New System.Web.Services.Protocols.SoapException(exceptionName + ": " + message, New System.Xml.XmlQualifiedName("BufferedUpload"))
    End Sub

    Private Function GenRandomValues(ByVal len As Integer) As String
        Dim buff((len / 2) - 1) As Byte 'JBox added the decrement b/c of VB array decl syntax
        Dim rng As New RNGCryptoServiceProvider()
        rng.GetBytes(buff)
        Dim sb As New StringBuilder(len)
        Dim i As Integer
        For i = 0 To buff.Length - 1
            sb.Append(String.Format("{0:X2}", buff(i)))
        Next i
        Return sb.ToString
    End Function

    ' called from Global's App_Start method
    Public Shared Sub Initialize()
        If _initialized Then
            Return
        End If

        _uploadDir = GetDirectory(Path.Combine(WebConfigurationManager.AppSettings("BaseDir"), WebConfigurationManager.AppSettings("UploadDir")))
        _workingDir = GetDirectory(Path.Combine(WebConfigurationManager.AppSettings("BaseDir"), WebConfigurationManager.AppSettings("WorkingDir")))
        _excludedFilesDir = GetDirectory(Path.Combine(WebConfigurationManager.AppSettings("BaseDir"), WebConfigurationManager.AppSettings("ExcludedFilesDir")))

        _excludeList = New List(Of String)
        For Each pat As String In Regex.Split(WebConfigurationManager.AppSettings("Exclude_Patterns"), "[\\s,]+")
            If pat.Length > 0 Then
                _excludeList.Add(pat)
            End If
        Next

        Dim config As LoggingConfiguration = New LoggingConfiguration()

        Dim fileTarget As FileTarget = New FileTarget()
        Dim fileName As String = Path.Combine(WebConfigurationManager.AppSettings("BaseDir"), WebConfigurationManager.AppSettings("LogFile"))
        fileTarget.FileName = fileName
        ' The ### is a magic NLog thing for its log-rolling: # means keep 10 backups, ## means keep 100, etc
        fileTarget.ArchiveFileName = fileName.Replace(".log", "##.log")
        fileTarget.Layout = "[${longdate}] ${level}: ${message} ${exception:format=tostring}"
        fileTarget.ArchiveAboveSize = 1 * 1024 * 1024  ' Roll logs at 1 meg
        config.AddTarget("file", fileTarget)
        Dim fileRule As LoggingRule
        If WebConfigurationManager.AppSettings("TraceFlag").ToUpper() = "TRUE" Then
            fileRule = New LoggingRule("*", LogLevel.Trace, fileTarget)
        Else
            fileRule = New LoggingRule("*", LogLevel.Info, fileTarget)
        End If

        config.LoggingRules.Add(fileRule)

        LogManager.Configuration = config

        _logger = LogManager.GetLogger("NRC Logger")

        'Check database connection
        Using dbi As DBInterface = New DBInterface()
            dbi.Test()
        End Using

        _initialized = True
    End Sub

    ''' <summary>
    ''' Makes sure that the directory exists
    ''' </summary>
    Private Shared Function GetDirectory(dir As String) As String

        If Not System.IO.Directory.Exists(dir) Then
            System.IO.Directory.CreateDirectory(dir)
        End If

        Return dir

    End Function

End Class

