VERSION 5.00
Begin VB.Form frmMailRoomSupport 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Production Support"
   ClientHeight    =   5205
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5895
   ControlBox      =   0   'False
   Icon            =   "MailRoomSupport.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5205
   ScaleWidth      =   5895
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox tbxIntDays 
      Enabled         =   0   'False
      Height          =   375
      Left            =   2400
      TabIndex        =   11
      Top             =   2280
      Width           =   2655
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Height          =   495
      Left            =   960
      TabIndex        =   10
      Top             =   4200
      Width           =   1815
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   3120
      TabIndex        =   9
      Top             =   4200
      Width           =   1815
   End
   Begin VB.TextBox tbxLitho 
      Height          =   375
      Left            =   1920
      TabIndex        =   5
      Top             =   360
      Width           =   2655
   End
   Begin VB.TextBox tbxCurrLang 
      Enabled         =   0   'False
      Height          =   375
      Left            =   2400
      Locked          =   -1  'True
      TabIndex        =   4
      Top             =   2820
      Width           =   2655
   End
   Begin VB.ComboBox CboLang 
      Enabled         =   0   'False
      Height          =   315
      Left            =   2400
      TabIndex        =   3
      Top             =   3360
      Width           =   2655
   End
   Begin VB.CommandButton cmdGo 
      Caption         =   "&Lookup"
      Enabled         =   0   'False
      Height          =   375
      Left            =   4680
      TabIndex        =   2
      Top             =   360
      Width           =   975
   End
   Begin VB.OptionButton OptRegen 
      Caption         =   "Regenerate Form"
      Height          =   495
      Left            =   2040
      TabIndex        =   1
      Top             =   1440
      Width           =   1695
   End
   Begin VB.OptionButton OptTOCL 
      Caption         =   "Do Not Contact List"
      Height          =   495
      Left            =   2040
      TabIndex        =   0
      Top             =   840
      Width           =   1695
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      Caption         =   "Interval Days:"
      Enabled         =   0   'False
      Height          =   255
      Left            =   1080
      TabIndex        =   12
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "LithoCode:"
      Height          =   255
      Left            =   960
      TabIndex        =   8
      Top             =   480
      Width           =   855
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Current Language:"
      Enabled         =   0   'False
      Height          =   255
      Left            =   840
      TabIndex        =   7
      Top             =   2820
      Width           =   1455
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Change Language To:"
      Enabled         =   0   'False
      Height          =   255
      Left            =   480
      TabIndex        =   6
      Top             =   3360
      Width           =   1815
   End
End
Attribute VB_Name = "frmMailRoomSupport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mlngPopID As Long
Private mlngSamplePopID As Long
Private mlngStudyID As Long
Private mlngSurveyID As Long
Private mstrCurrentLanguage As String
Private mlngMethodologyID As Long
Private mbolLanguageFlag As Boolean
Private mlngNewLanguageID As Long
Private mlngIntervalDays As Long
Private mstrLithoCode As String
Private mobjLanguageRS As ADODB.Recordset
Private mdatExpire As Date   '** 04-06-09 JJF - Added code to get datExpire

Private Sub Form_Activate()
    
    tbxLitho.SetFocus

End Sub

Private Sub Form_Load()

'    Me.tbxLitho.Text = "180108  "

End Sub

Private Sub Form_Unload(Cancel As Integer)
    
    Set mobjLanguageRS = Nothing

End Sub

Private Sub OptRegen_Click()
    
    Me.cmdGo.Enabled = True
    Me.cmdOK.Enabled = False
    
End Sub

Private Sub OptTOCL_Click()
    
    Me.cmdGo.Enabled = False
    Me.cmdOK.Enabled = True
    Me.tbxCurrLang.Enabled = False
    Me.tbxIntDays.Enabled = False
    Me.CboLang.Enabled = False
    Me.Label2.Enabled = False
    Me.Label3.Enabled = False
    Me.Label4.Enabled = False
    'Me.cmdOK.Enabled = False

End Sub

Private Sub tbxIntDays_LostFocus()
    
    If Not IsNumeric(tbxIntDays.Text) Then
        MsgBox "Enter a Number Greater Than Or Equal to Zero", vbOKOnly, "Queue Manager"
        tbxIntDays.Text = ""
        tbxIntDays.SetFocus
    End If

End Sub

Private Sub cmdCancel_Click()
    
    Unload Me

End Sub

Private Sub cmdGo_Click()
    
    'On Error GoTo ErrorHandler
    'Check to see if LithoCode is entered.
    If Me.tbxLitho = "" Then
        MsgBox "You Have to Enter LithoCode First!", vbOKOnly, "Queue Manager"
        Me.tbxLitho.SetFocus
        Exit Sub
    End If
    
    'Assign LithoCode to a variable to verify later if its changed
    mstrLithoCode = Trim(tbxLitho.Text)
    
    'Check to see if all IDs are available for the Lithocode and enable controls
    If GetIDs(mstrLithoCode) = True Then
        Me.tbxCurrLang.Enabled = True
        Me.tbxIntDays.Enabled = True
        Me.CboLang.Enabled = True
        Me.Label2.Enabled = True
        Me.Label3.Enabled = True
        Me.Label4.Enabled = True
        Me.cmdOK.Enabled = True
        Call Lang_proc
        Me.tbxCurrLang.Text = mstrCurrentLanguage
    Else
        MsgBox "Data Not Found for This LithoCode!", vbOKOnly, "Queue Manager"
        Me.tbxLitho.SetFocus
        Exit Sub
    End If
    
ErrorHandlerDone:
    Exit Sub

ErrorHandler:
    MsgBox Err.Number & Err.Description, vbCritical, "MailRoom Support"
    Resume ErrorHandlerDone
    
End Sub

Private Sub cmdOk_Click()

    On Error GoTo ErrorHandler

    If Me.tbxLitho = "" Then
        MsgBox "You Have to Enter LithoCode First!", vbOKOnly, "Queue Manager"
        Me.tbxLitho.SetFocus
        Exit Sub
    End If
    
    If Me.OptTOCL.Value = True Then
        'This will run if user has chosen to TOCL
        If GetIDs(Trim(tbxLitho.Text)) = True Then
            Dim strConfirm As String, VResponse
            strConfirm = "Are You Sure You Want To Take Off Call List?"
            VResponse = MsgBox(strConfirm, vbYesNo, "Queue Manager")
            If VResponse = vbYes Then
                Call TOCL_proc
            Else
                Exit Sub
            End If
        Else
            MsgBox "Data Not Found for This LithoCode!", vbOKOnly, "Queue Manager"
            Me.tbxLitho.SetFocus
            Exit Sub
        End If
    Else
        'This will run if user chose to Regenerate
        If Not Trim(tbxLitho.Text) = mstrLithoCode Then
            'Check to see if lithocode is changed and make user choose Lookup again
            MsgBox "LithoCode has Changed. Click on Lookup Again", vbOKOnly, "Queue Manager"
            Me.tbxCurrLang.Enabled = False
            Me.tbxCurrLang.Text = ""
            Me.tbxIntDays.Enabled = False
            Me.CboLang.Enabled = False
            Me.Label2.Enabled = False
            Me.Label3.Enabled = False
            Me.Label4.Enabled = False
            Me.cmdOK.Enabled = False
            Exit Sub
        End If
        
        '** 04-06-09 JJF - Added check for expired LithoCode
        'Check to see if the LithoCode is already expired
        If mdatExpire < Now Then
            MsgBox "This LithoCode is already expired and cannot be regenerated!", vbOKOnly, "Queue Manager"
            Exit Sub
        End If
        '** 04-06-09 JJF - End of add
        
        'Make sure they have entered the interval days
        If Me.tbxIntDays.Text = "" Then
            MsgBox "Interval Days Cannot Be Empty", vbOKOnly, "Queue Manager"
            Exit Sub
        Else
            mlngIntervalDays = CInt(Me.tbxIntDays.Text)
        End If
        
        'Check to see if we are generating in a different language
        If Not Me.CboLang.Text = "" And Not Me.CboLang.Text = Me.tbxCurrLang Then
            'This means that the language has been changed and flag is set
            mbolLanguageFlag = True
            mobjLanguageRS.MoveFirst
            While Not mobjLanguageRS.EOF
                If mobjLanguageRS!language = Me.CboLang.Text Then
                    mlngNewLanguageID = mobjLanguageRS!LangID
                    GoTo OutofLoop
                Else
                    mobjLanguageRS.MoveNext
                End If
            Wend
            If mlngNewLanguageID = 0 Then
                MsgBox "Language Not From List", vbOKOnly, "Queue Manager"
                CboLang.Text = ""
                Exit Sub
            End If
        End If
OutofLoop:
        Call OverRide_proc
    End If

    Unload Me
    
ErrorHandlerDone:
    Exit Sub
    
ErrorHandler:
    MsgBox Err.Number & Err.Description, vbCritical, "MailRoom Support"
    Resume ErrorHandlerDone
    
End Sub

Public Function GetIDs(LithoCode As String) As Boolean
    
    Dim objDataAccess 'As QueueManDLL.cMRDataAccess
    Dim objTempRS As ADODB.Recordset
    
    On Error GoTo ErrorHandler
    
    Set objDataAccess = CreateObject("QueueManDLL.cMRDataAccess")
    
    Set objTempRS = objDataAccess.DB_GetIDs(LithoCode)
    
    If Not objTempRS.EOF And Not objTempRS.BOF Then
        objTempRS.MoveFirst
        mlngSamplePopID = objTempRS!SamplePop_id
        mlngPopID = objTempRS!pop_id
        mlngStudyID = objTempRS!study_id
        mlngSurveyID = objTempRS!Survey_id
        mlngMethodologyID = objTempRS!methodology_id
        mdatExpire = IIf(IsNull(objTempRS!datExpire), CDate("12/31/2099"), objTempRS!datExpire)  '** 04-06-09 JJF - Added
        GetIDs = True
    Else
        GetIDs = False
    End If
 
    objTempRS.Close
    Set objTempRS = Nothing
    Set objDataAccess = Nothing
   
ErrorHandlerDone:
    Exit Function
    
ErrorHandler:
    MsgBox Err.Number & Err.Description, vbCritical, "MailRoom Support"
    Resume ErrorHandlerDone
    
End Function

Public Sub TOCL_proc()
    
    On Error GoTo ErrorHandler
    
    Dim objDataAccess As QueueManDLL.cMRDataAccess
    
    Set objDataAccess = CreateObject("QueueManDLL.cMRDataAccess")
    Call objDataAccess.DB_TOCL(mlngStudyID, mlngPopID, mlngSamplePopID)

ErrorHandlerDone:
    Exit Sub
    
ErrorHandler:
    MsgBox Err.Number & Err.Description, vbCritical, "MailRoom Support"
    Resume ErrorHandlerDone
    
End Sub

Public Sub Lang_proc()
    
    On Error GoTo ErrorHandler
    
    Dim objDataAccess 'As QueueManDLL.cMRDataAccess
    
    Set objDataAccess = CreateObject("QueueManDLL.cMRDataAccess")
    mstrCurrentLanguage = objDataAccess.DB_GetLang(mlngStudyID, mlngPopID)
    Set mobjLanguageRS = objDataAccess.DB_GetAllLangs(mlngSurveyID)
        
    CboLang.Clear
    CboLang.Text = ""
    
    If Not mobjLanguageRS.EOF And Not mobjLanguageRS.BOF Then
        mobjLanguageRS.MoveFirst
        While Not mobjLanguageRS.EOF
            Me.CboLang.AddItem mobjLanguageRS!language
            If Not mobjLanguageRS.EOF Then mobjLanguageRS.MoveNext
        Wend
    End If
        
ErrorHandlerDone:
    Exit Sub
    
ErrorHandler:
    MsgBox Err.Number & Err.Description, vbCritical, "MailRoom Support"
    Resume ErrorHandlerDone
    
End Sub

Public Sub OverRide_proc()
    
    On Error GoTo ErrorHandler
    
    Dim objDataAccess As QueueManDLL.cMRDataAccess
    
    Set objDataAccess = CreateObject("QueueManDLL.cMRDataAccess")
    Call objDataAccess.DB_UpdateLang(mlngStudyID, mlngPopID, mlngSamplePopID, mlngMethodologyID, mlngNewLanguageID, mlngIntervalDays, mbolLanguageFlag)

ErrorHandlerDone:
    Exit Sub

ErrorHandler:
    MsgBox Err.Number & Err.Description, vbCritical, "MailRoom Support"
    Resume ErrorHandlerDone

End Sub
