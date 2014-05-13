Imports System.Security.Cryptography
Namespace Security
    Friend Class EncryptTransformer
        Private algorithmID As EncryptionAlgorithm
        Private initVec() As Byte
        Private encKey() As Byte

        Friend Property IV() As Byte()
            Get
                Return Me.initVec
            End Get
            Set(ByVal Value As Byte())
                Me.initVec = Value
            End Set
        End Property

        Friend ReadOnly Property Key() As Byte()
            Get
                Return Me.encKey
            End Get
        End Property

        Friend Sub New(ByVal algId As EncryptionAlgorithm)
            Me.algorithmID = algId
        End Sub

        Friend Function GetCryptoServiceProvider(ByVal bytesKey() As Byte) As ICryptoTransform
            Select Case Me.algorithmID
                Case EncryptionAlgorithm.Des
                    Dim des As DES = New DESCryptoServiceProvider
                    des.Mode = CipherMode.CBC

                    If bytesKey Is Nothing Then
                        Me.encKey = des.Key
                    Else
                        des.Key = bytesKey
                        Me.encKey = des.Key
                    End If

                    If Me.initVec Is Nothing Then
                        Me.initVec = des.IV
                    Else
                        des.IV = Me.initVec
                    End If

                    Return des.CreateEncryptor
                Case EncryptionAlgorithm.TripleDes
                    Dim des3 As New TripleDESCryptoServiceProvider
                    des3.Mode = CipherMode.CBC

                    If bytesKey Is Nothing Then
                        Me.encKey = des3.Key
                    Else
                        des3.Key = bytesKey
                        Me.encKey = des3.Key
                    End If

                    If Me.initVec Is Nothing Then
                        Me.initVec = des3.IV
                    Else
                        des3.IV = Me.initVec
                    End If

                    Return des3.CreateEncryptor
                Case EncryptionAlgorithm.Rc2
                    Dim rc2 As New RC2CryptoServiceProvider
                    rc2.Mode = CipherMode.CBC

                    If bytesKey Is Nothing Then
                        Me.encKey = rc2.Key
                    Else
                        rc2.Key = bytesKey
                        Me.encKey = rc2.Key
                    End If

                    If Me.initVec Is Nothing Then
                        Me.initVec = rc2.IV
                    Else
                        rc2.IV = Me.initVec
                    End If

                    Return rc2.CreateEncryptor
                Case EncryptionAlgorithm.Rijndael
                    Dim rijndael As New RijndaelManaged
                    rijndael.Mode = CipherMode.CBC

                    If bytesKey Is Nothing Then
                        Me.encKey = rijndael.Key
                    Else
                        rijndael.Key = bytesKey
                        Me.encKey = rijndael.Key
                    End If

                    If Me.initVec Is Nothing Then
                        Me.initVec = rijndael.IV
                    Else
                        rijndael.IV = Me.initVec
                    End If

                    Return rijndael.CreateEncryptor
                Case Else
                    Throw New CryptographicException("Algorithm ID " & Me.algorithmID & " not supported.")
            End Select
        End Function

    End Class
End Namespace
