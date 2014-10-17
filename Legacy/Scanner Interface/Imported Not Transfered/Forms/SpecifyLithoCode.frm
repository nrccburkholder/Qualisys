VERSION 5.00
Object = "{BC691F0A-3A98-11D1-9464-00AA006F7AF1}#5.0#0"; "GSEnhLV.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmSpecifyLithoCode 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Specify LithoCodes"
   ClientHeight    =   4215
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6330
   Icon            =   "SpecifyLithoCode.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4215
   ScaleWidth      =   6330
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   435
      Left            =   3900
      TabIndex        =   10
      Top             =   3660
      Width           =   1095
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   435
      Left            =   5100
      TabIndex        =   11
      Top             =   3660
      Width           =   1095
   End
   Begin VB.Frame fraInput 
      Caption         =   " Input LithoCodes "
      Height          =   2235
      Left            =   3660
      TabIndex        =   5
      Tag             =   "LithoCode"
      Top             =   1260
      Width           =   2535
      Begin VB.CommandButton cmdClipboard 
         Caption         =   "Paste From Clipboard"
         Height          =   435
         Left            =   180
         TabIndex        =   8
         Top             =   1080
         Width           =   2175
      End
      Begin VB.CommandButton cmdImport 
         Caption         =   "Import From File"
         Height          =   435
         Left            =   180
         TabIndex        =   9
         Top             =   1620
         Width           =   2175
      End
      Begin VB.CommandButton cmdAdd 
         Caption         =   "Add"
         Default         =   -1  'True
         Height          =   315
         Left            =   1800
         TabIndex        =   7
         Top             =   300
         Width           =   555
      End
      Begin VB.TextBox txtInput 
         Height          =   315
         Left            =   180
         TabIndex        =   6
         Top             =   300
         Width           =   1635
      End
   End
   Begin VB.Frame fraInputOptions 
      Caption         =   " Input Options "
      Height          =   1095
      Left            =   3660
      TabIndex        =   2
      Top             =   60
      Width           =   2535
      Begin VB.OptionButton optInputType 
         Caption         =   "Input as Barcodes"
         Height          =   255
         Index           =   1
         Left            =   180
         TabIndex        =   4
         Top             =   660
         Width           =   2235
      End
      Begin VB.OptionButton optInputType 
         Caption         =   "Input as LithoCodes"
         Height          =   255
         Index           =   0
         Left            =   180
         TabIndex        =   3
         Top             =   300
         Value           =   -1  'True
         Width           =   2235
      End
   End
   Begin VB.Frame fraLithoCodes 
      Caption         =   " LithoCodes To Be Processed "
      Height          =   3435
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   3375
      Begin GSEnhListView.GSListView lvwLithoCodes 
         Height          =   2955
         Left            =   180
         TabIndex        =   1
         TabStop         =   0   'False
         Top             =   300
         Width           =   3015
         _ExtentX        =   5318
         _ExtentY        =   5212
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         LabelEdit       =   1
         MouseIcon       =   "SpecifyLithoCode.frx":0442
         View            =   3
         FullRowSelect   =   -1  'True
         GridLines       =   -1  'True
         SortType        =   2
      End
   End
   Begin MSComDlg.CommonDialog dlgMain 
      Left            =   2040
      Top             =   3660
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
End
Attribute VB_Name = "frmSpecifyLithoCode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mbOKClicked As Boolean
    
    Private Const mknMaximumLithos As Integer = 480
Public Property Get LithoInList() As String
    
    Dim sInList As String
    Dim oItem As GSEnhListView.GSListItem
    
    For Each oItem In lvwLithoCodes.ListItems
        sInList = sInList & IIf(Len(sInList) = 0, "", "','") & oItem.Text
    Next oItem
    
    Set oItem = Nothing
    LithoInList = "'" & sInList & "'"
    
End Property

Private Sub cmdAdd_Click()
    
    Dim sLithoCode As String
    Dim sBarCode As String
    Dim sMsg As String
    Dim oItem As GSEnhListView.GSListItem
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Check to see if we have reached the maximum
    If lvwLithoCodes.ListItems.Count >= mknMaximumLithos Then
        sMsg = "You have reached the maximum of " & mknMaximumLithos & " " & fraInput.Tag & "s!"
        MsgBox sMsg, vbExclamation, "Maximum Reached"
        Exit Sub
    End If
    
    'Get the values
    Select Case fraInput.Tag
        Case "LithoCode"
            sLithoCode = Trim(txtInput.Text)
            sBarCode = Crunch(lLithoCode:=sLithoCode)
            
        Case "Barcode"
            sBarCode = Left(Trim(txtInput.Text), 6)
            sLithoCode = UnCrunch(sBarCode:=sBarCode)
            
    End Select
    
    'Add them to the list
    If lvwLithoCodes.ListItems("SM" & sLithoCode) Is Nothing Then
        Set oItem = lvwLithoCodes.ListItems.Add(, "SM" & sLithoCode, sLithoCode, , "Litho")
        oItem.SubItems(1) = sBarCode
    Else
        sMsg = fraInput.Tag & " " & IIf(fraInput.Tag = "LithoCode", sLithoCode, sBarCode) & " already exists in the list!"
        MsgBox sMsg, vbInformation
    End If
    
    'Cleanup
    Set oItem = Nothing
    
    'Set the focus for next input
    cmdAdd.SetFocus
    txtInput.SetFocus
    
Exit Sub


ErrorHandler:
    MsgBox "Invalid " & fraInput.Tag & " Encountered!" & vbCrLf & vbCrLf & "Please try again.", vbCritical
    cmdAdd.SetFocus
    txtInput.SetFocus
    
End Sub

Private Sub cmdCancel_Click()
    
    OKClicked = False
    Me.Hide
    
End Sub

Private Sub cmdClipboard_Click()
    
    Dim sMsg        As String
    Dim sTemp       As String
    Dim sLithoCode  As String
    Dim sBarCode    As String
    Dim oToken      As CToken
    Dim oItem       As GSEnhListView.GSListItem
    Dim nDuplicates As Integer
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Get the contents of the clipboard
    sTemp = Clipboard.GetText(vbCFText)
    Set oToken = New CToken
    oToken.Delimiter = vbCrLf
    oToken.ParseString = sTemp
    
    'Add them to the list
    nDuplicates = 0
    Do Until oToken.IsFinished
        'Get the next token
        sTemp = Trim(oToken.GetNextToken)
        
        If Len(sTemp) > 0 Then
            'Get the values
            Select Case fraInput.Tag
                Case "LithoCode"
                    sLithoCode = sTemp
                    sBarCode = Crunch(lLithoCode:=sLithoCode)
                    
                Case "Barcode"
                    sBarCode = Left(sTemp, 6)
                    sLithoCode = UnCrunch(sBarCode:=sBarCode)
            End Select
            
            'Add them to the list
            If lvwLithoCodes.ListItems("SM" & sLithoCode) Is Nothing Then
                Set oItem = lvwLithoCodes.ListItems.Add(, "SM" & sLithoCode, sLithoCode, , "Litho")
                oItem.SubItems(1) = sBarCode
            Else
                'This item is already in the list
                nDuplicates = nDuplicates + 1
            End If
            
            'Cleanup
            Set oItem = Nothing
            
            'Check to see if we have reached the maximum lithos allowed
            If lvwLithoCodes.ListItems.Count >= mknMaximumLithos Then
                sMsg = "You have reached the maximum of " & mknMaximumLithos & " " & fraInput.Tag & "s!"
                MsgBox sMsg, vbExclamation, "Maximum Reached"
                Exit Do
            End If
        End If
    Loop
    
    'Display a message for the user if any duplicates were found
    If nDuplicates > 0 Then
        sMsg = "" & nDuplicates & " " & fraInput.Tag & "s were skipped as they already existed in the list!"
        MsgBox sMsg, vbInformation
    End If
    
    'Cleanup
    txtInput.SetFocus
    Set oToken = Nothing
    Set oItem = Nothing
    
Exit Sub


ErrorHandler:
    MsgBox "Invalid " & fraInput.Tag & "(s) encountered on clipboard!" & vbCrLf & vbCrLf & "Please try again.", vbCritical
    txtInput.SetFocus
    
End Sub


Private Sub cmdImport_Click()
    
    Dim sMsg            As String
    Dim sTemp           As String
    Dim sInputFile      As String
    Dim lInputHandle    As Long
    Dim sLithoCode      As String
    Dim sBarCode        As String
    Dim oItem           As GSEnhListView.GSListItem
    Dim nDuplicates     As Integer
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the input file
    With dlgMain
        .DialogTitle = "Select " & fraInput.Tag & " Import File"
        .CancelError = True
        .DefaultExt = ".txt"
        If fraInput.Tag = "LithoCode" Then
            .Filter = "Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        Else
            .Filter = "Deliverable File (*.dlv)|*.dlv|Undeliverable File (*.ndl)|*.ndl|Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        End If
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sInputFile = .filename
    End With
    
    'Reset the error trap
    On Error GoTo ErrorHandler
    
    'Open the file
    lInputHandle = FreeFile
    Open sInputFile For Input As #lInputHandle
    
    'Loop through each line of the file
    nDuplicates = 0
    Do Until EOF(lInputHandle)
        'Read in a line
        Line Input #lInputHandle, sTemp
        sTemp = Trim(sTemp)
        
        If Len(sTemp) > 0 Then
            'Get the values
            Select Case fraInput.Tag
                Case "LithoCode"
                    sLithoCode = sTemp
                    sBarCode = Crunch(lLithoCode:=sLithoCode)
                    
                Case "Barcode"
                    sBarCode = Left(sTemp, 6)
                    sLithoCode = UnCrunch(sBarCode:=sBarCode)
            End Select
            
            'Add them to the list
            If lvwLithoCodes.ListItems("SM" & sLithoCode) Is Nothing Then
                Set oItem = lvwLithoCodes.ListItems.Add(, "SM" & sLithoCode, sLithoCode, , "Litho")
                oItem.SubItems(1) = sBarCode
            Else
                'This item is already in the list
                nDuplicates = nDuplicates + 1
            End If
            
            'Cleanup
            Set oItem = Nothing
            
            'Check to see if we have reached the maximum lithos allowed
            If lvwLithoCodes.ListItems.Count >= mknMaximumLithos Then
                sMsg = "You have reached the maximum of " & mknMaximumLithos & " " & fraInput.Tag & "s!"
                MsgBox sMsg, vbExclamation, "Maximum Reached"
                Exit Do
            End If
        End If
    Loop
    
    'Display a message for the user if any duplicates were found
    If nDuplicates > 0 Then
        sMsg = "" & nDuplicates & " " & fraInput.Tag & "s were skipped as they already existed in the list!"
        MsgBox sMsg, vbInformation
    End If
    
    'Close the files
    txtInput.SetFocus
    Close #lInputHandle
    Set oItem = Nothing
    
DLGErrorHandler:
    Exit Sub


ErrorHandler:
    MsgBox "Invalid " & fraInput.Tag & "(s) encountered in file!" & vbCrLf & vbCrLf & "Please try again.", vbCritical
    txtInput.SetFocus
    Close
    Exit Sub
    
End Sub

Private Sub cmdOK_Click()
    
    If lvwLithoCodes.ListItems.Count = 0 Then
        MsgBox "You must enter the LithoCode(s)/Barcode(s) to be processed!", vbCritical
    ElseIf lvwLithoCodes.ListItems.Count > mknMaximumLithos Then
        MsgBox "You have exceded the maximum of " & mknMaximumLithos & " " & fraInput.Tag & "s!", vbCritical
    Else
        OKClicked = True
        Me.Hide
    End If
    
End Sub

Private Sub Form_Load()
    
    'Setup the screen
    With lvwLithoCodes
        'Clear current settings
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        'Setup the sorting
        .SortKey = 1    'Barcode
        .SortOrder = gslvAscending
        .SortType = gslvOnColumnClick
        
        'Other settings
        Set .SmallIcons = frmMain.imlMain
        
        'Add the column headers
        With .ColumnHeaders
            .Add , "strLithoCode", "LithoCode", 1500, gslvColumnLeft, gslvAsNumber
            .Add , "Barcode", "Barcode", 1080, gslvColumnLeft, gslvAsText
        End With '.ColumnHeaders
    End With 'lvwMain

End Sub


Private Sub optInputType_Click(nIndex As Integer)
    
    With fraInput
        Select Case nIndex
            Case 0  'LithoCode
                .Caption = " Input LithoCodes "
                .Tag = "LithoCode"
            Case 1  'Barcodes
                .Caption = " Input Barcodes "
                .Tag = "Barcode"
        End Select
    End With
    
End Sub


Private Sub txtInput_GotFocus()
    
    SelectAllText ctrControl:=txtInput
    
End Sub


Private Sub txtInput_KeyPress(nKeyAscii As Integer)
    
    nKeyAscii = UCaseKeyPress(nKeyAscii:=nKeyAscii)
    
End Sub



Public Property Get OKClicked() As Boolean
    
    OKClicked = mbOKClicked
    
End Property

Public Property Let OKClicked(ByVal bData As Boolean)
    
    mbOKClicked = bData
    
End Property
