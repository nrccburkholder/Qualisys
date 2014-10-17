VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form frmScanExport 
   BackColor       =   &H00404040&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Create Definition Files"
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
   Begin ComctlLib.ListView lvwOutput 
      Height          =   2175
      Left            =   240
      TabIndex        =   2
      Top             =   960
      Width           =   6315
      _ExtentX        =   11139
      _ExtentY        =   3836
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
   Begin ComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   3
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
            TextSave        =   ""
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
            TextSave        =   ""
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
   Begin VB.CommandButton cmdManualPoll 
      Caption         =   "&Manual Poll"
      Height          =   495
      Left            =   960
      TabIndex        =   1
      Top             =   240
      Width           =   1935
   End
   Begin VB.CommandButton cmdStop 
      Caption         =   "Stop Timer and E&xit"
      Height          =   495
      Left            =   3900
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   240
      Width           =   1935
   End
   Begin VB.Timer tmrExportReturns 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   120
      Top             =   300
   End
   Begin ComctlLib.ImageList imlOutput 
      Left            =   6060
      Top             =   240
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
            Picture         =   "frmScanExport.frx":0000
            Key             =   "Message"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmScanExport.frx":031A
            Key             =   "Warning"
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmScanExport.frx":0634
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
      Begin VB.Menu mnuFileSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
End
Attribute VB_Name = "frmScanExport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private meOutputLevel       As eOutputLevelCodes
    Private meIntervalType      As eIntervalTypeCodes
    Private mlIntervalDefault   As Long
    Private mlIntervalOverride  As Long
    Private mlIntervalToUse     As Long
    Private mdtTimeToRun        As Date
    
    Private Const mknMaxOutputMessages  As Integer = 200
    
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
'\\                 export process.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type    Description
'\\     Long    Number of seconds elapsed during execution.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Changed so the status bar shows progress
'\\                         of the running poll.
'\\     10-31-05    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function PollNow() As Long
    
    Dim dtStart     As Date
    Dim dtFinish    As Date
    
    'Get the start time
    dtStart = Now
    
    'Set the mouse pointer
    Me.MousePointer = vbHourglass
    
    'Change the form color
    Me.BackColor = &HFF&
    
    'Lock things down so we cant be interupted in the middle of a run
    TimerEnabled = False
    Me.cmdManualPoll.Enabled = False
    Me.cmdStop.Enabled = False
    Me.mnuFile.Enabled = False
    
    'Process any existing files at this time
    ProcessFiles
    
    'Unlock everything
    Me.mnuFile.Enabled = True
    Me.cmdStop.Enabled = True
    Me.cmdManualPoll.Enabled = True
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
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub cmdManualPoll_Click()
    
    Dim lSeconds As Long
    
    lSeconds = PollNow
    Output sMessage:="Manual Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage
    
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
'\\                         the timer control to give the user a chance
'\\                         to answer the question.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub cmdStop_Click()

    Dim sMsg    As String
    Dim sTitle  As String
    
    'Disable the timer to give the user a chance
    tmrExportReturns.Enabled = False
    
    'Prepare the question
    sMsg = "Are you sure you want to stop polling barcode directory for files ?"
    sTitle = "Create Question Definition Files for each litho in barcode batch files"
    
    'Ask the question
    If MsgBox(sMsg, vbYesNo + vbCritical + vbDefaultButton2, sTitle) = vbYes Then
        'The user has chosen to head out of dodge
        Unload Me
    Else
        'The user has decided to stay so let's fire up the timer again
        tmrExportReturns.Enabled = True
    End If
    
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
'\\                 of seconds between attempts to export.
'\\                 Valid values:
'\\                     1 thru 60
'\\     /OL:        Sets the Output Level.  Specifies which types of
'\\                 output messages are displayed on screen.
'\\                 Valid values:
'\\                     0 = No messages are displayed
'\\                     1 = Display all messages
'\\                     2 = Display only Warnings and Errors
'\\                     3 = Display only Errors
'\\     /MR:        Sets the Multiple Response Level.  Specifies what
'\\                 type of questions to process.
'\\                 Valid values:
'\\                     0 = Process all questions (Default)
'\\                     1 = Process multiple response questions only
'\\                     2 = Process single response questions only
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
'\\     02-19-03    JJF     Moved some of the startup code to Sub Main.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     08-18-06    JJF   * Removed all old revision commenting.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Form_Load()
    
    Dim sTemp           As String
    Dim lDefOutLevel    As Long
    Dim nLoc            As Integer
    Dim oConn           As ADODB.Connection
    
    Me.Caption = App.ProductName & " - " & GetAppVersion
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Get the export interval
    sTemp = GetQualProParamString(sParamName:="ScanExportInterval", oConn:=oConn)
    If IsNumeric(sTemp) And Val(sTemp) > 0 And Val(sTemp) <= 60000 Then
        'Set the default interval
        mlIntervalDefault = Val(sTemp)
    Else
        'Default to 10 seconds
        mlIntervalDefault = 10000
    End If
    
    'Get the output level
    sTemp = GetQualProParamString(sParamName:="ScanExportOutput", oConn:=oConn)
    If IsNumeric(sTemp) And _
       Val(sTemp) >= olcOutputLevelNone And _
       Val(sTemp) <= olcOutputLevelError Then
        'Set the default level
        lDefOutLevel = Val(sTemp)
    Else
        'Default to show all messages
        lDefOutLevel = olcOutputLevelMessage
    End If
    
    'Get country
    geCountry = GetQualProParamNum(sParamName:="Country", oConn:=oConn)
    
    'Get the Canadian Litho Range
    sTemp = GetQualProParamString(sParamName:="CanadianLithoRange", oConn:=oConn)
    nLoc = InStr(sTemp, ",")
    goCALithoRange.sMinLitho = Mid(sTemp, 1, nLoc - 1)
    goCALithoRange.sMaxLitho = Mid(sTemp, nLoc + 1)
    
    'Close the database
    CloseDBConnection oConn:=oConn
    
    'Initialize the progress bar control class
    Set goProgressBar = New CProgressBar
    goProgressBar.Register oStatusPanel:=sbrMain.Panels("Status"), _
                           oProgressPanel:=sbrMain.Panels("Progress"), _
                           oProgressBar:=pbrMain
    
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
    
    'Enable the timer
    TimerEnabled = True
    
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


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Form_Unload
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine cleans up all module level objects
'\\                 before the program terminates.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     Cancel      Integer     TRUE  - Stop the form from unloading.
'\\                             FALSE - Allow the form to unload.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Form_Unload(Cancel As Integer)
    
    'Cleanup the progress bar control class
    Set goProgressBar = Nothing
    
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
    tmrExportReturns.Enabled = False
    
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
    tmrExportReturns.Enabled = True
    
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
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub mnuFilePoll_Click()
    
    Dim lSeconds As Long
    
    lSeconds = PollNow
    Output sMessage:="Manual Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage
    
End Sub

Private Sub mnuFileWorkstations_Click()
    
    Dim oUserInfo As New UserInfo.CUserInfo
    Dim bWeOpened As Boolean
    
    'Disable the timer to give the user a chance
    tmrExportReturns.Enabled = False
    
    'Open a database connection
    OpenDBConnection oConn:=goConn, sConnString:=goRegMainDBConnString.Value
    
    'Show the workstation list
    oUserInfo.ShowCurrentUsersDialog sProgramName:="Create Definition Files", _
                                     sDatabaseName:="QP_Prod", _
                                     oConn:=goConn
    
    'Close the database connection
    CloseDBConnection oConn:=goConn
    
    'The user has decided to stay so let's fire up the timer again
    tmrExportReturns.Enabled = True
    
    'Cleanup
    Set oUserInfo = Nothing
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   tmrExportReturns_Timer
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
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub tmrExportReturns_Timer()
    
    Dim lSeconds As Long
    
    'Determine if it is time to run the poll
    If mdtTimeToRun < Now Then
        'It is time to run so let's do it
        lSeconds = PollNow
        Output sMessage:="Automatic Poll completed in " & lSeconds & " seconds", eLevel:=omcOutputMessage
    Else
        'It is not time to run yet so update the remaining seconds
        sbrMain.Panels("Interval").Text = DateDiff("s", Now, mdtTimeToRun) & " second(s)"
    End If
    
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
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let OutputLevel(ByVal eData As eOutputLevelCodes)
    
    Dim nHeight     As Integer
    Dim bVisible    As Boolean
    Dim sOutput     As String
    
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
        mlIntervalToUse = mlIntervalDefault / 1000
    Else
        mlIntervalToUse = mlIntervalOverride / 1000
    End If
    
End Property



Public Property Get TimerEnabled() As Boolean
    
    TimerEnabled = tmrExportReturns.Enabled
    
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
    tmrExportReturns.Enabled = bData
    
End Property
