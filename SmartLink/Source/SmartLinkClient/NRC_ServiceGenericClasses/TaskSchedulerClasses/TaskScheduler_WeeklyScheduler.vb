Option Explicit On
'********************************************************************'
' Created by Elibad - 09/01/2007
'
'  This class inheriths the TaskScheduler functionality
'  and implements the Weekly Schedule
'*********************************************************************
Namespace Miscellaneous.TaskScheduler
    Public Class WeeklyScheduler : Inherits Scheduler
        Private _bWeekdays(7) As Boolean

        ''' <summary>
        ''' Sets the WeekDays using string format
        ''' </summary>
        Public Property WeekDays() As String
            Get
                Dim Day As DayOfWeek
                Dim iCount As Integer
                Dim Days As String = String.Empty

                For iCount = DayOfWeek.Sunday To DayOfWeek.Saturday
                    If _bWeekdays(iCount) Then
                        Day = CType(System.Enum.Parse(GetType(DayOfWeek), iCount.ToString), DayOfWeek)
                        Days = Days & Day.ToString & ", "
                    End If
                Next

                WeekDays = Days.Substring(0, Days.Length - 2)

            End Get
            Set(ByVal value As String)
                If value.ToUpper.Contains("SUNDAY") Then
                    MarkWeekDay(DayOfWeek.Sunday, True)
                Else
                    MarkWeekDay(DayOfWeek.Sunday, False)
                End If

                If value.ToUpper.Contains("MONDAY") Then
                    MarkWeekDay(DayOfWeek.Monday, True)
                Else
                    MarkWeekDay(DayOfWeek.Monday, False)
                End If

                If value.ToUpper.Contains("TUESDAY") Then
                    MarkWeekDay(DayOfWeek.Tuesday, True)
                Else
                    MarkWeekDay(DayOfWeek.Tuesday, False)
                End If

                If value.ToUpper.Contains("WEDNESDAY") Then
                    MarkWeekDay(DayOfWeek.Wednesday, True)
                Else
                    MarkWeekDay(DayOfWeek.Wednesday, False)
                End If

                If value.ToUpper.Contains("THURSDAY") Then
                    MarkWeekDay(DayOfWeek.Thursday, True)
                Else
                    MarkWeekDay(DayOfWeek.Thursday, False)
                End If

                If value.ToUpper.Contains("FRIDAY") Then
                    MarkWeekDay(DayOfWeek.Friday, True)
                Else
                    MarkWeekDay(DayOfWeek.Friday, False)
                End If

                If value.ToUpper.Contains("SATURDAY") Then
                    MarkWeekDay(DayOfWeek.Saturday, True)
                Else
                    MarkWeekDay(DayOfWeek.Saturday, False)
                End If
            End Set
        End Property

        Protected Overrides Function GetNextOccurrence(ByVal BaseDate As DateTime) As DateTime
            Dim iAddDays As Integer
            Dim iCounter As Integer
            Dim iDay As Integer

            iAddDays = 0

            iDay = BaseDate.DayOfWeek

            For iCounter = 0 To 6
                If iDay > 6 Then ' If new week use interval to add the extra weeks
                    iDay = 0
                    iAddDays = (Me.Interval - 1) * 7
                End If

                If _bWeekdays(iDay) And Date.Parse(BaseDate.AddDays(iAddDays + iCounter).ToString("MM/dd/yyyy") & " " & Me.Time) > Date.Now Then
                    Exit For
                End If
                iDay = iDay + 1
            Next

            If Me._bFirstRun Then
                iAddDays = iCounter
                Me._bFirstRun = False
            Else
                iAddDays = iAddDays + iCounter
            End If

            GetNextOccurrence = Date.Parse(BaseDate.AddDays(iAddDays).ToString("MM/dd/yyyy") & " " & Me.Time)

        End Function

        ''' <summary>
        ''' Marks an specific day of the week to run schedule
        ''' </summary>
        Public Sub MarkWeekDay(ByVal Day As DayOfWeek, Optional ByVal Flag As Boolean = True)
            _bWeekdays(Day) = Flag
            If Me.Enabled Then
                Me._bFirstRun = True
                Me.UpdateNextOccurrence()
            End If
        End Sub

        'Public Function GetWeekDayFlag(ByVal Day As Weekdays)
        '    GetWeekDayFlag = _bWeekdays(Day)
        'End Function

        Public Sub New()
            MyBase.New()
        End Sub



        Public Sub New(ByVal Time As String)
            MyBase.New(Time)
            Dim iCounter As Integer

            For iCounter = 0 To 7
                _bWeekdays(iCounter) = False
            Next
        End Sub

        Public Sub New(ByVal Interval As Integer, ByVal StartDate As String, ByVal Time As String, ByVal Enabled As Boolean)
            MyBase.New(Interval, StartDate, Time, Enabled)
        End Sub

    End Class


End Namespace
