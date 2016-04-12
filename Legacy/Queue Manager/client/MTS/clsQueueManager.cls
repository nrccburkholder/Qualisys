VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsQueueManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
    
Public bolReprint As Boolean
Private strShowGroupedPrint As String
Private strFilePath As String
Private strPDFPath As String
Private strAcrobatEXE As String
Private strFinalPDFPath As String   '** Added 08-11-05 JJF
Dim lngStudyId As Long
Const conDeleted = 6
Const conHospital = 12
Const conConfiguration = 13
Const conBundle = 14
Const conPrinting = 16
Dim strPCLServer As String
Dim strPCLDatabase As String
Dim strPCL As String
Dim strQueue As String
Dim strThisServer As String
Dim strThisDatabase As String
Dim strBundlingSheetPrinter As String

Private Enum col
        iTrayNumber = 1
        iTrayLevel = 2
        iTrayZip = 3
        iGroupDest = 4
        iCB = 5
        i5b = 6
        i3b = 7
        iadc = 8
        imadc = 9
        iRunningTotal = 10
End Enum

Private moConn As ADODB.Connection
Private moConn2 As ADODB.Connection
Const PassCodeCharSet = "ACDEFGHJKLMNPQRTUVWXY"
Const PassCodeLen = 8
   
Private Sub Initialize()
    
'    On Error GoTo ErrHandler
    If Not (moConn Is Nothing) Then Exit Sub
    
    Dim oQP_Lib As QualiSysFunctions.Library
    Dim strConnection As String
    Dim p1 As Long
    Dim p2 As Long
    Dim rs As New ADODB.Recordset
        
    If moConn Is Nothing Then
        Set moConn = New ADODB.Connection
    End If
    
    If moConn2 Is Nothing Then
        Set moConn2 = New ADODB.Connection
    End If
    
    If moConn.State = adStateOpen Then
        moConn.Close
    End If
    
    If moConn2.State = adStateOpen Then
        moConn2.Close
    End If
    
    Set oQP_Lib = CreateObject("QualiSysFunctions.Library")
    
    moConn.ConnectionTimeout = 0
    strConnection = oQP_Lib.GetDBString
    'strConnection = "driver={SQL Server};SERVER=NRC20;UID=qpsa;PWD=qpsa;DATABASE=QP_test"
    moConn.Open strConnection
    moConn.Close
    moConn.Properties("User ID").Value = "qpsa"
    moConn.Properties("Password").Value = "qpsa"
    moConn.Open
    moConn.CommandTimeout = 0
          
    rs.Open "select " & _
            "(select strParam_Value from QualPro_Params where strParam_nm ='QueueServer') as strServer, " & _
            "(select strParam_Value from QualPro_Params where strParam_nm ='QueueDatabase') as strDatabase ", moConn
    
    If Not ((rs.EOF) And (rs.BOF)) Then
      strPCLServer = UCase(rs.Fields("strServer"))
      strPCLDatabase = UCase(rs.Fields("strDatabase"))
    Else
      strPCLServer = ""
      strPCLDatabase = ""
    End If
    
    If rs.State = adStateOpen Then rs.Close
    Set rs = Nothing
          
    p1 = InStr(1, strConnection, "SERVER=", vbTextCompare) + 7
    p2 = InStr(p1, strConnection, ";UID", vbTextCompare)
    If p1 > 7 Then strThisServer = UCase(Mid(strConnection, p1, p2 - p1))
    p1 = InStr(1, strConnection, "DATABASE=", vbTextCompare) + 9
    If p1 > 9 Then strThisDatabase = UCase(Mid(strConnection, p1))
    
    strPCL = "pcloutput"
    strQueue = "dbo."
    
    If strThisDatabase <> strPCLDatabase Then
      strPCL = strPCLDatabase & ".dbo." & strPCL
      strQueue = strThisDatabase & "." & strQueue
      If strThisServer <> strPCLServer Then
        strPCL = strThisServer & "." & strPCL
        strQueue = strThisServer & "." & strQueue
      End If
    End If
    'strPCLServer = "nrc20"
    'strPCLDatabase = "qp_test"

    moConn2.ConnectionTimeout = 0
    moConn2.Open "driver={SQL Server};SERVER=" & strPCLServer & ";UID=qpsa;PWD=qpsa;DATABASE=" & strPCLDatabase
    moConn2.CommandTimeout = 0
           
    Set oQP_Lib = Nothing
        
    Exit Sub
    
ErrHandler:
    If rs.State = adStateOpen Then rs.Close
    Set rs = Nothing
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Sub

Private Sub Terminate()

    If Not moConn Is Nothing Then
        If moConn.State = adStateOpen Then
            moConn.Close
        End If
        Set moConn = Nothing
    End If
    
    If Not moConn2 Is Nothing Then
        If moConn2.State = adStateOpen Then
            moConn2.Close
        End If
        Set moConn2 = Nothing
    End If
    
End Sub

Public Function BundlingReport(ByVal strSurvey_id As String, _
                               ByVal strConfig_id As String, _
                               ByVal strBundled As String) As String
                               
    Dim strSQL As String
    Dim strFileHeader As String
    Dim datBundled As Date
    datBundled = strBundled
    
    Initialize
    
    strFileHeader = "BR" & strSurvey_id & "_" & Format(datBundled, "yyyymmdd_hhmm") & _
                    "_" & strConfig_id & ".xls"
                    
    BundlingReport = ExcelBundleReport(strSurvey_id, strConfig_id, datBundled, strFileHeader)
    
    Terminate
    
End Function

Public Function PostOfficeReport(ByVal strSurvey_id As String, _
                                 ByVal strConfig_id As String, _
                                 ByVal strBundled As String, _
                                 ByVal strMailed As String) As String
    Dim strSQL As String
    Dim strFileHeader As String
    Dim datBundled As Date, datMailed As Date
    Dim oCommand As ADODB.Command
    
    datBundled = strBundled
    datMailed = strMailed
    
    Initialize
    
    'Setup the command object for the stored procedure
    Set oCommand = New ADODB.Command
    With oCommand
        .CommandText = "sp_Queue_PostOfficeReport"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("datMailed", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("Survey_id", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
    
        'Set the values
        .Parameters("datBundled") = datBundled
        .Parameters("datMailed") = datMailed
        .Parameters("Survey_id") = strSurvey_id
        .Parameters("PaperConfig") = Val(strConfig_id)
    End With 'oCommand
    
    strFileHeader = "PO_" & strSurvey_id & "_" & Format(datMailed, "yyyymmdd_hhmm") & _
                    "_" & strConfig_id & "_" & ".xls"
    
    PostOfficeReport = PrintPostOfficeReport(oCommand, strFileHeader)
    
    Set oCommand = Nothing
    
    Terminate
    
End Function

Public Function PostOfficeFlatsReport(ByVal strSurvey_id As String, ByVal strConfig_id As String, ByVal strBundled As String, ByVal strMailed As String) As String
    
    Dim strSQL As String
    Dim strFileHeader As String
    Dim datBundled As Date, datMailed As Date
    Dim oCommand As ADODB.Command
    
    datBundled = strBundled
    datMailed = strMailed
    
    Initialize
    
    'Setup the command object for the stored procedure
    Set oCommand = New ADODB.Command
    With oCommand
        .CommandText = "sp_Queue_PostOfficeReport_Flats"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("datMailed", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("Survey_id", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
    
        'Set the values
        .Parameters("datBundled") = datBundled
        .Parameters("datMailed") = datMailed
        .Parameters("Survey_id") = Val(strSurvey_id)
        .Parameters("PaperConfig") = Val(strConfig_id)
    End With 'oCommand
    
    strFileHeader = "PO_" & strSurvey_id & "_" & Format(datMailed, "yyyymmdd_hhmm") & _
                    "_" & strConfig_id & "_" & ".xls"
    
    PostOfficeFlatsReport = PrintPostOfficeReport(oCommand, strFileHeader)
    
    Set oCommand = Nothing

    Terminate
    
End Function

Private Function PrintPostOfficeReport(ByRef oCommand As ADODB.Command, _
                                       ByVal strFileHeader As String) As String
    Dim tmpStr As String
    Dim rs As ADODB.Recordset
    Dim strFileName As String
    Dim strProjName As String
    Dim strPaperConfig_nm As String
    Dim datBundled As Date
    Dim datMailed As Date
    Dim bol9Digit As Boolean
    Dim cur9Digit As Boolean
    Dim strPostalBundle As String
    Dim TrayType As String
    Dim TrayLvl As String
    Dim strGroupDest As String
    Dim pieces As Long
    Dim intRunningTotal As Long
    Dim int5Btotal As Long
    Dim int3Btotal As Long
    Dim intADCtotal As Long
    Dim intMADCtotal As Long
    Dim bolNewReport As Boolean
    Dim intTrayNum As Integer
    Dim strAutomation As String
    Dim strFiller As String
    Dim iRunnintTotal As Long
    Dim iLastRow As Integer
    Dim strGroup As String
    Dim SheetsInNewWorkbook As Integer
    
    If InStr(1, strFileHeader, "\") = 0 Then strFileHeader = printFilePath & strFileHeader
    PrintPostOfficeReport = ""
    
    strFileName = strFileHeader
    If FileExists(strFileName) Then Kill (strFileName)
    
    Set rs = New ADODB.Recordset
    moConn.CommandTimeout = 0
    
    Set rs = oCommand.Execute()
    
    If Not rs.EOF And Not rs.BOF Then
        strProjName = ""
        strPaperConfig_nm = ""
        datBundled = Now
        datMailed = Now
        bol9Digit = False
        cur9Digit = (InStr("ABCDEKLMN", rs.Fields("TrayType").Value) > 0)
        strFileName = IIf(cur9Digit, "9", "5") + strFileHeader
        strPostalBundle = ""
        TrayType = ""
        strGroupDest = ""
        
        Dim xl As New Excel.Application
        Dim iRow As Integer
        Dim iCol As Integer
        
        SheetsInNewWorkbook = xl.SheetsInNewWorkbook
        xl.SheetsInNewWorkbook = 1
        xl.Workbooks.Add
                
        'On Error GoTo e1
        
        Do While Not rs.EOF
            If rs.Fields("intOrder").Value = 3 Then Exit Do
            bolNewReport = (strProjName <> rs.Fields("strProjName").Value Or strPaperConfig_nm <> rs.Fields("strPaperConfig_nm").Value Or datBundled <> rs.Fields("datBundled").Value Or datMailed <> rs.Fields("datMailed").Value Or bol9Digit <> cur9Digit)
            If bolNewReport Then
                strProjName = rs.Fields("strProjName").Value
                strPaperConfig_nm = rs.Fields("strPaperConfig_nm").Value
                datBundled = rs.Fields("datBundled").Value
                datMailed = rs.Fields("datMailed").Value
                bol9Digit = cur9Digit
                pieces = 0
                intRunningTotal = 0
                int5Btotal = 0
                int3Btotal = 0
                intADCtotal = 0
                intMADCtotal = 0
                TrayLvl = ""
                intTrayNum = 0
                
                xl.Worksheets.Add
                
                xl.Visible = False
                 
                xl.Cells(1, 1) = "USPS QUALIFICATION REPORT"
                xl.Cells(3, 1) = "MAIL DATE: " & datMailed
                xl.Cells(4, 1) = strProjName
                xl.Cells(5, 1) = strPaperConfig_nm
                
                If bol9Digit Then
                    xl.Cells(6, 1) = "9 DIGIT ZIP CODES"
                    strAutomation = "Automation"
                    'strFiller = ""
                Else
                    xl.Cells(6, 1) = "5 DIGIT ZIP CODES"
                    strAutomation = "Non-Automation"
                    'strFiller = "    "
                End If
                
                xl.ActiveSheet.Name = strAutomation
                
                xl.Cells(8, col.iTrayNumber) = "TRAY"
                xl.Cells(8, col.iTrayLevel) = "TRAY"
                xl.Cells(8, col.iTrayZip) = "TRAY"
                xl.Cells(8, col.iGroupDest) = "GROUP"
                xl.Cells(8, col.iGroupDest + 1) = "---------------------------------- RATES ----------------------------------"
                xl.Cells(8, col.iRunningTotal) = "RUNNING"
                xl.Cells(9, col.iTrayNumber) = "#"
                xl.Cells(9, col.iTrayLevel) = "LEVEL"
                xl.Cells(9, col.iTrayZip) = "ZIP"
                xl.Cells(9, col.iGroupDest) = "DEST"
                xl.Cells(9, col.iCB) = "CB"
                xl.Cells(9, col.i5b) = "5B"
                xl.Cells(9, col.i3b) = "3B"
                xl.Cells(9, col.iadc) = "ADC"
                xl.Cells(9, col.imadc) = "MADC"
                xl.Cells(9, col.iRunningTotal) = "TOTAL"
                iRow = 10
            End If
            tmpStr = ""
            If rs.Fields("TrayLvl").Value <> TrayLvl Then
                intTrayNum = intTrayNum + 1
                TrayType = rs.Fields("TrayType").Value
                TrayLvl = rs.Fields("TrayLvl").Value
                Select Case TrayType
                    Case "A", "F", "K", "O"
                        tmpStr = "5DG"
                    Case "B", "G"
                        tmpStr = "3DGS"
                    Case "C", "H", "L", "P"
                        tmpStr = "3DG"
                    Case "D", "I"
                        tmpStr = "AADC"
                    Case "M", "Q"
                        tmpStr = "ADC"
                    Case "E", "J"
                        tmpStr = "MAAD"
                    Case "N", "R"
                        tmpStr = "MADC"
                End Select
                
                xl.Cells(iRow, col.iTrayNumber) = "'" & intTrayNum
                xl.Cells(iRow, col.iTrayLevel) = tmpStr
                                                
                tmpStr = Pad(intTrayNum, 6) + Pad(tmpStr, 8)
                If TrayType = "E" Or TrayType = "J" Or TrayType = "N" Or TrayType = "R" Then
                    tmpStr = tmpStr & Pad("683", 8)
                    xl.Cells(iRow, iCol + col.iTrayZip) = "'683"
                Else
                    If InStr(rs.Fields("TrayLvl").Value, "-") > 0 Then
                        tmpStr = tmpStr + Pad(Mid(rs.Fields("TrayLvl").Value, 2, InStr(rs.Fields("TrayLvl").Value, "-") - 2), 8)
                        xl.Cells(iRow, col.iTrayZip) = "'" & Mid(rs.Fields("TrayLvl").Value, 2, InStr(rs.Fields("TrayLvl").Value, "-") - 2)
                    Else
                        tmpStr = tmpStr + Pad(Mid(rs.Fields("TrayLvl").Value, 2, 8), 8)
                        xl.Cells(iRow, col.iTrayZip) = "'" & Mid(rs.Fields("TrayLvl").Value, 2, 8)
                    End If
                End If
                TrayLvl = rs.Fields("TrayLvl").Value
            Else
                tmpStr = tmpStr & Pad("", 22)
            End If
            
            
            strGroup = UCase(Trim(IIf(IsNull(rs.Fields("strGroupDest").Value), "", rs.Fields("strGroupDest").Value)))
            
            If IsNull(rs.Fields("strGroupDest").Value) Then
                tmpStr = tmpStr + String(8, " ")
            Else
                If Left(tmpStr, 1) <> " " And Left(rs.Fields("TrayLvl").Value, Len(Trim(rs.Fields("strGroupDest").Value))) = Trim(rs.Fields("strGroupDest").Value) Then
                    tmpStr = tmpStr + String(8, " ")
                Else
                    If InStr("MQ", Left(rs.Fields("strGroupDest").Value, 1)) > 0 Then
                        tmpStr = tmpStr + Pad("A" + Mid(rs.Fields("strGroupDest").Value, 2, 8), 8)
                        xl.Cells(iRow, col.iGroupDest) = "A" + Mid(rs.Fields("strGroupDest").Value, 2, 8)
                    Else
                        tmpStr = tmpStr + Pad(Mid(rs.Fields("strGroupDest").Value, 2, 8), 8)
                        xl.Cells(iRow, col.iGroupDest) = "'" & Mid(rs.Fields("strGroupDest").Value, 2, 8)
                    End If
                End If
            End If
                        
            pieces = rs.Fields("Pieces").Value
            tmpStr = tmpStr + String(7, " ") 'No carrier route bundles
            Select Case TrayType
                Case "A", "F":   '5B
                    tmpStr = tmpStr + LPad(pieces, 10)
                    intRunningTotal = intRunningTotal + pieces
                    xl.Cells(iRow, col.i5b) = pieces
                    int5Btotal = int5Btotal + pieces
                Case "B", "C", "G", "H": '3B
                    xl.Cells(iRow, col.i3b) = pieces
                    tmpStr = tmpStr + LPad(pieces, 20)
                    intRunningTotal = intRunningTotal + pieces
                    int3Btotal = int3Btotal + pieces
                Case "D", "I": 'ADC
                    intRunningTotal = intRunningTotal + pieces
                    tmpStr = tmpStr + LPad(pieces, 30)
                    xl.Cells(iRow, col.iadc) = pieces
                    intADCtotal = intADCtotal + pieces
                Case "D", "I", "E", "J": 'ADC
                    intRunningTotal = intRunningTotal + pieces
                    xl.Cells(iRow, col.imadc) = pieces
                    intMADCtotal = intMADCtotal + pieces
                Case "K", "L", "M", "N", "O", "P", "Q", "R":
                    Select Case Left(strGroup, 1)
                        Case "K", "O": '5B
                            tmpStr = tmpStr + LPad(pieces, 10)
                            xl.Cells(iRow, col.i5b) = pieces
                            intRunningTotal = intRunningTotal + pieces
                            int5Btotal = int5Btotal + pieces
                        Case "L", "P": '3B
                            tmpStr = tmpStr + LPad(pieces, 20)
                            xl.Cells(iRow, col.i3b) = pieces
                            intRunningTotal = intRunningTotal + pieces
                            int3Btotal = int3Btotal + pieces
                        Case "M", "Q", "N", "R": 'ADC
                            intRunningTotal = intRunningTotal + pieces
                    
                            If InStr(2, strGroup, "MADC") > 0 Then
                                xl.Cells(iRow, col.imadc) = pieces
                                intMADCtotal = intMADCtotal + pieces
                            Else
                                tmpStr = tmpStr + LPad(pieces, 30)
                                xl.Cells(iRow, col.iadc) = pieces
                                intADCtotal = intADCtotal + pieces
                            End If
                    End Select
                
            End Select
jump1:
            xl.Cells(iRow, col.iRunningTotal) = intRunningTotal
            tmpStr = Pad(tmpStr, 67) & LPad(intRunningTotal, 10) & vbCrLf
            iRow = iRow + 1
            rs.MoveNext
            If rs.EOF Then
                bolNewReport = True
            ElseIf Not rs.EOF And rs.Fields("intorder").Value = 3 Then
                bolNewReport = True
            Else
                cur9Digit = (InStr("ABCDEKLMN", rs.Fields("TrayType").Value) > 0)
                bolNewReport = (strProjName <> rs.Fields("strProjName").Value Or strPaperConfig_nm <> rs.Fields("strPaperConfig_nm").Value Or datBundled <> rs.Fields("datBundled").Value Or datMailed <> rs.Fields("datMailed").Value Or bol9Digit <> cur9Digit)
            End If
            If bolNewReport Then
                xl.Range(xl.Cells(8, col.iCB), xl.Cells(iRow - 1, col.iRunningTotal)).HorizontalAlignment = xlRight
                xl.Range(xl.Cells(8, col.iTrayZip), xl.Cells(iRow - 1, col.iTrayZip)).NumberFormat = "000"
                
                xl.Range(xl.Cells(8, col.iCB), xl.Cells(8, col.imadc)).Select
                xl.Selection.HorizontalAlignment = xlCenter
                xl.Selection.Merge
                                
                xl.Cells(iRow + 1, 1) = "TOTALS"
                xl.Cells(iRow + 1, col.iCB) = 0
                
                iCol = col.iadc
                xl.Cells(iRow + 1, iCol) = "=sum(" & Chr(64 + iCol) & "10:" & Chr(64 + iCol) & iRow & ")"
                iCol = col.imadc
                xl.Cells(iRow + 1, iCol) = "=sum(" & Chr(64 + iCol) & "10:" & Chr(64 + iCol) & iRow & ")"
                iCol = col.i5b
                xl.Cells(iRow + 1, iCol) = "=sum(" & Chr(64 + iCol) & "10:" & Chr(64 + iCol) & iRow & ")"
                iCol = col.i3b
                xl.Cells(iRow + 1, iCol) = "=sum(" & Chr(64 + iCol) & "10:" & Chr(64 + iCol) & iRow & ")"
                xl.Cells(iRow + 1, col.iRunningTotal) = intRunningTotal
                
                xl.Cells(iRow + 3, 1) = "RATES SUMMARY"
                xl.Cells(iRow + 4, 1) = strAutomation & " Carrier Route (CB)"
                xl.Cells(iRow + 5, 1) = strAutomation & " 5-Digit (5B)"
                xl.Cells(iRow + 6, 1) = strAutomation & " 3-Digit (3B)"
                xl.Cells(iRow + 7, 1) = strAutomation & " Basic (ADC)"
                xl.Cells(iRow + 8, 1) = strAutomation & " Basic (MADC)"
                xl.Cells(iRow + 9, 1) = "TOTAL " & strAutomation
                
                
                xl.Cells(iRow + 3, 5) = "PIECES"
                xl.Cells(iRow + 3, 5).HorizontalAlignment = xlRight
                xl.Cells(iRow + 4, 5) = 0
                xl.Cells(iRow + 5, 5) = int5Btotal
                xl.Cells(iRow + 6, 5) = int3Btotal
                xl.Cells(iRow + 7, 5) = intADCtotal
                xl.Cells(iRow + 8, 5) = intMADCtotal
                xl.Cells(iRow + 9, 5) = intRunningTotal
                
                xl.Cells.Font.Name = "Times New Roman"
                xl.Cells.Font.Size = 10
                xl.Columns.ColumnWidth = 8
                
            End If
        Loop 'do while
        If Not rs.EOF Then
            xl.Worksheets.Add
            xl.ActiveSheet.Name = "Survey Breakdown"
            
            xl.Cells(1, 1) = "GROUPED PRINT SURVEY BREAKDOWN REPORT"
            xl.Cells(3, 1) = "MAIL DATE: " & datMailed
            xl.Cells(4, 1) = strPaperConfig_nm
            xl.Range(xl.Cells(1, 1), xl.Cells(1, 7)).Merge
            xl.Range(xl.Cells(3, 1), xl.Cells(3, 7)).Merge
            xl.Range(xl.Cells(4, 1), xl.Cells(4, 7)).Merge
                
            xl.Cells(6, 2) = "---------------------------------- RATES ----------------------------------"
            xl.Range(xl.Cells(6, 2), xl.Cells(6, 6)).Merge
            xl.Cells(6, 2).HorizontalAlignment = xlCenter
            xl.Cells(7, 1) = "Client/Survey"
            xl.Cells(7, 2) = "CB"
            xl.Cells(7, 3) = "5B"
            xl.Cells(7, 4) = "3B"
            xl.Cells(7, 5) = "ADC"
            xl.Cells(7, 6) = "MADC"
            xl.Cells(6, 7) = "RUNNING"
            xl.Cells(7, 7) = "TOTAL"
            With xl.Range(xl.Cells(7, 1), xl.Cells(7, 7)).Borders(xlEdgeBottom)
                .LineStyle = xlContinuous
                .Weight = xlThin
                .ColorIndex = xlAutomatic
            End With
            
            iRow = 7
            strProjName = "xyz"
            intRunningTotal = 0
                
            While Not rs.EOF
                If rs.Fields("strProjName").Value <> strProjName Then
                    If iRow > 7 Then xl.Cells(iRow, 7) = intRunningTotal
                    iRow = iRow + 1
                    strProjName = rs.Fields("strProjName").Value
                    xl.Cells(iRow, 1) = strProjName
                End If
                Select Case rs.Fields("TrayType").Value
                    Case "A":
                        xl.Cells(iRow, 2) = rs.Fields("pieces").Value
                    Case "B", "C":
                        xl.Cells(iRow, 3) = rs.Fields("pieces").Value
                    Case "D":
                        xl.Cells(iRow, 4) = rs.Fields("pieces").Value
                    Case "E":
                        xl.Cells(iRow, 5) = rs.Fields("pieces").Value
                    Case Else:
                        xl.Cells(iRow, 6) = rs.Fields("pieces").Value
                End Select
                intRunningTotal = intRunningTotal + rs.Fields("pieces").Value
                rs.MoveNext
            Wend
            xl.Cells(iRow, 7) = intRunningTotal
            xl.Columns("A:A").AutoFit
            xl.Columns("B:F").ColumnWidth = 6
            xl.Columns("G:G").AutoFit
            xl.Range("B7:G7").HorizontalAlignment = xlRight
            xl.Range("G6").HorizontalAlignment = xlRight
        
        End If
        PrintPostOfficeReport = strFileHeader
        
    End If
     
    If rs.State = adStateOpen Then
        rs.Close
    End If
    Set rs = Nothing
    xl.Workbooks(1).SaveAs (strFileHeader)
e1:
    xl.SheetsInNewWorkbook = SheetsInNewWorkbook
    On Error Resume Next
    xl.Sheets("Sheet1").Delete
    xl.Sheets("Automation").Select
    xl.Sheets("Automation").Move Before:=xl.Sheets(1)
    xl.Visible = True
    Set xl = Nothing
    On Error GoTo 0
End Function

Private Function Pad(ByVal str As String, ByVal strLen As Integer) As String
    Pad = Left(str + String(strLen, " "), strLen)
End Function

Private Function LPad(ByVal str As String, ByVal strLen As Integer) As String
    LPad = Right(String(strLen, " ") + str, strLen)
End Function

' *** 12-08-2005 SH Added
Private Function GetSurveyType(ByVal SurveyID As Long) As String

    Dim SQL As String
    Dim rs As New ADODB.Recordset
    
    SQL = "SELECT st.SurveyType_ID, st.SurveyType_Dsc " & _
          "FROM Survey_Def sd, SurveyType st " & _
          "WHERE sd.SurveyType_ID = st.SurveyType_ID " & _
          "  AND sd.Survey_ID = " & SurveyID
    
    rs.Open SQL, moConn, adOpenKeyset, adLockReadOnly
    If Not rs.EOF And Not rs.BOF Then
        If rs!SurveyType_ID > 1 Then
            GetSurveyType = "     ********** " & rs!SurveyType_Dsc & " **********     "
        Else
            GetSurveyType = ""
        End If
    Else
        GetSurveyType = ""
    End If
    
    rs.Close
    Set rs = Nothing
    
End Function
' *** End of addition

Private Function ExcelBundleReport(ByVal strSurvey_idSelect As String, _
                                   ByVal strConfig_idSelect As String, _
                                   ByVal datBundledSelect As Date, _
                                   ByVal strFileHeader As String) As String
    Dim strSurvey_id As String
    Dim rs As ADODB.Recordset
    Dim curBundle As String, strBundle As String, strGroup As String
    Dim boolFlats As Boolean
    Dim oBunRepCm As ADODB.Command
    Dim pieces As Long
    Dim runningTotal As Long
    Dim isGroupedPrint As Boolean
    Dim SheetsInNewWorkbook As Integer
    Dim ExtraColumns, aColumn As String
    Dim curColumn As Integer
    Dim flagNQLBundle As Boolean   '** Added 07-26-2010 JJF
    
    ExcelBundleReport = ""
    
    If InStr(1, strFileHeader, "\") = 0 Then strFileHeader = printFilePath & strFileHeader
    If FileExists(strFileHeader) Then Kill (strFileHeader)
    
    Initialize
    
    Set oBunRepCm = New ADODB.Command
    With oBunRepCm
        .CommandText = "sp_Queue_BundleReport"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("Survey_id", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
    End With 'oBunRepCm
    
    Set rs = New ADODB.Recordset
    moConn.CommandTimeout = 0
    
    With oBunRepCm
        .Parameters("datBundled") = datBundledSelect
        .Parameters("Survey_id") = strSurvey_idSelect
        .Parameters("PaperConfig") = Val(strConfig_idSelect)
        Set rs = .Execute()
    End With
    
    If rs.EOF And rs.BOF Then
        Set rs = Nothing
        Set oBunRepCm = Nothing
        Exit Function
    End If
    
    Dim xl As New Excel.Application
    Dim iRow As Integer
    
    SheetsInNewWorkbook = xl.SheetsInNewWorkbook
    xl.SheetsInNewWorkbook = 1
    xl.Workbooks.Add
    xl.ActiveSheet.Name = "Bundling Report"
    
    With xl.ActiveSheet.PageSetup
        .LeftMargin = Application.InchesToPoints(0.5)
        .RightMargin = Application.InchesToPoints(0.5)
        .TopMargin = Application.InchesToPoints(0.5)
        .BottomMargin = Application.InchesToPoints(0.5)
        .Orientation = xlPortrait
        .FitToPagesWide = 1
        .FitToPagesTall = False
    End With
   
    ' *** 12-08-2005 SH Added
    ' Added the survey type on the bundling report and make it BOLD.
    xl.Rows("1:1").EntireRow.Font.Bold = True
    '01-21-2010 JJF - Added HHCAHPS
    'xl.Cells(1, 1) = "BUNDLING REPORT" & "" & IIf(GetSurveyType(Val(strSurvey_idSelect)) = 2, "     ********** HCAHPS **********     ", "")
    xl.Cells(1, 1) = "BUNDLING REPORT" & "" & GetSurveyType(Val(strSurvey_idSelect))
    
    xl.Cells(3, 1) = rs.Fields("strProjName").Value
    xl.Cells(4, 1) = strFileHeader
    xl.Cells(5, 1) = rs.Fields("strPaperConfig_nm").Value
    xl.Cells(6, 1) = "Spooled on " & rs.Fields("datBundled").Value
    
    xl.Range(xl.Cells(1, 1), xl.Cells(1, 6)).Select: xl.Selection.Merge
    xl.Range(xl.Cells(3, 1), xl.Cells(3, 6)).Select: xl.Selection.Merge
    xl.Range(xl.Cells(4, 1), xl.Cells(4, 6)).Select: xl.Selection.Merge
    xl.Range(xl.Cells(5, 1), xl.Cells(5, 6)).Select: xl.Selection.Merge
    xl.Range(xl.Cells(6, 1), xl.Cells(6, 6)).Select: xl.Selection.Merge
            
    boolFlats = (Left(rs.Fields("strPostalBundle"), 1) >= "K")
    
    If boolFlats Then
        xl.Cells(7, 1) = "Tray"
        xl.Cells(7, 2) = "Bundle"
    Else
        xl.Cells(7, 1) = "Bundle"
        xl.Cells(7, 2) = "Group"
    End If
    xl.Cells(7, 3) = "Litho Range"
    xl.Cells(7, 4) = "Pieces"
    xl.Cells(7, 5) = "Running" & Chr(10) & "Total"
    
    curColumn = 5
    ExtraColumns = GetRegValue(HKEY_LOCAL_MACHINE, "Software\National Research\QualiSys\Queue Manager", "BundlingReportExtraColumns")
    If ExtraColumns <> "-1" And ExtraColumns <> "" Then
        If Right(ExtraColumns, 1) <> "," Then ExtraColumns = ExtraColumns + ","
        While InStr(1, ExtraColumns, ",") > 0
            aColumn = Mid(ExtraColumns, 1, InStr(1, ExtraColumns, ",") - 1)
            curColumn = curColumn + 1
            aColumn = Replace(aColumn, "||", Chr(10))
            xl.Cells(7, curColumn) = aColumn
            ExtraColumns = Mid(ExtraColumns, InStr(1, ExtraColumns, ",") + 1)
        Wend
    End If
    
    With xl.Range(xl.Cells(7, 1), xl.Cells(7, curColumn)).Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
        
    strSurvey_id = rs.Fields("Survey_id").Value
    strGroup = ""
    curBundle = ""
    isGroupedPrint = (strSurvey_id = "0")
    iRow = 7
    
    flagNQLBundle = False  '** Added 07-26-2010 JJF
    While (Not rs.EOF) And ((Not isGroupedPrint) Or strSurvey_id = "0")
        'until rs.eof or (isgroupedprint and survey_id <> "0")
        If IsNull(rs.Fields("strGroupDest").Value) Then
            strGroup = ""
        Else
            strGroup = rs.Fields("strGroupDest").Value
        End If
        If curBundle <> rs.Fields("strpostalbundle").Value Then
            strBundle = rs.Fields("strPostalBundle").Value
            curBundle = strBundle
            '** Added 07-26-10 JJF
            'If this is an NQL bundle then flag it for background color change
            If UCase(strBundle) = "FOR" Then
                flagNQLBundle = True
            Else
                flagNQLBundle = False
            End If
            '** End of add 07-26-10 JJF
        Else
            strBundle = ""
        End If
        
        iRow = iRow + 1
        xl.Cells(iRow, 1) = strBundle
        '** Added 07-26-10 JJF
        'If this is an NQL bundle then make the background yellow
        If flagNQLBundle Then
            xl.Rows(iRow).Select
            With xl.Selection.Interior
                .ColorIndex = 27
                .Pattern = xlSolid
                .PatternColorIndex = xlAutomatic
            End With
        End If
        '** End of add 07-26-10 JJF
        xl.Cells(iRow, 2) = strGroup
        xl.Cells(iRow, 3) = rs.Fields("MinLitho").Value & " - " & rs.Fields("MaxLitho").Value
        xl.Cells(iRow, 4) = rs.Fields("pieces").Value
        runningTotal = runningTotal + rs.Fields("Pieces").Value
        xl.Cells(iRow, 5) = runningTotal
        
        rs.MoveNext
        If Not rs.EOF Then strSurvey_id = rs.Fields("Survey_id").Value
    Wend
       
    xl.Columns("A:" & Chr(64 + curColumn)).Select
    xl.Selection.ColumnWidth = 30
    xl.Columns("A:" & Chr(64 + curColumn)).EntireColumn.AutoFit
    xl.Rows("7:7").EntireRow.AutoFit
    xl.Range("A1").Select
    
    If isGroupedPrint Then
        xl.Worksheets.Add
        xl.ActiveSheet.Name = "Survey Breakdown"
        With xl.ActiveSheet.PageSetup
            .LeftMargin = Application.InchesToPoints(0.5)
            .RightMargin = Application.InchesToPoints(0.5)
            .TopMargin = Application.InchesToPoints(0.5)
            .BottomMargin = Application.InchesToPoints(0.5)
            .Orientation = xlLandscape
            .FitToPagesWide = 1
            .FitToPagesTall = False
        End With
        xl.Cells(1, 1) = "GROUPED PRINT SURVEY BREAKDOWN REPORT"
        xl.Cells(3, 1) = strFileHeader
        xl.Cells(4, 1) = "Spooled on " & Format(datBundledSelect, "mm/dd/yyyy hh:nn:ss AMPM")
        xl.Cells(5, 1) = rs.Fields("strPaperConfig_nm").Value
                                
        xl.Range(xl.Cells(1, 1), xl.Cells(1, 4)).Select: xl.Selection.Merge
        xl.Range(xl.Cells(3, 1), xl.Cells(3, 4)).Select: xl.Selection.Merge
        xl.Range(xl.Cells(4, 1), xl.Cells(4, 4)).Select: xl.Selection.Merge
        xl.Range(xl.Cells(5, 1), xl.Cells(5, 4)).Select: xl.Selection.Merge
                                             
        xl.Cells(6, 1) = "Project"
        xl.Cells(6, 2) = "Litho Range"
        xl.Cells(6, 3) = "Pieces"
        xl.Cells(6, 4) = "Running" & Chr(10) & "Total"
        
        ExtraColumns = GetRegValue(HKEY_LOCAL_MACHINE, "Software\National Research\QualiSys\Queue Manager", "SurveyBreakdownExtraColumns")
        curColumn = 4
        If ExtraColumns <> "-1" And ExtraColumns <> "" Then
            If Right(ExtraColumns, 1) <> "," Then ExtraColumns = ExtraColumns + ","
            While InStr(1, ExtraColumns, ",") > 0
                aColumn = Mid(ExtraColumns, 1, InStr(1, ExtraColumns, ",") - 1)
                curColumn = curColumn + 1
                aColumn = Replace(aColumn, "||", Chr(10))
                xl.Cells(6, curColumn) = aColumn
                ExtraColumns = Mid(ExtraColumns, InStr(1, ExtraColumns, ",") + 1)
            Wend
        End If
        
'        xl.Cells(6, 5) = "Special Instructions"
'        xl.Cells(6, 6) = "Date Printed"
'        xl.Cells(6, 7) = "Date Mailed"
'        xl.Cells(6, 8) = "Outbound" & Chr(10) & "#10 Used"
'        xl.Cells(6, 9) = "BRE" & Chr(10) & "Used"
'        xl.Cells(6, 10) = "Unit" & Chr(10) & "Price"
    
        With xl.Range(xl.Cells(6, 1), xl.Cells(6, curColumn)).Borders(xlEdgeBottom)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .ColorIndex = xlAutomatic
        End With
    
        runningTotal = 0
        iRow = 6
        While Not rs.EOF
            iRow = iRow + 1
            xl.Cells(iRow, 1) = rs.Fields("strProjName").Value
            xl.Cells(iRow, 2) = rs.Fields("MinLitho").Value & " - " & rs.Fields("MaxLitho").Value
            xl.Cells(iRow, 3) = rs.Fields("Pieces").Value
            runningTotal = runningTotal + rs.Fields("Pieces").Value
            xl.Cells(iRow, 4) = runningTotal
            rs.MoveNext
        Wend
        xl.Columns("A:" & Chr(64 + curColumn)).Select
        xl.Selection.ColumnWidth = 30
        xl.Columns("A:" & Chr(64 + curColumn)).EntireColumn.AutoFit
        xl.Rows("6:6").EntireRow.AutoFit
        xl.Range("A1").Select
    End If
                
    ExcelBundleReport = strFileHeader

    If rs.State = adStateOpen Then
        rs.Close
    End If
    Set rs = Nothing
    Set oBunRepCm = Nothing
    xl.Workbooks(1).SaveAs (strFileHeader)
e1:
    xl.SheetsInNewWorkbook = SheetsInNewWorkbook
    On Error Resume Next
    xl.Sheets("Sheet1").Delete
    xl.Sheets("Bundling Report").Select
    xl.Sheets("Bundling Report").Move Before:=xl.Sheets(1)
    xl.Visible = True
    Set xl = Nothing
    On Error GoTo 0

End Function

Private Function oldPrintBundleReport(ByVal strSurvey_idSelect As String, _
                                   ByVal strConfig_idSelect As String, _
                                   ByVal datBundledSelect As Date, _
                                   ByVal strFileHeader As String) As String

    Dim tmpStr As String
    Dim strProjName As String
    Dim strSurvey_id As String
    Dim strConfig_nm As String
    Dim datBundled As Date
    Dim rs As ADODB.Recordset
    Dim strFileName As String
    Dim curBundle As String, strBundle As String, strGroup As String
    Dim UnprintedBundles As Long
    Dim UnprintedPieces As Long
    Dim LastUnprintedBundle As String
    Dim boolFlats As Boolean
    Dim oBunRepCm As ADODB.Command      '** Added 09-12-02 JJF
    Dim pieces As Long                  '** Added 12-01-2004 SH
    Dim runningTotal As Long            '** Added 12-01-2004 SH
    Dim isGroupedPrint As Boolean
        
    oldPrintBundleReport = ""
    Initialize
    
    Set oBunRepCm = New ADODB.Command
    With oBunRepCm
        .CommandText = "sp_Queue_BundleReport"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("Survey_id", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
    End With 'oBunRepCm
    
    Set rs = New ADODB.Recordset
    moConn.CommandTimeout = 0
    
    With oBunRepCm
        .Parameters("datBundled") = datBundledSelect
        .Parameters("Survey_id") = strSurvey_idSelect
        .Parameters("PaperConfig") = Val(strConfig_idSelect)
        Set rs = .Execute()
    End With
    
    strFileName = strFileHeader
    If FileExists(strFileName) Then Kill (strFileName)
    
    If Not WriteFile(strFileName, "BUNDLING REPORT") Then
        If rs.State = adStateOpen Then
            rs.Close
        End If
        Set rs = Nothing
        Exit Function
    End If
    
    If Not rs.EOF And Not rs.BOF Then
        strProjName = ""
        strConfig_nm = ""
        strSurvey_id = ""
        datBundled = Now
        UnprintedBundles = 0
        UnprintedPieces = 0
        LastUnprintedBundle = ""
        
        boolFlats = (Left(rs.Fields("strPostalBundle"), 1) >= "K")
               
            'If strProjName <> rs.Fields("strProjName").Value Or strConfig_nm <> rs.Fields("strPaperConfig_nm").Value Or datBundled <> rs.Fields("datBundled").Value Then
                runningTotal = 0
                strProjName = rs.Fields("strProjName").Value
                strConfig_nm = rs.Fields("strPaperConfig_nm").Value
                strSurvey_id = rs.Fields("Survey_id").Value
                datBundled = rs.Fields("datBundled").Value
                tmpStr = vbCrLf & vbCrLf & strProjName & vbCrLf & strConfig_nm & vbCrLf & datBundled & vbCrLf
                If boolFlats Then
                    ' ** 12-01-2004 SH - Added Running Total column
                    tmpStr = tmpStr + "        Tray        Bundle   Litho Range             Pieces   Running Total" & vbCrLf
                    tmpStr = tmpStr + "        ---------   ------   ---------------------   ------   -------------" & vbCrLf
                Else
                    ' ** 12-01-2004 SH - Added Running Total column
                    tmpStr = tmpStr + "        Bundle   Group   Litho Range             Pieces   Running Total" & vbCrLf
                    tmpStr = tmpStr + "        ------   -----   ---------------------   ------   -------------" & vbCrLf
                End If
                If Not WriteFile(strFileName, tmpStr) Then
                    If rs.State = adStateOpen Then
                        rs.Close
                    End If
                    Set rs = Nothing
                    Exit Function
                End If
                strGroup = ""
                curBundle = ""
            'End If
        
        isGroupedPrint = (strSurvey_id = "0")
        
        While (Not rs.EOF) And ((Not isGroupedPrint) Or strSurvey_id = "0")
            'until rs.eof or (isgroupedprint and survey_id <> "0")
            If IsNull(rs.Fields("strGroupDest").Value) Then
                strGroup = ""
            Else
                strGroup = rs.Fields("strGroupDest").Value
            End If
            If curBundle <> rs.Fields("strpostalbundle").Value Then
                strBundle = rs.Fields("strPostalBundle").Value
                curBundle = strBundle
            Else
                strBundle = ""
            End If
            
            If boolFlats Then
                tmpStr = "        " & Pad(strBundle, 12) & Pad(strGroup, 9) & Pad(rs.Fields("MinLitho").Value & " - " & rs.Fields("MaxLitho").Value, 24) & Pad(rs.Fields("pieces").Value, 8)
            Else
                tmpStr = "        " & Pad(strBundle, 9) & Pad(strGroup, 8) & Pad(rs.Fields("MinLitho").Value & " - " & rs.Fields("MaxLitho").Value, 24) & Pad(rs.Fields("pieces").Value, 8)
            End If
            pieces = rs.Fields("Pieces").Value
            runningTotal = runningTotal + pieces
            tmpStr = tmpStr & str(runningTotal) & vbCrLf
            
            If IsNull(rs.Fields("MinLitho").Value) Then
                UnprintedPieces = UnprintedPieces + rs.Fields("Pieces").Value
                If LastUnprintedBundle <> curBundle Then
                    UnprintedBundles = UnprintedBundles + 1
                    LastUnprintedBundle = curBundle
                End If
            Else
                If Not WriteFile(strFileName, tmpStr) Then
                    If rs.State = adStateOpen Then
                        rs.Close
                    End If
                    Set rs = Nothing
                    Exit Function
                End If
            End If
            rs.MoveNext
            If Not rs.EOF Then strSurvey_id = rs.Fields("Survey_id").Value
        Wend
        
        If isGroupedPrint Then
            tmpStr = vbCrLf & vbCrLf
            tmpStr = tmpStr + "Project                                                      Litho Range             #" & vbCrLf
            tmpStr = tmpStr + "-----------------------------------------------------------  ----------------------  ----" & vbCrLf
            If Not WriteFile(strFileName, tmpStr) Then
                If rs.State = adStateOpen Then rs.Close
                Set rs = Nothing
                Exit Function
            End If
            runningTotal = 0
            While Not rs.EOF
                tmpStr = Pad(rs.Fields("strProjName").Value, 61) & Pad(rs.Fields("MinLitho").Value & " - " & rs.Fields("MaxLitho").Value, 24) & Pad(rs.Fields("pieces").Value, 4)
                pieces = rs.Fields("Pieces").Value
                runningTotal = runningTotal + pieces
                tmpStr = tmpStr & vbCrLf
                If Not WriteFile(strFileName, tmpStr) Then
                    If rs.State = adStateOpen Then rs.Close
                    Set rs = Nothing
                    Exit Function
                End If
                rs.MoveNext
            Wend
        End If
                
        If UnprintedPieces > 0 Then
            tmpStr = vbCrLf & "There are " & UnprintedPieces & " questionnaires in " & UnprintedBundles & " bundle(s) that haven't been printed yet"
            WriteFile strFileName, tmpStr
        End If
        oldPrintBundleReport = printFilePath & strFileName
    End If

    If rs.State = adStateOpen Then
        rs.Close
    End If
    Set rs = Nothing
        
    Set oBunRepCm = Nothing     '** Added 09-12-02 JJF

End Function



Public Function GroupedPrintList(ByVal bolReprint As Boolean) As Variant
    Dim rs As New Recordset
    Dim oGroupedCm As ADODB.Command
    
    On Error GoTo ErrorCond
    
    Initialize
    
    Set oGroupedCm = New ADODB.Command
    With oGroupedCm
      .CommandText = "sp_Queue_GroupedPrintList"
      .CommandType = adCmdStoredProc
      .CommandTimeout = 0
      .ActiveConnection = moConn
      .Parameters.Append .CreateParameter("QueueType", adChar, adParamInput, 1)
    End With
    moConn.CommandTimeout = 0
    
    With oGroupedCm
        .Parameters("QueueType") = IIf(bolReprint, "M", "P")
        Set rs = .Execute
    End With
    
    If Not rs.EOF And Not rs.BOF Then
        GroupedPrintList = rs.GetRows
    End If
    rs.Close
    Set rs = Nothing
    
    Set oGroupedCm = Nothing
    
    Terminate
    Exit Function
    
ErrorCond:
    Terminate
    
End Function

Public Function TreeList(ByVal QueueType As String) As Variant
    Dim rs As New Recordset
    Dim strSQL As String
    Dim oClientCm As ADODB.Command
    
    On Error GoTo ErrorCond
    
    Initialize
    
    'Setup the command object for the stored procedure
    Set oClientCm = New ADODB.Command
    With oClientCm
        .CommandText = "sp_Queue_TreeList"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("PCLOutput", adVarChar, adParamInput, 200)
        .Parameters.Append .CreateParameter("QueueType", adChar, adParamInput, 1)
    End With 'oClientCm
        
    moConn.CommandTimeout = 0
   
    With oClientCm
        .Parameters("PCLOutput") = strPCL
        .Parameters("QueueType") = QueueType
        Set rs = .Execute()
    End With
    
    If Not rs.EOF And Not rs.BOF Then
        TreeList = rs.GetRows
    End If
    rs.Close
    Set rs = Nothing
        
    Set oClientCm = Nothing
    
    Terminate
    Exit Function
    
ErrorCond:
    Terminate

End Function

Public Function Clients(ByVal pbolReprint As Boolean) As Variant
    Dim rs As New Recordset
    Dim strSQL As String
    Dim oClientCm As ADODB.Command      '** Added 09-12-02 JJF
    
    On Error GoTo ErrorCond
    
    Initialize
    
    '** Added 09-12-02 JJF
    'Setup the command object for the stored procedure
    Set oClientCm = New ADODB.Command
    With oClientCm
        .CommandText = "sp_Queue_ClientList"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("PCLOutput", adVarChar, adParamInput, 200)
        .Parameters.Append .CreateParameter("QueueType", adChar, adParamInput, 1)
    End With 'oClientCm
    '** End of add 09-12-02 JJF
    
    moConn.CommandTimeout = 0
   
    With oClientCm
        .Parameters("PCLOutput") = strPCL
        .Parameters("QueueType") = IIf(pbolReprint, "M", "P")
        Set rs = .Execute()
    End With
    
    If Not rs.EOF And Not rs.BOF Then
        Clients = rs.GetRows
    End If
    rs.Close
    Set rs = Nothing
    '** End of modification 09-12-02 JJF
    
    Set oClientCm = Nothing     '** Added 09-12-02 JJF
    
    Terminate
    Exit Function
    
ErrorCond:
    Terminate

End Function

Public Function Configurations(ByVal pbolReprint As Boolean, ByVal lngSurveyId As Long) As Variant
    
    Dim rs As New Recordset
    Dim strSQL As String
    Dim oConfigCm As ADODB.Command
        
    On Error GoTo ErrorCond
    
    Initialize
    
    'Setup the command object for the stored procedure
    Set oConfigCm = New ADODB.Command
    With oConfigCm
        .CommandText = "sp_Queue_BundleList"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("PCLOutput", adVarChar, adParamInput, 200)
        .Parameters.Append .CreateParameter("Survey_id", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QueueType", adChar, adParamInput, 1)
    End With 'oConfigCm
    
    With oConfigCm
        .Parameters("PCLOutput") = strPCL
        .Parameters("Survey_id") = lngSurveyId
        .Parameters("QueueType") = IIf(pbolReprint, "M", "P")
        Set rs = .Execute()
    End With
    
    If Not rs.EOF And Not rs.BOF Then
        Configurations = rs.GetRows
    End If
    
    If rs.State = adStateOpen Then rs.Close
    
    Set rs = Nothing
    
    Set oConfigCm = Nothing
    
    Terminate
    
    Exit Function

ErrorCond:
    Terminate
    
End Function

Public Function PaperConfig(ByVal pbolReprint As Boolean, ByVal lngSurveyId As Long, ByVal lngPaperConfig As Long, ByVal strBundled As String) As Variant
    
    Dim rs As New ADODB.Recordset
    Dim strSQL As String
    Dim oConfigCm As ADODB.Command      '** Added 09-12-02 JJF
        
    On Error GoTo ErrorCond
    
    Initialize
    
    '** Added 09-12-02 JJF
    'Setup the command object for the stored procedure
    Set oConfigCm = New ADODB.Command
    With oConfigCm
        .CommandText = "sp_Queue_BundleListDetails"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("PCLOutput", adVarChar, adParamInput, 200)
        .Parameters.Append .CreateParameter("Survey_id", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QueueType", adChar, adParamInput, 1)
    End With 'oConfigCm
    '** End of add 09-12-02 JJF
    
    '** Modified 09-12-02 JJF
    'If pbolReprint Then
    '    strSQL = "SELECT SM.strpostalBundle, count(*) as total, MS.Survey_id, SM.PaperConfig_id, " & _
    '    " SM.intPages, SUM(1), convert(integer,SV.bitLetterHead), convert(varchar,SM.datBundled,120), convert(varchar,SM.datMailed,120) " & _
    '    " FROM ScheduledMailing SC, MailingStep MS, SentMailing SM, Sel_Cover SV, QualPro_Params QPP " & _
    '    " WHERE SM.SentMail_id in (select sentmail_id from " & strPCL & ") " & _
    '    " AND SV.Survey_id = " & lngSurveyId & _
    '    " AND SM.PaperConfig_id = " & lngPaperConfig & _
    '    " AND abs(datediff(second,SM.datBundled,'" & strBundled & "'))<=1 " & _
    '    " AND SM.SentMail_id = SC.SentMail_id   " & _
    '    " AND MS.MailingStep_id = SC.MailingStep_id " & _
    '    " AND SV.Survey_id = MS.Survey_id " & _
    '    " AND SV.SelCover_id = MS.SelCover_id " & _
    '    " AND SM.datPrinted IS NOT NULL " & _
    '    " AND QPP.strParam_nm = 'MailedDaysInQ' " & _
    '    " AND (SM.datMailed IS NULL OR datediff(day,SM.datMailed,getdate())<=QPP.numParam_value) " & _
    '    " GROUP BY MS.Survey_id, SM.PaperConfig_id, SM.strPostalBundle, SM.intPages, convert(integer,SV.bitLetterHead), SM.datBundled, SM.datMailed"
    'Else
    '    strSQL = "SELECT SM.strpostalBundle, count(*) as total, MS.Survey_id, SM.PaperConfig_id, " & _
    '    " SM.intPages, SUM(1), convert(integer,SV.bitLetterHead), convert(varchar,SM.datBundled,120), null " & _
    '    " FROM ScheduledMailing SC, MailingStep MS, SentMailing SM, Sel_Cover SV " & _
    '    " WHERE SM.SentMail_id in (select sentmail_id from " & strPCL & ") " & _
    '    " AND SV.Survey_id = " & lngSurveyId & _
    '    " AND SM.PaperConfig_id = " & lngPaperConfig & _
    '    " AND abs(datediff(second,SM.datBundled,'" & strBundled & "'))<=1 " & _
    '    " AND SM.SentMail_id = SC.SentMail_id   " & _
    '    " AND MS.MailingStep_id = SC.MailingStep_id " & _
    '    " AND SV.Survey_id = MS.Survey_id " & _
    '    " AND SV.SelCover_id = MS.SelCover_id " & _
    '    " AND SM.datPrinted IS NULL " & _
    '    " GROUP BY MS.Survey_id, SM.PaperConfig_id, SM.strPostalBundle, SM.intPages, convert(integer,SV.bitLetterHead), SM.datBundled"
    'End If
    'moConn.CommandTimeout = 0
    'rs.Open strSQL, moConn, adOpenForwardOnly
    
    moConn.CommandTimeout = 0
    With oConfigCm
        .Parameters("PCLOutput") = strPCL
        .Parameters("Survey_id") = lngSurveyId
        .Parameters("datBundled") = CDate(strBundled)
        .Parameters("PaperConfig") = lngPaperConfig
        .Parameters("QueueType") = IIf(pbolReprint, "M", "P")
        Set rs = .Execute()
    End With
    '** End of modification 09-12-02 JJF
    
    If Not rs.EOF And Not rs.BOF Then
        PaperConfig = rs.GetRows
    End If
    
    If rs.State = adStateOpen Then rs.Close
    Set rs = Nothing
    
    Set oConfigCm = Nothing     '** Added 09-12-02 JJF
    
    Terminate
    Exit Function
        
ErrorCond:
    Terminate
    
End Function

Public Function LithoRange(ByVal strBundleId As String, _
                           ByVal lngSurveyId As Long, _
                           ByVal lngPaperConfig As Long, _
                           ByVal strBundled As String) As Variant
    
    Dim strSQL As String
    Dim rs As New ADODB.Recordset
    Dim oLithoCm As ADODB.Command      '** Added 09-12-02 JJF
    
    On Error GoTo ErrorCond
    
    Initialize
    moConn.CommandTimeout = 0
    
    '** Added 09-12-02 JJF
    'Setup the command object for the stored procedure
    Set oLithoCm = New ADODB.Command
    With oLithoCm
        .CommandText = "sp_Queue_LithoRange"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("Survey_id", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("strPostalBundle", adVarChar, adParamInput, 20)
    End With 'oLithoCm
    '** End of add 09-12-02 JJF
    
    '** Modified 09-12-02 JJF
    'strSQL = " SELECT max(convert(integer,strLithoCode)), min(convert(integer,strLithoCode)) " & _
    '" FROM SentMailing SM, MailingMethodology MM, QualPro_Params QPP " & _
    '" WHERE Sm.Methodology_id = MM.Methodology_id " & _
    '" AND MM.Survey_id = " & lngSurveyId & _
    '" AND SM.PaperConfig_id = " & lngPaperConfig & _
    '" AND abs(datediff(second,SM.datBundled,'" & strBundled & "'))<=1 " & _
    '" AND QPP.strParam_nm = 'MailedDaysInQ' " & _
    '" AND (SM.datMailed IS NULL OR datediff(day,SM.datMailed,getdate())<=QPP.numParam_value) " & _
    '" AND SM.strPostalBundle = '" & strBundleId & "'"
    '
    'rs.Open strSQL, moConn, adOpenForwardOnly
    
    With oLithoCm
        .Parameters("datBundled") = CDate(strBundled)
        .Parameters("Survey_id") = lngSurveyId
        .Parameters("PaperConfig") = lngPaperConfig
        .Parameters("strPostalBundle") = strBundleId
        Set rs = .Execute()
    End With
    '** End of modification 09-12-02 JJF
    
    If Not rs.EOF And Not rs.BOF Then
        LithoRange = rs.GetRows()
    End If
    If rs.State = adStateOpen Then rs.Close
    Set rs = Nothing
    
    Set oLithoCm = Nothing     '** Added 09-12-02 JJF
    
    Terminate
    Exit Function
        
ErrorCond:
    If rs.State = adStateOpen Then rs.Close
    Set rs = Nothing
    Terminate
    
End Function

Private Function RunBundling() As String
    
    Dim BundleStatus As Integer
    Dim pcmADO      As ADODB.Command
    Dim pParmADO    As ADODB.Parameter
    
    Set pcmADO = CreateObject("ADODB.Command")
    Set pParmADO = CreateObject("ADODB.Parameter")
        
    On Error GoTo ErrorHandler
    ' ---------------------------------------------
    ' Set the Command Object to execute the
    ' Desired stored procedure
    ' ---------------------------------------------
    With pcmADO
        .CommandText = "sp_Queue_Bundle"
        .CommandType = adCmdStoredProc
    End With
    
    ' ---------------------------------------------
    ' Create and Append each Parameter to the
    ' Command Object
    ' ---------------------------------------------
    Set pParmADO = pcmADO.CreateParameter("Status", adInteger, adParamOutput, 4)
    pcmADO.Parameters.Append pParmADO
    Set pParmADO = pcmADO.CreateParameter("strPclOutput", adVarChar, adParamInput, 30, strPCL)
    pcmADO.Parameters.Append pParmADO
    
    ' ---------------------------------------------
    ' Set the Command object to use the
    ' already established Connection and Execute
    ' Stored Procedure
    ' ---------------------------------------------
    pcmADO.ActiveConnection = moConn
    pcmADO.CommandTimeout = 0
    pcmADO.Execute
    
    ' ---------------------------------------------
    ' Retrieve the output Parameter by Item number
    ' (with Item(0) being the first parm appended
    ' ---------------------------------------------
    BundleStatus = pcmADO.Parameters.Item(0).Value
        
    ' ---------------------------------------------
    ' Clear the Parameter and Command objects
    ' ---------------------------------------------
    Set pParmADO = Nothing
    Set pcmADO = Nothing
    
    If BundleStatus = 1 Then
        RunBundling = "Cannot bundle at this time.  Another user is currently bundling."
    ElseIf BundleStatus = 2 Then
        RunBundling = "Cannot bundle at this time.  Another user is currently printing."
    ElseIf BundleStatus = 3 Then
        RunBundling = "Cannot bundle at this time.  PCLGen is currently running."
    Else
        RunBundling = ""
    End If
    
    Exit Function
    
ErrorHandler:
    If InStr(1, Err.Description, "Duplicate key was ignored", vbTextCompare) Then
        Resume Next
    Else
        Err.Raise Err.Number, Err.Source, Err.Description
    End If
    
End Function

Public Function BundleUp() As String

    On Error GoTo BundleUpError
    
    Call Initialize
    BundleUp = RunBundling
    moConn.Close
    Set moConn = Nothing
    Call Terminate
    
    Exit Function

BundleUpError:

End Function

Private Function GetBundle(ByVal Survey_id As Long, _
                           strPostalBundle_id As String, _
                           ByVal lngPaperconfig_id As Long, _
                           ByVal intPage_num As Long) As Variant
    
    Dim strSQL As String
    Dim rs As New ADODB.Recordset

Retry:
    ' This will grab the information we need to print
    ' a bundle of lithocodes into one file.
    'strSQL = "SELECT Q.strPostalBundle, Z.strSizeCode, P.intSheet_num, Q.SentMail_id, P.PCLStream " & _
    '" INTO #QueueTemp " & _
    '" FROM " & strQueue & "SentMailing SM, pcloutput PO, " & _
    'strQueue & "PaperSize PS, " & strQueue & "MailingMethodology MM " & _
    '" WHERE SM.Methodology_id = MM.Methodology_id " & _
   ' " AND MM.Survey_id = " & Survey_id & _
   ' " AND PO.SentMail_id = SM.SentMail_id " & _
   ' " AND PO.PaperSize_id = PS.PaperSize_id " & _
   ' " AND SM.PaperConfig_id = " & lngPaperConfig_id & _
   ' " AND P.Sheet_num = " & intPage_num & _
   ' " AND SM.strPostalBundle = " & strPostalBundle_id & _
   ' " AND SM.datPrinted IS NULL "
    
    ' This next bit of code will try and create the temp
    ' table.  If the table is already there than an error
    ' will occur and we will drop the table and retry to
    ' create the database.
   ' On Error GoTo ZapTable
   ' moConn2.Execute strSQL
   ' On Error GoTo 0
   ' GoTo Continue
'ZapTable:
 '   On Error GoTo 0
 '   moConn2.Execute "DROP TABLE #QueueTemp"
 '   GoTo Retry
'Continue:
    ' Looks like the table is here.  Now lets get the
    ' records and get out.
 '   strSQL = "SELECT * FROM #QueueTemp"
 '   Set rs = moConn2.Execute(strSQL)
 
 strSQL = "SELECT Q.strPostalBundle, Z.strSizeCode, P.intSheet_num, Q.SentMail_id, P.PCLStream " & _
          "FROM " & strQueue & "NPSentMailing SM, pcloutput PO, " & _
          strQueue & "PaperSize PS, " & strQueue & "MailingMethodology MM " & _
          "WHERE SM.Methodology_id = MM.Methodology_id " & _
          "      AND MM.Survey_id = " & Survey_id & _
          "      AND PO.SentMail_id = SM.SentMail_id " & _
          "      AND PO.PaperSize_id = PS.PaperSize_id " & _
          "      AND SM.PaperConfig_id = " & lngPaperconfig_id & _
          "      AND P.Sheet_num = " & intPage_num & _
          "      AND SM.strPostalBundle = " & strPostalBundle_id & _
          "      AND SM.datPrinted = '1/1/4000' "
    
    rs.Open strSQL, moConn2, adOpenForwardOnly
 
    If Not rs.EOF And Not rs.BOF Then
        GetBundle = rs.GetRows
    End If
    
    If rs.State = adStateOpen Then rs.Close
    
    Set rs = Nothing

End Function

Private Function FileExists(strFileName As String) As Boolean
    If InStr(1, strFileName, "\") = 0 Then strFileName = printFilePath & strFileName
    If Len(Dir(strFileName)) > 0 Then
        FileExists = True
    Else
        FileExists = False
    End If

End Function

Private Function WriteFile(strFileName As String, _
                           ByVal strPCLCode As String) As Boolean
    
    'Dim rs As New ADODB.Recordset
    
    On Error GoTo BadFile
    
    'I DV 9/9/1999 - Set this function to false at the beginning, then
    'I DV 9/9/1999 - to true when it is complete.
    WriteFile = False
    Open printFilePath & strFileName For Append Access Write As #1
    Print #1, strPCLCode;
    Close #1
    WriteFile = True
    
    Exit Function
    
BadFile:
    Close #1
'D    WriteFile = False
    Terminate

End Function

Private Function WriteBinary(strFileName As String, _
                             bitByteArray() As Byte) As Boolean
    
    'Dim rsFile As New ADODB.Recordset
    
    On Error GoTo BadFile
    
    'I DV 9/9/1999 - Changed to initialize WriteBinary to false, then set
    'I DV 9/9/1999 - to true once the function successfully completes, don't
    'I DV 9/9/1999 - need the 2nd set to FALSE.
    WriteBinary = False
    Open printFilePath & strFileName For Binary Access Write As #1
    Put #1, LOF(1) + 1, bitByteArray()
    Close #1
    WriteBinary = True
    
    Exit Function

BadFile:
    Close #1
'D    WriteBinary = False
    Terminate

End Function

Private Function WritePCLObject(strFileName As String, _
                                strInit_Reset As String) As Boolean
    
    Dim rs As New ADODB.Recordset
    Dim lngTotalSize As Long
    
    'I DV 9/9/1999 - Changed function to return a boolean.  Only set to
    'I DV 9/9/1999 - TRUE once it gets to the very end.
    
    On Error GoTo BadFile
    
    WritePCLObject = False
    
    rs.Open "SELECT PCLSTREAM FROM PCLOBJECT WHERE PCLObject_dsc = '" & strInit_Reset & "'", moConn, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        lngTotalSize = rs.Fields("PCLStream").ActualSize
        If Not WriteBinary(strFileName, rs.Fields("PCLStream").GetChunk(lngTotalSize)) Then
            If rs.State = adStateOpen Then
                rs.Close
                Set rs = Nothing
            End If
            Exit Function
        End If
    End If
    If rs.State = adStateOpen Then rs.Close
    Set rs = Nothing
    WritePCLObject = True
    
    Exit Function

BadFile:
    'D    WritePCLObject = False
    If rs.State = adStateOpen Then rs.Close
    Set rs = Nothing
    Terminate

End Function

Public Function SetLithoCodes(ByVal pbolReprint As Boolean, _
                              ByVal Survey_id As Long, _
                              ByVal strPostalBundle_id As String, _
                              ByVal lngPaperconfig_id As Long, _
                              ByVal intPage_num As Long, _
                              ByVal strBundled As String) As Variant
    
    Dim strSQL As String
    
    Initialize
    moConn.CommandTimeout = 0

    'I DV 9/16/1999 - We want to prevent the duplicate lithos from occuring
    'I DV 9/16/1999 - because of concurrency issues.

    On Error GoTo BadLitho
    
    strSQL = "exec dbo.sp_queue_setlitho " & _
             "@survey_id = " & Survey_id & ", " & _
             "@strpostalbundle_id = '" & strPostalBundle_id & "', " & _
             "@paperconfig_id = " & lngPaperconfig_id & ", " & _
             "@reprint = " & CLng(pbolReprint) & ", " & _
             "@datBundled = '" & strBundled & "'"
    moConn.Execute strSQL

    If moConn.State = adStateOpen Then
        moConn.Close
    End If
    
    Set moConn = Nothing
    
    Terminate
    
    Exit Function

BadLitho:
    Terminate

End Function

Public Function AddToGroupedPrint(ByVal Survey_id As Long, _
                                  ByVal lngPaperconfig_id As Long, _
                                  ByVal strBundled As String) As Boolean
    
    Dim datBundled As Date
    datBundled = strBundled
    
    Dim oCommand As ADODB.Command
    Initialize
    
    Set oCommand = New ADODB.Command
    With oCommand
        .CommandText = "sp_Queue_AddToGroupedPrint"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("Survey_id", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("PaperConfig_id", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
    
        'Set the values
        .Parameters("Survey_id") = Survey_id
        .Parameters("PaperConfig_id") = lngPaperconfig_id
        .Parameters("datBundled") = datBundled
        
        .Execute
    End With 'oCommand
    

End Function

Public Function RemoveFromGroupedPrint(ByVal Survey_id As Long, _
                                       ByVal lngPaperconfig_id As Long, _
                                       ByVal strBundled As String) As Boolean
    
    Dim datBundled As Date
    datBundled = strBundled
    
    Dim oCommand As ADODB.Command
    Initialize
    
    Set oCommand = New ADODB.Command
    With oCommand
        .CommandText = "sp_Queue_RemoveFromGroupedPrint"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("Survey_id", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("PaperConfig_id", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
    
        'Set the values
        .Parameters("Survey_id") = Survey_id
        .Parameters("PaperConfig_id") = lngPaperconfig_id
        .Parameters("datBundled") = datBundled
        
        .Execute
    End With 'oCommand
    

End Function

Public Sub GroupedPrintRebundleAndSetLithos(ByVal lngPaperconfig_id As Long, ByVal PrintDate As Date)
    
    Initialize
    Dim strTemp As String
    
    strTemp = "exec dbo.sp_Queue_GroupedPrintRebundleAndSetLithos " & _
              "@paperconfig_id=" + str(lngPaperconfig_id) & ", " & _
              "@printdate='" + Format(PrintDate, "yyyy-mm-dd hh:nn:ss AMPM") & "'"
    moConn.Execute strTemp
                    
'    Dim oCommand As ADODB.Command
'    Initialize
'    Set oCommand = New ADODB.Command
'    With oCommand
'        .CommandText = "sp_Queue_GroupedPrintRebundleAndSetLithos"
'        .CommandType = adCmdStoredProc
'        .CommandTimeout = 0
'        .ActiveConnection = moConn
'        .Parameters.Append .CreateParameter("PaperConfig_id", adInteger, adParamInput)
'        .Parameters.Append .CreateParameter("printdate", adDate, adParamInput)
'
'        'Set the values
'        .Parameters("PaperConfig_id") = lngPaperconfig_id
'        .Parameters("printdate") = PrintDate
'        .Execute
'    End With 'oCommand

End Sub

Public Function GetGroupedPrint(ByVal lngPaperconfig_id As Long, bolReprint As Boolean, Optional ByVal datPrinted As Date = #1/1/1980#) As Boolean
    Dim strSQL As String
    Dim strFileHeader As String
    Dim strFromWhere As String
    Dim minLithoCode As Long
    Dim numSplits As Long
    Dim numSheets As Long
    Dim numSheetsPerSplit As Long
    Dim numSplitThreshold As Long
    Dim rs As New ADODB.Recordset
    Dim oCommand As ADODB.Command

    If datPrinted = #1/1/1980# Then bolReprint = False
    
    Initialize
    
    strSQL = "SELECT MM.Survey_id, Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, " & _
             "P.intPD, S.strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
    
    strFromWhere = " FROM pcloutput P, " & strQueue & "PaperSize Z, " & strQueue & "NPSentMailing S, " & _
                   strQueue & "MailingMethodology MM, " & strQueue & "GroupedPrint GP " & _
                   " WHERE MM.survey_id = GP.Survey_id " & _
                   "       AND MM.Methodology_id = S.Methodology_id " & _
                   "       AND S.PaperConfig_id = GP.PaperConfig_id " & _
                   "       AND S.PaperConfig_id = " & lngPaperconfig_id & _
                   "       AND P.SentMail_id = S.SentMail_id " & _
                   "       AND abs(datediff(second,gp.datBundled,'" & Format(datPrinted, "mm/dd/yyyy hh:mm:ss AMPM") & "'))<=1 " & _
                   "       AND GP.datBundled= s.datBundled  " & _
                   "       AND P.PaperSize_id = Z.PaperSize_id "
                   
    If bolReprint Then
        strFromWhere = strFromWhere & " AND S.datPrinted<'4000' AND abs(datediff(second,S.datPrinted,'" & Format(datPrinted, "mm/dd/yyyy hh:mm:ss AMPM") & "'))<=1 "
    Else
        strFromWhere = strFromWhere & " AND S.datPrinted = '1/1/4000' "
    End If

    Set rs = New ADODB.Recordset
    rs.Open "SELECT Z.strSizeCode, P.intSheet_num, count(*) as cnt, min(strLithoCode) as minLithoCode " & _
        strFromWhere & _
        "GROUP BY Z.strSizeCode, P.intSheet_num " & _
        "ORDER BY count(*) DESC", moConn2, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        numSheets = rs!cnt
        minLithoCode = rs!minLithoCode
    Else
        Err.Raise vbError + 10001, "QueManagerDB:clsQueueManager:GetGroupedPrint", "error accessing print streams"
    End If
                
    rs.Close
    rs.Open "select numParam_value from qualpro_params where strParam_grp='QueueManager' and strParam_nm='SplitThreshold'", moConn, adOpenForwardOnly
    If rs.EOF And rs.BOF Then
        numSplitThreshold = 5000
    Else
        numSplitThreshold = rs!numParam_value
    End If
    rs.Close
        
    If bolReprint Then
        strFileHeader = "GP_" & Format(datPrinted, "yyyymmdd_hhmm") & "_" & lngPaperconfig_id
    Else
        strFileHeader = "GP_" & Format(Now, "yyyymmdd_hhmm") & "_" & lngPaperconfig_id
    End If
    
    If numSheets > numSplitThreshold Then
        numSplits = 1 + Int(numSheets / numSplitThreshold)
        numSheetsPerSplit = 1 + (numSheets / numSplits)
        strSQL = Replace(strSQL, "P.PCLStream", "(s.strLithoCode-" & minLithoCode & ") / " & numSheetsPerSplit & " as intSplit, P.PCLStream")
        strSQL = strSQL & _
                strFromWhere & " order by strLithoCode, intSheet_Num "
        GetGroupedPrint = PrintBundle(strSQL, strFileHeader, Array("strSizeCode", "intSheet_num", "intSplit"))
    Else
        strSQL = strSQL & strFromWhere & " ORDER BY strLithoCode, intSheet_Num "
        GetGroupedPrint = PrintBundle(strSQL, strFileHeader, Array("strSizeCode", "intSheet_num"))
    End If

    If (Not bolReprint) And GetGroupedPrint = True Then
        Set oCommand = New ADODB.Command
        With oCommand
            .CommandText = "sp_Queue_SetPrintDate"
            .CommandType = adCmdStoredProc
            .CommandTimeout = 0
            .ActiveConnection = moConn
            .Parameters.Append .CreateParameter("Survey_id", adInteger, adParamInput)
            .Parameters.Append .CreateParameter("strPostalBundle", adVarChar, adParamInput, 20)
            .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
            .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
            .Parameters.Append .CreateParameter("datPrinted", adDBTimeStamp, adParamInput)
        
            'Set the values
            .Parameters("Survey_id") = 0
            .Parameters("strPostalBundle") = ""
            .Parameters("PaperConfig") = lngPaperconfig_id
            .Parameters("datBundled") = #1/1/1980#
            .Parameters("datPrinted") = datPrinted
            .Execute
        End With 'oCommand
    End If
    
    Terminate
End Function

Public Function GetPrintBundle(ByVal Survey_id As Long, _
                               ByVal strPostalBundle_id As String, _
                               ByVal lngPaperconfig_id As Long, _
                               ByVal intPage_num As Long, _
                               ByVal strBundled As String) As Boolean
    
    Dim strSQL As String
    Dim strFileHeader As String
    Dim datBundled As Date
    Dim strFromWhere As String
    Dim numSplits As Long
    Dim numSheetsPerSplit As Long
    Dim numSheets As Long
    Dim minLithoCode As Long
    Dim numSplitThreshold As Long
    Dim rs As New ADODB.Recordset
    Dim oCommand As ADODB.Command

    datBundled = strBundled
    
    Initialize
    
    '***Modified 04-24-2003 SH
    'strSQL = "SELECT Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, " & _
             "P.intPD, S.strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
      
    ' Added MM.Survey_id
    strSQL = "SELECT MM.Survey_id, Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, " & _
             "P.intPD, S.strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
    '***End of modification 04-24-2003 SH
    
    strFromWhere = " FROM pcloutput P, " & strQueue & "PaperSize Z, " & _
                   strQueue & "NPSentMailing S, " & strQueue & "MailingMethodology MM " & _
                   " WHERE MM.survey_id = " & Survey_id & _
                   "       AND S.strPostalBundle = '" & strPostalBundle_id & "'" & _
                   "       AND MM.Methodology_id = S.Methodology_id " & _
                   "       AND S.PaperConfig_id = " & lngPaperconfig_id & _
                   "       AND s.datBundled<'1/1/4000' " & _
                   "       AND abs(datediff(second,S.datBundled,'" & strBundled & "'))<=1 " & _
                   "       AND P.SentMail_id = S.SentMail_id " & _
                   "       AND P.PaperSize_id = Z.PaperSize_id " & _
                   "       AND S.datPrinted = '1/1/4000' "
                   
                
    Set rs = New ADODB.Recordset
    rs.Open "SELECT Z.strSizeCode, P.intSheet_num, count(*) as cnt, min(strLithoCode) as minLithoCode " & _
        strFromWhere & _
        "GROUP BY Z.strSizeCode, P.intSheet_num " & _
        "ORDER BY count(*) DESC", moConn2, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        numSheets = rs!cnt
        minLithoCode = rs!minLithoCode
    Else
        Err.Raise vbError + 10001, "QueManagerDB:clsQueueManager:GetPrintBundle", "error accessing print streams"
    End If
    
    rs.Close
    rs.Open "select numParam_value from qualpro_params where strParam_grp='QueueManager' and strParam_nm='SplitThreshold'", moConn, adOpenForwardOnly
    If rs.EOF And rs.BOF Then
        numSplitThreshold = 5000
    Else
        numSplitThreshold = rs!numParam_value
    End If
    rs.Close
            
    If numSheets > numSplitThreshold Then
        numSplits = 1 + Int(numSheets / numSplitThreshold)
        numSheetsPerSplit = 1 + (numSheets / numSplits)
        
        strSQL = Replace(strSQL, "P.PCLStream", "(s.strLithoCode-" & minLithoCode & ") / " & numSheetsPerSplit & " as intSplit, P.PCLStream") & strFromWhere & " ORDER BY strLithoCode, intSheet_Num "
        
        strFileHeader = Survey_id & "_" & strPostalBundle_id & "_" & Format(datBundled, "yyyymmdd_hhmm") & _
                    "_" & lngPaperconfig_id
        GetPrintBundle = PrintBundle(strSQL, strFileHeader, Array("strSizeCode", "intSheet_num", "intSplit"))
        
    Else
        strSQL = strSQL & strFromWhere & " ORDER BY strLithoCode, intSheet_Num "
        strFileHeader = Survey_id & "_" & strPostalBundle_id & "_" & Format(datBundled, "yyyymmdd_hhmm") & _
                    "_" & lngPaperconfig_id
        GetPrintBundle = PrintBundle(strSQL, strFileHeader, Array("strSizeCode", "intSheet_num"))
    End If

    If GetPrintBundle = True Then
        Set oCommand = New ADODB.Command
        With oCommand
            .CommandText = "sp_Queue_SetPrintDate"
            .CommandType = adCmdStoredProc
            .CommandTimeout = 0
            .ActiveConnection = moConn
            .Parameters.Append .CreateParameter("Survey_id", adInteger, adParamInput)
            .Parameters.Append .CreateParameter("strPostalBundle", adVarChar, adParamInput, 20)
            .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
            .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
        
            'Set the values
            .Parameters("Survey_id") = Survey_id
            .Parameters("strPostalBundle") = strPostalBundle_id
            .Parameters("PaperConfig") = lngPaperconfig_id
            .Parameters("datBundled") = strBundled
            .Execute
        End With 'oCommand
       
    End If
    
    Terminate
    
End Function



Public Function SetRePrintIndiv(ByVal QList As String) As Boolean

    Dim strSQL As String
    Dim str As String

    On Error GoTo ErrorCond
    
    Initialize
    
    strSQL = "UPDATE SentMailing " & _
             "SET datReprinted = '4172-12-31' " & _
             "FROM " & strPCL & " p " & _
             "WHERE SentMailing.SentMail_id=p.SentMail_id " & _
             "      AND SentMailing.datPrinted is not null and ("
             
    QList = QList + Chr(13) + Chr(10)
    
    While InStr(QList, Chr(13) + Chr(10)) > 0
        str = Trim(Left(QList, InStr(QList, Chr(13) + Chr(10)) - 1))
        If str <> "" Then
            If InStr(str, "-") = 0 Then
                strSQL = strSQL + "strLithoCode='" & str & "' or "
            Else
                strSQL = strSQL + "(strLithoCode BETWEEN '" & _
                  Trim(Left(str, InStr(str, "-") - 1)) & "' AND '" & _
                  Trim(Mid(str, InStr(str, "-") + 1)) & "') or "
            End If
        End If
        QList = Mid(QList, InStr(QList, Chr(13) + Chr(10)) + 2)
    Wend
    
    strSQL = strSQL + "(1=2))"
    moConn.Execute strSQL
    SetRePrintIndiv = True
    Terminate
    
    Exit Function
    
ErrorCond:
    SetRePrintIndiv = False
    Terminate
    
End Function

Public Function GetRePrintIndiv2(ByVal QList As String) As Boolean
    
    Dim strSQL As String
    Dim strFromWhere As String
    Dim str As String
    
    Initialize
    
    On Error GoTo ErrorCond
    
    strSQL = "SELECT MM.Survey_id, CASE PC.intLetterhead WHEN 0 THEN 0 ELSE MM.Survey_id END as LetterheadSurvey_id," & _
            "Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, P.intPD, S.strLithoCode," & _
            "s.strPostalBundle , s.strGroupDest, P.PCLStream " & _
            "FROM pcloutput P, QP_PROD.dbo.PaperSize Z,QP_PROD.dbo.SentMailing S, " & _
            "QP_PROD.dbo.PaperConfig PC, QP_PROD.dbo.MailingMethodology MM " & _
            "Where P.sentmail_id = s.sentmail_id And Z.PaperSize_id = P.PaperSize_id " & _
            "AND S.datPrinted IS NOT NULL        AND PC.PaperConfig_id = S.PaperConfig_id " & _
            "AND S.Methodology_id = MM.Methodology_id " & _
            "AND P.SentMail_id in( " & _
            "select distinct sentmail_id  from QP_PROD.dbo.questionform where survey_id in( " & _
            "1483,1485,1486,1492,1493,1494,2151)) " & _
            "ORDER BY strLithoCode, intSheet_num"
    
    Terminate
    
    Exit Function
    
    GetRePrintIndiv2 = PrintBundle(strSQL, "Reprint", Array("LetterHeadSurvey_id", "strSizeCode"))
    
    If GetRePrintIndiv2 Then
       strFromWhere = " FROM " & strPCL & " P, PaperSize Z, " & _
                      "SentMailing S, PaperConfig PC, MailingMethodology MM " & _
                      " WHERE P.SentMail_id = S.SentMail_id " & _
                      "       AND Z.PaperSize_id = P.PaperSize_id " & _
                      "       AND S.datPrinted IS NOT NULL " & _
                      "       AND PC.PaperConfig_id = S.PaperConfig_id " & _
                      "       AND S.Methodology_id = MM.Methodology_id " & _
                      "       AND S.datReprinted = '4172-12-31' "
    
        SetPrintDate "UPDATE Sentmailing SET datReprinted=getdate(), intReprinted=intReprinted+1 " & strFromWhere
    End If
    
    Terminate
    
    Exit Function
    
ErrorCond:
    GetRePrintIndiv2 = False
    Terminate

End Function



Public Function GetRePrintIndiv(ByVal QList As String) As Boolean
    
    Dim strSQL As String
    Dim strFromWhere As String
    Dim str As String
    
    Initialize
    
    On Error GoTo ErrorCond
    
    If Not SetRePrintIndiv(QList) Then _
        GoTo ErrorCond
    
    '***Modified 04-24-2003 SH
    'strSQL = "SELECT CASE PC.intLetterhead WHEN 0 THEN 0 ELSE MM.Survey_id END as LetterheadSurvey_id, " & _
             " Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, P.intPD, " & _
             "S.strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
             
    ' Added MM.Survey_id to strSQL.
    strSQL = "SELECT MM.Survey_id, CASE PC.intLetterhead WHEN 0 THEN 0 ELSE MM.Survey_id END as LetterheadSurvey_id, " & _
             "Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, P.intPD, " & _
             "S.strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
    '***End of modification 04-24-2003 SH
    
    strFromWhere = " FROM pcloutput P, " & strQueue & "PaperSize Z, " & strQueue & _
                   "SentMailing S, " & strQueue & "PaperConfig PC, " & strQueue & "MailingMethodology MM " & _
                   " WHERE P.SentMail_id = S.SentMail_id " & _
                   "       AND Z.PaperSize_id = P.PaperSize_id " & _
                   "       AND S.datPrinted IS NOT NULL " & _
                   "       AND PC.PaperConfig_id = S.PaperConfig_id " & _
                   "       AND S.Methodology_id = MM.Methodology_id " & _
                   "       AND S.datReprinted = '4172-12-31' "
                   
    strSQL = strSQL & strFromWhere & " ORDER BY strLithoCode, intSheet_num"
    

    GetRePrintIndiv = PrintBundle(strSQL, "Reprint", Array("LetterHeadSurvey_id", "strSizeCode"))
    
    If GetRePrintIndiv Then
       strFromWhere = " FROM " & strPCL & " P, PaperSize Z, " & _
                      "SentMailing S, PaperConfig PC, MailingMethodology MM " & _
                      " WHERE P.SentMail_id = S.SentMail_id " & _
                      "       AND Z.PaperSize_id = P.PaperSize_id " & _
                      "       AND S.datPrinted IS NOT NULL " & _
                      "       AND PC.PaperConfig_id = S.PaperConfig_id " & _
                      "       AND S.Methodology_id = MM.Methodology_id " & _
                      "       AND S.datReprinted = '4172-12-31' "
    
        SetPrintDate "UPDATE Sentmailing SET datReprinted=getdate(), intReprinted=intReprinted+1 " & strFromWhere
    End If
    
    Terminate
    
    Exit Function
    
ErrorCond:
    GetRePrintIndiv = False
    Terminate

End Function

Public Function BundleFlats(ByVal Survey_id As Long, _
                            ByVal lngPaperconfig_id As Long, _
                            ByVal datBundled As Date, _
                            ByVal lngN As Long) As Boolean
    
 '   On Error GoTo BundleUpError
    Call Initialize
    BundleFlats = RunFlats(Survey_id, lngPaperconfig_id, datBundled, lngN)
    moConn.Close
    Set moConn = Nothing
    Call Terminate
    Exit Function

'BundleUpError:

End Function

Public Function RunFlats(ByVal Survey_id As Long, _
                         ByVal lngPaperconfig_id As Long, _
                         ByVal datBundled As String, _
                         ByVal lngN As Long) As Boolean
    
    Dim BundleStatus As Integer
    Dim pcmADO      As New ADODB.Command
    Dim pParmADO    As New ADODB.Parameter
    
    ' ---------------------------------------------
    ' Set the Command Object to execute the
    ' Desired stored procedure
    ' ---------------------------------------------
    With pcmADO
        .CommandText = "sp_Queue_BundleFlats"
        .CommandType = adCmdStoredProc
    End With
    
    ' ---------------------------------------------
    ' Create and Append each Parameter to the
    ' Command Object
    ' ---------------------------------------------
    Set pParmADO = pcmADO.CreateParameter("Survey_id", adInteger, adParamInput, 4, Survey_id)
    pcmADO.Parameters.Append pParmADO
    Set pParmADO = pcmADO.CreateParameter("PaperConfig_id", adInteger, adParamInput, 4, lngPaperconfig_id)
    pcmADO.Parameters.Append pParmADO
    Set pParmADO = pcmADO.CreateParameter("datBundled", adChar, adParamInput, Len(datBundled), datBundled)
    pcmADO.Parameters.Append pParmADO
    Set pParmADO = pcmADO.CreateParameter("intTrayCapacity", adInteger, adParamInput, 4, lngN)
    pcmADO.Parameters.Append pParmADO
    Set pParmADO = pcmADO.CreateParameter("intBundleStatus", adInteger, adParamOutput, 4)
    pcmADO.Parameters.Append pParmADO
    Set pParmADO = pcmADO.CreateParameter("strPclOutput", adVarChar, adParamInput, 30, strPCL)
    'Set pParmADO = pcmADO.CreateParameter("strPclOutput", , , , strPCL)
    pcmADO.Parameters.Append pParmADO
    
    ' ---------------------------------------------
    ' Set the Command object to use the
    ' already established Connection and Execute
    ' Stored Procedure
    ' ---------------------------------------------
    pcmADO.ActiveConnection = moConn
    pcmADO.CommandTimeout = 0
    pcmADO.Execute
    
    ' ---------------------------------------------
    ' Retrieve the output Parameter by Item number
    ' (with Item(0) being the first parm appended
    ' ---------------------------------------------
    BundleStatus = pcmADO.Parameters.Item(4).Value
        
    ' ---------------------------------------------
    ' Clear the Parameter and Command objects
    ' ---------------------------------------------
    Set pParmADO = Nothing
    Set pcmADO = Nothing
    
    RunFlats = (BundleStatus = 0)
    
    Exit Function
    
End Function

Private Sub ErrorTolerantFileCopy(ByVal FromFile As String, ByVal ToFile As String)
    On Error GoTo ErrHandler
    
    FileCopy FromFile, ToFile

    Exit Sub
    
ErrHandler:
    'Run-time error 75 is a "Path/File access error" and is thrown if the PRN file is converted
    'to a PDF too quickly and FileCopy thinks the PRN file must not have made it
    If Err.Number = 75 Or Err.Number = 76 Or Err.Number = 53 Then
        If FileExists(Replace(ToFile, ".prn", ".pdf")) Then Exit Sub
    End If
    Err.Raise Err.Number, Err.Source, Err.Description
End Sub

Public Function PrintSample(ByVal Survey_id As Long, _
                            ByVal strPostalBundle_id As String, _
        ByVal lngPaperconfig_id As Long, _
        ByVal strBundled As String, _
        ByVal strN As String, _
        ByVal bolSeperatePages As Boolean) As Boolean
    
    Dim strSQL As String
    Dim theFile As String
    Dim n, StartTime As Long
    Dim strFileHeader As String
    Dim datBundled As Date
    Dim strFromWhere As String
    Dim rs As New ADODB.Recordset
    Initialize
    datBundled = strBundled
    
    Set rs = New ADODB.Recordset
    rs.Open "select intpages*" & strN & " as Pages from paperconfig where paperconfig_id=" & lngPaperconfig_id, moConn, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        strN = rs!pages
    End If
    If rs.State = adStateOpen Then rs.Close
    
    Set rs = Nothing
    
    '***Modified 04-24-2003 SH
    'strSQL = "set rowcount " & strN & Chr(13) & _
             "SELECT Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, P.intPD, '99999999' as strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
    
    strSQL = "set rowcount " & strN & Chr(13) & _
             "SELECT MM.Survey_id, Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, P.intPD, '99999999' as strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
    '***End of modification 04-24-2003 SH
    
    strFromWhere = " FROM pcloutput P, " & strQueue & "PaperSize Z, " & strQueue & _
                   "NPSentMailing S, " & strQueue & "MailingMethodology MM " & _
                   " WHERE MM.survey_id = " & Survey_id
    
    If strPostalBundle_id <> "" Then
        strFromWhere = strFromWhere & " AND S.strPostalBundle = '" & strPostalBundle_id & "'"
    End If
    
    strFromWhere = strFromWhere & _
                   " AND MM.Methodology_id = S.Methodology_id " & _
                   " AND S.PaperConfig_id = " & lngPaperconfig_id & _
                   " AND P.SentMail_id = S.SentMail_id " & _
                   " AND Z.PaperSize_id = P.PaperSize_id " & _
                   " AND s.datBundled<'1/1/4000' " & _
                   " AND abs(datediff(second,S.datBundled,'" & strBundled & "'))<=1 "
    
    strSQL = strSQL & strFromWhere & " ORDER BY strLithoCode, S.SentMail_id, intSheet_num " & Chr(13) & "SET ROWCOUNT 0"

    strFileHeader = "Sample" & "_" & Survey_id
    
    If strPostalBundle_id <> "" Then
        strFileHeader = strFileHeader & "_" & strPostalBundle_id
    End If
    
    strFileHeader = strFileHeader & "_" & Format(datBundled, "yyyymmdd_hhmm") & _
      "_" & lngPaperconfig_id
                    
    If bolSeperatePages Then
        PrintSample = PrintBundle(strSQL, strFileHeader, Array("strSizeCode", "intSheet_num"))
    Else
        PrintSample = PrintBundle(strSQL, strFileHeader, Array("strSizeCode"))
    End If
        
    'change the print files to PDFs
    n = 0
    theFile = Dir(printFilePath & strFileHeader & "*.prn")
    While theFile <> ""
        ErrorTolerantFileCopy printFilePath & theFile, printPDFPath & theFile
        Kill printFilePath & theFile
        n = n + 1
        theFile = Dir(printFilePath & strFileHeader & "*.prn")
    Wend
    
    StartTime = Timer
    While n > 0
        theFile = Dir(printPDFPath & strFileHeader & "*.pdf")
        While theFile <> ""
            '** Modified 08-11-05 JJF
            'FileCopy printPDFPath & theFile, printFilePath & theFile
            FileCopy printPDFPath & theFile, finalPDFPath & theFile
            '** End of modification 08-11-05 JJF
            Kill printPDFPath & theFile
            n = n - 1
            '** Modified 08-11-05 JJF
            'strSQL = """" & AcrobatEXE & """ """ & printFilePath & theFile & """"
            strSQL = """" & AcrobatEXE & """ """ & finalPDFPath & theFile & """"
            '** End of modification 08-11-05 JJF
            Shell strSQL, vbMaximizedFocus
            theFile = Dir(printPDFPath & strFileHeader & "*.pdf")
        Wend
        If Abs(Timer - StartTime) > 15000 Then n = 0
        DoEvents
    Wend
        
    'We DON'T want to set print dates - this is just a QA sample:
    'If PrintSample = True Then _
    '    SetPrintDate "UPDATE Sentmailing SET datReprinted=getdate(), intReprinted=intReprinted+1 " & strFromWhere
    
    Terminate

End Function

Public Function GetRePrintBundle(ByVal Survey_id As Long, _
                                 strPostalBundle_id As String, _
                                 ByVal lngPaperconfig_id As Long, _
                                 ByVal intPage_num As Long, _
                                 ByVal strBundled As String) As Boolean
    Dim strSQL As String
    Dim strFileHeader As String
    Dim datBundled As Date
    Dim strFromWhere As String
    
    Initialize
    datBundled = strBundled

    '***Modified 04-24-2003 SH
    'strSQL = "SELECT Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, P.intPD, S.strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
    strSQL = "SELECT MM.Survey_id, Z.strSizeCode, P.intSheet_num, P.intPA, P.intPB, P.intPC, P.intPD, S.strLithoCode, S.strPostalBundle, S.strGroupDest, P.PCLStream "
    '***End of modification 04-24-2003 SH
    
    strFromWhere = " FROM pcloutput P, " & strQueue & "PaperSize Z, " & strQueue & _
                   "SentMailing S, " & strQueue & "MailingMethodology MM " & _
                   " WHERE MM.survey_id = " & Survey_id & _
                   "       AND S.strPostalBundle = '" & strPostalBundle_id & "'" & _
                   "       AND MM.Methodology_id = S.Methodology_id " & _
                   "       AND S.PaperConfig_id = " & lngPaperconfig_id & _
                   "       AND P.SentMail_id = S.SentMail_id " & _
                   "       AND Z.PaperSize_id = P.PaperSize_id " & _
                   "       AND abs(datediff(second,S.datBundled,'" & strBundled & "'))<=1 " & _
                   "       AND S.datPrinted IS NOT NULL "
                   
    strSQL = strSQL & strFromWhere & " ORDER BY strLithoCode, intSheet_num "

    strFileHeader = "RePrint" & "_" & Survey_id & "_" & strPostalBundle_id & "_" & Format(datBundled, "yyyymmdd_hhmm") & _
                    "_" & lngPaperconfig_id
                    
    GetRePrintBundle = PrintBundle(strSQL, strFileHeader, Array("strSizeCode", "intSheet_num"))
    
    If GetRePrintBundle = True Then
        strFromWhere = " FROM " & strPCL & " P, PaperSize Z, " & _
                       "SentMailing S, MailingMethodology MM " & _
                       " WHERE MM.survey_id = " & Survey_id & _
                       "       AND S.strPostalBundle = '" & strPostalBundle_id & "'" & _
                       "       AND MM.Methodology_id = S.Methodology_id " & _
                       "       AND S.PaperConfig_id = " & lngPaperconfig_id & _
                       "       AND P.SentMail_id = S.SentMail_id " & _
                       "       AND Z.PaperSize_id = P.PaperSize_id " & _
                       "       AND abs(datediff(second,S.datBundled,'" & strBundled & "'))<=1 " & _
                       "       AND S.datPrinted IS NOT NULL "
        SetPrintDate "UPDATE Sentmailing SET datReprinted=getdate(), intReprinted=intReprinted+1 " & strFromWhere

    End If

    Terminate

End Function

Private Sub SetPrintDate(ByVal strSQL As String)
   
    moConn.CommandTimeout = 0
    moConn.Execute strSQL
    
    Exit Sub
    
Skip:
    App.LogEvent "SetPrintDate: " & Err.Description, vbLogEventTypeError
    
End Sub

Public Sub SetMailingDate(ByVal strSurvey_id As String, _
            ByVal strPaperConfig_id As String, _
            ByVal strMailingDate As String, _
            ByVal strBundlingDate As String, _
            Optional ByVal strPostalBundle As String = "**")
    
    Dim strSQL As String
    
    On Error GoTo Skip
    
    Initialize
    
    moConn.CommandTimeout = 0
    strSQL = "EXEC dbo.sp_Queue_SetNextMailing " & _
             strSurvey_id & ", " & _
             strPaperConfig_id & ", " & _
             "'" & strMailingDate & "', " & _
             "'" & strBundlingDate & "'"
             
    If strPostalBundle <> "**" Then
        strSQL = strSQL + ", '" & strPostalBundle & "'"
    End If
    
    moConn.Execute strSQL
    Terminate
    
    Exit Sub
    
Skip:
    App.LogEvent "SetMailingDate: " & Err.Description, vbLogEventTypeError

End Sub

'Public Sub RePrintLitho(ByVal Survey_id As Long, strPostalBundle_id As String, ByVal lngPaperConfig_id As Long, ByVal intPage_num As Long)
'    Dim strSQL As String
'
'    Initialize
'    strSQL = " SELECT Q.SentMail_id " & _
'    " FROM QMgr_view Q, PCLOutput P, PaperSize Z " & _
'    " WHERE Q.survey_id = " & Survey_id & _
'    " AND Q.strPostalBundle = '" & strPostalBundle_id & "'" & _
'    " AND P.intSheet_num = " & intPage_num & _
'    " AND Q.PaperConfig_id = " & lngPaperConfig_id & _
'    " AND Q.SentMail_id = P.SentMail_id " & _
'    " AND Z.PaperSize_id = P.PaperSize_id " & _
'    " AND Q.datMailed IS NULL " & _
'    " AND Q.datPrinted IS NOT NULL"
''    moConn.Execute (strSql)
'    Terminate
'    If MTS Then objctX.SetComplete
'End Sub

'D DV 8/26/99 - We don't want to have the MTS hold this state, we
'D DV 8/26/99 - will have the client component tell us which one.
'DPublic Property Get RePrints() As Boolean
'D    RePrints = pbolReprint
'DEnd Property
'D
'DPublic Property Let RePrints(ByVal vNewValue As Boolean)
'D    pbolReprint = vNewValue
'DEnd Property

Public Function Crunch(ByVal lngLithoCode As Long) As String
    
    Dim LookUpTable: LookUpTable = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Dim tmpStr As String
    Dim saveLithoCode As Long
    Dim lngDigits As Long: lngDigits = 6
    Dim x, R As Long
    
    ' Will not cruch negative numbers
    If lngLithoCode < 0 Then
        Crunch = -1
        Exit Function
    End If
    
    saveLithoCode = lngLithoCode
    
    For x = lngDigits To 0 Step -1
        R = Int(lngLithoCode / (Len(LookUpTable) ^ x))
        tmpStr = tmpStr & Mid(LookUpTable, R + 1, 1)
        lngLithoCode = lngLithoCode - (R * (Len(LookUpTable) ^ x))
    Next x
    
    If saveLithoCode <> UnCrunch(tmpStr) Then
        Crunch = -1
    Else
        Crunch = Right("000000" & tmpStr, lngDigits)
    End If
    
End Function

Public Function UnCrunch(ByVal strLithoCode As String) As String
    
    Dim LookUpTable: LookUpTable = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Dim tmpLng As Long
    Dim CurrentDigit As String * 1
    Dim ConvertedDigit As Long
    Dim CurrentDecimal As Long
    Dim Base10 As Long
    
    Dim x As Long
    
    CurrentDecimal = Len(strLithoCode) - 2
    
    For x = 1 To Len(strLithoCode)
        ' Get the current digit from the number to convert
        CurrentDigit = Mid(strLithoCode, x, 1)
        ' Get the location in the lookup table for the base 10 number
        Base10 = InStr(LookUpTable, CurrentDigit) - 1
        ' Multiply it times the base we are converting from
        ConvertedDigit = Base10 * Len(LookUpTable)
        ' add it to the total
        tmpLng = tmpLng + ConvertedDigit * (Len(LookUpTable) ^ CurrentDecimal)
        CurrentDecimal = CurrentDecimal - 1
    Next x
    
    UnCrunch = tmpLng
    
End Function

Private Function PassCodeCrunch(ByVal lngLithoCode As Long) As String
    Dim tmpStr As String
    Dim saveLithoCode, x, R As Long
    
    ' Will not cruch negative numbers
    If lngLithoCode < 0 Then
        PassCodeCrunch = -1
        Exit Function
    End If
    
    saveLithoCode = lngLithoCode
    
    For x = PassCodeLen To 0 Step -1
        R = Int(lngLithoCode / (Len(PassCodeCharSet) ^ x))
        tmpStr = tmpStr & Mid(PassCodeCharSet, R + 1, 1)
        lngLithoCode = lngLithoCode - (R * (Len(PassCodeCharSet) ^ x))
    Next x
    
    If saveLithoCode <> PassCodeUnCrunch(tmpStr, 0) Then
        PassCodeCrunch = -1
    Else
        PassCodeCrunch = Right(String(PassCodeLen, Mid(PassCodeCharSet, 1, 1)) & tmpStr, PassCodeLen)
    End If
    
End Function

Private Function PassCodeUnCrunch(ByVal strLithoCode As String, numCheckDigits As Integer) As String
    Dim tmpLng, ConvertedDigit, CurrentDecimal, Base10, x As Long
    Dim CurrentDigit As String * 1
    Dim CheckDigits, Check As String
        
    strLithoCode = Replace(strLithoCode, "-", "")
    CheckDigits = Right(strLithoCode, numCheckDigits)
    strLithoCode = Mid(strLithoCode, 1, Len(strLithoCode) - numCheckDigits)
    
    CurrentDecimal = Len(strLithoCode) - 2
    
    For x = 1 To Len(strLithoCode)
        ' Get the current digit from the number to convert
        CurrentDigit = Mid(strLithoCode, x, 1)
        ' Get the location in the lookup table for the base 10 number
        Base10 = InStr(PassCodeCharSet, CurrentDigit) - 1
        ' Multiply it times the base we are converting from
        ConvertedDigit = Base10 * Len(PassCodeCharSet)
        ' add it to the total
        tmpLng = tmpLng + ConvertedDigit * (Len(PassCodeCharSet) ^ CurrentDecimal)
        CurrentDecimal = CurrentDecimal - 1
    Next x
    
    If numCheckDigits = 0 Then
        PassCodeUnCrunch = tmpLng
    Else
        Check = PassCodeCrunch(tmpLng)
        If PassCodeComputeCheckDigit(Check) = CheckDigits Then
            PassCodeUnCrunch = tmpLng
        Else
            PassCodeUnCrunch = -1
        End If
    End If
    
End Function

Private Function PassCodeComputeCheckDigit(ByRef digits As String) As String
    Dim Base, i, digit As Integer
    Dim sum As Double
    Dim Prime(36) As Integer
    
    Base = Len(PassCodeCharSet)
    Prime(0) = 3:      Prime(10) = 37:     Prime(20) = 79:      Prime(30) = 131
    Prime(1) = 5:      Prime(11) = 41:     Prime(21) = 83:      Prime(31) = 137
    Prime(2) = 7:      Prime(12) = 43:     Prime(22) = 89:      Prime(32) = 139
    Prime(3) = 11:     Prime(13) = 47:     Prime(23) = 97:      Prime(33) = 149
    Prime(4) = 13:     Prime(14) = 53:     Prime(24) = 101:     Prime(34) = 151
    Prime(5) = 17:     Prime(15) = 59:     Prime(25) = 103:     Prime(35) = 157
    Prime(6) = 19:     Prime(16) = 61:     Prime(26) = 107:     Prime(36) = 163
    Prime(7) = 23:     Prime(17) = 67:     Prime(27) = 109
    Prime(8) = 29:     Prime(18) = 71:     Prime(28) = 113
    Prime(9) = 31:     Prime(19) = 73:     Prime(29) = 127
           
    For i = Len(digits) To 1 Step -1
        digit = InStr(PassCodeCharSet, Mid(digits, i, 1))
        sum = sum + (digit * Prime(Len(digits) - i))
    Next

    sum = sum Mod (Base * Base)
    PassCodeComputeCheckDigit = Right(PassCodeCrunch(sum), 2)
End Function

Private Function GetFieldName(strFieldDescription As String) As String

    Dim rs As New ADODB.Recordset
    Dim strSQL As String
    
    On Error GoTo BadDescription
    
'    strSql = "SELECT m.strField_nm " & _
'    " FROM QualPro_Params q, MetaData_View m " & _
'    " WHERE m.Study_Id = " & lngStudyId & _
'    " AND m.intSpecialField_cd = q.numParam_Value " & _
'    " AND q.strParam_nm = '" & strFieldDescription & "'"
    strSQL = "SELECT m.strField_nm " & _
             "FROM QualPro_Params q, MetaField m " & _
             "WHERE m.intSpecialField_cd = q.numParam_Value " & _
             "      AND q.strParam_nm = '" & strFieldDescription & "'"
             
    rs.Open strSQL, moConn, adOpenForwardOnly
    
    If Not rs.EOF And Not rs.BOF Then
        GetFieldName = rs!strField_nm
    End If
    
    If rs.State = adStateOpen Then rs.Close
    
    Set rs = Nothing
    
    Exit Function
    
BadDescription:
    If rs.State = adStateOpen Then rs.Close
    Set rs = Nothing

End Function


Private Function GetKeyLine(l As Long) As String
    Dim s As String
    Dim i As Integer
    Dim j As Integer
    Dim c As String
    Dim cs As Integer
    cs = 0
    s = Format(l, "0000000000")
    For i = 1 To Len(s)
      
        c = Mid(s, i, 1) * ((i Mod 2) + 1)
        For j = 1 To Len(c)
            cs = cs + Mid(c, j, 1)
        Next
     
    Next
    c = 10 - Right(cs, 1)
    c = Right(c, 1)
    s = s & c
    GetKeyLine = Format(CDbl(s), "0000 0000 000")
   
End Function


'***Modified 04-23-2003 SH
'Private Function CreateLithoText(ByVal lngLithoCode As Long, ByVal strPostalBundle As String, ByVal strGroupDest As String, ByVal intPA As String, ByVal intPB As String, ByVal intPC As String, ByVal intPD As String) As String
Private Function CreateLithoText(ByVal Survey_id As Long, _
                                 ByVal lngLithoCode As Long, _
                                 ByVal strPostalBundle As String, _
                                 ByVal strGroupDest As String, _
                                 ByVal intPA As String, _
                                 ByVal intPB As String, _
                                 ByVal intPC As String, _
                                 ByVal intPD As String) As String
'***End of modification SH
   
    Dim LookUpTable As String: LookUpTable = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%"
    'Dim rs As Recordset
    Dim tmpStr As String
    Dim strSQL As String
    Dim strCrunch As String
    Dim SaveCrunch As String
    Dim x, lngValue As Long: lngValue = 0
    Dim intPageNum As Long
    Dim strKeyLine As String
    Dim PassCode As String
    
    strCrunch = Crunch(lngLithoCode)
    SaveCrunch = strCrunch
         
    tmpStr = Chr(27) & "&f497y0X" & _
             GetKeyLine(lngLithoCode) & _
             "" & _
             Chr(27) & "&f1X"
             
    tmpStr = tmpStr & _
             Chr(27) & "&f499y0X"
    
    If lngLithoCode = 99999999 Then
        'Push cursor; move cursor -600x +400y; run macro 498 (puts "SAMPLE" over address); pop cursor
        tmpStr = tmpStr & _
          Chr(27) & "&f0S" & _
          Chr(27) & "*p-600x+400Y" & _
          Chr(27) & "&f498y2X" & _
          Chr(27) & "&f1S"
    End If
    
    '*** Modified 04-23-2003 SH
    'tmpStr = tmpStr & _
    '  Trim(strPostalBundle) & _
    '  IIf(strGroupDest = "", "", "-" & Trim(strGroupDest)) & _
    '  Chr(27) & "&f1X" & _
    '  Chr(27) & "&f500y0X" & _
    '  Right("00000000" & lngLithoCode, 8) & _
    '  Chr (27) & "&f1X"
    '
    ' [27]&f500y0X <lithocode> => [27]&f500y0X <lithocode >  survey_id
        
    tmpStr = tmpStr & _
             Trim(strPostalBundle) & _
             IIf(strGroupDest = "", "", "-" & Trim(strGroupDest)) & _
             Chr(27) & "&f1X" & _
             Chr(27) & "&f500y0X" & _
             lngLithoCode & _
             "  " & Survey_id & _
             Chr(27) & "&f1X"
    '***End of modification 04-23-2003 SH
    
    PassCode = PassCodeCrunch(lngLithoCode)
    PassCode = PassCode & PassCodeComputeCheckDigit(PassCode)
    tmpStr = tmpStr & Chr(27) & "&f496y0X" & Format(PassCode, "@@@-@@@@-@@@") & Chr(27) & "&f1X"
    
    If Val(intPA) <> 0 Then
        intPageNum = CLng(intPA)
        intPA = CrunchPageNum(intPageNum)
        strCrunch = Right("00000000" & strCrunch & intPA, 7)
        lngValue = 0
        For x = 1 To 7
            lngValue = lngValue + InStr(1, LookUpTable, Mid(strCrunch, x, 1)) - 1
        Next x
        If lngValue Mod 43 = 0 Then
            strCrunch = strCrunch & "0"
        Else
            strCrunch = strCrunch & Mid(LookUpTable, (lngValue Mod 43) + 1, 1)
        End If
        tmpStr = tmpStr & Chr(27) & "&f" & 500 + intPageNum & "y0X" & Right("00000000" & strCrunch, 8) & Chr(27) & "&f1X"
    End If
    
    strCrunch = SaveCrunch
    
    If Val(intPB) <> 0 Then
        intPageNum = CLng(intPB)
        intPB = CrunchPageNum(intPageNum)
        strCrunch = Right("00000000" & strCrunch & intPB, 7)
        lngValue = 0
        For x = 1 To 7
            lngValue = lngValue + InStr(1, LookUpTable, Mid(strCrunch, x, 1)) - 1
        Next x
        If lngValue Mod 43 = 0 Then
            strCrunch = strCrunch & "0"
        Else
            strCrunch = strCrunch & Mid(LookUpTable, (lngValue Mod 43) + 1, 1)
        End If
        tmpStr = tmpStr & Chr(27) & "&f" & 500 + intPageNum & "y0X" & Right("00000000" & strCrunch, 8) & Chr(27) & "&f1X"
    End If
    
    strCrunch = SaveCrunch
    
    If Val(intPC) <> 0 Then
        intPageNum = CLng(intPC)
        intPC = CrunchPageNum(intPageNum)
        strCrunch = Right("00000000" & strCrunch & intPC, 7)
        lngValue = 0
        For x = 1 To 7
            lngValue = lngValue + InStr(1, LookUpTable, Mid(strCrunch, x, 1)) - 1
        Next x
        If lngValue Mod 43 = 0 Then
            strCrunch = strCrunch & "0"
        Else
            strCrunch = strCrunch & Mid(LookUpTable, (lngValue Mod 43) + 1, 1)
        End If
        tmpStr = tmpStr & Chr(27) & "&f" & 500 + intPageNum & "y0X" & Right("00000000" & strCrunch, 8) & Chr(27) & "&f1X"
    End If
    
    strCrunch = SaveCrunch
    
    If Val(intPD) <> 0 Then
        intPageNum = CLng(intPD)
        intPD = CrunchPageNum(intPageNum)
        strCrunch = Right("00000000" & strCrunch & intPD, 7)
        lngValue = 0
        For x = 1 To 7
            lngValue = lngValue + InStr(1, LookUpTable, Mid(strCrunch, x, 1)) - 1
        Next x
        If lngValue Mod 43 = 0 Then
            strCrunch = strCrunch & "0"
        Else
            strCrunch = strCrunch & Mid(LookUpTable, (lngValue Mod 43) + 1, 1)
        End If
        tmpStr = tmpStr & Chr(27) & "&f" & 500 + intPageNum & "y0X" & Right("00000000" & strCrunch, 8) & Chr(27) & "&f1X"
    End If
    
    CreateLithoText = tmpStr
    
End Function

Public Function CrunchPageNum(lPageNum As Long) As String

    If lPageNum >= 0 And lPageNum <= 9 Then
        CrunchPageNum = CStr(lPageNum)
    Else
        CrunchPageNum = Crunch(CStr(lPageNum))
        While InStr(1, CrunchPageNum, "0") = 1
            CrunchPageNum = Right(CrunchPageNum, Len(CrunchPageNum) - 1)
        Wend
    End If
            
End Function

Private Function PrintBundle(ByVal strBundleSQL As String, _
                             ByVal strFileHeader As String, _
                             ByVal FileNameFieldsArray As Variant) As Boolean

    Dim bitByteArray() As Byte
    Dim tmpStr As String
    Dim strSizeCode As String
    Dim lngPclSize As Long
    Dim rs As ADODB.Recordset
    Dim lngPostcard As Long: lngPostcard = 1
    Dim strFileName As String
    Dim colFiles As New Collection
    Dim vFileName As Variant
    Dim InitStream As String
    Dim xPRNPath As String
    
    ' 9-9-1999 DV
    ' Changed to catch errors coming from the write routines
    ' and to pass them back to the client correctly.
    PrintBundle = False
    Initialize
    
    xPRNPath = printFilePath
    
    Set rs = New ADODB.Recordset
   
    moConn2.CommandTimeout = 0
    rs.Open strBundleSQL, moConn2, adOpenForwardOnly
    Dim cnt
    'Dim x As Integer
    'x = 0
    If Not rs.EOF And Not rs.BOF Then
        While Not rs.EOF
            'x = x + 1
            strFileName = strFileHeader
            For Each vFileName In FileNameFieldsArray
              strFileName = strFileName & "_" & rs.Fields(vFileName) '& x
            Next
            strFileName = strFileName & ".prn"
            ' Initialization PCL code for printer.
            If FileExists(xPRNPath & strFileName) = False Then
                colFiles.Add strFileName
                'Dan - Post card initialization
                If rs!strSizeCode = "PCD" Or rs!strSizeCode = "LPC" Then
                    InitStream = "POSTCARD_INITIALIZATION"
                Else
                    InitStream = "INITIALIZATION"
                End If
                'I DV 9/9/1999 - If WritePCLObject fails, stop and return.
                If Not WritePCLObject(strFileName, InitStream) Then
                    If rs.State = adStateOpen Then
                        rs.Close
                    End If
                    Set rs = Nothing
                    Exit Function
                End If
            End If
            
            '***Modified 04-23-2003 SH
            ' Added a new parameter Survey_id to CreateLithoText).
            ' createing the lithocode macro text
            'tmpStr = CreateLithoText(rs!strLithoCode, rs!strPostalBundle, IIf(IsNull(rs!strGroupDest), "", rs!strGroupDest), _
            '    IIf(Val(IIf(IsNull(rs!intPA), "", rs!intPA)) = 0, "", IIf(IsNull(rs!intPA), "", rs!intPA)), _
            '    IIf(Val(IIf(IsNull(rs!intPB), "", rs!intPB)) = 0, "", IIf(IsNull(rs!intPB), "", rs!intPB)), _
            '    IIf(Val(IIf(IsNull(rs!intPC), "", rs!intPC)) = 0, "", IIf(IsNull(rs!intPC), "", rs!intPC)), _
            '    IIf(Val(IIf(IsNull(rs!intPD), "", rs!intPD)) = 0, "", IIf(IsNull(rs!intPD), "", rs!intPD)) _
            '    )
            tmpStr = CreateLithoText(rs!Survey_id, rs!strLithoCode, rs!strPostalBundle, IIf(IsNull(rs!strGroupDest), "", rs!strGroupDest), _
                     IIf(Val(IIf(IsNull(rs!intPA), "", rs!intPA)) = 0, "", IIf(IsNull(rs!intPA), "", rs!intPA)), _
                     IIf(Val(IIf(IsNull(rs!intPB), "", rs!intPB)) = 0, "", IIf(IsNull(rs!intPB), "", rs!intPB)), _
                     IIf(Val(IIf(IsNull(rs!intPC), "", rs!intPC)) = 0, "", IIf(IsNull(rs!intPC), "", rs!intPC)), _
                     IIf(Val(IIf(IsNull(rs!intPD), "", rs!intPD)) = 0, "", IIf(IsNull(rs!intPD), "", rs!intPD)) _
                     )
            '***End of modification 04-23-2003 SH
            
            ' Check to see if this is a postcard
            If rs!strSizeCode = "PCD" Or rs!strSizeCode = "LPC" Then
                Select Case lngPostcard
                    Case 1:
                        tmpStr = tmpStr & Chr(27) & "*p0000x0000Y" & Chr(27) & "&f701y0X"
                        lngPostcard = 2
                    Case 2:
                        tmpStr = tmpStr & Chr(27) & "*p" & IIf(rs!strSizeCode = "PCD", "3300", "4200") & "x0000Y" & Chr(27) & "&f702y0X"
                        lngPostcard = 3
                    Case 3:
                        tmpStr = tmpStr & Chr(27) & "*p0000x2550Y" & Chr(27) & "&f703y0X"
                        lngPostcard = 4
                    Case 4:
                        tmpStr = tmpStr & Chr(27) & "*p" & IIf(rs!strSizeCode = "PCD", "3300", "4200") & "x2550Y" & Chr(27) & "&f704y0X"
                        lngPostcard = 1
                End Select
            End If
            ' Write Litho code macros to file.
            'I DV 9/9/1999 - If WriteFile fails, we will want to exit this
            'I DV 9/9/1999 - function now, not later.
            If Not WriteFile(strFileName, tmpStr) Then
                'D rs.MoveLast
                If rs.State = adStateOpen Then
                    rs.Close
                End If
                Set rs = Nothing
                Exit Function
            End If
            
            ' Write the PCL From the database
            lngPclSize = rs.Fields("PCLStream").ActualSize
            If lngPclSize > 0 Then
                bitByteArray = rs.Fields("PCLStream").GetChunk(lngPclSize)
            End If
            'I DV 9/9/1999 - If WriteBinary fails, we will want to exit this
            'I DV 9/9/1999 - function now, not later.
            If Not WriteBinary(strFileName, bitByteArray()) Then
                'D                rs.MoveLast
                If rs.State = adStateOpen Then
                    rs.Close
                End If
                Set rs = Nothing
                Exit Function
            End If
            ' Check to see if this is the fourth postcard
            ' because we are changing 4 to 1 in the case statement
            ' above we have to look for a 1 when we have printed
            ' the fourth postcard.
            If (rs!strSizeCode = "PCD" Or rs!strSizeCode = "LPC") And lngPostcard = 1 Then
                tmpStr = Chr(27) & "&a0G" & _
                Chr(27) & "*p" & IIf(rs!strSizeCode = "PCD", "3300", "4200") & "x0000Y" & Chr(27) & "&f701y2X" & _
                Chr(27) & "*p0000x0000Y" & Chr(27) & "&f702y2X" & _
                Chr(27) & "*p" & IIf(rs!strSizeCode = "PCD", "3300", "4200") & "x2550Y" & Chr(27) & "&f703y2X" & _
                Chr(27) & "*p0000x2550Y" & Chr(27) & "&f704y2X" & Chr(12)
                'I DV 9/9/1999 - If WriteFile fails, we will want to exit this
                'I DV 9/9/1999 - function now, not later.
                If Not WriteFile(strFileName, tmpStr) Then
                    'D                    rs.MoveLast
                    If rs.State = adStateOpen Then
                        rs.Close
                    End If
                    Set rs = Nothing
                    Exit Function
                End If
            End If
            strSizeCode = rs!strSizeCode
            rs.MoveNext
        Wend
        
        If strSizeCode = "PCD" Or strSizeCode = "LPC" Then
            tmpStr = ""
            Select Case lngPostcard
                Case 2: 'really on 1
                    tmpStr = Chr(27) & "&a0G" & _
                    Chr(27) & "*p" & IIf(strSizeCode = "PCD", "3300", "4200") & "x0000Y" & Chr(27) & "&f701y2X"
                Case 3: 'really on 2
                    tmpStr = Chr(27) & "&a0G" & _
                    Chr(27) & "*p" & IIf(strSizeCode = "PCD", "3300", "4200") & "x0000Y" & Chr(27) & "&f701y2X" & _
                    Chr(27) & "*p0000x0000Y" & Chr(27) & "&f702y2X"
                Case 4: 'really on 3
                    tmpStr = Chr(27) & "&a0G" & _
                    Chr(27) & "*p" & IIf(strSizeCode = "PCD", "3300", "4200") & "x0000Y" & Chr(27) & "&f701y2X" & _
                    Chr(27) & "*p0000x0000Y" & Chr(27) & "&f702y2X" & _
                    Chr(27) & "*p" & IIf(strSizeCode = "PCD", "3300", "4200") & "x2550Y" & Chr(27) & "&f703y2X"
            End Select
            If tmpStr <> "" Then
                tmpStr = tmpStr & Chr(12)
                'I DV 9/9/1999 - If WriteFile fails, we will want to exit this
                'I DV 9/9/1999 - function now, not later.
                If Not WriteFile(strFileName, tmpStr) Then
                    If rs.State = adStateOpen Then
                        rs.Close
                    End If
                    Set rs = Nothing
                    Exit Function
                End If
            End If
        End If
        
        ' Reset PCL code for printer
        For Each vFileName In colFiles
            'I DV 9/9/1999 - If WritePCLObject fails, stop and return.
            If Not WritePCLObject(CStr(vFileName), "RESET") Then
                If rs.State = adStateOpen Then
                    rs.Close
                End If
                Set rs = Nothing
                Exit Function
            End If
        Next
        PrintBundle = True
        'D DV 9/9/1999 - Since we set PrintBundle to False at the beginning
        'D DV 9/9/1999 - We don't have to set it again here.
        'D    Else
        'D        PrintBundle = False
    End If

    If rs.State = adStateOpen Then
        rs.Close
    End If
    Set rs = Nothing

End Function

Public Function GetLastBundleDate() As String
    
    Dim IsRunning As Boolean
    Dim LastBundleTime As String
    
    Call CheckBundlingStatus(IsRunning, LastBundleTime)
    
    GetLastBundleDate = LastBundleTime
    
End Function

Private Sub CheckBundlingStatus(ByRef IsRunning As Boolean, _
                                ByRef LastBundleTime As String)
    
    Dim pcmADO      As New ADODB.Command
    Dim pParmADO    As New ADODB.Parameter
    
    'DG On Error GoTo ErrorHandler
    
    Call Initialize
    
    ' ---------------------------------------------
    ' Set the Command Object to execute the
    ' Desired stored procedure
    ' ---------------------------------------------
    With pcmADO
        .CommandText = "sp_Queue_BundleStatus"
        .CommandType = adCmdStoredProc
    End With
    
    ' ---------------------------------------------
    ' Create and Append each Parameter to the
    ' Command Object
    ' ---------------------------------------------
    Set pParmADO = pcmADO.CreateParameter("IsRunning", adInteger, adParamOutput, 4)
    pcmADO.Parameters.Append pParmADO
    
    Set pParmADO = pcmADO.CreateParameter("LastBundleTime", adVarChar, adParamOutput, 50)
    pcmADO.Parameters.Append pParmADO
    
    ' ---------------------------------------------
    ' Set the Command object to use the
    ' already established Connection and Execute
    ' Stored Procedure
    ' ---------------------------------------------
    moConn.CommandTimeout = 0
    pcmADO.ActiveConnection = moConn
    pcmADO.Execute
    
    ' ---------------------------------------------
    ' Retrieve the output Parameter by Item number
    ' (with Item(0) being the first parm appended
    ' ---------------------------------------------
    IsRunning = pcmADO.Parameters.Item(0).Value
    LastBundleTime = Trim(pcmADO.Parameters.Item(1).Value)
        
    ' ---------------------------------------------
    ' Clear the Parameter and Command objects
    ' ---------------------------------------------
    Set pParmADO = Nothing
    Set pcmADO = Nothing
    
    moConn.Close
    Set moConn = Nothing
    
    Exit Sub
    
ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Sub

Public Function PrintingInstance_Add(ByRef LastPrintDate As String) As Boolean
    
    Dim pcmADO      As New ADODB.Command
    Dim pParmADO    As New ADODB.Parameter
    
    On Error GoTo ErrorHandler
    
    Call Initialize
    
    ' ---------------------------------------------
    ' Set the Command Object to execute the
    ' Desired stored procedure
    ' ---------------------------------------------
    With pcmADO
        .CommandText = "sp_Queue_Printing_AddInstance"
        .CommandType = adCmdStoredProc
    End With
    
    ' ---------------------------------------------
    ' Create and Append each Parameter to the
    ' Command Object
    ' ---------------------------------------------
    Set pParmADO = pcmADO.CreateParameter("IsAdded", adInteger, adParamOutput, 4)
    pcmADO.Parameters.Append pParmADO
    
    Set pParmADO = pcmADO.CreateParameter("LastDate", adVarChar, adParamOutput, 22)
    pcmADO.Parameters.Append pParmADO
    
    ' ---------------------------------------------
    ' Set the Command object to use the
    ' already established Connection and Execute
    ' Stored Procedure
    ' ---------------------------------------------
    pcmADO.ActiveConnection = moConn
    pcmADO.Execute
    
    ' ---------------------------------------------
    ' Retrieve the output Parameter by Item number
    ' (with Item(0) being the first parm appended
    ' ---------------------------------------------
    PrintingInstance_Add = pcmADO.Parameters.Item(0).Value
    LastPrintDate = pcmADO.Parameters.Item(1).Value
    
    ' ---------------------------------------------
    ' Clear the Parameter and Command objects
    ' ---------------------------------------------
    Set pParmADO = Nothing
    Set pcmADO = Nothing
    
    moConn.Close
    Set moConn = Nothing
    
    Exit Function
    
ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

Public Sub PrintingInstance_Remove()
    
    Dim pcmADO      As New ADODB.Command
    Dim pParmADO    As New ADODB.Parameter
    
    On Error GoTo ErrorHandler
    
    Call Initialize
    
    ' ---------------------------------------------
    ' Set the Command Object to execute the
    ' Desired stored procedure
    ' ---------------------------------------------
    With pcmADO
        .CommandText = "sp_Queue_Printing_RemoveInstan"
        .CommandType = adCmdStoredProc
    End With
    
    ' ---------------------------------------------
    ' Set the Command object to use the
    ' already established Connection and Execute
    ' Stored Procedure
    ' ---------------------------------------------
    pcmADO.ActiveConnection = moConn
    pcmADO.Execute
    
    ' ---------------------------------------------
    ' Clear the Parameter and Command objects
    ' ---------------------------------------------
    Set pParmADO = Nothing
    Set pcmADO = Nothing
    
    moConn.Close
    Set moConn = Nothing
    
    Exit Sub
    
ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Sub

Private Function printFilePath() As String
    
  If strFilePath = "" Then
    Initialize
    
    Dim rs As New ADODB.Recordset
    
    'Set rs = New ADODB.Recordset
    rs.Open "SELECT strParam_Value FROM QualPro_Params WHERE strParam_nm = 'QueueManager'", moConn, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        strFilePath = rs!strParam_Value
    Else
        Err.Raise vbError + 10001, "QueManagerDB:clsQueueManager:PrintBundleReport", "'QueueManager' Param does not exist"
    End If
    rs.Close
    If Right(strFilePath, 1) <> "\" Then strFilePath = strFilePath & "\"
  End If
  printFilePath = strFilePath
  
End Function

Private Function printPDFPath() As String
    
  If strPDFPath = "" Then
    
    Initialize

    Dim rs As New ADODB.Recordset
    
    'Set rs = New ADODB.Recordset
    rs.Open "SELECT strParam_Value FROM QualPro_Params WHERE strParam_nm = 'PCLGenPrnLoc_TP'", moConn, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        strPDFPath = rs!strParam_Value
    Else
        Err.Raise vbError + 10001, "QueManagerDB:clsQueueManager:PrintBundleReport", "'PCLGenPrnLoc_TP' Param does not exist"
    End If
    rs.Close
    
    If Right(strPDFPath, 1) <> "\" Then strPDFPath = strPDFPath & "\"
  End If
  printPDFPath = strPDFPath
  
End Function

'** Added this routine to specify a path where we can put samples printed from QueueManager
'** Added on 08-11-05 JJF
Private Function finalPDFPath() As String
    
  If strFinalPDFPath = "" Then
    
    Initialize

    Dim rs As New ADODB.Recordset
    
    'Set rs = New ADODB.Recordset
    rs.Open "SELECT strParam_Value FROM QualPro_Params WHERE strParam_nm = 'QManSamplePath'", moConn, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        strFinalPDFPath = rs!strParam_Value
    Else
        Err.Raise vbError + 10001, "QueManagerDB:clsQueueManager:PrintBundleReport", "'QManSamplePath' Param does not exist"
    End If
    rs.Close
    
    If Right(strFinalPDFPath, 1) <> "\" Then strFinalPDFPath = strFinalPDFPath & "\"
  End If
  finalPDFPath = strFinalPDFPath
  
End Function




Private Function AcrobatEXE() As String
    If strAcrobatEXE = "" Then
        strAcrobatEXE = GetRegValue(HKEY_CLASSES_ROOT, "AcroExch.Document\shell\open\command", "")
        strAcrobatEXE = Replace(strAcrobatEXE, """", "")
        strAcrobatEXE = Trim(Replace(strAcrobatEXE, "%1", ""))
    End If
    
    AcrobatEXE = strAcrobatEXE
End Function

Public Function ShowGroupedPrint() As Boolean
    
  If strShowGroupedPrint = "" Then
    Initialize
  
    Dim rs As New ADODB.Recordset
    
    'Set rs = ADODB.Recordset
    rs.Open "SELECT numParam_Value FROM QualPro_Params WHERE strParam_nm = 'ShowGroupedPrint'", moConn, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        strShowGroupedPrint = rs!numParam_value
    Else
        strShowGroupedPrint = "0"
    End If
    rs.Close
  End If
  ShowGroupedPrint = (strShowGroupedPrint = "1")
  
End Function


Public Function CreateBundleSheet(ByVal strSurvey_idSelect As String, _
                                   ByVal strConfig_idSelect As String, _
                                   ByVal datBundledSelect As Date) As String

    Dim tmpStr As String
    Dim strProjName As String
    Dim strSurvey_id As String
    Dim strConfig_nm As String
    Dim datBundled As Date
    Dim rs As ADODB.Recordset
    Dim strFileName As String
    Dim curBundle As String, strBundle As String, strGroup As String
    Dim UnprintedBundles As Long
    Dim UnprintedPieces As Long
    Dim LastUnprintedBundle As String
    Dim boolFlats As Boolean
    Dim oBunRepCm As ADODB.Command      '** Added 09-12-02 JJF
    Dim pieces As Long                  '** Added 12-01-2004 SH
    Dim runningTotal As Long            '** Added 12-01-2004 SH
    Dim isGroupedPrint As Boolean
        
    CreateBundleSheet = ""
    Initialize
    
    Set oBunRepCm = New ADODB.Command
    With oBunRepCm
        .CommandText = "sp_Queue_BundleReport"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = moConn
        .Parameters.Append .CreateParameter("datBundled", adDBTimeStamp, adParamInput)
        .Parameters.Append .CreateParameter("Survey_id", adVarChar, adParamInput, 10)
        .Parameters.Append .CreateParameter("PaperConfig", adInteger, adParamInput)
    End With 'oBunRepCm
    
    Set rs = New ADODB.Recordset
    moConn.CommandTimeout = 0
    
    With oBunRepCm
        .Parameters("datBundled") = datBundledSelect
        .Parameters("Survey_id") = strSurvey_idSelect
        .Parameters("PaperConfig") = Val(strConfig_idSelect)
        Set rs = .Execute()
    End With
    
    
    If Not rs.EOF And Not rs.BOF Then
        strProjName = ""
        strConfig_nm = ""
        strSurvey_id = ""
        datBundled = Now
        UnprintedBundles = 0
        UnprintedPieces = 0
        LastUnprintedBundle = ""
        
        boolFlats = (Left(rs.Fields("strPostalBundle"), 1) >= "K")
               
                runningTotal = 0
                strProjName = rs.Fields("strProjName").Value
                strConfig_nm = rs.Fields("strPaperConfig_nm").Value
                strSurvey_id = rs.Fields("Survey_id").Value
                datBundled = rs.Fields("datBundled").Value
                tmpStr = vbTab + "BUNDLING REPORT" & "" & GetSurveyType(Val(strSurvey_idSelect)) & vbCrLf & vbCrLf
                tmpStr = tmpStr + strProjName & vbCrLf
                tmpStr = tmpStr + strConfig_nm & vbCrLf
                tmpStr = tmpStr + "Spooled on: " & datBundled & vbCrLf & vbCrLf
                If boolFlats Then
                    ' ** 12-01-2004 SH - Added Running Total column
                    tmpStr = tmpStr + "Tray        Bundle   Litho Range             Pieces   Running Total" & vbCrLf
                    tmpStr = tmpStr + "---------   ------   ---------------------   ------   -------------" & vbCrLf
                Else
                    ' ** 12-01-2004 SH - Added Running Total column
                    tmpStr = tmpStr + "Bundle   Group   Litho Range             Pieces   Running Total" & vbCrLf
                    tmpStr = tmpStr + "------   -----   ---------------------   ------   -------------" & vbCrLf
                End If
                
                strGroup = ""
                curBundle = ""
            'End If
        
        isGroupedPrint = (strSurvey_id = "0")
        
        While (Not rs.EOF) And ((Not isGroupedPrint) Or strSurvey_id = "0")
            'until rs.eof or (isgroupedprint and survey_id <> "0")
            If IsNull(rs.Fields("strGroupDest").Value) Then
                strGroup = ""
            Else
                strGroup = rs.Fields("strGroupDest").Value
            End If
            If curBundle <> rs.Fields("strpostalbundle").Value Then
                strBundle = rs.Fields("strPostalBundle").Value
                curBundle = strBundle
            Else
                strBundle = ""
            End If
            
            If boolFlats Then
                tmpStr = tmpStr & Pad(strBundle, 12) & Pad(strGroup, 9) & Pad(rs.Fields("MinLitho").Value & " - " & rs.Fields("MaxLitho").Value, 24) & Pad(rs.Fields("pieces").Value, 8)
            Else
                tmpStr = tmpStr & Pad(strBundle, 9) & Pad(strGroup, 8) & Pad(rs.Fields("MinLitho").Value & " - " & rs.Fields("MaxLitho").Value, 24) & Pad(rs.Fields("pieces").Value, 8)
            End If
            pieces = rs.Fields("Pieces").Value
            runningTotal = runningTotal + pieces
            tmpStr = tmpStr & str(runningTotal) & vbCrLf
            
            If IsNull(rs.Fields("MinLitho").Value) Then
                UnprintedPieces = UnprintedPieces + rs.Fields("Pieces").Value
                If LastUnprintedBundle <> curBundle Then
                    UnprintedBundles = UnprintedBundles + 1
                    LastUnprintedBundle = curBundle
                End If
            
            End If
            rs.MoveNext
            If Not rs.EOF Then strSurvey_id = rs.Fields("Survey_id").Value
        Wend
        
        If isGroupedPrint Then
            tmpStr = tmpStr + vbCrLf & vbCrLf
            tmpStr = tmpStr + "Project                                                      Litho Range             #" & vbCrLf
            tmpStr = tmpStr + "-----------------------------------------------------------  ----------------------  ----" & vbCrLf
            
            runningTotal = 0
            While Not rs.EOF
                tmpStr = Pad(rs.Fields("strProjName").Value, 61) & Pad(rs.Fields("MinLitho").Value & " - " & rs.Fields("MaxLitho").Value, 24) & Pad(rs.Fields("pieces").Value, 4)
                pieces = rs.Fields("Pieces").Value
                runningTotal = runningTotal + pieces
                tmpStr = tmpStr & vbCrLf
                
                rs.MoveNext
            Wend
        End If
                
        If UnprintedPieces > 0 Then
            tmpStr = vbCrLf & "There are " & UnprintedPieces & " questionnaires in " & UnprintedBundles & " bundle(s) that haven't been printed yet"
        End If
        CreateBundleSheet = tmpStr
    End If

    If rs.State = adStateOpen Then
        rs.Close
    End If
    Set rs = Nothing
        
    Set oBunRepCm = Nothing     '** Added 09-12-02 JJF

End Function

Public Function BundlingSheetPrinter() As String
    
  If strBundlingSheetPrinter = "" Then
    Initialize
    
    Dim rs As New ADODB.Recordset
    
    'Set rs = New ADODB.Recordset
    rs.Open "SELECT strParam_Value FROM QualPro_Params WHERE strParam_grp = 'QueueManager' and strParam_nm = 'BundlingSheetPrinter'", moConn, adOpenForwardOnly
    If Not rs.EOF And Not rs.BOF Then
        strBundlingSheetPrinter = rs!strParam_Value
    Else
        Err.Raise vbError + 10001, "QueManagerDB:clsQueueManager:PrintBundleSheet", "'BundlingSheetPrinter' Param does not exist"
    End If
    rs.Close
  End If
  BundlingSheetPrinter = strBundlingSheetPrinter
  
End Function


