VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CQuestions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"CQuestion"
Attribute VB_Ext_KEY = "Member0" ,"CQuestion"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CQuestionaires.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the object definition that is used
'\\                 to collect and process the questions from a given
'\\                 questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private msResponseString As String
    
    'local variable to hold collection
    Private moQuestions As Collection
    
    
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetSingleValue
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine evaluates the response to a single
'\\                 question and returns the adjusted value.
'\\
'\\ Parameters:
'\\     Name        Type    Description
'\\     lStartLoc   Long    The starting position for the requested
'\\                         question's response within the response
'\\                         line for this questionaire.
'\\     lLength     Long    The number of characters to be evaluated.
'\\
'\\ Return Value:
'\\     Type    Description
'\\     Long    The value of this question's response.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function GetSingleValue(ByVal lStartLoc As Long, _
                                ByVal lLength As Long) As Long
    
    Dim sTemp  As String
    Dim lValue As Long
    
    sTemp = Trim(Mid(msResponseString, lStartLoc, lLength))
    Select Case sTemp
        Case ""
            lValue = -9
        Case "*"
            lValue = -8
        Case "0-1", "00-1"
            lValue = -1
        Case Else
            lValue = Val(sTemp)
    End Select
    
    GetSingleValue = lValue
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ResponseString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the complete line for this questionaire
'\\                 from the import file.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ResponseString(ByVal sData As String)
    
    msResponseString = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ResponseString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the complete line for this questionaire
'\\                 from the import file.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ResponseString() As String
    
    ResponseString = msResponseString
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Clear
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine clears out all members of the collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Clear()
    
    Dim lCnt As Long
    
    For lCnt = 1 To Count
        Remove 1
    Next lCnt
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Add
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is used to add new questions to the
'\\                 collection.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     lQuestionFormID Long    Specifies the QuestionForm_id of the
'\\                             questionaire being operated on.
'\\     lSampleUnitID   Long    Specifies the SampleUnit_id of the
'\\                             question being added.
'\\     lPageNo         Long    Specifies the page number of the
'\\                             questionaire that this question was
'\\                             located on.
'\\     lQstnCore       Long    Specifies the QstnCore of the
'\\                             question being added.
'\\     lBeginCol       Long    Specifies the beginning column in the
'\\                             ResponseString for the answer to this
'\\                             question.
'\\     lResponseCol    Long    Specifies how many characters are used
'\\                             in the ResponseString for the answer to
'\\                             this question.
'\\     bMultiResponse  Boolean A boolean flag that indicated whether
'\\                             or not this question allows for multiple
'\\                             responses.
'\\     eTransferType   eTransferTypeConstants
'\\                             Specified the type of transfer to be
'\\                             performed.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     CQuestion   A reference to the newly added question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-13-01    JJF     Added the eTransferType parameter.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'** Modified 08-13-01 JJF
'Public Function Add(ByVal lQuestionFormID As Long, ByVal lSampleUnitID As Long, ByVal lPageNo As Long, ByVal lQstnCore As Long, ByVal lBeginCol As Long, ByVal lResponseCol As Long, ByVal bMultiResponse As Boolean) As CQuestion
Public Function Add(ByVal lQuestionFormID As Long, _
                    ByVal lSampleUnitID As Long, _
                    ByVal lPageNo As Long, _
                    ByVal lQstnCore As Long, _
                    ByVal lBeginCol As Long, _
                    ByVal lResponseCol As Long, _
                    ByVal bMultiResponse As Boolean, _
                    ByVal eTransferType As eTransferTypeConstants) As CQuestion
'** End of modification 08-13-01 JJF

    Dim oQuestion As CQuestion
    
    'Create a new object
    Set oQuestion = New CQuestion
    
    'Set the properties passed into the method
    With oQuestion
        .SampleUnitID = lSampleUnitID
        .QstnCore = lQstnCore
        .MultiResponse = bMultiResponse
        
        If Not bMultiResponse Then
            .Values(1) = GetSingleValue(lStartLoc:=lBeginCol, _
                                        lLength:=lResponseCol)
        Else
            '** Modified 08-13-01 JJF
            'SetMultiValues lQuestionFormID:=lQuestionFormID, lPageNo:=lPageNo, oQuestion:=oQuestion, lStartLoc:=lBeginCol, lLength:=lResponseCol
            SetMultiValues lQuestionFormID:=lQuestionFormID, _
                           lPageNo:=lPageNo, _
                           oQuestion:=oQuestion, _
                           lStartLoc:=lBeginCol, _
                           lLength:=lResponseCol, _
                           eTransferType:=eTransferType
            '** End of modification 08-13-01 JJF
        End If
    End With
    
    'Add the object to the collection
    moQuestions.Add oQuestion
    
    'return the object created
    Set Add = oQuestion
    Set oQuestion = Nothing
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Item
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns a reference to the requested question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Item(ByVal vIndexKey As Variant) As CQuestion
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = moQuestions(vIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Count
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns the total quantity of questions in this
'\\                 collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Count() As Long
    
    Count = moQuestions.Count
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Remove
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Removes the specified question from the collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     vIndexKey   Variant     Either the KEY or INDEX of the question
'\\                             to be removed from the collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Remove(ByVal vIndexKey As Variant)
    
    moQuestions.Remove vIndexKey
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  NewEnum
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns the IUnknown interface of the collection
'\\                 to allow for using the FOR EACH construct.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = moQuestions.[_NewEnum]
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   SetMultiValues
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine evaluates the responses to a multi-
'\\                 response question and adds them to the collection.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     lQuestionFormID Long        This is this questionaires
'\\                                 QuestionForm_id from the database.
'\\     lPageNo         Long        This is the page number of the
'\\                                 questionaire that this question is
'\\                                 located on.
'\\     oQuestion       CQuestion   This is the CQuestion object that
'\\                                 is to be worked with.
'\\     lStartLoc       Long        The starting position for the
'\\                                 requested question's response within
'\\                                 the response line for this
'\\                                 questionaire.
'\\     lLength         Long        The number of characters to be
'\\                                 evaluated.
'\\     eTransferType   eTransferTypeConstants
'\\                                 Specified the type of transfer to be
'\\                                 performed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-13-01    JJF     Added the eTransferType parameter and code
'\\                         to deal with non-QualPro Multi-Response
'\\                         questions.
'\\     03-07-02    JJF     Modified to get bubble info from QP_Scan.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'** Modified 08-13-01 JJF
'Private Sub SetMultiValues(ByVal lQuestionFormID As Long, ByVal lPageNo As Long, oQuestion As CQuestion, ByVal lStartLoc As Long, ByVal lLength As Long)
Private Sub SetMultiValues(ByVal lQuestionFormID As Long, _
                           ByVal lPageNo As Long, _
                           oQuestion As CQuestion, _
                           ByVal lStartLoc As Long, _
                           ByVal lLength As Long, _
                           ByVal eTransferType As eTransferTypeConstants)
'** End of modification 08-13-01 JJF

    Dim sSql                As String
    Dim sTemp               As String
    Dim sChar               As String   '** Added 08-13-01 JJF
    Dim lCnt                As Long
    Dim lIndex              As Long
    Dim alPossibleVals()    As Long
    Dim oTempRs             As ADODB.Recordset
    
    Const ksAvailableCharacters As String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Get the possible values for this question
    sSql = "SELECT Item, Val " & _
           "FROM BubbleItemPos " & _
           "WHERE QuestionForm_Id = " & lQuestionFormID & " " & _
           "AND SampleUnit_id = " & oQuestion.SampleUnitID & " " & _
           "AND intPage_num = " & lPageNo & " " & _
           "AND QstnCore = " & oQuestion.QstnCore & " " & _
           "ORDER BY Item"
    '** Modified 03-07-02 JJF
    'Set oTempRs = goConn.Execute(sSql)
    Set oTempRs = goScanConn.Execute(sSql)
    '** End of modification 03-07-02 JJF
    
    'Store the values in the temp array
    '  The index of a value in this array will be equivilent to
    '  it's 'Item' field in the DB as the 'Item' always starts
    '  at one and increments upward
    ReDim alPossibleVals(0) As Long
    With oTempRs
        Do Until .EOF
            '** Modified 05-22-00 JJF
            'lCnt = lCnt + 1
            lCnt = !Item
            '** End of modification 05-22-00 JJF
            ReDim Preserve alPossibleVals(lCnt) As Long
            alPossibleVals(lCnt) = !Val
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
    'Add the appropriate values to the question
    '** Modified 08-13-01 JJF
    ''Get the list of responses
    'sTemp = Trim(Mid(msResponseString, lStartLoc, lLength))
    '
    ''Loop through the list and convert it to the 'Val'
    'For lCnt = 1 To Len(sTemp)
    '    'Get the index ('Item')
    '    lIndex = InStr(ksAvailableCharacters, Mid(sTemp, lCnt, 1))
    '
    '    'Add the value for this response
    '    oQuestion.Values(lCnt) = alPossibleVals(lIndex)
    'Next lCnt
    If eTransferType = ttcNonQualPro Then
        'This is a non-QualPro question
        'Get the list of responses
        sTemp = Mid(msResponseString, lStartLoc, lLength)
        
        'Loop through the list and convert it to the 'Val'
        lCnt = 0
        For lIndex = 1 To Len(sTemp)
            'Get the current character from the string of responses
            sChar = Trim(Mid(sTemp, lIndex, 1))
            
            If sChar = "1" Then
                'If the character is '1' then store the response val
                lCnt = lCnt + 1
                oQuestion.Values(lCnt) = alPossibleVals(lIndex)
            End If
        Next lIndex
    Else
        'This is not a non-QualPro question
        'Get the list of responses
        sTemp = Trim(Mid(msResponseString, lStartLoc, lLength))
        
        'Loop through the list and convert it to the 'Val'
        For lCnt = 1 To Len(sTemp)
            'Get the index ('Item')
            lIndex = InStr(ksAvailableCharacters, Mid(sTemp, lCnt, 1))
            
            If lIndex > 0 Then      '** Added 03-07-02 JJF
                'Add the value for this response
                oQuestion.Values(lCnt) = alPossibleVals(lIndex)
            End If                  '** Added 03-07-02 JJF
        Next lCnt
    End If
    '** End of modification 08-13-01 JJF
    
    'Cleanup
    Erase alPossibleVals
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorSetMultipleValuesFailed, _
              Source:="CQuestions::SetMultipleValues", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Initialize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 initialization of an instance of this class.  This
'\\                 is where we create the new collection object.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set moQuestions = New Collection
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Terminate
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
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
    
    'destroys collection when this class is terminated
    Set moQuestions = Nothing
    
End Sub

