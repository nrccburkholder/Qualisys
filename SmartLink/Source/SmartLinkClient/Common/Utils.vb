Imports System.Security.Cryptography

Public Class Utils

    ' Note this has to return the same results as the equivalent function in the server's web service
    Public Shared Function CheckFileHash(ByVal FileName As String) As String
        Dim FilePath As String = FileName
        Dim hash() As Byte
        Dim SHA1 As SHA1CryptoServiceProvider = New SHA1CryptoServiceProvider
        Dim fs As FileStream

        fs = New FileStream(FilePath, FileMode.Open, FileAccess.Read, FileShare.Read, 4096)
        hash = SHA1.ComputeHash(fs)
        fs.Close()
        Return BitConverter.ToString(hash)
    End Function

End Class
