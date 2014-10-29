VERSION 5.00
Object = "{57F57641-590A-11D1-9464-00AA006F7AF1}#1.0#0"; "GSCboBox.ocx"
Begin VB.Form frmAddEdit 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Add/Edit"
   ClientHeight    =   3015
   ClientLeft      =   1560
   ClientTop       =   2355
   ClientWidth     =   5835
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3015
   ScaleWidth      =   5835
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fraDialog 
      Height          =   2235
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   5595
      Begin GSEnhComboBox.GSComboBox cboDisposition 
         Height          =   315
         Left            =   1140
         TabIndex        =   8
         Top             =   1740
         Width           =   4275
         _ExtentX        =   7541
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
      End
      Begin VB.TextBox txtCode 
         Height          =   315
         Left            =   1140
         MaxLength       =   100
         TabIndex        =   6
         Top             =   1260
         Width           =   4275
      End
      Begin VB.TextBox txtSubHeader 
         Height          =   315
         Left            =   1140
         MaxLength       =   100
         TabIndex        =   4
         Top             =   780
         Width           =   4275
      End
      Begin VB.TextBox txtHeader 
         Height          =   315
         Left            =   1140
         MaxLength       =   100
         TabIndex        =   2
         Top             =   300
         Width           =   4275
      End
      Begin VB.Label lblDisposition 
         Caption         =   "Disposition:"
         Height          =   195
         Left            =   180
         TabIndex        =   7
         Top             =   1800
         Width           =   915
      End
      Begin VB.Label lblCode 
         Caption         =   "Code:"
         Height          =   195
         Left            =   180
         TabIndex        =   5
         Top             =   1320
         Width           =   915
      End
      Begin VB.Label lblSubHeader 
         Caption         =   "SubHeader:"
         Height          =   195
         Left            =   180
         TabIndex        =   3
         Top             =   840
         Width           =   915
      End
      Begin VB.Label lblHeader 
         Caption         =   "Header:"
         Height          =   195
         Left            =   180
         TabIndex        =   1
         Top             =   360
         Width           =   915
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   435
      Left            =   4560
      TabIndex        =   10
      Top             =   2460
      Width           =   1155
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   435
      Left            =   3300
      TabIndex        =   9
      Top             =   2460
      Width           =   1155
   End
End
Attribute VB_Name = "frmAddEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mbFormActive    As Boolean
    Private mbOKClicked     As Boolean
    Private mdtModified     As Date
    Private meMode          As eAddEditModeConstants
    
Private Function IsKeyValid(ByVal nKeyAscii As Integer) As Boolean
    
    Const ksValidKeys As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_-+={}[]|\:;<>,.?/ "
    
    If InStr(ksValidKeys, Chr(nKeyAscii)) = 0 And nKeyAscii <> vbKeyBack Then
        IsKeyValid = False
    Else
        IsKeyValid = True
    End If
    
End Function

Private Sub cmdCancel_Click()
    
    OKClicked = False
    Me.Hide
    
End Sub

Private Sub cmdOK_Click()
    
    Dim sSql    As String
    Dim sMsg    As String
    Dim oTempRs As ADODB.Recordset
    
    'See if the data is valid
    If Not IsDataValid Then Exit Sub
    
    'Start the error trap
    On Error GoTo ErrorHandler
    
    'Begin the transaction
    goConn.BeginTrans
    
    'If we made it to here then save the data
    Select Case meMode
        Case eAEMAddHeader
            'Insert the new record
            sSql = "INSERT INTO CommentHeaders (strCmntHeader_Nm, strModifiedBy, datModified) " & _
                   "VALUES ('" & Header & "', '" & Left(goUserInfo.UserName, 50) & "', GetDate())"
            goConn.Execute (sSql)
            
            'Get the ID and date for the newly added record
            sSql = "SELECT CmntHeader_id, datModified " & _
                   "FROM CommentHeaders " & _
                   "WHERE strCmntHeader_Nm = '" & Header & "'"
            Set oTempRs = goConn.Execute(sSql)
            HeaderID = oTempRs!CmntHeader_id
            DateModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
            
        Case eAEMEditHeader
            'Save the changes to this record
            sSql = "UPDATE CommentHeaders " & _
                   "SET strCmntHeader_Nm = '" & Header & "', " & _
                   "    strModifiedBy = '" & Left(goUserInfo.UserName, 50) & "', " & _
                   "    datModified = GetDate() " & _
                   "WHERE CmntHeader_id = " & HeaderID
            goConn.Execute (sSql)
            
            'Get the date for the modified record
            sSql = "SELECT datModified " & _
                   "FROM CommentHeaders " & _
                   "WHERE CmntHeader_id = " & HeaderID
            Set oTempRs = goConn.Execute(sSql)
            DateModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
            
        Case eAEMAddSubHeader
            'Insert the new record
            sSql = "INSERT INTO CommentSubHeaders (CmntHeader_id, strCmntSubHeader_Nm, strModifiedBy, datModified) " & _
                   "VALUES (" & HeaderID & ", '" & SubHeader & "', '" & Left(goUserInfo.UserName, 50) & "', GetDate())"
            goConn.Execute (sSql)
            
            'Get the ID and date for the newly added record
            sSql = "SELECT CmntSubHeader_id, datModified " & _
                   "FROM CommentSubHeaders " & _
                   "WHERE CmntHeader_id = " & HeaderID & " " & _
                   "  AND strCmntSubHeader_Nm = '" & SubHeader & "'"
            Set oTempRs = goConn.Execute(sSql)
            SubHeaderID = oTempRs!CmntSubHeader_id
            DateModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
        
        Case eAEMEditSubHeader
            'Save the changes to this record
            sSql = "UPDATE CommentSubHeaders " & _
                   "SET strCmntSubHeader_Nm = '" & SubHeader & "', " & _
                   "    strModifiedBy = '" & Left(goUserInfo.UserName, 50) & "', " & _
                   "    datModified = GetDate() " & _
                   "WHERE CmntSubHeader_id = " & SubHeaderID
            goConn.Execute (sSql)
            
            'Get the date for the modified record
            sSql = "SELECT datModified " & _
                   "FROM CommentSubHeaders " & _
                   "WHERE CmntSubHeader_id = " & SubHeaderID
            Set oTempRs = goConn.Execute(sSql)
            DateModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
            
        Case eAEMAddCode
            'Insert the new record
            sSql = "INSERT INTO CommentCodes (CmntSubHeader_id, strCmntCode_Nm, strModifiedBy, datModified, Disposition_id) " & _
                   "VALUES (" & SubHeaderID & ", '" & Code & "', '" & Left(goUserInfo.UserName, 50) & "', GetDate(), " & _
                   "        " & IIf(DispositionID = -1, "NULL", DispositionID) & ")"
            goConn.Execute (sSql)
        
            'Get the ID and date for the newly added record
            sSql = "SELECT CmntCode_id, datModified " & _
                   "FROM CommentCodes " & _
                   "WHERE CmntSubHeader_id = " & SubHeaderID & " " & _
                   "  AND strCmntCode_Nm = '" & Code & "'"
            Set oTempRs = goConn.Execute(sSql)
            CodeID = oTempRs!CmntCode_id
            DateModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
        
        Case eAEMEditCode
            'Save the changes to this record
            sSql = "UPDATE CommentCodes " & _
                   "SET strCmntCode_Nm = '" & Code & "', " & _
                   "    strModifiedBy = '" & Left(goUserInfo.UserName, 50) & "', " & _
                   "    datModified = GetDate(), " & _
                   "    Disposition_id = " & IIf(DispositionID = -1, "NULL", DispositionID) & " " & _
                   "WHERE CmntCode_id = " & CodeID
            goConn.Execute (sSql)
            
            'Get the date for the modified record
            sSql = "SELECT datModified " & _
                   "FROM CommentCodes " & _
                   "WHERE CmntCode_id = " & CodeID
            Set oTempRs = goConn.Execute(sSql)
            DateModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
            
    End Select
    
    'Commit the transaction
    goConn.CommitTrans
    
    'Set the flags and hide the form
    OKClicked = True
    Me.Hide
    
Exit Sub


ErrorHandler:
    'Rollback the transaction
    goConn.RollbackTrans
    
    'Cleanup
    If Not (oTempRs Is Nothing) Then oTempRs.Close
    Set oTempRs = Nothing
    
    'Display the error message
    sMsg = "The following unexpected error was encountered!" & vbCrLf & vbCrLf & _
           "Error #: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & Err.Description & vbCrLf & vbCrLf & _
           "Please try again!"
    MsgBox sMsg, vbCritical
    Exit Sub
    
End Sub

Private Sub Form_Activate()
    
    'If we are already active then exit
    If mbFormActive Then Exit Sub
    
    'If we are not active then set focus to the appropriate field
    Select Case meMode
        Case eAEMAddHeader, eAEMEditHeader
            txtHeader.SetFocus
            
        Case eAEMAddSubHeader, eAEMEditSubHeader
            txtSubHeader.SetFocus
            
        Case eAEMAddCode, eAEMEditCode
            txtCode.SetFocus
            
    End Select
    
End Sub

Public Property Get OKClicked() As Boolean
    
    OKClicked = mbOKClicked
    
End Property

Public Property Let OKClicked(ByVal bData As Boolean)
    
    mbOKClicked = bData
    
End Property

Public Function IsDataValid() As Boolean
    
    Dim sMsg    As String
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Validate the data
    Select Case meMode
        Case eAEMAddHeader
            If Len(Header) = 0 Then
                sMsg = "You must enter the Header!"
                txtHeader.SetFocus
            Else
                sSql = "SELECT Count(*) AS QtyRec " & _
                       "FROM CommentHeaders " & _
                       "WHERE strCmntHeader_Nm = '" & Header & "'"
                Set oTempRs = goConn.Execute(sSql)
                If oTempRs("QtyRec").Value > 0 Then
                    sMsg = "The specified Header already exists!"
                    txtHeader.SetFocus
                End If
                oTempRs.Close: Set oTempRs = Nothing
            End If
            
        Case eAEMEditHeader
            If Len(Header) = 0 Then
                sMsg = "You must enter the Header!"
                txtHeader.SetFocus
            Else
                sSql = "SELECT Count(*) AS QtyRec " & _
                       "FROM CommentHeaders " & _
                       "WHERE strCmntHeader_Nm = '" & Header & "' " & _
                       "  AND CmntHeader_id <> " & HeaderID
                Set oTempRs = goConn.Execute(sSql)
                If oTempRs("QtyRec").Value > 0 Then
                    sMsg = "The specified Header already exists!"
                    txtHeader.SetFocus
                End If
                oTempRs.Close: Set oTempRs = Nothing
            End If
        
        Case eAEMAddSubHeader
            If Len(SubHeader) = 0 Then
                sMsg = "You must enter the SubHeader!"
                txtSubHeader.SetFocus
            Else
                sSql = "SELECT Count(*) AS QtyRec " & _
                       "FROM CommentSubHeaders " & _
                       "WHERE strCmntSubHeader_Nm = '" & SubHeader & "' " & _
                       "  AND CmntHeader_id = " & HeaderID
                Set oTempRs = goConn.Execute(sSql)
                If oTempRs("QtyRec").Value > 0 Then
                    sMsg = "The specified SubHeader already exists!"
                    txtSubHeader.SetFocus
                End If
                oTempRs.Close: Set oTempRs = Nothing
            End If
        
        Case eAEMEditSubHeader
            If Len(SubHeader) = 0 Then
                sMsg = "You must enter the SubHeader!"
                txtSubHeader.SetFocus
            Else
                sSql = "SELECT Count(*) AS QtyRec " & _
                       "FROM CommentSubHeaders " & _
                       "WHERE strCmntSubHeader_Nm = '" & SubHeader & "' " & _
                       "  AND CmntHeader_id = " & HeaderID & " " & _
                       "  AND CmntSubHeader_id <> " & SubHeaderID
                Set oTempRs = goConn.Execute(sSql)
                If oTempRs("QtyRec").Value > 0 Then
                    sMsg = "The specified SubHeader already exists!"
                    txtSubHeader.SetFocus
                End If
                oTempRs.Close: Set oTempRs = Nothing
            End If
        
        Case eAEMAddCode
            If Len(Code) = 0 Then
                sMsg = "You must enter the Code!"
                txtCode.SetFocus
            Else
                sSql = "SELECT Count(*) AS QtyRec " & _
                       "FROM CommentCodes " & _
                       "WHERE strCmntCode_Nm = '" & Code & "' " & _
                       "  AND CmntSubHeader_id = " & SubHeaderID
                Set oTempRs = goConn.Execute(sSql)
                If oTempRs("QtyRec").Value > 0 Then
                    sMsg = "The specified Code already exists!"
                    txtCode.SetFocus
                End If
                oTempRs.Close: Set oTempRs = Nothing
            End If
        
        Case eAEMEditCode
            If Len(Code) = 0 Then
                sMsg = "You must enter the Code!"
                txtCode.SetFocus
            Else
                sSql = "SELECT Count(*) AS QtyRec " & _
                       "FROM CommentCodes " & _
                       "WHERE strCmntCode_Nm = '" & Code & "' " & _
                       "  AND CmntSubHeader_id = " & SubHeaderID & " " & _
                       "  AND CmntCode_id <> " & CodeID
                Set oTempRs = goConn.Execute(sSql)
                If oTempRs("QtyRec").Value > 0 Then
                    sMsg = "The specified Code already exists!"
                    txtCode.SetFocus
                End If
                oTempRs.Close: Set oTempRs = Nothing
            End If
        
    End Select
    
    'Determine return value
    If Len(Trim(sMsg)) = 0 Then
        IsDataValid = True
    Else
        MsgBox sMsg, vbCritical
        IsDataValid = False
    End If
    
Exit Function


ErrorHandler:
    'Set the return value
    IsDataValid = False
    
    'Set the error message
    sMsg = "The following unexpected error was encountered!" & vbCrLf & vbCrLf & _
           "Error #: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & Err.Description & vbCrLf & vbCrLf & _
           "Please try again!"
    MsgBox sMsg, vbCritical
    Exit Function
    
End Function

Public Property Let Mode(ByVal eData As eAddEditModeConstants)
    
    'Store the mode
    meMode = eData
    
    'Setup the form
    Select Case meMode
        Case eAEMAddHeader, eAEMEditHeader
            lblHeader.Visible = True
            With txtHeader
                .Visible = True
                .Locked = False
                .BackColor = vbWindowBackground
            End With
            lblSubHeader.Visible = False
            txtSubHeader.Visible = False
            lblCode.Visible = False
            txtCode.Visible = False
            lblDisposition.Visible = False
            cboDisposition.Visible = False
            If meMode = eAEMAddHeader Then
                Me.Caption = "Add Header"
            Else
                Me.Caption = "Edit Header"
            End If
            
        Case eAEMAddSubHeader, eAEMEditSubHeader
            lblHeader.Visible = True
            With txtHeader
                .Visible = True
                .Locked = True
                .BackColor = vbButtonFace
            End With
            lblSubHeader.Visible = True
            With txtSubHeader
                .Visible = True
                .Locked = False
                .BackColor = vbWindowBackground
            End With
            lblCode.Visible = False
            txtCode.Visible = False
            lblDisposition.Visible = False
            cboDisposition.Visible = False
            If meMode = eAEMAddSubHeader Then
                Me.Caption = "Add SubHeader"
            Else
                Me.Caption = "Edit SubHeader"
            End If
        
        Case eAEMAddCode, eAEMEditCode
            lblHeader.Visible = True
            With txtHeader
                .Visible = True
                .Locked = True
                .BackColor = vbButtonFace
            End With
            lblSubHeader.Visible = True
            With txtSubHeader
                .Visible = True
                .Locked = True
                .BackColor = vbButtonFace
            End With
            lblCode.Visible = True
            With txtCode
                .Visible = True
                .Locked = False
                .BackColor = vbWindowBackground
            End With
            lblDisposition.Visible = True
            cboDisposition.Visible = True
            If meMode = eAEMAddCode Then
                Me.Caption = "Add Code"
            Else
                Me.Caption = "Edit Code"
            End If
        
    End Select
    
End Property

Public Property Get SubHeader() As String
    
    SubHeader = Trim(txtSubHeader.Text)
    
End Property

Public Property Get Disposition() As String
    
    Disposition = cboDisposition.Text
    
End Property

Public Property Get Code() As String
    
    Code = Trim(txtCode.Text)
    
End Property

Public Property Get Header() As String
    
    Header = Trim(txtHeader.Text)
    
End Property

Public Property Let SubHeader(ByVal sData As String)
    
    txtSubHeader.Text = sData
    
End Property
Public Property Let Code(ByVal sData As String)
    
    txtCode.Text = sData
    
End Property

Public Property Let Header(ByVal sData As String)
    
    txtHeader.Text = sData
    
End Property

Private Sub Form_Load()
    
    'Populate the Disposition Code combo
    LoadDispositionComboBox
    
End Sub

Private Sub LoadDispositionComboBox()
    
    Dim sSql As String
    Dim oTempRs As ADODB.Recordset
    
    'Clear the combo
    cboDisposition.Clear
    
    'Get the data to be loaded
    sSql = "SELECT Disposition_id, strReportLabel " & _
           "FROM Disposition " & _
           "ORDER BY strReportLabel"
    Set oTempRs = goConn.Execute(sSql)
    
    'Add the none option to the combo
    With cboDisposition
        .AddItem "<none>"
        .ItemData(.NewIndex) = -1
    End With
    
    'Populate the combo
    Do Until oTempRs.EOF
        'Add this Disposition to the combo
        With cboDisposition
            .AddItem "" & Trim(oTempRs!strReportLabel)
            .ItemData(.NewIndex) = oTempRs!Disposition_id
        End With
        
        'Prepare for next pass
        oTempRs.MoveNext
    Loop
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Sub

Private Sub txtCode_GotFocus()
    
    SelectAllText ctrControl:=txtCode
    
End Sub

Private Sub txtCode_KeyPress(nKeyAscii As Integer)
    
    'Validate the key
    If Not IsKeyValid(nKeyAscii:=nKeyAscii) Then
        Beep
        nKeyAscii = 0
    End If
    
End Sub


Private Sub txtHeader_GotFocus()
    
    SelectAllText ctrControl:=txtHeader
    
End Sub

Private Sub txtHeader_KeyPress(nKeyAscii As Integer)
    
    'Validate the key
    If Not IsKeyValid(nKeyAscii:=nKeyAscii) Then
        Beep
        nKeyAscii = 0
    End If
    
End Sub


Private Sub txtSubHeader_GotFocus()
    
    SelectAllText ctrControl:=txtSubHeader
    
End Sub

Private Sub txtSubHeader_KeyPress(nKeyAscii As Integer)
    
    'Validate the key
    If Not IsKeyValid(nKeyAscii:=nKeyAscii) Then
        Beep
        nKeyAscii = 0
    End If
    
End Sub



Public Property Get SubHeaderID() As Long
    
    SubHeaderID = txtSubHeader.Tag
    
End Property

Public Property Get DispositionID() As Long
    
    DispositionID = cboDisposition.ItemData(cboDisposition.ListIndex)
    
End Property

Public Property Get CodeID() As Long
    
    CodeID = txtCode.Tag
    
End Property

Public Property Get HeaderID() As Long
    
    HeaderID = txtHeader.Tag
    
End Property

Public Property Let SubHeaderID(ByVal lData As Long)
    
    txtSubHeader.Tag = lData
    
End Property
Public Property Let DispositionID(ByVal lData As Long)
    
    Dim lCnt As Long
    
    With cboDisposition
        For lCnt = 0 To .ListCount - 1
            If .ItemData(lCnt) = lData Then
                .ListIndex = lCnt
                Exit For
            End If
        Next lCnt
    End With
    
End Property

Public Property Let CodeID(ByVal lData As Long)
    
    txtCode.Tag = lData
    
End Property

Public Property Let HeaderID(ByVal lData As Long)
    
    txtHeader.Tag = lData
    
End Property


Public Property Get DateModified() As Date
    
    DateModified = mdtModified
    
End Property

Public Property Let DateModified(ByVal dtDate As Date)
    
    mdtModified = dtDate
    
End Property
