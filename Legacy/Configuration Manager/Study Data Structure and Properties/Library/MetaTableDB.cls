VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaTableDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS objects.
Option Explicit

Private udtProps As MetaTableProps
Private empProps As StudyEmployeeProps ' 05-10-2005 SH Added

Public Sub SaveChild(StudyID As Long)
    With udtProps
        If .IsDeleted Then
            DeleteObject .ID
        ElseIf .IsDirty Or .IsNew Then
            .StudyID = StudyID
            Save
        End If
    End With
End Sub

Public Sub Save()
' *** 05-10-2005 SH Added
    Dim cmd As New ADODB.Command

    ' Set up a Command Structure
    With cmd
        .CommandType = adCmdStoredProc
        .CommandText = "dbo.SDS_SaveMetaTable"
    End With
    
    ' Set the following as input parameter:
    '   Employee_id INT
    '   Table_id INT Output
    '   Study_id INT
    '   Table_nm VARCHAR(20)
    '   Table_dsc VARCHAR(80)
    '   UsesAddress BIT

    cmd.Parameters.Append cmd.CreateParameter("Employee_id", adInteger, _
    adParamInput, , empProps.EmployeeID)

    cmd.Parameters.Append cmd.CreateParameter("Table_id", adInteger, _
    adParamInputOutput, , udtProps.ID)
        
    cmd.Parameters.Append cmd.CreateParameter("Study_id", adInteger, _
        adParamInput, , udtProps.StudyID)
        
    cmd.Parameters.Append cmd.CreateParameter("Table_nm", adVarChar, _
        adParamInput, 20, udtProps.name)
        
    cmd.Parameters.Append cmd.CreateParameter("Table_dsc", adVarChar, _
        adParamInput, 80, udtProps.Description)
    
    cmd.Parameters.Append cmd.CreateParameter("UsesAddress", adBoolean, _
    adParamInput, , udtProps.UsesAddress)
        
    cmd.ActiveConnection = cn
    cmd.Execute
    
    If udtProps.IsNew Then
        udtProps.ID = cmd.Parameters("Table_id").Value
    End If
' *** 05-10-2005 SH End of addition

' *** 05-10-2005 SH Deleted
'    Dim sSQL As String
'    Dim rs As New ADODB.Recordset
'
'    On Error GoTo errhandler
'
'    If udtProps.IsNew Then
'        sSQL = "SELECT * from MetaTable"
'        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
'        rs.AddNew
'    Else
'        sSQL = "SELECT * from MetaTable WHERE table_id=" & udtProps.ID
'        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
'    End If
'
'    rs("Study_id") = udtProps.StudyID
'    rs("strTable_nm") = Trim$(udtProps.name)
'    rs("strTable_dsc") = udtProps.Description
'    rs("bitUsesAddress") = udtProps.UsesAddress
'    rs.Update
'
'    If udtProps.IsNew Then
'        udtProps.ID = rs("table_id")
'    End If
'
'    rs.Close
'    Set rs = Nothing
' *** 05-10-2005 SH End of deletion

    Exit Sub
    
errhandler:
' *** 05-10-2005 SH Deleted
'    If Not rs Is Nothing Then
'        rs.Close
'        Set rs = Nothing
'    End If
' *** 05-10-2005 SH End of deletion
    App.LogEvent "MetaTable Save - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub DeleteObject(MetaTableID As Long)
    Dim sSQL As String
    
    On Error GoTo errhandler
       
    'delete all the metastructure and metalookup associated with this table id
    sSQL = "DELETE FROM metaLookup WHERE numMasterTable_id=" & MetaTableID
    cn.Execute sSQL
    
    sSQL = "DELETE FROM metaStructure WHERE Table_id=" & MetaTableID
    cn.Execute sSQL
    
    sSQL = "DELETE FROM metaTable WHERE table_ID=" & MetaTableID
    cn.Execute sSQL
       
    Exit Sub
    
errhandler:
    App.LogEvent "MetaTable DeleteObject - " & _
                 Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub Fetch(ByVal MetaTableID As Long)
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
        
    On Error GoTo errhandler
    
    sSQL = "SELECT * FROM MetaTable WHERE table_id =" & MetaTableID
       
    Set rs = cn.Execute(sSQL)
    
    With rs
        If .BOF And .EOF Then
            ' nothing
            udtProps.ID = -1
            udtProps.StudyID = -1
            udtProps.name = ""
            udtProps.Description = ""
            udtProps.UsesAddress = False
        Else
            udtProps.ID = MetaTableID
            udtProps.StudyID = rs("Study_id")
            udtProps.name = rs("strTable_nm") & ""
            udtProps.Description = rs("strTable_dsc") & ""
            udtProps.UsesAddress = rs("bitUsesAddress")
        End If
        .Close
    End With
    
    Set rs = Nothing
    
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "MetaTable Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Property Get IsDeleted() As Boolean
    IsDeleted = udtProps.IsDeleted
End Property

Public Sub SetState(Buffer As String)
    Dim udtData As MetaTableData
  
    udtData.Buffer = Buffer
    LSet udtProps = udtData
End Sub

Public Function GetState() As String
    Dim udtData As MetaTableData
    
    LSet udtData = udtProps
    GetState = udtData.Buffer
End Function
