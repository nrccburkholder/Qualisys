VERSION 5.00
Begin VB.Form dlgAuthEmployees 
   Caption         =   "Authorized Associates for Study"
   ClientHeight    =   5730
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6510
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   5730
   ScaleWidth      =   6510
   Begin VB.Frame Frame2 
      Caption         =   "Authorized Associates"
      Height          =   3975
      Left            =   3840
      TabIndex        =   5
      Top             =   120
      Width           =   2655
      Begin VB.ListBox List2 
         Height          =   3570
         Left            =   0
         Sorted          =   -1  'True
         TabIndex        =   7
         Top             =   240
         Width           =   2625
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "NRC Associates"
      Height          =   3975
      Left            =   120
      TabIndex        =   4
      Top             =   120
      Width           =   2655
      Begin VB.ListBox List1 
         Height          =   3570
         Left            =   0
         Sorted          =   -1  'True
         TabIndex        =   6
         Top             =   340
         Width           =   2625
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   400
      Left            =   5280
      TabIndex        =   3
      Top             =   4200
      Width           =   1200
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   400
      Left            =   3960
      TabIndex        =   2
      Top             =   4200
      Width           =   1200
   End
   Begin VB.CommandButton cmdRemoveEmployee 
      Caption         =   "<"
      Height          =   495
      Left            =   3000
      TabIndex        =   1
      Top             =   2040
      Width           =   615
   End
   Begin VB.CommandButton cmdAddEmployee 
      Caption         =   ">"
      Height          =   495
      Left            =   3000
      TabIndex        =   0
      Top             =   1320
      Width           =   615
   End
End
Attribute VB_Name = "dlgAuthEmployees"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private flgLoading As Boolean
Private flgChanged As Boolean

Private WithEvents objStudy As Study
Attribute objStudy.VB_VarHelpID = -1
Private newEmpID As Collection
Private delEmpID As Collection
Private sameEmpID As Collection
Dim rs1 As New ADODB.Recordset

Public Sub Component(aStudy As Study)
    Set objStudy = aStudy
End Sub

Private Sub cmdAddEmployee_Click()
    'Dim currentIndex As Long
    'Dim lstItem As ListItem
    
    'If lvwMaster.SelectedItem Is Nothing Then Exit Sub
        
    'currentIndex = val(lvwMaster.SelectedItem.Key)
    'lvwMaster.ListItems.Remove (lvwMaster.SelectedItem.Index)
    'Set lstItem = lvwSelected.ListItems.Add
    'lstItem.Text = objStudy.EmployeeList(currentIndex)
    'lstItem.Key = Format$(currentIndex) & "K"
    
    'flgChanged = True
    dgUsers1_DblClick
End Sub

Private Sub cmdRemoveEmployee_Click()
    'Dim currentIndex As Long
    'Dim lstItem As ListItem
    
    'If lvwSelected.SelectedItem Is Nothing Then Exit Sub

    'currentIndex = val(lvwSelected.SelectedItem.Key)
    'lvwSelected.ListItems.Remove (lvwSelected.SelectedItem.Index)
    'Set lstItem = lvwMaster.ListItems.Add
    'lstItem.Text = objStudy.EmployeeList(currentIndex)
    'lstItem.Key = Format$(currentIndex) & "K"
    
    'flgChanged = True
    dgUsers2_DblClick
End Sub

Private Sub DataGrid1_Click()

End Sub

Private Sub dgUsers1_DblClick()
   Dim a As Integer
   Dim r As Integer
   List1_DblClick
   'rs1.Filter = "Active = 0"
   'rs2.Filter = "Active = 1"
   'rs2.Requery
   'rs1.Requery
   'If r > -1 Then
   '  rs1.AbsolutePosition = Abs(a - r)
   '  dgUsers1.Row = r
   'End If
End Sub

Private Sub dgUsers2_DblClick()
   Dim r As Integer
   Dim a As Integer
   'a = rs1.AbsolutePosition
   'r = dgUsers2.Row
   List2_DblClick
   'rs2.Fields("Active").Value = 0
   'rs1.Filter = "Active = 0"
   'rs2.Filter = "Active = 1"
   
   'rs2.Requery
   'rs1.Requery
   
   'If r > -1 Then
   '  rs2.AbsolutePosition = Abs(a - r)
   '  dgUsers2.Row = r
   'End If
End Sub

Private Sub Form_Load()
    Dim i As Integer
    rs1.CursorLocation = adUseClient
    Dim r As Integer
      
    cn.Execute "SELECT * into #temp2 FROM #temp"
   
    rs1.Open "select * from #temp2", cn, adOpenDynamic, adLockOptimistic
    
    List1.Clear
    List2.Clear
    Do While Not rs1.EOF
        Select Case rs1.Fields("Active").Value
            Case 0
              List1.AddItem rs1.Fields("Associate Name").Value
              List1.ItemData(List1.NewIndex) = rs1.Fields("Employee_id").Value
            Case 1
              List2.AddItem rs1.Fields("Associate Name").Value
              List2.ItemData(List2.NewIndex) = rs1.Fields("Employee_id").Value
        End Select
            
        rs1.MoveNext
    Loop
'    rs2.Open "select * from #temp2", cn, adOpenDynamic, adLockOptimistic
'
'    rs1.Filter = "Active = 0"
'    rs2.Filter = "Active = 1"
'
'    Set DataList1.DataSource = rs1.DataSource
'    Set DataList2.DataSource = rs2.DataSource
'
'    Set DataList1.RowSource = rs1.DataSource
'    Set DataList2.RowSource = rs2.DataSource
'
'    DataList1.BoundColumn = "Associate Name"
'    DataList2.BoundColumn = "Associate Name"
'
'    DataList1.DataField = "Associate Name"
'    DataList2.DataField = "Associate Name"
'
'    DataList1.ListField = "Associate Name"
'    DataList2.ListField = "Associate Name"
    
    'r = dgUsers1.Width
    
        
    
'    Do While Not rs1.EOF
'     i = Me.TextWidth(rs1.Fields("Associate Name").Value)
'     If i > dgUsers1.Columns("Associate Name").Width Then
'       dgUsers1.Columns("Associate Name").Width = i
'     End If
'     rs1.MoveNext
'   Loop
'   rs1.MoveFirst
'   dgUsers1.Columns("Associate Name").Width = dgUsers1.Columns("Associate Name").Width + 50
'   dgUsers2.Columns("Associate Name").Width = dgUsers1.Columns("Associate Name").Width
'
'   dgUsers1.Columns(0).Caption = "Associate Name"
'   dgUsers1.Columns(0).DataField = "Associate Name"
'
'   dgUsers2.Columns(0).Caption = "Associate Name"
'   dgUsers2.Columns(0).DataField = "Associate Name"
     
    'BuildListViewHeaders
    'LoadMasterList
    'LoadSelectedList
    
    'Set newEmpID = New Collection
    'Set delEmpID = New Collection
    'Set sameEmpID = New Collection

    flgChanged = False
End Sub

Private Sub cmdOK_Click()
    'Dim lngIndex As Long
    'Dim empCount As Long
    'Dim aKey As Long
    'Dim anObj As StudyEmployee
    
    'objStudy.StudyEmployeeColl.Delete
    
    'If lvwSelected.ListItems.Count > 0 Then
    '    For empCount = 1 To lvwSelected.ListItems.Count
    '        lngIndex = val(lvwSelected.ListItems.Item(empCount).Key)
    '        aKey = objStudy.EmployeeList.Key(objStudy.EmployeeList(lngIndex))
            'If Not objStudy.StudyEmployeeColl.ExistsItem(aKey) Then
            '    ' new employees were added to the collection
            '    newEmpID.Add Item:=aKey
            'Else
            '    ' no change
            '    sameEmpID.Add Item:=aKey
            'End If
            Set anObj = objStudy.StudyEmployeeColl.Add
    '        anObj.BeginEdit
    '        anObj.EmployeeID = aKey
    '        anObj.ApplyEdit
    '    Next
        ' what ever is left in the StudyEmployee collection
        ' can be deleted
    'End If
    cn.Execute "update #temp set active = b.active from #temp2 b inner join #temp a on a.Employee_id = b.Employee_id"
    rsUsers.Requery
    Set newEmpID = Nothing
    Set delEmpID = Nothing
    Set sameEmpID = Nothing
    
    Unload Me
End Sub

Private Sub cmdCancel_Click()
    If flgChanged Then
        If (MsgBox("Do you wish to save changes to this screen", vbYesNo, G_Study.name) = vbYes) Then
            cmdOK_Click
            Exit Sub
        End If
    End If

    Set newEmpID = Nothing
    Set delEmpID = Nothing
    Set sameEmpID = Nothing
    
    Unload Me
End Sub

Private Sub LoadMasterList()
    Dim lngIndex As Long
    Dim lstItem As ListItem
    Dim aKey As Long
    
    lvwMaster.ListItems.Clear
    
    For lngIndex = 1 To objStudy.EmployeeList.Count
        aKey = objStudy.EmployeeList.Key(objStudy.EmployeeList(lngIndex))
        If Not objStudy.StudyEmployeeColl.ExistsItem(aKey) Then
            Set lstItem = lvwMaster.ListItems.Add
            lstItem.Text = objStudy.EmployeeList(lngIndex)
            lstItem.Key = Format$(lngIndex) & "K"
        End If
    Next
End Sub

Private Sub LoadSelectedList()
    Dim lngIndex As Long
    Dim lstItem As ListItem
    Dim aKey As Long
    
    lvwSelected.ListItems.Clear
    
    For lngIndex = 1 To objStudy.EmployeeList.Count
        aKey = objStudy.EmployeeList.Key(objStudy.EmployeeList(lngIndex))
        If objStudy.StudyEmployeeColl.ExistsItem(aKey) Then
            Set lstItem = lvwSelected.ListItems.Add
            lstItem.Text = objStudy.EmployeeList(lngIndex)
            lstItem.Key = Format$(lngIndex) & "K"
        End If
    Next
End Sub

Private Sub BuildListViewHeaders()
    Dim colHead As ColumnHeader
    Dim lstItem As ListItem
    
    'lvwMaster.View = lvwReport
    'Set colHead = lvwMaster.ColumnHeaders.Add()
    'colHead.Text = "List of All Associates"
    'colHead.Width = lvwMaster.Width
    
    'lvwSelected.View = lvwReport
    'Set colHead = lvwSelected.ColumnHeaders.Add()
    'colHead.Text = "Authorized Associates"
    'colHead.Width = lvwSelected.Width
End Sub

Private Sub Form_Unload(Cancel As Integer)
    rs1.Close
    Set rs1 = Nothing
    cn.Execute "drop table #temp2"
End Sub

Private Sub List1_DblClick()
    If List1.ListIndex < 0 Then Exit Sub
    cn.Execute "update #temp2 set Active = 1 where Employee_id =" & List1.ItemData(List1.ListIndex)
    List2.AddItem (List1.List(List1.ListIndex))
    List2.ItemData(List2.NewIndex) = List1.ItemData(List1.ListIndex)
    List1.RemoveItem (List1.ListIndex)
    List2.Refresh
End Sub

Private Sub List2_DblClick()
    If List2.ListIndex < 0 Then Exit Sub
    If List2.List(List2.ListIndex) = AccountDirector Then
        If MsgBox("You are attempting to remove the current Account Director for this study." & vbCrLf & "Proceed anyway?", vbYesNo, "Warning!") = vbNo Then
            Exit Sub
        End If
    End If
    cn.Execute "update #temp2 set Active = 0 where Employee_id =" & List2.ItemData(List2.ListIndex)
    List1.AddItem (List2.List(List2.ListIndex))
    List1.ItemData(List1.NewIndex) = List2.ItemData(List2.ListIndex)
    List2.RemoveItem (List2.ListIndex)
    List1.Refresh
End Sub
