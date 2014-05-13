Imports System.Xml.Serialization


Namespace Configuration.EnterpriseLibrary

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC Class Library
    ''' Class	 : Configuration.EnterpriseLibrary.EnvironmentSettings
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents configuration settings for various defined environments.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	8/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    <Serializable(), XmlRoot("environmentSettings", Namespace:="")> _
    Public Class EnvironmentSettings

#Region " Shared Members "
        Private Shared mConfigManType As Type
        Private Shared ReadOnly Property ConfigManType() As Type
            Get
                If mConfigManType Is Nothing Then
                    mConfigManType = Type.GetType("Microsoft.Practices.EnterpriseLibrary.Configuration.ConfigurationManager, Microsoft.Practices.EnterpriseLibrary.Configuration", True)
                End If
                Return mConfigManType
            End Get
        End Property

#End Region

#Region " Private Members "
        Private mUseUrlDetection As Boolean
        Private mCurrentEnvironment As Environment
        Private mCurrentEnvironmentName As String
        Private mEnvironments As EnvironmentCollection
        Private mGlobalSettings As SettingCollection
#End Region

#Region " Public Properties "
        <XmlAttributeAttribute("useUrlDetection")> _
          Public Property UseUrlDetection() As Boolean
            Get
                Return mUseUrlDetection
            End Get
            Set(ByVal Value As Boolean)
                mUseUrlDetection = Value
            End Set
        End Property

        <XmlAttributeAttribute("currentEnvironment")> _
        Public Property CurrentEnvironmentName() As String
            Get
                Return mCurrentEnvironmentName
            End Get
            Set(ByVal Value As String)
                mCurrentEnvironmentName = Value
                mCurrentEnvironment = Nothing
            End Set
        End Property

        <XmlIgnore()> _
        Public ReadOnly Property CurrentEnvironment() As Environment
            Get
                If mCurrentEnvironment Is Nothing Then
                    mCurrentEnvironment = GetCurrentEnvironment()
                    'Debug.WriteLine("Internally caching CurrentEnvironment object.")
                End If

                Return mCurrentEnvironment
            End Get
        End Property

        <XmlIgnore()> _
        Default Public ReadOnly Property Setting(ByVal name As String) As String
            Get
                Dim s As Setting
                s = mGlobalSettings(name)

                If s Is Nothing Then
                    s = CurrentEnvironment.Settings(name)
                End If

                If s Is Nothing Then
                    Throw New Exception("Environment setting '" & name & "' is not declared")
                Else
                    Return s.Value
                End If
            End Get
        End Property

        <XmlElement("globalSetting", IsNullable:=True)> _
        Public ReadOnly Property GlobalSettings() As SettingCollection
            Get
                Return mGlobalSettings
            End Get
        End Property

        <XmlElement("environment", IsNullable:=True)> _
        Public ReadOnly Property Environments() As EnvironmentCollection
            Get
                Return mEnvironments
            End Get
        End Property
#End Region

#Region " Constructors "
        Public Sub New()
            mEnvironments = New EnvironmentCollection
            mGlobalSettings = New SettingCollection
        End Sub
#End Region

#Region " Public Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Loads an EnvironmentSettings object from a Enterprise Library configuration section called "EnvironmentSettings"
        ''' </summary>
        ''' <returns></returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[jcamp]	8/18/2005	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Function LoadFromConfig() As EnvironmentSettings
            Return LoadFromConfig("EnvironmentSettings")
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Loads an EnvironmentSettings object from a Enterprise Library configuration section with the section name provided
        ''' </summary>
        ''' <param name="configSection">The name of the Enterprise Library configuration section to load</param>
        ''' <returns></returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[jcamp]	8/18/2005	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Function LoadFromConfig(ByVal configSection As String) As EnvironmentSettings
            Dim settings As Object
            settings = ConfigManType.InvokeMember("GetConfiguration", Reflection.BindingFlags.InvokeMethod, Type.DefaultBinder, Nothing, New Object() {configSection}, Nothing)
            Return CType(settings, EnvironmentSettings)
        End Function

        Public Shared Sub SaveToConfig(ByVal settings As EnvironmentSettings)
            SaveToConfig(settings, "EnvironmentSettings")
        End Sub

        Public Shared Sub SaveToConfig(ByVal settings As EnvironmentSettings, ByVal configSection As String)
            ConfigManType.InvokeMember("WriteConfiguration", Reflection.BindingFlags.InvokeMethod, Type.DefaultBinder, Nothing, New Object() {configSection, settings}, Nothing)
        End Sub
#End Region

#Region " Private Methods "
        Private Function FindEnvironmentByUrl(ByVal url As String) As Environment
            For Each key As String In Me.mEnvironments
                For Each webUrl As String In mEnvironments(key).WebUrls
                    If webUrl.ToLower = url.ToLower Then
                        Return mEnvironments(key)
                    End If
                Next
            Next

            Return Nothing
        End Function

        Private Function GetCurrentEnvironment() As Environment
            Dim env As Environment
            Dim url As String

            If mCurrentEnvironmentName = "" AndAlso Not mUseUrlDetection Then
                Throw New Exception("EnvironmentSettings section must declare a 'currentEnvironment' element or 'userUrlDetection' must be set to 'true'")
            ElseIf mCurrentEnvironmentName = "" AndAlso mUseUrlDetection Then
                Try
                    'url = System.Web.HttpContext.Current.Request.Url.Host
                    url = "www.nrcpicker.com"
                Catch ex As Exception
                    Throw New Exception("EnvironmentSettings could not determine current URL for useUrlDetection='true'", ex)
                End Try
                env = FindEnvironmentByUrl(url)
                If env Is Nothing Then
                    Throw New Exception("EnvironmentSettings section does not declare and environment for '" & url & "'")
                Else
                    Return env
                End If
            Else
                If mEnvironments(mCurrentEnvironmentName) Is Nothing Then
                    Throw New Exception("EnvironmentSettings section must declare a 'environment' section for '" & mCurrentEnvironmentName & "'")
                Else
                    Return mEnvironments(mCurrentEnvironmentName)
                End If
            End If
        End Function
#End Region

    End Class

End Namespace


