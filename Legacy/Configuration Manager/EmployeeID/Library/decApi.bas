Attribute VB_Name = "Module1"
Option Explicit

Declare Function GetUserName Lib "advapi32.dll" Alias _
                "GetUserNameA" (ByVal lpBuffer As String, _
                nSize As Long) As Long

