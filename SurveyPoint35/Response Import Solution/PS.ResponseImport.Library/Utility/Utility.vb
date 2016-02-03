Public Class StringHelpers
    Public Shared Function GetNumericDate() As String
        'TODO:  Just google to format correctly.
        Dim retVal As String = String.Empty
        Dim dte As DateTime = Now
        retVal = dte.ToShortDateString
        retVal += dte.ToShortTimeString
        retVal = Replace(retVal, "/", "")
        retVal = Replace(retVal, ".", "")
        retVal = Replace(retVal, ":", "")
        retVal = Replace(retVal, " ", "")
        Return retVal
    End Function
    Public Shared Function AppendDateToFileName(ByVal fn As String) As String
        Dim retVal As String = fn
        If retVal.LastIndexOf("."c) > 0 Then
            Dim ext As String = retVal.Substring(retVal.LastIndexOf("."c))
            retVal = retVal.Substring(0, retVal.LastIndexOf("."c)) & "_" & GetNumericDate() & ext
        Else
            retVal = retVal & GetNumericDate()
        End If

        Return retVal
    End Function
    Public Shared Function ReplaceTicks(ByVal str As String) As String
        Return Replace(str, "'", "''")
    End Function
    Public Shared Function NullString(ByVal obj As Object) As String
        If IsDBNull(obj) Then
            Return ""
        Else
            Return CStr(obj)
        End If
    End Function

End Class

