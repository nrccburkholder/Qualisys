Namespace Configuration

    <Serializable()> _
    Public Class ParamCollection
        Inherits Specialized.NameObjectCollectionBase

        Default Public ReadOnly Property Item(ByVal name As String) As Param
            Get
                Return DirectCast(BaseGet(name.ToLower), Param)
            End Get
        End Property

        Default Public ReadOnly Property Item(ByVal index As Integer) As Param
            Get
                Return DirectCast(BaseGet(index), Param)
            End Get
        End Property

        Public Sub Add(ByVal value As Param)

            Me.BaseAdd(value.Name.ToLower, value)

        End Sub

        Public Sub Remove(ByVal name As String)

            Me.BaseRemove(name)

        End Sub

        Public Sub Remove(ByVal index As Integer)

            Me.BaseRemoveAt(index)

        End Sub

    End Class

End Namespace
