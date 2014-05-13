Option Strict On

Public Class GroupingsCollection
    Inherits CollectionBase

#Region " Public Properties"

    Default Public Property Item(ByVal index As Integer) As Groupings
        Get
            Return CType(MyBase.List.Item(index), Groupings)
        End Get
        Set(ByVal Value As Groupings)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Public Sub Add(ByVal dest As Groupings)
        MyBase.List.Add(dest)
    End Sub

#End Region

End Class
