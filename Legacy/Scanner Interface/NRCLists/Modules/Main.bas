Attribute VB_Name = "modMain"
Option Explicit

Public Sub OpenDBConnection(objConn As ADODB.Connection, ByVal strConnString As String)
    
    'Set the error handler
    On Error GoTo ErrorHandler
    
    'If the connection is already open then close it
    CloseDBConnection objConn:=objConn
    
    'Open the connection
    Set objConn = New ADODB.Connection
    objConn.Open strConnString
    objConn.CommandTimeout = 30
    
Exit Sub


ErrorHandler:
    Set objConn = Nothing
    Err.Raise Number:=Err.Number, _
              Source:="modMain::OpenDBConnection", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

Public Sub CloseDBConnection(objConn As ADODB.Connection)
    
    'Set the error handler
    On Error GoTo ErrorHandler
    
    'If the connection is already open then close it
    If Not (objConn Is Nothing) Then
        objConn.Close
    End If
    Set objConn = Nothing
    
Exit Sub


ErrorHandler:
    Set objConn = Nothing
    Err.Raise Number:=Err.Number, _
              Source:="modMain::CloseDBConnection", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub




