VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "AdminDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS objects.
Option Explicit

Public Sub CreateStudyAsUser(aStudyID As Long)
    
    Dim userName As String
    Dim sSQL As String
    
    On Error GoTo errhandler
    
    userName = getUser(aStudyID)
    
    '** Removed JJF 09-22-09 - Not needed in SQL 2008
    'sSQL = "Execute sp_addlogin " & userName
    'cn.Execute sSQL
    '
    'sSQL = "Execute sp_adduser " & userName & ", " & userName & ", Studys"
    'cn.Execute sSQL
    '** End of remove
    
    '** Added JJF 09-22-09 - New way of owning a table in SQL 2008
    sSQL = "CREATE SCHEMA " & userName
    cn.Execute sSQL
    '** End of add
    
    Exit Sub
    
errhandler:
    App.LogEvent "CreateStudyAsUser - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub

Public Sub DeleteStudyAsUser(aStudyID As Long)
    
    Dim userName As String
    Dim sSQL As String
        
    On Error GoTo errhandler
    
    userName = getUser(aStudyID)
        
    '** Removed JJF 09-22-09 - Not needed in SQL 2008
    'sSQL = "Execute sp_dropuser " & userName
    'cn.Execute sSQL
    '
    'sSQL = "Execute sp_droplogin " & userName
    'cn.Execute sSQL
    '** End of remove

    '** Added JJF 09-22-09 - New way of owning a table in SQL 2008
    sSQL = "DROP SCHEMA " & userName
    cn.Execute sSQL
    '** End of add
    
    Exit Sub
    
errhandler:
    App.LogEvent "DeleteStudyAsUser - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub

Private Function getUser(aStudyID As Long) As String

    getUser = "s" & CStr(aStudyID)
    
End Function
