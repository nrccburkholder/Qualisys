VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmScanImport 
   BackColor       =   &H00404040&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Transfer Results"
   ClientHeight    =   3705
   ClientLeft      =   135
   ClientTop       =   705
   ClientWidth     =   6780
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3705
   ScaleWidth      =   6780
   Begin VB.CheckBox chkVSTR 
      Caption         =   "Process VSTR Files (Comments Data)"
      Height          =   195
      Left            =   3360
      TabIndex        =   8
      Top             =   840
      Value           =   1  'Checked
      Width           =   3195
   End
   Begin VB.CheckBox chkSTR 
      Caption         =   "Process STR Files (Bubble Data)"
      Height          =   195
      Left            =   240
      TabIndex        =   7
      Top             =   840
      Value           =   1  'Checked
      Width           =   2955
   End
   Begin VB.CommandButton cmdNonQualPro 
      Caption         =   "&Non-QualPro"
      Height          =   495
      Left            =   3360
      TabIndex        =   6
      Top             =   240
      Width           =   1395
   End
   Begin VB.CommandButton cmdHandEntered 
      Caption         =   "&Hand Entered"
      Height          =   495
      Left            =   1800
      TabIndex        =   1
      Top             =   240
      Width           =   1395
   End
   Begin MSComDlg.CommonDialog dlgMain 
      Left            =   540
      Top             =   2880
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdManualPoll 
      Caption         =   "&Manual Poll"
      Height          =   495
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1395
   End
   Begin VB.CommandButton cmdStop 
      Caption         =   "Sto&p Timer and Exit"
      Height          =   495
      Left            =   4920
      TabIndex        =   2
      Top             =   240
      Width           =   1635
   End
   Begin VB.Timer tmrImportReturns 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   60
      Top             =   2940
   End
   Begin ComctlLib.ProgressBar pbrMain 
      Height          =   225
      Left            =   3720
      TabIndex        =   4
      Top             =   3450
      Visible         =   0   'False
      Width           =   3030
      _ExtentX        =   5345
      _ExtentY        =   397
      _Version        =   327682
      Appearance      =   1
   End
   Begin ComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   5
      Top             =   3405
      Width           =   6780
      _ExtentX        =   11959
      _ExtentY        =   529
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   7
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   2
            Object.Width           =   1931
            MinWidth        =   1940
            Text            =   "Next Run In:"
            TextSave        =   "Next Run In:"
            Key             =   "IntervalCaption"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            Object.Width           =   1940
            MinWidth        =   1940
            Text            =   "60 second(s)"
            TextSave        =   "60 second(s)"
            Key             =   "Interval"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel3 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Bevel           =   0
            Object.Width           =   176
            MinWidth        =   176
            Key             =   "Spacer1"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel4 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   2
            Object.Width           =   2302
            MinWidth        =   2293
            Text            =   "Display Setting:"
            TextSave        =   "Display Setting:"
            Key             =   "OutputCaption"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel5 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   5450
            Key             =   "OutputLevel"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel6 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Visible         =   0   'False
            Key             =   "Status"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel7 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            Object.Visible         =   0   'False
            Object.Width           =   5080
            MinWidth        =   5080
            Text            =   "Please Wait ..."
            TextSave        =   "Please Wait ..."
            Key             =   "Progress"
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ListView lvwOutput 
      Height          =   2055
      Left            =   240
      TabIndex        =   3
      Top             =   1140
      Width           =   6315
      _ExtentX        =   11139
      _ExtentY        =   3625
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   327682
      SmallIcons      =   "imlOutput"
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   2
      BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Date/Time"
         Object.Width           =   3351
      EndProperty
      BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         SubItemIndex    =   1
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Description"
         Object.Width           =   5997
      EndProperty
   End
   Begin ComctlLib.ImageList imlOutput 
      Left            =   1080
      Top             =   2820
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   3
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmScanImport.frx":0000
            Key             =   "Message"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmScanImport.frx":031A
            Key             =   "Warning"
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmScanImport.frx":0634
            Key             =   "Error"
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileWorkstations 
         Caption         =   "&Show Current Workstation List"
      End
      Begin VB.Menu mnuFileOptions 
         Caption         =   "&Options..."
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFilePoll 
         Caption         =   "&Manual Poll"
      End
      Begin VB.Menu mnuFileHand 
         Caption         =   "Process &Hand Entered Data"
      End
      Begin VB.Menu mnuFileNonQualPro 
         Caption         =   "Process &Non-QualPro Data"
      End
      Begin VB.Menu mnuFileSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
End
Attribute VB_Name = "frmScanImport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private meOutputLevel       As eOutputLevelCodes
    Private meIntervalType      As eIntervalTypeCodes
    Private mlIntervalDefault   As Long
    Private mlIntervalOverride  As Long
    Private mlIntervalToUse     As Long     '** Added 08-18-00 JJF
    Private mdtTimeToRun        As Date     '** Added 08-18-00 JJF
    
    Private mbIsSTRChecked      As Boolean
    Private mbIsVSTRChecked     As Boolean
    
    
    Private Const mknMaxOutputMessages As Integer = 200
    
    'Dim cnOne As New ADODB.Connection  '** Removed 04-05-00 JJF
    
    'Const SCANIMPORTINTERVAL = "ScanimportInterval"    '** Removed 04-05-00 JJF

'** Removed 04-05-00 JJF
'Public Function fctImportInterval(ByRef pstrInterval As String) As Boolean
'Dim strSql As String
'Dim rsImportInterval As ADODB.Recordset
'
'On Error GoTo errfctImportInterval
'
'    strSql = _
'    "SELECT QP.strParam_Value " _
'    & "FROM  QualPro_Params QP " _
'    & "WHERE QP.strParam_Nm = " & "'" & SCANIMPORTINTERVAL & "'"
'
'    Set rsImportInterval = New ADODB.Recordset
'    rsImportInterval.CursorLocation = adUseClient
'    rsImportInterval.Open strSql, cnOne, adOpenKeyset, adLockBatchOptimistic
'    Set rsImportInterval.ActiveConnection = Nothing
'
'    If rsImportInterval.BOF And rsImportInterval.EOF Then
'        'Write to Error_Log
'        fctImportInterval = False
'    Else
'        rsImportInterval.MoveFirst
'        pstrInterval = rsImportInterval!strParam_Value
'        fctImportInterval = True
'    End If
'
'    rsImportInterval.Close
'    Set rsImportInterval = Nothing
'    cnOne.Close
'    Set cnOne = Nothing
'
'Exit Function
'
'errfctImportInterval:
'
'App.LogEvent Err.Description, vbLogEventTypeError
'
'
'End Function
'** End of remove 04-05-00 JJF
'** Removed 04-05-00 JJF
'Public Function mtsRetrieveDSN_INFO()
'
'    Dim o As QualProFunctions.Library
'    Dim strDSN_Info As String
'
'    Set o = CreateObject("QualProFunctions.Library")
'    strDSN_Info = o.GetDBString
'
'    cnOne.Open strDSN_Info
'    cnOne.CommandTimeout = 0
'    Set o = Nothing
'
'End Function
'** End of remove 04-05-00 JJF






'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Output
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine takes care of displaying all user
'\\                 output messages.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sMessage    String      The message to be displayed.
'\\     eLevel      eOutputMessageCodes
'\\                             An enum value indicating the severity
'\\                             of the message.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Output(ByVal sMessage As String, _
                  Optional ByVal eLevel As eOutputMessageCodes = omcOutputMessage)
    
    Dim oItem As ComctlLib.ListItem
    
    'Check for major problems
    If meOutputLevel = olcOutputLevelNone And eLevel = omcOutputError Then
        MsgBox sMessage, vbCritical
        Exit Sub
    End If
    
    'Determine if we are to display this message
    If eLevel < meOutputLevel Or meOutputLevel = olcOutputLevelNone Then
        Exit Sub
    End If
    
    'Check to see if we have reached the max number of entries
    If lvwOutput.ListItems.Count = mknMaxOutputMessages Then
        lvwOutput.ListItems.Remove mknMaxOutputMessages
    End If
    
    'If we are here then we are going to display it
    Set oItem = lvwOutput.ListItems.Add(Index:=1, Text:=Format(Now, "mm/dd/yy hh:nn:ss am/pm"), SmallIcon:=eLevel)
    oItem.SubItems(1) = sMessage
    oItem.Selected = True
    oItem.EnsureVisible
    Set oItem = Nothing
    
    lvwOutput.Refresh
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   PollNow
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine takes care of actually performing the
'\\                 import process.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\     eTransferType   eTransferTypeConstants
'\\                                 Specified the type of transfer to be
'\\                                 performed.
'\\
'\\ Return Value:
'\\     Type    Description
'\\     Long    Number of seconds elapsed during execution.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Changed so the status bar shows progress
'\\                         of the running poll.
'\\     08-29-00    JJF     Added ability to deal with hand entered
'\\                         results.
'\\     06-12-01    JJF   * Changed parameter from a boolean to the
'\\                         TransferType enum.
'\\                       * Added ability to import non-qualpro string
'\\                         files.
'\\     08-13-01    JJF     Modified the call to ProcessFiles to
'\\                         include the TransferType enum parameter.
'\\     10-15-01    JJF   * Added ability to deal with comment boxes.
'\\                       * Removed revision notes and code as it was
'\\                         to difficult to read.
'\\     12-16-02    JJF     Added checkboxes to specify whether or not
'\\                         to process STR and/or VSTR files.
'\\     01-23-03    JJF     Added the capability to stop processing
'\\                         after the completion of the current batch.
'\\     10-31-05    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function PollNow(ByVal eTransferType As eTransferTypeConstants) As Long
    
    Dim dtStart         As Date
    Dim dtFinish        As Date
    Dim sSTRFileName    As String
    Dim oLocalSelect    As frmSelectInput
    Dim nLithoStart     As Integer
    Dim nLithoLength    As Integer
    Dim bProcess        As Boolean
    
    'Get the start time
    dtStart = Now
    
    'Set the mouse pointer
    Me.MousePointer = vbHourglass
    
    'Change the form color
    Me.BackColor = &HFF&
    
    'Lock things down so we cant be interupted in the middle of a run
    TimerEnabled = False
    Me.cmdManualPoll.Enabled = False
    Me.cmdHandEntered.Enabled = False
    Me.cmdNonQualPro.Enabled = False
    Me.mnuFile.Enabled = False
    Me.cmdStop.Caption = "Stop &Processing"
    gbStopProcessing = False
    
    Dim bIsSTRChecked As Boolean
    Dim bIsVSTRChecked As Boolean
    
    ' get the current values of the check boxes
    bIsSTRChecked = chkSTR.Value = vbChecked
    bIsVSTRChecked = chkVSTR.Value = vbChecked
    
    ' only execute if there is a change in the check boxes since last poll
    If (mbIsSTRChecked <> bIsSTRChecked) Or (mbIsVSTRChecked <> bIsVSTRChecked) Then
        LogUserActivity userActivity:=eUserUpdate
    End If
    
    bProcess = False
    If eTransferType = ttcNormal Then
        'We are going to process this as normal
        sSTRFileName = ""
        nLithoStart = 0
        nLithoLength = 0
        bProcess = True
    Else
        'We need to get the filename of the result file
        Set oLocalSelect = New frmSelectInput
        Load oLocalSelect
        
        'Display the form
        With oLocalSelect
            'Set the properties
            .TransferType = eTransferType
            
            'Show the form
            .Show vbModal
            
            'Deal with the result
            bProcess = .OKClicked
            If bProcess Then
                sSTRFileName = .ResultFile
                nLithoStart = .LithoStart
                nLithoLength = .LithoLength
            End If
        End With
        
        'Cleanup
        Unload oLocalSelect
        Set oLocalSelect = Nothing
    End If
    
    'Process any existing files at this time
    If bProcess Then
        ProcessFiles sSTRFileName:=sSTRFileName, _
                     nLithoStart:=nLithoStart, _
                     nLithoLength:=nLithoLength, _
                     eTransferType:=eTransferType, _
                     bTransferSTR:=(chkSTR.Value = vbChecked), _
                     bTransferVSTR:=(chkVSTR.Value = vbChecked)
    End If
    
DLGErrorHandler:
    'Unlock everything
    Me.mnuFile.Enabled = True
    Me.cmdHandEntered.Enabled = True
    Me.cmdNonQualPro.Enabled = True
    Me.cmdManualPoll.Enabled = True
    Me.cmdStop.Caption = "Sto&p Timer and Exit"
    gbStopProcessing = False
    TimerEnabled = True
    
    'Restore the form color
    Me.BackColor = &H404040
    
    'Reset the mouse pointer
    Me.MousePointer = vbDefault
    
    'Get the finish time
    dtFinish = Now
    
    'Set the return value
    PollNow = DateDiff("S", dtStart, dtFinish)
    
End Function

Public Property Get TimerEnabled() As Boolean
    
    TimerEnabled = tmrImportReturns.Enabled
    
End Property

Public Property Let TimerEnabled(ByVal bData As Boolean)
    
    'Setup the status bar
    With sbrMain
        .Panels("IntervalCaption").Visible = bData
        .Panels("Interval").Visible = bData
        .Panels("Spacer1").Visible = bData
        .Panels("OutputCaption").Visible = bData
        .Panels("OutputLevel").Visible = bData
        .Panels("Status").Visible = Not bData
        .Panels("Progress").Visible = Not bData
        
        pbrMain.Visible = Not bData
        
        If Not bData Then
            With .Panels("Progress")
                pbrMain.Move .Left, sbrMain.Top + 45, .Width, sbrMain.Height - 60
                pbrMain.Value = 0
            End With
        End If
    End With
    
    mdtTimeToRun = DateAdd("s", mlIntervalToUse, Now)
    sbrMain.Panels("Interval").Text = mlIntervalToUse & " second(s)"
    tmrImportReturns.Enabled = bData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   cmdHandEntered_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine is used to process questionaires that
'\\                 were input by hand and never went through first
'\\                 pass (CreateDefinitionFiles.exe).
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-12-01    JJF     Changed parameter from a boolean to the
'\\                         Transfer Type enum.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub cmdHandEntered_Click()
    
    Dim lSeconds As Long
    
    '** Modified 06-12-01 JJF
    'lSeconds = PollNow(bHandEntered:=True)
    lSeconds = PollNow(eTransferType:=ttcHandEntered)
    '** End of modification 06-12-01 JJF
    Output sMessage:="Hand Entered Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage

End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   cmdManualPoll_Click
'\\
'\\ Created By:     X
'\\         Date:   00-00-2000
'\\
'\\ Description:    X
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     04-05-00    JJF     Modified to call into new code.
'\\     06-12-01    JJF     Added Transfer Type enum parameter to call.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub cmdManualPoll_Click()
    
    Dim lSeconds As Long
    
    '** Modified 06-12-01 JJF
    'lSeconds = PollNow
    lSeconds = PollNow(eTransferType:=ttcNormal)
    '** End of modification 06-12-01 JJF
    
    Output sMessage:="Manual Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   cmdNonQualPro_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-12-2001
'\\
'\\ Description:    This routine is used to process questionaires that
'\\                 were scanned into the old system and need their
'\\                 results in QualPro but never went through first
'\\                 pass (CreateDefinitionFiles.exe).
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub cmdNonQualPro_Click()
    
    Dim lSeconds As Long
    
    lSeconds = PollNow(eTransferType:=ttcNonQualPro)
    Output sMessage:="Non-QualPro Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage

End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   cmdStop_Click
'\\
'\\ Created By:     X
'\\         Date:   00-00-2000
'\\
'\\ Description:    X
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     04-05-00    JJF     Fixed a possible memory leak and disabled
'\\                         the timer control to give the user time to
'\\                         answer the question.
'\\     01-23-03    JJF     Added the capability to stop processing
'\\                         after the completion of the current batch.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub cmdStop_Click()

    Dim sMsg   As String
    Dim sTitle As String
    
    If Me.cmdStop.Caption = "Sto&p Timer and Exit" Then     '** Added 01-23-03 JJF
        '** Added 04-05-00 JJF
        'Disable the timer
        tmrImportReturns.Enabled = False
        '** End of add 04-05-00 JJF
        
        'Setup the question
        sMsg = "Are you sure you want to stop polling returns directory for files ?"
        sTitle = "Import results for each litho in result batch files into QualPro Data Base"
        
        'Ask the user
        If MsgBox(sMsg, vbYesNo + vbCritical + vbDefaultButton2, sTitle) = vbYes Then
            'The user says to head out of dodge
            Beep
            Beep
            Beep
            '** Modified 04-05-00 JJF
            '**  Never use the END statement as this causes big memory leaks
            'End
            LogUserActivity userActivity:=eUserLogout
            Unload Me
            '** End of modification 04-05-00 JJF
        '** Added 04-05-00 JJF
        Else
            'The user decided to stay so lets restart the timer
            tmrImportReturns.Enabled = True
        '** End of add 04-05-00 JJF
        End If
    '** Added 01-23-03 JJF
    Else
        gbStopProcessing = True
    End If
    '** End of Add 01-23-03 JJF
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Form_Load
'\\
'\\ Created By:     X
'\\         Date:   00-00-2000
'\\
'\\ Description:    X
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Command Line Parameters:
'\\     Parameter   Description
'\\     /OI:        Sets the Override Interval.  Specifies the number
'\\                 of seconds between attempts to import.
'\\                 Valid values: 1 thru 60
'\\     /OL:        Sets the Output Level.  Specifies which types of
'\\                 output messages are displayed on screen.
'\\                 Valid values:
'\\                     0 = No messages are displayed
'\\                     1 = Display all messages
'\\                     2 = Display only Warnings and Errors
'\\                     3 = Display only Errors
'\\     /MR:        Sets the Multiple Responce Level.  Specifies which
'\\                 types of questions are to be processed.
'\\                 Valid values:
'\\                     0 = Process all questions
'\\                     1 = Process Multiple Responce Questions Only
'\\                     2 = Process Single Responce Questions Only
'\\     /BD:        Sets the Process Bubble Data checkbox.  Specifies
'\\                 whether or not to process bubble data (STR) files.
'\\                 Valid values:
'\\                     0 = Do not process buble data (STR) files.
'\\                     1 = Process bubble data (STR) files.
'\\     /CD:        Sets the Process Comment Data checkbox.  Specifies
'\\                 whether or not to process comment data (VSTR) files.
'\\                 Valid values:
'\\                     0 = Do not process buble data (VSTR) files.
'\\                     1 = Process bubble data (VSTR) files.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     04-05-00    JJF     Modified to call into new code.
'\\                         Also added the capability to specify some
'\\                         command line parameters:
'\\     05-10-00    JJF     Added the multiple response level command
'\\                         line parameter.
'\\     08-18-00    JJF     Changed so that it shows time remaining
'\\                         until next poll and added progress
'\\                         indication.
'\\     03-07-02    JJF     Changed to use the connection string stored
'\\                         in the local registry instead of the MTS
'\\                         object.
'\\     12-16-02    JJF     Added checkboxes to specify whether or not
'\\                         to process STR and/or VSTR files.
'\\     02-19-03    JJF     Moved some of the startup code to Sub Main.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Form_Load()
    
    Dim nLoc         As Integer     '** Added 05-27-05 JJF
    Dim sTemp        As String
    Dim lDefOutLevel As Long
    Dim oConn        As ADODB.Connection
    
    Dim oUserInfo As New CUserInfo
    
    Me.Caption = App.ProductName & " - " & GetAppVersion
    
    mbIsSTRChecked = chkSTR.Value = vbChecked
    mbIsVSTRChecked = chkVSTR.Value = vbChecked
    
    '** Removed 02-19-03 JJF
    ''** Added 03-07-02 JJF
    ''Read in all registry settings
    'ReadRegistry
    ''** End of add 03-07-02 JJF
    '** End of remove 02-19-03 JJF
    
    'Open the database
    '** Modified 03-07-02 JJF
    'OpenDBConnection oConnection:=oConn
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    '** End of modification 03-07-02 JJF

    LogUserActivity userActivity:=eUserLogin
    
    'Get the Import interval
    sTemp = GetQualProParamString(sParamName:="ScanImportInterval", oConn:=oConn)
    If IsNumeric(sTemp) And Val(sTemp) > 0 And Val(sTemp) <= 60000 Then
        'Set the default interval
        mlIntervalDefault = Val(sTemp)
    Else
        'Default to 10 seconds
        mlIntervalDefault = 10000
    End If
    
    'Get the output level
    sTemp = GetQualProParamString(sParamName:="ScanImportOutput", oConn:=oConn)
    If IsNumeric(sTemp) And _
       Val(sTemp) >= olcOutputLevelNone And _
       Val(sTemp) <= olcOutputLevelError Then
        'Set the default level
        lDefOutLevel = Val(sTemp)
    Else
        'Default to show all messages
        lDefOutLevel = olcOutputLevelMessage
    End If
    
    '** Removed 03-07-02 JJF
    ''Display a message box if we are compiled in testing mode
    '#If bOverrideDatabase Then
    '    MsgBox "Currently running in TESTING mode!!!" & vbCrLf & vbCrLf & "Using " & oConn.ConnectionString
    '#End If
    '** End of remove 03-07-02 JJF
    
    '** Added 05-27-05 JJF
    'Get country
    geCountry = GetQualProParamNum(sParamName:="Country", oConn:=oConn)
    
    'Get the Canadian Litho Range
    sTemp = GetQualProParamString(sParamName:="CanadianLithoRange", oConn:=oConn)
    nLoc = InStr(sTemp, ",")
    goCALithoRange.sMinLitho = Mid(sTemp, 1, nLoc - 1)
    goCALithoRange.sMaxLitho = Mid(sTemp, nLoc + 1)
    '** End of add 05-27-05 JJF
    
    'Close the database
    '** Modified 03-07-02 JJF
    'CloseDBConnection oConnection:=oConn
    CloseDBConnection oConn:=oConn
    '** End of modification 03-07-02 JJF
    
    '** Added 08-18-00 JJF
    'Initialize the progress bar control class
    Set goProgressBar = New CProgressBar
    goProgressBar.Register oStatusPanel:=sbrMain.Panels("Status"), _
                           oProgressPanel:=sbrMain.Panels("Progress"), _
                           oProgressBar:=pbrMain
    '** End of add 08-18-00 JJF
            
    'Set the override interval
    If GetCommandLineParameter(sParamID:="/OI:", sParamVal:=sTemp) Then
        'The override interval was found make sure the supplied value is numeric
        '  and between 1 and 60 seconds
        If IsNumeric(sTemp) And Val(sTemp) > 0 And Val(sTemp) <= 60 Then
            'The value supplied on the command line is valid so we go to override mode
            mlIntervalOverride = Val(sTemp) * 1000
            IntervalType = itcUseOverrideInterval
        Else
            'An invalid value was supplied
            mlIntervalOverride = mlIntervalDefault
            IntervalType = itcUseDefaultInterval
        End If
    Else
        'The override interval was not specified on the command line
        mlIntervalOverride = mlIntervalDefault
        IntervalType = itcUseDefaultInterval
    End If
    
    'Set the output level
    If GetCommandLineParameter(sParamID:="/OL:", sParamVal:=sTemp) Then
        'The output level was found so make sure the supplied value is valid
        If IsNumeric(sTemp) And _
           Val(sTemp) >= olcOutputLevelNone And _
           Val(sTemp) <= olcOutputLevelError Then
            'The value supplied is valid
            OutputLevel = Val(sTemp)
        Else
            'An invalid value was supplied
            OutputLevel = lDefOutLevel
        End If
    Else
        'The output level was not specified on the command line
        OutputLevel = lDefOutLevel
    End If
    
    '** Added 05-10-00 JJF
    'Set the multiple response level
    If GetCommandLineParameter(sParamID:="/MR:", sParamVal:=sTemp) Then
        'The multiple response level was found so make sure the supplied value is valid
        If IsNumeric(sTemp) And _
           Val(sTemp) >= mrcProcessAllQuestions And _
           Val(sTemp) <= mrcProcessSingleRespOnly Then
            'The value supplied is valid
            geMultipleResponseLevel = Val(sTemp)
        Else
            'An invalid value was supplied
            geMultipleResponseLevel = mrcProcessAllQuestions
        End If
    Else
        'The multiple response level was not specified on the command line
        geMultipleResponseLevel = mrcProcessAllQuestions
    End If
    '** End of add 05-10-00 JJF
    
    '** Added 12-16-02 JJF
    'Set the process bubble data
    If GetCommandLineParameter(sParamID:="/BD:", sParamVal:=sTemp) Then
        'The process bubble data was found so make sure the supplied value is valid
        If IsNumeric(sTemp) And _
           Val(sTemp) >= 0 And _
           Val(sTemp) <= 1 Then
            'The value supplied is valid
            chkSTR.Value = IIf(Val(sTemp) = 0, vbUnchecked, vbChecked)
        Else
            'An invalid value was supplied
            chkSTR.Value = vbChecked
        End If
    Else
        'The process bubble data was not specified on the command line
        chkSTR.Value = vbChecked
    End If
    
    'Set the process comment data
    If GetCommandLineParameter(sParamID:="/CD:", sParamVal:=sTemp) Then
        'The process comment data was found so make sure the supplied value is valid
        If IsNumeric(sTemp) And _
           Val(sTemp) >= 0 And _
           Val(sTemp) <= 1 Then
            'The value supplied is valid
            chkVSTR.Value = IIf(Val(sTemp) = 0, vbUnchecked, vbChecked)
        Else
            'An invalid value was supplied
            chkVSTR.Value = vbChecked
        End If
    Else
        'The process comment data was not specified on the command line
        chkVSTR.Value = vbChecked
    End If
    '** End of add 12-16-02 JJF
    
    'Enable the timer
    '** Modified 08-18-00 JJF
    'tmrImportReturns.Enabled = True
    TimerEnabled = True
    '** End of modification 08-18-00 JJF
    
End Sub



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Form_Resize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-31-2000
'\\
'\\ Description:    This event fires whenever the form is resized.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Form_Resize()
    
    'Locate the form
    Me.Move Screen.Width - Me.Width - 90, 90
    
End Sub


Private Sub Form_Unload(Cancel As Integer)
    
    '** Added 08-18-00 JJF
    'Cleanup the progress bar control class
    Set goProgressBar = Nothing
    '** End of add 08-18-00 JJF

End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   mnuFileExit_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine exits the program.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub mnuFileExit_Click()
    
    cmdStop.Value = True

End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   mnuFileHand_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine is used to process questionaires that
'\\                 were input by hand and never went through first
'\\                 pass (CreateDefinitionFiles.exe).
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-12-01    JJF     Changed parameter from a boolean to the
'\\                         Transfer Type enum.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub mnuFileHand_Click()
    
    Dim lSeconds As Long
    
    '** Modified 06-12-01 JJF
    'lSeconds = PollNow(bHandEntered:=True)
    lSeconds = PollNow(eTransferType:=ttcHandEntered)
    '** End of modification 06-12-01 JJF
    Output sMessage:="Hand Entered Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage

End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   mnuFileNonQualPro_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-12-2001
'\\
'\\ Description:    This routine is used to process questionaires that
'\\                 were scanned into the old system and need their
'\\                 results in QualPro but never went through first
'\\                 pass (CreateDefinitionFiles.exe).
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub mnuFileNonQualPro_Click()
    
    Dim lSeconds As Long
    
    lSeconds = PollNow(eTransferType:=ttcNonQualPro)
    Output sMessage:="Non-QualPro Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage

End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   mnuFileOptions_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine displays the options dialog.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub mnuFileOptions_Click()
    
    Dim oLocalOptionsForm As frmOptions
    
    'Disable the timer
    tmrImportReturns.Enabled = False
    
    'Load the options form
    Set oLocalOptionsForm = New frmOptions
    Load oLocalOptionsForm
    
    With oLocalOptionsForm
        'Setup the values
        .IntervalDefault = mlIntervalDefault
        .IntervalOverride = mlIntervalOverride
        .IntervalType = meIntervalType
        .OutputLevel = meOutputLevel
        
        'Show the form
        .Show vbModal
        
        'Determine what to do
        If .OKClicked Then
            mlIntervalOverride = .IntervalOverride
            IntervalType = .IntervalType
            OutputLevel = .OutputLevel
        End If
    End With
    
    'Unload the options form
    Unload oLocalOptionsForm
    Set oLocalOptionsForm = Nothing
    
    'Enable the timer
    tmrImportReturns.Enabled = True

End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   mnuFilePoll_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine fires off a manual run.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-12-01    JJF     Added Transfer Type enum parameter to call.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub mnuFilePoll_Click()
    
    Dim lSeconds As Long
    
    '** Modified 06-12-01 JJF
    'lSeconds = PollNow
    lSeconds = PollNow(eTransferType:=ttcNormal)
    '** End of modification 06-12-01 JJF
    
    Output sMessage:="Manual Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage

End Sub


Private Sub mnuFileWorkstations_Click()

    ShowActiveWorkstations

End Sub


Private Sub ShowActiveWorkstations()

    dlgShowCurrentUsers.Show vbModal
    Unload dlgShowCurrentUsers
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   tmrImportReturns_Timer
'\\
'\\ Created By:     X
'\\         Date:   00-00-2000
'\\
'\\ Description:    X
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     04-05-00    JJF     Modified to call into new code.
'\\     08-18-00    JJF     Changed status bar so that is shows the
'\\                         time remaining until the next run.  The
'\\                         timer now fires once every second.
'\\     06-12-01    JJF     Added Transfer Type enum parameter to call.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub tmrImportReturns_Timer()
    
    Dim lSeconds As Long
    
    '** Modified 08-18-00 JJF
    'lSeconds = PollNow
    'Output sMessage:="Automatic Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage
    
    'Determine if it is time to run the poll
    If mdtTimeToRun < Now Then
        'It is time to run so let's do it
        '** Modified 06-12-01 JJF
        'lSeconds = PollNow
        lSeconds = PollNow(eTransferType:=ttcNormal)
        '** End of modification 06-12-01 JJF
        
        Output sMessage:="Automatic Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage
    Else
        'It is not time to run yet so update the remaining seconds
        sbrMain.Panels("Interval").Text = DateDiff("s", Now, mdtTimeToRun) & " second(s)"
    End If
    '** End of modification 08-18-00 JJF
    
End Sub

Private Sub LogUserActivity(ByVal userActivity As eUserActivity)

    ' set the global variables to the current status of the checkboxes
    mbIsSTRChecked = chkSTR.Value = vbChecked
    mbIsVSTRChecked = chkVSTR.Value = vbChecked

    OpenDBConnection oConn:=goConn, sConnString:=goRegMainDBConnString.Value
    SetUserLoginInfo sUserName:=UserName, sWorkStationName:=ComputerName, iActivity:=userActivity, oConn:=goConn, bIsSTR:=mbIsSTRChecked, bIsVSTR:=mbIsVSTRChecked
    CloseDBConnection oConn:=goConn
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  OutputLevel
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets the output level and prepares for the form
'\\                 accordingly.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Changed so the status bar shows progress
'\\                         of the running poll.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let OutputLevel(ByVal eData As eOutputLevelCodes)
    
    Dim nHeight As Integer
    Dim bVisible As Boolean
    Dim sOutput As String
    
    meOutputLevel = eData
    
    Select Case meOutputLevel
        Case olcOutputLevelNone
            nHeight = 1905
            bVisible = False
            sOutput = "Don't show any messages"
        Case olcOutputLevelMessage
            nHeight = 4365
            bVisible = True
            sOutput = "Show all messages"
        Case olcOutputLevelWarning
            nHeight = 4365
            bVisible = True
            sOutput = "Show only Warning and Error messages"
        Case olcOutputLevelError
            nHeight = 4365
            bVisible = True
            sOutput = "Show only Error messages"
    End Select
    
    'Setup the display
    Me.Height = nHeight
    lvwOutput.Visible = bVisible
    sbrMain.Panels("OutputLevel").Text = sOutput
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  IntervalType
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets the interval type and prepares for the form
'\\                 accordingly.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Changed so that the remaining time until
'\\                         execution is shown in the status bar.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let IntervalType(ByVal eData As eIntervalTypeCodes)
    
    meIntervalType = eData
    
    If eData = itcUseDefaultInterval Then
        '** Modified 08-18-00 JJF
        'tmrImportReturns.Interval = mlIntervalDefault
        'sbrMain.Panels("IntervalCaption").Text = "Timer Default:"
        mlIntervalToUse = mlIntervalDefault / 1000
        '** End of modification 08-18-00 JJF
    Else
        '** Modified 08-18-00 JJF
        'tmrImportReturns.Interval = mlIntervalOverride
        'sbrMain.Panels("IntervalCaption").Text = "Timer Override:"
        mlIntervalToUse = mlIntervalOverride / 1000
        '** End of modification 08-18-00 JJF
    End If
    '** Removed 08-18-00 JJF
    'sbrMain.Panels("Interval").Text = "" & (tmrImportReturns.Interval / 1000) & " seconds "
    
End Property

