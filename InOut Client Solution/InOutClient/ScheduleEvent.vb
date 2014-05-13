<Serializable()> _
Public Class ScheduleEvent
    Implements ICloneable

    <Flags()> _
    Enum EventFrequency
        Monday = 1
        Tuesday = 2
        Wednesday = 4
        Thursday = 8
        Friday = 16
        Saturday = 32
        Sunday = 64
        Daily = 127
        Weekdays = 31
        Weekends = 96
    End Enum

#Region " Time Structure "
    Public Structure Time
        Private mHour As Integer
        Private mMinute As Integer

        Public Property Hour() As Integer
            Get
                Return mHour
            End Get
            Set(ByVal Value As Integer)
                mHour = Value
            End Set
        End Property
        Public Property Minute() As Integer
            Get
                Return mMinute
            End Get
            Set(ByVal Value As Integer)
                mMinute = Value
            End Set
        End Property

        Sub New(ByVal hr As Integer, ByVal min As Integer)
            mHour = hr
            mMinute = min
        End Sub

        Public Overrides Function ToString() As String
            Dim dayPart As String
            Dim dayHour As Integer

            If mHour > 12 Then
                dayHour = mHour - 12
                dayPart = "PM"
            Else
                dayHour = mHour
                dayPart = "AM"
            End If
            Return String.Format("{0}:{1} {2}", dayHour, mMinute.ToString.PadLeft(2, Convert.ToChar("0")), dayPart)
        End Function

        Public Shared Function FromTimeSpan(ByVal span As TimeSpan) As Time
            Return New Time(span.Hours, span.Minutes)
        End Function
    End Structure
#End Region

    Private mFreq As EventFrequency
    Private mScheduledTime As Time
    Private mStatusId As Integer

#Region " Public Properties "
    Public Property Frequency() As EventFrequency
        Get
            Return mFreq
        End Get
        Set(ByVal Value As EventFrequency)
            mFreq = Value
        End Set
    End Property
    Public Property ScheduledTime() As Time
        Get
            Return mScheduledTime
        End Get
        Set(ByVal Value As Time)
            mScheduledTime = Value
        End Set
    End Property
    Public Property StatusId() As Integer
        Get
            Return mStatusId
        End Get
        Set(ByVal Value As Integer)
            mStatusId = Value
        End Set
    End Property
#End Region

    Sub New()
    End Sub

    Sub New(ByVal frequency As EventFrequency, ByVal time As Time, ByVal statusId As Integer)
        Me.mFreq = frequency
        Me.mScheduledTime = time
        Me.mStatusId = statusId
    End Sub

    Private Sub New(ByVal evnt As ScheduleEvent)
        Me.mFreq = evnt.mFreq
        Me.mScheduledTime = New Time(evnt.ScheduledTime.Hour, evnt.ScheduledTime.Minute)
        Me.mStatusId = StatusId
    End Sub

    Public Function HappensOnDay(ByVal day As DayOfWeek) As Boolean
        Dim d As EventFrequency = DayOfWeekToDay(day)
        If (mFreq And d) = d Then
            Return True
        Else
            Return False
        End If
        'Dim isValidDay As Boolean = False
        'Select Case mFreq
        '    Case EventFrequency.Daily
        '        isValidDay = True
        '    Case EventFrequency.Weekends
        '        If day.DayOfWeek > 5 Then
        '            isValidDay = True
        '        End If
        '    Case EventFrequency.Weekdays
        '        If day.DayOfWeek < 6 Then
        '            isValidDay = True
        '        End If
        'End Select

        'Return isValidDay
    End Function

    Private Function DayOfWeekToDay(ByVal d As DayOfWeek) As EventFrequency
        Select Case d
            Case DayOfWeek.Monday
                Return EventFrequency.Monday
            Case DayOfWeek.Tuesday
                Return EventFrequency.Tuesday
            Case DayOfWeek.Wednesday
                Return EventFrequency.Wednesday
            Case DayOfWeek.Thursday
                Return EventFrequency.Thursday
            Case DayOfWeek.Friday
                Return EventFrequency.Friday
            Case DayOfWeek.Saturday
                Return EventFrequency.Saturday
            Case DayOfWeek.Sunday
                Return EventFrequency.Sunday
        End Select
    End Function

    Public Function HasHappenedToday() As Boolean
        'Dim now As DateTime = DateTime.Now

        'If HappensOnDay(now.DayOfWeek) Then
        If Now.Hour > mScheduledTime.Hour Then
            Return True
        ElseIf Now.Hour = mScheduledTime.Hour Then
            If Now.Minute >= mScheduledTime.Minute Then
                Return True
            End If
        End If
        'End If

        Return False
    End Function

    Public Function Clone() As Object Implements System.ICloneable.Clone
        Return New ScheduleEvent(Me)
    End Function
End Class
