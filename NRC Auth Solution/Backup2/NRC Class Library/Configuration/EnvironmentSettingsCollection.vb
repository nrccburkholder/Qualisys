Namespace Configuration
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Configuration.EnvironmentSettingsCollection
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents a collection of all the EnvironmentSettings objects as they are defined
    ''' in a .Config file.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/15/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class EnvironmentSettingsCollection
        Inherits System.Collections.Specialized.NameObjectCollectionBase

#Region " Private Members "
        Private mCurrentEnvironment As EnvironmentSettings
#End Region

#Region " Public Properties "

        Default Public ReadOnly Property Items(ByVal name As String) As EnvironmentSettings
            Get
                Return DirectCast(MyBase.BaseGet(name), EnvironmentSettings)
            End Get
        End Property
        Default Public ReadOnly Property Items(ByVal index As Integer) As EnvironmentSettings
            Get
                Return DirectCast(MyBase.BaseGet(index), EnvironmentSettings)
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Determines if a certain environment is contained in the collection.
        ''' </summary>
        ''' <param name="name">the name of the environment to search for</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property Contains(ByVal name As String) As Boolean
            Get
                Return (Not MyBase.BaseGet(name) Is Nothing)
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The EnvironmentSettings object for the application's current environment
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property CurrentEnvironment() As EnvironmentSettings
            Get
                Return mCurrentEnvironment
            End Get
            Set(ByVal Value As EnvironmentSettings)
                mCurrentEnvironment = Value
            End Set
        End Property
#End Region

#Region " Public Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Adds a new EnvironmentSettings object to the collection
        ''' </summary>
        ''' <param name="settings">the EnvironmentSettings object to add.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub Add(ByVal settings As EnvironmentSettings)
            If Contains(settings.EnvironmentName) Then
                Throw New ArgumentException("Environment name must be unique", "settings.EnvironmentName")
            End If

            MyBase.BaseAdd(settings.EnvironmentName, settings)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Sets the current Environment based on the environment identifier.
        ''' </summary>
        ''' <param name="identifier">The identifier for the environment that will be set as the current.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub SetCurrentEnvironment(ByVal identifier As String)
            Dim e As EnvironmentSettings
            e = GetEnvironmentFromID(identifier)

            If e Is Nothing Then
                Throw New ApplicationException("Environment identifier '" & identifier & "' could not be found.")
            End If

            mCurrentEnvironment = e
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns the EnvironmentSetting object with the given identifier
        ''' </summary>
        ''' <param name="identifier">The environment identifier for the environment</param>
        ''' <returns></returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Function GetEnvironmentFromID(ByVal identifier As String) As EnvironmentSettings
            Dim e As EnvironmentSettings
            Dim i As Integer = 0

            For i = 0 To Me.Count - 1
                e = Items(i)
                If e.HasIdentifier(identifier) Then
                    Return e
                End If
            Next

            Return Nothing
        End Function
#End Region

    End Class
End Namespace
