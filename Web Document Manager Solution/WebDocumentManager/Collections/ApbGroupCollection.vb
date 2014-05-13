Option Explicit On 
Option Strict On

'Public Class ApbGroupCollection
'    Inherits CollectionBase

'    Default Public ReadOnly Property Item(ByVal index As Integer) As ApbGroup
'        Get
'            Return DirectCast(MyBase.List(index), ApbGroup)
'        End Get
'    End Property

'    Public Function Add(ByVal group As ApbGroup) As Integer
'        Return MyBase.List.Add(group)
'    End Function

'End Class

Public Class ApbGroupCollection
    Inherits DictionaryBase

    Public Sub Add(ByVal key As Integer, ByVal value As ApbGroup)
        MyBase.Dictionary.Add(key, value)
    End Sub

    Default Public Property Item(ByVal key As Integer) As ApbGroup
        Get
            Return CType(MyBase.Dictionary.Item(key), ApbGroup)
        End Get
        Set(ByVal Value As ApbGroup)
            MyBase.Dictionary(key) = Value
        End Set
    End Property

    Public ReadOnly Property Values() As ICollection
        Get
            Return Dictionary.Values
        End Get
    End Property

End Class