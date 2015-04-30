VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CComment"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CComment.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This file contains the object definition used to
'\\                 contain a single comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     01-28-02    JJF     Added the unmasked version of the comment
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private msBarcode               As String
    Private msLithoCode             As String
    Private mlSentMailID            As Long
    Private mlQuestionFormID        As Long
    Private mlSampleUnitID          As Long
    Private msCommentText           As String
    Private mlCommentType           As Long
    Private mlCommentValence        As Long
    Private mlQstnCore              As Long
    Private msCommentOrHandWritten  As String
    Private msBatchNumber           As String
    Private mlLineNumber            As Long
    Private msErrorString           As String
    Private msKey                   As String
    Private mbTextLineAdded         As Boolean
    Private mbCodeLineAdded         As Boolean
    Private mlUnusedReturnID        As Long
    Private mbQuestionNotFound      As Boolean
    Private msCommentTextUM         As String   '** Added 01-28-02 JJF
    Private meWhereIsIt             As eCountryCodeConstants    '** Added 05-27-05 JJF
    Private mlSamplePopID           As Long
    Private mlLithoCode         As Long  '** Added 04-30-205 TSB
    
    Private malCommentCodes()       As Long
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  WhereIsIt
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Sets/Returns the country code for where this survey
'\\                 is located.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Friend Property Let WhereIsIt(eData As eCountryCodeConstants)
    
    meWhereIsIt = eData
    
End Property

    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  WhereIsIt
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Sets/Returns the country code for where this survey
'\\                 is located.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get WhereIsIt() As eCountryCodeConstants
    
    WhereIsIt = meWhereIsIt
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsNameMaskingValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   01-21-2002
'\\
'\\ Description:    This function checks to see if the name masking
'\\                 brackets are in the correct locations and that
'\\                 each opening bracket has a matching closing bracket.
'\\                 If all is good then the brackets are replaced with
'\\                 the HTML code as required.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - If all masking brackets are formatted
'\\                         correctly.
'\\                 FALSE - Unequal bracket counts or brackets within
'\\                         brackets.
'\\ Revisions:
'\\     Date        By      Description
'\\     01-28-02    JJF     Changed the way the masking is done
'\\     04-09-03    JJF     Changed so that comments are masked
'\\                         regardless of the valence.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsNameMaskingValid() As Boolean
    
    Dim nLoc            As Integer
    Dim nPrevious       As Integer
    Dim nOpeningCnt     As Integer
    Dim nClosingCnt     As Integer
    Dim anLocOpening()  As Integer
    Dim anLocClosing()  As Integer
    Dim sTemp           As String
    'Dim sNameMaskPrefix As String  '** Removed 01-28-02 JJF
    'Dim sNameMaskSuffix As String  '** Removed 01-28-02 JJF
    Dim sMasked         As String   '** Added 01-28-02 JJF
    Dim sUnMasked       As String   '** Added 01-28-02 JJF
    Dim bDoMasking      As String   '** Added 01-28-02 JJF
    
    'Begin the error trap
    On Error GoTo ErrorHandler
    
    'Setup the replacement strings
    Select Case mlCommentValence
        Case eCommentValenceConstants.eCVCNegative, eCommentValenceConstants.eCVCBoth
            '** Modified 01-28-02 JJF
            'sNameMaskPrefix = gsNameMaskPrefix
            'sNameMaskSuffix = gsNameMaskSuffix
            bDoMasking = True
            '** End of modification 01-28-02 JJF
        Case Else
            '** Modified 04-09-03 JJF
            ''** Modified 01-28-02 JJF
            ''sNameMaskPrefix = ""
            ''sNameMaskSuffix = ""
            'bDoMasking = False
            ''** End of modification 01-28-02 JJF
            bDoMasking = True
            '** End of modification 04-09-03 JJF
    End Select
    
    'Prepare the arrays
    ReDim anLocOpening(nOpeningCnt) As Integer
    ReDim anLocClosing(nClosingCnt) As Integer
    
    'Find all of the opening brackets
    nLoc = InStr(msCommentText, "[")
    Do Until nLoc = 0
        'Store this location
        nOpeningCnt = nOpeningCnt + 1
        ReDim Preserve anLocOpening(nOpeningCnt) As Integer
        anLocOpening(nOpeningCnt) = nLoc
        
        'Get the next location
        nLoc = InStr(nLoc + 1, msCommentText, "[")
    Loop
    
    'Find all of the closing brackets
    nLoc = InStr(msCommentText, "]")
    Do Until nLoc = 0
        'Store this location
        nClosingCnt = nClosingCnt + 1
        ReDim Preserve anLocClosing(nClosingCnt) As Integer
        anLocClosing(nClosingCnt) = nLoc
        
        'Get the next location
        nLoc = InStr(nLoc + 1, msCommentText, "]")
    Loop
    
    'Check to make sure there are the same number of opening and closing braces
    If nOpeningCnt <> nClosingCnt Then
        IsNameMaskingValid = False
        Exit Function
    End If
    
    'Check to make sure that the closing bracket is after the opening bracket
    For nLoc = 1 To nOpeningCnt
        If anLocClosing(nLoc) < anLocOpening(nLoc) Then
            IsNameMaskingValid = False
            Exit Function
        End If
    Next nLoc
    
    'Check to make sure that the next open is after the previous close
    For nLoc = 2 To nOpeningCnt
        If anLocOpening(nLoc) < anLocClosing(nLoc - 1) Then
            IsNameMaskingValid = False
            Exit Function
        End If
    Next nLoc
    
    '** Modified 01-28-02 JJF
    ''If we made it to here then do the replacements
    'nPrevious = 1
    'For nLoc = 1 To nOpeningCnt
    '    'Replace the opening bracket
    '    sTemp = sTemp & Mid(msCommentText, nPrevious, anLocOpening(nLoc) - nPrevious) & sNameMaskPrefix
    '
    '    'Put the name in the string
    '    sTemp = sTemp & Mid(msCommentText, anLocOpening(nLoc) + 1, anLocClosing(nLoc) - anLocOpening(nLoc) - 1)
    '
    '    'Replace the closing bracket
    '    sTemp = sTemp & sNameMaskSuffix
    '
    '    'Prepare for next pass
    '    nPrevious = anLocClosing(nLoc) + 1
    '
    'Next nLoc
    '
    ''Add the tail end of the string
    'sTemp = sTemp & Mid(msCommentText, nPrevious)
    '
    ''Set the new string into the member variable
    'msCommentText = sTemp
    
    'If we made it to here then do the masking
    If nOpeningCnt > 0 Then
        'There were brackets so we must do the masking
        nPrevious = 1
        For nLoc = 1 To nOpeningCnt
            'Remove the opening bracket
            sMasked = sMasked & Mid(msCommentText, nPrevious, anLocOpening(nLoc) - nPrevious)
            sUnMasked = sUnMasked & Mid(msCommentText, nPrevious, anLocOpening(nLoc) - nPrevious)
            
            'Get the name
            sTemp = Mid(msCommentText, anLocOpening(nLoc) + 1, anLocClosing(nLoc) - anLocOpening(nLoc) - 1)
            
            'Put the name in the string
            sMasked = sMasked & String(Len(sTemp), "X")
            sUnMasked = sUnMasked & sTemp
            
            'Prepare for next pass
            nPrevious = anLocClosing(nLoc) + 1
            
        Next nLoc
        
        'Add the tail end of the string
        sMasked = sMasked & Mid(msCommentText, nPrevious)
        sUnMasked = sUnMasked & Mid(msCommentText, nPrevious)
        
        'Determine which strings are to be saved
        If bDoMasking Then
            msCommentText = sMasked
            msCommentTextUM = sUnMasked
        Else
            msCommentText = sUnMasked
            msCommentTextUM = ""
        End If
    Else
        'No brackets found so there is no unmasked string
        msCommentTextUM = ""
    End If
    '** End of modification 01-28-02 JJF
    
    'Set the return value
    IsNameMaskingValid = True
    
Exit Function


ErrorHandler:
    IsNameMaskingValid = False
    Exit Function
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QuestionNotFound
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns a flag indicating whether or not we
'\\                 were able to find this comment in CommentPos or
'\\                 BubblePos.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let QuestionNotFound(ByVal bData As Boolean)
    
    mbQuestionNotFound = bData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QuestionNotFound
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns a flag indicating whether or not we
'\\                 were able to find this comment in CommentPos or
'\\                 BubblePos.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get QuestionNotFound() As Boolean
    
    QuestionNotFound = mbQuestionNotFound
    
End Property



    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  UnusedReturnID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the UnusedReturnID for the questionaire
'\\                 that this comment is located on.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let UnusedReturnID(ByVal lData As Long)
    
    mlUnusedReturnID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  UnusedReturnID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the UnusedReturnID for the questionaire
'\\                 that this comment is located on.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get UnusedReturnID() As Long
    
    UnusedReturnID = mlUnusedReturnID
    
End Property



    
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CommentCodeCount
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the count of codes for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CommentCodeCount() As Long
    
    CommentCodeCount = UBound(malCommentCodes)
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ResponseString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets the CommentText for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ResponseString(ByVal sData As String)
    
    Dim sLineType   As String
    Dim sRemaining  As String
    Dim lLoc        As Long
    Dim lCnt        As Long
    Dim oToken      As CToken
    
    'Determine if we need to initialize this object
    lLoc = InStr(sData, ":")
    If Not mbTextLineAdded And Not mbCodeLineAdded Then
        'Get the barcode
        Barcode = Left(sData, 8)
        
        'Get the QstnCore
        QstnCore = Val(Trim(Mid(sData, 11, lLoc - 11)))
        
        'Set the Key Value
        msKey = "LC" & msLithoCode & "-QC" & QstnCore & "-CH" & msCommentOrHandWritten
    End If
    
    'Determine which line we are dealing with
    sLineType = UCase(Mid(sData, 10, 1))
    
    'Deal with the data according to the line type
    sRemaining = Trim(Mid(sData, lLoc + 1))
    If sLineType = "K" And Not mbTextLineAdded Then
        'This is the text of the comment
        'Set the text added flag
        mbTextLineAdded = True
        
        'Find the comment text
        msCommentText = sRemaining
        
    ElseIf sLineType = "C" And Not mbCodeLineAdded Then
        'This is the coding for the comment
        'Set the codes added flag
        mbCodeLineAdded = True
        
        If Len(sRemaining) > 0 Then
            'Create the token parcer object
            Set oToken = New CToken
            
            'Parse out the codes
            With oToken
                'Set the string and delimiter
                .ParseString = sRemaining
                .Delimiter = ","
                
                'Get the CommentType
                mlCommentType = Val(.GetNextToken)
                
                'Get the CommentValence
                mlCommentValence = Val(.GetNextToken)
                
                'Get all of the codes
                lCnt = 0
                Do Until .IsFinished
                    lCnt = lCnt + 1
                    CommentCodes(lCnt) = Val(.GetNextToken)
                Loop
            End With
            
            'Cleanup
            Set oToken = Nothing
        End If
                
    End If
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CommentOrHandWritten
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns a character that identifies whether
'\\                 this entry is a comment or a HandWritten responce.
'\\                 'C' = Comment
'\\                 'H' = Hand Written responce
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CommentOrHandWritten() As String
    
    CommentOrHandWritten = msCommentOrHandWritten
    
End Property



    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QstnCore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the QstnCore for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Property Let QstnCore(ByVal lData As Long)
    
    If lData = gklCmntBoxIDOffset Then
        msCommentOrHandWritten = "A"
        mlQstnCore = lData - gklCmntBoxIDOffset
    ElseIf lData > gklCmntBoxIDOffset Then
        msCommentOrHandWritten = "C"
        mlQstnCore = lData - gklCmntBoxIDOffset
    Else
        msCommentOrHandWritten = "H"
        mlQstnCore = lData
    End If
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QstnCore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the QstnCore for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get QstnCore() As Long
    
    QstnCore = mlQstnCore
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CommentCodes
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the selected codes for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Property Let CommentCodes(ByVal lIndex As Long, _
                                  ByVal lData As Long)
    
    If lIndex > UBound(malCommentCodes) Then
        ReDim Preserve malCommentCodes(lIndex) As Long
    End If
    
    malCommentCodes(lIndex) = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CommentCodes
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the selected codes for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CommentCodes(ByVal lIndex As Long) As Long
    
    If lIndex < LBound(malCommentCodes) Or lIndex > UBound(malCommentCodes) Then
        CommentCodes = 0
    Else
        CommentCodes = malCommentCodes(lIndex)
    End If
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CommentValence
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the valence for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CommentValence() As Long
    
    CommentValence = mlCommentValence
    
End Property





'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CommentType
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the type for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CommentType() As Long
    
    CommentType = mlCommentType
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CommentText
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the text for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CommentText() As String
    
    CommentText = msCommentText
    
End Property




'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CommentTextUM
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   01-28-2002
'\\
'\\ Description:    Returns the text for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CommentTextUM() As String
    
    CommentTextUM = msCommentTextUM
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  BatchNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the batch number for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get BatchNumber() As String
    
    BatchNumber = msBatchNumber
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  BatchNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the batch number for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let BatchNumber(ByVal sData As String)
    
    msBatchNumber = sData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  LineNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the line number that this comment
'\\                 occupied in the scan file.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get LineNumber() As Long
    
    LineNumber = mlLineNumber
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  LineNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the first line number that this comment
'\\                 occupied in the scan file.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let LineNumber(ByVal lData As Long)
    
    'We only want the line number of the first line for this comment
    If lData < mlLineNumber Then mlLineNumber = lData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ErrorString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns any error conditions encountered while
'\\                 processing this comment.  Later used to create
'\\                 the INCOMPLETE file if any errors exist.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ErrorString() As String
    
    ErrorString = msErrorString
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ErrorString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns any error conditions encountered while
'\\                 processing this comment.  Later used to create
'\\                 the INCOMPLETE file if any errors exist.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ErrorString(ByVal sData As String)
    
    msErrorString = sData
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsCommentTypeValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine returns a flag indicating whether or
'\\                 not the comment type is valid.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - The comment type is valid.
'\\                 FALSE - The comment type failed the validation.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsCommentTypeValid() As Boolean
    
    IsCommentTypeValid = goCommentTypes.IsIDValid(lID:=mlCommentType)
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsCommentCodesValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine returns a flag indicating whether or
'\\                 not the comment codes are valid.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - The comment codes are valid.
'\\                 FALSE - The comment codes failed the validation.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     10-31-05    JJF     Added check for existence of at least one
'\\                         code.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsCommentCodesValid() As Boolean
    
    Dim bValid      As Boolean
    Dim lCnt        As Long
    Dim lQtyCodes   As Long
    
    'Optimistic initialization
    bValid = True
    lQtyCodes = 0
    
    'Loop through all the codes and validate them
    For lCnt = 1 To CommentCodeCount
        If Not goCommentCodes.IsIDValid(lID:=CommentCodes(lIndex:=lCnt)) Then
            bValid = False
            Exit For
        Else
            If Not goCommentCodes.IsDisposition(lID:=CommentCodes(lIndex:=lCnt)) Then
                lQtyCodes = lQtyCodes + 1
            End If
        End If
    Next lCnt
    
    'Check to see if we are still valid
    If bValid Then
        'All codes are valid so let's see if we have at least one code
        If lQtyCodes = 0 Then bValid = False
    End If
    
    'Set return value
    IsCommentCodesValid = bValid
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsCommentValenceValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine returns a flag indicating whether or
'\\                 not the comment valence is valid.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - The comment valence is valid.
'\\                 FALSE - The comment valence failed the validation.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsCommentValenceValid() As Boolean
    
    IsCommentValenceValid = goCommentValences.IsIDValid(lID:=mlCommentValence)
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsBarcodeValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine returns a flag indicating whether or
'\\                 not the check digit of the barcode is valid.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - The check digit is valid.
'\\                 FALSE - The check digit failed the validation.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsBarcodeValid() As Boolean
    
    IsBarcodeValid = IsCheckDigitValid(sBarCode:=msBarcode)
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Key
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the KEY for this questionaire used to
'\\                 keep the collection unique.
'\\                 It is "LC" & msLithoCode & "-QC" & mlQstnCore & "-CH" & msCommentOrHandWritten
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Key() As String
    
    Key = msKey
    
End Property




'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SampleUnitID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the SampleUnit_id for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let SampleUnitID(ByVal lData As Long)
    
    mlSampleUnitID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SamplePopID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-31-2005
'\\
'\\ Description:    Sets/Returns the SamplePop_id for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let SamplePopID(ByVal lData As Long)
    
    mlSamplePopID = lData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SampleUnitID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the SampleUnit_id for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get SampleUnitID() As Long
    
    SampleUnitID = mlSampleUnitID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SamplePopID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-31-2005
'\\
'\\ Description:    Sets/Returns the SamplePop_id for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get SamplePopID() As Long
    
    SamplePopID = mlSamplePopID
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  TextLineAdded
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns a boolean flag that indicates whether
'\\                 or not the comment text line was found in the
'\\                 import file.
'\\                 TRUE  - Comment Text Line found.
'\\                 FALSE - No Comment Text Line was present.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get TextLineAdded() As Boolean
    
    TextLineAdded = mbTextLineAdded
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CodeLineAdded
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns a boolean flag that indicates whether
'\\                 or not the comment code line was found in the
'\\                 import file.
'\\                 TRUE  - Comment Code Line found.
'\\                 FALSE - No Comment Code Line was present.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CodeLineAdded() As Boolean
    
    CodeLineAdded = mbCodeLineAdded
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Ignore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns a boolean flag that indicates whether
'\\                 or not this comment should be ignored during
'\\                 processing.
'\\                 TRUE  - Ignore this comment.
'\\                 FALSE - This comment should be processed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Ignore() As Boolean
    
    Dim bIgnore As Boolean
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    
    'Optimistic initialization
    bIgnore = False
    
    'Check for ignore conditions
    '** Removed 08-05-02 JJF
    'If UnusedReturnID > urcNone And UnusedReturnID <> urcKeepMultiReturns Then
    '    'This questionaire was kicked out in the CreateDefinitionFile stage
    '    bIgnore = True
    'Else
    '** End of remove 08-05-02 JJF
        'Check to see if this comment is already in the Comments table
        sSql = "SELECT Count(*) AS QtyRec " & _
               "FROM Comments " & _
               "WHERE QuestionForm_id = " & QuestionFormID & " " & _
               "  AND QstnCore = " & QstnCore & " " & _
               "  AND strCmntOrHand = '" & CommentOrHandWritten & "'"
        Set oTempRs = goConn.Execute(sSql)
        
        'Check the result
        If oTempRs!QtyRec > 0 Then bIgnore = True
        
        'Cleanup
        oTempRs.Close: Set oTempRs = Nothing
    'End If     '** Removed 08-05-02 JJF
    
    'Set return value
    Ignore = bIgnore
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SentMailID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the SentMail_id for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let SentMailID(ByVal lData As Long)
    
    mlSentMailID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QuestionFormID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the QuestionForm_id for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let QuestionFormID(ByVal lData As Long)
    
    mlQuestionFormID = lData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SentMailID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the SentMail_id for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get SentMailID() As Long
    
    SentMailID = mlSentMailID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QuestionFormID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the QuestionForm_id for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get QuestionFormID() As Long
    
    QuestionFormID = mlQuestionFormID
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  LithoCode
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the LITHO CODE for this comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get LithoCode() As String
    
    LithoCode = msLithoCode
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Barcode
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the barcode used to identify this
'\\                 comment.  The LITHO CODE is also generated
'\\                 at this time by UnCrunching the barcode.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Property Let Barcode(ByVal sData As String)
    
    'Save the barcode
    msBarcode = sData
    
    'Determine the lithocode
    msLithoCode = BarcodeToLitho(sBarCode:=Left(msBarcode, 6))
    
    'INC0044335 Tim Butler 04-30-2015  convert litho values to long to allow proper comparison below
    mlLithoCode = CLng(msLithoCode)
    Dim lMinLitho As Long
    Dim lMaxLitho As Long
    lMinLitho = CLng(goCALithoRange.sMinLitho)
    lMaxLitho = CLng(goCALithoRange.sMaxLitho)
    
    '** Added 05-27-05 JJF
    'Determine where this survey lives
    'INC0044335 Tim Butler 04-30-2015  changed compare to use Long instead of string
    If mlLithoCode >= lMinLitho And _
       mlLithoCode <= lMaxLitho Then
        meWhereIsIt = cccCanada
    Else
        meWhereIsIt = cccUS
    End If
    '** End of add 05-27-05 JJF
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Barcode
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets/Returns the barcode used to identify this
'\\                 comment.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Barcode() As String
    
    Barcode = msBarcode
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Initialize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 initialization of an instance of this class.  This
'\\                 is where we create the new collection object and
'\\                 set any required variables to thier default values.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Initialize()
    
    mlSentMailID = -1
    mlQuestionFormID = -1
    mlCommentType = -1
    mlCommentValence = -1
    mbTextLineAdded = False
    mbCodeLineAdded = False
    mlLineNumber = 999999
    ReDim malCommentCodes(0)
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Terminate
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 termination of an instance of this class.  This
'\\                 is where we cleanup the collection object.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Terminate()
    
    Erase malCommentCodes
    
End Sub


