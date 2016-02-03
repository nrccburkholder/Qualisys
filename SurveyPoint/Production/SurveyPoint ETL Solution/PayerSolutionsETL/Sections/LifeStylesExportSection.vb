Imports System.IO
Imports System.Text
Imports System.Data
Public Enum BarCodeType
    Page
    PageData
End Enum
Public Class LifeStylesExportSection
#Region " Private Variables "
    Private mLifeStylesNavigator As LifeStylesExportNavigator
    Private mRespondentIDs As List(Of String)
    Private mSurveyIDs As List(Of String)
    Private mSurveyInstanceIDs As List(Of String)
    Private mClientIDs As List(Of String)
    Private mRecordCount As Long = 0
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mLifeStylesNavigator = TryCast(navCtrl, LifeStylesExportNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region
#Region " Event Handlers "    
    Private Sub cmdExportFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdExportFile.Click
        Dim dlg As DialogResult = Me.SaveFileDialog1.ShowDialog
        If dlg = DialogResult.OK Then
            Me.txtExportFile.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub
    Private Sub cmdExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdExport.Click
        ExportData(False)
    End Sub
    Private Sub cmdExportAndMark_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdExportAndMark.Click
        If MessageBox.Show("Are you sure you wish to run the export with event code updates?", "Warning", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) = DialogResult.OK Then
            ExportData(True)
            UpdateEventCodes()
        End If        
    End Sub
    Private Sub LifeStylesExportSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sb As New StringBuilder()
        sb.AppendLine("This Section creates a formatted text file for Himark lifestyles export of Survey 58.  It  Adds barcode data to the file for the survey they will be sending out.")        
        sb.AppendLine("You have the choice to just export to a text file, or once exported, mark all respondent in the file with a 2401 event code.")
        Me.txtDescription.Text = sb.ToString()
    End Sub
#End Region
#Region " Private Methods "    
    Private Sub UpdateEventCodes()
        Dim conn As SqlClient.SqlConnection = Nothing
        Dim sql As String = ""        
        Try
            If mRecordCount <> Me.mRespondentIDs.Count OrElse mRecordCount <> Me.mClientIDs.Count OrElse mRecordCount <> mSurveyIDs.Count OrElse mRecordCount <> Me.mSurveyInstanceIDs.Count Then
                MessageBox.Show("Event Codes Not Updated.  Respondent Count out of sync with returned count.")
            Else
                conn = New SqlClient.SqlConnection(Config.QMSConnection)
                Dim sb As New StringBuilder()
                For i As Integer = 0 To Me.mRespondentIDs.Count - 1
                    sql = "Insert into EventLog (EventDate, EventID, UserID, RespondentID, SurveyInstanceID, SurveyID, ClientID, EventTypeID) Values ("
                    sql += "'" & Now & "', 2401, 1, " & Me.mRespondentIDs(i) & ", " & Me.mSurveyInstanceIDs(i) & ", " & Me.mSurveyIDs(i) & ", " & Me.mClientIDs(i) & ",4)"
                    'If conn.State = ConnectionState.Closed Then conn.Open()
                    'Dim cmd As New SqlClient.SqlCommand(sql, conn)
                    'cmd.ExecuteNonQuery()
                    System.Diagnostics.Debug.Print(sql)
                    sb.AppendLine(sql)
                Next
                MessageBox.Show(sb.ToString())
                Me.txtDescription.Text += vbCrLf & "Event Codes have been added."
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not conn Is Nothing Then
                If conn.State <> ConnectionState.Closed Then
                    conn.Close()
                    conn = Nothing
                End If
            End If
        End Try
    End Sub
    Private Function ComputeCheckDigit(ByVal val As String) As String        
        Dim tempCheckDigit As String
        Dim checkCode As String
        Dim checkCnt As Integer
        Dim position As Integer

        Const kBarcodeDigits As String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%"

        'Divide the string into it's component parts
        checkCode = val.ToUpper

        'Accumulate the checksum of all of the digits
        checkCnt = 0
        For position = 1 To checkCode.Length
            'Get the current digit to be checksummed
            tempCheckDigit = checkCode.Substring(position - 1, 1)

            'If this digit is a space then set it to an exclamation point
            If tempCheckDigit = " " Then tempCheckDigit = "!"

            'Add the checksum value
            '** Modified 08-17-04 JJF
            'nCheckCnt = nCheckCnt + ksBarcodeDigits.IndexOf(sTempCheckDigit)
            checkCnt += kBarcodeDigits.IndexOf(tempCheckDigit) + 1
            '** End of modification 08-17-04 JJF
        Next position

        'Determine the check digit
        If (checkCnt Mod (kBarcodeDigits.Length + 1)) = 0 Then
            tempCheckDigit = "0"
        Else
            tempCheckDigit = kBarcodeDigits.Substring((checkCnt Mod (kBarcodeDigits.Length + 1)) - 1, 1)
        End If

        Return tempCheckDigit        
    End Function
    Private Sub GetOriginalRespondentCount()
        Dim conn As SqlClient.SqlConnection = Nothing
        Dim originalRespondentCount As Long = 0
        Try
            conn = New SqlClient.SqlConnection(Config.QMSConnection)
            If conn.State = ConnectionState.Closed Then conn.Open()
            Dim cmd As New SqlClient.SqlCommand()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "dbo.HLExport_GetRespondentCount"
            cmd.Connection = conn
            Dim temp As Object = cmd.ExecuteScalar
            If IsDBNull(temp) Then
                originalRespondentCount = 0
            Else
                originalRespondentCount = CLng(temp)
            End If
            Me.txtDescription.Text += vbCrLf & "Orginal Respondent Count: " & originalRespondentCount
        Catch ex As Exception
            Throw ex
        Finally
            If Not conn Is Nothing Then
                If conn.State <> ConnectionState.Closed Then
                    conn.Close()
                End If
            End If
        End Try
    End Sub
    Private Function GenerateBarCode(ByVal faqssID As String, ByVal templateID As Long, ByVal respID As Long, ByVal pagenumber As Integer, typeOfBarCode as BarCodeType) As String
        Dim retVal As String = ""
        Dim sb As New StringBuilder
        sb.Remove(0, sb.Length)
        sb.Append(String.Format("{0}{1:D5}{2:D8}{3}", faqssID, templateID, respID, pagenumber))
        Dim checkDigit As String = ComputeCheckDigit(sb.ToString())
        If checkDigit = "!" AndAlso typeOfBarCode = BarCodeType.Page Then
            checkDigit = "~"
        End If
        sb.Remove(0, sb.Length)
        If typeOfBarCode = BarCodeType.Page Then
            sb.Append(String.Format("*{0}{1:D5}{2:D8}{3}{4}*", faqssID, templateID, respID, pagenumber, checkDigit))
        Else
            sb.Append(String.Format("*{0}{1:D5}{2:D8}{3}{4}*", faqssID, templateID, respID, pagenumber, checkDigit))
        End If


        retVal = sb.ToString.PadRight(25)
        Return retVal
    End Function
    Private Sub ExportData(ByVal withUpdate As Boolean)
        If ValidateFiles() Then
            Dim headerString As New StringBuilder()
            Dim dataString As New StringBuilder()
            Dim footerString As New StringBuilder()
            Dim myWrite As StreamWriter = Nothing
            Dim conn As SqlClient.SqlConnection = Nothing
            Dim reader As SqlClient.SqlDataReader = Nothing
            mRecordCount = 0
            Try
                'Get the original resp count and post to screen.
                GetOriginalRespondentCount()

                'Write the header.
                myWrite = New StreamWriter(Me.txtExportFile.Text)
                headerString.Append("HEADER".PadRight(20))
                headerString.Append(Now.ToString("yyyyMMdd").PadRight(10))
                headerString.Append(" ".PadRight(909))
                myWrite.WriteLine(headerString.ToString())

                'Get the export data.
                conn = New SqlClient.SqlConnection(Config.QMSConnection)                
                If conn.State = ConnectionState.Closed Then conn.Open()
                Dim cmd As New SqlClient.SqlCommand()
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandText = "dbo.HLExport_GetRespondentData"
                cmd.CommandTimeout = 600
                cmd.Connection = conn
                reader = cmd.ExecuteReader()
                While reader.Read
                    dataString = New StringBuilder()
                    Dim newRespID As Long = CLng(reader("NewRespondentID_HIDE"))
                    Dim faqssID As String = CStr(reader("FAQSSID_HIDE"))
                    Dim TemplateID As Long = CLng(reader("TemplateID_HIDE"))
                    For i As Integer = 0 To reader.FieldCount - 1
                        Dim colName As String = reader.GetName(i).ToLower
                        If Not colName.IndexOf("_hide") > 0 Then
                            If colName = "lsr_1_barcode" Then
                                dataString.Append(GenerateBarCode(faqssID, TemplateID, newRespID, 1, BarCodeType.Page))
                            ElseIf colName = "lsr_2_barcode" Then
                                dataString.Append(GenerateBarCode(faqssID, TemplateID, newRespID, 1, BarCodeType.PageData))
                            ElseIf colName = "lsr_5_barcode" Then
                                dataString.Append(GenerateBarCode(faqssID, TemplateID, newRespID, 2, BarCodeType.Page))
                            ElseIf colName = "lsr_6_barcode" Then
                                dataString.Append(GenerateBarCode(faqssID, TemplateID, newRespID, 2, BarCodeType.PageData))
                            Else
                                dataString.Append(reader.GetString(i))
                            End If
                        End If
                    Next
                    'Me.mRespondentIDs.Add(CStr(CInt(reader("RespondentID"))))
                    myWrite.WriteLine(dataString.ToString())
                    mRecordCount += 1
                End While
                'write the footerString
                footerString.Append("TRAILER".PadRight(20))
                footerString.Append("TOTAL NUMBER OF RECORDS".PadRight(24))
                footerString.Append(PadZeros(mRecordCount.ToString(), 5))
                footerString.Append("".PadRight(890))
                myWrite.WriteLine(footerString.ToString())
                Me.txtDescription.Text += vbCrLf & "File Export Complete"
                Me.txtDescription.Text += vbCrLf & "Total number of records exported: " & mRecordCount
                If withUpdate Then
                    Me.txtDescription.Text += vbCrLf & "Updating Event Codes."
                End If
            Catch ex As System.Exception
                Globals.ReportException(ex)
            Finally
                If Not myWrite Is Nothing Then
                    myWrite.Close()
                End If
                If Not reader Is Nothing Then
                    reader.Close()
                End If
                If Not conn Is Nothing Then
                    If conn.State <> ConnectionState.Closed Then
                        conn.Close()
                        conn = Nothing
                    End If
                End If
            End Try
        End If
    End Sub
    Private Function ValidateFiles() As Boolean
        Dim fileString As String = ""
        Dim sr As StreamReader = Nothing
        Try                  
            If Me.txtExportFile.Text.Length = 0 Then
                MessageBox.Show("No Export File Chosen.")
                Return False
            End If            
            Return True
        Catch ex As System.Exception
            Globals.ReportException(ex)
        Finally
            If Not sr Is Nothing Then
                sr.Close()
                sr = Nothing
            End If
        End Try
    End Function    
    Private Function PadZeros(ByVal value As String, ByVal length As Integer) As String
        Dim retVal As String = Trim(value)
        If retVal.Length > length Then
            retVal = retVal.Substring(0, length)
        End If
        If retVal.Length < length Then
            Dim padChars As String = ""
            For i As Integer = 1 To length - retVal.Length
                padChars += "0"
            Next
            retVal = padChars & retVal
        End If
        Return retVal
    End Function
#End Region
End Class
