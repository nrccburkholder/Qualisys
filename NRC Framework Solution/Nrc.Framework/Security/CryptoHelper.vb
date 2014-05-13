Imports System.Security.Cryptography
Imports System.IO

Namespace Security

    ''' <summary>
    ''' A class that simplifies usage of the .NET Framework cryptography namespace
    ''' </summary>
    Public Class CryptoHelper
        Implements IDisposable

#Region " Private Members "
        Private mAlgorithm As System.Security.Cryptography.SymmetricAlgorithm
        Private mEncryptTransform As ICryptoTransform
        Private mDecryptTransform As ICryptoTransform
#End Region

#Region " Factory Methods "

#Region " DES "
        ''' <summary>
        ''' Creates a CryptoHelper instance using the DES algorithm
        ''' </summary>
        ''' <param name="key">An 8 byte encryption key</param>
        ''' <param name="vector">An 8 byte initialization vector</param>
        ''' <returns>Returns a new CryptoHelper instance.</returns>
        Public Overloads Shared Function CreateDESCryptoHelper(ByVal key As Byte(), ByVal vector As Byte()) As CryptoHelper
            If Not key.Length = 8 Then
                Throw New ArgumentOutOfRangeException("key", "The key for this algorithm must be 8 bytes long.")
            End If
            If Not vector.Length = 8 Then
                Throw New ArgumentOutOfRangeException("vector", "The initialization vector for this algorithm must be 8 bytes long.")
            End If
            Return New CryptoHelper(DES.Create, key, vector)
        End Function

        ''' <summary>
        ''' Creates a CryptoHelper instance using the DES algorithm with a generated key and initialization vector
        ''' </summary>
        ''' <returns>Returns a new CryptoHelper instance.</returns>
        Public Overloads Shared Function CreateDESCryptoHelper() As CryptoHelper
            Return New CryptoHelper(DES.Create)
        End Function
#End Region

#Region " Triple DES "
        ''' <summary>
        ''' Creates a CryptoHelper instance using the Triple DES algorithm
        ''' </summary>
        ''' <param name="key">A 16 or 24 byte encryption key</param>
        ''' <param name="vector">An 8 byte initialization vector</param>
        ''' <returns>Returns a new CryptoHelper instance.</returns>
        Public Overloads Shared Function CreateTripleDESCryptoHelper(ByVal key As Byte(), ByVal vector As Byte()) As CryptoHelper
            If Not (key.Length = 16 OrElse key.Length = 24) Then
                Throw New ArgumentOutOfRangeException("key", "The key for this algorithm must be 16 or 24 bytes long.")
            End If
            If Not vector.Length = 8 Then
                Throw New ArgumentOutOfRangeException("vector", "The initialization vector for this algorithm must be 8 bytes long.")
            End If
            Return New CryptoHelper(TripleDES.Create, key, vector)
        End Function

        ''' <summary>
        ''' Creates a CryptoHelper instance using the Triple DES algorithm with a generated key and initialization vector
        ''' </summary>
        ''' <returns>Returns a new CryptoHelper instance.</returns>
        Public Overloads Shared Function CreateTripleDESCryptoHelper() As CryptoHelper
            Return New CryptoHelper(TripleDES.Create)
        End Function
#End Region

#Region " AES "
        ''' <summary>
        ''' Creates a CryptoHelper instance using the AES (Rijndael) algorithm
        ''' </summary>
        ''' <param name="key">A 16 byte encryption key</param>
        ''' <param name="vector">A 16 byte initialization vector</param>
        ''' <returns>Returns a new CryptoHelper instance.</returns>
        Public Overloads Shared Function CreateAESCryptoHelper(ByVal key As Byte(), ByVal vector As Byte()) As CryptoHelper
            If Not key.Length = 16 Then
                Throw New ArgumentOutOfRangeException("key", "The key for this algorithm must be 16 bytes long.")
            End If
            If Not vector.Length = 16 Then
                Throw New ArgumentOutOfRangeException("vector", "The initialization vector for this algorithm must be 16 bytes long.")
            End If
            Return New CryptoHelper(RijndaelManaged.Create, key, vector)
        End Function

        ''' <summary>
        ''' Creates a CryptoHelper instance using the AES (Rijndael) algorithm with a generated key and initialization vector
        ''' </summary>
        ''' <returns>Returns a new CryptoHelper instance.</returns>
        Public Overloads Shared Function CreateAESCryptoHelper() As CryptoHelper
            Return New CryptoHelper(RijndaelManaged.Create)
        End Function
#End Region

#Region " RC2 "
        ''' <summary>
        ''' Creates a CryptoHelper instance using the RC2 algorithm
        ''' </summary>
        ''' <param name="key">A 4-16 byte encryption key</param>
        ''' <param name="vector">A 8 byte initialization vector</param>
        ''' <returns>Returns a new CryptoHelper instance.</returns>
        Public Overloads Shared Function CreateRC2CryptoHelper(ByVal key As Byte(), ByVal vector As Byte()) As CryptoHelper
            If key.Length < 4 OrElse key.Length > 16 Then
                Throw New ArgumentOutOfRangeException("key", "The key for this algorithm must be between 4 to 16 bytes long.")
            End If
            If Not vector.Length = 8 Then
                Throw New ArgumentOutOfRangeException("vector", "The initialization vector for this algorithm must be 8 bytes long.")
            End If

            Return New CryptoHelper(RC2.Create, key, vector)
        End Function
        ''' <summary>
        ''' Creates a CryptoHelper instance using the RC2 algorithm with a generated key and initialization vector
        ''' </summary>
        ''' <returns>Returns a new CryptoHelper instance.</returns>
        Public Overloads Shared Function CreateRC2CryptoHelper() As CryptoHelper
            Return New CryptoHelper(RC2.Create)
        End Function
#End Region

#End Region

#Region " Constructors "

        ''' <summary>Constructor</summary>
        ''' <param name="algorithm">The symmetric algorithm to use for encryption</param>
        ''' <remarks>This constructor is private.  The shared factory methods should by used to create instances of this class.</remarks>
        Private Sub New(ByVal algorithm As SymmetricAlgorithm)
            mAlgorithm = algorithm
        End Sub

        ''' <summary>Constructor</summary>
        ''' <param name="algorithm">The symmetric algorithm to use for encryption</param>
        ''' <param name="key">The encryption key</param>
        ''' <param name="vector">The initialization vector</param>
        ''' <remarks>This constructor is private.  The shared factory methods should by used to create instances of this class.</remarks>
        Private Sub New(ByVal algorithm As SymmetricAlgorithm, ByVal key As Byte(), ByVal vector As Byte())
            mAlgorithm = algorithm
            mAlgorithm.Key = key
            mAlgorithm.IV = vector
        End Sub
#End Region

#Region " Public Properties "
        Public ReadOnly Property Key() As Byte()
            Get
                Return mAlgorithm.Key
            End Get
        End Property
        Public ReadOnly Property Vector() As Byte()
            Get
                Return mAlgorithm.IV
            End Get
        End Property
#End Region

#Region " Private Properties "
        Private ReadOnly Property Encryptor() As ICryptoTransform
            Get
                'Create the transform if we haven't yet
                If mEncryptTransform Is Nothing Then
                    mEncryptTransform = mAlgorithm.CreateEncryptor()
                End If

                Return mEncryptTransform
            End Get
        End Property

        Private ReadOnly Property Decryptor() As ICryptoTransform
            Get
                'Create the transform if we haven't yet
                If mDecryptTransform Is Nothing Then
                    mDecryptTransform = mAlgorithm.CreateDecryptor()
                End If
                Return mDecryptTransform
            End Get
        End Property
#End Region

#Region " Public Methods "
        ''' <summary>
        ''' Encrypts an array of bytes
        ''' </summary>
        ''' <param name="plainData">The "plain text" data to encrypt.</param>
        ''' <returns>The encrypted array of bytes</returns>
        Public Function Encrypt(ByVal plainData As Byte()) As Byte()
            Return TransformBlock(plainData, Me.Encryptor)
        End Function

        ''' <summary>
        ''' Decrypts an array of bytes
        ''' </summary>
        ''' <param name="cipherData">The "cipher text" data to decrypt.</param>
        ''' <returns>The decrypted array of bytes</returns>
        Public Function Decrypt(ByVal cipherData As Byte()) As Byte()
            Return TransformBlock(cipherData, Me.Decryptor)
        End Function

        ''' <summary>Encrypts a string</summary>
        ''' <param name="plainText">The "plain text" string to encrypt</param>
        ''' <returns>A Base 64 string of the cipher text</returns>
        Public Function EncryptString(ByVal plainText As String) As String
            Dim plainData As Byte() = System.Text.Encoding.ASCII.GetBytes(plainText)
            Dim cipherData As Byte() = Me.Encrypt(plainData)
            Return Convert.ToBase64String(cipherData)
        End Function

        ''' <summary>Decrypts a string</summary>
        ''' <param name="cipherText">The Base 64 "cipher text" string to decrypt</param>
        ''' <returns>The plain text string</returns>
        Public Function DecryptString(ByVal cipherText As String) As String
            Dim cipherData As Byte() = Convert.FromBase64String(cipherText)
            Dim plainData As Byte() = Me.Decrypt(cipherData)
            Return System.Text.Encoding.ASCII.GetString(plainData)
        End Function

#End Region

#Region " Private Methods "

        'Transforms a set of bytes using the specified transformation
        Private Shared Function TransformBlock(ByVal data As Byte(), ByVal transform As ICryptoTransform) As Byte()
            Using ms As New MemoryStream
                Using cryptoStream As New System.Security.Cryptography.CryptoStream(ms, transform, CryptoStreamMode.Write)
                    cryptoStream.Write(data, 0, data.Length)
                    cryptoStream.FlushFinalBlock()
                    cryptoStream.Close()
                    Return ms.ToArray
                End Using
            End Using
        End Function

#End Region

#Region " IDisposable "
        Private disposedValue As Boolean = False        ' To detect redundant calls

        ' IDisposable
        Protected Overridable Sub Dispose(ByVal disposing As Boolean)
            If Not Me.disposedValue Then
                If disposing Then
                    If mEncryptTransform IsNot Nothing Then mEncryptTransform.Dispose()
                    If mDecryptTransform IsNot Nothing Then mDecryptTransform.Dispose()
                End If

                ' TODO: free shared unmanaged resources
            End If
            Me.disposedValue = True
        End Sub

#Region " IDisposable Support "
        ' This code added by Visual Basic to correctly implement the disposable pattern.
        Public Sub Dispose() Implements IDisposable.Dispose
            ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub
#End Region
#End Region

    End Class
End Namespace
