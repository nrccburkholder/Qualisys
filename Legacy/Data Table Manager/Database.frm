VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Begin VB.Form frmDatabase 
   Caption         =   "Database Window"
   ClientHeight    =   3540
   ClientLeft      =   3405
   ClientTop       =   2910
   ClientWidth     =   3690
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   HelpContextID   =   2016146
   Icon            =   "Database.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MDIChild        =   -1  'True
   ScaleHeight     =   3540
   ScaleWidth      =   3690
   ShowInTaskbar   =   0   'False
   Begin ComctlLib.TreeView tvDatabase 
      Height          =   3465
      Left            =   30
      TabIndex        =   0
      Top             =   30
      Width           =   3600
      _ExtentX        =   6350
      _ExtentY        =   6112
      _Version        =   327682
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Sorted          =   -1  'True
      Style           =   7
      ImageList       =   "imlTreePics"
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
   Begin ComctlLib.ImageList imlTreePics 
      Left            =   1215
      Top             =   1560
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   -2147483643
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   6
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Database.frx":014A
            Key             =   "Table"
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Database.frx":0464
            Key             =   "Query"
         EndProperty
         BeginProperty ListImage3 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Database.frx":077E
            Key             =   "Index"
         EndProperty
         BeginProperty ListImage4 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Database.frx":0A98
            Key             =   "Property"
         EndProperty
         BeginProperty ListImage5 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Database.frx":0DB2
            Key             =   "Attached"
         EndProperty
         BeginProperty ListImage6 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "Database.frx":10CC
            Key             =   "Field"
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "frmDatabase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const FORMCAPTION = "Database Window"

Dim mnodEditNode As Node

Dim mlngStudy_Id    As Long
Dim mlngTypeTables  As Long

Dim cn As ADODB.Connection
Dim connectstring As String

'Dim frmActiveDB         As Database
Dim frmActiveWS         As Workspace

Private Sub TempGetConnection()

    If cn Is Nothing Then
        Set cn = CreateObject("ADODB.Connection")
    Else
        cn.Close
    End If
    
    connectstring = "driver=" & gstrDSNDRVName
    connectstring = connectstring & ";server=" & gstrServer
    connectstring = connectstring & ";UID=" & gstrSAUser
    connectstring = connectstring & ";PWD=" & gstrSAPWD
    connectstring = connectstring & ";APP=DataTableManager"
    connectstring = connectstring & ";DATABASE=" & gstrDatabase
    
    cn.Open connectstring

End Sub

Public Sub LoadDatabase()

    'for standalone use, this method must be called
    'from the operation that loads this form
    
    'On Error GoTo ADErr
    
    Dim nodX As Node    ' Create variable.
    Dim sTBLName As String
    Dim sQRYName As String
    Dim sPropName As String
    Dim tblObj As DAO.TableDef
    Dim qdfObj As DAO.QueryDef
    Dim prpObj As DAO.Property
    Dim bAttached As Boolean
    Dim sTmp As String
    Dim qryObj As QueryDef
    Dim bTablesFound As Boolean
    Dim bIncludeSysTables As Boolean
    ' --------------------------------
    ' Added for Data Table Manager
    ' --------------------------------
    Dim pMetaTblRS     As Recordset
    Dim pstrSQL               As String
    Dim strSqlSysObjects As String
    Dim pAryTblNames()   As String
    Dim plngI                   As Long
    Dim pstrMsg             As String
    
    '
    'Dim rsADOSysObjects As New adodb.Recordset
    
    'Change this temp Connection
    'D DV 8/16/99 - IS THIS IN THE WAY????
    'Call TempGetConnection
    
    Dim pWS                   As Workspace
    Dim pDBTemp               As Database
    Dim pCNTemp               As Connection
  
    'D  Set frmActiveDB = modVisData.gwsActiveWS.Databases(0)
    Set frmActiveWS = modVisData.gwsActiveWS
  
    Me.MousePointer = vbHourglass
    tvDatabase.Nodes.Clear
    If frmActiveWS.Databases.Count = 0 And _
        frmActiveWS.Connections.Count = 0 Then Exit Sub
        
    'add the properties node
    bIncludeSysTables = False
        
    ' Read Meta Structure/Tables
    ' to determine which tables to show
    ' the user
    plngI = 0
    
    'D DV 8/17/99 - This is part of the next SELECT CASE.
    'D        Select Case mlngTypeTables
    'D        Case SYSTEM_TABLES
    'D            ' -----------------------------------
    'D            ' This will be replaced with the search
    'D            ' in the qualpro domain table and will do
    'D            ' fill the array with the valid tables
    'D            ' -----------------------------------
    'D              pstrSQL = "SELECT name  "
    'D              pstrSQL = pstrSQL & " FROM QualProDomainList "
    'D        Case STUDY_TABLES
    'D            ' -----------------------------------
    'D            ' This will search the Meta Table
    'D            ' fill the array with the valid tables
    'D            ' editable by the Study Administrator (logged in employee)
    'D            ' -----------------------------------
    'D
    'D            pstrSQL = "SELECT strTable_nm  "
    'D            pstrSQL = pstrSQL & " FROM MetaTable "
    'D            pstrSQL = pstrSQL & " WHERE Study_ID = " & mlngStudy_Id
    'D
    'D        Case Else
    'D            Exit Sub
    'D        End Select
    'log in by study id selected or by  system table owners if system

    Select Case mlngTypeTables
        Case SYSTEM_TABLES
            SetTempWS pWS, pDBTemp, pCNTemp, gstrSAUser, gstrSAPWD, True, gstrServer, gstrDatabase
            'D            SetTempDB pWS, pDBTemp, gstrSAUser, gstrSAPWD, gstrServer, gstrDatabase
            pstrSQL = "SELECT CONVERT(varchar(60),CASE WHEN PATINDEX('dbo%',qpc_name) = 0 THEN 'dbo.' + qpc_name ELSE qpc_name END) AS name  " & _
                        " FROM QualProDomainList " & _
                        " Where QPC_Name <> 'Employee'" ' 05-12-2005 SH Added
            'D            Set pMetaTblRS = pDBTemp.OpenRecordset(pstrSQL, dbOpenSnapshot)
        Case STUDY_TABLES
            SetTempWS pWS, pDBTemp, pCNTemp, gstrSAUser, gstrSAPWD, True, gstrServer, gstrDatabase
            'D            SetTempDB pWS, pDBTemp, gstrSAUser, gstrSAPWD, gstrServer, gstrDatabase
            pstrSQL = "SELECT CONVERT(varchar(60),'S' + rtrim(ltrim(convert(varchar(9),study_id))) + '.' + strTable_nm) AS name " & _
                        " FROM MetaTable " & _
                        " WHERE Study_ID = " & mlngStudy_Id
            'D            Set pMetaTblRS = pDBTemp.OpenRecordset(pstrSQL, dbOpenSnapshot)
        Case Else
            Exit Sub
    End Select
    
    If pWS.Type = dbUseODBC Then
        Set pMetaTblRS = pWS.Connections(0).OpenRecordset(pstrSQL, dbOpenSnapshot)
    Else
        Set pMetaTblRS = pWS.Databases(0).OpenRecordset(pstrSQL, dbOpenSnapshot)
    End If
        
    If pMetaTblRS.EOF And pMetaTblRS.BOF Then
        Set pMetaTblRS = Nothing
        '
        '<<--GET OUT OF LoadDataBase
        '
        Exit Sub
    Else
        'I DV 8/17/99 - We will populate the Tree-View here, no array needed.
        Do While Not pMetaTblRS.EOF
            bTablesFound = True
            Set nodX = tvDatabase.Nodes.Add(, , "T" & UCase(Trim(pMetaTblRS!Name)), UCase(Trim(pMetaTblRS!Name)), TABLE_STR)
            nodX.Tag = TABLE_STR
            pMetaTblRS.MoveNext
        Loop
        
        pMetaTblRS.Close
        pWS.Close
    End If

    'enable menus that depend on tables being present
    If bTablesFound Then
        frmMDI.mnuUQuery.Enabled = True
        'frmMDI.mnuDBPUNewQuery.Visible = True
    Else
        'no tables available
        frmMDI.mnuUQuery.Enabled = False
        'frmMDI.mnuDBPUNewQuery.Visible = False
    End If
    
    Me.MousePointer = vbDefault
    
    Exit Sub
  
ADErr:
    ShowError
    Me.MousePointer = vbDefault

End Sub

Public Property Let Study_ID(xlngStudy_ID As Long)

    mlngStudy_Id = xlngStudy_ID

End Property

Public Property Let TypeTables(xlngTypeTables As Long)

    mlngTypeTables = xlngTypeTables

End Property

Function TableInMetaTables(xAryTableNames() As String, xTblObjName As String) As Boolean
    
    Dim plngI       As Long
    Dim pstrMsg     As String
    Dim pstrTblObjNm As String
    
    On Error GoTo TblInMetaTablesError
    
    TableInMetaTables = False
    pstrTblObjNm = UCase$(Trim(StripOwner(xTblObjName)))
    
    For plngI = 0 To UBound(xAryTableNames) - 1
        Select Case mlngTypeTables
            Case SYSTEM_TABLES
                If (pstrTblObjNm = UCase$(Trim(xAryTableNames(plngI)))) Then
                    TableInMetaTables = True
                End If
            Case STUDY_TABLES
                If pstrTblObjNm = UCase$(Trim(xAryTableNames(plngI))) Then
                    TableInMetaTables = True
                End If
        End Select
    Next plngI
    
    GoTo TblInMetaTablesExit
    
TblInMetaTablesError:
    pstrMsg = "Error:" & Error.Number & vbCrLf
    pstrMsg = pstrMsg & "Error Text: " & Error.Description & vbCrLf
    pstrMsg = pstrMsg & "Error Testing MetaTable Membership." & vbCrLf & vbCrLf
    pstrMsg = pstrMsg & "Error Module: TableInMetaTables" & vbCrLf
    MsgBox pstrMsg
    Resume TblInMetaTablesExit
        
TblInMetaTablesExit:

End Function

Private Sub Form_GotFocus()

    Set frmActiveFrm = Me

End Sub

Private Sub Form_Load()
  
    On Error Resume Next
    
    Me.Caption = FORMCAPTION
    Me.Height = Val(GetINIString("DBWindowHeight", "3870"))
    Me.Width = Val(GetINIString("DBWindowWidth", "3835"))
    Me.Top = Val(GetINIString("DBWindowTop", "0"))
    Me.Left = Val(GetINIString("DBWindowLeft", "0"))
    
    Err.Clear
    
    Set frmActiveFrm = Me

End Sub

Private Sub Form_Resize()
    
    On Error Resume Next
    
    tvDatabase.Width = Me.ScaleWidth - (tvDatabase.Left * 2)
    tvDatabase.Height = Me.ScaleHeight - (tvDatabase.Top * 2)

End Sub

Private Sub Form_Unload(Cancel As Integer)
  
    If Me.WindowState = vbNormal Then
        SaveSetting APP_CATEGORY, App.Title, "DBWindowTop", Me.Top
        SaveSetting APP_CATEGORY, App.Title, "DBWindowLeft", Me.Left
        SaveSetting APP_CATEGORY, App.Title, "DBWindowWidth", Me.Width
        SaveSetting APP_CATEGORY, App.Title, "DBWindowHeight", Me.Height
    End If
    
    frmMDI.mnuEditStudy.Enabled = True
    frmMDI.mnuEditSystem.Enabled = True
    frmMDI.mnuDBClose.Enabled = False

End Sub

Private Sub tvDatabase_AfterLabelEdit(Cancel As Integer, NewString As String)
  
    On Error Resume Next
    
    'change the name in the database
    '  Select Case mnodEditNode.Tag
    '    Case TABLE_STR
    '      gwsmainws.databases(0).TableDefs(mnodEditNode.Text).Name = NewString
    '    Case QUERY_STR
    '      gwsmainws.databases(0).QueryDefs(mnodEditNode.Text).Name = NewString
    '    Case INDEX_STR
    '      gwsmainws.databases(0).TableDefs(mnodEditNode.Parent.Parent.Text).Indexes(mnodEditNode.Text).Name = NewString
    '    Case FIELD_STR
    '      gwsmainws.databases(0).TableDefs(mnodEditNode.Parent.Parent.Text).Fields(mnodEditNode.Text).Name = NewString
    '  End Select
    '
    '  If Err Then
    '    MsgBox Err.Description
    '    'errored out so set it back
    '    Cancel = True
    '  End If
    '
    '  'set it back
    '  If Not gnodDBNode Is Nothing Then
    '    Set frmDatabase.tvDatabase.SelectedItem = gnodDBNode
    '  End If
    '
    '  Err.Clear

End Sub

Private Sub tvDatabase_BeforeLabelEdit(Cancel As Integer)

    '  Dim sTmp As String
    '
    '  sTmp = tvDatabase.SelectedItem.Tag
    '
    '  If sTmp = FIELDS_STR Or _
    '     sTmp = INDEXES_STR Or _
    '     sTmp = PROPERTIES_STR Or _
    '     sTmp = PROPERTY_STR Then
    '
    '    Cancel = True
    '  Else
    '    Set mnodEditNode = gnodDBNode
    '  End If

End Sub

Private Sub tvDatabase_DblClick()
  
    If gnodDBNode Is Nothing Then Exit Sub
    
    'reverse the automatic expansion change
    'from the mouse click
    gnodDBNode.Expanded = Not gnodDBNode.Expanded
    
    Set gnodDBNode2 = gnodDBNode
    If gnodDBNode2.Tag = PROPERTY_STR Then
        frmMDI.mnuDBPUEdit_Click
    Else
        frmMDI.mnuDBPUOpen_Click
    End If
  
End Sub

Private Sub tvDatabase_MouseUp(BUTTON As Integer, Shift As Integer, x As Single, y As Single)
  
    On Error Resume Next
    
    If BUTTON = vbRightButton Then
        'try to get the node that they right clicked
        Set gnodDBNode2 = tvDatabase.HitTest(x, y)
        If gnodDBNode2 Is Nothing Then
            Set gnodDBNode2 = tvDatabase.HitTest(800, y)
        End If
        If gnodDBNode2 Is Nothing Then
            'try a little farther over
            Set gnodDBNode2 = tvDatabase.HitTest(1200, y)
        End If
        If gnodDBNode2 Is Nothing Then
            'frmMDI.mnuDBPUCopyStruct.Visible = False
            'frmMDI.mnuDBPURename.Visible = False
            'frmMDI.mnuDBPUDelete.Visible = False
            'frmMDI.mnuDBPUDesign.Visible = False
            'frmMDI.mnuDBPUOpen.Visible = False
            'frmMDI.mnuDBPUEdit.Visible = False
            frmMDI.mnuDBPUBar1.Visible = False
        Else
            'frmMDI.mnuDBPURename.Visible = True
            'frmMDI.mnuDBPUDelete.Visible = True
            frmMDI.mnuDBPUBar1.Visible = True
            If gnodDBNode2.Tag = TABLE_STR Then
                frmMDI.mnuDBPUOpen.Visible = True
                frmMDI.mnuDBPUEdit.Visible = False
                'frmMDI.mnuDBPUCopyStruct.Visible = True
                frmMDI.mnuDBPUDesign.Visible = False
                frmMDI.mnuDBPURename.Visible = False
                frmMDI.mnuDBPUDelete.Visible = False
                'frmMDI.mnuDBPUCopyStruct.Visible = True
                'frmMDI.mnuDBPUDesign.Visible = True
                'frmMDI.mnuDBPURename.Enabled = True
                'frmMDI.mnuDBPUDelete.Enabled = True
            ElseIf gnodDBNode2.Tag = QUERY_STR Then
                frmMDI.mnuDBPUOpen.Visible = True
                frmMDI.mnuDBPUEdit.Visible = False
                'frmMDI.mnuDBPUCopyStruct.Visible = False
                'frmMDI.mnuDBPUDesign.Visible = True
                'frmMDI.mnuDBPURename.Enabled = True
                'frmMDI.mnuDBPUDelete.Enabled = True
            ElseIf gnodDBNode2.Tag = INDEX_STR Then
                frmMDI.mnuDBPUOpen.Visible = False
                frmMDI.mnuDBPUEdit.Visible = False
                'frmMDI.mnuDBPUCopyStruct.Visible = False
                'frmMDI.mnuDBPUDesign.Visible = False
                'frmMDI.mnuDBPURename.Enabled = True
                'frmMDI.mnuDBPUDelete.Enabled = True
            ElseIf gnodDBNode2.Tag = FIELD_STR Then
                frmMDI.mnuDBPUOpen.Visible = False
                frmMDI.mnuDBPUEdit.Visible = False
                'frmMDI.mnuDBPUCopyStruct.Visible = False
                'frmMDI.mnuDBPUDesign.Visible = False
                'frmMDI.mnuDBPURename.Enabled = True
                'frmMDI.mnuDBPUDelete.Enabled = True
            ElseIf gnodDBNode2.Tag = PROPERTY_STR Then
                frmMDI.mnuDBPUOpen.Visible = False
                frmMDI.mnuDBPUEdit.Visible = True
                'frmMDI.mnuDBPUCopyStruct.Visible = False
                'frmMDI.mnuDBPUDesign.Visible = False
                'frmMDI.mnuDBPURename.Enabled = False
                'frmMDI.mnuDBPUDelete.Enabled = False
            ElseIf gnodDBNode2.Tag = PROPERTIES_STR Then
                frmMDI.mnuDBPUOpen.Visible = False
                frmMDI.mnuDBPUEdit.Visible = False
                'frmMDI.mnuDBPUCopyStruct.Visible = False
                'frmMDI.mnuDBPUDesign.Visible = False
                'frmMDI.mnuDBPURename.Enabled = False
                'frmMDI.mnuDBPUDelete.Enabled = False
            Else
                frmMDI.mnuDBPUOpen.Visible = False
                'frmMDI.mnuDBPUCopyStruct.Visible = False
                'frmMDI.mnuDBPUDesign.Visible = False
                'frmMDI.mnuDBPURename.Enabled = False
                'frmMDI.mnuDBPUDelete.Enabled = False
            End If
        End If
        'Set gwsactivews.databases(0) = frmActiveDB
        'Set gwsActiveWS = frmActiveWS
        'Set frmActiveFrm = Me
        PopupMenu frmMDI.mnuDBPopUp
    End If

End Sub

Private Sub tvDatabase_NodeClick(ByVal Node As Node)
  
    On Error GoTo tvDatabase_NodeClickErr
    
    Dim nod As Node
    Dim nodX As Node
    Dim fldObj As DAO.Field
    Dim idxObj As DAO.Index
    Dim prpObj As DAO.Property
    Dim colTmp As Object
    Dim vTmp As Variant
    
    Set gnodDBNode = Node
    
    Select Case Node.Tag
        Case FIELDS_STR
            If Node.Children > 0 Then Exit Sub
            
            'add the fields
            For Each fldObj In gwsActiveWS.Databases(0).TableDefs(Node.Parent.Text).Fields
                'For Each fldObj In gwsmainws.databases(0).TableDefs(Node.Parent.Text).Fields
                Set nodX = tvDatabase.Nodes.Add(Node.Key, _
                                                tvwChild, _
                                                Node.Parent.Key & ">" & FIELDS_STR & ">" & fldObj.Name, _
                                                fldObj.Name, FIELD_STR)
                nodX.Tag = FIELD_STR
            Next
            Node.Expanded = True
        
        Case FIELD_STR
            If Node.Children > 0 Then Exit Sub
            'For Each prpObj In gwsmainws.databases(0).TableDefs(Node.Parent.Parent.Text).Fields(Node.Text).Properties
            For Each prpObj In gwsActiveWS.Databases(0).TableDefs(Node.Parent.Parent.Text).Fields(Node.Text).Properties
                'special case the Value property because it
                'is not available from the field object on a tabledef
                If prpObj.Name <> "Value" Then
                    vTmp = GetPropertyValue(prpObj)
                    Set nodX = tvDatabase.Nodes.Add(Node.Key, _
                                                   tvwChild, _
                                                   Node.Parent.Key & Node.Key & ">" & prpObj.Name, _
                                                   prpObj.Name & "=" & vTmp, PROPERTY_STR)
                    nodX.Tag = PROPERTY_STR
                End If
            Next
            Node.Expanded = True
            Set tvDatabase.SelectedItem = Node
          
        Case INDEXES_STR
            If Node.Children > 0 Then Exit Sub
            'add the indexes
            'For Each idxObj In gwsmainws.databases(0).TableDefs(Node.Parent.Text).Indexes
            For Each idxObj In gwsActiveWS.Databases(0).TableDefs(Node.Parent.Text).Indexes
                Set nodX = tvDatabase.Nodes.Add(Node.Key, _
                                                tvwChild, _
                                                Node.Parent.Key & ">" & INDEXES_STR & ">" & idxObj.Name, _
                                                idxObj.Name, INDEX_STR)
                nodX.Tag = INDEX_STR
            Next
            Node.Expanded = True
        
        Case INDEX_STR
            If Node.Children > 0 Then Exit Sub
            'For Each prpObj In gwsmainws.databases(0).TableDefs(Node.Parent.Parent.Text).Indexes(Node.Text).Properties
            For Each prpObj In gwsActiveWS.Databases(0).TableDefs(Node.Parent.Parent.Text).Indexes(Node.Text).Properties
                vTmp = GetPropertyValue(prpObj)
                Set nodX = tvDatabase.Nodes.Add(Node.Key, _
                                                tvwChild, _
                                                Node.Parent.Key & Node.Key & ">" & prpObj.Name, _
                                                prpObj.Name & "=" & vTmp, PROPERTY_STR)
                nodX.Tag = PROPERTY_STR
            Next
            Node.Expanded = True
            Set tvDatabase.SelectedItem = Node
      
        Case PROPERTIES_STR
            If Node.Children > 0 Then Exit Sub
            'add the properties
            If Node.Parent Is Nothing Then
                'Set colTmp = gwsmainws.databases(0).Properties
                Set colTmp = gwsActiveWS.Databases(0).Properties
            Else
                Select Case Node.Parent.Tag
                    Case TABLE_STR
                        'Set colTmp = gwsmainws.databases(0).TableDefs(Node.Parent.Text).Properties
                        Set colTmp = gwsActiveWS.Databases(0).TableDefs(Node.Parent.Text).Properties
                    Case QUERY_STR
                        'Set colTmp = gwsmainws.databases(0).QueryDefs(Node.Parent.Text).Properties
                        If gwsActiveWS.Type = dbUseODBC Then
                            Set colTmp = gwsActiveWS.Connections(0).QueryDefs(Node.Parent.Text).Properties
                        Else
                            Set colTmp = gwsActiveWS.Databases(0).QueryDefs(Node.Parent.Text).Properties
                        End If
                    Case PROPERTY_STR
                        Exit Sub  'undone: need to get parent object
                End Select
            End If
            For Each prpObj In colTmp
                vTmp = GetPropertyValue(prpObj)
                If VarType(vTmp) = vbString Then
                    'truncate it to 50 chars
                    vTmp = Left$(vTmp, 50)
                End If
                If Node.Parent Is Nothing Then
                    Set nodX = tvDatabase.Nodes.Add(Node.Key, _
                                                    tvwChild, _
                                                    Node.Key & ">" & prpObj.Name, _
                                                    prpObj.Name & "=" & vTmp, PROPERTY_STR)
                Else
                    Set nodX = tvDatabase.Nodes.Add(Node.Key, _
                                                    tvwChild, _
                                                    Node.Parent.Key & ">" & prpObj.Name, _
                                                    prpObj.Name & "=" & vTmp, PROPERTY_STR)
                End If
                nodX.Tag = PROPERTY_STR
            Next
            Node.Expanded = True
    End Select
    
    Exit Sub
    
tvDatabase_NodeClickErr:
    If Err = 35602 Then Resume Next
    ShowError

End Sub

Function GetPropertyValue(prpObj As DAO.Property) As Variant

    On Error Resume Next
    
    Dim vTmp As Variant
    
    vTmp = prpObj.Value
    If Err Then
        Err.Clear
        GetPropertyValue = "N/A"
    Else
        GetPropertyValue = vTmp
    End If
  
End Function
