Option Explicit On 
Option Strict On

Public Class DateRange

#Region " Private Members"

    Private mDateBegin As Date
    Private mDateEnd As Date

#End Region

#Region " Public Properties"

    Public Property DateBegin() As Date
        Get
            Return mDateBegin
        End Get
        Set(ByVal Value As Date)
            mDateBegin = Value
        End Set
    End Property

    Public Property DateEnd() As Date
        Get
            Return mDateEnd
        End Get
        Set(ByVal Value As Date)
            mDateEnd = Value
        End Set
    End Property

#End Region

#Region " Public Methods"

    Public Sub New()

    End Sub

    Public Sub New(ByVal dateBegin As Date, ByVal dateEnd As Date)
        If (dateBegin <= dateEnd) Then
            mDateBegin = dateBegin
            mDateEnd = dateEnd
        Else
            mDateBegin = dateEnd
            mDateEnd = dateBegin
        End If
    End Sub

#End Region
End Class
