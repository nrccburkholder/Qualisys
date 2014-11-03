' Collection of GroupItem objects.

Public Class GroupItemCollection
    Inherits CollectionBase

    ' Return the item at the specified index.
    Default Public ReadOnly Property Item(ByVal Index As Integer) As GroupItem
        Get
            Return DirectCast(List(Index), GroupItem)
        End Get
    End Property

    ' Adds elements to the list.
    Public Sub AddRange(ByVal Items() As GroupItem)
        For Each item As GroupItem In Items
            List.Add(item)
        Next
    End Sub

    ' Add one element to the list.
    Public Sub Add(ByVal Item As GroupItem)
        List.Add(Item)
    End Sub
End Class
