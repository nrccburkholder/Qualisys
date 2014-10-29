VERSION 5.00
Object = "{57F57641-590A-11D1-9464-00AA006F7AF1}#1.0#0"; "GSCboBox.ocx"
Object = "{F6F1BF46-5475-11D1-9464-00AA006F7AF1}#1.1#0"; "GSREdit.ocx"
Begin VB.Form frmSurveyBDUSList 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Add/Edit MetaField Mapping"
   ClientHeight    =   5550
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5835
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5550
   ScaleWidth      =   5835
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fraMetaField 
      Caption         =   " MetaField Selection "
      Height          =   1755
      Left            =   120
      TabIndex        =   12
      Top             =   3060
      Width           =   5595
      Begin VB.CheckBox chkRequired 
         Caption         =   "This Field Requires Input (Not Optional)"
         Height          =   315
         Left            =   2040
         TabIndex        =   19
         Top             =   1260
         Width           =   3375
      End
      Begin GSRealEditAciveX.GSRealEdit redOrder 
         Height          =   315
         Left            =   1140
         TabIndex        =   18
         Top             =   1260
         Width           =   435
         _ExtentX        =   767
         _ExtentY        =   556
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Max             =   99
         Min             =   1
         Precision       =   0
         Value           =   1
      End
      Begin VB.TextBox txtValidValues 
         Height          =   315
         Left            =   1140
         MaxLength       =   1000
         TabIndex        =   16
         Top             =   780
         Width           =   4275
      End
      Begin GSEnhComboBox.GSComboBox cboMetaField 
         Height          =   315
         Left            =   1140
         TabIndex        =   14
         Top             =   300
         Width           =   4275
         _ExtentX        =   7541
         _ExtentY        =   556
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.Label lblOrder 
         Caption         =   "Order:"
         Height          =   195
         Left            =   180
         TabIndex        =   17
         Top             =   1320
         Width           =   915
      End
      Begin VB.Label lblMetaField 
         Caption         =   "MetaField:"
         Height          =   195
         Left            =   180
         TabIndex        =   13
         Top             =   360
         Width           =   915
      End
      Begin VB.Label lblValidValues 
         Caption         =   "Valid Values:"
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
            Name            =   "Tahoma"
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
            Name            =   "Tahoma"
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
            Name            =   "Tahoma"
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
      TabIndex        =   21
      Top             =   4980
      Width           =   1155
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   435
      Left            =   3300
      TabIndex        =   20
      Top             =   4980
      Width           =   1155
   End
End
Attribute VB_Name = "frmSurveyBDUSList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mdtModified As Date
    Private meMode      As eSurveyBDUSListModeConstants
    Private mbOKClicked As Boolean
    

Private Sub LoadMetaFieldComboBox()
    
    Dim sSql As String
    Dim oTempRs As ADODB.Recordset
        
    'If nothing is selected in Survey then head out of dodge
    If cboStudy.ListIndex < 0 Then Exit Sub

    'Clear the combo
    cboMetaField.Clear
    
    'Get the data to be loaded
    sSql = "SELECT mt.strTable_Nm, mf.strField_Nm, ms.Field_id " & _
           "FROM MetaStructure ms, MetaField mf, MetaTable mt " & _
           "WHERE ms.Table_id = mt.Table_id " & _
           "  AND ms.Field_id = mf.Field_id " & _
           "  AND mt.strTable_Nm = 'population' " & _
           "  AND ms.bitUserField_Flg = 1 " & _
           "  AND ms.bitMatchField_Flg = 0 " & _
           "  AND ms.bitPostedField_Flg = 1 " & _
           "  AND ms.Study_id = " & StudyID & " " & _
           "ORDER BY mf.strField_Nm"
    Set oTempRs = goDMConn.Execute(sSql)
    
    'Populate the combo
    Do Until oTempRs.EOF
        'Add this Header to the combo
        With cboMetaField
            .AddItem "" & Trim(oTempRs!strTable_Nm) & "." & Trim(oTempRs!strField_Nm)
            .ItemData(.NewIndex) = oTempRs!Field_id
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
    cboSurvey.Clear
    txtSurveyID.Text = ""
    cboMetaField.Clear
    
End Sub



Private Sub cboStudy_Click()
    
    LoadSurveyComboBox
    txtSurveyID.Text = ""
    LoadMetaFieldComboBox
    
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
    sSql = "SELECT Distinct Client_id, Study_id " & _
           "FROM ClientStudySurvey " & _
           "WHERE Survey_id = " & lSurveyID
    Set oTempRs = goDMConn.Execute(sSql)
    
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
    
    'See if the data is valid
    If Not IsDataValid Then Exit Sub
    
    'Start the error trap
    On Error GoTo ErrorHandler
    
    'If we made it to here then save the data
    Select Case meMode
        Case eSurveyBDUSListModeConstants.eSBLAddMode
            'Insert the new record
            sSql = "INSERT INTO BDUS_MetaFieldLookup (Survey_id, Field_id, intOrder, strValidValues, bitRequired) " & _
                   "VALUES (" & SurveyID & ", " & MetaFieldID & ", " & Order & ", '" & ValidValues & "', " & IIf(Required, 1, 0) & ")"
            goConn.Execute (sSql)
        
        Case eSurveyBDUSListModeConstants.eSBLEditMode
            'Save the changes to this record
            sSql = "UPDATE BDUS_MetaFieldLookup " & _
                   "SET strValidValues = '" & ValidValues & "', " & _
                   "    intOrder = " & Order & ", " & _
                   "    bitRequired = " & IIf(Required, 1, 0) & " " & _
                   "WHERE Survey_id = " & SurveyID & " " & _
                   "  AND Field_id = " & MetaFieldID
            goConn.Execute (sSql)
            
    End Select
    
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
    ElseIf cboMetaField.ListIndex < 0 Then
        sMsg = "You must select a MetaField from the list!"
        cboMetaField.SetFocus
    ElseIf Not redOrder.IsValidRange Then
        sMsg = "Order must be between " & redOrder.Min & " and " & redOrder.Max & "!"
        redOrder.SetFocus
    Else
        If meMode = eSBLAddMode Then
            'Check to see if this one already exists
            sSql = "SELECT Count(*) AS QtyRec " & _
                   "FROM BDUS_MetaFieldLookup " & _
                   "WHERE Survey_id = " & SurveyID & " " & _
                   "  AND Field_id = " & MetaFieldID
            Set oTempRs = goConn.Execute(sSql)
            
            If oTempRs("QtyRec").Value > 0 Then
                sMsg = "A mapping for the specified survey and MetaField already exists!"
                cboMetaField.SetFocus
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

Public Property Get MetaField() As String
    
    MetaField = cboMetaField.Text
    
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


Public Property Get ValidValues() As String
    
    ValidValues = Trim(txtValidValues.Text)
    
End Property

Public Property Get Order() As Long
    
    Order = redOrder.Value
    
End Property

Public Property Get Required() As Boolean
    
    Required = chkRequired.Value
    
End Property

Public Property Get MetaFieldID() As Long
    
    MetaFieldID = cboMetaField.ItemData(cboMetaField.ListIndex)
    
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

Public Property Let ValidValues(ByVal sData As String)
    
    txtValidValues.Text = sData
    
End Property
Public Property Let Order(ByVal lData As Long)
    
    redOrder.Value = lData
    
End Property

Public Property Let Required(ByVal bData As Boolean)
    
    chkRequired.Value = IIf(bData, vbChecked, vbUnchecked)
    
End Property

Public Property Let MetaFieldID(ByVal lData As Long)
    
    Dim lCnt As Long
    
    With cboMetaField
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


Public Property Get Mode() As eSurveyBDUSListModeConstants
    
    Mode = meMode
    
End Property

Public Property Let Mode(ByVal eData As eSurveyBDUSListModeConstants)
    
    'Save the value
    meMode = eData
    
    'Setup the screen
    Select Case meMode
        Case eSurveyBDUSListModeConstants.eSBLAddMode
            optSurvey(0).Value = True
            lblMetaField.Enabled = True
            cboMetaField.Enabled = True
            txtValidValues.Enabled = True
            redOrder.Enabled = True
            chkRequired.Enabled = True
            
        Case eSurveyBDUSListModeConstants.eSBLEditMode
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
            lblMetaField.Enabled = False
            cboMetaField.Enabled = False
            txtValidValues.Enabled = True
            redOrder.Enabled = True
            chkRequired.Enabled = True
            
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


Private Sub txtValidValues_GotFocus()
    
    SelectAllText txtValidValues

End Sub


