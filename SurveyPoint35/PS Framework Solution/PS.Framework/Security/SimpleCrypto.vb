Imports System.Security.Cryptography
Imports System.IO
Imports System.Text
Namespace Security
    ''' <summary>
    ''' Provides simple was to encrypt and decrypt strings.
    ''' </summary>
    ''' <remarks></remarks>    
    Public Class SimpleCrypto

#Region " Fields "
        Private Shared mCryptoProvider As RijndaelManaged
        Private Shared ReadOnly Key() As Byte = {18, 19, 8, 24, 36, 22, 4, 22, 17, 5, 11, 9, 13, 15, 6, 23}
        Private Shared ReadOnly IV() As Byte = {14, 2, 16, 7, 5, 9, 17, 8, 4, 47, 16, 12, 1, 32, 25, 18}
#End Region
#Region " Constructors "
        Shared Sub New()
            mCryptoProvider = New RijndaelManaged
            mCryptoProvider.Mode = CipherMode.CBC
            mCryptoProvider.Padding = PaddingMode.PKCS7
        End Sub
#End Region
#Region " Shared Methods "
        Public Shared Function Encrypt(ByVal unencrptedString As String)
            Dim bytIn() As Byte = ASCIIEncoding.ASCII.GetBytes(unencrptedString)
            Dim ms As MemoryStream = New MemoryStream
            Dim cs As New CryptoStream(ms, mCryptoProvider.CreateEncryptor(Key, IV), CryptoStreamMode.Write)
            cs.Write(bytIn, 0, bytIn.Length)
            cs.FlushFinalBlock()
            Dim bytOut() As Byte = ms.ToArray
            Return Convert.ToBase64String(bytOut)
        End Function
        Public Shared Function Decrypt(ByVal encryptedString As String)
            If (encryptedString.Trim().Length <> 0) Then
                Dim bytIn() As Byte = Convert.FromBase64String(encryptedString)
                Dim ms As New MemoryStream(bytIn, 0, bytIn.Length)
                Dim cs As New CryptoStream(ms, mCryptoProvider.CreateDecryptor(Key, IV), CryptoStreamMode.Read)
                Dim sr As New StreamReader(cs)
                Return sr.ReadToEnd()
            Else
                Return ""
            End If
        End Function
#End Region
    End Class
End Namespace
