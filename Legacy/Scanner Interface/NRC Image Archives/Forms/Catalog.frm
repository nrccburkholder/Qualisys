VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Object = "{BC691F0A-3A98-11D1-9464-00AA006F7AF1}#5.0#0"; "GSENHLV.OCX"
Object = "{57F57641-590A-11D1-9464-00AA006F7AF1}#1.0#0"; "GSCBOBOX.OCX"
Begin VB.Form frmCatalog 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Catalog TIFFs"
   ClientHeight    =   6015
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6030
   Icon            =   "Catalog.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6015
   ScaleWidth      =   6030
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdSelect 
      Caption         =   "Default"
      Height          =   435
      Index           =   2
      Left            =   2400
      TabIndex        =   12
      Top             =   5160
      Width           =   1035
   End
   Begin VB.CommandButton cmdSelect 
      Caption         =   "Select All"
      Height          =   435
      Index           =   0
      Left            =   120
      TabIndex        =   7
      Top             =   5160
      Width           =   1035
   End
   Begin VB.CommandButton cmdSelect 
      Caption         =   "Unselect All"
      Height          =   435
      Index           =   1
      Left            =   1260
      TabIndex        =   8
      Top             =   5160
      Width           =   1035
   End
   Begin VB.Frame fraLocation 
      Caption         =   " Template Folder Location "
      Height          =   1215
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   5775
      Begin GSEnhComboBox.GSComboBox cboArchiveLabel 
         Height          =   315
         Left            =   1440
         TabIndex        =   2
         Top             =   300
         Width           =   4155
         _ExtentX        =   7329
         _ExtentY        =   556
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         AllowNew        =   -1  'True
         MaxLength       =   12
      End
      Begin VB.CommandButton cmdBrowse 
         Caption         =   "..."
         Height          =   315
         Left            =   5220
         TabIndex        =   5
         Top             =   720
         Width           =   375
      End
      Begin VB.TextBox txtLocation 
         Height          =   315
         Left            =   1440
         Locked          =   -1  'True
         TabIndex        =   4
         Top             =   720
         Width           =   3735
      End
      Begin VB.Label lblCaption 
         Caption         =   "Archive Label:"
         Height          =   255
         Index           =   1
         Left            =   180
         TabIndex        =   1
         Top             =   360
         Width           =   1215
      End
      Begin VB.Label lblCaption 
         Caption         =   "Location:"
         Height          =   255
         Index           =   0
         Left            =   180
         TabIndex        =   3
         Top             =   780
         Width           =   1215
      End
   End
   Begin VB.CommandButton cmdFinished 
      Caption         =   "Finished"
      Height          =   435
      Left            =   4860
      TabIndex        =   10
      Top             =   5160
      Width           =   1035
   End
   Begin VB.CommandButton cmdCatalog 
      Caption         =   "Catalog"
      Enabled         =   0   'False
      Height          =   435
      Left            =   3720
      TabIndex        =   9
      Top             =   5160
      Width           =   1035
   End
   Begin ComctlLib.StatusBar sbrCatalog 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   11
      Top             =   5715
      Width           =   6030
      _ExtentX        =   10636
      _ExtentY        =   529
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   5
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   7197
            TextSave        =   ""
            Key             =   "Status"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Bevel           =   0
            Object.Width           =   106
            MinWidth        =   106
            TextSave        =   ""
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel3 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            Object.Width           =   1270
            MinWidth        =   1270
            Text            =   "0"
            TextSave        =   "0"
            Key             =   "Count"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel4 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            Object.Width           =   635
            MinWidth        =   635
            Text            =   "of"
            TextSave        =   "of"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel5 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            Object.Width           =   1270
            MinWidth        =   1270
            Text            =   "0"
            TextSave        =   "0"
            Key             =   "Total"
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin GSEnhListView.GSListView lvwTemplates 
      Height          =   3555
      Left            =   120
      TabIndex        =   6
      Top             =   1440
      Width           =   5775
      _ExtentX        =   10186
      _ExtentY        =   6271
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
      MouseIcon       =   "Catalog.frx":0442
      View            =   3
      FullRowSelect   =   -1  'True
      CheckBoxes      =   -1  'True
      SortType        =   2
   End
End
Attribute VB_Name = "frmCatalog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private WithEvents moBrowseDlg As CCRPBrowseDlgSvr5.BrowseDialog
Attribute moBrowseDlg.VB_VarHelpID = -1

Private Property Let LockForm(ByVal bData As Boolean)
    
    Dim nCnt As Integer
    
    cboArchiveLabel.Enabled = Not bData
    txtLocation.Enabled = Not bData
    cmdBrowse.Enabled = Not bData
    lvwTemplates.Enabled = Not bData
    cmdSelect(0).Enabled = Not bData
    cmdSelect(1).Enabled = Not bData
    cmdSelect(2).Enabled = Not bData
    cmdCatalog.Enabled = Not bData
    cmdFinished.Enabled = Not bData
    
End Property

Private Sub cmdBrowse_Click()
    
    Dim sPath       As String
    Dim sSql        As String
    Dim sTempList   As String
    Dim lBatches    As Long
    Dim lTemplates  As Long
    Dim dtStart     As Date
    Dim dtFinish    As Date
    Dim oFileSys    As Scripting.FileSystemObject
    Dim oRootFolder As Scripting.Folder
    Dim oTemplate   As Scripting.Folder
    Dim oBatch      As Scripting.Folder
    Dim oItem       As GSEnhListView.GSListItem
    Dim oTemplateRs As ADODB.Recordset
    
    'Make sure the label is specified first
    If Len(Trim(cboArchiveLabel.Text)) = 0 Then
        MsgBox "Archive Label must be filled in!"
        cboArchiveLabel.SetFocus
        Exit Sub
    End If
    
    'Setup the form
    Screen.MousePointer = vbHourglass
    LockForm = True
    dtStart = Now
    
    'Setup the status bar
    With sbrCatalog
        .Panels("Status").Text = "Scanning For Templates..."
        .Panels("Count").Text = "0"
        .Panels("Total").Text = "0"
        .Refresh
    End With
    
    'Clear previous settings
    lvwTemplates.ListItems.Clear
    cmdCatalog.Enabled = False
    
    'Browse for the folder
    With moBrowseDlg
        .Prompt1 = "Select a Folder"
        .SelectedFolder = txtLocation.Text
        .AllowNewFolder = False
        
        If .Browse Then
            'Update the screen
            sPath = .SelectedFolder
        Else
            txtLocation.Text = ""
            Screen.MousePointer = vbNormal
            LockForm = False
            Exit Sub
        End If
    End With
    
    'Update the screen
    If Right$(sPath, 1) <> "\" Then sPath = sPath & "\"
    With txtLocation
        .Text = sPath
        .Refresh
    End With
    
    'Get the file system objects
    Set oFileSys = New Scripting.FileSystemObject
    Set oRootFolder = oFileSys.GetFolder(sPath)
    
    'Set the status bar
    sbrCatalog.Panels("Total").Text = oRootFolder.SubFolders.Count
    
    'Get existing template data
    sSql = "SELECT DISTINCT sTemplateLabel " & _
           "FROM ImageArchive " & _
           "WHERE sArchiveLabel = '" & cboArchiveLabel.Text & "' " & _
           "ORDER BY sTemplateLabel"
    Set oTemplateRs = goConn.Execute(sSql)
    
    'Build the template search string
    With oTemplateRs
        Do Until .EOF
            'Add this one to the string
            sTempList = sTempList & IIf(Len(sTempList) = 0, "'", ",'") & !sTemplateLabel & "'"
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With
    
    'Close the recordset
    oTemplateRs.Close: Set oTemplateRs = Nothing
    
    'Populate the listview
    For Each oTemplate In oRootFolder.SubFolders
        'Determine if this template has any batches to catalog
        lBatches = 0
        For Each oBatch In oTemplate.SubFolders
            If oFileSys.FolderExists(oBatch.Path & "\Images\000") Then
                lBatches = lBatches + 1
            End If
        Next oBatch
        
        'If there are batches to be cataloged then add it to the listview
        If lBatches > 0 Then
            'Add this template to the list
            Set oItem = lvwTemplates.ListItems.Add(, "TMP" & oTemplate.Name, oTemplate.Name)
            oItem.SubItems(1) = lBatches
            
            'Determine if this one exists already
            If InStr(sTempList, "'" & oTemplate.Name & "'") > 0 Then
                oItem.SubItems(2) = "Yes"
                oItem.Checked = False
                oItem.Tag = False
            Else
                oItem.SubItems(2) = "No"
                oItem.Checked = True
                oItem.Tag = True
            End If
        End If
        
        'Update the status bar
        lTemplates = lTemplates + 1
        sbrCatalog.Panels("Count").Text = lTemplates
    Next oTemplate
    
    'Cleanup
    Set oFileSys = Nothing
    Set oRootFolder = Nothing
    Set oTemplate = Nothing
    Set oBatch = Nothing
    Set oItem = Nothing
    
    'Update status bar
    dtFinish = Now
    With sbrCatalog
        .Panels("Status").Text = "Total time elapsed: " & Format(dtFinish - dtStart, "hh:nn:ss")
        .Panels("Count").Text = 0
        .Panels("Total").Text = lvwTemplates.ListItems.Count
        .Refresh
    End With
    
    'Reset mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub cmdFinished_Click()
    
    Unload Me
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   cmdCatalog_Click
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   00-00-2000
'\\
'\\ Description:    This routine is executed in responce to the user
'\\                 clicking on the Catalog button and actually performs
'\\                 the cataloging operation.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     10-31-00    JJF     Changed so we are calculating the LithoCode
'\\                         for non-QualPro surveys.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub cmdCatalog_Click()
    
    Dim sMsg            As String
    Dim sSql            As String
    Dim sInList         As String
    Dim sPath           As String
    Dim sArchiveLabel   As String
    Dim sBarCode        As String
    Dim sLithoCode      As String
    Dim sExtension      As String
    Dim bTransRunning   As Boolean
    Dim nCnt            As Integer
    Dim nBatchCnt       As Integer
    Dim lQtyBatches     As Long
    Dim lQtyTemplates   As Long
    Dim dtStart         As Date
    Dim dtFinish        As Date
    Dim oItem           As GSEnhListView.GSListItem
    Dim oInsertCm       As ADODB.Command
    Dim oFileSys        As Scripting.FileSystemObject
    Dim oTemplate       As Scripting.Folder
    Dim oBatch          As Scripting.Folder
    Dim oBatchImage     As Scripting.Folder
    Dim oGroup          As Scripting.Folder
    Dim oFile           As Scripting.File
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Determine how many Templates are selected
    For Each oItem In lvwTemplates.ListItems
        If oItem.Checked Then
            'Increment the count
            lQtyTemplates = lQtyTemplates + 1
            lQtyBatches = lQtyBatches + oItem.SubItems(1)
            
            'Determine if this one exists
            If Not oItem.Tag Then
                sInList = sInList & IIf(Len(sInList) = 0, "'", ",'") & oItem.Text & "'"
            End If
        End If
    Next oItem
    Set oItem = Nothing
    
    'If none are checked then head out of dodge
    If lQtyTemplates = 0 Then Exit Sub
    
    'Setup the form
    Screen.MousePointer = vbHourglass
    LockForm = True
    dtStart = Now
    
    'Check to see if any of the selected templates already exist
    sArchiveLabel = cboArchiveLabel.Text
    If Len(sInList) > 0 Then
        'Some of the selected templates already exist so ask the user what to do
        sMsg = "The catalog already contains entries for" & vbCrLf & _
               "some of the selected templates!" & vbCrLf & vbCrLf & _
               "Do you wish to continue?"
        If MsgBox(sMsg, vbDefaultButton2 + vbQuestion + vbYesNo) = vbYes Then
            'User says to delete them
            sbrCatalog.Panels("Status").Text = "Deleting Selected Templates..."
            sSql = "DELETE FROM ImageArchive " & _
                   "WHERE sArchiveLabel = '" & sArchiveLabel & "' " & _
                   "  AND sTemplateLabel IN (" & sInList & ")"
            goConn.Execute CommandText:=sSql
        Else
            'User chickened out
            GoTo AllDoneHere
        End If
    End If
        
    'Setup the status bar
    With sbrCatalog
        .Panels("Status").Text = "Cataloging..."
        .Panels("Count").Text = "0"
        .Panels("Total").Text = lQtyBatches
        .Refresh
    End With
    
    'Create the insert statement
    sSql = "INSERT INTO ImageArchive " & _
           "       (sBarcode, sLithoCode, sArchiveLabel, sTemplateLabel, sBatchLabel, " & _
           "       sFileName, dtArchiveDate) " & _
           "VALUES (?, ?, ?, ?, ?, ?, GetDate())"
    Set oInsertCm = New ADODB.Command
    With oInsertCm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("Barcode", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("LithoCode", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("ArchiveLabel", adVarChar, adParamInput, 12)
        .Parameters.Append .CreateParameter("TemplateLabel", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("BatchLabel", adVarChar, adParamInput, 8)
        .Parameters.Append .CreateParameter("FileName", adVarChar, adParamInput, 255)
        .Prepared = True
    End With 'oInsertCm
    
    'Set the path
    sPath = txtLocation.Text
    
    'Get the file system objects
    Set oFileSys = New Scripting.FileSystemObject
    
    'Loop through all of the templates in the listview
    For Each oItem In lvwTemplates.ListItems
        
        'If the template is selected then catalog it
        If oItem.Checked Then
            
            'Get the folder object for the template
            Set oTemplate = oFileSys.GetFolder(sPath & "\" & oItem.Text)
            
            'Loop through all the batches in this template
            nBatchCnt = 0
            For Each oBatch In oTemplate.SubFolders
                
                'If the batch contains an Image folder then catalog it
                If oFileSys.FolderExists(oBatch.Path & "\Images") Then
                    
                    'Start a transaction
                    bTransRunning = True
                    goConn.BeginTrans
                    
                    'Update the status bar
                    nBatchCnt = nBatchCnt + 1
                    With sbrCatalog
                        .Panels("Status").Text = "Cataloging " & oTemplate.Name & " " & nBatchCnt & " of " & oItem.SubItems(1) & "..."
                        With .Panels("Count")
                            .Text = Val(.Text) + 1
                        End With
                        .Refresh
                    End With
                    
                    'Get a reference to the Images folder
                    Set oBatchImage = oFileSys.GetFolder(oBatch.Path & "\Images")
                    
                    'Loop through all the group folders in this batch
                    For Each oGroup In oBatchImage.SubFolders
                        
                        'Loop through all the files in this group
                        For Each oFile In oGroup.Files
                            
                            'Get the file extension
                            sExtension = UCase(oFileSys.GetExtensionName(oFile.Path))
                            sBarCode = oFileSys.GetFileName(oFile.Path)
                            
                            'Only catalog .TIF and numeric (.000, .001) extensions
                            If sExtension = "TIF" Or IsNumeric(sExtension) Then
                                
                                'Get the barcode and lithocode
                                sBarCode = Left(sBarCode, Len(sBarCode) - Len(sExtension) - 1)
                                If Len(sBarCode) <= 8 Then
                                    'This is a QualPro barcode so get the litho
                                    sBarCode = Left(sBarCode, 7)    'No need for the check digit
                                    sLithoCode = UnCrunch(sBarCode:=Left(sBarCode, 6))
                                Else
                                    'This is non-QualPro
                                    '** Modified 10-31-00 JJF
                                    'sLithoCode = "0"
                                    sBarCode = Left(sBarCode, 9)    'No need for the check digit
                                    sLithoCode = UnCrunch(sBarCode:=Left(sBarCode, 5))
                                    '** End of modifications 10-31-00 JJF
                                End If
                                
                                'Add this image to the database
                                With oInsertCm
                                    .Parameters("Barcode") = sBarCode
                                    .Parameters("LithoCode") = sLithoCode
                                    .Parameters("ArchiveLabel") = sArchiveLabel
                                    .Parameters("TemplateLabel") = oItem.Text
                                    .Parameters("BatchLabel") = oBatch.Name
                                    
                                    'Determine what to save for the filename
                                    If Mid(oFile.Path, 2, 1) = ":" Then
                                        'We are working with a local drive or mapped
                                        '  network drive so strip the drive letter
                                        .Parameters("FileName") = Mid(oFile.Path, 3)
                                    ElseIf Left(oFile.Path, 2) = "\\" Then
                                        'We are working with a UNC path so strip the
                                        '  server name and share name
                                        nCnt = InStr(3, oFile.Path, "\")        'Between server and share
                                        nCnt = InStr(nCnt + 1, oFile.Path, "\") 'Between share and path
                                        .Parameters("FileName") = Mid(oFile.Path, nCnt)
                                    Else
                                        'Unknown condition so save the entire path
                                        .Parameters("FileName") = oFile.Path
                                    End If
                                    
                                    'Add the image to the DB
                                    .Execute
                                End With
                                
                                'Refresh the screen
                                DoEvents
                                
                            End If
                        Next oFile
                    Next oGroup
                                    
                    'Commit this batch to the DB
                    goConn.CommitTrans
                    bTransRunning = False
                End If
            Next oBatch
            
            'Mark this template as existing
            With oItem
                .Tag = False
                .Checked = False
                .SubItems(2) = "Yes"
            End With
        End If
    Next oItem
    
AllDoneHere:
    'Cleanup
    Set oItem = Nothing
    Set oInsertCm = Nothing
    Set oTemplate = Nothing
    Set oBatch = Nothing
    Set oBatchImage = Nothing
    Set oGroup = Nothing
    Set oFile = Nothing
    Set oFileSys = Nothing
    
    'Update status bar
    dtFinish = Now
    With sbrCatalog
        .Panels("Status").Text = "Total time elapsed: " & Format(dtFinish - dtStart, "hh:nn:ss")
        .Refresh
    End With
    
    'Reset mousepointer
    LockForm = False
    Screen.MousePointer = vbNormal
    
Exit Sub


ErrorHandler:
    'If a trasaction is in progress roll it back
    If bTransRunning Then
        goConn.RollbackTrans
    End If
    
    sMsg = "The following unexpected error was encountered!" & vbCrLf & vbCrLf & _
           "Error #: " & Err.Number & vbCrLf & _
           "Source: " & Err.Source & vbCrLf & _
           "Description: " & Err.Description
    MsgBox sMsg, vbCritical
    Resume AllDoneHere
    
End Sub

Private Sub cmdSelect_Click(nIndex As Integer)
    
    Dim oItem   As GSEnhListView.GSListItem
    
    'Set the check values according to the button clicked
    For Each oItem In lvwTemplates.ListItems
        'Determine the action to be taken
        Select Case nIndex
            Case 0  'Select All
                oItem.Checked = True
            Case 1  'Unselect All
                oItem.Checked = False
            Case 2  'Default
                oItem.Checked = oItem.Tag
        End Select
    Next oItem
    
End Sub

Private Sub Form_Load()
    
    Dim sSql As String
    Dim oTempRS As ADODB.Recordset
    
    'Initialize the browse dialog
    Set moBrowseDlg = New CCRPBrowseDlgSvr5.BrowseDialog
    With moBrowseDlg
        .AllowNewFolder = False
        .BrowseMode = bdBrowseFSFoldersOnly
        .hwndOwner = Me.hWnd
        .PositionMode = bdPositionCenterOwner
        .ShowPrompt2 = True
        .Sizable = True
    End With
    
    'Setup the listview
    With lvwTemplates
        With .ColumnHeaders
            .Add , "Template", "Template Label", 1800, gslvColumnLeft, gslvAsText
            .Add , "Batches", "Qty Of Batches", 1800, gslvColumnRight, gslvAsNumber
            .Add , "Exists", "Already Exists", 1800, gslvColumnCenter, gslvAsText
        End With
    End With
    
    'Load the ArchiveLabel list
    sSql = "SELECT DISTINCT sArchiveLabel FROM ImageArchive ORDER BY sArchiveLabel"
    Set oTempRS = goConn.Execute(sSql)
    With oTempRS
        Do Until .EOF
            'Add this label
            cboArchiveLabel.AddItem !sArchiveLabel
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    oTempRS.Close: Set oTempRS = Nothing
    
    'Reset the mouse pointer
    Screen.MousePointer = vbNormal
    
End Sub


Private Sub Form_Unload(Cancel As Integer)
    
    If gbStartCatalog Then
        goConn.Close: Set goConn = Nothing
    End If
    
End Sub


Private Sub moBrowseDlg_SelectionChanged(OKEnabled As Boolean)
    
    'Update the dialog
    With moBrowseDlg
        'Set the prompt2 to the selected folder path
        .Prompt2 = .SelectedFolder.Name
    End With
    
End Sub

Private Sub txtLocation_GotFocus()
    
    SelectAllText ctrControl:=txtLocation
    
End Sub


