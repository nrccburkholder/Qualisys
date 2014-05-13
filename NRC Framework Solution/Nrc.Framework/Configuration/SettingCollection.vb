Namespace Configuration

    ''' <summary>Represents a collection of Settings</summary>
    <Serializable()> Public Class SettingCollection
        Inherits Specialized.NameObjectCollectionBase

        Default Public ReadOnly Property Item(ByVal name As String) As Setting
            Get
                Return DirectCast(BaseGet(name.ToLower), Setting)
            End Get
        End Property
        Default Public ReadOnly Property Item(ByVal index As Integer) As Setting
            Get
                Return DirectCast(BaseGet(index), Setting)
            End Get
        End Property

        Public Sub Add(ByVal value As Setting)
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