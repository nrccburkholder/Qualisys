VERSION 5.00
Begin VB.Form frmCopyStruct 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Copy Structure"
   ClientHeight    =   3300
   ClientLeft      =   1380
   ClientTop       =   1650
   ClientWidth     =   6525
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   HelpContextID   =   2016121
   Icon            =   "CPYSTRU.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2873.239
   ScaleMode       =   0  'User
   ScaleWidth      =   6436.072
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox chkCopyData 
      Caption         =   "Copy Data   "
      Height          =   255
      Left            =   3120
      MaskColor       =   &H00000000&
      TabIndex        =   9
      Top             =   2160
      Width           =   3135
   End
   Begin VB.TextBox txtDatabase 
      BackColor       =   &H00FFFFFF&
      Height          =   285
      Left            =   3045
      TabIndex        =   1
      Top             =   420
      Width           =   3375
   End
   Begin VB.CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "&Close"
      Height          =   375
      Left            =   4800
      MaskColor       =   &H00000000&
      TabIndex        =   4
      Top             =   2730
      Width           =   1575
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3000
      MaskColor       =   &H00000000&
      TabIndex        =   3
      Top             =   2730
      Width           =   1575
   End
   Begin VB.TextBox txtConnect 
      BackColor       =   &H00FFFFFF&
      Height          =   540
      Left            =   3045
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   1155
      Width           =   3375
   End
   Begin VB.CheckBox chkCopyIndexes 
      Caption         =   "Copy Indexes"
      Height          =   255
      Left            =   3120
      MaskColor       =   &H00000000&
      TabIndex        =   2
      Top             =   1800
      Value           =   1  'Checked
      Width           =   3165
   End
   Begin VB.ListBox lstTables 
      BackColor       =   &H00FFFFFF&
      Height          =   2400
      Left            =   105
      MultiSelect     =   2  'Extended
      Sorted          =   -1  'True
      TabIndex        =   5
      Top             =   360
      Width           =   2775
   End
   Begin VB.Label lblLabels 
      AutoSize        =   -1  'True
      Caption         =   "(Note:Export is Faster)"
      Height          =   195
      Index           =   3
      Left            =   3360
      TabIndex        =   10
      Top             =   2400
      Width           =   1665
   End
   Begin VB.Label lblLabels 
      AutoSize        =   -1  'True
      Caption         =   " Target Connect String: "
      Height          =   195
      Index           =   2
      Left            =   3045
      TabIndex        =   8
      Top             =   840
      Width           =   1740
   End
   Begin VB.Label lblLabels 
      AutoSize        =   -1  'True
      Caption         =   " Target Database: "
      Height          =   195
      Index           =   1
      Left            =   3045
      TabIndex        =   7
      Top             =   105
      Width           =   1365
   End
   Begin VB.Label lblLabels 
      AutoSize        =   -1  'True
      Caption         =   " Tables: "
      Height          =   195
      Index           =   0
      Left            =   105
      TabIndex        =   6
      Top             =   105
      Width           =   615
   End
End
Attribute VB_Name = "frmCopyStruct"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const FORMCAPTION = "Copy Structure"
Const BUTTON1 = "&OK"
Const BUTTON2 = "&Close"
Const LABEL0 = "Tables:"
Const Label1 = "Target Database:"
Const Label2 = "Target Connect String:"
Const LABEL3 = "(Note: Export is Faster)"
Const CHKBOX1 = "Copy Indexes"
Const CHKBOX2 = "Copy Data"
Const MSG1 = "Copying Table(s)"
Const MSG2 = "Enter New Table Name:"
Const MSG3 = "Copy of Data was Unsuccessful!"
Const MSG4 = "Copy of Structure was Successful!"

Private Sub cmdClose_Click()
  
    Set gwsActiveWS = gwsMainWS
    RefreshTables Nothing, frmDatabase 'just in case some were added
    Unload Me

End Sub

Private Sub Form_Load()
  
    Dim i As Integer
    
    Me.Caption = FORMCAPTION
    cmdOK.Caption = BUTTON1
    cmdClose.Caption = BUTTON2
    lblLabels(0).Caption = LABEL0
    lblLabels(1).Caption = Label1
    lblLabels(2).Caption = Label2
    lblLabels(3).Caption = LABEL3
    chkCopyIndexes.Caption = CHKBOX1
    chkCopyData.Caption = CHKBOX2
        
    Set gwsActiveWS = gwsMainWS
    RefreshTables Nothing, frmDatabase 'just in case some were added
        
    txtDatabase.Text = gsDBName
    txtConnect.Text = gwsMainWS.Databases(0).Connect
    
    'select the table that was selected on the database form
    For i = 0 To lstTables.ListCount - 1
        If lstTables.List(i) = gnodDBNode.Text Then
            lstTables.Selected(i) = True
            Exit For
        End If
    Next

End Sub

Private Sub cmdOK_Click()
  
    Dim i As Integer
    Dim bDifferentDB As Integer
    Dim sToName As String
    Dim dbToDatabase As Database
    
    On Error GoTo OkayErr
    
    MsgBar MSG1, True
    
    Screen.MousePointer = vbHourglass
    
    If Len(txtDatabase.Text) = 0 Or txtDatabase.Text = gsDBName Then
        Set dbToDatabase = gwsMainWS.Databases(0)
        bDifferentDB = False
    Else
        Set dbToDatabase = gwsMainWS.OpenDatabase(txtDatabase.Text, False, False, txtConnect.Text)
        dbToDatabase.QueryTimeout = glQueryTimeout
        bDifferentDB = True
    End If
    
    For i = 0 To lstTables.ListCount - 1
        If lstTables.Selected(i) Then
            If bDifferentDB = False Then
                sToName = InputBox(MSG2)
                If Len(sToName) = 0 Then GoTo SkipIt
            Else
                sToName = (StripConnect(lstTables.List(i)))
            End If
        Else
            GoTo SkipIt
        End If
        
        Screen.MousePointer = vbHourglass
        If CopyStruct(gwsMainWS.Databases(0), dbToDatabase, (StripConnect(lstTables.List(i))), sToName, (chkCopyIndexes)) Then
            If chkCopyData = 1 Then
                If CopyData(gwsMainWS.Databases(0), dbToDatabase, (StripConnect(lstTables.List(i))), sToName) = False Then
                    Beep
                    MsgBox (StripConnect(lstTables.List(i))) & ": " & MSG3, vbInformation, Me.Caption
                End If
            End If
            Screen.MousePointer = vbDefault
            MsgBox (StripConnect(lstTables.List(i))) & ": " & MSG4, vbInformation, Me.Caption
            lstTables.Selected(i) = False
        Else
            Screen.MousePointer = vbDefault
            Beep
            MsgBox (StripConnect(lstTables.List(i))) & ": " & MSG3, vbInformation, Me.Caption
        End If
    
SkipIt:
    Next
    MsgBar vbNullString, False
    
    Exit Sub
    
OkayErr:
    ShowError

End Sub
