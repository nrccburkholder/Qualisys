Imports System.Security.Cryptography
Imports System.Text

Friend Class PasswordHelper
    Private Shared SPECIAL_CHARS() As Char = "abcdefghijkzmnopqrstuvwxy".ToCharArray

    ''' <summary>
    ''' Converts a plain-text password to a base65 hashed string for secure storage
    ''' </summary>
    ''' <param name="password">The plain-text password</param>
    ''' <param name="salt">The salt value to be appended to the password</param>
    Friend Shared Function HashPassword(ByVal password As String, ByVal salt As String) As String
        If password Is Nothing OrElse password = "" Then
            Throw New ArgumentNullException("password")
        End If
        If salt Is Nothing OrElse salt = "" Then
            Throw New ArgumentNullException("salt")
        End If

        Dim passwordBytes As Byte() = Encoding.Unicode.GetBytes(password)
        Dim saltBytes As Byte() = Convert.FromBase64String(salt)
        Dim totalBytes As Byte() = New Byte(saltBytes.Length + passwordBytes.Length - 1) {}
        Dim resultBytes As Byte() = Nothing
        Buffer.BlockCopy(saltBytes, 0, totalBytes, 0, saltBytes.Length)
        Buffer.BlockCopy(passwordBytes, 0, totalBytes, saltBytes.Length, passwordBytes.Length)

        Return HashString(totalBytes)
    End Function

    ''' <summary>
    ''' Hashes a string
    ''' </summary>
    ''' <param name="plainText">The string to be hashed</param>
    Friend Shared Function HashString(ByVal plainText As String) As String
        Return HashString(Encoding.Unicode.GetBytes(plainText))
    End Function
    ''' <summary>
    ''' Hashes a byte array and returns the string
    ''' </summary>
    ''' <param name="plainTextBytes">The byte array to be hashed</param>
    Friend Shared Function HashString(ByVal plainTextBytes() As Byte) As String
        Dim hastBytes() As Byte
        If plainTextBytes Is Nothing OrElse plainTextBytes.Length = 0 Then
            Throw New ArgumentNullException("plainTextBytes")
        End If
        Dim hash As HashAlgorithm = HashAlgorithm.Create("MD5")
        If (hash Is Nothing) Then
            Throw New Exception("Could not create hash algorithm.")
        End If

        hastBytes = hash.ComputeHash(plainTextBytes)

        Return Convert.ToBase64String(hastBytes)
    End Function

    ''' <summary>
    ''' Generates a random salt string
    ''' </summary>
    Friend Shared Function GenerateSalt() As String
        Dim buffer As Byte() = New Byte(15) {}
        Dim rng As New RNGCryptoServiceProvider
        rng.GetBytes(buffer)
        Return Convert.ToBase64String(buffer)
    End Function

    ''' <summary>
    ''' Generates a random 12 character password string
    ''' </summary>
    Friend Shared Function GeneratePassword() As String
        Dim pass As String = GeneratePassword(12)
        While Not IsAlphaNumeric(pass)
            pass = GeneratePassword(12)
        End While
        Return pass
    End Function
    ''' <summary>
    ''' Generates a random password string
    ''' </summary>
    ''' <param name="length">The desired length of the password</param>
    Friend Shared Function GeneratePassword(ByVal length As Integer) As String
        If ((length < 1) OrElse (length > 50)) Then
            Throw New ArgumentException("Password length must be between 2 and 50")
        End If

        Dim buffer As Byte() = New Byte(length - 1) {}
        Dim chars As Char() = New Char(length - 1) {}
        Dim rng As New RNGCryptoServiceProvider
        rng.GetBytes(buffer)

        Dim num1 As Integer
        For num1 = 0 To length - 1
            Dim num2 As Integer = (buffer(num1) Mod 87)
            If (num2 < 10) Then
                chars(num1) = Convert.ToChar(48 + num2)
            ElseIf (num2 < 36) Then
                chars(num1) = Convert.ToChar((65 + num2) - 10)

            ElseIf (num2 < 62) Then
                chars(num1) = Convert.ToChar((97 + num2) - 36)
            Else
                chars(num1) = SPECIAL_CHARS(num2 - 62)
            End If
        Next
        Return New String(chars)
    End Function

    Friend Shared Function IsStrongPassword(ByVal password As String) As Boolean
        If password.Length < 8 Then
            Return False
        End If
        If Not PasswordHelper.IsAlphaNumeric(password) Then
            Return False
        End If

        Return True
    End Function

    Friend Shared Function IsAlphaNumeric(ByVal str As String) As Boolean
        Dim hasDigit As Boolean = False
        Dim hasLetter As Boolean = False
        For i As Integer = 0 To str.Length - 1
            hasDigit = hasDigit OrElse Char.IsDigit(str, i)
            hasLetter = hasLetter OrElse Char.IsLetter(str, i)
        Next

        Return (hasDigit AndAlso hasLetter)
    End Function

End Class
