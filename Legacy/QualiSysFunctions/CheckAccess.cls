VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "checkAccess"
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
' Created By:       SH
'         Date:     01-13-2003
'
' Description:
'
' Parameters:
'     Name        Type        Description
'
'-----------------------------------------------------------------

Public Function IsUserInModules(intEmployeeId As Integer, strModuleName As String) As Boolean

    On Error GoTo ErrIsUserInModules
    
    IsUserInModules = False
    
    Dim strSQL As String
    Dim rs As New ADODB.Recordset
    Dim Conn As New ADODB.Connection
    Dim anObject As New QualiSysFunctions.Library
    
    Conn.Open anObject.GetDBString
    
    strSQL = "SELECT * FROM Module_Employee me, Modules m " & _
             "WHERE me.module_id = m.module_id " & _
             "      AND m.strmodule_nm = '" & strModuleName & "'" & _
             "      AND me.employee_id = " & intEmployeeId

    rs.Open strSQL, Conn
    
    If Not (rs.BOF And rs.EOF) Then
        IsUserInModules = True
    End If
            
    rs.Close
    Set rs = Nothing
    Conn.Close
    Set Conn = Nothing
    
    Set anObject = Nothing
    
    Exit Function

ErrIsUserInModules:
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
