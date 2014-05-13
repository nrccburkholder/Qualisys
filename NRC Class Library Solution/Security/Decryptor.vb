Imports System.Security.Cryptography
Imports System.IO
Imports System.Text

Namespace Security
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Security.Decryptor
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This class provides simplified access to the .NET Framework's encryption
    ''' algorithms.  This class is used to decrypt data using a given decryption
    ''' key.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	6/21/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class Decryptor

        Private transformer As DecryptTransformer
        Private initVec() As Byte

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The initialize vector used in conjuction with the decryption
        ''' key to decrypt the data
        ''' </summary>
        ''' <value>The initialization vector to store</value>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/21/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public WriteOnly Property IV() As Byte()
            Set(ByVal Value As Byte())
                Me.initVec = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Constructor to initialize the decryptor and specify the 
        ''' algorithm that should be used.
        ''' </summary>
        ''' <param name="algorithm">The encryption algorithm used to generate the encrypted data stream</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/21/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New(ByVal algorithm As EncryptionAlgorithm)

            Me.transformer = New DecryptTransformer(algorithm)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Decrypts the provided array of bytes using the specified decryption key.
        ''' </summary>
        ''' <param name="bytesData">The byte array of encrypted data to be decrypted</param>
        ''' <param name="bytesKey">The byte array of the encryption key</param>
        ''' <returns>An array of bytes representing the decrypted data</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/21/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Function Decrypt(ByVal bytesData() As Byte, ByVal bytesKey() As Byte) As Byte()
            Dim ms As New MemoryStream

            Me.transformer.IV = Me.initVec
            Dim transform As ICryptoTransform = Me.transformer.GetCryptoServiceProvider(bytesKey)
            Dim decStream As New CryptoStream(ms, transform, CryptoStreamMode.Write)

            Try
                decStream.Write(bytesData, 0, bytesData.Length)
            Catch ex As Exception
                Throw New Exception("Error while writing encrypted data to stream: " & vbCrLf & ex.Message)
            End Try

            decStream.FlushFinalBlock()
            decStream.Close()

            Return ms.ToArray
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' A shared function for simple and quick DES decryption of data that was
        ''' encrypted using the NRC.Security.Encryptor class.  This method uses
        ''' a fixed initialzation vector and the user needs only provide the encrypted
        ''' data and the encryption key
        ''' </summary>
        ''' <param name="strKey">The encryption key that will be used to decrypt the data</param>
        ''' <param name="strData">The data to be decrypted</param>
        ''' <returns>An array of bytes representing the decrypted data</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/21/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Function DecryptDES(ByVal strKey As String, ByVal strData As String) As String
            Dim dec As NRC.Security.Decryptor
            Dim IV() As Byte = Nothing
            Dim cipherText() As Byte = Nothing
            Dim key() As Byte = Nothing
            Dim plainText() As Byte

            Try
                dec = New NRC.Security.Decryptor(Security.EncryptionAlgorithm.Des)

                key = Encoding.ASCII.GetBytes(strKey)
                IV = Encoding.ASCII.GetBytes("ZYXWVUTS")
                cipherText = Convert.FromBase64String(strData)

                dec.IV = IV
                plainText = dec.Decrypt(cipherText, key)

                Return Encoding.ASCII.GetString(plainText)
            Catch ex As Exception
                Throw ex
            End Try
        End Function

    End Class

End Namespace
