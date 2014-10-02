VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CQuestionaires"
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
'\\ File Name:      CQuestionaires.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the object definition that is used
'\\                 to collect and process scanned questionaires.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Added the required routines to allow for
'\\                         validation of the quantity of images in the
'\\                         batch
'\\     06-27-00    JJF     Added output process logging.
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
    Private msBatchImageFilePath    As String   '** Added 06-19-00 JJF
    Private msLogFilePath           As String   '** Added 09-06-00 JJF
    Private msFileName              As String
    Private mnQtyImagesFound        As Integer  '** Added 06-19-00 JJF
    
    'local variable(s) to hold internal counter(s)
    Private mnImported              As Integer  '** Added 06-27-00 JJF
    Private mnIgnored               As Integer  '** Added 06-27-00 JJF
    Private mnErrors                As Integer  '** Added 06-27-00 JJF
    
    'local variable to hold collection
    Private moQuestionaires As Collection


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  LogFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   09-06-2000
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
'\\ Property Name:  BatchImageFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-19-2000
'\\
'\\ Description:    Sets/returns the path to where the batch image files
'\\                 are stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get BatchImageFilePath() As String
    
    Dim sTemp As String
    Dim nLoc1 As Integer
    Dim nLoc2 As Integer
    Dim nLoc As Integer
    
    'Build the string by replacing the appropriate place holders
    sTemp = msBatchImageFilePath
    
    'First let's do the PaperSize
    nLoc = InStr(UCase(sTemp), "<PAPERSIZE>")
    sTemp = Left(sTemp, nLoc - 1) & PaperSize & Mid(sTemp, nLoc + 11)
    
    'And now for the BatchNumber
    nLoc = InStr(UCase(sTemp), "<BATCHNUMBER>")
    sTemp = Left(sTemp, nLoc - 1) & BatchNumber & Mid(sTemp, nLoc + 13)
    
    'Set the return value
    BatchImageFilePath = sTemp
    
End Property

Public Property Get FileName() As String
    
    FileName = msFileName
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetAdditionalInfo
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine collects the base information for the
'\\                 questionaires being processed.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Added progress indication.
'\\     08-29-00    JJF     Added ability to deal with hand entered
'\\                         results.
'\\     12-20-00    JJF     Added KeepMultiReturns property.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub GetAdditionalInfo()
    
    Dim sSql            As String
    Dim lUnusedReturnID As Long
    Dim oTempRs         As ADODB.Recordset
    Dim oQuestionaire   As CQuestionaire
    Dim lCurRec         As Long             '** Added 08-18-00 JJF
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    '** Added 08-18-00 JJF
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Getting Additional Info for " & FileName & "..."
    End With
    '** End of add 08-18-00 JJF
    
    'Get the remaining info from the database
    '** Modified 05-27-05 JJF
    ''** Modified 12-20-00 JJF
    '''** Modified 08-29-00 JJF
    '''sSql = "SELECT SM.strLithoCode, SM.SentMail_id, QF.QuestionForm_id, " & _
    '''               "QF.SamplePop_id, QF.Survey_id, QF.UnusedReturn_id, " & _
    '''               "QF.datResultsImported " & _
    '''       "FROM SentMailing SM LEFT JOIN QuestionForm QF " & _
    '''             "ON SM.SentMail_id = QF.SentMail_id " & _
    '''       "WHERE SM.strLithoCode IN (" & LithoInList & ")"
    ''sSql = "SELECT SM.strLithoCode, SM.SentMail_id, QF.QuestionForm_id, " & _
    ''               "QF.SamplePop_id, QF.Survey_id, QF.UnusedReturn_id, " & _
    ''               "QF.datResultsImported, QF.datReturned " & _
    ''       "FROM SentMailing SM LEFT JOIN QuestionForm QF " & _
    ''             "ON SM.SentMail_id = QF.SentMail_id " & _
    ''       "WHERE SM.strLithoCode IN (" & LithoInList & ")"
    '''** End of modifications 08-29-00 JJF
    'sSql = "SELECT SM.strLithoCode, SM.SentMail_id, QF.QuestionForm_id, " & _
    '       "       QF.SamplePop_id, QF.Survey_id, QF.UnusedReturn_id, " & _
    '       "       QF.datResultsImported, QF.datReturned, SD.bitMultReturns " & _
    '       "FROM (SentMailing SM LEFT JOIN QuestionForm QF ON SM.SentMail_id = QF.SentMail_id) " & _
    '       "                     LEFT JOIN Survey_Def SD ON QF.Survey_id = SD.Survey_id " & _
    '       "WHERE SM.strLithoCode IN (" & LithoInList & ")"
    ''** End of modifications 12-20-00 JJF
    sSql = "SELECT SM.strLithoCode, SM.SentMail_id, QF.QuestionForm_id, " & _
           "       QF.SamplePop_id, QF.Survey_id, QF.UnusedReturn_id, " & _
           "       QF.datResultsImported, QF.datReturned, SD.bitMultReturns, " & _
           "       SM.Country_id " & _
           "FROM (SentMailing SM LEFT JOIN QuestionForm QF ON SM.SentMail_id = QF.SentMail_id) " & _
           "                     LEFT JOIN Survey_Def SD ON QF.Survey_id = SD.Survey_id " & _
           "WHERE SM.strLithoCode IN (" & LithoInList & ")"
    '** End of modifications 05-27-05 JJF
    Set oTempRs = goConn.Execute(sSql)
    
    'Loop through the recordset
    lCurRec = 0         '** Added 08-18-00 JJF
    With oTempRs
        Do Until .EOF
            'Get a reference to the Questionaire
            lCurRec = lCurRec + 1                               '** Added 08-18-00 JJF
            goProgressBar.Progress = (lCurRec / Count) * 100    '** Added 08-18-00 JJF
            Set oQuestionaire = Item("LC" & !strLithoCode)
            
            'Set the properties
            If Not (oQuestionaire Is Nothing) Then
                oQuestionaire.SentMailID = IIf(IsNull(!SentMail_id), -1, !SentMail_id)
                oQuestionaire.QuestionFormID = IIf(IsNull(!QuestionForm_id), -1, !QuestionForm_id)
                oQuestionaire.SamplePopID = IIf(IsNull(!SamplePop_id), -1, !SamplePop_id)
                oQuestionaire.SurveyID = IIf(IsNull(!Survey_id), -1, !Survey_id)
                oQuestionaire.DateReturned = IIf(IsNull(!datReturned), #1/1/1900#, !datReturned)   '** Added 08-29-00 JJF
                '** Added 12-20-00 JJF
                oQuestionaire.KeepMultiReturns = IIf(IsNull(!bitMultReturns), False, !bitMultReturns)
                '** End of add 12-20-00 JJF
                
                'Determine if this questionaire is to be ignored
                'Get the UnusedReturn_id
                lUnusedReturnID = IIf(IsNull(!UnusedReturn_id), urcNone, !UnusedReturn_id)
                'If the UnusedReturn_id indicates an error was encountered or
                '  the results imported date has been set then we will ignore
                '  this questionaire.
                oQuestionaire.Ignore = (lUnusedReturnID > urcNone Or Not IsNull(!datResultsImported))
                
                '** Added 05-27-05 JJF
                oQuestionaire.WhereIsIt = IIf(IsNull(!Country_id), cccUnknown, !Country_id)
                If geCountry = cccUS And oQuestionaire.WhereIsIt <> cccUS Then
                    oQuestionaire.Ignore = True
                End If
                '** End of add 05-27-05 JJF
            End If
            
            'Prepare for the next pass
            Set oQuestionaire = Nothing
            .MoveNext
            DoEvents
        Loop
    End With
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorGetAddInfoFailed, _
              Source:="CQuestionaires::GetAdditionalInfo", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub
    

    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OutputLog
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-27-2000
'\\
'\\ Description:    This routine writes the results of the current
'\\                 import batch to a log file for statistical tracking.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Added the ability for this program to have
'\\                         multiple instances running at once.
'\\     09-05-00    JJF     Added date, user name, and computer name to
'\\                         the log file record.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'Public Sub OutputLog()
Public Sub OutputLog(Optional ByVal sComment As String = "")
    
    Dim bExists     As Boolean
    Dim lFileHandle As Long
    Dim lLockHandle As Long         '** Added 08-18-00 JJF
    Dim sFileName   As String
    Dim oUserInfo   As CUserInfo    '** Added 09-05-00 JJF
    
    '** Added 08-18-00 JJF
    'Place a lock on the STR files
    
    lLockHandle = LockFiles(sLockFileName:=msLogFilePath & "TRLog.lck", _
                            bWaitForever:=True)
    '** End of add 08-18-00 JJF
    
    'Get the file name
    sFileName = msLogFilePath & Format(Now, "yyyymmdd") & "TR.log"
    
    'Check to see if the log file exists
    If Dir$(sFileName, vbNormal) <> "" Then bExists = True
    
    'Open the file
    lFileHandle = FreeFile
    Open sFileName For Append As #lFileHandle
    
    '** Added 09-05-00 JJF
    'Initialize the user info object
    Set oUserInfo = New CUserInfo
    '** End of add 09-05-00 JJF
    
    'Write the header if required
    If Not bExists Then
        '** Modified 09-05-00 JJF
        'Print #lFileHandle, "PaperSize  Batch     Qty Lines    Images/Line  Qty Images   Imported  Ignored   Error   "
        'Print #lFileHandle, "---------  --------  -----------  -----------  -----------  --------  --------  --------"
        Print #lFileHandle, "PaperSize  Batch     Qty Lines    Images/Line  Qty Images   Imported  Ignored   Error     Date/Time            ComputerName/UserName                             "
        Print #lFileHandle, "---------  --------  -----------  -----------  -----------  --------  --------  --------  -------------------  --------------------------------------------------"
        '** End of modification 09-05-00 JJF
    End If
    
    'Write the values for this batch
    '** Modified 05-27-05 JJF
    ''** Modified 09-05-00 JJF
    ''Print #lFileHandle, RPad(sString:=PaperSize, nLength:=11) & _
    ''                    RPad(sString:=BatchNumber, nLength:=10) & _
    ''                    LPad(sString:=Count, nLength:=11) & _
    ''                    LPad(sString:=QtyImagesPerQuestionaire, nLength:=13) & _
    ''                    LPad(sString:=QtyImagesFound, nLength:=13) & _
    ''                    LPad(sString:=mnImported, nLength:=10) & _
    ''                    LPad(sString:=mnIgnored, nLength:=10) & _
    ''                    LPad(sString:=mnErrors, nLength:=10)
    'Print #lFileHandle, RPad(sString:=PaperSize, nLength:=11) & _
    '                    RPad(sString:=BatchNumber, nLength:=10) & _
    '                    LPad(sString:=Count, nLength:=11) & _
    '                    LPad(sString:=QtyImagesPerQuestionaire, nLength:=13) & _
    '                    LPad(sString:=QtyImagesFound, nLength:=13) & _
    '                    LPad(sString:=mnImported, nLength:=10) & _
    '                    LPad(sString:=mnIgnored, nLength:=10) & _
    '                    LPad(sString:=mnErrors, nLength:=10) & "  " & _
    '                    RPad(sString:=Format(Now, "mm/dd/yyyy hh:nn:ss"), nLength:=21) & _
    '                    RPad(sString:=oUserInfo.ComputerName & "/" & oUserInfo.UserName, _
    '                         nLength:=50, bTruncate:=True)
    ''** End of modification 09-05-00 JJF
    If sComment <> "" Then
        'Print the batch number and the supplied comment
        Print #lFileHandle, RPad(sString:=PaperSize, nLength:=11) & _
                            RPad(sString:=BatchNumber, nLength:=10) & _
                            RPad(sString:=sComment, nLength:=69) & _
                            RPad(sString:=Format(Now, "mm/dd/yyyy hh:nn:ss"), nLength:=21) & _
                            RPad(sString:=oUserInfo.ComputerName & "/" & oUserInfo.UserName, _
                                 nLength:=50, bTruncate:=True)
    Else
        'Print the batch number and the batch counts
        Print #lFileHandle, RPad(sString:=PaperSize, nLength:=11) & _
                            RPad(sString:=BatchNumber, nLength:=10) & _
                            LPad(sString:=Count, nLength:=11) & _
                            LPad(sString:=QtyImagesPerQuestionaire, nLength:=13) & _
                            LPad(sString:=QtyImagesFound, nLength:=13) & _
                            LPad(sString:=mnImported, nLength:=10) & _
                            LPad(sString:=mnIgnored, nLength:=10) & _
                            LPad(sString:=mnErrors, nLength:=10) & "  " & _
                            RPad(sString:=Format(Now, "mm/dd/yyyy hh:nn:ss"), nLength:=21) & _
                            RPad(sString:=oUserInfo.ComputerName & "/" & oUserInfo.UserName, _
                                 nLength:=50, bTruncate:=True)
    End If
    '** End of modification 05-27-05 JJF
    
    'Close the log file
    Close #lFileHandle
    Set oUserInfo = Nothing     '** Added 09-05-00 JJF
    
    '** Added 08-18-00 JJF
    'Unlock the file so other processes can continue
    UnlockFiles lFileHandle:=lLockHandle
    '** End of add 08-18-00 JJF
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Process
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called to do the final processing
'\\                 of the questionaires in the collection.  When this
'\\                 process is complete all question values will have
'\\                 been written to the database.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     eTransferType   eTransferTypeConstants
'\\                                 Specified the type of transfer to be
'\\                                 performed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Added CommandTimeout = 0 on the command
'\\                         object and transactions to the updates.
'\\     06-27-00    JJF     Added output process logging.
'\\     08-18-00    JJF     Added progress indication.
'\\     08-29-00    JJF     Added ability to deal with hand entered
'\\                         results.
'\\     12-20-00    JJF     Added KeepMultiReturns property.
'\\     08-13-01    JJF     Added the eTransferType parameter.
'\\     10-11-01    JJF     Removed call to WriteImportError as it is
'\\                         no longer needed.
'\\     02-12-02    JJF   * Updated the commands that set the date
'\\                         imported so they only update the date
'\\                         returned if this is a non-standard run.
'\\                       * Removed the revision comments as it was
'\\                         getting a little to foggy to see the real
'\\                         code.
'\\     04-03-02    JJF     Added an error condition for when the
'\\                         questionaire has not been marked as
'\\                         returned yet.
'\\     08-25-04    JJF     Removed the scheduled mailing command as
'\\                         this is now taken care of via a trigger.
'\\     10-31-05    JJF   * Removed revision notes.
'\\                       * Added ReceiptType_id to the QuestionForm
'\\                         table update.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Process(ByVal eTransferType As eTransferTypeConstants)

    Dim sSql            As String
    Dim sSql1           As String
    Dim lCnt            As Long
    Dim lCurRec         As Long
    Dim bTransInProcess As Boolean
    Dim oQuestionaire   As CQuestionaire
    Dim oQuestion       As CQuestion
    Dim oResultCm       As ADODB.Command
    Dim oResult1Cm      As ADODB.Command
    Dim oResult2Cm      As ADODB.Command
    Dim oImportDateCm   As ADODB.Command
    Dim oImportDate1Cm  As ADODB.Command
    Dim oImportDate2Cm  As ADODB.Command
    Dim oThankYouCm     As ADODB.Command
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Updating Results for " & FileName & "..."
    End With
    
    'Setup the question result INSERT command object for the main table
    sSql = "INSERT INTO QuestionResult " & _
           "       (QuestionForm_Id ,SampleUnit_Id, QstnCore, intResponseVal) " & _
           "VALUES (?, ?, ?, ?)"
    Set oResult1Cm = New ADODB.Command
    With oResult1Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("SampleUnitID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QstnCore", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("ResponseVal", adInteger, adParamInput)
        .Prepared = True
    End With 'oResult1Cm
    
    'Setup the question result INSERT command object for the secondary table
    sSql = "INSERT INTO QuestionResult2 " & _
           "       (QuestionForm_Id ,SampleUnit_Id, QstnCore, intResponseVal) " & _
           "VALUES (?, ?, ?, ?)"
    Set oResult2Cm = New ADODB.Command
    With oResult2Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("SampleUnitID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QstnCore", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("ResponseVal", adInteger, adParamInput)
        .Prepared = True
    End With 'oResult2Cm
    
    'Setup the Import Date command
    If eTransferType <> ttcNormal Then
        'This is a non-qualpro or hand entered str file so we need
        '  to set the date returned
        sSql = "UPDATE QuestionForm " & _
               "SET datResultsImported = getdate(), " & _
               "    datReturned = getdate()-1, " & _
               "    strSTRBatchNumber = ?, " & _
               "    intSTRLineNumber = ?, " & _
               "    ReceiptType_id = ? " & _
               "WHERE QuestionForm_id = ?"
        
        sSql1 = "UPDATE QuestionForm " & _
                "SET datResultsImported = getdate(), " & _
                "    UnusedReturn_id = " & urcKeepMultiReturns & ", " & _
                "    datReturned = getdate()-1, " & _
                "    strSTRBatchNumber = ?, " & _
                "    intSTRLineNumber = ?, " & _
                "    ReceiptType_id = ? " & _
                "WHERE QuestionForm_id = ?"
    Else
        'This is a normal qualpro str file so do not set the date returned
        sSql = "UPDATE QuestionForm " & _
               "SET datResultsImported = getdate(), " & _
               "    strSTRBatchNumber = ?, " & _
               "    intSTRLineNumber = ?, " & _
               "    ReceiptType_id = ? " & _
               "WHERE QuestionForm_id = ?"
        
        sSql1 = "UPDATE QuestionForm " & _
                "SET datResultsImported = getdate(), " & _
                "    UnusedReturn_id = " & urcKeepMultiReturns & ", " & _
                "    strSTRBatchNumber = ?, " & _
                "    intSTRLineNumber = ?, " & _
                "    ReceiptType_id = ? " & _
                "WHERE QuestionForm_id = ?"
    End If
    
    Set oImportDate1Cm = New ADODB.Command
    With oImportDate1Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("STRBatchNumber", adVarChar, adParamInput, 8)
        .Parameters.Append .CreateParameter("STRLineNumber", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("ReceiptTypeID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Prepared = True
    End With 'oImportDate1Cm
    
    Set oImportDate2Cm = New ADODB.Command
    With oImportDate2Cm
        .CommandText = sSql1
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("STRBatchNumber", adVarChar, adParamInput, 8)
        .Parameters.Append .CreateParameter("STRLineNumber", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("ReceiptTypeID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Prepared = True
    End With 'oImportDate2Cm
    
    'Setup the Thank You command
    sSql = "INSERT INTO ScheduledMailing " & _
           "       (MailingStep_id, SamplePop_id, Methodology_id, datGenerate) " & _
           "SELECT DISTINCT ms.MailingStep_id, ?, ms.Methodology_id, getdate() " & _
           "FROM MailingStep ms, SentMailing sm " & _
           "WHERE sm.strLithoCode = ? " & _
           "  AND sm.Methodology_id = ms.Methodology_id " & _
           "  AND ms.bitThankYouItem = 1"
    Set oThankYouCm = New ADODB.Command
    With oThankYouCm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("SamplePopID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("LithoCode", adVarChar, adParamInput, 10)
        .Prepared = True
    End With 'oThankYouCm
    
    'Loop through all of the questionaires
    lCurRec = 0
    For Each oQuestionaire In moQuestionaires
        'Update the status
        lCurRec = lCurRec + 1
        goProgressBar.Progress = (lCurRec / Count) * 100
        
        With oQuestionaire
            'Process this questionaire
            If Not .IsBarcodeValid Then
                'If the barcode is not valid then write the error and move on
                '  to the next questionaire
                .ErrorString = "CQuestionaires::Process - Error #" & imcInvalidBarcode & ": Invalid Barcode Checkdigit"
                mnErrors = mnErrors + 1
            
            ElseIf .SentMailID < 0 Then
                'The SentMail_id is invalid
                .ErrorString = "CQuestionaires::Process - Error #" & imcNoSentMailingRecord & ": No SentMailing Record Exists for this LithoCode"
                mnErrors = mnErrors + 1
            
            ElseIf .QuestionFormID < 0 Then
                'The QuestionForm_id is invalid
                .ErrorString = "CQuestionaires::Process - Error #" & imcNoQuestionFormRecord & ": No QuestionForm Record Exists for this LithoCode"
                mnErrors = mnErrors + 1
            
            ElseIf .DateReturned < CDate("01/02/1900") And eTransferType = ttcNormal Then
                'This questionaire has not been marked as returned yet
                .ErrorString = "CQuestionaires::Process - Error #" & imcNotMarkedReturnedYet & ": This LithoCode has not been marked as returned yet"
                mnErrors = mnErrors + 1
            
            ElseIf .Ignore Then
                'This questionaire has already been imported or encountered
                '  an error during export so do nothing
                mnIgnored = mnIgnored + 1
            
            Else
                'No errors were encountered so lets do the updates
                'Get the question info
                .GetQuestions eTransferType:=eTransferType
                
                'Determine which command objects to use
                If .KeepMultiReturns Then
                    'If we are to keep multiple returns then check
                    '  to see if one has already been imported
                    If .OtherStepImported Then
                        'One has already been imported so save this one
                        '  to the secondary table
                        Set oResultCm = oResult2Cm
                        Set oImportDateCm = oImportDate2Cm
                    Else
                        'One has not been imported yet so save this one
                        '  to the primary table
                        Set oResultCm = oResult1Cm
                        Set oImportDateCm = oImportDate1Cm
                    End If
                Else
                    'We are not keeping multiple returns for this survey
                    '  so save the data to the primary table
                    Set oResultCm = oResult1Cm
                    Set oImportDateCm = oImportDate1Cm
                End If
                
                'Start the trasaction
                goConn.BeginTrans
                bTransInProcess = True
                
                'Insert these responses into the database
                For Each oQuestion In .Questions
                    For lCnt = 1 To oQuestion.ValueCount
                        oResultCm.Parameters("QuestionFormID") = .QuestionFormID
                        oResultCm.Parameters("SampleUnitID") = oQuestion.SampleUnitID
                        oResultCm.Parameters("QstnCore") = oQuestion.QstnCore
                        oResultCm.Parameters("ResponseVal") = oQuestion.Values(lCnt)
                        oResultCm.Execute
                    Next lCnt
                Next oQuestion
                
                'Update the Import Date in the QuestionForm table
                oImportDateCm.Parameters("STRBatchNumber") = .BatchNumber
                oImportDateCm.Parameters("STRLineNumber") = .LineNumber
                oImportDateCm.Parameters("ReceiptTypeID") = goRegReceiptTypeSurvey.Value
                oImportDateCm.Parameters("QuestionFormID") = .QuestionFormID
                oImportDateCm.Execute
                
                'Send any required Thank Yous
                oThankYouCm.Parameters("SamplePopID") = .SamplePopID
                oThankYouCm.Parameters("LithoCode") = .LithoCode
                oThankYouCm.Execute
                
                'If all was okey dokey then commit
                goConn.CommitTrans
                bTransInProcess = False
                
                mnImported = mnImported + 1
            End If
            
            'If we made it to here then this questionaire is finished
            DoEvents
        End With 'oQuestionaire
        
ResumeFromError:
    Next oQuestionaire
    
    'Cleanup
    Set oQuestionaire = Nothing
    Set oResultCm = Nothing
    Set oImportDateCm = Nothing
    Set oThankYouCm = Nothing
    
Exit Sub


ErrorHandler:
    If bTransInProcess Then
        goConn.RollbackTrans
        bTransInProcess = False
    End If
    
    oQuestionaire.ErrorString = "CQuestionaires::Process - Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    mnErrors = mnErrors + 1
    Resume ResumeFromError
    
End Sub

Public Sub MoveFileToCanada()
    
    If Dir(msProcessedHoldFilePath & msFileName) > "" Then
        FileCopy msProcessedHoldFilePath & msFileName, msCAUnProcessedFilePath & msFileName
        Kill msProcessedHoldFilePath & msFileName
    End If
    
End Sub

Public Property Get IsCanadian() As Boolean
    
    Dim oTemp As CQuestionaire
    
    IsCanadian = False
    
    For Each oTemp In moQuestionaires
        If oTemp.WhereIsIt = cccCanada Then
            IsCanadian = True
            Exit For
        End If
    Next oTemp
    
End Property

Public Sub MoveFileFromHolding()
    
    If Dir(msProcessedHoldFilePath & msFileName) > "" Then
        FileCopy msProcessedHoldFilePath & msFileName, msProcessedFilePath & msFileName
        Kill msProcessedHoldFilePath & msFileName
    End If
    
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
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns the quantity of questionaires that contain
'\\                 errors.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Modified to look directly at ErrorString
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ErrorCount() As Long
    
    Dim lErrorCnt     As Long
    Dim oQuestionaire As CQuestionaire
    
    'Determine how many questionaires have errors
    For Each oQuestionaire In moQuestionaires
        '** Modified 06-19-00 JJF
        'If Not oQuestionaire.Complete Then lErrorCnt = lErrorCnt + 1
        If Len(Trim(oQuestionaire.ErrorString)) > 0 Then lErrorCnt = lErrorCnt + 1
        '** End of modification 06-19-00 JJF
    Next oQuestionaire
    
    'Cleanup
    Set oQuestionaire = Nothing
    ErrorCount = lErrorCnt
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OutputErrors
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine creates the error file in the folder
'\\                 where the incomplete files are kept.  This file will
'\\                 contain all of the questionaires that encountered
'\\                 an error during processing.  For each questionaire
'\\                 it lists out all of the information that has been
'\\                 accumulated as well as the error condition.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Modified to look directly at ErrorString
'\\                         and added listings of the barcodes and
'\\                         lithocodes at the end of the file for
'\\                         debugging purposes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub OutputErrors()
    
    Dim lFileHandle   As Long
    Dim oQuestionaire As CQuestionaire
    
    'Get a file handle
    lFileHandle = FreeFile
    
    'Open the output file
    Open msIncompleteFilePath & msFileName For Output As #lFileHandle
    
    'Write the file header
    Print #lFileHandle, "Barcode   Litho Code  SentMail_id  QuestionForm_id  SamplePop_id  " & _
                        "Survey_id  BatchNumber  LineNumber  Error String"
    Print #lFileHandle, "--------  ----------  -----------  ---------------  ------------  " & _
                        "---------  -----------  ----------  ------------"
    
    'Write all of the incomplete questionaires
    For Each oQuestionaire In moQuestionaires
        With oQuestionaire
            '** Modified 06-19-00 JJF
            'If Not .Complete Then
            If Len(Trim(.ErrorString)) > 0 Then
            '** End of modification 06-19-00 JJF
                Print #lFileHandle, RPad(.Barcode, 10) & _
                                    LPad(.LithoCode, 10) & _
                                    LPad(.SentMailID, 13) & _
                                    LPad(.QuestionFormID, 17) & _
                                    LPad(.SamplePopID, 14) & _
                                    LPad(.SurveyID, 11) & "  " & _
                                    RPad(.BatchNumber, 11) & _
                                    LPad(.LineNumber, 12) & _
                                    LPad(.ErrorString, Len(.ErrorString) + 2)
            End If
        End With
    Next oQuestionaire
    
    '** Added 06-19-00 JJF
    'Write the barcode header
    Print #lFileHandle, ""
    Print #lFileHandle, ""
    Print #lFileHandle, "Barcodes only"
    Print #lFileHandle, "-------------"
    
    'Write all of the incomplete questionaires
    For Each oQuestionaire In moQuestionaires
        With oQuestionaire
            If Len(Trim(.ErrorString)) > 0 Then
                Print #lFileHandle, .Barcode
            End If
        End With
    Next oQuestionaire
    
    'Write the LithoCode header
    Print #lFileHandle, ""
    Print #lFileHandle, ""
    Print #lFileHandle, "LithoCodes only"
    Print #lFileHandle, "---------------"
    
    'Write all of the incomplete questionaires
    For Each oQuestionaire In moQuestionaires
        With oQuestionaire
            If Len(Trim(.ErrorString)) > 0 Then
                Print #lFileHandle, .LithoCode & ","
            End If
        End With
    Next oQuestionaire
    '** End of add 06-19-00 JJF
    
    'Close the output file and cleanup
    Close #lFileHandle
    Set oQuestionaire = Nothing
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  PaperSize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-19-2000
'\\
'\\ Description:    Returns the paper size of the questionaires being
'\\                 processed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get PaperSize() As String
    
    Dim sTemp As String
    Dim nLoc  As Integer
    
    'Strip off the file extension
    sTemp = Trim(Left(msFileName, InStr(msFileName, ".") - 1))
    
    'Determine if the space character is present and if so strip off everything after it
    nLoc = InStr(msFileName, " ")
    If nLoc > 0 Then
        sTemp = Trim(Mid(sTemp, 1, nLoc - 1))
    End If
    
    'Return the remaining batch number
    PaperSize = sTemp
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  BatchNumber
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns the batch number of the questionaires being
'\\                 processed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-12-01    JJF     Trimmed the BatchNumber to 8 characters to
'\\                         eliminate the error writing it to the DB.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get BatchNumber() As String
    
    Dim sTemp As String
    Dim nLoc  As Integer
    
    Const knMaxLength As Integer = 8    '** Added 06-12-01 JJF
    
    'Strip off the file extension
    sTemp = Trim(Left(msFileName, InStr(msFileName, ".") - 1))
    
    'Determine if the space character is present and if so strip off everything before it
    nLoc = InStr(msFileName, " ")
    If nLoc > 0 Then
        sTemp = Trim(Mid(sTemp, nLoc + 1))
    End If
    
    'Return the remaining batch number
    '** Modified 06-12-01 JJF
    'BatchNumber = sTemp
    BatchNumber = IIf(Len(sTemp) > knMaxLength, Left(sTemp, knMaxLength), sTemp)
    '** End of modification 06-12-01 JJF
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   LithoInList
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine returns a properly delimited list of
'\\                 the litho codes in this collection for use as an
'\\                 IN clause in a SQL statement.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      IN clause delimited list of litho codes.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function LithoInList() As String
    
    Dim sInList       As String
    Dim oQuestionaire As CQuestionaire
    
    'Build a comma delimited list of the LithoCodes
    For Each oQuestionaire In moQuestionaires
        With oQuestionaire
            If Len(sInList) = 0 Then
                sInList = "'" & .LithoCode & "'"
            Else
                sInList = sInList & ",'" & .LithoCode & "'"
            End If
        End With
    Next oQuestionaire
    
    'Cleanup
    Set oQuestionaire = Nothing
    LithoInList = sInList
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   LoadFromFile
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine loads the collection with the barcodes
'\\                 to be processed and then moves the source file from
'\\                 the unprocessed to the processed file folder.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     sSTRFileName    String      The path and filename of the hand
'\\                                 entered STR file.  Empty string if
'\\                                 normal processing is to occur.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  if the barcodes were successfully loaded and the
'\\                       source file moved.
'\\                 FALSE if there were no source files found to process.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Modified to allow to run on multiple PCs.
'\\     08-29-00    JJF     Added ability to deal with hand entered
'\\                         results.
'\\     06-12-01    JJF     Added ability to import non-qualpro string
'\\                         files.
'\\     02-20-03    JJF     Changed so that the read file is copied to
'\\                         a holding location for recovery later if
'\\                         required.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'** Modified 06-12-01 JJF
''** Modified 08-29-00 JJF
''Public Function LoadFromFile() As Boolean
'Public Function LoadFromFile(ByVal sSTRFileName As String) As Boolean
''** End of modification 08-29-00 JJF
Public Function LoadFromFile(ByVal sSTRFileName As String, _
                             ByVal nLithoStart As Integer, _
                             ByVal nLithoLength As Integer) As Boolean
'** End of modification 06-12-01 JJF
    
    Dim sTextLine       As String
    Dim sBarCode        As String
    Dim sBatchNumber    As String
    Dim lFileHandle     As Long
    Dim lLineNumber     As Long
    Dim lLockHandle     As Long     '** Added 08-18-00 JJF
    Dim lLithoCode      As Long     '** Added 06-12-01 JJF
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    '** Added 08-29-00 JJF
    If Len(sSTRFileName) > 0 Then
        'We are processing a hand entered result file
        msFileName = sSTRFileName
    Else
    '** End of add 08-29-00 JJF
        '** Added 08-18-00 JJF
        'Place a lock on the STR files
        lLockHandle = LockFiles(sLockFileName:=msUnProcessedFilePath & "str.lck", _
                                bWaitForever:=True)
        
        'If we were unable to lock the files then we are going to head out of dodge
        If lLockHandle < 0 Then
            LoadFromFile = False
            Exit Function
        End If
        '** End of add 08-18-00 JJF
        
        'Let's get a filename to process
        msFileName = Dir$(msUnProcessedFilePath & "*.str")
        
        'If there are no files to process then head out of dodge
        If msFileName = "" Then
            UnlockFiles lFileHandle:=lLockHandle    '** Added 08-18-00 JJF
            LoadFromFile = False
            Exit Function
        End If
    End If      '** Added 08-29-00 JJF
    
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
        
        'Setup the required values
        '** Modified 06-12-01 JJF
        'sBarCode = Mid(sTextLine, 9, 8)
        If nLithoStart > 0 Then
            'We are working with a non-QualPro result file
            lLithoCode = Val(Trim(Mid(sTextLine, nLithoStart, nLithoLength)))
            sBarCode = LithoToBarcode(lLithoCode:=lLithoCode, bIncludeCheckDigit:=True)
        Else
            'We are working with a QualPro result file
            sBarCode = Mid(sTextLine, 9, 8)
        End If
        '** End of modification 06-12-01 JJF
        lLineNumber = lLineNumber + 1
        
        'Add this line to the collection
        If Len(Trim(sBarCode)) > 0 Then
            Add sBarCode:=sBarCode, _
                sResponseString:=sTextLine, _
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
    
    '** Modified 06-12-01 JJF
    'Kill msUnProcessedFilePath & msFileName
    'If this is a non-QualPro do not delete it
    If nLithoStart = 0 Then Kill msUnProcessedFilePath & msFileName
    '** End of modification 06-12-01 JJF
    
    If Len(sSTRFileName) = 0 Then   '** Added 08-29-00 JJF
        '** Added 08-18-00 JJF
        'Unlock the file so other processes can continue
        UnlockFiles lFileHandle:=lLockHandle
        '** End of add 08-18-00 JJF
    End If                          '** Added 08-29-00 JJF
    
    'Cleanup
    LoadFromFile = True
    
Exit Function


ErrorHandler:
    Err.Raise Number:=iecErrorLoadFromFileFailed, _
              Source:="CQuestionaires::LoadFromFile", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  BatchImageFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-19-2000
'\\
'\\ Description:    Sets/returns the path to where the batch image files
'\\                 are stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let BatchImageFilePath(ByVal sData As String)
    
    msBatchImageFilePath = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  IncompleteFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
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
'\\ Property Name:  QtyImagesFound
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-19-2000
'\\
'\\ Description:    Returns the quantity of images required for each
'\\                 questionaire in this batch.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get QtyImagesFound() As Integer
    
    QtyImagesFound = mnQtyImagesFound
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QtyImagesPerQuestionaire
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-19-2000
'\\
'\\ Description:    Returns the quantity of images required for each
'\\                 questionaire in this batch.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get QtyImagesPerQuestionaire() As Integer
    
    QtyImagesPerQuestionaire = Val(Mid(BatchNumber, 5, 1))
    
End Property

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
'\\ Property Name:  UnProcessedFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
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
'\\         Date:   04-05-2000
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
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine clears out all members of the collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-15-01    JJF     Added progress indication to the collection
'\\                         cleanup process.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Clear()
    
    Dim lCnt    As Long
    Dim lTotRec As Long     '** Added 08-15-01 JJF
    
    '** Added 08-15-01 JJF
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Cleaning Up Memory for " & FileName & "..."
    End With
    lTotRec = Count
    '** End of add 08-15-01 JJF
    
    '** Modified 08-15-01 JJF
    'For lCnt = 1 To Count
    For lCnt = 1 To lTotRec
    '** End of modification 08-15-01 JJF
        '** Added 08-15-01 JJF
        'Update the status
        goProgressBar.Progress = (lCnt / lTotRec) * 100
        '** End of add 08-15-01 JJF
        
        'Remove the object from the collection
        Remove 1
        
        DoEvents    '** Added 08-15-01 JJF
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
'\\ Description:    This routine is used to add new questionaires to
'\\                 the collection.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     sBarCode        String  Specifies the barcode of the questionaire
'\\                             to be added to the collection.
'\\     sResponseString String  The complete line from the response file
'\\                             for this questionaire.
'\\     sBatchNumber    String  The batch number that this questionaire
'\\                             is being processed in.  This can later
'\\                             be used to determine the TIF filenames.
'\\     lLineNumber     Long    The line number of this response string
'\\                             within the batch file.  This can later
'\\                             be used to determine the TIF filenames.
'\\
'\\ Return Value:
'\\     Type            Description
'\\     CQuestionaire   A reference to the newly added questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function Add(ByVal sBarCode As String, _
                    ByVal sResponseString As String, _
                    ByVal sBatchNumber As String, _
                    ByVal lLineNumber As Long) As CQuestionaire
    
    Dim sKey          As String
    Dim oQuestionaire As CQuestionaire
    
    'Create a new object
    Set oQuestionaire = New CQuestionaire
    
    'set the properties passed into the method
    With oQuestionaire
        .Barcode = sBarCode
        .Questions.ResponseString = sResponseString
        .BatchNumber = sBatchNumber
        .LineNumber = lLineNumber
        sKey = "LC" & .LithoCode
        .Key = sKey
    End With
    
    'Check to see if this one is in the collection already
    If Item(sKey) Is Nothing Then
        'Add this questionaire to the collection
        moQuestionaires.Add oQuestionaire, sKey
    End If
    
    'Return the object created
    Set Add = oQuestionaire
    Set oQuestionaire = Nothing
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Item
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns a reference to the requested questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Item(ByVal vIndexKey As Variant) As CQuestionaire
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = moQuestionaires(vIndexKey)
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
'\\ Description:    Returns the total quantity of questionaires in this
'\\                 collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Count() As Long
    
    Count = moQuestionaires.Count
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Remove
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Removes the specified questionaire from the collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     vIndexKey   Variant     Either the KEY or INDEX of the questionaire
'\\                             to be removed from the collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Remove(ByVal vIndexKey As Variant)
    
    moQuestionaires.Remove vIndexKey
    
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
    
    Set NewEnum = moQuestionaires.[_NewEnum]
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   VerifyBatchImageCount
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-19-2000
'\\
'\\ Description:    This routine is used to determine if the correct
'\\                 number of images are present for the number of
'\\                 result strings in the batch file.
'\\
'\\ Parameters:
'\\     Name        Type    Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  if the quantity of images matches the quantity
'\\                       of result strings * quantity of images per.
'\\                 FALSE if this does not match up.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     10-21-04    JJF     Added code to ignore the 'attached.map'
'\\                         file that the new version of FAQSS places
'\\                         in the image folder.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function VerifyBatchImageCount() As Boolean
    
    '** Added 08-06-14 CAA
    Dim nDoVerifyBatchImageCount As Integer
    OpenDBConnection oConn:=goConn, sConnString:=goRegMainDBConnString.Value
    nDoVerifyBatchImageCount = GetQualProParamNum(sParamName:="DoVerifyImageCount", oConn:=goConn)
    
    'Assume count matches
    VerifyBatchImageCount = True
        
    If nDoVerifyBatchImageCount = 1 Then
        
        Dim sImageRoot  As String
        Dim sGroupName  As String
        Dim sFileName   As String
        Dim nGroupCnt   As Integer
        
        Dim asImageGroups() As String
        
        'Set the error trap
        On Error GoTo ErrorHandler
        
        'Get the root path to the images
        sImageRoot = BatchImageFilePath
        
        'Get all of the image groups
        nGroupCnt = 0
        ReDim asImageGroups(nGroupCnt) As String
        
        sGroupName = Dir$(sImageRoot, vbDirectory)
        Do Until Len(sGroupName) = 0
            '** Modified 10-21-04 JJF
            'If Left(sGroupName, 1) <> "." Then
            If Left(sGroupName, 1) <> "." And IsNumeric(sGroupName) Then
            '** End of modification 10-21-04 JJF
                'Add this group
                nGroupCnt = nGroupCnt + 1
                ReDim Preserve asImageGroups(nGroupCnt) As String
                asImageGroups(nGroupCnt) = sImageRoot & sGroupName & "\"
            End If
            
            'Prepare for next pass
            sGroupName = Dir$()
        Loop
        
        'Determine the quantity of images in this batch
        mnQtyImagesFound = 0
        For nGroupCnt = 1 To UBound(asImageGroups)
            sFileName = Dir$(asImageGroups(nGroupCnt) & "*.*", vbNormal)
            Do Until Len(sFileName) = 0
                'Increment the image count
                mnQtyImagesFound = mnQtyImagesFound + 1
                
                'Prepare for next pass
                sFileName = Dir$()
            Loop
        Next nGroupCnt
        
        'Cleanup
        Erase asImageGroups
        
        'Set return value
        VerifyBatchImageCount = (mnQtyImagesFound = (Count * QtyImagesPerQuestionaire))
    End If
    
Exit Function


ErrorHandler:
    mnQtyImagesFound = -1
    VerifyBatchImageCount = False
    Exit Function
    
End Function

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
    Set moQuestionaires = New Collection
    
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
    Set moQuestionaires = Nothing
    
End Sub

