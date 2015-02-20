Imports Nrc.QualiSys.Library
Imports Nrc.Framework.BusinessLogic.Configuration
Imports System.Collections.ObjectModel

Public Class SeededMailingServiceTest

#Region " Private Members "


#End Region

#Region "Run As Service Button Events"

    Private Sub StartButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartButton.Click

        Try
            'Instatiate the timer and start it
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
            LogEvent("The Seeded Mailing Service was unable to start!", ex, EventLogEntryType.Error)

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
        CheckForWork()

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

        'Check to see if we are within operating hours
        If Now.Hour >= AppConfig.Params("SeededMailingServiceStartHour").IntegerValue AndAlso Now.Hour < AppConfig.Params("SeededMailingServiceEndHour").IntegerValue Then
            CheckForWork()
        End If

        'When processing it complete restart the timer
        ServiceTimer.Enabled = True

    End Sub

#End Region

#Region "Private Methods"

    Private Sub CheckForWork()

        'Display a message
        ServiceTextBox.Text = String.Format("CheckForWork at: {0}{1}{2}", DateTime.Now.ToLongTimeString, vbCrLf, ServiceTextBox.Text)

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

    Private Sub LogEvent(ByVal eventData As String, ByVal entryType As EventLogEntryType)

        MessageBox.Show(eventData, My.Application.Info.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)

    End Sub

    Private Sub LogEvent(ByVal message As String, ByVal ex As Exception, ByVal entryType As EventLogEntryType)

        LogEvent(String.Format("{0}{1}{1}{2}{1}{1}Source: {3}{1}{1}Stack Trace:{1}{4}", message, vbCrLf, ex.Message, ex.Source, ex.StackTrace), entryType)

    End Sub

#End Region

End Class
