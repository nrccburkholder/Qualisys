VERSION 5.00
Object = "{C932BA88-4374-101B-A56C-00AA003668DC}#1.1#0"; "msmask32.ocx"
Begin VB.Form frmMailingDates 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Set Mailing Dates"
   ClientHeight    =   1350
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3135
   ControlBox      =   0   'False
   Icon            =   "frmMailingDates.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1350
   ScaleWidth      =   3135
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin MSMask.MaskEdBox txtMailDate 
      Height          =   315
      Left            =   1200
      TabIndex        =   0
      Top             =   120
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   556
      _Version        =   393216
      AutoTab         =   -1  'True
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Format          =   "mm-dd-yyyy"
      PromptChar      =   "_"
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   1800
      TabIndex        =   3
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   1215
   End
   Begin VB.Label lblDate 
      Caption         =   "Mail Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   975
   End
End
Attribute VB_Name = "frmMailingDates"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim cmd As ADODB.Command
Dim con As ADODB.Connection
Dim strDSN_Info As String

Private Sub cmdCancel_Click()
    txtMailDate.Text = ""
    Unload Me
End Sub

Private Sub cmdOk_Click()
    
    Dim Survey_id As Long
    Dim PostalBundle As String
    Dim PaperConfig As Long
    Dim Page_num As Long
    Dim strID As String
    Dim Counter As Integer
    Dim SelectedNode As ComctlLib.Node
    Dim NodeIndex As Integer
    Dim n As Integer
    Dim strTemp As String
    Dim NumberOfChildren As Integer
    Dim strPrinted As String
    Dim strBundled As String
    
    strDSN_Info = getConnection
        
    If Not IsDate(txtMailDate) Then
        MsgBox "You must type in a valid date!", vbOKOnly, "Invalid Date"
        Exit Sub
    End If
    
    If frmMain.tvTreeView.SelectedItem.Expanded = False Then
        'need to expand tree
        Set SelectedNode = frmMain.tvTreeView.SelectedItem
        If frmMain.tvTreeView.SelectedItem.Text <> "" Then
            frmMain.ButtonUsed = -1
            frmMain.ShowProperties SelectedNode
            SelectedNode.Selected = True
        End If
    End If
    If Trim(frmMain.tvTreeView.SelectedItem.Tag) <> "" Or frmMain.tvTreeView.SelectedItem.Children <> 0 Then
        Me.MousePointer = vbHourglass
        frmMain.MousePointer = vbHourglass
        NumberOfChildren = frmMain.tvTreeView.SelectedItem.Children
        If NumberOfChildren <> 0 Then
            n = frmMain.tvTreeView.SelectedItem.Child.index
            Counter = 0
            While n <> -1
                If Not frmMain.IsBundle(frmMain.tvTreeView.Nodes(n).image) Then
                    Counter = Counter + 1
                End If
                If n = frmMain.tvTreeView.Nodes(n).LastSibling.index Then
                    n = -1
                Else
                    n = frmMain.tvTreeView.Nodes(n).Next.index
                End If
            Wend
            If Counter > 0 And Counter <> NumberOfChildren Then
                If MsgBox("This will mail ALL bundles in '" + frmMain.tvTreeView.SelectedItem.Text + "'.  Do you want to proceed?", vbYesNo + vbQuestion, "Not all bundles were marked") <> vbYes Then
                    n = MsgBox("To just mail the marked bundles, right-click on one of the bundles and select 'Set Mailing Dates'.", vbOKOnly + vbInformation, "Help")
                    frmMain.MousePointer = vbDefault
                    Me.MousePointer = vbDefault
                    frmMain.tvTreeView.Refresh
                    txtMailDate.Text = ""
                    Unload Me
                    Exit Sub
                End If
            End If
            If frmMain.IsGroupedPrintConfiguration(frmMain.tvTreeView.SelectedItem.image) Then
                strID = frmMain.tvTreeView.SelectedItem.Key
                If Mid(strID, 1, 19) = "GroupedPrintConfig=" Then
                    strID = Mid(strID, 20)
                    PaperConfig = frmMain.NextValue(strID, vbTab)
                    strPrinted = frmMain.NextValue(strID, vbTab)
                    Set con = New ADODB.Connection
                    con.ConnectionTimeout = 0
                    con.Open strDSN_Info
                    con.CommandTimeout = 0
                    strTemp = "exec sp_Queue_SetNextMailing " & _
                              "@survey_id=" + str(Survey_id) & ", " & _
                              "@paperconfig_id=" + str(PaperConfig) & ", " & _
                              "@Mailingdate='" + txtMailDate.Text & "', " & _
                              "@Bundledate='" + strPrinted & "', " & _
                              "@PostalBundle='GP'"
                    con.Execute strTemp
                End If
            Else
                strID = frmMain.tvTreeView.SelectedItem.Tag
                Survey_id = frmMain.NextValue(strID, vbTab)
                PaperConfig = frmMain.NextValue(strID, vbTab)
                strBundled = frmMain.NextValue(strID, vbTab)
                Set con = New ADODB.Connection
                con.ConnectionTimeout = 0
                con.Open strDSN_Info
                con.CommandTimeout = 0
                strTemp = "exec sp_Queue_SetNextMailing " & _
                          "@survey_id=" + str(Survey_id) & ", " & _
                          "@paperconfig_id=" + str(PaperConfig) & ", " & _
                          "@Mailingdate='" + txtMailDate.Text & "', " & _
                          "@Bundledate='" + strBundled & "'"
                con.Execute strTemp
            End If
            con.Close
            Set con = Nothing
            n = frmMain.tvTreeView.SelectedItem.Child.index
            While n <> -1
                frmMain.tvTreeView.Nodes(n).image = frmMain.AlreadyMailed(frmMain.tvTreeView.Nodes(n).image)
                strID = frmMain.tvTreeView.Nodes(n).Tag
                If InStr(1, strID, "Not Mailed") > 0 Then
                    frmMain.tvTreeView.Nodes(n).Tag = Left(strID, InStr(1, strID, "Not Mailed") - 1) + txtMailDate.Text
                End If
                If n = frmMain.tvTreeView.Nodes(n).LastSibling.index Then
                    n = -1
                Else
                    n = frmMain.tvTreeView.Nodes(n).Next.index
                End If
            Wend
            frmMain.tvTreeView.Refresh
            frmMain.MousePointer = vbDefault
            Me.MousePointer = vbDefault
        Else
            n = frmMain.tvTreeView.SelectedItem.FirstSibling.index
            While n <> -1
                If frmMain.IsMailBundle(frmMain.tvTreeView.Nodes(n).image) Then
                    strID = frmMain.tvTreeView.Nodes(n).Tag
                    Survey_id = frmMain.NextValue(strID, vbTab)
                    PostalBundle = frmMain.NextValue(strID, vbTab)
                    PaperConfig = frmMain.NextValue(strID, vbTab)
                    Page_num = frmMain.NextValue(strID, vbTab)
                    strTemp = frmMain.NextValue(strID, vbTab)
                    strTemp = frmMain.NextValue(strID, vbTab)
                    strBundled = frmMain.NextValue(strID, vbTab)
                    Set cmd = New ADODB.Command
                    Set con = New ADODB.Connection
                    con.Open strDSN_Info
                    With cmd
                        .ActiveConnection = con
                        .CommandType = adCmdStoredProc
                        .CommandText = "sp_Queue_SetNextMailing"
                        .Parameters.Refresh
                        .Parameters("@survey_id").Value = Survey_id
                        .Parameters("@paperconfig_id").Value = PaperConfig
                        .Parameters("@Mailingdate").Value = txtMailDate.Text
                        .Parameters("@Bundledate").Value = strBundled
                        .Parameters("@postalbundle").Value = PostalBundle
'dbg                        .Execute
                    End With
                    con.Close
                    Set con = Nothing
                    Set cmd = Nothing
                    frmMain.tvTreeView.Nodes(n).image = frmMain.AlreadyMailed(frmMain.tvTreeView.Nodes(n).image)
                    strID = frmMain.tvTreeView.Nodes(n).Tag
                    If InStr(1, strID, "Not Mailed") > 0 Then
                        frmMain.tvTreeView.Nodes(n).Tag = Left(strID, InStr(1, strID, "Not Mailed") - 1) + txtMailDate.Text
                    End If
                    
                End If
                If n = frmMain.tvTreeView.Nodes(n).LastSibling.index Then
                    n = -1
                Else
                    n = frmMain.tvTreeView.Nodes(n).Next.index
                End If
            Wend
            frmMain.MousePointer = vbDefault
            Me.MousePointer = vbDefault
        End If
        frmMain.tvTreeView.Refresh
    Else
BadSelection:
        MsgBox "An error occurred.  Please refresh the tree.", vbOKOnly, "Error Message"
        'for some reason the "cmd.Parameters.Refresh" command raises a BOF/EOF error
        On Error GoTo 0
    End If
    Unload Me
End Sub

Private Sub Form_Activate()
    txtMailDate.SetFocus
End Sub

Private Sub Form_Load()
    txtMailDate.Text = Month(Now) & "-" & Day(Now) & "-" & Year(Now) & " " & Hour(Now) & ":00"
End Sub

Private Function getConnection() As String
    If strDSN_Info = "" Then
               
        Dim User_id As String
        Dim User_PWD As String
        Dim Server_nm As String
        Dim Database_nm As String
   
        User_id = "UID=" & GetRegValue(HKEY_LOCAL_MACHINE, "SOFTWARE\QualiSys\Connection", "DefaultUser") & ";"
        User_PWD = "PWD=" & GetRegValue(HKEY_LOCAL_MACHINE, "SOFTWARE\QualiSys\Connection", "DefaultPWD") & ";"
        Server_nm = "SERVER=" & GetRegValue(HKEY_LOCAL_MACHINE, "SOFTWARE\QualiSys\Connection", "Server") & ";"
        Database_nm = "DATABASE=" & GetRegValue(HKEY_LOCAL_MACHINE, "SOFTWARE\QualiSys\Connection", "Database")
    
        strDSN_Info = "driver={SQL Server};" & Server_nm & User_id & User_PWD & Database_nm
    
    End If
    getConnection = strDSN_Info
End Function
