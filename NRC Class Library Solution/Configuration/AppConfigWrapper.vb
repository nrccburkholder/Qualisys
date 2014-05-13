Imports System.Configuration
Namespace Configuration

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Configuration.AppConfigWrapper
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents a wrapper around a .Config file that contains an EnvironmentSettings section.
    '''  The wrapper is used to allow access to the .Config file setting through strongly
    ''' typed properties of a class.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <example>This is an example of how to inherit from NRC.Configuration.AppConfigWrapper
    ''' <code>
    ''' Imports System.Configuration.ConfigurationSettings
    ''' 
    '''   Public Class AppConfig
    '''     Inherits NRC.Configuration.AppConfigWrapper
    ''' 
    '''     'Singleton instance
    '''     Private Shared mInstance As AppConfig = New AppConfig
    ''' 
    '''     'Singleton Constructor is private
    '''     Private Sub New()
    '''     End Sub
    ''' 
    '''     'Returns the Singleton instance
    '''     Public Shared ReadOnly Property Instance() As AppConfig
    '''       Get
    '''         Return mInstance
    '''       End Get
    '''     End Property
    ''' 
    '''     'Determines the Environment Identifier for matching with the Configuration Environment Settings
    '''     Public Overrides ReadOnly Property EnvironmentIdentifier() As String
    '''       Get
    '''         Return Environment.MachineName
    '''       End Get
    '''     End Property
    ''' 
    '''     Public ReadOnly Property ConnectionString() As String
    '''       Get
    '''         Return EnvironmentSetting("connectionString")
    '''       End Get
    '''     End Property
    ''' 
    '''     Public ReadOnly Property AutoUpdateURL() As String
    '''       Get
    '''         Return EnvironmentSetting("autoUpdateURL")
    '''       End Get
    '''     End Property
    ''' 
    '''     Public ReadOnly Property TestSetting() As String
    '''       Get
    '''         Return EnvironmentSetting("TestSetting")
    '''       End Get
    '''     End Property
    ''' 
    '''   End Class
    ''' </code>
    ''' </example>
    ''' <history>
    ''' 	[JCamp]	7/15/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public MustInherit Class AppConfigWrapper

#Region " Private Members "
        Private mEnvironmentSettings As NRC.Configuration.EnvironmentSettingsCollection
#End Region

#Region " Protected Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>Gets the EnvironmentSettings object from the .Config file
        ''' </summary>
        ''' <remarks>
        ''' Gets the EnvironmentSettingsCollection of the .Config file and if the current 
        ''' environment is explicitly defined in the XML returns the associated EnvironmentSettings
        ''' object.  If the current environment is not explicitly defined then it will be 
        ''' automatically determined using the EnvironmentIdentifier property that must be 
        ''' implemented by classes that derive from AppConfigWrapper.
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected ReadOnly Property CurrentEnvironment() As EnvironmentSettings
            Get
                'If we haven't yet gotten the collection then go get it
                If mEnvironmentSettings Is Nothing Then
                    'Get the collection from the config file
                    mEnvironmentSettings = DirectCast(ConfigurationSettings.GetConfig("environmentSettings"), EnvironmentSettingsCollection)

                    'If the current environment cannot be determined from the .Config file
                    'If mEnvironmentSettings.CurrentEnvironment Is Nothing Then
                    '    'Then get the current environment that is associated with the
                    '    'EnvironmentIdentifier returned by the property implemented
                    '    'by the derived class.
                    '    mEnvironmentSettings.SetCurrentEnvironment(EnvironmentIdentifier)
                    'End If

                End If

                'Now return the environment
                'If the current environment cannot be determined from the .Config file
                If mEnvironmentSettings.CurrentEnvironment Is Nothing Then
                    Return mEnvironmentSettings.GetEnvironmentFromID(EnvironmentIdentifier)
                Else        'Other wise return what was defined in the .Config file as current environment
                    Return mEnvironmentSettings.CurrentEnvironment
                End If
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns the value of a given setting in the current environment.
        ''' </summary>
        ''' <param name="settingName">The name of the setting that should be returned.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected ReadOnly Property EnvironmentSetting(ByVal settingName As String) As String
            Get
                Return CurrentEnvironment.Item(settingName)
            End Get
        End Property
#End Region

#Region " Public Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns the name associated with the current environment.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property EnvironmentName() As String
            Get
                Return CurrentEnvironment.EnvironmentName
            End Get
        End Property
#End Region

        Public Enum AppEnvironment
            Production = 0
            Testing = 1
            Development = 2
        End Enum

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The EnvironmentIdentifier for the client application.  This is only used if
        ''' the .Config file does not assign a current environment.
        ''' </summary>
        ''' <value></value>
        ''' <remarks>The class that derives from AppConfigWrapper must implement how an 
        ''' environment should be identified if the .Config file does not specifically
        ''' assign an environment.  For example, the client app might use the URL of a website
        ''' to determine which environment it is running under.  The .Config file would then
        ''' specify which URLs are associated with the production environment etc.
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public MustOverride ReadOnly Property EnvironmentIdentifier() As String

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns an enumeration specifying which of the three main environment types
        ''' the application is currently running under.        ''' 
        ''' </summary>
        ''' <value></value>
        ''' <remarks>This implementation assumes that the environment names in the .Config
        ''' file will be called "Production", "Testing", and "Development".  This property
        ''' is overridable if a different system needs to be used.
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Overridable ReadOnly Property EnvironmentType() As AppEnvironment
            Get
                Select Case Me.EnvironmentName.ToUpper
                    Case "PRODUCTION"
                        Return AppEnvironment.Production
                    Case "TESTING"
                        Return AppEnvironment.Testing
                    Case "DEVELOPMENT"
                        Return AppEnvironment.Development
                    Case Else
                        If Me.EnvironmentName.ToUpper.StartsWith("PRODUCTION") Then
                            Return AppEnvironment.Production
                        ElseIf Me.EnvironmentName.ToUpper.StartsWith("TESTING") Then
                            Return AppEnvironment.Testing
                        ElseIf Me.EnvironmentName.ToUpper.StartsWith("DEVELOPMENT") Then
                            Return AppEnvironment.Development
                        Else
                            Return AppEnvironment.Production
                        End If
                End Select
            End Get
        End Property

    End Class

End Namespace
