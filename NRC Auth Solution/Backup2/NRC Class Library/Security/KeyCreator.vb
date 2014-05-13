Imports System.Text
Imports System.Security.Cryptography

Namespace Security
    Public Class KeyCreator
        Private Const entropyData As String = "NRC Encryption Tool"

        Public Shared Function CreateKey(ByVal numBytes As Integer) As String
            Dim rng As New RNGCryptoServiceProvider
            Dim buffer(numBytes - 1) As Byte
            rng.GetBytes(buffer)
            Return BytesToHexString(buffer)
        End Function

        Public Shared Function BytesToHexString(ByVal bytes() As Byte) As String
            Dim hexString As New StringBuilder(64)

            For i As Integer = 0 To bytes.Length - 1
                hexString.Append(String.Format("{0:X2}", bytes(i)))
            Next
            Return hexString.ToString
        End Function
        Public Shared Function HexStringToBytes(ByVal hexString) As Byte()
            If Not hexString.Length Mod 2 = 0 Then
                Throw New ArgumentException("HEX String must contain an even number of characters", "hexString")
            End If

            Dim byteCount As Integer = hexString.Length / 2
            Dim bytes(byteCount - 1) As Byte

            For i As Integer = 0 To byteCount - 1
                bytes(i) = Byte.Parse(hexString.Substring(i * 2, 2), Globalization.NumberStyles.HexNumber)
            Next

            Return bytes
        End Function
        Public Shared Function HexStringToASCIIString(ByVal hexString As String) As String
            Dim bytes() As Byte = HexStringToBytes(hexString)

            Return Encoding.ASCII.GetString(bytes)
        End Function
        Public Shared Function ASCIIStringToHexString(ByVal asciiString As String)
            Dim asciiBytes() As Byte = Encoding.ASCII.GetBytes(asciiString)
            Return BytesToHexString(asciiBytes)
        End Function

        Public Shared Function GetRegistryEncryptionKey() As String
            Dim nrcKey As Microsoft.Win32.RegistryKey
            Dim keyKey As Microsoft.Win32.RegistryKey
            Dim nullVal As String = ""
            Dim cipherText As String = ""

            keyKey = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\National Research\Encryption Key")

            If keyKey Is Nothing Then
                Return nullVal
            Else
                cipherText = keyKey.GetValue("key", "")
                If cipherText = "" Then
                    Return nullVal
                Else
                    Return NRC.Security.DataProtection.Decrypt(cipherText, entropyData, NRC.Security.DataProtection.Store.Machine)
                End If
            End If
        End Function
        Public Shared Sub SetRegistryEncryptionKey(ByVal newKey As String)
            Dim nrcKey As Microsoft.Win32.RegistryKey
            Dim keyKey As Microsoft.Win32.RegistryKey
            Dim overwriteMsg As String = "An encryption key has already been stored.  Do you want to overwrite it?"
            Dim cipherText As String = NRC.Security.DataProtection.Encrypt(newKey, entropyData, NRC.Security.DataProtection.Store.Machine)

            nrcKey = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\National Research", True)
            keyKey = nrcKey.OpenSubKey("Encryption Key", True)

            If keyKey Is Nothing Then
                keyKey = nrcKey.CreateSubKey("Encryption Key")
            End If

            keyKey.SetValue("key", cipherText)
        End Sub
    End Class
End Namespace
