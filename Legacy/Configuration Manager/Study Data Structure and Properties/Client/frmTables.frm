VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form frmTables 
   Caption         =   "Tables  for the Study: "
   ClientHeight    =   6195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7800
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   6195
   ScaleWidth      =   7800
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Height          =   400
      Left            =   3840
      TabIndex        =   16
      Top             =   5520
      Width           =   1095
   End
   Begin VB.CommandButton cmdFields 
      Caption         =   "&Fields ..."
      Height          =   400
      Left            =   120
      TabIndex        =   15
      Top             =   5520
      Width           =   1095
   End
   Begin VB.Frame Frame2 
      Caption         =   "Custom Tables"
      Height          =   4215
      Left            =   120
      TabIndex        =   4
      Top             =   1080
      Width           =   7215
      Begin VB.TextBox editTableName 
         Height          =   315
         Left            =   1680
         MaxLength       =   13
         TabIndex        =   17
         Top             =   240
         Width           =   3495
      End
      Begin ComctlLib.ListView lvwCustomTables 
         Height          =   1575
         Left            =   240
         TabIndex        =   12
         Top             =   2400
         Width           =   6600
         _ExtentX        =   11642
         _ExtentY        =   2778
         View            =   3
         Sorted          =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         _Version        =   327682
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.CommandButton cmdClear 
         Caption         =   "C&lear"
         Height          =   375
         Left            =   5640
         TabIndex        =   11
         Top             =   1800
         Width           =   1215
      End
      Begin VB.CommandButton cmdDelete 
         Caption         =   "&Delete"
         Height          =   375
         Left            =   5640
         TabIndex        =   10
         Top             =   1280
         Width           =   1215
      End
      Begin VB.CommandButton cmdChange 
         Caption         =   "C&hange"
         Height          =   375
         Left            =   5640
         TabIndex        =   9
         Top             =   760
         Width           =   1215
      End
      Begin VB.CommandButton cmdAdd 
         Caption         =   "A&dd"
         Height          =   375
         Left            =   5640
         TabIndex        =   8
         Top             =   240
         Width           =   1215
      End
      Begin VB.TextBox editTableDescription 
         Height          =   975
         Left            =   1680
         MaxLength       =   80
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   6
         Top             =   720
         Width           =   3495
      End
      Begin VB.CheckBox chkCleanAddress 
         Alignment       =   1  'Right Justify
         Caption         =   "Clean Address"
         Height          =   495
         Left            =   480
         TabIndex        =   7
         Top             =   1680
         Width           =   1455
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Table Name"
         Height          =   195
         Left            =   615
         TabIndex        =   18
         Top             =   300
         Width           =   870
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "Table Description"
         Height          =   195
         Left            =   240
         TabIndex        =   5
         Top             =   720
         Width           =   1245
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   400
      Left            =   5040
      TabIndex        =   14
      Top             =   5520
      Width           =   1095
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "&Apply"
      Default         =   -1  'True
      Height          =   400
      Left            =   6240
      TabIndex        =   13
      Top             =   5520
      Width           =   1095
   End
   Begin VB.Frame Frame1 
      Caption         =   "Pre-defined Tables"
      Height          =   855
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7215
      Begin VB.CheckBox chkProvider 
         Caption         =   "Provider"
         Height          =   195
         Left            =   5280
         TabIndex        =   3
         Top             =   360
         Width           =   1335
      End
      Begin VB.CheckBox chkEncounter 
         Caption         =   "Encounter"
         Height          =   195
         Left            =   2640
         TabIndex        =   2
         Top             =   360
         Width           =   1335
      End
      Begin VB.CheckBox chkPopulation 
         Caption         =   "Population"
         Enabled         =   0   'False
         Height          =   195
         Left            =   360
         TabIndex        =   1
         TabStop         =   0   'False
         Top             =   360
         Width           =   1215
      End
   End
End
Attribute VB_Name = "frmTables"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private flgLoading As Boolean
Private flgChanged As Boolean

Private WithEvents objStudy As Study
Attribute objStudy.VB_VarHelpID = -1

Public Sub Component(aStudyObject As Study)
    
    Set objStudy = aStudyObject
    
End Sub

Private Sub chkEncounter_Click()
    
    Dim lstItem As ListItem
    Dim aMetaTable As MetaTable
    
    If flgLoading Then Exit Sub
    
    If chkEncounter.Value = 1 Then  'checked
        Set aMetaTable = objStudy.MetaTableColl.AddEncounterTable
        With aMetaTable
            .BeginEdit
            .AddKeyField
            .AddNewRecordDateField
            .ApplyEdit
        End With
        cmdChange.Enabled = False
        cmdDelete.Enabled = False
        cmdFields.Enabled = False
        flgChanged = True
    Else 'unchecked
        Set lstItem = lvwCustomTables.FindItem(ENCOUNTER_TABLE, lvwText, , lvwWhole)
        Set aMetaTable = objStudy.MetaTableColl(val(lstItem.Key))
        If aMetaTable.IsPosted Then
            MsgBox "Cannot remove posted tables", , G_Study.name
        ElseIf G_Study.IsTableReferenced(aMetaTable.ID) Then
            MsgBox "Cannot remove this table.  It is referenced by other fields in this study.", , G_Study.name
        Else
            objStudy.MetaTableColl.Remove (val(lstItem.Key))
            editTableName.Enabled = True
            flgChanged = True
        End If
    End If
    
    LoadMetaTables
    ClearCustomControls

End Sub

Private Sub chkProvider_Click()
    
    Dim lstItem As ListItem
    Dim aMetaTable As MetaTable
    
    If flgLoading Then Exit Sub
    
    If chkProvider.Value = 1 Then  'checked
        Set aMetaTable = objStudy.MetaTableColl.AddProviderTable
        With aMetaTable
            .BeginEdit
            .AddKeyField
            .AddNewRecordDateField
            .ApplyEdit
        End With

        cmdChange.Enabled = False
        cmdDelete.Enabled = False
        cmdFields.Enabled = False
        flgChanged = True
    Else 'unchecked
        Set lstItem = lvwCustomTables.FindItem(PROVIDER_TABLE, lvwText, , lvwWhole)
        Set aMetaTable = objStudy.MetaTableColl(val(lstItem.Key))
        If aMetaTable.IsPosted Then
            MsgBox "Cannot remove posted tables", , G_Study.name
        ElseIf G_Study.IsTableReferenced(aMetaTable.ID) Then
            MsgBox "Cannot remove this table.  It is referenced by other fields in this study.", , G_Study.name
        Else
            objStudy.MetaTableColl.Remove (val(lstItem.Key))
            editTableName.Enabled = True
            flgChanged = True
        End If
    End If
    
    LoadMetaTables
    ClearCustomControls

End Sub

Private Sub cmdAdd_Click()
    
    Dim aMetaTable As MetaTable
    Dim tableName As String
    
    tableName = Trim(editTableName.Text)
   
    If Len(tableName) < 1 Then
        MsgBox "Please enter a Table Name", , G_Study.name
        Exit Sub
    End If
    
    If IsPreDefinedTable(tableName) Then
        MsgBox "Cannot add a custom table having the same name as a predefined table", , G_Study.name
        Exit Sub
    End If
    
    Set aMetaTable = objStudy.MetaTableColl.AddCustomTable
    With aMetaTable
        .BeginEdit
        .name = tableName
        .Description = Trim(editTableDescription.Text)
        .UsesAddress = IIf((chkCleanAddress.Value = 1), True, False)
        .AddKeyField
        .AddNewRecordDateField
        .ApplyEdit
    End With
    
    flgChanged = True
    
    LoadMetaTables
    ClearCustomControls
    cmdChange.Enabled = False
    cmdDelete.Enabled = False
    cmdFields.Enabled = False

End Sub

Private Sub cmdChange_Click()
    
    Dim aMetaTable As MetaTable
    Dim tableName As String
    
    tableName = Trim(editTableName.Text)
    
    If Len(tableName) < 1 Then
        MsgBox "Please enter a Table Name", , G_Study.name
        Exit Sub
    End If
    
    If editTableName.Enabled = True Then
        If IsPreDefinedTable(tableName) Then
            MsgBox "Cannot change the name of a table to have the same name as a predefined table", , G_Study.name
            Exit Sub
        End If
    End If
    
    Set aMetaTable = objStudy.MetaTableColl(val(lvwCustomTables.SelectedItem.Key))
    
    With aMetaTable
        .BeginEdit
        .name = tableName
        .Description = Trim(editTableDescription.Text)
        .UsesAddress = IIf((chkCleanAddress.Value = 1), True, False)
        .ApplyEdit
    End With
    
    flgChanged = True
    LoadMetaTables
    ClearCustomControls
    editTableName.Enabled = True
    cmdAdd.Enabled = True
    cmdChange.Enabled = False
    cmdDelete.Enabled = False
    cmdFields.Enabled = False
    
End Sub

Private Sub cmdDelete_Click()
    
    Dim aMetaTable As MetaTable
    
    If lvwCustomTables.SelectedItem.Index > -1 Then
        Set aMetaTable = objStudy.MetaTableColl(val(lvwCustomTables.SelectedItem.Key))
        If aMetaTable.IsPosted Then
            MsgBox "Cannot remove posted tables", , G_Study.name
            Exit Sub
        ElseIf G_Study.IsTableReferenced(aMetaTable.ID) Then
            MsgBox "Cannot remove this table.  It is referenced by other fields in this study.", , G_Study.name
            Exit Sub
        Else
            If (MsgBox("Are you sure you want to delete this entry?", vbYesNo, G_Study.name) = vbNo) Then
                Exit Sub
            End If
            
            objStudy.MetaTableColl.Remove val(lvwCustomTables.SelectedItem.Key)
            LoadMetaTables
            
            flgChanged = True
            ClearCustomControls
            ' disable / enable the appropriate buttons
            cmdAdd.Enabled = True
            cmdChange.Enabled = False
            cmdDelete.Enabled = False
            cmdFields.Enabled = False
        End If
    End If

End Sub

Private Sub cmdClear_Click()
    
    ClearCustomControls
    
    ' disable / enable the appropriate buttons
    cmdAdd.Enabled = True
    cmdChange.Enabled = False
    cmdDelete.Enabled = False
    cmdFields.Enabled = False
    editTableName.Enabled = True

End Sub

Private Sub cmdOK_Click()
    
    If Not objStudy.MetaTableColl.IsValid Then
        MsgBox "Only one table can have the clean Addresses bit set.", , G_Study.name
        Exit Sub
    End If
    
    Me.MousePointer = vbHourglass
    objStudy.MetaTableApplyEdit
    objStudy.MetaTableBeginEdit
    Me.MousePointer = vbDefault
    
    Unload Me

End Sub

Private Sub cmdCancel_Click()
    
    If flgChanged Then
        If (MsgBox("Do you wish to save changes to this screen", vbYesNo, G_Study.name) = vbYes) Then
            cmdOK_Click
        End If
    End If
    
    objStudy.MetaTableCancelEdit
    objStudy.MetaTableBeginEdit
    Unload Me

End Sub

Private Sub cmdApply_Click()
    
    cmdClear_Click
    
    If Not objStudy.MetaTableColl.IsValid Then
        MsgBox "Only one table can have the clean Addresses bit set.", , G_Study.name
        Exit Sub
    End If
    
    Me.MousePointer = vbHourglass
    
    objStudy.MetaTableApplyEdit
    objStudy.MetaTableBeginEdit
    LoadMetaTables
    
    flgChanged = False
    Me.MousePointer = vbDefault

End Sub

Private Sub editTableName_LostFocus()
    
    Dim aStr As String
    
    aStr = Trim(editTableName.Text)
    If InStr(1, aStr, " ") > 0 Then
        MsgBox "Table Names cannot have spaces.", , G_Study.name
        editTableName.SetFocus
    ElseIf IsNumeric(Left(aStr, 1)) Then
        MsgBox "Table Names cannot begin with a number.", , G_Study.name
        editTableName.SetFocus
    End If
            
End Sub

Private Sub Form_Load()
    
    flgLoading = True
    
    EnableOK objStudy.IsValid
    
    SetListControlTitles
    LoadMetaTables
    cmdClear_Click
    flgLoading = False
    Me.Caption = "Tables for the study: " & G_Study.name

End Sub

Private Sub EnableOK(flgValid As Boolean)
    
    cmdOK.Enabled = flgValid
    cmdApply.Enabled = flgValid

End Sub

Private Sub lvwCustomTables_BeforeLabelEdit(Cancel As Integer)
    
    Cancel = True

End Sub

Private Sub lvwCustomTables_ItemClick(ByVal Item As ComctlLib.ListItem)

    Dim aMetaTable As MetaTable
    
    ' disable / enable the appropriate buttons
    cmdAdd.Enabled = False
    cmdChange.Enabled = True
    cmdDelete.Enabled = True
    cmdFields.Enabled = True
    
    Set aMetaTable = objStudy.MetaTableColl(val(lvwCustomTables.SelectedItem.Key))
    
    ' populate the custom table info.
    editTableName.Text = aMetaTable.name
    editTableDescription.Text = aMetaTable.Description
    chkCleanAddress.Value = IIf((aMetaTable.UsesAddress = True), 1, 0)

    If aMetaTable.IsPreDefinedTable Then
        editTableName.Enabled = False
        cmdDelete.Enabled = False
    Else
        editTableName.Enabled = True
        cmdDelete.Enabled = True
    End If
      
    If aMetaTable.IsPosted Then
        editTableName.Enabled = False
    End If
        
End Sub

Private Sub objStudy_Valid(IsValid As Boolean)
    
    EnableOK IsValid

End Sub

Private Sub SetListControlTitles()

    Dim colHead As ColumnHeader
    
    ' set the list view properties
    lvwCustomTables.View = lvwReport
    Set colHead = lvwCustomTables.ColumnHeaders.Add()
    colHead.Text = "Table Name"
    colHead.Width = lvwCustomTables.Width * 0.2
    
    Set colHead = lvwCustomTables.ColumnHeaders.Add()
    colHead.Text = "Posted"
    colHead.Width = lvwCustomTables.Width * 0.09

    Set colHead = lvwCustomTables.ColumnHeaders.Add()
    colHead.Text = "Clean Address"
    colHead.Width = lvwCustomTables.Width * 0.15
    
    Set colHead = lvwCustomTables.ColumnHeaders.Add()
    colHead.Text = "Table Description"
    colHead.Width = lvwCustomTables.Width * 0.35
    
End Sub

Private Sub LoadMetaTables()
    
    Dim aMetaTable As MetaTable
    Dim lstItem As ListItem
    Dim lngIndex As Long
        
    flgLoading = True
    
    lvwCustomTables.ListItems.Clear
    chkPopulation.Value = 0
    chkEncounter.Value = 0
    chkProvider.Value = 0
    
    If Not objStudy.MetaTableColl.Count > 0 Then
        flgLoading = False
        Exit Sub
    End If
        
    For lngIndex = 1 To objStudy.MetaTableColl.Count
        Set aMetaTable = objStudy.MetaTableColl(lngIndex)
        Set lstItem = lvwCustomTables.ListItems.Add
        With lstItem
            .Key = Format$(lngIndex) & "K"
            .Text = aMetaTable.name
            .SubItems(1) = IIf(aMetaTable.IsPosted, "X", " ")
            .SubItems(2) = IIf(aMetaTable.UsesAddress, "X", " ")
            .SubItems(3) = aMetaTable.Description
        End With
        
        If aMetaTable.IsPopulationTable Then
            chkPopulation.Value = 1
        ElseIf aMetaTable.IsEncounterTable Then
            chkEncounter.Value = 1
        ElseIf aMetaTable.IsProviderTable Then
            chkProvider.Value = 1
        Else 'it is a custom table.
            ' do nothing
        End If
    Next
    
    flgLoading = False

End Sub

Private Function IsPreDefinedTable(aTableName As String) As Boolean
    
    If (aTableName = POPULATION_TABLE) _
        Or (aTableName = ENCOUNTER_TABLE) _
        Or (aTableName = PROVIDER_TABLE) Then
            IsPreDefinedTable = True
    Else
        IsPreDefinedTable = False
    End If

End Function

Private Sub ClearCustomControls()
    
    editTableName.Text = ""
    editTableDescription.Text = ""
    chkCleanAddress.Value = 0
    cmdFields.Enabled = False

End Sub

Private Sub cmdFields_Click()

    Dim aForm As New frmFields
    Dim aMetaTable As MetaTable
    
    cmdClear_Click

    If flgChanged = True Then
        MsgBox "Please save changes to this screen first.", , G_Study.name
        Exit Sub
    End If
    
    If Not lvwCustomTables.SelectedItem Is Nothing Then
        Set aMetaTable = objStudy.MetaTableColl(val(lvwCustomTables.SelectedItem.Key))
        aForm.Component aMetaTable
        aForm.Show vbModal
    Else
        MsgBox "Please select a table first.", , G_Study.name
    End If

End Sub
