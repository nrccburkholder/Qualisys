Imports Nrc.Qualisys.Library
Public Class MassSamplePeriodCreator
    Private mSurvey As Survey

    Private mSamplePeriods As SamplePeriodCollection

#Region "Public Properties"


    Public Property ParentSamplePeriods() As SamplePeriodCollection
        Get
            Return mSamplePeriods
        End Get
        Set(ByVal value As SamplePeriodCollection)
            mSamplePeriods = value
        End Set
    End Property


#End Region

#Region "Constructor"
    Public Sub New(ByVal survey As survey)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mSurvey = survey
    End Sub
#End Region

    Private Sub MassSamplePeriodCreator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Add all sampling Methods to the repository
        For Each i As Integer In System.Enum.GetValues(GetType(SampleSet.SamplingMethod))
            Me.SamplingMethodComboBoxEdit.Properties.Items.Add(SampleSet.SamplingMethodLabel(DirectCast(i, SampleSet.SamplingMethod)))
        Next

        'IF HCAHPS select Monthly and don't let it be edited.  
        If mSurvey.IsMonthlyOnly Then
            Me.PeriodTimeSpanComboBoxEdit.SelectedIndex = 1
            Me.PeriodTimeSpanComboBoxEdit.Enabled = False
        Else
            Me.PeriodTimeSpanComboBoxEdit.SelectedIndex = 0
        End If

        Me.FirstEncounterStartDateEdit.Visible = Not mSurvey.IsMonthlyOnly
        Me.MonthEdit1.Visible = mSurvey.IsMonthlyOnly
        Me.YearComboBoxEdit.Visible = mSurvey.IsMonthlyOnly

        Dim override As String = mSurvey.SurveySubTypeOverrideName() 'will retrieve PCMH for example CJB 8/14/2014

        'Me.SamplingMethodComboBoxEdit.EditValue = SampleSet.SamplingMethodFromLabel(Me.mSurvey.SamplingMethodDefault)
        Me.SamplingMethodComboBoxEdit.EditValue = Me.mSurvey.SamplingMethodDefault(override)
        Me.SamplingMethodComboBoxEdit.Enabled = Not Me.mSurvey.IsSamplingMethodDisabled(override)

        Me.FirstEncounterStartDateEdit.DateTime = Today
        Me.MonthEdit1.SelectedIndex = Today.Month - 1
        Me.YearComboBoxEdit.Text = CStr(Today.Year)
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Dim scheduledSample As SamplePeriodScheduledSample
        Dim counter As Integer
        Dim dates As Collection(Of Date)
        Dim samplePeriods As New Collection(Of SamplePeriod)
        Dim newPeriod As SamplePeriod
        Dim expectedStartDate As Date

        If Me.mSurvey.IsMonthlyOnly Then
            expectedStartDate = DateTime.Parse(String.Format("{0} {1}, {2}", Me.MonthEdit1.Text, "01", Me.YearComboBoxEdit.Text))
        Else
            expectedStartDate = Me.FirstEncounterStartDateEdit.DateTime
        End If

        For i As Integer = 1 To CInt(Me.PeriodsOccurenceSpinEdit.Value)
            newPeriod = SamplePeriod.NewSamplePeriod(Me.mSurvey, CurrentUser.Employee.Id)
            newPeriod.ExpectedStartDate = expectedStartDate
            newPeriod.SamplingMethodLabel = Me.SamplingMethodComboBoxEdit.Text
            Select Case Me.PeriodTimeSpanComboBoxEdit.Text
                Case "Weekly"
                    newPeriod.ExpectedEndDate = newPeriod.ExpectedStartDate.Value.AddDays(6)
                Case "Monthly"
                    newPeriod.ExpectedEndDate = newPeriod.ExpectedStartDate.Value.AddMonths(1).AddDays(-1)
                Case "Quarterly"
                    newPeriod.ExpectedEndDate = newPeriod.ExpectedStartDate.Value.AddMonths(3).AddDays(-1)
            End Select
            If Me.mSurvey.IsMonthlyOnly Then
                newPeriod.Name = newPeriod.ExpectedStartDate.Value.ToString("MMM") & newPeriod.ExpectedStartDate.Value.ToString("yy")
            Else
                newPeriod.Name = newPeriod.ExpectedStartDate.Value.ToShortDateString & " - " & newPeriod.ExpectedEndDate.Value.ToShortDateString
            End If
            samplePeriods.Add(newPeriod)

            'Prepare to loop again
            expectedStartDate = newPeriod.ExpectedEndDate.Value.AddDays(1)
        Next

        If Not ValidateExpectedDates(samplePeriods) Then
            MessageBox.Show("The Properties you have selected will create new periods that overlap with existing periods.  This is not allowed.", "Overlapping Periods Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else

            For Each newPeriod In samplePeriods
                newPeriod.SamplingScheduleName = SchedulingWizard.SamplingSchedule
                counter = 1

                dates = SchedulingWizard.CalculateDates(newPeriod.ExpectedStartDate.Value)
                For Each tmpDate As Date In dates

                    scheduledSample = SamplePeriodScheduledSample.NewSamplePeriodScheduledSample
                    scheduledSample.SampleNumber = counter
                    scheduledSample.ScheduledSampleDate = tmpDate
                    scheduledSample.SamplePeriodId = newPeriod.Id
                    newPeriod.SamplePeriodScheduledSamples.Add(scheduledSample)

                    'Prepare for next scheduled sample to add
                    counter += 1
                Next
                'ReValidate
                newPeriod.ReValidate()

                'Add to the surveys collection
                Me.mSurvey.SamplePeriods.Add(newPeriod)
            Next

            Me.Close()

        End If


    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click
        Me.Close()
    End Sub


    Private Function ValidateExpectedDates(ByVal periods As Collection(Of SamplePeriod)) As Boolean

        If Not Me.ParentSamplePeriods Is Nothing Then
            For Each period As SamplePeriod In periods
                For Each item As SamplePeriod In ParentSamplePeriods
                    ' checking for overlapping dates
                    If (period.ExpectedStartDate <= item.ExpectedEndDate) And (item.ExpectedStartDate <= period.ExpectedEndDate) Then
                        Return False
                    End If
                Next
            Next
        End If

        Return True

    End Function
End Class
