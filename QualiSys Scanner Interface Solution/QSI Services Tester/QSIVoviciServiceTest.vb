Imports System.Data
Imports System.IO
Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration


Public Class QSIVoviciServiceTest

#Region " Private Members "


#End Region

#Region "Run As Service Button Events"

    Private Sub StartButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartButton.Click

        Try
            'Instatiate the timer and start it
            'ServiceTimer.Interval = AppConfig.Params("QSIVoviciInterval").IntegerValue
            ServiceTimer.Interval = 10000
            ServiceTimer.Enabled = True

            'Lock buttons
            StartButton.Enabled = False
            PauseButton.Enabled = True
            ContinueButton.Enabled = False
            StopButton.Enabled = True

            'Display a message
            ServiceTextBox.Text = String.Format("Service Started at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)
            ServiceStatusLabel.Text = "Running"

        Catch ex As Exception
            'Log the error in the event log
            LogEvent("The QSI Vovici Service was unable to start!", ex, EventLogEntryType.Error)

            'Lock buttons
            StartButton.Enabled = True
            PauseButton.Enabled = False
            ContinueButton.Enabled = False
            StopButton.Enabled = False
            ServiceStatusLabel.Text = "Stopped"

        End Try

    End Sub

    Private Sub StopButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StopButton.Click

        'Pause the timer
        ServiceTimer.Enabled = False

        'Lock buttons
        StartButton.Enabled = True
        PauseButton.Enabled = False
        ContinueButton.Enabled = False
        StopButton.Enabled = False

        'Display a message
        ServiceTextBox.Text = String.Format("Service Stopped at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)
        ServiceStatusLabel.Text = "Stopped"

    End Sub

    Private Sub ContinueButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ContinueButton.Click

        'Start the timer
        ServiceTimer.Enabled = True

        'Lock buttons
        StartButton.Enabled = False
        PauseButton.Enabled = True
        ContinueButton.Enabled = False
        StopButton.Enabled = True

        'Display a message
        ServiceTextBox.Text = String.Format("Service Continued at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)
        ServiceStatusLabel.Text = "Running"

    End Sub

    Private Sub PauseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PauseButton.Click

        'Pause the timer
        ServiceTimer.Enabled = False

        'Lock buttons
        StartButton.Enabled = False
        PauseButton.Enabled = False
        ContinueButton.Enabled = True
        StopButton.Enabled = True

        'Display a message
        ServiceTextBox.Text = String.Format("Service Paused at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)
        ServiceStatusLabel.Text = "Paused"

    End Sub

    Private Sub RunNowButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunNowButton.Click

        'Display a message
        ServiceTextBox.Text = String.Format("RunNow Button at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)


        'Stop the timer
        ServiceTimer.Enabled = False

        'Check to see if there are any files to process
        CheckForOutboundWork()
        Dim curtime As DateTime

        If RadioButSystime.Checked = True Then
            curtime = DateTime.Now
        Else
            curtime = DateTimePicker.Value
        End If

        CheckForInboundWork(curtime)

        'Lock buttons
        StartButton.Enabled = True
        PauseButton.Enabled = False
        ContinueButton.Enabled = False
        StopButton.Enabled = False

    End Sub

#End Region

#Region "Timer Events"

    Private Sub ServiceTimer_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ServiceTimer.Tick

        ServiceTimer.Enabled = False

        'Check to see if run time
        Dim curTime As DateTime = Now
        Dim curTimePlusInterval As DateTime = curTime.AddMilliseconds((-1 * (AppConfig.Params("QSIVoviciInterval").IntegerValue + 1)))

        Dim outboundRunTimes() As String = AppConfig.Params("QSIVoviciOutboundRunTimes").StringValue.Split(",".ToCharArray)
        For Each runTime As String In outboundRunTimes
            Dim time As DateTime = DateAndTime.TimeValue(runTime)
            Dim checkDayTime As New DateTime(curTime.Year, curTime.Month, curTime.Day, time.Hour, time.Minute, time.Second)

            If DateTime.Compare(curTime, checkDayTime) >= 0 AndAlso DateTime.Compare(checkDayTime, curTimePlusInterval) >= 0 Then
                Debug.WriteLine(checkDayTime.ToString)
                Debug.WriteLine(curTime.ToString)
                Debug.WriteLine(curTimePlusInterval.ToString)

                'Check to see if there are any files to process
                CheckForOutboundWork()
                Exit For

            End If
        Next

        Dim inboundRunTimes() As String = AppConfig.Params("QSIVoviciInboundRunTimes").StringValue.Split(",".ToCharArray)
        For Each runTime As String In inboundRunTimes
            Dim time As DateTime = DateAndTime.TimeValue(runTime)
            Dim checkDayTime As New DateTime(curTime.Year, curTime.Month, curTime.Day, time.Hour, time.Minute, time.Second)

            If DateTime.Compare(curTime, checkDayTime) >= 0 AndAlso DateTime.Compare(checkDayTime, curTimePlusInterval) >= 0 Then
                Debug.WriteLine(checkDayTime.ToString)
                Debug.WriteLine(curTime.ToString)
                Debug.WriteLine(curTimePlusInterval.ToString)

                'Check to see if there are any inbound files to process
                CheckForInboundWork(checkDayTime)
                Exit For

            End If
        Next

        'When processing it complete restart the timer
        ServiceTimer.Enabled = True

    End Sub

#End Region

#Region "Private Methods"

    Private Sub CheckForOutboundWork()
        Dim IdVerintUS As Integer = AppConfig.Params("QSIVerint-US-VendorID").IntegerValue
        Dim IdVerintCA As Integer = AppConfig.Params("QSIVerint-CA-VendorID").IntegerValue

        'Dim projectDataInstances As New Dictionary(Of Integer, VoviciProjectData)
        'projectDataInstances = VoviciProjectData.VerintProjectDataInstances

        Dim Country As String = AppConfig.Params("Country").StringValue()

        Dim cultureCode As String

        Try
            'Get all approved (Status = 3) records from the Vendor File Creation Queue
            Dim files As VendorFileCreationQueueCollection = VendorFileCreationQueue.GetByVendorFileStatusId(VendorFileStatusCodes.Approved)

            For Each file As VendorFileCreationQueue In files
                Dim methStep As MethodologyStep = MethodologyStep.Get(file.MailingStepId)

                Dim supressPiiFromVovici As Boolean = ((Country = "CA") AndAlso (methStep.VendorID.Value = IdVerintUS)) Or (methStep.IsExcludePII)

                If (Country = "US") AndAlso (methStep.VendorID.Value = IdVerintCA) Then
                    Throw New Exception(String.Format("US Environment has attempted to use Verint-CA Instance!"))
                End If

                'Check to see if it is a Vovici web survey step
                If (methStep.StepMethodId = MailingStepMethodCodes.Web OrElse methStep.StepMethodId = MailingStepMethodCodes.MailWeb OrElse methStep.StepMethodId = MailingStepMethodCodes.LetterWeb) AndAlso methStep.VendorID.HasValue Then
                    If (methStep.VendorID.Value = IdVerintUS) Or
                       (methStep.VendorID.Value = IdVerintCA) Then

                        Try
                            'Get the project ID (Vovici's internal survey ID)
                            Dim projectId As Integer = methStep.VendorSurveyID
                            Dim errorList As New List(Of TranslatorError)
                            Dim bIsOtherError As Boolean = False
                            Dim sMalformedEmailErrorMessage As String = AppConfig.Params("QSIVoviciMalformedEmailErrorMessage").StringValue

                            'Get file's data records and loop through them
                            '2013-1203 Changing Strategy with the PII for Canada
                            'Will call the stored proc with a False, so that it doesn't hide the PII
                            'otherwise when we save the Participant back we loose the PII locally in Canada as well
                            'instead we will use the Country setting here to not pass in values to the Vovici API
                            Dim participants As VendorWebFile_DataCollection = VendorWebFile_Data.GetByVendorFileId(file.VendorFileId, False)
                            For Each participant As VendorWebFile_Data In participants
                                Try
                                    'Check to see if record has already been added to Vovici
                                    If Not participant.SentToVendor Then

                                        'Check to see if the participant has been added already
                                        Dim participantID As Long
                                        If participant.ExternalRespondentID.Trim = String.Empty Then
                                            'Add participant to Vocici
                                            Dim cultFromLangId As CultureToLanguage = CultureToLanguage.GetByLangId(participant.LangId)
                                            If cultFromLangId Is Nothing Then
                                                cultureCode = "en-US"   'Not found, default is English US
                                            Else
                                                cultureCode = cultFromLangId.CultureCode
                                            End If

                                            Dim emailForVovici As String
                                            If supressPiiFromVovici = True Then
                                                emailForVovici = AppConfig.Params("QSIVoviciCanadaSurveyEmailAddress").StringValue
                                            Else
                                                emailForVovici = participant.EmailAddr
                                            End If

                                            Try
                                                participantID = VoviciProjectData.VerintProjectDataInstances(methStep.VendorID.Value).AddParticipantToSurvey(projectId, emailForVovici, participant.WAC, Nothing, Nothing, cultureCode)
                                                participant.ExternalRespondentID = participantID.ToString
                                            Catch ex1 As Exception
                                                If ex1.Message.Contains(sMalformedEmailErrorMessage) Then

                                                    errorList.Add(New TranslatorError(participant.Id, participant.Litho, ex1.Message))

                                                    emailForVovici = "noreply@nationalresearch.com"
                                                    participantID = VoviciProjectData.VerintProjectDataInstances(methStep.VendorID.Value).AddParticipantToSurvey(projectId, emailForVovici, participant.WAC, Nothing, Nothing, cultureCode)
                                                    participant.ExternalRespondentID = participantID.ToString
                                                Else
                                                    Throw ex1
                                                End If
                                            End Try

                                        Else
                                            participantID = CLng(participant.ExternalRespondentID)
                                        End If

                                        'Add responses to the hidden personalization questions for participant
                                        VoviciProjectData.VerintProjectDataInstances(methStep.VendorID.Value).AddHiddenQuestionDataToSurveyForParticipant(projectId, participantID, participant, supressPiiFromVovici)


                                        'Mark successful
                                        participant.SentToVendor = True

                                    End If

                                Catch ex As Exception
                                    errorList.Add(New TranslatorError(participant.Id, participant.Litho, ex.Message))
                                    bIsOtherError = True
                                End Try
                            Next

                            'Save file participants
                            participants.Save()


                            If Not bIsOtherError Then
                                'All participants were successfully added to Vovici, mark file as sent.
                                file.VendorFileStatusId = VendorFileStatusCodes.Sent
                            End If


                            If errorList.Count > 0 Then
                                Dim errCount As Integer = errorList.Count
                                If errCount > 2500 Then
                                    errorList.RemoveRange(2500, errCount - 2500)
                                End If
                                Throw New InvalidFileException(String.Format("Process error(s) occurred, ({0}) records out of ({1}) did not process.  Will retry on next pass!", errCount.ToString, participants.Count.ToString), file.ArchiveFileName, errorList)
                            End If

                        Catch ex As Exception
                            Try
                                LogEvent(Translator.SendNotification(QSIServiceNames.QSIVoviciService, "Exception Encountered While Attempting to Process File!", ex, False), EventLogEntryType.Error)
                            Catch ex1 As Exception
                                'The Notification most likely got sent but we don't want an unhandled exception to be thrown here
                            End Try

                        End Try
                    End If
                End If
            Next

            Try
                'Save files
                files.Save()

            Catch ex As Exception
                LogEvent(Translator.SendNotification(QSIServiceNames.QSIVoviciService, "Exception Encountered While Attempting to Process File!", ex, False), EventLogEntryType.Error)

            End Try

        Catch ex As Exception
            'Send the notification
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIVoviciService, "Error encountered, unable to check for outbound work", ex, False), EventLogEntryType.Error)

        End Try

    End Sub

    Private Sub CheckVerintInstance(ByVal vendorId As Integer, ByVal endTime As DateTime)

        ServiceTextBox.Text = String.Format("CheckForInboundWork at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)

        Dim projectData As New VoviciProjectData
        projectData = VoviciProjectData.VerintProjectDataInstances(vendorId)

        Try
            'Get translator for Vovici
            Dim translatorMod As TranslationModule = TranslationModule.GetByVendorId(vendorId).Item(0)
            If translatorMod Is Nothing Then
                ServiceTextBox.Text = String.Format("No translation module set up for vendor Vovici ({0}).{1}{2}", vendorId.ToString, vbCrLf, ServiceTextBox.Text)
                Return
            End If

            'Make sure the folders exists
            If Not Directory.Exists(translatorMod.WatchedFolderPath) Then
                Directory.CreateDirectory(translatorMod.WatchedFolderPath)
            End If
            If Not Directory.Exists(String.Concat(translatorMod.WatchedFolderPath, "\NQL")) Then
                Directory.CreateDirectory(String.Concat(translatorMod.WatchedFolderPath, "\NQL"))
            End If

            'Get temp work directory
            Dim tempPath As String = AppConfig.Params("QSITransferTempFolder").StringValue

            'Connect to Vovici
            'projectData.Login()

            'Get NRC Picker active survey list and process
            Dim pattern As String = AppConfig.Params("QSIVoviciSurveyPattern").StringValue
            Dim activeSurveys As DataView = projectData.GetActiveSurveyList(String.Format("Name Like '{0}'", pattern))
            For Each survey As DataRowView In activeSurveys
                Dim projectID As Integer = CInt(survey("id"))
                Dim fileName As String = String.Concat(projectID.ToString, "_", endTime.ToString("yyyyMMdd_HHmmss"))

                Try
                    'Set start time
                    Dim startTime As DateTime = DateTime.MinValue
                    Dim voviciLog As VoviciDownloadLog = VoviciDownloadLog.GetBySurveyID(projectID.ToString.Trim)
                    If voviciLog Is Nothing Then
                        'First time processing survey
                        voviciLog = VoviciDownloadLog.NewVoviciDownloadLog
                        With voviciLog
                            .VoviciSurveyId = projectID.ToString.Trim
                            .datLastDownload = startTime
                        End With
                    Else
                        'We have to subtract 1 second to included this startTime time, which is the last run end time. Otherwise we could miss some records.
                        'Vovici gives back results after start time and up until the end time, start time and end time are not included.
                        startTime = voviciLog.datLastDownload.AddSeconds(-1)
                    End If

                    'Get survey's data map for report values
                    Dim dataMapXML As Xml.XmlNode = projectData.GetReportDataMap(projectID)

                    'Add additional system fields to the data map that are needed
                    Dim xmlDoc As New Xml.XmlDocument
                    xmlDoc.LoadXml(dataMapXML.OuterXml)

                    'Dim elem As Xml.XmlElement = xmlDoc.CreateElement("FieldMap")
                    'elem.SetAttribute("sourceField", "CULTURE")
                    'elem.SetAttribute("destinationField", "CULTURE")
                    'xmlDoc.DocumentElement.AppendChild(elem)

                    'elem = xmlDoc.CreateElement("FieldMap")
                    'elem.SetAttribute("sourceField", "COMPLETED")
                    'elem.SetAttribute("destinationField", "COMPLETED")
                    'xmlDoc.DocumentElement.AppendChild(elem)

                    'Get survey results
                    Dim results As DataSet = projectData.GetSurveyData(projectID, xmlDoc.OuterXml, Nothing, startTime.ToUniversalTime, endTime.ToUniversalTime, True)

                    If results.Tables(0).Rows.Count > 0 Then
                        'Display a message
                        ServiceTextBox.Text = String.Format("Starting File Create at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)

                        'Results found, translate into CSV file for transfer results

                        'Get question information about the survey from Vovici (column type, question core)
                        Dim translatorVovici As New TranslatorVovici(projectData.GetSurveyInformation(projectID))

                        'Use the culture column to determine how many files to make
                        'Qualisys languages all go into 1 file.
                        'Non-qualisys languages each go into their own seperate file.
                        Dim qualisysCultures As String = String.Empty
                        Dim nonQualisysCultures As New List(Of String)

                        For Each row As DataRow In results.Tables(0).Select("", "Culture")
                            If Not qualisysCultures.Contains(row("Culture").ToString.Trim) AndAlso Not nonQualisysCultures.Contains(row("Culture").ToString.Trim) Then
                                Dim cultFromLangId As CultureToLanguage = CultureToLanguage.GetByCultureCode(row("Culture").ToString.Trim)

                                If cultFromLangId Is Nothing OrElse Not cultFromLangId.IsQualisysLanguage Then
                                    'Those not in cross reference table are defaulted to nonqualisys languages
                                    nonQualisysCultures.Add(row("Culture").ToString.Trim)
                                Else
                                    qualisysCultures = String.Concat(qualisysCultures, "'", cultFromLangId.CultureCode.Trim, "',")
                                End If
                            End If
                        Next

                        Dim dv As New DataView(results.Tables(0))

                        If Not String.IsNullOrEmpty(qualisysCultures) Then
                            'Process Qualisys languages file.

                            'Remove end comma
                            qualisysCultures = qualisysCultures.Remove((qualisysCultures.Length - 1), 1)
                            dv.RowFilter = String.Concat("Culture IN (", qualisysCultures, ")")

                            translatorVovici.Translate(projectID, Path.Combine(tempPath, fileName), dv)

                            'Write out XML file
                            dv.ToTable.WriteXml(Path.Combine(translatorMod.WatchedFolderPath, String.Concat(fileName, ".xml")))

                            'Move CSV file to transfer results input folder
                            File.Move(Path.Combine(tempPath, String.Concat(fileName, ".csv")), Path.Combine(translatorMod.WatchedFolderPath, String.Concat(fileName, ".csv")))
                        End If

                        'Process Non-qualisys languages file(s).
                        For Each item As String In nonQualisysCultures
                            dv.RowFilter = String.Concat("Culture IN ('", item.ToString, "')")

                            translatorVovici.Translate(projectID, Path.Combine(tempPath, String.Concat(fileName, "_", item.ToString)), dv)

                            'Write out XML file
                            dv.ToTable.WriteXml(Path.Combine(translatorMod.WatchedFolderPath, String.Concat("NQL\", fileName, "_", item.ToString, ".xml")))

                            'Move CSV file to transfer results input folder
                            File.Move(Path.Combine(tempPath, String.Concat(fileName, "_", item.ToString, ".csv")), Path.Combine(translatorMod.WatchedFolderPath, String.Concat("NQL\", fileName, "_", item.ToString, ".csv")))

                            'Send notification
                            translatorVovici.SendNQLNotification(Path.Combine(translatorMod.WatchedFolderPath, String.Concat("NQL\", fileName, "_", item.ToString, ".csv")), String.Concat(fileName, "_", item.ToString, ".csv"), item.ToString)
                        Next

                        voviciLog.datLastDownload = endTime
                        voviciLog.Save()
                    End If

                Catch ex As Exception
                    LogEvent(Translator.SendNotification("QSI Vovici Service", String.Format("Exception Encountered While Attempting to Process Survey ({0})!", projectID.ToString), ex, False), EventLogEntryType.Error)

                    'Remove final output files if they happen to exist on failure.
                    FileCleanup(translatorMod.WatchedFolderPath, String.Concat(fileName, "*"))
                    FileCleanup(translatorMod.WatchedFolderPath, String.Concat("NQL\", fileName, "*"))

                Finally
                    'Remove working files if they're still there. Should only happen when process errors.
                    FileCleanup(tempPath, String.Concat(fileName, "*"))

                End Try
            Next

        Catch ex As Exception
            'Send the notification
            LogEvent(Translator.SendNotification("QSI Vovici Service", "Error encountered, unable to check for inbound work", ex, False), EventLogEntryType.Error)
        End Try

    End Sub

    Private Sub CheckForInboundWork(ByVal endTime As DateTime)

        CheckVerintInstance(AppConfig.Params("QSIVerint-US-VendorID").IntegerValue, endTime)

        Dim Country As String = AppConfig.Params("Country").StringValue()
        If Country = "CA" Then
            CheckVerintInstance(AppConfig.Params("QSIVerint-CA-VendorID").IntegerValue, endTime)
        End If

    End Sub

    Private Sub FileCleanup(ByVal folder As String, ByVal pattern As String)

        For Each fileName As String In Directory.GetFiles(folder, pattern)
            File.Delete(fileName)
        Next

    End Sub

    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        MessageBox.Show(eventData, My.Application.Info.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)

    End Sub

    Private Sub LogEvent(ByVal message As String, ByVal ex As Exception, ByVal entryType As EventLogEntryType)

        LogEvent(String.Format("{0}{1}{1}{2}{1}{1}Source: {3}{1}{1}Stack Trace:{1}{4}", message, vbCrLf, ex.Message, ex.Source, ex.StackTrace), entryType)

    End Sub

#End Region

End Class
