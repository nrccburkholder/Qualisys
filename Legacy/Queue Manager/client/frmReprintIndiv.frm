VERSION 5.00
Begin VB.Form frmReprintIndiv 
   Caption         =   "Reprint Individual Surveys"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   Icon            =   "frmReprintIndiv.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdSort 
      Caption         =   "&Sort"
      Height          =   495
      Left            =   1680
      TabIndex        =   4
      Top             =   2640
      Width           =   1215
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   495
      Left            =   3120
      TabIndex        =   2
      Top             =   2640
      Width           =   1215
   End
   Begin VB.CommandButton cmdPrint 
      Caption         =   "&Print"
      Height          =   495
      Left            =   240
      TabIndex        =   1
      Top             =   2640
      Width           =   1215
   End
   Begin VB.TextBox txtLithoList 
      Height          =   1245
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   120
      Width           =   4455
   End
   Begin VB.ListBox List1 
      Height          =   2205
      ItemData        =   "frmReprintIndiv.frx":164A
      Left            =   120
      List            =   "frmReprintIndiv.frx":164C
      Sorted          =   -1  'True
      TabIndex        =   3
      Top             =   120
      Visible         =   0   'False
      Width           =   4455
   End
End
Attribute VB_Name = "frmReprintIndiv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdClose_Click()
   Unload Me
End Sub

Private Sub cmdPrint_Click()
  MousePointer = vbHourglass
  Call cmdSort_Click
  If MsgBox("Are you sure you want to print the individual reprints now?", vbYesNo, "Reprint Now?") = vbYes Then
      If frmMain.RePrintIndividuals(txtLithoList.Text) Then
          txtLithoList.Text = ""
          Unload Me
      End If
  End If
  MousePointer = vbDefault
End Sub

Public Function ListExists() As Boolean
    ListExists = (txtLithoList.Text)
End Function

Private Sub cmdSort_Click()
    Dim str As String
  
    List1.Clear
    txtLithoList.Text = txtLithoList.Text + Chr(13) + Chr(10)
    
    While InStr(txtLithoList.Text, Chr(13) + Chr(10)) > 0
        str = Trim(Left(txtLithoList.Text, InStr(txtLithoList.Text, Chr(13) + Chr(10)) - 1))
        If str <> "" Then
            If InStr(str, "*") = 0 Then
                List1.AddItem str
            Else
                If InStr(str, "-") = 0 Then
                    List1.AddItem frmMain.DecodeBarcode(Mid(str, 2, 6))
                Else
                    List1.AddItem _
                      frmMain.DecodeBarcode(Mid(Trim(Left(str, InStr(str, "-") - 1)), 2, 6)) & "-" & _
                      frmMain.DecodeBarcode(Mid(Trim(Mid(str, InStr(str, "-") + 1)), 2, 6))
                End If
            End If
        End If
        txtLithoList.Text = Mid(txtLithoList.Text, InStr(txtLithoList.Text, Chr(13) + Chr(10)) + 2)
    Wend
    
    txtLithoList.Text = ""
    str = ""
  
    While List1.ListCount > 0
        If str <> List1.List(0) Then
          txtLithoList.Text = txtLithoList.Text + List1.List(0) + Chr(13) + Chr(10)
          str = List1.List(0)
        End If
        List1.RemoveItem (0)
    Wend
End Sub

Private Sub Form_Resize()
   txtLithoList.Height = frmReprintIndiv.Height - 1185
   txtLithoList.Width = frmReprintIndiv.Width - 345
   cmdPrint.Top = frmReprintIndiv.Height - 960
   cmdSort.Top = cmdPrint.Top
   cmdClose.Top = cmdPrint.Top
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Answer As Integer
    
    Call cmdSort_Click
    If txtLithoList.Text <> "" Then
        Answer = MsgBox("Do you want to mark these lithos as needing reprints?  Pressing 'No' will discard them.", vbYesNoCancel, "Save these?")
        If Answer = vbYes Then
            If frmMain.SetReprintIndividuals(txtLithoList.Text) Then
                txtLithoList.Text = ""
            Else
                Cancel = 1
            End If
        ElseIf Answer = vbCancel Then
            Cancel = 1
        ElseIf Answer = vbNo Then
            txtLithoList.Text = ""
        End If
    End If
End Sub
