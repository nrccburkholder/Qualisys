Public Class BiMonthlyRecurrenceControl

    Public ReadOnly Property SecondDay() As Integer
        Get
            Return Decimal.ToInt32(SecondDaySpinEdit.Value)
        End Get
    End Property

    Public ReadOnly Property FirstDay() As Integer
        Get
            Return Decimal.ToInt32(FirstDaySpinEdit.Value)
        End Get
    End Property

End Class
