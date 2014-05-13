Option Strict On

Public Class QPClientCollection
    Inherits CollectionBase

#Region " Public Properties"

    Default Public Property Item(ByVal index As Integer) As QPClient
        Get
            Return CType(MyBase.List.Item(index), QPClient)
        End Get
        Set(ByVal Value As QPClient)
            MyBase.List.Item(index) = Value
        End Set
    End Property

#End Region

    Public Sub Add(ByVal value As QPClient)
        MyBase.List.Add(value)
    End Sub

End Class
