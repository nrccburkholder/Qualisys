Option Explicit On 
Option Strict On

Public Class ApbGroupListItemCollection
    Inherits DictionaryBase

    Public Sub Add(ByVal key As Integer, ByVal value As ApbGroupListItem)
        Dictionary.Add(key, value)
    End Sub

    Default Public Property Item(ByVal key As Integer) As ApbGroupListItem
        Get
            Return CType(Dictionary.Item(key), ApbGroupListItem)
        End Get
        Set(ByVal Value As ApbGroupListItem)
            Dictionary.Item(key) = Value
        End Set
    End Property

    Public ReadOnly Property Values() As ICollection
        Get
            Return Dictionary.Values
        End Get
    End Property

End Class
