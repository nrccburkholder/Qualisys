Attribute VB_Name = "modMain"
Option Explicit
    
    Public gbCanResetQS As Boolean
    Public gbCanResetDM As Boolean
    Public glMaxResetCountQS As Integer
    Public glMaxResetCountDM As Integer
    Public goUserInfo As CUserInfo
    
    Public Enum ePrivLevelConstants
        plcNormal = 0
        plcPowerUser = 9
        plcAdmin = 19
    End Enum
    
    Public Enum eListviewColumnLocationConstants
        'Lithocode display mode
        eLCLLCLithoCode = 0
        eLCLLCBarcode = 1
        eLCLLCClientName = 2
        eLCLLCSurveyName = 3
        eLCLLCUndelDate = 4
        eLCLLCReturnDate = 5
        eLCLLCUnusedID = 6
        eLCLLCUnusedDate = 7
        eLCLLCImportDate = 8
        eLCLLCBatchNumber = 9
        eLCLLCLineNumber = 10
        eLCLLCScanBatch = 11
        eLCLLCSentMailID = 12
        eLCLLCQstnFormID = 13
        eLCLLCSurveyID = 14
    End Enum


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetAppVersion
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-10-2003
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


    
    
    
    
Public Sub Main()

    Dim sMsg                As String
    Dim sTemp               As String
    Dim oConn               As ADODB.Connection
    Dim sCurrentVersion     As String
    Dim sRequiredVersion    As String
    
    'Initialize the user info object
    Set goUserInfo = New CUserInfo
    
    'Read in the registry settings
    ReadRegistry
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Get the versioning information
    sCurrentVersion = GetAppVersion
    sRequiredVersion = GetQualProParamString(sParamName:="ImpNotTranVersion", oConn:=oConn)
    
    'Get the security information
    sTemp = "," & UCase(GetQualProParamString(sParamName:="ImpNotTranResetQS", oConn:=oConn)) & ","
    gbCanResetQS = (InStr(sTemp, "," & UCase(goUserInfo.UserName) & ",") > 0)
    sTemp = "," & UCase(GetQualProParamString(sParamName:="ImpNotTranResetDM", oConn:=oConn)) & ","
    gbCanResetDM = (InStr(sTemp, "," & UCase(goUserInfo.UserName) & ",") > 0)
    sTemp = GetQualProParamString(sParamName:="ImpNotTranMaxResetQS", oConn:=oConn)
    glMaxResetCountQS = Val(sTemp)
    sTemp = GetQualProParamString(sParamName:="ImpNotTranMaxResetDM", oConn:=oConn)
    glMaxResetCountDM = Val(sTemp)
    
    'Close the database
    CloseDBConnection oConn:=oConn
    
    'Determine if we are running the correct version of the software
    If sCurrentVersion <> sRequiredVersion Then
        'We are not running the required version of this program so we are out of here
        sMsg = "You are not running the most recent version of" & vbCrLf & _
               "Imported Not Transferred!" & vbCrLf & vbCrLf & _
               "Your Version: " & sCurrentVersion & vbCrLf & _
               "Required Version: " & sRequiredVersion & vbCrLf & vbCrLf & _
               "Please contact the help desk and request the" & vbCrLf & _
               "specified version be installed on this PC!"
        MsgBox sMsg, vbCritical, "Imported Not Transferred"
        Exit Sub
    End If
    
    'If we made it to here then all is good
    frmMain.Show
    
End Sub

Public Function UCaseKeyPress(ByVal nKeyAscii As Integer) As Integer
    
    UCaseKeyPress = Asc(UCase(Chr(nKeyAscii)))
    
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
    
    Dim sSql As String
    Dim oTempRS As ADODB.Recordset
    
    On Error GoTo ErrorHandler
    
    sSql = "SELECT strParam_Value " & _
           "FROM QualPro_Params " & _
           "WHERE strParam_Nm = '" & sParamName & "'"
    
    Set oTempRS = New ADODB.Recordset
    
    With oTempRS
        .CursorLocation = adUseClient
        .Open sSql, oConn, adOpenKeyset, adLockBatchOptimistic
        Set .ActiveConnection = Nothing
        
        GetQualProParamString = !strParam_Value
        
        .Close
    End With
    
    Set oTempRS = Nothing
    
Exit Function


ErrorHandler:
    GetQualProParamString = ""
    If Not (oTempRS Is Nothing) Then oTempRS.Close
    Set oTempRS = Nothing
    
End Function


Public Sub SelectAllText(ctrControl As Control)

    ctrControl.SelStart = 0
    ctrControl.SelLength = Len(ctrControl.Text)
    
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
'\\     10-26-00    JJF     Removed the use of the QualProFunctions MTS
'\\                         object so that the PC does not have to have
'\\                         QualPro in order to run this.
'\\     06-08-01    JJF     Put QualProFunctions MTS back into use so
'\\                         we do not have to recompile to put through
'\\                         the testing environment.
'\\     03-07-02    JJF     Changed so that it uses the provided
'\\                         connection string.
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


