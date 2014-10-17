VERSION 5.00
Begin VB.Form frmOptions 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Options"
   ClientHeight    =   3930
   ClientLeft      =   2565
   ClientTop       =   1500
   ClientWidth     =   4350
   Icon            =   "Options.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3930
   ScaleWidth      =   4350
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fraInterval 
      Caption         =   " Timer Options "
      Height          =   1215
      Left            =   120
      TabIndex        =   5
      Top             =   2040
      Width           =   4095
      Begin VB.TextBox txtOverrideInterval 
         Height          =   315
         Left            =   2400
         TabIndex        =   10
         Top             =   720
         Width           =   675
      End
      Begin VB.TextBox txtDefaultInterval 
         BackColor       =   &H8000000F&
         Height          =   315
         Left            =   2400
         Locked          =   -1  'True
         TabIndex        =   7
         TabStop         =   0   'False
         Top             =   300
         Width           =   675
      End
      Begin VB.OptionButton optInterval 
         Caption         =   "Use override setting of:"
         Height          =   315
         Index           =   1
         Left            =   240
         TabIndex        =   9
         Top             =   720
         Width           =   1935
      End
      Begin VB.OptionButton optInterval 
         Caption         =   "Use default setting of:"
         Height          =   315
         Index           =   0
         Left            =   240
         TabIndex        =   6
         Top             =   300
         Width           =   1935
      End
      Begin VB.Label lblCaption 
         Caption         =   "seconds"
         Height          =   255
         Index           =   1
         Left            =   3240
         TabIndex        =   11
         Top             =   780
         Width           =   675
      End
      Begin VB.Label lblCaption 
         Caption         =   "seconds"
         Height          =   255
         Index           =   0
         Left            =   3240
         TabIndex        =   8
         Top             =   360
         Width           =   675
      End
   End
   Begin VB.Frame fraOutputLevel 
      Caption         =   " Message Display Options "
      Height          =   1875
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   4095
      Begin VB.OptionButton optOutputLevel 
         Caption         =   "Show only Error output messages"
         Height          =   315
         Index           =   3
         Left            =   240
         TabIndex        =   4
         Top             =   1380
         Width           =   3735
      End
      Begin VB.OptionButton optOutputLevel 
         Caption         =   "Show only Warning and Error output messages"
         Height          =   315
         Index           =   2
         Left            =   240
         TabIndex        =   3
         Top             =   1020
         Width           =   3735
      End
      Begin VB.OptionButton optOutputLevel 
         Caption         =   "Show all output messages"
         Height          =   315
         Index           =   1
         Left            =   240
         TabIndex        =   2
         Top             =   660
         Width           =   3735
      End
      Begin VB.OptionButton optOutputLevel 
         Caption         =   "Don't show any output messages"
         Height          =   315
         Index           =   0
         Left            =   240
         TabIndex        =   1
         Top             =   300
         Width           =   3735
      End
   End
   Begin VB.PictureBox picOptions 
      BorderStyle     =   0  'None
      Height          =   3780
      Index           =   3
      Left            =   -20000
      ScaleHeight     =   3780
      ScaleWidth      =   5685
      TabIndex        =   16
      TabStop         =   0   'False
      Top             =   480
      Width           =   5685
      Begin VB.Frame fraSample4 
         Caption         =   "Sample 4"
         Height          =   1785
         Left            =   2100
         TabIndex        =   19
         Top             =   840
         Width           =   2055
      End
   End
   Begin VB.PictureBox picOptions 
      BorderStyle     =   0  'None
      Height          =   3780
      Index           =   2
      Left            =   -20000
      ScaleHeight     =   3780
      ScaleWidth      =   5685
      TabIndex        =   15
      TabStop         =   0   'False
      Top             =   480
      Width           =   5685
      Begin VB.Frame fraSample3 
         Caption         =   "Sample 3"
         Height          =   1785
         Left            =   1545
         TabIndex        =   18
         Top             =   675
         Width           =   2055
      End
   End
   Begin VB.PictureBox picOptions 
      BorderStyle     =   0  'None
      Height          =   3780
      Index           =   1
      Left            =   -20000
      ScaleHeight     =   3780
      ScaleWidth      =   5685
      TabIndex        =   14
      TabStop         =   0   'False
      Top             =   480
      Width           =   5685
      Begin VB.Frame fraSample2 
         Caption         =   "Sample 2"
         Height          =   1785
         Left            =   645
         TabIndex        =   17
         Top             =   300
         Width           =   2055
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3120
      TabIndex        =   13
      Top             =   3420
      Width           =   1095
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   1920
      TabIndex        =   12
      Top             =   3420
      Width           =   1095
   End
End
Attribute VB_Name = "frmOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mbOKClicked As Boolean
    
Private Function IsDataValid() As Boolean
    
    Dim sMsg As String
    
    'Check for errors
    If optInterval(itcUseOverrideInterval).Value Then
        If Trim(txtOverrideInterval.Text) = "" Then
            sMsg = "Override Interval must be filled in!"
        End If
    End If
    
    'If an error was encountered then display it and head out of dodge
    If Len(sMsg) > 0 Then
        MsgBox sMsg, vbCritical
        IsDataValid = False
    Else
        IsDataValid = True
    End If
    
End Function

Private Sub cmdCancel_Click()
    
    mbOKClicked = False
    Me.Hide
    
End Sub

Private Sub cmdOK_Click()
    
    If IsDataValid Then
        mbOKClicked = True
        Me.Hide
    End If
    
End Sub

Private Sub optInterval_Click(nIndex As Integer)
    
    With txtOverrideInterval
        Select Case nIndex
            Case itcUseDefaultInterval
                .Enabled = False
                .BackColor = vbButtonFace
            Case itcUseOverrideInterval
                .Enabled = True
                .BackColor = vbWindowBackground
        End Select
    End With
    
End Sub


Private Sub txtOverrideInterval_GotFocus()
    
    With txtOverrideInterval
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
    
End Sub

Private Sub txtOverrideInterval_KeyPress(KeyAscii As Integer)
    
    'Allow only numbers
    If (KeyAscii < Asc("0") Or KeyAscii > Asc("9")) And _
       KeyAscii <> vbKeyBack Then
        Beep
        KeyAscii = 0
    End If
    
End Sub



Public Property Get OutputLevel() As eOutputLevelCodes
    
    Dim lCnt As Long
    
    'Set the output level
    For lCnt = optOutputLevel.LBound To optOutputLevel.UBound
        If optOutputLevel(lCnt).Value Then
            OutputLevel = lCnt
            Exit For
        End If
    Next lCnt
    
End Property

Public Property Let OutputLevel(ByVal eData As eOutputLevelCodes)
    
    optOutputLevel(eData).Value = True
    
End Property

Public Property Get IntervalType() As eIntervalTypeCodes
    
    If optInterval(itcUseDefaultInterval).Value Then
        IntervalType = itcUseDefaultInterval
    Else
        IntervalType = itcUseOverrideInterval
    End If
    
End Property

Public Property Let IntervalType(ByVal eData As eIntervalTypeCodes)
    
    optInterval(eData).Value = True
    
End Property

Public Property Let IntervalDefault(ByVal lData As Long)
    
    txtDefaultInterval.Text = lData / 1000
    
End Property

Public Property Get IntervalOverride() As Long
    
    IntervalOverride = Val(txtOverrideInterval.Text) * 1000
    
End Property

Public Property Let IntervalOverride(ByVal lData As Long)
    
    txtOverrideInterval.Text = lData / 1000
    
End Property

Public Property Get OKClicked() As Boolean
    
    OKClicked = mbOKClicked
    
End Property

