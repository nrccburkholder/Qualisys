Imports System.IO
Imports System.Data
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.QualiSys.Library
Imports Tamir.SharpSsh
Imports Nrc.Framework.Notification

Public Class QueuedVendorFile

#Region "Private Members"

    Private mVendorFile As VendorFileCreationQueue
    Private mVendor As Vendor
    Private mMethodologyStep As MethodologyStep
    Private mTelematchLog As VendorFileTelematchLog
    Private mTelematchOverdue As Boolean
    Private mException As Exception

#End Region

#Region "Constructors"

    Public Sub New(ByVal vendorFile As VendorFileCreationQueue, ByVal vendor As Vendor, ByVal methStep As MethodologyStep)

        mVendorFile = vendorFile
        mVendor = vendor
        mMethodologyStep = methStep
        mTelematchLog = Nothing

    End Sub

    Public Sub New(ByVal vendorFile As VendorFileCreationQueue, ByVal vendor As Vendor, ByVal methStep As MethodologyStep, ByVal log As VendorFileTelematchLog)

        mVendorFile = vendorFile
        mVendor = vendor
        mMethodologyStep = methStep
        mTelematchLog = log

    End Sub

#End Region

#Region "Public Properties"

    Public ReadOnly Property VendorFile() As VendorFileCreationQueue
        Get
            Return mVendorFile
        End Get
    End Property

    Public ReadOnly Property Vendor() As Vendor
        Get
            Return mVendor
        End Get
    End Property

    Public ReadOnly Property MethodologyStep() As MethodologyStep
        Get
            Return mMethodologyStep
        End Get
    End Property

    Public ReadOnly Property TelematchLog() As VendorFileTelematchLog
        Get
            Return mTelematchLog
        End Get
    End Property

    Public ReadOnly Property TelematchOverdue() As Boolean
        Get
            Return mTelematchOverdue
        End Get
    End Property

    Public ReadOnly Property Ex() As Exception
        Get
            Return mException
        End Get
    End Property

#End Region

#Region "Public Methods"

    Public Sub SendCSVFileToTelematch()

        Dim fileName As String = String.Empty
        Dim archiveName As String = String.Empty

        Try
            'Get the data to be written
            Dim fileDataTable As DataTable = VendorFileCreationQueue.GetVendorFileData(mVendorFile.VendorFileId)

            'Log the telematch event so we can get the ID
            mTelematchLog = VendorFileTelematchLog.NewVendorFileTelematchLog
            With mTelematchLog
                .VendorFileId = mVendorFile.VendorFileId
                .Save()
            End With

            'We are sending the file for telematching so name it the VendorFileTelematchLogId
            fileName = GetTelematchFileName()
            archiveName = Path.Combine(AppConfig.Params("QSIVendorFileArchiveFolder").StringValue, fileName)

            'Create the file
            DataWriter.WriteCsv(fileDataTable, archiveName)

            'Force garbage collection so the files get flushed and closed
            System.GC.Collect()

            'FTP the file to telematch
            Dim host As String = AppConfig.Params("QSIVendorFileTelematchSFTPHost").StringValue
            Dim username As String = AppConfig.Params("QSIVendorFileTelematchSFTPUser").StringValue
            Dim password As String = AppConfig.Params("QSIVendorFileTelematchSFTPPassword").StringValue
            Dim sshCp As SshTransferProtocolBase = New Sftp(host, username, password)
            With sshCp
                .Connect()
                .Put(archiveName, AppConfig.Params("QSIVendorFileTelematchSFTPFolder").StringValue & fileName)
                .Close()
            End With

            'Update the log entry
            With mTelematchLog
                .DateSent = Date.Now
                .Save()
            End With

            'Update the VendorFileCreationQueue record
            With mVendorFile
                .ArchiveFileName = archiveName
                .DateFileCreated = Date.Now
                .VendorFileStatusId = VendorFileStatusCodes.Telematching
                .Save()
            End With

        Catch ex As Exception
            'We have encountered an error so let's record it
            mException = ex

            'Cleanup the log record
            If mTelematchLog IsNot Nothing Then
                VendorFileTelematchLogProvider.Instance.DeleteVendorFileTelematchLog(mTelematchLog)
                mTelematchLog = Nothing
            End If

            'Cleanup the archive file
            If Not String.IsNullOrEmpty(archiveName) Then
                If System.IO.File.Exists(archiveName) Then
                    Try
                        System.IO.File.Delete(archiveName)

                    Catch
                        'We were unable to delete the file
                        '  We are not going to do anything about this at this time
                    End Try
                End If
            End If

        End Try

    End Sub

    Public Sub SendCSVFileToVendor()

        Dim fileName As String = String.Empty
        Dim fullName As String = String.Empty
        Dim archiveName As String = String.Empty

        Try
            'Get the data to be written
            Dim fileDataTable As DataTable = VendorFileCreationQueue.GetVendorFileData(mVendorFile.VendorFileId)

            'Determine the filename
            fileName = GetFileName(".csv")
            fullName = Path.Combine(Path.Combine(Path.Combine(AppConfig.Params("QSIVendorFileOutboundRootFolder").StringValue, mVendor.LocalFTPLoginName), "outbound"), fileName)
            archiveName = Path.Combine(AppConfig.Params("QSIVendorFileArchiveFolder").StringValue, String.Format("{0}_{1}", mVendorFile.VendorFileId.ToString, fileName))

            'Create the file
            DataWriter.WriteCsv(fileDataTable, fullName)

            'Copy the file to the archive folder
            DataWriter.WriteCsv(fileDataTable, archiveName)

            'Force garbage collection so the files get flushed and closed
            System.GC.Collect()

            'Update the VendorFileCreationQueue record
            With mVendorFile
                .ArchiveFileName = archiveName
                .DateFileCreated = Date.Now
                .VendorFileStatusId = VendorFileStatusCodes.Sent
                .Save()
            End With

        Catch ex As Exception
            'We have encountered an error so let's record it
            mException = ex

        End Try

    End Sub

    Public Sub SendXLSFileToVendor()

        Dim fileName As String = String.Empty
        Dim fullName As String = String.Empty
        Dim archiveName As String = String.Empty

        Try
            'Get the data to be written
            Dim fileDataTable As DataTable = VendorFileCreationQueue.GetVendorFileData(mVendorFile.VendorFileId)

            'Determine the file name
            fileName = GetFileName(".xls")
            fullName = Path.Combine(Path.Combine(Path.Combine(AppConfig.Params("QSIVendorFileOutboundRootFolder").StringValue, mVendor.LocalFTPLoginName), "outbound"), fileName)
            archiveName = Path.Combine(AppConfig.Params("QSIVendorFileArchiveFolder").StringValue, String.Format("{0}_{1}", mVendorFile.VendorFileId.ToString, fileName))

            'Create the file
            DataWriter.WriteExcel(fileDataTable, fullName)

            'Copy the file to the archive folder
            DataWriter.WriteExcel(fileDataTable, archiveName)

            'Force garbage collection so the files get flushed and closed
            System.GC.Collect()

            'Update the VendorFileCreationQueue record
            With mVendorFile
                .ArchiveFileName = archiveName
                .DateFileCreated = Date.Now
                .VendorFileStatusId = VendorFileStatusCodes.Sent
                .Save()
            End With

        Catch ex As Exception
            'We have encountered an error so let's record it
            mException = ex

        End Try

    End Sub

    Public Sub SendTelematchedFileToVendor(ByVal convertToXLS As Boolean)

        Dim fileName As String = String.Empty
        Dim fullName As String = String.Empty
        Dim archiveName As String = String.Empty
        Dim inProcessFolder As String = String.Empty

        Try
            'Get the file object for the telematched file
            Dim file As FileInfo = New FileInfo(Path.Combine(AppConfig.Params("QSIVendorFileTelematchInboundFolder").StringValue, GetTelematchFileName()))

            'Check to see if the file exists at the drop point
            If Not file.Exists() Then
                'The file is not at the drop point yet so lets see if it is time to send a warning email
                If Math.Abs(DateAndTime.DateDiff(DateInterval.Hour, mTelematchLog.DateSent, Date.Now)) > AppConfig.Params("QSIVendorFileTelematchAgeInHoursEmail").IntegerValue Then
                    'It has been more than the specified time for the file to be returned so let's send an email
                    mTelematchOverdue = True

                    'Send notification that we haven't received a response to a file sent to telematch.
                    If (Date.Now - mTelematchLog.DateOverdueNoticeSent).Days >= 1 Then
                        SendOverdueTelematchNotification()
                        mTelematchLog.DateOverdueNoticeSent = Date.Now
                        mTelematchLog.Save()
                    End If
                End If

                'The file is not there so we are out of here
                Exit Sub
            End If

            'The file exists so let's move it to a working folder
            MoveToInProcess(file)
            inProcessFolder = file.DirectoryName

            'Read the file in as a datatable
            Dim fileDataTable As DataTable = QueuedVendorFileProvider.Instance.GetDataTable(file.FullName)

            'Check to see if the file needs to be reformatted
            If convertToXLS Then
                'Determine the file name
                fileName = GetFileName(".xls")
                fullName = Path.Combine(Path.Combine(Path.Combine(AppConfig.Params("QSIVendorFileOutboundRootFolder").StringValue, mVendor.LocalFTPLoginName), "outbound"), fileName)
                archiveName = Path.Combine(AppConfig.Params("QSIVendorFileArchiveFolder").StringValue, String.Format("{0}_{1}", mVendorFile.VendorFileId.ToString, fileName))

                'Write the file as an Excel file to the vendors folder location
                DataWriter.WriteExcel(fileDataTable, fullName)

                'Copy the file to the archive folder
                DataWriter.WriteExcel(fileDataTable, archiveName)

                'Force garbage collection so the files get flushed and closed
                System.GC.Collect()
            Else
                'Determine the file name
                fileName = GetFileName(".csv")
                fullName = Path.Combine(Path.Combine(Path.Combine(AppConfig.Params("QSIVendorFileOutboundRootFolder").StringValue, mVendor.LocalFTPLoginName), "outbound"), fileName)
                archiveName = Path.Combine(AppConfig.Params("QSIVendorFileArchiveFolder").StringValue, String.Format("{0}_{1}", mVendorFile.VendorFileId.ToString, fileName))

                'Move the file to the archive folder
                If System.IO.File.Exists(archiveName) Then
                    System.IO.File.Delete(archiveName)
                End If
                file.MoveTo(archiveName)

                'Copy the file from the archive folder to the vendor folder
                If System.IO.File.Exists(fullName) Then
                    System.IO.File.Delete(fullName)
                End If
                file.CopyTo(fullName)
            End If

            'Delete the CSV file in the Working folder
            CleanupInProcess(inProcessFolder)

            'Determine the quantity of cleaned records
            Dim dataRows As DataRow() = fileDataTable.Select("TeleMatch IS NOT NULL")

            'Log receipt from Telematch
            With mTelematchLog
                .DateReturned = Date.Now
                .RecordsReturned = dataRows.Length
                .Save()
            End With

            'Update the VendorFileCreationQueue record
            With mVendorFile
                .ArchiveFileName = archiveName
                .DateFileCreated = Date.Now
                .VendorFileStatusId = VendorFileStatusCodes.Sent
                .Save()
            End With

        Catch ex As Exception
            'We have encountered an error so let's record it
            mException = ex

        End Try

    End Sub

    Public Function ExceptionString(ByVal isHtml As Boolean) As String

        Dim errMessage As String = String.Empty

        If isHtml Then
            'Add the message
            errMessage = mException.Message.Replace(vbCrLf, "<BR>")

            'Add the stack trace
            If mException.StackTrace IsNot Nothing Then
                Dim stack As String = mException.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at")
                If (stack.StartsWith("<BR>&nbsp;&nbsp;at")) Then
                    stack = stack.Substring("<BR>".Length)
                End If
                errMessage &= "<BR><BR>--------Stack Trace--------<BR>" & stack
            End If

            'Add the inner exceptions
            If mException.InnerException IsNot Nothing Then
                Dim innerEx As Exception = mException.InnerException
                Dim innerMessage As String = String.Empty
                Do While innerEx IsNot Nothing
                    If innerMessage.Length > 0 Then
                        innerMessage &= "<BR>"
                    End If

                    If innerEx.Message IsNot Nothing OrElse innerEx.StackTrace IsNot Nothing Then
                        innerMessage &= "--------Inner Exception--------" & "<BR>"
                        If innerEx.Message IsNot Nothing Then
                            innerMessage &= innerEx.Message.Replace(vbCrLf, "<BR>") & "<BR>"
                        End If
                        If innerEx.StackTrace IsNot Nothing Then
                            innerMessage &= innerEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at") & "<BR>"
                        End If
                    End If

                    'Prepare for next pass
                    innerEx = innerEx.InnerException
                Loop
                errMessage &= "<BR><BR>" & innerMessage
            End If
        Else
            'Add the message
            errMessage = mException.Message

            'Add the stack trace
            If mException.StackTrace IsNot Nothing Then
                errMessage &= String.Format("{0}{0}--------Stack Trace--------{0}{1}", vbCrLf, mException.StackTrace)
            End If

            'Add the inner exceptions
            If mException.InnerException IsNot Nothing Then
                Dim innerEx As Exception = mException.InnerException
                Dim innerMessage As String = String.Empty
                Do While innerEx IsNot Nothing
                    If innerMessage.Length > 0 Then
                        innerMessage &= vbCrLf
                    End If

                    If innerEx.Message IsNot Nothing OrElse innerEx.StackTrace IsNot Nothing Then
                        innerMessage &= "--------Inner Exception--------" & vbCrLf
                        If innerEx.Message IsNot Nothing Then
                            innerMessage &= innerEx.Message & vbCrLf
                        End If
                        If innerEx.StackTrace IsNot Nothing Then
                            innerMessage &= innerEx.StackTrace & vbCrLf
                        End If
                    End If

                    'Prepare for next pass
                    innerEx = innerEx.InnerException
                Loop
                errMessage &= vbCrLf & vbCrLf & innerMessage
            End If
        End If

        Return errMessage

    End Function

#End Region

#Region " Private Methods "

    Private Function GetFileName(ByVal extension As String) As String

        'Get the client name
        Dim clientName As String = String.Empty
        With mVendorFile.Client.Name.Trim
            If .Length > 15 Then
                clientName = .Substring(0, 15)
            ElseIf .Length > 0 Then
                clientName = .Substring(0, .Length)
            End If
        End With

        'Get the dates
        Dim dateStart As String = "NoDate"
        Dim dateEnd As String = "NoDate"
        With mVendorFile.SampleSet
            If .DateRangeFrom.HasValue Then
                dateStart = .DateRangeFrom.Value.ToString("MMddyy")
            End If
            If .DateRangeTo.HasValue Then
                dateEnd = .DateRangeTo.Value.ToString("MMddyy")
            End If
        End With

        'Build the file name
        Dim fileName As String = String.Format("{0}_{1}_{2}_{3}_{4}{5}", _
                                               clientName, _
                                               mVendorFile.Study.Name.Trim, _
                                               mVendorFile.Survey.Name.Trim, _
                                               dateStart, _
                                               dateEnd, _
                                               extension)

        Return Nrc.Framework.IO.Path.CleanFileName(fileName).Replace(" ", "_")

    End Function

    Private Function GetTelematchFileName() As String

        Return String.Format("{0}_Telematch.txt", mTelematchLog.Id.ToString)

    End Function

    Private Sub MoveToInProcess(ByRef file As FileInfo)

        Dim tempPath As String = Path.Combine(AppConfig.Params("QSIVendorFileInProcessFolder").StringValue, Format(Now(), "yyyyMMdd HHmmssff"))

        'Make sure the folder exists
        If Not Directory.Exists(tempPath) Then
            Directory.CreateDirectory(tempPath)
        End If

        'Move the file
        file.MoveTo(Path.Combine(tempPath, file.Name))
        mVendorFile.InProcessFileName = file.FullName

    End Sub

    Private Sub CleanupInProcess(ByRef folder As String)

        'Delete all of the files in the folder
        For Each filename As String In Directory.GetFiles(folder)
            System.IO.File.Delete(filename)
        Next

        'Delete the folder
        Directory.Delete(folder)

    End Sub

    Private Function SendOverdueTelematchNotification() As String

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environmentName As String = String.Empty

        Try
            'If we are still here then create and send an email
            'Determine who the recipients are going to be
            toList.Add("eDDFiles@NRCPicker.com")

            'Determine recipients bases on the environment
            If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
                'We are not in production
                'Add the real recipients to the note
                recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
                For Each email As String In toList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
                For Each email As String In ccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production BCC:{0}", vbCrLf)
                For Each email As String In bccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR>")

                'Clear the lists
                toList.Clear()
                ccList.Clear()
                bccList.Clear()

                'Populate the toList with the Testing group only
                toList.Add("Testing@NRCPicker.com")

                'Set the environment string
                environmentName = String.Format("({0})", AppConfig.EnvironmentName)
            End If

            'Create the message object
            Dim msg As Message = New Message("QSITelematchOverdueNotice", AppConfig.SMTPServer)

            'Set the message properties
            With msg
                'To recipient
                For Each email As String In toList
                    .To.Add(email)
                Next

                'Cc recipient
                For Each email As String In ccList
                    .Cc.Add(email)
                Next

                'Bcc recipient
                For Each email As String In bccList
                    .Bcc.Add(email)
                Next

                'Add the replacement values
                With .ReplacementValues
                    .Add("Environment", environmentName)
                    .Add("FileName", mVendorFile.ArchiveFileName)
                    .Add("FileId", mVendorFile.VendorFileId.ToString)
                    .Add("ClientName", mVendorFile.Client.Name)
                    .Add("ClientId", mVendorFile.Client.Id.ToString)
                    .Add("Study", mVendorFile.Study.Name)
                    .Add("StudyId", mVendorFile.Study.Id.ToString)
                    .Add("Survey", mVendorFile.Survey.Name)
                    .Add("SurveyId", mVendorFile.Survey.Id.ToString)
                    .Add("MethStep", mMethodologyStep.Name)
                    .Add("TelematchLogId", mTelematchLog.Id.ToString)
                    .Add("SampleSetId", mVendorFile.SampleSet.Id.ToString)
                    .Add("SampleDate", mVendorFile.SampleSet.DateCreated.ToShortDateString)
                    .Add("EncounterDates", String.Concat(mVendorFile.SampleSet.SampleStartDate.ToShortDateString, " - ", mVendorFile.SampleSet.SampleEndDate.ToShortDateString))
                    .Add("DateCreated", mVendorFile.DateDataCreated.ToShortDateString)
                    .Add("TelematchSentDate", mTelematchLog.DateSent.ToShortDateString)
                End With

            End With

            'Merge the template
            msg.MergeTemplate()

            'Get the body text
            Dim bodyText As String = msg.BodyText

            'Send the message
            msg.Send()

            'Return the body text
            Return bodyText

        Catch ex As Exception
            'Return this exception
            Return String.Format("Exception encountered while attempting to send Telematch Overdue Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}", vbCrLf, ex.Message, ex.Source, ex.StackTrace)

        End Try

    End Function
#End Region

#Region " Public Shared Methods "

    Public Shared Function SendNotification(ByVal toTelematchFiles As QueuedVendorFileCollection, ByVal toVendorFiles As QueuedVendorFileCollection, ByVal fromTelematchFiles As QueuedVendorFileCollection) As String

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environmentName As String = String.Empty
        Dim successVendorFiles As DataTable
        Dim failedVendorFilesText As DataTable
        Dim failedVendorFilesHtml As DataTable
        Dim successTelematchFiles As DataTable
        Dim failedTelematchFilesText As DataTable
        Dim failedTelematchFilesHtml As DataTable
        Dim successTeleVendorFiles As DataTable
        Dim failedTeleVendorFilesText As DataTable
        Dim failedTeleVendorFilesHtml As DataTable

        Try
            'Populate the tables for the different types of information
            successVendorFiles = CreateDataTable(TableTypes.SuccessVendor, toVendorFiles, False)
            failedVendorFilesText = CreateDataTable(TableTypes.FailedVendor, toVendorFiles, False)
            failedVendorFilesHtml = CreateDataTable(TableTypes.FailedVendor, toVendorFiles, True)
            successTelematchFiles = CreateDataTable(TableTypes.SuccessTelematch, toTelematchFiles, False)
            failedTelematchFilesText = CreateDataTable(TableTypes.FailedTelematch, toTelematchFiles, False)
            failedTelematchFilesHtml = CreateDataTable(TableTypes.FailedTelematch, toTelematchFiles, True)
            successTeleVendorFiles = CreateDataTable(TableTypes.SuccessTelematchToVendor, fromTelematchFiles, False)
            failedTeleVendorFilesText = CreateDataTable(TableTypes.FailedTelematchToVendor, fromTelematchFiles, False)
            failedTeleVendorFilesHtml = CreateDataTable(TableTypes.FailedTelematchToVendor, fromTelematchFiles, True)

            'Determine if we are going to send an email
            If successVendorFiles.Rows.Count + failedVendorFilesHtml.Rows.Count + successTelematchFiles.Rows.Count + failedTelematchFilesHtml.Rows.Count + successTeleVendorFiles.Rows.Count + failedTeleVendorFilesHtml.Rows.Count = 0 Then
                'Everything has a zero count so we do not need to send the email
                Return "There were no files in the queue to create."
            End If

            'If we are still here then create and send an email
            'Determine who the recipients are going to be
            toList.Add("NonMailGen@NRCPicker.com")
            ccList.Add("MeasurementServices-CA@NRCPicker.com")
            ccList.Add("MeasurementServices-LM@NRCPicker.com")
            ccList.Add("MeasurementServices-SB@NRCPicker.com")

            If failedVendorFilesText.Rows.Count > 0 OrElse failedTelematchFilesText.Rows.Count > 0 OrElse failedTeleVendorFilesText.Rows.Count > 0 Then
                ccList.Add("Testing@NRCPicker.com")
            End If

            'Determine recipients based on the environment
            If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
                'We are not in production
                'Add the real recipients to the note
                recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
                For Each email As String In toList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
                For Each email As String In ccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production BCC:{0}", vbCrLf)
                For Each email As String In bccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR>")

                'Clear the lists
                toList.Clear()
                ccList.Clear()
                bccList.Clear()

                'Populate the toList with the Testing group only
                toList.Add("Testing@NRCPicker.com")

                'Set the environment string
                environmentName = String.Format("({0})", AppConfig.EnvironmentName)
            End If

            'Create the message object
            Dim msg As Message = New Message("QSIVendorFilesSent", AppConfig.SMTPServer)

            'Set the message properties
            With msg
                'To recipient
                For Each email As String In toList
                    .To.Add(email)
                Next

                'Cc recipient
                For Each email As String In ccList
                    .Cc.Add(email)
                Next

                'Bcc recipient
                For Each email As String In bccList
                    .Bcc.Add(email)
                Next

                'Add the replacement values
                With .ReplacementValues
                    .Add("Environment", environmentName)
                    .Add("ReportDate", DateTime.Now.ToString)
                    .Add("RecipientNoteText", recipientNoteText)
                    .Add("RecipientNoteHtml", recipientNoteHtml)
                    .Add("QtySuccessVendorFiles", successVendorFiles.Rows.Count.ToString)
                    .Add("QtyFailedVendorFiles", failedVendorFilesHtml.Rows.Count.ToString)
                    .Add("QtySuccessTelematchFiles", successTelematchFiles.Rows.Count.ToString)
                    .Add("QtyFailedTelematchFiles", failedTelematchFilesHtml.Rows.Count.ToString)
                    .Add("QtySuccessTeleVendorFiles", successTeleVendorFiles.Rows.Count.ToString)
                    .Add("QtyFailedTeleVendorFiles", failedTeleVendorFilesHtml.Rows.Count.ToString)
                End With

                'Add the replacement tables
                With .ReplacementTables
                    .Add("SuccessVendorFiles_Text", successVendorFiles)
                    .Add("SuccessVendorFiles_Html", successVendorFiles)
                    .Add("FailedVendorFiles_Text", failedVendorFilesText)
                    .Add("FailedVendorFiles_Html", failedVendorFilesHtml)
                    .Add("SuccessTelematchFiles_Text", successTelematchFiles)
                    .Add("SuccessTelematchFiles_Html", successTelematchFiles)
                    .Add("FailedTelematchFiles_Text", failedTelematchFilesText)
                    .Add("FailedTelematchFiles_Html", failedTelematchFilesHtml)
                    .Add("SuccessTeleVendorFiles_Text", successTeleVendorFiles)
                    .Add("SuccessTeleVendorFiles_Html", successTeleVendorFiles)
                    .Add("FailedTeleVendorFiles_Text", failedTeleVendorFilesText)
                    .Add("FailedTeleVendorFiles_Html", failedTeleVendorFilesHtml)
                End With
            End With

            'Merge the template
            msg.MergeTemplate()

            'Get the body text
            Dim bodyText As String = msg.BodyText

            'Send the message
            msg.Send()

            'Return the body text
            Return bodyText

        Catch ex As Exception
            'Return this exception
            Return String.Format("Exception encountered while attempting to send FileReceived Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}", vbCrLf, ex.Message, ex.Source, ex.StackTrace)

        End Try

    End Function

#End Region

#Region " Private Shared Methods "

    Private Enum TableTypes
        SuccessVendor = 0
        FailedVendor = 1
        SuccessTelematch = 2
        FailedTelematch = 3
        SuccessTelematchToVendor = 4
        FailedTelematchToVendor = 5
    End Enum

    Private Shared Function CreateDataTable(ByVal tableType As TableTypes, ByVal files As QueuedVendorFileCollection, ByVal isHtml As Boolean) As DataTable

        Dim addRow As Boolean = False
        Dim table As New DataTable

        'Add the columns
        With table
            With .Columns
                If tableType = TableTypes.SuccessVendor OrElse tableType = TableTypes.SuccessTelematch OrElse tableType = TableTypes.SuccessTelematchToVendor OrElse tableType = TableTypes.FailedTelematchToVendor Then
                    .Add("ArchiveFileName", GetType(String))
                End If
                .Add("VendorFileID", GetType(String))
                .Add("ClientName", GetType(String))
                .Add("ClientID", GetType(String))
                .Add("StudyName", GetType(String))
                .Add("StudyID", GetType(String))
                .Add("SurveyName", GetType(String))
                .Add("SurveyID", GetType(String))
                .Add("SampleSetID", GetType(String))
                .Add("SampleCreateDate", GetType(String))
                .Add("DateRangeFrom", GetType(String))
                .Add("DateRangeTo", GetType(String))
                .Add("MethStepName", GetType(String))
                .Add("DateDataCreated", GetType(String))
                .Add("RecordsInFile", GetType(String))
                .Add("RecordsNoLitho", GetType(String))
                If tableType = TableTypes.SuccessTelematch OrElse tableType = TableTypes.SuccessTelematchToVendor OrElse tableType = TableTypes.FailedTelematchToVendor Then
                    .Add("TelematchLogID", GetType(String))
                    .Add("DateSent", GetType(String))
                End If
                If tableType = TableTypes.FailedVendor OrElse tableType = TableTypes.FailedTelematch OrElse tableType = TableTypes.FailedTelematchToVendor Then
                    .Add("Exception", GetType(String))
                End If
            End With
        End With

        'Populate the columns
        For Each file As QueuedVendorFile In files
            'Determine criteria
            Select Case tableType
                Case TableTypes.SuccessVendor
                    addRow = (file.Ex Is Nothing AndAlso file.VendorFile.VendorFileStatusId = VendorFileStatusCodes.Sent)

                Case TableTypes.FailedVendor
                    addRow = (file.Ex IsNot Nothing)

                Case TableTypes.SuccessTelematch
                    addRow = (file.Ex Is Nothing AndAlso file.VendorFile.VendorFileStatusId = VendorFileStatusCodes.Telematching)

                Case TableTypes.FailedTelematch
                    addRow = (file.Ex IsNot Nothing)

                Case TableTypes.SuccessTelematchToVendor
                    addRow = (file.Ex Is Nothing AndAlso file.VendorFile.VendorFileStatusId = VendorFileStatusCodes.Sent)

                Case TableTypes.FailedTelematchToVendor
                    addRow = (file.Ex IsNot Nothing)

            End Select

            'Check to see if we are to add this file to the table
            If addRow Then
                'Create a new row
                Dim row As DataRow = table.NewRow

                'Populate the row
                If tableType = TableTypes.SuccessVendor OrElse tableType = TableTypes.SuccessTelematch OrElse tableType = TableTypes.SuccessTelematchToVendor Then
                    row.Item("ArchiveFileName") = Chr(34) & file.VendorFile.ArchiveFileName & Chr(34)
                ElseIf tableType = TableTypes.FailedTelematchToVendor Then
                    row.Item("ArchiveFileName") = Chr(34) & file.VendorFile.InProcessFileName & Chr(34)
                End If
                row.Item("VendorFileID") = file.VendorFile.VendorFileId.ToString
                row.Item("ClientName") = file.VendorFile.Client.Name.Trim
                row.Item("ClientID") = file.VendorFile.Client.Id.ToString
                row.Item("StudyName") = file.VendorFile.Study.Name.Trim
                row.Item("StudyID") = file.VendorFile.Study.Id.ToString
                row.Item("SurveyName") = file.VendorFile.Survey.Name.Trim
                row.Item("SurveyID") = file.VendorFile.Survey.Id.ToString
                row.Item("SampleSetID") = file.VendorFile.SamplesetId.ToString
                row.Item("SampleCreateDate") = file.VendorFile.SampleSet.DateCreated.ToString
                row.Item("DateRangeFrom") = file.VendorFile.SampleSet.SampleStartDate.ToShortDateString
                row.Item("DateRangeTo") = file.VendorFile.SampleSet.SampleEndDate.ToShortDateString
                row.Item("MethStepName") = file.MethodologyStep.Name
                row.Item("DateDataCreated") = file.VendorFile.DateDataCreated.ToString
                row.Item("RecordsInFile") = file.VendorFile.RecordsInFile.ToString
                row.Item("RecordsNoLitho") = file.VendorFile.RecordsNoLitho.ToString
                If tableType = TableTypes.SuccessTelematch OrElse tableType = TableTypes.SuccessTelematchToVendor OrElse tableType = TableTypes.FailedTelematchToVendor Then
                    row.Item("TelematchLogID") = file.TelematchLog.Id.ToString
                    row.Item("DateSent") = file.TelematchLog.DateSent
                End If
                If tableType = TableTypes.FailedVendor OrElse tableType = TableTypes.FailedTelematch OrElse tableType = TableTypes.FailedTelematchToVendor Then
                    row.Item("Exception") = file.ExceptionString(isHtml)
                End If

                'Add the row to the table
                table.Rows.Add(row)
            End If
        Next

        Return table

    End Function

#End Region

End Class
