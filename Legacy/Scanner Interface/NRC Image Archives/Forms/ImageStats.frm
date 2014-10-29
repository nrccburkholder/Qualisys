VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.2#0"; "COMCTL32.OCX"
Object = "{BC691F0A-3A98-11D1-9464-00AA006F7AF1}#5.0#0"; "GSENHLV.OCX"
Begin VB.Form frmImageStats 
   Caption         =   "Image Statistics"
   ClientHeight    =   4755
   ClientLeft      =   555
   ClientTop       =   510
   ClientWidth     =   7530
   Icon            =   "ImageStats.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4755
   ScaleWidth      =   7530
   StartUpPosition =   3  'Windows Default
   Begin GSEnhListView.GSListView lvwStats 
      Height          =   4215
      Left            =   120
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
      MouseIcon       =   "ImageStats.frx":0442
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
End
Attribute VB_Name = "frmImageStats"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
    Private mbFormActive    As Boolean
    Private msArchiveLabel  As String
    Private msTemplateLabel As String
    Private msBatchLabel    As String
    Private moFormBase      As CFormBase98
    
    
    
Public Property Let BatchLabel(ByVal sData As String)
    
    'Save value
    msBatchLabel = sData
    
    'Set the form caption
    Me.Caption = "Image Statistics for Archive '" & msArchiveLabel & "', Template '" & msTemplateLabel & "', Batch '" & msBatchLabel & "'"
    
End Property

Public Property Let TemplateLabel(ByVal sData As String)
    
    'Save value
    msTemplateLabel = sData
    
    'Set the form caption
    Me.Caption = "Image Statistics for Archive '" & msArchiveLabel & "', Template '" & msTemplateLabel & "', Batch '" & msBatchLabel & "'"
    
End Property

Public Property Let ArchiveLabel(ByVal sData As String)
    
    'Save value
    msArchiveLabel = sData
    
    'Set the form caption
    Me.Caption = "Image Statistics for Archive '" & msArchiveLabel & "', Template '" & msTemplateLabel & "', Batch '" & msBatchLabel & "'"
    
End Property

Private Sub LoadListView()
    
    Dim lBatchCnt   As Long
    Dim lImageCnt   As Long
    Dim sSql        As String
    Dim oTempRS     As ADODB.Recordset
    Dim oItem       As GSEnhListView.GSListItem
    
    'Set the mousepointer
    Screen.MousePointer = vbHourglass
    
    'Get the data
    sbrMain.Panels("Status").Text = "Retrieving records from database..."
    sSql = "SELECT IA.sBarcode, IA.sLithoCode, SM.datMailed, QF.datReturned, " & _
           "       QF.datResultsImported, IA.dtArchiveDate, IA.sFileName, " & _
           "       SM.SentMail_id, QF.QuestionForm_id, QF.Survey_id " & _
           "FROM (ImageArchive IA LEFT JOIN SentMailing SM ON IA.sLithoCode = SM.strLithoCode)" & _
           "                      LEFT JOIN QuestionForm QF ON SM.SentMail_id = QF.SentMail_id " & _
           "WHERE IA.sArchiveLabel = '" & msArchiveLabel & "' " & _
           "  AND IA.sTemplateLabel = '" & msTemplateLabel & "' " & _
           "  AND IA.sBatchLabel = '" & msBatchLabel & "' " & _
           "ORDER BY IA.sFileName"
    Set oTempRS = goConn.Execute(sSql)
    
    'Populate the listview
    With oTempRS
        lImageCnt = 0
        
        Do Until .EOF
            'Increment the counters
            lImageCnt = lImageCnt + 1
            
            'Update the status bar
            sbrMain.Panels("Status").Text = "Retrieving record " & lImageCnt & "..."
            sbrMain.Refresh
            
            'Add this entry
            Set oItem = lvwStats.ListItems.Add(, , "" & !sBarCode, , "Image")
            oItem.SubItems(1) = !sLithoCode
            oItem.SubItems(2) = IIf(IsNull(!datMailed), "", Format(!datMailed, "mm/dd/yyyy hh:nn:ss"))
            oItem.SubItems(3) = IIf(IsNull(!datReturned), "", Format(!datReturned, "mm/dd/yyyy hh:nn:ss"))
            oItem.SubItems(4) = IIf(IsNull(!datResultsImported), "", Format(!datResultsImported, "mm/dd/yyyy hh:nn:ss"))
            oItem.SubItems(5) = IIf(IsNull(!dtArchiveDate), "", Format(!dtArchiveDate, "mm/dd/yyyy hh:nn:ss"))
            oItem.SubItems(6) = !sFileName
            oItem.SubItems(7) = IIf(IsNull(!SentMail_id), "", !SentMail_id)
            oItem.SubItems(8) = IIf(IsNull(!QuestionForm_id), "", !QuestionForm_id)
            oItem.SubItems(9) = IIf(IsNull(!Survey_id), "", !Survey_id)
            
            'Prepare for the next pass
            .MoveNext
        Loop
    End With
    
    'Update the statusbar
    sbrMain.Panels("Status").Text = lImageCnt & " Image(s)"
    
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
            .Add , "Barcode", "Barcode", 1560, gslvColumnLeft, gslvAsText
            .Add , "LithoCode", "LithoCode", 1080, gslvColumnRight, gslvAsNumber
            .Add , "Mailed", "Mailed", 1800, gslvColumnLeft, gslvAsDate
            .Add , "Returned", "Returned", 1800, gslvColumnLeft, gslvAsDate
            .Add , "Imported", "Results Imported", 1800, gslvColumnLeft, gslvAsDate
            .Add , "ArchiveDate", "Archive Date", 1800, gslvColumnLeft, gslvAsDate
            .Add , "FileName", "FileName", 1800, gslvColumnLeft, gslvAsText
            .Add , "SMID", "SM ID", 720, gslvColumnRight, gslvAsNumber
            .Add , "QFID", "QF ID", 720, gslvColumnRight, gslvAsNumber
            .Add , "SVID", "SurveyID", 720, gslvColumnRight, gslvAsNumber
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


