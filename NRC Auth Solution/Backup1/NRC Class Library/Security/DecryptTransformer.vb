Imports System.Security.Cryptography
Namespace Security
    Friend Class DecryptTransformer
        Private algorithmID As EncryptionAlgorithm
        Private initVec() As Byte

        Friend WriteOnly Property IV() As Byte()
            Set(ByVal Value As Byte())
                Me.initVec = Value
            End Set
        End Property

        Friend Sub New(ByVal deCryptID As EncryptionAlgorithm)
            Me.algorithmID = deCryptID
        End Sub

        Friend Function GetCryptoServiceProvider(ByVal bytesKey() As Byte) As ICryptoTransform
            Select Case Me.algorithmID
                Case EncryptionAlgorithm.Des
                    Dim des As New DESCryptoServiceProvider
                    des.Mode = CipherMode.CBC
                    des.Key = bytesKey
                    des.IV = Me.initVec
                    Return des.CreateDecryptor
                Case EncryptionAlgorithm.TripleDes
                    Dim des3 As New TripleDESCryptoServiceProvider
                    des3.Mode = CipherMode.CBC
                    Return des3.CreateDecryptor(bytesKey, initVec)
                Case EncryptionAlgorithm.Rc2
                    Dim rc2 As New RC2CryptoServiceProvider
                    rc2.Mode = CipherMode.CBC
                    Return rc2.CreateDecryptor(bytesKey, initVec)
                Case EncryptionAlgorithm.Rijndael
                    Dim rijndael As New RijndaelManaged
                    rijndael.Mode = CipherMode.CBC
                    Return rijndael.CreateDecryptor(bytesKey, initVec)
                Case Else
                    Throw New CryptographicException("Algorithm ID '" & Me.algorithmID & "' is not supported.")
            End Select
        End Function

    End Class

End Namespace
