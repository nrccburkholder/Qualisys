VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Object = "{0F987290-56EE-11D0-9C43-00A0C90F29FC}#1.0#0"; "ActBar.ocx"
Object = "{BC691F0A-3A98-11D1-9464-00AA006F7AF1}#5.0#0"; "GSEnhLV.ocx"
Object = "{95649FF3-431C-11D1-9464-00AA006F7AF1}#1.2#0"; "GSGrpBar.ocx"
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   Caption         =   "Comment Administration"
   ClientHeight    =   6210
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7770
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   6210
   ScaleWidth      =   7770
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog dlgMain 
      Left            =   3720
      Top             =   5520
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin Threed.SSPanel pnlMain 
      Height          =   5235
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   7755
      _Version        =   65536
      _ExtentX        =   13679
      _ExtentY        =   9234
      _StockProps     =   15
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Begin VB.PictureBox picSplitter 
         BackColor       =   &H00808080&
         BorderStyle     =   0  'None
         FillColor       =   &H00808080&
         Height          =   4800
         Left            =   7560
         ScaleHeight     =   2090.126
         ScaleMode       =   0  'User
         ScaleWidth      =   624
         TabIndex        =   7
         Top             =   300
         Visible         =   0   'False
         Width           =   60
      End
      Begin GSEnhListView.GSListView lvwMain 
         Height          =   4095
         Left            =   4200
         TabIndex        =   4
         Top             =   660
         Width           =   3195
         _ExtentX        =   5636
         _ExtentY        =   7223
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BorderStyle     =   0
         HideSelection   =   0   'False
         LabelEdit       =   1
         MouseIcon       =   "Main.frx":0000
         View            =   3
         FullRowSelect   =   -1  'True
         CheckBoxes      =   -1  'True
      End
      Begin ComctlLib.TreeView tvwMain 
         Height          =   4095
         Left            =   1800
         TabIndex        =   3
         Top             =   660
         Width           =   2295
         _ExtentX        =   4048
         _ExtentY        =   7223
         _Version        =   327682
         HideSelection   =   0   'False
         Indentation     =   529
         LabelEdit       =   1
         Style           =   7
         ImageList       =   "imlSmall"
         Appearance      =   1
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
      Begin VB.PictureBox picTitle 
         Appearance      =   0  'Flat
         BackColor       =   &H00808080&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   435
         Left            =   1800
         ScaleHeight     =   435
         ScaleWidth      =   5595
         TabIndex        =   2
         Top             =   120
         Width           =   5595
         Begin VB.Label lblTitle 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            BackStyle       =   0  'Transparent
            Caption         =   "Label1"
            BeginProperty Font 
               Name            =   "Tahoma"
               Size            =   12
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   315
            Left            =   60
            TabIndex        =   5
            Top             =   60
            Width           =   4995
         End
      End
      Begin GSGroupBarActiveX.GSGroupBar gbrMain 
         Height          =   4635
         Left            =   120
         TabIndex        =   1
         Top             =   120
         Width           =   1575
         _ExtentX        =   2778
         _ExtentY        =   8176
         BeginProperty GroupFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty IconFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin ComctlLib.StatusBar sbrMain 
         Height          =   300
         Left            =   120
         TabIndex        =   6
         Top             =   4800
         Width           =   7320
         _ExtentX        =   12912
         _ExtentY        =   529
         SimpleText      =   ""
         _Version        =   327682
         BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
            NumPanels       =   4
            BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
               AutoSize        =   1
               Object.Width           =   9763
               TextSave        =   ""
               Key             =   "Status"
               Object.Tag             =   ""
            EndProperty
            BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
               Alignment       =   1
               AutoSize        =   2
               Object.Width           =   979
               MinWidth        =   988
               Key             =   "ComputerName"
               Object.Tag             =   ""
            EndProperty
            BeginProperty Panel3 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
               Alignment       =   1
               AutoSize        =   2
               Object.Width           =   979
               MinWidth        =   988
               Key             =   "UserName"
               Object.Tag             =   ""
            EndProperty
            BeginProperty Panel4 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
               Alignment       =   1
               AutoSize        =   2
               Object.Width           =   1058
               MinWidth        =   1058
               Key             =   "Version"
               Object.Tag             =   ""
            EndProperty
         EndProperty
      End
      Begin VB.Image imgSplitter 
         Height          =   4095
         Index           =   1
         Left            =   4080
         MousePointer    =   9  'Size W E
         Top             =   660
         Width           =   120
      End
      Begin VB.Image imgSplitter 
         Height          =   4635
         Index           =   0
         Left            =   1680
         MousePointer    =   9  'Size W E
         Top             =   120
         Width           =   120
      End
   End
   Begin ComctlLib.ImageList imlLarge 
      Left            =   2640
      Top             =   5520
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   32
      ImageHeight     =   32
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   4
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":001C
            Key             =   "CodeSettings"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0336
            Key             =   "StartDates"
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0650
            Key             =   "SurveyCodeList"
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":096A
            Key             =   "SurveyBDUSList"
         EndProperty
      EndProperty
   End
   Begin ComctlLib.ImageList imlSmall 
      Left            =   1800
      Top             =   5520
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   17
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0C84
            Key             =   "CodeSettings"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0F9E
            Key             =   "StartDates"
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":12B8
            Key             =   "SurveyCodeList"
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":15D2
            Key             =   "SurveyBDUSList"
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":18EC
            Key             =   "HeaderAC"
         EndProperty
         BeginProperty ListImage6 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1C06
            Key             =   "HeaderAO"
         EndProperty
         BeginProperty ListImage7 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1F20
            Key             =   "HeaderRC"
         EndProperty
         BeginProperty ListImage8 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":223A
            Key             =   "HeaderRO"
         EndProperty
         BeginProperty ListImage9 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":2554
            Key             =   "SubHeaderAC"
         EndProperty
         BeginProperty ListImage10 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":286E
            Key             =   "SubHeaderAO"
         EndProperty
         BeginProperty ListImage11 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":2B88
            Key             =   "SubHeaderRC"
         EndProperty
         BeginProperty ListImage12 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":2EA2
            Key             =   "SubHeaderRO"
         EndProperty
         BeginProperty ListImage13 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":31BC
            Key             =   "CodeA"
         EndProperty
         BeginProperty ListImage14 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":34D6
            Key             =   "CodeR"
         EndProperty
         BeginProperty ListImage15 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":37F0
            Key             =   "Root"
         EndProperty
         BeginProperty ListImage16 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":3B0A
            Key             =   "MoveUp"
         EndProperty
         BeginProperty ListImage17 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":3E24
            Key             =   "MoveDown"
         EndProperty
      EndProperty
   End
   Begin ActiveBarLibraryCtl.ActiveBar abrMain 
      Left            =   780
      Top             =   5640
      _ExtentX        =   847
      _ExtentY        =   847
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Bands           =   "Main.frx":413E
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private moFormBase      As CFormBase98
    Private mbMoving        As Boolean
    Private meScreenMode    As eScreenModeConstants
    
    'Constants for form sizing
    Private Const mknMinWidth           As Integer = 7800
    Private Const mknMinHeight          As Integer = 5200
    Private Const mknEdgeDist           As Integer = 90
    Private Const mknControlSpacing     As Integer = 60
    Private Const mknMinWidthGroupBar   As Integer = 1275
    Private Const mknMinWidthTreeView   As Integer = 2000
    Private Const mknMinWidthListView   As Integer = 4000
    
    'Enum for the splitters
    Private Enum eSplitterTypeConstants
        eSTCVertSplit1 = 0
        eSTCVertSplit2 = 1
    End Enum
    
    'Enum for the screen mode
    Public Enum eScreenModeConstants
        eSMCModeUndefined = -1
        eSMCCodeSettings = 0
        eSMCStartDates = 1
        eSMCSurveyCodeList = 2
        eSMCSurveyBDUSList = 3
    End Enum
    
Private Sub AddCodingEntry()
    
    Dim bOKClicked      As Boolean
    Dim lHeaderID       As Long
    Dim lSubHeaderID    As Long
    Dim lCodeID         As Long
    Dim lDispositionID  As Long
    Dim dtModified      As Date
    Dim sSelKey         As String
    Dim sHeader         As String
    Dim sSubHeader      As String
    Dim sCode           As String
    Dim sDisposition    As String
    Dim sType           As String
    Dim eMode           As eAddEditModeConstants
    Dim oLocalAddEdit   As frmAddEdit
    Dim oNode           As ComctlLib.Node
    Dim oItem           As GSEnhListView.GSListItem
    
    'Determine what level is being added to
    sSelKey = tvwMain.SelectedItem.Key
    
    'Setup the variables for the appropriate level
    Select Case Left(sSelKey, 1)
        Case "R"    'Root node selected - Adding Header
            sHeader = ""
            lHeaderID = -1
            sSubHeader = ""
            lSubHeaderID = -1
            sCode = ""
            lCodeID = -1
            lDispositionID = -1
            eMode = eAEMAddHeader
            sType = "Header"
            
        Case "H"    'Header node selected - Adding SubHeader
            sHeader = tvwMain.SelectedItem.Text
            lHeaderID = Val(Mid(sSelKey, 3))
            sSubHeader = ""
            lSubHeaderID = -1
            sCode = ""
            lCodeID = -1
            lDispositionID = -1
            eMode = eAEMAddSubHeader
            sType = "SubHeader"
            
        Case "S"    'SubHeader node selected - Adding Code
            sHeader = tvwMain.SelectedItem.Parent.Text
            lHeaderID = Val(Mid(tvwMain.SelectedItem.Parent.Key, 3))
            sSubHeader = tvwMain.SelectedItem.Text
            lSubHeaderID = Val(Mid(sSelKey, 3))
            sCode = ""
            lCodeID = -1
            lDispositionID = -1
            eMode = eAEMAddCode
            sType = "Code"
            
    End Select
    
    'Load the form
    Set oLocalAddEdit = New frmAddEdit
    Load oLocalAddEdit
    
    'Populate and display the form
    With oLocalAddEdit
        'Set the properties
        .Header = sHeader
        .HeaderID = lHeaderID
        .SubHeader = sSubHeader
        .SubHeaderID = lSubHeaderID
        .Code = sCode
        .CodeID = lCodeID
        .DispositionID = lDispositionID
        .Mode = eMode
        
        'Display the form
        .Show vbModal
        
        'Deal with the result
        If .OKClicked Then
            sHeader = .Header
            lHeaderID = .HeaderID
            sSubHeader = .SubHeader
            lSubHeaderID = .SubHeaderID
            sCode = .Code
            lCodeID = .CodeID
            sDisposition = .Disposition
            lDispositionID = .DispositionID
            dtModified = .DateModified
        End If
        bOKClicked = .OKClicked
    End With
    
    'Close the form
    Unload oLocalAddEdit
    Set oLocalAddEdit = Nothing
    
    'Add the new node to the screen
    If bOKClicked Then
        Select Case eMode
            Case eAEMAddHeader
                'Add the treeview node for the Header
                Set oNode = tvwMain.Nodes.Add(sSelKey, tvwChild, "H-" & lHeaderID, sHeader, gksICONHeaderActiveClosed, gksICONHeaderActiveOpen)
                oNode.ExpandedImage = gksICONHeaderActiveOpen
                
                'Add the listview item for the Header
                Set oItem = lvwMain.ListItems.Add(, "H-" & lHeaderID, sHeader, , gksICONHeaderActiveClosed)
                oItem.SubItems(1) = goUserInfo.UserName
                oItem.SubItems(2) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
                
            Case eAEMAddSubHeader
                'Add the treeview node for the SubHeader
                Set oNode = tvwMain.Nodes.Add(sSelKey, tvwChild, "S-" & lSubHeaderID, sSubHeader, gksICONSubHeaderActiveClosed, gksICONSubHeaderActiveOpen)
                oNode.ExpandedImage = gksICONSubHeaderActiveOpen
                
                'Add the listview item for the SubHeader
                Set oItem = lvwMain.ListItems.Add(, "S-" & lSubHeaderID, sSubHeader, , gksICONSubHeaderActiveClosed)
                oItem.SubItems(1) = goUserInfo.UserName
                oItem.SubItems(2) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
            
            Case eAEMAddCode
                'Add the listview item for the Code
                Set oItem = lvwMain.ListItems.Add(, "C-" & lCodeID, sCode, , gksICONCodeActive)
                oItem.SubItems(1) = sDisposition
                oItem.SubItems(2) = goUserInfo.UserName
                oItem.SubItems(3) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
                oItem.Tag = lDispositionID
            
        End Select
    End If
    
    'Update the order
    UpdateOrder
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " " & sType & "(s)"
    
    'Cleanup
    Set oNode = Nothing
    Set oItem = Nothing
    
End Sub

Private Sub AddEntry()
    
    Select Case meScreenMode
        Case eScreenModeConstants.eSMCCodeSettings
            AddCodingEntry
            
        Case eScreenModeConstants.eSMCStartDates
            AddStartDateEntry
            
        Case eScreenModeConstants.eSMCSurveyCodeList
            AddSurveyCodeListEntry
            
        Case eScreenModeConstants.eSMCSurveyBDUSList
            AddSurveyBDUSListEntry
            
    End Select
    
End Sub

Private Sub AddSurveyCodeListEntry()
    
    Dim sKey            As String
    Dim oItem           As GSEnhListView.GSListItem
    Dim oLocalCodeList  As frmSurveyCodeList
    
    'Create the form
    Set oLocalCodeList = New frmSurveyCodeList
    Load oLocalCodeList
    
    'Display the form
    With oLocalCodeList
        'Set the required properties
        .Mode = eSCLAddMode
        
        'Display the form
        .Show vbModal
        
        'Get the result
        If .OKClicked Then
            'Add the new entry to the list view
            sKey = "CL" & .ClientID & "-ST" & .StudyID & "-SD" & .SurveyID
            Set oItem = lvwMain.ListItems.Add(, sKey, .Client, , gksICONSurveyCodeList)
            oItem.SubItems(1) = .ClientID
            oItem.SubItems(2) = .Study
            oItem.SubItems(3) = .StudyID
            oItem.SubItems(4) = .Survey
            oItem.SubItems(5) = .SurveyID
            oItem.SubItems(6) = .Header & " / " & .SubHeader
            oItem.SubItems(7) = Left(goUserInfo.UserName, 50)
            oItem.SubItems(8) = Format(.DateModified, "mm/dd/yyyy hh:nn:ss")
            oItem.Tag = "HD" & .HeaderID & "-SH" & .SubHeaderID
            
        End If
    End With
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Survey Code List(s)"
    
    'Cleanup
    Set oItem = Nothing
    Unload oLocalCodeList
    Set oLocalCodeList = Nothing
    
End Sub


Private Sub AddSurveyBDUSListEntry()
    
    Dim sKey            As String
    Dim oItem           As GSEnhListView.GSListItem
    Dim oLocalBDUSList  As frmSurveyBDUSList
    
    'Create the form
    Set oLocalBDUSList = New frmSurveyBDUSList
    Load oLocalBDUSList
    
    'Display the form
    With oLocalBDUSList
        'Set the required properties
        .Mode = eSBLAddMode
        
        'Display the form
        .Show vbModal
        
        'Get the result
        If .OKClicked Then
            'Add the new entry to the list view
            sKey = "CL" & .ClientID & "-ST" & .StudyID & "-SD" & .SurveyID & "-MF" & .MetaFieldID
            Set oItem = lvwMain.ListItems.Add(, sKey, .Client, , gksICONSurveyBDUSList)
            oItem.SubItems(1) = .ClientID
            oItem.SubItems(2) = .Study
            oItem.SubItems(3) = .StudyID
            oItem.SubItems(4) = .Survey
            oItem.SubItems(5) = .SurveyID
            oItem.SubItems(6) = .MetaField
            oItem.SubItems(7) = .MetaFieldID
            oItem.SubItems(8) = .Order
            oItem.SubItems(9) = .ValidValues
            oItem.SubItems(10) = IIf(.Required, "Yes", "No")
            'oItem.Tag = "HD" & .HeaderID & "-SH" & .SubHeaderID
            
        End If
    End With
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Survey MetaField Mapping(s)"
    
    'Cleanup
    Set oItem = Nothing
    Unload oLocalBDUSList
    Set oLocalBDUSList = Nothing
    
End Sub

Private Sub AddStartDateEntry()
    
    Dim sKey            As String
    Dim oItem           As GSEnhListView.GSListItem
    Dim oLocalStartDate As frmStartDates
    
    'Create the form
    Set oLocalStartDate = New frmStartDates
    Load oLocalStartDate
    
    'Display the form
    With oLocalStartDate
        'Set the required properties
        .Mode = eSDMAddMode
        
        'Display the form
        .Show vbModal
        
        'Get the result
        If .OKClicked Then
            'Add the new entry to the list view
            sKey = "CL" & .ClientID & "-ST" & .StudyID & "-SD" & .SurveyID
            Set oItem = lvwMain.ListItems.Add(, sKey, .Client, , gksICONStartDates)
            oItem.SubItems(1) = .ClientID
            oItem.SubItems(2) = .Study
            oItem.SubItems(3) = .StudyID
            oItem.SubItems(4) = .Survey
            oItem.SubItems(5) = .SurveyID
            oItem.SubItems(6) = Left(goUserInfo.UserName, 50)
            oItem.SubItems(7) = Format(.DateModified, "mm/dd/yyyy hh:nn:ss")
            
        End If
    End With
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Skip Survey(s)"
    
    'Cleanup
    Set oItem = Nothing
    Unload oLocalStartDate
    Set oLocalStartDate = Nothing
    
End Sub


Private Sub DeleteEntry()
    
    Select Case meScreenMode
        Case eScreenModeConstants.eSMCCodeSettings
        
        Case eScreenModeConstants.eSMCStartDates
            DeleteStartDateEntry
            
        Case eScreenModeConstants.eSMCSurveyCodeList
            DeleteSurveyCodeListEntry
            
        Case eScreenModeConstants.eSMCSurveyBDUSList
            DeleteSurveyBDUSListEntry
            
    End Select
    
End Sub

Private Sub DeleteSurveyCodeListEntry()
    
    Dim sSql        As String
    Dim sMsg        As String
    Dim sKey        As String
    Dim lClientID   As Long
    Dim lStudyID    As Long
    Dim lSurveyID   As Long
    Dim nLoc1       As Integer
    Dim nLoc2       As Integer
    Dim oItem       As GSEnhListView.GSListItem
    
    'Get a reference to the Item being deleted
    Set oItem = lvwMain.SelectedItem
    sKey = oItem.Key
    
    'Get the required IDs
    nLoc1 = InStr(sKey, "-")
    lClientID = Val(Mid(sKey, 3, nLoc1 - 3))
    
    nLoc1 = nLoc1 + 3
    nLoc2 = InStr(nLoc1, sKey, "-")
    lStudyID = Val(Mid(sKey, nLoc1, nLoc2 - nLoc1))
    
    lSurveyID = Val(Mid(sKey, nLoc2 + 3))
    
    'Determine if the user really wants to do this
    sMsg = "You have chosen to delete the following Survey" & vbCrLf & _
           "Code List setting from the database:" & vbCrLf & vbCrLf & _
           "Client: " & oItem.Text & vbCrLf & _
           "Study: " & oItem.SubItems(1) & vbCrLf & _
           "Survey: " & oItem.SubItems(2) & vbCrLf & _
           "Code List: " & oItem.SubItems(3) & vbCrLf & vbCrLf & _
           "Do you wish to proceed?"
    If MsgBox(sMsg, vbDefaultButton2 + vbQuestion + vbYesNo, "Delete Survey Code List Entry") = vbYes Then
        'Delete the record from the database
        sSql = "DELETE FROM CommentSurveyCodeList WHERE Survey_id = " & lSurveyID
        goConn.Execute (sSql)
        
        'Remove the record from the screen
        lvwMain.ListItems.Remove sKey
    End If
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Survey Code List(s)"
    
    'Cleanup
    Set oItem = Nothing
    
End Sub


Private Sub DeleteSurveyBDUSListEntry()
    
    Dim sSql        As String
    Dim sMsg        As String
    Dim sKey        As String
    Dim lClientID   As Long
    Dim lStudyID    As Long
    Dim lSurveyID   As Long
    Dim lFieldID    As Long
    Dim nLoc1       As Integer
    Dim nLoc2       As Integer
    Dim oItem       As GSEnhListView.GSListItem
    
    'Get a reference to the Item being deleted
    Set oItem = lvwMain.SelectedItem
    sKey = oItem.Key
    
    'Get the required IDs
    nLoc1 = InStr(sKey, "-")
    lClientID = Val(Mid(sKey, 3, nLoc1 - 3))
    
    nLoc1 = nLoc1 + 3
    nLoc2 = InStr(nLoc1, sKey, "-")
    lStudyID = Val(Mid(sKey, nLoc1, nLoc2 - nLoc1))
    
    nLoc1 = nLoc2 + 3
    nLoc2 = InStr(nLoc1, sKey, "-")
    lSurveyID = Val(Mid(sKey, nLoc1, nLoc2 - nLoc1))
    
    lFieldID = Val(Mid(sKey, nLoc2 + 3))
    
    'Determine if the user really wants to do this
    sMsg = "You have chosen to delete the following Survey" & vbCrLf & _
           "MetaField Mapping from the database:" & vbCrLf & vbCrLf & _
           "Client: " & oItem.Text & vbCrLf & _
           "Study: " & oItem.SubItems(2) & vbCrLf & _
           "Survey: " & oItem.SubItems(4) & vbCrLf & _
           "MetaField: " & oItem.SubItems(6) & vbCrLf & vbCrLf & _
           "Do you wish to proceed?"
    If MsgBox(sMsg, vbDefaultButton2 + vbQuestion + vbYesNo, "Delete Survey MetaField Mapping") = vbYes Then
        'Delete the record from the database
        sSql = "DELETE FROM BDUS_MetaFieldLookup " & _
               "WHERE Survey_id = " & lSurveyID & " " & _
               "  AND Field_id = " & lFieldID
        goConn.Execute (sSql)
        
        'Remove the record from the screen
        lvwMain.ListItems.Remove sKey
    End If
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Survey MetaField Mapping(s)"
    
    'Cleanup
    Set oItem = Nothing
    
End Sub

Private Sub DeleteStartDateEntry()
    
    Dim sSql        As String
    Dim sMsg        As String
    Dim sKey        As String
    Dim lClientID   As Long
    Dim lStudyID    As Long
    Dim lSurveyID   As Long
    Dim nLoc1       As Integer
    Dim nLoc2       As Integer
    Dim oItem       As GSEnhListView.GSListItem
    
    'Get a reference to the Item being deleted
    Set oItem = lvwMain.SelectedItem
    sKey = oItem.Key
    
    'Get the required IDs
    nLoc1 = InStr(sKey, "-")
    lClientID = Val(Mid(sKey, 3, nLoc1 - 3))
    
    nLoc1 = nLoc1 + 3
    nLoc2 = InStr(nLoc1, sKey, "-")
    lStudyID = Val(Mid(sKey, nLoc1, nLoc2 - nLoc1))
    
    lSurveyID = Val(Mid(sKey, nLoc2 + 3))
    
    'Determine if the user really wants to do this
    sMsg = "You have chosen to delete the following Skip Survey" & vbCrLf & _
           "setting from the database:" & vbCrLf & vbCrLf & _
           "Client: " & oItem.Text & vbCrLf & _
           "Study: " & oItem.SubItems(1) & vbCrLf & _
           "Survey: " & oItem.SubItems(2) & vbCrLf & vbCrLf & _
           "Do you wish to proceed?"
    If MsgBox(sMsg, vbDefaultButton2 + vbQuestion + vbYesNo, "Delete Skip Survey Entry") = vbYes Then
        'Delete the record from the database
        sSql = "DELETE FROM CommentSkipSurveys WHERE Survey_id = " & lSurveyID
        goConn.Execute (sSql)
        
        'Remove the record from the screen
        lvwMain.ListItems.Remove sKey
    End If
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Skip Survey(s)"
    
    'Cleanup
    Set oItem = Nothing
    
End Sub

Private Sub EditCodingEntry()
    
    Dim bOKClicked      As Boolean
    Dim lHeaderID       As Long
    Dim lSubHeaderID    As Long
    Dim lCodeID         As Long
    Dim lDispositionID  As Long
    Dim dtModified      As Date
    Dim sSelKey         As String
    Dim sHeader         As String
    Dim sSubHeader      As String
    Dim sCode           As String
    Dim sDisposition    As String
    Dim eMode           As eAddEditModeConstants
    Dim oLocalAddEdit   As frmAddEdit
    Dim oItem           As GSEnhListView.GSListItem
    
    'Get a reference to the Item being edited
    Set oItem = lvwMain.SelectedItem
    sSelKey = oItem.Key
    
    'Setup the variables for the appropriate level
    Select Case Left(sSelKey, 1)
        Case "H"    'Edit Header
            sHeader = oItem.Text
            lHeaderID = Val(Mid(sSelKey, 3))
            sSubHeader = ""
            lSubHeaderID = -1
            sCode = ""
            lCodeID = -1
            lDispositionID = -1
            eMode = eAEMEditHeader
            
        Case "S"    'Edit SubHeader
            sHeader = tvwMain.SelectedItem.Text
            lHeaderID = Val(Mid(tvwMain.SelectedItem.Key, 3))
            sSubHeader = oItem.Text
            lSubHeaderID = Val(Mid(sSelKey, 3))
            sCode = ""
            lCodeID = -1
            lDispositionID = -1
            eMode = eAEMEditSubHeader
            
        Case "C"    'Edit Code
            sHeader = tvwMain.SelectedItem.Parent.Text
            lHeaderID = Val(Mid(tvwMain.SelectedItem.Parent.Key, 3))
            sSubHeader = tvwMain.SelectedItem.Text
            lSubHeaderID = Val(Mid(tvwMain.SelectedItem.Key, 3))
            sCode = oItem.Text
            lCodeID = Val(Mid(sSelKey, 3))
            lDispositionID = oItem.Tag
            eMode = eAEMEditCode
            
    End Select
    
    'Load the form
    Set oLocalAddEdit = New frmAddEdit
    Load oLocalAddEdit
    
    'Populate and display the form
    With oLocalAddEdit
        'Set the properties
        .Header = sHeader
        .HeaderID = lHeaderID
        .SubHeader = sSubHeader
        .SubHeaderID = lSubHeaderID
        .Code = sCode
        .CodeID = lCodeID
        .DispositionID = lDispositionID
        .Mode = eMode
        
        'Display the form
        .Show vbModal
        
        'Deal with the result
        If .OKClicked Then
            sHeader = .Header
            lHeaderID = .HeaderID
            sSubHeader = .SubHeader
            lSubHeaderID = .SubHeaderID
            sCode = .Code
            lCodeID = .CodeID
            sDisposition = .Disposition
            lDispositionID = .DispositionID
            dtModified = .DateModified
        End If
        bOKClicked = .OKClicked
    End With
    
    'Close the form
    Unload oLocalAddEdit
    Set oLocalAddEdit = Nothing
    
    'Update the item on the screen
    If bOKClicked Then
        Select Case eMode
            Case eAEMEditHeader
                'Update the treeview node for the Header
                tvwMain.Nodes(sSelKey).Text = sHeader
                
                'Update the listview item for the Header
                oItem.Text = sHeader
                oItem.SubItems(1) = goUserInfo.UserName
                oItem.SubItems(2) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
                
            Case eAEMEditSubHeader
                'Update the treeview node for the SubHeader
                tvwMain.Nodes(sSelKey).Text = sSubHeader
                
                'Update the listview item for the SubHeader
                oItem.Text = sSubHeader
                oItem.SubItems(1) = goUserInfo.UserName
                oItem.SubItems(2) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
                
            Case eAEMEditCode
                'Update the listview item for the Code
                oItem.Text = sCode
                oItem.SubItems(1) = sDisposition
                oItem.SubItems(2) = goUserInfo.UserName
                oItem.SubItems(3) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
                oItem.Tag = lDispositionID
                
        End Select
    End If
    
    'Cleanup
    Set oItem = Nothing
    
End Sub


Private Sub EditEntry()
    
    Select Case meScreenMode
        Case eScreenModeConstants.eSMCCodeSettings
            EditCodingEntry
            
        Case eScreenModeConstants.eSMCStartDates
            EditStartDateEntry
            
        Case eScreenModeConstants.eSMCSurveyCodeList
            EditSurveyCodeListEntry
            
        Case eScreenModeConstants.eSMCSurveyBDUSList
            EditSurveyBDUSListEntry
            
    End Select
    
End Sub

Private Sub EditSurveyCodeListEntry()
    
    Dim sKey            As String
    Dim sTag            As String
    Dim lClientID       As Long
    Dim lStudyID        As Long
    Dim lSurveyID       As Long
    Dim lHeaderID       As Long
    Dim lSubHeaderID    As Long
    Dim nLoc1           As Integer
    Dim nLoc2           As Integer
    Dim oItem           As GSEnhListView.GSListItem
    Dim oLocalCodeList  As frmSurveyCodeList
    
    'Get a reference to the Item being edited
    Set oItem = lvwMain.SelectedItem
    sKey = oItem.Key
    sTag = oItem.Tag
    
    'Get the required IDs
    nLoc1 = InStr(sKey, "-")
    lClientID = Val(Mid(sKey, 3, nLoc1 - 3))
    
    nLoc1 = nLoc1 + 3
    nLoc2 = InStr(nLoc1, sKey, "-")
    lStudyID = Val(Mid(sKey, nLoc1, nLoc2 - nLoc1))
    
    lSurveyID = Val(Mid(sKey, nLoc2 + 3))
    
    nLoc1 = InStr(sTag, "-")
    lHeaderID = Val(Mid(sTag, 3, nLoc1 - 3))
    
    lSubHeaderID = Val(Mid(sTag, nLoc1 + 3))
    
    'Create the form
    Set oLocalCodeList = New frmSurveyCodeList
    Load oLocalCodeList
    
    'Display the form
    With oLocalCodeList
        'Set the required properties
        .ClientID = lClientID
        .StudyID = lStudyID
        .SurveyID = lSurveyID
        .HeaderID = lHeaderID
        .SubHeaderID = lSubHeaderID
        .Mode = eSCLEditMode
        
        'Display the form
        .Show vbModal
        
        'Get the result
        If .OKClicked Then
            'Update the entry in the list view
            oItem.SubItems(6) = .Header & " / " & .SubHeader
            oItem.SubItems(7) = Left(goUserInfo.UserName, 50)
            oItem.SubItems(8) = Format(.DateModified, "mm/dd/yyyy hh:nn:ss")
            oItem.Tag = "HD" & .HeaderID & "-SH" & .SubHeaderID
            
        End If
    End With
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Survey Code List(s)"
    
    'Cleanup
    Set oItem = Nothing
    Unload oLocalCodeList
    Set oLocalCodeList = Nothing
    
End Sub

Private Sub EditSurveyBDUSListEntry()
    
    Dim sKey            As String
    Dim lClientID       As Long
    Dim lStudyID        As Long
    Dim lSurveyID       As Long
    Dim lFieldID        As Long
    Dim nLoc1           As Integer
    Dim nLoc2           As Integer
    Dim oItem           As GSEnhListView.GSListItem
    Dim oLocalBDUSList  As frmSurveyBDUSList
    
    'Get a reference to the Item being edited
    Set oItem = lvwMain.SelectedItem
    sKey = oItem.Key
    
    'Get the required IDs
    nLoc1 = InStr(sKey, "-")
    lClientID = Val(Mid(sKey, 3, nLoc1 - 3))
    
    nLoc1 = nLoc1 + 3
    nLoc2 = InStr(nLoc1, sKey, "-")
    lStudyID = Val(Mid(sKey, nLoc1, nLoc2 - nLoc1))
    
    nLoc1 = nLoc2 + 3
    nLoc2 = InStr(nLoc1, sKey, "-")
    lSurveyID = Val(Mid(sKey, nLoc1, nLoc2 - nLoc1))
    
    lFieldID = Val(Mid(sKey, nLoc2 + 3))
    
    'Create the form
    Set oLocalBDUSList = New frmSurveyBDUSList
    Load oLocalBDUSList
    
    'Display the form
    With oLocalBDUSList
        'Set the required properties
        .ClientID = lClientID
        .StudyID = lStudyID
        .SurveyID = lSurveyID
        .MetaFieldID = lFieldID
        .Order = oItem.SubItems(8)
        .ValidValues = oItem.SubItems(9)
        .Required = IIf(oItem.SubItems(10) = "Yes", True, False)
        .Mode = eSBLEditMode
        
        'Display the form
        .Show vbModal
        
        'Get the result
        If .OKClicked Then
            'Update the entry in the list view
            oItem.SubItems(8) = .Order
            oItem.SubItems(9) = .ValidValues
            oItem.SubItems(10) = IIf(.Required, "Yes", "No")
        End If
    End With
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Survey MetaField Mapping(s)"
    
    'Cleanup
    Set oItem = Nothing
    Unload oLocalBDUSList
    Set oLocalBDUSList = Nothing
    
End Sub

Private Sub EditStartDateEntry()
    
    Dim sKey            As String
    Dim lClientID       As Long
    Dim lStudyID        As Long
    Dim lSurveyID       As Long
    Dim nLoc1           As Integer
    Dim nLoc2           As Integer
    Dim oItem           As GSEnhListView.GSListItem
    Dim oLocalStartDate As frmStartDates
    
    'Get a reference to the Item being edited
    Set oItem = lvwMain.SelectedItem
    sKey = oItem.Key
    
    'Get the required IDs
    nLoc1 = InStr(sKey, "-")
    lClientID = Val(Mid(sKey, 3, nLoc1 - 3))
    
    nLoc1 = nLoc1 + 3
    nLoc2 = InStr(nLoc1, sKey, "-")
    lStudyID = Val(Mid(sKey, nLoc1, nLoc2 - nLoc1))
    
    lSurveyID = Val(Mid(sKey, nLoc2 + 3))
    
    'Create the form
    Set oLocalStartDate = New frmStartDates
    Load oLocalStartDate
    
    'Display the form
    With oLocalStartDate
        'Set the required properties
        .ClientID = lClientID
        .StudyID = lStudyID
        .SurveyID = lSurveyID
        .Mode = eSDMEditMode
        
        'Display the form
        .Show vbModal
        
        'Get the result
        If .OKClicked Then
            'Update the entry in the list view
            oItem.SubItems(6) = Left(goUserInfo.UserName, 50)
            oItem.SubItems(7) = Format(.DateModified, "mm/dd/yyyy hh:nn:ss")
            
        End If
    End With
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lvwMain.ListItems.Count & " Skip Survey(s)"
    
    'Cleanup
    Set oItem = Nothing
    Unload oLocalStartDate
    Set oLocalStartDate = Nothing
    
End Sub

Private Sub MoveEntry(ByVal bMoveUp As Boolean)
    
    Dim oItem As GSListItem
    Dim nNewIndex As Integer
    Dim nOldIndex As Integer
    Dim aoItems() As MyItem
    Dim oMyItem As MyItem
    Dim nCnt As Integer
    Dim sSql As String
    
    'If we are not in code mode then we are out of here
    If meScreenMode <> eSMCCodeSettings Then Exit Sub
    
    'If no entry is selected we are out of here
    If lvwMain.SelectedItem Is Nothing Then Exit Sub
    
    'Get the location of the selected item in the list
    nOldIndex = lvwMain.SelectedItem.Index
    
    'Check to see if we can move this item
    If nOldIndex = 1 And bMoveUp Then
        'This is already at the top and cannot be moved
        Exit Sub
    ElseIf nOldIndex = lvwMain.ListItems.Count And Not bMoveUp Then
        'This item is already at the bottom and cannot be moved
        Exit Sub
    End If
    
    'Adjust the location
    If bMoveUp Then
        'We are going to move this item up one in the list
        nNewIndex = nOldIndex - 1
    Else
        'We are going to move this item down one in the list
        nNewIndex = nOldIndex + 1
    End If
    
    'Move the items into the array
    nCnt = 0
    ReDim aoItems(lvwMain.ListItems.Count) As MyItem
    For Each oItem In lvwMain.ListItems
        nCnt = nCnt + 1
        With oItem
            aoItems(nCnt).sKey = .Key
            aoItems(nCnt).sText = .Text
            aoItems(nCnt).sSmallIcon = .SmallIcon
            aoItems(nCnt).sSubItem1 = .SubItems(1)
            aoItems(nCnt).sSubItem2 = .SubItems(2)
        End With
    Next oItem
    
    'Get the item in the new location
    oMyItem.sKey = aoItems(nNewIndex).sKey
    oMyItem.sText = aoItems(nNewIndex).sText
    oMyItem.sSmallIcon = aoItems(nNewIndex).sSmallIcon
    oMyItem.sSubItem1 = aoItems(nNewIndex).sSubItem1
    oMyItem.sSubItem2 = aoItems(nNewIndex).sSubItem2
    
    'Move the item in the old location to the new location
    aoItems(nNewIndex).sKey = aoItems(nOldIndex).sKey
    aoItems(nNewIndex).sText = aoItems(nOldIndex).sText
    aoItems(nNewIndex).sSmallIcon = aoItems(nOldIndex).sSmallIcon
    aoItems(nNewIndex).sSubItem1 = aoItems(nOldIndex).sSubItem1
    aoItems(nNewIndex).sSubItem2 = aoItems(nOldIndex).sSubItem2
    
    'Move the item that was in the new location to the old location
    aoItems(nOldIndex).sKey = oMyItem.sKey
    aoItems(nOldIndex).sText = oMyItem.sText
    aoItems(nOldIndex).sSmallIcon = oMyItem.sSmallIcon
    aoItems(nOldIndex).sSubItem1 = oMyItem.sSubItem1
    aoItems(nOldIndex).sSubItem2 = oMyItem.sSubItem2
    
    'Clear the listview
    lvwMain.ListItems.Clear
    
    'Insert the items into the listview in the new order
    For nCnt = 1 To UBound(aoItems)
        'Add this item to the list view
        Set oItem = lvwMain.ListItems.Add(, aoItems(nCnt).sKey, aoItems(nCnt).sText, , aoItems(nCnt).sSmallIcon)
        oItem.SubItems(1) = aoItems(nCnt).sSubItem1
        oItem.SubItems(2) = aoItems(nCnt).sSubItem2
        
        'If this is the item we moved select it
        If nCnt = nNewIndex Then oItem.Selected = True
    Next nCnt
    
    'Update the order in the database
    UpdateOrder nIndex1:=nNewIndex, nIndex2:=nOldIndex
    
End Sub

Private Sub PopCodeListView(oNode As ComctlLib.Node)
    
    Dim sSql        As String
    Dim sMsg        As String
    Dim sType       As String
    Dim sIDPrefix   As String
    Dim sICONActive As String
    Dim sICONRetire As String
    Dim lRecCnt     As Long
    Dim oTempRs     As ADODB.Recordset
    Dim oItem       As GSEnhListView.GSListItem
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    
    'Clear the listview
    With lvwMain
        .ListItems.Clear
        .ColumnHeaders.Clear
        
        .CheckBoxes = False
        Set .SmallIcons = imlSmall
    End With
    
    'Determine what we are going to populate into the listview
    Select Case Left(oNode.Key, 1)
        Case "R"    'Root node selected, pop with headers
            sType = "Header"
            sIDPrefix = "H-"
            sICONActive = gksICONHeaderActiveClosed
            sICONRetire = gksICONHeaderRetireClosed
            sSql = "SELECT CmntHeader_id AS My_ID, strCmntHeader_Nm AS strText, bitRetired, strModifiedBy, datModified " & _
                   "FROM CommentHeaders " & _
                   "ORDER BY intOrder"
            
        Case "H"    'Header node selected, pop with subheaders
            sType = "SubHeader"
            sIDPrefix = "S-"
            sICONActive = gksICONSubHeaderActiveClosed
            sICONRetire = gksICONSubHeaderRetireClosed
            sSql = "SELECT CmntSubHeader_id AS My_ID, strCmntSubHeader_Nm AS strText, bitRetired, strModifiedBy, datModified " & _
                   "FROM CommentSubHeaders " & _
                   "WHERE CmntHeader_id = " & Mid(oNode.Key, 3) & " " & _
                   "ORDER BY intOrder"
            
        Case "S"    'SubHeader node selected, pop with codes
            sType = "Code"
            sIDPrefix = "C-"
            sICONActive = gksICONCodeActive
            sICONRetire = gksICONCodeRetire
            sSql = "SELECT CmntCode_id AS My_ID, strCmntCode_Nm AS strText, bitRetired, strModifiedBy, datModified, IsNull(cc.Disposition_id, -1) As Disposition_id, IsNull(strReportLabel, '<none>') as strReportLabel " & _
                   "FROM CommentCodes cc LEFT JOIN Disposition dp ON cc.Disposition_id = dp.Disposition_id " & _
                   "WHERE CmntSubHeader_id = " & Mid(oNode.Key, 3) & " " & _
                   "ORDER BY intOrder"
            
    End Select
    
    'Set the status bar
    sbrMain.Panels("Status").Text = "Getting the " & sType & " settings..."
    
    'Populate the columnheaders collection
    With lvwMain
        .ColumnHeaders.Add , , sType, 2880, gslvColumnLeft, gslvAsText
        If sType = "Code" Then
            .ColumnHeaders.Add , , "Disposition", 2160, gslvColumnLeft, gslvAsText
        End If
        .ColumnHeaders.Add , , "Modified By", 1440, gslvColumnLeft, gslvAsText
        .ColumnHeaders.Add , , "Date Modified", 1800, gslvColumnLeft, gslvAsDate
    End With
    
    'Open the recordset
    Set oTempRs = goConn.Execute(sSql)
    
    'Populate the listview
    lRecCnt = 0
    With oTempRs
        Do Until .EOF
            'Add this entry to the listview
            lRecCnt = lRecCnt + 1
            Set oItem = lvwMain.ListItems.Add(, sIDPrefix & !My_ID, "" & !strText, , _
                                              IIf(!bitRetired, sICONRetire, sICONActive))
            If sType = "Code" Then
                oItem.SubItems(1) = "" & !strReportLabel
                oItem.SubItems(2) = "" & !strModifiedBy
                oItem.SubItems(3) = IIf(IsNull(!datModified), "", Format(!datModified, "mm/dd/yyyy hh:nn:ss"))
                oItem.Tag = !Disposition_id
            Else
                oItem.SubItems(1) = "" & !strModifiedBy
                oItem.SubItems(2) = IIf(IsNull(!datModified), "", Format(!datModified, "mm/dd/yyyy hh:nn:ss"))
            End If
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With 'oTempRs
    
    'Cleanup
    oTempRs.Close
    Set oTempRs = Nothing
    Set oItem = Nothing
    
    'Select the first item
    If lvwMain.ListItems.Count > 0 Then
        lvwMain.ListItems(1).Selected = True
    End If
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lRecCnt & " " & sType & "(s)"
    Screen.MousePointer = vbNormal
    
Exit Sub


ErrorHandler:
    If Not (oTempRs Is Nothing) Then oTempRs.Close
    Set oTempRs = Nothing
    
    sbrMain.Panels("Status").Text = "Error encountered"
    Screen.MousePointer = vbNormal
    
    sMsg = "The following error was encountered while populating the list of codes!" & vbCrLf & vbCrLf & _
           "Error#: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & Err.Description
    MsgBox sMsg, vbCritical
    Exit Sub
    
End Sub


Private Sub RetireCodingEntry()
    
    Dim nRetire         As Integer
    Dim dtModified      As Date
    Dim sMsg            As String
    Dim sSql            As String
    Dim sSelKey         As String
    Dim sNormalImage    As String
    Dim sSelectedImage  As String
    Dim sExpandedImage  As String
    Dim oItem           As GSEnhListView.GSListItem
    Dim oTempRs         As ADODB.Recordset
    
    'Get a reference to the Item being retired
    Set oItem = lvwMain.SelectedItem
    sSelKey = oItem.Key
    
    'Setup the variables for the appropriate level
    Select Case Left(sSelKey, 1)
        Case "H"    'Retire Header
            'Determine if we are retiring or unretiring
            If oItem.SmallIcon = gksICONHeaderActiveClosed Then
                nRetire = 1
                sNormalImage = gksICONHeaderRetireClosed
                sSelectedImage = gksICONHeaderRetireOpen
                sExpandedImage = gksICONHeaderRetireOpen
            Else
                nRetire = 0
                sNormalImage = gksICONHeaderActiveClosed
                sSelectedImage = gksICONHeaderActiveOpen
                sExpandedImage = gksICONHeaderActiveOpen
            End If
            
            'Update the database
            sSql = "UPDATE CommentHeaders " & _
                   "SET bitRetired = " & nRetire & ", " & _
                   "    strModifiedBy = '" & Left(goUserInfo.UserName, 50) & "', " & _
                   "    datModified = GetDate() " & _
                   "WHERE CmntHeader_id = " & Val(Mid(sSelKey, 3))
            goConn.Execute (sSql)
            
            'Get the date for the modified record
            sSql = "SELECT datModified " & _
                   "FROM CommentHeaders " & _
                   "WHERE CmntHeader_id = " & Val(Mid(sSelKey, 3))
            Set oTempRs = goConn.Execute(sSql)
            dtModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
            
            'Update the treeview node for the Header
            With tvwMain.Nodes(sSelKey)
                .Image = sNormalImage
                .SelectedImage = sSelectedImage
                .ExpandedImage = sExpandedImage
            End With
            
            'Update the listview item for the Header
            With oItem
                .SmallIcon = sNormalImage
                .SubItems(1) = goUserInfo.UserName
                .SubItems(2) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
            End With
            
        Case "S"    'Retire SubHeader
            'Determine if we are retiring or unretiring
            If oItem.SmallIcon = gksICONSubHeaderActiveClosed Then
                nRetire = 1
                sNormalImage = gksICONSubHeaderRetireClosed
                sSelectedImage = gksICONSubHeaderRetireOpen
                sExpandedImage = gksICONSubHeaderRetireOpen
            Else
                nRetire = 0
                sNormalImage = gksICONSubHeaderActiveClosed
                sSelectedImage = gksICONSubHeaderActiveOpen
                sExpandedImage = gksICONSubHeaderActiveOpen
            End If
            
            'Update the database
            sSql = "UPDATE CommentSubHeaders " & _
                   "SET bitRetired = " & nRetire & ", " & _
                   "    strModifiedBy = '" & Left(goUserInfo.UserName, 50) & "', " & _
                   "    datModified = GetDate() " & _
                   "WHERE CmntSubHeader_id = " & Val(Mid(sSelKey, 3))
            goConn.Execute (sSql)
            
            'Get the date for the modified record
            sSql = "SELECT datModified " & _
                   "FROM CommentSubHeaders " & _
                   "WHERE CmntSubHeader_id = " & Val(Mid(sSelKey, 3))
            Set oTempRs = goConn.Execute(sSql)
            dtModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
            
            'Update the treeview node for the SubHeader
            With tvwMain.Nodes(sSelKey)
                .Image = sNormalImage
                .SelectedImage = sSelectedImage
                .ExpandedImage = sExpandedImage
            End With
            
            'Update the listview item for the SubHeader
            With oItem
                .SmallIcon = sNormalImage
                .SubItems(1) = goUserInfo.UserName
                .SubItems(2) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
            End With
            
        Case "C"    'Retire Code
            'Determine if we are retiring or unretiring
            If oItem.SmallIcon = gksICONCodeActive Then
                nRetire = 1
                sNormalImage = gksICONCodeRetire
            Else
                nRetire = 0
                sNormalImage = gksICONCodeActive
            End If
            'Update the database
            sSql = "UPDATE CommentCodes " & _
                   "SET bitRetired = " & nRetire & ", " & _
                   "    strModifiedBy = '" & Left(goUserInfo.UserName, 50) & "', " & _
                   "    datModified = GetDate() " & _
                   "WHERE CmntCode_id = " & Val(Mid(sSelKey, 3))
            goConn.Execute (sSql)
            
            'Get the date for the modified record
            sSql = "SELECT datModified " & _
                   "FROM CommentCodes " & _
                   "WHERE CmntCode_id = " & Val(Mid(sSelKey, 3))
            Set oTempRs = goConn.Execute(sSql)
            dtModified = IIf(IsNull(oTempRs!datModified), 0, oTempRs!datModified)
            oTempRs.Close: Set oTempRs = Nothing
            
            'Update the listview item for the Code
            With oItem
                .SmallIcon = sNormalImage
                .SubItems(2) = goUserInfo.UserName
                .SubItems(3) = Format(dtModified, "mm/dd/yyyy hh:nn:ss")
            End With
            
    End Select
    
    'Cleanup
    Set oItem = Nothing
    
End Sub

Private Sub RetireEntry()
    
    Select Case meScreenMode
        Case eScreenModeConstants.eSMCCodeSettings
            RetireCodingEntry
            
        Case eScreenModeConstants.eSMCStartDates
        
        Case eScreenModeConstants.eSMCSurveyCodeList
        
        Case eScreenModeConstants.eSMCSurveyBDUSList
        
    End Select
    
End Sub

Private Sub SetScreenMode(ByVal eScreenMode As eScreenModeConstants)
    
    'Save the mode
    meScreenMode = eScreenMode
    
    'Clear the checked status of all of the menu options
    With abrMain.Tools
        .Item("mnuFileCodeSettings").Checked = False
        .Item("mnuFileStartDates").Checked = False
        .Item("mnuFileSurveyCodeList").Checked = False
        .Item("mnuFileSurveyBDUSList").Checked = False
    End With
    
    'Setup the screen for the new mode
    Select Case eScreenMode
        Case eScreenModeConstants.eSMCCodeSettings
            tvwMain.Visible = True
            With abrMain.Tools
                .Item("mnuFileCodeSettings").Checked = True
                .Item("mnuEditAdd").Enabled = True
                .Item("mnuEditEdit").Enabled = True
                .Item("mnuEditRetire").Enabled = True
                .Item("mnuEditDelete").Enabled = False
                .Item("mnuEditCreate").Enabled = True
            End With
            lblTitle.Caption = "Header, SubHeader, and Code Settings"
            SetupCodeSettings
            
        Case eScreenModeConstants.eSMCStartDates
            tvwMain.Visible = False
            With abrMain.Tools
                .Item("mnuFileStartDates").Checked = True
                .Item("mnuEditAdd").Enabled = True
                .Item("mnuEditEdit").Enabled = True
                .Item("mnuEditRetire").Enabled = False
                .Item("mnuEditDelete").Enabled = True
                .Item("mnuEditCreate").Enabled = False
            End With
            lblTitle.Caption = "Skip Surveys"
            SetupStartDates
            
        Case eScreenModeConstants.eSMCSurveyCodeList
            tvwMain.Visible = False
            With abrMain.Tools
                .Item("mnuFileSurveyCodeList").Checked = True
                .Item("mnuEditAdd").Enabled = True
                .Item("mnuEditEdit").Enabled = True
                .Item("mnuEditRetire").Enabled = False
                .Item("mnuEditDelete").Enabled = True
                .Item("mnuEditCreate").Enabled = False
            End With
            lblTitle.Caption = "Survey Code List Settings"
            SetupSurveyCodeList
            
        Case eScreenModeConstants.eSMCSurveyBDUSList
            tvwMain.Visible = False
            With abrMain.Tools
                .Item("mnuFileSurveyBDUSList").Checked = True
                .Item("mnuEditAdd").Enabled = True
                .Item("mnuEditEdit").Enabled = True
                .Item("mnuEditRetire").Enabled = False
                .Item("mnuEditDelete").Enabled = True
                .Item("mnuEditCreate").Enabled = False
            End With
            lblTitle.Caption = "Survey MetaField Mappings"
            SetupSurveyBDUSList
            
    End Select
    
    'Resize Controls
    ResizeControls
    
End Sub

Private Sub SetupCodeSettings()
    
    Dim sMsg            As String
    Dim sSql            As String
    Dim lCurHeaderID    As Long
    Dim oTempRs         As ADODB.Recordset
    Dim oRootNode       As ComctlLib.Node
    Dim oHeaderNode     As ComctlLib.Node
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Set the status bar
    Screen.MousePointer = vbHourglass
    sbrMain.Panels("Status").Text = "Getting the Header, SubHeader, and Code settings..."
    
    'Clear the listview
    With lvwMain
        .ListItems.Clear
        .ColumnHeaders.Clear
        .SortType = gslvNoSort
        
        .CheckBoxes = False
    End With
    
    'Clear the tree view
    With tvwMain
        .Nodes.Clear
    End With
    
    'Get the stuff to load the treeview
    sSql = "SELECT ch.CmntHeader_id, ch.strCmntHeader_Nm, ch.bitRetired AS bitHeaderRetired, " & _
           "       cs.CmntSubHeader_id, cs.strCmntSubHeader_Nm, cs.bitRetired AS bitSubHeaderRetired " & _
           "FROM CommentHeaders ch, CommentSubHeaders cs " & _
           "WHERE ch.CmntHeader_id = cs.CmntHeader_id " & _
           "ORDER BY ch.intOrder, cs.intOrder"
    Set oTempRs = goConn.Execute(sSql)
    
    'Add the root node
    Set oRootNode = tvwMain.Nodes.Add(, , "Root", "Comment Codes", gksICONTreeViewRoot)
    
    'Populate the treeview
    lCurHeaderID = -1
    With oTempRs
        Do Until .EOF
            'Check to see if we have added the header node
            If !CmntHeader_id <> lCurHeaderID Then
                'Add this header
                lCurHeaderID = !CmntHeader_id
                Set oHeaderNode = Nothing
                Set oHeaderNode = tvwMain.Nodes.Add("Root", tvwChild, "H-" & !CmntHeader_id, "" & !strCmntHeader_Nm, _
                                                    IIf(!bitHeaderRetired, gksICONHeaderRetireClosed, gksICONHeaderActiveClosed), _
                                                    IIf(!bitHeaderRetired, gksICONHeaderRetireOpen, gksICONHeaderActiveOpen))
                oHeaderNode.ExpandedImage = IIf(!bitHeaderRetired, gksICONHeaderRetireOpen, gksICONHeaderActiveOpen)
            End If
            
            'Add this sub header
            tvwMain.Nodes.Add oHeaderNode.Key, tvwChild, "S-" & !CmntSubHeader_id, "" & !strCmntSubHeader_Nm, _
                              IIf(!bitSubHeaderRetired, gksICONSubHeaderRetireClosed, gksICONSubHeaderActiveClosed), _
                              IIf(!bitHeaderRetired, gksICONSubHeaderRetireOpen, gksICONSubHeaderActiveOpen)
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With 'oTempRs
    
    'Update the status
    sbrMain.Panels("Status").Text = ""
    
    'Select the root node
    With oRootNode
        .Selected = True
        .Expanded = True
    End With
    PopCodeListView oNode:=oRootNode
    
    'Cleanup
    oTempRs.Close
    Set oTempRs = Nothing
    Set oRootNode = Nothing
    Set oHeaderNode = Nothing
    
    'Set the mousepointer
    Screen.MousePointer = vbNormal
    
Exit Sub


ErrorHandler:
    If Not (oTempRs Is Nothing) Then oTempRs.Close
    Set oTempRs = Nothing
    
    sbrMain.Panels("Status").Text = "Error encountered"
    Screen.MousePointer = vbNormal
    
    sMsg = "The following error was encountered while populating the list of codes!" & vbCrLf & vbCrLf & _
           "Error#: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & Err.Description
    MsgBox sMsg, vbCritical
    Exit Sub
    
End Sub



Private Sub SetupSurveyCodeList()
    
    Dim sSql        As String
    Dim sMsg        As String
    Dim sKey        As String
    Dim lRecCnt     As Long
    Dim oTempRs     As ADODB.Recordset
    Dim oItem       As GSEnhListView.GSListItem
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Set the status bar
    Screen.MousePointer = vbHourglass
    sbrMain.Panels("Status").Text = "Getting Survey Code List settings..."
    
    'Clear the listview
    With lvwMain
        .ListItems.Clear
        .ColumnHeaders.Clear
        .SortType = gslvOnColumnClick

        .CheckBoxes = False
    End With
    
    'Clear the tree view
    With tvwMain
        .Nodes.Clear
    End With
    
    'Populate the columnheaders collection
    With lvwMain.ColumnHeaders
        .Add , , "Client", 2160, gslvColumnLeft, gslvAsText
        .Add , , "ClientID", 800, gslvColumnRight, gslvAsNumber
        .Add , , "Study", 1080, gslvColumnLeft, gslvAsText
        .Add , , "StudyID", 800, gslvColumnRight, gslvAsNumber
        .Add , , "Survey", 1080, gslvColumnLeft, gslvAsText
        .Add , , "SurveyID", 860, gslvColumnRight, gslvAsNumber
        .Add , , "Code List", 2880, gslvColumnLeft, gslvAsText
        .Add , , "Modified By", 1440, gslvColumnLeft, gslvAsText
        .Add , , "Date Modified", 1800, gslvColumnLeft, gslvAsDate
    End With
    
    'Get the stuff to load the ListView
    sSql = "SELECT cl.Client_id, cl.strClient_Nm, cl.Study_id, cl.strStudy_Nm, " & _
           "       cl.Survey_id, cl.strQSurvey_Nm AS strSurvey_Nm, " & _
           "       ch.CmntHeader_id, ch.strCmntHeader_Nm, " & _
           "       cs.CmntSubHeader_id, cs.strCmntSubHeader_Nm, " & _
           "       sc.strModifiedBy , sc.datModified " & _
           "FROM " & GetConnServerName(goDMConn) & ".QP_Comments.dbo.ClientStudySurvey cl, CommentSurveyCodeList sc, " & _
           "     CommentHeaders ch, CommentSubHeaders cs " & _
           "WHERE cl.Survey_id = sc.Survey_id " & _
           "  AND sc.CmntSubHeader_id = cs.CmntSubHeader_id " & _
           "  AND cs.CmntHeader_id = ch.CmntHeader_id " & _
           "ORDER BY cl.strClient_Nm, cl.strStudy_Nm, cl.strQSurvey_Nm"
    Set oTempRs = goConn.Execute(sSql)
    
    'Populate the listview
    lRecCnt = 0
    With oTempRs
        Do Until .EOF
            'Add this entry to the listview
            lRecCnt = lRecCnt + 1
            sKey = "CL" & !Client_id & "-ST" & !Study_id & "-SD" & !Survey_id
            Set oItem = lvwMain.ListItems.Add(, sKey, "" & Trim(!strClient_Nm), , gksICONSurveyCodeList)
            oItem.SubItems(1) = CStr(!Client_id)
            oItem.SubItems(2) = "" & Trim(!strStudy_Nm)
            oItem.SubItems(3) = CStr(!Study_id)
            oItem.SubItems(4) = "" & Trim(!strSurvey_Nm)
            oItem.SubItems(5) = CStr(!Survey_id)
            oItem.SubItems(6) = "" & Trim(!strCmntHeader_Nm) & " / " & Trim(!strCmntSubHeader_Nm)
            oItem.SubItems(7) = "" & !strModifiedBy
            oItem.SubItems(8) = IIf(IsNull(!datModified), "", Format(!datModified, "mm/dd/yyyy hh:nn:ss"))
            oItem.Tag = "HD" & !CmntHeader_id & "-SH" & !CmntSubHeader_id
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With 'oTempRs
    
    'Cleanup
    oTempRs.Close
    Set oTempRs = Nothing
    Set oItem = Nothing
    
    'Select the first item
    If lvwMain.ListItems.Count > 0 Then
        lvwMain.ListItems(1).Selected = True
    End If
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lRecCnt & " Survey Code List(s)"
    Screen.MousePointer = vbNormal
    
Exit Sub


ErrorHandler:
    If Not (oTempRs Is Nothing) Then oTempRs.Close
    Set oTempRs = Nothing
    
    sbrMain.Panels("Status").Text = "Error encountered"
    Screen.MousePointer = vbNormal
    
    sMsg = "The following error was encountered while populating the list of Survey Code Lists!" & vbCrLf & vbCrLf & _
           "Error#: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & Err.Description
    MsgBox sMsg, vbCritical
    Exit Sub
    
End Sub


Private Sub SetupSurveyBDUSList()
    
    Dim sSql        As String
    Dim sMsg        As String
    Dim sKey        As String
    Dim sDMServer   As String
    Dim lRecCnt     As Long
    Dim oTempRs     As ADODB.Recordset
    Dim oItem       As GSEnhListView.GSListItem
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Set the status bar
    Screen.MousePointer = vbHourglass
    sbrMain.Panels("Status").Text = "Getting Survey MetaField Mappings..."
    
    'Clear the listview
    With lvwMain
        .ListItems.Clear
        .ColumnHeaders.Clear
        .SortType = gslvOnColumnClick

        .CheckBoxes = False
    End With
    
    'Clear the tree view
    With tvwMain
        .Nodes.Clear
    End With
    
    'Populate the columnheaders collection
    With lvwMain.ColumnHeaders
        .Add , , "Client", 2160, gslvColumnLeft, gslvAsText
        .Add , , "ClientID", 800, gslvColumnRight, gslvAsNumber
        .Add , , "Study", 1200, gslvColumnLeft, gslvAsText
        .Add , , "StudyID", 800, gslvColumnRight, gslvAsNumber
        .Add , , "Survey", 1200, gslvColumnLeft, gslvAsText
        .Add , , "SurveyID", 860, gslvColumnRight, gslvAsNumber
        .Add , , "Field", 2640, gslvColumnLeft, gslvAsText
        .Add , , "FieldID", 860, gslvColumnRight, gslvAsNumber
        .Add , , "Order", 600, gslvColumnRight, gslvAsNumber
        .Add , , "Valid Values", 1880, gslvColumnLeft, gslvAsText
        .Add , , "Required", 860, gslvColumnCenter, gslvAsText
    End With
    
    'Get the stuff to load the ListView
    sDMServer = GetConnServerName(goDMConn) & ".QP_Comments.dbo."
    sSql = "SELECT cl.Client_id, cl.strClient_Nm, cl.Study_id, cl.strStudy_Nm, " & _
           "       cl.Survey_id, cl.strQSurvey_Nm AS strSurvey_Nm, " & _
           "       mt.strTable_Nm + '.' + mf.strField_Nm AS strField_Nm, " & _
           "       mf.Field_id , bd.intOrder, bd.strValidValues, bd.bitRequired " & _
           "FROM BDUS_MetaFieldLookup bd, " & sDMServer & "ClientStudySurvey cl, " & _
           "     " & sDMServer & "MetaField mf, " & sDMServer & "MetaTable mt, " & _
           "     " & sDMServer & "MetaStructure ms " & _
           "WHERE cl.Survey_id = bd.Survey_id " & _
           "  AND cl.Study_id = ms.Study_id " & _
           "  AND ms.Field_id = bd.Field_id " & _
           "  AND ms.Field_id = mf.Field_id " & _
           "  AND ms.Table_id = mt.Table_id " & _
           "ORDER BY cl.strClient_Nm, cl.strStudy_Nm, cl.strQSurvey_Nm, bd.intOrder"
    Set oTempRs = goConn.Execute(sSql)
    
    'Populate the listview
    lRecCnt = 0
    With oTempRs
        Do Until .EOF
            'Add this entry to the listview
            lRecCnt = lRecCnt + 1
            sKey = "CL" & !Client_id & "-ST" & !Study_id & "-SD" & !Survey_id & "-MF" & !Field_id
            Set oItem = lvwMain.ListItems.Add(, sKey, "" & Trim(!strClient_Nm), , gksICONSurveyBDUSList)
            oItem.SubItems(1) = CStr(!Client_id)
            oItem.SubItems(2) = "" & Trim(!strStudy_Nm)
            oItem.SubItems(3) = CStr(!Study_id)
            oItem.SubItems(4) = "" & Trim(!strSurvey_Nm)
            oItem.SubItems(5) = CStr(!Survey_id)
            oItem.SubItems(6) = "" & Trim(!strField_Nm)
            oItem.SubItems(7) = CStr(!Field_id)
            oItem.SubItems(8) = CStr(!intOrder)
            oItem.SubItems(9) = "" & !strValidValues
            oItem.SubItems(10) = IIf(!bitRequired, "Yes", "No")
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With 'oTempRs
    
    'Cleanup
    oTempRs.Close
    Set oTempRs = Nothing
    Set oItem = Nothing
    
    'Select the first item
    If lvwMain.ListItems.Count > 0 Then
        lvwMain.ListItems(1).Selected = True
    End If
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lRecCnt & " Survey MetaField Mapping(s)"
    Screen.MousePointer = vbNormal
    
Exit Sub


ErrorHandler:
    If Not (oTempRs Is Nothing) Then oTempRs.Close
    Set oTempRs = Nothing
    
    sbrMain.Panels("Status").Text = "Error encountered"
    Screen.MousePointer = vbNormal
    
    sMsg = "The following error was encountered while populating the list of Survey MetaField Mappings!" & vbCrLf & vbCrLf & _
           "Error#: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & Err.Description
    MsgBox sMsg, vbCritical
    Exit Sub
    
End Sub



Private Sub SetupStartDates()
    
    Dim sSql        As String
    Dim sMsg        As String
    Dim sKey        As String
    Dim lRecCnt     As Long
    Dim oTempRs     As ADODB.Recordset
    Dim oItem       As GSEnhListView.GSListItem
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Set the status bar
    Screen.MousePointer = vbHourglass
    sbrMain.Panels("Status").Text = "Getting the Skip Survey settings..."
    
    'Clear the listview
    With lvwMain
        .ListItems.Clear
        .ColumnHeaders.Clear
        .SortType = gslvOnColumnClick

        .CheckBoxes = False
    End With
    
    'Clear the tree view
    With tvwMain
        .Nodes.Clear
    End With
    
    'Populate the columnheaders collection
    With lvwMain.ColumnHeaders
        .Add , , "Client", 2160, gslvColumnLeft, gslvAsText
        .Add , , "ClientID", 800, gslvColumnRight, gslvAsNumber
        .Add , , "Study", 1080, gslvColumnLeft, gslvAsText
        .Add , , "StudyID", 800, gslvColumnRight, gslvAsNumber
        .Add , , "Survey", 1080, gslvColumnLeft, gslvAsText
        .Add , , "SurveyID", 860, gslvColumnRight, gslvAsNumber
        .Add , , "Modified By", 1440, gslvColumnLeft, gslvAsText
        .Add , , "Date Modified", 1800, gslvColumnLeft, gslvAsDate
    End With
    
    'Get the stuff to load the ListView
    sSql = "SELECT cl.Client_id, cl.strClient_Nm, cl.Study_id, cl.strStudy_Nm, " & _
           "       cl.Survey_id , cl.strQSurvey_Nm AS strSurvey_Nm, cs.strModifiedBy, cs.datModified " & _
           "FROM " & GetConnServerName(goDMConn) & ".QP_Comments.dbo.ClientStudySurvey cl, CommentSkipSurveys cs " & _
           "WHERE cl.Survey_id = cs.Survey_id " & _
           "ORDER BY cl.strClient_Nm, cl.strStudy_Nm, cl.strSurvey_Nm"
    Set oTempRs = goConn.Execute(sSql)

    'Populate the listview
    lRecCnt = 0
    With oTempRs
        Do Until .EOF
            'Add this entry to the listview
            lRecCnt = lRecCnt + 1
            sKey = "CL" & !Client_id & "-ST" & !Study_id & "-SD" & !Survey_id
            Set oItem = lvwMain.ListItems.Add(, sKey, "" & Trim(!strClient_Nm), , gksICONStartDates)
            oItem.SubItems(1) = CStr(!Client_id)
            oItem.SubItems(2) = "" & Trim(!strStudy_Nm)
            oItem.SubItems(3) = CStr(!Study_id)
            oItem.SubItems(4) = "" & Trim(!strSurvey_Nm)
            oItem.SubItems(5) = CStr(!Survey_id)
            oItem.SubItems(6) = "" & !strModifiedBy
            oItem.SubItems(7) = IIf(IsNull(!datModified), "", Format(!datModified, "mm/dd/yyyy hh:nn:ss"))
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With 'oTempRs
    
    'Cleanup
    oTempRs.Close
    Set oTempRs = Nothing
    Set oItem = Nothing
    
    'Select the first item
    If lvwMain.ListItems.Count > 0 Then
        lvwMain.ListItems(1).Selected = True
    End If
    
    'Update the status
    sbrMain.Panels("Status").Text = "" & lRecCnt & " Skip Survey(s)"
    Screen.MousePointer = vbNormal
    
Exit Sub


ErrorHandler:
    If Not (oTempRs Is Nothing) Then oTempRs.Close
    Set oTempRs = Nothing
    
    sbrMain.Panels("Status").Text = "Error encountered"
    Screen.MousePointer = vbNormal
    
    sMsg = "The following error was encountered while populating the list of Skip Surveys!" & vbCrLf & vbCrLf & _
           "Error#: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & Err.Description
    MsgBox sMsg, vbCritical
    Exit Sub
    
End Sub

Public Sub UpdateOrder(Optional ByVal nIndex1 As Integer = -1, Optional ByVal nIndex2 As Integer = -1)
    
    Dim oHeader1Cm      As ADODB.Command
    Dim oHeader2Cm      As ADODB.Command
    Dim oSubHeader1Cm   As ADODB.Command
    Dim oSubHeader2Cm   As ADODB.Command
    Dim oCode1Cm        As ADODB.Command
    Dim oCode2Cm        As ADODB.Command
    Dim oCommand1       As ADODB.Command
    Dim oCommand2       As ADODB.Command
    Dim sSql            As String
    Dim oItem           As GSListItem
    Dim nCnt            As Integer
    
    'Setup the Header update command object with date and user
    sSql = "UPDATE CommentHeaders " & _
           "SET intOrder = ?, " & _
           "    datModified = GetDate(), " & _
           "    strModifiedBy = ? " & _
           "WHERE CmntHeader_id = ?"
    Set oHeader1Cm = New ADODB.Command
    With oHeader1Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("intOrder", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("strModifiedBy", adVarChar, adParamInput, 50)
        .Parameters.Append .CreateParameter("RecordID", adInteger, adParamInput)
        .Prepared = True
    End With 'oHeader1Cm
    
    'Setup the Header update command object without date and user
    sSql = "UPDATE CommentHeaders " & _
           "SET intOrder = ? " & _
           "WHERE CmntHeader_id = ?"
    Set oHeader2Cm = New ADODB.Command
    With oHeader2Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("intOrder", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("RecordID", adInteger, adParamInput)
        .Prepared = True
    End With 'oHeader2Cm
    
    'Setup the SubHeader update command object with date and user
    sSql = "UPDATE CommentSubHeaders " & _
           "SET intOrder = ?, " & _
           "    datModified = GetDate(), " & _
           "    strModifiedBy = ? " & _
           "WHERE CmntSubHeader_id = ?"
    Set oSubHeader1Cm = New ADODB.Command
    With oSubHeader1Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("intOrder", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("strModifiedBy", adVarChar, adParamInput, 50)
        .Parameters.Append .CreateParameter("RecordID", adInteger, adParamInput)
        .Prepared = True
    End With 'oSubHeader1Cm
    
    'Setup the SubHeader update command object without date and user
    sSql = "UPDATE CommentSubHeaders " & _
           "SET intOrder = ? " & _
           "WHERE CmntSubHeader_id = ?"
    Set oSubHeader2Cm = New ADODB.Command
    With oSubHeader2Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("intOrder", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("RecordID", adInteger, adParamInput)
        .Prepared = True
    End With 'oSubHeader2Cm
    
    'Setup the Code update command object with date and user
    sSql = "UPDATE CommentCodes " & _
           "SET intOrder = ?, " & _
           "    datModified = GetDate(), " & _
           "    strModifiedBy = ? " & _
           "WHERE CmntCode_id = ?"
    Set oCode1Cm = New ADODB.Command
    With oCode1Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("intOrder", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("strModifiedBy", adVarChar, adParamInput, 50)
        .Parameters.Append .CreateParameter("RecordID", adInteger, adParamInput)
        .Prepared = True
    End With 'oCode1Cm
    
    'Setup the Code update command object without date and user
    sSql = "UPDATE CommentCodes " & _
           "SET intOrder = ? " & _
           "WHERE CmntCode_id = ?"
    Set oCode2Cm = New ADODB.Command
    With oCode2Cm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("intOrder", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("RecordID", adInteger, adParamInput)
        .Prepared = True
    End With 'oCode2Cm
    
    'Determine which command we are using
    Select Case Left(lvwMain.ListItems(1).Key, 1)
        Case "H"    'Header
            Set oCommand1 = oHeader1Cm
            Set oCommand2 = oHeader2Cm
        
        Case "S"    'SubHeader
            Set oCommand1 = oSubHeader1Cm
            Set oCommand2 = oSubHeader2Cm
            
        Case "C"    'Code
            Set oCommand1 = oCode1Cm
            Set oCommand2 = oCode2Cm
            
    End Select
    
    'Update the orders
    nCnt = 0
    For Each oItem In lvwMain.ListItems
        'Increment the order counter
        nCnt = nCnt + 1
        
        If nCnt = nIndex1 Or nCnt = nIndex2 Then
            'Update the record
            oCommand1.Parameters("intOrder") = nCnt
            oCommand1.Parameters("strModifiedBy") = goUserInfo.UserName
            oCommand1.Parameters("RecordID") = Val(Mid(oItem.Key, 3))
            oCommand1.Execute
            
            'Update the list item
            oItem.SubItems(1) = goUserInfo.UserName
            oItem.SubItems(2) = Format(Now, "mm/dd/yyyy hh:nn:ss")
        Else
            'Update the record
            oCommand2.Parameters("intOrder") = nCnt
            oCommand2.Parameters("RecordID") = Val(Mid(oItem.Key, 3))
            oCommand2.Execute
        End If
    Next oItem
    
End Sub



Private Sub abrMain_Click(ByVal oTool As ActiveBarLibraryCtl.Tool)
    
    Select Case oTool.Name
        'File menu
        Case "mnuFileCodeSettings"
            SetScreenMode eScreenMode:=eSMCCodeSettings
        
        Case "mnuFileStartDates"
            SetScreenMode eScreenMode:=eSMCStartDates
        
        Case "mnuFileSurveyCodeList"
            SetScreenMode eScreenMode:=eSMCSurveyCodeList
        
        Case "mnuFileSurveyBDUSList"
            SetScreenMode eScreenMode:=eSMCSurveyBDUSList
        
        Case "mnuFileExit"
            Unload Me
        
        'View menu
        Case "mnuViewGroupbar"
            oTool.Checked = Not oTool.Checked
            gbrMain.Visible = oTool.Checked
            imgSplitter(eSTCVertSplit1).Visible = oTool.Checked
            ResizeControls
            
        Case "mnuViewStatusbar"
            oTool.Checked = Not oTool.Checked
            sbrMain.Visible = oTool.Checked
            ResizeControls
        
        'Edit Menu
        Case "mnuEditAdd"
            AddEntry
            
        Case "mnuEditEdit"
            EditEntry
            
        Case "mnuEditRetire"
            RetireEntry
            
        Case "mnuEditDelete"
            DeleteEntry
            
'        Case "mnuEditCreate"
'            CreateFAQSSCodeFile
            
        Case "mnuEditMoveUp"
            MoveEntry bMoveUp:=True
            
        Case "mnuEditMoveDown"
            MoveEntry bMoveUp:=False
            
'        Case "mnuEditHCMGLookups"
'            RefreshHCMGLookups
            
    End Select
    
End Sub


Private Sub Form_KeyDown(nKeyCode As Integer, nShift As Integer)
    
    Dim bHandled As Boolean
    
    'Pass the keystroke to the active bar control to see if it is a shortcut
    bHandled = abrMain.OnKeyDown(KeyCode:=nKeyCode, Shift:=nShift)
    
    'If the active bar control handled the keystroke then kill it
    If bHandled Then
        nKeyCode = 0
        nShift = 0
    End If
    
End Sub

Private Sub SaveSplitters(ByVal lHKey As RegDBServer98.gsrsHKEYConstantsEnum, _
                          ByVal sSection As String)
    
    Dim nCnt        As Integer
    Dim oRegTemp    As RegDBServer98.RegRect
    
    On Error GoTo ErrorHandler
    
    For nCnt = imgSplitter.LBound To imgSplitter.ubound
        'Get a registry object
        Set oRegTemp = New RegDBServer98.RegRect
        oRegTemp.Register sSection:=sSection, _
                          sKey:=Me.Name & " Splitter " & nCnt, _
                          lHKey:=lHKey
        
        'Save the splitter
        oRegTemp.SetFromObject oObject:=imgSplitter(nCnt)
        
        'Cleanup
        Set oRegTemp = Nothing
        
NextSplitter:
    Next nCnt
    
Exit Sub


ErrorHandler:
    Resume NextSplitter
    
End Sub

Private Sub ResizeControls()
    
    Dim nVertSplit1     As Integer
    Dim nVertSplit2     As Integer
    Dim nStatusBarTop   As Integer
    
    'Get the status bar height
    If sbrMain.Visible Then
        nStatusBarTop = pnlMain.Height - mknEdgeDist - sbrMain.Height
    Else
        nStatusBarTop = pnlMain.Height - (mknEdgeDist - mknControlSpacing)
    End If
    
    'Size the controls based on the screen mode
    Select Case meScreenMode
        Case eScreenModeConstants.eSMCCodeSettings
            'Determine splitter locations
            If gbrMain.Visible Then
                nVertSplit1 = imgSplitter(eSTCVertSplit1).Left
                nVertSplit2 = imgSplitter(eSTCVertSplit2).Left
                
                If nVertSplit1 < mknEdgeDist + mknMinWidthGroupBar Then
                    nVertSplit1 = mknEdgeDist + mknMinWidthGroupBar
                End If
                
                If nVertSplit2 < nVertSplit1 + mknControlSpacing + mknMinWidthTreeView Then
                    nVertSplit2 = nVertSplit1 + mknControlSpacing + mknMinWidthTreeView
                End If
                
                If nVertSplit2 > pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing Then
                    nVertSplit2 = pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing
                End If
                
                If nVertSplit1 > nVertSplit2 - mknMinWidthTreeView - mknControlSpacing Then
                    nVertSplit1 = nVertSplit2 - mknMinWidthTreeView - mknControlSpacing
                End If
            Else
                nVertSplit1 = mknEdgeDist - mknControlSpacing
                nVertSplit2 = imgSplitter(eSTCVertSplit2).Left
                
                If nVertSplit2 < nVertSplit1 + mknControlSpacing + mknMinWidthTreeView Then
                    nVertSplit2 = nVertSplit1 + mknControlSpacing + mknMinWidthTreeView
                End If
                
                If nVertSplit2 > pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing Then
                    nVertSplit2 = pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing
                End If
            End If
            
            'Locate the controls
            If sbrMain.Visible Then
                With sbrMain
                    .Move mknEdgeDist, pnlMain.Height - mknEdgeDist - .Height, _
                          pnlMain.Width - mknEdgeDist * 2
                End With
            End If
            
            If gbrMain.Visible Then
                With gbrMain
                    .Move mknEdgeDist, mknEdgeDist, _
                          nVertSplit1 - mknEdgeDist, _
                          nStatusBarTop - mknEdgeDist - mknControlSpacing
                End With
                
                With imgSplitter(eSTCVertSplit1)
                    .Move nVertSplit1, mknEdgeDist, mknControlSpacing, _
                          nStatusBarTop - mknEdgeDist - mknControlSpacing
                End With
            End If
            
            With picTitle
                .Move nVertSplit1 + mknControlSpacing, mknEdgeDist, _
                      pnlMain.Width - mknEdgeDist - nVertSplit1 - mknControlSpacing
            End With
            
            With lblTitle
                .Move .Left, .Top, picTitle.Width - .Left * 2
            End With
            
            With imgSplitter(eSTCVertSplit2)
                .Move nVertSplit2, picTitle.Top + picTitle.Height + mknControlSpacing, _
                      mknControlSpacing, nStatusBarTop - picTitle.Top - picTitle.Height - mknControlSpacing * 2
            End With
            
            With tvwMain
                .Move nVertSplit1 + mknControlSpacing, imgSplitter(eSTCVertSplit2).Top, _
                      nVertSplit2 - nVertSplit1 - mknControlSpacing, imgSplitter(eSTCVertSplit2).Height
            End With
            
            With lvwMain
                .Move nVertSplit2 + mknControlSpacing, tvwMain.Top, _
                      pnlMain.Width - mknEdgeDist - nVertSplit2 - mknControlSpacing, tvwMain.Height
            End With
        
        Case eScreenModeConstants.eSMCStartDates, eScreenModeConstants.eSMCSurveyCodeList, eScreenModeConstants.eSMCSurveyBDUSList
            'Determine splitter locations
            If gbrMain.Visible Then
                nVertSplit1 = imgSplitter(eSTCVertSplit1).Left
                
                If nVertSplit1 < mknEdgeDist + mknMinWidthGroupBar Then
                    nVertSplit1 = mknEdgeDist + mknMinWidthGroupBar
                End If
                
                If nVertSplit1 > pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing Then
                    nVertSplit1 = pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing
                End If
            Else
                nVertSplit1 = mknEdgeDist - mknControlSpacing
            End If
            
            'Locate the controls
            If sbrMain.Visible Then
                With sbrMain
                    .Move mknEdgeDist, pnlMain.Height - mknEdgeDist - .Height, _
                          pnlMain.Width - mknEdgeDist * 2
                End With
            End If
            
            If gbrMain.Visible Then
                With gbrMain
                    .Move mknEdgeDist, mknEdgeDist, _
                          nVertSplit1 - mknEdgeDist, _
                          nStatusBarTop - mknEdgeDist - mknControlSpacing
                End With
                
                With imgSplitter(eSTCVertSplit1)
                    .Move nVertSplit1, mknEdgeDist, mknControlSpacing, _
                          nStatusBarTop - mknEdgeDist - mknControlSpacing
                End With
            End If
            
            With picTitle
                .Move nVertSplit1 + mknControlSpacing, mknEdgeDist, _
                      pnlMain.Width - mknEdgeDist - nVertSplit1 - mknControlSpacing
            End With
            
            With lblTitle
                .Move .Left, .Top, picTitle.Width - .Left * 2
            End With
            
            With lvwMain
                .Move nVertSplit1 + mknControlSpacing, picTitle.Top + picTitle.Height + mknControlSpacing, _
                      pnlMain.Width - mknEdgeDist - nVertSplit1 - mknControlSpacing, _
                      nStatusBarTop - picTitle.Top - picTitle.Height - mknControlSpacing * 2
            End With
        
    End Select
    
End Sub

Private Sub Form_KeyUp(nKeyCode As Integer, nShift As Integer)
    
    Dim bHandled  As Boolean
    
    'Pass the keystroke to the active bar control to see if it is a shortcut
    bHandled = abrMain.OnKeyUp(KeyCode:=nKeyCode, Shift:=nShift)
    
    'If the active bar control hadled the keystroke then kill it
    If bHandled Then
        nKeyCode = 0
        nShift = 0
    End If
    
End Sub


Private Sub Form_Load()
    
    Dim oBarGroup As GSGroupBarActiveX.GSBarGroup
    
    'Locate the form and controls
    SetupViewOptions lHKey:=gsrsHKEYCurrentUser, sSection:=gksRegSectionForms
    LocateSplitters lHKey:=gsrsHKEYCurrentUser, sSection:=gksRegSectionForms
    Set moFormBase = New CFormBase98
    moFormBase.Register oForm:=Me, _
                        lHKey:=gsrsHKEYCurrentUser, _
                        sSection:=gksRegSectionForms
    moFormBase.LocateMe
    
    'Setup the groupbar
    With gbrMain
        Set .LargeIcons = imlLarge
        Set .SmallIcons = imlSmall
        .View = gsgbLargeIcons
    End With
    
    Set oBarGroup = gbrMain.BarGroups.Add("Settings", "Settings")
    With oBarGroup
        .GroupItems.Add gksICONCodeSettings, "Code Settings", gksICONCodeSettings, gksICONCodeSettings
        .GroupItems.Add gksICONStartDates, "Skip Surveys", gksICONStartDates, gksICONStartDates
        .GroupItems.Add gksICONSurveyCodeList, "Survey Code List Settings", gksICONSurveyCodeList, gksICONSurveyCodeList
        .GroupItems.Add gksICONSurveyBDUSList, "Survey MetaField Mappings", gksICONSurveyBDUSList, gksICONSurveyBDUSList
    End With
    
    'Setup the statusbar
    With sbrMain
        'Add the user name
        With .Panels("UserName")
            .Text = " " & goUserInfo.UserName & " "
            .ToolTipText = "User Name: " & goUserInfo.UserName
        End With
        
        'Add the computer name
        With .Panels("ComputerName")
            .Text = " " & goUserInfo.ComputerName & " "
            .ToolTipText = "Computer Name: " & goUserInfo.ComputerName
        End With
        
        'Add the program version
        With .Panels("Version")
            .Text = " " & GetAppVersion() & " "
            .ToolTipText = "Version: " & GetAppVersion()
        End With
    End With
    
    'Setup the form
    meScreenMode = eSMCModeUndefined
    SetScreenMode eScreenMode:=eSMCCodeSettings
    
End Sub


Private Sub SaveViewOptions(ByVal lHKey As RegDBServer98.gsrsHKEYConstantsEnum, _
                            ByVal sSection As String)
    
    Dim oRegTemp    As RegDBServer98.RegBool
    
    'Restore the view option for the groupbar
    Set oRegTemp = New RegDBServer98.RegBool
    oRegTemp.Register sSection:=sSection, _
                      sKey:=Me.Name & " View GroupBar", _
                      lHKey:=lHKey
    oRegTemp.Value = abrMain.Tools("mnuViewGroupbar").Checked
    
    'Cleanup
    Set oRegTemp = Nothing
    
    'Restore the view option for the statusbar
    Set oRegTemp = New RegDBServer98.RegBool
    oRegTemp.Register sSection:=sSection, _
                      sKey:=Me.Name & " View StatusBar", _
                      lHKey:=lHKey
    oRegTemp.Value = abrMain.Tools("mnuViewStatusbar").Checked
    
    'Cleanup
    Set oRegTemp = Nothing
    
End Sub

Private Sub SetupViewOptions(ByVal lHKey As RegDBServer98.gsrsHKEYConstantsEnum, _
                             ByVal sSection As String)
    
    Dim oRegTemp    As RegDBServer98.RegBool
    
    'Restore the view option for the groupbar
    Set oRegTemp = New RegDBServer98.RegBool
    oRegTemp.Register sSection:=sSection, _
                      sKey:=Me.Name & " View GroupBar", _
                      lHKey:=lHKey, _
                      bDefault:=True
    abrMain.Tools("mnuViewGroupbar").Checked = oRegTemp.Value
    gbrMain.Visible = oRegTemp.Value
    imgSplitter(eSTCVertSplit1).Visible = oRegTemp.Value
    ResizeControls
    
    'Cleanup
    Set oRegTemp = Nothing
    
    'Restore the view option for the statusbar
    Set oRegTemp = New RegDBServer98.RegBool
    oRegTemp.Register sSection:=sSection, _
                      sKey:=Me.Name & " View StatusBar", _
                      lHKey:=lHKey, _
                      bDefault:=True
    abrMain.Tools("mnuViewStatusbar").Checked = oRegTemp.Value
    sbrMain.Visible = oRegTemp.Value
    ResizeControls
    
    'Cleanup
    Set oRegTemp = Nothing
    
End Sub

Private Sub LocateSplitters(ByVal lHKey As RegDBServer98.gsrsHKEYConstantsEnum, _
                            ByVal sSection As String)
    
    Dim nCnt        As Integer
    Dim fTemp       As Single
    Dim oRegTemp    As RegDBServer98.RegRect
    
    'Set the error handler
    On Error GoTo ErrorHandler
    
    'Locate the splitters
    For nCnt = imgSplitter.LBound To imgSplitter.ubound
        'Get a registry object
        Set oRegTemp = New RegDBServer98.RegRect
        oRegTemp.Register sSection:=sSection, _
                          sKey:=Me.Name & " Splitter " & nCnt, _
                          lHKey:=lHKey
        
        'Locate the splitter
        fTemp = oRegTemp.Left
        If oRegTemp.IsPresent Then oRegTemp.SetToObject oObject:=imgSplitter(nCnt)
        
        'Cleanup
        Set oRegTemp = Nothing
        
NextSplitter:
    Next nCnt
    
Exit Sub


ErrorHandler:
    Resume NextSplitter
    
End Sub

Private Sub Form_Resize()
    
    'If the form has been minimized then we do not want to do this
    If Me.WindowState = vbMinimized Then Exit Sub
    
    'Check for minimum size requirements
    If Me.Width < mknMinWidth Then Me.Width = mknMinWidth
    If Me.Height < mknMinHeight Then Me.Height = mknMinHeight
    
    'Resize the panel
    pnlMain.Move 0, 0, Me.ScaleWidth, Me.ScaleHeight
    
    'Resize all controls
    ResizeControls
    
End Sub


Private Sub Form_Unload(nCancel As Integer)
    
    On Error Resume Next
    
    'Save the form location
    moFormBase.SaveLocation
    SaveSplitters lHKey:=gsrsHKEYCurrentUser, sSection:=gksRegSectionForms
    SaveViewOptions lHKey:=gsrsHKEYCurrentUser, sSection:=gksRegSectionForms
    
    On Error GoTo 0
    
    'Cleanup
    CloseDBConnection oConn:=goConn
    CloseDBConnection oConn:=goDMConn   '** Added 09-29-05 JJF
    Set moFormBase = Nothing
    
End Sub


Private Sub gbrMain_ItemClick(oGroupItem As GSGroupBarActiveX.GSGroupItem)
    
    Select Case oGroupItem.Key
        Case gksICONCodeSettings
            SetScreenMode eScreenMode:=eSMCCodeSettings
        
        Case gksICONStartDates
            SetScreenMode eScreenMode:=eSMCStartDates
        
        Case gksICONSurveyCodeList
            SetScreenMode eScreenMode:=eSMCSurveyCodeList
        
        Case gksICONSurveyBDUSList
            SetScreenMode eScreenMode:=eSMCSurveyBDUSList
        
    End Select
    
End Sub


Private Sub imgSplitter_MouseDown(nIndex As Integer, nButton As Integer, nShift As Integer, fXCoord As Single, fYCoord As Single)
    
    Dim fWidth    As Single
    Dim fHeight   As Single
            
    'Size the picture box and display it
    With imgSplitter(nIndex)
        'Determine the width and height of the visible splitter
        Select Case nIndex
            Case eSTCVertSplit1, eSTCVertSplit2
                fWidth = .Width
                fHeight = .Height
        End Select
        
        'Move the visible splitter and display it
        picSplitter.Move .Left, .Top, fWidth, fHeight
        picSplitter.Visible = True
    End With
    
    'Set the flag to indicate that we are moving the splitter
    mbMoving = True
    
End Sub


Private Sub imgSplitter_MouseMove(nIndex As Integer, nButton As Integer, nShift As Integer, fXCoord As Single, fYCoord As Single)
    
    Dim fSplitPos         As Single
    Dim nToolBarHeight    As Integer
    Dim nStatusBarHeight  As Integer

    'If we are in moving mode then proceed
    If mbMoving Then
        'Get the status bar height
        If sbrMain.Visible Then
            nStatusBarHeight = sbrMain.Height
        Else
            nStatusBarHeight = 0
        End If
        
        'Take the appropriate action based on the splitter being moved
        Select Case nIndex
            Case eSTCVertSplit1
                'Get the splitter position
                fSplitPos = fXCoord + imgSplitter(nIndex).Left
                
                'Locate the visible splitter
                If fSplitPos < mknMinWidthGroupBar + mknEdgeDist Then
                    picSplitter.Left = mknMinWidthGroupBar + mknEdgeDist
                ElseIf tvwMain.Visible And _
                       fSplitPos > lvwMain.Left - mknControlSpacing - mknMinWidthTreeView - mknControlSpacing Then
                    picSplitter.Left = lvwMain.Left - mknControlSpacing - mknMinWidthTreeView - mknControlSpacing
                ElseIf Not tvwMain.Visible And _
                       fSplitPos > pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing Then
                    picSplitter.Left = pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing
                Else
                    picSplitter.Left = fSplitPos
                End If
            Case eSTCVertSplit2
                'Get the splitter position
                fSplitPos = fXCoord + imgSplitter(nIndex).Left
                
                'Locate the visible splitter
                If gbrMain.Visible And _
                   fSplitPos < mknEdgeDist + gbrMain.Width + mknControlSpacing + mknMinWidthTreeView Then
                    picSplitter.Left = mknEdgeDist + gbrMain.Width + mknControlSpacing + mknMinWidthTreeView
                ElseIf Not gbrMain.Visible And _
                       fSplitPos < mknEdgeDist + mknMinWidthTreeView Then
                    picSplitter.Left = mknEdgeDist + mknMinWidthTreeView
                ElseIf fSplitPos > pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing Then
                    picSplitter.Left = pnlMain.Width - mknEdgeDist - mknMinWidthListView - mknControlSpacing
                Else
                    picSplitter.Left = fSplitPos
                End If
        End Select
    End If
    
End Sub


Private Sub imgSplitter_MouseUp(nIndex As Integer, nButton As Integer, nShift As Integer, fXCoord As Single, fYCoord As Single)
    
    'Take action on appropriate splitter
    Select Case nIndex
        Case eSTCVertSplit1, eSTCVertSplit2
            imgSplitter(nIndex).Left = picSplitter.Left
    End Select
    
    'Resize the controls
    ResizeControls
    
    'Turn of the visible splitter
    picSplitter.Visible = False
    mbMoving = False
    
End Sub


Private Sub lvwMain_DblClick()
    
    'Determine if there is a selected item
    If lvwMain.SelectedItem Is Nothing Then Exit Sub
    
    'Make sure the selected item is highlighted
    lvwMain.SelectedItem.Selected = True
    
    'Edit the selected item
    EditEntry

End Sub

Private Sub lvwMain_MouseUp(nButton As Integer, nShift As Integer, fXCoord As Single, fYCoord As Single)
    
    Dim oListItem As GSEnhListView.GSListItem
    
    'If this is not the right mousebutton then head out of dodge
    If nButton <> vbRightButton Then Exit Sub
    
    'Determine if we are on a listitem or not
    Set oListItem = lvwMain.HitTest(x:=fXCoord, y:=fYCoord)
    If oListItem Is Nothing Then
        abrMain.Bands("mnuLVNPopup").TrackPopup x:=-1, y:=-1
    Else
        abrMain.Bands("mnuLVIPopup").TrackPopup x:=-1, y:=-1
    End If
    
    'Cleanup
    Set oListItem = Nothing
    
End Sub


Private Sub tvwMain_NodeClick(ByVal oNode As ComctlLib.Node)
    
    Select Case meScreenMode
        Case eScreenModeConstants.eSMCCodeSettings
            PopCodeListView oNode:=oNode
        
    End Select
    
End Sub


