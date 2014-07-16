Attribute VB_Name = "modStringRoutines"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      StringRoutines.bas
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains a collection of usefull string
'\\                 manipulation routines.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Replace
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   01-08-2001
'\\
'\\ Description:    This routine is used to replace one or all occurances
'\\                 of the specified string with another string.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sString     String      The string to be edited.
'\\     sSearch     String      The substring to searched for.
'\\     sReplace    String      The substring to be used to replace one
'\\                             or all occurances of the search string.
'\\     nStart      Integer     The starting position with sString to
'\\                             to be used for the search.
'\\     bReplaceAll Boolean     Specifies whether or not to replace all
'\\                             occurances of sSearch with sReplace.
'\\                             TRUE  - Replace all occurances (Default)
'\\                             FALSE - Replace only the first occurance
'\\     eCompare    VbCompareMethod Enum
'\\                             Specified the type of search to be
'\\                             performed.  Refer to VB Help on the
'\\                             INSTR function for an explanation.
'\\                             vbBinaryCompare is the Default.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function Replace(ByVal sString As String, _
                        ByVal sSearch As String, _
                        ByVal sReplace As String, _
                        Optional ByVal nStart As Integer = 1, _
                        Optional ByVal bReplaceAll As Boolean = True, _
                        Optional ByVal eCompare As VbCompareMethod = vbBinaryCompare) As String

    Dim nLoc    As Integer
    Dim sTemp   As String

    'Set the error trap
    On Error GoTo ErrorHandler

    'Determine the first location of the search string
    nLoc = InStr(nStart, sString, sSearch, eCompare)

    'Loop through the string replacing all occurances of sSearch with sReplace
    Do While nLoc > 0
        'Perform the replacement
        sString = Left(sString, nLoc - 1) & sReplace & Mid(sString, nLoc + Len(sSearch))

        'Determine if we need to do any further replacements
        If bReplaceAll Then
            'We are to replace all occurances so check for the next one
            nLoc = InStr(nStart, sString, sSearch, eCompare)
        Else
            'We are only supposed to replace the first occurance
            '  so lets head out of dodge
            nLoc = 0
        End If
    Loop

    'Set the return value
    Replace = sString

Exit Function


ErrorHandler:
    Replace = ""
    Exit Function

End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   CPad
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is used to pad out a string so as to
'\\                 center it in a specified length with the character
'\\                 of your choice.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     sString         String      The original string to be padded.
'\\     nLength         Integer     The length to pad the string out to.
'\\     sPadCharacter   String      Optional: The character to be used
'\\                                 to pad the string.  Defaults to a
'\\                                 SPACE character.
'\\     bTruncate       Boolean     Optional: Specifies whether or not
'\\                                 to truncate the original string to
'\\                                 the specified length if it already
'\\                                 exceeds it.  Defaults to FALSE.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The padded string or an empty string if an error
'\\                 is encountered.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function CPad(ByVal sString As String, _
                     ByVal nLength As Integer, _
                     Optional ByVal sPadCharacter As String = " ", _
                     Optional ByVal bTruncate As Boolean = False)
    
    Dim nPadLength As Integer
    Dim sTemp      As String
    Dim bFlag      As Boolean
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Determine the length of the return string
    If bTruncate Then
        nPadLength = nLength
    Else
        If Len(sString) > nLength Then
            nPadLength = Len(sString)
        Else
            nPadLength = nLength
        End If
    End If
    
    'Build the working string
    sTemp = String(nLength, sPadCharacter) & sString & String(nLength, sPadCharacter)
    
    'Now center the original string
    bFlag = False
    Do Until Len(sTemp) = nPadLength
        If bFlag Then
            sTemp = Right(sTemp, Len(sTemp) - 1)
        Else
            sTemp = Left(sTemp, Len(sTemp) - 1)
        End If
        bFlag = Not bFlag
    Loop
    
    'Return the padded string
    CPad = sTemp
    
Exit Function


ErrorHandler:
    CPad = ""
    Exit Function
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   LPad
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is used to pad out the left side of
'\\                 a string to a specified length with the character
'\\                 of your choice.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     sString         String      The original string to be padded.
'\\     nLength         Integer     The length to pad the string out to.
'\\     sPadCharacter   String      Optional: The character to be used
'\\                                 to pad the string.  Defaults to a
'\\                                 SPACE character.
'\\     bTruncate       Boolean     Optional: Specifies whether or not
'\\                                 to truncate the original string to
'\\                                 the specified length if it already
'\\                                 exceeds it.  Defaults to FALSE.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The padded string or an empty string if an error
'\\                 is encountered.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function LPad(ByVal sString As String, _
                     ByVal nLength As Integer, _
                     Optional ByVal sPadCharacter As String = " ", _
                     Optional ByVal bTruncate As Boolean = False)
    
    Dim nPadLength As Integer
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Determine the length of the return string
    If bTruncate Then
        nPadLength = nLength
    Else
        If Len(sString) > nLength Then
            nPadLength = Len(sString)
        Else
            nPadLength = nLength
        End If
    End If
    
    'Return the padded string
    LPad = Right(String(nLength, sPadCharacter) & sString, nPadLength)
    
Exit Function


ErrorHandler:
    LPad = ""
    Exit Function
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   RPad
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is used to pad out the right side of
'\\                 a string to a specified length with the character
'\\                 of your choice.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     sString         String      The original string to be padded.
'\\     nLength         Integer     The length to pad the string out to.
'\\     sPadCharacter   String      Optional: The character to be used
'\\                                 to pad the string.  Defaults to a
'\\                                 SPACE character.
'\\     bTruncate       Boolean     Optional: Specifies whether or not
'\\                                 to truncate the original string to
'\\                                 the specified length if it already
'\\                                 exceeds it.  Defaults to FALSE.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The padded string or an empty string if an error
'\\                 is encountered.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function RPad(ByVal sString As String, _
                     ByVal nLength As Integer, _
                     Optional ByVal sPadCharacter As String = " ", _
                     Optional ByVal bTruncate As Boolean = False)
    
    Dim nPadLength As Integer
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Determine the length of the return string
    If bTruncate Then
        nPadLength = nLength
    Else
        If Len(sString) > nLength Then
            nPadLength = Len(sString)
        Else
            nPadLength = nLength
        End If
    End If
    
    'Return the padded string
    RPad = Left(sString & String(nLength, sPadCharacter), nPadLength)
    
Exit Function


ErrorHandler:
    RPad = ""
    Exit Function
    
End Function


