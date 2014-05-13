Imports System.Security.Cryptography
Imports System.Text
Imports System.IO
Namespace Security

    'Des uses 8 byte key and 8 byte IV
    'Rc2 uses variable length keys (4-16 bytes) and 8 byte IV
    'Rijndael uses 16 byte key and 16 byte IV
    'TripleDes uses 16 or 24 byte key and 8 byte IV
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Includes enumeration values for the various encryption algorithms supported by the .NET Framework
    ''' cryptography classes.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	6/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Enum EncryptionAlgorithm
        Des = 1
        Rc2
        Rijndael
        TripleDes
        HashSHA1
        HashMD5
        NRCConnection
        DPAPIMachine
    End Enum

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Security.Encryptor
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This class provides simplified access to the .NET Framework's encryption algorithms.
    ''' This class is used to encrypt data using a specified encryption key.    ''' 
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	6/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class Encryptor

        Private transformer As EncryptTransformer
        Private initVec() As Byte
        Private encKey() As Byte

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The initialization vector to be used with this encryption algorithm
        ''' </summary>
        ''' <value>The initialization vector to store</value>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property IV() As Byte()
            Get
                Return Me.initVec
            End Get
            Set(ByVal Value As Byte())
                Me.initVec = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The encryption key used to generated the cipher data.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property Key() As Byte()
            Get
                Return Me.encKey
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Constructor to initialize the Encryptor object.
        ''' </summary>
        ''' <param name="algorithm">The encryption algorithm to use to generate the cipher text</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New(ByVal algorithm As EncryptionAlgorithm)
            Me.transformer = New EncryptTransformer(algorithm)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Encrypts data using a specified encryption key.
        ''' </summary>
        ''' <param name="bytesData">The byte array of data to be encrypted</param>
        ''' <param name="bytesKey">The byte array representing the encryption key</param>
        ''' <returns>A byte array of cipher text</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Function Encrypt(ByVal bytesData() As Byte, ByVal bytesKey() As Byte) As Byte()
            Dim ms As New MemoryStream

            transformer.IV = initVec
            Dim transform As ICryptoTransform = Me.transformer.GetCryptoServiceProvider(bytesKey)
            Dim encStream As New CryptoStream(ms, transform, CryptoStreamMode.Write)

            Try
                encStream.Write(bytesData, 0, bytesData.Length)
            Catch ex As Exception
                Throw New Exception("Error while writing encrypted data to the stream: " & vbCrLf & ex.Message)
            End Try

            Me.encKey = Me.transformer.Key
            Me.initVec = Me.transformer.IV
            encStream.FlushFinalBlock()
            encStream.Close()

            Return ms.ToArray
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' A shared function for easy DES encryption.  This function uses a constant initialization
        ''' vector that can be decrypted with the NRC.Security.Decryptor class.  This is best used
        ''' when you need to convert data to a non human-readable form and security is not your top
        ''' priority
        ''' </summary>
        ''' <param name="strKey">The encryption key to use with this DES algorithm</param>
        ''' <param name="strData">The byte array of data to be encrypted</param>
        ''' <returns>A byte array of encrypted data</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Function EncryptDES(ByVal strKey As String, ByVal strData As String) As String
            Dim enc As NRC.Security.Encryptor
            Dim IV() As Byte = Nothing
            Dim cipherText() As Byte = Nothing
            Dim key() As Byte = Nothing
            Dim plainText() As Byte

            Try
                enc = New NRC.Security.Encryptor(Security.EncryptionAlgorithm.Des)
                plainText = Encoding.ASCII.GetBytes(strData)
                key = Encoding.ASCII.GetBytes(strKey)
                IV = Encoding.ASCII.GetBytes("ZYXWVUTS")

                enc.IV = IV
                cipherText = enc.Encrypt(plainText, key)
                IV = enc.IV
                key = enc.Key

                Return Convert.ToBase64String(cipherText)
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class

End Namespace
