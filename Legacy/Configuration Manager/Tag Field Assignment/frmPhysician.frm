VERSION 5.00
Begin VB.Form frmPhysician 
   Caption         =   "Physician Name Exception Mapping"
   ClientHeight    =   1560
   ClientLeft      =   2700
   ClientTop       =   4005
   ClientWidth     =   6405
   LinkTopic       =   "Form1"
   ScaleHeight     =   1560
   ScaleWidth      =   6405
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4440
      TabIndex        =   6
      Top             =   1080
      Width           =   1335
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "&Delete"
      Height          =   375
      Left            =   3120
      TabIndex        =   5
      Top             =   1080
      Width           =   1215
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   1920
      TabIndex        =   4
      Top             =   1080
      Width           =   1095
   End
   Begin VB.ComboBox cmbAvailableFields 
      Height          =   315
      Left            =   3120
      TabIndex        =   2
      Top             =   360
      Width           =   2655
   End
   Begin VB.ComboBox cmbTag 
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   2655
   End
   Begin VB.Label lblAssigned 
      Caption         =   "Assigned Field:"
      Height          =   255
      Left            =   3120
      TabIndex        =   3
      Top             =   120
      Width           =   1335
   End
   Begin VB.Label lblTag 
      Caption         =   "Tag Description:"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "frmPhysician"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public bolEditable As Boolean

Private Sub cmbAvailableFields_KeyPress(KeyAscii As Integer)
    
    KeyAscii = 0

End Sub

Private Sub cmbTag_KeyPress(KeyAscii As Integer)
    
    KeyAscii = 0

End Sub

Private Sub cmdCancel_Click()

    frmPhysician.Hide
    
End Sub

Private Sub cmdDelete_Click()

    'Delete TagException record for the current study
    MousePointer = vbHourglass
    DelTagException frmMain.lngStudyId
    frmPhysician.cmbAvailableFields.Text = ""
    MousePointer = vndefalt
    
End Sub

Private Sub cmdOk_Click()

    If Trim(cmbAvailableFields.Text) <> "" Then
        'Delete current exception record for study
        MousePointer = vbHourglass
        frmMain.dbTagConnection.DelTagException frmMain.lngStudyId
        'Save new PA Name
        SaveFields
    End If

    MousePointer = vbDefault
    frmPhysician.Hide
    
End Sub

Private Sub SaveFields()
    
    Dim oImportWizard As MetadataView.Metadata_View
    Dim varFieldNames As Variant
    Dim X As Long
    
    MousePointer = vbHourglass
    Set oImportWizard = CreateObject("MetadataView.Metadata_View")
    varFieldNames = oImportWizard.mts_fnvnt_Get_Metadata_View(frmMain.lngStudyId)
    
    For X = 0 To UBound(varFieldNames, 2)
        ' If we found a match than save it
        If varFieldNames(3, X) & "." & varFieldNames(4, X) = Trim(cmbAvailableFields.Text) Then
            ' Found the Table and Field Id!
            frmMain.dbTagConnection.DelTagException frmMain.lngStudyId
            If Not cmbTag.ListIndex = -1 Then
                frmMain.dbTagConnection.SetTagExceptions cmbTag.ItemData(cmbTag.ListIndex), Val(varFieldNames(1, X)), Val(varFieldNames(2, X)), frmMain.lngStudyId
            End If
            X = UBound(varFieldNames, 2)
        End If
    Next X
    
    MousePointer = vbNormal
    Set oImportWizard = Nothing
    Set dbTagConnection = Nothing
    
    Exit Sub
   
Skip:
    pstrMsg = "Could not save your data!" & vbCrLf
    pstrMsg = pstrMsg & "ERROR #: " & Err.Number & vbCrLf
    pstrMsg = pstrMsg & "ERROR TEXT: " & Err.Description & vbCrLf & vbCrLf
    pstrMsg = pstrMsg & "Error Saveing Physician Tool." & vbCrLf
    pstrMsg = pstrMsg & "ERROR PROC: SaveFields in frmPhysician.frm" & vbCrLf
    MsgBox pstrMsg
    MousePointer = vbNormal
    Set oImportWizard = Nothing
    Set dbTagConnection = Nothing

End Sub

Public Sub Editable(ByVal ReadWrite As Boolean)
    
    If Not ReadWrite Then
        cmbTag.Enabled = False
        cmbAvailableFields.Enabled = False
        cmdDelete.Enabled = False
    Else
        cmbTag.Enabled = True
        cmbAvailableFields.Enabled = True
        cmdDelete.Enabled = True
    End If

End Sub
