VERSION 5.00
Begin VB.Form frmProperties 
   Caption         =   "Properties for the Field: "
   ClientHeight    =   4035
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6045
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   4035
   ScaleWidth      =   6045
   Begin VB.CheckBox chkPII 
      Caption         =   "PII"
      Height          =   255
      Left            =   840
      TabIndex        =   9
      Top             =   720
      Width           =   3615
   End
   Begin VB.Frame Frame1 
      Caption         =   "Field Properties"
      Height          =   2895
      Left            =   480
      TabIndex        =   2
      Top             =   360
      Width           =   5055
      Begin VB.CheckBox chkAllowUS 
         Caption         =   "Transfer to US"
         Height          =   255
         Left            =   360
         TabIndex        =   10
         Top             =   720
         Width           =   2775
      End
      Begin VB.ComboBox cmbTableName 
         Height          =   315
         Left            =   1920
         Style           =   2  'Dropdown List
         TabIndex        =   7
         Top             =   1815
         Width           =   2655
      End
      Begin VB.ComboBox CmbFieldName 
         Height          =   315
         Left            =   1920
         Style           =   2  'Dropdown List
         TabIndex        =   5
         Top             =   2265
         Width           =   2655
      End
      Begin VB.CheckBox ChkLookupField 
         Caption         =   "Related to another table and field"
         Height          =   255
         Left            =   360
         TabIndex        =   4
         Top             =   1440
         Width           =   2775
      End
      Begin VB.CheckBox chkMatchField 
         Caption         =   "Match Field"
         Height          =   255
         Left            =   360
         TabIndex        =   3
         Top             =   1080
         Width           =   1335
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Related Table"
         Height          =   195
         Left            =   750
         TabIndex        =   8
         Top             =   1875
         Width           =   1005
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "Related Field"
         Height          =   195
         Left            =   825
         TabIndex        =   6
         Top             =   2325
         Width           =   930
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4320
      TabIndex        =   0
      Top             =   3480
      Width           =   1215
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2880
      TabIndex        =   1
      Top             =   3480
      Width           =   1215
   End
End
Attribute VB_Name = "frmProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim rs As ADODB.Recordset
Dim rsPII As ADODB.Recordset
Dim sSql As String
    
Private flgLoading As Boolean
Private flgChanged As Boolean
Private WithEvents objMetaField As MetaField
Attribute objMetaField.VB_VarHelpID = -1

Public Sub Component(aFieldObject As MetaField)
    Set objMetaField = aFieldObject
End Sub

' *** 05-05-2005 SH Added
Private Sub chkPII_Click()
    If chkPII.Value = 1 Then chkAllowUS.Value = 0
    flgChanged = True
End Sub

Private Sub chkAllowUS_Click()
    If chkAllowUS.Value = 1 Then chkPII.Value = 0
    flgChanged = True
End Sub
' *** End of addition

Private Sub cmdOK_Click()
    Dim aTable As MetaTable
    Dim aFld As MetaField
     
    Me.MousePointer = vbHourglass
    
    If cmbTableName.Text = "" And CmbFieldName.Text = "" And ChkLookupField.Value <> 0 Then
        MsgBox "You must choose a related table or a related field before clicking OK"
        Me.MousePointer = vbDefault
    ElseIf cmbTableName.Text <> "" And CmbFieldName.Text = "" And ChkLookupField.Value <> 0 Then
        MsgBox "Please choose a related field."
        Me.MousePointer = vbDefault
    Else
        objMetaField.BeginEdit
        
        ' set the values to the object
        objMetaField.IsMatchField = IIf((chkMatchField.Value = 1), True, False)
        
        If ChkLookupField.Value = 1 Then
            Set aTable = G_Study.MetaTableColl.Item(cmbTableName.ItemData(cmbTableName.ListIndex))
            objMetaField.lookupTableID = aTable.ID
     
            Set aFld = aTable.MetaFieldColl.Item(CmbFieldName.ItemData(CmbFieldName.ListIndex))
            objMetaField.lookupFieldID = aFld.ID
            If aFld.IsKeyField Then
                objMetaField.LookupType = G_FOREIGN_CHAR
            Else
                objMetaField.LookupType = G_LOOKUP_CHAR
            End If
        Else
            ' re-initialize
            objMetaField.lookupTableID = -1
            objMetaField.lookupFieldID = -1
    '        objMetaField.LookupType = ""
        End If
        
        ' *** 05-09-2005 SH Added
        objMetaField.IsPII = IIf((chkPII.Value = 1), True, False)
        ' 08-09-2005 SH Added.
        ' To make sure that if PII is true, AllowUS will be false.
        If chkPII.Value = 1 Then chkAllowUS.Value = 0
    
        objMetaField.IsAllowUS = IIf((chkAllowUS.Value = 1), True, False)
        ' *** End of addition
        
        objMetaField.ApplyEdit
        G_Study.MetaTableApplyEdit
        G_Study.MetaTableBeginEdit
        
        Me.MousePointer = vbDefault
        
        MsgBox "Please be sure to Post everything from the main screen after saving them all.", , G_Study.name
        Unload Me
    End If
End Sub

Private Sub cmdCancel_Click()
    If flgChanged Then
        If (MsgBox("Do you wish to save changes to this screen", vbYesNo, G_Study.name) = vbYes) Then
            cmdOK_Click
        Else
            Unload Me
        End If
    Else
        Unload Me
    End If
End Sub

Private Sub Form_Load()
    Dim aFldList As MetaFieldList
    Dim intIndex As Long
    Dim aTable As MetaTable
    Dim aFld As MetaField
    
    flgLoading = True
    InitializeControls
    LoadLookupTableNames
    
    If cn.State = 0 Then cn.Open strConnection ' 06-07-2005 SH Added
    
    ' set the values from the object
    Set aFldList = G_Study.MetaFieldItems.ListItem(objMetaField.ID)
    
    '* code added by Daniel Wagner to fix issue 391 *'
    'following lines check to see if a mailing date has been set
    '  If one has been set, can't change match fields
    If objMetaField.IsMatchField Then
        chkMatchField.Value = 1
        Set rs = New ADODB.Recordset
        sSql = "If Exists (Select SM.datGenerated from SentMailing SM, ScheduledMailing SchM, " & _
               "SamplePop SP where SM.ScheduledMailing_id = SchM.ScheduledMailing_id " & _
               "and SP.SamplePop_Id = SchM.SamplePop_Id and SP.Study_ID = " & G_Study.ID & ")" & _
               "Select 1 as MyData " & _
               "Else Select 2 as MyData"
                
        rs.Open sSql, cn, adOpenKeyset, adLockBatchOptimistic
        
        If rs!MyData = 2 Then
            chkMatchField.Enabled = True
        Else
            chkMatchField.Enabled = False
        End If
    End If
    
    If aFldList.DataType <> "S" Then
        chkMatchField.Enabled = False
    End If

    ' Following lines disable the check box
    'If aFldList.DataType <> "S" Then
    '    chkMatchField.Enabled = False
    'Else
    '    chkMatchField.Enabled = True
    'End If
    '* end of added code *'
    
    If objMetaField.lookupTableID > 0 Then
        ChkLookupField.Value = 1
        cmbTableName.Enabled = True
        CmbFieldName.Enabled = True
        
        ' show the selected lookup table
        intIndex = 0
        
        While intIndex < cmbTableName.ListCount
            Set aTable = G_Study.MetaTableColl.Item(cmbTableName.ItemData(intIndex))
            If aTable.ID = objMetaField.lookupTableID Then
                cmbTableName.ListIndex = intIndex
                intIndex = cmbTableName.ListCount ' forcing to exit the while loop
            End If
            intIndex = intIndex + 1
        Wend
        
        LoadLookupFieldNames
        
        ' show the selected lookup field
        intIndex = 0
        While intIndex < CmbFieldName.ListCount
            Set aFld = aTable.MetaFieldColl.Item(CmbFieldName.ItemData(intIndex))
            If aFld.ID = objMetaField.lookupFieldID Then
                CmbFieldName.ListIndex = intIndex
                intIndex = CmbFieldName.ListCount ' forcing to exit the while loop
            End If
            intIndex = intIndex + 1
        Wend
    End If
    
    ' *** 05-09-2005 SH Added
    chkPII.Value = IIf(objMetaField.IsPII, 1, 0)
    chkAllowUS.Value = IIf(objMetaField.IsAllowUS, 1, 0)
    
    Dim SQL As String

    Set rsPII = New ADODB.Recordset

    ' Disable PII if bitPII in MetaField is 1 so user cannot change it.
    ' Do not allow user to change PII to false after PII is selected.
    ' Contact Admin to do so.  Or modify here.
    SQL = "Select bitPII From MetaField Where Field_id = " & objMetaField.ID
    rsPII.Open SQL, cn, adOpenKeyset, adLockBatchOptimistic

    If Not rsPII.EOF And Not rsPII.BOF Then
        chkPII.Enabled = Not rsPII!bitpii
        If rsPII!bitpii Then chkPII.Value = 1
    End If
    
    ' 08-09-2005 SH Added
    If chkPII.Value = 1 Then
        chkPII.Enabled = False
        chkAllowUS.Value = 0
        chkAllowUS.Enabled = False
    End If
    
    rsPII.Close
    Set rsPII = Nothing
    ' *** End of addition
        
    flgLoading = False
    flgChanged = False
    
    'Don't need this next line, added code to call it above
    'Set aFldList = G_Study.MetaFieldItems.ListItem(objMetaField.ID)
    Me.Caption = "Properties for the field: " & Trim(aFldList.name)
End Sub

Private Sub InitializeControls()
    chkMatchField.Value = 0
    ChkLookupField.Value = 0
    cmbTableName.Clear
    CmbFieldName.Clear
    cmbTableName.Enabled = False
    CmbFieldName.Enabled = False
    ' *** 05-08-2005 SH Added
    chkPII.Value = 0
    chkAllowUS.Value = 1 ' 08-09-2005 SH Modified
    chkPII.Enabled = False
    chkAllowUS.Enabled = True
    ' *** End of addition
End Sub

Private Sub LoadLookupTableNames()
    Dim aMetaTable As MetaTable
    Dim lngIndex As Long
    
    cmbTableName.Clear
    
    For lngIndex = 1 To G_Study.MetaTableColl.Count
        Set aMetaTable = G_Study.MetaTableColl(lngIndex)
        cmbTableName.AddItem (aMetaTable.name)
        cmbTableName.ItemData(cmbTableName.NewIndex) = lngIndex
    Next
End Sub

Private Sub LoadLookupFieldNames()
    Dim aMetaField As MetaField
    Dim aMetaTable As MetaTable
    Dim aFldList As MetaFieldList
    Dim lngIndex As Long
    
    CmbFieldName.Clear
    
   ' load all the fields for the lookup table
    If cmbTableName.ListIndex <> -1 Then
        Set aMetaTable = G_Study.MetaTableColl.Item(cmbTableName.ItemData(cmbTableName.ListIndex))
        For lngIndex = 1 To aMetaTable.MetaFieldColl.Count
            Set aMetaField = aMetaTable.MetaFieldColl(lngIndex)
            Set aFldList = G_Study.MetaFieldItems.ListItem(aMetaField.ID)
            CmbFieldName.AddItem (aFldList.name)
            CmbFieldName.ItemData(CmbFieldName.NewIndex) = lngIndex
        Next
    End If
End Sub

Private Sub ChkLookupField_Click()
    If ChkLookupField.Value = 0 Then
        cmbTableName.Enabled = False
        CmbFieldName.Enabled = False
    Else
        cmbTableName.Enabled = True
        CmbFieldName.Enabled = True
    End If
     
    flgChanged = True
End Sub

Private Sub chkMatchField_Click()
    flgChanged = True
End Sub

Private Sub CmbFieldName_Change()
    flgChanged = True
End Sub

Private Sub cmbTableName_Click()
    If cmbTableName.ListIndex < 0 Then Exit Sub
    
    LoadLookupFieldNames
    flgChanged = True
End Sub

Private Function IsScreenValid() As Boolean
    IsScreenValid = True
    
    If ChkLookupField.Value = 1 Then
        If (cmbTableName.ListIndex = -1) _
           Or (CmbFieldName.ListIndex = -1) Then
                IsScreenValid = False
        End If
    End If
End Function
