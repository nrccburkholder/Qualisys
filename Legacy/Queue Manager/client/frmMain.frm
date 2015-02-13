VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   Caption         =   "Print Queue Manager"
   ClientHeight    =   7170
   ClientLeft      =   165
   ClientTop       =   555
   ClientWidth     =   8130
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7170
   ScaleWidth      =   8130
   StartUpPosition =   1  'CenterOwner
   WindowState     =   2  'Maximized
   Begin VB.CommandButton cmdPostal 
      Caption         =   "&Report Manager"
      Height          =   495
      Left            =   2280
      TabIndex        =   9
      Top             =   3960
      Visible         =   0   'False
      Width           =   1300
   End
   Begin VB.CommandButton cmdPrint 
      Caption         =   "&Print"
      Height          =   495
      Left            =   2280
      TabIndex        =   6
      Top             =   3360
      Width           =   1300
   End
   Begin VB.CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "&Close"
      Default         =   -1  'True
      Height          =   495
      Left            =   3720
      TabIndex        =   5
      Top             =   3360
      Width           =   1300
   End
   Begin VB.Frame fraProperties 
      Height          =   3255
      Left            =   2280
      TabIndex        =   4
      Top             =   0
      Width           =   2535
      Begin RichTextLib.RichTextBox txtProperties 
         Height          =   2415
         Left            =   120
         TabIndex        =   7
         TabStop         =   0   'False
         Top             =   240
         Width           =   3000
         _ExtentX        =   5292
         _ExtentY        =   4260
         _Version        =   393217
         BackColor       =   -2147483644
         BorderStyle     =   0
         Enabled         =   -1  'True
         HideSelection   =   0   'False
         ReadOnly        =   -1  'True
         DisableNoScroll =   -1  'True
         Appearance      =   0
         TextRTF         =   $"frmMain.frx":164A
      End
      Begin VB.Label lblBundlingDate 
         Alignment       =   1  'Right Justify
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   0
         TabIndex        =   8
         Top             =   3000
         Width           =   3000
      End
   End
   Begin VB.PictureBox picSplitter 
      BackColor       =   &H00808080&
      BorderStyle     =   0  'None
      FillColor       =   &H00808080&
      Height          =   4800
      Left            =   6000
      ScaleHeight     =   2090.126
      ScaleMode       =   0  'User
      ScaleWidth      =   780
      TabIndex        =   3
      Top             =   705
      Visible         =   0   'False
      Width           =   72
   End
   Begin ComctlLib.TreeView tvTreeView 
      Height          =   5175
      Left            =   0
      TabIndex        =   2
      Top             =   360
      Width           =   1650
      _ExtentX        =   2910
      _ExtentY        =   9128
      _Version        =   327682
      HideSelection   =   0   'False
      Indentation     =   0
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      ImageList       =   "imlIcons"
      Appearance      =   1
   End
   Begin VB.PictureBox picTitles 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   0
      ScaleHeight     =   300
      ScaleWidth      =   8130
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   0
      Width           =   8130
      Begin VB.Label lblTitle 
         BorderStyle     =   1  'Fixed Single
         Caption         =   " Print Queue:"
         Height          =   270
         Index           =   0
         Left            =   0
         TabIndex        =   1
         Tag             =   " TreeView:"
         Top             =   12
         Width           =   2016
      End
   End
   Begin MSComDlg.CommonDialog dlgCommonDialog 
      Left            =   1800
      Top             =   1080
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Image imgSplitter 
      Height          =   5145
      Left            =   1620
      MousePointer    =   9  'Size W E
      Top             =   345
      Width           =   60
   End
   Begin ComctlLib.ImageList imlIcons 
      Left            =   1680
      Top             =   1920
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   111
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":16CC
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1C1E
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":2170
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":26C2
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":2C14
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":3166
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":36B8
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":3C0A
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":415C
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":46AE
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":4C00
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":5152
            Key             =   ""
         EndProperty
         BeginProperty ListImage13 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":54A4
            Key             =   ""
         EndProperty
         BeginProperty ListImage14 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":57F6
            Key             =   ""
         EndProperty
         BeginProperty ListImage15 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":5B48
            Key             =   ""
         EndProperty
         BeginProperty ListImage16 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":5E62
            Key             =   ""
         EndProperty
         BeginProperty ListImage17 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":63A4
            Key             =   ""
         EndProperty
         BeginProperty ListImage18 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":66BE
            Key             =   ""
         EndProperty
         BeginProperty ListImage19 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":6A10
            Key             =   ""
         EndProperty
         BeginProperty ListImage20 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":6D62
            Key             =   ""
         EndProperty
         BeginProperty ListImage21 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":70B4
            Key             =   ""
         EndProperty
         BeginProperty ListImage22 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":7406
            Key             =   ""
         EndProperty
         BeginProperty ListImage23 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":7758
            Key             =   ""
         EndProperty
         BeginProperty ListImage24 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":7AAA
            Key             =   ""
         EndProperty
         BeginProperty ListImage25 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":7DFC
            Key             =   ""
         EndProperty
         BeginProperty ListImage26 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":814E
            Key             =   ""
         EndProperty
         BeginProperty ListImage27 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":84A0
            Key             =   ""
         EndProperty
         BeginProperty ListImage28 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":87F2
            Key             =   ""
         EndProperty
         BeginProperty ListImage29 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":8B44
            Key             =   ""
         EndProperty
         BeginProperty ListImage30 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":8E96
            Key             =   ""
         EndProperty
         BeginProperty ListImage31 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":91E8
            Key             =   ""
         EndProperty
         BeginProperty ListImage32 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":953A
            Key             =   ""
         EndProperty
         BeginProperty ListImage33 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":988C
            Key             =   ""
         EndProperty
         BeginProperty ListImage34 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":9BDE
            Key             =   ""
         EndProperty
         BeginProperty ListImage35 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":9F30
            Key             =   ""
         EndProperty
         BeginProperty ListImage36 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":A282
            Key             =   ""
         EndProperty
         BeginProperty ListImage37 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":A5D4
            Key             =   ""
         EndProperty
         BeginProperty ListImage38 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":A926
            Key             =   ""
         EndProperty
         BeginProperty ListImage39 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":AC78
            Key             =   ""
         EndProperty
         BeginProperty ListImage40 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":AFCA
            Key             =   ""
         EndProperty
         BeginProperty ListImage41 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":B0DC
            Key             =   ""
         EndProperty
         BeginProperty ListImage42 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":B1EE
            Key             =   ""
         EndProperty
         BeginProperty ListImage43 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":B540
            Key             =   ""
         EndProperty
         BeginProperty ListImage44 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":B892
            Key             =   ""
         EndProperty
         BeginProperty ListImage45 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":BBE4
            Key             =   ""
         EndProperty
         BeginProperty ListImage46 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":BF36
            Key             =   ""
         EndProperty
         BeginProperty ListImage47 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":C288
            Key             =   ""
         EndProperty
         BeginProperty ListImage48 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":C5DA
            Key             =   ""
         EndProperty
         BeginProperty ListImage49 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":C92C
            Key             =   ""
         EndProperty
         BeginProperty ListImage50 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":CC7E
            Key             =   ""
         EndProperty
         BeginProperty ListImage51 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":CFD0
            Key             =   ""
         EndProperty
         BeginProperty ListImage52 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":D322
            Key             =   ""
         EndProperty
         BeginProperty ListImage53 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":D674
            Key             =   ""
         EndProperty
         BeginProperty ListImage54 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":D9C6
            Key             =   ""
         EndProperty
         BeginProperty ListImage55 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":DD18
            Key             =   ""
         EndProperty
         BeginProperty ListImage56 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":E06A
            Key             =   ""
         EndProperty
         BeginProperty ListImage57 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":E3BC
            Key             =   ""
         EndProperty
         BeginProperty ListImage58 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":E70E
            Key             =   ""
         EndProperty
         BeginProperty ListImage59 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":EA60
            Key             =   ""
         EndProperty
         BeginProperty ListImage60 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":EDB2
            Key             =   ""
         EndProperty
         BeginProperty ListImage61 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":F104
            Key             =   ""
         EndProperty
         BeginProperty ListImage62 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":F456
            Key             =   ""
         EndProperty
         BeginProperty ListImage63 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":F7A8
            Key             =   ""
         EndProperty
         BeginProperty ListImage64 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":FAFA
            Key             =   ""
         EndProperty
         BeginProperty ListImage65 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":FE4C
            Key             =   ""
         EndProperty
         BeginProperty ListImage66 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1019E
            Key             =   ""
         EndProperty
         BeginProperty ListImage67 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":104F0
            Key             =   ""
         EndProperty
         BeginProperty ListImage68 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":10842
            Key             =   ""
         EndProperty
         BeginProperty ListImage69 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":10B94
            Key             =   ""
         EndProperty
         BeginProperty ListImage70 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":10EE6
            Key             =   ""
         EndProperty
         BeginProperty ListImage71 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":11238
            Key             =   ""
         EndProperty
         BeginProperty ListImage72 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1158A
            Key             =   ""
         EndProperty
         BeginProperty ListImage73 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":118DC
            Key             =   ""
         EndProperty
         BeginProperty ListImage74 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":11C2E
            Key             =   ""
         EndProperty
         BeginProperty ListImage75 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":11F80
            Key             =   ""
         EndProperty
         BeginProperty ListImage76 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":122D2
            Key             =   ""
         EndProperty
         BeginProperty ListImage77 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":12624
            Key             =   ""
         EndProperty
         BeginProperty ListImage78 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":12976
            Key             =   ""
         EndProperty
         BeginProperty ListImage79 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":12CC8
            Key             =   ""
         EndProperty
         BeginProperty ListImage80 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1301A
            Key             =   ""
         EndProperty
         BeginProperty ListImage81 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1336C
            Key             =   ""
         EndProperty
         BeginProperty ListImage82 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":136BE
            Key             =   ""
         EndProperty
         BeginProperty ListImage83 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":13A10
            Key             =   ""
         EndProperty
         BeginProperty ListImage84 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":13D62
            Key             =   ""
         EndProperty
         BeginProperty ListImage85 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":140B4
            Key             =   ""
         EndProperty
         BeginProperty ListImage86 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":14406
            Key             =   ""
         EndProperty
         BeginProperty ListImage87 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":14758
            Key             =   ""
         EndProperty
         BeginProperty ListImage88 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":14AAA
            Key             =   ""
         EndProperty
         BeginProperty ListImage89 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":14DFC
            Key             =   ""
         EndProperty
         BeginProperty ListImage90 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1514E
            Key             =   ""
         EndProperty
         BeginProperty ListImage91 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":154A0
            Key             =   ""
         EndProperty
         BeginProperty ListImage92 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":157F2
            Key             =   ""
         EndProperty
         BeginProperty ListImage93 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":15B44
            Key             =   ""
         EndProperty
         BeginProperty ListImage94 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":15E96
            Key             =   ""
         EndProperty
         BeginProperty ListImage95 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":161E8
            Key             =   ""
         EndProperty
         BeginProperty ListImage96 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1653A
            Key             =   ""
         EndProperty
         BeginProperty ListImage97 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1688C
            Key             =   ""
         EndProperty
         BeginProperty ListImage98 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":16BDE
            Key             =   ""
         EndProperty
         BeginProperty ListImage99 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":16F30
            Key             =   ""
         EndProperty
         BeginProperty ListImage100 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":17282
            Key             =   ""
         EndProperty
         BeginProperty ListImage101 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":175D4
            Key             =   ""
         EndProperty
         BeginProperty ListImage102 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":17926
            Key             =   ""
         EndProperty
         BeginProperty ListImage103 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":17C78
            Key             =   ""
         EndProperty
         BeginProperty ListImage104 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":17FCA
            Key             =   ""
         EndProperty
         BeginProperty ListImage105 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1831C
            Key             =   ""
         EndProperty
         BeginProperty ListImage106 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":1866E
            Key             =   ""
         EndProperty
         BeginProperty ListImage107 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":189C0
            Key             =   ""
         EndProperty
         BeginProperty ListImage108 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":18D12
            Key             =   ""
         EndProperty
         BeginProperty ListImage109 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":19064
            Key             =   ""
         EndProperty
         BeginProperty ListImage110 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":193B6
            Key             =   ""
         EndProperty
         BeginProperty ListImage111 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":19708
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuTreeViewPopUp 
      Caption         =   "TreeViewPopUp"
      Visible         =   0   'False
      Begin VB.Menu mnuRollbackGen 
         Caption         =   "&Rollback Generation"
      End
      Begin VB.Menu mnuPopUpPrint 
         Caption         =   "&Print"
      End
      Begin VB.Menu mnuPrintSample 
         Caption         =   "View S&ample"
         Begin VB.Menu mnuPrintSampleAllPagesInOneFile 
            Caption         =   "&All Pages in One File"
         End
         Begin VB.Menu mnuPrintSampleOneFilePerPage 
            Caption         =   "&One File per Page"
         End
      End
      Begin VB.Menu mnuAddToGroupedPrint 
         Caption         =   "&Add to Grouped Print"
      End
      Begin VB.Menu mnuBundlingReport 
         Caption         =   "&Bundling Report"
      End
      Begin VB.Menu mnuPostOfficeReport 
         Caption         =   "Post &Office Report"
      End
      Begin VB.Menu mnuPopUpDelete 
         Caption         =   "&Delete"
         Visible         =   0   'False
      End
      Begin VB.Menu mnuMailingDates 
         Caption         =   "&Set Mailing Dates"
         Visible         =   0   'False
      End
      Begin VB.Menu mnuPopupMarkMailing 
         Caption         =   "Mark for &Mailing"
         Visible         =   0   'False
      End
      Begin VB.Menu mnuBundleFlats 
         Caption         =   "Bundle for &Flats"
         Visible         =   0   'False
      End
      Begin VB.Menu mnuRemoveFromGroupedPrint 
         Caption         =   "Remove &from Grouped Print"
      End
   End
   Begin VB.Menu mnuModify 
      Caption         =   "&Modify Items"
      Begin VB.Menu mnuPrint 
         Caption         =   "&Print"
         Shortcut        =   ^P
      End
      Begin VB.Menu mnuDelete 
         Caption         =   "&Delete"
         Shortcut        =   {DEL}
         Visible         =   0   'False
      End
      Begin VB.Menu mnuSeparater2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuBundle 
         Caption         =   "&Bundle"
      End
      Begin VB.Menu mnuSeperator 
         Caption         =   "-"
         Index           =   0
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuReprint 
         Caption         =   "View &Mailing Queue"
         Shortcut        =   ^Q
      End
      Begin VB.Menu mnuSeperator3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuRefresh 
         Caption         =   "&Refresh"
      End
   End
   Begin VB.Menu mnuMailRoom 
      Caption         =   "Mail &Room Support"
      Begin VB.Menu mnuCallList 
         Caption         =   "&Call List"
      End
      Begin VB.Menu mnuReprintList 
         Caption         =   "&Reprint List"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      NegotiatePosition=   3  'Right
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuAboutBox 
         Caption         =   "About &Box"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     11-30-2004  SH      Added Rollback Generation in the menu bar
'\\                         so that users can roll back the generation
'\\                         for a specific survey, bundle code and
'\\                         date.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Option Explicit
  
    Private mbReprint As Boolean
    Private mbTreeSel As Boolean
    Private mbListSel As Boolean
    Private mbActivated As Boolean
    Private mbMoving As Boolean
    Private mlUniqueKey As Long
    Private msUserName As String ' 11-30-2004 SH added - needs in Rollback Generation
    Private moQueueManager As QueueManDLL.clsQueueManager
    Private mvStartLitho As Variant
    Private mvEndLitho As Variant

    Private Const mknSplitLimit = 5250

    Private mlButtonUsed As Long

Public Sub CheckQueue()
    
    Dim oProjectNode As Node
    Dim vHospitalQueue As Variant
    Dim sProperties As String
    Dim lImageIndex As Long
    Dim lNodeIndex As Long
    Dim lQueueCnt As Long
    Dim bIsEmpty As Boolean
    Dim iHospital As Integer
    Dim iOffset As Integer
    
    'On Error GoTo EmptyQueue
    MousePointer = vbHourglass
    
    txtProperties.TextRTF = "{ "
    txtProperties.TextRTF = txtProperties.Text & "{\ul \b \qc \cell \fs25 Showing available configurations... }"
    txtProperties.TextRTF = txtProperties.Text & "{ \b \qc \line \fs20 \line \line }"
    txtProperties.TextRTF = txtProperties.Text & " }"
    DoEvents
    vHospitalQueue = moQueueManager.Clients(mbReprint)
    'vHospitalQueue(0,lQueueCnt) = Client_nm
    'vHospitalQueue(1,lQueueCnt) = Survey_nm
    'vHospitalQueue(2,lQueueCnt) = Survey_id
    'vHospitalQueue(3,lQueueCnt) = Survey_Type
    'vHospitalQueue(4,lQueueCnt) = numPieces
    'vHospitalQueue(5,lQueueCnt) = numPrinted
    'vHospitalQueue(6,lQueueCnt) = numMailed
    'vHospitalQueue(7,lQueueCnt) = numInGroupedPrint
        
    'Get the date that bundling was last run
    If mnuReprint.Caption = "View &Mailing Queue" Then
        lblBundlingDate.Caption = "Last Bundling Date: " & _
        Format(moQueueManager.GetLastBundleDate, "mm/dd/yyyy hh:nn:ss AM/PM")
    End If
    
    bIsEmpty = True
    If Not IsEmpty(vHospitalQueue) Then
        bIsEmpty = False
        For lQueueCnt = 0 To UBound(vHospitalQueue, 2)
            iOffset = 0
            iOffset = IIf(UCase(Left(vHospitalQueue(3, lQueueCnt), 6)) = "HCAHPS", OffsetHCAHPS, iOffset)
            iOffset = IIf(UCase(Left(vHospitalQueue(3, lQueueCnt), 11)) = "HOME HEALTH", OffsetHHCAHPS, iOffset)
            iOffset = IIf(UCase(Left(vHospitalQueue(3, lQueueCnt), 8)) = "ACOCAHPS", OffsetACOCAHPS, iOffset)
            iOffset = IIf(UCase(Left(vHospitalQueue(3, lQueueCnt), 8)) = "ICHCAHPS", OffsetICHCAHPS, iOffset)
            iOffset = IIf(UCase(Left(vHospitalQueue(3, lQueueCnt), 7)) = "HOSPICE", OffsetHOSPICE, iOffset)
            iHospital = conHospital + iOffset
            ' I am hold the description of the node in the
            ' key value of the node.  this is what is
            ' displayed when clicked on in the tree
            sProperties = "{\ul \b \pard \qc " & Trim(vHospitalQueue(0, lQueueCnt)) & " (" & Trim(vHospitalQueue(1, lQueueCnt)) & " - " & vHospitalQueue(2, lQueueCnt) & ")" & " \ulnone \par}"
            'sProperties = sProperties & "{ \cell \ql Number of pieces: \tab \cell #PAGES \par }"
            sProperties = sProperties & " }"
            ' This last part is to ensure the uniqueness of the key value
            mlUniqueKey = mlUniqueKey + 1
            sProperties = sProperties & mlUniqueKey
            If mbReprint Then
                lImageIndex = IIf(vHospitalQueue(6, lQueueCnt) = vHospitalQueue(4, lQueueCnt), _
                                iHospital + CheckedHospital, _
                                iHospital)
            Else
                lImageIndex = IIf(vHospitalQueue(7, lQueueCnt) = vHospitalQueue(4, lQueueCnt), _
                                iHospital + CheckedHospital, _
                                iHospital)
            End If
            
            Set oProjectNode = tvTreeView.Nodes.Add(, , sProperties, Trim(vHospitalQueue(0, lQueueCnt)) & " (" & Trim(vHospitalQueue(1, lQueueCnt)) & _
                                                    " - " & vHospitalQueue(2, lQueueCnt) & ")", lImageIndex)
            ' 08-12-1999 DV
            ' We will only get one level, and let the clicks to the rest.
            ' However, we need to know the study id, which we are going to
            ' store as the first child (which will eventually get deleted).
            Set oProjectNode = tvTreeView.Nodes.Add(oProjectNode, tvwChild, "QUERY=" & vHospitalQueue(2, lQueueCnt), "")
            'CheckConfiguration oProjectNode, vHospitalQueue(2, lQueueCnt) ' D
        Next lQueueCnt
    End If
     
    vHospitalQueue = moQueueManager.GroupedPrintList(mbReprint)
    'vHospitalQueue(0,lQueueCnt) = survey_id
    'vHospitalQueue(1,lQueueCnt) = paperconfig_id
    'vHospitalQueue(2,lQueueCnt) = datBundled (for print queue) or datPrinted (for mail queue)
    'vHospitalQueue(3,lQueueCnt) = Client_nm
    'vHospitalQueue(4,lQueueCnt) = Survey_nm
    'vHospitalQueue(5,lQueueCnt) = paperconfig_nm
    'vHospitalQueue(6,lQueueCnt) = surveytype
    'vHospitalQueue(7,lQueueCnt) = number of pieces
    'vHospitalQueue(8,lQueueCnt) = datMailed

    If Not IsEmpty(vHospitalQueue) Then
        bIsEmpty = False
        'add the 'Grouped Print' node
        lNodeIndex = FindNodeByKey("GroupedPrint")
        If lNodeIndex = -1 Then
            Set oProjectNode = tvTreeView.Nodes.Add(, , "GroupedPrint", "Grouped Print", conGroupedPrint)
        End If
        
        For lQueueCnt = 0 To UBound(vHospitalQueue, 2)
            iOffset = 0
            iOffset = IIf(UCase(Left(vHospitalQueue(6, lQueueCnt), 6)) = "HCAHPS", OffsetHCAHPS, iOffset)
            iOffset = IIf(UCase(Left(vHospitalQueue(6, lQueueCnt), 11)) = "HOME HEALTH", OffsetHHCAHPS, iOffset)
            iOffset = IIf(UCase(Left(vHospitalQueue(6, lQueueCnt), 8)) = "ACOCAHPS", OffsetACOCAHPS, iOffset)
            iOffset = IIf(UCase(Left(vHospitalQueue(6, lQueueCnt), 8)) = "ICHCAHPS", OffsetICHCAHPS, iOffset)
            iOffset = IIf(UCase(Left(vHospitalQueue(6, lQueueCnt), 7)) = "HOSPICE", OffsetHOSPICE, iOffset)
            iHospital = conHospital + iOffset
            'add the paperconfig node if it isn't already there
            'key is defined by paperconfig_id (plus datPrinted for the mail queue)
            lNodeIndex = FindNodeByKey("GroupedPrintConfig=" & Trim(vHospitalQueue(1, lQueueCnt)) & IIf(mbReprint, vbTab & vHospitalQueue(2, lQueueCnt), ""))
            If lNodeIndex = -1 Then
                lImageIndex = IIf(vHospitalQueue(8, lQueueCnt) < #1/1/4000#, _
                                    iHospital + CheckedConfiguration, _
                                    iHospital + GroupedPrintConfiguration)
                Set oProjectNode = tvTreeView.Nodes.Add(tvTreeView.Nodes("GroupedPrint"), tvwChild, "GroupedPrintConfig=" & _
                                                        Trim(vHospitalQueue(1, lQueueCnt)) & IIf(mbReprint, vbTab & vHospitalQueue(2, lQueueCnt), ""), _
                                                        Trim(IIf(mbReprint, vHospitalQueue(2, lQueueCnt) & " ", "") & vHospitalQueue(5, lQueueCnt)), lImageIndex)
                oProjectNode.Tag = vHospitalQueue(7, lQueueCnt)
            Else
                tvTreeView.Nodes(lNodeIndex).Tag = tvTreeView.Nodes(lNodeIndex).Tag + vHospitalQueue(7, lQueueCnt)
            End If
            
            'add the detail node
            sProperties = "{\ul \b \pard \qc " & Trim(vHospitalQueue(3, lQueueCnt)) & " (" & Trim(vHospitalQueue(4, lQueueCnt)) & " - " & vHospitalQueue(0, lQueueCnt) & ")" & " \ulnone \par}"
            sProperties = sProperties & "{ \cell \ql Number of pieces: \tab \cell " & vHospitalQueue(7, lQueueCnt) & " \par }"
            sProperties = sProperties & " }"
            mlUniqueKey = mlUniqueKey + 1
            sProperties = sProperties & mlUniqueKey
            lImageIndex = IIf(vHospitalQueue(8, lQueueCnt) < #1/1/4000#, _
                                iHospital + CheckedGroupedPrintHospital, _
                                iHospital + GroupedPrintHospital)
            Set oProjectNode = tvTreeView.Nodes.Add(tvTreeView.Nodes("GroupedPrintConfig=" & _
                                                    Trim(vHospitalQueue(1, lQueueCnt)) & IIf(mbReprint, vbTab & vHospitalQueue(2, lQueueCnt), "")), _
                                                    tvwChild, "GroupedPrintItem=" & sProperties, vHospitalQueue(3, lQueueCnt) & _
                                                    " (" & vHospitalQueue(4, lQueueCnt) & " - " & vHospitalQueue(0, lQueueCnt) & ")", lImageIndex)
            'oProjectNode.Tag = vHospitalQueue(0, lQueueCnt) & vbTab & vHospitalQueue(1, lQueueCnt) & vbTab & vHospitalQueue(2, lQueueCnt) & vbTab & vHospitalQueue(7, lQueueCnt)
            oProjectNode.Tag = vHospitalQueue(0, lQueueCnt) & vbTab & vHospitalQueue(1, lQueueCnt) & vbTab & vHospitalQueue(2, lQueueCnt) & vbTab & vHospitalQueue(6, lQueueCnt) & vbTab & vHospitalQueue(7, lQueueCnt)
            If vHospitalQueue(8, lQueueCnt) < #1/1/4000# Then oProjectNode.Tag = oProjectNode.Tag & vbTab & vHospitalQueue(8, lQueueCnt)
        Next lQueueCnt
    End If
                
    If bIsEmpty Then
        MsgBox "The Queue is Empty!", vbOKOnly, "Empty Queue"
        mnuPrint.Enabled = False
        mnuAbout_Click
    Else
        ' 08-12-1999 DV - Show the first node in the hierarchy by default
        tvTreeView.Nodes.Item(1).Root.Selected = True
        ButtonUsed = 1
        ShowProperties tvTreeView.Nodes(1)
    End If
    
    txtProperties.TextRTF = ""
    MousePointer = vbNormal
    
    Exit Sub
    
    
EmptyQueue:
    MsgBox "The Queue is unavailable because: " & Chr(10) & vbTab & Err.Description & "!", vbOKOnly, "Empty Queue"
    mnuPrint.Enabled = False
    mnuAbout_Click
    MousePointer = vbNormal
    
End Sub

Public Sub ClearTree()
    tvTreeView.Nodes.Clear
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   ShowProperties
'\\
'\\ Created By:     X
'\\         Date:   X
'\\
'\\ Description:    This routine updates the properties displayed for
'\\                 the specified Node of the TreeView.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     nodSelected     Node    The node for which the properties are to
'\\                             be updated and displayed on the screen.
'\\ Revisions:
'\\     Date        By      Description
'\\     03-31-00    JJF     Removed a call to DoEvents that was causing
'\\                         a re-entrancy problem that stopped the tree
'\\                         from being properly refreshed if the user
'\\                         tried to expand a node before the last one
'\\                         was complete.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub ShowProperties(nodSelected As Node)
    ' 08-12-1999 DV
    ' Added code to expand the children of the selected
    ' node, if the first child of that node starts with QUERY=
    
    Dim strStudy_id As String
    Dim strKey As String
    Dim lngBundleCount As Long
    Dim strProperties As String
    Dim oldmouse As Integer
    Dim strConfig_id As String
    Dim strBundled As String
    Dim n As Long
    
    'On Error GoTo Skip
    
    oldmouse = Screen.MousePointer
    frmMain.MousePointer = vbHourglass
    'DoEvents   '** Removed 03-31-00 JJF

    txtProperties.TextRTF = "{ "
    Select Case nodSelected.Image Mod TotalStates
        Case Hospital, CheckedHospital:
            strKey = nodSelected.Child.Key
            If InStr(1, strKey, "QUERY=", vbTextCompare) > 0 And ButtonUsed < 0 Then
                CheckConfiguration nodSelected, Mid(strKey, 7)
                tvTreeView.Nodes.Remove nodSelected.Child.Index
            End If
            txtProperties.TextRTF = txtProperties.Text & nodSelected.Key
        Case Configuration, FadedConfiguration, CheckedConfiguration:
            If nodSelected.Child Is Nothing Then
              strKey = ""
            Else
              strKey = nodSelected.Child.Key
            End If
            If InStr(1, strKey, "QUERY=", vbTextCompare) > 0 And ButtonUsed < 0 Then
                strKey = Mid(strKey, 7)
                strStudy_id = NextValue(strKey, "|")
                strConfig_id = NextValue(strKey, "|")
                strBundled = NextValue(strKey, "|")
                lngBundleCount = CheckBundleId(nodSelected, strStudy_id, strConfig_id, strBundled)
                strProperties = nodSelected.Key & "{ \cell \ql Number of Bundles: \tab \cell " & lngBundleCount & " \par }"
                strProperties = strProperties & " }"
                ' This last part is to ensure the uniqueness of the key value
                mlUniqueKey = mlUniqueKey + 1
                strProperties = strProperties & mlUniqueKey
                nodSelected.Key = strProperties
                tvTreeView.Nodes.Remove nodSelected.Child.Index
            End If
            txtProperties.TextRTF = txtProperties.Text & nodSelected.Key
        Case Bundle, MailBundle, AlreadyMailed:
            txtProperties.TextRTF = txtProperties.Text & nodSelected.Key
        Case Printing:
            txtProperties.TextRTF = txtProperties.Text & "{\par \qc Printing... \par \line } " & nodSelected.Key
        Case Deleted:
            txtProperties.TextRTF = txtProperties.Text & "{\par \qc Deleting... \par \line } " & nodSelected.Key
        Case GroupedPrintHospital:
            txtProperties.TextRTF = txtProperties.Text & Mid(nodSelected.Key, InStr(nodSelected.Key, "=") + 1)
        Case CheckedGroupedPrintHospital:
            txtProperties.TextRTF = txtProperties.Text & Mid(nodSelected.Key, InStr(nodSelected.Key, "=") + 1)
            strKey = nodSelected.Tag
            strStudy_id = NextValue(strKey, vbTab)
            strConfig_id = NextValue(strKey, vbTab)
            strBundled = NextValue(strKey, vbTab)
            lngBundleCount = NextValue(strKey, vbTab)
            txtProperties.TextRTF = txtProperties.Text & "mailed on " & strKey
        Case GroupedPrintConfiguration:
            txtProperties.TextRTF = nodSelected.Text & vbCrLf & "Number of pieces: " & nodSelected.Tag
        'Case conBundle:
        '   txtProperties.TextRTF = txtProperties.Text & "{ \cell \ql Number of pieces: \tab \cell " & nodSelected.Image & " \par }"
        'Case Else:
        '   txtProperties.TextRTF = txtProperties.Text & nodSelected.Key
    End Select
Skip:
    frmMain.MousePointer = oldmouse
    On Error GoTo 0
End Sub

Private Sub CheckConfiguration(nodParent As Node, ByVal lngSurveyId As Long)
    Dim n, X As Long
    Dim nodConfiguration As Node
    Dim varConfiguration As Variant
    Dim strProperties As String
    Dim lngBundleCount As Long
    
    varConfiguration = moQueueManager.Configurations(mbReprint, lngSurveyId)
    'varConfiguration(0,X)=datBundled Paperconfig_nm
    'varConfiguration(1,X)=paperconfig_id
    'varConfiguration(2,X)=intPages
    'varConfiguration(3,X)=study_id
    'varConfiguration(4,X)=Survey_id
    'varConfiguration(5,X)=Count
    'varConfiguration(6,X)=numMailed
    'varConfiguration(7,X)=datMailed
    
    If Not IsEmpty(varConfiguration) Then
        For X = 0 To UBound(varConfiguration, 2)
            ' I am hold the description of the node in the
            ' key value of the node.  this is what is
            ' displayed when clicked on in the tree
            strProperties = "{\ul \b \pard \qc " & varConfiguration(0, X) & " \ulnone \par}"
            strProperties = strProperties & "{ \cell \ql Number of pieces: \tab \cell " & varConfiguration(5, X) & " \par }"
            '** Modified 09-19-02 JJF
            'strProperties = strProperties & " }"
            strProperties = strProperties & " }" & lngSurveyId
            '** End of modification 09-19-02 JJF
            lngBundleCount = IIf(varConfiguration(6, X) = varConfiguration(5, X), _
                             (nodParent.Image \ TotalStates) * TotalStates + CheckedConfiguration, _
                             (nodParent.Image \ TotalStates) * TotalStates + Configuration)
            Set nodConfiguration = tvTreeView.Nodes.Add(nodParent, tvwChild, strProperties, varConfiguration(0, X), lngBundleCount)
            strProperties = varConfiguration(4, X) & vbTab & varConfiguration(1, X) & vbTab & Trim(Left(varConfiguration(0, X), InStr(varConfiguration(0, X), "  "))) & vbTab & varConfiguration(5, X)
            n = FindNodeByTag(strProperties)
            nodConfiguration.Tag = strProperties
            If varConfiguration(7, X) <> #1/1/4000# Then _
                nodConfiguration.Tag = strProperties & vbTab & varConfiguration(7, X)
            If n > -1 Then
                nodConfiguration.Key = Mid(tvTreeView.Nodes(n).Key, 18)
                nodConfiguration.Image = (nodConfiguration.Image \ TotalStates) * TotalStates + FadedConfiguration
            Else
                ' 08-12-1999 DV
                ' We will only get one level, and let the clicks to the rest.
                ' However, we need to know the study id, which we are going to
                ' store as the first child (which will eventually get deleted).
                If Left(varConfiguration(0, X), InStr(varConfiguration(0, X), "  ")) <> "(unbundled) " Then
                  Set nodConfiguration = tvTreeView.Nodes.Add(nodConfiguration, tvwChild, "QUERY=" & _
                                         lngSurveyId & "|" & varConfiguration(1, X) & "|" & _
                                         Left(varConfiguration(0, X), InStr(varConfiguration(0, X), "  ")), "")
                End If
            End If
        Next X
    End If
End Sub

Private Sub DeleteConfiguration(nodSelected As Node)
    Dim X As Long
    Dim AnotherNode As Node
    
    nodSelected.Image = (nodSelected.Image \ TotalStates) * TotalStates + Deleted
    Set AnotherNode = nodSelected.Child
    For X = 1 To nodSelected.Children
        DeleteBundleId AnotherNode
        Set AnotherNode = AnotherNode.Next
    Next X
End Sub

Private Sub UnDeleteConfiguration(nodSelected As Node)
    Dim X As Long
    Dim AnotherNode As Node
    
    nodSelected.Image = (nodSelected.Image \ TotalStates) * TotalStates + Configuration
    Set AnotherNode = nodSelected.Child
    For X = 1 To nodSelected.Children
        UnDeleteBundleId AnotherNode
        Set AnotherNode = AnotherNode.Next
    Next X
End Sub

Private Function CheckBundleId(nodParent As Node, ByVal lngSurveyId As Long, ByVal lngPaperConfig As Long, ByVal strBundled As String) As Long
    Dim X As Long
    Dim nodBundle As Node
    Dim strProperties As String
    Dim varBundle As Variant
    Dim varLithoRange As Variant
    
    varBundle = moQueueManager.PaperConfig(mbReprint, lngSurveyId, lngPaperConfig, strBundled)
    'varBundle(0,X)=strBundle
    'varBundle(1,X)=Count
    'varBundle(2,X)=Survey_id
    'varBundle(3,X)=paperconfig_id
    'varBundle(4,X)=intpages
    'varBundle(5,X)=Count
    'varBundle(6,X)=bitLetterhead
    'varBundle(7,X)=datbundled
    'varBundle(8,X)=datMailed
    
    If Not IsEmpty(varBundle) Then
        For X = 0 To UBound(varBundle, 2)
            ' I am hold the description of the node in the
            ' key value of the node.  this is what is
            ' displayed when clicked on in the tree
            strProperties = "{\ul \b \pard \qc " & varBundle(0, X) & " \ulnone \par}"
            If Not IsNull(varBundle(8, X)) Then
                strProperties = strProperties & "{ \ul \b \pard \qc This bundle was mailed on " & varBundle(8, X) & " \ulnone \par}"
            End If
            strProperties = strProperties & "{ \cell \ql Number of pieces: \tab \cell " & varBundle(5, X) & " \par }"
            strProperties = strProperties & "{ \cell \ql Use Letter Head: \tab \cell " & IIf(varBundle(6, X) = "1", "Yes", "No") & " \par }"
            If frmMain.Caption = "Mailing Queue Manager" Then
                varLithoRange = moQueueManager.LithoRange(IIf(IsNull(varBundle(0, X)), " ", varBundle(0, X)), lngSurveyId, lngPaperConfig, strBundled)
                If IsEmpty(varLithoRange) Then
                    strProperties = strProperties & "{ \cell \ql LithoCode Range: \tab \cell UnAssigned \par }"
                Else
                    If Not Trim(varLithoRange(0, 0)) = "" Then
                        If Val(varLithoRange(0, 0)) > Val(varLithoRange(1, 0)) Then
                            mvStartLitho = varLithoRange(1, 0)
                            mvEndLitho = varLithoRange(0, 0)
                        Else
                            mvStartLitho = varLithoRange(0, 0)
                            mvEndLitho = varLithoRange(1, 0)
                        End If
                        strProperties = strProperties & "{ \cell \ql LithoCode Range: \tab \cell " & mvStartLitho & " to " & mvEndLitho & " \par }"
                    Else
                        strProperties = strProperties & "{ \cell \ql LithoCode Range: \tab \cell UnAssigned \par }"
                    End If
                End If
            Else
                strProperties = strProperties & "{ \cell \ql LithoCode Range: \tab \cell UnAssigned \par }"
            End If
            strProperties = strProperties & " }"
            ' This last part is for idenntifying the bundle
            ' in the database for printing and deleteing
            mlUniqueKey = mlUniqueKey + 1
            strProperties = strProperties & mlUniqueKey
            Set nodBundle = tvTreeView.Nodes.Add(nodParent, tvwChild, strProperties, _
                                                 IIf(IsNull(varBundle(0, X)), "Not Bundled", varBundle(0, X)), _
                                                 IIf(IsNull(varBundle(8, X)), (nodParent.Image \ TotalStates) * TotalStates + Bundle, _
                                                     (nodParent.Image \ TotalStates) * TotalStates + AlreadyMailed))
            nodBundle.Tag = varBundle(2, X) & vbTab & varBundle(0, X) & vbTab & varBundle(3, X) & _
                            vbTab & varBundle(4, X) & vbTab & mvStartLitho & vbTab & mvEndLitho & vbTab & _
                            varBundle(7, X) & vbTab & IIf(IsNull(varBundle(8, X)), "Not Mailed", varBundle(8, X))
        Next X
    End If
    CheckBundleId = X
End Function

Private Sub DeleteBundleId(nodSelected As Node)
    nodSelected.Image = (nodSelected.Image \ TotalStates) * TotalStates + Deleted
End Sub

Private Sub UnDeleteBundleId(nodSelected As Node)
    nodSelected.Image = (nodSelected.Image \ TotalStates) * TotalStates + Bundle
End Sub

Public Sub LaunchReport(TypeOfReport As String)
    Shell ("reportmgr.exe")
End Sub

Private Sub cmdBundling_Click()
    Call LaunchReport("Bundling")
End Sub

Private Sub cmdPostal_Click()
    Call LaunchReport("Post Office")
End Sub

Private Sub cmdPrint_Click()
    On Error GoTo BadSelection
    If (tvTreeView.SelectedItem.Image Mod TotalStates <> Hospital) And _
        (tvTreeView.SelectedItem.Image Mod TotalStates <> CheckedHospital) Then
        mnuPrint_Click
    Else
BadSelection:
        MsgBox "You cannot print from this level.", vbInformation, "Queue Manager Warning"
        'Call BundleLevelPrint
    End If
End Sub

Private Sub Form_Activate()
    ' Make sure this only runs when the program first loads.
    If Not mbActivated Then
'        CheckQueue
'        mbActivated = True
    End If
End Sub

Private Sub mnuAboutBox_Click()
    frmAbout.Show vbModal
End Sub

Private Function FindNodeByKey(ByRef KeyVal As String) As Long
    Dim n As Long
    n = 1
    While n <= tvTreeView.Nodes.Count
        If tvTreeView.Nodes(n).Key = KeyVal Then
            FindNodeByKey = n
            Exit Function
        End If
        n = n + 1
    Wend
    FindNodeByKey = -1
End Function

Private Function FindNodeByTag(ByRef TagVal As String) As Long
    Dim n As Long
    n = 1
    While n <= tvTreeView.Nodes.Count
        If tvTreeView.Nodes(n).Tag = TagVal Then
            FindNodeByTag = n
            Exit Function
        End If
        n = n + 1
    Wend
    FindNodeByTag = -1
End Function


Private Sub mnuAddToGroupedPrint_Click()
    Dim nodProject As Node
    Dim strBundled, n As Long
    Dim Survey_id, SelectedConfig, Config_nm As String
    Dim dummy, strID As String
    Dim iOffset As Integer
    Dim iHospital As Integer

    strID = tvTreeView.SelectedItem.Tag
    Survey_id = NextValue(strID, vbTab) ' survey_id
    SelectedConfig = NextValue(strID, vbTab) ' config_id
    strBundled = NextValue(strID, vbTab) ' strBundled
    Config_nm = Trim(Mid(tvTreeView.SelectedItem.Text, 1 + Len(strBundled)))
    iOffset = 0
    iOffset = IIf(UCase(Left(NextValue(strID, vbTab), 6)) = "HCAHPS", OffsetHCAHPS, iOffset)
    iOffset = IIf(UCase(Left(NextValue(strID, vbTab), 11)) = "HOME HEALTH", OffsetHHCAHPS, iOffset)
    iOffset = IIf(UCase(Left(NextValue(strID, vbTab), 8)) = "ACOCAHPS", OffsetACOCAHPS, iOffset)
    iOffset = IIf(UCase(Left(NextValue(strID, vbTab), 8)) = "ICHCAHPS", OffsetICHCAHPS, iOffset)
    iOffset = IIf(UCase(Left(NextValue(strID, vbTab), 7)) = "HOSPICE", OffsetHOSPICE, iOffset)
    iHospital = conHospital + iOffset
    
    dummy = NextValue(strID, vbTab) ' number of pieces
   
    n = FindNodeByKey("GroupedPrint")
    If n = -1 Then
        Set nodProject = tvTreeView.Nodes.Add(, , "GroupedPrint", "Grouped Print", conGroupedPrint)
    End If
    
    n = FindNodeByKey("GroupedPrintConfig=" & SelectedConfig)
    If n = -1 Then
        Set nodProject = tvTreeView.Nodes.Add(tvTreeView.Nodes("GroupedPrint"), tvwChild, "GroupedPrintConfig=" & SelectedConfig, _
                         Config_nm, iHospital + GroupedPrintConfiguration)
        nodProject.Tag = Val(dummy)
    Else
        tvTreeView.Nodes(n).Tag = tvTreeView.Nodes(n).Tag + Val(dummy)
    End If
    
    n = FindNodeByKey("GroupedPrintItem=" & tvTreeView.SelectedItem.Key)
    If n = -1 Then
        Set nodProject = tvTreeView.Nodes.Add(tvTreeView.Nodes("GroupedPrintConfig=" & SelectedConfig), tvwChild, "GroupedPrintItem=" & tvTreeView.SelectedItem.Key, _
                         tvTreeView.SelectedItem.Parent.Text, iHospital + GroupedPrintHospital)
        nodProject.Tag = tvTreeView.SelectedItem.Tag
        tvTreeView.SelectedItem.Image = iHospital + FadedConfiguration
        ' & remove any bundles
        tvTreeView.SelectedItem.Expanded = False
        While tvTreeView.SelectedItem.Children > 0
            tvTreeView.Nodes.Remove (tvTreeView.SelectedItem.Child.Index)
        Wend
        ' & check to see if its parent should be checked
        Set nodProject = tvTreeView.SelectedItem.FirstSibling
        n = iHospital + CheckedHospital
        While Not nodProject Is Nothing
            If nodProject.Image = iHospital + Configuration Then
                n = iHospital
            End If
            Set nodProject = nodProject.Next
        Wend
        tvTreeView.SelectedItem.Parent.Image = n
        moQueueManager.AddToGroupedPrint Survey_id, SelectedConfig, strBundled
    End If
End Sub

Private Sub mnuBundle_Click()
    Dim strMsg As String
    
    frmMain.MousePointer = vbHourglass
    txtProperties.TextRTF = "{ "
    txtProperties.TextRTF = txtProperties.Text & "{\ul \b \qc \cell \fs25 Bundling in Progress... }"
    txtProperties.TextRTF = txtProperties.Text & "{ \b \qc \line \fs20 \line \line }"
    txtProperties.TextRTF = txtProperties.Text & " }"

    strMsg = moQueueManager.BundleUp
    If Trim(strMsg) = "" Then
        ClearTree
        CheckQueue
    Else
        Beep
        MsgBox strMsg, vbInformation, "Bundling"
    End If
        
    txtProperties.TextRTF = ""
    frmMain.MousePointer = vbDefault
End Sub

Private Sub mnuBundleFlats_Click()
    Dim intN As Integer
    Dim strID As String
    Dim strSurvey_id, strConfig_id, strBundled As String
    
    strID = tvTreeView.SelectedItem.Tag
    If tvTreeView.SelectedItem.Image Mod TotalStates = Configuration Then
        strSurvey_id = NextValue(strID, vbTab)
        strConfig_id = NextValue(strID, vbTab)
        strBundled = NextValue(strID, vbTab)
        intN = Val(InputBox("How many pieces of this configuration will fill 2/3 of a tray?", "Tray Capacity", "0"))
        If intN > 0 Then
            MousePointer = vbHourglass
            If Not moQueueManager.BundleFlats(strSurvey_id, strConfig_id, strBundled, intN) Then
                MousePointer = vbNormal
                MsgBox "An error occurred while bundling flats.  Procedure aborted."
            End If
            mnuRefresh_Click
            MousePointer = vbNormal
        End If
    End If
End Sub

Private Sub mnuBundlingReport_Click()
    Dim strID As String
    Dim strSurvey_id As String
    Dim strConfig_id As String
    Dim strBundled As String
    Dim dummy As String
    
    MousePointer = vbHourglass
    strID = tvTreeView.SelectedItem.Tag
    If tvTreeView.SelectedItem.Image Mod TotalStates = Configuration Then
        strSurvey_id = NextValue(strID, vbTab)
        strConfig_id = NextValue(strID, vbTab)
        strBundled = NextValue(strID, vbTab)
    ElseIf tvTreeView.SelectedItem.Image Mod TotalStates = GroupedPrintConfiguration Then
        strID = tvTreeView.SelectedItem.Key
        strSurvey_id = "GP"
        strConfig_id = Replace(NextValue(strID, vbTab), "GroupedPrintConfig=", "")
        strBundled = NextValue(strID, vbTab)
    ElseIf tvTreeView.SelectedItem.Image Mod TotalStates = CheckedConfiguration Then
        If InStr(1, tvTreeView.SelectedItem.Key, "GroupedPrintConfig=") > 0 Then
            strID = tvTreeView.SelectedItem.Key
            strSurvey_id = "GP"
            strConfig_id = Replace(NextValue(strID, vbTab), "GroupedPrintConfig=", "")
            strBundled = NextValue(strID, vbTab)
        Else
            strSurvey_id = NextValue(strID, vbTab)
            strConfig_id = NextValue(strID, vbTab)
            strBundled = NextValue(strID, vbTab)
        End If
    Else
        strSurvey_id = NextValue(strID, vbTab)
        dummy = NextValue(strID, vbTab) 'postalbundle
        strConfig_id = NextValue(strID, vbTab)
        dummy = NextValue(strID, vbTab) 'page_num
        dummy = NextValue(strID, vbTab) 'startlitho
        dummy = NextValue(strID, vbTab) 'endlitho
        strBundled = NextValue(strID, vbTab)
    End If
    strID = moQueueManager.BundlingReport(strSurvey_id, strConfig_id, strBundled)
    If strID = "" Then
        Beep
        MsgBox "Error while writing bundling report"
'    Else
'        Shell "notepad.exe """ + strID + """", 1
    End If
    MousePointer = vbNormal
End Sub

Private Sub PrintSample(ByVal bolSeperatePages As Boolean)
    Dim intN As Integer
    Dim strID As String
    Dim strSurvey_id, strConfig_id, strBundled, strPostalBundle, dummy As String

    strID = tvTreeView.SelectedItem.Tag
    If (tvTreeView.SelectedItem.Image Mod TotalStates = FadedConfiguration) Or _
        (tvTreeView.SelectedItem.Image Mod TotalStates = Configuration) Or _
        (tvTreeView.SelectedItem.Image Mod TotalStates = GroupedPrintConfiguration) Then
        strSurvey_id = NextValue(strID, vbTab)
        strConfig_id = NextValue(strID, vbTab)
        strBundled = NextValue(strID, vbTab)
        strPostalBundle = ""
        intN = Val(InputBox("How many pieces in this configuration do you want to print for QA?", "Print Sample", "0"))
    Else
        strSurvey_id = NextValue(strID, vbTab)
        strPostalBundle = NextValue(strID, vbTab)
        strConfig_id = NextValue(strID, vbTab)
        dummy = NextValue(strID, vbTab) 'page_num
        dummy = NextValue(strID, vbTab) 'startlitho
        dummy = NextValue(strID, vbTab) 'endlitho
        strBundled = NextValue(strID, vbTab)
        intN = Val(InputBox("How many pieces in this bundle do you want to print for QA?", "Print Sample", "0"))
    End If
    If intN > 0 Then
        If Not moQueueManager.PrintSample(strSurvey_id, strPostalBundle, strConfig_id, strBundled, intN, bolSeperatePages) Then
            MsgBox "An error occurred while printing QA surveys.  No surveys were printed."
        End If
    End If
End Sub

Private Sub mnuPrintSampleAllPagesInOneFile_Click()
    PrintSample (False)
End Sub

Private Sub mnuPrintSampleOneFilePerPage_Click()
    PrintSample (True)
End Sub

Private Sub mnuRemoveFromGroupedPrint_Click()
    Dim strKey As String
    Dim Survey_id, Config_id, strBundled, dummy, strX As String
    Dim n As Long
    Dim nodProject As Node
    Dim iOffset As Integer
    Dim iHospital As Integer
    
    strKey = tvTreeView.SelectedItem.Key
    If Mid(strKey, 1, 17) = "GroupedPrintItem=" Then
        strKey = Mid(strKey, 18)
    End If

    n = FindNodeByKey("GroupedPrintItem=" & strKey)
    strX = tvTreeView.Nodes(n).Tag
    Survey_id = NextValue(strX, vbTab) ' survey_id
    Config_id = NextValue(strX, vbTab) ' config_id
    strBundled = NextValue(strX, vbTab) ' datbundled
    iOffset = 0
    iOffset = IIf(UCase(Left(NextValue(strX, vbTab), 6)) = "HCAHPS", OffsetHCAHPS, iOffset)
    iOffset = IIf(UCase(Left(NextValue(strX, vbTab), 11)) = "HOME HEALTH", OffsetHHCAHPS, iOffset)
    iOffset = IIf(UCase(Left(NextValue(strX, vbTab), 8)) = "ACOCAHPS", OffsetACOCAHPS, iOffset)
    iOffset = IIf(UCase(Left(NextValue(strX, vbTab), 8)) = "ICHCAHPS", OffsetICHCAHPS, iOffset)
    iOffset = IIf(UCase(Left(NextValue(strX, vbTab), 7)) = "HOSPICE", OffsetHOSPICE, iOffset)
    iHospital = conHospital + iOffset
    dummy = NextValue(strX, vbTab) ' number of pieces
    
    tvTreeView.Nodes(n).Parent.Tag = tvTreeView.Nodes(n).Parent.Tag - Val(dummy)
    tvTreeView.Nodes.Remove (n)
    moQueueManager.RemoveFromGroupedPrint Survey_id, Config_id, strBundled
    
    n = FindNodeByKey(strKey)
    If n > -1 Then
        strKey = tvTreeView.Nodes(n).Tag
        strX = "QUERY=" & NextValue(strKey, vbTab) & "|"
        strX = strX & NextValue(strKey, vbTab) & "|"
        strX = strX & NextValue(strKey, vbTab)
        
        tvTreeView.Nodes(n).Image = iHospital + Configuration
        tvTreeView.Nodes(n).Parent.Image = iHospital
        Set nodProject = tvTreeView.Nodes.Add(tvTreeView.Nodes(n), tvwChild, strX, "")
        nodProject.Expanded = False
    End If
    
End Sub

' 11-30-2004 SH Added
Private Sub mnuRollbackGen_Click()
    Dim strID As String
    Dim surveyID As String
    Dim bundleCode As String
    Dim paperConfigID As String
    Dim pages As String
    Dim minLitho As String
    Dim maxLitho As String
    Dim dateBundled As String
    Dim dateMailed As String
    Dim mailDateSet As Boolean
    
    bundleCode = ""
    dateMailed = ""
    mailDateSet = False
    MousePointer = vbHourglass
        
    ' strID:
    ' surveyID bundleCode paperConfigID pages minLitho maxLitho dateBundled         dateMailed
    ' 440                 1                                     2004-05-27 16:05:01
    ' 645      PVEND      1             1     44672104 44672123 2004-11-30 07:32:06 2004-11-30 12:00:00
    strID = tvTreeView.SelectedItem.Tag
    surveyID = NextValue(strID, vbTab)
    
    If frmMain.tvTreeView.SelectedItem.Image Mod TotalStates = Configuration Then
        Dim SelectedNode As ComctlLib.Node
        Dim n As Integer
        
        paperConfigID = NextValue(strID, vbTab)
        dateBundled = NextValue(strID, vbTab)
                
        If frmMain.tvTreeView.SelectedItem.Expanded = False Then
            ' Need to expand tree
            Set SelectedNode = frmMain.tvTreeView.SelectedItem
            If frmMain.tvTreeView.SelectedItem.Text <> "" Then
                frmMain.ButtonUsed = -1
                frmMain.ShowProperties SelectedNode
                SelectedNode.Selected = True
            End If
        End If

        ' Check if any mailing date of any child is set.
        If frmMain.tvTreeView.SelectedItem.Children <> 0 Then
            n = frmMain.tvTreeView.SelectedItem.Child.Index
            Do While n >= 0
                If frmMain.tvTreeView.Nodes(n).Image Mod TotalStates = AlreadyMailed Then
                    mailDateSet = True
                    Exit Do
                End If
                If n = frmMain.tvTreeView.Nodes(n).LastSibling.Index Then Exit Do
                n = frmMain.tvTreeView.Nodes(n).Next.Index
            Loop
        End If
    Else
        bundleCode = NextValue(strID, vbTab)
        paperConfigID = NextValue(strID, vbTab)
        pages = NextValue(strID, vbTab)
        minLitho = NextValue(strID, vbTab)
        maxLitho = NextValue(strID, vbTab)
        dateBundled = NextValue(strID, vbTab)
        dateMailed = NextValue(strID, vbTab)
        If UCase(Trim(dateMailed)) <> "NOT MAILED" And Len(dateMailed) > 0 Then mailDateSet = True
    End If

    ' if print queue is not bundled, user can't roll back.
    If Len(dateBundled) = 0 Then
        MsgBox "Bundling must be done before you can rollback!", vbCritical + vbOKOnly, "Error!"
        MousePointer = vbNormal
        Exit Sub
    End If
    
    If mailDateSet Then
        With frmRollbackMessage
            .Caption = "WARNING!"
            .txtMessage = "****************** STOP! *******************" & vbCrLf & _
                          "" & vbCrLf & _
                          "            MAIL DATE HAS BEEN SET!!!        " & vbCrLf & _
                          "       Are you sure you want to rollback?    "
            .txtMessage.ForeColor = &HFF&
            .WindowState = 2
            .Show vbModal, Me
            If Not .Rollback Then
                MousePointer = vbNormal
                Exit Sub
            End If
        End With
    End If

    With frmRollbackMessage
        .Caption = "ROLLBACK GENERATION?"
        .txtMessage = "Do you want to rollback the generation for:" & vbCrLf & _
                      "Survey ID: " & surveyID & vbCrLf & _
                      "Date Bundled: " & dateBundled & vbCrLf & _
                      "Bundle Code: " & _
                      IIf(bundleCode = "", "ALL", bundleCode) & " ?"
        .txtMessage.ForeColor = &HFF0000
        .WindowState = 0
        .Show vbModal, Me
        If .Rollback Then
            GenerationRollback surveyID, dateBundled, paperConfigID, bundleCode
            mnuRefresh_Click
        End If
    End With
    
    MousePointer = vbNormal
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GenerationRollback
'\\
'\\ Created By:     Hui Holay
'\\         Date:   12-01-2004
'\\
'\\ Description:    This routine rolls back the print generation by calling
'\\                 the stored procedure sp_Queue_GenerationRollback which
'\\                 required Survey_id, BundleCode, datBundle, and who.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     surveyID        String  The survey to be rolled back
'\\     dateBundled     String  The bundle date
'\\     PaperConfigID   String  The paper config
'\\     bundleCode      String  The bundle to be rolled back
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub GenerationRollback(ByVal surveyID As String, _
                               ByVal dateBundled As String, _
                               ByVal paperConfigID As String, _
                               ByVal bundleCode As String)
    Dim con As New ADODB.Connection
    Dim DSNInfo As String
    Dim anObj As New QualiSysFunctions.Library
    Dim SQL As String
                               
    ' TODO: Call stored procedure sp_Queue_GenerationRollback.
    '       Parameters needed: strSurvey_id, datBundled, PaperConfig_id,
    '                          BundleCode, msUserName
    '       Removed the child from the tree.
    DSNInfo = anObj.GetDBString(True)
    con.ConnectionTimeout = 0
    con.Open DSNInfo
    con.CommandTimeout = 0

    SQL = "EXEC sp_Queue_GenerationRollback " & _
          "@Survey_id=" + surveyID & ", " & _
          "@datBundled='" + dateBundled & "', " & _
          "@PaperConfig_id=" + paperConfigID & ", " & _
          IIf(bundleCode = "", "", "@BundleCode='" + bundleCode & "', ") & _
          "@who='" + msUserName & "'"
    con.Execute SQL

    con.Close
    Set con = Nothing
    Set anObj = Nothing
End Sub
' ***11-30-2004 SH End of addition

Private Sub mnuExit_Click()
    cmdClose_Click
End Sub

Private Sub cmdClose_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    
    ' *** Added 01-13-2003 SH
    Dim pGetEmpObj As New getEmpId.GetEmpIdDll
    Dim lngEmployee_id As Long
    
    ' Retrieve Employee ID.
    If pGetEmpObj.RetrieveUserEmployeeID() Then
        lngEmployee_id = pGetEmpObj.UserEmployeeID
        msUserName = pGetEmpObj.UserLoginName ' 11-30-2004 SH Added
                
        Dim anObject As New QualiSysFunctions.checkAccess
        
        ' Check the access to the module.
        If Not anObject.IsUserInModules(CInt(lngEmployee_id), "Queue_Mgr") Then
            MsgBox "Security violation.  You have not been assigned permission to run this application(Queue Manager).  Please see QualiSys-Security Administrator."
            End
        End If
        Set anObject = Nothing
    Else
        MsgBox "Access Denied.  Login name not found in QualiSys Associates table."
        End
    End If
    
    Set pGetEmpObj = Nothing

    mbTreeSel = False
    mbListSel = False
    Set moQueueManager = CreateObject("QueueManDLL.clsQueueManager")
    mbReprint = False
'D    moQueueManager.RePrints = False
    mnuAbout_Click
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim i As Integer
    
    'close all sub forms
    For i = Forms.Count - 1 To 1 Step -1
        Unload Forms(i)
    Next
    Set moQueueManager = Nothing
    If Me.WindowState <> vbMinimized Then
        SaveSetting App.Title, "Settings", "MainLeft", Me.Left
        SaveSetting App.Title, "Settings", "MainTop", Me.Top
        SaveSetting App.Title, "Settings", "MainWidth", Me.Width
        SaveSetting App.Title, "Settings", "MainHeight", Me.Height
    End If
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    SizeControls imgSplitter.Left
    On Error GoTo 0
End Sub

Private Sub imgSplitter_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    With imgSplitter
        picSplitter.Move .Left, .Top, .Width \ 2, .Height - 20
    End With
    picSplitter.Visible = True
    mbMoving = True
End Sub

Private Sub imgSplitter_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim sglPos As Single

    If mbMoving Then
        sglPos = X + imgSplitter.Left
        If sglPos < mknSplitLimit Then
            picSplitter.Left = mknSplitLimit
        ElseIf sglPos > Me.Width - mknSplitLimit - 1400 Then
            picSplitter.Left = Me.Width - mknSplitLimit - 1400
        Else
            picSplitter.Left = sglPos
        End If
    End If
End Sub

Private Sub imgSplitter_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If picSplitter.Left > cmdPrint.Left Then picSplitter.Left = cmdPrint.Left - 200
    SizeControls picSplitter.Left
    picSplitter.Visible = False
    mbMoving = False
End Sub

Sub SizeControls(X As Single)
    On Error Resume Next
    'set the width
    If X < mknSplitLimit Then X = mknSplitLimit
    If X > (Me.Width - 3000) Then X = Me.Width - 1500
    If Me.Height < 3000 Then Me.Height = 3000
    If Me.Width < 8000 Then Me.Width = 8000
    imgSplitter.Left = X
    
    tvTreeView.Width = X
    lblTitle(0).Width = tvTreeView.Width

    tvTreeView.Height = Me.Height - 1200
    imgSplitter.Top = tvTreeView.Top
    imgSplitter.Height = tvTreeView.Height
    
    fraProperties.Left = imgSplitter.Left + 50
    fraProperties.Width = Me.Width - imgSplitter.Left - 250
    fraProperties.Height = tvTreeView.Height - cmdClose.Height + 250
    fraProperties.Top = cmdClose.Height + 100
    
    txtProperties.Left = 100
    txtProperties.Width = fraProperties.Width - 500
    txtProperties.Height = fraProperties.Height - 600
    
    lblBundlingDate.Left = 100
    lblBundlingDate.Width = fraProperties.Width - 200
    lblBundlingDate.Top = txtProperties.Top + txtProperties.Height
    
    cmdClose.Left = Me.Width - cmdClose.Width - 200
    cmdPrint.Left = cmdClose.Left - cmdPrint.Width - 100
    'cmdBundling.Left = cmdPrint.Left - cmdBundling.Width - 100
    cmdPostal.Left = cmdPrint.Left - cmdPostal.Width - 100
    cmdClose.Top = 100
    cmdPrint.Top = cmdClose.Top
    'cmdBundling.Top = cmdPrint.Top
    cmdPostal.Top = cmdPrint.Top
End Sub

Private Sub mnuAbout_Click()
    txtProperties.TextRTF = "{ "
    txtProperties.TextRTF = txtProperties.Text & "{\ul \b \qc \cell \fs25 National Research Corporation }"
    txtProperties.TextRTF = txtProperties.Text & "{ \b \qc \line \fs20 \line \line }"
    txtProperties.TextRTF = txtProperties.Text & " }"
End Sub

Private Sub mnuCallList_Click()
    frmMailRoomSupport.Show vbModal, Me
End Sub

Private Sub mnuMailingDates_Click()
    DoEvents
    If tvTreeView.SelectedItem.Image Mod TotalStates = Bundle Then
        If MsgBox("The current bundle is not marked for mailing date assignment.  Do you want to include this bundle?", vbYesNo, "Include this bundle?") = vbYes Then
            tvTreeView.SelectedItem.Image = (tvTreeView.SelectedItem.Image \ TotalStates) * TotalStates + MailBundle
        End If
    End If
    frmMailingDates.Show vbModal
    mnuAbout_Click
End Sub

Private Sub mnuModify_Click()
    On Error GoTo Skip
    mbTreeSel = True
    mbListSel = False
    
    If tvTreeView.Nodes.Count = 0 Then
        mnuPrint.Enabled = False
        mnuDelete.Enabled = False
    Else
        Select Case tvTreeView.SelectedItem.Image Mod TotalStates
            Case Hospital, CheckedHospital:
                mnuPrint.Enabled = False
                mnuDelete.Enabled = False
            Case Configuration, Bundle:
                mnuDelete.Caption = "&Delete"
                mnuDelete.Enabled = True
                mnuPrint.Enabled = True
            Case Deleted:
                mnuDelete.Caption = "&UnDelete"
                mnuPrint.Enabled = False
        End Select
    End If
Skip:
    On Error GoTo 0
End Sub

Private Sub mnuPopUpDelete_Click()
    mnuDelete_Click
End Sub

Private Sub mnuDelete_Click()
On Error GoTo NoSelection
    Dim X As Long
    If mbTreeSel Then
        If tvTreeView.SelectedItem.Image Mod TotalStates <> Deleted Then
            Select Case tvTreeView.SelectedItem.Image Mod TotalStates
                Case Configuration:
                    DeleteConfiguration tvTreeView.SelectedItem
                Case Bundle:
                    DeleteBundleId tvTreeView.SelectedItem
            End Select
        Else
            Select Case tvTreeView.SelectedItem.Parent.Image Mod TotalStates
                Case Hospital, CheckedHospital:
                    UnDeleteConfiguration tvTreeView.SelectedItem
                Case Configuration:
                    UnDeleteBundleId tvTreeView.SelectedItem
            End Select
        End If
    End If
    On Error GoTo 0
    ShowProperties tvTreeView.SelectedItem
    Exit Sub
NoSelection:
    MsgBox "You must first select an item to delete!", vbExclamation, "Delete Error Message"
    On Error GoTo 0
End Sub

Private Sub mnuPopupMarkMailing_Click()
    
    If tvTreeView.SelectedItem.Image Mod TotalStates = Bundle Then
        tvTreeView.SelectedItem.Image = tvTreeView.SelectedItem.Image - Bundle + MailBundle
    ElseIf tvTreeView.SelectedItem.Image Mod TotalStates = MailBundle Then
        tvTreeView.SelectedItem.Image = tvTreeView.SelectedItem.Image - MailBundle + Bundle
    End If

End Sub

Private Sub mnuPopUpPrint_Click()
    mnuPrint_Click
End Sub

Private Sub mnuPostOfficeReport_Click()
    Dim strID As String, strSurvey_id As String, strConfig_id As String
    Dim strBundled As String, strMailed As String, strBundle As String
    Dim strFileName, strFilePath As String
    Dim dummy As String
    
    MousePointer = vbHourglass
    If InStr(1, tvTreeView.SelectedItem.Key, "GroupedPrintConfig") > 1 Then
        strID = tvTreeView.SelectedItem.Key
        strSurvey_id = "GP"
        strConfig_id = Replace(NextValue(strID, vbTab), "GroupedPrintConfig=", "")
        strBundled = NextValue(strID, vbTab)
        strMailed = "1/1/1980"
    ElseIf tvTreeView.SelectedItem.Image Mod TotalStates = AlreadyMailed Then
        strID = tvTreeView.SelectedItem.Tag
        strSurvey_id = NextValue(strID, vbTab)
        strBundle = NextValue(strID, vbTab)
        strConfig_id = NextValue(strID, vbTab)
        dummy = NextValue(strID, vbTab) 'pages
        dummy = NextValue(strID, vbTab) 'minlitho
        dummy = NextValue(strID, vbTab) 'maxlitho
        strBundled = NextValue(strID, vbTab)
        strMailed = NextValue(strID, vbTab)
    Else
        strID = tvTreeView.SelectedItem.Tag
        strSurvey_id = NextValue(strID, vbTab)
        strConfig_id = NextValue(strID, vbTab)
        strBundled = NextValue(strID, vbTab)
        dummy = NextValue(strID, vbTab) 'cnt
        strMailed = NextValue(strID, vbTab)
    End If
    If InStr(strBundle, "-") > 0 Then
        strID = moQueueManager.PostOfficeFlatsReport(strSurvey_id, strConfig_id, strBundled, strMailed)
    Else
        strID = moQueueManager.PostOfficeReport(strSurvey_id, strConfig_id, strBundled, strMailed)
    End If
    If strID = "" Then
        Beep
        MsgBox "Error while writing post office report"
    Else
'        strFileName = Dir(strID)
'        strFilePath = Left(strID, Len(strID) - Len(strFileName))
'        strFileName = "5" + Right(strFileName, Len(strFileName) - 1)
'        If Len(Dir(strFilePath & strFileName)) > 0 Then
'            Shell "notepad.EXE """ + strFilePath & strFileName + """", 1
'        End If
'        strFileName = "9" + Right(strFileName, Len(strFileName) - 1)
'        If Len(Dir(strFilePath & strFileName)) > 0 Then
'            Shell "notepad.EXE """ + strFilePath & strFileName + """", 1
'        End If
    End If
    MousePointer = vbNormal
End Sub

Private Sub mnuPrint_Click()
    On Error GoTo Skip
    
    Dim strStatus As String
    Dim strMsg As String
    Dim LastBundlingDate As String
    
    MousePointer = vbHourglass
    DoEvents
    If mnuReprint.Caption = "View Print &Queue" Then
        mnuPopUpPrint.Caption = "&RePrint"
        mnuAddToGroupedPrint.Visible = False
        mnuPrintSample.Visible = False
        mnuBundleFlats.Visible = False
        mnuMailingDates.Visible = True
        mnuPopupMarkMailing.Visible = True
        mnuBundlingReport.Visible = True
        frmRePrintDates.Show vbModal, Me
    Else
        If moQueueManager.PrintingInstance_Add(LastBundlingDate) = False Then
            strMsg = "Cannot Print.  Another user is currently bundling."
            Beep
            MsgBox strMsg, vbInformation, "Queue Manager"
        ElseIf Format(LastBundlingDate, "mm/dd/yyyy hh:nn:ss AM/PM") <> Trim(Mid(lblBundlingDate.Caption, InStr(lblBundlingDate.Caption, ":") + 1)) Then
            moQueueManager.PrintingInstance_Remove
            strMsg = "Cannot Print.  Bundling has been run since you last refreshed the Print Queue.  The view will be refreshed and you can try to print again."
            Beep
            MsgBox strMsg, vbInformation, "Queue Manager"
        Else
            mnuPopUpPrint.Caption = "&Print"
            mnuAddToGroupedPrint.Visible = True
            mnuPrintSample.Visible = True
            mnuBundleFlats.Visible = True
            mnuMailingDates.Visible = False
            mnuPopupMarkMailing.Visible = False
            mnuBundlingReport.Visible = False
            If tvTreeView.SelectedItem.Image Mod TotalStates = Deleted Then
                If InStr(tvTreeView.SelectedItem.Tag, "(unbundled)") = 0 Then
                    Call PrintBundles(tvTreeView.SelectedItem)
                    moQueueManager.PrintingInstance_Remove
                    tvTreeView.Nodes.Remove tvTreeView.SelectedItem.Index
                    Do While (Not (tvTreeView.SelectedItem Is Nothing))
                        If (tvTreeView.SelectedItem.Image Mod TotalStates <> Hospital And _
                            tvTreeView.SelectedItem.Image Mod TotalStates <> Configuration) Or _
                           (Not (tvTreeView.SelectedItem.Child Is Nothing)) Then
                            Exit Do
                        End If
                        tvTreeView.Nodes.Remove tvTreeView.SelectedItem.Index
                    Loop
                Else
                    MsgBox "You can't print unbundled surveys.", vbOKOnly
                End If
            End If
        End If
    End If
    MousePointer = vbNormal
    Exit Sub
Skip:
    On Error GoTo 0
    MsgBox "You must first select an item to print!", vbExclamation, "Print Error Message"
    MousePointer = vbNormal
    
End Sub

Private Sub mnuRefresh_Click()
    ClearTree
    CheckQueue
End Sub

Private Sub mnuRePrint_Click()
    'Dim IsRunning As Boolean
    'Dim LastRunning As String
    
    MousePointer = vbHourglass
    
    If mnuReprint.Caption = "View Print &Queue" Then
        mnuBundle.Visible = True
        mnuSeparater2.Visible = True
        lblBundlingDate.Visible = True
        mnuReprint.Caption = "View &Mailing Queue"
        lblTitle(0).Caption = " Print Queue:"
        Me.Caption = "Print Queue Manager"
        mnuMailingDates.Visible = False
        mnuPopupMarkMailing.Visible = False
        mnuBundlingReport.Visible = False
        mbReprint = False
'D        moQueueManager.RePrints = False
    Else
'        moQueueManager.RePrints = True
'        mnuBundle.Visible = False
'        mnuSeparater2.Visible = False
'        mnuRePrint.Caption = "View Print &Queue"
'        Me.Caption = "Mailing Queue Manager"
'        mnuMailingDates.Visible = True
'        mnuPopupMarkMailing.Visible = True
'        mnuBundlingReport.Visible = True
        Call PrepareMailingQueue

    End If
    ClearTree
    CheckQueue
    mnuAbout_Click
    MousePointer = vbNormal
End Sub

Private Sub mnuReprintList_Click()
    frmReprintIndiv.Show vbModal, Me
End Sub

Private Sub tvTreeView_DblClick()
    
    If mnuReprint.Caption = "View Print &Queue" And _
       (tvTreeView.SelectedItem.Image Mod TotalStates = Bundle Or _
        tvTreeView.SelectedItem.Image Mod TotalStates = MailBundle) Then
        mnuPopupMarkMailing_Click
    End If
End Sub

Private Sub tvTreeView_KeyUp(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyF5 Then
        ClearTree
        CheckQueue
        mnuAbout_Click
    Else
        tvTreeView_MouseUp vbLeftButton, 0, 0, 0
    End If
End Sub

Private Sub tvTreeView_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim bolReprint, bolShowGroupedPrint As Boolean
    bolReprint = (mnuReprint.Caption = "View Print &Queue")
    bolShowGroupedPrint = moQueueManager.ShowGroupedPrint()
    
    mbTreeSel = True
    mbListSel = False
   ' On Error GoTo Skip
    ButtonUsed = Button
    Select Case Button
        Case vbRightButton:
            Select Case tvTreeView.SelectedItem.Image Mod TotalStates
                Case Configuration, AlreadyMailed:
                    mnuPopUpPrint.Visible = True
                    mnuPopUpDelete.Caption = "&Delete"
                    If bolReprint Then
                        mnuPopUpPrint.Caption = "&RePrint"
                        mnuAddToGroupedPrint.Visible = False
                        mnuPrintSample.Visible = False
                        mnuBundleFlats.Visible = False
                        mnuBundlingReport.Visible = True
                        mnuMailingDates.Visible = (tvTreeView.SelectedItem.Image Mod TotalStates = Configuration)
                    Else
                        mnuPopUpPrint.Caption = "&Print"
                        mnuAddToGroupedPrint.Visible = bolShowGroupedPrint
                        mnuPrintSample.Visible = True
                        mnuBundleFlats.Visible = True
                        mnuBundlingReport.Visible = False
                        mnuMailingDates.Visible = False
                    End If
                    mnuPopUpPrint.Enabled = True
                    mnuAddToGroupedPrint.Enabled = bolShowGroupedPrint
                    mnuPrintSample.Enabled = True
                    mnuBundleFlats.Enabled = True
                    mnuPopupMarkMailing.Visible = False
                    mnuRollbackGen.Visible = True
                    mnuPostOfficeReport.Visible = tvTreeView.SelectedItem.Image Mod TotalStates = AlreadyMailed
                    mnuRemoveFromGroupedPrint.Visible = False
                    If InStr(tvTreeView.SelectedItem.Tag, "(unbundled)") = 0 Then
                        PopupMenu mnuTreeViewPopUp, , , , mnuPopUpPrint
                    End If
                Case Bundle, MailBundle:
                    mnuPopUpPrint.Visible = True
                    mnuPopUpDelete.Caption = "&Delete"
                    mnuAddToGroupedPrint.Visible = False
                    If bolReprint Then
                        mnuPopUpPrint.Caption = "&RePrint"
                        mnuPrintSample.Visible = False
                        mnuBundleFlats.Visible = False
                        mnuBundlingReport.Visible = True
                        mnuPopupMarkMailing.Visible = True
                        mnuMailingDates.Visible = True
                    Else
                        mnuPopUpPrint.Caption = "&Print"
                        mnuPrintSample.Visible = True
                        mnuBundleFlats.Visible = False 'True
                        mnuBundlingReport.Visible = False
                        mnuPopupMarkMailing.Visible = False
                        mnuMailingDates.Visible = False
                        If tvTreeView.SelectedItem.Image Mod TotalStates = Bundle Then
                            mnuPopupMarkMailing.Caption = "Mark for &Mailing"
                        Else
                            mnuPopupMarkMailing.Caption = "Unmark for &Mailing"
                        End If
                    End If
                    mnuPopUpPrint.Enabled = True
                    mnuAddToGroupedPrint.Enabled = bolShowGroupedPrint
                    mnuPrintSample.Enabled = True
                    mnuBundleFlats.Enabled = True
                    mnuRollbackGen.Visible = True ' 11-30-2004 SH Added
                    mnuPostOfficeReport.Visible = False
                    mnuRemoveFromGroupedPrint.Visible = False
                    PopupMenu mnuTreeViewPopUp, , , , mnuPopUpPrint
                Case Deleted:
                    mnuPopUpDelete.Caption = "&UnDelete"
                    mnuPopUpPrint.Enabled = False
                    mnuPopUpPrint.Visible = False
                    mnuAddToGroupedPrint.Enabled = False
                    mnuPrintSample.Enabled = False
                    mnuBundleFlats.Enabled = False
                    PopupMenu mnuTreeViewPopUp, , , , mnuPopUpPrint
                    mnuAbout_Click
                Case FadedConfiguration:
                    mnuRemoveFromGroupedPrint.Visible = bolShowGroupedPrint
                    mnuPrintSample.Visible = True
                    mnuAddToGroupedPrint.Visible = False
                    mnuBundleFlats.Visible = False
                    mnuBundlingReport.Visible = False
                    mnuMailingDates.Visible = False
                    mnuPopUpDelete.Visible = False
                    mnuPopupMarkMailing.Visible = False
                    mnuPopUpPrint.Visible = False
                    mnuPostOfficeReport.Visible = False
                    mnuRollbackGen.Visible = False
                    PopupMenu mnuTreeViewPopUp
                Case GroupedPrintConfiguration, CheckedConfiguration:
                    If bolReprint Then
                        mnuPopUpPrint.Caption = "&RePrint"
                    Else
                        mnuPopUpPrint.Caption = "&Print"
                    End If
                    mnuMailingDates.Visible = bolReprint
                    If tvTreeView.SelectedItem.Image Mod TotalStates = CheckedConfiguration Then
                        mnuMailingDates.Visible = False
                    End If
                    mnuPopUpPrint.Visible = True
                    mnuPrintSample.Visible = False
                    mnuAddToGroupedPrint.Visible = False
                    mnuBundleFlats.Visible = False
                    mnuBundlingReport.Visible = bolReprint
                    mnuPopUpDelete.Visible = False
                    mnuPopupMarkMailing.Visible = False
                    mnuPostOfficeReport.Visible = bolReprint
                    mnuRollbackGen.Visible = False
                    mnuRemoveFromGroupedPrint.Visible = False
                    PopupMenu mnuTreeViewPopUp, , , , mnuPopUpPrint
                Case GroupedPrintHospital:
                    mnuRemoveFromGroupedPrint.Visible = bolShowGroupedPrint
                    mnuPrintSample.Visible = True
                    mnuAddToGroupedPrint.Visible = False
                    mnuBundleFlats.Visible = False
                    mnuBundlingReport.Visible = False
                    mnuMailingDates.Visible = False
                    mnuPopUpDelete.Visible = False
                    mnuPopupMarkMailing.Visible = False
                    mnuPopUpPrint.Visible = False
                    mnuPostOfficeReport.Visible = False
                    mnuRollbackGen.Visible = False
                    If Not bolReprint Then PopupMenu mnuTreeViewPopUp
            End Select
        Case vbLeftButton:
            If tvTreeView.SelectedItem.Text <> "" Then
                ShowProperties tvTreeView.SelectedItem
            End If
    End Select
    ' Use this to reset the timer.
    ' If somebody is using the tree then do not refresh
    '  until nobody has used the view for a time span
    Exit Sub
Skip:
    On Error GoTo 0
    mnuAbout_Click
End Sub

Public Function NextValue(s As String, ByVal Delim As String) As String
    If InStr(s, Delim) Then
        NextValue = Left(s, InStr(1, s, Delim) - 1)
        s = Mid(s, InStr(1, s, Delim) + 1, Len(s))
    Else
        NextValue = s
        s = ""
    End If
End Function

Public Sub GroupedPrintNode(NodeIndex As Long)
    Dim PaperConfig As Long
    Dim strID As String
    Dim PrintDate As Date
    PrintDate = Now
       
    strID = tvTreeView.Nodes(NodeIndex).Key
    If Mid(strID, 1, 19) = "GroupedPrintConfig=" Then
        PaperConfig = Val(Mid(strID, 20))
        frmMain.tvTreeView.Nodes(NodeIndex).Image = (frmMain.tvTreeView.Nodes(NodeIndex).Image \ TotalStates) * TotalStates + Printing
        moQueueManager.GroupedPrintRebundleAndSetLithos PaperConfig, PrintDate
        If Not moQueueManager.GetGroupedPrint(PaperConfig, False, PrintDate) Then
            MsgBox "No surveys were printed!", vbExclamation, "Print Warning"
        End If
        frmMain.tvTreeView.Nodes(NodeIndex).Image = (frmMain.tvTreeView.Nodes(NodeIndex).Image \ TotalStates) * TotalStates + Bundle
    Else
        MsgBox "That doesn't appear to be a Grouped Print configuration", vbCritical, "Error"
    End If
End Sub

Public Sub PrintNode(NodeIndex As Long)

    Dim PaperConfig, Page_num, Survey_id As Long
    Dim strBundled, PostalBundle, strID As String
    
    strID = frmMain.tvTreeView.Nodes(NodeIndex).Tag
    If mnuReprint.Caption = "View Print &Queue" Then
        mbReprint = True
    Else
        mbReprint = False
    End If
    Survey_id = NextValue(strID, vbTab)
    PostalBundle = NextValue(strID, vbTab)
    PaperConfig = NextValue(strID, vbTab)
    Page_num = NextValue(strID, vbTab)
    mvStartLitho = NextValue(strID, vbTab)
    mvEndLitho = NextValue(strID, vbTab)
    strBundled = NextValue(strID, vbTab)
    frmMain.tvTreeView.Nodes(NodeIndex).Image = (frmMain.tvTreeView.Nodes(NodeIndex).Image \ TotalStates) * TotalStates + Printing
    moQueueManager.SetLithoCodes mbReprint, Survey_id, PostalBundle, PaperConfig, Page_num, strBundled
    If Not moQueueManager.GetPrintBundle(Survey_id, PostalBundle, PaperConfig, Page_num, strBundled) Then
        MsgBox "No surveys were printed for the " & PostalBundle & " bundle!", vbExclamation, "Print Warning"
    End If
    frmMain.tvTreeView.Nodes(NodeIndex).Image = (frmMain.tvTreeView.Nodes(NodeIndex).Image \ TotalStates) * TotalStates + Bundle
End Sub

Public Function PrintBundles(nodSelected As Node) As String
    Dim X, lngTotalChildren As Long
    Dim SelectedNode As Node
    
'    On Error GoTo NoPrint
    
    Me.MousePointer = vbHourglass
    If frmMain.tvTreeView.SelectedItem.Expanded = False Then
        'need to expand tree
        Set SelectedNode = frmMain.tvTreeView.SelectedItem
        If frmMain.tvTreeView.SelectedItem.Text <> "" Then
            frmMain.ButtonUsed = -1
            frmMain.ShowProperties nodSelected
            SelectedNode.Selected = True
        End If
    End If
    If nodSelected.Image Mod TotalStates = GroupedPrintConfiguration Then
    '01-19-2010 JJF - End of add
        'check to see if any surveys have been added to grouped print since the last time the tree was refreshed!
        '(write some code here)
        GroupedPrintNode (nodSelected.Index)
    ElseIf nodSelected.Image Mod TotalStates = Bundle Then
        PrintNode (nodSelected.Index)
    ElseIf nodSelected.Parent.Image Mod TotalStates <> Hospital And _
        nodSelected.Parent.Image Mod TotalStates <> CheckedHospital Then
        Set nodSelected = nodSelected.Parent
        PrintNode (nodSelected.Index)
    Else
        lngTotalChildren = nodSelected.Children
        ' This will go through all the children for the selected paper configuration
        For X = nodSelected.Child.Index To nodSelected.Child.Index + lngTotalChildren - 1
            DoEvents
            PrintNode (X)
        Next X
    End If
    Me.MousePointer = vbDefault
    nodSelected.Image = (nodSelected.Image \ TotalStates) * TotalStates + Configuration
    Exit Function
NoPrint:
    
End Function

Public Function SetReprintIndividuals(ByVal QList As String) As Boolean
    If Trim(QList) = "" Then
        SetReprintIndividuals = False
        MsgBox "No one is listed as needing reprints."
    Else
        SetReprintIndividuals = moQueueManager.SetRePrintIndiv(QList)
    End If
End Function

Public Function RePrintIndividuals(ByVal QList As String) As Boolean
    RePrintIndividuals = moQueueManager.GetRePrintIndiv(QList)
End Function

Public Function DecodeBarcode(ByVal BC As String) As String
    DecodeBarcode = moQueueManager.UnCrunch(BC)
End Function

Public Function RePrintBundles(nodSelected As Node) As Boolean
    Dim varPrintQueue As Variant
    Dim X, Y, z As Long
    Dim AnotherNode As Node
    Dim Survey_id As Long
    Dim PostalBundle As String
    Dim PaperConfig As Long
    Dim strBundled As String
    Dim strPrinted As String
    Dim strMailedOn As String
    Dim Page_num As Long
    Dim strID As String
    Dim lngTotalChildren As Long
    Dim tmpStr As String
    Dim bitByteArray() As Byte
    Dim strInit As String
    Dim strReset As String
    Dim SelectedNode As ComctlLib.Node
    Dim oQueueManager As New QueueManDLL.clsQueueManager
    Dim n As Integer
    
    On Error GoTo NoPrint
    
    Me.MousePointer = vbHourglass
    If frmMain.tvTreeView.SelectedItem.Expanded = False Then
        'need to expand tree
        Set SelectedNode = frmMain.tvTreeView.SelectedItem
        If frmMain.tvTreeView.SelectedItem.Text <> "" Then
            frmMain.ButtonUsed = -1
            frmMain.ShowProperties SelectedNode
            SelectedNode.Selected = True
        End If
    End If
    If nodSelected.Parent.Image = conGroupedPrint Then
        strID = tvTreeView.SelectedItem.Key
        If Mid(strID, 1, 19) = "GroupedPrintConfig=" Then
            strID = Mid(strID, 20)
            PaperConfig = NextValue(strID, vbTab)
            strPrinted = NextValue(strID, vbTab)
            If Not oQueueManager.GetGroupedPrint(PaperConfig, True, strPrinted) Then
                MsgBox "No surveys were printed!", vbExclamation, "Print Warning"
            End If
        End If
    ElseIf nodSelected.Parent.Image Mod TotalStates <> Hospital And _
            nodSelected.Parent.Image Mod TotalStates <> CheckedHospital Then
        Set AnotherNode = nodSelected
        Set nodSelected = nodSelected.Parent
        lngTotalChildren = 1
        strID = frmMain.tvTreeView.SelectedItem.Tag
        Survey_id = NextValue(strID, vbTab)
        PostalBundle = NextValue(strID, vbTab)
        PaperConfig = NextValue(strID, vbTab)
        Page_num = NextValue(strID, vbTab)
        mvStartLitho = NextValue(strID, vbTab)
        mvEndLitho = NextValue(strID, vbTab)
        strBundled = NextValue(strID, vbTab)
        strMailedOn = NextValue(strID, vbTab)
        n = frmMain.tvTreeView.SelectedItem.Image
        n = (n \ TotalStates) * TotalStates + Printing
        
        If Not oQueueManager.GetRePrintBundle(Survey_id, PostalBundle, PaperConfig, Page_num, strBundled) Then
            MsgBox "No surveys were printed for the " & PostalBundle & " bundle!", vbExclamation, "Print Warning"
        End If
        If strMailedOn = "Not Mailed" Then
            n = (n \ TotalStates) * TotalStates + Bundle
        Else
            n = (n \ TotalStates) * TotalStates + AlreadyMailed
        End If
        frmMain.tvTreeView.SelectedItem.Image = n
    Else
        lngTotalChildren = nodSelected.Children
        Set AnotherNode = nodSelected
        For X = nodSelected.Child.Index To nodSelected.Child.Index + lngTotalChildren - 1
            strID = frmMain.tvTreeView.Nodes(X).Tag
            Survey_id = NextValue(strID, vbTab)
            PostalBundle = NextValue(strID, vbTab)
            PaperConfig = NextValue(strID, vbTab)
            Page_num = NextValue(strID, vbTab)
            mvStartLitho = NextValue(strID, vbTab)
            mvEndLitho = NextValue(strID, vbTab)
            strBundled = NextValue(strID, vbTab)
            strMailedOn = NextValue(strID, vbTab)
            n = frmMain.tvTreeView.Nodes(X).Image
            n = (n \ TotalStates) * TotalStates + Printing
            If Not oQueueManager.GetRePrintBundle(Survey_id, PostalBundle, PaperConfig, Page_num, strBundled) Then
                MsgBox "No surveys were printed for the " & PostalBundle & " bundle!", vbExclamation, "Print Warning"
            End If
            If strMailedOn = "Not Mailed" Then
                n = (n \ TotalStates) * TotalStates + Bundle
            Else
                n = (n \ TotalStates) * TotalStates + AlreadyMailed
            End If
            frmMain.tvTreeView.Nodes(X).Image = n
        Next X
    End If
    ' This will go through all the children for
    ' the selected paper configuration
    Me.MousePointer = vbDefault
    nodSelected.Image = (nodSelected.Image \ TotalStates) * TotalStates + Configuration
    RePrintBundles = True
    Exit Function
NoPrint:
    RePrintBundles = False
    
End Function

Private Sub PrepareMailingQueue()
    mbReprint = True
'D    moQueueManager.RePrints = True
    mnuBundle.Visible = False
    mnuSeparater2.Visible = False
    mnuReprint.Caption = "View Print &Queue"
    lblTitle(0).Caption = " Mailing Queue:"
    lblBundlingDate.Visible = False
    Me.Caption = "Mailing Queue Manager"
    mnuMailingDates.Visible = True
    mnuPopupMarkMailing.Visible = True
    mnuBundlingReport.Visible = True
End Sub

Private Sub tvTreeView_Expand(ByVal Node As ComctlLib.Node)
'I DV 8/12/99 - This is the event that we want to use to identify
'I DV 8/12/99 - what they clicked on the Tree View for expanding.
    
    ButtonUsed = -1
    If Node.Text <> "" Then
        ShowProperties Node
    End If
    Node.Selected = True
    
End Sub

Public Property Get ButtonUsed() As Long
    
    ButtonUsed = mlButtonUsed
    
End Property

Public Property Let ButtonUsed(ByVal lData As Long)
    
    mlButtonUsed = lData
    
End Property
