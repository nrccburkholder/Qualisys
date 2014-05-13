Option Strict On

Public Class DimensionsCollection
    Inherits CollectionBase

#Region " Public Properties"

    Default Public Property Item(ByVal index As Integer) As Dimension
        Get
            Return CType(MyBase.List.Item(index), Dimension)
        End Get
        Set(ByVal Value As Dimension)
            MyBase.List.Item(index) = Value
        End Set
    End Property

#End Region

    Public Sub Add(ByVal value As Dimension)
        MyBase.List.Add(value)
    End Sub

End Class
