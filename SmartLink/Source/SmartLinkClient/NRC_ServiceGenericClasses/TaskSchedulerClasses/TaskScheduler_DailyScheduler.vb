Option Explicit On
'********************************************************************'
' Created by Elibad - 09/01/2007
'
'  This class inheriths the TaskScheduler functionality
'  and implements the Daily Schedule
'*********************************************************************
Namespace Miscellaneous.TaskScheduler
    Public Class DailyScheduler : Inherits Scheduler


        Protected Overrides Function GetNextOccurrence(ByVal BaseDate As DateTime) As DateTime
            If Date.Now.ToString("HH:mm:ss") > Me.Time Then
                GetNextOccurrence = Date.Parse(BaseDate.AddDays(Me.Interval).ToString("MM/dd/yyyy") & " " & Me.Time)
            Else
                GetNextOccurrence = Date.Parse(BaseDate.ToString("MM/dd/yyyy") & " " & Me.Time)
            End If
            Me._bFirstRun = False
        End Function

        Public Sub New()
            MyBase.New()
        End Sub

        Public Sub New(ByVal Time As String)
            MyBase.New(Time)
        End Sub

        Public Sub New(ByVal Interval As Integer, ByVal StartDate As String, ByVal Time As String, ByVal Enabled As Boolean)
            MyBase.New(Interval, StartDate, Time, Enabled)
        End Sub

    End Class




End Namespace

