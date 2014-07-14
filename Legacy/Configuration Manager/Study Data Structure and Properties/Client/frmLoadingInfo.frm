VERSION 5.00
Begin VB.Form frmLoadingInfo 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "caption"
   ClientHeight    =   1125
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   3810
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1125
   ScaleWidth      =   3810
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Label lblLoadInfo 
      AutoSize        =   -1  'True
      Caption         =   "Loading Data.  Please Wait ..."
      Height          =   195
      Left            =   720
      TabIndex        =   0
      Top             =   360
      Width           =   2130
   End
End
Attribute VB_Name = "frmLoadingInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    
    Me.MousePointer = vbHourglass

End Sub

Private Sub Form_Unload(Cancel As Integer)
    
    Me.MousePointer = vbDefault

End Sub

