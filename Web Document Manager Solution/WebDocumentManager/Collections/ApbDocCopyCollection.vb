Option Explicit On 
Option Strict On

Public Class ApbDocCopyCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As ApbDocCopy
        Get
            Return DirectCast(MyBase.List(index), ApbDocCopy)
        End Get
    End Property

    Public Function Add(ByVal value As ApbDocCopy) As Integer
        Return MyBase.List.Add(value)
    End Function

End Class
