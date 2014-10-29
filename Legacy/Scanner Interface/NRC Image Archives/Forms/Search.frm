VERSION 5.00
Object = "{57F57641-590A-11D1-9464-00AA006F7AF1}#1.0#0"; "GSCBOBOX.OCX"
Begin VB.Form frmSearch 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Search"
   ClientHeight    =   5865
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7710
   Icon            =   "Search.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5865
   ScaleWidth      =   7710
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.PictureBox Picture1 
      BackColor       =   &H80000005&
      Height          =   3555
      Left            =   120
      ScaleHeight     =   3495
      ScaleWidth      =   7395
      TabIndex        =   7
      TabStop         =   0   'False
      Top             =   1620
      Width           =   7455
      Begin VB.TextBox txtSelect 
         Appearance      =   0  'Flat
         BorderStyle     =   0  'None
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   735
         Left            =   60
         MultiLine       =   -1  'True
         TabIndex        =   8
         Top             =   60
         Width           =   7275
      End
      Begin VB.TextBox txtFromWhere 
         Appearance      =   0  'Flat
         BorderStyle     =   0  'None
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2655
         Left            =   60
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   9
         Top             =   840
         Width           =   7335
      End
   End
   Begin VB.OptionButton optSearchMode 
      Caption         =   "Advanced Search"
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   6
      Top             =   1320
      Width           =   2115
   End
   Begin VB.OptionButton optSearchMode 
      Caption         =   "Simple Search"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   2115
   End
   Begin VB.Frame fraSimpleSearch 
      Height          =   795
      Left            =   120
      TabIndex        =   1
      Top             =   360
      Width           =   7455
      Begin GSEnhComboBox.GSComboBox cboSearchFor 
         Height          =   315
         Left            =   4860
         TabIndex        =   5
         Top             =   300
         Width           =   2415
         _ExtentX        =   4260
         _ExtentY        =   556
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         AllowNew        =   -1  'True
         ListCount       =   2
         List(0)         =   "NOT NULL"
         List(1)         =   "NULL"
      End
      Begin GSEnhComboBox.GSComboBox cboSearchField 
         Height          =   315
         Left            =   1260
         TabIndex        =   3
         Top             =   300
         Width           =   2415
         _ExtentX        =   4260
         _ExtentY        =   556
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ListCount       =   6
         List(0)         =   "Barcode"
         List(1)         =   "LithoCode"
         List(2)         =   "Archive"
         List(3)         =   "Template"
         List(4)         =   "Batch"
         List(5)         =   "File Name"
      End
      Begin VB.Label lblSimpleSearch 
         Caption         =   "Search For:"
         Height          =   255
         Index           =   0
         Left            =   3900
         TabIndex        =   4
         Top             =   360
         Width           =   975
      End
      Begin VB.Label lblSimpleSearch 
         Caption         =   "Search Field:"
         Height          =   255
         Index           =   1
         Left            =   180
         TabIndex        =   2
         Top             =   360
         Width           =   1095
      End
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   6480
      TabIndex        =   11
      Top             =   5340
      Width           =   1095
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   5280
      TabIndex        =   10
      Top             =   5340
      Width           =   1095
   End
End
Attribute VB_Name = "frmSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mbOKClicked As Boolean
    
Private Function IsDataValid() As Boolean
    
    Dim sMsg As String
    
    If SearchMode = smcSimpleSearch Then
        If Len(cboSearchField.Text) = 0 Then
            sMsg = "Select a Search Field!"
            cboSearchField.SetFocus
        ElseIf Len(cboSearchFor.Text) = 0 Then
            sMsg = "Search For is required!"
            cboSearchFor.SetFocus
        End If
    Else
        If Len(Trim(txtFromWhere.Text)) = 0 Then
            sMsg = "You must supply the FROM and WHERE" & vbCrLf & _
                   "clauses of the SELECT statement!"
            txtFromWhere.SetFocus
        ElseIf InStr(UCase(txtFromWhere.Text), "FROM") = 0 Then
            sMsg = "You must also supply the FROM clause" & vbCrLf & _
                   "of the SELECT statement!"
            txtFromWhere.SetFocus
        ElseIf InStr(UCase(txtFromWhere.Text), "WHERE") = 0 Then
            sMsg = "You must also supply the WHERE clause" & vbCrLf & _
                   "of the SELECT statement!"
            txtFromWhere.SetFocus
        End If
    End If
    
    If Len(sMsg) = 0 Then
        IsDataValid = True
    Else
        IsDataValid = False
        MsgBox sMsg, vbCritical
    End If
    
End Function

Public Property Let SearchField(ByVal sData As String)
    
    Select Case sData
        Case "sBarcode"
            cboSearchField.Text = "Barcode"
        Case "sLithoCode"
            cboSearchField.Text = "LithoCode"
        Case "sArchiveLabel"
            cboSearchField.Text = "Archive"
        Case "sTemplateLabel"
            cboSearchField.Text = "Template"
        Case "sBatchLabel"
            cboSearchField.Text = "Batch"
        Case "sFileName"
            cboSearchField.Text = "File Name"
    End Select
    
End Property

Public Property Get SearchField() As String
    
    Select Case cboSearchField.Text
        Case "Barcode"
            SearchField = "sBarcode"
        Case "LithoCode"
            SearchField = "sLithoCode"
        Case "Archive"
            SearchField = "sArchiveLabel"
        Case "Template"
            SearchField = "sTemplateLabel"
        Case "Batch"
            SearchField = "sBatchLabel"
        Case "File Name"
            SearchField = "sFileName"
    End Select
    
End Property

Public Property Let SearchString(ByVal sData As String)
    
    cboSearchFor.Text = sData
    
End Property


Public Property Get SearchString() As String
    
    SearchString = cboSearchFor.Text
    
End Property

Public Property Get OKClicked() As Boolean
    
    OKClicked = mbOKClicked
    
End Property

Public Property Let OKClicked(ByVal bData As Boolean)
    
    mbOKClicked = bData
    
End Property

Private Sub cmdCancel_Click()
    
    OKClicked = False
    Me.Hide
    
End Sub

Private Sub cmdOK_Click()
    
    If IsDataValid Then
        OKClicked = True
        Me.Hide
    End If
    
End Sub


Public Property Get SearchMode() As eSearchModeConstants
    
    If optSearchMode(smcSimpleSearch).Value Then
        SearchMode = smcSimpleSearch
    Else
        SearchMode = smcAdvancedSearch
    End If
    
End Property

Public Property Let SearchMode(ByVal eData As eSearchModeConstants)
    
    optSearchMode(eData).Value = True
    
End Property

Private Sub optSearchMode_Click(nIndex As Integer)
    
    Select Case nIndex
        Case smcSimpleSearch
            lblSimpleSearch(0).Enabled = True
            lblSimpleSearch(1).Enabled = True
            cboSearchField.Enabled = True
            cboSearchFor.Enabled = True
            txtFromWhere.Enabled = False
        
        Case smcAdvancedSearch
            lblSimpleSearch(0).Enabled = False
            lblSimpleSearch(1).Enabled = False
            cboSearchField.Enabled = False
            cboSearchFor.Enabled = False
            txtFromWhere.Enabled = True
        
    End Select
    
End Sub



Public Property Get SearchSelect() As String
    
    SearchSelect = txtSelect.Text
    
End Property

Public Property Let SearchSelect(ByVal sData As String)
    
    txtSelect.Text = sData
    
End Property

Public Property Get SearchFromWhere() As String
    
    SearchFromWhere = txtFromWhere.Text
    
End Property

Public Property Let SearchFromWhere(ByVal sData As String)
    
    txtFromWhere.Text = sData
    
End Property
