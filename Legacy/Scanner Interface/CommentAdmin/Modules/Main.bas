Attribute VB_Name = "modMain"
Option Explicit
    
    Public goMainForm As frmMain
    Public goUserInfo As CUserInfo
    Public goConn     As ADODB.Connection
    Public goDMConn   As ADODB.Connection   '** Added 09-29-05 JJF
    
    Public Enum eAddEditModeConstants
        eAEMAddHeader = 0
        eAEMEditHeader = 1
        eAEMAddSubHeader = 2
        eAEMEditSubHeader = 3
        eAEMAddCode = 4
        eAEMEditCode = 5
    End Enum
    
    Public Enum eStartDateModeConstants
        eSDMAddMode = 0
        eSDMEditMode = 1
    End Enum
    
    Public Enum eSurveyCodeListModeConstants
        eSCLAddMode = 0
        eSCLEditMode = 1
    End Enum
    
    Public Enum eSurveyBDUSListModeConstants
        eSBLAddMode = 0
        eSBLEditMode = 1
    End Enum
    
    Public Type MyItem
        sKey As String
        sText As String
        sSmallIcon As String
        sSubItem1 As String
        sSubItem2 As String
    End Type
    
    
    
    
Public Function GetConnServerName(ByVal oConn As ADODB.Connection) As String
    
    GetConnServerName = oConn.Properties("Server Name")
    
End Function


Public Sub SelectAllText(ctrControl As Control)

    ctrControl.SelStart = 0
    ctrControl.SelLength = Len(ctrControl.Text)
    
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
'\\     04-26-02    JJF     Changed so that it uses the provided
'\\                         connection string.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'Public Sub OpenDBConnection(oConnection As ADODB.Connection)
Public Sub OpenDBConnection(oConn As ADODB.Connection, ByVal sConnString As String)
    
    '** Modified 04-26-02 JJF
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
    '** End of modification 04-26-02 JJF
    
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


    
Public Sub Main()
    
    Dim sMsg                As String
    Dim sCurrentVersion     As String
    Dim sRequiredVersion    As String
    
    'Create the user info object
    Set goUserInfo = New CUserInfo
    
    'Read the registry settings
    ReadRegistry
    
    'Open the database connection
    OpenDBConnection oConn:=goConn, sConnString:=goRegMainDBConnString.Value
    OpenDBConnection oConn:=goDMConn, sConnString:=goRegDMartDBConnString.Value '** Added 09-29-05 JJF
    
    'Get the versioning information
    sCurrentVersion = GetAppVersion
    sRequiredVersion = GetQualProParamString(sParamName:="CmntAdminVersion", oConn:=goConn)
    
    'Determine if we are running the correct version of the software
    If sCurrentVersion <> sRequiredVersion Then
        'We are not running the required version of this program so we are out of here
        sMsg = "You are not running the most recent version of" & vbCrLf & _
               "Comment Administration!" & vbCrLf & vbCrLf & _
               "Your Version: " & sCurrentVersion & vbCrLf & _
               "Required Version: " & sRequiredVersion & vbCrLf & vbCrLf & _
               "Please contact the help desk and request the" & vbCrLf & _
               "specified version be installed on this PC!"
        MsgBox sMsg, vbCritical, "Comment Administration"
        
        'Close the database
        CloseDBConnection oConn:=goConn
        CloseDBConnection oConn:=goDMConn   '** Added 09-29-05 JJF
        
        Exit Sub
    End If
    
    'Show the main form
    Set goMainForm = New frmMain
    goMainForm.Show
    
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
    
    Dim sSql As String
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


