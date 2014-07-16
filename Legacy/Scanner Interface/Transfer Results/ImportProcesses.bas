Attribute VB_Name = "modImportProcesses"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      ImportProcesses.bas
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the routines that actually
'\\                 perform the IMPORT process.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Added a check to verify that we have the
'\\                         correct number of responses for the number
'\\                         of images in the batch.
'\\     09-06-00    JJF     Added a new path for log files.
'\\     02-20-03    JJF     Added Holding Path.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'Local variables that hold the various paths required
    Private msProcessedFilePath     As String
    Private msProcessedHoldFilePath As String       '** Added 02-20-03 JJF
    Private msUnProcessedFilePath   As String
    Private msIncompleteFilePath    As String
    Private msBatchImageFilePath    As String       '** Added 06-19-00 JJF
    Private msLogFilePath           As String       '** Added 09-06-00 JJF
    Private msCAUnProcessedFilePath As String       '** Added 05-27-05 JJF
    
    'Local constants used to retrieve paths from QualPro_Params
    Private Const mksScanImportProcRet      As String = "ScanImportProcRet"
    Private Const mksScanImportUnProcRet    As String = "ScanImportUnProcRet"
    Private Const mksScanImportIncomplete   As String = "ScanImportIncomplete"
    Private Const mksScanImportBatchImage   As String = "ScanImportBatchImage"  '** Added 06-19-00 JJF
    Private Const mksScanImportLog          As String = "ScanImportLog"         '** Added 09-06-00 JJF
    Private Const mksScanImportCAUnProcRet  As String = "ScanImportCAFinal"     '** Added 05-27-05 JJF
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   ProcessFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This is the main routine called by the form to
'\\                 process all files in the queue.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     sSTRFileName    String      The path and filename of the hand
'\\                                 entered STR file.  Empty string if
'\\                                 normal processing is to occur.
'\\     nLithoStart     Integer     Column within the STR line at which
'\\                                 the LithoCode starts in a non-qualpro
'\\                                 STR file.
'\\     nLithoLength    Integer     Width of the LithoCode entry in the
'\\                                 STR line for a non-QualPro STR file.
'\\     eTransferType   eTransferTypeConstants
'\\                                 Specified the type of transfer to be
'\\                                 performed.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Added a check to verify that we have the
'\\                         correct number of responses for the number
'\\                         of images in the batch.
'\\     08-18-00    JJF   * Added ability to run on multiple machines
'\\                         so this routine changed completely.
'\\                       * Added progress indication.
'\\     08-29-00    JJF     Added ability to deal with hand entered
'\\                         results.
'\\     09-06-00    JJF     Added a new path for log files.
'\\     06-12-01    JJF     Added ability to import non-qualpro string
'\\                         files.
'\\     08-13-01    JJF     Added the eTransferType parameter.
'\\     10-11-01    JJF   * Added code for dealing with comment boxes.
'\\                       * Removed all previous revision text as it
'\\                         was gettng to hard to read.
'\\     01-21-02    JJF     Load the HTML prefix and suffix for name
'\\                         masking.
'\\     01-28-02    JJF     Changed the way masking is done.
'\\     03-07-02    JJF   * Changed to use the connection string stored
'\\                         in the local registry instead of the MTS
'\\                         object.
'\\                       * Added code to open the new QP_Scan
'\\                         connection.
'\\                       * Added code to populate and cleanup the
'\\                         global collection lookup objects.
'\\     12-16-02    JJF     Added checkboxes to specify whether or not
'\\                         to process STR and/or VSTR files.
'\\     01-23-03    JJF     Added the capability to stop processing
'\\                         after the completion of the current batch.
'\\     02-20-03    JJF   * Added code to check time and quantity of
'\\                         running apps privileges.
'\\                       * Added a new file path to QPParams to identify
'\\                         the interim location of files to allow for
'\\                         recovery in the event of a PC lockup.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     10-31-05    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub ProcessFiles(ByVal sSTRFileName As String, _
                        ByVal nLithoStart As Integer, _
                        ByVal nLithoLength As Integer, _
                        ByVal eTransferType As eTransferTypeConstants, _
                        ByVal bTransferSTR As Boolean, _
                        ByVal bTransferVSTR As Boolean)

    Dim sMsg            As String
    Dim bSTRContinue    As Boolean
    Dim bVSTRContinue   As Boolean
    Dim nCnt            As Integer
    Dim oUserInfo       As New UserInfo.CUserInfo
    Dim oUserStuff      As New CUserInfo
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsPleaseWait
        .Status = "Opening Database Connections..."
    End With
    
    'Open the database connection
    OpenDBConnection oConn:=goConn, sConnString:=goRegMainDBConnString.Value
    OpenDBConnection oConn:=goScanConn, sConnString:=GetScanDBConnString()
    
    'Read in the Read Method table lookups
    Set goReadMethods = New CReadMethods
    goReadMethods.PopulateFromDB
    
    'Set file paths
    goProgressBar.Status = "Getting Path Information..."
    #If bOverridePaths Then
        msProcessedFilePath = "E:\FAQSS\Dynamic\ProcessedReturns\"
        msProcessedHoldFilePath = msProcessedFilePath & "Holding\"
        msUnProcessedFilePath = "E:\FAQSS\Dynamic\Final\"
        msIncompleteFilePath = "E:\FAQSS\Dynamic\Error\"
        msBatchImageFilePath = "E:\FAQSS\<PaperSize>\<BatchNumber>\Images\"
        msLogFilePath = "E:\FAQSS\Dynamic\Log\"
        msCAUnProcessedFilePath = "E:\FAQSSCA\Dynamic\Final\"
        frmScanImport.Output sMessage:="Processed Files: " & msProcessedFilePath, eLevel:=omcOutputWarning
        frmScanImport.Output sMessage:="UnProcessed Files: " & msUnProcessedFilePath, eLevel:=omcOutputWarning
        frmScanImport.Output sMessage:="Error Files: " & msIncompleteFilePath, eLevel:=omcOutputWarning
        frmScanImport.Output sMessage:="Batch Image Files: " & msBatchImageFilePath, eLevel:=omcOutputWarning
        frmScanImport.Output sMessage:="Log Files: " & msLogFilePath, eLevel:=omcOutputWarning
        frmScanImport.Output sMessage:="CA UnProcessed Files: " & msCAUnProcessedFilePath, eLevel:=omcOutputWarning
    #Else
        msProcessedFilePath = GetQualProParamString(sParamName:=mksScanImportProcRet, oConn:=goConn)
        msProcessedHoldFilePath = msProcessedFilePath & "Holding\"
        msUnProcessedFilePath = GetQualProParamString(sParamName:=mksScanImportUnProcRet, oConn:=goConn)
        msIncompleteFilePath = GetQualProParamString(sParamName:=mksScanImportIncomplete, oConn:=goConn)
        msBatchImageFilePath = GetQualProParamString(sParamName:=mksScanImportBatchImage, oConn:=goConn)
        msLogFilePath = GetQualProParamString(sParamName:=mksScanImportLog, oConn:=goConn)
        msCAUnProcessedFilePath = GetQualProParamString(sParamName:=mksScanImportCAUnProcRet, oConn:=goConn)
    #End If
    
    'If we are going to process a hand entered result file then reset the UnProcessedFilePath
    If Len(sSTRFileName) > 0 Then
        'Find the last backslash in the filename
        For nCnt = Len(sSTRFileName) To 1 Step -1
            If Mid(sSTRFileName, nCnt, 1) = "\" Then
                Exit For
            End If
        Next nCnt
        
        'Breakup the filename into path and filename
        msUnProcessedFilePath = Left(sSTRFileName, nCnt)
        sSTRFileName = Mid(sSTRFileName, nCnt + 1)
    End If
    
    'Check for errors
    If msProcessedFilePath = "" Or msUnProcessedFilePath = "" Or _
       msIncompleteFilePath = "" Or msBatchImageFilePath = "" Or msLogFilePath = "" Or _
       (geCountry = cccUS And msCAUnProcessedFilePath = "") Then
        'At least one of the paths is blank so throw an error
        Err.Raise Number:=iecErrorUnableToGetPaths, _
                  Source:="modImportProcesses::ProcessFiles", _
                  Description:="Unable to get file paths"
    End If
    
    'Process all available STR files
    If bTransferSTR Then
        
        Do
            'Check to see if we can continue
            If Not oUserInfo.CanContinueApp(sUserName:=oUserStuff.UserName, _
                                            sProgramName:="Transfer Results", _
                                            sDatabaseName:="QP_Prod", _
                                            oConn:=goConn, _
                                            sQPParamPrefix:="ScanImport", sMessage:=sMsg) Then
                frmScanImport.Output sMessage:=sMsg, eLevel:=omcOutputError
                Exit Do
            End If
            
            'Process the STR files
            bSTRContinue = ProcessSTRFiles(sSTRFileName:=sSTRFileName, _
                                           nLithoStart:=nLithoStart, _
                                           nLithoLength:=nLithoLength, _
                                           eTransferType:=eTransferType)
                                           
        Loop While bSTRContinue And Len(sSTRFileName) = 0 And Not gbStopProcessing
        
    End If
    
    'Process the comment files
    If eTransferType = ttcNormal And bTransferVSTR And Not gbStopProcessing Then
        
        'Setup the progress bar
        With goProgressBar
            .Style = pbsPleaseWait
            .Status = "Loading Comment Varification Data..."
        End With
        
        'Load the codes, types and valences
        Set goCommentCodes = New CCommentCodes
        goCommentCodes.PopulateFromDB eCodeType:=eCCTCodes
        
        Set goCommentTypes = New CCommentCodes
        goCommentTypes.PopulateFromDB eCodeType:=eCCTTypes
        
        Set goCommentValences = New CCommentCodes
        goCommentValences.PopulateFromDB eCodeType:=eCCTValences
        
        'Process all available VSTR files
        Do
            'Check to see if we can continue
            If Not oUserInfo.CanContinueApp(sUserName:=oUserStuff.UserName, _
                                            sProgramName:="Transfer Results", _
                                            sDatabaseName:="QP_Prod", _
                                            oConn:=goConn, _
                                            sQPParamPrefix:="ScanImport", sMessage:=sMsg) Then
                frmScanImport.Output sMessage:=sMsg, eLevel:=omcOutputError
                Exit Do
            End If
            
            'Process the VSTR files
            bVSTRContinue = ProcessVSTRFiles()
        
        Loop While bVSTRContinue And Not gbStopProcessing
    
    End If
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsPleaseWait
        .Status = "Closing Database Connections..."
    End With
    
    'Close the database connection
    CloseDBConnection oConn:=goConn
    CloseDBConnection oConn:=goScanConn
    
    'Cleanup
    Set goReadMethods = Nothing
    Set goCommentCodes = Nothing
    Set goCommentTypes = Nothing
    Set goCommentValences = Nothing
    Set oUserInfo = Nothing
    Set oUserStuff = Nothing
    
Exit Sub


ErrorHandler:
    'Deal with the errors here
    sMsg = "The following unrecoverable error was encountered: " & _
           "Error Source: " & Err.Source & " - " & _
           "Error #" & Err.Number & " - " & Err.Description
    frmScanImport.Output sMessage:=sMsg, eLevel:=omcOutputError
    
    CloseDBConnection oConn:=goConn
    CloseDBConnection oConn:=goScanConn
    
    'Cleanup
    Set goReadMethods = Nothing
    Set goCommentCodes = Nothing
    Set goCommentTypes = Nothing
    Set goCommentValences = Nothing
    Set oUserInfo = Nothing
    Set oUserStuff = Nothing
    
End Sub



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OutputCmntErrors
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-12-01
'\\
'\\ Description:    This routine outputs a top level error followed by
'\\                 all data collected up to this point.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     sErrorString    String  Contains the error that caused us to
'\\                             find ourselves in this predicament.
'\\     oComments       Object  Contains a reference to a CComments
'\\                             object that was being processed when
'\\                             the error occured.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-20-04    JJF     Added ability to deal with Hand Entries.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub OutputCmntErrors(ByVal sErrorString As String, _
                             oComments As Object)
    
    Dim lFileHandle     As Long
    '** Modified 02-20-04 JJF
    'Dim oComment        As CComment
    Dim oItem           As Object
    '** End of modification 02-20-04 JJF
    
    If oComments Is Nothing Then
        'Not sure what to do here
        frmScanImport.Output sMessage:="The following error was encountered: " & sErrorString, eLevel:=omcOutputError
    ElseIf Len(Trim(oComments.FileName)) = 0 Then
        'Not sure what to do here
        frmScanImport.Output sMessage:="The following error was encountered: " & sErrorString, eLevel:=omcOutputError
    Else
        'Get a file handle
        lFileHandle = FreeFile
        
        'Open the output file
        Open msIncompleteFilePath & oComments.FileName For Output As #lFileHandle
        
        'Write the main error message
        Print #lFileHandle, "The following error was encountered:"
        Print #lFileHandle, sErrorString
        Print #lFileHandle, " "
        
        'Write the file header
        '** Modified 02-20-04 JJF
        'Print #lFileHandle, "Barcode   Litho Code  SentMail_id  QuestionForm_id  CmntBox_id"
        'Print #lFileHandle, "--------  ----------  -----------  ---------------  ----------"
        Print #lFileHandle, "Barcode   Litho Code  SentMail_id  QuestionForm_id  Type  QstnCore    BubbleID  LineID  "
        Print #lFileHandle, "--------  ----------  -----------  ---------------  ----  ----------  --------  --------"
        '** End of modification 02-20-04 JJF
        
        'Write all of the Comments
        '** Modified 02-20-04 JJF
        'For Each oComment In oComments
        '    With oComment
        '        Print #lFileHandle, RPad(.Barcode, 10) & _
        '                            LPad(.LithoCode, 10) & _
        '                            LPad(.SentMailID, 13) & _
        '                            LPad(.QuestionFormID, 17) & _
        '                            LPad(.QstnCore, 12)
        '    End With
        'Next oComment
        For Each oItem In oComments
            If TypeOf oItem Is CComment Then
                'This is a comment
                With oItem
                    If Len(Trim(.ErrorString)) > 0 Then
                        Print #lFileHandle, RPad(.Barcode, 10) & _
                                            LPad(.LithoCode, 10) & _
                                            LPad(.SentMailID, 13) & _
                                            LPad(.QuestionFormID, 17) & "  Cmnt" & _
                                            LPad(.QstnCore, 12)
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
                                            LPad(.LineID, 10)
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
        'For Each oComment In oComments
        '    With oComment
        '        Print #lFileHandle, .Barcode
        '    End With
        'Next oComment
        For Each oItem In oComments
            With oItem
                Print #lFileHandle, .Barcode
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
        'For Each oComment In oComments
        '    With oComment
        '        Print #lFileHandle, .LithoCode & ","
        '    End With
        'Next oComment
        For Each oItem In oComments
            With oItem
                Print #lFileHandle, .LithoCode & ","
            End With
        Next oItem
        '** End of modification 02-20-04 JJF
        
        'Close the output file and cleanup
        Close #lFileHandle
        '** Modified 02-20-04 JJF
        'Set oComment = Nothing
        Set oItem = Nothing
        '** End of modification 02-20-04 JJF
        frmScanImport.Output sMessage:="Errors encountered during processing!  See incomplete file for details.", eLevel:=omcOutputError
    End If
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OutputErrors
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine outputs a top level error followed by
'\\                 all data collected up to this point.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     sErrorString    String  Contains the error that caused us to
'\\                             find ourselves in this predicament.
'\\     oQuestionaires  Object  Contains a reference to a CQuestionaires
'\\                             object that was being processed when
'\\                             the error occured.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Added individual barcode and lithocode
'\\                         listings at the end of the file to make it
'\\                         easier to do debugging.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub OutputErrors(ByVal sErrorString As String, _
                         oQuestionaires As Object)
    
    Dim lFileHandle     As Long
    Dim oQuestionaire   As CQuestionaire
    
    If oQuestionaires Is Nothing Then
        'Not sure what to do here
        frmScanImport.Output sMessage:="The following error was encountered: " & sErrorString, eLevel:=omcOutputError
    ElseIf Len(Trim(oQuestionaires.FileName)) = 0 Then
        'Not sure what to do here
        frmScanImport.Output sMessage:="The following error was encountered: " & sErrorString, eLevel:=omcOutputError
    Else
        'Get a file handle
        lFileHandle = FreeFile
        
        'Open the output file
        Open msIncompleteFilePath & oQuestionaires.FileName For Output As #lFileHandle
        
        'Write the main error message
        Print #lFileHandle, "The following error was encountered:"
        Print #lFileHandle, sErrorString
        Print #lFileHandle, " "
        
        'Write the file header
        Print #lFileHandle, "Barcode   Litho Code  SentMail_id  QuestionForm_id"
        Print #lFileHandle, "--------  ----------  -----------  ---------------"
        
        'Write all of the questionaires
        For Each oQuestionaire In oQuestionaires
            With oQuestionaire
                Print #lFileHandle, RPad(.Barcode, 10) & _
                                    LPad(.LithoCode, 10) & _
                                    LPad(.SentMailID, 13) & _
                                    LPad(.QuestionFormID, 17)
            End With
        Next oQuestionaire
        
        '** Added 06-19-00 JJF
        'Write the barcode header
        Print #lFileHandle, ""
        Print #lFileHandle, ""
        Print #lFileHandle, "Barcodes only"
        Print #lFileHandle, "-------------"
        
        'Write all of the incomplete questionaires
        For Each oQuestionaire In oQuestionaires
            With oQuestionaire
                Print #lFileHandle, .Barcode
            End With
        Next oQuestionaire
        
        'Write the LithoCode header
        Print #lFileHandle, ""
        Print #lFileHandle, ""
        Print #lFileHandle, "LithoCodes only"
        Print #lFileHandle, "---------------"
        
        'Write all of the incomplete questionaires
        For Each oQuestionaire In oQuestionaires
            With oQuestionaire
                Print #lFileHandle, .LithoCode & ","
            End With
        Next oQuestionaire
        '** End of add 06-19-00 JJF
        
        'Close the output file and cleanup
        Close #lFileHandle
        Set oQuestionaire = Nothing
        frmScanImport.Output sMessage:="Errors encountered during processing!  See incomplete file for details.", eLevel:=omcOutputError
    End If
    
End Sub



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   ProcessVSTRFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-11-2001
'\\
'\\ Description:    This routine is called to process the comment
'\\                 return files.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\
'\\ Return Value:
'\\     Type        Value   Description
'\\     Boolean     TRUE    A file was successfully processed.
'\\                 FALSE   No files were found to process or an
'\\                         unexpected error occured.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-09-02    JJF     Removed the error condition for empty VSTR
'\\                         files.
'\\     02-20-03    JJF     Added the holding folder.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     10-31-05    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function ProcessVSTRFiles() As Boolean

    Dim sErrorString    As String
    Dim oComments       As CComments
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    Set oComments = New CComments
    With oComments
        'Set the file paths
        .ProcessedFilePath = msProcessedFilePath
        .ProcessedHoldFilePath = msProcessedHoldFilePath
        .UnProcessedFilePath = msUnProcessedFilePath
        .IncompleteFilePath = msIncompleteFilePath
        .LogFilePath = msLogFilePath
        .CAUnProcessedFilePath = msCAUnProcessedFilePath
        
        'Setup the progress bar
        With goProgressBar
            .Style = pbsPleaseWait
            .Status = "Loading VSTR File..."
        End With
        
        'Populate the collection
        If Not .LoadFromFile() Then
            'If there were no files to process then we are out of here
            ProcessVSTRFiles = False
            Exit Function
        End If
        DoEvents
        
        If .Count > 0 Then
            
            'If one of the surveys from this file is Canadian then copy it there
            If geCountry = cccUS And .IsCanadian Then
                .MoveFileToCanada
                .OutputLog "Moved to Canada"
                ProcessVSTRFiles = True
                Exit Function
            End If
            
            'Get the required information for these questionaires
            .GetAdditionalInfo
            
            'If one of the surveys from this file is Canadian then copy it there
            If geCountry = cccUS And .IsCanadian Then
                .MoveFileToCanada
                .OutputLog "Moved to Canada"
                ProcessVSTRFiles = True
                Exit Function
            End If
        
            'Process the loaded questionaires
            .Process
        
            'Output any unhandled processing errors
            If .ErrorCount > 0 Then
                .OutputErrors
                frmScanImport.Output sMessage:="Errors encountered during processing!  See incomplete file for details.", eLevel:=omcOutputError
            End If
        End If
        
        'Output the LOG file data
        .OutputLog
        .MoveFileFromHolding
    End With 'oComments
    
    'If we made it to here then all is well
    oComments.Clear
    Set oComments = Nothing
    ProcessVSTRFiles = True
    
Exit Function


ErrorHandler:
    ProcessVSTRFiles = False
    sErrorString = "modImportProcesses::ProcessVSTRFiles - Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    OutputCmntErrors sErrorString:=sErrorString, oComments:=oComments
    Set oComments = Nothing
    Exit Function

End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   ProcessSTRFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine is called to process the return files.
'\\                 NOTE: MOST OF THIS CODE CAME FROM ProcessFiles
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     sSTRFileName    String      The path and filename of the hand
'\\                                 entered STR file.  Empty string if
'\\                                 normal processing is to occur.
'\\     nLithoStart     Integer     Column within the STR line at which
'\\                                 the LithoCode starts in a non-qualpro
'\\                                 STR file.
'\\     nLithoLength    Integer     Width of the LithoCode entry in the
'\\                                 STR line for a non-QualPro STR file.
'\\     eTransferType   eTransferTypeConstants
'\\                                 Specified the type of transfer to be
'\\                                 performed.
'\\
'\\ Return Value:
'\\     Type        Value   Description
'\\     Boolean     TRUE    A file was successfully processed.
'\\                 FALSE   No files were found to process or an
'\\                         unexpected error occured.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Modified to produce an error when an empty
'\\                         results file is encountered.  Also added a
'\\                         check to verify that we have the correct
'\\                         number of responses for the number of
'\\                         images in the batch.
'\\     06-27-00    JJF     Added the output process logging.
'\\     08-18-00    JJF   * Added ability to run on multiple machines
'\\                         so this routine changed completely.
'\\                       * Added progress indication.
'\\     08-29-00    JJF     Added ability to deal with hand entered
'\\                         results.
'\\     09-06-00    JJF     Added a new path for log files.
'\\     06-12-01    JJF     Added ability to import non-qualpro string
'\\                         files.
'\\     08-13-01    JJF     Added the eTransferType parameter.
'\\     08-15-01    JJF     Added progress indication to the collection
'\\                         cleanup process.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     10-31-05    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function ProcessSTRFiles(ByVal sSTRFileName As String, _
                                 ByVal nLithoStart As Integer, _
                                 ByVal nLithoLength As Integer, _
                                 ByVal eTransferType As eTransferTypeConstants) As Boolean

    Dim sErrorString   As String
    Dim oQuestionaires As CQuestionaires
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    Set oQuestionaires = New CQuestionaires
    With oQuestionaires
        'Set the file paths
        .ProcessedFilePath = msProcessedFilePath
        .ProcessedHoldFilePath = msProcessedHoldFilePath
        .UnProcessedFilePath = msUnProcessedFilePath
        .IncompleteFilePath = msIncompleteFilePath
        .BatchImageFilePath = msBatchImageFilePath
        .LogFilePath = msLogFilePath
        .CAUnProcessedFilePath = msCAUnProcessedFilePath
        
        'Setup the progress bar
        With goProgressBar
            .Style = pbsPleaseWait
            .Status = "Loading STR File..."
        End With
        
        'Populate the collection
        If Not .LoadFromFile(sSTRFileName:=sSTRFileName, _
                             nLithoStart:=nLithoStart, _
                             nLithoLength:=nLithoLength) Then
            'If there were no files to process then we are out of here
            ProcessSTRFiles = False
            Exit Function
        End If
        DoEvents
                
        If .Count = 0 Then
            'This file did not contain any result strings so throw an error
            sErrorString = "The following STR file does not contain any results!" & vbCrLf & vbCrLf & _
                           "Filename: " & msProcessedFilePath & .FileName & vbCrLf & vbCrLf & _
                           "Click [OK] to continue"
            MsgBox sErrorString, vbCritical
            sErrorString = "modImportProcesses::ProcessFiles - Error #" & iecErrorEmptyFileEncountered & ": This file did not contain any results"
            OutputErrors sErrorString:=sErrorString, oQuestionaires:=oQuestionaires
            .MoveFileFromHolding
            ProcessSTRFiles = True
            Exit Function
        ElseIf Not .VerifyBatchImageCount And Len(sSTRFileName) = 0 Then
            'The quantity of result strings in this file does not match up
            '  with the number of images in the batch so throw an error
            sErrorString = "The following STR file does not contain the" & vbCrLf & _
                           "correct quantity of result strings!" & vbCrLf & vbCrLf & _
                           "Filename: " & msProcessedFilePath & .FileName & vbCrLf & _
                           "Qty Result Strings: " & .Count & vbCrLf & _
                           "Qty Images Per: " & .QtyImagesPerQuestionaire & vbCrLf & _
                           "Qty Images Required: " & .Count * .QtyImagesPerQuestionaire & vbCrLf & _
                           "Qty Images Found: " & .QtyImagesFound & vbCrLf & vbCrLf & _
                           "This batch will not be processed!" & vbCrLf & _
                           "Click [OK] to continue"
            MsgBox sErrorString, vbCritical
            sErrorString = "modImportProcesses::ProcessFiles - Error #" & iecErrorIncorrectQtyOfImages & ": This file did not contain the correct quantity of result strings - Qty Result Strings: " & .Count & " - Qty Images Per: " & .QtyImagesPerQuestionaire & " - Qty Images Required: " & .Count * .QtyImagesPerQuestionaire & " - Qty Images Found: " & .QtyImagesFound
            OutputErrors sErrorString:=sErrorString, oQuestionaires:=oQuestionaires
            .MoveFileFromHolding
            ProcessSTRFiles = True
            Exit Function
        End If
        
        'If one of the surveys from this file is Canadian then copy it there
        If geCountry = cccUS And .IsCanadian Then
            .MoveFileToCanada
            .OutputLog "Moved to Canada"
            ProcessSTRFiles = True
            Exit Function
        End If
        
        'Get the required information for these questionaires
        .GetAdditionalInfo
        
        'If one of the surveys from this file is Canadian then copy it there
        If geCountry = cccUS And .IsCanadian Then
            .MoveFileToCanada
            .OutputLog "Moved to Canada"
            ProcessSTRFiles = True
            Exit Function
        End If
        
        'Process the loaded questionaires
        .Process eTransferType:=eTransferType
        
        'Output any unhandled processing errors
        If .ErrorCount > 0 Then
            .OutputErrors
            frmScanImport.Output sMessage:="Errors encountered during processing!  See incomplete file for details.", eLevel:=omcOutputError
        End If
        
        'Output the LOG file data
        .OutputLog
        .MoveFileFromHolding
    End With 'oQuestionaires
    
    'If we made it to here then all is well
    oQuestionaires.Clear
    Set oQuestionaires = Nothing
    ProcessSTRFiles = True
    
Exit Function


ErrorHandler:
    ProcessSTRFiles = False
    sErrorString = "modImportProcesses::ProcessSTRFiles - Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    OutputErrors sErrorString:=sErrorString, oQuestionaires:=oQuestionaires
    Set oQuestionaires = Nothing
    Exit Function

End Function


