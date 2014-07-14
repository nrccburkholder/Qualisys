VERSION 5.00
Begin VB.Form frmRollbackMessage 
   Caption         =   "Rollback Generation?"
   ClientHeight    =   3690
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7995
   Icon            =   "frmRollbackMessage.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3690
   ScaleWidth      =   7995
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtMessage 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   2175
      Left            =   240
      MultiLine       =   -1  'True
      TabIndex        =   2
      Text            =   "frmRollbackMessage.frx":57E2
      Top             =   240
      Width           =   7575
   End
   Begin VB.CommandButton cmdNo 
      Caption         =   "No"
      Default         =   -1  'True
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   6240
      TabIndex        =   0
      Top             =   2760
      Width           =   1455
   End
   Begin VB.CommandButton cmdYes 
      Caption         =   "Yes"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   4560
      TabIndex        =   1
      Top             =   2760
      Width           =   1455
   End
End
Attribute VB_Name = "frmRollbackMessage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public Rollback As Boolean

Private Sub cmdNo_Click()
    Rollback = False
    Unload Me
End Sub

Private Sub cmdYes_Click()
    Rollback = True
    Unload Me
End Sub

