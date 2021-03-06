VERSION 5.00
Begin VB.Form frmSQL 
   Caption         =   "SQL Statement"
   ClientHeight    =   2880
   ClientLeft      =   3690
   ClientTop       =   1575
   ClientWidth     =   5130
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   HelpContextID   =   2016144
   Icon            =   "SQL.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MDIChild        =   -1  'True
   ScaleHeight     =   2863.353
   ScaleMode       =   0  'User
   ScaleWidth      =   5147.588
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdSaveQueryDef 
      Caption         =   "&Save"
      Height          =   375
      Left            =   3375
      MaskColor       =   &H00000000&
      TabIndex        =   3
      Top             =   30
      Visible         =   0   'False
      Width           =   1695
   End
   Begin VB.CommandButton cmdExecuteSQL 
      Caption         =   "&Execute"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   375
      Left            =   15
      MaskColor       =   &H00000000&
      TabIndex        =   1
      Top             =   30
      Width           =   1575
   End
   Begin VB.CommandButton cmdClearSQL 
      Caption         =   "&Clear"
      Height          =   375
      Left            =   1695
      MaskColor       =   &H00000000&
      TabIndex        =   2
      Top             =   30
      Width           =   1575
   End
   Begin VB.TextBox txtSQLStatement 
      BackColor       =   &H00FFFFFF&
      Height          =   2175
      Left            =   15
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   435
      Width           =   5055
   End
End
Attribute VB_Name = "frmSQL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const FORMCAPTION = "SQL Statement"
Const BUTTON1 = "&Execute"
Const BUTTON2 = "&Clear"
Const BUTTON3 = "&Save"
Const MSG1 = "Update"
Const MSG2 = "Enter QueryDef Name:"
Const MSG3 = "Is this a SQLPassThrough QueryDef?"
Const MSG4 = "Enter Connect property value:"
Const MSG5 = "Is the Query Row Returning?"

Private Sub cmdClearSQL_Click()
    
    txtSQLStatement.Text = vbNullString
    txtSQLStatement.SetFocus

End Sub

Private Sub cmdSaveQueryDef_Click()
  
    On Error GoTo SQDErr
    
    Dim sQueryName As String
    Dim sTmp As String
    Dim qdNew As QueryDef
    
    If Not gnodDBNode Is Nothing Then
        If gnodDBNode.Tag = QUERY_STR Then
            'a querydef is selected so user may want to update it's SQL
            If MsgBox(MSG1 & " '" & gnodDBNode.Text & "'?", vbYesNo + vbQuestion) = vbYes Then
                'store the SQL from the SQL Window in the currently
                'selected querydef
                If gwsMainWS.Type = dbUseODBC Then
                    gwsMainWS.Connections(0).QueryDefs(gnodDBNode.Text).SQL = Me.txtSQLStatement.Text
                Else
                    gwsMainWS.Databases(0).QueryDefs(gnodDBNode.Text).SQL = Me.txtSQLStatement.Text
                End If
                Exit Sub
            End If
        End If
    End If
    
    'either there is no current querydef selected or the user
    'didn't want to update the current one so we need
    'to propmpt for a new name
    sQueryName = InputBox(MSG2)
    If Len(sQueryName) = 0 Then Exit Sub
    
    'check for a dupe and exit if the user won't overwrite it
    If DupeTableName(sQueryName) Then
        Exit Sub
    End If
      
    'add the new querydef
    If gwsMainWS.Type = dbUseODBC Then
        Set qdNew = gwsMainWS.Connections(0).CreateQueryDef(sQueryName)
    Else
        Set qdNew = gwsMainWS.Databases(0).CreateQueryDef(sQueryName)
    End If
    
    'prompt for passthrough querydef
    If MsgBox(MSG3, vbYesNo + vbQuestion + vbDefaultButton2) = vbYes Then
        sTmp = InputBox(MSG4)
        If Len(sTmp) > 0 Then
            qdNew.Connect = sTmp
            If MsgBox(MSG5, vbYesNo + vbQuestion) = vbNo Then
                qdNew.ReturnsRecords = False
            End If
        End If
    End If
    
    qdNew.SQL = txtSQLStatement.Text
    
    If gwsMainWS.Type = dbUseODBC Then
        gwsMainWS.Connections(0).QueryDefs.Refresh
    Else
        gwsMainWS.Databases(0).QueryDefs.Refresh
    End If
    
    Set gwsActiveWS = gwsMainWS
    RefreshTables Nothing, frmDatabase 'just in case some were added
    
    'RefreshTables Nothing, gwsmainws.databases(0), frmDatabase
    
    Exit Sub
    
SQDErr:
    ShowError

End Sub

Private Sub Form_Unload(Cancel As Integer)
  
    ' only save the sql text if there are no carriage returns in it
    ' because they are not preserved in the INI file
    'If InStr(frmSQL.txtSQLStatement.Text, Chr(13)) = 0 Then
        SaveSetting APP_CATEGORY, App.Title, "SQLStatement", frmSQL.txtSQLStatement.Text
    'End If
    
    If frmSQL.WindowState = vbNormal Then
        SaveSetting APP_CATEGORY, App.Title, "SQLWindowTop", frmSQL.Top
        SaveSetting APP_CATEGORY, App.Title, "SQLWindowLeft", frmSQL.Left
        SaveSetting APP_CATEGORY, App.Title, "SQLWindowWidth", frmSQL.Width
        SaveSetting APP_CATEGORY, App.Title, "SQLWindowHeight", frmSQL.Height
    End If

End Sub

Private Sub txtSQLStatement_Change()
    
    cmdExecuteSQL.Enabled = Len(txtSQLStatement.Text) > 0
    
End Sub

Private Sub cmdExecuteSQL_Click()
  
    If Len(txtSQLStatement.Text) = 0 Then Exit Sub
    
    OpenQuery txtSQLStatement.Text, True

End Sub

Private Sub Form_Load()
  
    Me.Caption = FORMCAPTION
    cmdExecuteSQL.Caption = BUTTON1
    cmdClearSQL.Caption = BUTTON2
    cmdSaveQueryDef.Caption = BUTTON3
    
    txtSQLStatement.Text = GetINIString("SQLStatement", vbNullString)
    
    Me.Height = Val(GetINIString("SQLWindowHeight", "3000"))
    Me.Width = Val(GetINIString("SQLWindowWidth", "5370"))
    Me.Top = Val(GetINIString("SQLWindowTop", "0"))
    Me.Left = Val(GetINIString("SQLWindowLeft", "3850"))

End Sub

Private Sub Form_Resize()
  
    On Error Resume Next
    
    If WindowState <> vbMinimized Then
        txtSQLStatement.Width = Me.ScaleWidth - (txtSQLStatement.Left * 2)
        txtSQLStatement.Height = Me.ScaleHeight - (txtSQLStatement.Top + 50)
    End If

End Sub

Private Sub txtSQLStatement_DragDrop(Source As Control, x As Single, y As Single)
  
    If Source = frmDatabase.tvDatabase Then
        If gwsMainWS.Type = dbUseODBC Then
            frmSQL.txtSQLStatement.Text = gwsMainWS.Connections(0).QueryDefs(gnodDBNode.Text).SQL
        Else
            frmSQL.txtSQLStatement.Text = gwsMainWS.Databases(0).QueryDefs(gnodDBNode.Text).SQL
        End If
    End If

End Sub
