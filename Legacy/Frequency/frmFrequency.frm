VERSION 5.00
Begin VB.Form frmFrequency 
   Caption         =   "Frequency"
   ClientHeight    =   6075
   ClientLeft      =   135
   ClientTop       =   420
   ClientWidth     =   8235
   LinkTopic       =   "Form1"
   ScaleHeight     =   6075
   ScaleWidth      =   8235
   Begin VB.CommandButton cmdRunFrequencies 
      Caption         =   "&Run Frequencies"
      Height          =   405
      Left            =   3765
      TabIndex        =   10
      Top             =   5400
      Width           =   1530
   End
   Begin VB.Frame fraSelectFields 
      Caption         =   " Select Fields for Evaluation "
      Height          =   4560
      Left            =   180
      TabIndex        =   1
      Top             =   705
      Width           =   7845
      Begin VB.CommandButton cmdSelectAll 
         Caption         =   ">>"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   405
         Left            =   3660
         TabIndex        =   7
         Top             =   1395
         Width           =   585
      End
      Begin VB.ListBox lstAvailableFields 
         Height          =   3180
         Left            =   225
         Sorted          =   -1  'True
         TabIndex        =   6
         Top             =   900
         Width           =   3045
      End
      Begin VB.ListBox lstSelectedFields 
         Height          =   3180
         Left            =   4590
         Sorted          =   -1  'True
         TabIndex        =   5
         Top             =   900
         Width           =   3045
      End
      Begin VB.CommandButton cmdDeSelectAll 
         Caption         =   "<<"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   405
         Left            =   3660
         TabIndex        =   4
         Top             =   3345
         Width           =   585
      End
      Begin VB.CommandButton cmdDeSelect 
         Caption         =   "<"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   405
         Left            =   3660
         TabIndex        =   3
         Top             =   2790
         Width           =   585
      End
      Begin VB.CommandButton cmdSelect 
         Caption         =   ">"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   405
         Left            =   3660
         TabIndex        =   2
         Top             =   2115
         Width           =   585
      End
      Begin VB.Label Label1 
         Caption         =   "Selected Fields:"
         Height          =   3375
         Left            =   4590
         TabIndex        =   9
         Top             =   585
         Width           =   3045
      End
      Begin VB.Label lblAvailableFields 
         Caption         =   "Available Fields:"
         Height          =   285
         Left            =   150
         TabIndex        =   8
         Top             =   600
         Width           =   1275
      End
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   360
      Left            =   6705
      TabIndex        =   0
      Top             =   5535
      Width           =   1215
   End
End
Attribute VB_Name = "frmFrequency"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'Public OLEExcel As Excel.Application
Private strSql As String
'Private aFreq() As Variant  ' FG don't need this
Private aFreq As String
Private iRecCount As Long
Private xlRow As Long
Private mlngFileHandle As Long
Private mstrFileName As String
Private mStrToWrite As String
Private Enc_Exist As Integer

Private Type udtTableFields
    TableName As String
    Table_id As Long
    FieldName As String
    Key_Field As Long
    Field_id As Long
    Field_Type As String
End Type

Dim strField As String

Private aTableFields() As udtTableFields

Sub LoadAvailableFieldsListBox()

    Dim strSql As String
    Dim rsFields As ADODB.Recordset

    strSql = _
             "SELECT DISTINCT metaTable.strTable_nm, metaField.strField_nm " & _
             "FROM (metaStructure " & _
             "INNER JOIN metaTable ON metaStructure.Table_id = metaTable.Table_id) " & _
             "INNER JOIN metaField ON metaStructure.Field_id = metaField.Field_id " & _
             "WHERE Study_id = " & glngStudy_id
    
    Set rsFields = New ADODB.Recordset
    rsFields.CursorLocation = adUseClient
    
    rsFields.Open strSql, cnOne, adOpenKeyset, adLockBatchOptimistic
    
    Set rsFields = cnOne.Execute(strSql, dbOpenDynaset)
    
    If rsFields.EOF = True And rsFields.BOF = True Then
        ' When finished free resourses and point to nothing
        rsFields.Close
        Set rsFields = Nothing
        Exit Sub
    Else
        ' return the array size
        ' Get the study's tables and field names
        ' Clear out the listbox and build the entries, excluding the three preselected fields listed below.
        lstAvailableFields.Clear
        Do Until rsFields.EOF
            lstAvailableFields.AddItem rsFields!strTable_nm & "." & rsFields!strField_nm
            If UCase(rsFields!strTable_nm & "." & rsFields!strField_nm) = "ENCOUNTER.ENC_ID" Then Enc_Exist = 1
            rsFields.MoveNext
        Loop
    End If
    
    rsFields.Close
    Set rsFields.ActiveConnection = Nothing

End Sub

Private Sub cmdClose_Click()
    
    '----------------------------------------------------------------------------------------------------------------------------------------
    ' Purpose:  Close frmFrequency and redisplay
    '           frmMain.
    '----------------------------------------------------------------------------------------------------------------------------------------
    
    frmMain.Show
    
    'Me.Hide
    Unload Me 'destroy form instead

End Sub

Private Sub cmdDeSelect_Click()
            
    MoveFields (3)

End Sub

Private Sub cmdDeSelectAll_Click()
    
    MoveFields (4)

End Sub

Private Sub cmdRunFrequencies_Click()

    If frmFrequency.lstSelectedFields.ListCount = 0 Then
        MsgBox "Please select a field from the Available fields list box."
        Exit Sub
    Else
        Screen.MousePointer = vbHourglass
        mStrToWrite = ""
        Call RunFrequencies
        
        ' Write the data to the file
        Call subWriteAscii(mStrToWrite)
        
        ' close the 'csv' file
        ' launch excel with the file name as parameter so it opens
        If fctCloseAsciiFile(mstrFileName) Then
            'good
        Else
            'bad
        End If
        
        Dim xls As Object

        ' *** Added 09-18-2002 SH
        Dim strUserPath As String
        
        strUserPath = "c:\Users\" & Trim(gstrLoginName) & "\Documents\"
        
        Beep
        Beep
        
        'Shell "c:\program files\microsoft office\office\excel.exe ""c:\my documents\" & mstrFileName & """"
        'Shell "excel.exe c:\mydocu~1\" & mstrFileName
        Set xls = Nothing
        ' *** Removed 09-18-2002 SH
        'Set xls = GetObject("c:\my documents\" & mstrFileName)
        ' *** Added 09-18-2002 SH
        Set xls = GetObject(strUserPath & mstrFileName)
        
        'let's try to format that sheet a littel better...
        xls.Application.Windows(mstrFileName).Activate
        xls.Application.Range("C:C").NumberFormat = "0.00%"
        
        Dim ir As Integer
        Dim cr As Integer
        Dim pr As Integer
        
        ir = 1
        pr = 1
        cr = 1
        
        xls.Application.Range("a1").Select
        xls.Application.Visible = True
        
        On Error Resume Next
        
        xls.Application.Cells.Find(What:="Totals", After:=xls.Application.ActiveCell, LookIn:=xlCellValue, LookAt _
            :=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:= _
            False).Activate
        
        ir = xls.Application.ActiveCell.Row
        If ir > 2 Then
            cr = xls.Application.ActiveCell.Row
            xls.Application.Range("a" & pr & ":c" & cr).AutoFormat xlRangeAutoFormatSimple
            pr = xls.Application.ActiveCell.Row + 1
    
            Do While True
                xls.Application.Cells.FindNext(After:=xls.Application.ActiveCell).Activate
                cr = xls.Application.ActiveCell.Row
                If cr = ir Then Exit Do
                xls.Application.Range("a" & pr & ":c" & cr).AutoFormat xlRangeAutoFormatSimple
                pr = xls.Application.ActiveCell.Row + 1
            Loop
        End If
        'end formatting
        
        'xls.Application.ActiveSheet.UsedRange.AutoFormat
        'xls.Application.ActiveSheet.Range("A:C").Columns.AutoFit
        xls.Application.DisplayAlerts = False
        ' *** Removed 09-18-2002 SH
        'xls.Application.ActiveWorkbook.SaveAs "c:\my documents\" & mstrFileName, 1
        ' *** Added 09-18-2002 SH
        xls.Application.ActiveWorkbook.SaveAs strUserPath & mstrFileName, 1
        xls.Application.Visible = True
        xls.Application.DisplayAlerts = True
        
        Screen.MousePointer = vbDefault
        Set xls = Nothing
        
        Beep
        Beep
    End If
    
End Sub

Private Sub cmdSelect_Click()
    
    MoveFields (2)

End Sub

Private Sub cmdSelectAll_Click()
        
    MoveFields (1)

End Sub

Private Sub Form_Activate()

    If frmMain!optPopulation(RAW_DATA).Value = True Then
        frmFrequency!fraSelectFields = " Select Load Table Available Fields "
        frmFrequency.Caption = frmFrequency.Caption & " From _LOAD Tables "
    Else
        frmFrequency!fraSelectFields = " Select Available Fields "
    End If
    
End Sub

Private Sub Form_Load()
    Enc_Exist = 0
    LoadAvailableFieldsListBox

End Sub

Public Sub MoveFields(iMovefields As Long)
    
    '-----------------------------------------------------------------------
    ' Purpose:  Moves fields between the Available and Selected list boxes
    '           controlled by the value of iMovefields passed in.
    '-----------------------------------------------------------------------

    Dim i As Long
    
    Select Case iMovefields
        Case 1:
            For i = 0 To lstAvailableFields.ListCount - 1
                lstSelectedFields.AddItem lstAvailableFields.List(i)
            Next
            lstAvailableFields.Clear
        Case 2:
            If lstAvailableFields.ListCount = 0 Then
                MsgBox "The Available  Fields box is empty"
            ElseIf lstAvailableFields.SelCount = 0 Then
                MsgBox "Please select a field"
            Else
                lstSelectedFields.AddItem lstAvailableFields.List(lstAvailableFields.ListIndex)
                lstAvailableFields.RemoveItem (lstAvailableFields.ListIndex)
            End If
        Case 3:
            If lstSelectedFields.ListCount = 0 Then
                MsgBox "The Selected Fields box is empty"
            ElseIf lstSelectedFields.SelCount = 0 Then
                MsgBox "Please select a field"
            Else
                lstAvailableFields.AddItem lstSelectedFields.List(lstSelectedFields.ListIndex)
                lstSelectedFields.RemoveItem (lstSelectedFields.ListIndex)
            End If
        Case 4:
            For i = 0 To lstSelectedFields.ListCount - 1
                lstAvailableFields.AddItem lstSelectedFields.List(i)
            Next
            lstSelectedFields.Clear
    End Select
    
End Sub

Public Sub RunFrequencies()
    
    '-------------------------------------------------------------
    ' Purpose:  User has selected fields and clicked Run Frequencies
    '           to perform frequencies on the selected tables
    '--------------------------------------------------------------
    
    On Error GoTo ErrorHandler
    
    Dim i As Long, iFlag As Long
    Dim lPosition As Long
    Dim iTotal As Long
    Dim strSearch As String
    Dim strTable As String
    Dim strTableField As String
    Dim strStudy As String
    Dim strSql As String
    Dim lngOptionSelected As Long
    Dim lngStart As Long
    Dim lngLength As Long
    Dim strTotalSQL As String
    'Dim objwiz As mtsImportFunctions.mts_Import_Wizard ' Removed 09-16-2002 SH
    Dim objwiz As ImportFunctionsPROC.Import_Wizard_PROC

    xlRow = 1
    iTotal = 0
    i = 0
    
    'Set OLEExcel = CreateObject("excel.application")
    'OLEExcel.Visible = True
    'OLEExcel.Workbooks.Add
    
    ' Open a text file for output
    ' Give it the same file name but a 'csv' extension
    mstrFileName = fctGetUniqueFileName(glngStudy_id)

    If fctOpenAsciiFile(mstrFileName) Then
        'good
    Else
        'bad
    End If
    
    ' For each of the fields in the selected fields list box
    For i = 0 To frmFrequency.lstSelectedFields.ListCount - 1
        iFlag = 0
        strSql = ""
        strSearch = frmFrequency.lstSelectedFields.List(i)
        strTableField = strSearch
        lPosition = InStr(strSearch, Chr(46))
        strField = Mid(strSearch, lPosition + 1)
        strStudy = Mid(strSearch, 1, lPosition - 1)
        strTable = Mid(strTableField, 1, lPosition - 1)
        strTable = "S" & glngStudy_id & "." & strTable
        
        lngOptionSelected = frmMain.lngGetPopulationOption()
        If lngOptionSelected = RAW_DATA Then
            strTable = strTable & "_LOAD"
            strSearch = strTable
        End If
        
        strTotalSQL = fnstr_GetTotalSQL(strTable, strField)
         
        iTotal = mts_fnlng_Get_FieldCountForTool(strTotalSQL)
        
        If iTotal > 0 Then
            Call GetFreqData(strTable, strField, iTotal)
            'Call CreateExcelSpreadsheet(True, i, strSearch)
            If fctOutPutFrequencies(True, i, strSearch, strTable & "." & strField) Then
               '- good
            Else
               '- bad
            End If
        Else
            'Call CreateExcelSpreadsheet(False, i, strSearch)
            If fctOutPutFrequencies(False, i, strSearch, strTable & "." & strField) Then
                '- good
            Else
                '- bad
            End If
        End If
    Next
    
    xlRow = 1
    
    'OLEExcel.Columns(1).AutoFit
    'OLEExcel.Columns(2).AutoFit
    'OLEExcel.Columns(3).AutoFit
    'OLEExcel.Visible = True

    frmFrequency.MousePointer = vbDefault
    
    'Set OLEExcel = Nothing
    
    Exit Sub
    
ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: frmFrequency.RunFrequencies, Error Description: " & Err.Description
    End
    
End Sub

Public Sub GetFreqData(ByVal strTable As String, ByVal strField As String, ByVal iTotal As Long)

    Dim i As Long
    Dim aData As Variant
    Dim strSql As String
    Dim strSQL1 As String
    Dim strSQL2 As String
    Dim varTtl1, varTtl2
    Dim strS_StudyNum As String
    
    strSql = GetFrequencySQL(strTable, strField, iTotal)
    aData = mts_fnvnt_Get_FreqDataForTool(strSql)
    iRecCount = UBound(aData, 2)
    
    ' FG Why do we need to use an array here?
    ' I'll rather use a string...
    
    'ReDim aFreq(Trim(iRecCount), 3)
    
    'For i = 0 To UBound(aFreq, 1)
    '    aFreq(i, 1) = aData(0, i)
    '    aFreq(i, 2) = aData(1, i)
    '    aFreq(i, 3) = aData(2, i)
    'Next i
    aFreq = "" 'Blank it
    varTtl1 = 0
    varTtl2 = 0
    
    For i = 0 To iRecCount
        varTtl1 = varTtl1 + aData(1, i)
        varTtl2 = varTtl2 + aData(2, i)
        aFreq = aFreq & IIf(IsNull(aData(0, i)), "[NULL]", aData(0, i)) & ","
        aFreq = aFreq & aData(1, i) & ","
        aFreq = aFreq & aData(2, i) & vbCr
        DoEvents
    Next i
    
    aFreq = aFreq & "Totals," & varTtl1 & "," & varTtl2 & vbCr & vbCr

End Sub

Private Sub lstAvailableFields_DblClick()

    cmdSelect_Click

End Sub

Private Sub lstSelectedFields_DblClick()

    cmdDeSelect_Click

End Sub

Private Function GetFrequencySQL(strTableName As String, strFieldName As String, lTotal As Long) As String
    
    '-----------------------------------------------------
    ' Purpose:  Based on the control settings on fmrMain
    '           build the SQL string to retrieve the
    '           frequency Data.  The SQL's output will contain
    '           the fieldName, fieldcount, and the percentage.
    '           Thes are the 3 entried you see on the Frequencies
    '           Excel spreadsheet.
    '-----------------------------------------------------
    
    Dim strSql As String
    Dim strSQL1 As String
    Dim strSQL2 As String
    Dim strSQLNewRecDate As String
    Dim strDateRecName As String
    Dim strTableNm As String
    Dim strStudyNum As String
    Dim lngOptionSelected  As Long
    Dim lngKey As Long
    Dim lLenName As Long
    Dim lngPeriodPos As Long
    Dim vKey As Variant
    Dim ssobj As Object
    Dim rs As New ADODB.Recordset
    Dim strKeyField As String
    
    ' Get the Population option button selected
   lngOptionSelected = frmMain.lngGetPopulationOption()

    Select Case lngOptionSelected
        Case UNIVERSE
            ' Get the fieldname for the data retrieval
            strSQLNewRecDate = "SELECT strField_nm " & _
                               "FROM metafield " & _
                               "WHERE intSpecialField_cd = " & _
                               "(SELECT numParam_value " & _
                               " FROM qualpro_params " & _
                               " WHERE strParam_nm = 'FieldNewRecordDate')"
            Set rs = cnOne.Execute(strSQLNewRecDate, adOpenKeyset)
            
            rs.MoveFirst
            strDateRecName = rs!strField_nm
            Set rs = Nothing
            
            strSql = "SELECT " & strFieldName & ", COUNT (*), " & _
                     "(CONVERT(real,(COUNT(*)))/" & lTotal & ") " & _
                     "FROM " & strTableName & " " & _
                     "WHERE " & strDateRecName & " " & _
                     "BETWEEN '" & frmMain!mebStartDate & "' AND '" & frmMain!mebEndDate & "' " & _
                     "GROUP BY " & strFieldName & " " & _
                     "ORDER BY " & strFieldName
                
        Case SAMPLE_SET
            lngPeriodPos = InStr(1, strTableName, ".")
            lLenName = Len(strTableName)
            strTableNm = Right(strTableName, lLenName - lngPeriodPos)
            strStudyNum = Left(strTableName, lngPeriodPos - 1)
            vKey = mts_fnvnt_Get_KeyField(glngStudy_id, strTableNm)
            If UCase(strTableNm) = "ENCOUNTER" Then
                strKeyField = "Enc_id"
            ElseIf UCase(strTableNm) = "POPULATION" Then
                strKeyField = "Pop_id"
            Else
                strKeyField = strTableNm & vKey(0, 0)
            End If
            ' 8/31/1999 DV - CGA
            ' Dead Unused SQL
            'strSql = "SELECT strTable_nm, Table_id " & _
            '         "From metaTable " & _
            '         "WHERE strTable_nm = '" & strTableNm & " ' " & _
            '         "And study_id = " & glngStudy_id
            
            If UCase(strTableNm) = "ENCOUNTER" Or UCase(strTableNm) = "POPULATION" Then
            strSql = " SELECT t." & strFieldName & ", COUNT (*)," & _
                     " (CONVERT(real,(COUNT(*)))/" & lTotal & ") " & _
                     " FROM " & strTableName & " t, " & _
                     " (SELECT Distinct " & strKeyField & " AS KeyValue " & _
                     " FROM selectedsample" & _
                     " WHERE sampleset_id IN (" & gstrSampleSets & ")" & _
                     "      AND strunitselecttype='D') US " & _
                     " WHERE t." & vKey(0, 0) & " = US.KeyValue " & _
                     " GROUP BY t." & strFieldName & " " & _
                     " ORDER BY " & strFieldName
            Else
                If Enc_Exist = 1 Then
                    strSql = "SELECT t." & strFieldName & ", COUNT (*)," & _
                         " (CONVERT(real,(COUNT(*)))/" & lTotal & ") " & _
                         " FROM " & strTableName & " t, " & _
                         " (SELECT " & strKeyField & " as KeyValue " & _
                         "  FROM selectedsample ss, " & strStudyNum & ".big_view bv " & _
                         "  WHERE sampleset_id IN (" & gstrSampleSets & ")" & _
                         "      AND ss.strunitselecttype='D'" & _
                         "      AND ss.pop_id=bv.populationPop_id" & _
                         "      AND ss.enc_id=bv.encounterEnc_id) US " & _
                         " WHERE t." & vKey(0, 0) & " = US.KeyValue " & _
                         " GROUP BY t." & strFieldName & " " & _
                         " ORDER BY " & strFieldName
                Else
                strSql = "SELECT t." & strFieldName & ", COUNT (*)," & _
                         " (CONVERT(real,(COUNT(*)))/" & lTotal & ") " & _
                         " FROM " & strTableName & " t, " & _
                         " (SELECT " & strKeyField & " as KeyValue " & _
                         " FROM selectedsample ss, " & strStudyNum & ".big_view bv " & _
                         " WHERE sampleset_id IN (" & gstrSampleSets & ")" & _
                         "      AND ss.strunitselecttype='D'" & _
                         "      AND ss.pop_id=bv.populationPop_id) US " & _
                         " WHERE t." & vKey(0, 0) & " = US.KeyValue " & _
                         " GROUP BY t." & strFieldName & " " & _
                         " ORDER BY " & strFieldName
                End If
            End If
            
'            strSql = "SELECT t." & strFieldName & ", COUNT (*)," & _
'                     "(CONVERT(real,(COUNT(*)))/" & lTotal & ") " & _
'                     "FROM " & strTableName & " t, " & _
'                     "(SELECT DISTINCT u.KeyValue " & _
'                     " FROM " & strStudyNum & ".unikeys u, samplepop s " & _
'                     " WHERE u.sampleset_id IN (" & gstrSampleSets & ") " & _
'                     "       AND u.table_id = " & vKey(1, 0) & " " & _
'                     "       AND u.sampleset_id = s.sampleset_id " & _
'                     "       AND u.pop_id = s.pop_id) US " & _
'                     "WHERE t." & vKey(0, 0) & " = US.KeyValue " & _
'                     "GROUP BY t." & strFieldName & " " & _
'                     "ORDER BY " & strFieldName
            
            'strSql = "SELECT " & strFieldName & ", count (*)," & _
            '        "(convert(real,(count(*)))/" & lTotal & ") " & _
            '        "FROM " & strTableName & " t " & _
            '        "WHERE EXISTS " & _
            '        "(SELECT * " & _
            '        "FROM " & strStudyNum & ".unikeys u, samplepop s " & _
            '        "WHERE u.sampleset_id   IN  (" & gstrSampleSets & ") " & _
            '            "AND  t." & vKey(0, 0) & " = u.KeyValue " & _
            '            "AND u.table_id = " & vKey(1, 0) & " " & _
            '            "AND u.sampleset_id = s.sampleset_id " & _
            '            "AND u.pop_id = s.pop_id) " & _
            '        "GROUP BY " & strFieldName
                   
        Case RESPONDENTS
            lngPeriodPos = InStr(1, strTableName, ".")
            lLenName = Len(strTableName)
            strTableNm = Right(strTableName, lLenName - lngPeriodPos)
            strStudyNum = Left(strTableName, lngPeriodPos - 1)
            vKey = mts_fnvnt_Get_KeyField(glngStudy_id, strTableNm)
                                                 
            ' 8/31/1999 DV - CGA
            ' This SQL doesn't run!
            'strSql = "SELECT strTable_nm, Table_id " & _
            '         "From metaTable " & _
            '         "WHERE strTable_nm = '" & strTableNm & " ' " & _
            '         "And study_id = " & glngStudy_id
 
            ' Option NEW chosen
            If frmMain!optTypeOfRespondents(0).Value = True Then
                ' 8/31/1999 DV
                ' Trying to get performance improvements.
                strSql = _
                         "SELECT t." & strFieldName & ", COUNT (*)," & _
                         "(CONVERT(real,(COUNT(*)))/" & lTotal & ") " & _
                         "FROM " & strTableName & " t, " & _
                         "(SELECT distinct u.KeyValue " & _
                         " FROM " & strStudyNum & ".unikeys u, " & _
                         "      samplepop s, questionform q " & _
                         " WHERE q.datReturned Is Not Null " & _
                         "       AND Q.cutoff_id IS NULL " & _
                         "       AND q.samplepop_id = s.samplepop_id " & _
                         "       AND u.Table_id = " & vKey(1, 0) & " " & _
                         "       AND u.pop_id = s.pop_id) US " & _
                         "WHERE t." & vKey(0, 0) & " = US.KeyValue " & _
                         "GROUP BY t." & strFieldName & " " & _
                         "ORDER BY " & strFieldName

                'strSql = _
                '    "SELECT " & strFieldName & ", count (*)," & _
                '    "(convert(real,(count(*)))/" & lTotal & ") " & _
                '    "FROM " & strTableName & " t " & _
                '    "WHERE EXISTS " & _
                '        "(SELECT * FROM " & strStudyNum & ".unikeys u, " & _
                '                 "samplepop s, questionform q " & _
                '        "WHERE q.datReturned Is Not Null " & _
                '            "AND Q.cutoff_id IS NULL " & _
                '            "AND q.samplepop_id = s.samplepop_id " & _
                '            "AND t." & vKey(0, 0) & " = u.KeyValue " & _
                '            "AND u.Table_id = " & vKey(1, 0) & " " & _
                '            "AND u.pop_id = s.pop_id)  " & _
                '    "Group By " & strFieldName
                
            ' Option ALL chosen
            Else
                ' 8/31/1999 DV
                ' Performance enhancement.
                strSql = _
                         "SELECT t." & strFieldName & ", COUNT (*)," & _
                         "(CONVERT(real,(COUNT(*)))/" & lTotal & ") " & _
                         "FROM " & strTableName & " t, " & _
                         "(SELECT DISTINCT u.KeyValue " & _
                         " FROM " & strStudyNum & ".unikeys u, " & _
                         "      samplepop s, questionform q " & _
                         " WHERE q.datReturned Is Not Null " & _
                         "       AND q.samplepop_id = s.samplepop_id " & _
                         "       AND u.Table_id = " & vKey(1, 0) & " " & _
                         "       AND u.pop_id = s.pop_id) US " & _
                         "WHERE t." & vKey(0, 0) & " = US.KeyValue " & _
                         "GROUP BY t." & strFieldName & " " & _
                         "ORDER BY " & strFieldName
                'strSql = _
                '    "SELECT " & strFieldName & ", count (*)," & _
                '    "(convert(real,(count(*)))/" & lTotal & ") " & _
                '    "FROM " & strTableName & " t " & _
                '    "WHERE EXISTS " & _
                '        "(SELECT * FROM " & strStudyNum & ".unikeys u, " & _
                '                 "samplepop s, questionform q " & _
                '        "WHERE q.datReturned Is Not Null " & _
                '            "AND q.samplepop_id = s.samplepop_id " & _
                '            "AND t." & vKey(0, 0) & " = u.KeyValue " & _
                '            "AND u.Table_id = " & vKey(1, 0) & " " & _
                '            "AND u.pop_id = s.pop_id)  " & _
                '    "Group By " & strFieldName
            End If
            
        Case RAW_DATA
            strSql = "SELECT " & strFieldName & ", COUNT (*)," & _
                     "(CONVERT(real,(COUNT(*)))/" & lTotal & ") " & _
                     "FROM " & strTableName & " " & _
                     "GROUP BY " & strFieldName & " " & _
                     "ORDER BY " & strFieldName
                     
    End Select
    
   GetFrequencySQL = strSql
     
End Function

Private Function fnstr_GetTotalSQL(strTableName As String, strFieldName As String) As String
    
    '-----------------------------------------------------
    ' Purpose:  Based on the control settings on frmMain
    '           calculate the SQL string to retrieve the
    '           frequency Data.
    '-----------------------------------------------------
    
    Dim strSQLNewRecDate As String
    Dim strSql As String
    Dim strDateRecName As String
    Dim strTableNm As String
    Dim strStudyNum As String
    Dim lngOptionSelected  As Long
    Dim rs As New ADODB.Recordset
    Dim ssobj As Object
    Dim lLenName As Long
    Dim lngKey As Long
    Dim lngPeriodPos As Long
    Dim vKey As Variant
    Dim strKeyField As String
    
    lngOptionSelected = frmMain.lngGetPopulationOption()
    
    Select Case lngOptionSelected
        Case UNIVERSE
            ' Get the fieldname for the data retrieval
            strSQLNewRecDate = _
                               "SELECT strField_nm " & _
                               "FROM metafield " & _
                               "WHERE intSpecialField_cd = " & _
                               "(SELECT numParam_value " & _
                               " FROM qualpro_params " & _
                               " WHERE strParam_nm = 'FieldNewRecordDate')"
                    
            Set rs = cnOne.Execute(strSQLNewRecDate, adOpenKeyset)
            rs.MoveFirst
            strDateRecName = rs!strField_nm
            Set rs = Nothing
    
            strSql = "SELECT COUNT(*) AS TotalCount " & _
                     "FROM " & strTableName & " " & _
                     "WHERE " & strDateRecName & " " & _
                     "BETWEEN '" & frmMain!mebStartDate & "' AND '" & frmMain!mebEndDate & "' "
                     
        Case SAMPLE_SET
            lngPeriodPos = InStr(1, strTableName, ".")
            lLenName = Len(strTableName)
            strTableNm = Right(strTableName, lLenName - lngPeriodPos)
            strStudyNum = Left(strTableName, lngPeriodPos - 1)
            vKey = mts_fnvnt_Get_KeyField(glngStudy_id, strTableNm)
            If UCase(strTableNm) = "ENCOUNTER" Then
                strKeyField = "Enc_id"
            ElseIf UCase(strTableNm) = "POPULATION" Then
                strKeyField = "Pop_id"
            Else
                strKeyField = strTableNm & vKey(0, 0)
            End If
            

            ' 8/31/1999 DV
            ' Dead SQL.
            'strSql = "SELECT strTable_nm, Table_id " & _
            '         "From metaTable " & _
            '         "WHERE strTable_nm = '" & strTableNm & " ' " & _
            '         "And study_id = " & glngStudy_id
    
            ' must get name and id of the table
            ' see mts_fnlng_Get_Key field
            If strTableNm = "ENCOUNTER" Or strTableNm = "POPULATION" Then
            strSql = "SELECT COUNT(Distinct " & strKeyField & ") AS TotalCount " & _
                     " FROM selectedsample" & _
                     " WHERE sampleset_id IN (" & gstrSampleSets & ")" & _
                     "      AND strunitselecttype='D'"
            Else
                If Enc_Exist = 1 Then
                    strSql = "SELECT COUNT(" & strKeyField & ") as TotalCount " & _
                            " FROM selectedsample ss, " & strStudyNum & ".big_view bv " & _
                            " WHERE sampleset_id IN (" & gstrSampleSets & ")" & _
                            "      AND ss.strunitselecttype='D'" & _
                            "      AND ss.pop_id=bv.populationPop_id" & _
                            "      AND ss.enc_id=bv.encounterEnc_id"
                Else
                    strSql = "SELECT COUNT(" & strKeyField & ") as TotalCount " & _
                            " FROM selectedsample ss, " & strStudyNum & ".big_view bv " & _
                            " WHERE sampleset_id IN (" & gstrSampleSets & ")" & _
                            "      AND ss.strunitselecttype='D'" & _
                            "      AND ss.pop_id=bv.populationPop_id"
                End If
 
            End If
                     
'            strSql = "SELECT COUNT(*) AS TotalCount " & _
'                     "FROM " & strTableName & " t, " & _
'                     "(SELECT DISTINCT u.KeyValue " & _
'                     " FROM " & strStudyNum & ".unikeys u, samplepop s " & _
'                     " WHERE u.sampleset_id IN (" & gstrSampleSets & ") " & _
'                     "       AND u.table_id = " & vKey(1, 0) & " " & _
'                     "       AND u.sampleset_id = s.sampleset_id " & _
'                     "       AND u.pop_id = s.pop_id) US " & _
'                     "WHERE t." & vKey(0, 0) & " = US.KeyValue "

            'strSql = "Select Count(*) as TotalCount " & _
            '        "FROM " & strTableName & " t " & _
            '        "WHERE EXISTS " & _
            '        "(SELECT * " & _
            '        "FROM " & strStudyNum & ".unikeys u, samplepop s " & _
            '        "WHERE u.sampleset_id   IN  (" & gstrSampleSets & ") " & _
            '            "AND  t." & vKey(0, 0) & " = u.KeyValue " & _
            '            "AND u.table_id = " & vKey(1, 0) & " " & _
            '            "AND u.sampleset_id = s.sampleset_id " & _
            '            "AND u.pop_id = s.pop_id) "
         
        Case RESPONDENTS
            lngPeriodPos = InStr(1, strTableName, ".")
            lLenName = Len(strTableName)
            strTableNm = Right(strTableName, lLenName - lngPeriodPos)
            strStudyNum = Left(strTableName, lngPeriodPos - 1)
                    
            vKey = mts_fnvnt_Get_KeyField(glngStudy_id, strTableNm)
                                                             
            ' 8/31/1999 DV - CGA
            ' Dead SQL.
            'strSql = "SELECT strTable_nm, Table_id " & _
            '         "From metaTable " & _
            '         "WHERE strTable_nm = '" & strTableNm & " ' " & _
            '         "And study_id = " & glngStudy_id
            
            ' Option NEW chosen
            If frmMain!optTypeOfRespondents(0).Value = True Then
                ' 8/31/1999 DV
                ' Performance improvements?
                strSql = "SELECT COUNT(*) AS TotalCount " & _
                         "FROM " & strTableName & " t, " & _
                         "(SELECT DISTINCT u.KeyValue " & _
                         " FROM " & strStudyNum & ".unikeys u, " & _
                         "      samplepop s, questionform q " & _
                         " WHERE q.datReturned Is Not Null " & _
                         "       AND Q.cutoff_id IS NULL " & _
                         "       AND q.samplepop_id = s.samplepop_id " & _
                         "       AND u.Table_id = " & vKey(1, 0) & " " & _
                         "       AND u.pop_id = s.pop_id) US " & _
                         "WHERE t." & vKey(0, 0) & " = US.KeyValue "
    
                'strSql = _
                '    "SELECT Count(*) as TotalCount " & _
                '    "FROM " & strTableName & " t " & _
                '    "WHERE EXISTS " & _
                '        "(SELECT * " & _
                '         "FROM " & strStudyNum & ".unikeys u, " & _
                '                 "samplepop s, questionform q " & _
                '         "Where q.datReturned Is Not Null " & _
                '            "AND Q.cutoff_id IS NULL " & _
                '            "AND q.samplepop_id = s.samplepop_id " & _
                '            "AND t." & vKey(0, 0) & " = u.KeyValue " & _
                '            "AND u.Table_id = " & vKey(1, 0) & " " & _
                '            "AND u.pop_id = s.pop_id)"
                                                  
            ' Option ALL chosen
            Else
                strSql = "SELECT COUNT(*) AS TotalCount " & _
                         "FROM " & strTableName & " t, " & _
                         "(SELECT DISTINCT u.KeyValue " & _
                         " FROM " & strStudyNum & ".unikeys u, " & _
                         "      samplepop s, questionform q " & _
                         " WHERE q.datReturned Is Not Null " & _
                         "       AND q.samplepop_id = s.samplepop_id " & _
                         "       AND u.Table_id = " & vKey(1, 0) & " " & _
                         "       AND u.pop_id = s.pop_id) US " & _
                         "WHERE t." & vKey(0, 0) & " = US.KeyValue "
    
                'strSql = _
                '    "SELECT Count(*) as TotalCount " & _
                '    "FROM " & strTableName & " t " & _
                '    "WHERE EXISTS " & _
                '        "(SELECT * FROM " & strStudyNum & ".unikeys u, " & _
                '                 "samplepop s, questionform q " & _
                '        "WHERE q.datReturned Is Not Null " & _
                '            "AND q.samplepop_id = s.samplepop_id " & _
                '            "AND t." & vKey(0, 0) & " = u.KeyValue " & _
                '            "AND u.Table_id = " & vKey(1, 0) & " " & _
                '            "AND u.pop_id = s.pop_id)"
            End If
                   
        Case RAW_DATA
            strSql = "SELECT COUNT(*) AS TotalCount " & _
                     "FROM " & strTableName
    End Select
    
    fnstr_GetTotalSQL = strSql
     
End Function

Function fctOpenAsciiFile(ByRef pstrFileName As String) As Boolean
        
    fctOpenAsciiFile = False

    mlngFileHandle = FreeFile
    
    ' 09-17-2002 SH
    ' To avoid the problem with any platform,
    ' create a temporary directory on the local drive (c:\Temp\).
        
    Dim strTempPath As String
    
    strTempPath = "C:\TEMP\"
    If Dir(strTempPath, vbDirectory) = "" Then
        MkDir strTempPath
    End If
        
    'Open "c:\windows\temp\" & pstrFileName For Output As #mlngFileHandle
    Open strTempPath & pstrFileName For Output As #mlngFileHandle
    
    fctOpenAsciiFile = True

End Function

Private Sub subWriteAscii(ByRef pstrToWrite As String)
    
    ' Output text
    Print #mlngFileHandle, pstrToWrite
    
End Sub

Function fctCloseAsciiFile(ByVal pstrFileName As String) As Boolean

    fctCloseAsciiFile = False

    Close #mlngFileHandle
        
    ' 09-18-2002 SH
    Dim strTempPath As String
    
    strTempPath = "c:\Temp\"
    
    ' Create the "Documents and Settings" directory (XP platform)
    ' on local drive (C) if it doesn't exist.
    Dim strUserPath As String
    
    strUserPath = "c:\Users\"
    If Dir(strUserPath, vbDirectory) = "" Then
        MkDir strUserPath
    End If
    
    ' Check subdirectory for the user and create it if it doesn't exist.
    strUserPath = strUserPath & Trim(gstrLoginName) & "\"
    If Dir(strUserPath, vbDirectory) = "" Then
        MkDir strUserPath
    End If
    
    ' Check subdirectory "My Documents" and create it if it doesn't exist.
    strUserPath = strUserPath & "Documents\"
    If Dir(strUserPath, vbDirectory) = "" Then
        MkDir strUserPath
    End If
    
    ' *** Removed 09-18-2002 SH
    'FileCopy "C:\Windows\Temp\" & pstrFileName, "C:\my documents\" & pstrFileName
    FileCopy strTempPath & pstrFileName, strUserPath & pstrFileName
    
    'Kill "C:\Windows\Temp\" & pstrFileName ' Removed 09-18-2002 SH
    Kill strTempPath & pstrFileName
    
    fctCloseAsciiFile = True

End Function

Private Function fctOutPutFrequencies(ByVal bData As Boolean, ByVal iIndex As Long, ByVal strSearch As String, ByVal strFieldName As String) As Boolean

    On Error GoTo ErrorHandler
    
    Dim iRow
    Dim i As Long
    Dim iCol As Long
    Dim strData As String
        
    If iIndex = 0 Then
       xlRow = 1
       
       'If frmMain.strCaller = "Import" Then
       '     strSearch = strSearch & "." & strField
       'End If
       mStrToWrite = mStrToWrite & """" & strFieldName & """"
       mStrToWrite = mStrToWrite & ","
    
       mStrToWrite = mStrToWrite & "Count"
       mStrToWrite = mStrToWrite & ","
        
       mStrToWrite = mStrToWrite & "Percentage"
       mStrToWrite = mStrToWrite & "%" & vbCr
        
       xlRow = xlRow + 1
       iRow = xlRow
    Else
       xlRow = xlRow + 1
    
       mStrToWrite = mStrToWrite & """" & strFieldName & """"
       mStrToWrite = mStrToWrite & ","
        
       mStrToWrite = mStrToWrite & "Count"
       mStrToWrite = mStrToWrite & ","
        
       mStrToWrite = mStrToWrite & "Percentage"
       mStrToWrite = mStrToWrite & " %" & vbCr
        
       xlRow = xlRow + 1
       iRow = xlRow
    End If
    
    '-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    '- Greg Bogard CGA 07131999
    '- this will be an errror to test the ErrorHandler
    '-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    '- idiot = "idiot"
    '-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    'If bData = True Then
    '   For i = 0 To iRecCount
    
    '       If IsNull(aFreq(i, 1)) Then
    '           strData = "[NULL]"
    '       Else
    '           strData = (aFreq(i, 1))
    '       End If
         
    '      mStrToWrite = mStrToWrite & """" & strData & """"
    '       mStrToWrite = mStrToWrite & ","
    
    '       strData = (aFreq(i, 2))
    '       mStrToWrite = mStrToWrite & strData
    '       mStrToWrite = mStrToWrite & ","
    
    '      strData = (aFreq(i, 3))
    '       mStrToWrite = mStrToWrite & strData * 100 & "%"
    '       mStrToWrite = mStrToWrite & vbCr
            
    '       xlRow = xlRow + 1
    '       DoEvents
    '   Next
    'End If
    
    mStrToWrite = mStrToWrite & aFreq '& "Total,=sum(B" & iIndex + 1 & ":B" & xlRow & ")" & vbCr
    
Exit Function

ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: frmFrequency.fctOutPutFrequencies, Error Description: " & Err.Description
    End

End Function

Private Function fctGetUniqueFileName(pglngStudy_id As Long) As String
    
    Dim MyDate As String
    Dim strStudy_Id As String
    Dim InMyStr As Integer
    Dim strLength As Integer
    
    'MyDate = Now()
    'strLength = Len(MyDate)
    'InMyStr = 1
    
    'Do While InMyStr <> 0
    '    InMyStr = InStr(1, MyDate, "/", vbTextCompare)
    '    If InMyStr = 0 Then
    '        'do nothing
    '    Else
    '        MyDate = Left(MyDate, InMyStr - 1) & "-" & Right(MyDate, strLength - InMyStr)
    '    End If
    'Loop
    
    fctGetUniqueFileName = "FreqS" & pglngStudy_id & Format(Now, "-mm-dd-yy-hhmmssAm/Pm") & ".csv"
    
    'InMyStr = 1
    
    'Do While InMyStr <> 0
    '    InMyStr = InStr(1, MyDate, ":", vbTextCompare)
    '    If InMyStr = 0 Then
    '        'do nothing
    '    Else
    '        MyDate = Left(MyDate, InMyStr - 1) & "-" & Right(MyDate, strLength - InMyStr)
    '    End If
    'Loop
    
    'InMyStr = 1
    
    'Do While InMyStr <> 0
    '    InMyStr = InStr(1, MyDate, " ", vbTextCompare)
    '    If InMyStr = 0 Then
    '        'do nothing
    '    Else
    '        MyDate = Left(MyDate, InMyStr - 1) & "-" & Right(MyDate, strLength - InMyStr)
    '    End If
    'Loop
    'strStudy_Id = Trim(Str(pglngStudy_id))
    
    'fctGetUniqueFileName = Trim("Study_" & strStudy_Id & "_" & Now() & "_" & "Freqs.csv")
    'fctGetUniqueFileName = Trim("FreqS" & strStudy_Id & MyDate & ".csv")
    
End Function
