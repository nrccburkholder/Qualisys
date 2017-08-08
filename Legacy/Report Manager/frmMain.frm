VERSION 5.00
Begin VB.Form frmMain 
   Caption         =   "Report Manager"
   ClientHeight    =   5925
   ClientLeft      =   405
   ClientTop       =   525
   ClientWidth     =   5115
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5925
   ScaleWidth      =   5115
   Begin VB.CommandButton cmdExit 
      BackColor       =   &H00C0C0C0&
      Caption         =   "E&xit"
      Height          =   360
      Left            =   3720
      TabIndex        =   9
      Top             =   5400
      Width           =   1200
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   2895
      Left            =   0
      ScaleHeight     =   2895
      ScaleWidth      =   5055
      TabIndex        =   3
      Top             =   2160
      Width           =   5055
      Begin VB.TextBox txtSearchSpec 
         Height          =   285
         Left            =   2520
         TabIndex        =   7
         Text            =   "*.MDB"
         Top             =   120
         Visible         =   0   'False
         Width           =   2415
      End
      Begin VB.FileListBox filList 
         Height          =   2235
         Left            =   120
         TabIndex        =   6
         Top             =   480
         Width           =   2295
      End
      Begin VB.DirListBox dirList 
         Height          =   2340
         Left            =   2520
         TabIndex        =   5
         Top             =   480
         Width           =   2415
      End
      Begin VB.DriveListBox drvList 
         Height          =   315
         Left            =   2520
         TabIndex        =   4
         Top             =   120
         Width           =   2415
      End
      Begin VB.Label lblCriteria 
         Alignment       =   2  'Center
         Caption         =   "Select Ad Hoc Report"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   240
         Width           =   2295
      End
   End
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   975
      Left            =   120
      Picture         =   "frmMain.frx":0A8A
      ScaleHeight     =   945
      ScaleWidth      =   1185
      TabIndex        =   2
      Top             =   0
      Width           =   1215
   End
   Begin VB.CommandButton cbCallReport 
      Caption         =   "&Report"
      Height          =   375
      Left            =   3000
      TabIndex        =   1
      Top             =   1440
      Width           =   1095
   End
   Begin VB.ComboBox cboxReports 
      Height          =   315
      ItemData        =   "frmMain.frx":3BBC
      Left            =   120
      List            =   "frmMain.frx":3BBE
      TabIndex        =   0
      Top             =   1440
      Width           =   2295
   End
   Begin VB.Label lblReportManager 
      Caption         =   "Report Manager"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1560
      TabIndex        =   11
      Top             =   240
      Width           =   3135
   End
   Begin VB.Label lblSelectReport 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H80000004&
      Caption         =   "Select Existing Report"
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   0
      TabIndex        =   10
      Top             =   1200
      Width           =   2415
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim SearchFlag As Integer
Dim strMDB As String
Dim gstrMDB As String
'Dim QualProConnect As ClientConnection.Connection ' 09-28-2002 SH
Dim QualiSysConnect As New QualiSysFunctions.Library
Dim rsReports As New ADODB.Recordset
Dim CN As New ADODB.Connection
Dim intStudy_ID As Long
Dim intSurvey_id As Long
Dim intSampleSet_id As Long

Private Sub cbCallReport_Click()
    
    Dim lngReturn As Long
    Dim strPath As String
    Dim strCommand As String
    Dim oSurveySelector As SurveySelector.SurveySelectorGUI
    Dim oSampleset As New frmSampleSet
    
    If cboxReports.ListIndex = -1 Then
        cboxReports.Text = " "
        Exit Sub
    End If
    
    If cboxReports = "" Then
        MsgBox "Please select a Report", vbCritical, "Select Report"
        Exit Sub
    End If
    
    If strMDB = "" Then
        strMDB = """" & gstrMDB & cboxReports & ".MDB"""
    Else
        strMDB = strMDB & cboxReports & """"
    End If
    
    If cboxReports = "Sample Plan" Or cboxReports = "Response Rate" Then
        Set oSurveySelector = CreateObject("SurveySelector.SurveySelectorGUI")
        oSurveySelector.study_id = intStudy_ID
        oSurveySelector.fctGetSurvey_Id
        intSurvey_id = oSurveySelector.SurveyId
        Set oSurveySelector = Nothing
        If intSurvey_id = 0 Then Exit Sub
        oSampleset.Survey_id = intSurvey_id
        oSampleset.DBConnection = CN
        'oSampleset.Show vbModal
        If cboxReports <> "Response Rate" Then
            oSampleset.Go Me
            intSampleSet_id = oSampleset.SampleSet_id
            Set oSampleset = Nothing
            If intSampleSet_id = 0 Then Exit Sub
        End If
    End If
    
    strPath = Dir("C:\Program Files\MICROSOFT OFFICE\OFFICE\MSACCESS.EXE")
'    strPath = Dir("C:\Program Files\MSOffice\Access\MSACCESS.EXE")
    
    If strPath = "" Then
        strPath = Dir("C:\MSOffice\Access\MSACCESS.EXE")
        If strPath = "" Then
            MsgBox "MS Access Not Found"
            Exit Sub
        Else
            strPath = "C:\MSOffice\Access\MSACCESS.EXE"
        End If
    Else
        strPath = """C:\Program Files\MICROSOFT OFFICE\OFFICE\MSACCESS.EXE"""
'        strPath = """C:\Program Files\MSOffice\Access\MSACCESS.EXE"""
    End If
    
    If cboxReports <> "Sample Plan" And cboxReports <> "Response Rate" Then
        strCommand = "/cmd """ & CN & ";StudyID=" & intStudy_ID & """"
        'strCommand = "/cmd """ & cn & """"
    Else
        strCommand = "/cmd """ & CN & ";StudyID=" & intStudy_ID & ";Survey=" & intSurvey_id & ";SampleSet=" & intSampleSet_id & """"
    End If
    
    lngReturn = Shell(strPath & " " & strMDB & " " & strCommand, vbMaximizedFocus)
    strMDB = ""

End Sub

Private Sub cboxReports_Click()

    On Error GoTo cboxReports_error
    
    Me.MousePointer = vbHourglass
    rsReports.MoveFirst
    rsReports.Move cboxReports.ListIndex
    
    If rsReports.BOF Then
        ' no nothing because we are at the beginning of file
    Else
        If rsReports.EOF Then
            'do nothing because we are at the end of file
        Else
            gstrMDB = rsReports.Fields(2)
        End If
    End If
    
    Me.MousePointer = vbDefault
    
    Exit Sub

cboxReports_error:
    If Err.Number <> 0 Then
        Me.MousePointer = vbDefault
        Exit Sub
    End If

End Sub

Private Sub cboxReports_KeyPress(KeyAscii As Integer)
    
    MsgBox "Do not type in this box"

End Sub

Private Sub cmdExit_Click()
    
    End

End Sub

Private Function DirDiver(NewPath As String, DirCount As Integer, BackUp As String) As Integer
    
    Static FirstErr As Integer
    
    Dim DirsToPeek As Integer, AbandonSearch As Integer, ind As Integer
    Dim OldPath As String, ThePath As String, entry As String
    Dim retval As Integer
    
    SearchFlag = True           ' Set flag so the user can interrupt.
    DirDiver = False            ' Set to True if there is an error.
    retval = DoEvents()         ' Check for events (for instance, if the user chooses Cancel).
    If SearchFlag = False Then
        DirDiver = True
        Exit Function
    End If
    
    On Local Error GoTo DirDriverHandler
    
    DirsToPeek = dirList.ListCount                  ' How many directories below this?
    
    Do While DirsToPeek > 0 And SearchFlag = True
        OldPath = dirList.Path                      ' Save old path for next recursion.
        dirList.Path = NewPath
        If dirList.ListCount > 0 Then
            dirList.Path = dirList.List(DirsToPeek - 1)
            AbandonSearch = DirDiver((dirList.Path), DirCount%, OldPath)
        End If
        DirsToPeek = DirsToPeek - 1
        If AbandonSearch = True Then Exit Function
    Loop
    
    If filList.ListCount Then
        If Len(dirList.Path) <= 3 Then             ' Check for 2 bytes/character
            ThePath = dirList.Path                  ' If at root level, leave as is...
        Else
            ThePath = dirList.Path + "\"            ' Otherwise put "\" before the filename.
        End If
        For ind = 0 To filList.ListCount - 1        ' Add conforming files in this directory to the list box.
            entry = ThePath + filList.List(ind)
        Next ind
    End If
    
    If BackUp <> "" Then        ' If there is a superior directory, move it.
        dirList.Path = BackUp
    End If
    
    Exit Function

DirDriverHandler:
    If Err = 7 Then             ' If Out of Memory error occurs, assume the list box just got full.
        DirDiver = True         ' Create Msg and set return value AbandonSearch.
        MsgBox "You've filled the list box. Abandoning search..."
        Exit Function           ' Note that the exit procedure resets Err to 0.
    Else                        ' Otherwise display error message and quit.
        MsgBox Error
        End
    End If

End Function

Private Sub DirList_Change()
    
    filList.Path = dirList.Path

End Sub

Private Sub DirList_LostFocus()
    
    dirList.Path = dirList.List(dirList.ListIndex)

End Sub

Private Sub DrvList_Change()
    
    On Error GoTo DriveHandler
    
    dirList.Path = drvList.Drive
    Exit Sub

DriveHandler:
    drvList.Drive = dirList.Path
    Exit Sub

End Sub

Private Sub filList_Click()
    
    cboxReports = filList
    strMDB = """" & dirList & "\"

End Sub

Private Sub filList_DblClick()
    
    filList_Click
    cbCallReport_Click

End Sub

Private Sub Form_Load()

    'On Error GoTo Form_Load_err
    
    Dim strSQL As String
    frmSplash.Show
    DoEvents
    
    ' This sub gets the ball rolling
    Dim StudyObject As StudySelector.StudySelectorGUI
    
    ' Create an object for the study selector
GetStudy:
    Set StudyObject = CreateObject("StudySelector.StudySelectorGUI")
    
    ' Send the users Id to the study selector
    StudyObject.EmployeeId = lngEmployeeID
    
    ' If the study selector returns a value greater than 0, we got one
    If StudyObject.GetClientIds > 0 Then
        intStudy_ID = StudyObject.StudyId
    Else
        ' No studys defined for user or they hit cancel.  Either way end the program
        Set StudyObject = Nothing
        End
    End If
    
    Set StudyObject = Nothing
    
    ' Removed 09-28-2002 SH
    'Set QualProConnect = CreateObject("ClientConnection.Connection")
    '
    'Set CN = QualProConnect.ClientConnect(ReportManager)
    ' Added 09-28-2002 SH
    CN.Open QualiSysConnect.GetDBString
    
    strSQL = "exec sp_GetReportManager_Fields"
    Set rsReports = CN.Execute(strSQL, adOpenKeyset)
    
    Do Until rsReports.EOF
        cboxReports.AddItem rsReports.Fields(1)
        rsReports.MoveNext
    Loop
    
    txtSearchSpec_Change
    frmSplash.Hide
    
Form_Load_err:
    If Err.Number = 429 Then
        MsgBox "Cannot Establish Connection.  Please contact the Lan Administrator.", vbCritical
        frmSplash.Hide
        End
    End If
    If Err.Number = 6 Then
        MsgBox "Error in loading Report Manager.  Exiting."
        End
    End If

End Sub

Private Sub Form_Unload(Cancel As Integer)
    
    rsReports.Close
    Set CN = Nothing
    Set QualiSysConnect = Nothing
    End

End Sub

Private Sub txtSearchSpec_Change()
    
    filList.Pattern = txtSearchSpec.Text

End Sub

Private Sub txtSearchSpec_GotFocus()
    
    txtSearchSpec.SelStart = 0          ' Highlight the current entry.
    txtSearchSpec.SelLength = Len(txtSearchSpec.Text)

End Sub
