VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
Begin VB.Form frmStudyProperties 
   Caption         =   "Study Properties"
   ClientHeight    =   6525
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8715
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   6525
   ScaleWidth      =   8715
   Begin VB.CommandButton cmdApply 
      Caption         =   "&Apply"
      Height          =   375
      Left            =   7080
      TabIndex        =   63
      Top             =   5880
      Width           =   1215
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   5640
      TabIndex        =   62
      Top             =   5880
      Width           =   1215
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   4200
      TabIndex        =   61
      Top             =   5880
      Width           =   1215
   End
   Begin TabDlg.SSTab SSTabStudyProperties 
      Height          =   5415
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   8295
      _ExtentX        =   14631
      _ExtentY        =   9551
      _Version        =   393216
      Tabs            =   8
      TabsPerRow      =   4
      TabHeight       =   794
      TabCaption(0)   =   "&Study Parameters"
      TabPicture(0)   =   "frmStudyProperties.frx":0000
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "FrameStudyParam"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "Client &Information"
      TabPicture(1)   =   "frmStudyProperties.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "FrameClientInfo"
      Tab(1).ControlCount=   1
      TabCaption(2)   =   "O&bjectives"
      TabPicture(2)   =   "frmStudyProperties.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "FrameObjectives"
      Tab(2).ControlCount=   1
      TabCaption(3)   =   "Co&mparison"
      TabPicture(3)   =   "frmStudyProperties.frx":0054
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "FrameComparison"
      Tab(3).ControlCount=   1
      TabCaption(4)   =   "Action &Plan Selections"
      TabPicture(4)   =   "frmStudyProperties.frx":0070
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "FrameActionPlan"
      Tab(4).ControlCount=   1
      TabCaption(5)   =   "Authorized &Associates"
      TabPicture(5)   =   "frmStudyProperties.frx":008C
      Tab(5).ControlEnabled=   0   'False
      Tab(5).Control(0)=   "FrameAuthorizedEmp"
      Tab(5).ControlCount=   1
      TabCaption(6)   =   "&Delivery Dates"
      TabPicture(6)   =   "frmStudyProperties.frx":00A8
      Tab(6).ControlEnabled=   0   'False
      Tab(6).Control(0)=   "FrameDeliveryDates"
      Tab(6).ControlCount=   1
      TabCaption(7)   =   "&Report Types"
      TabPicture(7)   =   "frmStudyProperties.frx":00C4
      Tab(7).ControlEnabled=   0   'False
      Tab(7).Control(0)=   "FrameReportTypes"
      Tab(7).ControlCount=   1
      Begin VB.Frame FrameAuthorizedEmp 
         Caption         =   "Authorized Associates"
         Height          =   3495
         Left            =   -74880
         TabIndex        =   48
         Top             =   1440
         Width           =   7935
         Begin VB.ComboBox cmbAccountDirector 
            Height          =   315
            Left            =   1560
            Style           =   2  'Dropdown List
            TabIndex        =   75
            Top             =   2880
            Width           =   4695
         End
         Begin MSDataGridLib.DataGrid DataGrid1 
            Height          =   2415
            Left            =   240
            TabIndex        =   73
            Top             =   360
            Width           =   6015
            _ExtentX        =   10610
            _ExtentY        =   4260
            _Version        =   393216
            AllowUpdate     =   0   'False
            AllowArrows     =   0   'False
            HeadLines       =   1
            RowHeight       =   15
            FormatLocked    =   -1  'True
            BeginProperty HeadFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ColumnCount     =   2
            BeginProperty Column00 
               DataField       =   "e-mail"
               Caption         =   "e-mail"
               BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
                  Type            =   0
                  Format          =   ""
                  HaveTrueFalseNull=   0
                  FirstDayOfWeek  =   0
                  FirstWeekOfYear =   0
                  LCID            =   1033
                  SubFormatType   =   0
               EndProperty
            EndProperty
            BeginProperty Column01 
               DataField       =   "Associate Name"
               Caption         =   "Associate Name"
               BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
                  Type            =   0
                  Format          =   ""
                  HaveTrueFalseNull=   0
                  FirstDayOfWeek  =   0
                  FirstWeekOfYear =   0
                  LCID            =   1033
                  SubFormatType   =   0
               EndProperty
            EndProperty
            SplitCount      =   1
            BeginProperty Split0 
               BeginProperty Column00 
               EndProperty
               BeginProperty Column01 
               EndProperty
            EndProperty
         End
         Begin VB.CommandButton cmdAuthEmp 
            Caption         =   "Add / Change..."
            Height          =   375
            Left            =   6480
            TabIndex        =   49
            Top             =   480
            Width           =   1335
         End
         Begin VB.Label Label29 
            AutoSize        =   -1  'True
            Caption         =   "Account Director:"
            Height          =   195
            Left            =   240
            TabIndex        =   50
            Top             =   2880
            Width           =   1245
         End
      End
      Begin VB.Frame FrameDeliveryDates 
         Height          =   3855
         Left            =   -74640
         TabIndex        =   51
         Top             =   1200
         Width           =   7575
         Begin VB.CommandButton cmdEditDate 
            Caption         =   "Edit..."
            Height          =   375
            Left            =   4440
            TabIndex        =   54
            Top             =   3000
            Width           =   1335
         End
         Begin VB.CommandButton cmdDeleteDate 
            Caption         =   "Delete"
            Height          =   375
            Left            =   5880
            TabIndex        =   55
            Top             =   3000
            Width           =   1335
         End
         Begin VB.CommandButton cmdAddDate 
            Caption         =   "Add..."
            Height          =   375
            Left            =   3000
            TabIndex        =   53
            Top             =   3000
            Width           =   1335
         End
         Begin ComctlLib.ListView lvwDeliveryDates 
            Height          =   2175
            Left            =   360
            TabIndex        =   52
            Top             =   480
            Width           =   6855
            _ExtentX        =   12091
            _ExtentY        =   3836
            LabelWrap       =   -1  'True
            HideSelection   =   -1  'True
            _Version        =   327682
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   0
         End
      End
      Begin VB.Frame FrameReportTypes 
         Height          =   3975
         Left            =   -74760
         TabIndex        =   56
         Top             =   1200
         Width           =   7695
         Begin VB.CommandButton cmdEditReport 
            Caption         =   "Edit..."
            Height          =   375
            Left            =   4440
            TabIndex        =   59
            Top             =   3000
            Width           =   1335
         End
         Begin VB.CommandButton cmdDeleteReport 
            Caption         =   "Delete"
            Height          =   375
            Left            =   5880
            TabIndex        =   60
            Top             =   3000
            Width           =   1335
         End
         Begin VB.CommandButton cmdAddReport 
            Caption         =   "Add..."
            Height          =   375
            Left            =   3000
            TabIndex        =   58
            Top             =   3000
            Width           =   1335
         End
         Begin ComctlLib.ListView lvwReportTypes 
            Height          =   2175
            Left            =   360
            TabIndex        =   57
            Top             =   600
            Width           =   6855
            _ExtentX        =   12091
            _ExtentY        =   3836
            LabelWrap       =   -1  'True
            HideSelection   =   -1  'True
            _Version        =   327682
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   0
         End
      End
      Begin VB.Frame FrameActionPlan 
         Height          =   4215
         Left            =   -74760
         TabIndex        =   36
         Top             =   1080
         Width           =   7695
         Begin RichTextLib.RichTextBox rtbReportLevels 
            Height          =   975
            Left            =   2640
            TabIndex        =   69
            Top             =   2880
            Width           =   4815
            _ExtentX        =   8493
            _ExtentY        =   1720
            _Version        =   393217
            Enabled         =   -1  'True
            TextRTF         =   $"frmStudyProperties.frx":00E0
         End
         Begin VB.TextBox editActionPlan 
            Height          =   975
            Left            =   2640
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   46
            Top             =   1800
            Width           =   4815
         End
         Begin VB.TextBox editConfidence 
            Height          =   315
            Left            =   6600
            MaxLength       =   5
            TabIndex        =   40
            Top             =   600
            Width           =   855
         End
         Begin VB.TextBox editNumCopies 
            Height          =   315
            Left            =   2640
            MaxLength       =   5
            TabIndex        =   38
            Top             =   600
            Width           =   855
         End
         Begin VB.TextBox editErrorMargin 
            Height          =   315
            Left            =   6600
            MaxLength       =   5
            TabIndex        =   44
            Top             =   1200
            Width           =   855
         End
         Begin VB.TextBox editCutOff 
            Height          =   315
            Left            =   2640
            MaxLength       =   5
            TabIndex        =   42
            Top             =   1200
            Width           =   855
         End
         Begin VB.Label Label19 
            AutoSize        =   -1  'True
            Caption         =   "Special instructions for low N size:"
            Height          =   195
            Left            =   120
            TabIndex        =   45
            Top             =   1800
            Width           =   2400
         End
         Begin VB.Label Label16 
            AutoSize        =   -1  'True
            Caption         =   "Confidence Interval %:"
            Height          =   195
            Left            =   4815
            TabIndex        =   39
            Top             =   600
            Width           =   1590
         End
         Begin VB.Label Label15 
            AutoSize        =   -1  'True
            Caption         =   "Number of Copies To Send:"
            Height          =   195
            Left            =   480
            TabIndex        =   37
            Top             =   600
            Width           =   1965
         End
         Begin VB.Label Label18 
            AutoSize        =   -1  'True
            Caption         =   "Cut-Off Target %:"
            Height          =   195
            Left            =   1230
            TabIndex        =   41
            Top             =   1200
            Width           =   1215
         End
         Begin VB.Label Label17 
            AutoSize        =   -1  'True
            Caption         =   "Error Margin %:"
            Height          =   195
            Left            =   5340
            TabIndex        =   43
            Top             =   1200
            Width           =   1065
         End
         Begin VB.Label Label14 
            AutoSize        =   -1  'True
            Caption         =   "Report Level:"
            Height          =   195
            Left            =   1485
            TabIndex        =   47
            Top             =   2880
            Width           =   960
         End
      End
      Begin VB.Frame FrameComparison 
         Height          =   4095
         Left            =   -74760
         TabIndex        =   31
         Top             =   1080
         Width           =   7695
         Begin VB.CommandButton cmdEditComparison 
            Caption         =   "Edit..."
            Height          =   375
            Left            =   4440
            TabIndex        =   34
            Top             =   2760
            Width           =   1335
         End
         Begin VB.CommandButton cmdDeleteComparison 
            Caption         =   "Delete"
            Height          =   375
            Left            =   6000
            TabIndex        =   35
            Top             =   2760
            Width           =   1335
         End
         Begin VB.CommandButton cmdAddComparison 
            Caption         =   "Add..."
            Height          =   375
            Left            =   2880
            TabIndex        =   33
            Top             =   2760
            Width           =   1335
         End
         Begin ComctlLib.ListView lvwComparison 
            Height          =   2055
            Left            =   360
            TabIndex        =   32
            Top             =   480
            Width           =   6975
            _ExtentX        =   12303
            _ExtentY        =   3625
            LabelWrap       =   -1  'True
            HideSelection   =   -1  'True
            _Version        =   327682
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   0
         End
      End
      Begin VB.Frame FrameClientInfo 
         Height          =   4215
         Left            =   -74880
         TabIndex        =   13
         Top             =   1080
         Width           =   7935
         Begin VB.TextBox editBBSUserName 
            Height          =   315
            Left            =   2760
            TabIndex        =   23
            Top             =   2640
            Width           =   1815
         End
         Begin VB.TextBox editBBSPassword 
            Height          =   315
            Left            =   2760
            TabIndex        =   25
            Top             =   3120
            Width           =   1815
         End
         Begin VB.TextBox editAccountCode 
            Height          =   315
            Left            =   2760
            TabIndex        =   21
            Top             =   2160
            Width           =   1815
         End
         Begin VB.TextBox editSpent 
            Height          =   315
            Left            =   2760
            MaxLength       =   15
            TabIndex        =   19
            Top             =   1680
            Width           =   1215
         End
         Begin VB.TextBox editBudget 
            Height          =   315
            Left            =   2760
            MaxLength       =   15
            TabIndex        =   17
            Top             =   1200
            Width           =   1215
         End
         Begin VB.Label Label10 
            AutoSize        =   -1  'True
            Caption         =   "BBS User Name:"
            Height          =   195
            Left            =   1365
            TabIndex        =   22
            Top             =   2640
            Width           =   1200
         End
         Begin VB.Label Label11 
            AutoSize        =   -1  'True
            Caption         =   "BBS Password:"
            Height          =   195
            Left            =   1470
            TabIndex        =   24
            Top             =   3120
            Width           =   1095
         End
         Begin VB.Label Label5 
            AutoSize        =   -1  'True
            Caption         =   "Accounting Code:"
            Height          =   195
            Left            =   1290
            TabIndex        =   20
            Top             =   2160
            Width           =   1275
         End
         Begin VB.Label lblClientName 
            Caption         =   "Client Name"
            Height          =   315
            Left            =   2760
            TabIndex        =   15
            Top             =   720
            Width           =   3855
         End
         Begin VB.Label Label26 
            AutoSize        =   -1  'True
            Caption         =   "Client Name:"
            Height          =   195
            Left            =   1665
            TabIndex        =   14
            Top             =   720
            Width           =   900
         End
         Begin VB.Label Label9 
            AutoSize        =   -1  'True
            Caption         =   "Amount Spent On Project:"
            Height          =   195
            Left            =   720
            TabIndex        =   18
            Top             =   1680
            Width           =   1845
         End
         Begin VB.Label Label8 
            AutoSize        =   -1  'True
            Caption         =   "Amount Budgeted For Project:"
            Height          =   195
            Left            =   435
            TabIndex        =   16
            Top             =   1200
            Width           =   2130
         End
      End
      Begin VB.Frame FrameObjectives 
         Height          =   4095
         Left            =   -74760
         TabIndex        =   26
         Top             =   1080
         Width           =   7695
         Begin RichTextLib.RichTextBox rtbDeliverableDesc 
            Height          =   1455
            Left            =   2160
            TabIndex        =   71
            Top             =   2400
            Width           =   5175
            _ExtentX        =   9128
            _ExtentY        =   2566
            _Version        =   393217
            Enabled         =   -1  'True
            TextRTF         =   $"frmStudyProperties.frx":0162
         End
         Begin RichTextLib.RichTextBox rtbObjective 
            Height          =   1095
            Left            =   2160
            TabIndex        =   70
            Top             =   480
            Width           =   5175
            _ExtentX        =   9128
            _ExtentY        =   1931
            _Version        =   393217
            Enabled         =   -1  'True
            TextRTF         =   $"frmStudyProperties.frx":01E4
         End
         Begin VB.TextBox editSignOffDate 
            Height          =   315
            Left            =   2160
            MaxLength       =   10
            TabIndex        =   29
            Top             =   1800
            Width           =   1215
         End
         Begin VB.Label Label13 
            Caption         =   "Deliverables Format/ Weighting Options:"
            Height          =   555
            Left            =   420
            TabIndex        =   30
            Top             =   2400
            Width           =   1500
         End
         Begin VB.Label Label12 
            AutoSize        =   -1  'True
            Caption         =   "Sign off Date:"
            Height          =   195
            Left            =   945
            TabIndex        =   28
            Top             =   1800
            Width           =   975
         End
         Begin VB.Label Label6 
            AutoSize        =   -1  'True
            Caption         =   "Objective:"
            Height          =   195
            Left            =   1200
            TabIndex        =   27
            Top             =   480
            Width           =   720
         End
      End
      Begin VB.Frame FrameStudyParam 
         Height          =   4335
         Left            =   120
         TabIndex        =   1
         Top             =   960
         Width           =   7935
         Begin VB.CheckBox chkNCOA 
            Caption         =   "National Change of Address"
            Enabled         =   0   'False
            Height          =   255
            Left            =   2400
            TabIndex        =   74
            Top             =   3720
            Width           =   2415
         End
         Begin VB.CheckBox chkProperCase 
            Caption         =   "Uses Proper Case for Names"
            Height          =   255
            Left            =   5160
            TabIndex        =   72
            Top             =   3720
            Value           =   1  'Checked
            Width           =   2535
         End
         Begin VB.CheckBox chkCheckPhone 
            Caption         =   "Uses Phone Number Cleaning"
            Height          =   255
            Left            =   5160
            TabIndex        =   68
            Top             =   3360
            Width           =   2532
         End
         Begin VB.TextBox editContractEndDate 
            Height          =   315
            Left            =   5400
            MaxLength       =   10
            TabIndex        =   67
            Top             =   1920
            Width           =   1215
         End
         Begin VB.TextBox editContractStartDate 
            Height          =   315
            Left            =   2400
            MaxLength       =   10
            TabIndex        =   66
            Top             =   1920
            Width           =   1215
         End
         Begin VB.TextBox editStudyDescription 
            Height          =   615
            Left            =   2400
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   7
            Top             =   1080
            Width           =   5055
         End
         Begin VB.TextBox editStudyName 
            Height          =   315
            Left            =   2400
            TabIndex        =   5
            Top             =   600
            Width           =   2055
         End
         Begin VB.TextBox editArchiveMonths 
            Height          =   315
            Left            =   2400
            MaxLength       =   5
            TabIndex        =   11
            Top             =   2880
            Width           =   855
         End
         Begin VB.TextBox editEndDate 
            Height          =   315
            Left            =   2400
            MaxLength       =   10
            TabIndex        =   9
            Top             =   2400
            Width           =   1215
         End
         Begin VB.CheckBox chkCleanAddress 
            Caption         =   "Uses Address Cleaning"
            Height          =   255
            Left            =   2400
            TabIndex        =   12
            Top             =   3360
            Width           =   2052
         End
         Begin VB.Label Label22 
            AutoSize        =   -1  'True
            Caption         =   "Contract End Date:"
            Height          =   195
            Left            =   3840
            TabIndex        =   65
            Top             =   1920
            Width           =   1365
         End
         Begin VB.Label Label21 
            AutoSize        =   -1  'True
            Caption         =   "Contract Start Date:"
            Height          =   195
            Left            =   840
            TabIndex        =   64
            Top             =   1920
            Width           =   1410
         End
         Begin VB.Label Label4 
            AutoSize        =   -1  'True
            Caption         =   "Projected End Date:"
            Height          =   195
            Left            =   810
            TabIndex        =   8
            Top             =   2400
            Width           =   1440
         End
         Begin VB.Label lblCreateDate 
            Caption         =   "99/99/99"
            Height          =   375
            Left            =   2400
            TabIndex        =   3
            Top             =   240
            Width           =   1215
         End
         Begin VB.Label Label7 
            AutoSize        =   -1  'True
            Caption         =   "# Months Before Archiving:"
            Height          =   195
            Left            =   315
            TabIndex        =   10
            Top             =   2880
            Width           =   1935
         End
         Begin VB.Label Label3 
            AutoSize        =   -1  'True
            Caption         =   "Date Created:"
            Height          =   195
            Left            =   1320
            TabIndex        =   2
            Top             =   240
            Width           =   990
         End
         Begin VB.Label Label2 
            AutoSize        =   -1  'True
            Caption         =   "Study Description:"
            Height          =   195
            Left            =   960
            TabIndex        =   6
            Top             =   1080
            Width           =   1290
         End
         Begin VB.Label Label1 
            AutoSize        =   -1  'True
            Caption         =   "Study Name:"
            Height          =   195
            Left            =   1335
            TabIndex        =   4
            Top             =   600
            Width           =   915
         End
      End
   End
End
Attribute VB_Name = "frmStudyProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim objStudy As Study
Dim flgLoading As Boolean

Private bConcurrencyLock As Boolean
Public objAudit As New Audit.cAudit
Private objEmpId As New getEmpId.GetEmpIdDll
Private blnViewOnly As Boolean

Public Sub Component(aStudy As Study)
    Set objStudy = aStudy
End Sub

' 03-12-2006 SH Added
Private Sub cmbStudyType_Change()
' *** 03-24-2006 SH Deleted
'    If flgLoading Then Exit Sub
'    If blnViewOnly Then Exit Sub
'
'    If cmbStudyType.ListIndex = 0 Then objStudy.IsStudyOnGoing = True
'    If cmbStudyType.ListIndex = 1 Then objStudy.IsStudyOnGoing = False
' *** 03-24-2006 SH End of deletion
End Sub

Private Sub cmbStudyType_Click()
' *** 03-24-2006 SH Deleted
'    If flgLoading Then Exit Sub
'    If blnViewOnly Then Exit Sub
'
'    If cmbStudyType.ListIndex = 0 Then objStudy.IsStudyOnGoing = True
'    If cmbStudyType.ListIndex = 1 Then objStudy.IsStudyOnGoing = False
' *** 03-24-2006 SH End of deletion
End Sub
' End of addition

' *** 06-01-2003 SH Added
Private Sub cboCountry_Change()
' *** 05-10-2005 SH Deleted
'    If cboCountry.ListIndex > -1 Then
'        objStudy.CountryID = cboCountry.ListIndex + 1
'    End If
' *** 05-10-2005 SH End of deletion
End Sub

' *** 06-01-2003 SH Added
Private Sub cboCountry_Click()
' *** 05-10-2005 SH Deleted
'    If cboCountry.ListIndex > -1 Then
'        objStudy.CountryID = cboCountry.ListIndex + 1
'    End If
' *** 05-10-2005 SH End of deletion
End Sub

Sub UpdateNCOA()
    cn.Execute "update Study set bitNCOA =  " & chkNCOA.Value & " WHERE Study_id = " & G_StudyID
End Sub

Sub UpdateUsers()
    On Error GoTo Rollback
    
    cn.BeginTrans
    cn.Execute "Delete Study_employee where employee_id in(select Employee_id from #temp where active = 0) and study_id =" & G_StudyID
    cn.Execute "delete #temp where employee_id in (select employee_id from study_employee where Study_id=" & G_StudyID & ") or active = 0"
    cn.Execute "INSERT into Study_employee (study_id,Employee_id) select distinct " & G_StudyID & ",t.Employee_id from #temp t, Employee"
    cn.CommitTrans
    cn.Execute "update study set ADEMPLOYEE_ID = " & cmbAccountDirector.ItemData(cmbAccountDirector.ListIndex) & " where Study_id=" & G_StudyID
    Exit Sub

Rollback:
    cn.RollbackTrans
End Sub

Private Sub cmdApply_Click()
    If IsScreenValid Then
        Me.MousePointer = vbHourglass
        ' 03-24-2006 SH Added
        If Not blnViewOnly Then
            With objStudy
                .IsStudyOnGoing = True
                .ArchiveMonths = CLng(Trim(Me.editArchiveMonths.Text))
            End With
        End If
        
        objStudy.ApplyEdit
        UpdateUsers
        'UpdateNCOA 'Uncomment this later 11-03-2003 SH
        objAudit.CommitAudit objStudy.ID, 0, objEmpId.UserEmployeeID, "Study Data Client"
        objStudy.BeginEdit
        Me.MousePointer = vbDefault
    Else
        MsgBox ValidationString, , G_Study.name
    End If
End Sub

Private Sub cmdOK_Click()
    If IsScreenValid Then
        Me.MousePointer = vbHourglass
        ' 03-24-2006 SH Added
        If Not blnViewOnly Then
            With objStudy
                .IsStudyOnGoing = True
                .ArchiveMonths = CLng(Trim(Me.editArchiveMonths.Text))
            End With
        End If

        objStudy.ApplyEdit
        UpdateUsers
        'UpdateNCOA ' Uncomment this later 11-03-2003 SH
        objAudit.CommitAudit objStudy.ID, 0, objEmpId.UserEmployeeID, "Study Data Client"
        Me.MousePointer = vbDefault
        Unload Me
    Else
        MsgBox ValidationString, , G_Study.name
    End If
End Sub

Private Sub cmdCancel_Click()
    If Not bConcurrencyLock Then
        Unload Me
        Exit Sub
    End If
    
    If (MsgBox("All work done during this session will be lost if not saved." & vbCrLf & "Do you wish to save changes done in this session ?", vbYesNo, G_Study.name) = vbYes) Then
        cmdOK_Click
        Exit Sub
    End If
    
    objStudy.CancelEdit
    Unload Me
End Sub

Private Sub editContractEndDate_Change()
    Dim intPos As Long
  
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    
    On Error Resume Next
    
    objStudy.ContractEndDate = editContractEndDate.Text
    
    If Err Then
        Beep
        intPos = editContractEndDate.SelStart
        editContractEndDate.Text = objStudy.ContractEndDate
        editContractEndDate.SelStart = intPos - 1
    End If
End Sub

Private Sub editContractEndDate_LostFocus()
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
  
    editContractEndDate.Text = objStudy.ContractEndDate
End Sub

Private Sub editContractStartDate_Change()
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    On Error Resume Next
    
    objStudy.ContractStartDate = editContractStartDate.Text
    
    If Err Then
        Beep
        intPos = editContractStartDate.SelStart
        editContractStartDate.Text = objStudy.ContractStartDate
        editContractStartDate.SelStart = intPos - 1
    End If
End Sub

Private Sub editContractStartDate_LostFocus()
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
  
    editContractStartDate.Text = objStudy.ContractStartDate
End Sub

Private Sub DataGrid1_DblClick()
'   Dim a As Integer
'   Dim r As Integer
'
'   a = rsUsers.AbsolutePosition
'   r = DataGrid1.Row
'
'   rsUsers.Fields("Active").Value = 0
'   rsUsers.Filter = "Active = 1"
'   rsUsers.Requery
'   If r > -1 Then
'     rsUsers.AbsolutePosition = Abs(a - r)
'     DataGrid1.Row = r
'   End If
End Sub

Private Sub Form_Load()
    Dim aList As TextList
    Dim aFrm As New frmLoadingInfo
    Dim rs As New ADODB.Recordset
    Dim i As Integer
    
    'aFrm.Caption = "Study Properties"
    'aFrm.Show
    Me.MousePointer = vbHourglass
    G_StudyID = objStudy.ID
    DoEvents
    
    flgLoading = True
    
    ' 05-10-2005 SH Added
    With objEmpId
        .RetrieveUserEmployeeID
        objStudy.CountryID = .UserCountryID
    End With
    'objEmpId.RetrieveUserEmployeeID
    
    BuildListViewHeaders
    
    'Initial loading of the study object
    Set aList = objStudy.ClientList
    
    'Tab study parameters
    lblCreateDate = objStudy.CreationDate
    editStudyName = objStudy.name
    editStudyDescription = objStudy.Description
    editEndDate = objStudy.CloseDate
    editContractStartDate = objStudy.ContractStartDate
    editContractEndDate = objStudy.ContractEndDate
    ' 03-26-2006 SH Modified ArchiveMonths to 6 as default.
    editArchiveMonths.Text = IIf((objStudy.ArchiveMonths = -1), "6", CStr(objStudy.ArchiveMonths))
    'chkDynamic.Value = IIf((objStudy.IsDynamic = True), 1, 0)
        
    If objStudy.UseAddressCleaning Then
        chkCleanAddress.Value = 1
        chkProperCase.Enabled = True
        ' Uncomment this later 11-03-2003 SH
        'chkNCOA.Enabled = True ' Added 10-31-2003 SH
    Else
        chkCleanAddress.Value = 0
        chkProperCase.Enabled = False
        ' Added 10-31-2003 SH
        ' Uncomment this later 11-03-2003
        'chkNCOA.value = 0
        'UpdateNCOA
        'chkNCOA.Enabled = False
    End If
    
    chkCheckPhone.Value = IIf((objStudy.UsePhoneChecking = True), 1, 0)
    chkProperCase.Value = IIf((objStudy.UseProperCase = True), 1, 0)
    
    ' 03-14-2006 SH Modified to work on Config Manager .NET
    ' Radio button doesn't work well on .NET so changed it
    ' to combo box.
    ' Study Type
    ' 03-24-2006 SH Deleted
    'LoadStudyTypeComboBox
    'cmbStudyType.ListIndex = IIf(objStudy.IsStudyOnGoing, 0, 1)
    ' *** End of deletion
    
    ' 03-14-2006 SH Deleted
'    If objStudy.IsStudyOnGoing Then
'        'optOnGoing.value = True
'        'optPoingInTime.value = False
'    Else
'        'optPoingInTime.value = True
'        'optOnGoing.value = False
'    End If
    ' 03-14-2006 End of deletion
    
    'If objStudy.CutOffResponseCode = "R" Then
    '    optResponse.Value = True
    '    optSample.Value = False
    'Else
    '    optSample.Value = True
    '    optResponse.Value = False
    'End If
    
    ' Tab Authorized Employee
  
'    cmbAccountDirector.Clear
    
    Do While DataGrid1.Columns.Count > 1
        DataGrid1.Columns.Remove 0
    Loop
   
    DataGrid1.Columns.Add (1)
    DataGrid1.Columns.Add (2)
      
    DataGrid1.Columns(0).Caption = "Associate Name"
    DataGrid1.Columns(1).Caption = "E-Mail"
    DataGrid1.Columns(2).Caption = "Extension"
      
    DataGrid1.Columns(0).DataField = "Associate Name"
    DataGrid1.Columns(1).DataField = "E-Mail"
    DataGrid1.Columns(2).DataField = "Extension"
   
    rsUsers.CursorLocation = adUseClient
    
    If cn.State = 0 Then cn.Open strConnection
   
    cn.Execute "SELECT [Associate Name]=strEmployee_first_nm + ' ' + strEmployee_last_nm, Extension = strPhoneExt,[E-Mail]=strEmail,Employee_id, Active = 0 into #temp FROM employee order by strEmployee_first_nm + ' ' + strEmployee_last_nm"
    cn.Execute "Update #temp set Active = 1 FROM study_employee se inner join #temp t on se.Employee_id = t.Employee_id where Study_id=" & G_StudyID
    rsUsers.Open "select * from #temp", cn, adOpenDynamic, adLockOptimistic
    
    Set DataGrid1.DataSource = rsUsers.DataSource
   
    'DataGrid1.Columns("Associate Name").Visible = True
    'DataGrid1.Columns("E-Mail").Visible = True
    'DataGrid1.Columns("Extension").Visible = True
    
    DataGrid1.Columns("Associate Name").Width = Me.TextWidth("Associate Name")
    DataGrid1.Columns("E-Mail").Width = Me.TextWidth("E-Mail")
    DataGrid1.Columns("Extension").Width = Me.TextWidth("E-Mail")
    
    Do While Not rsUsers.EOF
        i = Me.TextWidth(rsUsers.Fields("Associate Name").Value)
        If i > DataGrid1.Columns("Associate Name").Width Then
            DataGrid1.Columns("Associate Name").Width = i
        End If
        i = Me.TextWidth(rsUsers.Fields("Extension").Value)
        If i > DataGrid1.Columns("Extension").Width Then
            DataGrid1.Columns("Extension").Width = i
        End If
     
        i = Me.TextWidth(rsUsers.Fields("E-Mail").Value)
        If i > DataGrid1.Columns("E-Mail").Width Then
            DataGrid1.Columns("E-Mail").Width = i
        End If
        rsUsers.MoveNext
    Loop
    rsUsers.Filter = "Active = 1"
    
    If Not rsUsers.EOF Then rsUsers.MoveFirst
    'LoadStudyEmployees
     
    LoadAccountDirector
     
    ' Tab client
    lblClientName = objStudy.Client
    editBudget.Text = IIf((objStudy.BudgetAmount = -1), "", CStr(objStudy.BudgetAmount))
    editSpent.Text = IIf((objStudy.TotalSpent = -1), "", CStr(objStudy.TotalSpent))
    editAccountCode = objStudy.AccountingCode
    editBBSUserName = objStudy.BBSUserName
    editBBSPassword = objStudy.BBSPassword
    
    'Tab Comparisons
    LoadStudyComparisons
    
    'Tab Delivery Dates
    LoadStudyDeliveryDates
    
    'Tab Report Types
    LoadStudyReports
    
    'Tab Action Plan Selections
    editNumCopies = IIf((objStudy.NumberOfReports = -1), "", CStr(objStudy.NumberOfReports))
    editConfidence = IIf((objStudy.ConfidenceInterval = -1), "", CStr(objStudy.ConfidenceInterval))
    editCutOff = IIf((objStudy.CutOffTarget = -1), "", CStr(objStudy.CutOffTarget))
    editErrorMargin = IIf((objStudy.ErrorMargin = -1), "", CStr(objStudy.ErrorMargin))
    editActionPlan = objStudy.ActionPlanBelowQuata
    rtbReportLevels = objStudy.ReportLevels
     
    'Tab Objectives
    editSignOffDate = objStudy.ObjectiveSignOffDate
    rtbObjective.Text = objStudy.ObjectivesText
    rtbDeliverableDesc.Text = objStudy.ObjectiveDeliverables
        
    SSTabStudyProperties.Tab = 0 'start at the first tab
    
    SetCaption
    flgLoading = False
        
    'Unload aFrm
    Set aFrm = Nothing
    Me.MousePointer = vbDefault
    
    If bConcurrencyLock Then
        Me.cmdOK.Enabled = True
        Me.cmdApply.Enabled = True
        Me.cmdCancel.Caption = "&Cancel"
        EnableAllControls
        objStudy.BeginEdit
    Else
        Me.cmdOK.Enabled = False
        Me.cmdApply.Enabled = False
        Me.cmdCancel.Caption = "&Close"
        DisableAllControls
    End If
    
    'created by Ashwini
    'cboCountry.Clear
        'country.AddItem "USA"
        'country.AddItem "Canada"
    
    ' Uncomment this later 11-03-2003 SH
    'rs.Open "SELECT bitNCOA FROM Study WHERE Study_id = " & G_StudyID, cn
    
    'If Not rs.EOF Then
    '  chkNCOA.value = Abs(rs.Fields(0).value)
    'End If
    
    'rs.Close
    'Set rs = Nothing
    
    'LoadCountryComboBox ' 05-10-2005 SH Deleted
    AccountDirector = objStudy.AccountDirector
    ADEmpID = -1
    If cmbAccountDirector.NewIndex > -1 Then
        ADEmpID = cmbAccountDirector.ItemData(cmbAccountDirector.NewIndex)
    End If
End Sub

' 03-14-2006 SH Added
Private Sub LoadStudyTypeComboBox()
' *** 03-24-2006 SH Deleted
'    With cmbStudyType
'        .Clear
'        .AddItem "On Going"
'        .AddItem "Point in time"
'        .Enabled = bConcurrencyLock
'    End With
' *** 03-24-2006 SH End of deletion
End Sub

Private Sub LoadCountryComboBox()
' *** 05-10-2005 SH Deleted
' The user no longer has option to clean US or Canada address first.
' If it's in Canada, use CACE otherwise ACE.
'    Dim cnWasClosed As Boolean
'    Dim strSQL As String
'    Dim rs As New ADODB.Recordset
'    Dim lngCountry As Long
'
'    cnWasClosed = cn.State = 0
'
'    strSQL = "SELECT * FROM dbo.Country ORDER BY Country_id"
'
'    If cnWasClosed Then cn.Open strConnection
'    Set rs = cn.Execute(strSQL)
'    cboCountry.Clear
'    If Not rs.EOF Then
'        rs.MoveFirst
'        While Not rs.EOF
'            cboCountry.AddItem rs!strCountry_nm
'            cboCountry.ItemData(cboCountry.NewIndex) = rs!Country_id
'            If Not rs.EOF Then rs.MoveNext
'        Wend
'    End If
'
'    Set rs = Nothing
'
'    cboCountry.ListIndex = objStudy.CountryID - 1
'    cboCountry.Visible = chkCleanAddress.Value
'
'    'If cnWasClosed Then cn.Close
' *** 05-10-2005 SH End of deletion
End Sub

' Study Parameters Tab
Private Sub chkCleanAddress_Click()
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    objStudy.UseAddressCleaning = chkCleanAddress.Value
    chkProperCase.Enabled = chkCleanAddress.Value
    'cboCountry.Visible = chkCleanAddress.Value ' 05-10-2005 SH Deleted
    ' Uncomment this later 11-03-2003 SH
    'chkNCOA.Enabled = chkCleanAddress.value ' Added 10-31-2003 SH
End Sub

Private Sub chkCheckPhone_Click()
    ' 9/9/1999 DV
    ' When the person selects this checkbox, we will set the UsePhoneCleaning
    ' in the Study object.  If we are loading, we will not do this.
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    objStudy.UsePhoneChecking = IIf((chkCheckPhone.Value = 1), True, False)
End Sub

Private Sub chkProperCase_Click()
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    objStudy.UseProperCase = IIf((chkProperCase.Value = 1), True, False)
End Sub

' *** 10-31-2003 SH
Private Sub chkNCOA_Click()
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
End Sub

Private Sub editArchiveMonths_LostFocus()
    Dim val As String
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
        
    val = Trim(editArchiveMonths.Text)
    
    If Len(val) = 0 Then
        objStudy.ArchiveMonths = -1
    ElseIf IsNumeric(val) Then
        If CDbl(val) > MAX_INTEGER_VALUE Then
            SSTabStudyProperties.Tab = 0
            MsgBox "The value entered must be less than or equal to " & MAX_INTEGER_VALUE & ".", , G_Study.name
            editArchiveMonths.SetFocus
            editArchiveMonths.SelStart = 0
            editArchiveMonths.SelLength = Len(editArchiveMonths.Text)
        Else
            objStudy.ArchiveMonths = CLng(val)
        End If
    Else
        SSTabStudyProperties.Tab = 0
        MsgBox "Please enter only numeric values.", , G_Study.name
        editArchiveMonths.SetFocus
        editArchiveMonths.SelStart = 0
        editArchiveMonths.SelLength = Len(editArchiveMonths.Text)
    End If
End Sub

Private Sub editEndDate_Change()
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    On Error Resume Next
    
    objStudy.CloseDate = editEndDate.Text
    
    If Err Then
        Beep
        intPos = editEndDate.SelStart
        editEndDate.Text = objStudy.CloseDate
        editEndDate.SelStart = intPos - 1
    End If
End Sub

Private Sub editEndDate_LostFocus()
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
  
    editEndDate.Text = objStudy.CloseDate
End Sub

Private Sub editStudyDescription_Change()
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    On Error Resume Next
    
    objStudy.Description = editStudyDescription.Text
    
    If Err Then
        Beep
        intPos = editStudyDescription.SelStart
        editStudyDescription.Text = objStudy.Description
        editStudyDescription.SelStart = intPos - 1
    End If
End Sub

Private Sub editStudyDescription_LostFocus()
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
  
    editStudyDescription.Text = objStudy.Description
End Sub

Private Sub editStudyName_Change()
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
        
    On Error Resume Next
    
    objStudy.name = editStudyName.Text
    
    If Err Then
        Beep
        intPos = editStudyName.SelStart
        editStudyName.Text = objStudy.name
        editStudyName.SelStart = intPos - 1
    End If
    
    SetCaption
End Sub

Private Sub editStudyName_LostFocus()
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
  
    editStudyName.Text = objStudy.name
End Sub

Private Sub Form_Unload(Cancel As Integer)
   Set DataGrid1.DataSource = Nothing
   rsUsers.Close
   cn.Execute "drop table #temp"
End Sub

Private Sub optOnGoing_Click()
' 03-14-2006 SH Deleted
'    If flgLoading Then Exit Sub
'
'    If blnViewOnly Then Exit Sub
'
'    objStudy.IsStudyOnGoing = True
End Sub

Private Sub optPoingInTime_Click()
' 03-14-2006 SH Deleted
'    If flgLoading Then Exit Sub
'
'    If blnViewOnly Then Exit Sub
'
'    objStudy.IsStudyOnGoing = False

End Sub

Private Sub editBudget_LostFocus()
    
    Dim val As String
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
        
    val = Trim(editBudget.Text)
    
    If Len(val) = 0 Then
        objStudy.BudgetAmount = -1
    ElseIf IsNumeric(val) Then
        objStudy.BudgetAmount = CCur(val)
    Else
        MsgBox "Please enter only numeric values", , G_Study.name
        editBudget.SetFocus
    End If
    
End Sub

Private Sub editSpent_LostFocus()
    
    Dim val As String
    Dim iConfirm As Integer
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
        
    val = Trim(editSpent.Text)
    
    If Len(val) = 0 Then
        objStudy.TotalSpent = -1
    ElseIf IsNumeric(val) Then
        iConfirm = vbYes
        If CCur(val) > CCur(Me.editBudget) Then
            iConfirm = MsgBox("Amount Spent is more than Amount Budgeted.  Are you sure this is correct?", vbExclamation + vbYesNo, "Study Properties")
        End If
        
        If iConfirm = vbYes Then
            objStudy.TotalSpent = CCur(val)
        Else
            editSpent.Text = ""
            editSpent.SetFocus
        End If
    Else
        MsgBox "Please enter only numeric values", , G_Study.name
        editSpent.SetFocus
    End If
    
End Sub

Private Sub editAccountCode_Change()
  
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    On Error Resume Next
    
    objStudy.AccountingCode = editAccountCode.Text
    
    If Err Then
        Beep
        intPos = editAccountCode.SelStart
        editAccountCode.Text = objStudy.AccountingCode
        editAccountCode.SelStart = intPos - 1
    End If

End Sub

Private Sub editAccountCode_LostFocus()
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
  
    editAccountCode.Text = objStudy.AccountingCode

End Sub

Private Sub editBBSPassword_Change()
  
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    On Error Resume Next
    
    objStudy.BBSPassword = editBBSPassword.Text
    
    If Err Then
        Beep
        intPos = editBBSPassword.SelStart
        editBBSPassword.Text = objStudy.BBSPassword
        editBBSPassword.SelStart = intPos - 1
    End If

End Sub

Private Sub editBBSPassword_LostFocus()
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
  
    editBBSPassword.Text = objStudy.BBSPassword

End Sub

Private Sub editBBSUserName_Change()
  
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    
    If blnViewOnly Then Exit Sub
    
    On Error Resume Next
    
    objStudy.BBSUserName = editBBSUserName.Text
    
    If Err Then
        Beep
        intPos = editBBSUserName.SelStart
        editBBSUserName.Text = objStudy.BBSUserName
        editBBSUserName.SelStart = intPos - 1
    End If

End Sub

Private Sub editBBSUserName_LostFocus()
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
  
    editBBSUserName.Text = objStudy.BBSUserName
End Sub

' Tab Authorized Employee
Private Sub cmbAccountDirector_Click()
    If flgLoading Then Exit Sub

    If blnViewOnly Then Exit Sub

    If cmbAccountDirector.Text = "" Then Exit Sub

    objStudy.AccountDirector = cmbAccountDirector.Text
    AccountDirector = cmbAccountDirector.Text
    ADEmpID = cmbAccountDirector.ItemData(cmbAccountDirector.ListIndex)
End Sub

Private Sub cmdAuthEmp_Click()
    Dim aDlg As dlgAuthEmployees
    
    Set aDlg = New dlgAuthEmployees
    aDlg.Component objStudy
    aDlg.Show vbModal
    LoadStudyEmployees
    LoadAccountDirector

End Sub

Private Sub LoadStudyEmployees()
  
    Dim objStudyEmp As StudyEmployee
    Dim itmList As ListItem
    Dim lngIndex As Long
    
    'lvwAuthEmployees.ListItems.Clear
    'For lngIndex = 1 To objStudy.StudyEmployeeColl.Count
    '    Set itmList = lvwAuthEmployees.ListItems.Add _
    '        (Key:=Format$(lngIndex) & "K")
    '    Set objStudyEmp = objStudy.StudyEmployeeColl(lngIndex)
    '    With itmList
    '        .Text = objStudy.EmployeeList.Item(Format$(objStudyEmp.EmployeeID))
    '        .SubItems(1) = objStudy.EmployeeExtList.Item(Format$(objStudyEmp.EmployeeID))
    '        .SubItems(2) = objStudy.EmployeeEmailList.Item(Format$(objStudyEmp.EmployeeID))
    '    End With
    'Next

End Sub

Private Sub LoadAccountDirector()
    
    Dim lngIndex As Long
    Dim aStudyEmployee As StudyEmployee
    Dim empIndex As Long
    Dim empStr As String
    Dim bm As Variant
    Dim rs As New ADODB.Recordset
    
    cmbAccountDirector.Clear
'
'    cmbAccountDirector.ListIndex = -1
    empIndex = -1
'
'    For lngIndex = 1 To objStudy.StudyEmployeeColl.Count
'        Set aStudyEmployee = objStudy.StudyEmployeeColl(lngIndex)
'        empStr = objStudy.EmployeeList.Item(Format$(aStudyEmployee.EmployeeID))
'        cmbAccountDirector.AddItem empStr
'        If Trim(objStudy.AccountDirector) = empStr Then
'            empIndex = lngIndex
'        End If
'    Next
'
'    If empIndex > 0 Then
'        cmbAccountDirector.ListIndex = empIndex - 1 'because empIndex is 1 based
'    End If
    
    rs.Open "select Distinct [Associate Name] as an, Employee_id as ID from #temp where active = 1 order by [Associate Name]", cn
    
    cmbAccountDirector.ListIndex = -1
    objStudy.EmployeeList.Count
    rs.MoveFirst
    Do While Not rs.EOF
        empStr = Trim(rs.Fields("an").Value)
        cmbAccountDirector.AddItem empStr
        If Trim(objStudy.AccountDirector) = empStr Then
            cmbAccountDirector.ListIndex = cmbAccountDirector.NewIndex
        End If
        cmbAccountDirector.ItemData(cmbAccountDirector.NewIndex) = rs.Fields("id").Value
        rs.MoveNext
    Loop
    
    rs.Close
    Set rs = Nothing
    
    
    
    
End Sub

'
'  Comparison Tab
'

Private Sub lvwComparison_BeforeLabelEdit(Cancel As Integer)
    
    Cancel = True

End Sub

Private Sub cmdAddComparison_Click()
  
    Dim aDlg As dlgStudyComparison
    
    Set aDlg = New dlgStudyComparison
    aDlg.Component objStudy.StudyComparisonColl.Add
    aDlg.Show vbModal
    LoadStudyComparisons
    cmdEditComparison.Enabled = False
    cmdDeleteComparison.Enabled = False

End Sub

Private Sub cmdEditComparison_Click()
  
    Dim aDlg As dlgStudyComparison
    
    If lvwComparison.SelectedItem Is Nothing Then Exit Sub
    
    Set aDlg = New dlgStudyComparison
    aDlg.Component objStudy.StudyComparisonColl(val(lvwComparison.SelectedItem.Key))
    aDlg.Show vbModal
    LoadStudyComparisons
    cmdEditComparison.Enabled = False
    cmdDeleteComparison.Enabled = False

End Sub

Private Sub cmdDeleteComparison_Click()
  
    If lvwComparison.SelectedItem Is Nothing Then Exit Sub
      
    cmdEditComparison.Enabled = False
    cmdDeleteComparison.Enabled = False
    
    If (MsgBox("Are you sure you want to delete this entry?", vbYesNo, G_Study.name) = vbNo) Then
        Exit Sub
    End If
    
    objStudy.StudyComparisonColl.Remove val(lvwComparison.SelectedItem.Key)
    LoadStudyComparisons

End Sub

Private Sub LoadStudyComparisons()
  
    Dim objStudyComp As StudyComparison
    Dim itmList As ListItem
    Dim lngIndex As Long
    
    lvwComparison.ListItems.Clear
    For lngIndex = 1 To objStudy.StudyComparisonColl.Count
        Set itmList = lvwComparison.ListItems.Add _
            (Key:=Format$(lngIndex) & "K")
        Set objStudyComp = objStudy.StudyComparisonColl(lngIndex)
        With itmList
            If objStudyComp.ComparisonType > 0 Then
                .Text = G_Study.ComparisonTypeList.Item(Format$(objStudyComp.ComparisonType))
            Else
                .Text = ""
            End If
            
            If objStudyComp.MSA > 0 Then
                .SubItems(1) = G_Study.MSAList.Item(Format$(objStudyComp.MSA))
            Else
                .SubItems(1) = ""
            End If
            
            If objStudyComp.State > 0 Then
                .SubItems(2) = G_Study.StateList.Item(Format$(objStudyComp.State))
            Else
                .SubItems(2) = ""
            End If
            
            If objStudyComp.MarketGuidePlanType > 0 Then
                .SubItems(3) = G_Study.MGPTList.Item(Format$(objStudyComp.MarketGuidePlanType))
            Else
                .SubItems(3) = ""
            End If
            '.SubItems(3) = objStudyComp.MarketGuidePlanType
        End With
    Next

End Sub

'
'  Delivery Dates Tab
'

Private Sub lvwDeliveryDates_BeforeLabelEdit(Cancel As Integer)
    
    Cancel = True

End Sub

Private Sub cmdAddDate_Click()
  
    Dim aDlg As dlgStudyDelivery
    
    Set aDlg = New dlgStudyDelivery
    aDlg.Component objStudy.StudyDeliveryColl.Add
    
    Set aDlg.objAudit = objAudit
    aDlg.blnNew = True
    
    aDlg.Show vbModal
    LoadStudyDeliveryDates
    cmdEditDate.Enabled = False
    cmdDeleteDate.Enabled = False

End Sub

Private Sub cmdEditDate_Click()
  
    Dim aDlg As dlgStudyDelivery
    
    If lvwDeliveryDates.SelectedItem Is Nothing Then Exit Sub
    
    Set aDlg = New dlgStudyDelivery
    aDlg.Component objStudy.StudyDeliveryColl(val(lvwDeliveryDates.SelectedItem.Key))
    
    Set aDlg.objAudit = objAudit.GetChildAuditObject(val(lvwDeliveryDates.SelectedItem.Key))
    aDlg.blnNew = False
    
    aDlg.Show vbModal
    LoadStudyDeliveryDates
    cmdEditDate.Enabled = False
    cmdDeleteDate.Enabled = False

End Sub

Private Sub cmdDeleteDate_Click()
    
    If lvwDeliveryDates.SelectedItem Is Nothing Then Exit Sub
    cmdEditDate.Enabled = False
    cmdDeleteDate.Enabled = False
      
    If (MsgBox("Are you sure you want to delete this entry?", vbYesNo, G_Study.name) = vbNo) Then
        Exit Sub
    End If
      
    objAudit.AddDeletedItem objStudy.StudyDeliveryColl(val(lvwDeliveryDates.SelectedItem.Key)).DeliveryDate, DELIVERABLES_CHANGE, "Deliverable Date", val(lvwDeliveryDates.SelectedItem.Key)
    
    objStudy.StudyDeliveryColl.Remove val(lvwDeliveryDates.SelectedItem.Key)
    LoadStudyDeliveryDates

End Sub

Private Sub LoadStudyDeliveryDates()
  
    Dim objStudyDlvry As StudyDelivery
    Dim itmList As ListItem
    Dim lngIndex As Long
    
    lvwDeliveryDates.ListItems.Clear
    
    For lngIndex = 1 To objStudy.StudyDeliveryColl.Count
        Set itmList = lvwDeliveryDates.ListItems.Add _
            (Key:=Format$(lngIndex) & "K")
        Set objStudyDlvry = objStudy.StudyDeliveryColl(lngIndex)
        With itmList
            .Text = objStudyDlvry.DeliveryDate
            .SubItems(1) = objStudyDlvry.Description
        End With
    Next

End Sub

'
'  Report Type Tab
'

Private Sub lvwReportTypes_BeforeLabelEdit(Cancel As Integer)
    
    Cancel = True
    
End Sub

Private Sub cmdAddReport_Click()
  
    Dim aDlg As dlgStudyReport
    
    Set aDlg = New dlgStudyReport
    aDlg.Component objStudy.StudyReportColl.Add
    aDlg.Show vbModal
    LoadStudyReports
    cmdEditReport.Enabled = False
    cmdDeleteReport.Enabled = False

End Sub

Private Sub cmdEditReport_Click()
  
    Dim aDlg As dlgStudyReport
    
    If lvwReportTypes.SelectedItem Is Nothing Then Exit Sub
    
    Set aDlg = New dlgStudyReport
    aDlg.Component objStudy.StudyReportColl(val(lvwReportTypes.SelectedItem.Key))
    aDlg.Show vbModal
    LoadStudyReports
    cmdEditReport.Enabled = False
    cmdDeleteReport.Enabled = False

End Sub

Private Sub cmdDeleteReport_Click()
  
    If lvwReportTypes.SelectedItem Is Nothing Then Exit Sub
    cmdEditReport.Enabled = False
    cmdDeleteReport.Enabled = False
    If (MsgBox("Are you sure you want to delete this entry?", vbYesNo, G_Study.name) = vbNo) Then
        Exit Sub
    End If
    objStudy.StudyReportColl.Remove val(lvwReportTypes.SelectedItem.Key)
    LoadStudyReports

End Sub

Private Sub LoadStudyReports()
  
    Dim objStudyRpt As StudyReport
    Dim itmList As ListItem
    Dim lngIndex As Long
    
    lvwReportTypes.ListItems.Clear
    For lngIndex = 1 To objStudy.StudyReportColl.Count
        Set itmList = lvwReportTypes.ListItems.Add _
          (Key:=Format$(lngIndex) & "K")
        Set objStudyRpt = objStudy.StudyReportColl(lngIndex)
        With itmList
            If objStudyRpt.ReportType > 0 Then
                .Text = G_Study.ReportTypeList.Item(Format$(objStudyRpt.ReportType))
            Else
                .Text = ""
            End If
          .SubItems(1) = objStudyRpt.Description
        End With
    Next

End Sub

'
'  Action Plan settings Tab
'

Private Sub editActionPlan_Change()
  
    Dim intPos As Long
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    On Error Resume Next
    objStudy.ActionPlanBelowQuata = editActionPlan.Text
    If Err Then
        Beep
        intPos = editActionPlan.SelStart
        editActionPlan.Text = objStudy.ActionPlanBelowQuata
        editActionPlan.SelStart = intPos - 1
    End If

End Sub

Private Sub editActionPlan_LostFocus()
  
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    editActionPlan.Text = objStudy.ActionPlanBelowQuata

End Sub

Private Sub editConfidence_LostFocus()
    
    Dim val As String
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    
    
    val = Trim(editConfidence.Text)
    If Len(val) = 0 Then
        objStudy.ConfidenceInterval = -1
    ElseIf IsNumeric(val) Then
        If CDbl(val) > MAX_INTEGER_VALUE Then
            MsgBox "The value entered must be less than or equal to " & MAX_INTEGER_VALUE, , G_Study.name
            editArchiveMonths.SetFocus
        Else
            objStudy.ConfidenceInterval = CLng(val)
        End If
    Else
        MsgBox "Please enter only numeric values", , G_Study.name
        editConfidence.SetFocus
    End If
    
End Sub

Private Sub editCutOff_LostFocus()
    
    Dim val As String
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    
    val = Trim(editCutOff.Text)
    If Len(val) = 0 Then
        objStudy.CutOffTarget = -1
    ElseIf IsNumeric(val) Then
        If CDbl(val) > MAX_INTEGER_VALUE Then
            MsgBox "The value entered must be less than or equal to " & MAX_INTEGER_VALUE, , G_Study.name
            editArchiveMonths.SetFocus
        Else
            objStudy.CutOffTarget = CLng(val)
        End If
    Else
        MsgBox "Please enter only numeric values", , G_Study.name
        editCutOff.SetFocus
    End If
    
End Sub

Private Sub editErrorMargin_LostFocus()
    
    Dim val As String
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
        
    val = Trim(editErrorMargin.Text)
    If Len(val) = 0 Then
        objStudy.ErrorMargin = -1
    ElseIf IsNumeric(val) Then
        If CDbl(val) > MAX_INTEGER_VALUE Then
            MsgBox "The value entered must be less than or equal to " & MAX_INTEGER_VALUE, , G_Study.name
            editArchiveMonths.SetFocus
        Else
            objStudy.ErrorMargin = CLng(val)
        End If
    Else
        MsgBox "Please enter only numeric values", , G_Study.name
        editErrorMargin.SetFocus
    End If
    
End Sub

Private Sub editNumCopies_LostFocus()
    
    Dim val As String
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    
    
    val = Trim(editNumCopies.Text)
    If Len(val) = 0 Then
        objStudy.NumberOfReports = -1
    ElseIf IsNumeric(val) Then
        If CDbl(val) > MAX_INTEGER_VALUE Then
            MsgBox "The value entered must be less than or equal to " & MAX_INTEGER_VALUE, , G_Study.name
            editArchiveMonths.SetFocus
        Else
            objStudy.NumberOfReports = CLng(val)
        End If
    Else
        MsgBox "Please enter only numeric values", , G_Study.name
        editNumCopies.SetFocus
    End If
    
End Sub

Private Sub rtbReportLevels_LostFocus()
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    If Not rtbReportLevels.Locked Then
        objStudy.ReportLevels = rtbReportLevels.Text
    End If
    
End Sub

'
'  Objectives sign off Tab
'
Private Sub editSignOffDate_LostFocus()
    
    Dim val As String
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    
    val = Trim(editSignOffDate.Text)
    If Len(val) = 0 Then
        objStudy.ObjectiveSignOffDate = ""
    ElseIf IsDate(val) Then
        objStudy.ObjectiveSignOffDate = val
    Else
        MsgBox "Please enter valid dates", , G_Study.name
        editSignOffDate.SetFocus
    End If
    
End Sub

Private Sub rtbDeliverableDesc_LostFocus()
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    If Not rtbDeliverableDesc.Locked Then
        objStudy.ObjectiveDeliverables = rtbDeliverableDesc.Text
    End If
    
End Sub

Private Sub rtbObjective_LostFocus()
    
    If flgLoading Then Exit Sub
    If blnViewOnly Then Exit Sub
    If Not rtbObjective.Locked Then
        objStudy.ObjectivesText = rtbObjective.Text
    End If
    
End Sub

'
'  Support functions
'
Private Sub loadComboBox(cmbBox As ComboBox, aListName As String)
    Dim vntItem As Variant
    Dim aList As TextList
    
    Select Case aListName
        Case "EmployeeList"
            Set aList = G_Study.EmployeeList
        Case Else
            Set aList = Nothing
    End Select
    
    cmbBox.Clear
    
    For Each vntItem In aList
      cmbBox.AddItem vntItem
    Next
    
End Sub

Private Sub BuildListViewHeaders()
    
    Dim colHead As ColumnHeader
    Dim lstItem As ListItem
    
    ' Client Tab
   ' lvwAuthEmployees.View = lvwReport
    
    'Set colHead = lvwAuthEmployees.ColumnHeaders.Add()
    'colHead.Text = "Associate"
    'colHead.Width = lvwAuthEmployees.Width * 0.25
    
    'Set colHead = lvwAuthEmployees.ColumnHeaders.Add(, , "Extension", lvwAuthEmployees.Width * 0.095)
    'Set colHead = lvwAuthEmployees.ColumnHeaders.Add(, , "E-mail", lvwAuthEmployees.Width * 0.5)
        
    ' Comparison Tab
    lvwComparison.View = lvwReport
    Set colHead = lvwComparison.ColumnHeaders.Add()
    colHead.Text = "Comparison Type"
    colHead.Width = lvwComparison.Width * 0.3
    
    Set colHead = lvwComparison.ColumnHeaders.Add()
    colHead.Text = "MSA"
    colHead.Width = lvwComparison.Width * 0.15
    
    Set colHead = lvwComparison.ColumnHeaders.Add()
    colHead.Text = "State"
    colHead.Width = lvwComparison.Width * 0.15
    
    Set colHead = lvwComparison.ColumnHeaders.Add()
    colHead.Text = "Market Guide Plan Type"
    colHead.Width = lvwComparison.Width * 0.3
    
    ' Delivery Dates Tab
    lvwDeliveryDates.View = lvwReport
    Set colHead = lvwDeliveryDates.ColumnHeaders.Add()
    colHead.Text = "Delivery Date"
    colHead.Width = lvwDeliveryDates.Width * 0.3
    
    Set colHead = lvwDeliveryDates.ColumnHeaders.Add()
    colHead.Text = "Description"
    colHead.Width = lvwDeliveryDates.Width * 0.7

    ' Report Types Tab
    lvwReportTypes.View = lvwReport
    Set colHead = lvwReportTypes.ColumnHeaders.Add()
    colHead.Text = "Report Type"
    colHead.Width = lvwReportTypes.Width * 0.3
    
    Set colHead = lvwReportTypes.ColumnHeaders.Add()
    colHead.Text = "Report Note"
    colHead.Width = lvwReportTypes.Width * 0.7

End Sub

Private Function IsScreenValid() As Boolean
    ' 03-24-2006 SH Modified
    ' Added archive months checking.
    If Len(Trim(editArchiveMonths.Text)) = 0 Then
        IsScreenValid = False
    Else
        If rsUsers.RecordCount > 0 And Len(Trim(cmbAccountDirector.Text)) > 0 And _
            CLng(Trim(editArchiveMonths.Text)) > 0 Then
            IsScreenValid = True
        Else
            IsScreenValid = False
        End If
    End If
End Function

Private Function ValidationString() As String
    Dim aStr As String
    
    aStr = "Make sure that all of the following have been addressed before saving: "
    aStr = aStr & vbCrLf & vbTab & "Study must have at least one authorized associate defined."
    aStr = aStr & vbCrLf & vbTab & "Study must have an Account Director defined."
    ' 03-26-2006 SH Added
    aStr = aStr & vbCrLf & vbTab & "# Months before archiving cannot be blank or 0."
    
    ValidationString = aStr
End Function

Private Sub SSTabStudyProperties_Click(PreviousTab As Integer)
    
    Select Case SSTabStudyProperties.Tab
        Case 3 'lvwcomparison
            cmdEditComparison.Enabled = False
            cmdDeleteComparison.Enabled = False
            
        Case 6 'lvwdeliverydates
            cmdEditDate.Enabled = False
            cmdDeleteDate.Enabled = False
            
        Case 7 'lvwreporttypes
            cmdEditReport.Enabled = False
            cmdDeleteReport.Enabled = False
        Case Else
        
    End Select
    
End Sub

Private Sub lvwComparison_ItemClick(ByVal Item As ComctlLib.ListItem)
    
    If blnViewOnly Then Exit Sub

    cmdEditComparison.Enabled = True
    cmdDeleteComparison.Enabled = True

End Sub

Private Sub lvwDeliveryDates_ItemClick(ByVal Item As ComctlLib.ListItem)
    
    If blnViewOnly Then Exit Sub
    
    cmdEditDate.Enabled = True
    cmdDeleteDate.Enabled = True

End Sub

Private Sub lvwReportTypes_ItemClick(ByVal Item As ComctlLib.ListItem)
    
    If blnViewOnly Then Exit Sub
    
    cmdEditReport.Enabled = True
    cmdDeleteReport.Enabled = True

End Sub

Private Sub SetCaption()
    
    Caption = "Properties for Study: " & G_Study.name

End Sub

Private Sub DisableAllControls()

'I DV 10/14/1999 - Added variable to help identify if we are in the
'I DV 10/14/1999 - view only mode.

    blnViewOnly = True
    
    '*Issue 234, Need to active scroll bars on the frames that have them.
    '    Can't just set enabled to false on those frames.  Going to have to disable them
    'individually.  Dan Wagner.
    'lock all the edit (text boxes) fields, DW
    editNumCopies.Enabled = False
    editAccountCode.Enabled = False
'D    editActionPlan.Enabled = False
    editActionPlan.Locked = True
    editActionPlan.ForeColor = &H80000011
    
    editArchiveMonths.Enabled = False
    editBBSPassword.Enabled = False
    editBBSUserName.Enabled = False
    editBudget.Enabled = False
    editConfidence.Enabled = False
    editContractEndDate.Enabled = False
    editContractStartDate.Enabled = False
    editCutOff.Enabled = False
    editEndDate.Enabled = False
    editErrorMargin.Enabled = False
    editNumCopies.Enabled = False
    editSignOffDate.Enabled = False
    editSpent.Enabled = False
'D    editStudyDescription.Enabled = False
    editStudyDescription.Locked = True
    editStudyDescription.ForeColor = &H80000011
    
    editStudyName.Enabled = False
    'lock all the radio buttons DW
    ' 03-14-2006 Deleted radio button SH
    'optOnGoing.Enabled = False
    'optPoingInTime.Enabled = False
    'lock all the radio buttons DW
    chkCheckPhone.Enabled = False
    chkCleanAddress.Enabled = False
    chkProperCase.Enabled = False
    chkNCOA.Enabled = False ' Added 10-31-2003 SH
    'lock all the Rich Text Box Controls, DW
'D    rtbDeliverableDesc.Enabled = False
'D    rtbObjective.Enabled = False
'D    rtbReportLevels.Enabled = False
'I DV 10/14/1999 - Changed to have the RichText fields uneditable,
'I DV 10/14/1999 - instead of disabled.  This will allow people to move
'I DV 10/14/1999 - around the scrollbars.
    rtbDeliverableDesc.Locked = True
    rtbObjective.Locked = True
    rtbReportLevels.Locked = True
    
    'Change the foreground font color to disabled for the list views
'    lvwAuthEmployees.ForeColor = &H80000011
    lvwComparison.ForeColor = &H80000011
    lvwDeliveryDates.ForeColor = &H80000011
    lvwReportTypes.ForeColor = &H80000011

    'lock all command buttons, DW
    cmdAddComparison.Enabled = False
    cmdAddDate.Enabled = False
    cmdAddReport.Enabled = False
    cmdApply.Enabled = False
    cmdAuthEmp.Enabled = False
    cmdDeleteComparison.Enabled = False
    cmdDeleteDate.Enabled = False
    cmdDeleteReport.Enabled = False
    cmdEditComparison.Enabled = False
    cmdEditDate.Enabled = False
    cmdEditReport.Enabled = False
    'disable all drop down lists, dw
    cmbAccountDirector.Enabled = False
'end of code edited for issue 234, DW

End Sub

Private Sub EnableAllControls()
    
    Me.FrameActionPlan.Enabled = True
    Me.FrameAuthorizedEmp.Enabled = True
    Me.FrameClientInfo.Enabled = True
    Me.FrameComparison.Enabled = True
    Me.FrameDeliveryDates.Enabled = True
    Me.FrameObjectives.Enabled = True
    Me.FrameReportTypes.Enabled = True
    Me.FrameStudyParam.Enabled = True

End Sub

'Private Sub cmdEditProperties_Click()
'
'    Set oLockData = New LockData.StudyProperties
'    bConcurrencyLock = oLockData.SetLock(G_Study.ID)
'
'    If bConcurrencyLock Then
'        Me.cmdOK.Enabled = True
'        Me.cmdApply.Enabled = True
'        Me.cmdCancel.Caption = "&Cancel"
'        EnableAllControls
'        cmdEditProperties.Enabled = False
'        objStudy.BeginEdit
'    Else
'        ' dont allow
'        Set oLockData = Nothing
'    End If
'
'
'End Sub

Public Property Let EditMode(aValue As Boolean)
    
    bConcurrencyLock = aValue

End Property
