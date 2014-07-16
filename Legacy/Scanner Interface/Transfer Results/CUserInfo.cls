VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CUserInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

    Private Const mksMaxUserNameLength = 256    'UNLEN as defined in LMCONS.H
    Private Const mksMaxComputerNameLength = 31 'MAX_COMPUTERNAME_LENGTH as defined in WINBASE.H
    
    Private Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" _
                    (ByVal lpBuffer As String, nSize As Long) As Long
    Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" _
                    (ByVal lpBuffer As String, nSize As Long) As Long


Public Property Get UserName() As String
    
    Dim sBuffer     As String
    Dim lBufferSize As Long
    Dim lReturn     As Long
    
    'Prepare the buffer
    lBufferSize = mksMaxUserNameLength
    sBuffer = String(lBufferSize + 1, 0)
    
    'Get the user name from the API
    lReturn = GetUserName(sBuffer, lBufferSize)
    
    'Determine the return value
    If lReturn > 0 Then
        'Everything worked so return the user name
        UserName = Left(sBuffer, lBufferSize - 1)
    Else
        'An error was encountered so return an empty string
        UserName = ""
    End If
    
End Property

Public Property Get ComputerName() As String
    
    Dim sBuffer As String
    Dim lBufferSize As Long
    Dim lReturn As Long
    
    'Prepare the buffer
    lBufferSize = mksMaxComputerNameLength
    sBuffer = String(lBufferSize + 1, 0)
    
    'Get the computer name from the API
    lReturn = GetComputerName(sBuffer, lBufferSize)
    
    'Determine the return value
    If lReturn > 0 Then
        'Everything worked so return the computer name
        ComputerName = Left(sBuffer, lBufferSize)
    Else
        'An error was encountered so return an empty string
        ComputerName = ""
    End If
    
End Property

