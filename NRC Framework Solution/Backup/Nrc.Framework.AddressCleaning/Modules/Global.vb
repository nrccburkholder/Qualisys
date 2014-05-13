Module modMain

    ''' <summary>
    ''' This routine is used to cleanup null terminated strings returned 
    ''' from the name and address cleaning DLLs.  It trims the string at 
    ''' the terminating null and replaces all single and double quotes with 
    ''' fancy quotes.
    ''' </summary>
    ''' <param name="origStr">The string to be cleaned up.</param>
    ''' <param name="replaceQuotes">Specifies whether or not to replace all quotes (double and single) with fancy quotes.</param>
    ''' <param name="replaceCommas">Specifies whether or not to replace all commas with a space.  If this results in a double space then that will be replaced with a single space.</param>
    ''' <returns>Returns the cleaned up string.</returns>
    ''' <remarks></remarks>
    Public Function CleanString(ByVal origStr As String, ByVal replaceQuotes As Boolean, ByVal replaceCommas As Boolean) As String

        Dim loc As Integer

        'Trim the string off at the location of the null character if one is present
        loc = origStr.IndexOf(Chr(0))
        If loc > -1 Then
            origStr = origStr.Substring(0, loc)
        End If

        'Replace any single or double quotes with fancy quotes
        If replaceQuotes Then
            origStr = ReplaceAllQuotes(origStr)
        End If

        'Replace any commas with a space and double space with a single space
        If replaceCommas Then
            origStr = ReplaceAllCommas(origStr)
        End If

        'Trim off any leading or trailing blanks
        origStr = origStr.Trim

        'Set the return value
        Return origStr

    End Function

    ''' <summary>
    ''' This routine is used to replace all single and double quotes with 
    ''' fancy quotes.
    ''' </summary>
    ''' <param name="origStr">The original string to be cleaned up.</param>
    ''' <returns>The cleaned string or an empty string if an error is encountered.</returns>
    ''' <remarks></remarks>
    Private Function ReplaceAllQuotes(ByVal origStr As String) As String

        Try
            'Replace all single quotes with fancy quote
            origStr = origStr.Replace(Chr(39), "`"c)

            'Replace all double quotes with fancy quote
            origStr = origStr.Replace(Chr(34), "`"c)

        Catch
            origStr = String.Empty

        End Try

        Return origStr

    End Function

    ''' <summary>
    ''' This routine is used to replace all commas with a space.
    ''' </summary>
    ''' <param name="origStr">The original string to be cleaned up.</param>
    ''' <returns>The cleaned string or an empty string if an error is encountered.</returns>
    ''' <remarks></remarks>
    Private Function ReplaceAllCommas(ByVal origStr As String) As String

        Try
            'Replace all commas with a space
            origStr = origStr.Replace(","c, " "c)

            'Replace all double spaces with single spaces
            origStr = origStr.Replace("  ", " ")

        Catch
            origStr = String.Empty

        End Try

        Return origStr

    End Function

End Module
