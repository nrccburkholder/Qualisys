VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaFieldDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS objects
Option Explicit

Private udtProps As MetaFieldProps
Private empProps As StudyEmployeeProps ' 05-10-2005 SH Added

Public Sub SaveChild(MetaTableID As Long)
    With udtProps
        If .IsDeleted Then
            DeleteObject .TableID, .ID
        ElseIf .IsDirty Or .IsNew Then
            .TableID = MetaTableID
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
        .CommandText = "dbo.SDS_SaveMetaStructure"
    End With
    
    ' Set the following as input parameter:
    '   Employee_id INT
    '   IsKeyField BIT
    '   IsUserField BIT
    '   IsMatchField BIT
    '   IsPosted BIT
    '   IsPII BIT Output
    '   IsAllowUS BIT Output
    '   Table_id INT
    '   Field_id INT Output
    '   LookupTable_id INT
    '   LookupField_id INT
    '   LookupType CHAR(1)
    '   ResultMsg VARCHAR(100)

    cmd.Parameters.Append cmd.CreateParameter("Employee_id", adInteger, _
    adParamInput, , empProps.EmployeeID)

    cmd.Parameters.Append cmd.CreateParameter("IsKeyField", adBoolean, _
    adParamInput, , udtProps.IsKeyField)
    
    cmd.Parameters.Append cmd.CreateParameter("IsUserField", adBoolean, _
    adParamInput, , udtProps.IsUserField)
    
    cmd.Parameters.Append cmd.CreateParameter("IsMatchField", adBoolean, _
    adParamInput, , udtProps.IsMatchField)

    cmd.Parameters.Append cmd.CreateParameter("IsPosted", adBoolean, _
    adParamInput, , udtProps.IsPosted)

    cmd.Parameters.Append cmd.CreateParameter("IsPII", adBoolean, _
    adParamInputOutput, , udtProps.IsPII)

    cmd.Parameters.Append cmd.CreateParameter("IsAllowUS", adBoolean, _
    adParamInputOutput, , udtProps.IsAllowUS)

    cmd.Parameters.Append cmd.CreateParameter("Table_id", adInteger, _
    adParamInput, , udtProps.TableID)

    cmd.Parameters.Append cmd.CreateParameter("Field_id", adInteger, _
    adParamInputOutput, , udtProps.ID)
        
    cmd.Parameters.Append cmd.CreateParameter("LookupTable_id", adInteger, _
    adParamInput, , udtProps.lookupTableID)
        
    cmd.Parameters.Append cmd.CreateParameter("LookupField_id", adInteger, _
    adParamInput, , udtProps.lookupFieldID)
        
    cmd.Parameters.Append cmd.CreateParameter("LookupType", adChar, _
    adParamInput, 1, udtProps.LookupType)
        
    cmd.Parameters.Append cmd.CreateParameter("ResultMsg", adVarChar, _
    adParamOutput, 100)
    
    cmd.ActiveConnection = cn
    cmd.Execute
    
    With udtProps
        If .IsNew Then .ID = cmd.Parameters("Field_id").Value
        .IsAllowUS = cmd.Parameters("IsAllowUS").Value
        .IsPII = cmd.Parameters("IsPII").Value
    End With
            
    If cmd.Parameters("ResultMsg").Value <> "Success" Then
        MsgBox cmd.Parameters("ResultMsg").Value
    End If
' *** End of addition

' *** 05-10-2005 SH Deleted
'    Dim fldName As String
'    Dim tableName As String
'    Dim sSQL As String
'    Dim rs As New ADODB.Recordset
'
'    On Error GoTo errhandler
'
'    On Error GoTo 0
'
'    ' 09-10-1999 DV
'    ' For key fields, if it already exists in the
'    ' metafield table, we will NOT add a new record.
'    If udtProps.IsKeyField Then
'        If udtProps.IsNew Then
'            'add it to the metafield structure first
'            tableName = getTableName
'            fldName = getKeyFieldName(tableName)
'
'            ' 09-10-1999 DV
'            ' Check to see if the field already exists
'            sSQL = "SELECT field_id FROM dbo.metaField " & _
'                   "WHERE strfield_nm = '" & fldName & "'"
'
'            rs.Open sSQL, cn, adOpenKeyset
'            If rs.BOF And rs.EOF Then
'                ' 09-10-1999 DV
'                ' If the field doesn't exist, we will add it.
'                If rs.State = adStateOpen Then
'                    rs.Close
'                End If
'                sSQL = "SELECT * from metaField"
'
'                rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
'                rs.AddNew
'                rs("strField_nm") = fldName
'                rs("strField_dsc") = "key field for " & tableName
'                'rs("strFieldShort_nm") = fldName 'causes error if length is longer than specified in DB
'                rs("strFieldDataType") = "I"
'                rs("bitSyskey") = 1
'                rs.Update
'                udtProps.ID = rs("Field_id")
'            Else
'                ' 09-10-1999 DV
'                ' If the field exists, we use the existing field_id.
'                udtProps.ID = rs("Field_id")
'            End If
'            rs.Close
'        End If
'    End If
'
'    If udtProps.IsNew Then
'        sSQL = "SELECT * from metaStructure"
'        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
'        rs.AddNew
'    Else
'        sSQL = "SELECT * from metaStructure WHERE table_id=" & udtProps.TableID
'        sSQL = sSQL & " and field_id = " & udtProps.ID
'        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
'    End If
'
'    If udtProps.IsNew Then
'        rs("Table_id") = udtProps.TableID
'        rs("field_id") = udtProps.ID
'    End If
'
'    rs("bitKeyField_flg") = udtProps.IsKeyField
'    rs("bitUserField_flg") = udtProps.IsUserField
'    rs("bitMatchField_flg") = udtProps.IsMatchField
'    rs("bitPostedField_flg") = udtProps.IsPosted
'    ' *** 05-10-2005 SH Added
'    rs("bitPII") = udtProps.IsPII
'    rs("bitAllowUS") = udtProps.IsAllowUS
'    ' *** End of addition
'    rs.Update
'
'    rs.Close
'    Set rs = Nothing
'
'    SaveMetaLookup
' *** 05-10-2005 SH End of Deletion

    Exit Sub

errhandler:
' *** 05-10-2005 SH Deleted
'    If Not rs Is Nothing Then
'        rs.Close
'        Set rs = Nothing
'    End If
' *** 05-10-2005 SH End of deletion
    App.LogEvent "meta structure Save - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub DeleteObject(MetaTableID As Long, MetaFieldID As Long)
    Dim sSQL As String
    
    On Error GoTo errhandler
        
    sSQL = "DELETE from metaStructure WHERE table_id=" & MetaTableID
    sSQL = sSQL & " and field_id = " & MetaFieldID
    
    cn.Execute sSQL
    
    Exit Sub
    
errhandler:
    App.LogEvent "meta structure  DeleteObject - " & _
                 Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub Fetch(ByVal MetaTableID As Long, ByVal MetaFieldID As Long)
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    Dim newRec As Boolean
    
    On Error GoTo errhandler
    
    ' *** 05-09-2005 SH Modified
    ' bitPII and bitAllowUS are added to MetaStructure.
    newRec = True
    
'    sSQL = "SELECT * from metaStructure WHERE table_id=" & MetaTableID
'    sSQL = sSQL & " and field_id = " & MetaFieldID
'
'    Set rs = cn.Execute(sSQL)
'
'    With rs
'        If .BOF And .EOF Then
'            ' nothing
'            udtProps.ID = -1
'            udtProps.TableID = -1
'            udtProps.IsKeyField = False
'            udtProps.IsUserField = False
'            udtProps.IsMatchField = False
'            udtProps.IsPosted = False
'        Else
'            udtProps.ID = MetaFieldID
'            udtProps.TableID = rs("table_id")
'            udtProps.IsKeyField = rs("bitKeyField_flg")
'            udtProps.IsUserField = rs("bitUserField_flg")
'            udtProps.IsMatchField = rs("bitMatchField_flg")
'            udtProps.IsPosted = rs("bitPostedField_flg")
'            With udtProps
'            End With
'        End If
'        .Close
'    End With
'
'    Set rs = Nothing
    
    sSQL = "Select * From MetaStructure Where Table_id=" & MetaTableID & _
           " And Field_id = " & MetaFieldID
    
    rs.Open sSQL, cn, adOpenKeyset
    If Not rs.EOF And Not rs.BOF Then newRec = False
    
    With udtProps
        .ID = IIf(newRec, -1, MetaFieldID)
        .TableID = IIf(newRec, -1, rs("Table_id").Value)
        .IsKeyField = IIf(newRec, False, rs("bitKeyField_flg").Value)
        .IsUserField = IIf(newRec, False, rs("bitUserField_flg").Value)
        .IsMatchField = IIf(newRec, False, rs("bitMatchField_flg").Value)
        .IsPosted = IIf(newRec, False, rs("bitPostedField_flg").Value)
        .IsPII = IIf(newRec, False, rs("bitPII").Value)
        .IsAllowUS = IIf(newRec, False, rs("bitAllowUS").Value)
    End With
    ' *** End of modification

    rs.Close
    Set rs = Nothing
    
    FetchMetaLookup
    
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "meta structure Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Private Sub SaveMetaLookup()
' *** 05-10-2005 SH Deleted
' This functionality is already integrated in the stored procedure
' SDS_SaveMetaStructure.
'
'    Dim sSQL As String
'    Dim rs As New ADODB.Recordset
'
'    On Error GoTo errhandler
'
'    ' delete the object from the DB and then add it back
'    DeleteMetaLookup
'
'    ' insert it back
'    If (udtProps.lookupTableID > 0) And (udtProps.lookupFieldID > 0) Then
'        sSQL = "SELECT * from MetaLookup"
'        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
'        rs.AddNew
'
'        rs("numMasterTable_id") = udtProps.TableID
'        rs("numMasterField_id") = udtProps.ID
'        rs("numLkupTable_id") = udtProps.lookupTableID
'        rs("numLkupField_id") = udtProps.lookupFieldID
'        rs("strLkup_type") = udtProps.LookupType
'
'        rs.Update
'
'        rs.Close
'        Set rs = Nothing
'    End If
'
'    Exit Sub
'
'errhandler:
'    If Not rs Is Nothing Then
'        rs.Close
'        Set rs = Nothing
'    End If
'    App.LogEvent "MetaLookup Insert - " & _
'                 Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
'    Err.Raise vbObjectError
' *** 05-10-2005 SH End of deletion
End Sub

Private Sub DeleteMetaLookup()
    Dim sSQL As String
    
    On Error GoTo errhandler
        
    sSQL = "DELETE FROM metaLookup WHERE numMasterTable_id=" & udtProps.TableID
    sSQL = sSQL & " AND numMasterField_id = " & udtProps.ID
    
    cn.Execute sSQL
    
    Exit Sub
    
errhandler:
    App.LogEvent "MetaLookup DeleteObject - " & _
                 Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Private Sub FetchMetaLookup()
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    sSQL = "SELECT * FROM metaLookup WHERE numMasterTable_id=" & udtProps.TableID
    sSQL = sSQL & " AND numMasterField_id = " & udtProps.ID
    
    Set rs = cn.Execute(sSQL)
    If rs.BOF And rs.EOF Then
        udtProps.lookupTableID = -1
        udtProps.lookupFieldID = -1
        udtProps.LookupType = ""
    Else
        udtProps.lookupTableID = rs("numLkupTable_id")
        udtProps.lookupFieldID = rs("numLkupField_id")
        udtProps.LookupType = rs("strLkup_type") & ""
    End If
    
    rs.Close
     
    Set rs = Nothing
    
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "MetaLookup Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Property Get IsDeleted() As Boolean
    IsDeleted = udtProps.IsDeleted
End Property

Public Sub SetState(Buffer As String)
    Dim udtData As MetaFieldData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData
End Sub

Public Function GetState() As String
    Dim udtData As MetaFieldData
    
    LSet udtData = udtProps
    GetState = udtData.Buffer
End Function

Private Function getKeyFieldName(tableName As String) As String
    Dim fieldname As String
    
    If tableName = POPULATION_TABLE Then
        fieldname = POPULATION_TABLE_KEY
    ElseIf tableName = ENCOUNTER_TABLE Then
        fieldname = ENCOUNTER_TABLE_KEY
    ElseIf tableName = PROVIDER_TABLE Then
        fieldname = PROVIDER_TABLE_KEY
    Else 'custom tables
        fieldname = tableName & "_id"
    End If
        
    getKeyFieldName = fieldname
End Function

Private Function getTableName() As String
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    sSQL = "SELECT strTable_nm from metaTable WHERE table_id=" & udtProps.TableID
    
    Set rs = cn.Execute(sSQL)
    getTableName = Trim$(rs("strTable_nm") & "")
    rs.Close
    Set rs = Nothing
    
    Exit Function

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "Table Name Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Function
