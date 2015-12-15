Imports System.Collections.Generic
Imports System.IO
Imports System.Net
Imports System.ServiceModel
Imports System.ServiceModel.Channels
Imports System.Xml

Imports NRC.SmartLink.Common.WS

' Wrapper around the NRC web service; wraps up individual calls at a higher level, handles 
' logging and catches exceptions
Public Class WebService
    Private _service As SmartLinkWSSoapClient = Nothing
    Private Const WEB_SERVICE_KEY As String = "GO3@^DNiZm$u@xJ%nO*7vJ@w#sz^%eUpQ6e"

    ' Note this might throw an exception if, eg, the url is bad
    Sub New(Optional ByVal timeout As Integer = 60)
        Dim url As String = Settings.GetGeneralSetting("SmartLinkWS", "http://localhost:1619/SmartLinkWS.asmx")
        Dim proxyIP As String = Nothing
        Dim proxyPort As String = Nothing
        Dim proxyUser As String = Nothing
        Dim proxyPassword As String = Nothing
        Dim proxyDomain As String = Nothing

        Dim proxyEnabledStr As String = Settings.GetGeneralSetting("ProxyEnabled", "No").ToUpper
        If proxyEnabledStr = "YES" Or proxyEnabledStr = "TRUE" Or proxyEnabledStr = "1" Then
            proxyIP = Settings.GetGeneralSetting("ProxyIP")
            proxyPort = Settings.GetGeneralSetting("ProxyPort")
            proxyUser = Settings.GetGeneralSetting("ProxyUser")
            proxyPassword = Settings.GetGeneralSetting("ProxyPswrd")
            proxyDomain = Settings.GetGeneralSetting("ProxyDomain")
        End If

        Me.Init(url, proxyIP, proxyPort, proxyUser, proxyPassword, proxyDomain, timeout)
    End Sub

    ' Note this might throw an exception if, eg, the url is bad
    Sub New(ByVal url As String, ByVal proxyIP As String, ByVal proxyPort As String, ByVal proxyUser As String, ByVal proxyPassword As String, _
        ByVal proxyDomain As String, ByVal timeout As Integer)
        Me.Init(url, proxyIP, proxyPort, proxyUser, proxyPassword, proxyDomain, timeout)
    End Sub

    Private Sub Init(ByVal url As String, ByVal proxyIP As String, ByVal proxyPort As String, ByVal proxyUser As String, ByVal proxyPassword As String, _
        ByVal proxyDomain As String, ByVal timeout As Integer)
        Dim bind As Binding = Nothing
        If url.StartsWith("https") Then
            bind = New BasicHttpBinding(BasicHttpSecurityMode.Transport)
        Else
            bind = New BasicHttpBinding(BasicHttpSecurityMode.None)
        End If
        ' If there's a further timeout issue, look at the latter half of
        ' http://www.codeproject.com/KB/WCF/WCF_Operation_Timeout_.aspx
        bind.OpenTimeout = New TimeSpan(0, 0, timeout)
        bind.CloseTimeout = New TimeSpan(0, 0, timeout)
        bind.SendTimeout = New TimeSpan(0, 0, timeout)
        bind.ReceiveTimeout = New TimeSpan(0, 0, timeout)
        Dim endpointAddr As EndpointAddress = New EndpointAddress(url)
        _service = New SmartLinkWSSoapClient(bind, endpointAddr)

        If proxyIP IsNot Nothing Then
            ' Could think about merging proxyIP and proxyDomain -- we really just need a proxyHost (or even a proxy host + port as url)
            ' Taking proxy setup from http://stackoverflow.com/questions/187001/wcf-custom-http-proxy-authentication
            Dim proxyUri As Uri = New Uri("http://" + proxyIP + ":" + proxyPort)
            Dim ignoreProxyList(0) As String
            Dim proxyCredentials As NetworkCredential = New NetworkCredential(proxyUser, proxyPassword, proxyDomain)
            WebRequest.DefaultWebProxy = New WebProxy(proxyUri, False, ignoreProxyList, proxyCredentials)
            Log.WriteTrace("Initializing web service: url=" + url + ", proxyIP=" + proxyIP + ", proxyPort=" + proxyPort +
                ", proxyUser=" + proxyUser + ", proxyPassword=<not shown>, proxyDomain=" + proxyDomain)
        Else
            Log.WriteTrace("Initializing web service: url=" + url + ", no proxy")
        End If
    End Sub

    Public Function CheckForNewVersion(ByVal clientId As String, ByVal currentVersion As String,
                                       ByRef newVersion As String, ByRef url As String, ByRef fileName As String,
                                       ByRef checksum As String) As Boolean
        newVersion = Nothing
        url = Nothing
        fileName = Nothing
        checksum = Nothing

        Try
            Dim resp As WS.Version = _service.CheckForSmartLinkAppUpdate(WEB_SERVICE_KEY, clientId, currentVersion)
            Settings.SetGeneralSetting("AutoUpdateLastCheck", DateTime.Now.ToString())

            If currentVersion <> resp.VersionId Then
                newVersion = resp.VersionId
                url = resp.Url
                fileName = resp.FileName
                checksum = resp.Checksum
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Log.WriteError("Query for new version failed: " + ex.Message)
            If Not ValidateConnection() Then
                Throw New Exception("The new version check could not be performed: connection to the server failed")
            Else
                Throw New Exception("The new version check could not be performed: the NRC web service failed")
            End If
        End Try
    End Function

    Public Function UploadFile(ByVal fileName As String) As Boolean
        Const CHUNK_SIZE As Long = 16 * 1024

        Dim fs As FileStream = Nothing
        Try
            Dim fileInfo As New FileInfo(fileName)
            Dim fileSize As Long = fileInfo.Length
            Dim checksum As String = Utils.CheckFileHash(fileName)

            Dim sendID As String = _service.StartFileTransmission(WEB_SERVICE_KEY, fileName, fileSize, checksum)

            fs = New FileStream(fileName, FileMode.Open, FileAccess.Read)

            Dim offset As Long = 0
            Dim bytesRead As Integer = 0
            Dim buf(CHUNK_SIZE) As Byte

            While offset < fileSize
                bytesRead = fs.Read(buf, 0, CHUNK_SIZE)
                _service.DoFileTransmission(sendID, buf, offset, bytesRead)
                offset = offset + bytesRead
            End While

            Dim receipt As XmlNode = _service.EndFileTransmission(sendID).GetXmlNode

            If receipt.Name = "NRC_Receipt" Then
                Return True
            End If
        Catch ex As Exception
            Log.WriteError("Error attempting to upload file: " + ex.Message)
        Finally
            If fs IsNot Nothing Then
                fs.Close()
            End If
        End Try

        Return False
    End Function

    Public Shared Function DiagnoseConnection(Optional ByVal webService As WebService = Nothing) As ConnectionStatus
        If webService Is Nothing Then
            Try
                webService = New WebService()
            Catch ex As Exception
                Log.WriteError("Error initializing web service (will skip ping): " + ex.Message)
            End Try
        End If

        Try
            If (webService IsNot Nothing) AndAlso (Len(webService._service.Ping()) > 10) Then
                Log.WriteTrace("Connected to service, did a successful ping, connection seems OK")
                Return ConnectionStatus.OK
            End If
        Catch ex As Exception
            Log.WriteError("Ping of service failed, message: " + ex.Message)
        End Try

        ' If ping failed, can we at least fetch the service's base page?
        Dim url As String = Settings.GetGeneralSetting("SmartLinkWS")
        Try
            Dim objWebReq As System.Net.WebRequest = System.Net.WebRequest.Create(url)
            Dim objResp As System.Net.HttpWebResponse = DirectCast(objWebReq.GetResponse, HttpWebResponse)
            objResp.Close()

            If objResp.StatusCode = HttpStatusCode.OK Then
                If objResp.ResponseUri.AbsoluteUri.ToUpper() = url.ToUpper() Then
                    Log.WriteError("Connection to service host (" + url + ") valid (page returned " +
                                         "successfully), even if we couldn't ping the service")
                    Return ConnectionStatus.PageUp
                Else
                    Log.WriteError("Connection to service host (" + url + ") made but host is wrong, " +
                                         "DNS cache may be out of date")
                    Return ConnectionStatus.BadHost
                End If
            Else
                Log.WriteError("Connection to service host (" + url + ") made, but page returned with status code " + objResp.StatusCode.ToString())
                Return ConnectionStatus.BadHttpCode
            End If
        Catch ex As Exception
            Log.WriteError("Connection to service host (" + url + ") failed, exception: " + ex.Message)
        End Try

        url = Settings.GetGeneralSetting("InternetCheckURL")
        Try
            Dim objWebReq As System.Net.WebRequest = System.Net.WebRequest.Create(url)
            Dim objResp As System.Net.HttpWebResponse = DirectCast(objWebReq.GetResponse, HttpWebResponse)
            objResp.Close()
            If objResp.StatusCode = HttpStatusCode.OK Then
                Log.WriteError("Connection to check host (" + url + ") valid (page returned successfully), even if we couldn't contact the NRC service")
                Return ConnectionStatus.CheckPageUp
            Else
                Log.WriteError("Connection to check host (" + url + ") made, but page returned with status code " + objResp.StatusCode.ToString())
                Return ConnectionStatus.CheckPageUp
            End If
        Catch ex As Exception
            Log.WriteError("Connection to check host (" + url + ") failed, exception: " + ex.Message)
        End Try

        url = Settings.GetGeneralSetting("InternetCheckIP")
        Try
            Dim objWebReq As System.Net.WebRequest = System.Net.WebRequest.Create(url)
            Dim objResp As System.Net.HttpWebResponse = DirectCast(objWebReq.GetResponse, HttpWebResponse)
            objResp.Close()
            If objResp.StatusCode = HttpStatusCode.OK Then
                Log.WriteError("Connection to check IP (" + url + ") valid (page returned successfully), even if we couldn't contact the check host by name")
                Return ConnectionStatus.CheckIPUp
            Else
                Log.WriteError("Connection to check IP (" + url + ") made, but page returned with status code " + objResp.StatusCode.ToString())
                Return ConnectionStatus.CheckIPUp
            End If
        Catch ex As Exception
            Log.WriteError("Connection to check IP (" + url + ") failed, exception: " + ex.Message)
        End Try

        Return ConnectionStatus.NoConnection
    End Function

    Public Function ValidateConnection() As Boolean
        Return (DiagnoseConnection(Me) = ConnectionStatus.OK)
    End Function

End Class

Public Enum ConnectionStatus
    OK
    PageUp
    BadHost
    BadHttpCode
    CheckPageUp
    CheckIPUp
    NoConnection
End Enum
