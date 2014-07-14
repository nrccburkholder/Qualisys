VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Begin VB.Form frmStudyDataStruct 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Study Data Structure"
   ClientHeight    =   4695
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8430
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4695
   ScaleWidth      =   8430
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdPost 
      Caption         =   "&Post Study"
      Height          =   400
      Left            =   3120
      TabIndex        =   5
      Top             =   4080
      Width           =   1335
   End
   Begin VB.TextBox editProperties 
      Enabled         =   0   'False
      Height          =   3015
      Left            =   4320
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   600
      Width           =   3855
   End
   Begin VB.CommandButton cmdEditField 
      Caption         =   "&Fields ..."
      Height          =   400
      Left            =   1680
      TabIndex        =   3
      Top             =   4080
      Width           =   1335
   End
   Begin VB.CommandButton cmdEditTable 
      Caption         =   "&Tables ..."
      Height          =   400
      Left            =   240
      TabIndex        =   2
      Top             =   4080
      Width           =   1335
   End
   Begin ComctlLib.TreeView tvwStudyInfo 
      Height          =   3015
      Left            =   120
      TabIndex        =   0
      Top             =   585
      Width           =   3855
      _ExtentX        =   6800
      _ExtentY        =   5318
      _Version        =   327682
      HideSelection   =   0   'False
      LabelEdit       =   1
      LineStyle       =   1
      Sorted          =   -1  'True
      Style           =   6
      BorderStyle     =   1
      Appearance      =   1
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Close"
      Height          =   400
      Left            =   6840
      TabIndex        =   1
      Top             =   4080
      Width           =   1335
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Properties"
      Height          =   195
      Left            =   4320
      TabIndex        =   7
      Top             =   240
      Width           =   705
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Data Structure for the selected study"
      Height          =   195
      Left            =   120
      TabIndex        =   6
      Top             =   240
      Width           =   2595
   End
   Begin ComctlLib.ImageList ImageList1 
      Left            =   4320
      Top             =   5640
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmStudyDataStruct.frx":0000
            Key             =   "folderClose"
            Object.Tag             =   "tagFolderClose"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmStudyDataStruct.frx":005E
            Key             =   ""
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "frmStudyDataStruct"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim aSelectedMetaTable As MetaTable

Private bConcurrencyLock As Boolean

Private Sub cmdCancel_Click()
    If bConcurrencyLock = False Then
        Unload Me
        Exit Sub
    End If
        
    If Not G_Study.IsFullyPosted Then
        If (MsgBox("Do you wish to POST this study", vbYesNo, G_Study.name) = vbYes) Then
            cmdPost_Click
            Exit Sub
        End If
    End If
    
    Set aSelectedMetaTable = Nothing
    G_Study.MetaTableCancelEdit
    Unload Me
End Sub

Private Sub cmdEditField_Click()
    Dim aForm As New frmFields

    aForm.Component aSelectedMetaTable
    aForm.Show vbModal, Me
    RefreshData
End Sub

Private Sub cmdEditTable_Click()
    Dim aForm As New frmTables
    
    aForm.Component G_Study
    aForm.Show vbModal, Me
    RefreshData
End Sub

Private Sub cmdPost_Click()
    Dim sDDL As String
    Dim oMetaTable As MetaTable
    Dim oMetaField As MetaField
    Dim sTable_Name As String: sTable_Name = ""
    Dim bMatchField_flg As Boolean
    Dim bPost As Boolean
        
    On Error GoTo ErrorHandler
    
    Me.MousePointer = vbHourglass

    'Determine whether or not each table has a match field,
    'and record the tables that do not in sTable_nm
    For Each oMetaTable In G_Study.MetaTableColl
        bMatchField_flg = False
        For Each oMetaField In oMetaTable.MetaFieldColl
            If oMetaField.IsMatchField = True Then
                bMatchField_flg = True
                Exit For
            End If
        Next
        
        If bMatchField_flg = False Then
            If sTable_Name <> "" Then
                sTable_Name = sTable_Name & ", "
            End If
            sTable_Name = sTable_Name & oMetaTable.name
        End If
    Next
    
    'Determine whether or not to post
    If sTable_Name = "" Then
        bPost = True
    Else
        If MsgBox("The following tables do not have match fields: " & sTable_Name & ". Are you sure you want to post?", vbYesNo, "Post Study") = vbYes Then
            bPost = True
        Else
            bPost = False
        End If
    End If
    
    'Post the study if all tables have match fields or the
    'user selects yes to the match field posting question
    If bPost = True Then
        sDDL = G_Study.Post
        G_Study.MetaTableApplyEdit
        G_Study.MetaTableBeginEdit
        G_Study.PostToQPDataLoad
        MsgBox "Posted Successfully", , G_Study.name
    End If
    
    Me.MousePointer = vbDefault
    
    Exit Sub
    
ErrorHandler:
    MsgBox "Post Study process failed!", vbCritical, G_Study.name
    Me.MousePointer = vbDefault
End Sub

Private Sub Form_Load()
    'Dim aFrm As New frmLoadingInfo
    
    'aFrm.Caption = "Study Data Structure"
    'aFrm.Show
    
    Me.MousePointer = vbHourglass
    
    RefreshData
    
    Me.Caption = "Data Structures for Study: " & G_Study.name
    'Unload aFrm
    'Set aFrm = Nothing
    Me.MousePointer = vbDefault
    
    If bConcurrencyLock = False Then
        Me.cmdEditTable.Enabled = False
        Me.cmdEditField.Enabled = False
        Me.cmdPost.Enabled = False
    Else
        G_Study.MetaTableBeginEdit
    End If
End Sub

Private Sub RefreshData()
    Dim aTable As MetaTable
    Dim aLookupTable As MetaTable
    Dim aFld As MetaField
    Dim aFldList As MetaFieldList
    Dim aLookupFieldList As MetaFieldList
    Dim aNode As Node
    Dim strTableKey As String
    Dim strFldKey As String
    Dim strLookUpName As String
    Dim lngTableIndex As Long
    Dim lngFieldIndex As Long
    
    Me.MousePointer = vbHourglass
    
    cmdEditField.Enabled = False
    
    tvwStudyInfo.Nodes.Clear
    ' Build the root node
    Set aNode = tvwStudyInfo.Nodes.Add
    aNode.Text = "Study: " + G_Study.name ' CStr(G_Study.ID)
    aNode.Key = "ROOT"
    aNode.Expanded = True
    
    For lngTableIndex = 1 To G_Study.MetaTableColl.Count
        Set aTable = G_Study.MetaTableColl(lngTableIndex)
        ' build the table node
        Set aNode = tvwStudyInfo.Nodes.Add("ROOT", tvwChild)
        aNode.Text = aTable.name
        strTableKey = "T" + Format$(lngTableIndex)
        aNode.Key = strTableKey
        aNode.Expanded = True
        For lngFieldIndex = 1 To aTable.MetaFieldColl.Count
            Set aFld = aTable.MetaFieldColl(lngFieldIndex)
            Set aFldList = G_Study.MetaFieldItems.ListItem(aFld.ID)
            ' build the field node
            Set aNode = tvwStudyInfo.Nodes.Add(strTableKey, tvwChild)
            aNode.Text = aFldList.name
            strFldKey = "F" + Format$(lngTableIndex) + Format$(lngFieldIndex)
            aNode.Key = strFldKey
            aNode.Expanded = True
            
            'Build the relationship node
            If (aFld.lookupTableID > 0) And (aFld.lookupFieldID > 0) Then
                Set aNode = tvwStudyInfo.Nodes.Add(strFldKey, tvwChild)
                Set aLookupTable = G_Study.MetaTableColl.ListItem(aFld.lookupTableID)
                aNode.Text = "Lookup Table: " & aLookupTable.name
                'aNode.Key = "LT" + CStr(aTable.ID) + CStr(aFld.ID) + CStr(aFld.LookUpTableID)
                aNode.Expanded = True
                
                Set aNode = tvwStudyInfo.Nodes.Add(strFldKey, tvwChild)
                Set aLookupFieldList = G_Study.MetaFieldItems.ListItem(aFld.lookupFieldID)
                aNode.Text = "Lookup Field: " & aLookupFieldList.name
                'aNode.Key = "LF" + CStr(aTable.ID) + CStr(aFld.ID) + CStr(aFld.LookUpTableID) + CStr(aFld.LookUpfieldID)
                aNode.Expanded = True
                
                'Set aNode = tvwStudyInfo.Nodes.Add(strFldKey, tvwChild)
                'aNode.Text = "Lookup Type: " & aFld.LookupTypeAsString
                'aNode.Key = "LL" + CStr(aTable.ID)
                'aNode.Expanded = True
            End If
        Next
    Next
    
    Me.MousePointer = vbDefault
End Sub

Private Sub tvwStudyInfo_NodeClick(ByVal Node As ComctlLib.Node)
    Dim aTable As MetaTable
    Dim aFld As MetaField
    Dim aFldList As MetaFieldList
    Dim strKey As String
    Dim nodeType As String
    Dim parentKey  As String
    
    ' separate the key and node type
    nodeType = Left(Node.Key, 1)
    
    If nodeType = "T" Then
        ' it is a table
        strKey = Right(Node.Key, Len(Node.Key) - 1)
        Set aTable = G_Study.MetaTableColl.Item(CLng(strKey))
        Set aSelectedMetaTable = aTable
        editProperties.Text = aTable.DisplayProperties
        If bConcurrencyLock Then _
            cmdEditField.Enabled = True
    ElseIf nodeType = "F" Then
        ' it is a field
        ' split the tableID and Field ID
        ' table id is in the parent key
        parentKey = Right(Node.Parent.Key, Len(Node.Parent.Key) - 1)
        
        strKey = Right(Node.Key, Len(Node.Key) - 1)
        ' field id is the node key with the parent key removed
        strKey = Right(strKey, Len(strKey) - Len(parentKey))
        Set aTable = G_Study.MetaTableColl.Item(CLng(parentKey))
        Set aSelectedMetaTable = aTable
        Set aFld = aTable.MetaFieldColl.Item(CLng(strKey))
        Set aFldList = G_Study.MetaFieldItems.ListItem(aFld.ID)
        editProperties.Text = aFldList.DisplayProperties & aFld.DisplayProperties
        If bConcurrencyLock Then _
            cmdEditField.Enabled = True
    ElseIf nodeType = "R" Then ' it is a root
        strKey = Right(Node.Key, Len(Node.Key) - 1)
        editProperties.Text = G_Study.DisplayProperties
        Set aSelectedMetaTable = Nothing
        cmdEditField.Enabled = False
    Else    ' nodeType = "L". It is a lookup type
        editProperties.Text = ""
        Set aSelectedMetaTable = Nothing
        cmdEditField.Enabled = False
        'strKey = Right(Node.Key, Len(Node.Key) - 2)
        ''field id is the node key with the parent key removed
        'strKey = Right(strKey, Len(strKey) - Len(parentKey))
        'Set aTable = G_Study.MetaTableColl.Item(parentKey)
        'Set aSelectedMetaTable = aTable
        'Set aFld = aTable.MetaFieldColl.Item(strKey)
    End If
End Sub

'Private Sub cmdEditStudyData_Click()
'
'    Set oLockData = New LockData.StudyDataStructures
'    bConcurrencyLock = oLockData.SetLock(G_Study.ID)
'
'    If bConcurrencyLock Then
'        Me.cmdEditTable.Enabled = True
'        Me.cmdEditField.Enabled = True
'        Me.cmdPost.Enabled = True
'
'        cmdEditStudyData.Enabled = False
'        G_Study.MetaTableBeginEdit
'    Else
'        ' dont allow
'        Set oLockData = Nothing
'    End If
'
'End Sub
'

Public Property Let EditMode(aValue As Boolean)
    bConcurrencyLock = aValue
End Property
