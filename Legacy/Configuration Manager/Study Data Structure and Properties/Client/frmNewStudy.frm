VERSION 5.00
Begin VB.Form frmNewStudy 
   Caption         =   "Create New Study"
   ClientHeight    =   3780
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6390
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   3780
   ScaleWidth      =   6390
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox editDescription 
      Height          =   1095
      Left            =   1920
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Text            =   "frmNewStudy.frx":0000
      Top             =   840
      Width           =   3975
   End
   Begin VB.ComboBox cmbClientList 
      Height          =   315
      Left            =   1920
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   2160
      Visible         =   0   'False
      Width           =   3975
   End
   Begin VB.TextBox editName 
      Height          =   315
      Left            =   1920
      TabIndex        =   1
      Top             =   240
      Width           =   1935
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4680
      TabIndex        =   7
      Top             =   3000
      Width           =   1215
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   3360
      TabIndex        =   6
      Top             =   3000
      Width           =   1215
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "Study Description:"
      Height          =   195
      Left            =   420
      TabIndex        =   2
      Top             =   840
      Width           =   1290
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Client Name:"
      Height          =   195
      Left            =   810
      TabIndex        =   4
      Top             =   2160
      Visible         =   0   'False
      Width           =   900
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Study Name:"
      Height          =   195
      Left            =   795
      TabIndex        =   0
      Top             =   240
      Width           =   915
   End
End
Attribute VB_Name = "frmNewStudy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private flgLoading As Boolean
Private flgChanged As Boolean

Public mClientID As Long ' 03-15-2006 SH Added

Private WithEvents objStudy As Study
Attribute objStudy.VB_VarHelpID = -1

Public Sub Component(aStudy As Study)
    
    Set objStudy = aStudy
    
End Sub

Private Sub cmbClientList_Click()
    ' 03-15-2006 SH Removed.
'    If flgLoading Then Exit Sub
'
'    If cmbClientList.ListIndex < 0 Then Exit Sub
'
'    objStudy.Client = cmbClientList.Text

End Sub

Private Sub cmdOK_Click()
    
    Dim aTable As MetaTable
    Dim intCount As Long
    Dim objAudit As New Audit.cAudit
    Dim objEmpId As New getEmpId.GetEmpIdDll
    
    If Not IsScreenValid Then
        MsgBox "Study name must be entered.", , "New Study"
        Exit Sub
    End If
    
    Me.MousePointer = vbHourglass
    
    ' 03-15-2006 SH Added
    objEmpId.RetrieveUserEmployeeID
    
    With objStudy
        .CreationDate = Format$(Now, "m/d/yy")
        .Client = cmbClientList.Text
        .Description = editDescription.Text
        .IsStudyOnGoing = True
        .UseAddressCleaning = True
            .UseProperCase = True
        .CloseDate = Format$(Now, "m/d/yy")
        .ContractStartDate = Format$(Now, "m/d/yy")
        .ContractEndDate = Format$(Now, "m/d/yy")
        .CountryID = objEmpId.UserCountryID
        .ApplyEdit
    End With
    ' End of addition
    
    ' Remove these 2 lines.
    'objStudy.CreationDate = Format$(Now, "m/d/yy")
    'objStudy.ApplyEdit
    'objStudy.BeginEdit
    
    ' Force a load
    For Each aTable In objStudy.MetaTableColl
        intCount = aTable.MetaFieldColl.Count
    Next
    
    objStudy.MetaTableBeginEdit
    Set aTable = objStudy.MetaTableColl.AddPopulationTable
    With aTable
        .BeginEdit
        .AddKeyField
        .AddNewRecordDateField
        .AddLanguageCode
        .AddAgeField        ' 3/21/2000 FG
        .AddGenderField     ' 3/21/2000 FG
        .ApplyEdit
    End With
    objStudy.MetaTableApplyEdit
    
    ' 3/21/2000 FG
    ' add encounter table
    ' add pop_id
    
    ''''''''"We do not want to create encounter table".. As per Phil 10/29/2002
    'objStudy.MetaTableBeginEdit
    'Set aTable = objStudy.MetaTableColl.AddEncounterTable
    'With aTable
    '    .BeginEdit
    '    .AddKeyField
    '    .AddNewRecordDateField
    '    .AddPopIDField
    '    .ApplyEdit
    'End With
    'objStudy.MetaTableApplyEdit
    
    ' 10/5/1999 DV - Adding auditing.
    'objEmpId.RetrieveUserEmployeeID
    
    objAudit.AddInsertedItem editName.Text, STUDY_CREATION, "Study", objStudy.ID
    objAudit.CommitAudit objStudy.ID, 0, objEmpId.UserEmployeeID, "StudyDataClient"
    
    flgChanged = False
    
    Me.MousePointer = vbDefault
    
    Unload Me
    
End Sub

Private Sub cmdCancel_Click()
    
    If flgChanged Then
        If (MsgBox("Do you wish to save changes to this screen", vbYesNo, G_Study.name) = vbYes) Then
            cmdOK_Click
            Exit Sub
        End If
    End If
    
    objStudy.CancelEdit
    Unload Me
    
End Sub

Private Sub editName_Change()
  
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    On Error Resume Next
    
    objStudy.name = editName.Text
    
    If Err Then
        Beep
        intPos = editName.SelStart
        editName.Text = objStudy.name
        editName.SelStart = intPos - 1
    End If

End Sub

Private Sub editName_LostFocus()
    
    If flgLoading Then Exit Sub
  
    editName.Text = objStudy.name

End Sub

Private Sub editDescription_Change()
  
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    On Error Resume Next
    
    objStudy.Description = editDescription.Text
    
    If Err Then
        Beep
        intPos = editDescription.SelStart
        editDescription.Text = objStudy.Description
        editDescription.SelStart = intPos - 1
    End If

End Sub

Private Sub editDescription_LostFocus()
    
    If flgLoading Then Exit Sub
  
    editDescription.Text = objStudy.Description

End Sub

Private Sub Form_Load()
    
    'Dim aFrm As New frmLoadingInfo
    
    'aFrm.Caption = "New Study"
    'aFrm.Show
    Me.MousePointer = vbHourglass
    
    flgLoading = True
    
    LoadClientComboBox
    objStudy.BeginEdit
    flgLoading = False
    
    'Unload aFrm
    'Set aFrm = Nothing
    Me.MousePointer = vbDefault
    
End Sub

Private Sub LoadClientComboBox()
    
    Dim vntItem As Variant
    Dim aList As TextList
    Dim lngIndex As Long
    Dim i As Long
    
    ' 03-15-2006 SH Added
    ' Client Combo box is not visible so the selected client
    ' is behind the scene for Config Manager .NET
    Set aList = G_Study.ClientList
    
    cmbClientList.Clear

    'For Each vntItem In aList
    '  cmbClientList.AddItem vntItem
    'Next
    
    For lngIndex = 1 To aList.Count
        cmbClientList.AddItem aList.Item(lngIndex)
        cmbClientList.ItemData(cmbClientList.NewIndex) = aList.Key(aList.Item(lngIndex))
        If aList.Key(aList.Item(lngIndex)) = mClientID Then i = cmbClientList.NewIndex ' 03-16-2006 SH Added
    Next

    cmbClientList.ListIndex = i ' 03-16-2006 SH Added
End Sub

Private Function IsScreenValid() As Boolean
    ' 03-16-2006 SH Removed
    ' Still need to pass something so the description
    ' will be the same as study name if blank.
'    If Len(Trim$(editName.Text)) > 0 _
'        And Len(Trim$(editDescription.Text)) > 0 _
'        And Len(cmbClientList.Text) > 0 Then
'            IsScreenValid = True
    If Len(Trim$(editName.Text)) > 0 Then
        ' 03-15-2006 SH Added
        If Len(Trim$(editDescription.Text)) = 0 Then
            editDescription.Text = editName.Text
        End If
        IsScreenValid = True
    Else
        IsScreenValid = False
    End If
    
End Function
