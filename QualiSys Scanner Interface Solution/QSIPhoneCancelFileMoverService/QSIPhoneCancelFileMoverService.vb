Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.QualiSys.Scanning.Library
Imports System.IO


Public Class QSIPhoneCancelFileMoverService

#Region " Private Members "

    Private mMoveQueue As QueuedTransferFileCollection

    Private WithEvents mTimer As Timers.Timer

#End Region

#Region " Service Events (Start, Stop, Pause, Continue) "

    Protected Overrides Sub OnStart(ByVal args() As String)

        Dim dDelay As Double
        Dim sTime() As String
        Dim startDay As DateTime
        Try
            'Read start time'
            sTime = AppConfig.Params("QSIPhoneCancelFileMoverTimeOfDay").StringValue.Split(":".ToCharArray)
            LogEvent("QSIPhoneCancelFileMoverTimeOfDay setting is " + AppConfig.Params("QSIPhoneCancelFileMoverTimeOfDay").StringValue, EventLogEntryType.Information)
            startDay = DateTime.Today
            dDelay = (New DateTime(startDay.Year, startDay.Month, startDay.Day, Integer.Parse(sTime(0)), Integer.Parse(sTime(1)), 0) - DateTime.Now).TotalMilliseconds
            If dDelay < 0 Then
                startDay = startDay.AddDays(1)
                dDelay = (New DateTime(startDay.Year, startDay.Month, startDay.Day, Integer.Parse(sTime(0)), Integer.Parse(sTime(1)), 0) - DateTime.Now).TotalMilliseconds
            End If

            'Instatiate the timer and start it
            mTimer = New Timers.Timer(dDelay)
            mTimer.AutoReset = False
            mTimer.Enabled = True

            LogEvent("Scheduled daily for " + sTime(0) + ":" + sTime(1) + " beginning " + startDay.ToShortDateString, EventLogEntryType.Information)
        Catch ex As Exception
            'Send the notification
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIPhoneCancelFileMoverService, "The service was unable to start!", ex, True), EventLogEntryType.Error)

        End Try

    End Sub

    Protected Overrides Sub OnStop()

        'Pause the timer
        mTimer.Enabled = False

    End Sub

    Protected Overrides Sub OnContinue()

        'Pause the timer
        mTimer.Enabled = True

    End Sub

    Protected Overrides Sub OnPause()

        'Pause the timer
        mTimer.Enabled = False

    End Sub

#End Region

#Region " Timer Events "

    Private Sub mTimer_Elapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs) Handles mTimer.Elapsed

        Dim startTime As DateTime = DateTime.Now
        'Check to see if there are any files to process
        CheckForWork()

        'When processing it complete restart the timer and reset the interval
        mTimer.Enabled = True
        mTimer.Interval = (startTime.AddDays(1) - Now).TotalMilliseconds

    End Sub

#End Region

#Region " Private Methods "

    Private Sub CheckForWork()

        Try
            'Populate the queue with all files ready to be loaded
            'PopulateMoveQueue() 'TODO: make sure we load up with the results from QSL_PhoneVendorCancelList
            Dim ftpPath As String = String.Empty

            'Loop through all of the vendors
            Dim vendorPhoneFile_Data1 As VendorPhoneFile_Data = VendorPhoneFile_Data.NewVendorPhoneFile_Data
            Dim vendors As VendorCollection = Vendor.GetAll
            Dim sYYYYMMDD As String = Today.Year.ToString()
            If Today.Month < 10 Then
                sYYYYMMDD += "0"
            End If
            sYYYYMMDD += Today.Month.ToString()
            If Today.Day < 10 Then
                sYYYYMMDD += "0"
            End If
            sYYYYMMDD += Today.Day.ToString()

            For Each vend As Vendor In vendors
                If Not String.IsNullOrEmpty(vend.LocalFTPLoginName) Then
                    Try

                        'Check the FTP drop point to see if there are any files to be moved
                        ftpPath = Path.Combine(AppConfig.Params("QSIVendorFileOutboundRootFolder").StringValue, vend.LocalFTPLoginName)
                        ftpPath = Path.Combine(ftpPath, "outbound")

                        Dim PhoneCancels As VendorPhoneFile_DataCollection = vendorPhoneFile_Data1.GeneratePhoneVendorCancelFile(vend.VendorId)

                        If PhoneCancels.Count > 0 Then
                            Using ftpfile As System.IO.StreamWriter = New System.IO.StreamWriter(String.Format("{0}\daily_update_{1}.csv", ftpPath, sYYYYMMDD), False)
                                For Each pc As VendorPhoneFile_Data In PhoneCancels
                                    ftpfile.Write(String.Format("{0},{1}{2}", pc.SurveyId.ToString(), pc.Litho.ToString(), vbCrLf))
                                Next
                            End Using

                            vendorPhoneFile_Data1.MarkPhoneVendorCancelFileSent(vend.VendorId)

                            LogEvent("File sent : " + ftpPath + "\daily_update_" + sYYYYMMDD + ".csv", EventLogEntryType.Information)
                        Else
                            LogEvent("Nothing to send : " + ftpPath, EventLogEntryType.Information)
                        End If

                    Catch ex As Exception
                        Dim msg As String = "Exception Encountered While Attempting to Generate File!"
                        LogEvent(Translator.SendNotification(QSIServiceNames.QSIPhoneCancelFileMoverService, msg, ex, False), EventLogEntryType.Error)
                    End Try
                End If
            Next

        Catch ex As Exception
            'Houston, we have a problem!
            LogEvent(Translator.SendNotification(QSIServiceNames.QSIPhoneCancelFileMoverService, "Error encountered, unable to check for work", ex, False), EventLogEntryType.Error)

        End Try

    End Sub

#End Region

#Region " Notification And Event Logging "

    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        'Check the length of the eventData
        If eventData.Length > 32000 Then
            eventData = eventData.Substring(0, 32000)
        End If

        'Write the log entry
        EventLog.WriteEntry(eventData, entryType)

    End Sub

#End Region


End Class
