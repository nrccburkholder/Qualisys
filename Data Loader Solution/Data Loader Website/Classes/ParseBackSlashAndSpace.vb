Public Class ParseBackSlashAndSpace

    Private Const _wrapLength As Integer = 25
    Private Const _BSeperator As String = ""
    Private Const _ESeperator As String = "<br />"
    Private Const _tWrap As String = ""
    Private Const _CharToParse As String = "\"

    Public Shared Function ParseText(ByVal txt As String, _
     Optional ByVal beginTag As String = "", _
     Optional ByVal endTag As String = "", _
     Optional ByVal wrapper As Boolean = False, _
     Optional ByVal CharToParseOn As String = "", _
     Optional ByVal OtherParseLength As Integer = -1)
        Return ParseBackSlash(txt, beginTag, endTag, wrapper, CharToParseOn, OtherParseLength)
    End Function




    Private Shared Function ParseBackSlash(ByVal Pstring As String, _
     ByVal beginTag As String, _
      ByVal endTag As String, _
       ByVal wrapper As Boolean, _
        ByVal CharToParseOn As String, _
         ByVal OtherParseLength As Integer) As String
        Dim UploadFileName As New System.Text.StringBuilder
        'Count of how long each line will be
        Dim BTag As String = String.Empty
        Dim ETag As String = String.Empty
        Dim CharToParse As String = String.Empty
        If beginTag = "" Then
            BTag = _BSeperator
        Else
            BTag = beginTag
        End If
        If endTag = "" Then
            ETag = _ESeperator
        Else
            ETag = endTag
        End If
        Dim charCount As Integer
        If OtherParseLength > -1 Then
            charCount = OtherParseLength
        Else
            charCount = _wrapLength
        End If
        If CharToParseOn <> "" Then
            CharToParse = CharToParseOn
        Else
            CharToParse = _CharToParse
        End If

        'the stop point is the point at which the lastindexof a \ was found
        Dim StopPoint As Integer = 0
        'tagspot is the actual line that will be added to the stringbuilder
        Dim TagSpot As String = ""
        'line to check is a parse of the 25 characters creating a line 
        Dim LineTocheck As String = ""
        If Len(Pstring) > charCount Then
            For loopint As Integer = 0 To Len(Pstring) - 1
                ' will get psstring characters 1-25
                LineTocheck = Mid(Pstring, loopint + 1, charCount)
                'will find the last index of a \ in the lineto check 
                'adding one because it returns with an index starting at 0
                StopPoint = LineTocheck.LastIndexOf(CharToParse) + 1
                'if stop point is >0 then there is a \ so set the string to cut off after it
                'else just put the entire 25 characters on the line 
                If StopPoint > 0 Then
                    TagSpot = Left(LineTocheck, StopPoint)
                Else
                    'If there is no \ then break at the last space 
                    StopPoint = LineTocheck.LastIndexOf(" ") + 1
                    If StopPoint > 0 Then
                        TagSpot = Left(LineTocheck, StopPoint)

                    Else
                        'if there is no space then just break at 25
                        TagSpot = LineTocheck
                    End If
                End If
                'append the line to the uploadfilename string builder
                UploadFileName.Append(BTag)
                UploadFileName.Append(TagSpot)
                If loopint + Len(TagSpot) - 1 < Len(Pstring) - 1 Then
                    UploadFileName.AppendLine(ETag)
                End If
                'add the amount you have just chopped off to the loopint 
                'since loopint starts at 0 subtract 1 from the len of string
                loopint += Len(TagSpot) - 1
                'clear the used variables 
                LineTocheck = ""
                StopPoint = Nothing
            Next
        Else
            UploadFileName.Append(Pstring)
        End If
        Return UploadFileName.ToString
        'clear the stringbuilder
        UploadFileName = Nothing
    End Function


End Class
