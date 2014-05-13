Public Class MonthListItem

    Private mMonthName As String
    Private mMonthNumber As Integer

    Public ReadOnly Property MonthName() As String
        Get
            Return mMonthName
        End Get
    End Property

    Public ReadOnly Property MonthNumber() As Integer
        Get
            Return mMonthNumber
        End Get
    End Property

    Public Sub New(ByVal monthName As String, ByVal monthNumber As Integer)
        mMonthName = monthName
        mMonthNumber = monthNumber
    End Sub

End Class
