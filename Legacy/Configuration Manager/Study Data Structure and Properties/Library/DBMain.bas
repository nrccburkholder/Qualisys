Attribute VB_Name = "DBMain"
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Routine Name:
'
' Created By:       CGA
'         Date:     00-00-0000
'
' Description:
'
' Parameters:
'     Name        Type        Description
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       QualiSysFunctions
'
' Revisions:
'   Date        By      Description
'   08-20-2002  SH      Removed MTS objects from StudyDataMTS
'                       and called it StudyDataPROC.
'   09-28-2002  FG      Removed DBConnection and
'                       ClientConnection.
'   09-29-2002  SH      Renamed QualProFunctions to
'                       QualiSysFunctions.
'   10-02-2002  SH      Recompiled with VB6.0 and moved DLL to
'                       \components\QualiSysDLLs\.
'-----------------------------------------------------------------

Option Explicit

Public Function DBAdminOpen() As ADODB.Connection
    
    Dim cn As ADODB.Connection
    
    Set cn = CreateObject("adodb.connection")
    cn.Open ConnectString
    Set DBAdminOpen = cn
    Set cn = Nothing
    
End Function

Public Function DBOpen() As ADODB.Connection
    
    Dim cn As ADODB.Connection
    
    Set cn = CreateObject("adodb.connection")
    cn.Open ConnectString
    Set DBOpen = cn

    Set cn = Nothing
    
End Function

Public Sub DBClose(cn As ADODB.Connection)
    
    cn.Close
    Set cn = Nothing
    
End Sub
    
Private Function ClientDBConnection(Optional SAUser As Boolean) As ADODB.Connection
    ''
End Function

Private Function MTSDBConnection(Optional SAUser As Boolean) As ADODB.Connection

    'Dim cn As ADODB.Connection
    'Dim QualProConnect As DBConnection.Connection
    
    'On Error GoTo ErrorHandler
    
    'Set QualProConnect = objCtx.CreateInstance("DBConnection.Connection")
    'Set cn = QualProConnect.DBConnect(ConfigurationManager, SAUser)
    'Set MTSDBConnection = cn
    'Set cn = Nothing
    'Set QualProConnect = Nothing
    'Exit Function
    
    Dim o As QualiSysFunctions.Library
    Dim strDSN_Info As String
    
    Set o = CreateObject("QualiSysFunctions.Library")
    strDSN_Info = o.GetDBString
    Set MTSDBConnection = New ADODB.Connection
    MTSDBConnection.ConnectionTimeout = 0
    MTSDBConnection.Open strDSN_Info
    MTSDBConnection.CommandTimeout = 0
    Set o = Nothing
    
    Exit Function
    
ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
