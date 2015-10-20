VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Library"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Routine Name:
'
' Created By:       ?????
'         Date:     00-00-0000
'
' Description:
'
' Parameters:
'     Name        Type        Description
'
' Revisions:
'     Date        By      Description
'     04-10-2002  SH      Removed MTS objects.
'     09-27-2002  SH      Removed DBConnection.
'     10-01-2002  SH      Recompiled using VB6.0 and moved DLL
'                         to \components\QualiSysDLLs\
'-----------------------------------------------------------------

Public Function GetStudy_id(Survey_id As Long) As Long
    
    On Error GoTo ErrHandler
    
    Dim cn As New ADODB.Connection
    Dim rs As New ADODB.Recordset
    Dim SQL As String
    Dim DBstr As String
    
    DBstr = GetDBString
        
    cn.Open DBstr
    
    SQL = ""
    SQL = "SELECT Study_id FROM Survey_def WHERE Survey_id = " & Survey_id
    rs.Open SQL, cn, adOpenForwardOnly, adLockReadOnly
    
    GetStudy_id = rs("Study_id")
    
    rs.Close
    Set rs = Nothing
    cn.Close
    Set cn = Nothing
    
    Exit Function
    
ErrHandler:
    App.LogEvent Err.Description, vbLogEventTypeError
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

' ** Removed 09-27-2002 SH
'Private Function DBConnection() As ADODB.Connection
'
'    On Error GoTo ErrHandler
'
'    Dim oDBConnection As DBConnection.Connection
'
'    Set oDBConnection = CreateObject("DBConnection.Connection") 'SH 04-12-02
'    Set DBConnection = oDBConnection.DBConnect(ConfigurationManager)
'    Set oDBConnection = Nothing
'
'    Exit Function
'
'ErrHandler:
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

Public Function GetDBString(Optional SAUser As Boolean) As String

    Dim User_id As String
    Dim User_PWD As String
    Dim Server_nm As String
    Dim Database_nm As String
   
    On Error GoTo ErrorHandler:
    
    User_id = "UID=" & GetRegValue(IIf(SAUser = False, _
        "DefaultUser", "AdminUser")) & ";"
    User_PWD = "PWD=" & GetRegValue(IIf(SAUser = False, _
        "DefaultPWD", "AdminPWD")) & ";"
    Server_nm = "SERVER=" & GetRegValue("Server") & ";"
    Database_nm = "DATABASE=" & GetRegValue("Database")
    
    GetDBString = "driver={SQL Server};" & Server_nm & User_id & User_PWD & Database_nm
    
    Exit Function
    
ErrorHandler:
    App.LogEvent "QualiSysFunctions:Library:DBString, " & _
        Err.Number & ", " & Err.Description
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

Public Function GetCommandTimeout(module As String) As Integer
    
    Dim CommandTimeout As String
  
    On Error GoTo ErrorHandler:

    CommandTimeout = GetRegValue(module & "CommandTimeout")
    GetCommandTimeout = CInt(CommandTimeout)
        
    Exit Function
    
ErrorHandler:
    App.LogEvent "QualiSysFunctions:Library:DBString, " & _
                 Err.Number & ", " & Err.Description
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

Public Function GetConnectionTimeout(module As String) As Integer
    
    Dim ConnectionTimeout As String
  
    On Error GoTo ErrorHandler:

    ConnectionTimeout = GetRegValue(module & "ConnectionTimeout")
    GetConnectionTimeout = CInt(ConnectionTimeout)
        
    Exit Function
    
ErrorHandler:
    App.LogEvent "QualiSysFunctions:Library:DBString, " & _
                 Err.Number & ", " & Err.Description
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
