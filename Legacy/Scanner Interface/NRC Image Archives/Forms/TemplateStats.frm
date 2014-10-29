VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Object = "{BC691F0A-3A98-11D1-9464-00AA006F7AF1}#5.0#0"; "GSENHLV.OCX"
Begin VB.Form frmTemplateStats 
   Caption         =   "Template Statistics"
   ClientHeight    =   4755
   ClientLeft      =   555
   ClientTop       =   510
   ClientWidth     =   7530
   Icon            =   "TemplateStats.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4755
   ScaleWidth      =   7530
   StartUpPosition =   3  'Windows Default
   Begin GSEnhListView.GSListView lvwStats 
      Height          =   4215
      Left            =   180
      TabIndex        =   0
      Top             =   120
      Width           =   7275
      _ExtentX        =   12832
      _ExtentY        =   7435
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
      MouseIcon       =   "TemplateStats.frx":0442
      View            =   3
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      SortType        =   2
   End
   Begin ComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   1
      Top             =   4455
      Width           =   7530
      _ExtentX        =   13282
      _ExtentY        =   529
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   1
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   12779
            Key             =   "Status"
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuRCListView 
      Caption         =   "mnuRCListView"
      Visible         =   0   'False
      Begin VB.Menu mnuRCListViewProperties 
         Caption         =   "P&roperties"
      End
   End
End
Attribute VB_Name = "frmTemplateStats"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mbFormActive    As Boolean
    Private msArchiveLabel  As String
    Private moFormBase      As CFormBase98
    Private meRCMenuOption  As eRightClickConstants
    
    
    
Public Property Let ArchiveLabel(ByVal sData As String)
    
    'Save the data
    msArchiveLabel = sData
    
    'Set the form caption
    Me.Caption = "Template Statistics for Archive '" & msArchiveLabel & "'"
    
End Property

Private Sub LoadListView()
    
    Dim lTemplateCnt    As Long
    Dim lBatchCnt       As Long
    Dim lImageCnt       As Long
    Dim sSql            As String
    Dim oTempRS         As ADODB.Recordset
    Dim oItem           As GSEnhListView.GSListItem
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    
    'Get the data
    sbrMain.Panels("Status").Text = "Retrieving records from database..."
    sSql = "SELECT sTemplateLabel, Count(DISTINCT sBatchLabel) AS lQtyBatches, " & _
           "Count(*) AS lQtyImages, MIN(dtArchiveDate) AS dtStartTime, " & _
           "       MAX(dtArchiveDate) As dtFinishTime " & _
           "FROM ImageArchive " & _
           "WHERE sArchiveLabel = '" & msArchiveLabel & "' " & _
           "GROUP BY sTemplateLabel " & _
           "ORDER BY sTemplateLabel"
    Set oTempRS = goConn.Execute(sSql)
    
    'Populate the listview
    With oTempRS
        lTemplateCnt = 0
        lBatchCnt = 0
        lImageCnt = 0
        
        Do Until .EOF
            'Increment the counters
            lTemplateCnt = lTemplateCnt + 1
            lBatchCnt = lBatchCnt + !lQtyBatches
            lImageCnt = lImageCnt + !lQtyImages
            
            'Update the status bar
            sbrMain.Panels("Status").Text = "Retrieving record " & lTemplateCnt & "..."
            sbrMain.Refresh
            
            'Add this entry
            Set oItem = lvwStats.ListItems.Add(, "TL" & !sTemplateLabel, "" & !sTemplateLabel, , "Image")
            oItem.SubItems(1) = !lQtyBatches
            oItem.SubItems(2) = !lQtyImages
            oItem.SubItems(3) = Format(!dtStartTime, "mm/dd/yyyy hh:nn:ss")
            oItem.SubItems(4) = Format(!dtFinishTime, "mm/dd/yyyy hh:nn:ss")
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With
    
    'Update the statusbar
    sbrMain.Panels("Status").Text = lTemplateCnt & " Template(s), " & lBatchCnt & " Batch(es), " & lImageCnt & " Image(s)"
    
    'Cleanup
    oTempRS.Close: Set oTempRS = Nothing
    Set oItem = Nothing
    
    'Reset the mousepointer
    Screen.MousePointer = vbNormal
    
End Sub


Private Sub Form_Activate()
    
    If mbFormActive Then Exit Sub
    
    'Set the flag
    mbFormActive = True
    
    'Display the form
    DoEvents
    
    'Load the listview
    LoadListView
    
End Sub

Private Sub Form_Load()
    
    'Locate the form
    Set moFormBase = New CFormBase98
    moFormBase.Register frmForm:=Me, _
                        lHKey:=gsrsHKEYLocalMachine, _
                        sSection:=gksRegFormLocations
    moFormBase.LocateMe
    
    'Setup the listview
    With lvwStats
        Set .SmallIcons = frmMain.imlSmall
        .FullRowSelect = True
        .GridLines = True
        .SortType = gslvOnColumnClick
        
        'Setup the column headers
        With .ColumnHeaders
            .Add , "TemplateLabel", "Template", 1560, gslvColumnLeft, gslvAsText
            .Add , "QtyBatches", "Batches", 1080, gslvColumnRight, gslvAsNumber
            .Add , "QtyImages", "Images", 1080, gslvColumnRight, gslvAsNumber
            .Add , "StartTime", "Start Time", 1800, gslvColumnLeft, gslvAsDate
            .Add , "FinishTime", "Finish Time", 1800, gslvColumnLeft, gslvAsDate
        End With
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
    lvwStats.Move knEdgeDist, knEdgeDist, _
                  Me.ScaleWidth - knEdgeDist * 2, _
                  Me.ScaleHeight - sbrMain.Height - knEdgeDist * 1.5
    
End Sub


Private Sub Form_Unload(Cancel As Integer)
    
    'Save the form location
    moFormBase.SaveLocation
    Set moFormBase = Nothing
    
    'Cleanup
    lvwStats.ListItems.Clear
    
End Sub


Private Sub lvwStats_DblClick()
    
    Dim oItem As GSEnhListView.GSListItem
    
    'Get a reference to the item that was clicked on
    Set oItem = lvwStats.SelectedItem
    
    'Determine what to do
    If oItem Is Nothing Then
        'The user did not click on an item in the list
        Set oItem = Nothing
        Exit Sub
    End If
        
    'Show the properties for this item
    ShowBatchProperties sArchiveLabel:=msArchiveLabel, _
                        sTemplateLabel:=oItem.Text, _
                        oParentForm:=Me
    
    'Cleanup
    Set oItem = Nothing
    
End Sub

Private Sub lvwStats_MouseUp(nButton As Integer, nShift As Integer, _
                             fXCoord As Single, fYCoord As Single)
    
    Dim oItem As GSEnhListView.GSListItem
    
    'It the user did not click the right button then exit
    If nButton <> vbRightButton Then Exit Sub
    
    'Get a reference to the item that was clicked on
    Set oItem = lvwStats.HitTest(fXCoord, fYCoord)
    
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
    Me.PopupMenu mnuRCListView, , , , mnuRCListViewProperties
        
    'If the user clicked a valid option then do it
    Select Case meRCMenuOption
        Case rccBatchProperties
            'Show the properties for this item
            ShowBatchProperties sArchiveLabel:=msArchiveLabel, _
                                sTemplateLabel:=oItem.Text, _
                                oParentForm:=Me
    End Select
    
    'Cleanup
    meRCMenuOption = rccNone
    Set oItem = Nothing
    
End Sub


Private Sub mnuRCListViewProperties_Click()
    
    'Set the menu flag
    meRCMenuOption = rccBatchProperties
    
End Sub


