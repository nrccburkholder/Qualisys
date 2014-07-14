VERSION 5.00
Begin VB.Form dlgStudyDelivery 
   Caption         =   "Study Delivery"
   ClientHeight    =   6030
   ClientLeft      =   135
   ClientTop       =   420
   ClientWidth     =   5550
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   6030
   ScaleWidth      =   5550
   Begin VB.ComboBox cmbContactName 
      Height          =   315
      Left            =   1560
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   3000
      Width           =   3375
   End
   Begin VB.TextBox editHoursWorked 
      Height          =   315
      Left            =   1560
      MaxLength       =   5
      TabIndex        =   7
      Top             =   2490
      Width           =   855
   End
   Begin VB.TextBox editDateWorked 
      Height          =   315
      Left            =   1560
      MaxLength       =   10
      TabIndex        =   5
      Top             =   2000
      Width           =   1455
   End
   Begin VB.CheckBox chkCorrection 
      Caption         =   "Correction"
      Height          =   375
      Left            =   1560
      TabIndex        =   12
      Top             =   4560
      Width           =   1575
   End
   Begin VB.CheckBox chkClientRequest 
      Caption         =   "Client Request"
      Height          =   375
      Left            =   1560
      TabIndex        =   11
      Top             =   4005
      Width           =   1575
   End
   Begin VB.CheckBox chkBillable 
      Caption         =   "Billable"
      Height          =   375
      Left            =   1560
      TabIndex        =   10
      Top             =   3465
      Width           =   1575
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&OK"
      Height          =   400
      Left            =   2280
      TabIndex        =   13
      Top             =   5280
      Width           =   1200
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   400
      Left            =   3720
      TabIndex        =   14
      Top             =   5280
      Width           =   1200
   End
   Begin VB.TextBox editDelDateDesc 
      Height          =   855
      Left            =   1560
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Top             =   970
      Width           =   3375
   End
   Begin VB.TextBox editDeliveryDate 
      Height          =   315
      Left            =   1560
      MaxLength       =   10
      TabIndex        =   1
      Top             =   480
      Width           =   1455
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "Contact Name:"
      Height          =   195
      Left            =   300
      TabIndex        =   8
      Top             =   3000
      Width           =   1065
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Hours Worked:"
      Height          =   195
      Left            =   285
      TabIndex        =   6
      Top             =   2490
      Width           =   1080
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Date Worked:"
      Height          =   195
      Left            =   360
      TabIndex        =   4
      Top             =   1995
      Width           =   1005
   End
   Begin VB.Label Label27 
      AutoSize        =   -1  'True
      Caption         =   "Delivery Date:"
      Height          =   195
      Left            =   360
      TabIndex        =   0
      Top             =   540
      Width           =   1005
   End
   Begin VB.Label Label28 
      AutoSize        =   -1  'True
      Caption         =   "Description:"
      Height          =   195
      Left            =   525
      TabIndex        =   2
      Top             =   960
      Width           =   840
   End
End
Attribute VB_Name = "dlgStudyDelivery"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private flgLoading As Boolean
Private flgChanged As Boolean

' 10/5/1999 DV - Adding auditing.
Private pobjAudit As Audit.cAudit
Private pblnNew As Boolean
Private WithEvents objStudyDelivery As StudyDelivery
Attribute objStudyDelivery.VB_VarHelpID = -1

' 10/5/1999 DV - Adding auditing
Friend Property Set objAudit(pAudit As Audit.cAudit)
    Set pobjAudit = pAudit
End Property

Friend Property Let blnNew(pNew As Boolean)
    pblnNew = pNew
End Property

Public Sub Component(aStudyDelivery As StudyDelivery)
    Set objStudyDelivery = aStudyDelivery
End Sub

Private Sub Form_Load()
    Dim lngIndex As Long
    
    loadComboBox
    
    flgLoading = True
    
    editDeliveryDate = objStudyDelivery.DeliveryDate
    editDelDateDesc = objStudyDelivery.Description
    editDateWorked = objStudyDelivery.DateWorked
    editHoursWorked = IIf((objStudyDelivery.HoursWorked = -1), "", CStr(objStudyDelivery.HoursWorked))
    chkBillable.Value = IIf((objStudyDelivery.IsBillable = True), 1, 0)
    chkClientRequest.Value = IIf((objStudyDelivery.IsClientRequest = True), 1, 0)
    chkCorrection.Value = IIf((objStudyDelivery.IsCorrection = True), 1, 0)
    
    ' 10-5-1999 DV
    ' Adding auditing, if we are doing update, then
    ' we will register the objects and get the original value.

    If Not pblnNew Then
        pobjAudit.AddChangingItem editDeliveryDate, TEXT_BOX, DELIVERABLES_CHANGE, "Deliverable Date", 1
        pobjAudit.AddChangingItem editDelDateDesc, TEXT_BOX, DELIVERABLES_CHANGE, "Description", 2
        pobjAudit.AddChangingItem editDateWorked, TEXT_BOX, DELIVERABLES_CHANGE, "DateWorked", 3
        pobjAudit.AddChangingItem editHoursWorked, TEXT_BOX, DELIVERABLES_CHANGE, "HoursWorked", 4
        pobjAudit.AddChangingItem chkBillable, CHECK_BOX, DELIVERABLES_CHANGE, "IsBillable", 5
        pobjAudit.AddChangingItem chkClientRequest, CHECK_BOX, DELIVERABLES_CHANGE, "IsClientRequest", 6
        pobjAudit.AddChangingItem chkCorrection, CHECK_BOX, DELIVERABLES_CHANGE, "IsCorrection", 7
        pobjAudit.GetOriginalValues Me
    End If
    
    If objStudyDelivery.ContactID > 0 Then
        For lngIndex = 0 To cmbContactName.ListCount - 1
           If objStudyDelivery.ContactID = cmbContactName.ItemData(lngIndex) Then
              cmbContactName.ListIndex = lngIndex
           End If
        Next lngIndex
    End If
        
    flgLoading = False
    flgChanged = False
    objStudyDelivery.BeginEdit
End Sub

Private Sub cmdOK_Click()
    If IsScreenValid Then
        objStudyDelivery.ApplyEdit
        ' 10/5/1999 DV - Adding auditing.
        If Not pblnNew Then
            pobjAudit.GetNewValues Me
        Else
            pobjAudit.AddInsertedItem editDeliveryDate.Text, DELIVERABLES_CHANGE, "Deliverable Date", 1
            pobjAudit.AddInsertedItem editDelDateDesc.Text, DELIVERABLES_CHANGE, "Description", 2
            pobjAudit.AddInsertedItem editDateWorked.Text, DELIVERABLES_CHANGE, "DateWorked", 3
            pobjAudit.AddInsertedItem editHoursWorked.Text, DELIVERABLES_CHANGE, "HoursWorked", 4
            pobjAudit.AddInsertedItem chkBillable.Value, DELIVERABLES_CHANGE, "IsBillable", 5
            pobjAudit.AddInsertedItem chkClientRequest.Value, DELIVERABLES_CHANGE, "IsClientRequest", 6
            pobjAudit.AddInsertedItem chkCorrection.Value, DELIVERABLES_CHANGE, "IsCorrection", 7
        End If
        Unload Me
    Else
        MsgBox "Delivery Date, Description, and Contact Name are required.", vbInformation, G_Study.name
    End If
End Sub

Private Sub cmdCancel_Click()
    If flgChanged Then
        If (MsgBox("Do you wish to save changes to this screen", vbYesNo, G_Study.name) = vbYes) Then
            cmdOK_Click
            Exit Sub
        End If
    End If
  
    objStudyDelivery.CancelEdit
    
    Unload Me
End Sub

Private Sub objStudyDelivery_Valid(IsValid As Boolean)
    EnableOK IsValid
End Sub

Private Sub EnableOK(flgValid As Boolean)
    cmdOK.Enabled = flgValid
    'cmdApply.Enabled = flgValid
End Sub

Private Sub editDelDateDesc_Change()
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    On Error Resume Next
    
    objStudyDelivery.Description = editDelDateDesc.Text
    
    If Err Then
        Beep
        intPos = editDelDateDesc.SelStart
        editDelDateDesc.Text = objStudyDelivery.Description
        editDelDateDesc.SelStart = intPos - 1
    End If
    
    flgChanged = True
End Sub

Private Sub editDelDateDesc_LostFocus()
    If flgLoading Then Exit Sub
    
    editDelDateDesc = objStudyDelivery.Description
End Sub

Private Sub editDeliveryDate_LostFocus()
    Dim val As String
    
    If flgLoading Then Exit Sub
        
    val = Trim(editDeliveryDate.Text)
    
    If Len(val) = 0 Then
        objStudyDelivery.DeliveryDate = ""
    ElseIf IsDate(val) Then
        objStudyDelivery.DeliveryDate = val
    Else
        MsgBox "Please enter valid dates", , G_Study.name
        editDeliveryDate.SetFocus
    End If
End Sub

Private Sub chkBillable_Click()
    If flgLoading Then Exit Sub

    If chkBillable.Value = 0 Then
        objStudyDelivery.IsBillable = False
    Else
        objStudyDelivery.IsBillable = True
    End If

    flgChanged = True
End Sub

Private Sub chkClientRequest_Click()
    If flgLoading Then Exit Sub

    If chkClientRequest.Value = 0 Then
        objStudyDelivery.IsClientRequest = False
    Else
        objStudyDelivery.IsClientRequest = True
    End If

    flgChanged = True
End Sub

Private Sub chkCorrection_Click()
    If flgLoading Then Exit Sub

    If chkCorrection.Value = 0 Then
        objStudyDelivery.IsCorrection = False
    Else
        objStudyDelivery.IsCorrection = True
    End If

    flgChanged = True
End Sub

Private Sub editDateWorked_Change()
    If flgLoading Then Exit Sub
    flgChanged = True
End Sub

Private Sub editDateWorked_LostFocus()
    Dim val As String
    
    If flgLoading Then Exit Sub
    
    val = Trim(editDateWorked.Text)
    
    If Len(val) = 0 Then
        objStudyDelivery.DateWorked = ""
    ElseIf IsDate(val) Then
        objStudyDelivery.DateWorked = val
    Else
        MsgBox "Please enter valid dates", , G_Study.name
        editDateWorked.SetFocus
    End If
End Sub

Private Sub editDeliveryDate_Change()
    If flgLoading Then Exit Sub
    
    flgChanged = True
End Sub

Private Sub editHoursWorked_Change()
    If flgLoading Then Exit Sub
    
    flgChanged = True
End Sub

Private Sub editHoursWorked_Lostfocus()
    Dim val As String
    
    If flgLoading Then Exit Sub
        
    val = Trim(editHoursWorked.Text)
    
    If Len(val) = 0 Then
        objStudyDelivery.HoursWorked = -1
    ElseIf IsNumeric(val) Then
        If CDbl(val) > MAX_INTEGER_VALUE Then
            MsgBox "The value entered must be less than or equal to " & MAX_INTEGER_VALUE, , G_Study.name
            editHoursWorked.SetFocus
        Else
            objStudyDelivery.HoursWorked = CLng(val)
        End If
    Else
        MsgBox "Please enter only numeric values", , G_Study.name
        editHoursWorked.SetFocus
    End If
End Sub

Private Function IsScreenValid() As Boolean
    If IsDate(objStudyDelivery.DeliveryDate) _
        And Len(objStudyDelivery.Description) > 0 _
        And Trim(cmbContactName.Text) <> "" Then
        IsScreenValid = True
    Else
        IsScreenValid = False
    End If
End Function

Private Sub cmbContactName_Click()
    If flgLoading Then Exit Sub
    
    If cmbContactName.ListIndex < 0 Then Exit Sub
    
    objStudyDelivery.ContactID = val(G_Study.ContactList.Key(cmbContactName.Text))
    
    flgChanged = True
End Sub

Private Sub loadComboBox()
    Dim lngIndex As Long
    Dim aList As TextList
    
    flgLoading = True
    
    Set aList = G_Study.ContactList
    
    cmbContactName.Clear
    
    For lngIndex = 1 To aList.Count
        cmbContactName.AddItem aList.Item(lngIndex)
        cmbContactName.ItemData(cmbContactName.NewIndex) = aList.Key(aList.Item(lngIndex))
    Next
    
    flgLoading = False
End Sub
