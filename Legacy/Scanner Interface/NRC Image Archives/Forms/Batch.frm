VERSION 5.00
Object = "{BC691F0A-3A98-11D1-9464-00AA006F7AF1}#5.0#0"; "GSENHLV.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmBatch 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Create Batch File"
   ClientHeight    =   6495
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5070
   Icon            =   "Batch.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6495
   ScaleWidth      =   5070
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fraBatchType 
      Caption         =   " Selection Type "
      Height          =   3135
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   4815
      Begin GSEnhListView.GSListView lvwArchives 
         Height          =   2115
         Left            =   420
         TabIndex        =   3
         Top             =   840
         Width           =   4215
         _ExtentX        =   7435
         _ExtentY        =   3731
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
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
         MouseIcon       =   "Batch.frx":0442
         View            =   3
         FullRowSelect   =   -1  'True
         CheckBoxes      =   -1  'True
         GridLines       =   -1  'True
         SortType        =   2
      End
      Begin VB.OptionButton optBatchType 
         Caption         =   "Create Using Selected Archives"
         Height          =   195
         Index           =   1
         Left            =   180
         TabIndex        =   2
         Top             =   600
         Width           =   4455
      End
      Begin VB.OptionButton optBatchType 
         Caption         =   "Create Using Selected Images"
         Height          =   195
         Index           =   0
         Left            =   180
         TabIndex        =   1
         Top             =   300
         Width           =   4455
      End
   End
   Begin MSComDlg.CommonDialog dlgBatch 
      Left            =   180
      Top             =   5940
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   2640
      TabIndex        =   16
      Top             =   5940
      Width           =   1095
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3840
      TabIndex        =   17
      Top             =   5940
      Width           =   1095
   End
   Begin VB.Frame fraPaths 
      Caption         =   " Paths "
      Height          =   2475
      Left            =   120
      TabIndex        =   4
      Top             =   3300
      Width           =   4815
      Begin VB.CommandButton cmdFilePath 
         Caption         =   "..."
         Height          =   315
         Left            =   4260
         TabIndex        =   13
         Top             =   1980
         Width           =   375
      End
      Begin VB.TextBox txtFilePath 
         Height          =   315
         Left            =   180
         Locked          =   -1  'True
         TabIndex        =   12
         Top             =   1980
         Width           =   4035
      End
      Begin VB.TextBox txtFileName 
         Height          =   315
         Left            =   180
         Locked          =   -1  'True
         TabIndex        =   14
         Top             =   1980
         Width           =   4035
      End
      Begin VB.CommandButton cmdFileName 
         Caption         =   "..."
         Height          =   315
         Left            =   4260
         TabIndex        =   15
         Top             =   1980
         Width           =   375
      End
      Begin VB.TextBox txtCopyTo 
         Height          =   315
         Left            =   180
         Locked          =   -1  'True
         TabIndex        =   9
         Top             =   1260
         Width           =   4035
      End
      Begin VB.CommandButton cmdCopyTo 
         Caption         =   "..."
         Height          =   315
         Left            =   4260
         TabIndex        =   10
         Top             =   1260
         Width           =   375
      End
      Begin VB.TextBox txtLocation 
         Height          =   315
         Left            =   180
         Locked          =   -1  'True
         TabIndex        =   6
         Top             =   540
         Width           =   4035
      End
      Begin VB.CommandButton cmdLocation 
         Caption         =   "..."
         Height          =   315
         Left            =   4260
         TabIndex        =   7
         Top             =   540
         Width           =   375
      End
      Begin VB.Label lblFileName 
         Caption         =   "Batch Filename:"
         Height          =   195
         Left            =   180
         TabIndex        =   11
         Top             =   1740
         Width           =   4455
      End
      Begin VB.Label lblCaption 
         Caption         =   "Copy To ( Full Path ):"
         Height          =   195
         Index           =   1
         Left            =   180
         TabIndex        =   8
         Top             =   1020
         Width           =   4455
      End
      Begin VB.Label lblCaption 
         Caption         =   "Image Location ( Drive Letter [C:] or UNC [\\Nrc9\Nrc9] ):"
         Height          =   195
         Index           =   0
         Left            =   180
         TabIndex        =   5
         Top             =   300
         Width           =   4455
      End
   End
End
Attribute VB_Name = "frmBatch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mbActivated As Boolean
    Private mbOKClicked As Boolean
    
    Private WithEvents moBrowseDlg As CCRPBrowseDlgSvr5.BrowseDialog
Attribute moBrowseDlg.VB_VarHelpID = -1
    
Private Function CreatePath(ByVal sPath As String) As Boolean
    
    Dim sParentPath As String
    Dim oFileSys    As Scripting.FileSystemObject
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Get a reference to the file system
    Set oFileSys = New Scripting.FileSystemObject
    
    'Check to see if the parent folder exists
    sParentPath = oFileSys.GetParentFolderName(sPath)
    If Not oFileSys.FolderExists(sParentPath) Then
        'The parent folder does not exist so create it
        If Not CreatePath(sPath:=sParentPath) Then
            CreatePath = False
            Exit Function
        End If
    End If
    
    'Create this folder
    oFileSys.CreateFolder sPath
    CreatePath = True
    
    'Cleanup
    Set oFileSys = Nothing
    
Exit Function


ErrorHandler:
    CreatePath = False
    Exit Function
    
End Function

Private Function IsDataValid() As Boolean
    
    Dim bSelected   As Boolean
    Dim sMsg        As String
    Dim oFileSys    As Scripting.FileSystemObject
    Dim oItem       As GSEnhListView.GSListItem
    
    'Get a reference to the file system
    Set oFileSys = New Scripting.FileSystemObject
    
    'Determine if anything is selected
    For Each oItem In lvwArchives.ListItems
        If oItem.Checked Then
            bSelected = True
            Exit For
        End If
    Next oItem
    Set oItem = Nothing
    
    'Validate the input
    If BatchType = btcSelectedArchives And Not bSelected Then
        sMsg = "You must select at least one Archive!"
        lvwArchives.SetFocus
    ElseIf Len(Trim(txtLocation.Text)) = 0 Then
        sMsg = "The Image Location must be provided!"
        txtLocation.SetFocus
    ElseIf Not oFileSys.FolderExists(txtLocation.Text) And _
           oFileSys.GetDrive(txtLocation.Text).DriveType <> CDRom Then
        sMsg = "The Image Location must point to a valid path!"
        txtLocation.SetFocus
    ElseIf BatchType = btcSelectedImages And _
           Len(Trim(txtFileName.Text)) = 0 Then
        sMsg = "The Batch Filename must be provided!"
        txtFileName.SetFocus
    ElseIf BatchType = btcSelectedArchives And _
           Len(Trim(txtFilePath.Text)) = 0 Then
        sMsg = "The Batch File Path must be provided!"
        txtFilePath.SetFocus
    ElseIf Len(Trim(txtCopyTo.Text)) = 0 Then
        sMsg = "The Copy To path must be provided!"
        txtCopyTo.SetFocus
    ElseIf Not oFileSys.DriveExists(oFileSys.GetDriveName(txtCopyTo.Text)) Then
        sMsg = "The drive specified in Copy To does not exist!"
        txtCopyTo.SetFocus
    ElseIf BatchType = btcSelectedArchives And _
           Not oFileSys.DriveExists(oFileSys.GetDriveName(txtFilePath.Text)) Then
        sMsg = "The drive specified in Batch File Path does not exist!"
        txtFilePath.SetFocus
    End If
    
    'If we have encountered an error then deal with it
    If Len(sMsg) > 0 Then GoTo DetermineResult
    
    'Now check for a valid copy to path
    If Not oFileSys.FolderExists(txtCopyTo.Text) Then
        sMsg = "The Copy To path does not exist." & vbCrLf & vbCrLf & _
               "Do you want to create it now?"
        If MsgBox(sMsg, vbOKCancel + vbQuestion) = vbOK Then
            If Not CreatePath(txtCopyTo.Text) Then
                sMsg = "Error creating the Copy To folder!"
                txtCopyTo.SetFocus
            Else
                sMsg = ""
            End If
        Else
            sMsg = "The Copy To must point to a valid path!"
            txtCopyTo.SetFocus
        End If
    End If
    
    'If we have encountered an error then deal with it
    If Len(sMsg) > 0 Then GoTo DetermineResult
    
    'Now check for a valid copy to path
    If BatchType = btcSelectedArchives And Not oFileSys.FolderExists(txtFilePath.Text) Then
        sMsg = "The Batch File Path does not exist." & vbCrLf & vbCrLf & _
               "Do you want to create it now?"
        If MsgBox(sMsg, vbOKCancel + vbQuestion) = vbOK Then
            If Not CreatePath(txtFilePath.Text) Then
                sMsg = "Error creating the Batch File Path folder!"
                txtFilePath.SetFocus
            Else
                sMsg = ""
            End If
        Else
            sMsg = "The Batch File Path must point to a valid path!"
            txtFilePath.SetFocus
        End If
    End If
    
DetermineResult:
    'Determine the return value
    If Len(sMsg) > 0 Then
        MsgBox sMsg, vbCritical
        IsDataValid = False
    Else
        IsDataValid = True
    End If
    
    'Cleanup
    Set oFileSys = Nothing
    
End Function

Private Sub cmdCancel_Click()
    
    OKClicked = False
    Me.Hide
    
End Sub


Private Sub cmdCopyTo_Click()
    
    'Setup the form
    Screen.MousePointer = vbHourglass
    
    'Browse for the folder
    With moBrowseDlg
        .Prompt1 = "Select Copy To Path"
        .SelectedFolder = txtCopyTo.Text
        .AllowNewFolder = True
        
        If .Browse Then
            'Update the screen
            txtCopyTo.Text = .SelectedFolder
        Else
            txtCopyTo.Text = ""
        End If
    End With
    
    'Reset mousepointer
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub cmdFileName_Click()
    
    Dim sInitDir As String
    Dim sFileName As String
    Dim oFileSys As Scripting.FileSystemObject
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    
    'Set the error trap
    On Error GoTo DLGErrorHandler
    
    'Get the file data
    sInitDir = Trim(txtFileName.Text)
    If Len(sInitDir) > 0 Then
        Set oFileSys = New Scripting.FileSystemObject
        sFileName = oFileSys.GetFileName(sInitDir)
        sInitDir = Left(sInitDir, Len(sInitDir) - Len(sFileName))
    Else
        sInitDir = App.Path
        sFileName = ""
    End If
    
    'Get the Batch Filename
    With dlgBatch
        .DialogTitle = "Batch File"
        .CancelError = True
        .DefaultExt = ".bat"
        .Filter = "Batch File (*.bat)|*.bat|All Files (*.*)|*.*"
        .FilterIndex = 1
        .Flags = cdlOFNExplorer Or cdlOFNHideReadOnly Or cdlOFNLongNames Or cdlOFNPathMustExist
        .InitDir = sInitDir
        .FileName = sFileName
        
        'Show the dialog
        .ShowSave
        
        'Get the file name
        txtFileName.Text = .FileName
    End With
    
DLGErrorHandler:
    'Reset the mousepointer
    Screen.MousePointer = vbNormal
    
End Sub


Private Sub cmdFilePath_Click()
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    
    'Browse for the folder
    With moBrowseDlg
        .Prompt1 = "Select Batch File Path"
        .SelectedFolder = txtFilePath.Text
        .AllowNewFolder = True
        
        If .Browse Then
            'Update the screen
            txtFilePath.Text = .SelectedFolder
        Else
            txtFilePath.Text = ""
        End If
    End With
    
    'Reset the mousepointer
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub cmdLocation_Click()
    
    'Setup the form
    Screen.MousePointer = vbHourglass
    
    'Browse for the folder
    With moBrowseDlg
        .Prompt1 = "Select Image Location"
        .SelectedFolder = txtLocation.Text
        .AllowNewFolder = False
        
        If .Browse Then
            'Update the screen
            txtLocation.Text = .SelectedFolder
        Else
            txtLocation.Text = ""
        End If
    End With
    
    'Reset mousepointer
    Screen.MousePointer = vbNormal
    
End Sub


Private Sub cmdOK_Click()
        
    If IsDataValid Then
        OKClicked = True
        Me.Hide
    End If
    
End Sub

Public Property Get OKClicked() As Boolean
    
    OKClicked = mbOKClicked
    
End Property

Public Property Let OKClicked(ByVal bData As Boolean)
    
    mbOKClicked = bData
    
End Property



Public Property Get Location() As String
    
    Dim sTemp As String
    
    sTemp = Trim(txtLocation.Text)
    If Right(sTemp, 1) = "\" Then
        sTemp = Left(sTemp, Len(sTemp) - 1)
    End If
    
    Location = sTemp
    
End Property

Public Property Let Location(ByVal sData As String)
    
    txtLocation = sData
    
End Property

Public Property Get CopyTo() As String
    
    Dim sTemp As String
    
    sTemp = Trim(txtCopyTo.Text)
    If Right(sTemp, 1) = "\" Then
        sTemp = Left(sTemp, Len(sTemp) - 1)
    End If
    
    CopyTo = sTemp
    
End Property

Public Property Let CopyTo(ByVal sData As String)
    
    txtCopyTo.Text = sData
    
End Property

Public Property Get FilePath() As String
    
    FilePath = Trim(txtFilePath.Text)
    
End Property

Public Property Get FileName() As String
    
    FileName = Trim(txtFileName.Text)
    
End Property

Public Property Let FilePath(ByVal sData As String)
    
    txtFilePath.Text = sData
    
End Property

Public Property Let FileName(ByVal sData As String)
    
    txtFileName.Text = sData
    
End Property

Private Sub Form_Activate()
    
    Dim sKey    As String
    Dim oItem   As GSEnhListView.GSListItem
    
    'If the form has already been activated then we are out of here
    If mbActivated Then Exit Sub
    
    'Set the flag
    mbActivated = True
    
    'Populate the archives list view
    For Each oItem In frmMain.lvwImage.ListItems
        sKey = "K" & oItem.SubItems(2)
        If lvwArchives.ListItems(sKey) Is Nothing Then
            lvwArchives.ListItems.Add , sKey, oItem.SubItems(2), , "Image"
        End If
    Next oItem
    
    'Cleanup
    Set oItem = Nothing
    
End Sub

Private Sub Form_Load()
    
    'Initialize the browse dialog
    Set moBrowseDlg = New CCRPBrowseDlgSvr5.BrowseDialog
    With moBrowseDlg
        .BrowseMode = bdBrowseFSFoldersOnly
        .hwndOwner = Me.hWnd
        .PositionMode = bdPositionCenterOwner
        .ShowPrompt2 = True
        .Sizable = True
    End With
    
    'Initialize the list view
    With lvwArchives
        Set .SmallIcons = frmMain.imlSmall
        .CheckBoxes = True
        .FullRowSelect = True
        .GridLines = True
        .MultiSelect = False
        .SortType = gslvOnColumnClick
        
        'Setup the column headers
        With .ColumnHeaders
            .Add , "ArchLab", "Archive", 3840, gslvColumnLeft, gslvAsText
        End With
    End With
    
End Sub

Private Sub moBrowseDlg_SelectionChanged(OKEnabled As Boolean)
    
    With moBrowseDlg
        'Set the prompt2 to the selected folder path
        .Prompt2 = .SelectedFolder.Name
    End With
    
End Sub


Private Sub optBatchType_Click(nIndex As Integer)
    
    If nIndex = eBatchTypeConstants.btcSelectedImages Then
        lvwArchives.Enabled = False
        lblFileName.Caption = "Batch Filename:"
        txtFileName.Visible = True
        cmdFileName.Visible = True
        txtFilePath.Visible = False
        cmdFilePath.Visible = False
    Else
        lvwArchives.Enabled = True
        lblFileName.Caption = "Batch File Path:"
        txtFileName.Visible = False
        cmdFileName.Visible = False
        txtFilePath.Visible = True
        cmdFilePath.Visible = True
    End If
    
End Sub



Public Property Get BatchType() As eBatchTypeConstants
    
    If optBatchType(0).Value Then
        BatchType = btcSelectedImages
    Else
        BatchType = btcSelectedArchives
    End If
    
End Property

Public Property Let BatchType(ByVal eData As eBatchTypeConstants)
    
    optBatchType(eData).Value = True
    
End Property
