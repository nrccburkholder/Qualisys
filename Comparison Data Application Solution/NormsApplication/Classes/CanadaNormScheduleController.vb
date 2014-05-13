Option Explicit On 
Option Strict On

Imports System.Text
Imports System.Data.SqlClient
Imports NormsApplicationBusinessObjectsLibrary

Public Class CanadaNormScheduleController

#Region " Private Fields"

    Private Enum CheckSchedulableResult
        Scheduleable = 0
        NotApproved = 1
        AlreadyScheduled = 2
    End Enum

#End Region

#Region " Public Methods"

    Public Function SelectSchedulableNorm() As SqlDataReader
        Return DataAccess.SelectCanadaSchedulableNorm
    End Function

    Public Sub ScheduleJob(ByVal normID As Integer, ByVal scheduledStartTime As Date)
        Select Case CheckNormSchedulable(normID)
            Case CheckSchedulableResult.NotApproved
                Throw New ArgumentException("Norm settings haven't been approved.")
            Case CheckSchedulableResult.AlreadyScheduled
                Throw New ArgumentException("Norm is already scheduled.")
        End Select

        Dim memberID As Integer = CurrentUser.Member.MemberId
        DataAccess.ScheduleCanadaNormUpdate(normID, memberID, scheduledStartTime)
    End Sub

#End Region

#Region " Private Methods"

    Private Function CheckNormSchedulable(ByVal normID As Integer) As CheckSchedulableResult
        Return CType(DataAccess.CheckNormSchedulable(normID), CheckSchedulableResult)
    End Function

#End Region

End Class
