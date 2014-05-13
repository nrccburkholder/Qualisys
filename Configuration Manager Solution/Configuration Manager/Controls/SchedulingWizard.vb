Imports DevExpress.XtraScheduler
Public Class SchedulingWizard

#Region "Private Members"
    Private mRecurrenceInfo As New RecurrenceInfo(Today, 1)
    Private mSelectedRecurrenceControl As New UI.RecurrenceControlBase
    Private mCheckedRadioButton As RadioButton
    Private mBaseLineDate As Nullable(Of Date)
#End Region

#Region "Constructor"
    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
    End Sub
#End Region

#Region "Properties"
    Private Property BaselineDate() As Nullable(Of Date)
        Get
            If mBaseLineDate.HasValue = False Then mBaseLineDate = Today
            Return mBaseLineDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            mBaseLineDate = value
            mRecurrenceInfo.Start = MinimumFirstSampleDate
            mSelectedRecurrenceControl.UpdateControls()
        End Set
    End Property

    Private ReadOnly Property MinimumFirstSampleDate() As Date
        Get
            'Make sure we don't set a minimum date in the past
            Dim minDate As Date = BaselineDate.Value.AddDays(Me.BaselineDateIncrementNumericUpDown.Value)
            If minDate < Today Then minDate = Today
            Return minDate
        End Get
    End Property

    ''' <summary>
    ''' Label that appears next to the occurrence number control
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property OccurrenceNumberLabel() As String
        Get
            Return Me.OccurrenceLabel.Text
        End Get
        Set(ByVal value As String)
            Me.OccurrenceLabel.Text = value
        End Set
    End Property


    ''' <summary>
    ''' Label that appears next to the baseline date incrementor control
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property BaseLineDateIncrementLabel() As String
        Get
            Return Me.BaseLineDateIncrementNumberLabel.Text
        End Get
        Set(ByVal value As String)
            Me.BaseLineDateIncrementNumberLabel.Text = value
        End Set
    End Property

    ''' <summary>
    ''' Gets or Sets the checked radion button.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property SamplingSchedule() As Qualisys.Library.SamplePeriod.SamplingSchedule
        Get
            Dim schedule As Qualisys.Library.SamplePeriod.SamplingSchedule
            If mCheckedRadioButton.Equals(Me.DailyRadioButton) Then
                schedule = Library.SamplePeriod.SamplingSchedule.Daily
            ElseIf mCheckedRadioButton.Equals(Me.WeeklyRadioButton) Then
                schedule = Library.SamplePeriod.SamplingSchedule.Weekly
            ElseIf mCheckedRadioButton.Equals(Me.MonthlyRadioButton) Then
                schedule = Library.SamplePeriod.SamplingSchedule.Monthly
            ElseIf mCheckedRadioButton.Equals(Me.BiMonthlyRadioButton) Then
                schedule = Library.SamplePeriod.SamplingSchedule.BiMonthly
            End If
            Return schedule
        End Get
        Set(ByVal value As Qualisys.Library.SamplePeriod.SamplingSchedule)
            Select Case value
                Case Library.SamplePeriod.SamplingSchedule.Daily
                    Me.DailyRadioButton.Checked = True
                Case Library.SamplePeriod.SamplingSchedule.Weekly
                    Me.WeeklyRadioButton.Checked = True
                Case Library.SamplePeriod.SamplingSchedule.Monthly
                    Me.MonthlyRadioButton.Checked = True
                Case Library.SamplePeriod.SamplingSchedule.BiMonthly
                    Me.BiMonthlyRadioButton.Checked = True
            End Select
        End Set
    End Property

#End Region

#Region "Private Methods"
    Private Sub SetRecurrenceInfoProperties(ByVal checkedRadioButton As RadioButton)
        Dim occurenceNumber As Integer = 1
        If Not checkedRadioButton.Equals(Me.BiMonthlyRadioButton) Then
            mRecurrenceInfo.Periodicity = 1
            If CInt(Me.OccurenceNumberNumericUpDown.Value) > 0 Then occurenceNumber = CInt(Me.OccurenceNumberNumericUpDown.Value)
            mRecurrenceInfo.OccurrenceCount = occurenceNumber
            mRecurrenceInfo.DayNumber = Me.MinimumFirstSampleDate.Day

            Select Case ((Me.MinimumFirstSampleDate.Day - 1) \ 7) + 1
                Case 1
                    mRecurrenceInfo.WeekOfMonth = WeekOfMonth.First
                Case 2
                    mRecurrenceInfo.WeekOfMonth = WeekOfMonth.Second
                Case 3
                    mRecurrenceInfo.WeekOfMonth = WeekOfMonth.Third
                Case 4
                    mRecurrenceInfo.WeekOfMonth = WeekOfMonth.Fourth
                Case 5
                    mRecurrenceInfo.WeekOfMonth = WeekOfMonth.Last
                Case Else
                    mRecurrenceInfo.WeekOfMonth = WeekOfMonth.None
            End Select

            If Not mRecurrenceInfo.Type = RecurrenceType.Daily Then
                Select Case Me.MinimumFirstSampleDate.DayOfWeek
                    Case DayOfWeek.Monday
                        mRecurrenceInfo.WeekDays = WeekDays.Monday
                    Case DayOfWeek.Tuesday
                        mRecurrenceInfo.WeekDays = WeekDays.Tuesday
                    Case DayOfWeek.Wednesday
                        mRecurrenceInfo.WeekDays = WeekDays.Wednesday
                    Case DayOfWeek.Thursday
                        mRecurrenceInfo.WeekDays = WeekDays.Thursday
                    Case DayOfWeek.Friday
                        mRecurrenceInfo.WeekDays = WeekDays.Friday
                    Case DayOfWeek.Saturday
                        mRecurrenceInfo.WeekDays = WeekDays.Saturday
                    Case DayOfWeek.Sunday
                        mRecurrenceInfo.WeekDays = WeekDays.Sunday
                End Select
            End If
        End If
    End Sub

    Private Function CalculateDatesUsingRecurrenceInfo() As Collection(Of Date)
        Dim dates As New Collection(Of Date)
        Dim apt As Appointment = New Appointment(AppointmentType.Pattern)

        apt.RecurrenceInfo.Start = Me.mRecurrenceInfo.Start
        apt.RecurrenceInfo.Type = mRecurrenceInfo.Type
        apt.RecurrenceInfo.Duration = mRecurrenceInfo.Duration
        apt.RecurrenceInfo.Periodicity = mRecurrenceInfo.Periodicity
        apt.RecurrenceInfo.OccurrenceCount = mRecurrenceInfo.OccurrenceCount
        apt.RecurrenceInfo.WeekDays = mRecurrenceInfo.WeekDays
        apt.RecurrenceInfo.Range = mRecurrenceInfo.Range
        apt.RecurrenceInfo.DayNumber = mRecurrenceInfo.DayNumber
        apt.RecurrenceInfo.AllDay = mRecurrenceInfo.AllDay
        apt.RecurrenceInfo.End = Me.mRecurrenceInfo.End
        apt.RecurrenceInfo.Month = Me.mRecurrenceInfo.Month
        apt.RecurrenceInfo.WeekOfMonth = Me.mRecurrenceInfo.WeekOfMonth
        'Calculate 10 years of dates, and then only report the number in the occurence count
        Dim ti As New TimeInterval(apt.RecurrenceInfo.Start, TimeSpan.FromDays(3650))
        Dim aptExpander As New Native.AppointmentPatternExpander(apt)

        Dim abc As AppointmentBaseCollection = aptExpander.Expand(ti)
        Dim datecount As Integer = abc.Count
        For i As Integer = 0 To (mRecurrenceInfo.OccurrenceCount - 1)
            'Make sure we aren't passed the end of the collection
            If i < datecount Then dates.Add(abc(i).Start)
        Next

        Return dates
    End Function

    Private Function CalculateBiMonthlyDates() As Collection(Of Date)
        Dim dates As New Collection(Of Date)
        Dim startingYear As Integer = Me.MinimumFirstSampleDate.Year
        Dim startingMonth As Integer = Me.MinimumFirstSampleDate.Month
        Dim startingDay As Integer = Me.BiMonthlyRecurrenceControl.FirstDay

        If startingDay < Me.MinimumFirstSampleDate.Day Then
            'Start with the next month
            startingMonth += 1
            If startingMonth = 13 Then
                startingMonth = 1
                startingYear += 1
            End If
        End If

        For i As Integer = 1 To Decimal.ToInt32(Me.OccurenceNumberNumericUpDown.Value)
            'Check remainder to determine if we are setting the first date or 2nd
            If i Mod 2 = 1 Then
                dates.Add(FindValidDate(startingMonth, startingDay, startingYear))
            Else
                dates.Add(FindValidDate(startingMonth, Me.BiMonthlyRecurrenceControl.SecondDay, startingYear))
                'Increment to new month after setting the second date
                startingMonth += 1
                If startingMonth = 13 Then
                    startingMonth = 1
                    startingYear += 1
                End If
            End If
        Next

        Return dates
    End Function

    Private Function FindValidDate(ByVal startingMonth As Integer, ByVal startingDay As Integer, ByVal startingYear As Integer) As Date
        Dim goodDate As Date
        Date.TryParse(startingMonth.ToString + "/" + startingDay.ToString + "/" + startingYear.ToString, goodDate)

        'If the date isn't valid, then subtract 1 from the day and try again.  Keep
        'doing this until a valid date is found.
        If goodDate = Nothing Then
            goodDate = FindValidDate(startingMonth, startingDay - 1, startingYear)
        End If

        Return goodDate
    End Function

    Public Function CalculateDates(ByVal baseLineDate As Date) As Collection(Of Date)
        Me.BaselineDate = baseLineDate
        If Me.BiMonthlyRadioButton.Checked = False Then
            Return CalculateDatesUsingRecurrenceInfo()
        Else
            Return CalculateBiMonthlyDates()
        End If
    End Function
#End Region

#Region "Event Handlers"

    Private Sub RecurrenceRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DailyRadioButton.CheckedChanged, WeeklyRadioButton.CheckedChanged, MonthlyRadioButton.CheckedChanged, BiMonthlyRadioButton.CheckedChanged
        mCheckedRadioButton = (DirectCast(sender, RadioButton))

        If mCheckedRadioButton.Equals(Me.DailyRadioButton) Then
            mSelectedRecurrenceControl = Me.SamplePeriodDailyRecurrenceControl
        ElseIf mCheckedRadioButton.Equals(Me.WeeklyRadioButton) Then
            mSelectedRecurrenceControl = Me.SamplePeriodWeeklyRecurrenceControl
        ElseIf mCheckedRadioButton.Equals(Me.MonthlyRadioButton) Then
            mSelectedRecurrenceControl = Me.SamplePeriodMonthlyRecurrenceControl
        ElseIf mCheckedRadioButton.Equals(Me.BiMonthlyRadioButton) Then
            mSelectedRecurrenceControl = Me.BiMonthlyRecurrenceControl
        End If

        'Only do this when a button gets checked.  This avoids performing these actions
        'when a button is unchecked and then repeating them when the next button becomes checked
        If mCheckedRadioButton.Checked = False Then
            mSelectedRecurrenceControl.Visible = False
        Else
            mSelectedRecurrenceControl.Visible = True
            mRecurrenceInfo = mSelectedRecurrenceControl.RecurrenceInfo
            SetRecurrenceInfoProperties(mCheckedRadioButton)
            mSelectedRecurrenceControl.UpdateControls()
        End If
    End Sub

    Private Sub OccurenceNumberNumericUpDown_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OccurenceNumberNumericUpDown.ValueChanged
        Me.mRecurrenceInfo.OccurrenceCount = CInt(Me.OccurenceNumberNumericUpDown.Value)
    End Sub
#End Region

End Class
