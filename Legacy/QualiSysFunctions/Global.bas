Attribute VB_Name = "Global"
Option Explicit

Public Declare Function RegQueryValueExNULL Lib "advapi32.dll" Alias _
    "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As _
    String, ByVal lpReserved As Long, lpType As Long, ByVal lpData _
    As Long, lpcbData As Long) As Long
Public Declare Function RegQueryValueExString Lib "advapi32.dll" Alias _
    "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As _
    String, ByVal lpReserved As Long, lpType As Long, ByVal lpData _
    As String, lpcbData As Long) As Long
Public Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias _
    "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
Public Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long

Public Const ERROR_SUCCESS = 0&
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const KEY_QUERY_VALUE As Long = 1

Public Function GetRegValue(ValueItem As String)
    
    On Error GoTo ErrorHandler
    
    Dim cch As Long
    Dim lType As Long
    Dim sValue As String
    Dim KeyHandle As Long
    Dim Res As Long
    Dim RegistryKey As String
    
    RegistryKey = "SOFTWARE\QualiSys\Connection"
    
    Res = RegOpenKeyEx(HKEY_LOCAL_MACHINE, RegistryKey, 0, KEY_QUERY_VALUE, KeyHandle)
    If Res <> ERROR_SUCCESS Then
        GetRegValue = "-1"
        Exit Function
    End If
    
    Res = RegQueryValueExNULL(KeyHandle, ValueItem, 0&, lType, 0&, cch)
    If Res <> ERROR_SUCCESS Then
        GetRegValue = "-1"
        Exit Function
    End If
    
    sValue = String(cch, 0)
    Res = RegQueryValueExString(KeyHandle, ValueItem, 0&, lType, _
                                            sValue, cch)
    If Res = ERROR_SUCCESS Then
        sValue = Left$(sValue, cch - 1)
    Else
        sValue = "-1"
    End If
    
    Call RegCloseKey(KeyHandle)
    
    GetRegValue = sValue

    Exit Function
    
ErrorHandler:
    App.LogEvent "FormGenUtilities:cRegistry:GetRegValue, " & _
        Err.Number & ", " & Err.Description, vbLogEventTypeError
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function
