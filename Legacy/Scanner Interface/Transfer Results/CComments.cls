VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CComments"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"CQuestionaire"
Attribute VB_Ext_KEY = "Member0" ,"CQuestionaire"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CComments.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This file contains the object definition that is
'\\                 used to collect and process scanned comments and
'\\                 hand entries.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-04    JJF     Added ability to deal with Hand Entries
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
        
    'local variable(s) to hold property value(s)
    Private msProcessedFilePath     As String
    Private msProcessedHoldFilePath As String   '** Added 02-20-03 JJF
    Private msUnProcessedFilePath   As String
    Private msCAUnProcessedFilePath As String   '** Added 05-27-05 JJF
    Private msIncompleteFilePath    As String
    Private msLogFilePath           As String
    Private msFileName              As String
    
    'local variable(s) to hold internal counter(s)
    '** Modified 02-20-04 JJF
    'Private mnImported              As Integer
    'Private mnIgnored               As Integer
    'Private mnErrors                As Integer
    Private mnImportedComment       As Integer
    Private mnIgnoredComment        As Integer
    Private mnErrorsComment         As Integer
    '** End of modification 02-20-04
    
    Private mnImportedHandEntry     As Integer  '** Added 02-20-04 JJF
    Private mnIgnoredHandEntry      As Integer  '** Added 02-20-04 JJF
    Private mnErrorsHandEntry       As Integer  '** Added 02-20-04 JJF
    
    'local variable to hold collection
    Private moComments      As Collection

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CountByType
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the total quantity of Comments in this
'\\                 collection of the specified type.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-04    JJF     Added ability to deal with hand entries.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function GetCountByType(ByVal lCommentType As Long) As Long
    
    Dim lCount      As Long
    '** Modified 02-20-04 JJF
    'Dim oComment    As CComment
    Dim oItem       As Object
    '** End of modification 02-20-04 JJF
    
    'Get the quantity of the type specified
    lCount = 0
    '** Modified 02-20-04 JJF
    'For Each oComment In moComments
    '    If oComment.CommentType = lCommentType Then
    '        lCount = lCount + 1
    '    End If
    'Next oComment
    For Each oItem In moComments
        If TypeOf oItem Is CComment Then
            If oItem.CommentType = lCommentType Then
                lCount = lCount + 1
            End If
        End If
    Next oItem
    '** End of modification 02-20-04 JJF
    
    'Cleanup
    '** Modified 02-20-04 JJF
    'Set oComment = Nothing
    Set oItem = Nothing
    '** End of modification 02-20-04 JJF
    GetCountByType = lCount
    
End Function

Public Property Get IsCanadian() As Boolean
    
    Dim oTemp As Object
    
    IsCanadian = False
    
    For Each oTemp In moComments
        If oTemp.WhereIsIt = cccCanada Then
            IsCanadian = True
            Exit For
        End If
    Next oTemp
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  LogFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets the path to where the incomplete barcode files
'\\                 are stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let LogFilePath(ByVal sData As String)
    
    msLogFilePath = sData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  FileName
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the filename of the Batch being processed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get FileName() As String
    
    FileName = msFileName
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetAdditionalInfo
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine collects the base information for the
'\\                 Comments and Hand Entries being processed.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     03-07-02    JJF     Modified so that the bubble and comment pos
'\\                         data is retrieved from QP_Scan.
'\\     02-20-04    JJF     Re-Written to allow for Hand Entries.
'\\     08-13-04    JJF     Comment portion re-written to use a stored
'\\                         procedure for Qualisys Data Entry app.
'\\     05-27-05    JJF   * Modified to work with Canadian generated
'\\                         surveys.
'\\                       * Removed old code for clarity.
'\\     10-31-05    JJF     Added SamplePopID property
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub GetAdditionalInfo()
    
    Dim sSql            As String
    Dim lCurRec         As Long
    Dim oTempRs         As ADODB.Recordset
    Dim oHandEntryCm    As ADODB.Command
    Dim oCommentCm      As ADODB.Command    '** Added 08-13-04 JJF
    Dim oItem           As Object
    Dim oComment        As CComment
    Dim oHandEntry      As CHandEntry
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Getting Additional Info for " & FileName & "..."
    End With
    
    'Setup the comment info command
    Set oCommentCm = New ADODB.Command
    With oCommentCm
        .CommandText = "sp_SI_CommentInfo"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("LithoCode", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("QstnCore", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("CmntOrHand", adVarChar, adParamInput, 1)
    End With 'oCommentCm
    
    'Setup the hand entry info command
    Set oHandEntryCm = New ADODB.Command
    With oHandEntryCm
        .CommandText = "sp_SI_HandwrittenEntryInfo"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = goScanConn
        .Parameters.Append .CreateParameter("LithoCode", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("QstnCore", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("BubbleID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("LineID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("SampleUnitID", adInteger, adParamInput)
    End With 'oHandEntryCm
    
    'Loop through all items in the collection
    lCurRec = 0
    For Each oItem In moComments
        'Update the status bar
        lCurRec = lCurRec + 1
        goProgressBar.Progress = (lCurRec / Count) * 100
                
        'Determine if we are dealing with a comment or a hand entry
        If TypeOf oItem Is CComment Then
            'We are dealing with a comment
            Set oComment = oItem
            With oComment
            'With oItem
                'Check to see if this comment was actually filled out
                If Len(.CommentText) > 0 And .CodeLineAdded And .TextLineAdded Then
                    'Set the procedure parameters
                    oCommentCm.Parameters("LithoCode") = .LithoCode
                    oCommentCm.Parameters("QstnCore") = .QstnCore
                    oCommentCm.Parameters("CmntOrHand") = .CommentOrHandWritten
                    
                    'Open the record set
                    Set oTempRs = oCommentCm.Execute
                    
                    'Check to see if we found it
                    If Not oTempRs.EOF Then
                        'We found it so all is good
                        .SentMailID = oTempRs!SentMail_id
                        .QuestionFormID = oTempRs!QuestionForm_id
                        .UnusedReturnID = oTempRs!UnusedReturn_id
                        .SampleUnitID = oTempRs!SampleUnit_id
                        .SamplePopID = oTempRs!SamplePop_id
                        .QuestionNotFound = (Not oTempRs!Found)
                        .WhereIsIt = IIf(IsNull(oTempRs!Country_id), cccUnknown, oTempRs!Country_id)    '** Added 05-27-05 JJF
                    Else
                        .SentMailID = -1
                        .QuestionFormID = -1
                        .UnusedReturnID = urcNone
                        .SampleUnitID = -1
                        .SamplePopID = -1
                        .QuestionNotFound = True
                        .WhereIsIt = cccUnknown                  '** Added 05-27-05 JJF
                    End If
                    
                    'Cleanup
                    oTempRs.Close: Set oTempRs = Nothing
                End If
            End With
        Else
            'We are dealing with a hand entry
            Set oHandEntry = oItem
            With oHandEntry
            'With oItem
                'Check to see if this hand entry was actually filled out
                If Len(.HandEntryText) > 0 Then
                    'Set the procedure parameters
                    oHandEntryCm.Parameters("LithoCode") = .LithoCode
                    oHandEntryCm.Parameters("QstnCore") = .QstnCore
                    oHandEntryCm.Parameters("BubbleID") = .BubbleID
                    oHandEntryCm.Parameters("LineID") = .LineID
                    oHandEntryCm.Parameters("SampleUnitID") = .SampleUnitID
                    
                    'Open the record set
                    Set oTempRs = oHandEntryCm.Execute
                    
                    'Check to see if we found it
                    If Not oTempRs.EOF Then
                        'We found it so all is good
                        .SentMailID = IIf(IsNull(oTempRs!SentMail_id), -1, oTempRs!SentMail_id)
                        .QuestionFormID = IIf(IsNull(oTempRs!QuestionForm_id), -1, oTempRs!QuestionForm_id)
                        .UnusedReturnID = IIf(IsNull(oTempRs!UnusedReturn_id), urcNone, oTempRs!UnusedReturn_id)
                        .StudyID = IIf(IsNull(oTempRs!Study_id), -1, oTempRs!Study_id)
                        .PopID = IIf(IsNull(oTempRs!Pop_id), -1, oTempRs!Pop_id)
                        .SamplePopID = IIf(IsNull(oTempRs!SamplePop_id), -1, oTempRs!SamplePop_id)
                        .FieldName = IIf(IsNull(oTempRs!strField_Nm), -1, oTempRs!strField_Nm)
                        .QuestionNotFound = False
                        .WhereIsIt = IIf(IsNull(oTempRs!Country_id), cccUnknown, oTempRs!Country_id) '** Added 05-27-05 JJF
                        
                    Else
                        'Specified record not found so look for SentMail and QuestionForm IDs
                        oTempRs.Close: Set oTempRs = Nothing
                        
                        'Get the data
                        '** Modified 05-27-05 JJF
                        'sSql = "SELECT SM.SentMail_id, QF.QuestionForm_id, QF.UnusedReturn_id " & _
                        '       "FROM SentMailing SM LEFT JOIN QuestionForm QF " & _
                        '       "                           ON SM.SentMail_id = QF.SentMail_id " & _
                        '       "WHERE SM.strLithoCode = '" & .LithoCode & "'"
                        sSql = "SELECT SM.SentMail_id, QF.QuestionForm_id, QF.UnusedReturn_id, SM.Country_id " & _
                               "FROM SentMailing SM LEFT JOIN QuestionForm QF " & _
                               "                           ON SM.SentMail_id = QF.SentMail_id " & _
                               "WHERE SM.strLithoCode = '" & .LithoCode & "'"
                        '** End of modification 05-27-05 JJF
                        Set oTempRs = goConn.Execute(sSql)
                        
                        'Update the required properties
                        If Not oTempRs.EOF Then
                            .SentMailID = IIf(IsNull(oTempRs!SentMail_id), -1, oTempRs!SentMail_id)
                            .QuestionFormID = IIf(IsNull(oTempRs!QuestionForm_id), -1, oTempRs!QuestionForm_id)
                            .UnusedReturnID = IIf(IsNull(oTempRs!UnusedReturn_id), urcNone, oTempRs!UnusedReturn_id)
                            .WhereIsIt = IIf(IsNull(oTempRs!Country_id), cccUnknown, oTempRs!Country_id) '** Added 05-27-05 JJF
                        Else
                            .SentMailID = -1
                            .QuestionFormID = -1
                            .UnusedReturnID = urcNone
                            .WhereIsIt = cccUnknown
                        End If
                        .StudyID = -1
                        .PopID = -1
                        .SamplePopID = -1
                        .FieldName = ""
                        .QuestionNotFound = True
                        
                    End If
                    
                    'Cleanup
                    oTempRs.Close: Set oTempRs = Nothing
                End If
            End With
        End If
        
        'Allow the operating system to do any additional work
        DoEvents
    Next oItem
    
    'Cleanup
    Set oItem = Nothing
    Set oComment = Nothing
    Set oHandEntry = Nothing
    Set oHandEntryCm = Nothing
    Set oCommentCm = Nothing    '** Added 08-13-04 JJF
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorGetAddInfoFailed, _
              Source:="CComments::GetAdditionalInfo", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

    
    
    
    
    
Public Sub MoveFileFromHolding()
    
    If Dir(msProcessedHoldFilePath & msFileName) > "" Then
        FileCopy msProcessedHoldFilePath & msFileName, msProcessedFilePath & msFileName
        Kill msProcessedHoldFilePath & msFileName
    End If
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OutputLog
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine writes the results of the current
'\\                 import batch to a log file for statistical tracking.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-04    JJF     Added ability to deal with hand entries.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'Public Sub OutputLog()
Public Sub OutputLog(Optional ByVal sComment As String = "")
    
    Dim bExists     As Boolean
    Dim lFileHandle As Long
    Dim lLockHandle As Long
    Dim sFileName   As String
    Dim sTemp1      As String
    Dim sTemp2      As String
    Dim oUserInfo   As CUserInfo
    Dim oCmntType   As CCommentCode
    
    'Place a lock on the VSTR files
    lLockHandle = LockFiles(sLockFileName:=msLogFilePath & "VSTRLog.lck", _
                            bWaitForever:=True)
    
    'Get the file name
    sFileName = msLogFilePath & Format(Now, "yyyymmdd") & "VSTR.log"
    
    'Check to see if the log file exists
    If Dir$(sFileName, vbNormal) <> "" Then bExists = True
    
    'Open the file
    lFileHandle = FreeFile
    Open sFileName For Append As #lFileHandle
    
    'Initialize the user info object
    Set oUserInfo = New CUserInfo
    
    'Write the header if required
    If Not bExists Then
        'Start the header strings
        '** Modified 02-20-04 JJF
        'sTemp1 = "Batch                                     Qty Cmnts    Imported  Ignored   Error     "
        'sTemp2 = "----------------------------------------  -----------  --------  --------  --------  "
        sTemp1 = "Batch                                     Qty HandEnt  Imported  Ignored   Error     Qty Cmnts    Imported  Ignored   Error     "
        sTemp2 = "----------------------------------------  -----------  --------  --------  --------  -----------  --------  --------  --------  "
        '** End of modification 02-20-04 JJF
        
        'Add the comment type counts to the header strings
        For Each oCmntType In goCommentTypes
            With oCmntType
                sTemp1 = sTemp1 & RPad(sString:=Left(.Description, 10), nLength:=12)
                sTemp2 = sTemp2 & "----------  "
            End With
        Next oCmntType
        
        'Finish the header strings
        sTemp1 = sTemp1 & "Date/Time            ComputerName/UserName                             "
        sTemp2 = sTemp2 & "-------------------  --------------------------------------------------"
        
        'Print the header strings
        Print #lFileHandle, sTemp1
        Print #lFileHandle, sTemp2
    End If
    
    'Start the log string
    '** Modified 05-27-05 JJF
    ''** Modified 02-20-04 JJF
    ''sTemp1 = RPad(sString:=BatchNumber, nLength:=42) & _
    ''         LPad(sString:=Count, nLength:=11) & _
    ''         LPad(sString:=mnImportedComment, nLength:=10) & _
    ''         LPad(sString:=mnIgnoredComment, nLength:=10) & _
    ''         LPad(sString:=mnErrorsComment, nLength:=10)
    'sTemp1 = RPad(sString:=BatchNumber, nLength:=42) & _
    '         LPad(sString:=CountHandEntries, nLength:=11) & _
    '         LPad(sString:=mnImportedHandEntry, nLength:=10) & _
    '         LPad(sString:=mnIgnoredHandEntry, nLength:=10) & _
    '         LPad(sString:=mnErrorsHandEntry, nLength:=10) & _
    '         LPad(sString:=CountComments, nLength:=13) & _
    '         LPad(sString:=mnImportedComment, nLength:=10) & _
    '         LPad(sString:=mnIgnoredComment, nLength:=10) & _
    '         LPad(sString:=mnErrorsComment, nLength:=10)
    ''** End of modifications 02-20-04 JJF
    '
    ''Add the comment type counts
    'For Each oCmntType In goCommentTypes
    '    With oCmntType
    '        sTemp1 = sTemp1 & LPad(sString:=GetCountByType(lCommentType:=.ID), nLength:=12)
    '    End With
    'Next oCmntType
    If sComment <> "" Then
        'Print the batch number and the supplied comment
        sTemp1 = RPad(sString:=BatchNumber, nLength:=42) & _
                 RPad(sString:=sComment, nLength:=120)
    Else
        'Print the batch number and the batch counts
        sTemp1 = RPad(sString:=BatchNumber, nLength:=42) & _
                 LPad(sString:=CountHandEntries, nLength:=11) & _
                 LPad(sString:=mnImportedHandEntry, nLength:=10) & _
                 LPad(sString:=mnIgnoredHandEntry, nLength:=10) & _
                 LPad(sString:=mnErrorsHandEntry, nLength:=10) & _
                 LPad(sString:=CountComments, nLength:=13) & _
                 LPad(sString:=mnImportedComment, nLength:=10) & _
                 LPad(sString:=mnIgnoredComment, nLength:=10) & _
                 LPad(sString:=mnErrorsComment, nLength:=10)
        
        'Add the comment type counts
        For Each oCmntType In goCommentTypes
            With oCmntType
                sTemp1 = sTemp1 & LPad(sString:=GetCountByType(lCommentType:=.ID), nLength:=12)
            End With
        Next oCmntType
    End If
    '** End of modification 05-27-05 JJF
    
    'Finish the log string
    sTemp1 = sTemp1 & "  " & _
             RPad(sString:=Format(Now, "mm/dd/yyyy hh:nn:ss"), nLength:=21) & _
             RPad(sString:=oUserInfo.ComputerName & "/" & oUserInfo.UserName, nLength:=50, bTruncate:=True)
                             
    'Print the log string
    Print #lFileHandle, sTemp1
    
    'Close the log file
    Close #lFileHandle
    Set oUserInfo = Nothing     '** Added 09-05-00 JJF
    
    'Unlock the file so other processes can continue
    UnlockFiles lFileHandle:=lLockHandle
    
End Sub

Public Sub MoveFileToCanada()
    
    If Dir(msProcessedHoldFilePath & msFileName) > "" Then
        FileCopy msProcessedHoldFilePath & msFileName, msCAUnProcessedFilePath & msFileName
        Kill msProcessedHoldFilePath & msFileName
    End If
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CAUnProcessedFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Sets the path to where the unprocessed import files
'\\                 are stored for Canada.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let CAUnProcessedFilePath(ByVal sData As String)
    
    msCAUnProcessedFilePath = sData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Process
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine is called to do the final processing
'\\                 of the Comments in the collection.  When this
'\\                 process is complete all comment values will have
'\\                 been written to the database.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     01-21-02    JJF     Added code to deal with name masking.
'\\     01-28-02    JJF     Changed the way name masking is done.
'\\     09-24-02    JJF     Added additional error handling and retry
'\\                         logic.
'\\     02-20-04    JJF     Re-Written to deal with hand entries.
'\\     08-25-04    JJF     Modified so we can track and report counts
'\\                         for hand entries.
'\\     10-31-05    JJF   * Added ability to capture disposition info
'\\                         in the comment codes.
'\\                       * Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Process()

    Dim sDispSql        As String
    Dim lCnt            As Long
    Dim lCurRec         As Long
    Dim lCmntID         As Long
    Dim nRetryCount     As Integer
    Dim bTransInProcess As Boolean
    Dim bIsComment      As Boolean
    Dim oCodeCm         As ADODB.Command
    Dim oCommentCm      As ADODB.Command
    Dim oLockCm         As ADODB.Command
    Dim oHandEntryCm    As ADODB.Command
    Dim oItem           As Object
    Dim oComment        As CComment
    Dim oHandEntry      As CHandEntry
    Dim oCommentCode    As CCommentCode
    
    Const knChunkSize   As Integer = 6000
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Updating Comments for " & FileName & "..."
    End With

    'Setup the comment lock update command
    Set oLockCm = New ADODB.Command
    With oLockCm
        .CommandText = "sp_SI_CommentSetLock"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = goConn
    End With 'oLockCm
    
    'Setup the comment insert command
    Set oCommentCm = New ADODB.Command
    With oCommentCm
        .CommandText = "sp_SI_InsertComment2"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("CmntType", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("CmntValence", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("SampleUnitID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QstnCore", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("BatchNumber", adVarChar, adParamInput, 40)
        .Parameters.Append .CreateParameter("LineNumber", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("CmntOrHand", adChar, adParamInput, 1)
        .Parameters.Append .CreateParameter("CmntText1", adVarChar, adParamInput, knChunkSize)
        .Parameters.Append .CreateParameter("CmntText2", adVarChar, adParamInput, knChunkSize)
        .Parameters.Append .CreateParameter("CmntTextUM1", adVarChar, adParamInput, knChunkSize)
        .Parameters.Append .CreateParameter("CmntTextUM2", adVarChar, adParamInput, knChunkSize)
        .Parameters.Append .CreateParameter("CmntID", adInteger, adParamOutput)
    End With 'oCommentCm
    
    'Setup the comment code insert command
    Set oCodeCm = New ADODB.Command
    With oCodeCm
        .CommandText = "sp_SI_InsertCommentCode"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("CmntID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("CmntCode", adInteger, adParamInput)
    End With 'oCodeCm
    
    'Setup the hand entry insert command
    Set oHandEntryCm = New ADODB.Command
    With oHandEntryCm
        .CommandText = "sp_BDUS_UpdateBackgroundInfo"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 600
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("StudyID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("PopID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("SamplePopID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("SetClause", adVarChar, adParamInput, 7800)
        .Parameters.Append .CreateParameter("FieldList", adVarChar, adParamInput, 5000)
        .Parameters.Append .CreateParameter("Program", adInteger, adParamInput)
    End With 'oHandEntryCm
    
    'Loop through all of the Comments and Hand Entries
    lCurRec = 0
    For Each oItem In moComments
        'Update the status
        lCurRec = lCurRec + 1
        goProgressBar.Progress = (lCurRec / Count) * 100
        
        'Determine if we are dealing with a comment or a hand entry
        If TypeOf oItem Is CComment Then
            'We are dealing with a comment
            bIsComment = True
            Set oComment = oItem
            With oComment
                'Process this Comment
                If Not .TextLineAdded And .CodeLineAdded Then
                    'The Comment Text line was not found in the import file
                    .ErrorString = "CComments::Process - Error #" & imcCommentLineNotFound & ": The comment text line for this comment was not found in the import file"
                    mnErrorsComment = mnErrorsComment + 1
                
                ElseIf .TextLineAdded And Len(.CommentText) > 0 And Not .CodeLineAdded Then
                    'The Comment Code line was not found in the import file
                    .ErrorString = "CComments::Process - Error #" & imcCodeLineNotFound & ": The comment code line for this comment was not found in the import file"
                    mnErrorsComment = mnErrorsComment + 1
                    
                ElseIf Len(.CommentText) = 0 Then
                    'This comment has no text
                    mnIgnoredComment = mnIgnoredComment + 1
                
                ElseIf Not .IsCommentTypeValid Then
                    'The comment type is not one of the valid types
                    .ErrorString = "CComments::Process - Error #" & imcInvalidCommentType & ": Invalid Comment Type for this comment"
                    mnErrorsComment = mnErrorsComment + 1
                
                ElseIf Not .IsCommentValenceValid Then
                    'The comment type is not one of the valid types
                    .ErrorString = "CComments::Process - Error #" & imcInvalidCommentValence & ": Invalid Comment Valence for this comment"
                    mnErrorsComment = mnErrorsComment + 1
                
                ElseIf Not .IsCommentCodesValid Then
                    'The comment codes are not one of the valid codes
                    .ErrorString = "CComments::Process - Error #" & imcInvalidCommentCode & ": Invalid or Missing Comment Code found for this comment"
                    mnErrorsComment = mnErrorsComment + 1
                    
                ElseIf Not .IsNameMaskingValid Then
                    'The comment name masking characters are not correct
                    .ErrorString = "CComments::Process - Error #" & imcInvalidNameMasking & ": Invalid Name Masking characters found for the comment"
                    mnErrorsComment = mnErrorsComment + 1
                
                ElseIf Not .IsBarcodeValid Then
                    'If the barcode is not valid then write the error and move on to the next Comment
                    .ErrorString = "CComments::Process - Error #" & imcInvalidBarcode & ": Invalid Barcode Checkdigit"
                    mnErrorsComment = mnErrorsComment + 1
                
                ElseIf .SentMailID < 0 Then
                    'The SentMail_id is invalid
                    .ErrorString = "CComments::Process - Error #" & imcNoSentMailingRecord & ": No SentMailing Record Exists for this LithoCode"
                    mnErrorsComment = mnErrorsComment + 1
                
                ElseIf .QuestionFormID < 0 Then
                    'The QuestionForm_id is invalid
                    .ErrorString = "CComments::Process - Error #" & imcNoQuestionFormRecord & ": No QuestionForm Record Exists for this LithoCode"
                    mnErrorsComment = mnErrorsComment + 1
                
                ElseIf .QuestionNotFound Then
                    'The question was not found in the CommentPos (comments) or BubblePos (hand-written) tables
                    .ErrorString = "CComments::Process - Error #" & imcNoCommentPosRecord & ": No Record found for QstnCore in CommentPos or BubblePos"
                    mnErrorsComment = mnErrorsComment + 1
                
                ElseIf .SampleUnitID < 0 Then
                    'The Sample Unit ID could not be determined
                    .ErrorString = "CComments::Process - Error #" & imcInvalidSampleUnitID & ": Unable to determine the SampleUnit_id for this Comment"
                    mnErrorsComment = mnErrorsComment + 1
                    
                ElseIf .Ignore Then
                    'This Comment has already been imported or encountered an error during export so do nothing
                    mnIgnoredComment = mnIgnoredComment + 1
                
                Else
                    'No errors were encountered so lets do the updates
                    'Start the trasaction
RetryTransactionCM:
                    goConn.BeginTrans
                    bTransInProcess = True
                    
                    'Set the lock date on this table
                    oLockCm.Execute
                    'Err.Raise 3122
                    
                    'Insert this comment
                    oCommentCm.Parameters("CmntType") = .CommentType
                    oCommentCm.Parameters("CmntValence") = .CommentValence
                    oCommentCm.Parameters("SampleUnitID") = .SampleUnitID
                    oCommentCm.Parameters("QstnCore") = .QstnCore
                    oCommentCm.Parameters("QuestionFormID") = .QuestionFormID
                    oCommentCm.Parameters("BatchNumber") = .BatchNumber
                    oCommentCm.Parameters("LineNumber") = .LineNumber
                    oCommentCm.Parameters("CmntOrHand") = .CommentOrHandWritten
                    oCommentCm.Parameters("CmntText1") = Left(.CommentText, knChunkSize)
                    oCommentCm.Parameters("CmntText2") = Mid(.CommentText, knChunkSize + 1, knChunkSize)
                    oCommentCm.Parameters("CmntTextUM1") = Left(.CommentTextUM, knChunkSize)
                    oCommentCm.Parameters("CmntTextUM2") = Mid(.CommentTextUM, knChunkSize + 1, knChunkSize)
                    oCommentCm.Execute
                    
                    'Get the new comment's id
                    lCmntID = oCommentCm.Parameters("CmntID")
                    
                    'Insert the codes for this comment
                    For lCnt = 1 To .CommentCodeCount
                        'Get a reference to this code
                        Set oCommentCode = goCommentCodes.Item("K" & .CommentCodes(lCnt))
                        
                        'Determine if this is a comment code or a disposition
                        If oCommentCode.DispositionID > 0 Then
                            'This is a disposition code
                            Select Case oCommentCode.GetActionSQL(oComment, sDispSql)
                                Case eGetActionSQLReturnValues.eGASSuccess
                                    'We successfully determined the action to take so let's take it
                                    goConn.Execute sDispSql
                                    
                                Case eGetActionSQLReturnValues.eGASUnsupported
                                    'We are dealing with an action that is not yet supported so just log the disposition
                                    goConn.Execute sDispSql
                                    
                                Case eGetActionSQLReturnValues.eGASInvalid
                                    'We are either dealing with an error or an action we do not know what to do with
                                    'DO NOTHING
                                    
                            End Select
                        Else
                            'This is a normal comment code
                            oCodeCm.Parameters("CmntID") = lCmntID
                            oCodeCm.Parameters("CmntCode") = oCommentCode.ID
                            oCodeCm.Execute
                        End If
                        
                        'Prepare for next pass
                        sDispSql = ""
                        Set oCommentCode = Nothing
                    Next lCnt
                    
                    'If all was okey dokey then commit
                    goConn.CommitTrans
                    bTransInProcess = False
                    nRetryCount = 0
                    
                    mnImportedComment = mnImportedComment + 1
                End If
                
                'If we made it to here then this Comment is finished
                DoEvents
            End With 'oComment
            
        Else
        
            'We are dealing with a hand entry
            bIsComment = False
            Set oHandEntry = oItem
            With oHandEntry
                'Process this Hand Entry
                If Len(.HandEntryText) = 0 Then
                    'This hand entry has no text
                    mnIgnoredHandEntry = mnIgnoredHandEntry + 1
                
                ElseIf Not .IsBarcodeValid Then
                    'If the barcode is not valid then write the error and move on to the next Comment
                    .ErrorString = "CComments::Process - Error #" & imcInvalidBarcode & ": Invalid Barcode Checkdigit"
                    mnErrorsHandEntry = mnErrorsHandEntry + 1
                
                ElseIf .SentMailID < 0 Then
                    'The SentMail_id is invalid
                    .ErrorString = "CComments::Process - Error #" & imcNoSentMailingRecord & ": No SentMailing Record Exists for this LithoCode"
                    mnErrorsHandEntry = mnErrorsHandEntry + 1
                
                ElseIf .QuestionFormID < 0 Then
                    'The QuestionForm_id is invalid
                    .ErrorString = "CComments::Process - Error #" & imcNoQuestionFormRecord & ": No QuestionForm Record Exists for this LithoCode"
                    mnErrorsHandEntry = mnErrorsHandEntry + 1
                
                ElseIf .QuestionNotFound Then
                    'The question was not found in the HandWrittenPos table
                    .ErrorString = "CComments::Process - Error #" & imcNoHandWrittenPosRecord & ": No Record found for QstnCore in HandWrittenPos"
                    mnErrorsHandEntry = mnErrorsHandEntry + 1
                
                ElseIf .SampleUnitID < 0 Then
                    'The Sample Unit ID could not be determined
                    .ErrorString = "CComments::Process - Error #" & imcInvalidSampleUnitID & ": Unable to determine the SampleUnit_id for this Hand Entry"
                    mnErrorsHandEntry = mnErrorsHandEntry + 1
                    
                ElseIf .PopID < 0 Then
                    'The Pop ID could not be determined
                    .ErrorString = "CComments::Process - Error #" & imcInvalidPopID & ": Unable to determine the Pop_id for this Hand Entry"
                    mnErrorsHandEntry = mnErrorsHandEntry + 1
                    
                ElseIf .SamplePopID < 0 Then
                    'The SamplePopID could not be determined
                    .ErrorString = "CComments::Process - Error #" & imcInvalidSamplePopID & ": Unable to determine the SamplePop_id for this Hand Entry"
                    mnErrorsHandEntry = mnErrorsHandEntry + 1
                    
                ElseIf Len(.FieldName) = 0 Then
                    'The field name could not be determined
                    .ErrorString = "CComments::Process - Error #" & imcInvalidFieldName & ": Unable to determine the Field Name for this Hand Entry"
                    mnErrorsHandEntry = mnErrorsHandEntry + 1
                    
                ElseIf .Ignore Then
                    'This Hand Entry has already been imported or encountered an error during export so do nothing
                    mnIgnoredHandEntry = mnIgnoredHandEntry + 1
                
                Else
                    'No errors were encountered so lets do the updates
                    'Start the transaction
RetryTransactionHE:
                    goConn.BeginTrans
                    bTransInProcess = True
                    
                    'Insert this hand entry
                    oHandEntryCm.Parameters("StudyID") = .StudyID
                    oHandEntryCm.Parameters("PopID") = .PopID
                    oHandEntryCm.Parameters("SamplePopID") = .SamplePopID
                    oHandEntryCm.Parameters("QuestionFormID") = .QuestionFormID
                    oHandEntryCm.Parameters("SetClause") = .SetClause
                    oHandEntryCm.Parameters("FieldList") = .FieldList
                    oHandEntryCm.Parameters("Program") = 1
                    oHandEntryCm.Execute
                    
                    'If all was okey dokey then commit
                    goConn.CommitTrans
                    bTransInProcess = False
                    nRetryCount = 0
                    
                    mnImportedHandEntry = mnImportedHandEntry + 1
                End If
                
                'If we made it to here then this Comment is finished
                DoEvents
            End With 'oHandEntry
        End If
ResumeFromError:
    Next oItem
    
    'Cleanup
    Set oItem = Nothing
    Set oComment = Nothing
    Set oHandEntry = Nothing
    Set oCommentCode = Nothing
    Set oCommentCm = Nothing
    Set oCodeCm = Nothing
    Set oLockCm = Nothing
    Set oHandEntryCm = Nothing
    
Exit Sub


ErrorHandler:
    If bTransInProcess Then
        goConn.RollbackTrans
        
        If nRetryCount < gknMaxRetries Then
            'Increment the retry counter
            nRetryCount = nRetryCount + 1
            
            'Wait 2 seconds
            goConn.Execute "WAITFOR DELAY '000:00:02'"
            
            'Retry the transaction
            If bIsComment Then
                Resume RetryTransactionCM
            Else
                Resume RetryTransactionHE
            End If
        End If
        
        bTransInProcess = False
    End If
    
    oItem.ErrorString = "CComments::Process - Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    If bIsComment Then
        mnErrorsComment = mnErrorsComment + 1
    Else
        mnErrorsHandEntry = mnErrorsHandEntry + 1
    End If
    nRetryCount = 0
    Resume ResumeFromError
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ProcessedHoldFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2003
'\\
'\\ Description:    Sets the path to where the processed barcode files
'\\                 are stored until completed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ProcessedHoldFilePath(ByVal sData As String)
    
    msProcessedHoldFilePath = sData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ErrorCount
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the quantity of Comments and Hand Entries
'\\                 that contain errors.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-04    JJF     Added ability to deal with Hand Entries.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ErrorCount() As Long
    
    Dim lErrorCnt   As Long
    '** Modified 02-20-04 JJF
    'Dim oComment    As CComment
    Dim oItem       As Object
    '** End of modification 02-20-04 JJF
    
    'Determine how many Comments have errors
    '** Modified 02-20-04 JJF
    'For Each oComment In moComments
    '    If Len(Trim(oComment.ErrorString)) > 0 Then lErrorCnt = lErrorCnt + 1
    'Next oComment
    For Each oItem In moComments
        If Len(Trim(oItem.ErrorString)) > 0 Then lErrorCnt = lErrorCnt + 1
    Next oItem
    '** End of modification 02-20-04 JJF
    
    'Cleanup
    '** Modified 02-20-04 JJF
    'Set oComment = Nothing
    Set oItem = Nothing
    '** End of modification 02-20-04 JJF
    ErrorCount = lErrorCnt
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OutputErrors
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine creates the error file in the folder
'\\                 where the incomplete files are kept.  This file will
'\\                 contain all of the Comments that encountered
'\\                 an error during processing.  For each Comment
'\\                 it lists out all of the information that has been
'\\                 accumulated as well as the error condition.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-04    JJF     Added ability to deal with hand entries.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub OutputErrors()
    
    Dim lFileHandle As Long
    '** Modified 02-20-04 JJF
    'Dim oComment    As CComment
    Dim oItem       As Object
    '** End of modification 02-20-04 JJF
    
    'Get a file handle
    lFileHandle = FreeFile
    
    'Open the output file
    Open msIncompleteFilePath & msFileName For Output As #lFileHandle
    
    'Write the file header
    '** Modified 02-20-04 JJF
    'Print #lFileHandle, "Barcode   Litho Code  SentMail_id  QuestionForm_id  CmntBox_id  SampleUnit_id  Error String"
    'Print #lFileHandle, "--------  ----------  -----------  ---------------  ----------  -------------  ------------"
    Print #lFileHandle, "Barcode   Litho Code  SentMail_id  QuestionForm_id  Type  QstnCore    BubbleID  LineID    SampleUnit_id  Error String"
    Print #lFileHandle, "--------  ----------  -----------  ---------------  ----  ----------  --------  --------  -------------  ------------"
    '** End of modification 02-20-04 JJF
    
    'Write all of the incomplete Comments
    '** Modified 02-20-04 JJF
    'For Each oComment In moComments
    '    With oComment
    '        If Len(Trim(.ErrorString)) > 0 Then
    '            Print #lFileHandle, RPad(.Barcode, 10) & _
    '                                LPad(.LithoCode, 10) & _
    '                                LPad(.SentMailID, 13) & _
    '                                LPad(.QuestionFormID, 17) & _
    '                                LPad(.QstnCore, 12) & _
    '                                LPad(.SampleUnitID, 15) & _
    '                                LPad(.ErrorString, Len(.ErrorString) + 2)
    '        End If
    '    End With
    'Next oComment
    For Each oItem In moComments
        If TypeOf oItem Is CComment Then
            'This is a comment
            With oItem
                If Len(Trim(.ErrorString)) > 0 Then
                    Print #lFileHandle, RPad(.Barcode, 10) & _
                                        LPad(.LithoCode, 10) & _
                                        LPad(.SentMailID, 13) & _
                                        LPad(.QuestionFormID, 17) & "  Cmnt" & _
                                        LPad(.QstnCore, 12) & "                    " & _
                                        LPad(.SampleUnitID, 15) & _
                                        LPad(.ErrorString, Len(.ErrorString) + 2)
                End If
            End With
        Else
            'This is a hand entry
            With oItem
                If Len(Trim(.ErrorString)) > 0 Then
                    Print #lFileHandle, RPad(.Barcode, 10) & _
                                        LPad(.LithoCode, 10) & _
                                        LPad(.SentMailID, 13) & _
                                        LPad(.QuestionFormID, 17) & "  Hand" & _
                                        LPad(.QstnCore, 12) & _
                                        LPad(.BubbleID, 10) & _
                                        LPad(.LineID, 10) & _
                                        LPad(.SampleUnitID, 15) & _
                                        LPad(.ErrorString, Len(.ErrorString) + 2)
                End If
            End With
        End If
    Next oItem
    '** End of modification 02-20-04 JJF
    
    'Write the barcode header
    Print #lFileHandle, ""
    Print #lFileHandle, ""
    Print #lFileHandle, "Barcodes only"
    Print #lFileHandle, "-------------"
    
    'Write all of the incomplete Comments
    '** Modified 02-20-04 JJF
    'For Each oComment In moComments
    '    With oComment
    '        If Len(Trim(.ErrorString)) > 0 Then
    '            Print #lFileHandle, .Barcode
    '        End If
    '    End With
    'Next oComment
    For Each oItem In moComments
        With oItem
            If Len(Trim(.ErrorString)) > 0 Then
                Print #lFileHandle, .Barcode
            End If
        End With
    Next oItem
    '** End of modification 02-20-04 JJF
    
    'Write the LithoCode header
    Print #lFileHandle, ""
    Print #lFileHandle, ""
    Print #lFileHandle, "LithoCodes only"
    Print #lFileHandle, "---------------"
    
    'Write all of the incomplete Comments
    '** Modified 02-20-04 JJF
    'For Each oComment In moComments
    '    With oComment
    '        If Len(Trim(.ErrorString)) > 0 Then
    '            Print #lFileHandle, .LithoCode & ","
    '        End If
    '    End With
    'Next oComment
    For Each oItem In moComments
        With oItem
            If Len(Trim(.ErrorString)) > 0 Then
                Print #lFileHandle, .LithoCode & ","
            End If
        End With
    Next oItem
    '** End of modification 02-20-04 JJF
    
    'Close the output file and cleanup
    Close #lFileHandle
    '** Modified 02-20-04 JJF
    'Set oComment = Nothing
    Set oItem = Nothing
    '** End of modification 02-20-04 JJF
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  BatchNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the batch number of the Comments being
'\\                 processed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get BatchNumber() As String
    
    Dim sTemp As String
    Dim nLoc  As Integer
    
    Const knMaxLength As Integer = 40
    
    'Strip off the file extension
    sTemp = Trim(Left(msFileName, InStr(msFileName, ".") - 1))
    
    'Return the remaining batch number
    BatchNumber = IIf(Len(sTemp) > knMaxLength, Left(sTemp, knMaxLength), sTemp)
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   LoadFromFile
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine loads the collection with the barcodes
'\\                 to be processed and then moves the source file from
'\\                 the unprocessed to the processed file folder.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  if the barcodes were successfully loaded and the
'\\                       source file moved.
'\\                 FALSE if there were no source files found to process.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-03    JJF     Changed so that the read file is copied to
'\\                         a holding location for recovery later if
'\\                         required.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function LoadFromFile() As Boolean
    
    Dim sTextLine       As String
    Dim sBarCode        As String
    Dim sBatchNumber    As String
    Dim lLineNumber     As Long
    Dim lFileHandle     As Long
    Dim lLockHandle     As Long
    Dim lLithoCode      As Long
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Place a lock on the STR files
    lLockHandle = LockFiles(sLockFileName:=msUnProcessedFilePath & "vstr.lck", _
                            bWaitForever:=True)
    
    'If we were unable to lock the files then we are going to head out of dodge
    If lLockHandle < 0 Then
        LoadFromFile = False
        Exit Function
    End If
    
    'Let's get a filename to process
    msFileName = Dir$(msUnProcessedFilePath & "*.vstr")
    
    'If there are no files to process then head out of dodge
    If msFileName = "" Then
        UnlockFiles lFileHandle:=lLockHandle
        LoadFromFile = False
        Exit Function
    End If
    
    'We have a file to deal with so get on with it
    'Open the file
    lFileHandle = FreeFile
    Open msUnProcessedFilePath & msFileName For Input As #lFileHandle
    
    'Get the batch number
    sBatchNumber = BatchNumber
    
    'Reset the line counter
    lLineNumber = 0
    
    'Process each line of the file
    While Not EOF(lFileHandle)
        'Read in a line
        Line Input #lFileHandle, sTextLine
        sTextLine = RTrim(sTextLine)
        lLineNumber = lLineNumber + 1
        
        'Add this line to the collection
        If Len(Trim(sTextLine)) > 0 Then
            Add sResponseString:=sTextLine, _
                sBatchNumber:=sBatchNumber, _
                lLineNumber:=lLineNumber
        End If
    Wend
    
    'Close the file
    Close #lFileHandle
    
    'Now lets move the file to the processed file location
    '** Modified 02-20-03 JJF
    'FileCopy msUnProcessedFilePath & msFileName, msProcessedFilePath & msFileName
    FileCopy msUnProcessedFilePath & msFileName, msProcessedHoldFilePath & msFileName
    '** End of modification 02-20-03 JJF
    Kill msUnProcessedFilePath & msFileName
    
    'Unlock the file so other processes can continue
    UnlockFiles lFileHandle:=lLockHandle
    
    'Cleanup
    LoadFromFile = True
    
Exit Function


ErrorHandler:
    Err.Raise Number:=iecErrorLoadFromFileFailed, _
              Source:="CComments::LoadFromFile", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  IncompleteFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets the path to where the incomplete import files
'\\                 are stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let IncompleteFilePath(ByVal sData As String)
    
    msIncompleteFilePath = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  UnProcessedFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets the path to where the unprocessed import files
'\\                 are stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let UnProcessedFilePath(ByVal sData As String)
    
    msUnProcessedFilePath = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ProcessedFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Sets the path to where the processed import files
'\\                 are stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ProcessedFilePath(ByVal sData As String)
    
    msProcessedFilePath = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Clear
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
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
    
    Dim lCnt    As Long
    Dim lTotRec As Long
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Cleaning Up Memory for " & FileName & "..."
    End With
    lTotRec = Count
    
    For lCnt = 1 To lTotRec
        'Update the status
        goProgressBar.Progress = (lCnt / lTotRec) * 100
        
        'Remove the object from the collection
        Remove 1
        
        DoEvents
    Next lCnt
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Add
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    This routine is used to add new Comments to
'\\                 the collection.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     sResponseString String  The complete line from the response file
'\\                             for this Comment or Hand Entry.
'\\     sBatchNumber    String  The batch number that this Comment or
'\\                             Hand Entry is being processed in.
'\\     lLineNumber     Long    The line number of this response string
'\\                             within the batch file.
'\\
'\\ Return Value:
'\\     Type            Description
'\\     CComment        A reference to the newly added Comment or
'\\                     Hand Entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-04    JJF     Added ability to deal with hand entries.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'** Modified 02-20-04 JJF
'Public Function Add(ByVal sResponseString As String, ByVal sBatchNumber As String, ByVal lLineNumber As Long) As CComment
Public Function Add(ByVal sResponseString As String, _
                    ByVal sBatchNumber As String, _
                    ByVal lLineNumber As Long) As Object
'** End of modification 02-20-04 JJF

    Dim sKey        As String
    Dim oComment    As CComment
    Dim oCheck      As CComment
    Dim oHandEntry  As CHandEntry
    
    '** Added 02-20-04 JJF
    If UCase(Mid(sResponseString, 10, 1)) = "H" Then
        'Create a new object
        Set oHandEntry = New CHandEntry
        
        'Set the properties passed into the method
        With oHandEntry
            .ResponseString = sResponseString
            .BatchNumber = sBatchNumber
            .LineNumber = lLineNumber
            sKey = .Key
        End With
        
        'Add this object to the collection
        moComments.Add oHandEntry, sKey
        Set Add = oHandEntry
    Else
    '** End of add 02-20-04 JJF
        'Create a new object
        Set oComment = New CComment
        
        'Set the properties passed into the method
        With oComment
            .ResponseString = sResponseString
            .BatchNumber = sBatchNumber
            .LineNumber = lLineNumber
            sKey = .Key
        End With
        
        'Check to see if this one is in the collection already
        Set oCheck = Item(sKey)
        If oCheck Is Nothing Then
            'This comment does not exist so add it to the collection
            moComments.Add oComment, sKey
            Set Add = oComment  '** Added 02-20-04 JJF
        Else
            'This comment is already in the collection so add the new string
            oCheck.ResponseString = sResponseString
            Set Add = oCheck    '** Added 02-20-04 JJF
        End If
    End If  '** Added 02-20-04 JJF
    
    'Return the object created
    'Set Add = oComment     '** Removed 02-20-04 JJF
    
    'Cleanup
    Set oComment = Nothing
    Set oCheck = Nothing
    Set oHandEntry = Nothing    '** Added 02-20-04 JJF
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Item
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns a reference to the requested Comment or
'\\                 Hand Entry.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-04    JJF     Changed return type from CComment to Object
'\\                         to allow for dealing with Hand Entries.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Item(ByVal vIndexKey As Variant) As Object
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = moComments(vIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CountHandEntries
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the total quantity of Hand Entries in this
'\\                 collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CountHandEntries() As Long

    Dim oItem   As Object
    Dim lCnt    As Long
    
    lCnt = 0
    For Each oItem In moComments
        If TypeOf oItem Is CHandEntry Then
            lCnt = lCnt + 1
        End If
    Next oItem
    
    CountHandEntries = lCnt
    Set oItem = Nothing
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CountComments
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-20-2004
'\\
'\\ Description:    Returns the total quantity of Comments in this
'\\                 collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CountComments() As Long

    Dim oItem   As Object
    Dim lCnt    As Long
    
    lCnt = 0
    For Each oItem In moComments
        If TypeOf oItem Is CComment Then
            lCnt = lCnt + 1
        End If
    Next oItem
    
    CountComments = lCnt
    Set oItem = Nothing
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Count
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Returns the total quantity of Comment and Hand
'\\                 Entry objects in this collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Count() As Long
    
    Count = moComments.Count
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Remove
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
'\\
'\\ Description:    Removes the specified Comment from the collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     vIndexKey   Variant     Either the KEY or INDEX of the Comment
'\\                             to be removed from the collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Remove(ByVal vIndexKey As Variant)
    
    moComments.Remove vIndexKey
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  NewEnum
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-2001
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
    
    Set NewEnum = moComments.[_NewEnum]
    
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
    Set moComments = New Collection
    
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
    
    'destroys collection when this class is terminated
    Set moComments = Nothing
    
End Sub

