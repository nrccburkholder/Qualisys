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

Global Const RHospital = 70
Global Const RConfiguration = 71
Global Const RBundle = 72
Global Const RFadedConfiguration = 73
Global Const RGroupedPrintHospital = 74
Global Const RGroupedPrintConfiguration = 75
Global Const RCheckedHospital = 76
Global Const RCheckedBundle = 77
Global Const RCheckedConfiguration = 78
Global Const RCheckedGroupedPrintHospital = 79
Global Const RMailBundle = 80
Global Const RAlreadyMailed = 81
Global Const RDeleted = 82
Global Const RPrinting = 83

Public fMainForm As frmMain

' These functions (IsCyan, IsPurple, etc.) replace the prior (IsHCAHPS, IsHHCAHPS, etc.) with the refactor to use FolderColor properties
Public Function IsCyan(ByVal image As Integer) As Boolean
    IsCyan = IIf(image > conCheckedGroupedPrintHospital And image < HHHospital, True, False)
End Function

Public Function IsPurple(ByVal image As Integer) As Boolean
    IsPurple = IIf(image > HPrinting And image < AHospital, True, False)
End Function

Public Function IsOrange(ByVal image As Integer) As Boolean
    IsOrange = IIf(image > HHPrinting And image < RHospital, True, False)
End Function

Public Function IsRed(ByVal image As Integer) As Boolean
    IsRed = IIf(image > APrinting, True, False)
End Function

Public Function IsManila(ByVal image As Integer) As Boolean
    Select Case image
        Case 6, 12, 13, 14, 16, 18, 19, 21, 22, 23, 24, 25, 26, 27
            IsManila = True
        Case Else
            IsManila = False
    End Select
End Function

'''''''''''''''''''''''''''''''
'
' The functions below like IsHospital take as a parameter an index of an icon
' and return a boolean indicating if it is a Hospital icon of any color
'
'''''''''''''''''''''''''''''''

Public Function IsHospital(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conHospital, HHospital, HHHospital, AHospital, RHospital
            IsHospital = True
        Case Else
            IsHospital = False
    End Select
End Function

Public Function IsConfiguration(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conConfiguration, HConfiguration, HHConfiguration, AConfiguration, RConfiguration
            IsConfiguration = True
        Case Else
            IsConfiguration = False
    End Select
End Function

Public Function IsBundle(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conBundle, HBundle, HHBundle, ABundle, RBundle
            IsBundle = True
        Case Else
            IsBundle = False
    End Select
End Function

Public Function IsFadedConfiguration(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conFadedConfiguration, HFadedConfiguration, HHFadedConfiguration, AFadedConfiguration, RFadedConfiguration
            IsFadedConfiguration = True
        Case Else
            IsFadedConfiguration = False
    End Select
End Function

Public Function IsGroupedPrintHospital(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conGroupedPrintHospital, HGroupedPrintHospital, HHGroupedPrintHospital, AGroupedPrintHospital, RGroupedPrintHospital
            IsGroupedPrintHospital = True
        Case Else
            IsGroupedPrintHospital = False
    End Select
End Function

Public Function IsGroupedPrintConfiguration(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conGroupedPrintConfiguration, HGroupedPrintConfiguration, HHGroupedPrintConfiguration, AGroupedPrintConfiguration, RGroupedPrintConfiguration
            IsGroupedPrintConfiguration = True
        Case Else
            IsGroupedPrintConfiguration = False
    End Select
End Function

Public Function IsCheckedHospital(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conCheckedHospital, HCheckedHospital, HHCheckedHospital, ACheckedHospital, RCheckedHospital
            IsCheckedHospital = True
        Case Else
            IsCheckedHospital = False
    End Select
End Function

Public Function IsCheckedConfiguration(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conCheckedConfiguration, HCheckedConfiguration, HHCheckedConfiguration, ACheckedConfiguration, RCheckedConfiguration
            IsCheckedConfiguration = True
        Case Else
            IsCheckedConfiguration = False
    End Select
End Function

Public Function IsCheckedGroupedPrintHospital(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conCheckedGroupedPrintHospital, HCheckedGroupedPrintHospital, HHCheckedGroupedPrintHospital, ACheckedGroupedPrintHospital, RCheckedGroupedPrintHospital
            IsCheckedGroupedPrintHospital = True
        Case Else
            IsCheckedGroupedPrintHospital = False
    End Select
End Function

Public Function IsMailBundle(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conMailBundle, HMailBundle, HHMailBundle, AMailBundle, RMailBundle
            IsMailBundle = True
        Case Else
            IsMailBundle = False
    End Select
End Function

Public Function IsAlreadyMailed(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conAlreadyMailed, HAlreadyMailed, HHAlreadyMailed, AAlreadyMailed, RAlreadyMailed
            IsAlreadyMailed = True
        Case Else
            IsAlreadyMailed = False
    End Select
End Function

Public Function IsDeleted(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conDeleted, HDeleted, HHDeleted, ADeleted, RDeleted
            IsDeleted = True
        Case Else
            IsDeleted = False
    End Select
End Function

Public Function IsPrinting(ByVal imageIndex As Integer) As Boolean
    Select Case imageIndex
        Case conPrinting, HPrinting, HHPrinting, APrinting, RPrinting
            IsPrinting = True
        Case Else
            IsPrinting = False
    End Select
End Function

'''''''''''''''''''''''''''''''
'
' The function sIconByColor takes a first parameter indicating the color,
' and then an icon imageIndex of each color of any desired icon (Hospital, etc.)
' and returns the icon from the list of the color passed in
'
'''''''''''''''''''''''''''''''

Private Function sIconByColor(sColor As String, ByVal manilaIcon As Integer, ByVal cyanIcon As Integer, ByVal purpleIcon As Integer, ByVal orangeIcon As Integer, _
                              ByVal redIcon As Integer) As Integer
    If sColor = "Manila" Then
        sIconByColor = manilaIcon
    ElseIf sColor = "Cyan" Then
        sIconByColor = cyanIcon
    ElseIf sColor = "Purple" Then
        sIconByColor = purpleIcon
    ElseIf sColor = "Orange" Then
        sIconByColor = orangeIcon
    ElseIf sColor = "Red" Then
        sIconByColor = redIcon
    Else
        sIconByColor = manilaIcon
    End If
End Function

'''''''''''''''''''''''''''''''
'
' The function IconByIndex takes a first parameter of an icon imageIndex to color match,
' and then an icon imageIndex of each color of any desired icon (Hospital, etc.)
' and returns the icon from the list which matches the first parameter icon imageIndex color
'
'''''''''''''''''''''''''''''''

Private Function IconByIndex(ByVal imageIndex As Integer, ByVal manilaIcon As Integer, ByVal cyanIcon As Integer, ByVal purpleIcon As Integer, ByVal orangeIcon As Integer, _
                             ByVal redIcon As Integer) As Integer
    If IsManila(imageIndex) Then
        IconByIndex = manilaIcon
    ElseIf IsCyan(imageIndex) Then
        IconByIndex = cyanIcon
    ElseIf IsPurple(imageIndex) Then
        IconByIndex = purpleIcon
    ElseIf IsOrange(imageIndex) Then
        IconByIndex = orangeIcon
    ElseIf IsRed(imageIndex) Then
        IconByIndex = redIcon
    Else
        IconByIndex = manilaIcon
    End If
End Function

'''''''''''''''''''''''''''''''
'
' The functions below of the form sIconType
' return an icon type based on the name of the function
' and of the color indicated by the sColor parameter
'
' The functions below of the form IconType
' return an icon type based on the name of the function
' which is the same color as the icon indicated by the imageIndex parameter
'
'''''''''''''''''''''''''''''''

Public Function sHospital(ByVal sColor As String) As Integer
    sHospital = sIconByColor(sColor, conHospital, HHospital, HHHospital, AHospital, RHospital)
End Function

Public Function Hospital(ByVal imageIndex As Integer) As Integer
    Hospital = IconByIndex(imageIndex, conHospital, HHospital, HHHospital, AHospital, RHospital)
End Function

Public Function sConfiguration(ByVal sColor As String) As Integer
    sConfiguration = sIconByColor(sColor, conConfiguration, HConfiguration, HHConfiguration, AConfiguration, RConfiguration)
End Function

Public Function Configuration(ByVal imageIndex As Integer) As Integer
    Configuration = IconByIndex(imageIndex, conConfiguration, HConfiguration, HHConfiguration, AConfiguration, RConfiguration)
End Function

Public Function Bundle(ByVal imageIndex As Integer) As Integer
    Bundle = IconByIndex(imageIndex, conBundle, HBundle, HHBundle, ABundle, RBundle)
End Function

Public Function sFadedConfiguration(ByVal sColor As String) As Integer
    sFadedConfiguration = sIconByColor(sColor, conFadedConfiguration, HFadedConfiguration, HHFadedConfiguration, AFadedConfiguration, RFadedConfiguration)
End Function

Public Function FadedConfiguration(ByVal imageIndex As Integer) As Integer
    FadedConfiguration = IconByIndex(imageIndex, conFadedConfiguration, HFadedConfiguration, HHFadedConfiguration, AFadedConfiguration, RFadedConfiguration)
End Function

Public Function sGroupedPrintHospital(ByVal sColor As String) As Integer
    sGroupedPrintHospital = sIconByColor(sColor, conGroupedPrintHospital, HGroupedPrintHospital, HHGroupedPrintHospital, AGroupedPrintHospital, RGroupedPrintHospital)
End Function

Public Function GroupedPrintHospital(ByVal imageIndex As Integer) As Integer
    GroupedPrintHospital = IconByIndex(imageIndex, conGroupedPrintHospital, HGroupedPrintHospital, HHGroupedPrintHospital, AGroupedPrintHospital, RGroupedPrintHospital)
End Function

Public Function sGroupedPrintConfiguration(ByVal sColor As String) As Integer
    sGroupedPrintConfiguration = sIconByColor(sColor, conGroupedPrintConfiguration, HGroupedPrintConfiguration, HHGroupedPrintConfiguration, AGroupedPrintConfiguration, RGroupedPrintConfiguration)
End Function

Public Function sCheckedHospital(ByVal sColor As String) As Integer
    sCheckedHospital = sIconByColor(sColor, conCheckedHospital, HCheckedHospital, HHCheckedHospital, ACheckedHospital, RCheckedHospital)
End Function

Public Function CheckedHospital(ByVal imageIndex As Integer) As Integer
    CheckedHospital = IconByIndex(imageIndex, conCheckedHospital, HCheckedHospital, HHCheckedHospital, ACheckedHospital, RCheckedHospital)
End Function

Public Function sCheckedConfiguration(ByVal sColor As String) As Integer
    sCheckedConfiguration = sIconByColor(sColor, conCheckedConfiguration, HCheckedConfiguration, HHCheckedConfiguration, ACheckedConfiguration, RCheckedConfiguration)
End Function

Public Function CheckedConfiguration(ByVal imageIndex As Integer) As Integer
    CheckedConfiguration = IconByIndex(imageIndex, conCheckedConfiguration, HCheckedConfiguration, HHCheckedConfiguration, ACheckedConfiguration, RCheckedConfiguration)
End Function

Public Function sCheckedGroupedPrintHospital(ByVal sColor As String) As Integer
    sCheckedGroupedPrintHospital = sIconByColor(sColor, conCheckedGroupedPrintHospital, HCheckedGroupedPrintHospital, HHCheckedGroupedPrintHospital, ACheckedGroupedPrintHospital, RCheckedGroupedPrintHospital)
End Function

Public Function CheckedGroupedPrintHospital(ByVal imageIndex As Integer) As Integer
    CheckedGroupedPrintHospital = IconByIndex(imageIndex, conCheckedGroupedPrintHospital, HCheckedGroupedPrintHospital, HHCheckedGroupedPrintHospital, ACheckedGroupedPrintHospital, RCheckedGroupedPrintHospital)
End Function

Public Function sMailBundle(ByVal sColor As String) As Integer
    sMailBundle = sIconByColor(sColor, conMailBundle, HMailBundle, HHMailBundle, AMailBundle, RMailBundle)
End Function

Public Function MailBundle(ByVal imageIndex As Integer) As Integer
    MailBundle = IconByIndex(imageIndex, conMailBundle, HMailBundle, HHMailBundle, AMailBundle, RMailBundle)
End Function

Public Function AlreadyMailed(ByVal imageIndex As Integer) As Integer
    AlreadyMailed = IconByIndex(imageIndex, conAlreadyMailed, HAlreadyMailed, HHAlreadyMailed, AAlreadyMailed, RAlreadyMailed)
End Function

Public Function Deleted(ByVal imageIndex As Integer) As Integer
    Deleted = IconByIndex(imageIndex, conDeleted, HDeleted, HHDeleted, ADeleted, RDeleted)
End Function

Public Function Printing(ByVal imageIndex As Integer) As Integer
    Printing = IconByIndex(imageIndex, conPrinting, HPrinting, HHPrinting, APrinting, RPrinting)
End Function


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

