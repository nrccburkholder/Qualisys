Imports System.Xml.Serialization
Imports System.IO



Namespace Configuration
    ''' <summary>
    ''' Represents configuration settings for various defined environments.
    ''' </summary>
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
                    Return s.PlainValue
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
        Public Shared Function LoadFromConfig(ByVal configSectionPath As String) As EnvironmentSettings
            Return DirectCast(System.Configuration.ConfigurationManager.GetSection(configSectionPath), EnvironmentSettings)
        End Function
        Public Shared Function LoadFromConfig() As EnvironmentSettings
            Return LoadFromConfig("Nrc.Framework.Configuration/environmentSettings")
        End Function

#Region " Serialization Methods "
        Public Function Serialize() As String
            Dim sb As New Text.StringBuilder
            Using writer As New StringWriter(sb)
                Me.Serialize(writer)
                Return sb.ToString
            End Using
        End Function
        Public Sub Serialize(ByVal filePath As String)
            Using fs As New FileStream(filePath, FileMode.Create)
                Me.Serialize(fs)
            End Using
        End Sub

        Public Shared Function Deserialize(ByVal xmlFragment As String) As EnvironmentSettings
            Using reader As New StringReader(xmlFragment)
                Return Deserialize(reader)
            End Using
        End Function
        Public Shared Function Deserialize(ByVal file As FileInfo) As EnvironmentSettings
            Using fs As FileStream = file.Open(FileMode.Open, FileAccess.Read)
                Return Deserialize(fs)
            End Using
        End Function
        Public Shared Function Deserialize(ByVal xmlFragment As Xml.XmlNode) As EnvironmentSettings
            Using reader As New Xml.XmlNodeReader(xmlFragment)
                Return Deserialize(reader)
            End Using
        End Function
#End Region
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
                Throw New Exception("EnvironmentSettings section must declare a 'currentEnvironment' element or 'useUrlDetection' must be set to 'true'")
            ElseIf mCurrentEnvironmentName = "" AndAlso mUseUrlDetection Then
                Try
                    url = System.Web.HttpContext.Current.Request.Url.Host
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

#Region " Serialization Methods "
        Private Sub Serialize(ByVal writer As TextWriter)
            Dim serializer As New System.Xml.Serialization.XmlSerializer(GetType(EnvironmentSettings))
            serializer.Serialize(writer, Me)
        End Sub
        Private Sub Serialize(ByVal stream As Stream)
            Dim serializer As New System.Xml.Serialization.XmlSerializer(GetType(EnvironmentSettings))
            serializer.Serialize(stream, Me)
        End Sub
        Private Shared Function Deserialize(ByVal reader As TextReader) As EnvironmentSettings
            Dim serializer As New System.Xml.Serialization.XmlSerializer(GetType(EnvironmentSettings))
            Return DirectCast(serializer.Deserialize(reader), EnvironmentSettings)
        End Function
        Private Shared Function Deserialize(ByVal stream As Stream) As EnvironmentSettings
            Dim serializer As New System.Xml.Serialization.XmlSerializer(GetType(EnvironmentSettings))
            Return DirectCast(serializer.Deserialize(stream), EnvironmentSettings)
        End Function
        Private Shared Function Deserialize(ByVal reader As Xml.XmlReader) As EnvironmentSettings
            Dim serializer As New System.Xml.Serialization.XmlSerializer(GetType(EnvironmentSettings))
            Return DirectCast(serializer.Deserialize(reader), EnvironmentSettings)
        End Function
#End Region

#End Region

    End Class

End Namespace


