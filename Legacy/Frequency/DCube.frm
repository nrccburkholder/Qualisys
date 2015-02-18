VERSION 5.00
Object = "{6D63F73C-3688-11D0-9C0F-00A0C90F29FC}#1.0#0"; "dcube.ocx"
Begin VB.Form frmDCube 
   Caption         =   "Cube Result Set"
   ClientHeight    =   6075
   ClientLeft      =   210
   ClientTop       =   495
   ClientWidth     =   7755
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6075
   ScaleWidth      =   7755
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   4320
      TabIndex        =   2
      Top             =   5445
      Width           =   1335
   End
   Begin VB.CommandButton cmdExcel 
      Caption         =   "Excel"
      Height          =   375
      Left            =   1950
      TabIndex        =   1
      Top             =   5445
      Width           =   1335
   End
   Begin DynamiCubeLibCtl.DCube DCube1 
      Height          =   4935
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   7215
      _ExtentX        =   12726
      _ExtentY        =   8705
      DataSource      =   ""
      BeginProperty HeadingsFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty FieldFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      RowAlignment    =   0
      ColAlignment    =   0
      RowStyle        =   1
      ColStyle        =   1
      OutlineIconAlignment=   1
      GridColor       =   12632256
      BackColor       =   16777215
      DCConnect       =   "fileDSN=qualpro.dsn"
      DCDatabaseName  =   ""
      CursorStyle     =   0
      FieldsBackColor =   8421504
      FieldsForeColor =   16777215
      HeadingsForeColor=   0
      HeadingsBackColor=   16777215
      DCRecordSource  =   "select * from encounter_data"
      TotalsBackColor =   16777215
      TotalsForeColor =   0
      BeginProperty TotalsFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      GridStyle       =   1
      ForeColor       =   0
      AllowFiltering  =   -1  'True
      AllowUserPivotFields=   -1  'True
      LeftMargin      =   0.75
      RightMargin     =   0.75
      TopMargin       =   0.49
      BottomMargin    =   0.49
      HeaderMargin    =   0.49
      FooterMargin    =   0.49
      FooterCaption   =   "- Page &P -"
      HeaderCaption   =   "DynamiCube"
      HeaderJustification=   1
      FooterJustification=   1
      ColPageBreak    =   0
      RowPageBreak    =   0
      ColHeadingsOnEveryPage=   -1  'True
      RowHeadingsOnEveryPage=   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      DCOptions       =   0
      AutoDataRefresh =   -1  'True
      BeginProperty PrinterFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty PrinterFontTotals {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty PrinterFontHeadings {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      PrinterColumnSpacing=   0.01
      PrinterGridColor=   0
      DCConnectType   =   99
      DCQueryTimeOut  =   0
      SQLYearPart     =   "datepart(""yyyy"",<field>)"
      SQLQuarterPart  =   "datepart(""q"",<field>)"
      SQLMonthPart    =   "datepart(""m"",<field>)"
      SQLWeekPart     =   "datepart(""ww"",<field>)"
      BorderStyle     =   1
      AllowSplitters  =   -1  'True
      QueryByPass     =   0   'False
      DataPath        =   ""
      DataNotAvailableCaption=   ""
      PageFieldsVisible=   -1  'True
      Fields          =   "DCube.frx":0000
   End
End
Attribute VB_Name = "frmDCube"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'variables and constants use in scaling DCube when the form is resized

Dim giCmdTop As Long
Dim gicmdExcelL As Long
Dim gicmdCloseL As Long

Private Const miMinHeight = 3000
Private Const miMinWidth = 5000
Private miExcelScaleF As Single
Private miCloseScaleF As Single

Private Sub cmdClose_Click()
    
    frmCrossTabs.MousePointer = vbDefault
    frmCrossTabs.Show
    frmCrossTabs.cboTableName.SetFocus
    
    Call frmCrossTabs.ResetMe
    
    Unload Me

End Sub

Private Sub cmdExcel_Click()
    
    Call ExportToExcel(DCube1)

End Sub

Private Sub Command1_Click()

    Unload Me

End Sub

Private Sub DCube1_FetchData()
    
    Dim i As Long
    Dim strTableName As String
    Dim oFld As Variant
    Dim strConnectString As String
    Dim strSql As String
    Dim cn As ADODB.Connection
    Dim rs As ADODB.Recordset
    
    Me.MousePointer = vbHourglass
    
    strTableName = Left$(frmCrossTabs.cboTableName.List(frmCrossTabs.cboTableName.ListIndex), 25)
    strTableName = Trim(strTableName)
    strSql = frmCrossTabs.GenerateSQL(strTableName)
    'strSql = frmCrossTabs.GetCrossTabSQL(strTableName)
    
    'strSQL = "Select Distinct "
    
    'For i = 0 To UBound(aFields)
    '    strSQL = strSQL & aFields(i).Name
    '    If i - UBound(aFields) <> 0 Then
    '        strSQL = strSQL & ", "
    '    Else
    '        strSQL = strSQL & " "
    '    End If
    'Next
    
    'strSQL = strSQL & "FROM " & strTableName & " " & _
                     "WHERE " & frmCrossTabs.strDateRecName & _
                     " BETWEEN '" & frmMain!mebStartDate & "' AND '" _
                     & frmMain!mebEndDate & "' "
    
    strConnectString = frmCrossTabs.fctMtsRetrieveDSN_INFO()
    
    Set cn = New ADODB.Connection
    Set rs = New ADODB.Recordset
    cn.CommandTimeout = 0
    cn.ConnectionTimeout = 0
    cn.Open strConnectString
    rs.ActiveConnection = cn
    rs.Open strSql
    
    Dim DCubeArray() As Variant
    Dim counter As Long
    Dim MyCounter As Variant
    Dim sMyStr As String
    
    counter = 0
    MyCounter = 0
    
    Do While Not rs.EOF
        ' need to write function to get the data starting with the rows in reverse, then the columns in reverse.
        ' The reason we have to do it this way is because dcube only has a add row function
        i = frmCrossTabs.lstCol.ListCount
        ReDim DCubeArray(counter)
        Do While i <= (UBound(aFields) - 1)
            ReDim Preserve DCubeArray(counter)
            sMyStr = aFields(i).Name
            sMyStr = Right(sMyStr, Len(sMyStr) - InStr(1, sMyStr, ".", vbTextCompare))
            sMyStr = Left(sMyStr, InStr(1, sMyStr, ".", vbTextCompare) - 1) & Right(sMyStr, Len(sMyStr) - InStr(1, sMyStr, ".", vbTextCompare))
            DCubeArray(counter) = rs.Fields(sMyStr).Value
            counter = counter + 1
            i = i + 1
        Loop
        
        i = 0
        Do While i < (frmCrossTabs.lstCol.ListCount)
            ReDim Preserve DCubeArray(counter)
            sMyStr = aFields(i).Name
            sMyStr = Right(sMyStr, Len(sMyStr) - InStr(1, sMyStr, ".", vbTextCompare))
            sMyStr = Left(sMyStr, InStr(1, sMyStr, ".", vbTextCompare) - 1) & Right(sMyStr, Len(sMyStr) - InStr(1, sMyStr, ".", vbTextCompare))
            DCubeArray(counter) = rs.Fields(sMyStr).Value
            counter = counter + 1
            i = i + 1
        Loop

        ReDim Preserve DCubeArray(counter)
        DCubeArray(counter) = 1
        Call frmDCube.DCube1.AddRowEx(DCubeArray)
        rs.MoveNext
        i = 0
        counter = 0
    Loop
    
    frmDCube.Show
    
    Me.MousePointer = vbDefault

End Sub

Private Sub Form_Load()
    
    Dim i As Long
    Dim oFld As DynamiCubeLibCtl.Field
    
    Me.MousePointer = vbHourglass
    
    frmDCube.DCube1.DCConnectType = DCCT_UNBOUND ' add all rows to DynamiCube
    
    For i = 0 To UBound(aFields)
        Set oFld = frmDCube.DCube1.Fields.Add(aFields(i).Name, aFields(i).Caption, aFields(i).Orient)
        If oFld.Orientation = 3 Then
            ' if not a data field
            oFld.AggregateFunc = DCCount
            oFld.NumberFormat = "0"
        Else
            oFld.GroupFooterType = aFields(i).GFType
            oFld.GroupFooterCaption = aFields(i).GFCaption
        End If
    Next
    
    frmDCube.DCube1.RefreshData
    
    DCube1.Left = 200
    DCube1.Width = frmDCube.ScaleWidth - 300
    DCube1.Top = 200
    DCube1.Height = frmDCube.ScaleHeight - (3 * cmdExcel.Height)
    
    DCube1.Refresh

    cmdExcel.Top = DCube1.Height + cmdExcel.Height
    cmdClose.Top = DCube1.Height + cmdClose.Height

    miExcelScaleF = cmdExcel.Left / frmDCube.ScaleWidth
    miCloseScaleF = cmdClose.Left / frmDCube.ScaleWidth
 
    Me.MousePointer = vbDefault
    
End Sub

Private Sub Form_Resize()

    If Me.Height < miMinHeight Then
        Me.Height = miMinHeight
    End If
    
    If Me.Width < miMinWidth Then
        Me.Width = miMinWidth
    End If
    
    DCube1.Left = 200
    DCube1.Width = frmDCube.ScaleWidth - 200

    DCube1.Top = 200
    DCube1.Height = frmDCube.ScaleHeight - (3 * cmdExcel.Height)

    DCube1.Refresh

    cmdExcel.Top = DCube1.Height + cmdExcel.Height
    cmdClose.Top = DCube1.Height + cmdClose.Height
    cmdExcel.Left = frmDCube.ScaleWidth * (cmdExcel.Left / frmDCube.ScaleWidth)
    cmdClose.Left = frmDCube.ScaleWidth * (cmdClose.Left / frmDCube.ScaleWidth)

End Sub
