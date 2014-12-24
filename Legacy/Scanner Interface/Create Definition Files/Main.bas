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
'\\                 and routines required to process the export files.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-10-00    JJF     Added the multiple response level command
'\\                         line parameter.
'\\     06-19-00    JJF     Added new error code for empty file issue.
'\\     08-18-00    JJF     Added progress indication to the polling.
'\\     12-20-00    JJF     Added KeepMultiReturns property.
'\\     10-11-01    JJF     Added comment processing capabilities.
'\\     03-07-02    JJF   * Added a connection object variable for the
'\\                         new location of the bubble tables.
'\\                       * Added a string variable to store the list
'\\                         of DOD survey ids needed since the bubble
'\\                         data was moved to QP_Scan and we can't do
'\\                         cross server joins.
'\\     02-13-04    JJF     Added code to deal with Handwritten
'\\                         responses.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     08-18-06    JJF     Removed revision notes.
'\\     12-02-2014  LEB     Changed file locking mechanism to use CreateFile/DeleteFile

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
        
    Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
    Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
    Private Declare Function GetLastError Lib "kernel32" () As Long
    Private Declare Function DeleteFile Lib "kernel32" Alias "DeleteFileA" (ByVal lpFileName As String) As Long
    Private Declare Function CreateFile Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As Long, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long

    Private Const FILE_SHARE_NONE As Long = 0
    Private Const GENERIC_WRITE As Long = &H40000000
    Private Const CREATE_NEW As Long = 1
    Private Const FILE_ATTRIBUTE_NORMAL As Long = &H80
    Private Const INVALID_HANDLE_VALUE As Long = -1
        
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

    'Global string to store the list of DOD survey ids
    Public gsDODSurveys As String
    
    'Comment box ID offsetused to distinguish between comment boxes and
    '  hand-written responses
    Public Const gklCmntBoxIDOffset As Long = 500000
    
    'Global object for controlling the progress bar
    Public goProgressBar As CProgressBar
    
    'Global command line parameters
    Public geMultipleResponseLevel As eMultipleResponseLevelCodes
    
    'Enum the defines the multiple response level
    Public Enum eMultipleResponseLevelCodes
        mrcProcessAllQuestions = 0
        mrcProcessMultiRespOnly = 1
        mrcProcessSingleRespOnly = 2
    End Enum
    
    'Global ADO Connection object
    Public goConn As ADODB.Connection
    Public goScanConn As ADODB.Connection
    
    'Enum that defines the constants for unused returns
    Public Enum eUnusedReturnConstants
        urcNone = 0
        urcOtherStepReturned = 1
        urcReturnAfterExpire = 2
        urcAlreadyScanned = 3
        urcKeepMultiReturns = 4
    End Enum
    
    'Enum that defines the constants for standard export
    '  error conditions
    Public Enum eExportErrorCodes
        eecNone = 0
        eecInvalidBarcode = 1
        eecNoSentMailingRecord = 2
        eecNoQuestionFormRecord = 3
        eecAlreadyMarkedReturned = 4
        eecAlreadyMarkedUndeliverable = 5
        eecLithoForDifferentCountry = 6
        eecUnknownErrorSeeFile = 99
    End Enum
    
    'Enum that defines the constants for trapped error
    '  conditions within the interface
    Public Enum eInterfaceErrorCodes
        iecErrorBase = 1000 + vbObjectError
        iecErrorUnableToGetPaths = iecErrorBase + 1
        iecErrorLoadFromFileFailed = iecErrorBase + 2
        iecErrorGetAddInfoFailed = iecErrorBase + 3
        iecErrorBuildTXTFileFailed = iecErrorBase + 4
        iecErrorGetRegStringFailed = iecErrorBase + 5
        iecErrorAddCmntBoxLinesFailed = iecErrorBase + 6
        iecErrorAddCommentBoxesFailed = iecErrorBase + 7
        iecErrorAddBarCodeLinesFailed = iecErrorBase + 8
        iecErrorAddQuestionLinesFailed = iecErrorBase + 9
        iecErrorWriteTXTFileFailed = iecErrorBase + 10
        iecErrorMinimalFileNotExist = iecErrorBase + 11
        iecErrorEmptyFileEncountered = iecErrorBase + 12
        iecErrorWriteERRFileFailed = iecErrorBase + 13
        iecErrorInvalidImages = iecErrorBase + 14
        iecErrorGetTemplateLineFailed = iecErrorBase + 15
        iecErrorAddHandwrittenResonsesFailed = iecErrorBase + 16
        iecErrorCreateLockFileFailed = iecErrorBase + 17
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
    
    'Enum that defines the execute interval types
    Public Enum eIntervalTypeCodes
        itcUseDefaultInterval = 0
        itcUseOverrideInterval = 1
    End Enum
    
    
    
    
    



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
    
    Dim sCommand    As String
    Dim nLoc1       As Integer
    Dim nLoc2       As Integer
    
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

Public Sub Main()
    
    Dim sMsg                As String
    Dim oUserInfo           As New UserInfo.CUserInfo
    Dim oUserStuff          As New CUserInfo
    Dim oConn               As ADODB.Connection
    Dim sCurrentVersion     As String
    Dim sRequiredVersion    As String
    
    'Read in all registry settings
    ReadRegistry
    
    'Open a database connection
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Determine if we can start the application
    If Not oUserInfo.CanLaunchApp(sUserName:=oUserStuff.UserName, _
                                  sProgramName:="Create Definition Files", _
                                  sDatabaseName:="QP_Prod", _
                                  oConn:=oConn, _
                                  sQPParamPrefix:="ScanExport", sMessage:=sMsg) Then
        MsgBox sMsg, vbCritical + vbOKOnly
        Exit Sub
    End If
    
    'Get the versioning information
    sCurrentVersion = GetAppVersion
    sRequiredVersion = GetQualProParamString(sParamName:="CreateDefVersion", oConn:=oConn)
    
    'Cleanup
    Set oUserInfo = Nothing
    Set oUserStuff = Nothing
    CloseDBConnection oConn:=oConn
    
    'Determine if we are running the correct version of the software
    If sCurrentVersion <> sRequiredVersion Then
        'We are not running the required version of this program so we are out of here
        sMsg = "You are not running the most recent version of" & vbCrLf & _
               "Create Definition Files!" & vbCrLf & vbCrLf & _
               "Your Version: " & sCurrentVersion & vbCrLf & _
               "Required Version: " & sRequiredVersion & vbCrLf & vbCrLf & _
               "Please contact the help desk and request the" & vbCrLf & _
               "specified version be installed on this PC!"
        MsgBox sMsg, vbCritical, "Create Definition Files"
        Exit Sub
    End If
    
    'If we made it to here then we need to launch the program
    frmScanExport.Show
    
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
'\\     QualProFunctions
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     03-07-02    JJF     Changed so that it uses the provided
'\\                         connection string.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub OpenDBConnection(oConn As ADODB.Connection, ByVal sConnString As String)
    
    'Set the error handler
    On Error GoTo ErrorHandler
    
    'If the connection is already open then close it
    CloseDBConnection oConn:=oConn
    
    'Open the connection
    Set oConn = New ADODB.Connection
    oConn.Open sConnString
    oConn.CommandTimeout = 0
    
Exit Sub


ErrorHandler:
    Set oConn = Nothing
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
'\\     oConnection     ADODB.Connection
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
    Set oTempRs = Nothing
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   WriteQFormError
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called to update the QuestionForm
'\\                 table when an unusable return is encountered.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     lQuestionFormID Long    The QuestionForm_id to be updated.
'\\     eReturnCode     eUnusedReturnConstants
'\\                             The reason code why it is unusable.
'\\     sBatchNumber    String  The batch number that this questionaire
'\\                             originated in.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Changed so that if the error is ReScan (3)
'\\                         we do not write out the STR data.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub WriteQFormError(ByVal lQuestionFormID As Long, _
                           Optional ByVal eReturnCode As eUnusedReturnConstants = urcNone, _
                           Optional ByVal sBatchNumber As String = "")
    
    Dim sSql As String
    
    If eReturnCode = urcAlreadyScanned Then
        sSql = "UPDATE QuestionForm " & _
               "SET UnusedReturn_id = " & eReturnCode & ", " & _
               "datUnusedReturn = getdate() " & _
               "WHERE QuestionForm_id = " & lQuestionFormID
    Else
        sSql = "UPDATE QuestionForm " & _
               "SET UnusedReturn_id = " & eReturnCode & ", " & _
               "datUnusedReturn = getdate(), " & _
               "strSTRBatchNumber = '" & sBatchNumber & "' " & _
               "WHERE QuestionForm_id = " & lQuestionFormID
    End If
    
    goConn.Execute sSql
    
End Sub



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   LockFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
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
    
    'FOR TESTING
    ' sLockFileName = TestFileName(sLockFileName)
    'END FOR TESTING
    
    Dim lFileHandle As Long
    Dim dtLockFileCreated As Date
    Dim lLockFileAge As Long
        
    'Set the error trap
    On Error GoTo LockWait
    
LockAgain:
    'Attempt to create the lock file
    lFileHandle = CreateFile(sLockFileName, GENERIC_WRITE, FILE_SHARE_NONE, 0&, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, 0&)
    If lFileHandle = INVALID_HANDLE_VALUE Then
        dtLockFileCreated = FileDateTime(sLockFileName)
        lLockFileAge = DateDiff("n", dtLockFileCreated, DateTime.Now) ' n = minutes
        
        'If the lock file is 10 minutes old, assume something failed, delete the file, and try again
        If lLockFileAge > 10 Then
            Kill sLockFileName
            GoTo LockAgain
        End If
        
        Err.Raise iecErrorCreateLockFileFailed
    End If
    
    'If we made it to here then the lock file has been created
    LockFiles = lFileHandle
    
Exit Function


LockWait:
    If bWaitForever Then
        'Let's wait a while and try again
        DelaySeconds (5)
        Resume LockAgain
    Else
        'Lock file already exists and we are not waiting around
        LockFiles = -1
        Exit Function
    End If
    
End Function

Private Function DelaySeconds(lSeconds As Long)
    Dim start As Date
    start = DateTime.Now
    Do While DateDiff("s", start, DateTime.Now) < lSeconds
        DoEvents
        Sleep 50
    Loop
End Function

Private Function TestFileName(strFileName As String) As String
    Dim strPrefix As String
    strPrefix = "\\TestArgus\Production\FAQSS\Dynamic"
    
    If Len(strFileName) > Len(strPrefix) Then
        If Left(strFileName, Len(strPrefix)) = strPrefix Then
            TestFileName = "K:" + Mid(strFileName, 1 + Len(strPrefix))
            Exit Function
        End If
    End If
    
    TestFileName = strFileName
            
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   UnlockFiles
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
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
Public Sub UnlockFiles(sLockFileName As String, lFileHandle As Long)
    'FOR TESTING
    ' sLockFileName = TestFileName(sLockFileName)
    'END FOR TESTING
    
    On Error GoTo UnlockFail
    
    CloseHandle (lFileHandle)
    DeleteFile (sLockFileName)
    
UnlockFail:
    Exit Sub
End Sub

