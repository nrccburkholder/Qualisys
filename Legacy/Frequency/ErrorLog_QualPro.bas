Attribute VB_Name = "ErrorLog_QualPro"
Option Explicit


Public Function fctErrorLog_QualPro(pNtUid As String, _
                                                pQpModule As String, _
                                                pSubModule As String, _
                                                pPCName As String, _
                                                pErrSource As String, _
                                                pErrDescription As String, _
                                                pErrLastDllError As String, _
                                                pMemoryVariables As String, _
                                                perrNumber As String _
                                                ) As Boolean

    Dim oQualProFunctionsLibrary As QualProFunctions.Library
    Dim strDSN_Info As String
    Dim DataBaseConnection As New ADODB.Connection
    Dim strSql As String
    Dim vntReturnValue As Variant

    
    fctErrorLog_QualPro = False
    
    Set oQualProFunctionsLibrary = CreateObject("QualProFunctions.Library")
    
    strDSN_Info = oQualProFunctionsLibrary.GetDBString()
    
    DataBaseConnection.Open strDSN_Info
    
    Set oQualProFunctionsLibrary = Nothing
        
    strSql = _
    "INSERT INTO ErrorLog_QualPro (NtUid, QpModule, SubModule, PCName,   ErrSource ,ErrDescription, ErrLastDllError,MemoryVariables,errnumber,errTimeStamp) Values (" _
            & "'" & pNtUid & "'" & "," _
            & "'" & pQpModule & "'" & "," _
            & "'" & pSubModule & "'" & "," _
            & "'" & pPCName & "'" & "," _
            & "'" & pErrSource & "'" & "," _
            & "'" & pErrDescription & "'" & "," _
            & "'" & pErrLastDllError & "'" & "," _
            & "'" & pMemoryVariables & "'" & "," _
            & "'" & perrNumber & "'" & "," _
            & "'" & Now() & "'" & ")"
            
    DataBaseConnection.Execute (strSql)

    DataBaseConnection.Close
    
    fctErrorLog_QualPro = True
    
    Beep
    Beep

    MsgBox vbCrLf & " An unexpected error has ocurred in your application." & vbCrLf _
        & vbCrLf _
        & vbCrLf _
        & vbCrLf & vbCrLf & vbCrLf & vbCrLf, vbCritical, "National Research Corporation"

    MsgBox vbCrLf & " This error has been logged to the QualPro Error Log" & vbCrLf _
        & vbCrLf _
        & vbCrLf _
        & "Please enter a quick synopsis of what task you were trying to complete, and any information that would help Information Services recreate the scenario. " _
        & vbCrLf _
        & vbCrLf _
        & "Thank you for your support." _
        & vbCrLf _
        & vbCrLf _
        & "  Shutting Down... " & vbCrLf & vbCrLf & vbCrLf & vbCrLf, vbInformation, "QualPro"

    Beep
    Beep
    'vntReturnValue = Shell("C:\Program Files\Microsoft Office\Office\MSACCESS.EXE \\NRC5\QualPro\QualPr~1\IssueL~1\Accept~1.mdb", vbMaximizedFocus)
    Beep
    Beep
    
    End
    End
    End
    End

End Function



Private Function fctComment()
'Declare Function WNetGetUser& Lib "mpr.dll" Alias "WNetGetUserA" (ByVal lpName As String, _
                                                                        ByVal lpUserName As String, lpnLength As Long)
'
'Description
'
'Used to retrieve the name under which a network resource was connected.
'
'Use with VB
'
'No Problem
'
'
'Parameter   Type/Description
'lpName  String — The remote name or local name of the connected resource. vbNullString to retreive the name of the current user.
'lpUserName  String — A string buffer to load with the user name.
'lpnLength   Long — The length of the lpUserName buffer. Set to the necessary buffer size if the buffer was not large enough.
'Return Value
'
'Long — Zero on success. Sets GetLastError. If GetLastError is ERROR_EXTENDED_ERROR use WNetGetLastError to retrieve additional error information.
'
'Platform
'
'Windows 95, Windows NT
'
'All of the material presented here is copyrighted by either Desaware or Macmillan. No part of this material may be used or reproduced in any fashion (except in brief quotations used in critical articles and reviews) without prior consent.
End Function

Private Function fctGetUserNetId()

'Declare Function WNetGetUser& Lib "mpr.dll" Alias "WNetGetUserA" (ByVal lpName As String, _
'                                                                        ByVal lpUserName As String, lpnLength As Long)
                                                                        
End Function
