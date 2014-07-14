VERSION 5.00
Begin VB.Form dlgStudyReport 
   Caption         =   "Study Report"
   ClientHeight    =   3375
   ClientLeft      =   135
   ClientTop       =   480
   ClientWidth     =   5520
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   3375
   ScaleWidth      =   5520
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   400
      Left            =   3840
      TabIndex        =   5
      Top             =   2520
      Width           =   1200
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&OK"
      Height          =   400
      Left            =   2400
      TabIndex        =   4
      Top             =   2520
      Width           =   1200
   End
   Begin VB.ComboBox cmbReportType 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   720
      Width           =   3375
   End
   Begin VB.TextBox editReportNote 
      Height          =   855
      Left            =   1680
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Top             =   1200
      Width           =   3375
   End
   Begin VB.Label Label23 
      AutoSize        =   -1  'True
      Caption         =   "Report Type Code:"
      Height          =   195
      Left            =   240
      TabIndex        =   0
      Top             =   720
      Width           =   1350
   End
   Begin VB.Label Label24 
      AutoSize        =   -1  'True
      Caption         =   "Note:"
      Height          =   195
      Left            =   1200
      TabIndex        =   2
      Top             =   1200
      Width           =   390
   End
End
Attribute VB_Name = "dlgStudyReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private flgLoading As Boolean
Private flgChanged As Boolean
Private WithEvents objStudyReport As StudyReport
Attribute objStudyReport.VB_VarHelpID = -1

Public Sub Component(aStudyReport As StudyReport)
    
    Set objStudyReport = aStudyReport
    
End Sub

Private Sub Form_Load()
    
    Dim i As Long
    
    loadComboBox
    flgLoading = True
    cmbReportType.ListIndex = -1
    
    If objStudyReport.ReportType > 0 Then
        'cmbReportType.Text = G_Study.ReportTypeList.Item(Format$(objStudyReport.ReportType))
        For i = 0 To cmbReportType.ListCount - 1
            If objStudyReport.ReportType = cmbReportType.ItemData(i) Then
                cmbReportType.ListIndex = i
            End If
        Next i
    End If
        
    editReportNote = objStudyReport.Description
    flgLoading = False
    flgChanged = False
    
    objStudyReport.BeginEdit
    
End Sub

Private Sub cmdOK_Click()
  
    If IsScreenValid Then
        objStudyReport.ApplyEdit
        Unload Me
    Else
        MsgBox "Report Type Code is required", , G_Study.name
    End If
  
End Sub

Private Sub cmdCancel_Click()
    
    If flgChanged Then
        If (MsgBox("Do you wish to save changes to this screen", vbYesNo, G_Study.name) = vbYes) Then
            cmdOK_Click
            Exit Sub
        End If
    End If
  
    objStudyReport.CancelEdit
    
    Unload Me

End Sub

Private Sub objStudyReport_Valid(IsValid As Boolean)
  
    EnableOK IsValid

End Sub

Private Sub EnableOK(flgValid As Boolean)
    
    cmdOK.Enabled = flgValid
    'cmdApply.Enabled = flgValid

End Sub

Private Sub cmbReportType_Click()
    
    If flgLoading Then Exit Sub
    
    If cmbReportType.ListIndex < 0 Then Exit Sub
    
    objStudyReport.ReportType = val(G_Study.ReportTypeList.Key(cmbReportType.Text))
    
    flgChanged = True

End Sub

Private Sub editReportNote_Change()
  
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    On Error Resume Next
    
    objStudyReport.Description = editReportNote.Text
    
    If Err Then
        Beep
        intPos = editReportNote.SelStart
        editReportNote.Text = objStudyReport.Description
        editReportNote.SelStart = intPos - 1
    End If
    
    flgChanged = True
  
End Sub

Private Sub editReportNote_LostFocus()
    
    If flgLoading Then Exit Sub
    
    editReportNote = objStudyReport.Description

End Sub

Private Sub loadComboBox()

    'Dim vntItem As Variant
    'Dim aList As TextList

    'flgLoading = True
    'Set aList = G_Study.ReportTypeList

    'cmbReportType.Clear

    'For Each vntItem In aList
    '  cmbReportType.AddItem vntItem
    'Next

    'flgLoading = False

    Dim lngIndex As Long
    Dim aList As TextList
    
    flgLoading = True
    
    Set aList = G_Study.ReportTypeList
    
    cmbReportType.Clear
    
    For lngIndex = 1 To aList.Count
        cmbReportType.AddItem aList.Item(lngIndex)
        cmbReportType.ItemData(cmbReportType.NewIndex) = aList.Key(aList.Item(lngIndex))
    Next
    
    flgLoading = False

End Sub

Private Function IsScreenValid() As Boolean
    
    If Len(cmbReportType.Text) > 0 Then
        IsScreenValid = True
    Else
        IsScreenValid = False
    End If

End Function
