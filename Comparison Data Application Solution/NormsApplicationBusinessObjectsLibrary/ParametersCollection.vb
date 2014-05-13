Public Class ParametersCollection
    Inherits CollectionBase

#Region " Public Properties"

    Default Public Property Item(ByVal index As Integer) As String
        Get
            Return CType(MyBase.List.Item(index), String)
        End Get
        Set(ByVal Value As String)
            MyBase.List.Item(index) = Value
        End Set
    End Property

#End Region

    Public Sub Add(ByVal value As String)
        MyBase.List.Add(value)
    End Sub
End Class
