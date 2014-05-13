Public Class ExportDateSet

    Private mStartDate As Date
    Private mEndDate As Date
    Private mRunDate As Date = Date.MinValue


    Public Enum IntervalTypes
        Weeks = 0
        Months = 1
    End Enum


    Public Enum MonthlyTypes
        SpecificDate = 0
        DayOfWeek = 1
    End Enum


    Public Property StartDate() As Date
        Get
            Return mStartDate
        End Get
        Set(ByVal value As Date)
            mStartDate = value
        End Set
    End Property


    Public Property EndDate() As Date
        Get
            Return mEndDate
        End Get
        Set(ByVal value As Date)
            mEndDate = value
        End Set
    End Property


    Public Property RunDate() As Date
        Get
            Return mRunDate
        End Get
        Set(ByVal value As Date)
            mRunDate = value
        End Set
    End Property


    Public ReadOnly Property IsScheduled() As Boolean
        Get
            Return (mRunDate <> Date.MinValue)
        End Get
    End Property


    Public ReadOnly Property MonthYearLabel() As String
        Get
            Return String.Format("{0} {1}", mStartDate.ToString("MMMM"), mStartDate.Year.ToString)
        End Get
    End Property


    Friend Sub SetByMonthYear(ByVal monthNum As Integer, ByVal yearNum As Integer)

        mStartDate = Date.Parse(monthNum & "/1/" & yearNum)
        mEndDate = mStartDate.AddMonths(1).AddDays(-1)

    End Sub


    Public Shared Function GetBySingleMonth(ByVal startMonth As Integer, ByVal startYear As Integer, ByVal quantity As Integer, _
                                            ByVal scheduleFile As Boolean, ByVal scheduleStartDate As Date) As Collection(Of ExportDateSet)

        'Create a collection of DateSets
        Dim dateSets As Collection(Of ExportDateSet) = New Collection(Of ExportDateSet)

        'Get the initial values for the dates
        Dim dateSet As ExportDateSet
        Dim month As Integer = startMonth
        Dim year As Integer = startYear
        Dim runDate As Date = scheduleStartDate

        'Populate the date set collection
        For cnt As Integer = 1 To quantity
            'Create teh DateSet object and populate it
            dateSet = New ExportDateSet
            With dateSet
                .SetByMonthYear(month, year)
                If scheduleFile Then
                    .RunDate = runDate
                End If
            End With

            'Add the new object to the collection
            dateSets.Add(dateSet)

            'Prepare for the next iteration
            month += 1
            If month > 12 Then
                month = 1
                year += 1
            End If
            runDate = scheduleStartDate.AddMonths(cnt)
        Next

        'Return the collection
        Return dateSets

    End Function


    Public Shared Function GetByStartAndEndDate(ByVal cutoffStartDate As Date, ByVal interval As Integer, ByVal intervalType As IntervalTypes, _
                                                ByVal monthlyType As MonthlyTypes, ByVal quantity As Integer, ByVal weekNumber As Integer, _
                                                ByVal scheduleFile As Boolean, ByVal scheduleStartDate As Date) As Collection(Of ExportDateSet)

        'Create a collection of DateSets
        Dim dateSets As Collection(Of ExportDateSet) = New Collection(Of ExportDateSet)

        'We are dealing with the recurrence setting
        Dim datSet As ExportDateSet
        Dim nextStartDate As Date
        Dim endDate As Date
        Dim runDaysInterval As Integer
        Dim startDate As Date = cutoffStartDate
        Dim runDate As Date = scheduleStartDate

        'Populate the collection
        For cnt As Integer = 1 To quantity
            'Determine the end date
            Select Case intervalType
                Case IntervalTypes.Weeks
                    'Get the end date for the specified number of weeks interval
                    endDate = startDate.AddDays((interval * 7) - 1)

                    'Get the next start date
                    nextStartDate = endDate.AddDays(1)

                    'Get the run date
                    If cnt > 1 Then
                        runDate = runDate.AddDays(interval * 7)
                    End If

                Case IntervalTypes.Months
                    'We are in months mode
                    Select Case monthlyType
                        Case MonthlyTypes.SpecificDate
                            'Specified date mode
                            'Get the next start date
                            nextStartDate = cutoffStartDate.AddMonths(interval * cnt)

                            'Get the end date
                            endDate = nextStartDate.AddDays(-1)

                            'Get the run date
                            If cnt > 1 Then
                                runDate = scheduleStartDate.AddMonths(interval * (cnt - 1))
                            End If

                        Case MonthlyTypes.DayOfWeek
                            'Specified day of week
                            endDate = GetEndDateByDayOfWeek(startDate, interval, weekNumber)

                            'Get the next start date
                            nextStartDate = endDate.AddDays(1)

                            'Determine the run days interval from end date
                            If cnt = 1 Then
                                runDaysInterval = CType(DateDiff(DateInterval.DayOfYear, endDate, runDate), Integer)
                            End If

                            'Get the run date
                            If cnt > 1 Then
                                runDate = endDate.AddDays(runDaysInterval)
                            End If

                    End Select

            End Select

            'Create the DateSet object and populate it
            datSet = New ExportDateSet
            With datSet
                .StartDate = startDate
                .EndDate = endDate
                If scheduleFile Then
                    .RunDate = runDate
                End If
            End With

            'Add the new object to the collection
            dateSets.Add(datSet)

            'Prepare for the next iteration
            startDate = nextStartDate
        Next

        'Return the collection
        Return dateSets

    End Function


    Public Shared Function GetEndDateByDayOfWeek(ByVal startDate As Date, ByVal interval As Integer, ByVal weekNumber As Integer) As Date

        Dim endDate As Date

        If weekNumber = 9 Then
            'We are looking for the last occurance of this weekday
            'Determine the first day to check
            Dim month As Integer = startDate.AddMonths(interval).Month
            Dim year As Integer = startDate.AddMonths(interval).Year
            Dim lastDay As Integer = Date.DaysInMonth(year, month)
            endDate = Date.Parse(month.ToString & "/" & lastDay.ToString & "/" & year.ToString)

            'Find the correct day of the week
            Do Until endDate.DayOfWeek = startDate.DayOfWeek
                endDate = endDate.AddDays(-1)
            Loop
        Else
            'We are looking for the specified occurance of this weekday
            'Determine the first day to check
            endDate = Date.Parse(startDate.AddMonths(interval).Month.ToString & "/" & (((weekNumber - 1) * 7) + 1).ToString & "/" & startDate.AddMonths(interval).Year.ToString)

            'Find the correct day of the week
            Do Until endDate.DayOfWeek = startDate.DayOfWeek
                endDate = endDate.AddDays(1)
            Loop
        End If

        'Set the return value
        Return endDate.AddDays(-1)

    End Function

End Class
