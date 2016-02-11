Option Explicit On
Option Strict On


Public Class ComparisonTypes
    Private Sub New()
    End Sub

    Public Enum ComparisonTypesEnum
        Equal = 1
        NotEqual = 2
        GreaterThan = 3
        LessThan = 4
        GreaterThanOrEqual = 5
        LessThanOrEqual = 6
    End Enum

    Public Shared Function GetOperatorAsString(ByVal operation As ComparisonTypes.ComparisonTypesEnum) As String
        Select Case (operation)
            Case ComparisonTypesEnum.Equal
                Return "="
            Case ComparisonTypesEnum.GreaterThan
                Return ">"
            Case ComparisonTypesEnum.GreaterThanOrEqual
                Return ">="
            Case ComparisonTypesEnum.LessThan
                Return "<"
            Case ComparisonTypesEnum.LessThanOrEqual
                Return "<="
            Case ComparisonTypesEnum.NotEqual
                Return "<>"
            Case Else
                Throw New ArgumentOutOfRangeException("operation", operation, "The value of operation is not a recognized type in ComparisonTypes.GetOperatorAsString()!")
        End Select
    End Function

    Public Shared Function DoComparison(ByVal operation As ComparisonTypes.ComparisonTypesEnum, ByVal obj1 As IComparable, ByVal obj2 As IComparable) As Boolean
        Dim result As Integer = obj1.CompareTo(obj2)

        Select Case (operation)
            Case ComparisonTypesEnum.Equal
                Return (0 = result)
            Case ComparisonTypesEnum.GreaterThan
                Return (result > 0)
            Case ComparisonTypesEnum.GreaterThanOrEqual
                Return (result >= 0)
            Case ComparisonTypesEnum.LessThan
                Return (result < 0)
            Case ComparisonTypesEnum.LessThanOrEqual
                Return (result <= 0)
            Case ComparisonTypesEnum.NotEqual
                Return (0 <> result)
            Case Else
                Throw New ArgumentOutOfRangeException("operation", operation, "The value of operation is not a recognized type in ComparisonTypes.GetOperatorAsString()!")
        End Select
    End Function
End Class
