Attribute VB_Name = "DCube"
Option Explicit

Public Type udtField
    Name As String
    Caption As String
    Orient As Long
    GFCaption As String
    GFType As Long
End Type

Public aFields() As udtField
Public iTable_id As Long
Public iField_id As Long

Private Enum enumDC_Excel_ConversionError
    NOERROR = 0
    TOOMANYCOLS = 1
    TOOMANYROWS = 2
End Enum
Dim WorkbookName As String
Private Const MAX_XLS_ROWS As Long = 65526
Private Const MAX_XLS_COLS As Long = 256

Private Const SW_SHOWNORMAL = 1
Private Const SW_SHOWMINIMIZED = 2

Private Const GW_HWNDNEXT = 2
Private Const GW_CHILD = 5

Private Declare Function apiShowWindow Lib "user32" _
    Alias "ShowWindow" (ByVal hWnd As Long, _
          ByVal nCmdShow As Long) As Long
          
Private Declare Function GetDesktopWindow Lib "user32" () As Long
          
Private Declare Function GetNextWindow Lib "user32" Alias "GetWindow" (ByVal _
hWnd As Long, ByVal wFlag As Long) As Long
Private Declare Function GetWindow Lib "user32" (ByVal hWnd As Long, ByVal _
wCmd As Long) As Long

Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" _
(ByVal hWnd As Long, ByVal lpString As String, ByVal cch As Long) As Long



Public Sub SaveToFile(dc As DynamiCubeLibCtl.DCube)
    
    Dim mlngFileHandle As Integer
    Dim pstrFileName As String
    Dim pstrToWrite As Variant
    Dim RowCounter As Integer, ColCounter As Integer, counterR As Integer, counterC As Integer
    
    pstrFileName = "dan.txt"
    mlngFileHandle = FreeFile
    pstrToWrite = ""
    RowCounter = dc.RowCount
    ColCounter = dc.ColCount
    
    Do While counterR <> RowCounter
        Do While counterC <> ColCounter
            pstrToWrite = pstrToWrite & dc.DataValue(counterR, counterC)
            counterC = counterC + 1
        Loop
        counterC = 0
        pstrToWrite = pstrToWrite & vbCr
        counterR = counterR + 1
    Loop
    Open "c:\" & pstrFileName For Output As #mlngFileHandle
    Print #mlngFileHandle, pstrToWrite
    Close #mlngFileHandle
    
    'FileCopy "C:" & pstrFileName, "C:\my documents\" & pstrFileName
    
    'Kill "C:" & pstrFileName
    
End Sub

Public Sub LoadCubeFields()
    
    Dim i As Long
    Dim iFields As Long
    Dim iField As Long

    'Count the number of items in the cube and redim the array
    iFields = frmCrossTabs.lstCol.ListCount + frmCrossTabs.lstRow.ListCount + frmCrossTabs.lstData.ListCount
    
    ReDim aFields(iFields - 1)
    
    frmCrossTabs.lstFieldName.Clear
    iField = 0
    
    For i = 0 To frmCrossTabs.lstCol.ListCount - 1
        frmCrossTabs.lstFieldName.AddItem frmCrossTabs.lstCol.List(i)
        aFields(iField).Name = frmCrossTabs.lstCol.List(i)
        aFields(iField).Caption = frmCrossTabs.lstCol.List(i)
        aFields(iField).Orient = 1
        aFields(iField).GFCaption = "Sum of " & aFields(iField).Name
        aFields(iField).GFType = 1
        iField = iField + 1
    Next
    
    For i = 0 To frmCrossTabs.lstRow.ListCount - 1
        frmCrossTabs.lstFieldName.AddItem frmCrossTabs.lstRow.List(i)
        aFields(iField).Name = frmCrossTabs.lstRow.List(i)
        aFields(iField).Caption = frmCrossTabs.lstRow.List(i)
        aFields(iField).Orient = 2
        aFields(iField).GFCaption = "Sum of " & aFields(iField).Name
        aFields(iField).GFType = 1
        iField = iField + 1
    Next
    
    For i = 0 To frmCrossTabs.lstData.ListCount - 1
        frmCrossTabs.lstFieldName.AddItem frmCrossTabs.lstData.List(i)
        aFields(iField).Name = frmCrossTabs.lstData.List(i)
        aFields(iField).Caption = frmCrossTabs.lstData.List(i)
        aFields(iField).Orient = 3
        iField = iField + 1
    Next
    
    frmCrossTabs.lstFieldName.ListIndex = 0

End Sub

Public Sub NewCube()
    
    Dim i As Long
    Dim strTableName As String
    Dim oFld As Variant
    
    strTableName = Left$(frmCrossTabs.cboTableName.List(frmCrossTabs.cboTableName.ListIndex), 25)
    strTableName = Trim(strTableName)

    ' Create a new Cube
    With frmDCube.DCube1
        ' Set up data source
        .DCConnectType = DCCT_RDO
        'The dsn connection must be set up with the MS drivers NOT Intersolve!!!
        '.DCConnect = "dsn=DCube;"
        .DCConnect = "dcube;UID=sa;PWD=newsapwd;"
        .DCRecordSource = "SELECT * from " & strTableName
        
        For i = 0 To UBound(aFields)
            Set oFld = .Fields.Add(aFields(i).Name, aFields(i).Caption, aFields(i).Orient)
            ' if not a data field
            If oFld.Orientation = 3 Then
                oFld.AggregateFunc = DCCount
                oFld.NumberFormat = "0"
            Else
                oFld.GroupFooterType = aFields(i).GFType
                oFld.GroupFooterCaption = aFields(i).GFCaption
            End If
        Next
    End With

    frmDCube.Show

End Sub

Public Sub LoadTables(mvarTables As Variant)
 
    Dim i As Long
 
    For i = 0 To UBound(mvarTables, 2)
        If mvarTables(2, i) Then
            frmCrossTabs.cboTableName.AddItem mvarTables(1, i)
            frmCrossTabs.cboTableName.ItemData(frmCrossTabs.cboTableName.NewIndex) = mvarTables(0, i)
        End If
    Next

End Sub

Public Sub LoadFields(iTable_id As Long)
    
    Dim rsField As New ADODB.Recordset
    Dim i As Long
    
    frmCrossTabs.lstFieldName.Clear
    frmCrossTabs.lstRow.Clear
    frmCrossTabs.lstCol.Clear
    frmCrossTabs.lstData.Clear
    
    For i = 0 To UBound(aTableFields, 1)
        If aTableFields(i).Table_id = iTable_id Then
            If aTableFields(i).Key_Field < 0 Then
                frmCrossTabs.lstData.AddItem aTableFields(i).FieldName
            Else
                frmCrossTabs.lstFieldName.AddItem aTableFields(i).FieldName
            End If
        End If
    Next i
        
End Sub

Function MultipleVisDatas(dc As DynamiCubeLibCtl.DCube) As Boolean

    '----------------------------------------------------------------------------------------------------------------------------------------------------------
    ' This function returns true if there are mulitple VISIBLE data fields else it returns false
    '----------------------------------------------------------------------------------------------------------------------------------------------------------
    
    Dim viscnt As Long, cnt As Long

    If dc.DataFields.Count > 1 Then
        ' There more than one, now see if they're all visible
        viscnt = 0
        
        For cnt = 0 To dc.DataFields.Count - 1
            If dc.DataFields(cnt).Visible = False Then viscnt = viscnt + 1
        Next cnt
        
        If viscnt > 0 Then
            ' at least one datfield is set to invisible
            If (dc.DataFields.Count - viscnt) > 1 Then
                ' there are multiple datafields visible
                MultipleVisDatas = True
                Exit Function
            Else
                ' then only one datafield is actually visible
                MultipleVisDatas = False
                Exit Function
            End If
        Else
            ' There are no invisible datafields
            MultipleVisDatas = True
            Exit Function
        End If
    End If
    
End Function

Public Sub ExportToText(dc As Control, sFileName As String)

    Dim hFile As Long
    Dim iRow, iCol, iDepth As Long
    Dim iRowFields, iColFields As Long
    Dim iSpaces As Long

    hFile = FreeFile
    
    Open sFileName For Output As #hFile
    
    iRowFields = dc.GetRowDepth(0)
    iColFields = dc.GetColDepth(0)
    
    For iDepth = 1 To dc.GetColDepth(iCol)
        iCol = 0
        
        ' space for rowheading area
        For iSpaces = 1 To iRowFields
            Print #hFile, Chr(9);
        Next
        
        ' column headings
        Do While (iCol < dc.ColCount)
            Print #hFile, Left(dc.ColHeading(iCol, iDepth), 7) + Chr(9);
            iCol = dc.GetNextCol(iCol)
        Loop
        Print #hFile,
    Next
    
    iRow = 0
    
    Do While (iRow < dc.RowCount)
        ' output row headings
        For iDepth = 1 To dc.GetRowDepth(iRow)
            Print #hFile, Left(dc.RowHeading(iRow, iDepth), 7) + Chr(9);
        Next
        
        ' if current iDepth is smaller than maxsize output spaces
        Do While iDepth <= iRowFields
            Print #hFile, Chr(9);
            iDepth = iDepth + 1
        Loop
        
        ' now output data
        iCol = 0

        Do While iCol < dc.ColCount
            Print #hFile, Left(Str$(dc.DataValue(iRow, iCol)), 7) + Chr(9);
            iCol = dc.GetNextCol(iCol)
        Loop
        
        ' incr loop counters for rows
        iRow = dc.GetNextRow(iRow)
        Print #hFile,
    Loop
 
    Close #hFile
    
End Sub

Public Sub ExportToExcel(dc As DynamiCubeLibCtl.DCube)

    On Error GoTo ErrorHandler

    Dim oXLApp As excel.Application
    Dim cnt As Long
    Dim iMaxRowDepth As Long
    Dim iMaxColDepth As Long
    Dim iCol As Long
    Dim iRow As Long
    Dim iColDepth As Long
    Dim iRowDepth As Long
    Dim xlCol As Long
    Dim xlRow As Long
    Dim iTempMaxColDepth As Long
    Dim viscnt As Long
    Dim strHeader As String
    Dim lXLSError As enumDC_Excel_ConversionError
    Dim strMsg As String
    Dim hWnd As Long
    Dim xlCaption As String
    
    Screen.MousePointer = vbHourglass
            
    ' Find out MaxRowDepth
    cnt = 0
    
    Do While cnt < dc.RowCount
        If dc.GetRowDepth(cnt) > iMaxRowDepth Then iMaxRowDepth = dc.GetRowDepth(cnt)
        cnt = dc.GetNextRow(cnt)
    Loop
    
    ' Find out MaxColDepth
    iMaxColDepth = 0
    cnt = 0
    
    Do While cnt < dc.ColCount - 1
        If iMaxColDepth < dc.GetColDepth(cnt) Then iMaxColDepth = dc.GetColDepth(cnt)
        cnt = dc.GetNextCol(cnt)
    Loop
    
    lXLSError = XLSEnabled(dc, iMaxColDepth, iMaxRowDepth)
    If lXLSError = NOERROR Then
        If 1 = 1 Then
            Set oXLApp = New excel.Application
            oXLApp.Caption = oXLApp.Caption & " Crostabs"
            xlCaption = oXLApp.Caption
            hWnd = GetHwnd(xlCaption)
            apiShowWindow hWnd, SW_SHOWMINIMIZED
            oXLApp.Workbooks.Add
            oXLApp.Visible = True
            
            WorkbookName = oXLApp.Workbooks(oXLApp.Workbooks.Count).Name
            oXLApp.Windows(WorkbookName).Activate
           ' Export Column Headings; start at iMaxRowDepth
            If MultipleVisDatas(dc) Then
                iTempMaxColDepth = (iMaxColDepth + 1)
            Else
                iTempMaxColDepth = iMaxColDepth
            End If
            
            For iColDepth = 1 To (iTempMaxColDepth)
                iCol = 0
                xlCol = (iMaxRowDepth + 1)
                
                Do While iCol < dc.ColCount
                   If MultipleVisDatas(dc) Then
                        If iColDepth < dc.GetColDepth(iCol) Then
                            strHeader = dc.ColHeading(iCol, iColDepth)
                            oXLApp.Cells(iColDepth, xlCol).Value = strHeader
                        End If
                    Else
                        If iColDepth <= dc.GetColDepth(iCol) Then
                            strHeader = dc.ColHeading(iCol, iColDepth)
                            oXLApp.Cells(iColDepth, xlCol).Value = strHeader
                        End If
                    End If
                    
                    iCol = dc.GetNextCol(iCol)
                    xlCol = xlCol + 1
                Loop
            Next iColDepth
            
            If MultipleVisDatas(dc) Then
                ' multiple visible datafields confirmed, now export captions
                xlCol = (iMaxRowDepth + 1)
                xlRow = (iMaxColDepth)
                iCol = 0
                
                Do While iCol < dc.ColCount
                    strHeader = dc.ColHeading(iCol, (dc.ColFields.Count + 1))
                    oXLApp.Cells(xlRow, xlCol).Value = strHeader
                    iCol = dc.GetNextCol(iCol)
                    xlCol = (xlCol + 1)
                Loop
            End If
            
            ' Now export RowHeadings and Data
            iRow = 0
            xlRow = (iMaxColDepth + 1)
            
            Do While iRow < dc.RowCount
                ' Get RowHeading(s)
                xlCol = 1
                
                For iRowDepth = 1 To dc.GetRowDepth(iRow)
                    strHeader = dc.RowHeading(iRow, iRowDepth)
                    oXLApp.Cells(xlRow, xlCol).Value = strHeader
                    xlCol = xlCol + 1
                Next iRowDepth
                
                iCol = 0
                xlCol = (iMaxRowDepth + 1)
                
                Do While iCol < dc.ColCount
                    strHeader = dc.DataValue(iRow, iCol)
                    oXLApp.Cells(xlRow, xlCol).Value = strHeader
                    iCol = dc.GetNextCol(iCol)
                    xlCol = (xlCol + 1)
                Loop
                
                iRow = dc.GetNextRow(iRow)
                xlCol = 1
                xlRow = (xlRow + 1)
            Loop
            
            'Max Row Depth in DQ converts to Column Depth in XLS and
            'Max Col Depth in DQ converts to Row Depth in XLS
            FormatWorkbook iMaxColDepth, iMaxRowDepth, oXLApp
            apiShowWindow hWnd, SW_SHOWNORMAL
            Set oXLApp = Nothing
        End If
    Else
        If lXLSError = TOOMANYCOLS Then
            strMsg = "There are too many Columns in the Cross Tab to Export to Excel."
        Else
            strMsg = "There are too many Rows in the Cross Tab to Export to Excel."
        End If
        MsgBox strMsg, vbInformation, "Cross Tabs"
    End If
    
    Screen.MousePointer = 0
    
    Exit Sub
    
ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: DCube.ExportToExcel, Error Description: " & Err.Description
    End
    
End Sub

Private Function XLSEnabled(x_dc As DynamiCubeLibCtl.DCube, x_lMaxColDepth As Long, x_lMaxRowDepth As Long) As enumDC_Excel_ConversionError
    
    ' Returns an error if the DynamicCube contains more rows or columns
    ' than Excel can handle
    
    XLSEnabled = NOERROR
    
    If x_dc.RowCount + x_lMaxColDepth > MAX_XLS_ROWS Then
        XLSEnabled = TOOMANYROWS
    ElseIf x_dc.ColCount + x_lMaxRowDepth > MAX_XLS_COLS Then
        XLSEnabled = TOOMANYCOLS
    ElseIf x_lMaxColDepth = 1 And x_lMaxRowDepth = 1 _
        And (x_dc.RowCount * 2) + x_lMaxColDepth > MAX_XLS_ROWS Then
            XLSEnabled = TOOMANYROWS
    ElseIf x_lMaxColDepth = 1 And x_lMaxRowDepth = 1 _
        And (x_dc.ColCount * 2) + x_lMaxRowDepth > MAX_XLS_COLS Then
            XLSEnabled = TOOMANYCOLS
    End If
    
End Function




Public Sub FormatWorkbook(x_lXLSRowDepth As Long, x_lXLSColDepth As Long, xl As excel.Application)
    Dim sHomeDataCell As String 'The first cell with data
    Dim lLastRowOffset As Long 'The offset from the first cell with data to the last row with data
    Dim lLastColOffset As Long 'The offset from the first cell with data to the last column with data
    Dim sSelectFrom As String 'The cell starting point in a selection of a group of cells
    Dim sSelectTo As String 'The cell ending point in a selection of a group of cells
    Dim lRow As Long 'Identifies the current row when ordering columns
    Dim lColOffset As Long 'The column offset from the first data cell to the last cell to sort
    Dim lCol As Long 'Identifies the current column when ordering rows
    Dim lRowOffset As Long 'The row offset from the first data cell to the last cell to sort
    Dim sNumerator As String 'The cell used as the numerator when calculating percentages
    Dim sDenominator As String 'The cell used as the denominator when calculating percentages
    Dim sFormula As String 'Holds the formula to calculate percentages
    Dim sLabel As String 'Used to hold the label for the percentage row and percentage column
    Dim sNewWorkbook As String 'Holds the name of the new workbook that is added
        
    'Set the active cell to "A1"
    xl.Range("A1").Select
    
    'Determine and record the first cell that contains data
    xl.ActiveCell.Offset(x_lXLSRowDepth, x_lXLSColDepth).Activate
    sHomeDataCell = xl.ActiveCell.Address(False, False)
    
    'Determine the last row with data and record the offset relative to sHomeDataCell
    xl.Range(sHomeDataCell).Select
    lLastRowOffset = 0
    While Trim(xl.ActiveCell.Offset(lLastRowOffset + 1, 0).Value) <> ""
        lLastRowOffset = lLastRowOffset + 1
    Wend
    
    'Determine the last column with data and record the offset relative to sHomeDataCell
    xl.Range(sHomeDataCell).Select
    lLastColOffset = 0
    While Trim(xl.ActiveCell.Offset(0, lLastColOffset + 1).Value) <> ""
        lLastColOffset = lLastColOffset + 1
    Wend
    
    'Order columns
    For lRow = x_lXLSRowDepth To 1 Step -1
        xl.Range(sHomeDataCell).Select
        xl.ActiveCell.Offset(-(lRow), 0).Activate
        sSelectFrom = xl.ActiveCell.Address(False, False)
        lColOffset = 0
        While xl.ActiveCell.Column < lLastColOffset + x_lXLSColDepth + 1
            While SumCol(lColOffset + 1, xl) = False
                lColOffset = lColOffset + 1
            Wend
            
            xl.ActiveCell.Offset(0, lColOffset).Activate
            xl.ActiveCell.Offset(lLastRowOffset + lRow, 0).Activate
            sSelectTo = xl.ActiveCell.Address(False, False)
            
            xl.Range(sSelectFrom, sSelectTo).Select
            xl.Selection.Sort Key1:=xl.Range(sSelectFrom, sSelectTo), Order1:=xlAscending, Header:=xlNo, _
                OrderCustom:=1, MatchCase:=False, Orientation:=xlLeftToRight
            
            'Get the next starting col
            lColOffset = lColOffset + 1
            
            While SumCol(lColOffset, xl) = True And _
                xl.ActiveCell.Offset(0, lColOffset).Column < lLastColOffset + x_lXLSColDepth + 1
                lColOffset = lColOffset + 1
            Wend
            xl.Range(sSelectFrom).Select
            xl.ActiveCell.Offset(0, lColOffset).Select
            sSelectFrom = xl.ActiveCell.Address(False, False)
            lColOffset = 0
        Wend
    Next
            
    'Order the rows
    For lCol = x_lXLSColDepth To 1 Step -1
        xl.Range(sHomeDataCell).Select
        xl.ActiveCell.Offset(0, -(lCol)).Activate
        sSelectFrom = xl.ActiveCell.Address(False, False)
        lRowOffset = 0
        While xl.ActiveCell.Row < lLastRowOffset + x_lXLSRowDepth + 1
            While SumRow(lRowOffset + 1, xl) = False
                lRowOffset = lRowOffset + 1
            Wend
            
            xl.ActiveCell.Offset(lRowOffset, 0).Activate
            xl.ActiveCell.Offset(0, lLastColOffset + lCol).Activate
            sSelectTo = xl.ActiveCell.Address(False, False)
            
            xl.Range(sSelectFrom, sSelectTo).Select
            xl.Selection.Sort Key1:=xl.Range(sSelectFrom, sSelectTo), Order1:=xlAscending, Header:=xlNo, _
                OrderCustom:=1, MatchCase:=False, Orientation:=xlTopToBottom
            
            'Get the next starting row
            lRowOffset = lRowOffset + 1
            While SumRow(lRowOffset, xl) = True And _
                xl.ActiveCell.Offset(lRowOffset, 0).Row < lLastRowOffset + x_lXLSRowDepth + 1
                lRowOffset = lRowOffset + 1
            Wend
            xl.Range(sSelectFrom).Select
            xl.ActiveCell.Offset(lRowOffset, 0).Select
            sSelectFrom = xl.ActiveCell.Address(False, False)
            lRowOffset = 0
        Wend
    Next
        
    If x_lXLSRowDepth = 1 And x_lXLSColDepth = 1 Then
        'Add Percent Rows
        xl.Range(sHomeDataCell).Select
        xl.ActiveCell.Offset(0, -1).Activate
        xl.ActiveCell.Offset(lLastRowOffset, 0).Activate
        sLabel = Trim(xl.ActiveCell.Value)
        sLabel = "Percent" & Right(sLabel, Len(sLabel) - 3)
        xl.ActiveCell.Offset(-(lLastRowOffset) + 1, 0).Activate
        While xl.ActiveCell.Row <= lLastRowOffset + 2
            xl.Rows(xl.ActiveCell.Row).Select
            xl.Selection.Insert Shift:=xlDown
            xl.Selection.NumberFormat = "0.00%"
            xl.ActiveCell.Select
            xl.ActiveCell.Value = sLabel
            lLastRowOffset = lLastRowOffset + 1
            xl.ActiveCell.Offset(2, 0).Activate
        Wend
        
        'Add Percent Columns
        xl.Range(sHomeDataCell).Select
        xl.ActiveCell.Offset(-1, 0).Activate
        xl.ActiveCell.Offset(0, lLastColOffset).Activate
        sLabel = Trim(xl.ActiveCell.Value)
        sLabel = "Percent" & Right(sLabel, Len(sLabel) - 3)
        xl.ActiveCell.Offset(0, -(lLastColOffset) + 1).Activate
        While xl.ActiveCell.Column <= lLastColOffset + 2
            xl.Columns(xl.ActiveCell.Column).Select
            xl.Selection.Insert Shift:=xlToRight
            xl.Selection.NumberFormat = "0.00%"
            xl.ActiveCell.Select
            xl.ActiveCell.Value = sLabel
            lLastColOffset = lLastColOffset + 1
            xl.ActiveCell.Offset(0, 2).Activate
        Wend
        
        'Calc Row Percents
        xl.Range(sHomeDataCell).Select
        sNumerator = xl.ActiveCell.Address(False, False)
        xl.ActiveCell.Offset(lLastRowOffset, 0).Activate
        sDenominator = xl.ActiveCell.Address(True, False)
        
        sFormula = "=" & sNumerator & "/" & sDenominator
        
        xl.Range(sHomeDataCell).Select
        xl.ActiveCell.Offset(1, 0).Activate

        xl.Range(xl.ActiveCell.Address).Formula = sFormula
        xl.Range(xl.ActiveCell.Address).Copy
        
        While xl.ActiveCell.Column <= lLastColOffset + 2
            While xl.ActiveCell.Row < lLastRowOffset
                xl.ActiveCell.Offset(2, 0).Activate
                xl.ActiveSheet.Paste
            Wend
            xl.ActiveCell.Offset(-(lLastRowOffset), 2).Activate
        Wend
        Application.CutCopyMode = False
        
        'Calc Column Percents
        xl.Range(sHomeDataCell).Select
        sNumerator = xl.ActiveCell.Address(False, False)
        xl.ActiveCell.Offset(0, lLastColOffset).Activate
        sDenominator = xl.ActiveCell.Address(False, True)
        
        sFormula = "=" & sNumerator & "/" & sDenominator
        
        xl.Range(sHomeDataCell).Select
        xl.ActiveCell.Offset(0, 1).Activate

        xl.Range(xl.ActiveCell.Address).Formula = sFormula
        xl.Range(xl.ActiveCell.Address).Copy
        
        While xl.ActiveCell.Row <= lLastRowOffset + 2
            While xl.ActiveCell.Column < lLastColOffset
                xl.ActiveCell.Offset(0, 2).Activate
                xl.ActiveSheet.Paste
            Wend
            xl.ActiveCell.Offset(2, -(lLastColOffset)).Activate
        Wend
        xl.Application.CutCopyMode = False
    End If
    'Stop
    
    'Add the data to a new workbook
    'Dim sBookName As String
    'xl.Application.Visible = True
    'sBookName = xl.ActiveWorkbook.Name
    'Workbooks.Add
    'sNewWorkbook = xl.ActiveWorkbook.Name
    'xl.Windows(sBookName).Activate
    'xl.Cells.Select
    'xl.Selection.Copy
    'xl.Windows(sNewWorkbook).Activate
    'xl.Cells.Select
    'xl.ActiveSheet.Paste
    'xl.Range("A1").Select
    'xl.Windows(sBookName).Activate
    'xl.Application.CutCopyMode = False
    'xl.Range("A1").Select
    'xl.Windows(sNewWorkbook).Activate
End Sub

Private Function SumRow(lRowOffset As Long, xl As excel.Application) As Boolean
    'Checks to see if the row is a "Sum Of" row
    Dim lCol As Long
    
    SumRow = False
    
    If InStr(xl.ActiveCell.Offset(lRowOffset, 0).Value, "Sum") <> 0 Then
        SumRow = True
    ElseIf Trim(xl.ActiveCell.Offset(lRowOffset, 0).Value) = "" Then
        lCol = xl.ActiveCell.Column - 1
        While SumRow = False And lCol > 0 And Trim(xl.ActiveCell.Offset(lRowOffset, 0).Value) = ""
            If InStr(xl.ActiveCell.Offset(lRowOffset, -(xl.ActiveCell.Column - lCol)).Value, "Sum") <> 0 Then
                SumRow = True
            End If
            lCol = lCol - 1
        Wend
    End If
End Function

Private Function SumCol(lColOffset As Long, xl As excel.Application) As Boolean
    'Checks to see if the column is a "Sum Of" column
    Dim lRow As Long
    
    SumCol = False
    
    If InStr(xl.ActiveCell.Offset(0, lColOffset).Value, "Sum") <> 0 Then
        SumCol = True
    ElseIf Trim(xl.ActiveCell.Offset(0, lColOffset).Value) = "" Then
        lRow = xl.ActiveCell.Row - 1
        While SumCol = False And lRow > 0 And Trim(xl.ActiveCell.Offset(0, lColOffset).Value) = ""
            If InStr(xl.ActiveCell.Offset(-(ActiveCell.Row - lRow), lColOffset).Value, "Sum") <> 0 Then
                SumCol = True
            End If
            lRow = lRow - 1
        Wend
    End If
End Function

Private Function GetText(ByVal hWnd As Long) As String
    Dim sText As String * 255
    Dim tmpLen As Long
    tmpLen = GetWindowText(hWnd, sText, 255)
     GetText = Left(sText, tmpLen)
End Function


Public Function GetHwnd(ByVal pTitle As String) As Long
Dim sTitle As String, hWnd As Long
hWnd = GetDesktopWindow
hWnd = GetWindow(hWnd, GW_CHILD)

Do While LCase(sTitle) <> LCase(pTitle)
    sTitle = GetText(hWnd)
    If LCase(sTitle) <> LCase(pTitle) Then
        hWnd = GetNextWindow(hWnd, GW_HWNDNEXT)
    End If
    If hWnd = 0 Then
        Exit Function
    End If
Loop
GetHwnd = hWnd

End Function

