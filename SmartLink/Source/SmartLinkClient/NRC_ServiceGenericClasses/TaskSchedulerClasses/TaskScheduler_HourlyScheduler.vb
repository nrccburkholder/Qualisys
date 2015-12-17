'********************************************************************'
' Created by Elibad - 09/01/2007
'
'  This class inheriths the TaskScheduler functionality
'  and implements the Hourly Schedule
'*********************************************************************
Namespace Miscellaneous.TaskScheduler
    Public Class HourlyScheduler : Inherits Scheduler

        Public Sub New()
            MyBase.New(1, Date.Now.ToString, Date.Now.ToString, False)
        End Sub

        Public Sub New(ByVal Interval As Integer, ByVal StartDate As String, ByVal Time As String, ByVal Enabled As Boolean)
            MyBase.New(Interval, StartDate, Time, Enabled)
        End Sub

        Protected Overrides Function GetNextOccurrence(ByVal BaseDate As Date) As Date
            If Me._bFirstRun Then
                Dim dResult As Date = Date.Parse(BaseDate.ToString("MM/dd/yyyy") & " " & Me.Time)
                If Me.Time < Date.Now.ToString("HH:mm:ss") Then
                    If dResult.ToString("mm") <= Date.Now.ToString("mm") Then
                        dResult = DateTime.Parse(dResult.ToString("MM/dd/yyyy ") & Date.Now.AddHours(1).ToString("HH:") & dResult.ToString("mm:ss"))
                    Else
                        dResult = DateTime.Parse(dResult.ToString("MM/dd/yyyy ") & Date.Now.ToString("HH:") & dResult.ToString("mm:ss"))
                    End If
                End If
                GetNextOccurrence = dResult
            Else
                GetNextOccurrence = BaseDate.AddHours(Me.Interval)
            End If
            Me._bFirstRun = False
        End Function

    End Class

End Namespace
