Namespace Configuration

    ''' <summary>
    ''' Represents a collection of Environments
    ''' </summary>
    <Serializable()> Public Class EnvironmentCollection
        Inherits Specialized.NameObjectCollectionBase

        Default Public ReadOnly Property Item(ByVal environmentName As String) As Environment
            Get
                Return DirectCast(MyBase.BaseGet(environmentName.ToLower), Environment)
            End Get
        End Property
        Default Public ReadOnly Property Item(ByVal index As Integer) As Environment
            Get
                Return DirectCast(MyBase.BaseGet(index), Environment)
            End Get
        End Property

        Public Sub Add(ByVal environment As Environment)
            MyBase.BaseAdd(environment.Name.ToLower, environment)
        End Sub
    End Class
End Namespace
