Option Explicit On 
Option Strict On

Public Class ApbPathCollection
    Inherits DictionaryBase

    Public Sub Add(ByVal key As String, ByVal value As ApbPath)
        MyBase.Dictionary.Add(key.ToUpper, value)
    End Sub

    Default Public Property Item(ByVal key As String) As ApbPath
        Get
            Return CType(MyBase.Dictionary.Item(key.ToUpper), ApbPath)
        End Get
        Set(ByVal Value As ApbPath)
            MyBase.Dictionary(key.ToUpper) = Value
        End Set
    End Property

    Public ReadOnly Property Values() As ICollection
        Get
            Return Dictionary.Values
        End Get
    End Property

End Class
