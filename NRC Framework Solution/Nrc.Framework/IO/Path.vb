Imports System.IO

Namespace IO
    Public Class Path
        Public Shared Function CleanFileName(ByVal fileName As String) As String
            For Each badChar As Char In System.IO.Path.GetInvalidFileNameChars
                fileName = fileName.Replace(badChar, "")
            Next
            Return fileName
        End Function

        Public Shared Function IsValidFileName(ByVal Filename As String) As Boolean
            If String.IsNullOrEmpty(Filename) Then
                Throw New Exception(" File name cannot be blank!")
                Return False
            End If

            ' Get a list of invalid file characters.
            Dim invalidFileChars As Char() = System.IO.Path.GetInvalidFileNameChars()
            Dim userchars As Char() = Filename.ToCharArray()

            For Each c As Char In userchars
                For Each i As Char In invalidFileChars
                    If c = i Then
                        Throw New Exception("File name contains invalid chars!")
                    End If
                Next i
            Next c

            Return True
        End Function
    End Class


End Namespace

