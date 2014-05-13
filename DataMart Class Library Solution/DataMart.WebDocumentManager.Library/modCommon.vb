Module modCommon
    Public Function StringRight(ByVal s As String, ByVal length As Integer) As String
        If (s Is Nothing) Then Return Nothing
        If (s = "") Then Return ""
        If (length > s.Length) Then length = s.Length
        Return s.Substring(s.Length - length, length)
    End Function

    Public Sub AppendFolderLastSlash(ByRef path As String)
        If (StringRight(path, 1) <> "\") Then
            path += "\"
        End If
    End Sub

End Module
