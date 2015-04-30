VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CHandEntry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CHandEntry.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    This file contains the object definition used to
'\\                 contain a single hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private msBarcode           As String   'local copy
    Private msLithoCode         As String   'local copy
    Private mlSentMailID        As Long     'local copy
    Private mlQuestionFormID    As Long     'local copy
    Private mlQstnCore          As Long     'local copy
    Private mlBubbleID          As Long     'local copy
    Private mlLineID            As Long     'local copy
    Private mlSampleUnitID      As Long     'local copy
    Private msHandEntryText     As String   'local copy
    Private mlStudyID           As Long     'local copy
    Private mlPopID             As Long     'local copy
    Private mlSamplePopID       As Long     'local copy
    Private msFieldName         As String   'local copy
    
    Private msKey               As String   'local copy
    Private msErrorString       As String   'local copy
    Private mlLineNumber        As Long     'local copy
    Private msBatchNumber       As String   'local copy
    Private mlUnusedReturnID    As Long     'local copy
    Private mbQuestionNotFound  As Boolean  'local copy
    Private meWhereIsIt         As eCountryCodeConstants    '** Added 05-27-05 JJF




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
'\\ Property Name:  FieldName
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the Field Name where this hand entries
'\\                 data is to be stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let FieldName(ByVal sData As String)
    
    msFieldName = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  FieldName
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the Field Name where this hand entries
'\\                 data is to be stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get FieldName() As String
    
    FieldName = msFieldName
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  FieldList
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-25-2004
'\\
'\\ Description:    Returns comma delimited list of field names.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get FieldList() As String
    
    FieldList = msFieldName
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SetClause
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the formatted SQL SET clause used to update
'\\                 this hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get SetClause() As String
    
    SetClause = msFieldName & " = " & IIf(Len(msHandEntryText) = 0, "NULL", "'" & Replace(msHandEntryText, "'", "`") & "'")
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SamplePopID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the SamplePop_id used to identify this
'\\                 hand entry.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the SamplePop_id used to identify this
'\\                 hand entry.
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
'\\ Property Name:  PopID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the PopID used to identify this
'\\                 hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let PopID(ByVal lData As Long)
    
    mlPopID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  PopID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the PopID used to identify this
'\\                 hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get PopID() As Long
    
    PopID = mlPopID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  StudyID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the StudyID used to identify this
'\\                 hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let StudyID(ByVal lData As Long)
    
    mlStudyID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  StudyID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the StudyID used to identify this
'\\                 hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get StudyID() As Long
    
    StudyID = mlStudyID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  LineID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the line id for this hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get LineID() As Long
    
    LineID = mlLineID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  BubbleID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the bubble id for this hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get BubbleID() As Long
    
    BubbleID = mlBubbleID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  HandEntryText
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the text for this hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get HandEntryText() As String
    
    HandEntryText = msHandEntryText
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QuestionNotFound
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns a flag indicating whether or not we
'\\                 were able to find this hand entry in HandWrittenPos.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns a flag indicating whether or not we
'\\                 were able to find this hand entry in HandWrittenPos.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the UnusedReturnID for the questionaire
'\\                 that this hand entry is located on.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the UnusedReturnID for the questionaire
'\\                 that this hand entry is located on.
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
'\\ Property Name:  ResponseString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets the HandEntryText for this hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ResponseString(ByVal sData As String)
    
    Dim sInfo       As String
    Dim sRemaining  As String
    Dim lLoc1       As Long
    Dim lLoc2       As Long
    Dim lCnt        As Long
    Dim oToken      As CToken
    
    'Parse the response string into is component parts
    lLoc1 = InStr(sData, ":")
    sInfo = Left(sData, lLoc1 - 1)
    msHandEntryText = Trim(Mid(sData, lLoc1 + 1))
    
    'Get the barcode
    Barcode = Left(sInfo, 8)
    
    'Get the QstnCore
    lLoc1 = InStr(sInfo, ",")
    mlQstnCore = Val(Trim(Mid(sInfo, 12, lLoc1 - 12)))
    
    'Get the BubbleID
    lLoc1 = lLoc1 + 1
    lLoc2 = InStr(lLoc1, sInfo, ",")
    mlBubbleID = Val(Trim(Mid(sInfo, lLoc1, lLoc2 - lLoc1)))
    
    'Get the LineID
    lLoc1 = lLoc2 + 1
    lLoc2 = InStr(lLoc1, sInfo, ",")
    mlLineID = Val(Trim(Mid(sInfo, lLoc1, lLoc2 - lLoc1)))
    
    'Get the SampleUnitID
    mlSampleUnitID = Val(Trim(Mid(sInfo, lLoc2 + 1)))
    
    'Set the Key Value
    msKey = "LC" & msLithoCode & "-QC" & mlQstnCore & "-BU" & mlBubbleID & "-LI" & mlLineID & "-SU" & mlSampleUnitID
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QstnCore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the QstnCore for this hand entry.
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
'\\ Property Name:  BatchNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the batch number for this hand entry.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the batch number for this hand entry.
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
'\\ Property Name:  LineNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the line number that this hand entry
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the line number that this hand entry
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
'\\ Property Name:  ErrorString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns any error conditions encountered while
'\\                 processing this hand entry.  Later used to create
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
'\\ Property Name:  ErrorString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns any error conditions encountered while
'\\                 processing this hand entry.  Later used to create
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
'\\ Routine Name:   IsBarcodeValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the KEY for this hand entry used to
'\\                 keep the collection unique.
'\\                 It is "LC" & msLithoCode & "-QC" & mlQstnCore & "-BU" & mlBubbleID & "-LI" & mlLineID & "-SU" & mlSampleUnitID
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the SampleUnit_id for this hand entry.
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
'\\ Property Name:  Ignore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns a boolean flag that indicates whether
'\\                 or not this hand entry should be ignored during
'\\                 processing.
'\\                 TRUE  - Ignore this hand entry.
'\\                 FALSE - This hand entry should be processed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Ignore() As Boolean
    
    Dim bIgnore As Boolean
    
    'Optimistic initialization
    bIgnore = False
    
    'Check for ignore conditions
    If UnusedReturnID > urcNone And UnusedReturnID <> urcKeepMultiReturns Then
        'This questionaire was kicked out in the CreateDefinitionFile stage
        bIgnore = True
    End If
    
    'Set return value
    Ignore = bIgnore
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SentMailID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the SentMail_id for this hand entry.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the SentMail_id for this hand entry.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the QuestionForm_id for this hand entry.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the QuestionForm_id for this hand entry.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the LITHO CODE for this hand entry.
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the barcode used to identify this
'\\                 hand entry.  The LITHO CODE is also generated
'\\                 at this time by UnCrunching the barcode.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Barcode(ByVal sData As String)
    
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
'\\         Date:   02-20-2004
'\\
'\\ Description:    Sets/Returns the barcode used to identify this
'\\                 hand entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Barcode() As String
    
    Barcode = msBarcode
    
End Property



