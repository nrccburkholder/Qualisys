VERSION 5.00
Begin VB.Form frmAttachments 
   Caption         =   "Attachments"
   ClientHeight    =   2895
   ClientLeft      =   3870
   ClientTop       =   2595
   ClientWidth     =   6075
   HelpContextID   =   2016086
   Icon            =   "ATTACH.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MDIChild        =   -1  'True
   ScaleHeight     =   2895
   ScaleWidth      =   6075
   ShowInTaskbar   =   0   'False
   Begin VB.ListBox lstTables 
      Height          =   2400
      Left            =   30
      MultiSelect     =   1  'Simple
      Sorted          =   -1  'True
      TabIndex        =   4
      Top             =   15
      Width           =   6000
   End
   Begin VB.PictureBox picButtons 
      Align           =   2  'Align Bottom
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   405
      Left            =   0
      ScaleHeight     =   405
      ScaleWidth      =   6075
      TabIndex        =   0
      Top             =   2484
      Width           =   6075
      Begin VB.CommandButton cmdNew 
         Caption         =   "&New"
         Height          =   330
         Left            =   120
         MaskColor       =   &H00000000&
         TabIndex        =   3
         Top             =   45
         Width           =   1815
      End
      Begin VB.CommandButton cmdReAttach 
         Caption         =   "&ReAttach"
         Height          =   330
         Left            =   2160
         MaskColor       =   &H00000000&
         TabIndex        =   2
         Top             =   45
         Width           =   1845
      End
      Begin VB.CommandButton cmdClose 
         Cancel          =   -1  'True
         Caption         =   "&Close"
         Height          =   330
         Left            =   4200
         MaskColor       =   &H00000000&
         TabIndex        =   1
         Top             =   45
         Width           =   1845
      End
   End
End
Attribute VB_Name = "frmAttachments"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const FORMCAPTION = "Attachments"
Const BUTTON1 = "&New"
Const BUTTON2 = "&ReAttach"
Const BUTTON3 = "&Close"

Sub cmdClose_Click()
  
    Unload Me
    
End Sub

Sub cmdNew_Click()
    
    frmNewAttach.Show vbModal
    
End Sub

Sub cmdReAttach_Click()
  
    On Error GoTo REAErr
    
    Dim i As Integer
    Dim sTmp As String
    
    Screen.MousePointer = vbHourglass
    
    'execute the refreshlink method on all the selected items
    For i = 0 To lstTables.ListCount - 1
        If lstTables.Selected(i) Then
            sTmp = Trim$(Left$(lstTables.Text, InStr(lstTables.Text, vbTab)))
            gwsMainWS.Databases(0).TableDefs(sTmp).RefreshLink
        End If
    Next
    
    MsgBar vbNullString, False
    Screen.MousePointer = vbDefault
    
    Exit Sub
    
REAErr:
    ShowError
    If i > 0 Then
        Resume Next    'try to continue
    End If

End Sub

Sub Form_Load()
  
    On Error GoTo FLErr
    
    Dim tdf As TableDef
    Dim i As Integer
    
    Me.Caption = FORMCAPTION
    cmdNew.Caption = BUTTON1
    cmdReAttach.Caption = BUTTON2
    cmdClose.Caption = BUTTON3
    
    'get the attached tables from the tabledefs collection
    For Each tdf In gwsMainWS.Databases(0).TableDefs
        If (tdf.Attributes And dbAttachedTable) = dbAttachedTable Or _
           (tdf.Attributes And dbAttachedODBC) = dbAttachedODBC Then
            lstTables.AddItem tdf.Name & String(32 - Len(tdf.Name), " ") & vbTab & tdf.SourceTableName & "=>" & tdf.Connect
        End If
    Next
    
    Me.Height = 3360
    Me.Width = 6195
    Me.Top = 1000
    Me.Left = 1000
    
    Screen.MousePointer = vbDefault
    
    Exit Sub
    
FLErr:
    ShowError
    Unload Me

End Sub

Private Sub lstTables_DblClick()
  
    On Error GoTo GTDErr
    
    Screen.MousePointer = vbHourglass
    gwsMainWS.Databases(0).TableDefs(Trim$(Left$(lstTables.Text, InStr(lstTables.Text, vbTab)))).RefreshLink
    Screen.MousePointer = vbDefault
    
    Exit Sub
    
GTDErr:
    ShowError
    '  Resume 'x

End Sub

Private Sub Form_Resize()
  
    On Error Resume Next
    
    If Me.WindowState = 1 Then Exit Sub
    
    lstTables.Width = Me.ScaleWidth - (lstTables.Left * 2)
    lstTables.Height = Me.ScaleHeight - (picButtons.Height + 40)

End Sub

Public Sub AddAttachment()
  
    On Error GoTo AttachErr
    
    Dim sConnect As String
    Dim tbl As TableDef
    Dim i As Integer
    Dim sTmp As String
    
    With frmNewAttach
        If DupeTableName(.txtAttachName.Text) Then
            .txtAttachName.SetFocus
            Exit Sub
        End If
        
        MsgBar "Attaching " & .txtAttachName.Text, True
        Screen.MousePointer = vbHourglass
        sConnect = .GetConnectStr()
        
        'set the properties
        Set tbl = gwsMainWS.Databases(0).CreateTableDef(.txtAttachName.Text)
        tbl.SourceTableName = .cboTableName.Text
        tbl.Connect = sConnect
        
        If .chkSavePassword.Value = vbChecked Then
            tbl.Attributes = dbAttachSavePWD
        End If
        
        If .chkExclusive.Value = vbChecked Then
            tbl.Attributes = tbl.Attributes Or dbAttachExclusive
        End If
        
        gwsMainWS.Databases(0).TableDefs.Append tbl
        
        'make sure and remove it if it was overwritten
        For i = 0 To lstTables.ListCount - 1
            sTmp = Trim$(Left$(lstTables.List(i), InStr(lstTables.List(i), vbTab)))
            If UCase(sTmp) = UCase(.txtAttachName.Text) Then
                lstTables.RemoveItem i
                Exit For
            End If
        Next
        'add it to the list
        lstTables.AddItem .txtAttachName.Text & String(32 - Len(.txtAttachName.Text), " ") & vbTab & .cboTableName.Text & "=>" & sConnect
        
        Screen.MousePointer = vbDefault
        .txtAttachName.Text = vbNullString
        .cboTableName.Text = vbNullString
    End With
    
    MsgBar vbNullString, False
    Screen.MousePointer = vbDefault
    
    Exit Sub
    
AttachErr:
    ShowError
    'Resume 'x

End Sub
