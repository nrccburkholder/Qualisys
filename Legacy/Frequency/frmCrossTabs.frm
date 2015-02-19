VERSION 5.00
Begin VB.Form frmCrossTabs 
   Caption         =   "Crosstabs"
   ClientHeight    =   6225
   ClientLeft      =   135
   ClientTop       =   420
   ClientWidth     =   8895
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6225
   ScaleWidth      =   8895
   Begin VB.Frame fraCrossTabResults 
      Caption         =   " CrossTab Results "
      Height          =   4920
      Left            =   240
      TabIndex        =   1
      Top             =   495
      Width           =   8450
      Begin VB.CommandButton cmdReset 
         Caption         =   "Reset"
         Height          =   315
         Left            =   3120
         TabIndex        =   9
         Top             =   4215
         Width           =   1455
      End
      Begin VB.ListBox lstRow 
         Height          =   1620
         Left            =   2800
         TabIndex        =   8
         Top             =   2250
         Width           =   2500
      End
      Begin VB.TextBox txtItem 
         Height          =   240
         Left            =   3075
         TabIndex        =   7
         Top             =   1065
         Visible         =   0   'False
         Width           =   1455
      End
      Begin VB.ListBox lstCol 
         Height          =   645
         Left            =   5500
         TabIndex        =   6
         Top             =   1050
         Width           =   2500
      End
      Begin VB.ListBox lstData 
         Enabled         =   0   'False
         Height          =   1620
         Left            =   5500
         TabIndex        =   5
         Top             =   2250
         Width           =   2500
      End
      Begin VB.CommandButton cmdResults 
         Caption         =   "View Crosstab Results..."
         Height          =   330
         Left            =   180
         TabIndex        =   4
         Top             =   4245
         Width           =   2175
      End
      Begin VB.ComboBox cboTableName 
         Height          =   315
         Left            =   180
         Style           =   2  'Dropdown List
         TabIndex        =   3
         Top             =   1050
         Width           =   2160
      End
      Begin VB.ListBox lstFieldName 
         DragIcon        =   "frmCrossTabs.frx":0000
         Height          =   2205
         Left            =   225
         Sorted          =   -1  'True
         TabIndex        =   2
         Top             =   1665
         Width           =   2160
      End
      Begin VB.Label Label8 
         AutoSize        =   -1  'True
         Caption         =   "Select row"
         Height          =   195
         Left            =   2875
         TabIndex        =   14
         Top             =   2010
         Width           =   750
      End
      Begin VB.Label Label7 
         AutoSize        =   -1  'True
         Caption         =   "Select data"
         Enabled         =   0   'False
         Height          =   195
         Left            =   5575
         TabIndex        =   13
         Top             =   2010
         Width           =   810
      End
      Begin VB.Label Label6 
         AutoSize        =   -1  'True
         Caption         =   "Select column"
         Height          =   195
         Left            =   5575
         TabIndex        =   12
         Top             =   810
         Width           =   1005
      End
      Begin VB.Label Label5 
         AutoSize        =   -1  'True
         Caption         =   "Select Fields"
         Height          =   195
         Left            =   180
         TabIndex        =   11
         Top             =   1440
         Width           =   900
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "Select Table"
         Height          =   195
         Left            =   180
         TabIndex        =   10
         Top             =   810
         Width           =   900
      End
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   360
      Left            =   6525
      TabIndex        =   0
      Top             =   5715
      Width           =   1215
   End
End
Attribute VB_Name = "frmCrossTabs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Type udtTableFields
    TableName As String
    Table_id As Long
    FieldName As String
    Key_Field As Long
    Field_id As Long
    Field_Type As String
End Type
Public strTableNm As String
Public strDateRecName As String
Public strTable_id As String
Dim TblArray() As String
Dim SelArray() As String
Public RowCtr As Integer
Public MovedItem As Boolean
Private mlngFileHandle As Long
Private mstrFileName As String
Private mStrToWrite As String
Private aFreq As String
Private xlRow As Long
Private intFieldCount As Integer
Private intRowCount As Integer



Public Sub GetAvailableFields(mvarTables As Variant, gIntStudy_id As Long)
 
    ' This procedure loads the table names into the Select Table drop down list box.
    ' 09-17-2002 SH
    ' Removed MTS objects for ImportFunctions and renamed it.
    ' mstImportFunctions -> ImportFunctionsPROC
    ' mts_Import_Wizard  -> Import_Wizard_PROC
    
    Dim i, X, iField, iTable_id As Long
    Dim strTableField As String
    Dim iRedim As Long
    Dim aField, aSelected As Variant
    'Dim objwiz As mtsImportFunctions.mts_Import_Wizard ' Removed 09-17-2002 SH
    Dim objwiz As ImportFunctionsPROC.Import_Wizard_PROC
    Dim bSelected As Boolean
    
    bSelected = False
    iRedim = 0
    iField = 0
    
    'Set objwiz = CreateObject("mtsImportFunctions.mts_import_wizard") ' Removed 09-17-2002 SH
    Set objwiz = CreateObject("ImportFunctionsPROC.Import_Wizard_PROC")
    aSelected = objwiz.mts_fnvnt_Get_Selected_Fields(gIntStudy_id)
    
    For i = 0 To UBound(mvarTables, 2)
        'If mvarTables(4, i) = "True" Then
            iTable_id = mvarTables(0, i)
            
            'Set objwiz = CreateObject("mtsImportFunctions.mts_import_wizard")
            aField = objwiz.mts_fnvnt_Get_FieldNames(iTable_id)
            
            iRedim = iRedim + (UBound(aField, 2) + 1)
            ReDim Preserve aTableFields(iRedim)
            
            For X = 0 To UBound(aField, 2)
                strTableField = Trim(mvarTables(1, i)) & "." & Trim(aField(0, X))
                'If Not IsEmpty(aSelected) Then
                '    bSelected = CheckSelectedFields(aSelected, iTable_id, aField(2, X))
                'Else
                '    bSelected = False
                'End If
                'If bSelected Then
                '    frmWizard.lstSelectedFields.AddItem strTableField
                'Else
                '    frmWizard.lstAvailableFields.AddItem strTableField
                'End If
            
                aTableFields(iField).TableName = Trim(mvarTables(1, i))
                aTableFields(iField).Table_id = iTable_id
                aTableFields(iField).FieldName = Trim(aField(0, X))
                aTableFields(iField).Key_Field = aField(1, X)
                aTableFields(iField).Field_id = aField(2, X)
                aTableFields(iField).Field_Type = IIf(IsNull(aField(3, X)), "NF", aField(3, X))
                iField = iField + 1
            Next X
        'End If
    Next i
    
    Set objwiz = Nothing
    
End Sub

Public Sub LoadTables(mvarTables As Variant)
 
    'This procedure loads the table names into the Select Table drop down list box.
    
    Dim i As Long
 
    'For i = 0 To UBound(mvarTables, 2) - 1
    '    If mvarTables(2, i) And mvarTables(0, i) <> -1 Then
    '        frmCrossTabs.cboTableName.AddItem mvarTables(1, i)
    '        frmCrossTabs.cboTableName.ItemData(frmCrossTabs.cboTableName.NewIndex) = mvarTables(0, i)
    '    End If
    '    Next
    'If mvarTables(0, i) <> -1 Then
    '    frmCrossTabs.cboTableName.ListIndex = 1
    'End If
    
    ' 12-14-98 gpb - CGA
    ' added the - 1
    For i = 0 To UBound(mvarTables, 2)
        If mvarTables(2, i) <> "" Then
            frmCrossTabs.cboTableName.AddItem mvarTables(1, i)
            frmCrossTabs.cboTableName.ItemData(frmCrossTabs.cboTableName.NewIndex) = mvarTables(0, i)
        End If
    Next
    
    'frmCrossTabs.cboTableName.ListIndex = 1

End Sub

Public Sub LoadFields(iTable_id As Long)
    
    'This procedure loads the selected table field names into the list box.
    
    Dim i As Integer
    
    frmCrossTabs.lstFieldName.Clear
    
    If MovedItem = False Then
        i = lstData.SelCount
        If i <> 0 Then
            lstData.RemoveItem i
        End If
    End If
    
    AddDataField iTable_id, 0

End Sub

Public Sub AddDataField(iTable_id As Long, CallerID As Integer)
    
    Dim i As Integer
    Dim c As Integer
    Dim wasFound As Boolean
    
    wasFound = False
    
    For i = 0 To UBound(aTableFields, 1)
       If aTableFields(i).Table_id = iTable_id Then
           If aTableFields(i).Key_Field < 0 And CallerID <> 0 Then
                ' need to see if it already exits in field
                c = 0
                If lstData.ListCount <> 0 Then
                    wasFound = False
                    Do While c <> lstData.ListCount
                        If lstData.List(c) = cboTableName.Text & "." & aTableFields(i).FieldName Then
                            ' we want to add to field
                            wasFound = True
                        Else
                            ' We don't want to add because it already exits
                        End If
                        c = c + 1
                    Loop
                Else
                    ' need to add
                    wasFound = False
                End If
                If wasFound = False Then
                    If lstData.ListCount = 0 Then
                        lstData.AddItem cboTableName.Text & "." & aTableFields(i).FieldName
                    End If
                    wasFound = True
                End If
            Else
                ' check to see if this item has already been selected in the row
                If CallerID = 0 Then
                    wasFound = False
                    ' Check in the rows
                    If lstRow.ListCount <> 0 And lstCol.ListCount <> 0 Then
                        c = 0
                        Do While c <> lstRow.ListCount
                            If lstRow.List(c) = cboTableName.Text & "." & aTableFields(i).FieldName Then
                                wasFound = True
                            End If
                            c = c + 1
                        Loop
                        c = 0
                        Do While c <> lstCol.ListCount
                            If lstCol.List(c) = cboTableName.Text & "." & aTableFields(i).FieldName Then
                                wasFound = True
                            End If
                            c = c + 1
                        Loop
                    Else
                        lstFieldName.AddItem aTableFields(i).FieldName
                        wasFound = True
                    End If
                    If wasFound = False Then
                        lstFieldName.AddItem aTableFields(i).FieldName
                    End If
                End If
            End If
        End If
    Next i

End Sub

Public Function CheckSelectedFields(aSelected As Variant, ByVal intTable_id As Long, ByVal intFields_id As Long) As Boolean

    Dim X As Long
    
    For X = 0 To UBound(aSelected, 2)
        If intTable_id = aSelected(0, X) And intFields_id = aSelected(1, X) Then
            CheckSelectedFields = True
            Exit For
        Else
            CheckSelectedFields = False
        End If
    Next X

End Function

Private Sub cboTableName_Click()

    '----------------------------------------------------------------------------
    ' Purpose:  Load the list of fields into the lstFieldName list box for  the
    '           table selected by the userin the cboTablename combo box.
    '----------------------------------------------------------------------------

    ' Get the Table id for the selected Table and then load the fields for that
    ' table
    If cboTableName.Text <> "" Then
        iTable_id = cboTableName.ItemData(cboTableName.ListIndex)
        LoadFields (iTable_id)
    End If

End Sub

Private Sub cmdClose_Click()
    
    cmdReset_Click
    frmMain.Show
    Unload Me

End Sub

Private Sub cmdReset_Click()

    ' Clear out existing info.
    cboTableName.Clear
    lstFieldName.Clear
    txtItem.Text = ""
    lstRow.Clear
    lstCol.Clear
    lstData.Clear
     
    Call LoadTables(mvarTables)
    ReDim RTblArray(0)
    ReDim SelArray(0)
    RowCtr = 0

End Sub

Public Function ResetMe()
    
    Call cmdReset_Click

End Function

Private Sub cmdResults_Click()

    If frmCrossTabs.lstCol.ListCount = 0 And frmCrossTabs.lstRow.ListCount = 0 Then
        MsgBox "Please select at least one column or row."
        Exit Sub
    Else
        Me.MousePointer = vbHourglass
        Call LoadCubeFields
        Call NewCube
    End If

    Me.MousePointer = vbHourglass
    Call LoadTables(mvarTables)
     
    'frmDCube.Show
    Call CreatePivotTable
    'Me.Hide

End Sub

Public Sub LoadCubeFields()
    
    Dim i As Long
    Dim iFields As Long
    Dim iField As Long

    ' Count the number of items in the cube and redim the array
    iFields = frmCrossTabs.lstCol.ListCount + frmCrossTabs.lstRow.ListCount + frmCrossTabs.lstData.ListCount
    ReDim aFields(iFields - 1)
    
    frmCrossTabs.lstFieldName.Clear
    iField = 0
    Me.MousePointer = vbHourglass
    
    For i = 0 To frmCrossTabs.lstCol.ListCount - 1
        frmCrossTabs.lstFieldName.AddItem frmCrossTabs.lstCol.List(i)
        aFields(iField).Name = frmCrossTabs.lstCol.List(i)
        aFields(iField).Caption = frmCrossTabs.lstCol.List(i)
        aFields(iField).Orient = 1
        aFields(iField).GFCaption = "Sum of " & aFields(iField).Name
        aFields(iField).GFType = 1
        iField = iField + 1
    Next
    
    For i = 0 To frmCrossTabs.lstRow.ListCount - 1
        frmCrossTabs.lstFieldName.AddItem frmCrossTabs.lstRow.List(i)
        aFields(iField).Name = frmCrossTabs.lstRow.List(i)
        aFields(iField).Caption = frmCrossTabs.lstRow.List(i)
        aFields(iField).Orient = 2
        aFields(iField).GFCaption = "Sum of " & aFields(iField).Name
        aFields(iField).GFType = 1
        iField = iField + 1
    Next
    
    For i = 0 To frmCrossTabs.lstData.ListCount - 1
        frmCrossTabs.lstFieldName.AddItem frmCrossTabs.lstData.List(i)
        aFields(iField).Name = frmCrossTabs.lstData.List(i)
        aFields(iField).Caption = frmCrossTabs.lstData.List(i)
        aFields(iField).Orient = 3
        iField = iField + 1
    Next
    
    frmCrossTabs.lstFieldName.ListIndex = 0
    Me.MousePointer = vbDefault

End Sub

Public Function GenerateSQL(strTableName As String) As String

    '-----------------------------------------------------
    ' Purpose:  Based on the control settings on fmrMain
    '           build the SQL string to retrieve the
    '           frequency Data.
    '-----------------------------------------------------
    
    Dim sSql As String
    Dim lngOptionSelected  As Long
    Dim strSQLNewRecDate As String
    Dim rs As New ADODB.Recordset
    Dim lngKey As Long
    Dim ssobj As Object
    Dim lLenName As Long
    Dim strStudyNum As String
    Dim lngPeriodPos As Long
    Dim lngTable_id As Long
    Dim vKey As Variant
    Dim strSql As String, strSQL1 As String, strSQL2 As String
    Dim i As Integer
    Dim strStudy As String, strTable As String
    Dim strKeyField As String

    lngTable_id = frmCrossTabs.cboTableName.ItemData(frmCrossTabs.cboTableName.ListIndex)
    strTable_id = Trim(Str(lngTable_id))

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
            
            strSql = "SELECT DISTINCT "
            
            For i = 0 To UBound(aFields)
                strStudy = aFields(i).Name
                strStudy = Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                If i = 0 Then
                    strTable = Left(strStudy, InStr(1, strStudy, ".", vbTextCompare) - 1)
                End If
                strStudy = Left(strStudy, InStr(1, strStudy, ".", vbTextCompare) - 1) & Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                strSql = strSql & strStudy
                If i - UBound(aFields) <> 0 Then
                    strSql = strSql & ", "
                Else
                    strSql = strSql & " "
                End If
            Next
            
            strSql = strSql & "FROM "
            
            strStudy = TblArray(0)
            strStudy = Left(strStudy, InStr(1, strStudy, ".", vbTextCompare) - 1)
            strStudy = strStudy & ".big_view"
            strSql = strSql & strStudy
            
            strSql = strSql & " WHERE "
    
            strSql = strSql & strTable & frmCrossTabs.strDateRecName
            
            strSql = strSql & " BETWEEN '" & frmMain!mebStartDate & "' AND '" & _
                     frmMain!mebEndDate & "' "
                     
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
            ' must get name and id of the table
            'strSql = "SELECT DISTINCT "
            strSql = "SELECT "


            For i = 0 To UBound(aFields)
                strStudy = aFields(i).Name
                strStudy = Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                If i = 0 Then
                    strTable = Left(strStudy, InStr(1, strStudy, ".", vbTextCompare) - 1)
                End If
                strStudy = Left(strStudy, InStr(1, strStudy, ".", vbTextCompare) - 1) & Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                strSql = strSql & strStudy
                If i - UBound(aFields) <> 0 Then
                    strSql = strSql & ", "
                Else
                    strSql = strSql & " "
                End If
            Next

            strSql = strSql & "FROM "

            strStudy = Left(strTableName, InStr(1, strTableName, ".", vbTextCompare) - 1)
            strTable = Right(strTableName, Len(strTableName) - InStr(1, strTableName, ".", vbTextCompare))

            strSQL1 = "DECLARE @SQL varchar(8000) " & _
                     "IF EXISTS (SELECT top 1 * FROM Metadata_view Where study_Id=" & Right(strStudyNum, Len(strStudyNum) - 1) & " and strtable_nm='Encounter')" & _
                     " BEGIN " & _
                     " SET @SQL='" & _
                     strSql & strStudy & ".big_view t, selectedsample ss" & _
                      " WHERE t.populationpop_id=ss.pop_id " & _
                      "     AND t.encounterEnc_id=ss.enc_id" & _
                      "     AND sampleset_id IN (" & gstrSampleSets & ")" & _
                      "     AND strunitselecttype=''D''' " & _
                      " END "
            strSQL2 = " ELSE " & _
                     " BEGIN " & _
                     " SET @SQL='" & _
                     strSql & strStudy & ".big_view t, selectedsample ss" & _
                      " WHERE t.populationpop_id=ss.pop_id " & _
                      "     AND sampleset_id IN (" & gstrSampleSets & ")" & _
                      "     AND strunitselecttype=''D''' " & _
                      " END " & _
                      " exec(@sql) "
            strSql = strSQL1 & strSQL2


            
'            strSql = strSql & strStudy & ".big_view t," & _
'                     "(SELECT DISTINCT u.KeyValue " & _
'                     " FROM " & strStudyNum & ".UniKeys u, " & _
'                     "      dbo.samplepop s " & _
'                     " WHERE u.sampleset_id = s.sampleset_id " & _
'                     "       AND u.pop_id = s.pop_id " & _
'                     "       AND u.table_id = " & vKey(1, 0) & " " & _
'                     "       AND u.sampleset_id IN (" & gstrSampleSets & ") " & _
'                     ") us " & _
'                     "WHERE us.KeyValue = t." & strTable & vKey(0, 0)
                     

        Case RESPONDENTS
            lngPeriodPos = InStr(1, strTableName, ".")
            lLenName = Len(strTableName)
            strTableNm = Right(strTableName, lLenName - lngPeriodPos)
            strStudyNum = Left(strTableName, lngPeriodPos - 1)
            
            vKey = mts_fnvnt_Get_KeyField(glngStudy_id, strTableNm)
            
            strSql = "SELECT strTable_nm, Table_id " & _
                     "FROM metaTable " & _
                     "WHERE strTable_nm = '" & strTableNm & " ' " & _
                     "      AND study_id = " & glngStudy_id
            
            ' Option NEW chosen
            strSql = "SELECT DISTINCT "
        
            For i = 0 To UBound(aFields)
                strStudy = aFields(i).Name
                strStudy = Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                If i = 0 Then
                    strTable = Left(strStudy, InStr(1, strStudy, ".", vbTextCompare) - 1)
                End If
                strStudy = Left(strStudy, InStr(1, strStudy, ".", vbTextCompare) - 1) & Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                strSql = strSql & strStudy
                If i - UBound(aFields) <> 0 Then
                    strSql = strSql & ", "
                Else
                    strSql = strSql & " "
                End If
            Next
        
            strSql = strSql & "FROM "
            
            strStudy = Left(strTableName, InStr(1, strTableName, ".", vbTextCompare) - 1)
            strTable = Right(strTableName, Len(strTableName) - InStr(1, strTableName, ".", vbTextCompare))
               
            strSql = strSql & strStudy & ".big_view t, "
            
            If frmMain!optTypeOfRespondents(0).Value = True Then
                ' 8/31/1999 DV -CGA
                ' Performance issue Improvement.
                strSql = strSql & _
                         "(SELECT DISTINCT u.Keyvalue " & _
                         " FROM " & strStudyNum & ".unikeys u, " & _
                         "      samplepop s, questionform q " & _
                         " WHERE q.datReturned IS NOT NULL " & _
                         "       AND Q.cutoff_id IS NULL " & _
                         "       AND q.samplepop_id = s.samplepop_id " & _
                         "       AND u.Table_id = " & vKey(1, 0) & " " & _
                         "       AND u.pop_id = s.pop_id) usq " & _
                         "WHERE t." & strTable & vKey(0, 0) & " = usq.KeyValue "

            ' Option ALL chosen
            Else
                ' 8/31/1999 DV - CGA
                ' Performance issue Improvement.
                strSql = strSql & _
                         "(SELECT DISTINCT u.Keyvalue " & _
                         " FROM " & strStudyNum & ".unikeys u, " & _
                         "      samplepop s, questionform q " & _
                         " WHERE q.datReturned IS NOT NULL " & _
                         "       AND q.samplepop_id = s.samplepop_id " & _
                         "       AND u.Table_id = " & vKey(1, 0) & " " & _
                         "       AND u.pop_id = s.pop_id) usq " & _
                         "WHERE t." & strTable & vKey(0, 0) & " = usq.KeyValue "
            End If
    
        Case RAW_DATA
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
                    
            strSql = "SELECT DISTINCT "
        
            For i = 0 To UBound(aFields)
                strStudy = aFields(i).Name
                strStudy = Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                strTable = Left(strStudy, InStr(1, strStudy, ".", vbTextCompare) - 1)
                strTable = Left(strStudy, InStr(1, strStudy, "_", vbTextCompare) - 1)
                strTable = strTable & Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                strSql = strSql & strTable & " as " & Left(strStudy, InStr(1, strStudy, "_", vbTextCompare) - 1) & "_LOAD" & Right(strStudy, Len(strStudy) - InStr(1, strStudy, ".", vbTextCompare))
                If i - UBound(aFields) <> 0 Then
                    strSql = strSql & ", "
                Else
                    strSql = strSql & " "
                End If
            Next
            
            strStudy = Left(aFields(0).Name, InStr(1, aFields(0).Name, ".", vbTextCompare) - 1)
            strSql = strSql & "FROM " & strStudy & ".BIG_VIEW_LOAD"
        
            'strStudy = Left(strTableName, InStr(1, strTableName, ".", vbTextCompare) - 1)
            'strTable = Right(strTableName, Len(strTableName) - InStr(1, strTableName, ".", vbTextCompare))
            'strSql = strSql & strStudy & ".big_view"
    End Select
    
    Debug.Print strSql
    GenerateSQL = strSql
    
    ' kill arrays
    ReDim TblArray(0)
    ReDim SelArray(0)
    RowCtr = 0
    
End Function

Public Sub NewCube()
    
'    Dim i As Long
'    Dim strTableName As String
'    Dim oFld As Variant
'    Dim strConnectString As String
'    Dim strSql As String
'
'    Dim cn As ADODB.Connection
'    Dim rs As ADODB.Recordset
'    Me.MousePointer = vbHourglass
'   strTableName = frmCrossTabs.strTable_id 'Left$(frmCrossTabs.cboTableName.List(frmCrossTabs.cboTableName.ListIndex), 25)
'   strTableName = Trim(strTableName)
'    strSql = GetCrossTabSQL(strTableName)
'
'    strSql = "Select Distinct "
'
'    For i = 0 To UBound(aFields)
'        strSql = strSql & aFields(i).Name
'        If i - UBound(aFields) <> 0 Then
'            strSql = strSql & ", "
'        Else
'            strSql = strSql & " "
'        End If
'    Next
'
'    strSql = strSql & "FROM " & strTableName & " " & _
'                     "WHERE " & strDateRecName & _
'                     " BETWEEN '" & frmMain!mebStartDate & "' AND '" _
'                     & frmMain!mebEndDate & "' "
'
'    strConnectString = fctMtsRetrieveDSN_INFO()
'    Set cn = New ADODB.Connection
'    Set rs = New ADODB.Recordset
'    cn.Open strConnectString
'    rs.ActiveConnection = cn
'    rs.Open strSql
'    'i = UBound(aFields) - 1
'    Dim DCubeArray() As Variant
'
'    Do While Not rs.EOF
'        For i = 0 To UBound(aFields) - 1
'            ReDim Preserve DCubeArray(i)
'            DCubeArray(i) = rs.Fields(i).Value
'        Next
'        Call frmDCube.DCube1.AddRowEx(DCubeArray)
'        rs.MoveNext
'        i = 0
'    Loop
'
'    'Dim oField As DynamiCubeLibCtl.Field ' tell dcube we're in unbound mode
''    frmDCube.DCube1.DCConnectType = DCCT_UNBOUND ' add all rows to DynamiCube
''    For i = 0 To UBound(aFields)
''        Set oFld = frmDCube.DCube1.Fields.Add(aFields(i).Name, aFields(i).Caption, aFields(i).Orient)
''        If oFld.Orientation = 3 Then
''            '- if not a data field
''            oFld.AggregateFunc = DCCount
''            oFld.NumberFormat = "0"
''        Else
''            oFld.GroupFooterType = aFields(i).GFType
''            oFld.GroupFooterCaption = aFields(i).GFCaption
''        End If
''    Next
''   frmDCube.DCube1.RefreshData
'    frmDCube.Show
'    Me.MousePointer = vbDefault
'    'Set oField = DCube1.Fields.Add("stor_id", "Store", DCRow) ' add all columns
'    'Set oField = DCube1.Fields.Add("title_id", "Title", DCColumn)
'    ' add all data fieldsSet
'    'oField = DCube1.Fields.Add("qty", "Quantity", DCData)
'    'frmDCube.DCube1.RefreshData
'    '- Create a new Cube
'    'With frmDCube.DCube1
'    '    .DCConnectType = DCCT_RDO
'    '    '- The dsn connection must be set up with the MS drivers NOT Intersolve!!!
'    '    strConnectString = fctMtsRetrieveDSN_INFO()
'    '    .DCConnect = strConnectString
'    '    .DCRecordSource = strSql
'
'    '    For i = 0 To UBound(aFields)
'    '        Set oFld = .Fields.Add(aFields(i).Name, aFields(i).Caption, aFields(i).Orient)
'    '        If oFld.Orientation = 3 Then
'    '            '- if not a data field
'    '            oFld.AggregateFunc = DCCount
'    '            oFld.NumberFormat = "0"
'    '        Else
'    '            oFld.GroupFooterType = aFields(i).GFType
'    '            oFld.GroupFooterCaption = aFields(i).GFCaption
'    '        End If
'    '    Next
'
'    'End With
'frmDCube.Show

End Sub

Private Sub Form_Load()
    
    Dim X As Long
    'Dim objwiz As mtsImportFunctions.mts_Import_Wizard ' Removed 09-17-2002 SH
    Dim objwiz As ImportFunctionsPROC.Import_Wizard_PROC
    Dim i As Long
    Dim oFld As Variant
    
    Me.Show

    For X = 0 To UBound(mvarTables, 2)
        If frmMain!optPopulation(RAW_DATA).Value = False Then
            ' not RAW_DATA
             mvarTables(1, X) = "S" & glngStudy_id & "." & mvarTables(1, X)
        Else
             mvarTables(1, X) = "S" & glngStudy_id & "." & mvarTables(1, X) & _
                                "_LOAD"
        End If
    Next X

    LoadTables (mvarTables)

    Call GetAvailableFields(mvarTables, glngStudy_id)

    Me.Show
    
    cboTableName.SetFocus
    
End Sub



Private Sub lstCol_DragDrop(Source As Control, X As Single, y As Single)
    HandleDrop lstCol, Source

End Sub



Private Sub lstFieldName_MouseDown(Button As Integer, Shift As Integer, X As Single, y As Single)
    StartDrag lstFieldName, X, y
End Sub



Public Sub AddItem(Source As Control)
    
    ' Need to add code to keep track of selected item and selected table
    
    Dim newEntry As Boolean
    Dim numTbl As Integer
    
    numTbl = RowCtr
    newEntry = True
    
    Do While numTbl <> 0
        If TblArray(numTbl - 1) = cboTableName.Text Then
            newEntry = False
        Else
            
        End If
        numTbl = numTbl - 1
    Loop
    
    If newEntry = True Then
        ReDim Preserve TblArray(RowCtr)
        TblArray(RowCtr) = cboTableName.Text
        RowCtr = RowCtr + 1
        MovedItem = True
        newEntry = False
    End If

End Sub

Private Sub lstRow_DragDrop(Source As Control, X As Single, y As Single)
    HandleDrop lstRow, Source
End Sub

Public Function fctMtsRetrieveDSN_INFO() As String

    Dim o As QualiSysFunctions.Library
    Dim strDSN_Info As String
    
    Set o = CreateObject("QualiSysFunctions.Library")
    strDSN_Info = o.GetDBString(True)
    
    fctMtsRetrieveDSN_INFO = strDSN_Info

    Set o = Nothing
    
End Function

Public Function GetCrossTabSQL(strTableName As String) As String
    
    '-----------------------------------------------------
    ' Purpose:  Based on the control settings on fmrMain
    '           build the SQL string to retrieve the
    '           frequency Data.
    '-----------------------------------------------------
    
    Dim strSql As String
    Dim lngOptionSelected  As Long
    Dim strSQLNewRecDate As String
    Dim rs As New ADODB.Recordset
    Dim lngKey As Long
    Dim ssobj As Object
    Dim lLenName As Long
    Dim strStudyNum As String
    Dim lngPeriodPos As Long
    Dim lngTable_id As Long
    Dim vKey As Variant

    lngTable_id = frmCrossTabs.cboTableName.ItemData(frmCrossTabs.cboTableName.ListIndex)
    strTable_id = Trim(Str(lngTable_id))

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
            
            strSql = "SELECT DISTINCT * " & _
                     "FROM " & strTableName & " " & _
                     "WHERE " & strDateRecName & " " & _
                     "BETWEEN '" & frmMain!mebStartDate & "' AND '" & _
                     frmMain!mebEndDate & "' "
    
        Case SAMPLE_SET
            lngPeriodPos = InStr(1, strTableName, ".")
            lLenName = Len(strTableName)
            strTableNm = Right(strTableName, lLenName - lngPeriodPos)
            strStudyNum = Left(strTableName, lngPeriodPos - 1)
            vKey = mts_fnvnt_Get_KeyField(glngStudy_id, strTableNm)

            ' 8/31/99 DV - CGA
            ' Dead assignment, reset below.
            'strSQL = "SELECT strTable_nm, Table_id " & _
            '         "From metaTable " & _
            '         "WHERE strTable_nm = '" & strTableNm & " ' " & _
            '         "And study_id = " & glngStudy_id
    
            ' must get name and id of the table
            strSql = "SELECT t.* " & _
                     "FROM " & strTableName & " t, " & _
                     "(SELECT distinct u.KeyValue " & _
                     " FROM " & strStudyNum & ".UniKeys u, " & _
                     "      dbo.samplepop s " & _
                     " WHERE u.sampleset_id = s.sampleset_id " & _
                     "       AND u.pop_id = s.pop_id " & _
                     "       AND u.table_id = " & vKey(1, 0) & " " & _
                     "       AND u.sampleset_id IN (" & gstrSampleSets & ") " & _
                     ") us " & _
                     "WHERE us.KeyValue = t." & vKey(0, 0)

            'strSQL = "SELECT * " & _
            '        "FROM " & strTableName & " t " & _
            '        "WHERE EXISTS " & _
            '        "(SELECT * " & _
            '        "FROM " & strStudyNum & ".unikeys u, samplepop s " & _
            '        "WHERE u.sampleset_id   IN  (" & gstrSampleSets & ") " & _
            '            "AND  t." & vKey(0, 0) & " = u.KeyValue " & _
            '            "AND u.table_id = " & vKey(1, 0) & " " & _
            '            "AND u.sampleset_id = s.sampleset_id " & _
            '            "AND u.pop_id = s.pop_id)"
    
        Case RESPONDENTS
            lngPeriodPos = InStr(1, strTableName, ".")
            lLenName = Len(strTableName)
            strTableNm = Right(strTableName, lLenName - lngPeriodPos)
            strStudyNum = Left(strTableName, lngPeriodPos - 1)
        
            vKey = mts_fnvnt_Get_KeyField(glngStudy_id, strTableNm)
        
            strSql = "SELECT strTable_nm, Table_id " & _
                     "FROM metaTable " & _
                     "WHERE strTable_nm = '" & strTableNm & " ' " & _
                     "      AND study_id = " & glngStudy_id

            ' Option NEW chosen
            If frmMain!optTypeOfRespondents(0).Value = True Then
                ' 8/31/1999 DV - CGA
                ' Performance issue Improvement.
                strSql = "SELECT * " & _
                         "FROM " & strTableName & " t , " & _
                         "(SELECT DISTINCT u.Keyvalue " & _
                         " FROM " & strStudyNum & ".unikeys u, " & _
                         "      samplepop s, questionform q " & _
                         " WHERE q.datReturned IS NOT NULL " & _
                         "       AND Q.cutoff_id IS NULL " & _
                         "       AND q.samplepop_id = s.samplepop_id " & _
                         "       AND u.Table_id = " & vKey(1, 0) & " " & _
                         "       AND u.pop_id = s.pop_id) usq " & _
                         "WHERE t." & vKey(0, 0) & " = usq.KeyValue "

                'strSQL = _
                '    "SELECT * " & _
                '    "FROM " & strTableName & " t " & _
                '    "WHERE EXISTS " & _
                '        "(SELECT * FROM " & strStudyNum & ".unikeys u, " & _
                '                 "samplepop s, questionform q " & _
                '        "WHERE q.datReturned IS NOT NULL " & _
                '            "AND Q.cutoff_id IS NULL " & _
                '            "AND q.samplepop_id = s.samplepop_id " & _
                '            "AND t." & vKey(0, 0) & " = u.KeyValue " & _
                '            "AND u.Table_id = " & vKey(1, 0) & " " & _
                '            "AND u.pop_id = s.pop_id)"
            ' Option ALL chosen
            Else
                ' 8/31/1999 DV - CGA
                ' Performance issue Improvement.
                strSql = "SELECT * " & _
                         "FROM " & strTableName & " t , " & _
                         "(SELECT DISTINCT u.Keyvalue " & _
                         " FROM " & strStudyNum & ".unikeys u, " & _
                         "      samplepop s, questionform q " & _
                         " WHERE q.datReturned IS NOT NULL " & _
                         "       AND q.samplepop_id = s.samplepop_id " & _
                         "       AND u.Table_id = " & vKey(1, 0) & " " & _
                         "       AND u.pop_id = s.pop_id) usq " & _
                         "WHERE t." & vKey(0, 0) & " = usq.KeyValue "
            
                'strSQL = _
                '    "SELECT * " & _
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
        
            strSql = "SELECT * " & _
                     "FROM " & strTableName
    End Select
    
    GetCrossTabSQL = strSql
     
End Function

Private Sub lstRow_MouseDown(Button As Integer, Shift As Integer, X As Single, y As Single)
    StartDrag lstRow, X, y
End Sub


Private Sub lstCol_MouseDown(Button As Integer, Shift As Integer, X As Single, y As Single)
    StartDrag lstCol, X, y
End Sub

Sub StartDrag(Sender As ListBox, X As Single, y As Single)
    If Sender.ListIndex = -1 Then Exit Sub
    txtItem.Text = Sender.Text
    txtItem.Top = y + Sender.Top
    txtItem.Left = X + Sender.Left
    txtItem.Drag
End Sub

Sub HandleDrop(Receiver As ListBox, Source As Control)
    Dim Sender As ListBox
    Dim s As String
    If lstCol.ListIndex > -1 Then
      Set Sender = lstCol
      s = txtItem.Text
    ElseIf lstRow.ListIndex > -1 Then
      Set Sender = lstRow
      s = txtItem.Text
    Else
        Set Sender = lstFieldName
        s = cboTableName.Text & "." & txtItem.Text
    End If
    
    Receiver.AddItem s
    Sender.RemoveItem Sender.ListIndex
    AddItem Source
    AddDataField iTable_id, 1
End Sub

Private Sub FetchData()
    
    Dim i As Long
    Dim strTableName As String
    Dim oFld As Variant
    Dim strConnectString As String
    Dim strSql As String
    Dim cn As ADODB.Connection
    Dim rs As ADODB.Recordset
    
    ' Open a text file for output
    ' Give it the same file name but a 'csv' extension
'    mstrFileName = fctGetUniqueFileName(glngStudy_id)

'    If fctOpenAsciiFile(mstrFileName) Then
'        'good
'    Else
'        'bad
'    End If
    
    Me.MousePointer = vbHourglass
'
'    strTableName = Left$(frmCrossTabs.cboTableName.List(frmCrossTabs.cboTableName.ListIndex), 25)
'    strTableName = Trim(strTableName)
'    strSql = frmCrossTabs.GenerateSQL(strTableName)
'
'    strConnectString = frmCrossTabs.fctMtsRetrieveDSN_INFO()
'
'    Set cn = New ADODB.Connection
'    Set rs = New ADODB.Recordset
'    cn.CommandTimeout = 0
'    cn.ConnectionTimeout = 0
'    cn.Open strConnectString
'    rs.ActiveConnection = cn
'    rs.Open strSql
'
'    Dim sMyStr As String
'    intRowCount = 0
'
'    aFreq = "" 'Blank it
'    If Not (rs.BOF And rs.EOF) Then
'        intFieldCount = rs.Fields.Count - 1
'        rs.MoveFirst
'        For i = 0 To intFieldCount
'            If i = intFieldCount Then
'                aFreq = aFreq & rs.Fields(i).Name & vbCr
'            Else
'                aFreq = aFreq & rs.Fields(i).Name & ","
'            End If
'            DoEvents
'        Next i
'    End If
'
'    Do While Not rs.EOF
'
'        For i = 0 To intFieldCount
'            If i = intFieldCount Then
'                aFreq = aFreq & IIf(IsNull(rs(i)), "[NULL]", rs(i)) & vbCr
'            Else
'                aFreq = aFreq & IIf(IsNull(rs(i)), "[NULL]", rs(i)) & ","
'            End If
'            DoEvents
'        Next i
'        intRowCount = intRowCount + 1
'        rs.MoveNext
'    Loop
'
'
'    'frmDCube.Show
'    rs.Close
'    xlRow = 1
'    Call subWriteAscii(aFreq)
'
'    ' close the 'csv' file
    ' launch excel with the file name as parameter so it opens
'    If fctCloseAsciiFile(mstrFileName) Then
'        'good
'    Else
'        'bad
'    End If
    Call CreatePivotTable
    Me.MousePointer = vbDefault

End Sub

Function CreatePivotTable()
    Dim xls As Object
    Dim strTableName As String
    Dim strConnectString As String
    Dim strSql As String
    Dim cn As ADODB.Connection
    Dim rs As ADODB.Recordset
    ' *** Added 09-18-2002 SH
    Dim strUserPath As String
    
    mstrFileName = fctGetUniqueFileName(glngStudy_id)
   
    Me.MousePointer = vbHourglass
    strTableName = Left$(frmCrossTabs.cboTableName.List(frmCrossTabs.cboTableName.ListIndex), 25)
    strTableName = Trim(strTableName)
    strSql = frmCrossTabs.GenerateSQL(strTableName)
    
    strUserPath = "c:\Users\" & Trim(gstrLoginName) & "\Documents\"

    Beep
    Beep
    
    Set xls = Nothing
    Set xls = CreateObject("excel.sheet")
    xls.Application.ActiveWorkbook.SaveAs strUserPath & mstrFileName, 1
    Set xls = Nothing
    Set xls = GetObject(strUserPath & mstrFileName)
    xls.Application.Windows(mstrFileName).Activate

    'let's try to format that sheet a littel better...
    strConnectString = frmCrossTabs.fctMtsRetrieveDSN_INFO()

    Dim ir As Integer
    Dim cr As Integer
    Dim pr As Integer
    
    ir = 1
    pr = 1
    cr = 1
    
    xls.Application.Range("a1").Select
    xls.Application.Visible = True

    On Error Resume Next
    
    'strConnectString = "ODBC;" & strConnectString
    strConnectString = Replace(strConnectString, "driver={SQL Server};", "")
    strConnectString = "OLEDB;Provider=SQLOLEDB.1;" & strConnectString
    
    With xls.Application.ActiveWorkbook.PivotCaches.Add(SourceType:=xlExternal)
        .Connection = strConnectString
        .CommandType = xlCmdSql
        .CommandText = strSql
        .MaintainConnection = False
        .CreatePivotTable TableDestination:="", TableName:="PivotTable1" ', DefaultVersion:=xlPivotTableVersion10
    End With
    xls.Application.ActiveSheet.Cells(3, 1).Select
   
  
    Dim strRowFields As String
    Dim strColFields As String
    Dim strDataFields As String
    Dim i As Integer
    Dim strName As String
    Dim lngPeriodPos As Integer
    Dim intRowCounter As Integer
    Dim intColCounter As Integer
    
    intRowCounter = 0
    intColCounter = 0
    strColFields = ""
  
    For i = 0 To UBound(aFields)
        lngPeriodPos = InStr(1, aFields(i).Name, ".")
        strName = Right(aFields(i).Name, Len(aFields(i).Name) - lngPeriodPos)
        strName = Replace(strName, ".", "")
        If aFields(i).Orient = 1 Then
            intColCounter = intColCounter + 1
            With xls.Application.ActiveSheet.PivotTables("PivotTable1").PivotFields(strName)
                .Orientation = xlColumnField
                .Position = intColCounter
            End With
        ElseIf aFields(i).Orient = 2 Then
            intRowCounter = intRowCounter + 1
            With xls.Application.ActiveSheet.PivotTables("PivotTable1").PivotFields(strName)
                .Orientation = xlRowField
                .Position = intRowCounter
            End With
        Else:
            With xls.Application.ActiveSheet.PivotTables("PivotTable1").PivotFields(strName)
                .Orientation = xlDataField
                .Position = 1
                .Function = xlCount
                .Caption = "Count"
            End With
        End If
    Next
    
    Dim tmpColumn As excel.PivotField

    For Each tmpColumn In xls.Application.ActiveSheet.PivotTables("PivotTable1").PivotFields
        tmpColumn.Subtotals = Array(False, False, False, False, False, False, False, False, False, False, _
        False, False)
    Next
   
    xls.Application.Cells.Select
    xls.Application.Cells.EntireColumn.AutoFit
    xls.Application.ActiveSheet.Cells(3, 1).Select
    xls.Application.DisplayAlerts = False
    
    xls.Application.ActiveWorkbook.Save
    'xls.Application.ActiveWorkbook.SaveAs strUserPath & mstrFileName, 1
    xls.Application.Visible = True
    xls.Application.DisplayAlerts = True

   
    Screen.MousePointer = vbDefault
    Set xls = Nothing
    
    Beep
    Beep
    Me.MousePointer = vbDefault
End Function


Private Function fctGetUniqueFileName(pglngStudy_id As Long) As String
    
    Dim MyDate As String
    Dim strStudy_Id As String
    Dim InMyStr As Integer
    Dim strLength As Integer

    
    fctGetUniqueFileName = "FreqS" & pglngStudy_id & Format(Now, "-mm-dd-yy-hhmmssAm/Pm") & ".xls"
       
End Function

