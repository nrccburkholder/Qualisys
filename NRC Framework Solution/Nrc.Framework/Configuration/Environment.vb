Imports System.Xml.Serialization

Namespace Configuration
    ''' <summary>
    ''' Represents a configuration environment and contains collections of its configuration settings and web url identifiers 
    ''' </summary>
    <Serializable(), DebuggerDisplay("Environment = {Name}")> _
    Public Class Environment

#Region " Private Members "
        Private mName As String
        Private mIdentifiers As Specialized.StringCollection
        Private mSettings As SettingCollection
        Private mEnvironmentType As EnvironmentType
#End Region

#Region " Public Properties "
        <XmlAttributeAttribute("name")> _
        Public Property Name() As String
            Get
                Return mName
            End Get
            Set(ByVal Value As String)
                mName = Value
            End Set
        End Property

        <XmlAttributeAttribute("type")> _
        Public Property EnvironmentType() As EnvironmentType
            Get
                Return mEnvironmentType
            End Get
            Set(ByVal Value As EnvironmentType)
                mEnvironmentType = Value
            End Set
        End Property

        <XmlElement("webUrl", IsNullable:=True)> _
        Public ReadOnly Property WebUrls() As System.Collections.Specialized.StringCollection
            Get
                Return mIdentifiers
            End Get
        End Property

        <XmlElement("setting", IsNullable:=True)> _
        Public ReadOnly Property Settings() As SettingCollection
            Get
                Return mSettings
            End Get
        End Property
#End Region

#Region " Constructors "
        Public Sub New()
            mIdentifiers = New Specialized.StringCollection
            mSettings = New SettingCollection
        End Sub

        Public Sub New(ByVal environmentName As String)
            Me.New()
            mName = environmentName
        End Sub
#End Region

    End Class
End Namespace
