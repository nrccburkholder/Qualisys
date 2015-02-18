VERSION 5.00
Object = "{C932BA88-4374-101B-A56C-00AA003668DC}#1.1#0"; "msmask32.ocx"
Begin VB.Form frmMain 
   Caption         =   "Frequency & CrossTabs- Data Selection"
   ClientHeight    =   6030
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7605
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6030
   ScaleWidth      =   7605
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fraTimes 
      Caption         =   " Enter/Change  Dates "
      Height          =   1635
      Left            =   780
      TabIndex        =   17
      Top             =   1605
      Width           =   2940
      Begin MSMask.MaskEdBox mebStartDate 
         Height          =   255
         Left            =   540
         TabIndex        =   18
         Top             =   495
         Width           =   1860
         _ExtentX        =   3281
         _ExtentY        =   450
         _Version        =   393216
         MaxLength       =   10
         Mask            =   "##/##/####"
         PromptChar      =   "_"
      End
      Begin MSMask.MaskEdBox mebEndDate 
         Height          =   255
         Left            =   495
         TabIndex        =   19
         Top             =   1080
         Width           =   1905
         _ExtentX        =   3360
         _ExtentY        =   450
         _Version        =   393216
         MaxLength       =   10
         Mask            =   "##/##/####"
         PromptChar      =   "_"
      End
      Begin VB.Label Label2 
         Caption         =   "End Date:  mm/dd/yyyy"
         Height          =   225
         Left            =   495
         TabIndex        =   21
         Top             =   855
         Width           =   2025
      End
      Begin VB.Label Label1 
         Caption         =   "Start Date:  mm/dd/yyyy"
         Height          =   225
         Left            =   450
         TabIndex        =   20
         Top             =   270
         Width           =   1890
      End
   End
   Begin VB.ListBox lstSampleSet 
      Height          =   1425
      Left            =   810
      MultiSelect     =   2  'Extended
      TabIndex        =   15
      Top             =   3735
      Width           =   6135
   End
   Begin VB.Frame fraTypeOfRespondents 
      Caption         =   " Type of Respondents"
      Height          =   1500
      Left            =   825
      TabIndex        =   12
      Top             =   1725
      Visible         =   0   'False
      Width           =   2400
      Begin VB.OptionButton optTypeOfResponents 
         Caption         =   "All"
         Height          =   495
         Index           =   1
         Left            =   630
         TabIndex        =   14
         Top             =   810
         Width           =   1215
      End
      Begin VB.OptionButton optTypeOfRespondents 
         Caption         =   "New"
         Height          =   495
         Index           =   0
         Left            =   630
         TabIndex        =   13
         Top             =   315
         Value           =   -1  'True
         Width           =   1215
      End
   End
   Begin VB.CommandButton cmdSelectClientandStudy 
      Height          =   310
      Left            =   3315
      Picture         =   "Main.frx":0000
      Style           =   1  'Graphical
      TabIndex        =   7
      Top             =   465
      Width           =   330
   End
   Begin VB.CommandButton cmdExit 
      Caption         =   "E&xit"
      Height          =   360
      Left            =   5805
      TabIndex        =   6
      Top             =   5385
      Width           =   1215
   End
   Begin VB.CommandButton cmdFrequency 
      Caption         =   "&Frequency"
      Height          =   360
      Left            =   3735
      TabIndex        =   5
      Top             =   5385
      Width           =   1215
   End
   Begin VB.CommandButton cmdCrossTabs 
      Caption         =   "&CrossTabs"
      Height          =   360
      Left            =   1305
      TabIndex        =   4
      Top             =   5385
      Width           =   1215
   End
   Begin VB.Frame fraPopulation 
      Caption         =   " Population "
      Height          =   2940
      Left            =   4185
      TabIndex        =   0
      Top             =   330
      Width           =   2760
      Begin VB.OptionButton optPopulation 
         Caption         =   "Raw Data"
         Height          =   270
         Index           =   2
         Left            =   450
         TabIndex        =   2
         Top             =   2025
         Width           =   1395
      End
      Begin VB.OptionButton optPopulation 
         Caption         =   "Sample Set"
         Height          =   270
         Index           =   1
         Left            =   450
         TabIndex        =   3
         Top             =   1305
         Width           =   1395
      End
      Begin VB.OptionButton optPopulation 
         Caption         =   "Universe"
         Height          =   270
         Index           =   0
         Left            =   450
         TabIndex        =   1
         Top             =   585
         Width           =   1395
      End
   End
   Begin VB.Label lblSampleSets 
      Caption         =   "SampleSets"
      Height          =   270
      Left            =   855
      TabIndex        =   16
      Top             =   3450
      Width           =   1215
   End
   Begin VB.Label lblClientStudy 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   1  'Fixed Single
      Height          =   315
      Left            =   855
      TabIndex        =   11
      Top             =   465
      Width           =   2445
   End
   Begin VB.Label lblSurvey 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   1  'Fixed Single
      Height          =   285
      Left            =   810
      TabIndex        =   10
      Top             =   1110
      Width           =   2490
   End
   Begin VB.Label lblClientStudy0 
      Caption         =   "Client Study"
      Height          =   255
      Left            =   810
      TabIndex        =   9
      Top             =   270
      Width           =   1740
   End
   Begin VB.Label lblSurvey0 
      Caption         =   "Survey"
      Height          =   255
      Index           =   1
      Left            =   810
      TabIndex        =   8
      Top             =   915
      Width           =   855
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim vntSampleSet As Variant

Private Sub cmdCrossTabs_Click()
    
    On Error GoTo ErrorHandler
    
    'Dim objwiz As mtsImportFunctions.mts_Import_Wizard ' Removed 09-17-2002 SH
    Dim objwiz As ImportFunctionsPROC.Import_Wizard_PROC
    Dim X As Long
    Dim lngOptSelected As Long
    Dim i As Long
    
    
    If lblClientStudy.Caption = "" Or lblSurvey.Caption = "" Then
        MsgBox "You must select a Client Study and Survey before entering Crosstabs", _
                vbOKOnly, "FrequencyMgr - Missing Input"
        Exit Sub
    End If
    
    If glngStudy_id <> 0 Then
         'Set objwiz = CreateObject("mtsImportFunctions.mts_Import_Wizard") ' Removed 09-17-2002 SH
         Set objwiz = CreateObject("ImportFunctionsPROC.Import_Wizard_PROC")
         mvarTables = objwiz.mts_fnvnt_Get_TableNames(glngStudy_id)
         Set objwiz = Nothing
     Else
         MsgBox "Please select a Client and Study", vbOKOnly, "Input Needed"
     End If
    
    ' Determine which of the Population option buttons is set
    lngOptSelected = lngGetPopulationOption()
    
    ' Select case and process depending on which option button was set.
    Select Case lngOptSelected
        Case SAMPLE_SET
            ReDim glngSampleSetAry(0)
            
            ' Fill an string with the sample set ids for use later in the
            ' retrieval SQL
            gstrSampleSets = ""

            For i = 0 To lstSampleSet.ListCount - 1
                If lstSampleSet.Selected(i) = True Then
                    gstrSampleSets = gstrSampleSets & lstSampleSet.ItemData(i) _
                                     & ","
                End If
            Next i

            ' Error message if no sample sets selected
            If gstrSampleSets = "" Then
                Screen.MousePointer = vbDefault
                MsgBox "You must select the sample sets to be processed.", _
                       vbOKOnly, "Frequency Manager Tool - Missing Input"
                Exit Sub
            End If

            ' Sample sets selected remove the trailing "'" from the string
            If Right(gstrSampleSets, 1) = "," Then
                gstrSampleSets = Left(gstrSampleSets, Len(gstrSampleSets) - 1)
            End If
    End Select

    frmCrossTabs.Show
    
    Me.Hide
    
    Exit Sub

ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: frmMain.cmdCrossTabs_Click, Error Description: " & Err.Description
    End
    
End Sub

Private Sub cmdExit_Click()

    Beep
    Beep
    End

End Sub

Private Sub cmdFrequency_Click()

    Dim strSql As String
    Dim lngDateDiff As Long
    Dim lngOptSelected As Long
    Dim lngKey
    Dim i As Long

    ' Ensure a study and survey have been entered
    If lblClientStudy.Caption = "" Or lblSurvey.Caption = "" Then
        MsgBox "You must select a Study and Survey for Frequencies", _
               vbOKOnly & vbExclamation, "Frequencies - Missing Input"
        Exit Sub
    End If
    
    ' Determine which of the Population option buttons is set
    lngOptSelected = lngGetPopulationOption()
    
    ' Select case and process depending on which option button was set.
    Select Case lngOptSelected
        ' If Universe or Load Data option selected  need to
        ' verify start and end dates are entered and valid
        Case UNIVERSE
            'Set missing import start data to Jan 1, 1900
            If StrComp(mebStartDate, "__/__/____") = 0 Then
               mebStartDate.Text = "01/01/1900"
            End If
            
            'Set missing import end data to today
            If StrComp(mebEndDate, "__/__/____") = 0 Then
               mebEndDate.Text = Format(Now, "mm/dd/yyyy")
            End If
    
            ' validate  start/stop date fields
            If IsDate(mebStartDate) = False Then
               MsgBox "Invalid Import Start Date", vbOKOnly + vbInformation, _
                      "Export Manager - Invalid Data Input"
               Exit Sub
            End If
        
            If IsDate(mebEndDate) = False Then
               MsgBox "Invalid or missing End Date", vbOKOnly + vbInformation, _
                      "Export Manager - Invalid Input Date"
                      Exit Sub
            End If
        
            lngDateDiff = DateDiff("d", mebStartDate, mebEndDate)
        
            If lngDateDiff < 1 Then
                MsgBox "Start Date must be before or equal to the End date", _
                        vbOKOnly + vbInformation, "Export Manager, -Invalid Input Date"
                Exit Sub
            End If
        
        Case SAMPLE_SET
            ReDim glngSampleSetAry(0)
        
            'Save the SampleSet_Id in global
            gstrSampleSets = ""
            
            ' Fill an string with the sample set ids for use later in the
            ' retrieval SQL
            gstrSampleSets = ""
    
            For i = 0 To lstSampleSet.ListCount - 1
                If lstSampleSet.Selected(i) = True Then
                    gstrSampleSets = gstrSampleSets & lstSampleSet.ItemData(i) _
                                     & ","
                End If
            Next i
            
            ' Error message if no sample sets selected
            If gstrSampleSets = "" Then
                Screen.MousePointer = vbDefault
                MsgBox "You must select the sample sets to be processed.", _
                        vbOKOnly, "Frequency Manager Tool - Missing Input"
                Exit Sub
            End If
            
            ' Sample sets selected remove the trailing "'" from the string
            If Right(gstrSampleSets, 1) = "," Then
                gstrSampleSets = Left(gstrSampleSets, Len(gstrSampleSets) - 1)
            End If
                           
        Case RAW_DATA
            gstrS_StudyNum = "S" & glngStudy_id
            ' 8/31/99 DV
            ' We don't use SETUSER!!!
            'D *SQL 7.0*
            'D            gstrSQL1 = "setuser '" & gstrS_StudyNum & "'"
            'D            gstrSQL2 = "setuser"
            gstrSQL1 = ""
            gstrSQL2 = ""
    End Select

    Me.Hide
  
    frmFrequency.Show

End Sub

Private Sub cmdSelectClientandStudy_Click()
    
    Dim StudyObject As StudySelector.StudySelectorGUI
    Dim SurveyObject  As SurveySelector.SurveySelectorGUI

    If lblClientStudy.Caption <> "" Then
        lblClientStudy.Caption = ""
    End If
    
    If lblSurvey.Caption <> "" Then
        lblSurvey.Caption = ""
    End If
    
    If optPopulation(SAMPLE_SET).Value = True Then
        lstSampleSet.Clear
    End If
    
GetStudy:
    Set StudyObject = CreateObject("StudySelector.StudySelectorGUI")

    glngEmployeeId = lngEmployeeId
    StudyObject.EmployeeId = lngEmployeeId

    If StudyObject.GetClientIds > 0 Then
        glngStudy_id = StudyObject.StudyId
        lblClientStudy.Caption = StudyObject.studyName
    Else
        Set StudyObject = Nothing
        End
    End If
    Set StudyObject = Nothing
    
    ' Create an object for the survey selector
    Set SurveyObject = CreateObject("SurveySelector.SurveySelectorGUI")

    SurveyObject.study_id = glngStudy_id
    
    If SurveyObject.fctGetSurvey_Id Then
        If SurveyObject.SurveyId > 0 Then
            glngSurvey_id = SurveyObject.SurveyId
            lblSurvey.Caption = SurveyObject.SurveyName
        Else
            Set SurveyObject = Nothing
            End
        End If
    Else
        Set SurveyObject = Nothing
        End
    End If
    
    Set SurveyObject = Nothing

    Me.Show
  
    ' if you changed surveys and the Sample Set option is set then update
    ' the sample set list box.
    If optPopulation(SAMPLE_SET).Value = True Then
        optPopulation_Click (SAMPLE_SET)
    End If

End Sub

Private Sub Form_Load()
    
    Const CALLER = "CALLER"
    Const STUDY = "STUDY"
    Const SURVEY = "SURVEY"
    
    Dim strCaller As String
    Dim strStudy_Id As String
    Dim strSurvey_id As String
    Dim lngStudy_id As Long
    Dim lngSurvey_id As Long
    Dim lngiWhichDisplay
    Dim strErrMsg As String
    
    strErrMsg = "Invalid Study Id or Survey Id passed to Frequency tool."
    strErrMsg = strErrMsg & vbCrLf & "Study Id: " & lngStudy_id
    strErrMsg = strErrMsg & vbCrLf & "Survey Id:  " & lngSurvey_id
    strErrMsg = strErrMsg & vbCrLf & "Frequency Tool terminating."
    
    Me.Show

    'Parse the parameter strings out of the command line args
    strCaller = Parser(CALLER, gstrCommandLine)
    strStudy_Id = Parser(STUDY, gstrCommandLine)
    strSurvey_id = Parser(SURVEY, gstrCommandLine)
    
    If strStudy_Id <> "" And IsNumeric(strStudy_Id) Then
        glngStudy_id = strStudy_Id
    Else
        glngStudy_id = INVALID_DATA
    End If
    
    If strSurvey_id <> "" And IsNumeric(strSurvey_id) Then
        glngSurvey_id = strSurvey_id
    Else
        glngSurvey_id = INVALID_DATA
    End If
    
    If strCaller = "" Or strStudy_Id = "" Then
        Exit Sub
    End If
    
    ' if I do not know studyId or survey_id set initial display so the
    '    user must choose them
    ' else
    '    fill in the study_id and survey_id prior to display
    If gstrCommandLine = "" Then
        frmMain.Show
    ElseIf UCase(strCaller) = "IMPORT" And IsNumeric(glngStudy_id) Then
        SetImportView
        frmMain.Show
    ElseIf glngStudy_id = INVALID_DATA Or glngSurvey_id = INVALID_DATA Then
        MsgBox strErrMsg, vbOKOnly, "Frequency Tool - Invalid input"
    ElseIf IsNumeric(glngStudy_id) And IsNumeric(glngSurvey_id) Then
        SetClientandStudyName
        frmMain.Show
    Else
        frmMain.Show
    End If
    
'    If lblClientStudy.Caption = "" Then
'        cmdSelectClientandStudy.Enabled = True
'    Else
'        cmdSelectClientandStudy.Enabled = False
'    End If
    
End Sub

Private Sub SetImportView()
    
    Dim rs As New ADODB.Recordset
    Dim SQL As String
    
    SQL = "SELECT strStudy_nm FROM Study where Study_id = " & glngStudy_id
    
    rs.Open SQL, cnOne, adOpenForwardOnly, adLockReadOnly
    
    If Not rs.BOF And Not rs.EOF Then
        rs.MoveFirst
        If Not IsNull(rs("strStudy_nm")) Then
            lblClientStudy.Caption = Trim(rs("strStudy_nm"))
            optPopulation(RAW_DATA).Top = optPopulation(SAMPLE_SET).Top
            'optPopulation(UNIVERSE).Top = optPopulation(2).Top
            optPopulation(SAMPLE_SET).Visible = False
            optPopulation(RAW_DATA).Value = True
            lblSurvey0(1).Visible = False
            lblSurvey.Caption = "None"
            lblSurvey.Visible = False
        End If
    End If
    
    rs.Close
    Set rs = Nothing

End Sub

Private Sub lblSurvey_Change()

    '------------------------------------------------------------------------
    ' Purpose:  If the user has entered the Survey and Study disable the
    '           cmdSelectClientandStudy button otherwise enable it (user
    '           doesn't have client or study.
    '------------------------------------------------------------------------

'    If lblClientStudy.Caption = "" Or lblSurvey.Caption = "" Then
'        cmdSelectClientandStudy.Enabled = True
'    Else
'        cmdSelectClientandStudy.Enabled = False
'    End If
    
End Sub

Private Sub optPopulation_Click(Index As Integer)

    '-----------------------------------------------------
    ' Purpose: A population option button was clicked
    '          reset the GUI display for the newly selected
    '          option
    '-----------------------------------------------------
    
    Select Case Index
        Case UNIVERSE
            fraTypeOfRespondents.Visible = False
            lstSampleSet.Visible = False
            lblSampleSets.Visible = False
            fraTimes.Visible = True

            ' Set missing start data to Jan 1, 1900
            If StrComp(mebStartDate, "__/__/____") = 0 Then
                mebStartDate.Text = "01/01/1900"
            End If
            
            If StrComp(mebEndDate, "__/__/____") = 0 Then
                Dim strToday As Date
                Dim strDate As String
                strToday = Now
                mebEndDate.Text = Format(strToday, "mm/dd/yyyy")
            End If

        Case SAMPLE_SET
            Screen.MousePointer = vbHourglass
            fraTypeOfRespondents.Visible = False
            lstSampleSet.Visible = True
            lblSampleSets.Visible = True
            fraTimes.Visible = False

            Load_Analyze_ListboxForTool
            Screen.MousePointer = vbDefault

        Case RESPONDENTS
            fraTypeOfRespondents.Visible = True
            lstSampleSet.Visible = False
            lblSampleSets.Visible = False
            fraTimes.Visible = False

        Case RAW_DATA
            fraTypeOfRespondents.Visible = False
            lstSampleSet.Visible = False
            lblSampleSets.Visible = False
            fraTimes.Visible = False
        
        Case Else
        
    End Select
    
End Sub

Public Function lngGetPopulationOption() As Long

    Dim i As Long

    For i = 0 To 2
        If optPopulation(i).Value = True Then
            lngGetPopulationOption = i
            Exit Function
        End If
    Next i

End Function

Public Static Function Parser(strWhatToReturn As String, strIn As String) As String

    '--------------------------------------------------------------
    ' Purpose:  Used in the Frequency tool to get information
    '           out of the command line passed by the program
    '           (i.e. ExportMgr, ImportWizard) which started
    '           the tool.  The calling programs should pass
    '           3 pieces of information seperated by ";" all as
    '           a string.  The expected format is:
    '           "caller=callerName;study=StudyId;survey=SurveyId"
    '           "Caller Name should be: "Import", "Export", "Other"
    '           for ImportMgr, ExportWizard, or started from icon.
    '
    ' Command Line Syntax Rules:
    '           1. no blanks
    '           2. use ";" as paramter seperator
    '           3. identify parameter with "caller=", "study=, or "
    '              "survey="
    '
    '           If the value can not be found an empty string is
    '           returned
    '
    '           User must return strings as numbers back into numbers
    '-------------------------------------------------------------

    On Error GoTo ErrorHandler

    Const EXPORT = "Export"
    Const IMPORT = "Import"
    Const OTHER = "Other"
    
    Const SEPERATOR = ";"
    
    Dim lStart As Long
    Dim lStrIn As Long
    Dim lCaller As Long
    Dim lend As Long
    Dim strTemp As String
    Dim strLocate As String


    ' if empty command string return an empty string
    If strIn = "" Then
        Parser = ""
        Exit Function
    End If

    'set string for parameter to locate from input command string
    'syntax check the string
    Select Case strWhatToReturn
        Case "CALLER"
            strLocate = "caller="
            
            If InStr(1, strIn, "caller=") = 0 Then
                Parser = ""
                Exit Function
            End If
            
        Case "STUDY"
            strLocate = "study="
            If InStr(1, strIn, "study=") = 0 Then
                Parser = ""
                Exit Function
            End If
            
        Case "SURVEY"
            strLocate = "survey="
            If InStr(1, strIn, "survey=") = 0 Then
                Parser = ""
                Exit Function
            End If
             
        Case Else
            Parser = ""
            Exit Function
    End Select
    
    'Locate the wanted string in the command line string
    lStart = InStr(1, strIn, strLocate)
    
    'return blank string if error or wanted string not in
    'command line
    If lStart = 0 Then
        Parser = ""
        Exit Function
    Else
        lStrIn = Len(strIn)
        lCaller = Len(strLocate)
        strTemp = Right(strIn, lStrIn - (lStart + lCaller) + 1)
        
        lend = InStr(strTemp, SEPERATOR) - 1
        
        If lend = -1 Then
            Parser = strTemp
        Else
            Parser = Left(strTemp, lend)
        End If
    End If
    
    Exit Function

ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: frmMain.Parser, Error Description: " & Err.Description
    End
    
End Function

Public Sub SetClientandStudyName()

    '-----------------------------------------------------
    ' Purpose: If the study_id and survey_id are known then
    '          use a SQL to retrieve the study and survey
    '          names and put them into the label boxes
    '          prior to display (so user doesn't have to
    '          choose - they were passed in from the calling
    '          program.
    '-----------------------------------------------------

    Dim rsNames As ADODB.Recordset
    Dim strSql As String

    ' SQL for retrieving study and survey name given the study_id
    ' and survey_id
    strSql = "SELECT Study.strStudy_nm, Survey_def.strSurvey_nm " & _
             "FROM Study, Survey_def " & _
             "WHERE STUDY.study_id = " & glngStudy_id & _
             "      AND Survey_def.Survey_id = " & glngSurvey_id

    Set rsNames = cnOne.Execute(strSql, dbOpenDynaset)

    If rsNames.EOF = True And rsNames.BOF = True Then
        lblClientStudy.Caption = ""
        lblSurvey.Caption = ""

        ' When finished free resourses and point to nothing
        Set rsNames = Nothing
        Exit Sub
    Else
        rsNames.MoveFirst
        lblClientStudy.Caption = rsNames!strStudy_nm
        lblSurvey = rsNames!strSurvey_nm
    End If
    
    rsNames.Close
    Set rsNames.ActiveConnection = Nothing
    
End Sub

Public Sub Load_Analyze_ListboxForTool()

    '--------------------------------------------------------------------
    ' Purpose:  Load the Sample Set information into the list box for the
    '           FrequencyMgr tool.
    '--------------------------------------------------------------------
    On Error GoTo ErrorHandler

    Dim X As Long
    Dim objSample As Object
    Dim strMsg1 As String

    lstSampleSet.Clear

    vntSampleSet = fnvar_GetSampleSets(glngSurvey_id)
    
    If Not IsNull(vntSampleSet) Then
        For X = 0 To UBound(vntSampleSet, 2)
            lstSampleSet.AddItem "Associate: " & vntSampleSet(3, X) & Chr(32) & Chr(32) & "Created: " & Chr(32) & vntSampleSet(4, X) & Chr(32)
            lstSampleSet.ItemData(lstSampleSet.NewIndex) = vntSampleSet(0, X)
        Next X
        
        lstSampleSet.ListIndex = 0
    Else
        MsgBox ("There are no Sample Sets for this survey.")
        optPopulation_Click (0)
        optPopulation(UNIVERSE).SetFocus
    End If
    
    Exit Sub

ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: frmMain.Load_Analyze_ListboxForTool, Error Description: " & Err.Description
    End
    
End Sub

Public Function fnvar_GetSampleSets(lngSurveyId As Long) As Variant

    On Error GoTo ErrorHandler
    
    Dim strSql As String
    Dim rs As New ADODB.Recordset

    strSql = "SELECT s.* " & _
             "FROM sampleset s " & _
             "WHERE survey_id = " & lngSurveyId & " " & _
             "ORDER BY datSampleCreate_dt DESC"
    Set rs = cnOne.Execute(strSql, adOpenKeyset)
        
    If Not rs.BOF And Not rs.EOF Then
        fnvar_GetSampleSets = rs.GetRows
        rs.Close
    Else
        fnvar_GetSampleSets = ""
        rs.Close
    End If
    
    Set rs = Nothing

    Exit Function

ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: frmMain.fnvar_GetSampleSets, Error Description: " & Err.Description
    End
    
End Function
