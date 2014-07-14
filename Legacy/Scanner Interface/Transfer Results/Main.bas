Attribute VB_Name = "modMain"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      Main.bas
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains all the global variables, enums,
'\\                 and routines required to process the import files.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-10-00    JJF     Added the multiple response level command
'\\                         line parameter.
'\\     06-19-00    JJF     Added new error code for empty file issue.
'\\     08-18-00    JJF     Added progress indication to the polling.
'\\     12-20-00    JJF     Added KeepMultiReturns property.
'\\     06-12-01    JJF     Added Transfer Type enum.
'\\     10-11-01    JJF     Added ability to deal with comment boxes.
'\\     01-21-02    JJF     Added variables to hold HTML prefix and
'\\                         suffix for name masking.
'\\     01-28-02    JJF     Changed the way name masking is done.
'\\     03-07-02    JJF   * Added a connection object variable for the
'\\                         new location of the bubble tables.
'\\                       * Added a lookup collection for the
'\\                         ReadMethod table.
'\\     04-03-02    JJF     Added and error code to identify the
'\\                         questionaires that have not been marked as
'\\                         as returned yet (imcNotMarkedReturnedYet).
'\\     09-24-02    JJF     Added variables required to do the error
'\\                         retry looping.
'\\     01-23-03    JJF     Added the capability to stop processing
'\\                         after the completion of the current batch.
'\\     02-20-04    JJF     Added ability to deal with Hand Entries.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    Public gbStopProcessing As Boolean      '** Added 01-23-03 JJF
    
    Public goReadMethods As CReadMethods    '** Added 03-07-02 JJF
    
    Public Const gknMaxRetries As Integer = 5   '** Added 09-24-02 JJF
    
    Public UserName As String
    Public ComputerName As String
    
    '** Added 01-21-02 JJF
    '** Removed 01-28-02 JJF
    ''Global variables to hold HTML markup for name masking
    'Public gsNameMaskPrefix As String
    'Public gsNameMaskSuffix As String
    '** End of remove 01-28-02 JJF
    
    'Enum for comment valences
    Public Enum eCommentValenceConstants
        eCVCPositive = 1
        eCVCNegative = 2
        eCVCBoth = 3
        eCVCNeutral = 4
    End Enum
    '** End of add 01-21-02 JJF
    
    '** Added 10-11-01 JJF
    'Constant used to offset the CmntBox_id to distinguish the
    '  difference between comment boxes and hand-written responses
    Public Const gklCmntBoxIDOffset As Long = 500000
    
    'Global collection for the comment types and valences
    Public goCommentCodes As CCommentCodes
    Public goCommentTypes As CCommentCodes
    Public goCommentValences As CCommentCodes
    
    'Enum for the comment types
    Public Enum eCommentTypeConstants
        eCTCGeneral = 1
        eCTCContact = 2
        eCTCUrgent = 3
    End Enum
    '** End of add 10-11-01 JJF
    
    'Added 08-18-00 JJF
    'Global object for controlling the progress bar
    Public goProgressBar As CProgressBar
    '** End of add 08-18-00 JJF
    
    '** Added 05-10-00 JJF
    'Global command line parameters
    Public geMultipleResponseLevel As eMultipleResponseLevelCodes
    
    'Enum the defines the multiple response level
    Public Enum eMultipleResponseLevelCodes
        mrcProcessAllQuestions = 0
        mrcProcessMultiRespOnly = 1
        mrcProcessSingleRespOnly = 2
    End Enum
    '** End of add 05-10-00 JJF
    
    'Global ADO Connection object
    Public goConn As ADODB.Connection
    Public goScanConn As ADODB.Connection   '** Added 03-07-02 JJF
    
    'Enum that defines the constants for unused returns
    Public Enum eUnusedReturnConstants
        urcNone = 0
        urcOtherStepReturned = 1
        urcReturnAfterExpire = 2
        urcAlreadyScanned = 3
        urcKeepMultiReturns = 4     '** Added 12-20-00 JJF
    End Enum
    
    'Enum that defines the constants for standard export
    '  error conditions
    Public Enum eImportErrorCodes
        imcNone = 0
        imcInvalidBarcode = 1
        imcNoSentMailingRecord = 2
        imcNoQuestionFormRecord = 3
        imcNoCommentPosRecord = 4       '** Added 10-11-01 JJF
        imcInvalidSampleUnitID = 5      '** Added 10-11-01 JJF
        imcCommentLineNotFound = 6      '** Added 10-11-01 JJF
        imcCodeLineNotFound = 7         '** Added 10-11-01 JJF
        imcInvalidCommentType = 8       '** Added 10-11-01 JJF
        imcInvalidCommentValence = 9    '** Added 10-11-01 JJF
        imcInvalidCommentCode = 10      '** Added 10-11-01 JJF
        imcInvalidNameMasking = 11      '** Added 01-21-02 JJF
        imcNotMarkedReturnedYet = 12    '** Added 04-03-02 JJF
        imcNoHandWrittenPosRecord = 13  '** Added 02-20-04 JJF
        imcInvalidPopID = 14            '** Added 02-20-04 JJF
        imcInvalidSamplePopID = 15      '** Added 02-20-04 JJF
        imcInvalidFieldName = 16        '** Added 02-20-04 JJF
        imcUnknownErrorSeeFile = 99
    End Enum
    
    'Enum that defines the constants for trapped error
    '  conditions within the interface
    Public Enum eInterfaceErrorCodes
        iecErrorBase = 1000 + vbObjectError
        iecErrorUnableToGetPaths = iecErrorBase + 1
        iecErrorLoadFromFileFailed = iecErrorBase + 2
        iecErrorGetAddInfoFailed = iecErrorBase + 3
        iecErrorGetQuestionsFailed = iecErrorBase + 4
        iecErrorSetMultipleValuesFailed = iecErrorBase + 5
        iecErrorEmptyFileEncountered = iecErrorBase + 6    '** Added 06-19-00 JJF
        iecErrorIncorrectQtyOfImages = iecErrorBase + 7    '** Added 06-19-00 JJF
        'iecError = iecErrorBase + X
    End Enum
    
    'Enum that defines the output message types for the listview
    Public Enum eOutputMessageCodes
        omcOutputMessage = 1
        omcOutputWarning = 2
        omcOutputError = 3
    End Enum
    Public Enum eOutputLevelCodes
        olcOutputLevelNone = 0
        olcOutputLevelMessage = omcOutputMessage
        olcOutputLevelWarning = omcOutputWarning
        olcOutputLevelError = omcOutputError
    End Enum
    
    Public Enum eIntervalTypeCodes
        itcUseDefaultInterval = 0
        itcUseOverrideInterval = 1
    End Enum
    
    '** Added 05-27-05 JJF
    Public Enum eCountryCodeConstants
        cccUnknown = 0
        cccUS = 1
        cccCanada = 2
    End Enum
    Public geCountry As eCountryCodeConstants
    
    Public Type gtypLithoRange
        sMinLitho As String
        sMaxLitho As String
    End Type
    Public goCALithoRange As gtypLithoRange
    '** End of add 05-27-05 JJF
    
    '** Added 06-12-01 JJF
    Public Enum eTransferTypeConstants
        ttcNormal = 0
        ttcHandEntered = 1
        ttcNonQualPro = 2
    End Enum
    '** End of add 06-12-01 JJF
    
    'Enum for the comment types
    Public Enum eUserActivity
        eUserLogin = 1
        eUserLogout = 2
        eUserUpdate = 3
    End Enum
    
    
    
    
    
    
    
    
    
    
    
    
Public Sub Main()
    
    Dim sMsg                As String
    Dim oUserInfo           As New UserInfo.CUserInfo
    Dim oUserStuff          As New CUserInfo
    Dim oConn               As ADODB.Connection
    Dim sCurrentVersion     As String   '** Added 08-14-03 JJF
    Dim sRequiredVersion    As String   '** Added 08-14-03 JJF
    
    'Read in all registry settings
    ReadRegistry
    
    'Open database connection
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    UserName = oUserStuff.UserName
    ComputerName = oUserStuff.ComputerName
    
    'Determine if we can start the application
    If Not oUserInfo.CanLaunchApp(sUserName:=oUserStuff.UserName, _
                                  sProgramName:="Transfer Results", _
                                  sDatabaseName:="QP_Prod", _
                                  oConn:=oConn, _
                                  sQPParamPrefix:="ScanImport", sMessage:=sMsg) Then
        MsgBox sMsg, vbCritical + vbOKOnly
        Exit Sub
    End If
    
    '** Added 08-14-03 JJF
    'Get the versioning information
    sCurrentVersion = GetAppVersion
    sRequiredVersion = GetQualProParamString(sParamName:="TransResVersion", oConn:=oConn)
    '** End of add 08-14-03 JJF

    'Cleanup
    Set oUserInfo = Nothing
    Set oUserStuff = Nothing
    CloseDBConnection oConn:=oConn
    
    '** Added 08-14-03 JJF
    'Determine if we are running the correct version of the software
    'If sCurrentVersion <> sRequiredVersion Then
     '   'We are not running the required version of this program so we are out of here
     '   sMsg = "You are not running the most recent version of" & vbCrLf & _
      '         "Transfer Results!" & vbCrLf & vbCrLf & _
      '         "Your Version: " & sCurrentVersion & vbCrLf & _
      '         "Required Version: " & sRequiredVersion & vbCrLf & vbCrLf & _
      '         "Please contact the help desk and request the" & vbCrLf & _
      '         "specified version be installed on this PC!"
      '  MsgBox sMsg, vbCritical, "Transfer Results"
      '  Exit Sub
    'End If
    '** End of add 08-14-03 JJF
    
    'If we made it to here then we need to launch the program
    frmScanImport.Show
    
End Sub

Public Function GetScanDBConnString() As String
    
    Dim sServer As String
    Dim sDBName As String
    
    'Get the server name
    sServer = Trim(GetQualProParamString(sParamName:="ScanServer", oConn:=goConn))
    
    'Get the database name
    sDBName = Trim(GetQualProParamString(sParamName:="ScanDatabase", oConn:=goConn))
    
    'Build the connection string
    GetScanDBConnString = "driver={SQL Server};server=" & sServer & ";UID=qpsa;PWD=qpsa;database=" & sDBName
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   SelectAllText
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-12-2001
'\\
'\\ Description:    This routine selects all text in a textbox.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub SelectAllText(ctrControl As Control)

    ctrControl.SelStart = 0
    ctrControl.SelLength = Len(ctrControl.Text)
    
End Sub


    
    
    
    


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetAppVersion
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-31-2000
'\\
'\\ Description:    This routine will a formated string for the
'\\                 application version number.
'\\
'\\ Parameters:
'\\     Name                Type        Description
'\\     bIncludeBuildNo     Boolean     Specifies whether or not to
'\\                                     include the build number in
'\\                                     the version string.
'\\                                     Defaults to TRUE.
'\\
'\\ Required References:
'\\     None
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function GetAppVersion(Optional ByVal bIncludeBuildNo As Boolean = True) As String
    
    GetAppVersion = "v" & App.Major & "." & Format(App.Minor, "00") & IIf(bIncludeBuildNo, "." & Format(App.Revision, "0000"), "")
    
End Function


    
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   LockFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine is used to lock a file in the unprocessed
'\\                 folder so that no other process can operate on the
'\\                 files at the same time.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     sLockFileName   String      The path and filename of the file
'\\                                 to be locked.
'\\     bWaitForever    Boolean     A flag that specifies whether or not
'\\                                 to wait here until the specified file
'\\                                 can be successfully locked.
'\\
'\\ Return Value:
'\\     Type    Description
'\\     Long    The file handle of the locked file if successfull.
'\\             -1 if bWaitForever is FALSE and the specified file
'\\             cannot be locked.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function LockFiles(sLockFileName As String, bWaitForever As Boolean) As Long
    
    Dim lFileHandle As Long
    
    Const ksWaitCommand As String = "WAITFOR DELAY '00:00:05'"
    
    'Set the error trap
    On Error GoTo LockWait
    
    'Get an available file handle
    lFileHandle = FreeFile

LockAgain:
    'Attempt to lock the file
    Open sLockFileName For Output Lock Read Write As #lFileHandle
    
    'If we made it to here then the file is locked
    LockFiles = lFileHandle
    
Exit Function


LockWait:
    'If we are here then the file is already locked
    If bWaitForever Then
        'Let's wait a while and try again
        goConn.Execute ksWaitCommand
        Resume LockAgain
    Else
        'File is already locked and we are not waiting around
        LockFiles = -1
        Exit Function
    End If
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   UnlockFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine is used to unlock a file in the unprocessed
'\\                 folder so that other processes can resume operations.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     lFileHandle     Long    The filehandle of the file to be unlocked.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub UnlockFiles(lFileHandle As Long)
    
    'If we encounter an error closing the lock file ignore it
    On Error Resume Next
    Close #lFileHandle
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetCommandLineParameter
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine will parse out the command line and
'\\                 return the value of the specified command line
'\\                 parameter.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sParamID    String      The parameter to be returned.
'\\     sParanVal   String      The variable to return the specified
'\\                             parameter's value in.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - If specified parameter is found.
'\\                 FALSE - If specified parameter is not found.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function GetCommandLineParameter(ByVal sParamID As String, _
                                        sParamVal As String) As Boolean
    
    Dim sCommand As String
    Dim nLoc1 As Integer
    Dim nLoc2 As Integer
    
    'Get the command line
    sCommand = UCase(Trim(Command$))
    sParamID = UCase(sParamID)
    
    'Find this parameter
    nLoc1 = InStr(sCommand, sParamID)
    If nLoc1 = 0 Then
        GetCommandLineParameter = False
        sParamVal = ""
        Exit Function
    End If
    
    'Determine where the end of this parameter is
    nLoc1 = nLoc1 + Len(sParamID)
    nLoc2 = InStr(nLoc1, sCommand, " ")
    If nLoc2 = 0 Then
        nLoc2 = Len(sCommand) + 1
    End If
    
    'Extract the parameter value
    sParamVal = Mid(sCommand, nLoc1, nLoc2 - nLoc1)
    GetCommandLineParameter = True
    
End Function

    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   WriteExportError
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called to update the ScanImportError
'\\                 table when an error is encountered while processing.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     sLithoCode      String  The litho code of the questionaire to
'\\                             be updated.
'\\     eErrorCode      eImportErrorCodes
'\\                             The reason code why it is unusable.
'\\     sBatchNumber    String  The batch number that this questionaire
'\\                             originated in.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'** Removed 10-11-01 JJF
'Public Sub WriteImportError(ByVal sLithoCode As String, _
'                            Optional ByVal eErrorCode As eImportErrorCodes = imcNone, _
'                            Optional ByVal sBatchNumber As String = "")
'
'    Dim sSql As String
'
'    sSql = "INSERT INTO ScanImportError " & _
'                   "(strLithoCode, datErrorDate, " & _
'                   "intErrorCode, strSTRBatchNumber) " & _
'           "VALUES " & _
'                   "('" & sLithoCode & "', getdate(), " & _
'                   eErrorCode & ", '" & sBatchNumber & "')"
'
'    goConn.Execute sSql
'
'End Sub
'** End of remove 10-11-01 JJF

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetQualProParamNum
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    This routine will query the numParam_Value field of
'\\                 the QualPro_Params table for the specified parameter
'\\                 name.
'\\
'\\ Parameters:
'\\     Name        Type                Description
'\\     sParamName  String              The parameter to be returned.
'\\     oConn       ADODB.Connection    An open DB connection
'\\
'\\ Required References:
'\\     Microsoft ActiveX Data Objects 1.5 Library
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function GetQualProParamNum(ByVal sParamName As String, _
                                   oConn As ADODB.Connection) As Long
    
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    
    On Error GoTo ErrorHandler
    
    sSql = "SELECT numParam_Value " & _
           "FROM QualPro_Params " & _
           "WHERE strParam_Nm = '" & sParamName & "'"
    
    Set oTempRs = New ADODB.Recordset
    
    With oTempRs
        .CursorLocation = adUseClient
        .Open sSql, oConn, adOpenKeyset, adLockBatchOptimistic
        Set .ActiveConnection = Nothing
        
        GetQualProParamNum = !numParam_Value
        
        .Close
    End With
    
    Set oTempRs = Nothing
    
Exit Function


ErrorHandler:
    GetQualProParamNum = 0
    If Not (oTempRs Is Nothing) Then oTempRs.Close
    Set oTempRs = Nothing
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetQualProParamString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine will query the strParam_Value field of
'\\                 the QualPro_Params table for the specified parameter
'\\                 name.
'\\
'\\ Parameters:
'\\     Name            Type                Description
'\\     sParamName  String              The parameter to be returned.
'\\     oConn       ADODB.Connection    An open DB connection
'\\
'\\ Required References:
'\\     Microsoft ActiveX Data Objects 1.5 Library
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function GetQualProParamString(ByVal sParamName As String, _
                                      oConn As ADODB.Connection) As String
    
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    
    On Error GoTo ErrorHandler
    
    sSql = "SELECT strParam_Value " & _
           "FROM QualPro_Params " & _
           "WHERE strParam_Nm = '" & sParamName & "'"
    
    Set oTempRs = New ADODB.Recordset
    
    With oTempRs
        .CursorLocation = adUseClient
        .Open sSql, oConn, adOpenKeyset, adLockBatchOptimistic
        Set .ActiveConnection = Nothing
        
        GetQualProParamString = !strParam_Value
        
        .Close
    End With
    
    Set oTempRs = Nothing
    
Exit Function


ErrorHandler:
    GetQualProParamString = ""
    If Not (oTempRs Is Nothing) Then oTempRs.Close
    Set oTempRs = Nothing
    
End Function


Public Sub SetUserLoginInfo(ByVal sUserName As String, _
                             ByVal sWorkStationName As String, _
                             ByVal iActivity As Integer, _
                             ByVal bIsSTR As Boolean, _
                             ByVal bIsVSTR As Boolean, _
                             oConn As ADODB.Connection)
    
    Dim oLoginCmd      As ADODB.Command

    'Setup the comment info command
    Set oLoginCmd = New ADODB.Command
    With oLoginCmd
        .CommandText = "TR_SetUserActivity"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = oConn
        .Parameters.Append .CreateParameter("UserName", adVarChar, adParamInput, 50, sUserName)
        .Parameters.Append .CreateParameter("WorkstationName", adVarChar, adParamInput, 50, sWorkStationName)
        .Parameters.Append .CreateParameter("Activity", adInteger, adParamInput, , iActivity)
        .Parameters.Append .CreateParameter("isSTRChecked", adBoolean, adParamInput, , bIsSTR)
        .Parameters.Append .CreateParameter("isVSTRChecked", adBoolean, adParamInput, , bIsVSTR)
    End With 'oLoginCmd
    
    oLoginCmd.Execute
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   OpenDBConnection
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-30-2000
'\\
'\\ Description:    This routine will query the QualProFunctions.Library
'\\                 object for the appropriate connection string and open
'\\                 the ADO Connection object that was passed in.
'\\
'\\ Parameters:
'\\     Name            Type                Description
'\\     oConnection     ADODB.Connection
'\\
'\\ Required References:
'\\     Microsoft ActiveX Data Objects 1.5 Library
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     03-07-02    JJF     Changed so that it uses the provided
'\\                         connection string.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'Public Sub OpenDBConnection(oConnection As ADODB.Connection)
Public Sub OpenDBConnection(oConn As ADODB.Connection, ByVal sConnString As String)
    
    '** Modified 03-07-02 JJF
    'Dim oQPLib As QualProFunctions.Library
    '
    ''Set the error handler
    'On Error GoTo ErrorHandler
    '
    ''Get a reference to the QualProFunctions.Library object
    'Set oQPLib = CreateObject("QualProFunctions.Library")
    '
    ''If the connection is already open then close it
    'CloseDBConnection oConnection:=oConnection
    '
    ''Open the connection
    'Set oConnection = New ADODB.Connection
    '#If bOverrideDatabase Then
    '    oConnection.Open "driver={SQL Server};SERVER=NRC20;UID=qpsa;PWD=qpsa;DATABASE=QP_TEST"
    '    'oConnection.Open "driver={SQL Server};SERVER=NRC20;UID=qpsa;PWD=qpsa;DATABASE=QP_DEV"
    '    'oConnection.Open "driver={SQL Server};SERVER=NRC10;UID=qpsa;PWD=qpsa;DATABASE=QP_PROD"
    '#Else
    '    oConnection.Open oQPLib.GetDBString
    '#End If
    'oConnection.CommandTimeout = 0
    '
    ''Clean up and head out of dodge
    'Set oQPLib = Nothing
    
    'Set the error handler
    On Error GoTo ErrorHandler
    
    'If the connection is already open then close it
    CloseDBConnection oConn:=oConn
    
    'Open the connection
    Set oConn = New ADODB.Connection
    oConn.Open sConnString
    oConn.CommandTimeout = 0
    '** End of modification 03-07-02 JJF
    
Exit Sub


ErrorHandler:
    Set oConn = Nothing
    'Set oQPLib = Nothing
    Err.Raise Number:=Err.Number, _
              Source:="modMain::OpenDBConnection", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   CloseDBConnection
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-30-2000
'\\
'\\ Description:    This routine will close the ADO Connection object
'\\                 that was passed in.
'\\
'\\ Parameters:
'\\     Name            Type                Description
'\\     oConn           ADODB.Connection
'\\
'\\ Required References:
'\\     Microsoft ActiveX Data Objects 1.5 Library
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub CloseDBConnection(oConn As ADODB.Connection)
    
    'Set the error handler
    On Error GoTo ErrorHandler
    
    'If the connection is already open then close it
    If Not (oConn Is Nothing) Then
        oConn.Close
    End If
    Set oConn = Nothing
    
Exit Sub


ErrorHandler:
    Set oConn = Nothing
    Err.Raise Number:=Err.Number, _
              Source:="modMain::CloseDBConnection", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub


