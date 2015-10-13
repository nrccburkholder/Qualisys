VERSION 5.00
Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
Begin VB.Form frmDataGrid 
   AutoRedraw      =   -1  'True
   ClientHeight    =   5565
   ClientLeft      =   3780
   ClientTop       =   2610
   ClientWidth     =   8070
   HelpContextID   =   2016191
   Icon            =   "DATAGRID.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MDIChild        =   -1  'True
   ScaleHeight     =   5565
   ScaleWidth      =   8070
   ShowInTaskbar   =   0   'False
   Tag             =   "Recordset"
   Begin MSDataGridLib.DataGrid DataGrid1 
      Align           =   1  'Align Top
      Height          =   4335
      Left            =   0
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   330
      Width           =   8070
      _ExtentX        =   14235
      _ExtentY        =   7646
      _Version        =   393216
      AllowUpdate     =   -1  'True
      HeadLines       =   1
      RowHeight       =   15
      TabAction       =   2
      AllowAddNew     =   -1  'True
      AllowDelete     =   -1  'True
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
         DataField       =   ""
         Caption         =   ""
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
         DataField       =   ""
         Caption         =   ""
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
   Begin VB.PictureBox picButtons 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   0
      ScaleHeight     =   330
      ScaleWidth      =   8070
      TabIndex        =   0
      Top             =   0
      Width           =   8070
      Begin VB.CommandButton cmdClrFilter 
         Caption         =   "Clea&r Filter"
         Height          =   330
         Left            =   2415
         MaskColor       =   &H00000000&
         TabIndex        =   3
         TabStop         =   0   'False
         Top             =   0
         Width           =   1215
      End
      Begin VB.CommandButton cmdRefresh 
         Caption         =   "&Refresh"
         Height          =   330
         Left            =   0
         MaskColor       =   &H00000000&
         TabIndex        =   1
         TabStop         =   0   'False
         Top             =   0
         Width           =   1215
      End
      Begin VB.CommandButton cmdFilter 
         Caption         =   "Set &Filter"
         Height          =   330
         Left            =   1200
         MaskColor       =   &H00000000&
         TabIndex        =   2
         TabStop         =   0   'False
         Top             =   0
         Width           =   1215
      End
      Begin VB.CommandButton cmdClose 
         Cancel          =   -1  'True
         Caption         =   "&Close"
         Height          =   330
         Left            =   3600
         MaskColor       =   &H00000000&
         TabIndex        =   4
         TabStop         =   0   'False
         Top             =   0
         Width           =   1215
      End
   End
End
Attribute VB_Name = "frmDataGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const BUTTON1 = "&Refresh"
Const BUTTON2 = "&Sort"
Const BUTTON3 = "&Filter"
Const BUTTON4 = "&Close"
Const BUTTON11 = "Clea&r Filter"
Const DATACTL = "Right Click for Data Control Properties"
Const MSG1 = "You Cannot Filter a Table Recordset!"
Const MSG2 = "Enter Filter Expression:"
Const MSG3 = "Setting New Filter"
Const MSG4 = "You Cannot Sort a Table Recordset!"
Const MSG5 = "Enter Sort Column:"
Const MSG6 = "Setting New Sort Order"
Const MSG7 = "Commit changes?"
Const MSG8 = "Delete Current Row?"

Dim gstr_sortby As String
Dim gstr_filterby As String
Dim sFilterStr As String

Dim SortOrder As Boolean
Dim PrevCol As Integer

Private Const MAX_PK_FIELDS = 16
Private gstrPKEY(MAX_PK_FIELDS + 1) As String
Public rs As New ADODB.Recordset
Public cn As New ADODB.Connection

Private gstrSELECT As String, gstrORDERBY As String, gstrWHERE As String
Private gstrTableName As String

Dim msSortCol As String
Dim mbCtrlKey As Integer

Public Sub AfterLoad(TableName As String)

    'Once we get here, we'll need to build the fields that will
    'be displayed in the grid.
    Dim qpf As New QualiSysFunctions.Library
    cn.ConnectionTimeout = 360
    cn.Open qpf.GetDBString
    cn.CommandTimeout = 360
    rs.CursorLocation = adUseClient
    rs.CursorType = adOpenKeyset
    rs.LockType = adLockOptimistic
    rs.ActiveConnection = cn
    rs.Open TableName
           
    
    Set qpf = Nothing
    'Set rs = pobjRecSet
    'BuildFields grdDataGrid, TableName
    'DataGrid.FirstRow = CStr(1)
    'Adodc1.Recordset.ActiveConnection = cn
    'Adodc1.UserName = "qpsa"
    'Adodc1.Password = "qpsa"
    'Adodc1.CursorLocation = adUseClient
    'Adodc1.CursorType = adOpenDynamic
    'Adodc1.LockType = adLockPessimistic
    'Adodc1.Recordset.Open TableName
    'Adodc1.RecordSource = TableName
    'Adodc1.r
    BuildFields TableName
    Set DataGrid1.DataSource = rs.DataSource
    DataGrid1.Refresh

End Sub

Private Sub BuildFields(TableName As String)
    
    ' Daniel Vansteenburg 8/18/99
    ' Since the Data Grid control is not
    ' building the right set of fields and displaying the data, we
    ' will put in our own data.
    Dim cnt As Integer, newcol As Integer
    Dim objADOrs As ADODB.Recordset
    Dim strowner As String
    Dim strtable As String
    Dim perpos As Integer
    Dim i As Integer

    On Error GoTo buildfielderr
    
     
    'Get the primary key columns so we don't allow them to update them.
    
    perpos = InStr(1, TableName, ".", vbTextCompare)
    
    If perpos > 0 Then
        strowner = Mid(TableName, 1, perpos - 1)
        strtable = Mid(TableName, perpos + 1)
    Else
        strowner = "dbo"
        strtable = Trim(TableName)
    End If
    
    gstrTableName = strowner & "." & Trim(strtable)
    'glngTypeTables = SYSTEM_TABLES
    If glngTypeTables = SYSTEM_TABLES Then
        Set objADOrs = cn.Execute("exec sp_pkeys '" & strtable & "','" & strowner & "', NULL")
    
        Do While Not objADOrs.EOF
            gstrPKEY(objADOrs!KEY_SEQ) = objADOrs!COLUMN_NAME
            'DataGrid1.Columns(gstrPKEY(objADOrs!KEY_SEQ)).Locked = True
            objADOrs.MoveNext
        Loop
    Else
        i = 0
        Set objADOrs = cn.Execute("select * from metadata_view where study_id = " & glngStudy_Id & " and BITKEYFIELD_FLG = 1 and STRTABLE_NM = '" & strtable & "'")
        Do While Not objADOrs.EOF
              i = i + 1
              gstrPKEY(i) = objADOrs!STRFIELD_NM
              'DataGrid1.Columns(gstrPKEY(i)).Locked = True
              objADOrs.MoveNext
         Loop
    End If
   
buildfielderr:
   'Rebind the Grid to the columns to make these changes perm.
    'pGrid.ReBind

End Sub

Sub cmdClose_Click()
    Unload Me
End Sub

Private Sub cmdClrFilter_Click()
    Dim strOldWhere As String
    
    On Error GoTo ClrFilterErr
    sFilterStr = ""
    
    rs.Filter = sFilterStr
    rs.Requery
    Exit Sub
    
ClrFilterErr:
    gstrWHERE = strOldWhere
    MsgBox "There was an error clearing the filter." & Chr(10) & _
           "Please try again.", vbOKOnly, "Clear Filter"
    Screen.MousePointer = 0
    MsgBar vbNullString, False
    
    Exit Sub
    
End Sub

Private Sub cmdFilter_Click()
  
    On Error GoTo FilterErr
    
    'Dim recRecordset1 As Recordset
       
    sFilterStr = InputBox(MSG2, , sFilterStr)
    
    If Len(sFilterStr) = 0 Then Exit Sub
    
    rs.Filter = sFilterStr
    
    Exit Sub
    
FilterErr:
    Screen.MousePointer = 0
    MsgBar vbNullString, False
    MsgBox "There was an error using the filter you specified, it was not applied." & Chr(10) & _
           "Please try again.", vbOKOnly, "Filter"
    
    Exit Sub

End Sub

Private Sub cmdRefresh_Click()

    On Error GoTo RefErr
    
    rs.Requery
    Set DataGrid1.DataSource = rs.DataSource
    DataGrid1.Refresh
    'grdDataGrid.Refresh
    'grdDataGrid.ReOpen
    
    Exit Sub
    
RefErr:
    MsgBox "Error:" & Err & " " & Error$
    
    Exit Sub
    
End Sub


Private Sub DataGrid1_KeyDown(KeyCode As Integer, Shift As Integer)
   'MsgBox KeyCode
End Sub

Private Sub DataGrid1_RowColChange(LastRow As Variant, ByVal LastCol As Integer)
'  Adodc1.Recordset.Save
End Sub

Private Sub Form_Load()
  
    On Error GoTo LoadErr
    
    cmdRefresh.Caption = BUTTON1
    cmdFilter.Caption = BUTTON3
    cmdClrFilter.Caption = BUTTON11
    cmdClose.Caption = BUTTON4
    
    'rs is a public module level variable
    'that must get set prior to 'Show'ing this form
    
    Me.Width = 6300
    Me.Height = 4560
    
    Exit Sub
    
LoadErr:
    MsgBox "Error:" & Err & " " & Error$
    Unload Me

End Sub

Private Sub Form_Unload(Cancel As Integer)
    If rs.State = adStateOpen Then
      If rs.EditMode = adEditInProgress Then
        rs.Update
      End If
       rs.Close
    End If
    'Set Adodc1.Recordset = Nothing
    If cn.State = adStateOpen Then cn.Close
    Set cn = Nothing
    Set rs = Nothing
        
End Sub

Private Sub Form_Resize()
  
    On Error Resume Next
    
    If Me.WindowState <> vbMinimized Then
        DataGrid1.Height = Me.ScaleHeight - (picButtons.Height + 135)
        ' DV 8/23/99 - Added Scaling on the Width of the object.
        'grdDataGrid.Width = Me.ScaleWidth
    End If
    
End Sub

Private Sub grdDataGrid_BeforeDelete(Cancel As Integer)
  
    If MsgBox(MSG8, vbYesNo + vbQuestion) <> vbYes Then
        Cancel = True
    End If

End Sub




Private Sub grdDataGrid_MouseUp(BUTTON As Integer, Shift As Integer, x As Single, y As Single)
  
    mbCtrlKey = Shift

End Sub

Private Sub grdDataGrid_UnboundAddData(ByVal RowBuf, NewRowBookmark As Variant)
    
    ' Daniel Vansteenburg 8/18/99
    ' This will allow us to do our data manipulation on the Data Grid
'    Dim Colcnt As Integer
'    Dim RowsUpdated As Integer
'    Dim blnUpdated As Boolean
'    Dim intPointer As Integer
'    Dim strSQLInsert As String
'    Dim strSQLValues As String
'
'    On Error GoTo exitfunc
'
'    intPointer = Screen.MousePointer
'    Screen.MousePointer = vbHourglass
'
'    blnUpdated = False
'    RowsUpdated = 0
'
'    'If Not rs.Updatable Then GoTo exitfunc
'
'    'Drs.AddNew
'
'    For Colcnt = 0 To RowBuf.ColumnCount - 1
'        ' Only columns that have been changed will be updated.
'        If Not IsNull(RowBuf.Value(0, Colcnt)) Then
'            strSQLInsert = strSQLInsert & Trim(rs.Fields(Colcnt).Name) & ","
'            Select Case rs.Fields(Colcnt).Type
'                Case dbChar, dbText, dbDate, dbTime, dbTimeStamp
'                    strSQLValues = strSQLValues & "'" & Trim(RowBuf.Value(0, Colcnt)) & "',"
'                Case Else
'                    strSQLValues = strSQLValues & "" & Trim(RowBuf.Value(0, Colcnt)) & ", "
'            End Select
'            'rs.Fields(Colcnt).Value = RowBuf.Value(0, Colcnt)
'        End If
'    Next
'
'    Dim objQPFunctions As New QualiSysFunctions.Library
'    Dim objADO As New ADODB.Connection
'
'    On Error GoTo UADError
'
'    objADO.ConnectionTimeout = 0
'    objADO.Open objQPFunctions.GetDBString
'    objADO.CommandTimeout = 0
'    objADO.Execute "SET IDENTITY_INSERT " & gstrTableName & " ON"
'    objADO.Execute "INSERT INTO " & gstrTableName & " (" & Left(Trim(strSQLInsert), Len(Trim(strSQLInsert)) - 1) & ") VALUES (" & Left(Trim(strSQLValues), Len(Trim(strSQLValues)) - 1) & ")", RowsUpdated
'    objADO.Execute "SET IDENTITY_INSERT " & gstrTableName & " OFF"
'    rs.Requery
'
'    'Drs.Update dbUpdateRegular, True
'    'DNewRowBookmark = CStr(rs.AbsolutePosition + 1)
'    NewRowBookmark = CStr(rs.RecordCount)
'    'DRowsUpdated = RowBuf.RowCount
'    blnUpdated = True
'
'    'grdDataGrid.ApproxCount = grdDataGrid.ApproxCount + RowsUpdated
'    grdDataGrid.ApproxCount = rs.RecordCount
'    RowBuf.RowCount = RowsUpdated
'    'grdDataGrid.ReOpen NewRowBookmark
'    'grdDataGrid.ReOpen
'
'exitfunc:
'    Screen.MousePointer = intPointer
'    Exit Sub
'
'UADError:
'    MsgBox "Error updating data." & vbCrLf & Err.Description, vbOKOnly, "Update"
'    RowBuf.RowCount = 0
'    Screen.MousePointer = intPointer
'    grdDataGrid.Refresh
'
    Exit Sub

End Sub

Private Sub grdDataGrid_UnboundDeleteRow(Bookmark As Variant)

'    ' Daniel Vansteenburg 8/18/99
'    ' This will allow us to do our data manipulation on the Data Grid
'    Dim intPointer As Integer
'
'    On Error GoTo exitfunc
'
'    intPointer = Screen.MousePointer
'    Screen.MousePointer = vbHourglass
'
'    'If Not rs.Updatable Then GoTo exitfunc
'
'    rs.MoveFirst
'    rs.Move CLng(Bookmark) - 1
'    rs.Delete
'    rs.Update dbUpdateCurrentRecord, True
'    grdDataGrid.ApproxCount = grdDataGrid.ApproxCount - 1
'    'DgrdDataGrid.Refresh
'    grdDataGrid.ReOpen
'
'exitfunc:
'    Screen.MousePointer = intPointer
'
End Sub

Private Sub grdDataGrid_UnboundReadDataEx(ByVal RowBuf, StartLocation As Variant, ByVal Offset As Long, ApproximatePosition As Long)

    ' Daniel Vansteenburg 8/18/99
    ' This will allow us to do our data manipulation on the Data Grid
    
    Dim Rowcnt As Long
    Dim Colcnt As Long
    Dim RowsReturned As Long
    Dim Increment As Long
    Dim ColIdx As Long
    Dim intPointer As Integer
    
    On Error GoTo exitfunc
    
    intPointer = Screen.MousePointer
    Screen.MousePointer = vbHourglass
    
    ' DV 8/23/1999
    ' If this condition is true, we are asking only
    ' for a bookmark.  Else, it is asking for data.
    If Offset < 0 Then
        Increment = -1
    Else
        Increment = 1
    End If
    
    RowsReturned = 0
    
    'If startlocation is null, then start reading at the end or
    'beginning of the dataset.
    If IsNull(StartLocation) Then
        If Offset < 0 Then
            rs.MoveLast
        Else
            rs.MoveFirst
        End If
    Else
        'find the position to start reading based on the
        'StartLocation bookmark and the Increment
        rs.MoveFirst
        rs.Move CLng(StartLocation) - 1
        rs.Move Offset
    End If
    
    'Transfer data from our data set array to the RowBuf
    'object which DBGrid uses to display data
    For Rowcnt = 0 To RowBuf.RowCount - 1
        If rs.BOF Or rs.EOF Then Exit For
        For Colcnt = 0 To RowBuf.ColumnCount - 1
            ColIdx = RowBuf.ColumnIndex(Rowcnt, Colcnt)
            Select Case rs.Fields(ColIdx).Type
                Case dbNumeric
                    RowBuf.Value(Rowcnt, Colcnt) = CLng(rs.Fields(ColIdx).Value)
                Case dbTimeStamp, dbDate, dbTime, dbBinary, dbLongBinary, dbVarBinary
                    RowBuf.Value(Rowcnt, Colcnt) = rs.Fields(ColIdx).Value
                Case Else
                    RowBuf.Value(Rowcnt, Colcnt) = rs.Fields(ColIdx).Value
            End Select
        Next
        'Set the bookmark using the RowID
        RowBuf.Bookmark(Rowcnt) = CStr(rs.AbsolutePosition + 1)
        rs.Move Increment
        RowsReturned = RowsReturned + 1
    Next
    
    ApproximatePosition = RowBuf.Bookmark(Rowcnt - 1) + 1
    
exitfunc:
    RowBuf.RowCount = RowsReturned
    Screen.MousePointer = intPointer

End Sub

Private Sub grdDataGrid_UnboundWriteData(ByVal RowBuf, WriteLocation As Variant)

    ' Daniel Vansteenburg 8/18/99
    ' This will allow us to do our data manipulation on the Data Grid
    Dim Colcnt As Integer
    Dim RowsUpdated As Integer
    Dim blnPKEY As Boolean, blnUpdated As Boolean
    Dim pkcnt As Integer
    Dim strSQLPkey As String
    Dim strSQLSet As String
    Dim intPointer As Integer
    On Error GoTo 0
    On Error GoTo exitfunc
    
    intPointer = Screen.MousePointer
    Screen.MousePointer = vbHourglass
    
    RowsUpdated = 0
    blnPKEY = False
    blnUpdated = False
    
    'If Not rs.Updatable Then GoTo exitfunc
    
    rs.MoveFirst
    rs.Move CLng(WriteLocation) - 1
    'Drs.Edit
    
    For Colcnt = 0 To RowBuf.ColumnCount - 1
        'Check to make sure that the Primary Key isn't changed.
        If Not IsNull(RowBuf.Value(0, Colcnt)) Then
            For pkcnt = 1 To MAX_PK_FIELDS
                If UCase(Trim(rs.Fields(Colcnt).Name)) = UCase(Trim(gstrPKEY(pkcnt))) Then
                    blnPKEY = True
                End If
            Next
            If Not blnPKEY Then
                ' Only columns that have been changed will be updated.
                strSQLSet = strSQLSet & _
                            Trim(rs.Fields(Colcnt).Name) & " = "
                Select Case rs.Fields(Colcnt).Type
                    Case dbChar, dbText, dbDate, dbTime, dbTimeStamp
                        'rs.Fields(Colcnt).Value = "'" & Trim(RowBuf.Value(0, Colcnt)) & "'"
                        strSQLSet = strSQLSet & "'" & Trim(RowBuf.Value(0, Colcnt)) & "',"
                    Case Else
                        'rs.Fields(Colcnt).Value = Trim(RowBuf.Value(0, Colcnt))
                        strSQLSet = strSQLSet & "" & Trim(RowBuf.Value(0, Colcnt)) & ", "
                End Select
                'rs.Fields(Colcnt).Value = RowBuf.Value(0, Colcnt)
                blnUpdated = True
            Else
                Exit For
            End If
        Else
            For pkcnt = 1 To MAX_PK_FIELDS
                If UCase(Trim(rs.Fields(Colcnt).Name)) = UCase(Trim(gstrPKEY(pkcnt))) Then
                    strSQLPkey = strSQLPkey & _
                                 "AND " & Trim(rs.Fields(Colcnt).Name) & " = "
                    Select Case rs.Fields(Colcnt).Type
                        Case dbChar, dbText, dbDate, dbTime, dbTimeStamp
                            strSQLPkey = strSQLPkey & "'" & Trim(rs.Fields(Colcnt).Value) & "' "
                        Case Else
                            strSQLPkey = strSQLPkey & "" & Trim(rs.Fields(Colcnt).Value) & " "
                    End Select
                End If
            Next
        End If
    Next
    
    'If the Primary key is changed, inform the user they cannot change it.
    'If we didn't update any rows, inform the user nothing changed.
    If blnPKEY Then
        MsgBox "You cannot change a Primary Key Field.", vbOKOnly, "Update"
        rs.CancelUpdate
    ElseIf Not blnUpdated Then
        MsgBox "No rows updated.", vbOKOnly, "Update"
        rs.CancelUpdate
    Else
      If rs.EditMode = adEditInProgress Then
         rs.Update
      End If
        RowsUpdated = RowBuf.RowCount
        'Always refresh the display after the change/or lack of/has been done.
        
        On Error GoTo UWDError
        
'        Dim objQPFunctions As New QualiSysFunctions.Library
'        Dim objADO As New adodb.Connection
'
'        objADO.ConnectionTimeout = 0
'        objADO.Open objQPFunctions.GetDBString
'        objADO.CommandTimeout = 0
'        objADO.Execute "UPDATE " & gstrTableName & " SET " & Left(Trim(strSQLSet), Len(Trim(strSQLSet)) - 1) & " WHERE 1=1 " & strSQLPkey
        'grdDataGrid.Refresh
    End If
    
exitfunc:
    rs.Requery
    'grdDataGrid.ReOpen
    Screen.MousePointer = intPointer
    
    Exit Sub
    
UWDError:
    MsgBox "Error updating data." & vbCrLf & Err.Description, vbOKOnly, "Update"
    RowBuf.RowCount = 0
    Screen.MousePointer = intPointer
    
    Exit Sub

End Sub

Private Sub DataGrid1_HeadClick(ByVal ColIndex As Integer)
   Dim s As String
   Dim s1 As String
   s1 = frmMDI.stsStatusBar.SimpleText
   s = DataGrid1.Columns(ColIndex).Caption
   frmMDI.stsStatusBar.SimpleText = "Sorting rows by " & s
   If PrevCol <> ColIndex Then
     SortOrder = True
   Else
     SortOrder = Not SortOrder
   End If
   
   PrevCol = ColIndex
   If SortOrder Then
     rs.Sort = s
   Else
     rs.Sort = s & " DESC"
   End If
   frmMDI.stsStatusBar.SimpleText = s1
      
End Sub
