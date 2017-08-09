VERSION 5.00
Begin VB.Form frmSplash 
   BackColor       =   &H00008000&
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   6240
   ClientLeft      =   300
   ClientTop       =   225
   ClientWidth     =   5145
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   Icon            =   "frmSplash.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6240
   ScaleWidth      =   5145
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox picLogo 
      BackColor       =   &H80000009&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   1935
      Left            =   240
      Picture         =   "frmSplash.frx":164A
      ScaleHeight     =   1875
      ScaleWidth      =   2475
      TabIndex        =   0
      Top             =   240
      Width           =   2535
   End
   Begin VB.Label lblReportManager 
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "Report Manager is Loading. One Moment Please"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800000&
      Height          =   1575
      Left            =   360
      TabIndex        =   1
      Top             =   2400
      Width           =   3735
   End
End
Attribute VB_Name = "frmSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
