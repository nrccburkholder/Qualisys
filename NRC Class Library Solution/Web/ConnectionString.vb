Imports System.Text
Namespace Web
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Web.ConnectionString
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Provides functionality for encrypting and decrypting database connection strings so
    ''' they can securely be stored in .Config files.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	6/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class ConnectionString
        Private Const _Key As String = "NRC DBConnection"
        Private Const _IV As String = "NRCSQLDB"

        Private _Encrypted As String
        Private _Decrypted As String

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The encrypted version of the connection string.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property EncryptedString() As String
            Get
                Return Me._Encrypted
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The decrypted version of the connection string.
        ''' </summary>
        ''' <value></value>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property DecryptedString() As String
            Get
                Return Me._Decrypted
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Encrypts a plain text connection string and returns an NRC.Web.ConnectionString object
        ''' </summary>
        ''' <param name="DecryptedString">The connection string to be encrypted for storage</param>
        ''' <returns>A ConnectionString object for the provided database connection string</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Function Encrypt(ByVal DecryptedString As String) As ConnectionString
            Dim enc As NRC.Security.Encryptor
            Dim IV() As Byte = Nothing
            Dim cipherText() As Byte = Nothing
            Dim key() As Byte = Nothing
            Dim plainText() As Byte

            Dim Conn As ConnectionString
            Try
                enc = New NRC.Security.Encryptor(Security.EncryptionAlgorithm.TripleDes)
                plainText = Encoding.ASCII.GetBytes(DecryptedString)
                key = Encoding.ASCII.GetBytes(_Key)
                IV = Encoding.ASCII.GetBytes(_IV)

                enc.IV = IV
                cipherText = enc.Encrypt(plainText, key)
                IV = enc.IV
                key = enc.Key

                Conn = New ConnectionString(Convert.ToBase64String(cipherText))

                Return Conn
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Constructor that initializes the ConnectionString object from an encrypted string
        ''' </summary>
        ''' <param name="EncryptedString">The encrypted connection string</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New(ByVal EncryptedString As String)
            Me._Encrypted = EncryptedString
            Decrypt()
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Decrypts a connection string and stores both the plain text and the cipher
        ''' text in the ConnectionString object.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	6/22/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub Decrypt()
            If Not Me._Encrypted.Length > 0 Then Exit Sub

            Dim dec As NRC.Security.Decryptor
            Dim IV() As Byte = Nothing
            Dim cipherText() As Byte = Nothing
            Dim key() As Byte = Nothing
            Dim plainText() As Byte

            Try
                dec = New NRC.Security.Decryptor(Security.EncryptionAlgorithm.TripleDes)

                key = Encoding.ASCII.GetBytes(_Key)
                IV = Encoding.ASCII.GetBytes(_IV)
                cipherText = Convert.FromBase64String(Me._Encrypted)

                dec.IV = IV
                plainText = dec.Decrypt(cipherText, key)
                Me._Decrypted = Encoding.ASCII.GetString(plainText)
            Catch ex As Exception
                Throw ex
            End Try
        End Sub
    End Class
End Namespace