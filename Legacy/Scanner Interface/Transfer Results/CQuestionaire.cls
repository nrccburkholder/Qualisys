VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CQuestionaire"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CQuestionaire.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the object definition used to
'\\                 contain a single questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Removed the Complete property
'\\     08-29-00    JJF     Added ability to deal with hand entered
'\\                         results.
'\\     12-20-00    JJF     Added KeepMultiReturns property.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private msBarcode           As String
    Private msLithoCode         As String
    Private mlSentMailID        As Long
    Private mlQuestionFormID    As Long
    Private mlSamplePopID       As Long
    Private mlSurveyID          As Long
    Private msBatchNumber       As String
    Private mlLineNumber        As Long
    Private mbIgnore            As Boolean
    'Private mbComplete          As Boolean     '** Removed 06-19-00 JJF
    Private msErrorString       As String
    Private msKey               As String
    Private moQuestions         As CQuestions
    Private mdtDateReturned     As Date         '** Added 08-29-00 JJF
    Private mbKeepMultiReturns  As Boolean      '** Added 12-20-00 JJF
    Private meWhereIsIt         As eCountryCodeConstants    '** Added 05-27-05 JJF



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  KeepMultiReturns
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   12-20-2000
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not this Survey allows for keeping multiple returns.
'\\                 TRUE  - The results are kept for all returns.
'\\                 FALSE - The results are kept for only the first
'\\                         return received.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get KeepMultiReturns() As Boolean
    
    KeepMultiReturns = mbKeepMultiReturns
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  KeepMultiReturns
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   12-20-2000
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not this Survey allows for keeping multiple returns.
'\\                 TRUE  - The results are kept for all returns.
'\\                 FALSE - The results are kept for only the first
'\\                         return received.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let KeepMultiReturns(ByVal bData As Boolean)
    
    mbKeepMultiReturns = bData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  OtherStepImported
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   12-20-2000
'\\
'\\ Description:    Returns a boolean flag indicating whether or not
'\\                 and earlier step for this questionaire has already
'\\                 been returned, scanned and imported.
'\\                 TRUE  - An earlier step has already been processed.
'\\                 FALSE - The questionaire is OK for processing.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get OtherStepImported() As Boolean
    
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    
    'Determine if a previous mailing step has been imported
    sSql = "SELECT Count(QF2.datReturned) AS QtyRec " & _
           "FROM QuestionForm QF, QuestionForm QF2 " & _
           "WHERE QF.QuestionForm_id = " & QuestionFormID & " " & _
           "AND QF2.QuestionForm_id <> QF.QuestionForm_id " & _
           "AND QF2.SamplePop_id = QF.SamplePop_id " & _
           "AND QF2.datResultsImported IS NOT NULL"
    Set oTempRs = goConn.Execute(sSql)
    
    If oTempRs!QtyRec > 0 Then
        OtherStepImported = True
    Else
        OtherStepImported = False
    End If
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DateReturned
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-29-2000
'\\
'\\ Description:    Sets/Returns the return date for this questionnaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let DateReturned(ByVal dtData As Date)
    
    mdtDateReturned = dtData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DateReturned
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-29-2000
'\\
'\\ Description:    Sets/Returns the return date for this questionnaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get DateReturned() As Date
    
    DateReturned = mdtDateReturned
    
End Property




'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ErrorString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns any error conditions encountered while
'\\                 processing this questionaire.  Later used to create
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
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns any error conditions encountered while
'\\                 processing this questionaire.  Later used to create
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
'\\ Routine Name:   GetQuestions
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine loads all of the question responses
'\\                 for this questionaire object.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     eTransferType   eTransferTypeConstants
'\\                                 Specified the type of transfer to be
'\\                                 performed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-10-00    JJF     Added the multiple response level command
'\\                         line parameter.
'\\     08-13-01    JJF     Added the eTransferType parameter.
'\\     03-07-02    JJF     Changed to use the bubble info from QP_Scan.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'** Modified 08-13-01 JJF
'Public Sub GetQuestions()
Public Sub GetQuestions(ByVal eTransferType As eTransferTypeConstants)
'** End of modification 08-13-01 JJF

    Dim sSql        As String
    Dim oTempRs     As ADODB.Recordset
    Dim bMultiResp  As Boolean  '** Added 03-07-02 JJF
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Get the list of questions
    '** Modified 03-07-02 JJF
    'sSql = "SELECT bp.SampleUnit_id, bp.intPage_Num, bp.QstnCore, " & _
    '               "bp.intBegColumn, bp.intRespCol, rm.bitMultiResp " & _
    '       "FROM BubblePos bp, ReadMethod rm " & _
    '       "WHERE bp.QuestionForm_Id = " & mlQuestionFormID & " " & _
    '       "AND bp.ReadMethod_id = rm.ReadMethod_id " & _
    '       "ORDER BY bp.intBegColumn"
    'Set oTempRs = goConn.Execute(sSql)
    sSql = "SELECT SampleUnit_id, intPage_Num, QstnCore, " & _
           "       intBegColumn, intRespCol, ReadMethod_id " & _
           "FROM BubblePos " & _
           "WHERE QuestionForm_Id = " & mlQuestionFormID & " " & _
           "ORDER BY intBegColumn"
    Set oTempRs = goScanConn.Execute(sSql)
    '** End of modification 03-07-02 JJF
    
    With oTempRs
        Do Until .EOF
            '** Added 03-07-02 JJF
            'Get the Muliple Responce Flag
            bMultiResp = goReadMethods("K" & !ReadMethod_id).MultiResponce
            '** End of add 03-07-02 JJF
            
            '** Modified 03-07-02 JJF
            ''** Added 05-10-00 JJF
            'If geMultipleResponseLevel = mrcProcessAllQuestions Or _
            '   (geMultipleResponseLevel = mrcProcessMultiRespOnly And !bitMultiResp) Or _
            '   (geMultipleResponseLevel = mrcProcessSingleRespOnly And Not !bitMultiResp) Then
            ''** End of add 05-10-00 JJF
            If geMultipleResponseLevel = mrcProcessAllQuestions Or _
               (geMultipleResponseLevel = mrcProcessMultiRespOnly And bMultiResp) Or _
               (geMultipleResponseLevel = mrcProcessSingleRespOnly And Not bMultiResp) Then
            '** End of modification 03-07-02 JJF
                'Add this question
                '** Modified 03-07-02 JJF
                ''** Modified 08-13-01 JJF
                ''moQuestions.Add lQuestionFormID:=mlQuestionFormID, lSampleUnitID:=!SampleUnit_id, lPageNo:=!intPage_Num, lQstnCore:=!QstnCore, lBeginCol:=!intBegColumn, lResponseCol:=!intRespCol, bMultiResponse:=!bitMultiResp
                'moQuestions.Add lQuestionFormID:=mlQuestionFormID, _
                '                lSampleUnitID:=!SampleUnit_id, _
                '                lPageNo:=!intPage_Num, _
                '                lQstnCore:=!QstnCore, _
                '                lBeginCol:=!intBegColumn, _
                '                lResponseCol:=!intRespCol, _
                '                bMultiResponse:=!bitMultiResp, _
                '                eTransferType:=eTransferType
                ''** End of modification 08-13-01 JJF
                moQuestions.Add lQuestionFormID:=mlQuestionFormID, _
                                lSampleUnitID:=!SampleUnit_id, _
                                lPageNo:=!intPage_Num, _
                                lQstnCore:=!QstnCore, _
                                lBeginCol:=!intBegColumn, _
                                lResponseCol:=!intRespCol, _
                                bMultiResponse:=bMultiResp, _
                                eTransferType:=eTransferType
                '** End of modification 03-07-02 JJF
            End If  '** Added 05-10-00 JJF
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With 'oTempRs
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorGetQuestionsFailed, _
              Source:="CQuestionaire::GetQuestions", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Complete
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not this questionaire has been completely processed.
'\\                 TRUE  - Processing of this questionaire is complete.
'\\                 FALSE - An error was encountered and further action
'\\                         is required.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Removed as it is no longer needed.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'** Removed 06-19-00 JJF
'Public Property Let Complete(ByVal bData As Boolean)
'
'    mbComplete = bData
'
'End Property
'** End of remove 06-19-00 JJF


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Complete
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not this questionaire has been completely processed.
'\\                 TRUE  - Processing of this questionaire is complete.
'\\                 FALSE - An error was encountered and further action
'\\                         is required.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Removed as it is no longer needed
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'** Removed 06-19-00 JJF
'Public Property Get Complete() As Boolean
'
'    Complete = mbComplete
'
'End Property
'** End of remove 06-19-00 JJF


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsBarcodeValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
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
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the KEY for this questionaire used to
'\\                 keep the collection unique.  It is "LC" & msLithoCode
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Key(ByVal sData As String)
    
    msKey = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Key
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the KEY for this questionaire used to
'\\                 keep the collection unique.  It is "LC" & msLithoCode
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
'\\ Property Name:  SurveyID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the Survey_id for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let SurveyID(ByVal lData As Long)
    
    mlSurveyID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SurveyID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the Survey_id for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get SurveyID() As Long
    
    SurveyID = mlSurveyID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SamplePopID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the SamplePop_id for this questionaire.
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
'\\ Property Name:  SamplePopID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the SamplePop_id for this questionaire.
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
'\\ Property Name:  SentMailID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the SentMail_id for this questionaire.
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
'\\ Property Name:  SentMailID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the SentMail_id for this questionaire.
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
'\\ Property Name:  LineNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the line number that this questionaire
'\\                 occupied in the scan file.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let LineNumber(ByVal lData As Long)
    
    mlLineNumber = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  LineNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the line number that this questionaire
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
'\\ Property Name:  BatchNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the batch number for this questionaire.
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
'\\ Property Name:  BatchNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the batch number for this questionaire.
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
'\\ Property Name:  Ignore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a boolean flag that indicates whether
'\\                 or not this questionaire should be ignored during
'\\                 processing.
'\\                 TRUE  - Ignore this questionaire.
'\\                 FALSE - This questionaire should be processed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Ignore(ByVal bData As Boolean)
    
    mbIgnore = bData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Ignore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a boolean flag that indicates whether
'\\                 or not this questionaire should be ignored during
'\\                 processing.
'\\                 TRUE  - Ignore this questionaire.
'\\                 FALSE - This questionaire should be processed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Ignore() As Boolean
    
    Ignore = mbIgnore
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Questions
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns a reference to the CQuestions collection
'\\                 object for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Questions() As CQuestions
    
    Set Questions = moQuestions
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QuestionFormID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the QuestionForm_id for this questionaire.
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
'\\ Property Name:  QuestionFormID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the QuestionForm_id for this questionaire.
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
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns the LITHO CODE for this questionaire.
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
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the barcode used to identify this
'\\                 questionaire.  The LITHO CODE is also generated
'\\                 at this time by UnCrunching the barcode.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-12-01    JJF     Updated to use new Litho Processing code.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Barcode(ByVal sData As String)
    
    'Save the barcode
    msBarcode = sData
    
    'Determine the lithocode
    '** Modified 06-12-01 JJF
    'msLithoCode = UnCrunch(sBarCode:=Left(msBarcode, 6))
    msLithoCode = BarcodeToLitho(sBarCode:=Left(msBarcode, 6))
    '** End of modifications 06-12-01 JJF
    
    '** Added 05-27-05 JJF
    'Determine where this survey lives
    If msLithoCode >= goCALithoRange.sMinLitho And _
       msLithoCode <= goCALithoRange.sMaxLitho Then
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
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the barcode used to identify this
'\\                 questionaire.
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
'\\ Routine Name:   Class_Initialize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
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
    mbIgnore = False
    Set moQuestions = New CQuestions
    
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
    
    Set moQuestions = Nothing
    
End Sub


