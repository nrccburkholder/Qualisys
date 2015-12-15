Option Explicit On
'********************************************************************'
' Created by Elibad - 09/01/2007
'
'  This class inheriths the TaskScheduler functionality
'  and implements the Monthly Schedule
'*********************************************************************
Namespace Miscellaneous.TaskScheduler
    Public Class QuarterlyScheduler : Inherits Scheduler
        Private _iDayOfMonth As Integer = 1

        Public Property DayofMonth() As Integer
            Get
                Return _iDayOfMonth
            End Get
            Set(ByVal value As Integer)
                If value <= 31 Then
                    _iDayOfMonth = value
                Else
                    Throw New System.Exception("Invalid Day of Month. This value can not be higher than 31")
                End If

            End Set
        End Property

        Public Sub New()
            MyBase.New()
        End Sub

        Public Sub New(ByVal Time As String)
            MyBase.New(Time)
        End Sub

        Public Sub New(ByVal Interval As Integer, ByVal StartDate As String, ByVal Time As String, ByVal Enabled As Boolean)
            MyBase.New(Interval, StartDate, Time, Enabled)
        End Sub

        Protected Overrides Function GetNextOccurrence(ByVal BaseDate As DateTime) As DateTime
            Dim iInterval As Integer = 1
            Dim MaxDays As Integer
            Dim iaddMonths As Integer = 1
            Dim iModMonth As Integer
            Dim dTestCheck As DateTime

            'Do While BaseDate.AddDays(iInterval).Day <> _iDayOfMonth
            '    iInterval += 1
            'Loop

            If BaseDate > DateTime.Now Then
                dTestCheck = BaseDate
            Else
                dTestCheck = DateTime.Now
            End If

            'iModMonth = (BaseDate.AddDays(iInterval).Month - 1) Mod 3
            iModMonth = (BaseDate.Month - 1) Mod 3

            If iModMonth <> 0 Or (iModMonth = 0 And (_iDayOfMonth <= dTestCheck.Day And Me.Time <= dTestCheck.ToString("HH:mm"))) Then
                iaddMonths = 3 - iModMonth
            Else
                iaddMonths = 0
            End If

            MaxDays = Date.DaysInMonth(BaseDate.AddDays(iInterval).Year, BaseDate.AddDays(iInterval).Month)

            If _iDayOfMonth >= MaxDays Then
                Return Date.Parse(BaseDate.AddMonths(iaddMonths).ToString("MM/") & MaxDays.ToString & BaseDate.AddMonths(iaddMonths).ToString("/yyyy ") & Me.Time)
            Else
                Return Date.Parse(BaseDate.AddMonths(iaddMonths).ToString("MM/") & _iDayOfMonth.ToString & BaseDate.AddMonths(iaddMonths).ToString("/yyyy ") & Me.Time)
                'Return Date.Parse(BaseDate.AddMonths(iaddMonths).AddDays(iInterval).ToString("MM/dd/yyyy") & " " & Me.Time)
            End If
        End Function
    End Class
End Namespace