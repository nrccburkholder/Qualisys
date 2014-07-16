VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Begin VB.Form frmFields 
   Caption         =   "Fields for the Study Table:"
   ClientHeight    =   6495
   ClientLeft      =   -15
   ClientTop       =   345
   ClientWidth     =   6900
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   6495
   ScaleWidth      =   6900
   Begin VB.CommandButton cmdApply 
      Caption         =   "&Apply"
      Height          =   375
      Left            =   5400
      TabIndex        =   9
      Top             =   5760
      Width           =   1215
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2760
      TabIndex        =   8
      Top             =   5760
      Width           =   1215
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   4080
      TabIndex        =   5
      Top             =   5760
      Width           =   1215
   End
   Begin VB.CommandButton cmdEditProperties 
      Caption         =   "&Properties ..."
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   5760
      Width           =   1215
   End
   Begin VB.CommandButton cmdRemove 
      Caption         =   "&Remove"
      Height          =   375
      Left            =   3480
      TabIndex        =   3
      Top             =   2880
      Width           =   1215
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "A&dd "
      Height          =   375
      Left            =   2160
      TabIndex        =   2
      Top             =   2880
      Width           =   1215
   End
   Begin ComctlLib.ListView lvwSelectedFields 
      Height          =   1935
      Left            =   240
      TabIndex        =   1
      Top             =   3600
      Width           =   6375
      _ExtentX        =   11245
      _ExtentY        =   3413
      View            =   2
      Sorted          =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   327682
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin ComctlLib.ListView lvwMasterFields 
      Height          =   2175
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   6375
      _ExtentX        =   11245
      _ExtentY        =   3836
      Sorted          =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   327682
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Selected Fields"
      Height          =   195
      Left            =   240
      TabIndex        =   7
      Top             =   3360
      Width           =   1080
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "List of Available Fields"
      Height          =   195
      Left            =   240
      TabIndex        =   6
      Top             =   120
      Width           =   1560
   End
End
Attribute VB_Name = "frmFields"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private flgLoading As Boolean
Private flgChanged As Boolean

Private WithEvents objMetaTable As MetaTable
Attribute objMetaTable.VB_VarHelpID = -1

Public Sub Component(aMetaTableObject As MetaTable)
    Set objMetaTable = aMetaTableObject
End Sub

Private Sub BuildListViewHeaders()
    Dim colHead As ColumnHeader
    Dim lstItem As ListItem
    
    ' set the list view properties
    lvwMasterFields.View = lvwReport
    Set colHead = lvwMasterFields.ColumnHeaders.Add()
    colHead.Text = "Field Name"
    colHead.Width = lvwMasterFields.Width * 0.48
    
    Set colHead = lvwMasterFields.ColumnHeaders.Add()
    colHead.Text = "Data Type"
    colHead.Width = lvwMasterFields.Width * 0.15
    
    Set colHead = lvwMasterFields.ColumnHeaders.Add()
    colHead.Text = "Field Length"
    colHead.Width = lvwMasterFields.Width * 0.15
    
    lvwSelectedFields.View = lvwReport
    Set colHead = lvwSelectedFields.ColumnHeaders.Add()
    colHead.Text = "Field Name"
    colHead.Width = lvwSelectedFields.Width * 0.38
    
    Set colHead = lvwSelectedFields.ColumnHeaders.Add()
    colHead.Text = "Data Type"
    colHead.Width = lvwSelectedFields.Width * 0.15
    
    Set colHead = lvwSelectedFields.ColumnHeaders.Add()
    colHead.Text = "Field Length"
    colHead.Width = lvwSelectedFields.Width * 0.15

    Set colHead = lvwSelectedFields.ColumnHeaders.Add()
    colHead.Text = "Posted"
    colHead.Width = lvwSelectedFields.Width * 0.09
End Sub

Private Sub Form_Load()
    'disable the buttons
    cmdAdd.Enabled = False
    cmdRemove.Enabled = False
    cmdEditProperties.Enabled = False
    
    BuildListViewHeaders
    LoadSelectedFields
    LoadMasterFieldsList
    
    flgChanged = False
    
    Me.Caption = "Fields for the study table: " & Trim(objMetaTable.name)
End Sub

Private Sub LoadSelectedFields()
    Dim aFld As MetaField
    Dim aFldList As MetaFieldList
    Dim lngIndex As Long
    Dim lstItem As ListItem
    
    lvwSelectedFields.ListItems.Clear
    
    For lngIndex = 1 To objMetaTable.MetaFieldColl.Count
        Set aFld = objMetaTable.MetaFieldColl(lngIndex)
        Set aFldList = G_Study.MetaFieldItems.ListItem(aFld.ID)
        Set lstItem = lvwSelectedFields.ListItems.Add
        lstItem.Text = aFldList.name
        lstItem.SubItems(1) = aFldList.DataType
        If aFldList.hasDBFieldLength Then
            lstItem.SubItems(2) = aFldList.fieldLength
        Else
            lstItem.SubItems(2) = "-"
        End If
        lstItem.SubItems(3) = IIf(aFld.IsPosted, "X", " ")
    
        lstItem.Key = Format$(lngIndex) & "K"
    Next
End Sub

Private Sub LoadMasterFieldsList()
    Dim aFld As MetaFieldList
    Dim lngIndex As Long
    Dim lstItem As ListItem
    
    lvwMasterFields.ListItems.Clear
    
    For lngIndex = 1 To G_Study.MetaFieldItems.Count
        Set aFld = G_Study.MetaFieldItems.Item(lngIndex)
        If Not objMetaTable.MetaFieldColl.ExistsItem(aFld.ID) Then
            Set lstItem = lvwMasterFields.ListItems.Add
            lstItem.Text = aFld.name
            lstItem.SubItems(1) = aFld.DataType
            If aFld.hasDBFieldLength Then
                lstItem.SubItems(2) = aFld.fieldLength
            Else
                lstItem.SubItems(2) = "-"
            End If
            
            lstItem.Key = Format$(lngIndex) & "K"
        End If
    Next
End Sub

Private Sub cmdAdd_Click()
    Dim aFld As MetaFieldList
    Dim iterFldList As MetaFieldList
    Dim aNewFld As MetaField
    Dim aGroupID As Long
    Dim found As Boolean
    Dim itemCount As Integer
    
    If Not lvwMasterFields.SelectedItem Is Nothing Then
        Set aFld = G_Study.MetaFieldItems(val(lvwMasterFields.SelectedItem.Key))
        aGroupID = aFld.GroupID
        
        If aGroupID < 1 Then
            Set aNewFld = objMetaTable.MetaFieldColl.Add
            With aNewFld
                .BeginEdit
                .IsUserField = True
                .IsKeyField = False
                .IsMatchField = False
                .IsPosted = False
                .IsPII = aFld.PII   ' 06-15-2005 SH Added
                .IsAllowUS = Not aFld.PII ' 08-09-2005 SH Modified
                .ID = aFld.ID
                .TableID = objMetaTable.ID
                .ApplyEdit
            End With
        Else
            For Each iterFldList In G_Study.MetaFieldItems
                If iterFldList.GroupID = aGroupID Then
                    ' 04-04-2006 SH Added
                    ' Check if the fields in the group already
                    ' exist in selected list.
                    found = False
                    For itemCount = 1 To Me.lvwSelectedFields.ListItems.Count
                        If iterFldList.name = lvwSelectedFields.ListItems(itemCount).Text Then
                            found = True
                            Exit For
                        End If
                    Next
                    
                    If Not found Then
                        Set aNewFld = objMetaTable.MetaFieldColl.Add
                        With aNewFld
                            .BeginEdit
                            .IsUserField = True
                            .IsKeyField = False
                            .IsMatchField = False
                            .IsPII = aFld.PII
                            .IsAllowUS = Not aFld.PII ' 08-09-2005 SH Modified
                            .IsPosted = False
                            .ID = iterFldList.ID
                            .TableID = objMetaTable.ID
                            .ApplyEdit
                        End With
                    End If
                End If
            Next
        End If
        
        cmdAdd.Enabled = False
        cmdEditProperties.Enabled = False
        
        flgChanged = True
        LoadSelectedFields
        LoadMasterFieldsList
    End If
End Sub

Private Sub cmdRemove_Click()
    Dim strDisplay As String
    Dim aFld As MetaField
    Dim aFldList As MetaFieldList
    Dim aGroupID As Long
    Dim lngIndex As Long
    
    If Not lvwSelectedFields.SelectedItem Is Nothing Then
        Set aFld = objMetaTable.MetaFieldColl(val(lvwSelectedFields.SelectedItem.Key))
        If aFld.IsPosted = True Then
            MsgBox "Posted fields cannot be removed.", , G_Study.name
        ElseIf Not aFld.IsUserField Then
            MsgBox "System generated fields cannot be removed.", , G_Study.name
        ElseIf G_Study.IsFieldReferenced(objMetaTable.ID, aFld.ID) Then
            strDisplay = "Cannot remove this field. It is referenced by the following:" + vbCrLf
            strDisplay = strDisplay & G_Study.FieldReferenceInfo(objMetaTable.ID, aFld.ID)
            MsgBox strDisplay, , G_Study.name
        Else
            Set aFld = objMetaTable.MetaFieldColl(val(lvwSelectedFields.SelectedItem.Key))
            Set aFldList = G_Study.MetaFieldItems.ListItem(aFld.ID)
            aGroupID = aFldList.GroupID
            
            If aGroupID < 1 Then
                objMetaTable.MetaFieldColl.Remove (val(lvwSelectedFields.SelectedItem.Key))
            Else
                For lngIndex = objMetaTable.MetaFieldColl.Count To 1 Step -1
                    Set aFld = objMetaTable.MetaFieldColl(lngIndex)
                    Set aFldList = G_Study.MetaFieldItems.ListItem(aFld.ID)
                    If aGroupID = aFldList.GroupID Then
                        objMetaTable.MetaFieldColl.Remove (lngIndex)
                    End If
                Next
            End If
            
            flgChanged = True
            LoadSelectedFields
            LoadMasterFieldsList
        End If
        
        cmdRemove.Enabled = False
        cmdEditProperties.Enabled = False
    End If
End Sub

Private Sub lvwMasterFields_BeforeLabelEdit(Cancel As Integer)
    Cancel = True
End Sub

Private Sub lvwMasterFields_ItemClick(ByVal Item As ComctlLib.ListItem)
    cmdAdd.Enabled = True
    cmdRemove.Enabled = False
    cmdEditProperties.Enabled = False
End Sub

Private Sub lvwSelectedFields_BeforeLabelEdit(Cancel As Integer)
    Cancel = True
End Sub

Private Sub lvwSelectedFields_ItemClick(ByVal Item As ComctlLib.ListItem)
    cmdAdd.Enabled = False
    cmdRemove.Enabled = True
    cmdEditProperties.Enabled = True
End Sub

Private Sub cmdEditProperties_Click()
    If flgChanged = True Then
        MsgBox "Please save changes to this screen first.", , G_Study.name
        Exit Sub
    End If

    Dim aFld As MetaField
    Dim aForm As New frmProperties
    
    If Not lvwSelectedFields.SelectedItem Is Nothing Then
        Set aFld = objMetaTable.MetaFieldColl(val(lvwSelectedFields.SelectedItem.Key))
        aForm.Component aFld
        aForm.Show vbModal, Me
    End If
End Sub

Private Sub cmdOK_Click()
    cmdApply_Click
    Unload Me
End Sub

Private Sub cmdCancel_Click()
    If flgChanged Then
        If (MsgBox("Do you wish to save changes to this screen", vbYesNo, G_Study.name) = vbYes) Then
            cmdOK_Click
            Exit Sub
        End If
    End If
    
    G_Study.MetaTableCancelEdit
    G_Study.MetaTableBeginEdit
    
    Unload Me
End Sub

Private Sub cmdApply_Click()
    Me.MousePointer = vbHourglass
    G_Study.MetaTableApplyEdit
    G_Study.MetaTableBeginEdit
    
    flgChanged = False
    
    Me.MousePointer = vbDefault
End Sub
