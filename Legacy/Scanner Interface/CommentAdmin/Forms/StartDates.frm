VERSION 5.00
Object = "{57F57641-590A-11D1-9464-00AA006F7AF1}#1.0#0"; "GSCboBox.ocx"
Begin VB.Form frmStartDates 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Add/Edit Skip Surveys"
   ClientHeight    =   2535
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5835
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2535
   ScaleWidth      =   5835
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fraDialog 
      Height          =   1755
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   5595
      Begin GSEnhComboBox.GSComboBox cboClient 
         Height          =   315
         Left            =   1140
         TabIndex        =   2
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
      Begin GSEnhComboBox.GSComboBox cboStudy 
         Height          =   315
         Left            =   1140
         TabIndex        =   4
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
      Begin GSEnhComboBox.GSComboBox cboSurvey 
         Height          =   315
         Left            =   1140
         TabIndex        =   6
         Top             =   1260
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
         Caption         =   "Client:"
         Height          =   195
         Left            =   180
         TabIndex        =   1
         Top             =   360
         Width           =   915
      End
      Begin VB.Label lblSubHeader 
         Caption         =   "Study:"
         Height          =   195
         Left            =   180
         TabIndex        =   3
         Top             =   840
         Width           =   915
      End
      Begin VB.Label lblCode 
         Caption         =   "Survey:"
         Height          =   195
         Left            =   180
         TabIndex        =   5
         Top             =   1320
         Width           =   915
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   435
      Left            =   4560
      TabIndex        =   8
      Top             =   1980
      Width           =   1155
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   435
      Left            =   3300
      TabIndex        =   7
      Top             =   1980
      Width           =   1155
   End
End
Attribute VB_Name = "frmStartDates"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mdtModified As Date
    Private meMode      As eStartDateModeConstants
    Private mbOKClicked As Boolean
    
Private Sub LoadSurveyComboBox()
    
    Dim sSql As String
    Dim oTempRs As ADODB.Recordset
    
    'If nothing is selected in Client then head out of dodge
    If cboStudy.ListIndex < 0 Then Exit Sub
    
    'Clear the combo
    cboSurvey.Clear
    
    'Get the data to be loaded
    sSql = "SELECT Survey_id, strQSurvey_Nm AS strSurvey_Nm " & _
           "FROM ClientStudySurvey " & _
           "WHERE Study_id = " & cboStudy.ItemData(cboStudy.ListIndex) & " " & _
           "ORDER BY strSurvey_Nm"
    Set oTempRs = goDMConn.Execute(sSql)
    
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
    sSql = "SELECT Distinct Study_id, strStudy_Nm " & _
           "FROM ClientStudySurvey " & _
           "WHERE Client_id = " & cboClient.ItemData(cboClient.ListIndex) & " " & _
           "ORDER BY strStudy_Nm"
    Set oTempRs = goDMConn.Execute(sSql)
    
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
    sSql = "SELECT Distinct Client_id, strClient_Nm " & _
           "FROM ClientStudySurvey " & _
           "ORDER BY strClient_Nm"
    Set oTempRs = goDMConn.Execute(sSql)
    
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
    
End Sub

Private Sub cboStudy_Click()
    
    LoadSurveyComboBox
    
End Sub

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
    
    'If we made it to here then save the data
    Select Case meMode
        Case eStartDateModeConstants.eSDMAddMode
            'Insert the new record
            sSql = "INSERT INTO CommentSkipSurveys (Survey_id, strModifiedBy, datModified) " & _
                   "VALUES (" & SurveyID & ", '" & Left(goUserInfo.UserName, 50) & "', GetDate())"
            goConn.Execute (sSql)
        
        Case eStartDateModeConstants.eSDMEditMode
            'Save the changes to this record
            sSql = "UPDATE CommentSkipSurveys " & _
                   "SET strModifiedBy = '" & Left(goUserInfo.UserName, 50) & "', " & _
                   "    datModified = GetDate() " & _
                   "WHERE Survey_id = " & SurveyID
            goConn.Execute (sSql)
            
    End Select
    
    'Get the date for the modified record
    sSql = "SELECT datModified " & _
           "FROM CommentSkipSurveys " & _
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
    If cboClient.ListIndex < 0 Then
        sMsg = "You must select a client from the list!"
        cboClient.SetFocus
    ElseIf cboStudy.ListIndex < 0 Then
        sMsg = "You must select a study from the list!"
        cboStudy.SetFocus
    ElseIf cboSurvey.ListIndex < 0 Then
        sMsg = "You must select a survey from the list!"
        cboSurvey.SetFocus
    Else
        If meMode = eSDMAddMode Then
            'Check to see if this one already exists
            sSql = "SELECT Count(*) AS QtyRec " & _
                   "FROM CommentSkipSurveys " & _
                   "WHERE Survey_id = " & SurveyID
            Set oTempRs = goConn.Execute(sSql)
            
            If oTempRs("QtyRec").Value > 0 Then
                sMsg = "The specified Survey already exists!"
                cboSurvey.SetFocus
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

Public Property Get Study() As String
    
    Study = cboStudy.Text
    
End Property


Public Property Get Survey() As String
    
    Survey = cboSurvey.Text
    
End Property


Public Property Get Client() As String
    
    Client = cboClient.Text
    
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


Public Property Get Mode() As eStartDateModeConstants
    
    Mode = meMode
    
End Property

Public Property Let Mode(ByVal eData As eStartDateModeConstants)
    
    'Save the value
    meMode = eData
    
    'Setup the screen
    Select Case meMode
        Case eStartDateModeConstants.eSDMAddMode
            cboClient.Enabled = True
            cboStudy.Enabled = True
            cboSurvey.Enabled = True
            
        Case eStartDateModeConstants.eSDMEditMode
            cboClient.Enabled = False
            cboStudy.Enabled = False
            cboSurvey.Enabled = False
        
    End Select
    
End Property
