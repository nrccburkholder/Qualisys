Attribute VB_Name = "basErr48"
Public Const DEBUG_MTS = 0
Public Const DEBUG_LOCAL = 1
Public CURRENT_DEBUG_MODE
Public ConnectString As String

Private Declare Function GetModuleFileName Lib "kernel32" _
         Alias "GetModuleFileNameA" _
         (ByVal hModule As Long, _
         ByVal lpFileName As String, _
         ByVal nSize As Long) As Long


' Keep a global object on the thread to
' keep the project from unloading when
' the last reference to it goes away
' It has to be public to trick VB into
' thinking that the thread is not done
Public gt_objDummy As New IDummy

' Sample Sub main function
Public Sub Main()
    
    ' First line of code should be to instantiate
    ' the dummy class. Be sure to set the Sun Main
    ' as the Startup Object in the project properties.
    
    Set gt_objDummy = New IDummy
   
    ' 3-7-2000 FG
    ' This is an efective way to find out if we are  running from within VB
    ConnectString = ""
    Dim strFileName As String
    Dim lngCount As Long
    strFileName = String(255, 0)
    lngCount = GetModuleFileName(App.hInstance, strFileName, 255)
    strFileName = Left(strFileName, lngCount)
    
    ' ** Removed 08-20-2002 SH
    'If UCase(Right(strFileName, 7)) <> "VB5.EXE" Then
    '    CURRENT_DEBUG_MODE = DEBUG_MTS
    'Else
        CURRENT_DEBUG_MODE = DEBUG_LOCAL
        Dim qpfunc As QualiSysFunctions.Library
        Set qpfunc = New QualiSysFunctions.Library
        ConnectString = qpfunc.GetDBString
        Set qpfunc = Nothing
    'End If
    
    ' Do rest of work if any
    
End Sub
