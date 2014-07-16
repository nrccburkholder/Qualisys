VERSION 5.00
Begin VB.Form frmRePrintDates 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Set RePrint LithoCode Range"
   ClientHeight    =   1410
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2745
   ControlBox      =   0   'False
   Icon            =   "frmRePrintDates.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1410
   ScaleWidth      =   2745
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&No"
      Height          =   495
      Left            =   1440
      TabIndex        =   1
      Top             =   840
      Width           =   1215
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Yes"
      Default         =   -1  'True
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblYouSure 
      Caption         =   "Are you sure you want to reprint?"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   240
      TabIndex        =   2
      Top             =   0
      Width           =   2295
   End
End
Attribute VB_Name = "frmRePrintDates"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdOk_Click()
    Me.MousePointer = vbHourglass
    If Not IsEmpty(frmMain.tvTreeView.SelectedItem.Tag) Then
        On Error GoTo BadSelection
        frmMain.RePrintBundles frmMain.tvTreeView.SelectedItem
        frmRePrintDates.Hide
        Me.MousePointer = vbNormal
    Else
BadSelection:
        MsgBox "You must select a paper configuration or a bundle in the tree first!", vbOKOnly, "Error Message"
        frmRePrintDates.Hide
        On Error GoTo 0
        Me.MousePointer = vbNormal
    End If
    Unload Me
End Sub

