Option Explicit On 
Option Strict On

Imports System.IO
Imports System.Text
Imports System.Collections.Specialized

Public Enum ProfileLetterCase
    ToUpper = 1
    ToLower = 2
    KeepCase = 3
End Enum

Public Class IniWrapper

#Region " Private Declarations "

    Private Declare Function GetPrivateProfileSectionNames _
        Lib "kernel32.dll" Alias "GetPrivateProfileSectionNamesA" _
            (ByVal lpszReturnBuffer() As Byte, _
             ByVal nSize As Integer, _
             ByVal lpFileName As String) As Integer

    Private Declare Function GetPrivateProfileSection _
        Lib "kernel32" Alias "GetPrivateProfileSectionA" _
            (ByVal lpAppName As String, _
             ByVal lpReturnedString() As Byte, _
             ByVal nSize As Integer, _
             ByVal lpFileName As String) As Integer

    Private Declare Function GetPrivateProfileString _
        Lib "KERNEL32.DLL" Alias "GetPrivateProfileStringA" _
            (ByVal lpAppName As String, _
             ByVal lpKeyName As String, _
             ByVal lpDefault As String, _
             ByVal lpReturnedString As StringBuilder, _
             ByVal nSize As Integer, _
             ByVal lpFileName As String) As Integer

    Private Declare Ansi Function WritePrivateProfileString _
        Lib "kernel32.dll" Alias "WritePrivateProfileStringA" _
            (ByVal lpAppName As String, _
             ByVal lpKeyName As String, _
             ByVal lpString As String, _
             ByVal lpFileName As String) As Integer

    Private Declare Ansi Function FlushPrivateProfileString _
        Lib "kernel32.dll" Alias "WritePrivateProfileStringA" _
            (ByVal lpAppName As Integer, _
             ByVal lpKeyName As Integer, _
             ByVal lpString As Integer, _
             ByVal lpFileName As String) As Integer

#End Region

#Region " Private Constants "

    Private Const MAX_ENTRY As Integer = 32768

#End Region

    Public Shared Function GetProfileSectionNames( _
                        ByVal filename As String _
                    ) As StringCollection

        Return (GetProfileSectionNames(filename, ProfileLetterCase.KeepCase))

    End Function

    Public Shared Function GetProfileSectionNames( _
                        ByVal filename As String, _
                        ByVal letterCase As ProfileLetterCase _
                    ) As StringCollection

        Dim sections As StringCollection = New StringCollection
        Dim buffer(MAX_ENTRY) As Byte
        Dim bufLen As Integer = 0
        Dim sb As StringBuilder
        Dim i As Integer

        bufLen = GetPrivateProfileSectionNames(buffer, buffer.GetUpperBound(0), filename)
        If bufLen <= 0 Then Return sections

        sb = New StringBuilder
        For i = 0 To bufLen - 1
            If buffer(i) <> 0 Then
                sb.Append(ChrW(buffer(i)))
            Else
                If sb.Length > 0 Then
                    Select Case letterCase
                        Case ProfileLetterCase.KeepCase
                            sections.Add(sb.ToString())
                        Case ProfileLetterCase.ToLower
                            sections.Add(sb.ToString().ToLower)
                        Case ProfileLetterCase.ToUpper
                            sections.Add(sb.ToString().ToUpper)
                    End Select
                    sb.Remove(0, sb.Length)
                End If
            End If
        Next

        Return sections

    End Function

    Public Shared Function GetProfileKeys( _
                        ByVal iniPath As String, _
                        ByVal section As String _
                    ) As StringCollection

        Return (GetProfileKeys(iniPath, section, ProfileLetterCase.KeepCase))

    End Function

    Public Shared Function GetProfileKeys( _
                        ByVal iniPath As String, _
                        ByVal section As String, _
                        ByVal letterCase As ProfileLetterCase _
                    ) As StringCollection

        Dim items As StringCollection = New StringCollection
        Dim buffer(MAX_ENTRY) As Byte
        Dim bufLen As Integer = 0
        Dim sb As StringBuilder
        Dim i As Integer
        Dim str As String

        bufLen = GetPrivateProfileSection(section, _
           buffer, buffer.GetUpperBound(0), iniPath)
        If bufLen > 0 Then
            sb = New StringBuilder
            For i = 0 To bufLen - 1
                If buffer(i) <> 0 Then
                    sb.Append(ChrW(buffer(i)))
                Else
                    If sb.Length > 0 Then
                        'items.Add(sb.ToString())
                        str = sb.ToString().Trim
                        If (str.IndexOf("=") >= 0) Then
                            str = str.Substring(0, str.IndexOf("=")).Trim
                            Select Case letterCase
                                Case ProfileLetterCase.KeepCase
                                    items.Add(str)
                                Case ProfileLetterCase.ToLower
                                    items.Add(str.ToLower)
                                Case ProfileLetterCase.ToUpper
                                    items.Add(str.ToUpper)
                            End Select
                        End If
                        sb.Remove(0, sb.Length)
                    End If
                End If
            Next
        End If

        Return items

    End Function

    Public Shared Function GetProfileKeysAndValues( _
                        ByVal iniPath As String, _
                        ByVal section As String _
                    ) As StringCollection

        Return (GetProfileKeysAndValues(iniPath, section, ProfileLetterCase.KeepCase))

    End Function

    Public Shared Function GetProfileKeysAndValues( _
                        ByVal iniPath As String, _
                        ByVal section As String, _
                        ByVal letterCase As ProfileLetterCase _
                    ) As StringCollection

        Dim items As StringCollection = New StringCollection
        Dim buffer(MAX_ENTRY) As Byte
        Dim bufLen As Integer = 0
        Dim sb As StringBuilder
        Dim i As Integer

        bufLen = GetPrivateProfileSection(section, buffer, buffer.GetUpperBound(0), iniPath)
        If bufLen > 0 Then
            sb = New StringBuilder
            For i = 0 To bufLen - 1
                If buffer(i) <> 0 Then
                    sb.Append(ChrW(buffer(i)))
                Else
                    If sb.Length > 0 Then
                        Select Case letterCase
                            Case ProfileLetterCase.KeepCase
                                items.Add(sb.ToString())
                            Case ProfileLetterCase.ToLower
                                items.Add(sb.ToString().ToLower)
                            Case ProfileLetterCase.ToUpper
                                items.Add(sb.ToString().ToUpper)
                        End Select
                        sb.Remove(0, sb.Length)
                    End If
                End If
            Next
        End If

        Return items

    End Function

    Public Shared Function GetProfileValue( _
                    ByVal iniPath As String, _
                    ByVal section As String, _
                    ByVal key As String _
                ) As String

        Return (GetProfileValue(iniPath, section, key, ProfileLetterCase.KeepCase))

    End Function

    Public Shared Function GetProfileValue( _
                        ByVal iniPath As String, _
                        ByVal section As String, _
                        ByVal key As String, _
                        ByVal letterCase As ProfileLetterCase _
                    ) As String

        Dim buffer As StringBuilder = New StringBuilder(256)
        Dim bufLen As Integer
        bufLen = GetPrivateProfileString( _
                        section, key, "", buffer, buffer.Capacity, iniPath)
        Select Case letterCase
            Case ProfileLetterCase.KeepCase
                Return buffer.ToString
            Case ProfileLetterCase.ToLower
                Return buffer.ToString.ToLower
            Case ProfileLetterCase.ToUpper
                Return buffer.ToString.ToUpper
            Case Else
                Return ""
        End Select

    End Function

    Public Shared Sub WriteProfileValue( _
                        ByVal iniPath As String, _
                        ByVal section As String, _
                        ByVal key As String, _
                        ByVal value As String)

        WritePrivateProfileString(section, key, value, iniPath)
        Flush(iniPath)
    End Sub

    Public Shared Sub WriteProfileValue( _
                    ByVal iniPath As String, _
                    ByVal section As String, _
                    ByVal key As String, _
                    ByVal value As Integer)

        WriteProfileValue(iniPath, section, key, CStr(value))
    End Sub

    Public Shared Sub WriteProfileValue( _
                ByVal iniPath As String, _
                ByVal section As String, _
                ByVal key As String, _
                ByVal value As Boolean)

        WriteProfileValue(iniPath, section, key, CStr(value))
    End Sub

    Private Shared Sub Flush(ByVal iniPath As String)
        ' Stores all the cached changes to your INI file
        FlushPrivateProfileString(0, 0, 0, iniPath)
    End Sub


End Class
