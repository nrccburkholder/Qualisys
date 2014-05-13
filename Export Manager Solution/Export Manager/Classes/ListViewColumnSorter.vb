Public Class ListViewColumnSorter
    Implements IComparer

    Private mColumnToSort As Integer
    Private mSortOrder As SortOrder
    Private mStringComparer As CaseInsensitiveComparer

    Public Property ColumnToSort() As Integer
        Get
            Return mColumnToSort
        End Get
        Set(ByVal value As Integer)
            mColumnToSort = value
        End Set
    End Property
    Public Property SortOrder() As SortOrder
        Get
            Return mSortOrder
        End Get
        Set(ByVal value As SortOrder)
            mSortOrder = value
        End Set
    End Property

    Public Sub New()
        Me.mColumnToSort = 0
        Me.mSortOrder = SortOrder.None
        Me.mStringComparer = New CaseInsensitiveComparer(Globalization.CultureInfo.CurrentCulture)
    End Sub

    Public Function Compare(ByVal x As Object, ByVal y As Object) As Integer Implements System.Collections.IComparer.Compare
        Dim result As Integer
        Dim itemA As ListViewItem
        Dim itemB As ListViewItem

        If x Is Nothing Then
            Throw New ArgumentNullException("x")
        End If
        If y Is Nothing Then
            Throw New ArgumentNullException("y")
        End If

        itemA = TryCast(x, ListViewItem)
        itemB = TryCast(y, ListViewItem)
        If itemA Is Nothing Then
            Throw New InvalidCastException("Cannot convert x to a ListViewItem")
        End If
        If itemB Is Nothing Then
            Throw New InvalidCastException("Cannot convert y to a ListViewItem")
        End If


        Dim textA As String = itemA.SubItems(mColumnToSort).Text
        Dim textB As String = itemB.SubItems(mColumnToSort).Text
        Dim intA As Integer
        Dim intB As Integer
        Dim dateA As Date
        Dim dateB As Date

        'Test what kind of comparison needs to be done
        If Integer.TryParse(textA, intA) AndAlso Integer.TryParse(textB, intB) Then
            result = Me.IntegerCompare(intA, intB)
        ElseIf (Date.TryParse(textA, dateA) AndAlso Date.TryParse(textB, dateB)) Then
            result = Me.DateCompare(dateA, dateB)
        Else
            result = Me.StringCompare(textA, textB)
        End If

        'Reverse the sort if needed
        If mSortOrder = SortOrder.Ascending Then
            Return result
        ElseIf mSortOrder = SortOrder.Descending Then
            Return -result
        Else
            Return 0
        End If
    End Function

    Private Function StringCompare(ByVal s1 As String, ByVal s2 As String) As Integer
        Return mStringComparer.Compare(s1, s2)
    End Function

    Private Function IntegerCompare(ByVal i1 As Integer, ByVal i2 As Integer) As Integer
        Return i1.CompareTo(i2)
    End Function

    Private Function DateCompare(ByVal d1 As Date, ByVal d2 As Date) As Integer
        Return Date.Compare(d1, d2)
    End Function
End Class
