VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CUserInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

    
Public Function CanLaunchApp(ByVal sUserName As String, ByVal sProgramName As String, _
                             ByVal sDatabaseName As String, ByRef oConn As ADODB.Connection, _
                             ByVal sQPParamPrefix As String, ByRef sMessage As String) As Boolean
    
    Dim nQtyRunning As Integer
    Dim sHours      As String
    Dim sRestrict   As String
    Dim sOverride   As String
    Dim sTemp       As String
    Dim dtTime      As Date
    Dim oTimes      As CTimes
    
    'Get the current time
    dtTime = Now
    
    'Get the quantity of running instances of this app
    nQtyRunning = HowManyRunning(sProgramName:=sProgramName, sDatabaseName:=sDatabaseName, oConn:=oConn)
    
    'Get the hours of operation and the restrictions from the database
    sHours = GetQualProParamString(sParamName:=sQPParamPrefix & "Hours", oConn:=oConn)
    sRestrict = UCase("," & Trim(GetQualProParamString(sParamName:=sQPParamPrefix & "Restrict", oConn:=oConn)) & ",")
    sOverride = UCase("," & Trim(GetQualProParamString(sParamName:=sQPParamPrefix & "Override", oConn:=oConn)) & ",")
    
    'Check to see if user name is restricted
    If InStr(sRestrict, "," & UCase(sUserName) & ",") > 0 And UCase(sUserName) = "BLIETKA" Then
        sMessage = "Sorry Bob, it has been determined that you do not" & vbCrLf & _
                   "have sufficient security clearance to utilize this" & vbCrLf & _
                   "or any other National Research Corp software!!!" & vbCrLf & vbCrLf & _
                   "If you persist in attempting to use this application" & vbCrLf & _
                   "a power surge will be sent through your keyboard" & vbCrLf & _
                   "with sufficient voltage to render you harmless!!!"
        CanLaunchApp = False
        Exit Function
    ElseIf InStr(sRestrict, "," & UCase(sUserName) & ",") > 0 And UCase(sUserName) = "JVONFELDT" Then
        sMessage = "Sorry Josh, due to your lack of motivation and limp" & vbCrLf & _
                   "leadership skills as reflected by the lack of any" & vbCrLf & _
                   "company awards being given to you, we are no longer" & vbCrLf & _
                   "willing to allow you to do your job!!!" & vbCrLf & vbCrLf & _
                   "Please check back once you have received as many" & vbCrLf & _
                   "awards as your Comments group counterpart!!!"
        CanLaunchApp = False
        Exit Function
    ElseIf InStr(sRestrict, "," & UCase(sUserName) & ",") > 0 And UCase(sUserName) = "AHARRIS" Then
        sMessage = "Sorry Adam, you will no longer be allowed to run" & vbCrLf & _
                   "this software until you keep us posted as to the" & vbCrLf & _
                   "whereabouts of Big Daddy on a weekly basis!!!" & vbCrLf & vbCrLf & _
                   "Failure to do so will result in very bad things!!!"
        CanLaunchApp = False
        Exit Function
    ElseIf InStr(sRestrict, "," & UCase(sUserName) & ",") > 0 Then
        sMessage = "User Name '" & sUserName & "' does not have permission" & vbCrLf & _
                   "to use '" & sProgramName & "'!"
        CanLaunchApp = False
        Exit Function
    End If
    
    'Check to see if user has override privilege
    If InStr(sOverride, "," & UCase(sUserName) & ",") > 0 Then
        sMessage = ""
        CanLaunchApp = True
        Exit Function
    End If
    
    'Populate the Times collection
    Set oTimes = New CTimes
    oTimes.Populate sParamString:=sHours
    
    'Check to see if we are in the appropriate time frames
    If Not oTimes.IsTimeValid(dtTime:=dtTime) Then
        sMessage = "'" & sProgramName & "' cannot be executed at this time!!!" & vbCrLf & vbCrLf & _
                   "The valid hours of operation for this software are:" & vbCrLf & vbCrLf & oTimes.HoursOfOperation
        CanLaunchApp = False
        Exit Function
    ElseIf Not oTimes.IsQtyValid(dtTime:=dtTime, nQtyRunning:=nQtyRunning) Then
        sTemp = GetUserList(sProgramName:=sProgramName, _
                            sDatabaseName:=sDatabaseName, _
                            oConn:=oConn)
        sMessage = "The maximum number of running '" & sProgramName & "' has been reached!!!" & vbCrLf & vbCrLf & sTemp
        CanLaunchApp = False
        Exit Function
    End If
    
    'Cleanup
    Set oTimes = Nothing
    
    'If we made it to here then all is well
    sMessage = ""
    CanLaunchApp = True
    
End Function

Public Function CanContinueApp(ByVal sUserName As String, ByVal sProgramName As String, _
                               ByVal sDatabaseName As String, ByRef oConn As ADODB.Connection, _
                               ByVal sQPParamPrefix As String, ByRef sMessage As String) As Boolean
    
    Dim nQtyRunning As Integer
    Dim sHours      As String
    Dim sRestrict   As String
    Dim sOverride   As String
    Dim sTemp       As String
    Dim dtTime      As Date
    Dim oTimes      As CTimes
    
    'Get the current time
    dtTime = Now
    
    'Get the quantity of running instances of this app
    nQtyRunning = HowManyRunning(sProgramName:=sProgramName, sDatabaseName:=sDatabaseName, oConn:=oConn)
    
    'Get the hours of operation and the restrictions from the database
    sHours = GetQualProParamString(sParamName:=sQPParamPrefix & "Hours", oConn:=oConn)
    sOverride = UCase("," & Trim(GetQualProParamString(sParamName:=sQPParamPrefix & "Override", oConn:=oConn)) & ",")
    
    'Check to see if user has override privilege
    If InStr(sOverride, "," & UCase(sUserName) & ",") > 0 Then
        sMessage = ""
        CanContinueApp = True
        Exit Function
    End If
    
    'Populate the Times collection
    Set oTimes = New CTimes
    oTimes.Populate sParamString:=sHours
    
    'Check to see if we are in the appropriate time frames
    If Not oTimes.IsTimeValid(dtTime:=dtTime) Then
        sMessage = "Outside valid hours of operation!"
        CanContinueApp = False
        Exit Function
    ElseIf Not oTimes.IsQtyValid(dtTime:=dtTime, nQtyRunning:=nQtyRunning) Then
        sMessage = "The maximum of running apps has been reached!!!"
        CanContinueApp = False
        Exit Function
    End If
    
    'Cleanup
    Set oTimes = Nothing
    
    'If we made it to here then all is well
    sMessage = ""
    CanContinueApp = True
    
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
Private Function GetQualProParamString(ByVal sParamName As String, _
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



Private Function GetUserList(ByVal sProgramName As String, ByVal sDatabaseName As String, ByRef oConn As ADODB.Connection) As String
    
    Dim sSql    As String
    Dim sMsg    As String
    Dim oTempRS As ADODB.Recordset

    'Get the list of users currently running this program
    sSql = "SELECT hostname AS strWorkstation, Count(*) AS intQtyRunning " & _
           "FROM master.dbo.sysprocesses sp, master.dbo.sysdatabases sd " & _
           "WHERE sp.dbid = sd.dbid " & _
           "  AND program_name = '" & sProgramName & "' " & _
           "  AND name = '" & sDatabaseName & "' " & _
           "GROUP BY hostname " & _
           "ORDER BY hostname"
    Set oTempRS = oConn.Execute(sSql)
    
    'Assemble the message text
    With oTempRS
        Do Until .EOF
            sMsg = sMsg & vbCrLf & Trim(!strWorkstation) & " (" & !intQtyRunning & ")"
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With
    
    'Finish the message
    If Len(Trim(sMsg)) = 0 Then
        sMsg = "There are currently no workstations running '" & sProgramName & "'."
    Else
        sMsg = "The following workstations have '" & sProgramName & "' running:" & vbCrLf & sMsg
    End If
    
    'Cleanup
    oTempRS.Close: Set oTempRS = Nothing
    
    'Set return value
    GetUserList = sMsg
    
End Function

Private Function HowManyRunning(ByVal sProgramName As String, ByVal sDatabaseName As String, ByRef oConn As ADODB.Connection) As Integer
    
    Dim sSql    As String
    Dim nQty    As Integer
    Dim oTempRS As ADODB.Recordset

    'Get the list of users currently running this program
    sSql = "SELECT Count(*) AS intQtyRunning " & _
           "FROM master.dbo.sysprocesses sp, master.dbo.sysdatabases sd " & _
           "WHERE sp.dbid = sd.dbid " & _
           "  AND program_name = '" & sProgramName & "' " & _
           "  AND name = '" & sDatabaseName & "'"
    Set oTempRS = oConn.Execute(sSql)
    
    'Get the quantity
    nQty = oTempRS!intQtyRunning
    
    'Cleanup
    oTempRS.Close: Set oTempRS = Nothing
    
    'Set the return value
    HowManyRunning = nQty
    
End Function

Public Sub ShowCurrentUsersDialog(ByVal sProgramName As String, ByVal sDatabaseName As String, ByRef oConn As ADODB.Connection)
    
    Dim sMsg As String
    
    'Get the message
    sMsg = GetUserList(sProgramName:=sProgramName, _
                       sDatabaseName:=sDatabaseName, _
                       oConn:=oConn)
    
    'Display the message
    MsgBox sMsg, vbInformation + vbOKOnly, "Current Workstations Listing"
    
End Sub



