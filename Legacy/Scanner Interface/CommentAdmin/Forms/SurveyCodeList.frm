VERSION 5.00
Object = "{57F57641-590A-11D1-9464-00AA006F7AF1}#1.0#0"; "GSCboBox.ocx"
Begin VB.Form frmSurveyCodeList 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Add/Edit Survey Code List"
   ClientHeight    =   5055
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5835
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5055
   ScaleWidth      =   5835
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fraCodeList 
      Caption         =   " Code List Selection "
      Height          =   1275
      Left            =   120
      TabIndex        =   12
      Top             =   3060
      Width           =   5595
      Begin GSEnhComboBox.GSComboBox cboHeader 
         Height          =   315
         Left            =   1140
         TabIndex        =   14
         Top             =   300
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
      Begin GSEnhComboBox.GSComboBox cboSubHeader 
         Height          =   315
         Left            =   1140
         TabIndex        =   16
         Top             =   780
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
      Begin VB.Label lblHeader 
         Caption         =   "Header:"
         Height          =   195
         Left            =   180
         TabIndex        =   13
         Top             =   360
         Width           =   915
      End
      Begin VB.Label lblSubHeader 
         Caption         =   "SubHeader:"
         Height          =   195
         Left            =   180
         TabIndex        =   15
         Top             =   840
         Width           =   915
      End
   End
   Begin VB.Frame fraSurvey 
      Caption         =   " Survey Selection "
      Height          =   2895
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   5595
      Begin VB.CommandButton cmdFind 
         Caption         =   "Find"
         Height          =   315
         Left            =   4740
         TabIndex        =   11
         Top             =   2400
         Width           =   675
      End
      Begin VB.TextBox txtSurveyID 
         Height          =   315
         Left            =   1380
         TabIndex        =   10
         Top             =   2400
         Width           =   3315
      End
      Begin VB.OptionButton optSurvey 
         Caption         =   "Enter By Client, Study, Survey Names"
         Height          =   195
         Index           =   0
         Left            =   180
         TabIndex        =   1
         Top             =   300
         Width           =   4875
      End
      Begin VB.OptionButton optSurvey 
         Caption         =   "Enter By Survey ID:"
         Height          =   195
         Index           =   1
         Left            =   180
         TabIndex        =   8
         Top             =   2100
         Width           =   4875
      End
      Begin GSEnhComboBox.GSComboBox cboClient 
         Height          =   315
         Left            =   1380
         TabIndex        =   3
         Top             =   600
         Width           =   4035
         _ExtentX        =   7117
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
      Begin GSEnhComboBox.GSComboBox cboStudy 
         Height          =   315
         Left            =   1380
         TabIndex        =   5
         Top             =   1080
         Width           =   4035
         _ExtentX        =   7117
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
      Begin GSEnhComboBox.GSComboBox cboSurvey 
         Height          =   315
         Left            =   1380
         TabIndex        =   7
         Top             =   1560
         Width           =   4035
         _ExtentX        =   7117
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
      Begin VB.Label lblSurveyID 
         Caption         =   "Survey ID:"
         Height          =   195
         Left            =   480
         TabIndex        =   9
         Top             =   2460
         Width           =   795
      End
      Begin VB.Label lblClient 
         Caption         =   "Client:"
         Height          =   195
         Left            =   480
         TabIndex        =   2
         Top             =   660
         Width           =   795
      End
      Begin VB.Label lblStudy 
         Caption         =   "Study:"
         Height          =   195
         Left            =   480
         TabIndex        =   4
         Top             =   1140
         Width           =   795
      End
      Begin VB.Label lblSurvey 
         Caption         =   "Survey:"
         Height          =   195
         Left            =   480
         TabIndex        =   6
         Top             =   1620
         Width           =   795
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   435
      Left            =   4560
      TabIndex        =   18
      Top             =   4500
      Width           =   1155
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   435
      Left            =   3300
      TabIndex        =   17
      Top             =   4500
      Width           =   1155
   End
End
Attribute VB_Name = "frmSurveyCodeList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mdtModified As Date
    Private meMode      As eSurveyCodeListModeConstants
    Private mbOKClicked As Boolean
    
Private Sub LoadSubHeaderComboBox()
    
    Dim sSql As String
    Dim oTempRs As ADODB.Recordset
    
    'If nothing is selected in Header then head out of dodge
    If cboHeader.ListIndex < 0 Then Exit Sub
    
    'Clear the combo
    cboSubHeader.Clear
    
    'Get the data to be loaded
    sSql = "SELECT CmntSubHeader_id, strCmntSubHeader_Nm " & _
           "FROM CommentSubHeaders " & _
           "WHERE CmntHeader_id = " & cboHeader.ItemData(cboHeader.ListIndex) & " " & _
           "  AND bitRetired = 0 " & _
           "ORDER BY intOrder"
    Set oTempRs = goConn.Execute(sSql)
    
    'Populate the combo
    Do Until oTempRs.EOF
        'Add this SubHeader to the combo
        With cboSubHeader
            .AddItem "" & Trim(oTempRs!strCmntSubHeader_Nm)
            .ItemData(.NewIndex) = oTempRs!CmntSubHeader_id
        End With
        
        'Prepare for next pass
        oTempRs.MoveNext
    Loop
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Sub

Private Sub LoadHeaderComboBox()
    
    Dim sSql As String
    Dim oTempRs As ADODB.Recordset
    
    'Clear the combo
    cboHeader.Clear
    
    'Get the data to be loaded
    sSql = "SELECT CmntHeader_id, strCmntHeader_Nm " & _
           "FROM CommentHeaders " & _
           "WHERE bitRetired = 0 " & _
           "ORDER BY intOrder"
    Set oTempRs = goConn.Execute(sSql)
    
    'Populate the combo
    Do Until oTempRs.EOF
        'Add this Header to the combo
        With cboHeader
            .AddItem "" & Trim(oTempRs!strCmntHeader_Nm)
            .ItemData(.NewIndex) = oTempRs!CmntHeader_id
        End With
        
        'Prepare for next pass
        oTempRs.MoveNext
    Loop
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Sub


Private Sub LoadSurveyComboBox()
    
    Dim sSql As String
    Dim oTempRs As ADODB.Recordset
    
    'If nothing is selected in Client then head out of dodge
    If cboStudy.ListIndex < 0 Then Exit Sub
    
    'Clear the combo
    cboSurvey.Clear
    
    'Get the data to be loaded
    '** Modified 09-29-05 JJF
    'sSql = "SELECT Survey_id, strSurvey_Nm " & _
    '       "FROM Survey_Def " & _
    '       "WHERE Study_id = " & cboStudy.ItemData(cboStudy.ListIndex) & " " & _
    '       "ORDER BY strSurvey_Nm"
    'Set oTempRs = goConn.Execute(sSql)
    sSql = "SELECT Survey_id, strQSurvey_Nm AS strSurvey_Nm " & _
           "FROM ClientStudySurvey " & _
           "WHERE Study_id = " & cboStudy.ItemData(cboStudy.ListIndex) & " " & _
           "ORDER BY strSurvey_Nm"
    Set oTempRs = goDMConn.Execute(sSql)
    '** End of modification 09-29-05 JJF
    
    'Populate the combo
    Do Until oTempRs.EOF
        'Add this Survey to the combo
        With cboSurvey
            .AddItem "" & Trim(oTempRs!strSurvey_Nm)
            .ItemData(.NewIndex) = oTempRs!Survey_id
        End With
        
        'Prepare for next pass
        oTempRs.MoveNext
    Loop
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Sub

Private Sub LoadStudyComboBox()
    
    Dim sSql As String
    Dim oTempRs As ADODB.Recordset
    
    'If nothing is selected in Client then head out of dodge
    If cboClient.ListIndex < 0 Then Exit Sub
    
    'Clear the combo
    cboStudy.Clear
    
    'Get the data to be loaded
    '** Modified 09-29-05 JJF
    'sSql = "SELECT Study_id, strStudy_Nm " & _
    '       "FROM Study " & _
    '       "WHERE Client_id = " & cboClient.ItemData(cboClient.ListIndex) & " " & _
    '       "ORDER BY strStudy_Nm"
    'Set oTempRs = goConn.Execute(sSql)
    sSql = "SELECT Distinct Study_id, strStudy_Nm " & _
           "FROM ClientStudySurvey " & _
           "WHERE Client_id = " & cboClient.ItemData(cboClient.ListIndex) & " " & _
           "ORDER BY strStudy_Nm"
    Set oTempRs = goDMConn.Execute(sSql)
    '** End of modification 09-29-05 JJF
    
    'Populate the combo
    Do Until oTempRs.EOF
        'Add this Study to the combo
        With cboStudy
            .AddItem "" & Trim(oTempRs!strStudy_Nm)
            .ItemData(.NewIndex) = oTempRs!Study_id
        End With
        
        'Prepare for next pass
        oTempRs.MoveNext
    Loop
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Sub

Private Sub LoadClientComboBox()
    
    Dim sSql As String
    Dim oTempRs As ADODB.Recordset
    
    'Clear the combo
    cboClient.Clear
    
    'Get the data to be loaded
    '** Modified 09-29-05 JJF
    'sSql = "SELECT Client_id, strClient_Nm " & _
    '       "FROM Client " & _
    '       "ORDER BY strClient_Nm"
    'Set oTempRs = goConn.Execute(sSql)
    sSql = "SELECT Distinct Client_id, strClient_Nm " & _
           "FROM ClientStudySurvey " & _
           "ORDER BY strClient_Nm"
    Set oTempRs = goDMConn.Execute(sSql)
    '** End of modification 09-29-05 JJF
    
    'Populate the combo
    Do Until oTempRs.EOF
        'Add this Client to the combo
        With cboClient
            .AddItem "" & Trim(oTempRs!strClient_Nm)
            .ItemData(.NewIndex) = oTempRs!Client_id
        End With
        
        'Prepare for next pass
        oTempRs.MoveNext
    Loop
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Sub

Private Sub cboClient_Click()
    
    LoadStudyComboBox
    cboSurvey.Clear
    txtSurveyID.Text = ""
    
End Sub

Private Sub cboHeader_Click()
    
    LoadSubHeaderComboBox
    
End Sub


Private Sub cboStudy_Click()
    
    LoadSurveyComboBox
    txtSurveyID.Text = ""
    
End Sub

Private Sub cboSurvey_Click()
    
    txtSurveyID.Text = cboSurvey.ItemData(cboSurvey.ListIndex)
    
End Sub

Private Sub cmdCancel_Click()
    
    OKClicked = False
    Me.Hide
    
End Sub


Private Sub cmdFind_Click()
    
    Dim sSql        As String
    Dim lSurveyID   As Long
    Dim oTempRs     As ADODB.Recordset
    
    'Determine if we should be here
    If Len(Trim(txtSurveyID.Text)) = 0 Then
        'No survey ID entered so we are out of here
        MsgBox "Please enter the SurveyID!"
        txtSurveyID.SetFocus
        txtSurveyID_GotFocus
        Exit Sub
    End If
    
    'Lookup the ClientID and StudyID
    lSurveyID = Val(Trim(txtSurveyID.Text))
    '** Modified 09-29-05 JJF
    'sSql = "SELECT cl.Client_id, st.Study_id " & _
    '       "FROM Client cl, Study st, Survey_Def sd " & _
    '       "WHERE cl.Client_id = st.Client_id " & _
    '       "  AND st.Study_id = sd.Study_id " & _
    '       "  AND sd.Survey_id = " & lSurveyID
    'Set oTempRs = goConn.Execute(sSql)
    sSql = "SELECT Distinct Client_id, Study_id " & _
           "FROM ClientStudySurvey " & _
           "WHERE Survey_id = " & lSurveyID
    Set oTempRs = goDMConn.Execute(sSql)
    '** End of modifications 09-29-05 JJF
    
    'Validate results
    If oTempRs.EOF Then
        MsgBox "Entered Survey ID was not found.  Please try again!"
        txtSurveyID.SetFocus
    Else
        'Populate screen
        ClientID = oTempRs!Client_id
        StudyID = oTempRs!Study_id
        SurveyID = lSurveyID
    End If
    
End Sub

Private Sub cmdOK_Click()
    
    Dim sSql    As String
    Dim sMsg    As String
    Dim oTempRs As ADODB.Recordset
    
    'See if the data is valid
    If Not IsDataValid Then Exit Sub
    
    'Start the error trap
    On Error GoTo ErrorHandler
    
    'If we made it to here then save the data
    Select Case meMode
        Case eSurveyCodeListModeConstants.eSCLAddMode
            'Insert the new record
            sSql = "INSERT INTO CommentSurveyCodeList (Survey_id, CmntSubHeader_id, strModifiedBy, datModified) " & _
                   "VALUES (" & SurveyID & ", " & SubHeaderID & ", '" & Left(goUserInfo.UserName, 50) & "', GetDate())"
            goConn.Execute (sSql)
        
        Case eSurveyCodeListModeConstants.eSCLEditMode
            'Save the changes to this record
            sSql = "UPDATE CommentSurveyCodeList " & _
                   "SET CmntSubHeader_id = " & SubHeaderID & ", " & _
                   "    strModifiedBy = '" & Left(goUserInfo.UserName, 50) & "', " & _
                   "    datModified = GetDate() " & _
                   "WHERE Survey_id = " & SurveyID
            goConn.Execute (sSql)
            
    End Select
    
    'Get the date for the modified record
    sSql = "SELECT datModified " & _
           "FROM CommentSurveyCodeList " & _
           "WHERE Survey_id = " & SurveyID
    Set oTempRs = goConn.Execute(sSql)
    DateModified = IIf(IsNull(oTempRs!datModified), Now, oTempRs!datModified)
    oTempRs.Close: Set oTempRs = Nothing
    
    'Set the flags and hide the form
    OKClicked = True
    Me.Hide
    
Exit Sub


ErrorHandler:
    'Display the error message
    sMsg = "The following unexpected error was encountered!" & vbCrLf & vbCrLf & _
           "Error #: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & Err.Description & vbCrLf & vbCrLf & _
           "Please try again!"
    MsgBox sMsg, vbCritical
    Exit Sub
    
End Sub

Private Sub Form_Load()
    
    LoadClientComboBox
    LoadHeaderComboBox
    
End Sub




Public Property Get DateModified() As Date
    
    DateModified = mdtModified
    
End Property

Public Property Let DateModified(ByVal dtDate As Date)
    
    mdtModified = dtDate
    
End Property

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
    If optSurvey(1).Value = True And Len(Trim(txtSurveyID.Text)) = 0 Then
        sMsg = "You must enter a Survey ID!"
        txtSurveyID.SetFocus
    ElseIf optSurvey(1).Value = True And cboClient.ListIndex < 0 Then
        sMsg = "You must click the Find button before proceeding!"
        cmdFind.SetFocus
    ElseIf cboClient.ListIndex < 0 Then
        sMsg = "You must select a client from the list!"
        cboClient.SetFocus
    ElseIf cboStudy.ListIndex < 0 Then
        sMsg = "You must select a study from the list!"
        cboStudy.SetFocus
    ElseIf cboSurvey.ListIndex < 0 Then
        sMsg = "You must select a survey from the list!"
        cboSurvey.SetFocus
    ElseIf cboHeader.ListIndex < 0 Then
        sMsg = "You must select a header from the list!"
        cboHeader.SetFocus
    ElseIf cboSubHeader.ListIndex < 0 Then
        sMsg = "You must select a subheader from the list!"
        cboSubHeader.SetFocus
    Else
        If meMode = eSDMAddMode Then
            'Check to see if this one already exists
            sSql = "SELECT Count(*) AS QtyRec " & _
                   "FROM CommentSurveyCodeList " & _
                   "WHERE Survey_id = " & SurveyID
            Set oTempRs = goConn.Execute(sSql)
            
            If oTempRs("QtyRec").Value > 0 Then
                sMsg = "A code list for the specified survey already exists!"
                If optSurvey(0).Value = True Then
                    cboSurvey.SetFocus
                Else
                    cboSurvey.Clear
                    cboStudy.Clear
                    cboClient.ListIndex = -1
                    txtSurveyID.SetFocus
                End If
            End If
            oTempRs.Close: Set oTempRs = Nothing
        End If
    End If
    
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

Public Property Get SubHeader() As String
    
    SubHeader = cboSubHeader.Text
    
End Property


Public Property Get Header() As String
    
    Header = cboHeader.Text
    
End Property

Public Property Get Study() As String
    
    Study = cboStudy.Text
    
End Property

Public Property Get Survey() As String
    
    Survey = cboSurvey.Text
    
End Property


Public Property Get Client() As String
    
    Client = cboClient.Text
    
End Property


Public Property Get SubHeaderID() As Long
    
    SubHeaderID = cboSubHeader.ItemData(cboSubHeader.ListIndex)
    
End Property

Public Property Get HeaderID() As Long
    
    HeaderID = cboHeader.ItemData(cboHeader.ListIndex)
    
End Property

Public Property Get StudyID() As Long
    
    StudyID = cboStudy.ItemData(cboStudy.ListIndex)
    
End Property


Public Property Get SurveyID() As Long
    
    SurveyID = cboSurvey.ItemData(cboSurvey.ListIndex)
    
End Property

Public Property Get ClientID() As Long
    
    ClientID = cboClient.ItemData(cboClient.ListIndex)
    
End Property

Public Property Let SubHeaderID(ByVal lData As Long)
    
    Dim lCnt As Long
    
    With cboSubHeader
        For lCnt = 0 To .ListCount - 1
            If .ItemData(lCnt) = lData Then
                .ListIndex = lCnt
                Exit For
            End If
        Next lCnt
    End With
    
End Property
Public Property Let HeaderID(ByVal lData As Long)
    
    Dim lCnt As Long
    
    With cboHeader
        For lCnt = 0 To .ListCount - 1
            If .ItemData(lCnt) = lData Then
                .ListIndex = lCnt
                Exit For
            End If
        Next lCnt
    End With
    
End Property

Public Property Let StudyID(ByVal lData As Long)
    
    Dim lCnt As Long
    
    With cboStudy
        For lCnt = 0 To .ListCount - 1
            If .ItemData(lCnt) = lData Then
                .ListIndex = lCnt
                Exit For
            End If
        Next lCnt
    End With
    
End Property

Public Property Let SurveyID(ByVal lData As Long)
    
    Dim lCnt As Long
    
    With cboSurvey
        For lCnt = 0 To .ListCount - 1
            If .ItemData(lCnt) = lData Then
                .ListIndex = lCnt
                Exit For
            End If
        Next lCnt
    End With
    
End Property

Public Property Let ClientID(ByVal lData As Long)
    
    Dim lCnt As Long
    
    With cboClient
        For lCnt = 0 To .ListCount - 1
            If .ItemData(lCnt) = lData Then
                .ListIndex = lCnt
                Exit For
            End If
        Next lCnt
    End With
    
End Property


Public Property Get Mode() As eSurveyCodeListModeConstants
    
    Mode = meMode
    
End Property

Public Property Let Mode(ByVal eData As eSurveyCodeListModeConstants)
    
    'Save the value
    meMode = eData
    
    'Setup the screen
    Select Case meMode
        Case eSurveyCodeListModeConstants.eSCLAddMode
            optSurvey(0).Value = True
            'cboClient.Enabled = True
            'cboStudy.Enabled = True
            'cboSurvey.Enabled = True
            cboHeader.Enabled = True
            cboSubHeader.Enabled = True
            
        Case eSurveyCodeListModeConstants.eSCLEditMode
            optSurvey(0).Enabled = False
            optSurvey(1).Enabled = False
            lblClient.Enabled = False
            cboClient.Enabled = False
            lblStudy.Enabled = False
            cboStudy.Enabled = False
            lblSurvey.Enabled = False
            cboSurvey.Enabled = False
            lblSurveyID.Enabled = False
            txtSurveyID.Enabled = False
            cmdFind.Enabled = False
            cboHeader.Enabled = True
            cboSubHeader.Enabled = True
            
    End Select
    
End Property

Private Sub optSurvey_Click(Index As Integer)
    
    If optSurvey(0).Value = True Then
        lblClient.Enabled = True
        cboClient.Enabled = True
        lblStudy.Enabled = True
        cboStudy.Enabled = True
        lblSurvey.Enabled = True
        cboSurvey.Enabled = True
        lblSurveyID.Enabled = False
        txtSurveyID.Enabled = False
        cmdFind.Enabled = False
    Else
        lblClient.Enabled = False
        cboClient.Enabled = False
        lblStudy.Enabled = False
        cboStudy.Enabled = False
        lblSurvey.Enabled = False
        cboSurvey.Enabled = False
        lblSurveyID.Enabled = True
        txtSurveyID.Enabled = True
        cmdFind.Enabled = True
    End If
    
End Sub


Private Sub txtSurveyID_GotFocus()
    
    SelectAllText txtSurveyID
    
End Sub


