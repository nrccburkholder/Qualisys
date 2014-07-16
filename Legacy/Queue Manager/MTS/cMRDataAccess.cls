VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMRDataAccess"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
    
Private moConn As ADODB.Connection
    
Public Function DB_GetIDs(LithoCode As String) As ADODB.Recordset
    
    Dim SQL As String
    Dim rs  As New ADODB.Recordset
    
    On Error GoTo ErrorHandler
         
    '** 04-06-09 JJF - Modified to include the datExpired
    'SQL = "select sp.study_id, sp.pop_id, sm.samplepop_id, mm.survey_id, sg.methodology_id from" & _
    '        " samplepop sp, scheduledmailing sm, mailingmethodology mm, sentmailing sg" & _
    '        " where sp.samplepop_id=sm.samplepop_id and" & _
    '        " sm.sentmail_id=sg.sentmail_id and" & _
    '        " sm.methodology_id = mm.methodology_id" & _
    '        " and sg.strlithocode = '" & LithoCode & "'"
    SQL = "select sp.study_id, sp.pop_id, sm.samplepop_id, mm.survey_id, sg.methodology_id, sg.datExpire " & _
          "from samplepop sp, scheduledmailing sm, mailingmethodology mm, sentmailing sg " & _
          "where sp.samplepop_id = sm.samplepop_id " & _
          "  and sm.sentmail_id = sg.sentmail_id " & _
          "  and sm.methodology_id = mm.methodology_id " & _
          "  and sg.strlithocode = '" & LithoCode & "'"
    '** 04-06-09 JJF - End of modification
    
    rs.CursorLocation = adUseClient
    
    rs.Open SQL, moConn, adOpenKeyset
    
    
    Set rs.ActiveConnection = Nothing
    
    
    Set moConn = Nothing
    
    Set DB_GetIDs = rs

    Exit Function

ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

Public Sub DB_TOCL(ByVal StudyID As Long, ByVal PopID As Long, ByVal SamplePopID As Long)

    Dim SQL As String, SQL1 As String
    
    On Error GoTo ErrorHandler
    
    SQL = "insert into TOCL (Study_id, Pop_id, datTOCl_dat)" & _
          " Values (" & StudyID & "," & PopID & ",'" & Now & "')"
    
    moConn.Execute (SQL)
    
    SQL1 = "delete from ScheduledMailing where " & _
           "scheduledmailing.samplepop_id=" & SamplePopID & _
           " and scheduledmailing.sentmail_id IS NULL"
         
    moConn.Execute (SQL1)

    Exit Sub

ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

Public Function DB_GetLang(ByVal StudyID As Long, ByVal PopID As Long) As String
    
    Dim SQL As String, SQL1 As String, SQL2 As String
    Dim rs As New ADODB.Recordset, rs1 As New ADODB.Recordset
    Dim rs2 As New ADODB.Recordset
    
    On Error GoTo ErrorHandler
    
    SQL = "select mt.strtable_nm, mt.strfield_nm " & _
            "from metadata_view mt, qualpro_params qp " & _
            "Where mt.intspecialfield_cd = qp.numparam_value " & _
            "and qp.strparam_nm='FieldLanguageCode'"
    
    rs.Open SQL, moConn, adOpenKeyset, adLockReadOnly
    
    If Not rs.EOF And Not rs.BOF Then
        rs.MoveFirst
        Dim TableName As String, FieldName As String
        Dim LangID As Long
        
        TableName = "S" & StudyID & "." & rs!strtable_nm
        FieldName = rs!strField_nm
        
        SQL1 = "Select " & TableName & "." & FieldName & _
                " from " & TableName & " where " & _
                TableName & ".Pop_id =" & PopID
        rs1.Open SQL1, moConn, adOpenKeyset, adLockReadOnly
        
        If Not rs1.EOF And Not rs1.BOF Then
            rs1.MoveFirst
            LangID = rs1(0)
        Else
            DB_GetLang = ""
            GoTo EndFunction
        End If
        
        SQL2 = "select L.language from Languages L where " & _
                "L.langID =" & LangID
        rs2.Open SQL2, moConn, adOpenKeyset, adLockReadOnly
        
        If Not rs2.EOF And Not rs2.BOF Then
            rs2.MoveFirst
            DB_GetLang = rs2(0)
        Else
            DB_GetLang = ""
        End If
        
        rs2.Close
        Set rs2 = Nothing
        
EndFunction:
        rs1.Close
        Set rs1 = Nothing
         
    End If

    rs.Close
    Set rs = Nothing
    
Exit Function

ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


Public Function DB_GetAllLangs(ByVal SurveyID As Long) As ADODB.Recordset
    
    Dim rs As New ADODB.Recordset
    Dim SQL As String
    
    On Error GoTo ErrorHandler
    
    SQL = "select L.* from languages L, SurveyLanguage SL " & _
            "Where L.LangID = SL.LangID And sl.survey_id = " & SurveyID
    
    rs.CursorLocation = adUseClient
    rs.Open SQL, moConn, adOpenKeyset, adLockReadOnly
    
    Set rs.ActiveConnection = Nothing
    
    Set DB_GetAllLangs = rs
    
Exit Function

ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


Public Sub DB_UpdateLang(ByVal StudyID As Long, ByVal PopID As Long, _
        ByVal SamplePopID As Long, ByVal MethodID As Long, _
        ByVal NewLangID As Long, ByVal intDays As Long, ByVal LangFlag As Boolean)

    Dim rs As New ADODB.Recordset
    Dim rs3 As New ADODB.Recordset
    Dim rs4 As New ADODB.Recordset
    Dim OverRideID As Long, MailStepID As Long
    Dim SQL As String, SQL1 As String, SQL2 As String
    Dim SQL3 As String, SQL4 As String, SQL5 As String
    
    On Error GoTo ErrorHandler
    
    If LangFlag = True Then
        SQL = "select mt.strtable_nm, mt.strfield_nm " & _
            "from metadata_view mt, qualpro_params qp " & _
            "Where mt.intspecialfield_cd = qp.numparam_value " & _
            "and qp.strparam_nm='FieldLanguageCode'"
    
        rs.Open SQL, moConn, adOpenKeyset, adLockPessimistic
        
        If Not rs.EOF And Not rs.BOF Then
            rs.MoveFirst
            Dim TableName As String, FieldName As String
            TableName = "S" & StudyID & "." & rs!strtable_nm
            FieldName = rs!strField_nm
            rs.Close
            Set rs = Nothing
        Else
            Set rs = Nothing
            Exit Sub
        End If
        
        'Update Population Table with new LanguageID
        SQL1 = "Update " & TableName & _
                " Set " & TableName & "." & FieldName & " = " & NewLangID & _
                " where " & _
                TableName & ".Pop_id =" & PopID
        moConn.Execute (SQL1)
    
    End If
    
    'Update ScheduledMailing to delay scheduled mail by interval chosen by user
    SQL2 = "Update ScheduledMailing " & _
            "Set Scheduledmailing.datGenerate = dateadd(day," & intDays & ",datgenerate)" & _
            " Where scheduledmailing.samplepop_id = " & SamplePopID & _
            " and scheduledmailing.sentmail_id IS NULL"
    moConn.Execute (SQL2)

    'Insert a record in OverRideItem and get its ID
    SQL3 = "Select * from OverrideItem"
    rs3.Open SQL3, moConn, adOpenKeyset, adLockPessimistic
    
    rs3.AddNew
    rs3!intintervalDays = intDays
    rs3.Update
    OverRideID = rs3!OverrideItem_id
    rs3.Close
    Set rs3 = Nothing
    
    'Get mailingStep_Id from mailingstep to insert into scheduledmailing
    
    SQL4 = "Select ms.mailingstep_id from mailingstep ms " & _
            "where ms.methodology_id = " & MethodID & _
            " and bitFirstSurvey = 1"
    
  
    rs4.Open SQL4, moConn, adOpenKeyset, adLockReadOnly
    
    If Not rs4.EOF And Not rs4.BOF Then
        rs4.MoveFirst
        MailStepID = rs4!mailingstep_id
    End If
    
    rs4.Close
    Set rs4 = Nothing
    
    'Insert a new record in ScheduledMailing with updated info
    SQL5 = "Insert into Scheduledmailing (MailingStep_id, samplepop_id" & _
            ", OverRideItem_id, methodology_id, Datgenerate)" & _
            " values (" & MailStepID & "," & SamplePopID & "," & _
            OverRideID & "," & MethodID & ", '" & Now & "')"
            
    moConn.Execute (SQL5)

    
Exit Sub

ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

Private Sub Class_Initialize()
    
    OpenDBConnection oConn:=moConn
    
End Sub

Private Sub Class_Terminate()
    
    CloseDBConnection oConn:=moConn
    
End Sub
