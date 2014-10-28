VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CNDLQuestionaires"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"CNDLQuestionaire"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CNDLQuestionaires.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the object definition that is used
'\\                 to collect and process undeliverable questionaires.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     09-06-00    JJF     Added process logging.
'\\     08-18-06    JJF   * Added code to get ScanBatch if it is on the
'\\                         first line of the NDL file.
'\\                       * Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
        
    'local variable(s) to hold property value(s)
    Private msUnProcessedFilePath   As String
    Private msIncompleteFilePath    As String
    Private msProcessedFilePath     As String
    Private msProcessedHoldFilePath As String
    Private msLogFilePath           As String
    Private msFileName              As String
    
    'local variable to hold collection
    Private moQuestionaires As Collection
    
    'Other local variables
    Private mdtUndeliverableDate    As Date
    Private mlGoodLithos            As Long
    Private mlErrorLithos           As Long
    Private msScanBatch             As String
    
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
'\\     06-19-00    JJF     Modified for new minimal file generation
'\\                         method and added new listings of the
'\\                         barcodes and litho codes to the end of
'\\                         the file for debugging purposes.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub OutputErrors()
    
    Dim lFileHandle     As Long
    Dim oQuestionaire   As CQuestionaire
    
    'Get a file handle
    lFileHandle = FreeFile
    
    'Open the output file
    Open msIncompleteFilePath & msFileName For Output As #lFileHandle
    
    'Write the file header
    Print #lFileHandle, "Barcode   Litho Code  SentMail_id  QuestionForm_id  Error String"
    Print #lFileHandle, "--------  ----------  -----------  ---------------  ------------"
    
    'Write all of the incomplete questionaires
    For Each oQuestionaire In moQuestionaires
        With oQuestionaire
            If Len(Trim(.ErrorString)) > 0 Then
                Print #lFileHandle, RPad(.Barcode, 10) & _
                                    LPad(.LithoCode, 10) & _
                                    LPad(.SentMailID, 13) & _
                                    LPad(.QuestionFormID, 17) & _
                                    LPad(.ErrorString, Len(.ErrorString) + 2)
            End If
        End With
    Next oQuestionaire
    
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
                Print #lFileHandle, "'" & .LithoCode & "',"
            End If
        End With
    Next oQuestionaire
    
    'Close the output file and cleanup
    Close #lFileHandle
    Set oQuestionaire = Nothing
    
End Sub

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
'\\     06-19-00    JJF     Modified for new minimal file generation
'\\                         method.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ErrorCount() As Long
    
    Dim lErrorCnt       As Long
    Dim oQuestionaire   As CQuestionaire
    
    'Determine how many questionaires have errors
    For Each oQuestionaire In moQuestionaires
        If Len(Trim(oQuestionaire.ErrorString)) > 0 Then
            lErrorCnt = lErrorCnt + 1
        End If
    Next oQuestionaire
    
    'Cleanup
    Set oQuestionaire = Nothing
    ErrorCount = lErrorCnt
    
End Property




'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  FileName
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns the filename for the questionaire batch
'\\                 that this object is processing.
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
'\\     08-24-12    JJF     Added nMaxLength and lNextLitho so we can
'\\                         loop through the collection and never make
'\\                         the sInList longer than the nMaxLength.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'Private Function LithoInList() As String                                                       'Removed 08-24-12 JJF
Private Function LithoInList(ByVal nMaxLength As Integer, ByRef lNextLitho As Long) As String   'Added 08-24-12 JJF
    
    Dim sInList         As String
    Dim oQuestionaire   As CQuestionaire
    Dim lCnt            As Integer                              'Added 08-24-12 JJF
    
    'Build a comma delimited list of the LithoCodes
    'For Each oQuestionaire In moQuestionaires                  'Removed 08-24-12 JJF
    '    With oQuestionaire
    '        If Len(sInList) = 0 Then
    '            sInList = "'" & .LithoCode & "'"
    '        Else
    '            sInList = sInList & ",'" & .LithoCode & "'"
    '        End If
    '    End With
    'Next oQuestionaire
    For lCnt = lNextLitho To moQuestionaires.Count              'Added 08-24-12 JJF
        'Get the questionaire
        Set oQuestionaire = moQuestionaires(lCnt)
        
        With oQuestionaire
            'Add this litho to the list
            If Len(sInList) = 0 Then
                sInList = "'" & .LithoCode & "'"
            Else
                sInList = sInList & ",'" & .LithoCode & "'"
            End If
            
            'Determine if we are done yet
            If lCnt < moQuestionaires.Count Then
                'We have not reached the end of the collection yet so check the length of the string
                If (Len(sInList) + Len(moQuestionaires(lCnt + 1).LithoCode) + 3) > nMaxLength Then
                    'We have reached the maximum lenth for the list so we are out of here
                    lNextLitho = lCnt + 1
                    Exit For
                End If
            Else
                'We have reached the end of the collection so we are out of here
                lNextLitho = -1
                Exit For
            End If
        End With
    Next lCnt
    
    'Cleanup
    Set oQuestionaire = Nothing
    LithoInList = sInList
    
End Function

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
'\\ Property Name:  ProcessedFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets the path to where the processed barcode files
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
'\\ Property Name:  IncompleteFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets the path to where the incomplete barcode files
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
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets the path to where the unprocessed barcode files
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
'\\     04-03-02    JJF     Added datReturned to the query.
'\\     08-18-06    JJF   * Changed to use stored procedure.
'\\                       * Removed revision notes.
'\\     08-24-12    JJF     Changed code to make sure the parameter to
'\\                         stored procedure never exceeds the
'\\                         knMaxLithoInList length.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub GetAdditionalInfo()
    
    Dim sSql            As String
    Dim oTempRs         As ADODB.Recordset
    Dim oQuestionaire   As CQuestionaire
    Dim lCurRec         As Long
    Dim oInfoCm         As ADODB.Command
    Dim lNextLitho      As Long                 'Added 08-24-12 JJF
    
    Const knMaxLithoInList As Integer = 7000    'Added 08-24-12 JJF
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Getting Non-Deliverable Info for " & FileName & "..."
    End With
    
    'Setup the info command
    Set oInfoCm = New ADODB.Command
    With oInfoCm
        .CommandText = "sp_SI_CDFGetAddInfoNDL"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goConn
        '.Parameters.Append .CreateParameter("LithoInList", adVarChar, adParamInput, 7000)              'Removed 08-24-12 JJF
        .Parameters.Append .CreateParameter("LithoInList", adVarChar, adParamInput, knMaxLithoInList)   'Added 08-24-12 JJF
    End With 'oInfoCm
    
    'Get the remaining info from the database
    lNextLitho = 1                                      'Added 08-24-12 JJF
    lCurRec = 0                                         'Added 08-24-12 JJF
    'oInfoCm.Parameters("LithoInList") = LithoInList    'Removed 08-24-12 JJF
    Do While lNextLitho > -1                            'Added 08-24-12 JJF
        oInfoCm.Parameters("LithoInList") = LithoInList(knMaxLithoInList, lNextLitho)  'Added 08-24-12 JJF
        Set oTempRs = oInfoCm.Execute
        
        'Loop through the recordset
        'lCurRec = 0                                    'Removed 08-24-12 JJF
        With oTempRs
            Do Until .EOF
                'Get a reference to the Questionaire
                lCurRec = lCurRec + 1
                goProgressBar.Progress = (lCurRec / Count) * 100
                Set oQuestionaire = Item("LC" & !strLithoCode)
                
                'Set the properties
                If Not (oQuestionaire Is Nothing) Then
                    oQuestionaire.SentMailID = IIf(IsNull(!SentMail_id), -1, !SentMail_id)
                    oQuestionaire.QuestionFormID = IIf(IsNull(!QuestionForm_Id), -1, !QuestionForm_Id)
                    oQuestionaire.DateReturned = IIf(IsNull(!datReturned), #1/1/1900#, !datReturned)
                End If
                
                'Prepare for the next pass
                Set oQuestionaire = Nothing
                .MoveNext
            Loop
        End With
        
        'Cleanup
        oTempRs.Close: Set oTempRs = Nothing
    Loop        'Added 08-24-12 JJF
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorGetAddInfoFailed, _
              Source:="CNDLQuestionaires::GetAdditionalInfo", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description

End Sub


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
'\\     Name        Type        Description
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
'\\     08-18-06    JJF   * Removed revision notes.
'\\                       * Added code to get ScanBatch if it is on the
'\\                         first line of the NDL file.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function LoadFromFile() As Boolean
    
    Dim sTextLine   As String
    Dim lFileHandle As Long
    Dim lLockHandle As Long
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Place a lock on the NDL files
    lLockHandle = LockFiles(sLockFileName:=msUnProcessedFilePath & "ndl.lck", _
                            bWaitForever:=False)
    
    'If we were unable to lock the files then we are going to head out of dodge
    If lLockHandle < 0 Then
        LoadFromFile = False
        Exit Function
    End If
    
    'Let's get a filename to process
    msFileName = Dir$(msUnProcessedFilePath & "*.ndl")
    
    'If there are no files to process then head out of dodge
    If msFileName = "" Then
        UnlockFiles lFileHandle:=lLockHandle
        LoadFromFile = False
        Exit Function
    End If
    
    'We have a file to deal with so get on with it
    'Get the file creation date
    mdtUndeliverableDate = FileDateTime(msUnProcessedFilePath & msFileName)
    
    'Open the file
    lFileHandle = FreeFile
    Open msUnProcessedFilePath & msFileName For Input As #lFileHandle
    
    'Read in the barcodes and add them to the collection
    msScanBatch = ""
    While Not EOF(lFileHandle)
        'Get a line from the file
        Line Input #lFileHandle, sTextLine
        
        'Determine if this is the scan batch line or a barcode line
        If UCase(Left(Trim(sTextLine), 5)) = "PATH:" Then
            'This is the scan batch line so capture it
            msScanBatch = Mid(Trim(sTextLine), 6)
        Else
            'Add this barcode to the collection
            If Len(Trim(sTextLine)) > 0 Then
                Add sBarCode:=sTextLine
            End If
        End If
    Wend
    
    'Close the file
    Close #lFileHandle
    
    'Now lets move the file to the processed file location
    FileCopy msUnProcessedFilePath & msFileName, msProcessedHoldFilePath & msFileName
    Kill msUnProcessedFilePath & msFileName
    
    'Unlock the file so other processes can continue
    UnlockFiles lFileHandle:=lLockHandle
    
    'Cleanup
    LoadFromFile = True
    
Exit Function


ErrorHandler:
    Err.Raise Number:=iecErrorLoadFromFileFailed, _
              Source:="CNDLQuestionaires::LoadFromFile", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description

End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Process
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called to do the final processing
'\\                 of the questionaires in the collection.  Here we
'\\                 update the database to indicate that the questionaires
'\\                 were returned as undeliverable.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Added CommandTimeout = 0 on the command
'\\                         object and transactions to the updates and
'\\                         removed check for QuestionForm record as
'\\                         it is not needed for a non-deliverable.
'\\     08-18-00    JJF     Added progress indication.
'\\     09-06-00    JJF     Added process logging.
'\\     10-11-01    JJF     Removed the calls to WriteExportError as
'\\                         this data is no longer required.
'\\     04-03-02    JJF     Added a check to see if the questionaire
'\\                         has already been marked as returned.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     10-31-05    JJF   * Removed revision notes.
'\\                       * Modified Scheduled Mailing command so it
'\\                         does not delete scheduled phone/web steps,
'\\                         only mail steps.
'\\     08-18-06    JJF   * Changed to use stored procedures
'\\                       * Added code to get ScanBatch if it is on the
'\\                         first line of the NDL file.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Process()
    
    Dim bTransInProcess As Boolean
    Dim oQuestionaire   As CQuestionaire
    Dim oUndelDateCm    As ADODB.Command
    Dim lCurRec         As Long
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Updating Non-Deliverables for " & FileName & "..."
    End With
    
    'Setup the Undeliverable Date command
    Set oUndelDateCm = New ADODB.Command
    With oUndelDateCm
        .CommandText = "sp_SI_CDFSetUndeliverableDateNDL"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("SentMailID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("UndeliverableDate", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("ScanBatch", adVarChar, adParamInput, 100)
    End With 'oUndelDateCm
    
    'Loop through all of the questionaires
    lCurRec = 0
    For Each oQuestionaire In moQuestionaires
        'Update the status
        lCurRec = lCurRec + 1
        goProgressBar.Progress = (lCurRec / Count) * 100
        
        With oQuestionaire
            'Process this questionaire
            If .WhereIsIt <> geCountry Then
                'This litho is for a different country so skip it.
                mlErrorLithos = mlErrorLithos + 1
            ElseIf Not .IsBarcodeValid Then
                'If the barcode is not valid then write the error and move on
                '  to the next questionaire
                mlErrorLithos = mlErrorLithos + 1
            ElseIf .SentMailID < 0 Then
                'The SentMail_id is invalid
                mlErrorLithos = mlErrorLithos + 1
            ElseIf .DateReturned > CDate("01/02/1900") Then
                'This questionaire has already been scanned
                mlErrorLithos = mlErrorLithos + 1
                .ErrorString = "CNDLQuestionaires::Process - Error #" & eecAlreadyMarkedReturned & ": This LithoCode has already been marked as returned!"
            Else
                'No errors were encountered so lets do the updates
                
                'Start the trasaction
                goConn.BeginTrans
                bTransInProcess = True
                
                'Update the undeliverable date
                oUndelDateCm.Parameters("SentMailID") = .SentMailID
                oUndelDateCm.Parameters("UndeliverableDate") = mdtUndeliverableDate
                oUndelDateCm.Parameters("ScanBatch") = msScanBatch
                oUndelDateCm.Execute
                
                'If all was okey dokey then commit
                goConn.CommitTrans
                bTransInProcess = False
                mlGoodLithos = mlGoodLithos + 1
            End If
        End With 'oQuestionaire
        
ResumeFromError:
    Next oQuestionaire
    
    'Move the file from holding to completed
    FileCopy msProcessedHoldFilePath & msFileName, msProcessedFilePath & msFileName
    Kill msProcessedHoldFilePath & msFileName
    
    'Cleanup
    Set oQuestionaire = Nothing
    Set oUndelDateCm = Nothing
    
Exit Sub


ErrorHandler:
    If bTransInProcess Then
        goConn.RollbackTrans
        bTransInProcess = False
    End If
    
    oQuestionaire.ErrorString = "CNDLQuestionaires::Process - Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    mlErrorLithos = mlErrorLithos + 1
    Resume ResumeFromError
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OutputLog
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   09-06-2000
'\\
'\\ Description:    This routine writes the results of the current
'\\                 batch to a log file for statistical tracking.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub OutputLog()
    
    Dim bExists     As Boolean
    Dim lFileHandle As Long
    Dim lLockHandle As Long
    Dim sFileName   As String
    Dim oUserInfo   As CUserInfo
    
    'Place a lock on the STR files
    lLockHandle = LockFiles(sLockFileName:=msLogFilePath & "CDFLog.lck", _
                            bWaitForever:=True)
    
    'Get the file name
    sFileName = msLogFilePath & Format(Now, "yyyymmdd") & "CDF.log"
    
    'Check to see if the log file exists
    If Dir$(sFileName, vbNormal) <> "" Then bExists = True
    
    'Open the file
    lFileHandle = FreeFile
    Open sFileName For Append As #lFileHandle
    
    'Initialize the user info object
    Set oUserInfo = New CUserInfo
    
    'Write the header if required
    If Not bExists Then
        Print #lFileHandle, "Filename      Type  Lithos    Images    Good      Ignored   Error     Date/Time            Computer/User                                     "
        Print #lFileHandle, "------------  ----  --------  --------  --------  --------  --------  -------------------  --------------------------------------------------"
    End If
    
    'Write the values for this batch
    Print #lFileHandle, RPad(sString:=FileName, nLength:=14) & _
                        RPad(sString:=UCase(Right(FileName, 3)), nLength:=4) & _
                        LPad(sString:=Count, nLength:=10) & _
                        LPad(sString:=0, nLength:=10) & _
                        LPad(sString:=mlGoodLithos, nLength:=10) & _
                        LPad(sString:=0, nLength:=10) & _
                        LPad(sString:=mlErrorLithos, nLength:=10) & "  " & _
                        RPad(sString:=Format(Now, "mm/dd/yyyy hh:nn:ss"), nLength:=21) & _
                        RPad(sString:=oUserInfo.ComputerName & "/" & oUserInfo.UserName, _
                             nLength:=50, bTruncate:=True)
    
    'Close the log file
    Close #lFileHandle
    Set oUserInfo = Nothing
    
    'Unlock the file so other processes can continue
    UnlockFiles lFileHandle:=lLockHandle
    
End Sub



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
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get BatchNumber() As String
    
    Dim sTemp   As String
    Dim nLoc    As Integer
    
    'Strip off the file extension
    sTemp = Trim(Left(msFileName, InStr(msFileName, ".") - 1))
    
    'Determine if the space cahracter is present and if so strip off everything before it
    nLoc = InStr(msFileName, " ")
    If nLoc > 0 Then
        sTemp = Trim(Mid(sTemp, nLoc + 1))
    End If
    
    'Return the remaining batch number
    BatchNumber = sTemp
    
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
'\\ Description:    This routine is used to add new questionaires to
'\\                 the collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sBarCode    String      Specifies the barcode of the questionaire
'\\                             to be added to the collection.
'\\
'\\ Return Value:
'\\     Type            Description
'\\     CQuestionaire   A reference to the newly added questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function Add(ByVal sBarCode As String) As CQuestionaire
    
    'Create a new object
    Dim sKey            As String
    Dim oQuestionaire   As CQuestionaire
    
    'Set the properties passed into the method
    Set oQuestionaire = New CQuestionaire
    With oQuestionaire
        'Set the passed in parameters
        .Barcode = sBarCode
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
    If Err.Number > 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  CountCountry
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Returns the quantity of questionaires in this
'\\                 collection that are from the specified country.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get CountCountry(ByVal eCountry As eCountryCodeConstants) As Long
    
    Dim lCount As Long
    Dim oQuestionaire As CQuestionaire
    
    lCount = 0
    
    For Each oQuestionaire In moQuestionaires
        If oQuestionaire.WhereIsIt = eCountry Then
            lCount = lCount + 1
        End If
    Next oQuestionaire
    
    CountCountry = lCount
    
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

