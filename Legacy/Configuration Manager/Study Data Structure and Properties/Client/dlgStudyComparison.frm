VERSION 5.00
Begin VB.Form dlgStudyComparison 
   Caption         =   "Study Comparison"
   ClientHeight    =   3705
   ClientLeft      =   60
   ClientTop       =   420
   ClientWidth     =   5670
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   3705
   ScaleWidth      =   5670
   Begin VB.ComboBox cmbMGPT 
      Height          =   315
      Left            =   2280
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   1920
      Width           =   3015
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   400
      Left            =   4080
      TabIndex        =   8
      Top             =   2880
      Width           =   1200
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   400
      Left            =   2640
      TabIndex        =   7
      Top             =   2880
      Width           =   1200
   End
   Begin VB.ComboBox cmbComparisonType 
      Height          =   315
      Left            =   2280
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   480
      Width           =   3015
   End
   Begin VB.ComboBox cmbMSA 
      Height          =   315
      Left            =   2280
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   960
      Width           =   3015
   End
   Begin VB.ComboBox cmbState 
      Height          =   315
      Left            =   2280
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   1440
      Width           =   3015
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Market Guide Plan Type:"
      Height          =   195
      Left            =   360
      TabIndex        =   6
      Top             =   1920
      Width           =   1770
   End
   Begin VB.Label Label20 
      AutoSize        =   -1  'True
      Caption         =   "Comparison Type:"
      Height          =   195
      Left            =   855
      TabIndex        =   0
      Top             =   480
      Width           =   1275
   End
   Begin VB.Label Label21 
      AutoSize        =   -1  'True
      Caption         =   "MSA:"
      Height          =   195
      Left            =   1740
      TabIndex        =   2
      Top             =   960
      Width           =   390
   End
   Begin VB.Label Label22 
      AutoSize        =   -1  'True
      Caption         =   "State:"
      Height          =   195
      Left            =   1710
      TabIndex        =   4
      Top             =   1440
      Width           =   420
   End
End
Attribute VB_Name = "dlgStudyComparison"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim strResult As String
Private flgLoading As Boolean
Private flgChanged As Boolean
Private WithEvents objStudyComparison As StudyComparison
Attribute objStudyComparison.VB_VarHelpID = -1

Public Sub Component(aStudyComparison As StudyComparison)
    Set objStudyComparison = aStudyComparison
End Sub

Private Sub cmbComparisonType_Click()
    If flgLoading Then Exit Sub
    If cmbComparisonType.ListIndex < 0 Then Exit Sub
    
    objStudyComparison.ComparisonType = val(G_Study.ComparisonTypeList.Key(cmbComparisonType.Text))
    
    flgChanged = True
End Sub

Private Sub cmbMGPT_Click()
    If flgLoading Then Exit Sub
    
    If cmbMGPT.ListIndex < 0 Then Exit Sub
    
    objStudyComparison.MarketGuidePlanType = val(G_Study.MGPTList.Key(cmbMGPT.Text))
    
    flgChanged = True
End Sub

Private Sub cmbMSA_Click()
    If flgLoading Then Exit Sub
    If cmbMSA.ListIndex < 0 Then Exit Sub
    
    objStudyComparison.MSA = val(G_Study.MSAList.Key(cmbMSA.Text))
    flgChanged = True
End Sub

Private Sub cmbState_Click()
    If flgLoading Then Exit Sub
    If cmbState.ListIndex < 0 Then Exit Sub
    
    objStudyComparison.State = val(G_Study.StateList.Key(cmbState.Text))
    flgChanged = True
End Sub

Private Sub Form_Load()
    Dim lngIndex As Long
      
    loadComboBox cmbComparisonType, "ComparisonType"
    loadComboBox cmbMSA, "MSA"
    loadComboBox cmbState, "State"
    loadComboBox cmbMGPT, "MarketGuidePlanType"
    
    flgLoading = True

    cmbComparisonType.ListIndex = -1
    cmbMSA.ListIndex = -1
    cmbState.ListIndex = -1
    cmbMGPT.ListIndex = -1
    'If objStudyComparison.ComparisonType > 0 Then
    '    cmbComparisonType.Text = G_Study.ComparisonTypeList.Item(Format$(objStudyComparison.ComparisonType))
    'End If

    'If objStudyComparison.MSA > 0 Then
    '    cmbMSA.Text = G_Study.MSAList.Item(Format$(objStudyComparison.MSA))
    'End If

    'If objStudyComparison.State > 0 Then
    '    cmbState.Text = G_Study.StateList.Item(Format$(objStudyComparison.State))
    'End If

    If objStudyComparison.ComparisonType > 0 Then
        For lngIndex = 0 To cmbComparisonType.ListCount - 1
            If objStudyComparison.ComparisonType = cmbComparisonType.ItemData(lngIndex) Then
                cmbComparisonType.ListIndex = lngIndex
            End If
        Next lngIndex
    End If
    
    If objStudyComparison.MSA > 0 Then
        For lngIndex = 0 To cmbMSA.ListCount - 1
            If objStudyComparison.MSA = cmbMSA.ItemData(lngIndex) Then
                cmbMSA.ListIndex = lngIndex
            End If
        Next lngIndex
    End If
        
    If objStudyComparison.State > 0 Then
        For lngIndex = 0 To cmbState.ListCount - 1
            If objStudyComparison.State = cmbState.ItemData(lngIndex) Then
                cmbState.ListIndex = lngIndex
            End If
        Next lngIndex
    End If

    If objStudyComparison.MarketGuidePlanType > 0 Then
        For lngIndex = 0 To cmbMGPT.ListCount - 1
            If objStudyComparison.MarketGuidePlanType = cmbMGPT.ItemData(lngIndex) Then
                cmbMGPT.ListIndex = lngIndex
            End If
        Next lngIndex
    End If
    
    'strResult = objStudyComparison.MarketGuidePlanType
    'If strResult <> "" Then
    '    cmbMGPT.Text = strResult
    'End If
    'cmbMGPT.SelText = objStudyComparison.MarketGuidePlanType
    'cmbMGPT.Text = objStudyComparison.MarketGuidePlanType

    flgLoading = False
    flgChanged = False
    
    objStudyComparison.BeginEdit
End Sub

Private Sub loadComboBox(cmbBox As ComboBox, aListName As String)
    Dim vntItem As Variant
    Dim aList As TextList
    Dim lngIndex As Long
        
    flgLoading = True
    
    '* need to add code here, Dan Wag
    Select Case aListName
        Case "ComparisonType"
            Set aList = G_Study.ComparisonTypeList
        Case "MSA"
            Set aList = G_Study.MSAList
        Case "State"
            Set aList = G_Study.StateList
        Case "MarketGuidePlanType"
            Set aList = G_Study.MGPTList
        Case Else
            Set aList = Nothing
    End Select
    
    cmbBox.Clear
    
    'For Each vntItem In aList
    '  cmbBox.AddItem vntItem
    'Next

    For lngIndex = 1 To aList.Count
        cmbBox.AddItem aList.Item(lngIndex)
        cmbBox.ItemData(cmbBox.NewIndex) = aList.Key(aList.Item(lngIndex))
    Next
    
    flgLoading = False
End Sub

Private Sub cmdOK_Click()
    If IsScreenValid Then
        objStudyComparison.ApplyEdit
        Unload Me
    Else
        MsgBox "Comparison Type is required", , G_Study.name
    End If
End Sub

Private Sub cmdCancel_Click()
    If flgChanged Then
        If (MsgBox("Do you wish to save changes to this screen", vbYesNo, G_Study.name) = vbYes) Then
            cmdOK_Click
            Exit Sub
        End If
    End If
  
    objStudyComparison.CancelEdit
    Unload Me
End Sub

Private Sub objStudyComparison_Valid(IsValid As Boolean)
    EnableOK IsValid
End Sub

Private Sub EnableOK(flgValid As Boolean)
    cmdOK.Enabled = flgValid
    '  cmdApply.Enabled = flgValid
End Sub

Private Function IsScreenValid() As Boolean
    If Len(cmbComparisonType.Text) > 0 Then
        IsScreenValid = True
    Else
        IsScreenValid = False
    End If
End Function
