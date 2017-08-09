VERSION 5.00
Begin VB.Form frmSampleSet 
   Caption         =   "Sample Set"
   ClientHeight    =   3195
   ClientLeft      =   315
   ClientTop       =   600
   ClientWidth     =   3735
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   3735
   Begin VB.CommandButton cmdEnter 
      Caption         =   "&Cancel"
      Height          =   615
      Index           =   1
      Left            =   2040
      TabIndex        =   2
      Top             =   2520
      Width           =   1095
   End
   Begin VB.CommandButton cmdEnter 
      Caption         =   "&OK"
      Height          =   615
      Index           =   0
      Left            =   600
      TabIndex        =   1
      Top             =   2520
      Width           =   1095
   End
   Begin VB.ListBox lstSampleSet 
      Height          =   1815
      Left            =   960
      TabIndex        =   0
      Top             =   480
      Width           =   1815
   End
   Begin VB.Label Label1 
      Caption         =   "Select a Sample Set:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   0
      TabIndex        =   3
      Top             =   120
      Width           =   2055
   End
End
Attribute VB_Name = "frmSampleSet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private CN As ADODB.Connection
Private g_intSurvey_id As Long
Private g_intSampleSet_id As Long

Private Sub cmdEnter_Click(Index As Integer)

    If Index = 0 Then
        If lstSampleSet.Text = "" Then
            Beep
            MsgBox "Please Select a Sample Set.", vbExclamation, "Report Manager"
        Else
            g_intSampleSet_id = CLng(lstSampleSet.Text)
            Unload Me
        End If
    Else
        g_intSampleSet_id = 0
        Unload Me
    End If
    
End Sub

Public Property Let DBConnection(ByVal x_CN As ADODB.Connection)
    
    Set CN = x_CN

End Property

Public Property Let Survey_id(ByVal x_Survey_id As Long)
    
    g_intSurvey_id = x_Survey_id

End Property

Public Property Get SampleSet_id() As Long
    
    SampleSet_id = g_intSampleSet_id

End Property

Public Sub Go(frm As VB.Form)

    Dim sql As String
    Dim rs As New ADODB.Recordset
    
    sql = "SELECT SampleSet_id from SampleSet WHERE Survey_id = " & g_intSurvey_id
    Set rs = CN.Execute(sql)
    
    If Not rs.BOF And Not rs.EOF Then
        While Not rs.EOF
            lstSampleSet.AddItem rs("SampleSet_id")
            rs.MoveNext
        Wend
    End If

    rs.Close
    Set rs = Nothing

    If lstSampleSet.ListCount = 0 Then
        MsgBox "There are not Sample Sets for this Survey.  Sample Plan Worksheet cannot be run.", vbExclamation, "Report Manager"
        Unload Me
    Else
        Me.Left = frm.Left + ((frm.Width - Me.Width) / 2)
        Me.Top = frm.Top + ((frm.Height - Me.Height) / 2)
        Me.Show vbModal, frm
    End If
    
End Sub
