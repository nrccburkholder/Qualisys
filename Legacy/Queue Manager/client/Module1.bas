Attribute VB_Name = "modQueueManager"
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       OLE Automation
'       Queue Manager DLL
'
' Revisions:
'       Date        By  Description
'       10-04-2002  SH  Recompiled with VB6.0 and moved EXE to
'                       \components\QualiSysEXEs\.
'       05-01-2006  SH  Added the image for HCAHPS.
'-----------------------------------------------------------------

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
Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const KEY_QUERY_VALUE As Long = 1

Global Const LISTVIEW_BUTTON = 11
Global Const conMailBundle = 18
Global Const conAlreadyMailed = 19
Global Const conDeleted = 6
Global Const conHospital = 12
Global Const conConfiguration = 13
Global Const conBundle = 14
Global Const conPrinting = 16
Global Const conGroupedPrint = 20
Global Const conFadedConfiguration = 21
Global Const conGroupedPrintHospital = 22
Global Const conGroupedPrintConfiguration = 23
Global Const conCheckedHospital = 24
Global Const conCheckedBundle = 25
Global Const conCheckedConfiguration = 26
Global Const conCheckedGroupedPrintHospital = 27

' 04-27-2006 SH Added HCAHPS
Global Const HHospital = 28
Global Const HConfiguration = 29
Global Const HBundle = 30
Global Const HFadedConfiguration = 31
Global Const HGroupedPrintHospital = 32
Global Const HGroupedPrintConfiguration = 33
Global Const HCheckedHospital = 34
Global Const HCheckedBundle = 35
Global Const HCheckedConfiguration = 36
Global Const HCheckedGroupedPrintHospital = 37
Global Const HMailBundle = 38
Global Const HAlreadyMailed = 39
Global Const HDeleted = 40
Global Const HPrinting = 41

' 01-08-2010 JJF - Added HHCAHPS / ACOCAHPS CJB 01-09-2014
Global Const HHHospital = 42
Global Const HHConfiguration = 43
Global Const HHBundle = 44
Global Const HHFadedConfiguration = 45
Global Const HHGroupedPrintHospital = 46
Global Const HHGroupedPrintConfiguration = 47
Global Const HHCheckedHospital = 48
Global Const HHCheckedBundle = 49
Global Const HHCheckedConfiguration = 50
Global Const HHCheckedGroupedPrintHospital = 51
Global Const HHMailBundle = 52
Global Const HHAlreadyMailed = 53
Global Const HHDeleted = 54
Global Const HHPrinting = 55

Global Const AHospital = 56
Global Const AConfiguration = 57
Global Const ABundle = 58
Global Const AFadedConfiguration = 59
Global Const AGroupedPrintHospital = 60
Global Const AGroupedPrintConfiguration = 61
Global Const ACheckedHospital = 62
Global Const ACheckedBundle = 63
Global Const ACheckedConfiguration = 64
Global Const ACheckedGroupedPrintHospital = 65
Global Const AMailBundle = 66
Global Const AAlreadyMailed = 67
Global Const ADeleted = 68
Global Const APrinting = 69

Public fMainForm As frmMain

'01-19-2010 JJF - Added HHCAHPS / ACOCAHPS CJB 01-09-2014
Public Function IsHCAHPS(ByVal image As Integer) As Boolean
    ' HCAHPS image starts at 28 (after conCheckedGroupedPrintHospital).
    'IsHCAHPS = IIf(image > conCheckedGroupedPrintHospital, True, False)
    IsHCAHPS = IIf(image > conCheckedGroupedPrintHospital And image < HHHospital, True, False)
End Function
' *** end of addition

'01-19-2010 JJF - Added HHCAHPS / ACOCAHPS CJB 01-09-2014
Public Function IsHHCAHPS(ByVal image As Integer) As Boolean
    'HHCAHPS image starts at 42 (after HPrinting).
    IsHHCAHPS = IIf(image > HPrinting And image < AHospital, True, False)
End Function

Public Function IsACOCAHPS(ByVal image As Integer) As Boolean
    'HHCAHPS image starts at 56 (after HHPrinting).
    IsACOCAHPS = IIf(image > HHPrinting, True, False)
End Function

' *** end of addition

Sub Main()
    Set fMainForm = New frmMain
    fMainForm.Show
End Sub

Public Function GetRegValue(hKey As Long, RegistryKey, ValueItem As String)
    
    On Error GoTo ErrorHandler
    
    Dim cch As Long
    Dim lType As Long
    Dim sValue As String
    Dim KeyHandle As Long
    Dim Res As Long
    
    Res = RegOpenKeyEx(hKey, RegistryKey, 0, KEY_QUERY_VALUE, KeyHandle)
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

