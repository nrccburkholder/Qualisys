Attribute VB_Name = "ModMain"
Option Explicit

' 12-09-2002 SH
' Renamed QualProFunctions to QualiSysFunctions.

Sub Main()
    Dim strSurvey_id As String
    Dim lngStudy_id As Long
    Dim oTagField As nrcTagField.clsSaveTagFields
    Dim oLibFunctions As QualiSysFunctions.Library
    Dim oLockData As LockData.PersonalizationTagAssignment
    Dim bLock As Boolean
    
    'Get the Command Line Argument
    strSurvey_id = Command()
    
    'Validate that it is a numeric value
    If IsNumeric(strSurvey_id) = False Or InStr(1, strSurvey_id, ".") <> 0 Then
        MsgBox "Command Line Argument must be an integer.", , "SaveTagField Error"
    Else
        Set oLibFunctions = CreateObject("QualiSysFunctions.Library")
        lngStudy_id = oLibFunctions.GetStudy_id(CLng(strSurvey_id))
        Set oLibFunctions = Nothing
        
        Set oLockData = New LockData.PersonalizationTagAssignment
        bLock = oLockData.SetLock(lngStudy_id)
        Set oTagField = CreateObject("nrcTagField.clsSaveTagFields")
        
        If bLock = True Then
            oTagField.Go lngStudy_id, CLng(strSurvey_id), True
        Else
            oTagField.Go lngStudy_id, CLng(strSurvey_id), False
        End If
        
        Set oTagField = Nothing
        Set oLockData = Nothing
    End If
End Sub
