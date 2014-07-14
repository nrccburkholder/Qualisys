VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmSelectInput 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Select Result File"
   ClientHeight    =   2535
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5175
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2535
   ScaleWidth      =   5175
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fraDialog 
      Height          =   1755
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   4935
      Begin VB.TextBox txtLithoLength 
         Height          =   315
         Left            =   2580
         TabIndex        =   7
         Text            =   "10"
         Top             =   1200
         Width           =   2175
      End
      Begin VB.TextBox txtLithoStart 
         Height          =   315
         Left            =   180
         TabIndex        =   5
         Text            =   "24"
         Top             =   1200
         Width           =   2175
      End
      Begin VB.CommandButton cmdCATIDataFile 
         Caption         =   "..."
         Height          =   315
         Left            =   4380
         TabIndex        =   3
         Top             =   480
         Width           =   375
      End
      Begin VB.TextBox txtResultFile 
         Height          =   315
         Left            =   180
         Locked          =   -1  'True
         TabIndex        =   2
         Top             =   480
         Width           =   4155
      End
      Begin VB.Label lblLithoLength 
         Caption         =   "LithoCode Length:"
         Height          =   195
         Left            =   2580
         TabIndex        =   6
         Top             =   960
         Width           =   2175
      End
      Begin VB.Label lblLithoStart 
         Caption         =   "LithoCode Starting Position:"
         Height          =   195
         Left            =   180
         TabIndex        =   4
         Top             =   960
         Width           =   2175
      End
      Begin VB.Label lblCaption 
         Caption         =   "Result File:"
         Height          =   195
         Index           =   0
         Left            =   180
         TabIndex        =   1
         Top             =   240
         Width           =   4575
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   435
      Left            =   3900
      TabIndex        =   9
      Top             =   1980
      Width           =   1155
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   435
      Left            =   2640
      TabIndex        =   8
      Top             =   1980
      Width           =   1155
   End
   Begin MSComDlg.CommonDialog dlgMain 
      Left            =   120
      Top             =   1920
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
End
Attribute VB_Name = "frmSelectInput"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mbOKClicked     As Boolean
    Private meTransferType  As eTransferTypeConstants
    
Private Sub cmdCancel_Click()
    
    OKClicked = False
    Me.Hide
    
End Sub

Private Sub cmdCATIDataFile_Click()
    
    Dim sType As String
    
    'Setup error handler
    On Error GoTo ErrorHandler
    
    'Determine the file type
    Select Case meTransferType
        Case eTransferTypeConstants.ttcHandEntered
            sType = "Hand Entered"
        Case eTransferTypeConstants.ttcNonQualPro
            sType = "Non-QualPro"
    End Select
    
    'Do the dialog
    With dlgMain
        .DialogTitle = sType & " Result File"
        .CancelError = True
        .DefaultExt = ".str"
        .Filter = sType & " Result File (*.str)|*.str|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        txtResultFile.Text = .FileName
    End With
    
Exit Sub


ErrorHandler:
    txtResultFile.Text = ""
    
End Sub

Private Sub cmdOK_Click()
    
    If IsDataValid Then
        OKClicked = True
        Me.Hide
    End If
    
End Sub

Public Property Get OKClicked() As Boolean
    
    OKClicked = mbOKClicked
    
End Property

Public Property Let OKClicked(ByVal bData As Boolean)
    
    mbOKClicked = bData
    
End Property

Public Function IsDataValid() As Boolean
    
    Dim sMsg As String
    
    'Validate the data
    If Len(Trim(txtResultFile.Text)) = 0 Then
        sMsg = "Result File must be selected!"
        txtResultFile.SetFocus
    ElseIf meTransferType = ttcNonQualPro And _
       (Val(txtLithoStart.Text) < 1 Or Val(txtLithoStart.Text) > 999) Then
        sMsg = "LithoCode Starting Position must be between 1 and 999!"
        txtLithoStart.SetFocus
    ElseIf meTransferType = ttcNonQualPro And _
           (Val(txtLithoLength.Text) < 8 Or Val(txtLithoLength.Text) > 10) Then
        sMsg = "LithoCode Length must be between 8 and 10!"
        txtLithoLength.SetFocus
    End If
    
    'Determine return value
    If Len(Trim(sMsg)) = 0 Then
        IsDataValid = True
    Else
        MsgBox sMsg, vbCritical
        IsDataValid = False
    End If
    
End Function

Public Property Get TransferType() As eTransferTypeConstants
    
    TransferType = meTransferType
    
End Property

Public Property Let TransferType(ByVal eData As eTransferTypeConstants)
    
    'Save the property setting
    meTransferType = eData
    
    'Setup the form
    Select Case meTransferType
        Case eTransferTypeConstants.ttcHandEntered
            lblLithoStart.Enabled = False
            txtLithoStart.Enabled = False
            txtLithoStart.BackColor = vbButtonFace
            txtLithoStart.Text = "0"
            lblLithoLength.Enabled = False
            txtLithoLength.Enabled = False
            txtLithoLength.BackColor = vbButtonFace
            txtLithoLength.Text = "0"
            
        Case eTransferTypeConstants.ttcNonQualPro
            lblLithoStart.Enabled = True
            txtLithoStart.Enabled = True
            txtLithoStart.BackColor = vbWindowBackground
            txtLithoStart.Text = "0"
            lblLithoLength.Enabled = True
            txtLithoLength.Enabled = True
            txtLithoLength.BackColor = vbWindowBackground
            txtLithoLength.Text = "10"
            
    End Select
    
End Property

Public Property Get ResultFile() As String
    
    ResultFile = txtResultFile.Text
    
End Property

Private Sub txtLithoLength_GotFocus()
    
    SelectAllText ctrControl:=txtLithoLength
    
End Sub


Private Sub txtLithoLength_KeyPress(nKeyAscii As Integer)
    
    'Allow only integer input
    If nKeyAscii = vbKeyBack Or _
       (nKeyAscii >= Asc("0") And nKeyAscii <= Asc("9")) Then
        'This is a valid key
        'Do nothing
    Else
        'This is an invalid key
        nKeyAscii = 0
        Beep
    End If
    
End Sub


Private Sub txtLithoStart_GotFocus()
    
    SelectAllText ctrControl:=txtLithoStart
    
End Sub


Private Sub txtLithoStart_KeyPress(nKeyAscii As Integer)
    
    'Allow only integer input
    If nKeyAscii = vbKeyBack Or _
       (nKeyAscii >= Asc("0") And nKeyAscii <= Asc("9")) Then
        'This is a valid key
        'Do nothing
    Else
        'This is an invalid key
        nKeyAscii = 0
        Beep
    End If
    
End Sub



Public Property Get LithoStart() As Integer
    
    LithoStart = Val(Trim(txtLithoStart.Text))
    
End Property


Public Property Get LithoLength() As Integer
    
    LithoLength = Val(Trim(txtLithoLength.Text))
    
End Property

