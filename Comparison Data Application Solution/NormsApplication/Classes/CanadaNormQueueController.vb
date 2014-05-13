Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports NormsApplicationBusinessObjectsLibrary

Public Class CanadaNormQueueController

#Region " Private Fields"

    Private mDays As Integer = 1

#End Region

#Region " Public Properties"

    Public Property Days() As Integer
        Get
            Return mDays
        End Get
        Set(ByVal Value As Integer)
            mDays = Value
        End Set
    End Property

#End Region

#Region " Public Methods"

    Public Function SelectJobQueue() As SqlDataReader
        Return DataAccess.SelectCanadaJobQueue(mDays)
    End Function

    Public Sub ApproveNormUpdate(ByVal normJobID As Integer, ByVal isApprove As Boolean)
        DataAccess.ApproveCanadaNormUpdate(normJobID, isApprove)
    End Sub

    Public Sub RemoveJob(ByVal normJobID As Integer)
        DataAccess.RemoveCanadaNormJob(normJobID)
    End Sub

#End Region

End Class
