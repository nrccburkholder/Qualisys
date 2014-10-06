VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Begin VB.Form frmStatus 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Question Parsing Status"
   ClientHeight    =   1395
   ClientLeft      =   3555
   ClientTop       =   1410
   ClientWidth     =   5085
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   1395
   ScaleWidth      =   5085
   ShowInTaskbar   =   0   'False
   Begin ComctlLib.StatusBar stbStatus 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   1020
      Width           =   5085
      _ExtentX        =   8969
      _ExtentY        =   661
      SimpleText      =   "Loading Application"
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   1
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            AutoSize        =   1
            Object.Width           =   8945
            MinWidth        =   2
            Text            =   ""
            TextSave        =   ""
            Key             =   ""
            Object.Tag             =   ""
            Object.ToolTipText     =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ProgressBar prgStatusLine 
      Height          =   735
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4815
      _ExtentX        =   8493
      _ExtentY        =   1296
      _Version        =   327682
      Appearance      =   1
   End
End
Attribute VB_Name = "frmStatus"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

