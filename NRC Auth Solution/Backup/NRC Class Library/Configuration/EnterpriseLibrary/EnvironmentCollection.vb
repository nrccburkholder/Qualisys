Namespace Configuration.EnterpriseLibrary


    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC Class Library
    ''' Class	 : Configuration.EnterpriseLibrary.EnvironmentCollection
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents a collection of Environments
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	8/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
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
