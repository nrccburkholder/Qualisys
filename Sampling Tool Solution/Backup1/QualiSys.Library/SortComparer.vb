Imports System
Imports System.Collections.Generic
Imports System.Text
Imports System.ComponentModel

Class SortComparer(Of T)
    Implements IComparer(Of T)

#Region " Private Members "

    Private mSortCollection As ListSortDescriptionCollection = Nothing
    Private mPropDesc As PropertyDescriptor = Nothing
    Private mDirection As ListSortDirection = ListSortDirection.Ascending

#End Region

#Region " Constructors "

    Public Sub New(ByVal propDesc As PropertyDescriptor, ByVal direction As ListSortDirection)

        mPropDesc = propDesc
        mDirection = direction

    End Sub


    Public Sub New(ByVal sortCollection As ListSortDescriptionCollection)

        mSortCollection = sortCollection

    End Sub

#End Region

#Region " IComparer(Of T) Methods "

    Function Compare(ByVal x As T, ByVal y As T) As Integer Implements IComparer(Of T).Compare

        If mPropDesc IsNot Nothing Then
            ' Simple sort 
            Dim xValue As Object = mPropDesc.GetValue(x)
            Dim yValue As Object = mPropDesc.GetValue(y)
            Return CompareValues(xValue, yValue, mDirection)
        Else
            If mSortCollection IsNot Nothing AndAlso mSortCollection.Count > 0 Then
                Return RecursiveCompareInternal(x, y, 0)
            Else
                Return 0
            End If
        End If

    End Function

#End Region

#Region " Private Methods "

    Private Function CompareValues(ByVal xValue As Object, ByVal yValue As Object, ByVal direction As ListSortDirection) As Integer

        Dim retValue As Integer = 0

        'Compare the values
        If xValue Is Nothing And yValue Is Nothing Then
            'Both values are nothing so assume equal
            retValue = 0
        ElseIf TypeOf xValue Is IComparable Then
            'X Value is IComparable so do the deed
            retValue = (DirectCast(xValue, IComparable)).CompareTo(yValue)
        ElseIf TypeOf yValue Is IComparable Then
            'Y Value is IComparable so do the deed and reverse the return value since we are comparing Y to X instead of X to Y
            retValue = (DirectCast(yValue, IComparable)).CompareTo(xValue) * -1
        ElseIf Not xValue.Equals(yValue) Then
            'X Value and Y Value are not IComparable so compare String representations
            retValue = xValue.ToString().CompareTo(yValue.ToString())
        End If

        'Adjust return value based on sort direction
        If direction = ListSortDirection.Ascending Then
            Return retValue
        Else
            Return retValue * -1
        End If

    End Function


    Private Function RecursiveCompareInternal(ByVal x As T, ByVal y As T, ByVal index As Integer) As Integer

        'Check to see if we are out of range
        If index >= mSortCollection.Count Then
            Return 0
        End If

        'Recursively compare
        Dim listSortDesc As ListSortDescription = mSortCollection(index)
        Dim xValue As Object = listSortDesc.PropertyDescriptor.GetValue(x)
        Dim yValue As Object = listSortDesc.PropertyDescriptor.GetValue(y)
        Dim retValue As Integer = CompareValues(xValue, yValue, listSortDesc.SortDirection)
        If retValue = 0 Then
            Return RecursiveCompareInternal(x, y, System.Threading.Interlocked.Increment(index))
        Else
            Return retValue
        End If

    End Function

#End Region

End Class
