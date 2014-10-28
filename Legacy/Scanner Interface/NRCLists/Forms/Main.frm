VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   7995
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9990
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7995
   ScaleWidth      =   9990
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fraOutput 
      Caption         =   "Output for"
      Height          =   3375
      Left            =   120
      TabIndex        =   34
      Top             =   4500
      Width           =   9735
      Begin VB.CheckBox chkIsLocal 
         Caption         =   "Show Only Local Content"
         Height          =   195
         Left            =   120
         TabIndex        =   36
         Top             =   240
         Value           =   1  'Checked
         Width           =   2295
      End
      Begin MSComctlLib.ListView lvwOutput 
         Height          =   2775
         Left            =   120
         TabIndex        =   35
         Top             =   480
         Width           =   9495
         _ExtentX        =   16748
         _ExtentY        =   4895
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         FullRowSelect   =   -1  'True
         GridLines       =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.Label lblQuantity 
         Alignment       =   1  'Right Justify
         Height          =   195
         Left            =   5700
         TabIndex        =   37
         Top             =   240
         Width           =   3915
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "HCMG Hand Entry Module"
      Height          =   4275
      Index           =   0
      Left            =   120
      TabIndex        =   27
      Top             =   120
      Width           =   2355
      Begin VB.TextBox txtHCMGHETemplateID 
         Height          =   315
         Left            =   120
         TabIndex        =   31
         Text            =   "H001"
         Top             =   480
         Width           =   2115
      End
      Begin VB.TextBox txtHCMGHEBarcode 
         Height          =   315
         Left            =   120
         TabIndex        =   30
         Text            =   "H001001YADA"
         Top             =   1140
         Width           =   2115
      End
      Begin VB.CommandButton cmdHCMGHEInitialize 
         Caption         =   "Initialize at Batch Opening"
         Height          =   555
         Left            =   120
         TabIndex        =   29
         Top             =   2940
         Width           =   2115
      End
      Begin VB.CommandButton cmdHCMGHEGetList 
         Caption         =   "Get List at Each Survey"
         Height          =   555
         Left            =   120
         TabIndex        =   28
         Top             =   3600
         Width           =   2115
      End
      Begin VB.Label Label1 
         Caption         =   "TemplateID:"
         Height          =   195
         Index           =   0
         Left            =   120
         TabIndex        =   33
         Top             =   240
         Width           =   2055
      End
      Begin VB.Label Label1 
         Caption         =   "Barcode:"
         Height          =   195
         Index           =   1
         Left            =   120
         TabIndex        =   32
         Top             =   900
         Width           =   2055
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Qualysis Open End Module"
      Height          =   4275
      Index           =   3
      Left            =   7500
      TabIndex        =   14
      Top             =   120
      Width           =   2355
      Begin VB.TextBox txtQSOETemplateID 
         Height          =   315
         Left            =   120
         TabIndex        =   18
         Text            =   "1441C01"
         Top             =   480
         Width           =   2115
      End
      Begin VB.TextBox txtQSOEQstnCore 
         Height          =   315
         Left            =   120
         TabIndex        =   17
         Text            =   "500001"
         Top             =   1140
         Width           =   2115
      End
      Begin VB.CommandButton cmdQSOEInitialize 
         Caption         =   "Initialize at Batch Opening"
         Height          =   555
         Left            =   120
         TabIndex        =   16
         Top             =   2940
         Width           =   2115
      End
      Begin VB.CommandButton cmdQSOEGetList 
         Caption         =   "Get List at Each Survey/Question"
         Height          =   555
         Left            =   120
         TabIndex        =   15
         Top             =   3600
         Width           =   2115
      End
      Begin VB.Label Label1 
         Caption         =   "TemplateID:"
         Height          =   195
         Index           =   7
         Left            =   120
         TabIndex        =   20
         Top             =   240
         Width           =   2055
      End
      Begin VB.Label Label1 
         Caption         =   "QstnCore:"
         Height          =   195
         Index           =   6
         Left            =   120
         TabIndex        =   19
         Top             =   900
         Width           =   2055
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Qualysis Hand Entry Module"
      Height          =   4275
      Index           =   2
      Left            =   5040
      TabIndex        =   7
      Top             =   120
      Width           =   2355
      Begin VB.TextBox txtQSHELineID 
         Height          =   315
         Left            =   120
         TabIndex        =   25
         Text            =   "1"
         Top             =   2460
         Width           =   2115
      End
      Begin VB.TextBox txtQSHEBubbleID 
         Height          =   315
         Left            =   120
         TabIndex        =   23
         Text            =   "5"
         Top             =   1800
         Width           =   2115
      End
      Begin VB.TextBox txtQSHETemplateID 
         Height          =   315
         Left            =   120
         TabIndex        =   11
         Text            =   "1441C01"
         Top             =   480
         Width           =   2115
      End
      Begin VB.TextBox txtQSHEQstnCore 
         Height          =   315
         Left            =   120
         TabIndex        =   10
         Text            =   "1025"
         Top             =   1140
         Width           =   2115
      End
      Begin VB.CommandButton cmdQSHEInitialize 
         Caption         =   "Initialize at Batch Opening"
         Height          =   555
         Left            =   120
         TabIndex        =   9
         Top             =   2940
         Width           =   2115
      End
      Begin VB.CommandButton cmdQSHEGetList 
         Caption         =   "Get List at Each Survey/Question"
         Height          =   555
         Left            =   120
         TabIndex        =   8
         Top             =   3600
         Width           =   2115
      End
      Begin VB.Label Label1 
         Caption         =   "LineID:"
         Height          =   195
         Index           =   10
         Left            =   120
         TabIndex        =   26
         Top             =   2220
         Width           =   2055
      End
      Begin VB.Label Label1 
         Caption         =   "BubbleID:"
         Height          =   195
         Index           =   9
         Left            =   120
         TabIndex        =   24
         Top             =   1560
         Width           =   2055
      End
      Begin VB.Label Label1 
         Caption         =   "TemplateID:"
         Height          =   195
         Index           =   5
         Left            =   120
         TabIndex        =   13
         Top             =   240
         Width           =   2055
      End
      Begin VB.Label Label1 
         Caption         =   "QstnCore:"
         Height          =   195
         Index           =   4
         Left            =   120
         TabIndex        =   12
         Top             =   900
         Width           =   2055
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "HCMG Open End Module"
      Height          =   4275
      Index           =   1
      Left            =   2580
      TabIndex        =   0
      Top             =   120
      Width           =   2355
      Begin VB.TextBox txtHCMGOEColNum 
         Height          =   315
         Left            =   120
         TabIndex        =   21
         Text            =   "200"
         Top             =   1800
         Width           =   2115
      End
      Begin VB.TextBox txtHCMGOETemplateID 
         Height          =   315
         Left            =   120
         TabIndex        =   4
         Text            =   "H001"
         Top             =   480
         Width           =   2115
      End
      Begin VB.TextBox txtHCMGOEBarcode 
         Height          =   315
         Left            =   120
         TabIndex        =   3
         Text            =   "H001001YADA"
         Top             =   1140
         Width           =   2115
      End
      Begin VB.CommandButton cmdHCMGOEInitialize 
         Caption         =   "Initialize at Batch Opening"
         Height          =   555
         Left            =   120
         TabIndex        =   2
         Top             =   2940
         Width           =   2115
      End
      Begin VB.CommandButton cmdHCMGOEGetList 
         Caption         =   "Get List at Each Survey/Question"
         Height          =   555
         Left            =   120
         TabIndex        =   1
         Top             =   3600
         Width           =   2115
      End
      Begin VB.Label Label1 
         Caption         =   "Column Number:"
         Height          =   195
         Index           =   8
         Left            =   120
         TabIndex        =   22
         Top             =   1560
         Width           =   1875
      End
      Begin VB.Label Label1 
         Caption         =   "TemplateID:"
         Height          =   195
         Index           =   3
         Left            =   120
         TabIndex        =   6
         Top             =   240
         Width           =   1875
      End
      Begin VB.Label Label1 
         Caption         =   "Barcode:"
         Height          =   195
         Index           =   2
         Left            =   120
         TabIndex        =   5
         Top             =   900
         Width           =   1875
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mobjHCMGHEList  As Object
    Private mobjHCMGOEList  As Object
    Private mobjQSHEList    As Object
    Private mobjQSOEList    As Object
    
Private Sub cmdHCMGHEGetList_Click()
    
    Dim objItem     As ListItem
    Dim objCode     As Object
    Dim objCodes    As Object
    Dim lngQuantity As Long
    
    Me.MousePointer = vbHourglass

    'Get the codes
    lblQuantity.Caption = "Loading List...": lblQuantity.Refresh
    Set objCodes = mobjHCMGHEList.GetList(strBarcode:=txtHCMGHEBarcode.Text)
    
    With lvwOutput
        'Add the column headers to the output list view
        With .ColumnHeaders
            .Clear
            .Add , , "CodeID", 960
            .Add , , "Code Name", 7200
            .Add , , "IsLocal", 960
        End With
        
        'Populate the output
        lngQuantity = 0
        With .ListItems
            .Clear
            For Each objCode In objCodes
                If (chkIsLocal.Value = vbChecked And objCode.IsLocal) Or chkIsLocal.Value = vbUnchecked Then
                    Set objItem = .Add(, , objCode.CodeID)
                    objItem.SubItems(1) = objCode.CodeName
                    objItem.SubItems(2) = objCode.IsLocal
                    lngQuantity = lngQuantity + 1
                End If
            Next objCode
        End With
    End With
    
    'Set the quantity shown
    lblQuantity.Caption = "Total Records: " & lngQuantity
    
    'Cleanup
    Set objItem = Nothing
    Set objCode = Nothing
    Set objCodes = Nothing
        
    Me.MousePointer = vbNormal

End Sub

Private Sub cmdHCMGHEInitialize_Click()
    
    Dim datStart    As Date
    
MsgBox "cmdHCMGHEInitialize_Click::Mousepointer"
    Me.MousePointer = vbHourglass
MsgBox "cmdHCMGHEInitialize_Click::Now"
    datStart = Now
    
    'Setup the screen
MsgBox "cmdHCMGHEInitialize_Click::fraOutput.Caption"
    fraOutput.Caption = "Output for HCMG Hand Entry Module"
MsgBox "cmdHCMGHEInitialize_Click::lblQuantity.Caption"
    lblQuantity.Caption = "Initializing...": lblQuantity.Refresh
MsgBox "cmdHCMGHEInitialize_Click::lvwOutput.ListItems.Clear"
    lvwOutput.ListItems.Clear
MsgBox "cmdHCMGHEInitialize_Click::lvwOutput.ColumnHeaders.Clear"
    lvwOutput.ColumnHeaders.Clear
    
    'Create the object
MsgBox "cmdHCMGHEInitialize_Click::Set mobjHCMGHEList = Nothing"
    Set mobjHCMGHEList = Nothing
MsgBox "cmdHCMGHEInitialize_Click::Set mobjHCMGHEList = CreateObject()"
    Set mobjHCMGHEList = CreateObject("NRCLists.HCMGHandEntryList")
    
    'Initialize the object
MsgBox "cmdHCMGHEInitialize_Click::mobjHCMGHEList.Initialize"
    mobjHCMGHEList.Initialize strTemplateID:=txtHCMGHETemplateID.Text
    
MsgBox "cmdHCMGHEInitialize_Click::lblQuantity.Caption"
    lblQuantity.Caption = "Initialized in " & DateDiff("s", datStart, Now) & " seconds"
MsgBox "cmdHCMGHEInitialize_Click::MousePointer"
    Me.MousePointer = vbNormal
    
End Sub


Private Sub cmdHCMGOEGetList_Click()
    
    Dim objItem     As ListItem
    Dim objCode     As Object
    Dim objCodes    As Object
    Dim lngQuantity As Long
        
    Me.MousePointer = vbHourglass

    'Get the codes
    lblQuantity.Caption = "Loading List...": lblQuantity.Refresh
    Set objCodes = mobjHCMGOEList.GetList(strBarcode:=txtHCMGOEBarcode.Text, intColNum:=Val(txtHCMGOEColNum.Text))
    
    With lvwOutput
        'Add the column headers to the output list view
        With .ColumnHeaders
            .Clear
            .Add , , "CodeID", 960
            .Add , , "Code Name", 7200
            .Add , , "IsLocal", 960
        End With
        
        'Populate the output
        lngQuantity = 0
        With .ListItems
            .Clear
            For Each objCode In objCodes
                If (chkIsLocal.Value = vbChecked And objCode.IsLocal) Or chkIsLocal.Value = vbUnchecked Then
                    Set objItem = .Add(, , objCode.CodeID)
                    objItem.SubItems(1) = objCode.CodeName
                    objItem.SubItems(2) = objCode.IsLocal
                    lngQuantity = lngQuantity + 1
                End If
            Next objCode
        End With
    End With
    
    'Set the quantity shown
    lblQuantity.Caption = "Total Records: " & lngQuantity
    
    'Cleanup
    Set objItem = Nothing
    Set objCode = Nothing
    Set objCodes = Nothing
        
    Me.MousePointer = vbNormal

End Sub


Private Sub cmdHCMGOEInitialize_Click()
    
    Dim datStart    As Date
    
    Me.MousePointer = vbHourglass
    datStart = Now
    
    'Setup the screen
    fraOutput.Caption = "Output for HCMG Open End Module"
    lblQuantity.Caption = "Initializing...": lblQuantity.Refresh
    lvwOutput.ListItems.Clear
    lvwOutput.ColumnHeaders.Clear
    
    'Create the object
    If mobjHCMGOEList Is Nothing Then
        Set mobjHCMGOEList = CreateObject("NRCLists.HCMGOpenEndList")
    End If
    
    'Initialize the object
    mobjHCMGOEList.Initialize strTemplateID:=txtHCMGOETemplateID.Text
    
    lblQuantity.Caption = "Initialized in " & DateDiff("s", datStart, Now) & " seconds"
    Me.MousePointer = vbNormal
    

End Sub


Private Sub cmdQSHEGetList_Click()
    
    Dim objItem     As ListItem
    Dim objCode     As Object
    Dim objCodes    As Object
    Dim lngQuantity As Long
        
    Me.MousePointer = vbHourglass

    'Get the codes
    lblQuantity.Caption = "Loading List...": lblQuantity.Refresh
    Set objCodes = mobjQSHEList.GetList(intQstnCore:=Val(txtQSHEQstnCore.Text), _
                                        intBubbleID:=Val(txtQSHEBubbleID.Text), _
                                        intLineID:=Val(txtQSHELineID.Text))
    
    With lvwOutput
        'Add the column headers to the output list view
        With .ColumnHeaders
            .Clear
            .Add , , "CodeID", 960
            .Add , , "Code Name", 7200
            .Add , , "IsLocal", 960
        End With
        
        'Populate the output
        lngQuantity = 0
        With .ListItems
            .Clear
            For Each objCode In objCodes
                If (chkIsLocal.Value = vbChecked And objCode.IsLocal) Or chkIsLocal.Value = vbUnchecked Then
                    Set objItem = .Add(, , objCode.CodeID)
                    objItem.SubItems(1) = objCode.CodeName
                    objItem.SubItems(2) = objCode.IsLocal
                    lngQuantity = lngQuantity + 1
                End If
            Next objCode
        End With
    End With
    
    'Set the quantity shown
    lblQuantity.Caption = "Total Records: " & lngQuantity
    
    'Cleanup
    Set objItem = Nothing
    Set objCode = Nothing
    Set objCodes = Nothing
        
    Me.MousePointer = vbNormal

End Sub

Private Sub cmdQSHEInitialize_Click()
    
    Dim datStart    As Date
    
    Me.MousePointer = vbHourglass
    datStart = Now
    
    'Setup the screen
    fraOutput.Caption = "Output for Qualysis Hand Entry Module"
    lblQuantity.Caption = "Initializing...": lblQuantity.Refresh
    lvwOutput.ListItems.Clear
    lvwOutput.ColumnHeaders.Clear
    
    'Create the object
    Set mobjQSHEList = Nothing
    Set mobjQSHEList = CreateObject("NRCLists.QSHandEntryList")
    
    'Initialize the object
    mobjQSHEList.Initialize strTemplateID:=txtQSHETemplateID.Text
    
    lblQuantity.Caption = "Initialized in " & DateDiff("s", datStart, Now) & " seconds"
    Me.MousePointer = vbNormal
    
End Sub


Private Sub cmdQSOEGetList_Click()
    
    Dim objItem         As ListItem
    Dim objCode         As Object
    Dim objHeader       As Object
    Dim objHeaders      As Object
    Dim objSubHeader    As Object
    Dim lngQuantity     As Long
        
    Me.MousePointer = vbHourglass

    'Get the codes
    lblQuantity.Caption = "Loading List...": lblQuantity.Refresh
    Set objHeaders = mobjQSOEList.GetList(intQstnCore:=Val(txtQSHEQstnCore.Text))
    
    With lvwOutput
        'Add the column headers to the output list view
        With .ColumnHeaders
            .Clear
            .Add , , "HeaderID", 900
            .Add , , "Header Name", 1440
            .Add , , "SubHeaderID", 900
            .Add , , "SubHeader Name", 1440
            .Add , , "CodeID", 900
            .Add , , "Code Name", 2600
            .Add , , "IsLocal", 900
        End With
        
        'Populate the output
        lngQuantity = 0
        With .ListItems
            .Clear
            For Each objHeader In objHeaders
                Set objItem = .Add(, , objHeader.HeaderID)
                objItem.SubItems(1) = objHeader.HeaderName
                
                For Each objSubHeader In objHeader.SubHeaders
                    If objItem Is Nothing Then
                        Set objItem = .Add(, , "")
                    End If
                    objItem.SubItems(2) = objSubHeader.SubHeaderID
                    objItem.SubItems(3) = objSubHeader.SubHeaderName
                    
                    For Each objCode In objSubHeader.Codes
                        If objItem Is Nothing Then
                            Set objItem = .Add(, , "")
                        End If
                        objItem.SubItems(4) = objCode.CodeID
                        objItem.SubItems(5) = objCode.CodeName
                        objItem.SubItems(6) = objCode.IsLocal
                        
                        Set objItem = Nothing
                        lngQuantity = lngQuantity + 1
                    Next objCode
                    
                    Set objItem = Nothing
                Next objSubHeader
                
                Set objItem = Nothing
            Next objHeader
        End With
    End With
    
    'Set the quantity shown
    lblQuantity.Caption = "Total Records: " & lngQuantity
    
    'Cleanup
    Set objItem = Nothing
    Set objCode = Nothing
    Set objHeader = Nothing
    Set objHeaders = Nothing
    Set objSubHeader = Nothing
    
    Me.MousePointer = vbNormal

End Sub

Private Sub cmdQSOEInitialize_Click()
    
    Dim datStart    As Date
    
    Me.MousePointer = vbHourglass
    datStart = Now
    
    'Setup the screen
    fraOutput.Caption = "Output for Qualysis Open End Module"
    lblQuantity.Caption = "Initializing...": lblQuantity.Refresh
    lvwOutput.ListItems.Clear
    lvwOutput.ColumnHeaders.Clear
    
    'Create the object
    Set mobjQSOEList = Nothing
    Set mobjQSOEList = CreateObject("NRCLists.QSOpenEndList")
    
    'Initialize the object
    mobjQSOEList.Initialize strTemplateID:=txtQSOETemplateID.Text
    
    lblQuantity.Caption = "Initialized in " & DateDiff("s", datStart, Now) & " seconds"
    Me.MousePointer = vbNormal
    
End Sub


