Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.QualiSys.Library
Imports System.Collections.ObjectModel

Public Class SeededMailingService

#Region " Private Members "

    Private WithEvents mTimer As Timers.Timer

#End Region

#Region " Service Events (Start, Stop, Pause, Continue) "

    Protected Overrides Sub OnStart(ByVal args() As String)

        Try
            'Instatiate the timer and start it
            mTimer = New Timers.Timer(AppConfig.Params("SeededMailingServiceInterval").IntegerValue)
            mTimer.AutoReset = False
            mTimer.Enabled = True

        Catch ex As Exception
            'Send the notification
            LogEvent(ToBeSeeded.SendExceptionNotification("Seeded Mailing Service", "The service was unable to start!", ex, True), EventLogEntryType.Error)

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

        'Check to see if we are within operating hours
        If Now.Hour >= AppConfig.Params("SeededMailingServiceStartHour").IntegerValue AndAlso Now.Hour < AppConfig.Params("SeededMailingServiceEndHour").IntegerValue Then
            CheckForWork()
        End If

        'When processing it complete restart the timer
        mTimer.Enabled = True

    End Sub

#End Region

#Region " Private Methods "

    Private Sub CheckForWork()

        Try
            'Get the designation for the current calendar quarter
            Dim yrQtr As String = ToBeSeeded.GetYearQtrFromDate(Date.Now)

            'Check to see if we need to populate ToBeSeeded for this quarter
            If Not ToBeSeeded.IsTimeToPopulateForQuarter(yrQtr) Then
                Exit Sub
            End If

            'Get the list of survey types
            Dim srvyTypes As SurveyTypeCollection = SurveyType.GetAll()

            'Check all survey types to determine if they need to be seeded
            For Each srvyType As SurveyType In srvyTypes
                If srvyType.SeedMailings Then
                    ExecuteToBeSeededPopulation(srvyType, yrQtr)
                End If
            Next

            'Send the notification email
            ToBeSeeded.SendNotification(srvyTypes, yrQtr, False)

        Catch ex As System.OutOfMemoryException
            'We seem to have used up all of the memory so let's log the problem and clean things up a bit.
            LogEvent(ToBeSeeded.SendExceptionNotification("Seeded Mailing Service", "Error encountered while checking for work (Out of Memory).  Attempting to do garbage collection", ex, True), EventLogEntryType.Error)
            GC.Collect()

        Catch ex As Exception
            'Houston, we have a problem!
            LogEvent(ToBeSeeded.SendExceptionNotification("Seeded Mailing Service", "Error encountered, unable to check for work", ex, False), EventLogEntryType.Error)

        End Try

    End Sub

    Private Sub ExecuteToBeSeededPopulation(ByVal srvyType As SurveyType, ByVal yrQtr As String)

        Dim seedSurvey As Survey

        'Get a collection of all mail surveys of this type
        Dim surveys As Collection(Of Survey) = Survey.GetMailSurveysBySurveyType(srvyType)

        'Randomize the list
        Dim randomNumber As Integer
        Dim surveyDictionary As New Dictionary(Of Integer, Survey)
        Dim indexList As New List(Of Integer)
        Dim ran As New Random(CInt(DateTime.Now.Ticks Mod System.Int32.MaxValue))

        For Each srvy As Survey In surveys
            Randomize()
            randomNumber = ran.Next
            surveyDictionary.Add(randomNumber, srvy)
            indexList.Add(randomNumber)
        Next

        'Sort the list by random number
        indexList.Sort()

        'Take the first N percent and write them out to ToBeSeeded
        For cnt As Integer = 0 To CInt(indexList.Count * (srvyType.SeedSurveyPercent / 100)) - 1
            'Get the survey to be added
            seedSurvey = surveyDictionary.Item(indexList(cnt))

            'Add this survey to the ToBeSeeded table
            Dim seed As ToBeSeeded = ToBeSeeded.NewToBeSeeded
            With seed
                .SurveyId = seedSurvey.Id
                .SurveyTypeId = srvyType.Id
                .YearQtr = yrQtr
                .IsSeeded = False
                .Save()
            End With

            'Add this survey to the SeededSurveys collection
            srvyType.SeedSurveys.Add(seedSurvey)
        Next

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
