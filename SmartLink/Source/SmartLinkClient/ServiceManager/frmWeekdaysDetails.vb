Public Class frmWeekdaysDetails


    Private Sub frmScheduleSettings_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Public Property WeekDays()
        Get
            WeekDays = GetWeekDaysString()
        End Get
        Set(ByVal value)
            ParseWeekDaysString(value)
        End Set
    End Property

    Private Function GetWeekDaysString() As String
        Dim Day As DayOfWeek
        Dim iCount As Integer
        Dim Days As String = String.Empty
        Dim chkDay As CheckBox

        GetWeekDaysString = String.Empty
        For iCount = 1 To 7
            chkDay = Me.grpWeekdays.Controls.Item("chkDay" & iCount.ToString())
            If chkDay.Checked Then
                Day = iCount - 1
                Days = Days & Day.ToString & ", "
            End If
        Next

        If Days.Length > 0 Then
            GetWeekDaysString = Days.Substring(0, Days.Length - 2)
        End If

    End Function

    Private Sub ParseWeekDaysString(ByVal WeekDays As String)
        If WeekDays.ToUpper.Contains("SUNDAY") Then
            MarkWeekDay(DayOfWeek.Sunday, True)
        Else
            MarkWeekDay(DayOfWeek.Sunday, False)
        End If

        If WeekDays.ToUpper.Contains("MONDAY") Then
            MarkWeekDay(DayOfWeek.Monday, True)
        Else
            MarkWeekDay(DayOfWeek.Monday, False)
        End If

        If WeekDays.ToUpper.Contains("TUESDAY") Then
            MarkWeekDay(DayOfWeek.Tuesday, True)
        Else
            MarkWeekDay(DayOfWeek.Tuesday, False)
        End If

        If WeekDays.ToUpper.Contains("WEDNESDAY") Then
            MarkWeekDay(DayOfWeek.Wednesday, True)
        Else
            MarkWeekDay(DayOfWeek.Wednesday, False)
        End If

        If WeekDays.ToUpper.Contains("THURSDAY") Then
            MarkWeekDay(DayOfWeek.Thursday, True)
        Else
            MarkWeekDay(DayOfWeek.Thursday, False)
        End If

        If WeekDays.ToUpper.Contains("FRIDAY") Then
            MarkWeekDay(DayOfWeek.Friday, True)
        Else
            MarkWeekDay(DayOfWeek.Friday, False)
        End If

        If WeekDays.ToUpper.Contains("SATURDAY") Then
            MarkWeekDay(DayOfWeek.Saturday, True)
        Else
            MarkWeekDay(DayOfWeek.Saturday, False)
        End If
    End Sub

    Private Sub MarkWeekDay(ByVal WeekDay As DayOfWeek, ByVal Value As Boolean)
        Dim chkDay As CheckBox
        Dim iDay As Integer

        iDay = WeekDay + 1
        chkDay = Me.grpWeekdays.Controls.Item("chkDay" & iDay.ToString)
        chkDay.Checked = Value
    End Sub

    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click

    End Sub
End Class
