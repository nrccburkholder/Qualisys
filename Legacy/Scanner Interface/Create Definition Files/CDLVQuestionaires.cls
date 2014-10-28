VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CDLVQuestionaires"
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
'\\ File Name:      CDLVQuestionaires.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the object definition that is used
'\\                 to collect and process deliverable questionaires.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     09-06-00    JJF     Added process logging.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     08-18-06    JJF   * Added code to get ScanBatch if it is on the
'\\                         first line of the DLV file.
'\\                       * Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
        
    'local variable(s) to hold property value(s)
    Private msUnProcessedFilePath   As String
    Private msIncompleteFilePath    As String
    Private msProcessedFilePath     As String
    Private msProcessedHoldFilePath As String
    Private msQDefTXTFilePath       As String
    Private msLogFilePath           As String
    Private msFileName              As String
    Private msQDefTXTFilePathUS     As String
    Private msImageFilePathUS       As String
    Private msImageFilePathCA       As String
    
    'local variable to hold collection
    Private moQuestionaires As Collection
    
    'Other local variables
    Private mlImagesPresent         As Long
    Private mlGoodLithos            As Long
    Private mlIgnoredLithos         As Long
    Private mlErrorLithos           As Long
    Private msScanBatch             As String
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ImageFilePathCA
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Sets the path to where the image files are stored
'\\                 in CA so they can be moved to the US.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ImageFilePathCA(ByVal sData As String)
    
    msImageFilePathCA = sData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ImageFilePathUS
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Sets the path to where the image files are stored
'\\                 in the US so they can be moved from CA.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ImageFilePathUS(ByVal sData As String)
    
    msImageFilePathUS = sData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QDefTXTFilePathUS
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Sets the path to where the Question Definition
'\\                 files are stored in the US for Canadian surveys.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let QDefTXTFilePathUS(ByVal sData As String)
    
    msQDefTXTFilePathUS = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QDefTXTFilePath
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets the path to where the Question Definition
'\\                 files are stored.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let QDefTXTFilePath(ByVal sData As String)
    
    msQDefTXTFilePath = sData
    
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
'\\                         method and added listings of the barcodes
'\\                         and lithocodes at the end of the file for
'\\                         debugging purposes.
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
'\\     09-16-00    JJF     Modified to account for new minimal file
'\\                         generation method.
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
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function LithoInList() As String
    
    Dim sInList         As String
    Dim oQuestionaire   As CQuestionaire
    
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
'\\     08-18-00    JJF   * Added the Survey_id and strTemplateCode to
'\\                         the select statement and the CQuestionaire
'\\                         object.
'\\                       * Added progress indication.
'\\     12-20-00    JJF     Added KeepMultiReturns property.
'\\     10-17-01    JJF     Added IncludeComments to the Questionaire
'\\                         object.
'\\     03-07-02    JJF   * Added the QFSurveyID to the select query.
'\\                       * Cleaned up the revision markers as the
'\\                         code was getting difficult to read.
'\\     04-03-02    JJF   * Added datUndeliverable to the query.
'\\                       * Modified so the Survey IDs in
'\\                         CommentStartDates are the ones we do not
'\\                         process.
'\\     07-22-02    JJF     Removed the datResultsImported from the
'\\                         determination of whether or not the survey
'\\                         is a ReScan.  It is now based solely on the
'\\                         datReturned field.
'\\     08-25-04    JJF   * Changed select statement to a stored procedure.
'\\                       * Added the DateExpired property.
'\\     08-07-05    JJF     Modified to work in Canada.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub GetAdditionalInfo()
    
    Dim sSql            As String
    Dim oTempRs         As ADODB.Recordset
    Dim oQuestionaire   As CQuestionaire
    Dim lCurRec         As Long
    Dim dtStartDate     As Date
    Dim oInfoCm         As ADODB.Command
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Getting Deliverable Info for " & FileName & "..."
    End With
    
    'Setup the comment info command
    Set oInfoCm = New ADODB.Command
    With oInfoCm
        .CommandText = "sp_SI_CDFGetAddInfoDLV"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("LithoInList", adVarChar, adParamInput, 7000)
    End With 'oInfoCm
    
    'Get the remaining info from the database
    oInfoCm.Parameters("LithoInList") = LithoInList
    Set oTempRs = oInfoCm.Execute
    
    'Loop through the recordset
    lCurRec = 0
    With oTempRs
        Do Until .EOF
            'Get a reference to the Questionaire
            lCurRec = lCurRec + 1
            If (lCurRec Mod 10) = 0 Then DoEvents
            goProgressBar.Progress = (lCurRec / Count) * 100
            Set oQuestionaire = Item("LC" & !strLithoCode)
            
            'Set the properties
            If Not (oQuestionaire Is Nothing) Then
                oQuestionaire.SentMailID = IIf(IsNull(!SentMail_id), -1, !SentMail_id)
                oQuestionaire.QuestionFormID = IIf(IsNull(!QuestionForm_Id), -1, !QuestionForm_Id)
                oQuestionaire.ReScan = IIf(Not IsNull(!datReturned), True, False)
                oQuestionaire.KeepMultiReturns = IIf(IsNull(!bitMultReturns), False, !bitMultReturns)
                oQuestionaire.SurveyID = IIf(IsNull(!QFSurveyID), -1, !QFSurveyID)
                oQuestionaire.DateUndeliverable = IIf(IsNull(!datUndeliverable), #1/1/1900#, !datUndeliverable)
                oQuestionaire.DateExpired = IIf(IsNull(!datExpire), #12/30/2100#, !datExpire)
                oQuestionaire.WhereIsIt = IIf(IsNull(!Country_id), cccUS, !Country_id)
                If IsNull(!Survey_id) Then
                    'This survey is not in the table so we want to
                    '  include the comments
                    oQuestionaire.IncludeComments = True
                Else
                    'This survey is in the table so we do not want to
                    '  include the comments
                    oQuestionaire.IncludeComments = False
                End If
            End If
            
            'Prepare for the next pass
            Set oQuestionaire = Nothing
            .MoveNext
        Loop
    End With
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    Set oInfoCm = Nothing
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorGetAddInfoFailed, _
              Source:="CDLVQuestionaires::GetAdditionalInfo", _
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
'\\     09-06-00    JJF     Added process logging.
'\\     02-20-03    JJF     Changed so that the read file is copied to
'\\                         a holding location for recovery later if
'\\                         required.
'\\     08-18-06    JJF   * Removed revision notes.
'\\                       * Added code to get ScanBatch if it is on the
'\\                         first line of the DLV file.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function LoadFromFile() As Boolean
    
    Dim sTextLine   As String
    Dim lFileHandle As Long
    Dim lLockHandle As Long
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Place a lock on the DLV files
    lLockHandle = LockFiles(sLockFileName:=msUnProcessedFilePath & "dlv.lck", _
                            bWaitForever:=True)
    
    'If we were unable to lock the files then we are going to head out of dodge
    If lLockHandle < 0 Then
        LoadFromFile = False
        Exit Function
    End If
    
    'Let's get a filename to process
    msFileName = Dir$(msUnProcessedFilePath & "*.dlv")
    
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
                mlImagesPresent = mlImagesPresent + 1
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
              Source:="CDLVQuestionaires::LoadFromFile", _
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
'\\                 of the questionaires in the collection.  When this
'\\                 process is complete there will be a Question
'\\                 Definition file for each questionaire processed.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF   * Added CommandTimeout = 0 on the command
'\\                         object and transactions to the updates.
'\\                       * Also changed the way minimal files are
'\\                         are generated so that they are based on the
'\\                         actual requirements of the specified
'\\                         questionaire.
'\\     08-18-00    JJF   * Moved creation of the minimal files up into
'\\                         the if block so that they are created as
'\\                         they are encountered.  This eliminates the
'\\                         need for the second pass through the
'\\                         collection and creates the files in the
'\\                         order that FAQSS is waiting for them.
'\\                       * Added code to create an error file in place
'\\                         of the definition file when an error is
'\\                         encountered or a condition that does not
'\\                         allow us to create the definition file.
'\\                       * Added code to verify that all of the images
'\\                         exist for this questionaire.  If they do not
'\\                         then we create one of the new error files.
'\\                       * Added progress indication.
'\\                         << ALSO REMOVED REVISION TEXT BECAUSE THE >>
'\\                         << CODE WAS GETTING TO CLUTTERED TO READ. >>
'\\     09-06-00    JJF     Added process logging.
'\\     12-20-00    JJF     Added KeepMultiReturns property.
'\\     10-11-01    JJF     Removed the calls to WriteExportError as
'\\                         this data is no longer required.
'\\     03-07-02    JJF   * Changed to use the connection string stored
'\\                         in the local registry instead of the MTS
'\\                         object.
'\\                       * Removed the call to sp_si_FixBubblePos as
'\\                         it is no longer needed for the new PCLGen.
'\\     04-03-02    JJF     Added a check to see if this questionaire
'\\                         has already been marked as undeliverable.
'\\     08-25-04    JJF     Removed the delete from scheduled mailing
'\\                         as this is now taken care of with a trigger.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     08-18-06    JJF   * Removed revision notes.
'\\                       * Added code to get ScanBatch if it is on the
'\\                         first line of the DLV file.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Process()
    
    Dim sSql                    As String
    Dim sFileName               As String
    Dim sImagesValid            As String
    Dim bTransInProcess         As Boolean
    Dim oQuestionaire           As CQuestionaire
    Dim oReturnDateCm           As ADODB.Command
    Dim lCurRec                 As Long
    Dim bDefinitionFileCopied   As Boolean
    Dim bImageFilesCopied       As Boolean
    Dim sTempFile               As String
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsProgressBar
        .Status = "Updating Deliverables for " & FileName & "..."
    End With
    
    'Setup the Return Date command
    Set oReturnDateCm = New ADODB.Command
    With oReturnDateCm
        .CommandText = "sp_SI_CDFSetDateReturnedDLV"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("ScanBatch", adVarChar, adParamInput, 100)
    End With 'oReturnDateCm
    
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
                
                'Create the error file
                If geCountry <> cccUS Then
                    'We only create the error file if we are not in the US.  If we are in the US
                    '  we are assuming that the complete definition file was created in the appropriate
                    '  country and moved here, so if we created an error file it would overwrite the
                    '  good one.  That would be bad... Very Very Bad!!!
                    .ErrorString = "CDLVQuestionaires::Process - Error #" & eecLithoForDifferentCountry & ": LithoCode: " & .LithoCode & " is not for this country"
                    .WriteERRFile sFilePath:=msQDefTXTFilePath
                End If
                
                mlErrorLithos = mlErrorLithos + 1
            ElseIf Not .IsBarcodeValid Then
                'The barcode is invalid
                
                'Create the error file
                .ErrorString = "CDLVQuestionaires::Process - Error #" & eecInvalidBarcode & ": Invalid Barcode Checkdigit"
                .WriteERRFile sFilePath:=msQDefTXTFilePath
                
                mlErrorLithos = mlErrorLithos + 1
            ElseIf .SentMailID < 0 Then
                'The SentMail_id is invalid
                
                'Create the error file
                .ErrorString = "CDLVQuestionaires::Process - Error #" & eecNoSentMailingRecord & ": No SentMailing Record Exists for this LithoCode"
                .WriteERRFile sFilePath:=msQDefTXTFilePath
                
                mlErrorLithos = mlErrorLithos + 1
            ElseIf .QuestionFormID < 0 Then
                'The QuestionForm_id is invalid
                
                'Create the error file
                .ErrorString = "CDLVQuestionaires::Process - Error #" & eecNoQuestionFormRecord & ": No QuestionForm Record Exists for this LithoCode"
                .WriteERRFile sFilePath:=msQDefTXTFilePath
                
                mlErrorLithos = mlErrorLithos + 1
            ElseIf .DateUndeliverable > CDate("01/02/1900") Then
                'This questionaire has already been marked as undeliverable
                
                'Create the error file
                .ErrorString = "CNDLQuestionaires::Process - Error #" & eecAlreadyMarkedUndeliverable & ": This LithoCode has already been marked as Undeliverable!"
                .WriteERRFile sFilePath:=msQDefTXTFilePath
                
                mlErrorLithos = mlErrorLithos + 1
            ElseIf .ReScan Then
                'This questionaire has already been scanned
                
                'Create the error file
                .ErrorString = "CDLVQuestionaires::Process - Error #" & urcAlreadyScanned & ": This LithoCode has already been scanned"
                .WriteERRFile sFilePath:=msQDefTXTFilePath
                .ErrorString = ""
                
                'Write the error condition to the DB
                WriteQFormError lQuestionFormID:=.QuestionFormID, _
                                eReturnCode:=urcAlreadyScanned, _
                                sBatchNumber:=BatchNumber
                mlIgnoredLithos = mlIgnoredLithos + 1
            ElseIf .OtherStepReturned And Not .KeepMultiReturns Then
                'A previous mailing step has already been returned
                
                'Create the error file
                .ErrorString = "CDLVQuestionaires::Process - Error #" & urcOtherStepReturned & ": This LithoCode already has another mailing step returned"
                .WriteERRFile sFilePath:=msQDefTXTFilePath
                .ErrorString = ""
                
                'Write the error condition to the DB
                WriteQFormError lQuestionFormID:=.QuestionFormID, _
                                eReturnCode:=urcOtherStepReturned, _
                                sBatchNumber:=BatchNumber
                mlIgnoredLithos = mlIgnoredLithos + 1
            ElseIf .ReturnAfterExpire Then
                'This questionaire has already expired
                
                'Create the error file
                .ErrorString = "CDLVQuestionaires::Process - Error #" & urcReturnAfterExpire & ": This LithoCode was returned after it expired"
                .WriteERRFile sFilePath:=msQDefTXTFilePath
                .ErrorString = ""
                
                'Write the error condition to the DB
                WriteQFormError lQuestionFormID:=.QuestionFormID, _
                                eReturnCode:=urcReturnAfterExpire, _
                                sBatchNumber:=BatchNumber
                mlIgnoredLithos = mlIgnoredLithos + 1
            Else
                'No errors were encountered so lets do the updates
                
                'Build the TXT file
                .BuildTXTFile
                
                'Verify the images
                If .ValidateImages(sMessage:=sImagesValid) Then
                    'The images are valid so proceed
                    'Start the trasaction
                    goConn.BeginTrans
                    bTransInProcess = True
                    
                    'Update the Return Date in the QuestionForm table
                    oReturnDateCm.Parameters("QuestionFormID") = .QuestionFormID
                    oReturnDateCm.Parameters("ScanBatch") = msScanBatch
                    oReturnDateCm.Execute
                    
                    'Write the finished questionaire TXT file to disk
                    .WriteTXTFile sFilePath:=msQDefTXTFilePath
                    
                    'Get the file name
                    sFileName = LithoToBarcode(lLithoCode:=.LithoCode)
                    
                    'Move the file to the appropriate location
                    bDefinitionFileCopied = False
                    bImageFilesCopied = False
                    Select Case geCountry
                        Case cccUS
                            'We are in the US
                            'Files are already in the appropriate location
                        
                        Case cccCanada
                            'We are in Canada
                            
                            'Copy the definition file to the US
                            FileCopy msQDefTXTFilePath & sFileName & ".txt", msQDefTXTFilePathUS & sFileName & ".txt"
                            bDefinitionFileCopied = True
                            
                            'Delete the original definition file
                            Kill msQDefTXTFilePath & sFileName & ".txt"
                            
                            'Copy the image files to the US
                            sTempFile = Dir$(msImageFilePathCA & sFileName & "*.*", vbNormal)
                            Do While sTempFile <> ""
                                'Copy the file to the US
                                FileCopy msImageFilePathCA & sTempFile, msImageFilePathUS & sTempFile
                                bImageFilesCopied = True
                                
                                'Kill the original file
                                Kill msImageFilePathCA & sTempFile
                                
                                'Get the next file name
                                sTempFile = Dir$()
                            Loop
                            
                    End Select
                    
                    'If all was okey dokey then commit
                    goConn.CommitTrans
                    bTransInProcess = False
                    bDefinitionFileCopied = False
                    bImageFilesCopied = False
                    mlGoodLithos = mlGoodLithos + 1
                Else
                    'The images are not valid so create an error file
                    .ErrorString = "CDLVQuestionaires::Process - Error #" & iecErrorInvalidImages & ": " & sImagesValid
                    .WriteERRFile sFilePath:=msQDefTXTFilePath
                    mlErrorLithos = mlErrorLithos + 1
                End If
            End If
            
            'If we made it to here then this questionaire is finished
            DoEvents
        End With 'oQuestionaire
        
ResumeFromError:
    Next oQuestionaire
    
    'Move the file from holding to completed
    FileCopy msProcessedHoldFilePath & msFileName, msProcessedFilePath & msFileName
    Kill msProcessedHoldFilePath & msFileName
    
    'Cleanup
    Set oQuestionaire = Nothing
    Set oReturnDateCm = Nothing
    
Exit Sub


ErrorHandler:
    If bTransInProcess Then
        goConn.RollbackTrans
        bTransInProcess = False
    End If
    
    If bDefinitionFileCopied Then
        Kill msQDefTXTFilePathUS & sFileName & ".txt"
        bDefinitionFileCopied = False
    End If
    
    If bImageFilesCopied Then
        sTempFile = Dir$(msImageFilePathUS & sFileName & "*.*", vbNormal)
        Do While sTempFile <> ""
            'Move the files back to this location
            FileCopy msImageFilePathUS & sTempFile, msImageFilePathCA & sTempFile
            
            'Delete the file
            Kill msImageFilePathUS & sTempFile
            
            'Get the next file name
            sTempFile = Dir$()
        Loop
        bImageFilesCopied = False
    End If
    
    oQuestionaire.ErrorString = "CDLVQuestionaires::Process - Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    oQuestionaire.WriteERRFile sFilePath:=msQDefTXTFilePath
    mlErrorLithos = mlErrorLithos + 1
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
                        LPad(sString:=mlImagesPresent, nLength:=10) & _
                        LPad(sString:=mlGoodLithos, nLength:=10) & _
                        LPad(sString:=mlIgnoredLithos, nLength:=10) & _
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
'\\     08-18-00    JJF     Modified so that it sets the image count
'\\                         for each barcode processed.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function Add(ByVal sBarCode As String) As CQuestionaire
    
    'Create a new object
    Dim sKey            As String
    Dim nPageNo         As Integer
    Dim oQuestionaire   As CQuestionaire
    Dim oTemp           As CQuestionaire
    
    'Get the page number
    nPageNo = Val(Mid(sBarCode, 7, 1))
    
    'Set the properties passed into the method
    Set oQuestionaire = New CQuestionaire
    With oQuestionaire
        'Set the passed in parameters
        .Barcode = sBarCode
        .IncrementImageCount nPageNo:=nPageNo
        sKey = "LC" & .LithoCode
        .Key = sKey
    End With
    
    'Check to see if this one is in the collection already
    Set oTemp = Item(sKey)
    If oTemp Is Nothing Then
        'Add this questionaire to the collection
        moQuestionaires.Add oQuestionaire, sKey
    Else
        'Set the flag for this image
        oTemp.IncrementImageCount nPageNo:=nPageNo
    End If
    
    'Return the object created
    Set Add = oQuestionaire
    Set oQuestionaire = Nothing
    Set oTemp = Nothing
    
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

