Imports Nrc.Framework.Configuration
Imports System.Data.SqlClient
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class MainForm

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim settings As New Nrc.Framework.Configuration.EnvironmentSettings

        Dim env As New Environment("Production")
        env.WebUrls.Add("www.nrcpicker.ca")
        env.WebUrls.Add("nrcpicker.com")
        env.EnvironmentType = EnvironmentType.Production
        env.Settings.Add(New Setting("SmtpServer", "smtp.nationalresearch.com"))
        env.Settings.Add(New Setting("DBInstance", "QualiSys Production"))
        settings.Environments.Add(env)

        env = New Environment("Testing")
        env.WebUrls.Add("dev.nrcpicker.com")
        env.EnvironmentType = EnvironmentType.Testing
        env.Settings.Add(New Setting("SmtpServer", "smtp.nationalresearch.com"))
        env.Settings.Add(New Setting("DBInstance", "QualiSys Test"))
        settings.Environments.Add(env)

        env = New Environment("Development")
        env.WebUrls.Add("localhost")
        env.WebUrls.Add("jcamp")
        env.EnvironmentType = EnvironmentType.Development
        env.Settings.Add(New Setting("SmtpServer", "smtp.nationalresearch.com"))
        env.Settings.Add(New Setting("DBInstance", "QualiSys Test"))
        env.Settings(1).Value = env.Settings(1).CipherValue
        env.Settings(1).IsEncrypted = True
        settings.Environments.Add(env)

        settings.GlobalSettings.Add(New Setting("LogEvents", "True"))
        settings.UseUrlDetection = True
        settings.CurrentEnvironmentName = "Testing"


        Dim xml As String = settings.Serialize
        OutputText.Text = xml
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        OutputText.Text = ""
        OutputText.AppendText(String.Format("Environment Name = {0}{1}", AppConfig.EnvironmentName, vbCrLf))
        OutputText.AppendText(String.Format("Environment Type = {0}{1}", AppConfig.EnvironmentType, vbCrLf))
        OutputText.AppendText(String.Format("SmptServer = {0}{1}", AppConfig.SMTPServer, vbCrLf))
    End Sub

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button3.Click
        Dim crypto As Nrc.Framework.Security.CryptoHelper
        Dim key() As Byte = New Byte() {1, 2, 3, 4, 5, 6, 7, 8} ', 9, 10, 11, 12, 13, 14, 15, 16} ', 17, 18, 19, 20, 21, 22, 23, 24}
        Dim vector() As Byte = New Byte() {1, 2, 3, 4, 5, 6, 7, 8} ', 9, 10, 11, 12, 13, 14, 15, 16}
        crypto = Nrc.Framework.Security.CryptoHelper.CreateRC2CryptoHelper(key, vector)

        Dim plainText As String
        Dim cipherText As String

        plainText = ""
        cipherText = crypto.EncryptString(plainText)
        MessageBox.Show(cipherText)

        plainText = ""
        plainText = crypto.DecryptString(cipherText)
        MessageBox.Show(plainText)
    End Sub

    Private Sub Button5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button5.Click
        Dim sw As New Stopwatch
        Try
            Me.Cursor = Cursors.WaitCursor
            Using con As New SqlConnection(Me.DataSourceText.Text)
                Using cmd As SqlCommand = con.CreateCommand
                    cmd.CommandType = CommandType.Text
                    cmd.CommandText = SqlText.Text
                    con.Open()
                    Using rdr As IDataReader = cmd.ExecuteReader
                        sw.Start()

                        Dim writer As DataWriter = Nothing
                        Select Case Me.FileTypeList.SelectedItem.ToString
                            Case "DBF"
                                writer = New DbfWriter(rdr)
                            Case "CSV"
                                writer = New CsvWriter(rdr)
                            Case "Excel"
                                writer = New ExcelWriter(rdr)
                        End Select

                        For Each col As DataWriterColumn In writer.Columns
                            If Not col.Name.ToUpper.StartsWith("Q0") Then
                                col.IsMasterColumn = True
                            End If
                        Next

                        writer.Write(ExportPath.Text)

                        'Dim exporter As New DBFExporterOleDb(rdr, ExportPath.Text)
                        'exporter.ExportData()

                        sw.Stop()
                    End Using
                    con.Close()
                End Using
            End Using
        Finally
            Me.Cursor = Me.DefaultCursor
            MessageBox.Show("File exported in " & sw.Elapsed.ToString)
        End Try

    End Sub

    Private Sub Button6_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button6.Click

        Dim msg As New Nrc.Framework.Notification.Message(AppConfig.SMTPServer)

        With msg
            .From = New Nrc.Framework.Notification.Address("jfleming@nationalresearch.com", "Jeffrey J. Fleming")
            .To.Add("jfleming@nationalresearch.com")
            .Subject = "Normal Email Test Message"
            .BodyText = "This is a test of the text body"
            .BodyHtml = "<b>This is a <i>TEST</i> of the HTML body</b>"

            If .Send() Then
                MsgBox("It worked")
            Else
                MsgBox("It failed")
            End If
        End With

    End Sub

    Private Sub Button7_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button7.Click

        Dim msg As New Nrc.Framework.Notification.Message("InternalUploadFile", AppConfig.SMTPServer)

        Dim enviro As String = String.Empty
        If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
            enviro = String.Format("({0})", AppConfig.EnvironmentName)
        End If

        With msg
            .From = New Nrc.Framework.Notification.Address("jfleming@nationalresearch.com", "")
            .To.Add("jfleming@nationalresearch.com")
            .Cc.Add("jfleming@nationalresearch.com")

            With .ReplacementValues
                .Add("ClientID", "4")
                .Add("ClientName", "Dana Don't Care Center")
                .Add("UserName", "Jeff Fleming")
                .Add("EmailTo", "jfleming@nationalresearch.com")
                .Add("UploadDate", "6/10/2008 4:17:02 PM")
                .Add("UploadFile", "MyFile.txt")
                .Add("Folder", "C:\Testing\")
                .Add("FileType", "HelpMe")
                .Add("Status", "Successful")
                .Add("Notes", "This is the main file for the month of May")
                .Add("Environment", enviro)
            End With

            'Create the table
            Dim table As New DataTable
            table.Columns.Add(New DataColumn("PackagePM"))
            table.Columns.Add(New DataColumn("StudyID"))
            table.Columns.Add(New DataColumn("StudyName"))
            table.Rows.Add("Jeff Fleming", "27", "JeffStudy")
            table.Rows.Add("Tony Picolli", "34", "TonyStudy")

            With .ReplacementTables
                .Add("Packages_Text", table)
                .Add("Packages_Html", table)
            End With

            If .Send() Then
                MsgBox("It worked")
            Else
                MsgBox("It failed")
            End If

        End With

    End Sub

    Private Sub TestExceptionButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TestExceptionButton.Click

        Dim rpt As New Nrc.Framework.WinForms.ExceptionReport(New Exception("Holy Shit Dude"))
        rpt.ReportSender = "JFleming"
        rpt.ReportSubject = My.Application.Info.ProductName & " Exception Report"
        rpt.SMTPServer = AppConfig.SMTPServer
        rpt.ShowException("Test Exception", True, False)

    End Sub

End Class