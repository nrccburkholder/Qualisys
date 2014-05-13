Imports System.Data.OleDb
Imports System.Net.Mail

Public Class MainForm

    Private mSpecialUpdateDataTable2 As New System.Data.DataTable
    Private mSpecialUpdateDataTable3 As New System.Data.DataTable

#Region " Public Declaration"

    'Public WorkingDirectory As String '= "\\neptune\teams\Client Services\Audit Team\Hospital Compare Database\2010_6_17\To Clients June 2010\"
    'Public excelSourceFile As String ' = WorkingDirectory & "Mitch Bergen.xls"

#End Region

#Region "Button Clicks"

    Private Sub Using_iText_Split()

        iTextHCAHPS.PDFParser.Split(Me.sourceFile.Text, Me.pdfLocation.Text)

    End Sub

    Private Sub Using_iText()

        Dim dirInf As New IO.DirectoryInfo(Me.pdfLocation.Text)

        For Each fileInf As IO.FileInfo In dirInf.GetFiles("*.pdf", IO.SearchOption.AllDirectories)

            Dim parsedData As iTextHCAHPS.ParsedData = iTextHCAHPS.PDFParser.Parse(fileInf.FullName)

            Dim FacilityName As String = String.Empty
            Dim FacilityNum As String = String.Empty

            FacilityName = parsedData.FacilityName
            FacilityNum = parsedData.CCN

            If FacilityName.StartsWith("Spring") Then
                Dim a As Integer

                a = 1
            End If

            FacilityName = FacilityNum & "_" & FacilityName.Replace(" ", "")
            FacilityName = FacilityName.Replace("/", " ").Replace("\", " ")

            If FileIO.FileSystem.FileExists(IO.Path.Combine(Me.pdfLocation.Text, FacilityName & ".pdf")) Then
                FacilityName = FacilityName & " (" & fileInf.Name.Replace(".pdf", "") & ")"
            End If

            Dim Str As String = IO.Path.Combine(Me.pdfLocation.Text, FacilityName & ".pdf")

            fileInf.MoveTo(Str)

        Next

    End Sub

    Private Sub RenameSplitPDFs_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RenameSplitPDFs.Click

        'Using_iText()
        Using_iText_Split()
        Return

        '' aa removed
        'Dim dirInf As New IO.DirectoryInfo(Me.pdfLocation.Text)

        'For Each fileInf As IO.FileInfo In dirInf.GetFiles("*.pdf", IO.SearchOption.AllDirectories)

        '    'Open The Original File
        '    Dim PDDoc As New Acrobat.AcroPDDoc
        '    PDDoc.Open(fileInf.FullName)

        '    'Get The First Page
        '    Dim PDPage As Acrobat.AcroPDPage
        '    PDPage = PDDoc.AcquirePage(0)

        '    ' set the selected text area to the size of the page        
        '    Dim CAcroRect As New Acrobat.AcroRect
        '    Dim CArcoPoint As Acrobat.AcroPoint
        '    CArcoPoint = PDPage.GetSize()
        '    CAcroRect.Top = CArcoPoint.y + 100
        '    CAcroRect.Left = 0
        '    CAcroRect.right = CArcoPoint.x + 100
        '    CAcroRect.bottom = 0
        '    Dim PDTxtSelect As Acrobat.AcroPDTextSelect = PDDoc.CreateTextSelect(0, CAcroRect)
        '    Dim iNumWords As Integer = PDTxtSelect.GetNumText

        '    ' Extract the text as String        
        '    ' see more notes below        
        '    Dim i As Integer
        '    Dim sPgTxt As String = String.Empty
        '    For i = 0 To iNumWords - 1
        '        sPgTxt = sPgTxt + PDTxtSelect.GetText(i)
        '    Next


        '    ' split the string on newlines,        
        '    ' put each line in array element        
        '    Dim arPdfLines
        '    arPdfLines = Split(sPgTxt, vbCrLf)

        '    Dim FacilityName As String = String.Empty
        '    Dim FacilityNum As String = arPdfLines(0).ToString.Trim
        '    For i = 0 To UBound(arPdfLines)
        '        If arPdfLines(i).ToString.Contains("experience for") Then
        '            FacilityName = arPdfLines(i).ToString.Replace("Springboarding the patient experience for", "")
        '        End If
        '    Next

        '    FacilityName = FacilityNum & "_" & FacilityName.Replace(" ", "")
        '    FacilityName = FacilityName.Replace("/", " ").Replace("\", " ")

        '    If FileIO.FileSystem.FileExists(IO.Path.Combine(Me.pdfLocation.Text, FacilityName & ".pdf")) Then FacilityName = FacilityName & " (" & fileInf.Name.Replace(".pdf", "") & ")"

        '    Dim Str As String = IO.Path.Combine(Me.pdfLocation.Text, FacilityName & ".pdf")

        '    Dim result = PDDoc.Save(1, Str)

        '    PDDoc.Close()

        'Next

        MsgBox("Done")

    End Sub

    Private Sub AddAttachmentInfo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddAttachmentInfo.Click

        'Open Connections To The File
        Dim strConn1 As String = "Provider=Microsoft.Jet.OleDb.4.0;data source=" & Me.excelFile.Text & ";Extended Properties=""Excel 8.0;HDR=Yes;"""
        Dim objConn1 As New OleDbConnection(strConn1)
        objConn1.Open()

        'Simply Open and Save Document First!?

        'Create A New DataTable from the File
        Dim strSql1 As String
        strSql1 = "Select * from [HCAHPS Experience Report Contac$]"
        Dim da1 As New OleDbDataAdapter(strSql1, objConn1)
        Me.mSpecialUpdateDataTable3.Reset()
        da1.Fill(mSpecialUpdateDataTable3)

        Dim i As Integer = 0
        Dim path As String = String.Empty
        Dim rowscount As String = mSpecialUpdateDataTable3.Rows.Count.ToString

        For Each row As DataRow In mSpecialUpdateDataTable3.Rows

            i = i + 1

            Dim CCN As String = row.Item("CCN").ToString.Trim

            path = ""
            Dim dirInf As New IO.DirectoryInfo(Me.pdfLocation.Text)
            For Each fileInf As IO.FileInfo In dirInf.GetFiles(CCN & "*.pdf", IO.SearchOption.AllDirectories)
                path = fileInf.Name
            Next

            strSql1 = "Update [HCAHPS Experience Report Contac$] set Attachment = '" & path.Replace("'", "''") & "' where CCN = '" & CCN & "'"
            da1.UpdateCommand = New OleDbCommand(strSql1, objConn1)
            da1.UpdateCommand.ExecuteNonQuery()

            Me.ToolStripStatusLabel1.Text = "Processing " & i & " out of " & rowscount
            Me.Refresh()

        Next
        Me.ToolStripStatusLabel1.Text = "Done " & Me.ToolStripStatusLabel1.Text
        objConn1.Dispose()


    End Sub

    Private Sub SendAllEmailsTest_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SendAllEmailsTest.Click

        SendAllEmails("Test")

    End Sub

    Private Sub SendAllEmailsProd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SendAllEmailsProd.Click
        SendAllEmails("Prod")
    End Sub

#End Region

#Region "Utils"

    Private Function GetClientNameFromInsidePDF(ByVal FullName As String)

        Return iTextHCAHPS.PDFParser.GetClientNameFromInsidePDF(FullName)

        ' AA
        ''Open The File
        'Dim PDDoc As New Acrobat.AcroPDDoc
        'PDDoc.Open(IO.Path.Combine(Me.pdfLocation.Text, FullName))

        ''Get The First Page
        'Dim PDPage As Acrobat.AcroPDPage
        'PDPage = PDDoc.AcquirePage(0)

        '' set the selected text area to the size of the page        
        'Dim CAcroRect As New Acrobat.AcroRect
        'Dim CArcoPoint As Acrobat.AcroPoint
        'CArcoPoint = PDPage.GetSize()
        'CAcroRect.Top = CArcoPoint.y + 100
        'CAcroRect.Left = 0
        'CAcroRect.right = CArcoPoint.x + 100
        'CAcroRect.bottom = 0
        'Dim PDTxtSelect As Acrobat.AcroPDTextSelect = PDDoc.CreateTextSelect(0, CAcroRect)
        'Dim iNumWords As Integer = PDTxtSelect.GetNumText

        '' Extract the text as String        
        '' see more notes below        
        'Dim i As Integer
        'Dim sPgTxt As String = String.Empty
        'For i = 0 To iNumWords - 1
        '    sPgTxt = sPgTxt + PDTxtSelect.GetText(i)
        'Next


        '' split the string on newlines,        
        '' put each line in array element        
        'Dim arPdfLines
        'arPdfLines = Split(sPgTxt, vbCrLf)

        'Dim FacilityName As String = String.Empty
        'Dim FacilityNum As String = arPdfLines(0).ToString.Trim
        'For i = 0 To UBound(arPdfLines)
        '    If arPdfLines(i).ToString.Contains("experience for") Then
        '        FacilityName = arPdfLines(i).ToString.Replace("Springboarding the patient experience forr", "")
        '        FacilityName = FacilityName.Replace("Springboarding the patient experience for", "")
        '    End If
        'Next

        'FacilityName = FacilityName.Replace("/", " ").Replace("\", " ")

        'PDDoc.Close()

        'Return FacilityName
        ' AA

    End Function

    Public Function GetEmailBody(ByVal RM As String)
        Dim formatedEmailBody As String
        Dim RMEmail As String = RM.Substring(0, 1).Trim & RM.Substring(RM.IndexOf(" ") + 1).Trim & "@nrcpicker.com"

        formatedEmailBody = EMailBody.Text
        formatedEmailBody = formatedEmailBody.Replace("[[RM]]", RM)
        formatedEmailBody = formatedEmailBody.Replace("[[RMEmail]]", RMEmail)

        Return formatedEmailBody
    End Function

    'Public Function GetEmailBodyJuly2010(ByVal RM As String) As String
    '    Dim EmailBody As String = String.Empty

    '    Dim RMEmail As String = RM.Substring(0, 1).Trim & RM.Substring(RM.IndexOf(" ") + 1).Trim & "@nrcpicker.com"

    '    EmailBody += "<span style='font-size:10.0pt;font-family:Arial'>" & vbCrLf

    '    EmailBody += "Hello!<p/>" & vbCrLf

    '    EmailBody += "The release of the HCAHPS national data for discharges from October 1, 2008 through September 30, 2009 is posted to the revised <a href=""http://www.hospitalcompare.hhs.gov/"">Hospital Compare</a> website. NRC Picker is excited to provide you with the attached HCAHPS Experience Report! The attached summary provides your patient-mix adjusted scores as seen on the Hospital Compare website. We are also pleased to offer both your national percentile rank and the score at the 90th percentile for each HCAHPS measure to assist your national placement determination.<p/> " & vbCrLf
    '    EmailBody += "We understand another area of interest is your position relative to hospitals within your state. Given this, we also provide the highest score achieved in your state for each measure and the names of all hospitals in the state achieving this score. <p/>" & vbCrLf
    '    EmailBody += "The HCAHPS measures are shown in order of your national percentile rank so you can easily rank and order your areas of success and improvement focus. <p/>" & vbCrLf
    '    EmailBody += "As always, your NRC Picker team is happy to assist in any way we can, please call us at 1-800-388-4264.<p/> " & vbCrLf

    '    EmailBody += "</span>"

    '    EmailBody += "<strong><span style='font-size:10.0pt;font-family:Helvetica'>" & RM & "</span></strong><br/>" & vbCrLf
    '    EmailBody += "<b><span style='font-size:8.0pt;font-family:Helvetica'>" & RMEmail.Replace(" ", "") & "</span></b><p/>" & vbCrLf

    '    EmailBody += "<span style='font-size:7.5pt;font-family:Helvetica'>"
    '    EmailBody += "<b><span style='color:#006B5B'>NRC Picker</span></b><br/>" & vbCrLf
    '    EmailBody += "<i>The world expert in patient-centered care.</i><br/>" & vbCrLf
    '    EmailBody += "------------------------------------------------------------------<br/>" & vbCrLf
    '    EmailBody += "<b>Measuring and improving the most important aspects of the<br/>" & vbCrLf
    '    EmailBody += "patient experience across the Continuum of Care.</b><p/>" & vbCrLf

    '    EmailBody += "1245 Q Street, Lincoln, NE  68508<br/>" & vbCrLf
    '    EmailBody += "phone: 402-475-2525  fax: 402-475-9061<br/>" & vbCrLf
    '    EmailBody += "toll free: 800-388-4264<br/>" & vbCrLf
    '    EmailBody += "NRCPicker.com</span><p/>" & vbCrLf
    '    EmailBody += "<p/><br><p/>" & vbCrLf

    '    EmailBody += "<span style='font-size:9pt;font-family:Helvetica'>Learn strategies to improve patient-centered care and network with the industry's best at NRC Picker's Annual Symposium. <a href=""http://www.nrcpicker.com/Events/Symposium/Pages/default.aspx"">Click here for more information</a>.</span><p/>" & vbCrLf

    '    Return EmailBody

    'End Function

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox1.CheckedChanged
        SendAllEmailsProd.Enabled = CheckBox1.Checked
    End Sub

    Public Function SendAllEmails(ByVal TestOrProd As String)

        If TestOrProd <> "Test" And TestOrProd <> "Prod" Then
            MsgBox("Invalid Envionment. Must be 'Test' or 'Prod'")
            Return False
        End If

        'Open Connections To The Source File
        Dim strConn1 As String = "Provider=Microsoft.Jet.OleDb.4.0;data source=" & Me.excelFile.Text & ";Extended Properties=""Excel 8.0;HDR=Yes;"""
        Dim objConn1 As New OleDbConnection(strConn1)
        objConn1.Open()

        'Create A New DataTable from the Source File
        Dim strSql1 As String = "Select * from [HCAHPS Experience Report Contac$]"
        Dim da1 As New OleDbDataAdapter(strSql1, objConn1)
        Me.mSpecialUpdateDataTable3.Reset()
        da1.Fill(mSpecialUpdateDataTable3)

        Dim i As Integer = 0

        For Each row As DataRow In mSpecialUpdateDataTable3.Rows

            If Not (TestOrProd = "Test" Or TestOrProd = "Prod") Then
                MsgBox("Invalid Envionment. Must be 'Test' or 'Prod'")
                Return False
            End If

            Me.ToolStripStatusLabel1.Text = "processing #" & i & " out of " & mSpecialUpdateDataTable3.Rows.Count.ToString
            Me.Refresh()

            'Determine Who The Email Is Sent To Based On Environment
            Dim TestContactEmail As String = String.Empty
            Dim ClientContactEmail As String = String.Empty

            Dim RM As String = row.Item("Relationship Manager").ToString.Replace("'", "''")
            Dim RMEmail As String = RM.Substring(0, 1).Trim & RM.Substring(RM.IndexOf(" ") + 1).Trim & "@nrcpicker.com"

            TestContactEmail = "NRCHCAHPS@nationalresearch.com," & RMEmail

            ClientContactEmail = row.Item("HCAHPS Experience Report Contact").ToString.Trim
            ClientContactEmail = ClientContactEmail.Substring(ClientContactEmail.IndexOf("(") + 1).Replace(")", "") 'Just the parenthetical part

            Dim Attachment As String = row.Item("Attachment").ToString.Replace("""", "")
            Dim ClientName As String = ""
            If Attachment.Trim <> "" Then ClientName = GetClientNameFromInsidePDF(Attachment)

            If ((ClientContactEmail.Trim <> "") And (Attachment.Trim <> "")) Then
                Dim SmtpServer As New SmtpClient()
                Dim emailMsg As New MailMessage()
                SmtpServer.Host = "smtp2.nationalresearch.com"
                SmtpServer.Credentials = New Net.NetworkCredential("NRCHCAHPS", "Summer08")
                emailMsg = New MailMessage()
                emailMsg.From = New MailAddress("NRCHCAHPS@nationalresearch.com")

                If TestOrProd = "Test" Then
                    emailMsg.To.Add(TestContactEmail)
                End If

                If TestOrProd = "Prod" Then
                    emailMsg.To.Add(ClientContactEmail)
                    emailMsg.Bcc.Add("NRCHCAHPS@nationalresearch.com") 'prod, do this
                    emailMsg.Bcc.Add(RMEmail) 'prod, do this
                End If

                emailMsg.Subject = "HCAHPS Experience Report for " & ClientName.Trim
                emailMsg.Body = GetEmailBody(RM) & "Sent To: " & ClientContactEmail & "</p>" & vbCrLf
                emailMsg.IsBodyHtml = True
                Dim attachFile As New Attachment(IO.Path.Combine(Me.pdfLocation.Text, Attachment))
                emailMsg.Attachments.Add(attachFile)
                SmtpServer.Send(emailMsg)
                i = i + 1
                Me.Refresh()
                Me.ToolStripStatusLabel1.Text = "Processed " & i & " out of " & mSpecialUpdateDataTable3.Rows.Count.ToString
                Me.Refresh()
            End If

        Next

        MsgBox("Done")
        Return True

    End Function

#End Region

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        FolderBrowserDialog1.Description = "Select Folder containing PDFs"
        FolderBrowserDialog1.ShowNewFolderButton = False
        'FolderBrowserDialog1.RootFolder = Me.pdfLocation.Text
        FolderBrowserDialog1.ShowDialog()

        pdfLocation.Text = FolderBrowserDialog1.SelectedPath

    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        OpenFileDialog1.Multiselect = False
        OpenFileDialog1.Filter = "Excel files|*.xls,*.xlsx|All files (*.*)|*.*"

        If Not String.IsNullOrEmpty(Me.excelFile.Text) Then
            If System.IO.File.Exists(Me.excelFile.Text) Then
                Dim fi As System.IO.FileInfo = New System.IO.FileInfo(Me.sourceFile.Text)
                OpenFileDialog1.InitialDirectory = fi.Directory.FullName
                OpenFileDialog1.FileName = fi.Name
            End If
        End If

        OpenFileDialog1.ShowDialog()

        excelFile.Text = OpenFileDialog1.FileName

    End Sub

    Private Sub pdfLocation_TextChange(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles pdfLocation.TextChanged

    End Sub

    Private Sub excelFile_TextChange(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles excelFile.TextChanged

    End Sub

    Private Sub EMailBody_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EMailBody.TextChanged

    End Sub

    Private Sub Form_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim _emailBody As String

        _emailBody = "<span style='font-size:10.0pt;font-family:Arial'>" & vbCrLf

        _emailBody += "Hello!<p/>" & vbCrLf

        _emailBody += "The release of the HCAHPS national data for discharges from October 1, 2008 through September 30, 2009 is posted to the revised <a href=""http://www.hospitalcompare.hhs.gov/"">Hospital Compare</a> website. NRC Picker is excited to provide you with the attached HCAHPS Experience Report! The attached summary provides your patient-mix adjusted scores as seen on the Hospital Compare website. We are also pleased to offer both your national percentile rank and the score at the 90th percentile for each HCAHPS measure to assist your national placement determination.<p/> " & vbCrLf
        _emailBody += "We understand another area of interest is your position relative to hospitals within your state. Given this, we also provide the highest score achieved in your state for each measure and the names of all hospitals in the state achieving this score. <p/>" & vbCrLf
        _emailBody += "The HCAHPS measures are shown in order of your national percentile rank so you can easily rank and order your areas of success and improvement focus. <p/>" & vbCrLf
        _emailBody += "As always, your NRC Picker team is happy to assist in any way we can, please call us at 1-800-388-4264.<p/> " & vbCrLf

        _emailBody += "</span>"

        _emailBody += "<strong><span style='font-size:10.0pt;font-family:Helvetica'>[[RM]]</span></strong><br/>" & vbCrLf
        _emailBody += "<b><span style='font-size:8.0pt;font-family:Helvetica'>[[RMEmail]]</span></b><p/>" & vbCrLf

        _emailBody += "<span style='font-size:7.5pt;font-family:Helvetica'>"
        _emailBody += "<b><span style='color:#006B5B'>NRC Picker</span></b><br/>" & vbCrLf
        _emailBody += "<i>The world expert in patient-centered care.</i><br/>" & vbCrLf
        _emailBody += "------------------------------------------------------------------<br/>" & vbCrLf
        _emailBody += "<b>Measuring and improving the most important aspects of the<br/>" & vbCrLf
        _emailBody += "patient experience across the Continuum of Care.</b><p/>" & vbCrLf

        _emailBody += "1245 Q Street, Lincoln, NE  68508<br/>" & vbCrLf
        _emailBody += "phone: 402-475-2525  fax: 402-475-9061<br/>" & vbCrLf
        _emailBody += "toll free: 800-388-4264<br/>" & vbCrLf
        _emailBody += "NRCPicker.com</span><p/>" & vbCrLf
        _emailBody += "<p/><br><p/>" & vbCrLf

        _emailBody += "<span style='font-size:9pt;font-family:Helvetica'>Learn strategies to improve patient-centered care and network with the industry's best at NRC Picker's Annual Symposium. <a href=""http://www.nrcpicker.com/Events/Symposium/Pages/default.aspx"">Click here for more information</a>.</span><p/>" & vbCrLf

        EMailBody.Text = _emailBody
    End Sub

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button3.Click

        OpenFileDialog1.Multiselect = False
        OpenFileDialog1.Filter = "PDF files|*.pdf|All files (*.*)|*.*"

        If Not String.IsNullOrEmpty(Me.sourceFile.Text) Then
            If System.IO.File.Exists(Me.sourceFile.Text) Then
                Dim fi As System.IO.FileInfo = New System.IO.FileInfo(Me.sourceFile.Text)
                OpenFileDialog1.InitialDirectory = fi.Directory.FullName
                OpenFileDialog1.FileName = fi.Name
            End If
        End If

        OpenFileDialog1.ShowDialog()

        Me.sourceFile.Text = OpenFileDialog1.FileName
    End Sub
End Class
