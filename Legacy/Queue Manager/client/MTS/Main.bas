Attribute VB_Name = "modMain"
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
'\\     Microsoft ActiveX Data Objects 2.5 Library
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     09-25-2002  SH      Recompiled due to MTS objects removal
'\\                         in QualProFunctions.
'\\     09-29-2002  SH      Renamed QualProFunctions to
'\\                         QualiSysFunctions.
'\\     10-02-2002  SH      Recompiled with VB6.0 and moved DLL to
'\\                         \components\QualiSysDLLs\.
'\\     12-01-2004  SH      Added Running Total to Bundling report.
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
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Sub

Public Sub Main()
    
    'No initialization required
    
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
'\\     oConn           ADODB.Connection
'\\
'\\ Required References:
'\\     Microsoft ActiveX Data Objects 2.5 Library
'\\     QualiSysFunctions
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub OpenDBConnection(oConn As ADODB.Connection)
    
    Dim oQPLib As QualiSysFunctions.Library
    
    'Set the error handler
    On Error GoTo ErrorHandler
    
    'Get a reference to the QualiSysFunctions.Library object
    Set oQPLib = CreateObject("QualiSysFunctions.Library")
    
    'If the connection is already open then close it
    CloseDBConnection oConn:=oConn
    
    'Open the connection
    Set oConn = New ADODB.Connection
    #If bOverrideDatabase Then
        oConn.Open "driver={SQL Server};SERVER=NRC20;UID=qpsa;PWD=qpsa;DATABASE=QP_TEST"
        'oConn.Open "driver={SQL Server};SERVER=NRC20;UID=qpsa;PWD=qpsa;DATABASE=QP_DEV"
        'oConn.Open "driver={SQL Server};SERVER=NRC10;UID=qpsa;PWD=qpsa;DATABASE=QP_PROD"
    #Else
        oConn.Open oQPLib.GetDBString
    #End If
    oConn.CommandTimeout = 0
    
    'Clean up and head out of dodge
    Set oQPLib = Nothing
    
    Exit Sub

ErrorHandler:
    Set oConn = Nothing
    Set oQPLib = Nothing
    Err.Raise Err.Number, Err.Source, Err.Description
    
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




