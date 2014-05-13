Imports System.Web
Imports System.Runtime.Serialization.Formatters
Namespace Web
    Public Class ClientPersistence

#Region " Private Shortcut Properties "
        Private Shared ReadOnly Property Request() As HttpRequest
            Get
                Return HttpContext.Current.Request
            End Get
        End Property
        Private Shared ReadOnly Property Response() As HttpResponse
            Get
                Return HttpContext.Current.Response
            End Get
        End Property
        Private Shared ReadOnly Property Context() As HttpContext
            Get
                Return HttpContext.Current
            End Get
        End Property
        Private Shared ReadOnly Property Key() As String
            Get
                Return Context.Session.SessionID.Substring(0, 8)
            End Get
        End Property
#End Region

#Region " Public Methods "
        Public Shared Sub Serialize(ByVal cookieName As String, ByVal obj As Object)
            Dim formatter As Binary.BinaryFormatter
            Dim ms As System.IO.MemoryStream
            Dim cookie As HttpCookie
            Dim bytes As Byte()
            Dim data As String

            Try
                'Create the stream and the serialization formatter
                ms = New System.IO.MemoryStream
                formatter = New Binary.BinaryFormatter

                'Serialize to memory
                formatter.Serialize(ms, obj)

                'Convert to a byte array
                bytes = ms.ToArray()

                'Convert to string, encrypt with session ID, HTML encode
                data = Convert.ToBase64String(bytes)
                data = Security.DataProtection.Encrypt(data, Key, Security.DataProtection.Store.Machine)
                'data = Security.Encryptor.EncryptDES(Key, data)
                data = Context.Server.HtmlEncode(data)

                'Store the cookie
                cookie = New HttpCookie(cookieName, data)
                Response.Cookies.Add(cookie)
            Finally
                If Not ms Is Nothing Then
                    ms.Close()
                End If
            End Try
        End Sub

        Public Shared Function Deserialize(ByVal cookieName As String) As Object
            Dim cookie As HttpCookie
            Dim bytes As Byte()
            Dim ms As System.IO.MemoryStream
            Dim formatter As Binary.BinaryFormatter
            Dim data As String

            Try
                'Get the cookie
                cookie = Request.Cookies(cookieName)
                If cookie Is Nothing Then
                    Return Nothing
                End If
                data = cookie.Value

                'HTML Decode, Decrypt with Session ID, convert to byte array
                data = Context.Server.HtmlDecode(data)
                data = Security.DataProtection.Decrypt(data, Key, Security.DataProtection.Store.Machine)
                'data = Security.Decryptor.DecryptDES(Key, data)
                bytes = Convert.FromBase64String(data)

                'Setup the stream and deserialize
                ms = New System.IO.MemoryStream(bytes)
                formatter = New Binary.BinaryFormatter
                Return formatter.Deserialize(ms)
            Finally
                If Not ms Is Nothing Then
                    ms.Close()
                End If
            End Try
        End Function

#End Region

    End Class
End Namespace
