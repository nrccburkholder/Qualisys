VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Begin VB.Form frmStatus 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Saving Tag Field Locations..."
   ClientHeight    =   1185
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   4470
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1185
   ScaleWidth      =   4470
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin ComctlLib.ProgressBar ProgressBar1 
      Height          =   495
      Left            =   240
      Negotiate       =   -1  'True
      TabIndex        =   0
      Top             =   480
      Width           =   3855
      _ExtentX        =   6800
      _ExtentY        =   873
      _Version        =   327682
      Appearance      =   1
      MousePointer    =   11
   End
   Begin VB.Label txtMax 
      Caption         =   "0"
      Height          =   255
      Left            =   3120
      TabIndex        =   4
      Top             =   120
      Width           =   615
   End
   Begin VB.Label txtValue 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   255
      Left            =   2040
      TabIndex        =   3
      Top             =   120
      Width           =   495
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "of"
      Height          =   255
      Left            =   2640
      TabIndex        =   2
      Top             =   120
      Width           =   375
   End
   Begin VB.Label Label1 
      Caption         =   "Processing Question"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   120
      Width           =   1575
   End
End
Attribute VB_Name = "frmStatus"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


