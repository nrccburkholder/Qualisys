Imports System.Reflection
Imports System.ComponentModel
Public Enum SortDirection
    Descending
    Ascending
End Enum
Public Class PropertyComparer(Of T)
    Implements IComparer(Of T)
    Private FPropertyName As String = ""
    Private FDirection As SortDirection
    Public Sub New(ByVal propertyName As String)
        FPropertyName = propertyName
        FDirection = SortDirection.Ascending
    End Sub
    Public Sub New(ByVal propertyName As String, _
       ByVal Direction As SortDirection)
        FPropertyName = propertyName
        FDirection = Direction
    End Sub
    ' Try to sort based on type using CompareTo method
    ' Multiple by FDirection to alternate sort direction
    Public Function Compare(ByVal x As T, ByVal y As T) _
       As Integer Implements System.Collections.Generic. _
          IComparer(Of T).Compare
        Dim propertyX As PropertyInfo = _
           x.GetType().GetProperty(FPropertyName)
        Dim propertyY As PropertyInfo = _
           y.GetType().GetProperty(FPropertyName)
        Dim px As Object = propertyX.GetValue(x, Nothing)
        Dim py As Object = propertyY.GetValue(y, Nothing)
        If (TypeOf px Is Integer) Then
            Return Compare(Of Integer)(CType(px, Integer), _
               CType(py, Integer)) * FDirection
        End If
        If (TypeOf px Is Decimal) Then
            Return Compare(Of Decimal)(CType(px, Decimal), _
               CType(py, Decimal)) * FDirection
        End If
        If (TypeOf px Is DateTime) Then
            Return Compare(Of DateTime)(CType(px, DateTime), _
               CType(py, DateTime)) * FDirection
        End If
        If (TypeOf px Is Double) Then
            Return Compare(Of Double)(CType(px, Double), _
               CType(py, Double)) * FDirection
        End If
        If (TypeOf px Is String) Then
            Return Compare(Of String)(CType(px, String), _
               CType(py, String)) * FDirection
        End If
        If (TypeOf px Is Decimal) Then
            Return Compare(Of Decimal)(CType(px, Decimal), _
               CType(py, Decimal)) * FDirection
        End If
        Dim methodX As Reflection.MethodInfo = _
           propertyX.GetType().GetMethod("CompareTo")
        If (methodX Is Nothing = False) Then
            Return CType(methodX.Invoke(px, New Object() {py}), _
               Integer) * FDirection
        Else
            Return 0
        End If
    End Function
    Private Function Compare(Of K As IComparable)(ByVal x As K, _
       ByVal y As K) As Integer
        Return x.CompareTo(y)
    End Function

End Class