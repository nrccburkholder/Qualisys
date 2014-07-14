VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaFieldListDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS objects.
Option Explicit

Private objBuffer As Buffer

Private Sub ShowError(Desc As String, E As Error)
    App.LogEvent Desc & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub


Public Sub Fetch(aStudyID As Long)
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    Dim udtProps As MetaFieldListProps
    Dim udtData As MetaFieldListData
    
    On Error GoTo errhandler
    
'    sSQL = "SELECT * FROM metaField f, metaFieldGroupDef fg "
'    sSQL = sSQL & "WHERE f.FieldGroup_id *= fg.fieldGroup_id"
    
    sSQL = "(SELECT * FROM metafield WHERE bitSyskey = 0)"
    sSQL = sSQL & " UNION "
    sSQL = sSQL & " (SELECT * FROM metafield WHERE bitSyskey = 1 "
    sSQL = sSQL & " AND field_id IN (SELECT field_id FROM metastructure WHERE "
    sSQL = sSQL & " table_id IN (SELECT table_id FROM metatable WHERE study_id = "
    sSQL = sSQL & CStr(aStudyID) & " )))"
    
    Set objBuffer = New Buffer
    objBuffer.Initialize Len(udtData), 100
    
    Set rs = cn.Execute(sSQL)
    Do While Not rs.EOF
        With udtProps
            .ID = rs.Fields("Field_id").Value
            .name = rs("strField_nm") & ""
            .Description = rs("strField_dsc") & ""
            .ShortName = rs("strFieldShort_nm") & ""
            .DataType = rs("strFieldDataType") & ""
            .fieldLength = DB2VB_Long(rs, "intFieldLength")
            .EditMask = rs("strFieldEditMask") & ""
            .SpecialCode = DB2VB_Long(rs, "intSpecialField_cd")
            .GroupID = DB2VB_Long(rs, "FieldGroup_id")
            .GroupName = "" ' rs("strFieldGroup_nm") & ""
            .PII = rs.Fields("bitPII").Value ' 05-09-2005 SH Added
        End With
        LSet udtData = udtProps
        objBuffer.Add udtData.Buffer
        rs.MoveNext
    Loop
    rs.Close
    Set rs = Nothing
    
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    ShowError "List Fetch - ", Err
    
End Sub

Public Function FetchNewRecordDateID() As Long
    FetchNewRecordDateID = FetchID(FIELD_NEW_RECORD_DATE)
End Function

Public Function FetchAgeField() As Long
    FetchAgeField = FetchID(FIELD_AGE)
End Function

Public Function FetchGenderField() As Long
    FetchGenderField = FetchID(FIELD_GENDER)
End Function

Public Function FetchPopID() As Long
    FetchPopID = FetchID(FIELD_POPID)
End Function

Public Function GetState() As String
    GetState = objBuffer.GetState
End Function

Public Function FetchLanguageID() As Long
    FetchLanguageID = FetchID(FIELD_LANGUAGE_CODE)
End Function

Public Function isPII(Field_ID As Long) As Boolean
     Dim rs As ADODB.Recordset
     Set rs = cn.Execute("Select bitPII from metaField where Field_id = " & Field_ID)
     If Not rs.EOF Then
       isPII = rs.Fields(0).Value
     Else
       isPII = False
    End If
    rs.Close
    Set rs = Nothing
End Function

Private Function FetchID(QualProParamName As String) As Long
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    sSQL = "SELECT field_id FROM metaField "
    sSQL = sSQL & "WHERE intSpecialField_cd = "
    sSQL = sSQL & "( SELECT numParam_value from QualPro_Params "
    sSQL = sSQL & "WHERE strParam_nm = " & QualProParamName & ")"
    
    Set rs = cn.Execute(sSQL)
    If rs.BOF And rs.EOF Then
        FetchID = -1
    Else
        FetchID = rs("Field_id")
    End If

    rs.Close
    Set rs = Nothing
        
    Exit Function

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "FetchID - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Function
