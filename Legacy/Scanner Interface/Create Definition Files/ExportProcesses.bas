Attribute VB_Name = "modExportProcesses"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      ExportProcesses.bas
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the routines that actually
'\\                 perform the EXPORT process.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     09-06-00    JJF     Added a new path for log files.
'\\     02-20-03    JJF     Added a new file path to QPParams to identify
'\\                         the interim location of files to allow for
'\\                         recovery in the event of a PC lockup.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'Local variables that hold the various paths required
    Private msUnProcessedFilePath   As String
    Private msIncompleteFilePath    As String
    Private msProcessedFilePath     As String
    Private msQDefTXTFilePath       As String
    Private msLogFilePath           As String
    Private msProcessedHoldFilePath As String
    Private msQDefTXTFilePathUS     As String
    Private msImageFilePathUS       As String
    Private msImageFilePathCA       As String
    
    'Local constants used to retrieve paths from QualPro_Params
    Private Const mksScanExportUnProc       As String = "ScanExportUnProc"
    Private Const mksScanExportIncomplete   As String = "ScanExportIncomplete"
    Private Const mksScanExportProc         As String = "ScanExportProc"
    Private Const mksScanExportQDefTXT      As String = "ScanExportQdefTxt"
    Private Const mksScanExportLog          As String = "ScanExportLog"
    Private Const mksScanExportQDefTXTUS    As String = "ScanExportQdefTxtUS"
    Private Const mksScanExportImageLocUS   As String = "ScanExportImageLocUS"
    Private Const mksScanExportImageLocCA   As String = "ScanExportImageLocCA"





    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OutputErrors
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine outputs a top level error followed by
'\\                 all data colloected up to this point.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     sErrorString    String  Contains the error that caused us to
'\\                             find ourselves in this predicament.
'\\     oQuestionaires  Object  Contains a reference to either a
'\\                             CDLVQuestionaires or CNDLQuestionaires
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
        frmScanExport.Output sMessage:="The following error was encountered: " & sErrorString, eLevel:=omcOutputError
    ElseIf Len(Trim(oQuestionaires.FileName)) = 0 Then
        'Not sure what to do here
        frmScanExport.Output sMessage:="The following error was encountered: " & sErrorString, eLevel:=omcOutputError
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
        
        'Write the barcode header
        Print #lFileHandle, ""
        Print #lFileHandle, ""
        Print #lFileHandle, "Barcodes only"
        Print #lFileHandle, "-------------"
        
        'Write all of the incomplete questionaires
        For Each oQuestionaire In oQuestionaires
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
        For Each oQuestionaire In oQuestionaires
            With oQuestionaire
                If Len(Trim(.ErrorString)) > 0 Then
                    Print #lFileHandle, "'" & .LithoCode & "',"
                End If
            End With
        Next oQuestionaire
        
        'Close the output file and cleanup
        Close #lFileHandle
        Set oQuestionaire = Nothing
        frmScanExport.Output sMessage:="Errors encountered during processing!  See incomplete file for details.", eLevel:=omcOutputError
    End If
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   ProcessDLVFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called to process the deliverable
'\\                 questionaires.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Value   Description
'\\     Boolean     TRUE    A file was successfully processed.
'\\                 FALSE   No files were found to process or an
'\\                         unexpected error occured.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Added error handling for empty deliverable
'\\                         files.
'\\     08-18-00    JJF     Added progress indication.
'\\     09-06-00    JJF     Added process logging.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function ProcessDLVFiles() As Boolean
    
    Dim sErrorString        As String
    Dim oDLVQuestionaires   As CDLVQuestionaires
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    Set oDLVQuestionaires = New CDLVQuestionaires
    With oDLVQuestionaires
        'Set the file paths
        .QDefTXTFilePath = msQDefTXTFilePath
        .ProcessedFilePath = msProcessedFilePath
        .ProcessedHoldFilePath = msProcessedHoldFilePath
        .IncompleteFilePath = msIncompleteFilePath
        .UnProcessedFilePath = msUnProcessedFilePath
        .LogFilePath = msLogFilePath
        .QDefTXTFilePathUS = msQDefTXTFilePathUS
        .ImageFilePathUS = msImageFilePathUS
        .ImageFilePathCA = msImageFilePathCA
        
        'Setup the progress bar
        With goProgressBar
            .Style = pbsPleaseWait
            .Status = "Loading Deliverable File..."
        End With
        
        'Populate the collection
        If Not .LoadFromFile Then
            'If there were no files to process then we are out of here
            ProcessDLVFiles = False
            Exit Function
        End If
        DoEvents
        
        'Check for empty file condition
        If .Count = 0 Then
            sErrorString = "modExportProcesses::ProcessDLVFiles - Error #" & iecErrorEmptyFileEncountered & ": This file did not contain any barcodes"
            OutputErrors sErrorString:=sErrorString, oQuestionaires:=oDLVQuestionaires
            ProcessDLVFiles = True
            Exit Function
        End If
        
        'Get the SentMailID and QuestionFormID for each litho
        .GetAdditionalInfo
        
        'Process the loaded questionaires
        .Process
        
        'Output any unhandled processing errors
        If .ErrorCount > 0 Then
            .OutputErrors
            frmScanExport.Output sMessage:="Errors encountered during processing!  See incomplete file for details.", eLevel:=omcOutputError
        End If
        
        'Output the LOG file data
        .OutputLog
    End With
    
    'If we made it to here then all is well
    Set oDLVQuestionaires = Nothing
    ProcessDLVFiles = True
    
Exit Function


ErrorHandler:
    ProcessDLVFiles = False
    sErrorString = "modExportProcesses::ProcessDLVFiles - Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    OutputErrors sErrorString:=sErrorString, oQuestionaires:=oDLVQuestionaires
    Set oDLVQuestionaires = Nothing
    Exit Function
    
End Function

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
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Added progress indication.
'\\     09-06-00    JJF     Added a new path for log files.
'\\     03-07-02    JJF     Changed to use the connection string stored
'\\                         in the local registry instead of the MTS
'\\                         object.
'\\     02-20-03    JJF   * Added code to check time and quantity of
'\\                         running apps privileges.
'\\                       * Added a new file path to QPParams to identify
'\\                         the interim location of files to allow for
'\\                         recovery in the event of a PC lockup.
'\\     05-27-05    JJF   * Modified to work with Canadian generated
'\\                         surveys.
'\\                       * Removed old code for clarity.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub ProcessFiles()
    
    Dim sMsg            As String
    Dim bNDLContinue    As Boolean
    Dim bDLVContinue    As Boolean
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
    
    'Get the list of DOD survey ids from QualPro_Params
    gsDODSurveys = "," & Trim(GetQualProParamString(sParamName:="DODSurveys", oConn:=goConn)) & ","
    
    'Set file paths
    goProgressBar.Status = "Getting Path Information..."
    #If bOverridePaths Then
        msProcessedFilePath = "E:\FAQSS\Dynamic\ProcessedBarcodes\"
        msProcessedHoldFilePath = msProcessedFilePath & "Holding\"
        msUnProcessedFilePath = "E:\FAQSS\Dynamic\Barcodes\"
        msIncompleteFilePath = "E:\FAQSS\Dynamic\Error\"
        msQDefTXTFilePath = "E:\FAQSS\Dynamic\Litho\"
        msLogFilePath = "E:\FAQSS\Dynamic\Log\"
        msQDefTXTFilePathUS = "E:\FAQSS\Dynamic\Litho\"
        msImageFilePathUS = "E:\FAQSS\Dynamic\Images\"
        msImageFilePathCA = "E:\FAQSSCA\Dynamic\Images\"
        frmScanExport.Output sMessage:="Processed Files: " & msProcessedFilePath, eLevel:=omcOutputWarning
        frmScanExport.Output sMessage:="UnProcessed Files: " & msUnProcessedFilePath, eLevel:=omcOutputWarning
        frmScanExport.Output sMessage:="Incomplete Files: " & msIncompleteFilePath, eLevel:=omcOutputWarning
        frmScanExport.Output sMessage:="Definition Files: " & msQDefTXTFilePath, eLevel:=omcOutputWarning
        frmScanExport.Output sMessage:="Log Files: " & msLogFilePath, eLevel:=omcOutputWarning
        frmScanExport.Output sMessage:="Definition Files in US: " & msQDefTXTFilePathUS, eLevel:=omcOutputWarning
        frmScanExport.Output sMessage:="Image Files in US: " & msImageFilePathUS, eLevel:=omcOutputWarning
        frmScanExport.Output sMessage:="Image Files in CA: " & msImageFilePathCA, eLevel:=omcOutputWarning
    #Else
        msProcessedFilePath = GetQualProParamString(sParamName:=mksScanExportProc, oConn:=goConn)
        msProcessedHoldFilePath = msProcessedFilePath & "Holding\"
        msUnProcessedFilePath = GetQualProParamString(sParamName:=mksScanExportUnProc, oConn:=goConn)
        msIncompleteFilePath = GetQualProParamString(sParamName:=mksScanExportIncomplete, oConn:=goConn)
        msQDefTXTFilePath = GetQualProParamString(sParamName:=mksScanExportQDefTXT, oConn:=goConn)
        msLogFilePath = GetQualProParamString(sParamName:=mksScanExportLog, oConn:=goConn)
        msQDefTXTFilePathUS = GetQualProParamString(sParamName:=mksScanExportQDefTXTUS, oConn:=goConn)
        msImageFilePathUS = GetQualProParamString(sParamName:=mksScanExportImageLocUS, oConn:=goConn)
        msImageFilePathCA = GetQualProParamString(sParamName:=mksScanExportImageLocCA, oConn:=goConn)
    #End If
    
    'Check for errors
    If msUnProcessedFilePath = "" Or msProcessedFilePath = "" Or _
       msQDefTXTFilePath = "" Or msIncompleteFilePath = "" Or msLogFilePath = "" Then
        'At least one of the paths is blank so throw an error
        Err.Raise Number:=iecErrorUnableToGetPaths, _
                  Source:="modExportProcesses::ProcessFiles", _
                  Description:="Unable to get file paths"
    End If
    
    'Process all of the available files
    Do
        'Check to see if we can continue
        If Not oUserInfo.CanContinueApp(sUserName:=oUserStuff.UserName, _
                                        sProgramName:="Create Definition Files", _
                                        sDatabaseName:="QP_Prod", _
                                        oConn:=goConn, _
                                        sQPParamPrefix:="ScanExport", sMessage:=sMsg) Then
            frmScanExport.Output sMessage:=sMsg, eLevel:=omcOutputError
            Exit Do
        End If
        
        'Process the undeliverable questionaires
        bNDLContinue = ProcessNDLFiles
        
        'Process the deliverable questionaires
        bDLVContinue = ProcessDLVFiles
    Loop While bNDLContinue Or bDLVContinue
    
    'Setup the progress bar
    With goProgressBar
        .Style = pbsPleaseWait
        .Status = "Closing Database Connections..."
    End With
    
    'Close the database connection
    CloseDBConnection oConn:=goConn
    CloseDBConnection oConn:=goScanConn
    
    'Cleanup
    Set oUserInfo = Nothing
    Set oUserStuff = Nothing
    
Exit Sub


ErrorHandler:
    'Deal with the errors here
    sMsg = "The following unrecoverable error was encountered: " & _
           "Error Source: " & Err.Source & " - " & _
           "Error #" & Err.Number & " - " & Err.Description
    frmScanExport.Output sMessage:=sMsg, eLevel:=omcOutputError
    
    'Close the database connection
    CloseDBConnection oConn:=goConn
    CloseDBConnection oConn:=goScanConn
    
    'Cleanup
    Set oUserInfo = Nothing
    Set oUserStuff = Nothing

End Sub




'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   ProcessNDLFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called to process the undeliverable
'\\                 questionaires.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Value   Description
'\\     Boolean     TRUE    A file was successfully processed.
'\\                 FALSE   No files were found to process or an
'\\                         unexpected error occured.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Added error handling for empty deliverable
'\\                         files.
'\\     08-18-00    JJF     Added progress indication.
'\\     09-06-00    JJF     Added process logging.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     10-31-05    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function ProcessNDLFiles() As Boolean
    
    Dim sErrorString        As String
    Dim oNDLQuestionaires   As CNDLQuestionaires
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    Set oNDLQuestionaires = New CNDLQuestionaires
    With oNDLQuestionaires
        'Set the file paths
        .ProcessedFilePath = msProcessedFilePath
        .ProcessedHoldFilePath = msProcessedHoldFilePath
        .IncompleteFilePath = msIncompleteFilePath
        .UnProcessedFilePath = msUnProcessedFilePath
        .LogFilePath = msLogFilePath
        
        'Setup the progress bar
        With goProgressBar
            .Style = pbsPleaseWait
            .Status = "Loading Non-Deliverable File..."
        End With
        
        'Populate the collection
        If Not .LoadFromFile Then
            ProcessNDLFiles = False
            Exit Function
        End If
        DoEvents
        
        'Check for empty file condition
        If .Count = 0 Then
            sErrorString = "modExportProcesses::ProcessNDLFiles - Error #" & iecErrorEmptyFileEncountered & ": This file did not contain any barcodes"
            OutputErrors sErrorString:=sErrorString, oQuestionaires:=oNDLQuestionaires
            ProcessNDLFiles = True
            Exit Function
        End If
        
        'Get the SentMailID and QuestionFormID for each litho
        If .CountCountry(eCountry:=geCountry) > 0 Then
            .GetAdditionalInfo
        End If
        
        'Process the loaded questionaires
        .Process
        
        'Output any unhandled processing errors
        If .ErrorCount > 0 Then
            .OutputErrors
            frmScanExport.Output sMessage:="Errors encountered during processing!  See incomplete file for details.", eLevel:=omcOutputError
        End If
        
        'Output the LOG file data
        .OutputLog
    End With
    
    'If we made it to here then all is well
    Set oNDLQuestionaires = Nothing
    ProcessNDLFiles = True
    
Exit Function


ErrorHandler:
    ProcessNDLFiles = False
    sErrorString = "modExportProcesses::ProcessNDLFiles - Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    OutputErrors sErrorString:=sErrorString, oQuestionaires:=oNDLQuestionaires
    Set oNDLQuestionaires = Nothing
    Exit Function
    
End Function



