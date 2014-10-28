VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Object = "{BC691F0A-3A98-11D1-9464-00AA006F7AF1}#5.0#0"; "GSENHLV.OCX"
Begin VB.Form frmMain 
   Caption         =   "NRC Image Archives"
   ClientHeight    =   5985
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   8850
   Icon            =   "Main.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5985
   ScaleWidth      =   8850
   StartUpPosition =   3  'Windows Default
   Begin ComctlLib.Toolbar tbrMain 
      Align           =   1  'Align Top
      Height          =   420
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   8850
      _ExtentX        =   15610
      _ExtentY        =   741
      ButtonWidth     =   635
      ButtonHeight    =   582
      Appearance      =   1
      ImageList       =   "imlSmall"
      _Version        =   327682
      BeginProperty Buttons {0713E452-850A-101B-AFC0-4210102A8DA7} 
         NumButtons      =   16
         BeginProperty Button1 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Catalog"
            Object.ToolTipText     =   "Catalog..."
            Object.Tag             =   ""
            ImageIndex      =   1
         EndProperty
         BeginProperty Button2 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button3 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Export"
            Object.ToolTipText     =   "Export current view to Excel..."
            Object.Tag             =   ""
            ImageIndex      =   7
         EndProperty
         BeginProperty Button4 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button5 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button6 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "ViewImage"
            Object.ToolTipText     =   "View the Image List"
            Object.Tag             =   ""
            ImageIndex      =   3
            Style           =   2
            Value           =   1
         EndProperty
         BeginProperty Button7 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "ViewRestore"
            Object.ToolTipText     =   "View the Restore List"
            Object.Tag             =   ""
            ImageIndex      =   10
            Style           =   2
         EndProperty
         BeginProperty Button8 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button9 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button10 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Search"
            Object.ToolTipText     =   "Search the Archives..."
            Object.Tag             =   ""
            ImageIndex      =   2
         EndProperty
         BeginProperty Button11 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "LithoCode"
            Object.ToolTipText     =   "Search for specific LithoCodes..."
            Object.Tag             =   ""
            ImageIndex      =   9
         EndProperty
         BeginProperty Button12 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button13 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "CheckAll"
            Object.ToolTipText     =   "Check all entries in list"
            Object.Tag             =   ""
            ImageIndex      =   4
         EndProperty
         BeginProperty Button14 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "UncheckAll"
            Object.ToolTipText     =   "Uncheck all entries in list"
            Object.Tag             =   ""
            ImageIndex      =   5
         EndProperty
         BeginProperty Button15 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Style           =   3
            MixedState      =   -1  'True
         EndProperty
         BeginProperty Button16 {0713F354-850A-101B-AFC0-4210102A8DA7} 
            Key             =   "Batch"
            Object.ToolTipText     =   "Create batch file for copying files..."
            Object.Tag             =   ""
            ImageIndex      =   6
         EndProperty
      EndProperty
   End
   Begin GSEnhListView.GSListView lvwImage 
      Height          =   4395
      Left            =   180
      TabIndex        =   2
      Top             =   480
      Width           =   8595
      _ExtentX        =   15161
      _ExtentY        =   7752
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
      MouseIcon       =   "Main.frx":0442
      View            =   3
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      SortType        =   2
   End
   Begin ComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   0
      Top             =   5685
      Width           =   8850
      _ExtentX        =   15610
      _ExtentY        =   529
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   3
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   12515
            TextSave        =   ""
            Key             =   "Status"
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Alignment       =   1
            AutoSize        =   2
            Object.Width           =   1270
            MinWidth        =   1270
            Key             =   "Filter"
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
   Begin GSEnhListView.GSListView lvwRestore 
      Height          =   4395
      Left            =   420
      TabIndex        =   3
      Top             =   780
      Width           =   8595
      _ExtentX        =   15161
      _ExtentY        =   7752
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
      MouseIcon       =   "Main.frx":045E
      View            =   3
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      SortType        =   2
   End
   Begin ComctlLib.ImageList imlSmall 
      Left            =   120
      Top             =   5040
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   255
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   10
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":047A
            Key             =   "Catalog"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0794
            Key             =   "Search"
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0AAE
            Key             =   "Image"
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0DC8
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0EDA
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":0FEC
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":153E
            Key             =   "Export"
         EndProperty
         BeginProperty ListImage8 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1A90
            Key             =   "Litho"
         EndProperty
         BeginProperty ListImage9 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1BA2
            Key             =   "SpecifyLitho"
         EndProperty
         BeginProperty ListImage10 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Main.frx":1CB4
            Key             =   "Restore"
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileCatalog 
         Caption         =   "&Catalog..."
         Shortcut        =   ^C
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExport 
         Caption         =   "&Export To Excel..."
         Shortcut        =   ^E
      End
      Begin VB.Menu mnuFileSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuViewImage 
         Caption         =   "&Image List"
         Checked         =   -1  'True
         Shortcut        =   ^I
      End
      Begin VB.Menu mnuViewRestore 
         Caption         =   "Restore &List"
         Shortcut        =   ^L
      End
      Begin VB.Menu mnuViewSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewArchiveStats 
         Caption         =   "&Archive Statistics..."
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Tools"
      Begin VB.Menu mnuToolsSearch 
         Caption         =   "&Search Archives..."
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuToolsLithoCode 
         Caption         =   "Search &By LithoCode..."
         Shortcut        =   ^B
      End
      Begin VB.Menu mnuToolsSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsSelect 
         Caption         =   "Select &All"
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuToolsSelectNonExpired 
         Caption         =   "Select Only &Non-Expired"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuToolsUnselect 
         Caption         =   "&Unselect All"
         Shortcut        =   ^U
      End
      Begin VB.Menu mnuToolsSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuToolsBatch 
         Caption         =   "Create Batch &File..."
         Shortcut        =   ^F
      End
   End
   Begin VB.Menu mnuRCListView 
      Caption         =   "mnuRCListView"
      Visible         =   0   'False
      Begin VB.Menu mnuRCLVTemplateStats 
         Caption         =   "Template Statistics"
      End
      Begin VB.Menu mnuRCLVBatchStats 
         Caption         =   "Batch Statistics"
      End
      Begin VB.Menu mnuRCLVImageStats 
         Caption         =   "Image Statistics"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private msSimpleSearchWhere As String
    Private moFormBase          As CFormBase98
    Private mlQtySelected       As Long
    Private meRCMenuOption      As eRightClickConstants
    Private msLithoInList       As String
    
    Private Const mksSimpleBaseSQL           As String = "SELECT lImageID, sBarcode, sLithoCode, sArchiveLabel, sTemplateLabel, sBatchLabel, dtArchiveDate, sFileName FROM ImageArchive"
    Private Const mksAdvancedSearchSelect    As String = "SELECT IA.lImageID, IA.sBarcode, IA.sLithoCode, " & vbCrLf & _
                                                         "       IA.sArchiveLabel, IA.sTemplateLabel, " & vbCrLf & _
                                                         "       IA.sBatchLabel, IA.dtArchiveDate, IA.sFileName "
    
Private Sub RequeryDB(ByVal bSpecifyLithoCodes As Boolean)
    
    Dim lCnt    As Long
    Dim sSql    As String
    Dim sFilter As String
    Dim oTempRs As ADODB.Recordset
    Dim oItem   As GSEnhListView.GSListItem
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    
    'Disable the listview and clear it
    sbrMain.Panels("Status").Text = "Clearing current results..."
    mlQtySelected = 0
    With lvwImage
        .ListItems.Clear
        .Enabled = False
    End With
    
    'Determine the Caption
    If bSpecifyLithoCodes Then
        sFilter = "Specify LithoCodes"
        sSql = mksSimpleBaseSQL & " WHERE sLithoCode IN (" & msLithoInList & ")"
    ElseIf goRegSearchMode.Value = smcSimpleSearch Then
        If Len(Trim(msSimpleSearchWhere)) = 0 Then
            sFilter = "All Records"
        Else
            sFilter = Mid(msSimpleSearchWhere, 7)
        End If
        sSql = mksSimpleBaseSQL & " " & msSimpleSearchWhere
    ElseIf goRegSearchMode.Value = smcAdvancedSearch Then
        sFilter = "Advanced Mode"
        sSql = mksAdvancedSearchSelect & vbCrLf & goRegAdvancedSearchFromWhere.Value
    End If
    
    sbrMain.Panels("Filter").Text = "  Filter: [" & sFilter & "]  "
    
    'Get the data
    sbrMain.Panels("Status").Text = "Retrieving records from database..."
    Set oTempRs = goConn.Execute(sSql)
    
    'Populate the listview
    With oTempRs
        lCnt = 0
        Do Until .EOF
            'Add this entry
            lCnt = lCnt + 1
            sbrMain.Panels("Status").Text = "Retrieving record " & lCnt & "..."
            sbrMain.Refresh
            
            Set oItem = lvwImage.ListItems.Add(, "ID" & !lImageID, "" & !sBarCode, , "Image")
            oItem.SubItems(1) = !sLithoCode
            oItem.SubItems(2) = !sArchiveLabel
            oItem.SubItems(3) = !sTemplateLabel
            oItem.SubItems(4) = !sBatchLabel
            oItem.SubItems(5) = Format(!dtArchiveDate, "mm/dd/yyyy hh:nn:ss")
            oItem.SubItems(6) = !sFileName
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With
    
    'Update the status bar
    sbrMain.Panels("Status").Text = lvwImage.ListItems.Count & " Images(s) - " & mlQtySelected & " Selected"
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    Set oItem = Nothing
    
    'Enable the listview
    lvwImage.Enabled = True
    
    'Reset the mousepointer
    Screen.MousePointer = vbNormal
    
End Sub

Private Sub Form_Load()
    
    'Locate the form
    Set moFormBase = New CFormBase98
    moFormBase.Register frmForm:=Me, _
                        lHKey:=gsrsHKEYLocalMachine, _
                        sSection:=gksRegFormLocations
    moFormBase.LocateMe
    
    'Setup the toolbar
    sbrMain.Panels("Version").Text = "  " & GetAppVersion & "  "
    
    'Setup the listview
    With lvwImage
        Set .SmallIcons = imlSmall
        .CheckBoxes = False
        .FullRowSelect = True
        .GridLines = True
        .Enabled = False
        .Visible = True
        .MultiSelect = True
        .SortType = gslvOnColumnClick
        
        'Setup the column headers
        With .ColumnHeaders
            .Add , "Barcode", "Barcode", 1560, gslvColumnLeft, gslvAsText
            .Add , "LithoCode", "LithoCode", 1080, gslvColumnRight, gslvAsNumber
            .Add , "ArchLab", "Archive", 1080, gslvColumnLeft, gslvAsText
            .Add , "TempLab", "Template", 1080, gslvColumnLeft, gslvAsText
            .Add , "BatchLab", "Batch", 1080, gslvColumnLeft, gslvAsText
            .Add , "ArchDate", "Archive Date", 1800, gslvColumnLeft, gslvAsDate
            .Add , "FileName", "File Name", 3000, gslvColumnLeft, gslvAsText
        End With
        
        'Restore the column header widths
        .ColumnHeaders.WidthSettings = goRegMainImageColWidths.Value
    End With
    
    With lvwRestore
        Set .SmallIcons = imlSmall
        .CheckBoxes = False
        .FullRowSelect = True
        .GridLines = True
        .Enabled = False
        .Visible = False
        .MultiSelect = False
        .SortType = gslvOnColumnClick
        
        'Setup the column headers
        With .ColumnHeaders
            .Add , "ArchLab", "Archive", 1560, gslvColumnLeft, gslvAsText
            .Add , "TempLab", "Template", 1080, gslvColumnLeft, gslvAsText
            .Add , "BatchLab", "Batch", 1080, gslvColumnLeft, gslvAsText
        End With
        
        'Restore the column header widths
        .ColumnHeaders.WidthSettings = goRegMainRestoreColWidths.Value
    End With
    
End Sub

Private Sub Form_Resize()
    
    Const knEdgeDist As Integer = 120
    
    'If the form is minimized then exit this place
    If Me.WindowState = vbMinimized Then Exit Sub
    
    'Check the form size
    If Me.Width < 8970 Then Me.Width = 8970
    If Me.Height < 6675 Then Me.Height = 6675
    
    'Locate the listview
    lvwImage.Move knEdgeDist, tbrMain.Height + knEdgeDist / 2, _
                    Me.ScaleWidth - knEdgeDist * 2, _
                    Me.ScaleHeight - tbrMain.Height - sbrMain.Height - knEdgeDist
    
    With lvwImage
        lvwRestore.Move .Left, .Top, .Width, .Height
    End With
    
End Sub


Private Sub Form_Unload(Cancel As Integer)
    
    'Close the database
    goConn.Close: Set goConn = Nothing
    
    'Save the form location
    moFormBase.SaveLocation
    Set moFormBase = Nothing
    
    'Save the listview settings
    goRegMainImageColWidths = lvwImage.ColumnHeaders.WidthSettings
    goRegMainRestoreColWidths = lvwRestore.ColumnHeaders.WidthSettings
    
End Sub


Private Sub lvwImage_Click()
    
    Dim lCnt    As Long
    Dim oItem   As GSEnhListView.GSListItem
    
    'Determine the selected count
    mlQtySelected = 0
    For Each oItem In lvwImage.ListItems
        If oItem.Selected Then
            mlQtySelected = mlQtySelected + 1
        End If
    Next oItem
    
    'Update the status bar
    sbrMain.Panels("Status").Text = lvwImage.ListItems.Count & " Images(s) - " & mlQtySelected & " Selected"
    
End Sub

Private Sub lvwImage_MouseUp(nButton As Integer, nShift As Integer, _
                             fXCoord As Single, fYCoord As Single)
    
    Dim oItem As GSEnhListView.GSListItem
    
    'It the user did not click the right button then exit
    If nButton <> vbRightButton Then Exit Sub
    
    'Get a reference to the item that was clicked on
    Set oItem = lvwImage.HitTest(fXCoord, fYCoord)
    
    'Determine what to do
    If oItem Is Nothing Then
        'The user did not click on an item in the list
        Set oItem = Nothing
        Exit Sub
    Else
        'The user clicked on a valid item so clear the selection flag
        meRCMenuOption = rccNone
    End If
    
    'Display the menu
    Me.PopupMenu mnuRCListView
        
    'If the user clicked a valid option then do it
    Select Case meRCMenuOption
        Case rccTemplateProperties
            'Show the properties for this item
            ShowTemplateProperties sArchiveLabel:=oItem.SubItems(2), _
                                   oParentForm:=Me
        Case rccBatchProperties
            'Show the properties for this item
            ShowBatchProperties sArchiveLabel:=oItem.SubItems(2), _
                                sTemplateLabel:=oItem.SubItems(3), _
                                oParentForm:=Me
        Case rccImageProperties
            'Show the properties for this item
            ShowImageProperties sArchiveLabel:=oItem.SubItems(2), _
                                sTemplateLabel:=oItem.SubItems(3), _
                                sBatchLabel:=oItem.SubItems(4), _
                                oParentForm:=Me
    End Select
    
    'Cleanup
    meRCMenuOption = rccNone
    Set oItem = Nothing
    
End Sub


Private Sub mnuFileCatalog_Click()
    
    Dim oLocalCatalogForm As frmCatalog
    
    'Set the mouse pointer
    Screen.MousePointer = vbHourglass
    
    'Create and load the catalog form
    Set oLocalCatalogForm = New frmCatalog
    Load oLocalCatalogForm
    
    'Display the form
    With oLocalCatalogForm
        .Show vbModal
    End With
    
    'Unload and cleanup
    Unload oLocalCatalogForm
    Set oLocalCatalogForm = Nothing
    
    'Switch to the Image View
    mnuViewImage_Click
    
    'Set the mouse pointer
    Screen.MousePointer = vbNormal
    
End Sub


Private Sub mnuFileExit_Click()
    
    Unload Me
    
End Sub

Private Sub mnuFileExport_Click()
    
    Dim lRow        As Long
    Dim lCol        As Long
    Dim bFound      As Boolean
    Dim sMsg        As String
    Dim oExcel      As Excel.Application
    Dim oBook       As Excel.Workbook
    Dim oSheet      As Excel.Worksheet
    Dim oColumn     As GSEnhListView.GSColumnHeader
    Dim oItem       As GSEnhListView.GSListItem
    Dim oListView   As GSEnhListView.GSListView
    
    'Determine which list view we are dealing with
    If mnuViewImage.Checked Then
        Set oListView = lvwImage
    ElseIf mnuViewRestore.Checked Then
        Set oListView = lvwRestore
    Else
        Set oListView = Nothing
        Exit Sub
    End If
    
    'If the listview is not enabled then head out of dodge
    If Not oListView.Enabled Then
        sMsg = "Nothing to export!"
        MsgBox sMsg, vbInformation
        Set oListView = Nothing
        Exit Sub
    End If
    
    'Check for data to export
    If oListView.MultiSelect Then
        'If this listview uses multiselect then determine if any are selected
        If mlQtySelected > 0 Then
            bFound = True
        Else
            sMsg = "Nothing is selected for export!" & vbCrLf & vbCrLf & _
                   "Please select at least one item" & vbCrLf & _
                   "and try the export again."
        End If
    Else
        'This listview does not use checkboxes so determine if there ae any items
        If oListView.ListItems.Count > 0 Then
            bFound = True
        Else
            sMsg = "Nothing to export!"
        End If
    End If
    
    'If there is not data to export then we are out of here
    If Not bFound Then
        MsgBox sMsg, vbInformation
        Set oListView = Nothing
        Exit Sub
    End If
    
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
    For Each oColumn In oListView.ColumnHeaders
        lCol = lCol + 1
        oSheet.Cells(1, lCol).Value = oColumn.Text
    Next oColumn
    
    'Populate the grid
    lRow = 1
    For Each oItem In oListView.ListItems
        If oItem.Selected Or Not oListView.MultiSelect Then
            lRow = lRow + 1
            lCol = 0
            For Each oColumn In oListView.ColumnHeaders
                lCol = lCol + 1
                If lCol = 1 Then
                    oSheet.Cells(lRow, lCol) = oItem.Text
                Else
                    oSheet.Cells(lRow, lCol) = oItem.SubItems(lCol - 1)
                End If
            Next oColumn
        End If
    Next oItem
    
    'Set the mousepointer
    Screen.MousePointer = vbNormal
    
    'Cleanup
    Set oSheet = Nothing
    Set oBook = Nothing
    Set oExcel = Nothing
    
End Sub

Private Sub mnuRCLVBatchStats_Click()
    
    'Set the menu flag
    meRCMenuOption = rccBatchProperties

End Sub

Private Sub mnuRCLVImageStats_Click()
    
    'Set the menu flag
    meRCMenuOption = rccImageProperties

End Sub

Private Sub mnuRCLVTemplateStats_Click()
    
    'Set the menu flag
    meRCMenuOption = rccTemplateProperties
    
End Sub

Private Sub mnuToolsBatch_Click()
    
    Dim sLocation   As String
    Dim sCopyTo     As String
    Dim sBatchPath  As String
    Dim sArchive    As String
    Dim sBatchLine  As String                   '** Added 11-08-00 JJF
    Dim sLithoList  As String                   '** Added 02-02-01 JJF
    Dim oLocalForm  As frmBatch
    Dim oFileSys    As Scripting.FileSystemObject
    Dim oFile       As Scripting.TextStream
    Dim oLithoFile  As Scripting.TextStream     '** Added 02-02-01 JJF
    Dim oItem       As GSEnhListView.GSListItem
    Dim oArchItem   As GSEnhListView.GSListItem
    
    'Create and load the form
    Set oLocalForm = New frmBatch
    Load oLocalForm
    
    'Display the form
    With oLocalForm
        'Set the properties
        .Location = goRegBatchLocation.Value
        .CopyTo = goRegBatchCopyTo.Value
        .FileName = goRegBatchFileName.Value
        .FilePath = goRegBatchFilePath.Value
        .BatchType = IIf(mlQtySelected > 0, eBatchTypeConstants.btcSelectedImages, eBatchTypeConstants.btcSelectedArchives)
        
        'Show the form
        .Show vbModal
        
        'Determine the course of action to be taken
        If .OKClicked Then
            'Set the mousepointer
            Screen.MousePointer = vbHourglass
            
            'Retrieve the input
            goRegBatchLocation.Value = .Location
            goRegBatchCopyTo.Value = .CopyTo
            goRegBatchFileName.Value = .FileName
            goRegBatchFilePath.Value = .FilePath
            
            'Get a reference to the file system
            Set oFileSys = New Scripting.FileSystemObject
            
            'Get the short pathnames
            sLocation = goRegBatchLocation.Value
            If Right(sLocation, 1) = "\" Then sLocation = Left(sLocation, Len(sLocation) - 1)
            sCopyTo = goRegBatchCopyTo.Value
            If Right(sCopyTo, 1) = "\" Then sCopyTo = Left(sCopyTo, Len(sCopyTo) - 1)
            
            If .BatchType = btcSelectedImages Then
                'Create the batch file
                Set oFile = oFileSys.CreateTextFile(goRegBatchFileName.Value, True, False)
                '** Added 02-02-01 JJF
                Set oLithoFile = oFileSys.CreateTextFile(goRegBatchFileName.Value & ".Lithos", True, False)
                '** End of add 02-02-01 JJF
                
                'Write out the copy commands
                sLithoList = ""     '** Added 02-02-01 JJF
                For Each oItem In lvwImage.ListItems
                    If oItem.Selected Then
                        sBatchLine = "Copy " & _
                                     Chr(34) & sLocation & oItem.SubItems(6) & Chr(34) & " " & _
                                     Chr(34) & sCopyTo & "\" & oItem.Text & ".tif" & Chr(34)
                        sBatchLine = Replace(sString:=sBatchLine, sReplace:="%", sWith:="%%")
                        oFile.WriteLine sBatchLine
                        
                        '** Added 02-02-01 JJF
                        'Output the list of litho codes
                        If InStr(sLithoList, oItem.SubItems(1)) = 0 Then
                            sLithoList = sLithoList & IIf(Len(sLithoList) = 0, "", ",") & oItem.SubItems(1)
                            oLithoFile.WriteLine oItem.SubItems(1)
                        End If
                        '** End of add 02-02-01 JJF
                    End If
                Next oItem
                
                'Close the file
                oFile.Close
                oLithoFile.Close    '** Added 02-02-01 JJF
            Else
                'Get the path for the batch files
                sBatchPath = .FilePath
                If Right(sBatchPath, 1) <> "\" Then sBatchPath = sBatchPath & "\"
                
                'Loop through all selected archives
                For Each oArchItem In .lvwArchives.ListItems
                    If oArchItem.Checked Then
                        'Get the archive name
                        sArchive = UCase(oArchItem.Text)
                        
                        'Create the batch file
                        Set oFile = oFileSys.CreateTextFile(sBatchPath & sArchive & ".bat", True, False)
                        '** Added 02-02-01 JJF
                        Set oLithoFile = oFileSys.CreateTextFile(sBatchPath & sArchive & ".bat.Lithos", True, False)
                        '** End of add 02-02-01 JJF
                        
                        'Write out the copy commands
                        sLithoList = ""     '** Added 02-02-01 JJF
                        For Each oItem In lvwImage.ListItems
                            If UCase(oItem.SubItems(2)) = sArchive Then
                                sBatchLine = "Copy " & _
                                             Chr(34) & sLocation & oItem.SubItems(6) & Chr(34) & " " & _
                                             Chr(34) & sCopyTo & "\" & oItem.Text & ".tif" & Chr(34)
                                sBatchLine = Replace(sString:=sBatchLine, sReplace:="%", sWith:="%%")
                                oFile.WriteLine sBatchLine
                                
                                '** Added 02-02-01 JJF
                                'Output the list of litho codes
                                If InStr(sLithoList, oItem.SubItems(1)) = 0 Then
                                    sLithoList = sLithoList & IIf(Len(sLithoList) = 0, "", ",") & oItem.SubItems(1)
                                    oLithoFile.WriteLine oItem.SubItems(1)
                                End If
                                '** End of add 02-02-01 JJF
                            End If
                        Next oItem
                        
                        'Close the file
                        oFile.Close
                        oLithoFile.Close    '** Added 02-02-01 JJF
                    End If
                Next oArchItem
                
            End If
            
            'Reset the mousepointer
            Screen.MousePointer = vbNormal
        End If
    End With
    
    'Cleanup
    Unload oLocalForm
    Set oLocalForm = Nothing
    Set oItem = Nothing
    Set oArchItem = Nothing
    Set oFile = Nothing
    Set oLithoFile = Nothing    '** Added 02-02-01 JJF
    Set oFileSys = Nothing
    
End Sub


Private Sub mnuToolsLithoCode_Click()
    
    Dim oSpecifyForm As frmSpecifyLithoCode
    Dim oItem As GSEnhListView.GSListItem
    
    'Switch to the Image View
    mnuViewImage_Click
    
    'Create and load the search form
    Set oSpecifyForm = New frmSpecifyLithoCode
    Load oSpecifyForm
    
    'Display the form
    With oSpecifyForm
        .Show vbModal
        
        'Get the results
        If .OKClicked Then
            'Retrieve the data
            msLithoInList = .LithoInList
'            msLithoInList = ""
'            For Each oItem In oSpecifyForm.lvwLithoCodes.ListItems
'                msLithoInList = msLithoInList & IIf(Len(msLithoInList) = 0, "", ",") & oItem.Text
'            Next oItem
            
            'Query the database and populate the listview
            RequeryDB bSpecifyLithoCodes:=True
        End If
    End With
    
    'Cleanup the form
    Unload oSpecifyForm
    Set oSpecifyForm = Nothing
    Set oItem = Nothing
    
End Sub

Private Sub mnuToolsSearch_Click()
    
    Dim oLocalSearchForm As frmSearch
    
    'Switch to the Image View
    mnuViewImage_Click

    'Create and load the search form
    Set oLocalSearchForm = New frmSearch
    Load oLocalSearchForm

    'Display the form
    With oLocalSearchForm
        'Reset the previous values
        .SearchField = goRegSimpleSearchField.Value
        .SearchString = goRegSimpleSearchString.Value
        .SearchSelect = mksAdvancedSearchSelect
        .SearchFromWhere = goRegAdvancedSearchFromWhere.Value
        .SearchMode = goRegSearchMode.Value
        
        'Show the form
        .Show vbModal
        
        'Deal with the result
        If .OKClicked Then
            'Retrieve the search mode
            goRegSearchMode.Value = .SearchMode
            
            'Process the results based on the search mode
            If goRegSearchMode.Value = smcSimpleSearch Then
                'Retrieve the data
                goRegSimpleSearchField.Value = .SearchField
                goRegSimpleSearchString.Value = .SearchString
                
                'Build the where clause
                msSimpleSearchWhere = "WHERE " & .SearchField & " "
                If InStr(UCase(.SearchString), "NOT NULL") > 0 Then
                    msSimpleSearchWhere = msSimpleSearchWhere & "IS NOT NULL"
                ElseIf InStr(UCase(.SearchString), "NULL") > 0 Then
                    msSimpleSearchWhere = msSimpleSearchWhere & "IS NULL"
                ElseIf InStr(.SearchString, "%") > 0 Or _
                       InStr(.SearchString, "_") > 0 Then
                    msSimpleSearchWhere = msSimpleSearchWhere & "LIKE '" & .SearchString & "'"
                Else
                    msSimpleSearchWhere = msSimpleSearchWhere & "= '" & .SearchString & "'"
                End If
            Else
                'Retieve the data
                goRegAdvancedSearchFromWhere.Value = .SearchFromWhere
            End If
            
            'Query the database and populate the listview
            RequeryDB bSpecifyLithoCodes:=False
        End If
    End With

    'Unload and cleanup
    Unload oLocalSearchForm
    Set oLocalSearchForm = Nothing

End Sub


Private Sub mnuToolsSelect_Click()
    
    Dim oItem As GSEnhListView.GSListItem
    
    'Select all records
    For Each oItem In lvwImage.ListItems
        oItem.Selected = True
    Next oItem
    
    'Update the status bar
    mlQtySelected = lvwImage.ListItems.Count
    sbrMain.Panels("Status").Text = lvwImage.ListItems.Count & " Images(s) - " & mlQtySelected & " Selected"
    
    'Cleanup
    Set oItem = Nothing
    
End Sub

Private Sub mnuToolsSelectNonExpired_Click()
    
    Dim sSql        As String
    Dim lCnt        As Long
    Dim oItem       As GSEnhListView.GSListItem
    Dim oTempRs     As ADODB.Recordset
    Dim oExistsCm   As ADODB.Command
    
    'Setup the command for checking existance
    sSql = "SELECT Count(*) AS QtyRec " & _
           "FROM SentMailing sm, QuestionForm qf, BubblePos bp " & _
           "WHERE sm.SentMail_id = qf.SentMail_id " & _
           "  AND qf.QuestionForm_id = bp.QuestionForm_id " & _
           "  AND sm.strLithoCode = ?"
    Set oExistsCm = New ADODB.Command
    With oExistsCm
        .CommandText = sSql
        .CommandType = adCmdText
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("LithoCode", adVarChar, adParamInput, 10)
        .Prepared = True
    End With 'oExistsCm
    
    'Select all recordsthat have matching records in the BubblePos table
    lCnt = 0
    mlQtySelected = 0
    For Each oItem In lvwImage.ListItems
        'Display status bar info
        lCnt = lCnt + 1
        sbrMain.Panels("Status").Text = "Checking record " & lCnt & "..."
        sbrMain.Refresh
        
        'Get the quantity of BubblePos records for this LithoCode
        oExistsCm.Parameters("LithoCode") = oItem.SubItems(1)
        Set oTempRs = oExistsCm.Execute
        
        'Determine if this one gets selected or not
        If oTempRs!QtyRec > 0 Then
            oItem.Selected = True
            mlQtySelected = mlQtySelected + 1
        Else
            oItem.Selected = False
        End If
        
        'Cleanup
        oTempRs.Close
        Set oTempRs = Nothing
    Next oItem
    
    'Update the status bar
    sbrMain.Panels("Status").Text = lvwImage.ListItems.Count & " Images(s) - " & mlQtySelected & " Selected"
    
    'Cleanup
    Set oItem = Nothing
    Set oExistsCm = Nothing
    Set oTempRs = Nothing
    
End Sub


Private Sub mnuToolsUnselect_Click()
    
    Dim oItem As GSEnhListView.GSListItem
    
    'Unselect all records
    For Each oItem In lvwImage.ListItems
        oItem.Selected = False
    Next oItem
    
    'Update the status bar
    mlQtySelected = 0
    sbrMain.Panels("Status").Text = lvwImage.ListItems.Count & " Images(s) - " & mlQtySelected & " Selected"
    
    'Cleanup
    Set oItem = Nothing
    
End Sub

Private Sub mnuViewArchiveStats_Click()
    
    Dim oLocalForm As frmArchiveStats
    
    'Load the form
    Set oLocalForm = New frmArchiveStats
    Load oLocalForm
    
    'Show the form
    oLocalForm.Show vbModal
    
    'Cleanup
    Unload oLocalForm
    Set oLocalForm = Nothing
    
End Sub

Private Sub mnuViewImage_Click()
    
    mnuViewImage.Checked = True
    tbrMain.Buttons("ViewImage").Value = tbrPressed
    
    mnuViewRestore.Checked = False
    tbrMain.Buttons("ViewRestore").Value = tbrUnpressed
    
    mnuToolsSelect.Enabled = True
    tbrMain.Buttons("CheckAll").Enabled = True
    mnuToolsUnselect.Enabled = True
    tbrMain.Buttons("UncheckAll").Enabled = True
    mnuToolsBatch.Enabled = True
    tbrMain.Buttons("Batch").Enabled = True
    
    lvwImage.Visible = True
    lvwRestore.Visible = False
    
    'Update the status bar
    sbrMain.Panels("Status").Text = lvwImage.ListItems.Count & " Images(s) - " & mlQtySelected & " Selected"
    
End Sub

Private Sub mnuViewRestore_Click()
    
    Dim sMsg            As String
    Dim sKey            As String
    Dim oImageItem      As GSEnhListView.GSListItem
    Dim oRestoreItem    As GSEnhListView.GSListItem
    
    'Check to see if anything is selected
    If mlQtySelected = 0 Then
        MsgBox "Nothing is selected to display on the restore list!", vbInformation
        mnuViewImage_Click
        Exit Sub
    End If
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    
    'Set the menu and toolbar
    mnuViewImage.Checked = False
    tbrMain.Buttons("ViewImage").Value = tbrUnpressed
    mnuViewRestore.Checked = True
    tbrMain.Buttons("ViewRestore").Value = tbrPressed
    
    mnuToolsSelect.Enabled = False
    tbrMain.Buttons("CheckAll").Enabled = False
    mnuToolsUnselect.Enabled = False
    tbrMain.Buttons("UncheckAll").Enabled = False
    mnuToolsBatch.Enabled = False
    tbrMain.Buttons("Batch").Enabled = False
    
    'Populate the restore list
    lvwRestore.ListItems.Clear
    
    For Each oImageItem In lvwImage.ListItems
        If oImageItem.Selected Then
            sKey = "K" & oImageItem.SubItems(2) & "-" & oImageItem.SubItems(3) & "-" & oImageItem.SubItems(4)
            If lvwRestore.ListItems(sKey) Is Nothing Then
                Set oRestoreItem = lvwRestore.ListItems.Add(, sKey, oImageItem.SubItems(2), , "Image")
                oRestoreItem.SubItems(1) = oImageItem.SubItems(3)
                oRestoreItem.SubItems(2) = oImageItem.SubItems(4)
            End If
        End If
    Next oImageItem
    
    'Display the correct listview
    lvwImage.Visible = False
    lvwRestore.Visible = True
    If lvwRestore.ListItems.Count > 0 Then lvwRestore.Enabled = True
    
    'Update the status bar
    sbrMain.Panels("Status").Text = lvwRestore.ListItems.Count & " Batches(s)"
    
    'Reset the mousepointer
    Screen.MousePointer = vbNormal
    
End Sub


Private Sub tbrMain_ButtonClick(ByVal oButton As ComctlLib.Button)
    
    Select Case oButton.Key
        Case "Catalog"
            mnuFileCatalog_Click
            
        Case "Export"
            mnuFileExport_Click
            
        Case "ViewImage"
            mnuViewImage_Click
            
        Case "ViewRestore"
            mnuViewRestore_Click
            
        Case "Search"
            mnuToolsSearch_Click
            
        Case "LithoCode"
            mnuToolsLithoCode_Click
            
        Case "CheckAll"
            mnuToolsSelect_Click
            
        Case "UncheckAll"
            mnuToolsUnselect_Click
            
        Case "Batch"
            mnuToolsBatch_Click
            
    End Select
    
End Sub


