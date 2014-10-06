VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form frmMain 
   Caption         =   "Survey Personalization"
   ClientHeight    =   4500
   ClientLeft      =   3285
   ClientTop       =   2040
   ClientWidth     =   5145
   LinkTopic       =   "Form1"
   ScaleHeight     =   4500
   ScaleWidth      =   5145
   Begin VB.CommandButton cmdPhysician 
      Caption         =   "PA Name"
      Height          =   495
      Left            =   2760
      TabIndex        =   7
      Top             =   3960
      Width           =   1095
   End
   Begin VB.TextBox lblAssignedValue 
      Alignment       =   2  'Center
      BackColor       =   &H80000004&
      BorderStyle     =   0  'None
      Height          =   195
      Left            =   1680
      Locked          =   -1  'True
      TabIndex        =   6
      TabStop         =   0   'False
      Text            =   "Assigned Field / Literal"
      Top             =   120
      Width           =   1215
   End
   Begin VB.TextBox lblTagDescription 
      Alignment       =   2  'Center
      BackColor       =   &H80000004&
      BorderStyle     =   0  'None
      Height          =   195
      Left            =   120
      Locked          =   -1  'True
      TabIndex        =   5
      TabStop         =   0   'False
      Text            =   "Tag Description"
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Ok"
      Height          =   495
      Left            =   360
      TabIndex        =   4
      Top             =   3960
      Width           =   1095
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   1560
      TabIndex        =   3
      Top             =   3960
      Width           =   1095
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "&Apply"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   495
      Left            =   3960
      TabIndex        =   2
      Top             =   3960
      Width           =   1095
   End
   Begin VB.ComboBox cmbAvailableFields 
      Height          =   315
      Left            =   2520
      Sorted          =   -1  'True
      TabIndex        =   1
      Top             =   840
      Width           =   1215
   End
   Begin MSFlexGridLib.MSFlexGrid grdTagFields 
      Height          =   3495
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   4935
      _ExtentX        =   8705
      _ExtentY        =   6165
      _Version        =   393216
      Rows            =   1
      Cols            =   4
      FixedRows       =   0
      FixedCols       =   0
      FocusRect       =   2
      GridLines       =   3
      GridLinesFixed  =   0
      ScrollBars      =   2
      SelectionMode   =   1
      MergeCells      =   2
      AllowUserResizing=   1
      MouseIcon       =   "frmMain.frx":0000
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public lngStudyId As Long          ' This is the global Study Identifier
Public lngSurveyId As Long         ' This is the current survey we are working on
Public bolGood As Boolean
Public bolEditable As Boolean
Dim lngTagCount As Long
Public dbTagConnection As DBTagFields.clsTagFields

' This will keep a final count of the number of tags found

' This is used to location all the tags and there
' positions within the text
Private Function GetQstnsTags(ByVal strQuestion As String, ByVal lngQuestionId As Long, ByVal lngLangID As Long) As Long
    
    Dim lngCountTags As Long: lngCountTags = 0
    Dim lngQuestionCount As Long: lngQuestionCount = 0
    Dim lngLocation As Long: lngLocation = 1
    Dim lngLength As Long: lngLength = 0
    Dim Y As Long: Y = 0
    Dim X As Long: X = 0
    Dim strTmp As String
    Dim strDescription As Variant
    Dim varCodeLocations As Variant
    Dim strCodeTextTag As Variant
    MousePointer = vbHourglass
    
    ' This will loop through all the numeric codes in this
    ' one question which will be held in the CodesQstns Table
    'On Error GoTo InvalidTag
    While lngLocation <> 0 And lngLocation <> -1
        lngLocation = InStr(lngLocation, strQuestion, "\{")
        If lngLocation <> 0 Then
            lngLength = InStr(lngLocation, strQuestion, "\}")
            If lngLength = 0 Then
                lngLocation = -1
            Else
                dbTagConnection.SaveQstnsCodeLoc lngQuestionId, lngSurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation - 1, lngLength - lngLocation + 2, lngLangID
                dbTagConnection.lngTagid = Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2)
                strDescription = dbTagConnection.TagDescriptions(Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngSurveyId)
                ' This will loop through all the Tags found for
                ' one code in this one question
                If Not IsNull(strDescription) Then
                    If InStr(1, strDescription(0), "---1") > 0 Then
                        MsgBox "Your Survey is not validated: " & Chr(10) & strDescription(0)
                        GetQstnsTags = -1
                        Exit Function
                    End If
                    For Y = 1 To UBound(strDescription)
'                        dbTagConnection.SaveQstnsCodeLoc lngQuestionId, lngSurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation - 1, lngLength - lngLocation + 2
                        X = InStr(1, strDescription(Y), "--") + 1
                        If CheckDistinct(Mid(strDescription(Y), 1, X - 2)) Then
                            grdTagFields.AddItem Mid(strDescription(Y), 1, X - 2) & vbTab & dbTagConnection.GetTagField(Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X), lngStudyId) & vbTab & Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X)
                            frmPhysician.cmbTag.AddItem Mid(strDescription(Y), 1, X - 2)
                            frmPhysician.cmbTag.ItemData(frmPhysician.cmbTag.NewIndex) = Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X)
                            lngCountTags = lngCountTags + 1
                        End If
                    Next Y
                    grdTagFields.RowHeightMin = cmbAvailableFields.Height
                End If
                lngLocation = lngLength
            End If
        End If
    Wend
    
    grdTagFields.RowHeight(grdTagFields.Rows - 1) = cmbAvailableFields.Height
    GetQstnsTags = lngCountTags
    ''Set dbTagConnection = Nothing
    MousePointer = vbNormal
    On Error GoTo 0
    
    Exit Function

InvalidTag:
    On Error GoTo 0
    GetQstnsTags = -1
    'Set dbTagConnection = Nothing
    MousePointer = vbNormal

End Function

Private Function GetSclsTags(ByVal strQuestion As String, ByVal lngQuestionId As Long, ByVal lngItem As Long, ByVal lngLanguage As Long) As Long
    
    Dim lngCountTags As Long: lngCountTags = 0
    Dim lngQuestionCount As Long: lngQuestionCount = 0
    Dim lngLocation As Long: lngLocation = 1
    Dim lngLength As Long: lngLength = 0
    Dim Y As Long: Y = 0
    Dim X As Long: X = 0
    Dim strTmp As String
    Dim strDescription As Variant
    Dim varCodeLocations As Variant
    Dim strCodeTextTag As Variant
    
    MousePointer = vbHourglass
    
    ' This will loop through all the numeric codes in this
    ' one question which will be held in the CodesQstns Table
    While lngLocation <> 0 And lngLocation <> -1
        lngLocation = InStr(lngLocation, strQuestion, "\{")
        If lngLocation <> 0 Then
            lngLength = InStr(lngLocation, strQuestion, "\}")
            If lngLength = 0 Then
                lngLocation = -1
            Else
                dbTagConnection.SaveSclsCodeLoc lngQuestionId, lngSurveyId, lngItem, lngLanguage, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation - 1, lngLength - lngLocation + 2
                dbTagConnection.lngTagid = Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2)
                strDescription = dbTagConnection.TagDescriptions(dbTagConnection.lngTagid, lngSurveyId)
                If Not IsNull(strDescription) Then
                    If InStr(1, strDescription(0), "---1") > 0 Then
                        MsgBox "Your Survey is not validated: " & Chr(10) & strDescription(0)
                        GetSclsTags = -1
                        Exit Function
                    End If
                End If
                ' This will loop through all the Tags found for
                ' one code in this one question
                If Not IsNull(strDescription) Then
                    For Y = 1 To UBound(strDescription)
'                        dbTagConnection.SaveSclsCodeLoc lngQuestionId, lngSurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation - 1, lngLength - lngLocation + 2
                        X = InStr(1, strDescription(Y), "--") + 1
                        If CheckDistinct(Mid(strDescription(Y), 1, X - 2)) Then
                            grdTagFields.AddItem Mid(strDescription(Y), 1, X - 2) & vbTab & dbTagConnection.GetTagField(Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X), lngStudyId) & vbTab & Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X)
                            frmPhysician.cmbTag.AddItem Mid(strDescription(Y), 1, X - 2)
                            frmPhysician.cmbTag.ItemData(frmPhysician.cmbTag.NewIndex) = Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X)
'                            grdTagFields.BackColor = "#FFFFFF"
                            grdTagFields.RowHeight(lngTagCount + lngCountTags) = cmbAvailableFields.Height
                            lngCountTags = lngCountTags + 1
                        End If
                    Next Y
                End If
                lngLocation = lngLength
            End If
        End If
    Wend
    
    grdTagFields.RowHeight(grdTagFields.Rows - 1) = cmbAvailableFields.Height
    GetSclsTags = lngCountTags
    ''Set dbTagConnection = Nothing
    MousePointer = vbNormal

End Function

Private Function GetTxtBoxTags(ByVal strQuestion As String, ByVal lngQuestionId As Long, ByVal lngLangID As Long) As Long
    
    Dim lngCountTags As Long: lngCountTags = 0
    Dim lngQuestionCount As Long: lngQuestionCount = 0
    Dim lngLocation As Long: lngLocation = 1
    Dim lngLength As Long: lngLength = 0
    Dim Y As Long: Y = 0
    Dim X As Long: X = 0
    Dim strTmp As String
    Dim strDescription As Variant
    Dim varCodeLocations As Variant
    Dim strCodeTextTag As Variant
    
    MousePointer = vbHourglass
    
    ' This will loop through all the numeric codes in this
    ' one question which will be held in the CodesQstns Table
    While lngLocation <> 0 And lngLocation <> -1
        lngLocation = InStr(lngLocation, strQuestion, "\{")
        If lngLocation <> 0 Then
            lngLength = InStr(lngLocation, strQuestion, "\}")
            If lngLength = 0 Then
                lngLocation = -1
            Else
                dbTagConnection.SaveTxtBoxCodeLoc lngQuestionId, lngSurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation - 1, lngLength - lngLocation + 2, lngLangID
                dbTagConnection.lngTagid = Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2)
                strDescription = dbTagConnection.TagDescriptions(dbTagConnection.lngTagid, lngSurveyId)
                ' This will loop through all the Tags found for
                ' one code in this one question
                If Not IsNull(strDescription) Then
                    If InStr(1, strDescription(0), "---1") > 0 Then
                        MsgBox "Your Survey is not validated: " & Chr(10) & strDescription(0)
                        GetTxtBoxTags = -1
                        Exit Function
                    End If
                    For Y = 1 To UBound(strDescription)
'                        dbTagConnection.SaveTxtBoxCodeLoc lngQuestionId, lngSurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation - 1, lngLength - lngLocation + 2
                        X = InStr(1, strDescription(Y), "--") + 1
                        If CheckDistinct(Mid(strDescription(Y), 1, X - 2)) Then
                            grdTagFields.AddItem Mid(strDescription(Y), 1, X - 2) & vbTab & dbTagConnection.GetTagField(Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X), lngStudyId) & vbTab & Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X)
                            frmPhysician.cmbTag.AddItem Mid(strDescription(Y), 1, X - 2)
                            frmPhysician.cmbTag.ItemData(frmPhysician.cmbTag.NewIndex) = Mid(strDescription(Y), X + 1, Len(strDescription(Y)) - X)
                            grdTagFields.RowHeight(lngTagCount + lngCountTags) = cmbAvailableFields.Height
                            lngCountTags = lngCountTags + 1
                        End If
                    Next Y
                End If
                lngLocation = lngLength
            End If
        End If
    Wend
    
    grdTagFields.RowHeight(grdTagFields.Rows - 1) = cmbAvailableFields.Height
    GetTxtBoxTags = lngCountTags
    'Set dbTagConnection = Nothing
    MousePointer = vbNormal

End Function

Private Function CheckDistinct(ByVal TagDsc As String) As Boolean
    
    Dim X As Long
    Dim retVal As Boolean
    
    If Trim(TagDsc) = "" Then
        CheckDistinct = False
        Exit Function
    End If
    
    For X = 0 To grdTagFields.Rows - 1
        If grdTagFields.TextMatrix(X, 0) = TagDsc Then
            CheckDistinct = False
            X = grdTagFields.Rows
        Else
            CheckDistinct = True
        End If
    Next X

End Function

' This is used to get all the meta field names
' and meta table name pairs for a study.
Public Sub GetFields()
    
    Dim oImportWizard As MetadataView.Metadata_View
    Dim X As Long
    Dim varFieldNames As Variant
    Dim TableName As String
    Dim FieldName As String
        
    Set oImportWizard = CreateObject("MetadataView.Metadata_View")
    varFieldNames = oImportWizard.mts_fnvnt_Get_Metadata_View(lngStudyId)

    On Error GoTo Skip
    For X = 0 To UBound(varFieldNames, 2)
        TableName = Trim(varFieldNames(3, X))
        FieldName = Trim(varFieldNames(4, X))
        frmMain.cmbAvailableFields.AddItem TableName & "." & FieldName
        frmPhysician.cmbAvailableFields.AddItem TableName & "." & FieldName
    Next X
    Set oImportWizard = Nothing
    
    Exit Sub

Skip:
    Set oImportWizard = Nothing
    'Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext

End Sub

' This will save all the selected tag assignments
' for each question.
Private Sub SaveFields()
    
    Dim oImportWizard As MetadataView.Metadata_View
    Dim varFieldNames As Variant
    Dim X As Long
    Dim lngCurrentTag As Long
       
    MousePointer = vbHourglass
    Set oImportWizard = CreateObject("MetadataView.Metadata_View")
    
    varFieldNames = oImportWizard.mts_fnvnt_Get_Metadata_View(lngStudyId)
    
    ' First make sure we go through each and every tag
    For lngCurrentTag = 0 To lngTagCount - 1
        ' This will take us through each field for each tag
        For X = 0 To UBound(varFieldNames, 2)
            ' Check to make sure we even have something to look for
            If Trim(grdTagFields.TextMatrix(lngCurrentTag, 1)) <> "" Then
                ' If we found a match than save it
                If varFieldNames(3, X) & "." & varFieldNames(4, X) = grdTagFields.TextMatrix(lngCurrentTag, 1) Then
                ' Found the Table and Field Id!
                    dbTagConnection.SetTagField lngStudyId, CLng(grdTagFields.TextMatrix(lngCurrentTag, 2)), Val(varFieldNames(1, X)), Val(varFieldNames(2, X))
                    grdTagFields.TextMatrix(lngCurrentTag, 3) = ""
                    X = UBound(varFieldNames, 2)
                ' If we havent' found a match than mark it as a no go
                Else
                    grdTagFields.TextMatrix(lngCurrentTag, 3) = -1
                End If
            Else
                ' This is what happens when nothing has been assigned to the tag
                X = UBound(varFieldNames, 2)
                ' We are going to try and delete any
                ' previous assignments to this field.
                'dbTagConnection.DelTagField grdTagFields.TextMatrix(lngCurrentTag, 2), lngStudyId
                dbTagConnection.SetTagField lngStudyId, CLng(grdTagFields.TextMatrix(lngCurrentTag, 2)), 0, 0, ""
            End If
        ' Continue on looking at the next field name
        Next X
        ' This happens if no database fields were found.
        ' We assume that they have typed in a literal string
        If Val(grdTagFields.TextMatrix(lngCurrentTag, 3)) = -1 Then
            dbTagConnection.SetTagField lngStudyId, CLng(grdTagFields.TextMatrix(lngCurrentTag, 2)), 0, 0, grdTagFields.TextMatrix(lngCurrentTag, 1)
        End If
    ' Continue on with the next tag definition
    Next lngCurrentTag
    
Skip:
    MousePointer = vbNormal
    Set oImportWizard = Nothing
    'Set dbTagConnection = Nothing

End Sub

Private Sub cmdApply_Click()
    
    SaveFields
    cmdApply.Enabled = False

End Sub

Private Sub cmdOk_Click()
    
    Dim retVal As Integer
    
    If cmdApply.Enabled And bolEditable Then
        'retVal = MsgBox("Would you like to save your changes?", vbYesNo, "Question")
        retVal = vbYes
        Select Case retVal
            Case vbYes:
                cmdApply_Click
                Unload Me
            Case vbNo:
                cmdApply.Enabled = False
                Unload Me
        End Select
    Else
        Unload Me
    End If

End Sub

Private Sub cmdCancel_Click()
    
    Dim retVal As Integer
    
    If cmdApply.Enabled And bolEditable Then
        'retVal = MsgBox("Are you sure you would like to continue and loose all your changes?", vbYesNo, "Question")
        retVal = vbYes
        Select Case retVal
            Case vbYes:
                Unload Me
            Case vbNo:
        End Select
    Else
        Unload Me
    End If

End Sub

Private Sub cmdPhysician_Click()

    'look for a current TagException record
    Dim vntException As Variant
    Dim X As Long
        
    vntException = frmMain.dbTagConnection.GetTagException(lngStudyId)
    
    If Not IsEmpty(vntException) Then
        'set exception to current value in combo boxes
         For X = 0 To frmPhysician.cmbTag.ListCount
            If frmPhysician.cmbTag.ItemData(X) = vntException(1, 0) Then
                frmPhysician.cmbTag.Text = frmPhysician.cmbTag.List(X)
                frmPhysician.cmbTag.ListIndex = X
                X = frmPhysician.cmbTag.ListCount
            End If
         Next X
         
         For X = 0 To frmPhysician.cmbAvailableFields.ListCount
            If frmPhysician.cmbAvailableFields.List(X) = vntException(6, 0) & "." & vntException(5, 0) Then
                frmPhysician.cmbAvailableFields.Text = frmPhysician.cmbAvailableFields.List(X)
                X = frmPhysician.cmbAvailableFields.ListCount
            End If
         Next X
    Else
        frmPhysician.cmbAvailableFields.Text = ""
        frmPhysician.cmbTag.Text = ""
    End If
    
    'Set dbTagConnection = Nothing
    frmPhysician.Editable bolEditable
    frmPhysician.Show vbModal

End Sub

Private Sub Form_Load()
    
    Dim X, Y As Long
    Dim strQuestions As Variant
    Dim strQst As String
    Dim pstrMsg As String
    
    'On Error GoTo BadLoad
    
    If lngStudyId = 0 Or lngSurveyId = 0 Then
        MsgBox "You must provide a Study and Survey first!", vbOKOnly, "Tag Field Assignment Error"
        Exit Sub
    End If

    Me.Left = GetSetting(App.Title, "Settings", "MainLeft", 1000)
    Me.Top = GetSetting(App.Title, "Settings", "MainTop", 1000)
    Me.Width = GetSetting(App.Title, "Settings", "MainWidth", 6500)
    Me.Height = GetSetting(App.Title, "Settings", "MainHeight", 6500)
    
    ' Make sure the status is displayed
    'frmStatus.Show 0, Me
    'frmStatus.stbStatus.Panels(1).Text = "Connecting to the database..."
    
    ' Go through all the questions assigned to this survey
    Set dbTagConnection = New DBTagFields.clsTagFields
    dbTagConnection.DelSurveyLocations lngSurveyId
    'frmStatus.stbStatus.Panels(1).Text = "Scanning Questions..."
    strQuestions = dbTagConnection.SelQuestions(lngSurveyId)
    If Not IsNull(strQuestions) Then
        'frmStatus.prgStatusLine.Max = IIf(UBound(strQuestions, 2) = 0, 1, UBound(strQuestions, 2))
        For X = 0 To UBound(strQuestions, 2)
            'frmStatus.prgStatusLine.Value = X
            DoEvents
            Y = GetQstnsTags(IIf(IsNull(strQuestions(1, X)), " ", strQuestions(1, X)), strQuestions(0, X), strQuestions(2, X))
            If Y <> -1 Then
                lngTagCount = lngTagCount + Y
            Else
                'Unload frmStatus
                cmdCancel_Click
                Exit Sub
            End If
        Next X
    End If
    
    ' Now go through all the Scales that are assigned to this survey
    'frmStatus.stbStatus.Panels(1).Text = "Scanning Scales..."
    strQuestions = dbTagConnection.SelScales(lngSurveyId)
    If Not IsNull(strQuestions) Then
        'frmStatus.prgStatusLine.Max = IIf(UBound(strQuestions, 2) = 0, 1, UBound(strQuestions, 2))
        For X = 0 To UBound(strQuestions, 2)
            Y = GetSclsTags(IIf(IsNull(strQuestions(3, X)), " ", strQuestions(3, X)), strQuestions(0, X), strQuestions(1, X), strQuestions(2, X))
            If Y <> -1 Then
                lngTagCount = lngTagCount + Y
            Else
                'Unload frmStatus
                cmdCancel_Click
                Exit Sub
            End If
            DoEvents
            'frmStatus.prgStatusLine.Value = X
        Next X
    End If
    
    '''Test Me Here!!!
    ' Now go through all the Text Boxes that are assigned to this survey
    'frmStatus.stbStatus.Panels(1).Text = "Scanning Text Boxes..."
    strQuestions = dbTagConnection.SelTextBoxes(lngSurveyId)
    If Not IsNull(strQuestions) Then
        'frmStatus.prgStatusLine.Max = IIf(UBound(strQuestions, 2) = 0, 1, UBound(strQuestions, 2))
        For X = 0 To UBound(strQuestions, 2)
            Y = GetTxtBoxTags(IIf(IsNull(strQuestions(1, X)), " ", strQuestions(1, X)), strQuestions(0, X), strQuestions(2, X))
            If Y <> -1 Then
                lngTagCount = lngTagCount + Y
            Else
                'Unload frmStatus
                cmdCancel_Click
                Exit Sub
            End If
            DoEvents
            'frmStatus.prgStatusLine.Value = X
        Next X
    End If
    
    'Set dbTagConnection = Nothing
    'frmStatus.stbStatus.Panels(1).Text = "Displaying Table.Field Names..."
    If lngTagCount > 0 Then
        GetFields
        grdTagFields.RemoveItem 0
        cmbAvailableFields.Text = grdTagFields.TextMatrix(0, 1)
        If Not bolEditable Then
            Me.Caption = "(Read Only) " & Me.Caption
            cmbAvailableFields.Enabled = False
        End If
        bolGood = True
    Else
        MsgBox "A Form Layout has not been saved for this survey!", vbInformation, "Personalization Tool Warning"
        bolGood = False
        Unload Me
    End If
    'frmStatus.Hide
    
    Exit Sub

BadLoad:
    pstrMsg = "ERROR #: " & Err.Number & vbCrLf
    pstrMsg = pstrMsg & "ERROR TEXT: " & Err.Description & vbCrLf & vbCrLf
    pstrMsg = pstrMsg & "Error Loading Personalization Tool." & vbCrLf
    pstrMsg = pstrMsg & "ERROR PROC: Load in frmMain.frm" & vbCrLf
    MsgBox pstrMsg
    'frmStatus.Hide
'    Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    
    Dim retVal As Integer
    
    If cmdApply.Enabled And bolEditable Then
        retVal = MsgBox("Are you sure you want to continue to exit and loose your changes?", vbYesNo, "Warning Message")
        Select Case retVal
            Case vbYes:
                Cancel = 0
            Case vbNo:
                Cancel = 1
        End Select
    Else
        Cancel = 0
    End If

End Sub

Private Sub Form_Resize()

    On Error GoTo SkipResize
    
    If Me.Width < cmdApply.Width + cmdCancel.Width + cmdOk.Width + 1500 Then
        Me.Width = cmdApply.Width + cmdCancel.Width + cmdOk.Width + 1500
    End If
    If Me.Height < cmdApply.Height + 2000 Then
        Me.Height = cmdApply.Height + 2000
    End If
    
    cmdApply.Left = Me.Width - cmdApply.Width - 200
    cmdApply.Top = Me.Height - cmdApply.Height - 500
    
    cmdPhysician.Left = cmdApply.Left - cmdCancel.Width - 200
    cmdPhysician.Top = Me.Height - cmdApply.Height - 500
    
    cmdCancel.Left = cmdPhysician.Left - cmdOk.Width - 200
    cmdCancel.Top = Me.Height - cmdPhysician.Height - 500
    
    cmdOk.Left = cmdCancel.Left - cmdOk.Width - 200
    cmdOk.Top = Me.Height - cmdApply.Height - 500
    
    On Error GoTo Skip
    
    grdTagFields.Height = Me.Height - cmdApply.Height - 950
    grdTagFields.RowHeight(grdTagFields.Row) = cmbAvailableFields.Height
    
    If grdTagFields.Height > (cmbAvailableFields.Height * grdTagFields.Rows) + 60 Then
        grdTagFields.ColWidth(0) = Me.Width / 2 - 100
        grdTagFields.ColWidth(1) = Me.Width / 2 - 300
    Else
        grdTagFields.ColWidth(0) = Me.Width / 2 - 200
        grdTagFields.ColWidth(1) = Me.Width / 2 - 400
    End If
    
Skip:
    On Error GoTo 0
    cmbAvailableFields.Left = grdTagFields.ColWidth(0) + grdTagFields.Left + 50
    cmbAvailableFields.Top = grdTagFields.Top + (grdTagFields.Row * cmbAvailableFields.Height) + 50
    cmbAvailableFields.Width = grdTagFields.ColWidth(1)
    
    lblTagDescription.Left = grdTagFields.Left
    lblTagDescription.Width = grdTagFields.ColWidth(0)
    lblAssignedValue.Left = grdTagFields.Left + grdTagFields.ColWidth(0)
    lblAssignedValue.Width = grdTagFields.ColWidth(0)
    
    grdTagFields.Width = Me.Width - 300
    grdTagFields.Row = grdTagFields.TopRow
    grdTagFields_Click
    
SkipResize:

End Sub

Private Sub Form_Unload(Cancel As Integer)
    
    Dim I As Integer
    
    'close all sub forms
    For I = Forms.Count - 1 To 1 Step -1
        Unload Forms(I)
    Next
    
    If Me.WindowState <> vbMinimized Then
        SaveSetting App.Title, "Settings", "MainLeft", Me.Left
        SaveSetting App.Title, "Settings", "MainTop", Me.Top
        SaveSetting App.Title, "Settings", "MainWidth", Me.Width
        SaveSetting App.Title, "Settings", "MainHeight", Me.Height
    End If

End Sub

Private Sub grdTagFields_Click()
    
    cmbAvailableFields.Text = grdTagFields.TextMatrix(grdTagFields.Row, 1)
    grdTagFields.RowHeight(grdTagFields.Row) = cmbAvailableFields.Height
    cmbAvailableFields.Left = grdTagFields.ColWidth(0) + grdTagFields.Left + 50
    cmbAvailableFields.Top = grdTagFields.Top + ((grdTagFields.Row - grdTagFields.TopRow) * cmbAvailableFields.Height) + 50
    cmbAvailableFields.Width = grdTagFields.ColWidth(1)

End Sub

Private Sub cmbAvailableFields_Click()
    
    Dim intMarker As Integer
    
    intMarker = InStr(1, cmbAvailableFields.Text, vbTab) - 1
    
    'grdTagFields.TextMatrix(grdTagFields.Row, 1) = Trim(Mid(cmbAvailableFields.Text, 1, intMarker))
    grdTagFields.TextMatrix(grdTagFields.Row, 1) = cmbAvailableFields.Text
    grdTagFields.TextMatrix(grdTagFields.Row, 3) = ""
    
    If bolEditable Then
        cmdApply.Enabled = True
    End If

End Sub

Private Sub cmbAvailableFields_KeyUp(KeyCode As Integer, Shift As Integer)
    
    cmbAvailableFields_Click
    grdTagFields.TextMatrix(grdTagFields.Row, 3) = -1

End Sub

Private Sub grdTagFields_Scroll()
    
    If grdTagFields.TopRow > 0 Then
        grdTagFields.Row = grdTagFields.TopRow
    Else
        grdTagFields.Row = 0
    End If
    
    grdTagFields_Click

End Sub
