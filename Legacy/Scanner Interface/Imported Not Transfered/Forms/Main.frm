VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Object = "{BC691F0A-3A98-11D1-9464-00AA006F7AF1}#5.0#0"; "GSEnhLV.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   Caption         =   "Imported Not Transfered"
   ClientHeight    =   4635
   ClientLeft      =   165
   ClientTop       =   750
   ClientWidth     =   7590
   Icon            =   "Main.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4635
   ScaleWidth      =   7590
   StartUpPosition =   3  'Windows Default
   Begin ComctlLib.Toolbar tbrMain 
      Align           =   1  'Align Top
      Height          =   420
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   7590
      _ExtentX        =   13388
      _ExtentY        =   741
      ButtonWidth     =   635
      ButtonHeight    =   582
      AllowCustomize  =   0   'False
      Appearance      =   1
      ImageList       =   "imlMain"
      _Version        =   327682
      BeginProperty Buttons {0713E452-850A-101B-AFC0-4210102A8DA7} 
         NumButtons      =   18
         BeginProperty Button1 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Count"
            Object.ToolTipText     =   "Get Count"
            Object.Tag             =   ""
            ImageIndex      =   1
         EndProperty
         BeginProperty Button2 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "LithoCode"
            Object.ToolTipText     =   "Show List By LithoCode"
            Object.Tag             =   ""
            ImageIndex      =   2
         EndProperty
         BeginProperty Button3 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "SpecifyLitho"
            Object.ToolTipText     =   "Show List By Specific LithoCode"
            Object.Tag             =   ""
            ImageIndex      =   19
         EndProperty
         BeginProperty Button4 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Survey"
            Object.ToolTipText     =   "Show List By Survey"
            Object.Tag             =   ""
            ImageIndex      =   3
         EndProperty
         BeginProperty Button5 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "SurveyDate"
            Object.ToolTipText     =   "Show List By Survey / Date"
            Object.Tag             =   ""
            ImageIndex      =   4
         EndProperty
         BeginProperty Button6 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button7 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "History"
            Object.Tag             =   ""
            ImageIndex      =   16
         EndProperty
         BeginProperty Button8 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Log"
            Object.ToolTipText     =   "View Transfer Log"
            Object.Tag             =   ""
            ImageIndex      =   12
         EndProperty
         BeginProperty Button9 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "CDFLog"
            Object.ToolTipText     =   "View Create Definition Log"
            Object.Tag             =   ""
            ImageIndex      =   13
         EndProperty
         BeginProperty Button10 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button11 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Export"
            Object.ToolTipText     =   "Export current view to Excel"
            Object.Tag             =   ""
            ImageIndex      =   5
         EndProperty
         BeginProperty Button12 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button13 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button14 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Check"
            Object.ToolTipText     =   "Check All"
            Object.Tag             =   ""
            ImageIndex      =   8
         EndProperty
         BeginProperty Button15 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Uncheck"
            Object.ToolTipText     =   "Uncheck All"
            Object.Tag             =   ""
            ImageIndex      =   9
         EndProperty
         BeginProperty Button16 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button17 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Nondeliverable"
            Object.ToolTipText     =   "Mark as Non-Deliverable"
            Object.Tag             =   ""
            ImageIndex      =   15
         EndProperty
         BeginProperty Button18 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Reset"
            Object.ToolTipText     =   "Reset for Import"
            Object.Tag             =   ""
            ImageIndex      =   7
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog dlgMain 
      Left            =   6840
      Top             =   2400
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin GSEnhListView.GSListView lvwMain 
      Height          =   3915
      Left            =   60
      TabIndex        =   2
      Top             =   420
      Width           =   6495
      _ExtentX        =   11456
      _ExtentY        =   6906
      Enabled         =   0   'False
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
      MouseIcon       =   "Main.frx":0442
      MultiSelect     =   -1  'True
      View            =   3
      FullRowSelect   =   -1  'True
      SortType        =   2
   End
   Begin ComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   0
      Top             =   4335
      Width           =   7590
      _ExtentX        =   13388
      _ExtentY        =   529
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   3
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   11430
            TextSave        =   ""
            Key             =   "Status"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Bevel           =   0
            Object.Width           =   106
            MinWidth        =   106
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel3 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            AutoSize        =   2
            Object.Width           =   1270
            MinWidth        =   1270
            Key             =   "Version"
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList imlMain 
      Left            =   6840
      Top             =   1380
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   255
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   19
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":045E
            Key             =   "Count"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0570
            Key             =   "Litho"
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0682
            Key             =   "Survey"
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0794
            Key             =   "Date"
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":08A6
            Key             =   "Excel"
         EndProperty
         BeginProperty ListImage6 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0DF8
            Key             =   "Ignore"
         EndProperty
         BeginProperty ListImage7 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0F0A
            Key             =   "Reset"
         EndProperty
         BeginProperty ListImage8 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":144C
            Key             =   "Check"
         EndProperty
         BeginProperty ListImage9 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":155E
            Key             =   "Uncheck"
         EndProperty
         BeginProperty ListImage10 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1670
            Key             =   "Add"
         EndProperty
         BeginProperty ListImage11 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":177A
            Key             =   "Modify"
         EndProperty
         BeginProperty ListImage12 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":188C
            Key             =   "LogGood"
         EndProperty
         BeginProperty ListImage13 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":199E
            Key             =   "LogImage"
         EndProperty
         BeginProperty ListImage14 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1AB0
            Key             =   "LogCount"
         EndProperty
         BeginProperty ListImage15 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1BC2
            Key             =   "NonDel"
         EndProperty
         BeginProperty ListImage16 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1CD4
            Key             =   "History"
         EndProperty
         BeginProperty ListImage17 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1DE6
            Key             =   "OutOfRange"
         EndProperty
         BeginProperty ListImage18 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1EF8
            Key             =   "UpdateOutOfRange"
         EndProperty
         BeginProperty ListImage19 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":200A
            Key             =   "SpecifyLitho"
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileCount 
         Caption         =   "&Get Count"
         Shortcut        =   ^G
      End
      Begin VB.Menu mnuFileLithocode 
         Caption         =   "List By &LithoCode"
         Shortcut        =   ^L
      End
      Begin VB.Menu mnuFileSpecific 
         Caption         =   "List &By Specific LithoCode"
         Shortcut        =   ^B
      End
      Begin VB.Menu mnuFileSurvey 
         Caption         =   "List By &Survey"
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuFileSurveydate 
         Caption         =   "List By Survey / &Date"
         Shortcut        =   ^D
      End
      Begin VB.Menu mnuFileSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileHistory 
         Caption         =   "View &History"
         Shortcut        =   ^H
      End
      Begin VB.Menu mnuFileLog 
         Caption         =   "View &Transfer Log..."
         Shortcut        =   ^T
      End
      Begin VB.Menu mnuFileCDFLog 
         Caption         =   "View CD&F Log..."
      End
      Begin VB.Menu mnuFileSep3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExport 
         Caption         =   "&Export to Excel"
         Shortcut        =   ^E
      End
      Begin VB.Menu mnuFileSep4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Edit"
      Begin VB.Menu mnuEditCheck 
         Caption         =   "Check &All"
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuEditUncheck 
         Caption         =   "&Uncheck All"
         Shortcut        =   ^U
      End
      Begin VB.Menu mnuEditSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditNondeliverable 
         Caption         =   "Mark as Non-Deliverable"
      End
      Begin VB.Menu mnuEditReset 
         Caption         =   "Reset For Import"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Tools"
      Begin VB.Menu mnuToolsLithoCodeToBarcode 
         Caption         =   "Convert LithoCodes To Barcodes"
      End
      Begin VB.Menu mnuToolsLithoCodeToDLVFile 
         Caption         =   "Convert LithoCodes To DLV/NDL File"
      End
      Begin VB.Menu mnuToolsBarcodeToLithoCode 
         Caption         =   "Convert Barcodes To LithoCodes"
      End
      Begin VB.Menu mnuToolsSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsGetLithoCodesFromSTR 
         Caption         =   "Get LithoCodes From STR File"
      End
      Begin VB.Menu mnuToolsGetBarcodesFromSTR 
         Caption         =   "Get Barcodes From STR File"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private moFormBase  As CFormBase98
    Private moSurveys   As CSurveys
    
    Private Enum eUpdateTypeConstants
        eUTCMarkUndeliverable = 0
        eUTCResetForImport = 1
    End Enum
    
Private Sub DoUpdates(ByVal eUpdateType As eUpdateTypeConstants)
    
    Dim sMsg            As String
    Dim sInList         As String
    Dim bFound          As Boolean
    Dim bSameDay        As Boolean
    Dim lSelCnt         As Long
    Dim lSkipCntQS      As Long
    Dim lSkipCntDM      As Long
    Dim dtImportDate    As Date
    Dim oItem           As GSEnhListView.GSListItem
    Dim oConn           As ADODB.Connection
    Dim oTempCm         As ADODB.Command
    Dim oQualiSysResets As Collection
    Dim oDataMartResets As Collection
    
    'Make sure that we are in a mode where this is valid
    If lvwMain.Tag <> "LithoCode" Then Exit Sub
    
    'Let's make sure that something is actually checked
    For Each oItem In lvwMain.ListItems
        If oItem.Checked Then
            bFound = True
            Exit For
        End If
    Next oItem
    If Not bFound Then
        sMsg = "You must check off the records to be updated!"
        MsgBox sMsg, vbExclamation
        Exit Sub
    End If
    
    'Let's make sure that this is what we want to do
    Select Case eUpdateType
        Case eUpdateTypeConstants.eUTCMarkUndeliverable
            sMsg = "You have chosen to mark all of the selected questionnaires" & vbCrLf & _
                   "as non-deliverable!!!" & vbCrLf & vbCrLf & _
                   "This will set the Undeliverable Date to today's date and" & vbCrLf & _
                   "the Returned, Imported, and Unused dates to null and delete" & vbCrLf & _
                   "any existing results and comments." & vbCrLf & vbCrLf & _
                   "Are you sure this is what you want to do?"
        
        Case eUpdateTypeConstants.eUTCResetForImport
            sMsg = "You have chosen to reset all of the selected questionnaires" & vbCrLf & _
                   "for import!!!" & vbCrLf & vbCrLf & _
                   "This will set the Undeliverable, Returned, Imported, and Unused" & vbCrLf & _
                   "dates to null and delete any existing results and comments." & vbCrLf & vbCrLf & _
                   "Are you sure this is what you want to do?"
    End Select
    If MsgBox(sMsg, vbDefaultButton2 + vbQuestion + vbYesNo) = vbNo Then Exit Sub
    
    'If we are here then this is what we want to do
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Get a list of the selected LithoCodes
    Set oQualiSysResets = New Collection
    Set oDataMartResets = New Collection
    lSkipCntQS = 0
    lSkipCntDM = 0
    For Each oItem In lvwMain.ListItems
        If oItem.Checked Then
            'Determine the date results were imported
            On Error Resume Next
            dtImportDate = CDate(oItem.SubItems(eListviewColumnLocationConstants.eLCLLCImportDate))
            If Err.Number <> 0 Then
                dtImportDate = Now
                Err.Clear
            End If
            On Error GoTo 0
            
            'Determine if this is a same day reset
            bSameDay = (DatePart("m", dtImportDate) = DatePart("m", Now) And _
                        DatePart("d", dtImportDate) = DatePart("d", Now) And _
                        DatePart("yyyy", dtImportDate) = DatePart("yyyy", Now))
            
            'Determine whether or not we can reset this one
            If bSameDay Then
                If gbCanResetQS Or gbCanResetDM Then
                    'Add this item to the QualiSys reset list
                    oQualiSysResets.Add oItem
                Else
                    'User does not have permission for this reset
                    oItem.Checked = False
                    lSkipCntQS = lSkipCntQS + 1
                End If
            Else
                If gbCanResetDM Then
                    'Add this item to the DataMart reset list
                    oDataMartResets.Add oItem
                Else
                    'User does not have permission for this reset
                    oItem.Checked = False
                    lSkipCntDM = lSkipCntDM + 1
                End If
            End If
        End If
    Next oItem
    
    'Check to make sure we have not exceded the maximum datamart resets
    If oDataMartResets.Count > glMaxResetCountDM Then
        'The user has selected more than the maximum
        sMsg = "You have selected " & oDataMartResets.Count & " questionnaires as datamart (non same day) resets!" & vbCrLf & vbCrLf & _
               "The maximum number of questionnaires allowed for datamart resets is " & glMaxResetCountDM & "." & vbCrLf & vbCrLf & _
               "These questionnaires will not be reset.  Please contact the helpdesk."
        MsgBox sMsg, vbCritical
        
        'Clear the collection
        For lSelCnt = 1 To oDataMartResets.Count
            Set oItem = oDataMartResets.Item(1)
            oItem.Checked = False
            oDataMartResets.Remove 1
        Next lSelCnt
    End If
    
    'Check to see if we still have anything left to reset
    If oQualiSysResets.Count + oDataMartResets.Count > 0 Then
        'Notify user of the forthcoming changes
        sMsg = "You have selected the following questionnaires" & vbCrLf
        Select Case eUpdateType
            Case eUpdateTypeConstants.eUTCMarkUndeliverable
                sMsg = sMsg & "to be marked as non-deliverable" & vbCrLf & vbCrLf
                
            Case eUpdateTypeConstants.eUTCResetForImport
                sMsg = sMsg & "to be reset for import." & vbCrLf & vbCrLf
        
        End Select
        sMsg = sMsg & oQualiSysResets.Count & " same day resets." & vbCrLf & vbCrLf & _
               oDataMartResets.Count & " datamart (non same day) resets." & vbCrLf & vbCrLf
               
        'Add part of message noting how many are not allowed in QualiSys
        If lSkipCntQS > 0 Then
            sMsg = sMsg & lSkipCntQS & " questionnaires will be skipped due to lack" & vbCrLf & _
                   "of permissions to do same day resets." & vbCrLf & vbCrLf
        End If
        
        'Add part of message noting how many are not allowed in DataMart
        If lSkipCntDM > 0 Then
            sMsg = sMsg & lSkipCntDM & " questionnaires will be skipped due to lack" & vbCrLf & _
                   "of permissions to do datamart (non same day) resets." & vbCrLf & vbCrLf
        End If
        
        'Add the last part of the message
        sMsg = sMsg & "Do you wish to continue?"
        
        'Perform the reset
        If MsgBox(sMsg, vbDefaultButton2 + vbQuestion + vbYesNo) = vbYes And oQualiSysResets.Count + oDataMartResets.Count <> 0 Then
            'Open the database
            OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
            
            'Setup the reset command
            Set oTempCm = New ADODB.Command
            With oTempCm
                .CommandText = "QCL_ResetLitho"
                .CommandType = adCmdStoredProc
                .CommandTimeout = 0
                .ActiveConnection = oConn
                .Parameters.Append .CreateParameter("strNTLogin_nm", adVarChar, adParamInput, 50)
                .Parameters.Append .CreateParameter("strWorkstation", adVarChar, adParamInput, 50)
                .Parameters.Append .CreateParameter("Litho", adVarChar, adParamInput, 1100)
                .Parameters.Append .CreateParameter("bitNonDel", adBoolean, adParamInput)
            End With 'oTempCm
    
            'Set the default parameters
            oTempCm.Parameters("strNTLogin_nm") = goUserInfo.UserName
            oTempCm.Parameters("strWorkstation") = goUserInfo.ComputerName
            oTempCm.Parameters("bitNonDel") = (eUpdateType = eUpdateTypeConstants.eUTCMarkUndeliverable)
            
            'Set the error trap
            On Error GoTo ErrorHandler
            
            'Begin the transaction
            oConn.BeginTrans
            
            'Build the LithoCode list to be reset for Same Day resets
            lSelCnt = 0
            For Each oItem In oQualiSysResets
                If lSelCnt >= glMaxResetCountQS And lSelCnt <> 0 Then
                    'We need to execute this batch
                    oTempCm.Parameters("Litho") = sInList
                    oTempCm.Execute
                    
                    'Reset the variables
                    lSelCnt = 0
                    sInList = ""
                End If
                
                'Add this one
                sInList = sInList & IIf(Len(sInList) > 0, ",", "") & oItem.Text
                lSelCnt = lSelCnt + 1
            Next oItem
            
            'Build the LithoCode list to be reset for DataMart resets
            For Each oItem In oDataMartResets
                If lSelCnt >= glMaxResetCountQS And lSelCnt <> 0 Then
                    'We need to execute this batch
                    oTempCm.Parameters("Litho") = sInList
                    oTempCm.Execute
                    
                    'Reset the variables
                    lSelCnt = 0
                    sInList = ""
                End If
                
                'Add this one
                sInList = sInList & IIf(Len(sInList) > 0, ",", "") & oItem.Text
                lSelCnt = lSelCnt + 1
            Next oItem
            
            'Do the last reset
            If lSelCnt <> 0 Then
                'We need to execute this batch
                oTempCm.Parameters("Litho") = sInList
                oTempCm.Execute
                
                'Reset the variables
                lSelCnt = 0
                sInList = ""
            End If
            
            'Reset the values on the screen for the same day resets changed
            For Each oItem In oQualiSysResets
                If oItem.Checked Then
                    Select Case eUpdateType
                        Case eUpdateTypeConstants.eUTCMarkUndeliverable
                            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUndelDate) = Now
                        
                        Case eUpdateTypeConstants.eUTCResetForImport
                            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUndelDate) = ""
                    
                    End Select
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCReturnDate) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUnusedID) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUnusedDate) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCImportDate) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCBatchNumber) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCLineNumber) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCScanBatch) = ""
                    oItem.Checked = False
                End If
            Next oItem
            
            'Reset the values on the screen for the datamart resets changed
            For Each oItem In oDataMartResets
                If oItem.Checked Then
                    Select Case eUpdateType
                        Case eUpdateTypeConstants.eUTCMarkUndeliverable
                            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUndelDate) = Now
                        
                        Case eUpdateTypeConstants.eUTCResetForImport
                            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUndelDate) = ""
                    
                    End Select
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCReturnDate) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUnusedID) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUnusedDate) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCImportDate) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCBatchNumber) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCLineNumber) = ""
                    oItem.SubItems(eListviewColumnLocationConstants.eLCLLCScanBatch) = ""
                    oItem.Checked = False
                End If
            Next oItem
            
            'Commit the transaction
            oConn.CommitTrans
            
            'Display the message
            sMsg = "Reset Complete!"
            MsgBox sMsg, vbInformation
            
            'Terminate error handling
            On Error GoTo 0
        End If
    End If
    
Cleanup:
    'Close the database
    CloseDBConnection oConn:=oConn
    Set oItem = Nothing
    Set oTempCm = Nothing
    
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
Exit Sub


ErrorHandler:
    'Rollback the transaction
    oConn.RollbackTrans
    
    'Display a message
    sMsg = "The following unexpected error has been encountered!" & vbCrLf & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & _
           "Error #: " & Err.Number & vbCrLf & Err.Description & vbCrLf & vbCrLf & _
           "The requested operation has been terminated."
    MsgBox sMsg, vbCritical
    Resume Cleanup
    

End Sub


Private Property Let LockForm(ByVal bData As Boolean)
    
    Dim bTotal As Boolean
    
    mnuFileCount.Enabled = Not bData
    tbrMain.Buttons("Count").Enabled = Not bData
    
    mnuFileLithocode.Enabled = Not bData
    tbrMain.Buttons("LithoCode").Enabled = Not bData
    
    mnuFileSpecific.Enabled = Not bData
    tbrMain.Buttons("SpecifyLitho").Enabled = Not bData
    
    mnuFileSurvey.Enabled = Not bData
    tbrMain.Buttons("Survey").Enabled = Not bData
    
    mnuFileSurveydate.Enabled = Not bData
    tbrMain.Buttons("SurveyDate").Enabled = Not bData
    
    mnuFileHistory.Enabled = Not bData
    tbrMain.Buttons("History").Enabled = Not bData
    
    mnuFileLog.Enabled = Not bData
    tbrMain.Buttons("Log").Enabled = Not bData
    
    mnuFileCDFLog.Enabled = Not bData
    tbrMain.Buttons("CDFLog").Enabled = Not bData
    
    mnuFileExport.Enabled = Not bData
    tbrMain.Buttons("Export").Enabled = Not bData
    
    'bTotal = Not bData And (gePrivLevel >= plcPowerUser) And (lvwMain.Tag = "LithoCode")
    bTotal = (Not bData) And (lvwMain.Tag = "LithoCode") And (gbCanResetQS Or gbCanResetDM)
    
    mnuEditCheck.Enabled = bTotal
    tbrMain.Buttons("Check").Enabled = bTotal
    
    mnuEditUncheck.Enabled = bTotal
    tbrMain.Buttons("Uncheck").Enabled = bTotal
    
    mnuEditNondeliverable.Enabled = bTotal
    tbrMain.Buttons("Nondeliverable").Enabled = bTotal
    
    mnuEditReset.Enabled = bTotal
    tbrMain.Buttons("Reset").Enabled = bTotal
    
    mnuToolsBarcodeToLithoCode.Enabled = Not bData
    
    mnuToolsGetBarcodesFromSTR.Enabled = Not bData
    
    mnuToolsGetLithoCodesFromSTR.Enabled = Not bData
    
    mnuToolsLithoCodeToBarcode.Enabled = Not bData
    
    'mnu.Enabled = Not bData
    'tbrMain.Buttons("").Enabled = Not bData
    
End Property

Private Sub WriteLogEntry(ByVal sRunType As String, _
                          ByVal lQuestionnaires As Long, _
                          Optional ByVal lSurveys As Long = 0)
    
    Dim sLogFile As String
    Dim lLogHandle As Long
    
    'Check to see if the file exists
    sLogFile = App.Path & "\History.txt"
    lLogHandle = FreeFile
    
    If Len(Dir$(sLogFile, vbNormal)) = 0 Then
        'The file does not yet exist so create it
        Open sLogFile For Output As #lLogHandle
        
        'Write the header
        Print #lLogHandle, "Run Type          Questionnaires         Surveys  Date               "
        Print #lLogHandle, "----------------  --------------  --------------  -------------------"
    Else
        'Open the file
        Open sLogFile For Append As #lLogHandle
    End If
    
    'Output this entry
    Print #lLogHandle, RPad(sString:=sRunType, nLength:=16, bTruncate:=True) & "  " & _
                       LPad(sString:=lQuestionnaires, nLength:=14) & "  " & _
                       LPad(sString:=IIf(lSurveys = 0, "", lSurveys), nLength:=14) & "  " & _
                       Format(Now, "mm/dd/yyyy hh:mm:ss")
    
    'Close the log
    Close #lLogHandle
    
End Sub

Private Sub Form_Load()
    
    Dim sPrivLevel As String
    
    'Locate the form
    Set moFormBase = New CFormBase98
    moFormBase.Register frmForm:=Me, _
                        lHKey:=gsrsHKEYLocalMachine, _
                        sSection:=gksRegFormLocations
    moFormBase.LocateMe
    sbrMain.Panels("Version").Text = "  " & GetAppVersion & "  "
    
    'Setup the form for the priveledge level
    LockForm = False
    
    'Initialize the collections
    Set moSurveys = New CSurveys
    
    'Setup the form caption
    Me.Caption = App.Title
    
End Sub

Private Sub Form_Resize()
    
    Const knEdgeDist As Integer = 60
    Const knMinWidth As Integer = 7710
    Const knMinHeight As Integer = 5325
    
    'If the form is minimized then head out of dodge
    If Me.WindowState = vbMinimized Then Exit Sub
    
    'Size the form
    If Me.Width < knMinWidth Then Me.Width = knMinWidth
    If Me.Height < knMinHeight Then Me.Height = knMinHeight
    
    'Size the listview
    With lvwMain
        .Move knEdgeDist, tbrMain.Height, Me.ScaleWidth - knEdgeDist * 2, _
              Me.ScaleHeight - tbrMain.Height - sbrMain.Height
    End With
    
End Sub


Private Sub Form_Unload(Cancel As Integer)
    
    'Save the form location
    moFormBase.SaveLocation
    Set moFormBase = Nothing
    
    'Cleanup
    Set moSurveys = Nothing
    Set goUserInfo = Nothing
    
End Sub

Private Sub mnuEditCheck_Click()
    
    Dim oItem As GSEnhListView.GSListItem
    
    'Check all of the items in the list
    For Each oItem In lvwMain.ListItems
        oItem.Checked = True
    Next oItem
    
    Set oItem = Nothing
    
End Sub

Private Sub mnuEditNondeliverable_Click()
    
    DoUpdates eUpdateType:=eUTCMarkUndeliverable
    
End Sub

Private Sub mnuEditReset_Click()
    
    DoUpdates eUpdateType:=eUTCResetForImport
    
End Sub

Private Sub mnuEditUncheck_Click()
    
    Dim oItem As GSEnhListView.GSListItem
    
    'Uncheck all of the items in the list
    For Each oItem In lvwMain.ListItems
        oItem.Checked = False
    Next oItem
    
    Set oItem = Nothing
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   mnuFileCDFLog_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   09-06-2000
'\\
'\\ Description:    This routine opens and displays the selected
'\\                 log file created by CreateDefinitionFiles.exe
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub mnuFileCDFLog_Click()
    
    Dim sLogFile        As String
    Dim sLogPath        As String
    Dim sImage          As String
    Dim sLine           As String
    Dim sDateTime       As String
    Dim sCompUser       As String
    Dim sFileName       As String
    Dim sFileType       As String
    Dim nIgnored        As Integer
    Dim nError          As Integer
    Dim nSkipCnt        As Integer
    Dim nLithos         As Integer
    Dim nImages         As Integer
    Dim nGood           As Integer
    Dim lTotalIgnored   As Long
    Dim lTotalError     As Long
    Dim lLogHandle      As Long
    Dim lTotalFiles     As Long
    Dim lTotalLithos    As Long
    Dim lTotalGood      As Long
    Dim oConn           As ADODB.Connection
    Dim oItem           As GSEnhListView.GSListItem
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Setup the screen
    With lvwMain
        'Clear current settings
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        'Setup the sorting
        'The sorting will be taken care of manually in this view
        .SortType = gslvNoSort
        
        'Other settings
        .Enabled = True
        .Tag = "CDF"
        .GridLines = True
        Set .SmallIcons = imlMain
        .CheckBoxes = False
        
        'Add the column headers
        With .ColumnHeaders
            .Add , "Filename", "Filename", 1560, gslvColumnLeft, gslvAsText
            .Add , "Type", "Type", 720, gslvColumnLeft, gslvAsText
            .Add , "Lithos", "Lithos", 840, gslvColumnRight, gslvAsNumber
            .Add , "Images", "Images", 840, gslvColumnRight, gslvAsNumber
            .Add , "Good", "Good", 840, gslvColumnRight, gslvAsNumber
            .Add , "Ignored", "Ignored", 840, gslvColumnRight, gslvAsNumber
            .Add , "Error", "Error", 840, gslvColumnRight, gslvAsNumber
            .Add , "DateTime", "Date/Time", 1980, gslvColumnRight, gslvAsDate
            .Add , "CompUser", "Computer/User", 1980, gslvColumnLeft, gslvAsText
        End With '.ColumnHeaders
    End With 'lvwMain
    sbrMain.Panels("Status").Text = ""
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Get the path for the CDF logs
    sLogPath = GetQualProParamString(sParamName:="ScanExportLog", oConn:=oConn)
    If Len(sLogPath) = 0 Then sLogPath = App.Path
    
    'Close the database
    CloseDBConnection oConn:=oConn
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the CDF LOG file (INPUT)
    With dlgMain
        .DialogTitle = "Create Definition LOG File"
        .CancelError = True
        .DefaultExt = ".log"
        .Filter = "CDF Log (*CDF.log)|*CDF.log|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = sLogPath
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sLogFile = .filename
    End With
    
    'Reset the error trap
    On Error GoTo 0
    
    'Get the info from the file
    lLogHandle = FreeFile
    Open sLogFile For Input As #lLogHandle
    
    'Populate the listview
    While Not EOF(lLogHandle)
        'Read in a line
        Line Input #lLogHandle, sLine
        nSkipCnt = nSkipCnt + 1
        
        If nSkipCnt > 2 Then
            'Setup the required values
            sFileName = Trim(Left(sLine, 12))
            sFileType = Trim(Mid(sLine, 15, 4))
            nLithos = Val(Trim(Mid(sLine, 21, 8)))
            nImages = Val(Trim(Mid(sLine, 31, 8)))
            nGood = Val(Trim(Mid(sLine, 41, 8)))
            nIgnored = Val(Trim(Mid(sLine, 51, 8)))
            nError = Val(Trim(Mid(sLine, 61, 8)))
            sDateTime = Trim(Mid(sLine, 71, 19))
            If IsDate(sDateTime) Then sDateTime = CDate(sDateTime)
            sCompUser = Trim(Mid(sLine, 92, 50))
            
            'Determine the icon
            If nGood + nIgnored + nError <> nLithos Then
                sImage = "LogCount"
            Else
                sImage = "LogGood"
            End If
            
            'Add up the totals
            lTotalFiles = lTotalFiles + 1
            lTotalLithos = lTotalLithos + nLithos
            lTotalGood = lTotalGood + nGood
            lTotalIgnored = lTotalIgnored + nIgnored
            lTotalError = lTotalError + nError
            
            'Add this line to the output file
            Set oItem = lvwMain.ListItems.Add(, , sFileName, , sImage)
            oItem.SubItems(1) = sFileType
            oItem.SubItems(2) = nLithos
            oItem.SubItems(3) = nImages
            oItem.SubItems(4) = nGood
            oItem.SubItems(5) = nIgnored
            oItem.SubItems(6) = nError
            oItem.SubItems(7) = sDateTime
            oItem.SubItems(8) = sCompUser
        End If
    Wend
    
    'Close the file
    Close #lLogHandle
    
    'Display the totals
    Set oItem = lvwMain.ListItems.Add(, , "TOTALS:")
    oItem.SubItems(1) = lTotalFiles
    oItem.SubItems(2) = lTotalLithos
    oItem.SubItems(4) = lTotalGood
    oItem.SubItems(5) = lTotalIgnored
    oItem.SubItems(6) = lTotalError
    
    'Display the status
    sbrMain.Panels("Status").Text = "Create Definition Log: " & sLogFile
    
DLGErrorHandler:
    'Reset the mousepointer
    Set oItem = Nothing
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuFileCount_Click()
    
    Dim sSql        As String
    Dim sMsg        As String
    Dim lQuantity   As Long
    Dim oTempRS     As ADODB.Recordset
    Dim oConn       As ADODB.Connection
    Dim oTempCm     As ADODB.Command
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    
    'Clear the listview
    With lvwMain
        .ListItems.Clear
        .ColumnHeaders.Clear
        .Enabled = False
        .Tag = "Count"
    End With 'lvwMain
    sbrMain.Panels("Status").Text = ""
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Setup the command
    Set oTempCm = New ADODB.Command
    With oTempCm
        .CommandText = "sp_SI_INTGetCount"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 300
        .ActiveConnection = oConn
    End With 'oTempCm
    
    'Get the info from the database
    Set oTempRS = oTempCm.Execute
    
    'Get the count
    lQuantity = oTempRS!QtyRec
    
    'Close the recordset and database
    oTempRS.Close: Set oTempRS = Nothing
    Set oTempCm = Nothing
    CloseDBConnection oConn:=oConn
    
    'Update the log file
    WriteLogEntry sRunType:="Count Only", lQuestionnaires:=lQuantity
    
    'Reset the mousepointer
    Screen.MousePointer = vbNormal
    LockForm = False
    
    'Display the result to the user
    sMsg = "There are currently " & lQuantity & " questionnaires that have" & vbCrLf & _
           "been imported but have not had the results transfered." & vbCrLf & vbCrLf & _
           "Would you like to see the list?"
    If MsgBox(sMsg, vbDefaultButton2 + vbYesNo + vbQuestion) = vbNo Then Exit Sub
    
    'If we are here then the user has chosen to view the list
    mnuFileSurvey_Click
    
End Sub


Private Sub mnuFileExit_Click()
    
    Unload Me
    
End Sub

Private Sub mnuFileExport_Click()
    
    Dim lRow As Long
    Dim lCol As Long
    Dim oExcel As Excel.Application
    Dim oBook As Excel.Workbook
    Dim oSheet As Excel.Worksheet
    Dim oColumn As GSEnhListView.GSColumnHeader
    Dim oItem As GSEnhListView.GSListItem
    
    'If the listview is not enabled then head out of dodge
    If Not lvwMain.Enabled Then Exit Sub
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    
    'Create the excel object
    Set oExcel = New Excel.Application
    Set oBook = oExcel.Workbooks.Add
    Set oSheet = oBook.Sheets(1)
    
    'Make Excel visible
    oExcel.Visible = True
    
    'Populate the header row
    lCol = 0
    For Each oColumn In lvwMain.ColumnHeaders
        lCol = lCol + 1
        oSheet.Cells(1, lCol).Value = oColumn.Text
    Next oColumn
    
    'Populate the grid
    lRow = 1
    For Each oItem In lvwMain.ListItems
        lRow = lRow + 1
        lCol = 0
        For Each oColumn In lvwMain.ColumnHeaders
            lCol = lCol + 1
            If lCol = 1 Then
                oSheet.Cells(lRow, lCol) = oItem.Text
            Else
                oSheet.Cells(lRow, lCol) = oItem.SubItems(lCol - 1)
            End If
        Next oColumn
    Next oItem
    
    'Set the mousepointer
    Screen.MousePointer = vbNormal
    
    'Cleanup
    Set oSheet = Nothing
    Set oBook = Nothing
    Set oExcel = Nothing
    
End Sub

Private Sub mnuFileHistory_Click()
    
    Dim sLogFile        As String
    Dim sLine           As String
    Dim sRunType        As String
    Dim sDateTime       As String
    Dim sMsg            As String
    Dim nSkipCnt        As Integer
    Dim lLogHandle      As Long
    Dim lQuestionnaires As Long
    Dim lSurveys        As Long
    Dim oItem           As GSEnhListView.GSListItem
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Setup the screen
    With lvwMain
        'Clear current settings
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        'Setup the sorting
        .SortKey = 4    'Date
        .SortOrder = gslvAscending
        .SortType = gslvOnColumnClick
        
        'Other settings
        .Enabled = True
        .Tag = "History"
        .GridLines = True
        Set .SmallIcons = imlMain
        .CheckBoxes = False
        
        'Add the column headers
        With .ColumnHeaders
            .Add , "Type", "Type", 2160, gslvColumnLeft, gslvAsText
            .Add , "Questionnaires", "Questionnaires", 1440, gslvColumnRight, gslvAsNumber
            .Add , "Surveys", "Surveys", 1440, gslvColumnRight, gslvAsNumber
            .Add , "DateTime", "Date/Time", 2160, gslvColumnLeft, gslvAsDate
        End With '.ColumnHeaders
    End With 'lvwMain
    sbrMain.Panels("Status").Text = ""
    
    'Check to see if the file exists
    sLogFile = App.Path & "\History.txt"
    If Dir$(sLogFile, vbHidden) = "" Then
        sMsg = "No history log file exists!"
        MsgBox sMsg, vbInformation
        GoTo AllDone
    End If
    
    'Get the info from the file
    lLogHandle = FreeFile
    Open sLogFile For Input As #lLogHandle
    
    'Populate the listview
    While Not EOF(lLogHandle)
        'Read in a line
        Line Input #lLogHandle, sLine
        nSkipCnt = nSkipCnt + 1
        
        If nSkipCnt > 2 And Len(Trim(sLine)) > 0 Then
            'Setup the required values
            sRunType = Trim(Left(sLine, 16))
            lQuestionnaires = Val(Trim(Mid(sLine, 19, 14)))
            lSurveys = Val(Trim(Mid(sLine, 35, 14)))
            sDateTime = Trim(Mid(sLine, 51, 19))
            
            'Add this line to the output file
            Set oItem = lvwMain.ListItems.Add(, , sRunType, , "History")
            oItem.SubItems(1) = lQuestionnaires
            oItem.SubItems(2) = lSurveys
            oItem.SubItems(3) = sDateTime
        End If
    Wend
    
    'Close the file
    Close #lLogHandle
    
    'Display the status
    sbrMain.Panels("Status").Text = "History Log: " & sLogFile
    
AllDone:
    'Reset the mousepointer
    Set oItem = Nothing
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuFileLithocode_Click()
    
    Dim lLithoCode  As Long
    Dim oTempRS     As ADODB.Recordset
    Dim oConn       As ADODB.Connection
    Dim oItem       As GSEnhListView.GSListItem
    Dim oTempCm     As ADODB.Command
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Setup the screen
    With lvwMain
        'Clear current settings
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        'Setup the sorting
        .SortKey = 1    'LithoCode
        .SortOrder = gslvAscending
        .SortType = gslvOnColumnClick
        
        'Other settings
        .Enabled = True
        .Tag = "LithoCode"
        .GridLines = True
        Set .SmallIcons = imlMain
        
        'Turn on the checkboxes if we have this priviledge
        .CheckBoxes = (gbCanResetQS Or gbCanResetDM)
        
        'Add the column headers
        With .ColumnHeaders
            .Add , "strLithoCode", "LithoCode", 1500, gslvColumnLeft, gslvAsNumber
            .Add , "strBarcode", "Barcode", 960, gslvColumnLeft, gslvAsText
            .Add , "strClient_nm", "Client", 3240, gslvColumnLeft, gslvAsText
            .Add , "strSurvey_nm", "Survey", 1260, gslvColumnLeft, gslvAsText
            .Add , "datUndeliverable", "Undeliverable", 1980, gslvColumnRight, gslvAsDate
            .Add , "datReturned", "Returned", 1980, gslvColumnRight, gslvAsDate
            .Add , "UnusedReturn_id", "UR ID", 900, gslvColumnRight, gslvAsNumber
            .Add , "datUnusedReturn", "UnusedReturn", 1980, gslvColumnRight, gslvAsDate
            .Add , "datResultsImported", "Imported", 1980, gslvColumnRight, gslvAsDate
            .Add , "strSTRBatchNumber", "STR Batch", 900, gslvColumnLeft, gslvAsText
            .Add , "intSTRLineNumber", "STR Line", 900, gslvColumnLeft, gslvAsNumber
            .Add , "strScanBatch", "Scan Batch", 900, gslvColumnLeft, gslvAsText
            .Add , "SentMail_id", "SM ID", 900, gslvColumnRight, gslvAsNumber
            .Add , "QuestionForm_id", "QF ID", 900, gslvColumnRight, gslvAsNumber
            .Add , "Survey_id", "Survey ID", 900, gslvColumnRight, gslvAsNumber
        End With '.ColumnHeaders
    End With 'lvwMain
    sbrMain.Panels("Status").Text = ""
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Setup the command
    Set oTempCm = New ADODB.Command
    With oTempCm
        .CommandText = "sp_SI_INTGetLithoCodes"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = oConn
    End With 'oTempCm
    
    'Get the info from the database
    Set oTempRS = oTempCm.Execute

    'Populate the listview
    With lvwMain.ListItems
        Do Until oTempRS.EOF
            'Add this entry
            lLithoCode = Val("" & oTempRS!strLithoCode)
            Set oItem = .Add(, "SM" & oTempRS!SentMail_id, "" & oTempRS!strLithoCode, , "Litho")
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCBarcode) = Crunch(lLithoCode:=lLithoCode)
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCClientName) = "" & oTempRS!strClient_nm
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCSurveyName) = "" & oTempRS!strSurvey_nm
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUndelDate) = "" & oTempRS!datUndeliverable
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCReturnDate) = "" & oTempRS!datReturned
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUnusedID) = "" & oTempRS!UnusedReturn_id
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUnusedDate) = "" & oTempRS!datUnusedReturn
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCImportDate) = "" & oTempRS!datResultsImported
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCBatchNumber) = "" & oTempRS!strSTRBatchNumber
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCLineNumber) = "" & oTempRS!intSTRLineNumber
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCScanBatch) = "" & oTempRS!strScanBatch
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCSentMailID) = "" & oTempRS!SentMail_id
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCQstnFormID) = "" & oTempRS!QuestionForm_id
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCSurveyID) = "" & oTempRS!Survey_id
            
            'Prepare for the next pass
            oTempRS.MoveNext
            Set oItem = Nothing
        Loop
    End With 'lvwMain.ListItems
    
    'Close the recordset and database
    oTempRS.Close: Set oTempRS = Nothing
    Set oTempCm = Nothing
    CloseDBConnection oConn:=oConn
    
    'Display the status
    sbrMain.Panels("Status").Text = lvwMain.ListItems.Count & " Questionnaire(s)"
    
    'Update the log file
    WriteLogEntry sRunType:="By LithoCode", lQuestionnaires:=lvwMain.ListItems.Count
    
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   mnuFileLog_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   06-21-2000
'\\
'\\ Description:    This routine opens and displays the selected
'\\                 log file created by TransferResults.exe
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     09-06-00    JJF     Added date/time and computer/user fields
'\\                         to the log file.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub mnuFileLog_Click()
    
    Dim sLogFile            As String
    Dim sLogPath            As String
    Dim sImage              As String
    Dim sLine               As String
    Dim sPaperSize          As String
    Dim sBatchNumber        As String
    Dim sDateTime           As String
    Dim sCompUser           As String
    Dim sLogType            As String
    Dim nImagesPerLine      As Integer
    Dim nQtyImages          As Integer
    Dim nHEQtyLines         As Integer
    Dim nHEImported         As Integer
    Dim nHEIgnored          As Integer
    Dim nHEError            As Integer
    Dim nQtyLines           As Integer
    Dim nImported           As Integer
    Dim nIgnored            As Integer
    Dim nError              As Integer
    Dim nGeneral            As Integer
    Dim nContact            As Integer
    Dim nSAlert             As Integer
    Dim nSkipCnt            As Integer
    Dim lTotalBatch         As Long
    Dim lTotalHELines       As Long
    Dim lTotalHEImported    As Long
    Dim lTotalHEIgnored     As Long
    Dim lTotalHEError       As Long
    Dim lTotalLines         As Long
    Dim lTotalImported      As Long
    Dim lTotalIgnored       As Long
    Dim lTotalError         As Long
    Dim lTotalGeneral       As Long
    Dim lTotalContact       As Long
    Dim lTotalSAlert        As Long
    Dim lLogHandle          As Long
    Dim oConn               As ADODB.Connection
    Dim oItem               As GSEnhListView.GSListItem
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Setup the screen
    With lvwMain
        'Clear current settings
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        'Setup the sorting
        'The sorting will be taken care of manually in this view
        .SortType = gslvNoSort
        
        'Other settings
        .Enabled = True
        .Tag = "Transfer"
        .GridLines = True
        Set .SmallIcons = imlMain
        .CheckBoxes = False
    End With 'lvwMain
    sbrMain.Panels("Status").Text = ""
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Get the path for the transfer logs
    sLogPath = GetQualProParamString(sParamName:="ScanImportLog", oConn:=oConn)
    If Len(sLogPath) = 0 Then sLogPath = App.Path
    
    'Close the database
    CloseDBConnection oConn:=oConn
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the Transfer LOG file (INPUT)
    With dlgMain
        .DialogTitle = "Transfer LOG File"
        .CancelError = True
        .DefaultExt = ".log"
        .Filter = "Transfer Log (*TR.log)|*TR.log|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = sLogPath
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sLogFile = .filename
    End With
    
    'Reset the error trap
    On Error GoTo 0
    
    'Setup the listview for the log file type
    If UCase(Left(Right(sLogFile, 8), 4)) = "VSTR" Then
        'This is a comment log file
        sLogType = "Comment"
        
        'Add the column headers
        With lvwMain.ColumnHeaders
            .Add , "BatchNumber", "Batch Number", 2000, gslvColumnLeft, gslvAsText
            .Add , "QtyHandEnt", "Qty Hand Entry", 1200, gslvColumnRight, gslvAsNumber
            .Add , "HEImported", "Imported", 840, gslvColumnRight, gslvAsNumber
            .Add , "HEIgnored", "Ignored", 840, gslvColumnRight, gslvAsNumber
            .Add , "HEError", "Error", 840, gslvColumnRight, gslvAsNumber
            .Add , "QtyCmnts", "Qty Comments", 1200, gslvColumnRight, gslvAsNumber
            .Add , "Imported", "Imported", 840, gslvColumnRight, gslvAsNumber
            .Add , "Ignored", "Ignored", 840, gslvColumnRight, gslvAsNumber
            .Add , "Error", "Error", 840, gslvColumnRight, gslvAsNumber
            .Add , "General", "General", 840, gslvColumnRight, gslvAsNumber
            .Add , "Contact", "Contact", 840, gslvColumnRight, gslvAsNumber
            .Add , "SAlert", "SAlert", 840, gslvColumnRight, gslvAsNumber
            .Add , "DateTime", "Date/Time", 1980, gslvColumnRight, gslvAsDate
            .Add , "CompUser", "Computer/User", 1980, gslvColumnLeft, gslvAsText
        End With 'lvwMain.ColumnHeaders
    Else
        'This is a bubble data log file
        sLogType = "Bubble"
        
        'Add the column headers
        With lvwMain.ColumnHeaders
            .Add , "PaperSize", "Paper Size", 1560, gslvColumnLeft, gslvAsText
            .Add , "BatchNumber", "Batch Number", 1320, gslvColumnLeft, gslvAsText
            .Add , "QtyLines", "Qty Lines", 1200, gslvColumnRight, gslvAsNumber
            .Add , "ImagesLine", "Images/Line", 1200, gslvColumnRight, gslvAsNumber
            .Add , "QtyImages", "Images Found", 1200, gslvColumnRight, gslvAsNumber
            .Add , "Imported", "Imported", 840, gslvColumnRight, gslvAsNumber
            .Add , "Ignored", "Ignored", 840, gslvColumnRight, gslvAsNumber
            .Add , "Error", "Error", 840, gslvColumnRight, gslvAsNumber
            .Add , "DateTime", "Date/Time", 1980, gslvColumnRight, gslvAsDate
            .Add , "CompUser", "Computer/User", 1980, gslvColumnLeft, gslvAsText
        End With 'lvwMain.ColumnHeaders
    End If
    
    'Get the info from the file
    lLogHandle = FreeFile
    Open sLogFile For Input As #lLogHandle
    
    'Populate the listview
    While Not EOF(lLogHandle)
        'Read in a line
        Line Input #lLogHandle, sLine
        nSkipCnt = nSkipCnt + 1
        
        If nSkipCnt > 2 Then
            Select Case sLogType
                Case "Comment"
                    'Setup the required values
                    sBatchNumber = Trim(Left(sLine, 40))
                    nHEQtyLines = Val(Trim(Mid(sLine, 43, 11)))
                    nHEImported = Val(Trim(Mid(sLine, 56, 8)))
                    nHEIgnored = Val(Trim(Mid(sLine, 66, 8)))
                    nHEError = Val(Trim(Mid(sLine, 76, 8)))
                    nQtyLines = Val(Trim(Mid(sLine, 86, 11)))
                    nImported = Val(Trim(Mid(sLine, 99, 8)))
                    nIgnored = Val(Trim(Mid(sLine, 109, 8)))
                    nError = Val(Trim(Mid(sLine, 119, 8)))
                    nGeneral = Val(Trim(Mid(sLine, 129, 10)))
                    nContact = Val(Trim(Mid(sLine, 141, 10)))
                    nSAlert = Val(Trim(Mid(sLine, 153, 10)))
                    sDateTime = Trim(Mid(sLine, 165, 19))
                    If IsDate(sDateTime) Then sDateTime = CDate(sDateTime)
                    sCompUser = Trim(Mid(sLine, 186, 50))
                    
                    'Determine the icon
                    If (nImported + nIgnored + nError <> nQtyLines) Or (nHEImported + nHEIgnored + nHEError <> nHEQtyLines) Then
                        sImage = "LogCount"
                    Else
                        sImage = "LogGood"
                    End If
                    
                    'Add up the totals
                    lTotalBatch = lTotalBatch + 1
                    lTotalHELines = lTotalHELines + nHEQtyLines
                    lTotalHEImported = lTotalHEImported + nHEImported
                    lTotalHEIgnored = lTotalHEIgnored + nHEIgnored
                    lTotalHEError = lTotalHEError + nHEError
                    lTotalLines = lTotalLines + nQtyLines
                    lTotalImported = lTotalImported + nImported
                    lTotalIgnored = lTotalIgnored + nIgnored
                    lTotalError = lTotalError + nError
                    lTotalGeneral = lTotalGeneral + nGeneral
                    lTotalContact = lTotalContact + nContact
                    lTotalSAlert = lTotalSAlert + nSAlert
                    
                    'Add this line to the listview
                    Set oItem = lvwMain.ListItems.Add(, , sBatchNumber, , sImage)
                    oItem.SubItems(1) = nHEQtyLines
                    oItem.SubItems(2) = nHEImported
                    oItem.SubItems(3) = nHEIgnored
                    oItem.SubItems(4) = nHEError
                    oItem.SubItems(5) = nQtyLines
                    oItem.SubItems(6) = nImported
                    oItem.SubItems(7) = nIgnored
                    oItem.SubItems(8) = nError
                    oItem.SubItems(9) = nGeneral
                    oItem.SubItems(10) = nContact
                    oItem.SubItems(11) = nSAlert
                    oItem.SubItems(12) = sDateTime
                    oItem.SubItems(13) = sCompUser
                    
                Case "Bubble"
                    'Setup the required values
                    sPaperSize = Trim(Left(sLine, 11))
                    sBatchNumber = Trim(Mid(sLine, 12, 8))
                    nQtyLines = Val(Trim(Mid(sLine, 22, 11)))
                    nImagesPerLine = Val(Trim(Mid(sLine, 35, 11)))
                    nQtyImages = Val(Trim(Mid(sLine, 48, 11)))
                    nImported = Val(Trim(Mid(sLine, 61, 8)))
                    nIgnored = Val(Trim(Mid(sLine, 71, 8)))
                    nError = Val(Trim(Mid(sLine, 81, 8)))
                    sDateTime = Trim(Mid(sLine, 91, 19))
                    If IsDate(sDateTime) Then sDateTime = CDate(sDateTime)
                    sCompUser = Trim(Mid(sLine, 112, 50))
                    
                    'Determine the icon
                    If nQtyLines * nImagesPerLine <> nQtyImages Then
                        sImage = "LogImage"
                    ElseIf nImported + nIgnored + nError <> nQtyLines Then
                        sImage = "LogCount"
                    Else
                        sImage = "LogGood"
                    End If
                    
                    'Add up the totals
                    lTotalBatch = lTotalBatch + 1
                    lTotalLines = lTotalLines + nQtyLines
                    lTotalImported = lTotalImported + nImported
                    lTotalIgnored = lTotalIgnored + nIgnored
                    lTotalError = lTotalError + nError
                    
                    'Add this line to the listview
                    Set oItem = lvwMain.ListItems.Add(, , sPaperSize, , sImage)
                    oItem.SubItems(1) = sBatchNumber
                    oItem.SubItems(2) = nQtyLines
                    oItem.SubItems(3) = nImagesPerLine
                    oItem.SubItems(4) = nQtyImages
                    oItem.SubItems(5) = nImported
                    oItem.SubItems(6) = nIgnored
                    oItem.SubItems(7) = nError
                    oItem.SubItems(8) = sDateTime
                    oItem.SubItems(9) = sCompUser
            End Select
        End If
    Wend
    
    'Close the file
    Close #lLogHandle
    
    'Display the totals
    Select Case sLogType
        Case "Comment"
            Set oItem = lvwMain.ListItems.Add(, , "TOTALS:  (" & lTotalBatch & ")")
            oItem.SubItems(1) = lTotalHELines
            oItem.SubItems(2) = lTotalHEImported
            oItem.SubItems(3) = lTotalHEIgnored
            oItem.SubItems(4) = lTotalHEError
            oItem.SubItems(5) = lTotalLines
            oItem.SubItems(6) = lTotalImported
            oItem.SubItems(7) = lTotalIgnored
            oItem.SubItems(8) = lTotalError
            oItem.SubItems(9) = lTotalGeneral
            oItem.SubItems(10) = lTotalContact
            oItem.SubItems(11) = lTotalSAlert
        
        Case "Bubble"
            Set oItem = lvwMain.ListItems.Add(, , "TOTALS:")
            oItem.SubItems(1) = lTotalBatch
            oItem.SubItems(2) = lTotalLines
            oItem.SubItems(5) = lTotalImported
            oItem.SubItems(6) = lTotalIgnored
            oItem.SubItems(7) = lTotalError
            
    End Select
    
    'Display the status
    sbrMain.Panels("Status").Text = "Transfer Log: " & sLogFile
    
DLGErrorHandler:
    'Reset the mousepointer
    Set oItem = Nothing
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuFileSpecific_Click()
    
    Dim sInList         As String
    Dim lLithoCode      As Long
    Dim oTempRS         As ADODB.Recordset
    Dim oConn           As ADODB.Connection
    Dim oItem           As GSEnhListView.GSListItem
    Dim oSpecifyForm    As frmSpecifyLithoCode
    Dim oTempCm         As ADODB.Command
    
    'Load the form
    Set oSpecifyForm = New frmSpecifyLithoCode
    Load oSpecifyForm
    
    'Display the form
    With oSpecifyForm
        .Show vbModal
        
        'Get the results
        If .OKClicked Then
            sInList = .LithoInList
        Else
            sInList = ""
        End If
    End With
    
    'Cleanup the form
    Unload oSpecifyForm
    Set oSpecifyForm = Nothing
    
    'If the user canceled then we are done
    If Len(sInList) = 0 Then Exit Sub
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Setup the screen
    With lvwMain
        'Clear current settings
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        'Setup the sorting
        .SortKey = 1    'LithoCode
        .SortOrder = gslvAscending
        .SortType = gslvOnColumnClick
        
        'Other settings
        .Enabled = True
        .Tag = "LithoCode"
        .GridLines = True
        Set .SmallIcons = imlMain
        
        'Turn on the checkboxes if we have this priviledge
        .CheckBoxes = (gbCanResetQS Or gbCanResetDM)
        
        'Add the column headers
        With .ColumnHeaders
            .Add , "strLithoCode", "LithoCode", 1500, gslvColumnLeft, gslvAsNumber
            .Add , "strBarcode", "Barcode", 960, gslvColumnLeft, gslvAsText
            .Add , "strClient_nm", "Client", 3240, gslvColumnLeft, gslvAsText
            .Add , "strSurvey_nm", "Survey", 1260, gslvColumnLeft, gslvAsText
            .Add , "datUndeliverable", "Undeliverable", 1980, gslvColumnRight, gslvAsDate
            .Add , "datReturned", "Returned", 1980, gslvColumnRight, gslvAsDate
            .Add , "UnusedReturn_id", "UR ID", 900, gslvColumnRight, gslvAsNumber
            .Add , "datUnusedReturn", "UnusedReturn", 1980, gslvColumnRight, gslvAsDate
            .Add , "datResultsImported", "Imported", 1980, gslvColumnRight, gslvAsDate
            .Add , "strSTRBatchNumber", "STR Batch", 900, gslvColumnLeft, gslvAsText
            .Add , "intSTRLineNumber", "STR Line", 900, gslvColumnLeft, gslvAsNumber
            .Add , "strScanBatch", "Scan Batch", 900, gslvColumnLeft, gslvAsText
            .Add , "SentMail_id", "SM ID", 900, gslvColumnRight, gslvAsNumber
            .Add , "QuestionForm_id", "QF ID", 900, gslvColumnRight, gslvAsNumber
            .Add , "Survey_id", "Survey ID", 900, gslvColumnRight, gslvAsNumber
        End With '.ColumnHeaders
    End With 'lvwMain
    sbrMain.Panels("Status").Text = ""
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Setup the command
    Set oTempCm = New ADODB.Command
    With oTempCm
        .CommandText = "sp_SI_INTGetSpecificLithoCodes"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = oConn
        .Parameters.Append .CreateParameter("LithoInList", adVarChar, adParamInput, 6240)
    End With 'oTempCm
    
    'Get the info from the database
    oTempCm.Parameters("LithoInList") = sInList
    Set oTempRS = oTempCm.Execute
    
    'Populate the listview
    With lvwMain.ListItems
        Do Until oTempRS.EOF
            'Add this entry
            lLithoCode = Val("" & oTempRS!strLithoCode)
            Set oItem = .Add(, "SM" & oTempRS!SentMail_id, "" & oTempRS!strLithoCode, , "SpecifyLitho")
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCBarcode) = Crunch(lLithoCode:=lLithoCode)
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCClientName) = "" & oTempRS!strClient_nm
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCSurveyName) = "" & oTempRS!strSurvey_nm
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUndelDate) = "" & oTempRS!datUndeliverable
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCReturnDate) = "" & oTempRS!datReturned
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUnusedID) = "" & oTempRS!UnusedReturn_id
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCUnusedDate) = "" & oTempRS!datUnusedReturn
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCImportDate) = "" & oTempRS!datResultsImported
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCBatchNumber) = "" & oTempRS!strSTRBatchNumber
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCLineNumber) = "" & oTempRS!intSTRLineNumber
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCScanBatch) = "" & oTempRS!strScanBatch
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCSentMailID) = "" & oTempRS!SentMail_id
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCQstnFormID) = "" & oTempRS!QuestionForm_id
            oItem.SubItems(eListviewColumnLocationConstants.eLCLLCSurveyID) = "" & oTempRS!Survey_id
            
            'Prepare for the next pass
            oTempRS.MoveNext
            Set oItem = Nothing
        Loop
    End With 'lvwMain.ListItems
    
    'Close the recordset and database
    oTempRS.Close: Set oTempRS = Nothing
    Set oTempCm = Nothing
    CloseDBConnection oConn:=oConn
    
    'Display the status
    sbrMain.Panels("Status").Text = lvwMain.ListItems.Count & " Questionnaire(s)"
    
    'Update the log file
    WriteLogEntry sRunType:="By Spec Lithos", lQuestionnaires:=lvwMain.ListItems.Count
    
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuFileSurvey_Click()
    
    Dim lSurveyCnt  As Long
    Dim oTempRS     As ADODB.Recordset
    Dim oConn       As ADODB.Connection
    Dim oItem       As GSEnhListView.GSListItem
    Dim oTempCm     As ADODB.Command
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Setup the screen
    With lvwMain
        'Clear current settings
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        'Setup the sorting
        .SortKey = 4    'QtySurveys
        .SortOrder = gslvDescending
        .SortType = gslvOnColumnClick
        
        'Other settings
        .Enabled = True
        .Tag = "Survey"
        .GridLines = True
        Set .SmallIcons = imlMain
        
        'Turn on the checkboxes if we have this priviledge
        .CheckBoxes = False
        
        'Add the column headers
        With .ColumnHeaders
            .Add , "strClient_nm", "Client", 3600, gslvColumnLeft, gslvAsText
            .Add , "strSurvey_nm", "Survey", 1260, gslvColumnLeft, gslvAsText
            .Add , "Survey_id", "Survey ID", 900, gslvColumnRight, gslvAsNumber
            .Add , "QtySurveys", "Qty Surveys", 1440, gslvColumnRight, gslvAsNumber
        End With '.ColumnHeaders
    End With 'lvwMain
    sbrMain.Panels("Status").Text = ""
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Setup the command
    Set oTempCm = New ADODB.Command
    With oTempCm
        .CommandText = "sp_SI_INTGetSurveys"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = oConn
    End With 'oTempCm
    
    'Get the info from the database
    Set oTempRS = oTempCm.Execute

    'Populate the listview
    lSurveyCnt = 0
    With lvwMain.ListItems
        Do Until oTempRS.EOF
            'Add this entry
            Set oItem = .Add(, , "" & oTempRS!strClient_nm, , "Survey")
            oItem.SubItems(1) = "" & oTempRS!strSurvey_nm
            oItem.SubItems(2) = "" & oTempRS!Survey_id
            oItem.SubItems(3) = "" & oTempRS!QtySurveys
            lSurveyCnt = lSurveyCnt + oTempRS!QtySurveys
            
            'Prepare for the next pass
            oTempRS.MoveNext
            Set oItem = Nothing
        Loop
    End With 'lvwMain.ListItems
    
    'Close the recordset and database
    oTempRS.Close: Set oTempRS = Nothing
    Set oTempCm = Nothing
    CloseDBConnection oConn:=oConn
    
    'Display the status
    sbrMain.Panels("Status").Text = lSurveyCnt & " Questionnaire(s) in " & lvwMain.ListItems.Count & " Survey(s)"
    
    'Update the log file
    WriteLogEntry sRunType:="By Survey", lQuestionnaires:=lSurveyCnt, lSurveys:=lvwMain.ListItems.Count
    
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuFileSurveydate_Click()
    
    Dim lSurveyCnt  As Long
    Dim oTempRS     As ADODB.Recordset
    Dim oConn       As ADODB.Connection
    Dim oItem       As GSEnhListView.GSListItem
    Dim oSurvey     As CSurvey
    Dim oReturn     As CDateReturned
    Dim sSurveyID   As String
    Dim oTempCm     As ADODB.Command
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Setup the screen
    With lvwMain
        'Clear current settings
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        'Setup the sorting
        'The sorting will be taken care of manually in this view
        .SortType = gslvNoSort
        
        'Other settings
        .Enabled = True
        .Tag = "SurveyDate"
        .GridLines = True
        Set .SmallIcons = imlMain
        
        'Turn on the checkboxes if we have this priviledge
        .CheckBoxes = False
        
        'Add the column headers
        With .ColumnHeaders
            .Add , "strClient_nm", "Client", 3600, gslvColumnLeft, gslvAsText
            .Add , "strSurvey_nm", "Survey", 1260, gslvColumnLeft, gslvAsText
            .Add , "Survey_id", "Survey ID", 900, gslvColumnRight, gslvAsNumber
            .Add , "QtyTotal", "Qty Total", 1020, gslvColumnRight, gslvAsNumber
            .Add , "DateReturned", "Returned", 1140, gslvColumnRight, gslvAsDate
            .Add , "QtySurveys", "Quantity", 1020, gslvColumnRight, gslvAsNumber
        End With '.ColumnHeaders
    End With 'lvwMain
    sbrMain.Panels("Status").Text = ""
    
    'Open the database
    OpenDBConnection oConn:=oConn, sConnString:=goRegMainDBConnString.Value
    
    'Setup the command
    Set oTempCm = New ADODB.Command
    With oTempCm
        .CommandText = "sp_SI_INTGetSurveyDates"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = oConn
    End With 'oTempCm
    
    'Get the info from the database
    Set oTempRS = oTempCm.Execute
    
    'Populate the collection
    moSurveys.Clear
    sSurveyID = ""
    Do Until oTempRS.EOF
        If sSurveyID <> oTempRS!Survey_id Then
            'Get the new survey ID
            sSurveyID = oTempRS!Survey_id
            
            'Add the survey to the collection
            Set oSurvey = moSurveys.Add(sClientName:="" & oTempRS!strClient_nm, _
                                        sSurveyName:="" & oTempRS!strSurvey_nm, _
                                        sSurveyID:=oTempRS!Survey_id)
        End If
        
        'Add this date to the collection
        oSurvey.Returns.Add dtDateReturned:=oTempRS!DateReturned, _
                            lQuantity:=oTempRS!QtySurveys
        
        'Prepare for the next pass
        oTempRS.MoveNext
    Loop
    
    'Close the recordset and database
    Set oSurvey = Nothing
    oTempRS.Close: Set oTempRS = Nothing
    Set oTempCm = Nothing
    CloseDBConnection oConn:=oConn
    
    'Sort the collection
    moSurveys.Sort
    
    'Populate the listview
    lSurveyCnt = 0
    With lvwMain.ListItems
        sSurveyID = -1
        For Each oSurvey In moSurveys
            For Each oReturn In oSurvey.Returns
                If sSurveyID <> oSurvey.SurveyID Then
                    sSurveyID = oSurvey.SurveyID
                    Set oItem = .Add(, oSurvey.Key & "-" & oReturn.Key, oSurvey.ClientName, , "Date")
                    oItem.SubItems(1) = oSurvey.SurveyName
                    oItem.SubItems(2) = oSurvey.SurveyID
                    oItem.SubItems(3) = oSurvey.Quantity
                Else
                    Set oItem = .Add(, oSurvey.Key & "-" & oReturn.Key, "")
                End If
                oItem.SubItems(4) = Format(oReturn.DateReturned, "mm/dd/yyyy")
                oItem.SubItems(5) = oReturn.Quantity
            Next oReturn
        Next oSurvey
    End With 'lvwMain.ListItems
    
    'Display the status
    sbrMain.Panels("Status").Text = moSurveys.Quantity & " Questionnaire(s) in " & moSurveys.Count & " Survey(s)"
    
    'Update the log file
    WriteLogEntry sRunType:="By Survey / Date", lQuestionnaires:=moSurveys.Quantity, lSurveys:=moSurveys.Count
    
    'Cleanup
    Set oReturn = Nothing
    Set oSurvey = Nothing
    
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuToolsBarcodeToLithoCode_Click()
    
    Dim sInputFile As String
    Dim sOutputFile As String
    Dim lInputHandle As Long
    Dim lOutputHandle As Long
    Dim sLithoCode As String
    Dim sBarCode As String
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the Barcode file (INPUT)
    With dlgMain
        .DialogTitle = "Barcode Input File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Deliverable File (*.dlv)|*.dlv|Undeliverable File (*.ndl)|*.ndl|Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 3
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sInputFile = .filename
    End With
    
    'Get the LithoCode file (OUTPUT)
    With dlgMain
        .DialogTitle = "LithoCode Output File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sOutputFile = .filename
    End With
    
    'Reset the error trap
    On Error GoTo 0
    
    'Open the files
    lInputHandle = FreeFile
    Open sInputFile For Input As #lInputHandle
    
    lOutputHandle = FreeFile
    Open sOutputFile For Output As #lOutputHandle
    
    'Loop through each line of the file
    While Not EOF(lInputHandle)
        'Read in a line
        Line Input #lInputHandle, sBarCode
        
        'Setup the required values
        sLithoCode = UnCrunch(sBarCode:=Left(sBarCode, 6))
        
        'Add this line to the output file
        Print #lOutputHandle, sLithoCode
    Wend
    
    'Close the files
    Close #lInputHandle
    Close #lOutputHandle

DLGErrorHandler:
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuToolsGetBarcodesFromSTR_Click()
    
    Dim sInputFile As String
    Dim sOutputFile As String
    Dim lInputHandle As Long
    Dim lOutputHandle As Long
    Dim sLine As String
    Dim sBarCode As String
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the STR file (INPUT)
    With dlgMain
        .DialogTitle = "STR Input File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Result File (*.str)|*.str|Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sInputFile = .filename
    End With
    
    'Get the Barcode file (OUTPUT)
    With dlgMain
        .DialogTitle = "Barcode Output File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Deliverable File (*.dlv)|*.dlv|Undeliverable File (*.ndl)|*.ndl|Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sOutputFile = .filename
    End With
    
    'Reset the error trap
    On Error GoTo 0
    
    'Open the files
    lInputHandle = FreeFile
    Open sInputFile For Input As #lInputHandle
    
    lOutputHandle = FreeFile
    Open sOutputFile For Output As #lOutputHandle
    
    'Loop through each line of the file
    While Not EOF(lInputHandle)
        'Read in a line
        Line Input #lInputHandle, sLine
        
        'Setup the required values
        sBarCode = Mid(sLine, 9, 6)
        
        'Add this line to the output file
        Print #lOutputHandle, sBarCode
    Wend
    
    'Close the files
    Close #lInputHandle
    Close #lOutputHandle
    
DLGErrorHandler:
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuToolsGetLithoCodesFromSTR_Click()
    
    Dim sInputFile As String
    Dim sOutputFile As String
    Dim lInputHandle As Long
    Dim lOutputHandle As Long
    Dim sLine As String
    Dim sLithoCode As String
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the STR file (INPUT)
    With dlgMain
        .DialogTitle = "STR Input File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Result File (*.str)|*.str|Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sInputFile = .filename
    End With
    
    'Get the LithoCode file (OUTPUT)
    With dlgMain
        .DialogTitle = "LithoCode Output File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sOutputFile = .filename
    End With
    
    'Reset the error trap
    On Error GoTo 0
    
    'Open the files
    lInputHandle = FreeFile
    Open sInputFile For Input As #lInputHandle
    
    lOutputHandle = FreeFile
    Open sOutputFile For Output As #lOutputHandle
    
    'Loop through each line of the file
    While Not EOF(lInputHandle)
        'Read in a line
        Line Input #lInputHandle, sLine
        
        'Setup the required values
        sLithoCode = UnCrunch(sBarCode:=Mid(sLine, 9, 6))
        
        'Add this line to the output file
        Print #lOutputHandle, sLithoCode
    Wend
    
    'Close the files
    Close #lInputHandle
    Close #lOutputHandle
    
DLGErrorHandler:
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub


Private Sub mnuToolsLithoCodeToBarcode_Click()
    
    Dim sInputFile As String
    Dim sOutputFile As String
    Dim lInputHandle As Long
    Dim lOutputHandle As Long
    Dim sLithoCode As String
    Dim sBarCode As String
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the LithoCode file (INPUT)
    With dlgMain
        .DialogTitle = "LithoCode Input File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sInputFile = .filename
    End With
    
    'Get the Barcode file (OUTPUT)
    With dlgMain
        .DialogTitle = "Barcode Output File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Deliverable File (*.dlv)|*.dlv|Undeliverable File (*.ndl)|*.ndl|Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sOutputFile = .filename
    End With
    
    'Reset the error trap
    On Error GoTo 0
    
    'Open the files
    lInputHandle = FreeFile
    Open sInputFile For Input As #lInputHandle
    
    lOutputHandle = FreeFile
    Open sOutputFile For Output As #lOutputHandle
    
    'Loop through each line of the file
    While Not EOF(lInputHandle)
        'Read in a line
        Line Input #lInputHandle, sLithoCode
        
        'Setup the required values
        sBarCode = Crunch(lLithoCode:=Val(sLithoCode))
        
        'Add this line to the output file
        Print #lOutputHandle, sBarCode
    Wend
    
    'Close the files
    Close #lInputHandle
    Close #lOutputHandle
    
DLGErrorHandler:
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub mnuToolsLithoCodeToDLVFile_Click()
    
    Dim sInputFile As String
    Dim sOutputFile As String
    Dim lInputHandle As Long
    Dim lOutputHandle As Long
    Dim sLithoCode As String
    Dim sBarCode As String
    Dim nQtyPages As Integer
    Dim nPageCnt As Integer
    Dim sTemp As String
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    LockForm = True
    DoEvents
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the LithoCode file (INPUT)
    With dlgMain
        .DialogTitle = "LithoCode Input File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sInputFile = .filename
    End With
    
    'Get the Barcode file (OUTPUT)
    With dlgMain
        .DialogTitle = "Barcode Output File"
        .CancelError = True
        .DefaultExt = ".txt"
        .Filter = "Deliverable File (*.dlv)|*.dlv|Undeliverable File (*.ndl)|*.ndl|Text File (*.txt)|*.txt|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = App.Path
        
        'Show the dialog
        .ShowOpen
        
        'Get the file name
        sOutputFile = .filename
    End With
    
    'Reset the error trap
    On Error GoTo 0
    
    'Get the quantity of pages per lithocode
    nQtyPages = 0
    Do Until nQtyPages > 0
        sTemp = InputBox("Enter the number of pages per lithocode", "LithoCode to DLV/NDL", "1")
        If Not IsNumeric(sTemp) Or Val(sTemp) <= 0 Then
            MsgBox "You must input a number of pages greater than 0!", vbCritical
        Else
            nQtyPages = Val(sTemp)
        End If
    Loop
    
    'Open the files
    lInputHandle = FreeFile
    Open sInputFile For Input As #lInputHandle
    
    lOutputHandle = FreeFile
    Open sOutputFile For Output As #lOutputHandle
    
    'Add the scan batch line to the file
    Print #lOutputHandle, "Manually Created Via Imported Not Transferred"
    
    'Loop through each line of the file
    While Not EOF(lInputHandle)
        'Read in a line
        Line Input #lInputHandle, sLithoCode
        
        'Setup the required values
        sTemp = Crunch(lLithoCode:=Val(sLithoCode))
        
        'Add the page number and check digit
        For nPageCnt = 1 To nQtyPages
            sBarCode = sTemp & nPageCnt
            sBarCode = sBarCode & GetCheckDigit(sBarCode:=sBarCode)
            
            'Add this line to the output file
            Print #lOutputHandle, sBarCode
        Next nPageCnt
    Wend
    
    'Close the files
    Close #lInputHandle
    Close #lOutputHandle
    
DLGErrorHandler:
    'Reset the mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub


Private Sub tbrMain_ButtonClick(ByVal oButton As ComctlLib.Button)
    
    Select Case oButton.Key
        Case "Count"
            mnuFileCount_Click
        Case "LithoCode"
            mnuFileLithocode_Click
        Case "SpecifyLitho"
            mnuFileSpecific_Click
        Case "Survey"
            mnuFileSurvey_Click
        Case "SurveyDate"
            mnuFileSurveydate_Click
        
        Case "History"
            mnuFileHistory_Click
        Case "Log"
            mnuFileLog_Click
        Case "CDFLog"
            mnuFileCDFLog_Click
        
        Case "Export"
            mnuFileExport_Click
        
        Case "Check"
            mnuEditCheck_Click
        Case "Uncheck"
            mnuEditUncheck_Click
        
        Case "Nondeliverable"
            mnuEditNondeliverable_Click
        Case "Reset"
            mnuEditReset_Click
    
    End Select
    
End Sub


