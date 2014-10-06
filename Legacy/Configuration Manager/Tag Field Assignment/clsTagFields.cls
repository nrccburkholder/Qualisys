VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsTagFields"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
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
'   Name        Type        Description
'
' Revisions:
'   Date        By      Description
'   04-10-2002  SH      Removed MTS objects.
'   09-29-2002  SH      Renamed QualProFunctions to QualiSys.
'   10-01-2002  SH      Recompiled with VB6.0 and moved DLL
'                       to \components\QualiSysDLLs\
'-----------------------------------------------------------------

Option Explicit

Public lngTagid As Long
Private cn As New ADODB.Connection

Private Sub Class_Initialize()
    
    Dim QPFunction As New QualiSysFunctions.Library '04-05-2002 SH
        
    Set cn = CreateObject("ADODB.Connection")
    cn.Open QPFunction.GetDBString
    Set QPFunction = Nothing
    
End Sub

Private Sub Class_Terminate()

    Set cn = Nothing
    
End Sub

Public Function TagDescriptions(strTag As String, ByVal lngSurveyId As Long) As Variant
    
    Dim rs As Recordset
    Dim strSql As String
    Dim varTags As New Collection
    Dim tmpTags() As String
    Dim strTmp As String
    Dim X As Long
    Dim Y As Long
        
    Set varTags = FindTags(lngTagid)
    
    For X = 1 To varTags.Count
        strTmp = strTag
        If Not Trim(varTags(X)) = "" Then
            Set rs = New ADODB.Recordset
            strSql = "sp_QP_FetchTag " & Chr(34) & varTags(X) & Chr(34)
            cn.CommandTimeout = 0
            Set rs = cn.Execute(strSql)
            If Not rs.EOF And Not rs.BOF Then
                rs.Close
                Set rs = Nothing
                ' We are now using the tag on the left side of the
                ' grid becuase the description is being used as
                ' sample data instead of a description.
                strTmp = varTags(X) & "--" & TagId(varTags(X))
                ReDim Preserve tmpTags(X) As String
                tmpTags(X) = strTmp
            Else
                rs.Close
                Set rs = Nothing
                strTmp = varTags(X)
                ReDim Preserve tmpTags(0) As String
                tmpTags(0) = "Undefined Tag '" & strTmp & "'!---1"
                cn.CommandTimeout = 0
                cn.Execute "UPDATE Survey_def SET bitValidated_flg = 0 WHERE Survey_id = " & lngSurveyId
                X = varTags.Count + 1
            End If
        End If
    Next X
    
    Set rs = Nothing
    If X > 1 Then
        TagDescriptions = tmpTags
    Else
        TagDescriptions = Null
    End If
    
End Function

Public Function FindTags(lngCode As Long) As Collection
    
    Dim rs As Recordset
    Dim rsSave As Recordset
    Dim strSql As String
    Dim lngCodeCount As Long: lngCodeCount = 0
    Dim lngLocation As Long: lngLocation = 1
    Dim lngLength As Long: lngLength = 0
    Dim lngTagid As Long: lngTagid = -1
    Dim strCodes As New Collection
    Dim rsGetTagCodeLoc As Recordset
    
    On Error GoTo BadTagField

    strSql = "SELECT t.CodeText_id, t.QPC_Text FROM CodesText as t WHERE Code = " & lngCode
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    
    '*SQL7.0*
    While Not rs.EOF
        While lngLocation <> 0 And lngLocation <> -1
            lngLocation = InStr(lngLocation, rs!QPC_Text, Chr(174))
            If lngLocation <> 0 Then
                lngLength = InStr(lngLocation, rs!QPC_Text, Chr(175))
                If lngLength = 0 Then
                    lngLocation = -1
                Else
                    ' A code was found
                    strCodes.Add Mid(rs!QPC_Text, lngLocation + 1, lngLength - lngLocation - 1)
                    ' Store the location in the database
                    lngTagid = TagId(Mid(rs!QPC_Text, lngLocation + 1, lngLength - lngLocation - 1))
                    strSql = "DELETE FROM CodeTextTag WHERE CodeText_id = " & _
                             rs!CodeText_id & " AND Tag_id = " & lngTagid
                    cn.CommandTimeout = 0
                    cn.Execute (strSql)
                    strSql = "INSERT INTO CodeTextTag (CodeText_id, Tag_id, intStartpos, intLength ) VALUES ( " & _
                             rs!CodeText_id & ", " & lngTagid & ", " & lngLocation & _
                             ", " & lngLength - lngLocation + 1 & " )"
                    cn.CommandTimeout = 0
                    cn.Execute (strSql)
                    lngCodeCount = lngCodeCount + 1
                    lngLocation = lngLength - 1
                End If
            End If
        Wend
        lngLocation = 1
        rs.MoveNext
    Wend
    
    Set rs = Nothing
    Set rsSave = Nothing
    If strCodes.Count > 0 Then
        Set FindTags = strCodes
    Else
        Set FindTags = Nothing
    End If
    Exit Function
    
BadTagField:
    App.LogEvent Err.Description, vbLogEventTypeError
    Set rs = Nothing
    Set rsSave = Nothing
    If strCodes.Count > 0 Then
        Set FindTags = strCodes
    Else
        Set FindTags = Nothing
    End If
    
End Function

Public Sub DelTagField(ByVal lngTagid As Long, lngStudyid As Long)
    
    Dim strSql As String
    
    strSql = "DELETE FROM TagField WHERE Tag_id = " & _
             lngTagid & " AND study_id = " & lngStudyid
    cn.CommandTimeout = 0
    cn.Execute (strSql)
    
End Sub

Public Sub DelTagException(ByVal lngStudyid As Long)
    
    Dim strSql As String
    
    strSql = "DELETE FROM TagException WHERE Study_id = " & lngStudyid
    cn.CommandTimeout = 0
    cn.Execute (strSql)
    
End Sub

Public Sub DelSurveyLocations(ByVal lngSurveyId As Long)
    
    Dim strSql As String
    
    ' Clear out all the locations of codes in Questions
    strSql = "DELETE FROM CodeQstns WHERE Survey_id = " & lngSurveyId
    cn.CommandTimeout = 0
    cn.Execute (strSql)
    strSql = "DELETE FROM CodeTxtBox WHERE Survey_id = " & lngSurveyId
    cn.CommandTimeout = 0
    cn.Execute (strSql)
    strSql = "DELETE FROM CodeScls WHERE Survey_id = " & lngSurveyId
    cn.CommandTimeout = 0
    cn.Execute (strSql)
    
End Sub

Public Sub SetTagField(ByVal lngStudyid As Long, ByVal lngTagid As Long, Optional lngTableid As Long = 0, Optional lngFieldid As Long = 0, Optional strLiteral As String = "")
    
    On Error GoTo ErrHandler
    
    Dim strSql As String
    Dim rs As Recordset
    Dim Y As Long
    Dim strTmp As String
    Dim flgReplaceField As Boolean
    
    If Trim(strLiteral) <> "" Then
        flgReplaceField = True
    Else
        flgReplaceField = False
    End If
    
    strSql = "SELECT f.Tag_id FROM TagField as f WHERE Tag_id = " & lngTagid & _
             " AND study_id = " & lngStudyid
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    
    If InStr(1, strLiteral, "'") = 0 Then
        If InStr(1, strLiteral, "''") <> 0 Then
            For Y = 1 To Len(strLiteral)
                If Mid(strLiteral, Y, 1) <> "''" Then
                    strTmp = strTmp + Mid(strLiteral, Y, 1)
                Else
                    strTmp = strTmp + "'"
                End If
            Next Y
            strLiteral = strTmp
        End If
    End If
    
    If InStr(1, strLiteral, "''") = 0 Then
        If InStr(1, strLiteral, "'") <> 0 Then
            For Y = 1 To Len(strLiteral)
                If Mid(strLiteral, Y, 1) <> "'" Then
                    strTmp = strTmp + Mid(strLiteral, Y, 1)
                Else
                    strTmp = strTmp + "''"
                End If
            Next Y
            strLiteral = strTmp
        End If
    End If
    
    If Not rs.EOF And Not rs.BOF Then
        rs.Close
        Set rs = Nothing
        If lngTableid > 0 And lngFieldid > 0 Then
            strSql = "UPDATE TagField SET Table_id = " & lngTableid & _
                     ", Field_id = " & lngFieldid & _
                     ", ReplaceField_flg = 0, strReplaceLiteral = Null WHERE Tag_id = " & _
                     lngTagid & " AND study_id = " & lngStudyid
        Else
            If Trim(strLiteral) <> "" Then
                strSql = "UPDATE TagField SET Table_id = Null, Field_id = Null, ReplaceField_flg = 1, strReplaceLiteral = '" & Trim(strLiteral) & "' WHERE Tag_id = " & lngTagid & " and study_id = " & lngStudyid
            Else
                strSql = "UPDATE TagField SET Table_id = Null, Field_id = Null, ReplaceField_flg = 1, strReplaceLiteral = Null WHERE Tag_id = " & lngTagid & " and study_id = " & lngStudyid
            End If
        End If
    Else
        rs.Close
        Set rs = Nothing
        If lngTableid > 0 And lngFieldid > 0 Then
            strSql = "INSERT INTO TagField (Tag_id, Table_id, Field_id, ReplaceField_flg, strReplaceLiteral, Study_id ) VALUES ( " & lngTagid & ", " & lngTableid & ", " & lngFieldid & ", 0, null, " & lngStudyid & ")"
        Else
            If Trim(strLiteral) <> "" Then
                strSql = "INSERT INTO TagField (Tag_id, Table_id, Field_id, ReplaceField_flg, strReplaceLiteral, Study_id ) VALUES ( " & lngTagid & ", null, null, 1, '" & Trim(strLiteral) & " ', " & lngStudyid & ")"
            Else
                strSql = "INSERT INTO TagField (Tag_id, Table_id, Field_id, ReplaceField_flg, strReplaceLiteral, Study_id ) VALUES ( " & lngTagid & ", null, null, 1, null, " & lngStudyid & ")"
            End If
        End If
    End If
    
    cn.CommandTimeout = 0
    cn.Execute (strSql)
    Set rs = Nothing
    
    Exit Sub
    
ErrHandler:
    App.LogEvent Err.Description, vbLogEventTypeError
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Sub

Public Function GetTagField(ByVal lngTagid As Long, ByVal lngStudyid As Long) As String
    
    Dim strSql As String
    Dim rs As ADODB.Recordset
    Dim lTable_id As Long
    Dim lField_id As Long
    
    strSql = "SELECT * FROM TagField as f WHERE f.Tag_id = " & lngTagid & " and study_id = " & lngStudyid
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    
    If Not rs.EOF And Not rs.BOF Then
        If rs.Fields("replaceField_flg").Value = True Then
            GetTagField = Trim(IIf(IsNull(rs.Fields("strReplaceLiteral").Value), "", rs.Fields("strReplaceLiteral").Value))
        Else
            lTable_id = rs.Fields("Table_id").Value
            lField_id = rs.Fields("Field_id").Value
            rs.Close
            
            strSql = "SELECT t.strTable_nm, f.strField_nm from metaTable as t, metaField as f WHERE " & _
            " t.Table_id = " & lTable_id & " AND " & _
            " f.Field_id = " & lField_id
            
            cn.CommandTimeout = 0
            Set rs = cn.Execute(strSql)
            If Not rs.EOF And Not rs.BOF Then
                GetTagField = Trim(rs.Fields("strTable_nm").Value) & "." & Trim(rs.Fields("strField_nm").Value)
            End If
        End If
    Else
        GetTagField = ""
    End If
    
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If

End Function

Public Function GetTagException(ByVal lngStudyid As Long) As Variant
    
    Dim strSql As String
    Dim rs As Recordset
    
    strSql = "SELECT t.*, m.strfield_nm, m.strtable_nm " & _
             " FROM TagException t, metadata_view m " & _
             " WHERE t.study_id = " & lngStudyid & _
             " AND m.study_id = t.study_id " & _
             " AND t.field_id = m.field_id " & _
             " AND t.table_id = m.table_id "
             
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    
    If Not rs.EOF And Not rs.BOF Then
        GetTagException = rs.GetRows
    End If
    
    Set rs = Nothing

End Function

Public Function SaveTagException(ByVal lngStudyid As Long, ByVal lngTagid As Long, ByVal lngTableid As Long, ByVal lngFieldid As Long) As Variant
    
    Dim strSql As String
    
    strSql = "UPDATE TagException " & _
             "SET Tag_id = " & lngTagid & _
             " AND Table_id = " & lngTableid & _
             " AND Field_id = " & lngFieldid & _
             " WHERE Study_id = " & lngStudyid
                          
    cn.CommandTimeout = 0
    cn.Execute (strSql)

End Function

Public Function TagId(ByVal strTag As String) As Long
    
    Dim rs As Recordset
    Dim Y As Long
    Dim X As Long
    Dim strSql As String
    Dim strTmp As String
    Dim lngTagid As Long
    
    If InStr(1, strTag, "''") = 0 Then
        If InStr(1, strTag, "'") <> 0 Then
            For Y = 1 To Len(strTag)
                If Mid(strTag, Y, 1) <> "'" Then
                    strTmp = strTmp + Mid(strTag, Y, 1)
                Else
                    strTmp = strTmp + "''"
                End If
            Next Y
        Else
            strTmp = strTag
        End If
    Else
        strTmp = strTag
    End If
    strSql = "SELECT * FROM Tag WHERE Tag = '" & strTmp & "'"
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    If Not rs.EOF And Not rs.BOF Then
        TagId = rs!tag_id
    Else
        TagId = -1
    End If
    
    Set rs = Nothing

End Function

Public Sub SaveQstnsCodeLoc(ByVal lngQuestionId As Long, ByVal lngSurveyId As Long, ByVal lngCode As Long, ByVal lngStart As Long, ByVal lngLength As Long, ByVal lngLangID As Long)
    
    Dim rs As Recordset
    Dim strSql As String
    
    On Error GoTo ErrorHandler
    
    strSql = "SELECT * FROM CodeQstns WHERE SelQstns_id = " & lngQuestionId & " AND Survey_id = " & lngSurveyId & " AND code = " & lngCode & " AND intStartPos = " & lngStart & " AND intLength = " & lngLength & " AND Language = " & lngLangID
    
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    
    If rs.EOF And rs.BOF Then
        rs.Close
        Set rs = Nothing
        
        strSql = "INSERT INTO CodeQstns (SelQstns_id, Survey_id, Code, Language, intStartPos, intLength ) VALUES ( " & lngQuestionId & ", " & lngSurveyId & ", " & lngCode & ", " & lngLangID & ", " & lngStart & ", " & lngLength & " )"
        cn.CommandTimeout = 0
        cn.Execute strSql
    End If
    
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    
    Exit Sub
    
ErrorHandler:
    App.LogEvent Err.Number & ":" & Err.Description
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Sub

Private Function ScaleLanguage(ByVal lngQuestionId As Long, ByVal lngSurveyId As Long) As Long
    
    Dim strSql As String
    Dim rs As ADODB.Recordset
    
    '*SQL7.0*
    strSql = "SELECT Language FROM Sel_Scls WHERE QPC_Id = " & lngQuestionId & " AND Survey_id = " & lngSurveyId
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    If Not rs.EOF And Not rs.BOF Then
        ScaleLanguage = rs!Language
    End If
    Set rs = Nothing

End Function

Public Sub SaveSclsCodeLoc(ByVal lngQuestionId As Long, ByVal lngSurveyId As Long, lngItem As Long, lngLanguage As Long, ByVal lngCode As Long, ByVal lngStart As Long, ByVal lngLength As Long)
    
    Dim rs As Recordset
    Dim strSql As String
    
    strSql = "SELECT * FROM CodeScls WHERE QPC_ID = " & lngQuestionId & " AND Survey_id = " & lngSurveyId & " AND Item = " & lngItem & " AND Language = " & lngLanguage & " AND code = " & lngCode & " AND intStartPos = " & lngStart & " AND intLength = " & lngLength
    
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    
    If rs.EOF And rs.BOF Then
        rs.Close
        Set rs = Nothing
        
        strSql = "INSERT INTO CodeScls (QPC_ID, Item, Survey_id, Language, Code, intStartPos, intLength ) VALUES (" & lngQuestionId & ", " & lngItem & ", " & lngSurveyId & ", " & lngLanguage & ", " & lngCode & ", " & lngStart & ", " & lngLength & " )"
        cn.CommandTimeout = 0
        cn.Execute (strSql)
    End If
    
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If

End Sub

Public Sub SaveTxtBoxCodeLoc(ByVal lngQuestionId As Long, ByVal lngSurveyId As Long, ByVal lngCode As Long, ByVal lngStart As Long, ByVal lngLength As Long, ByVal lngLangID As Long)
    
    Dim rs As Recordset
    Dim strSql As String
    
    strSql = "SELECT * FROM CodeTxtBox WHERE QPC_ID = " & lngQuestionId & " AND Survey_id = " & lngSurveyId & " AND code = " & lngCode & " AND intStartPos = " & lngStart & " AND intLength = " & lngLength & " AND Language = " & lngLangID
    
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    
    If rs.EOF And rs.BOF Then
        rs.Close
        Set rs = Nothing
        
        strSql = "INSERT INTO CodeTxtBox (QPC_ID, Survey_id, Language, Code, intStartPos, intLength ) VALUES ( " & lngQuestionId & ", " & lngSurveyId & ", " & lngLangID & ", " & lngCode & ", " & lngStart & ", " & lngLength & " )"
        cn.CommandTimeout = 0
        cn.Execute (strSql)
    End If
    
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    
End Sub

Public Function GetQstnsCodeLoc(lngQuestionId As Long, lngSurveyId As Long) As Variant
    
    Dim rs As Recordset
    Dim strSql As String
    
    strSql = "SELECT * FROM CodeQstns WHERE SelQstns_id = " & lngQuestionId & " AND Survey_id = " & lngSurveyId
    
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql)
    If Not rs.EOF And Not rs.BOF Then
        GetQstnsCodeLoc = rs.GetRows
    Else
        GetQstnsCodeLoc = Null
    End If
    Set rs = Nothing

End Function

Public Function SelQuestions(lngSurveyId As Long) As Variant
    
    Dim rs As New ADODB.Recordset
    Dim strSql As String
    
    'strSql = "SELECT q.SelQstns_id, q.RichText FROM Sel_Qstns as q WHERE q.Survey_id = " & lngSurveyId
    strSql = "SELECT q.SelQstns_id, q.RichText, q.language FROM Sel_Qstns as q WHERE q.Survey_id = " & lngSurveyId
    
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql, adOpenKeyset)
    
    If Not rs.EOF And Not rs.BOF Then
        SelQuestions = rs.GetRows
    Else
        SelQuestions = Null
    End If
    Set rs = Nothing

End Function

Public Function SelScales(lngSurveyId As Long) As Variant
    
    Dim rs As New ADODB.Recordset
    Dim strSql As String
    
    ' Not sure how to make this unique to survey
    '*SQL7.0*
    strSql = "SELECT q.QPC_ID, q.item, q.language, q.RichText FROM Sel_Scls as q WHERE q.Survey_id = " & lngSurveyId
    
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql, adOpenKeyset)
    
    If Not rs.EOF And Not rs.BOF Then
        SelScales = rs.GetRows
    Else
        SelScales = Null
    End If
    Set rs = Nothing

End Function

Public Function SelTextBoxes(lngSurveyId As Long) As Variant
    
    Dim rs As New ADODB.Recordset
    Dim strSql As String
    
    ' Not sure how to make this unique to survey
    '*SQL7.0*
    strSql = "SELECT q.QPC_ID, q.RichText, q.Language FROM Sel_TextBox as q WHERE q.Survey_id = " & lngSurveyId
    
    cn.CommandTimeout = 0
    Set rs = cn.Execute(strSql, adOpenKeyset)
    
    If Not rs.EOF And Not rs.BOF Then
        SelTextBoxes = rs.GetRows
    Else
        SelTextBoxes = Null
    End If
    Set rs = Nothing

End Function

Public Sub SetTagExceptions(lngTagid As Long, lngTableid As Long, lngFieldid As Long, lngStudyid As Long)
    
    Dim strSql As String

    strSql = "INSERT INTO TagException " & _
             "(Tag_id, Table_id, Field_id, Study_id) " & _
             "VALUES(" & lngTagid & "," & lngTableid & _
             "," & lngFieldid & "," & lngStudyid & ")"

    cn.CommandTimeout = 0
    cn.Execute (strSql)

End Sub
