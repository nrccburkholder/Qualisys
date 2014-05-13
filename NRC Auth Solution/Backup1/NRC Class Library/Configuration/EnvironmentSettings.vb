Imports System.Xml
Namespace Configuration
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Configuration.EnvironmentSettings
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents the configurable settings defined in a .Config file for a 
    ''' particular environment.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/15/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class EnvironmentSettings
        Inherits System.Collections.Specialized.NameValueCollection

#Region " Private Members "
        Private mEnvironmentName As String
        Private mIdentifiers As New ArrayList
#End Region

#Region " Public Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The name of the environment.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property EnvironmentName() As String
            Get
                Return mEnvironmentName
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns the value of a setting.
        ''' </summary>
        ''' <param name="settingName">The name of the setting that should be returned.</param>
        ''' <returns>the value associated with the setting</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Default Public Shadows ReadOnly Property Item(ByVal settingName As String) As String
            Get
                Return MyBase.Item(settingName)
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns the value of a setting.
        ''' </summary>
        ''' <param name="index">The index of the setting that should be returned.</param>
        ''' <returns>the value associated with the setting</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Default Public Shadows ReadOnly Property Item(ByVal index As Integer) As String
            Get
                Return MyBase.Item(index)
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Determines if this EnvironmentSettings object is associated with a certain
        ''' environment identifier
        ''' </summary>
        ''' <param name="id">the environment identifier</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property HasIdentifier(ByVal id As String) As Boolean
            Get
                Return mIdentifiers.Contains(id.ToLower)
            End Get
        End Property
#End Region

#Region " Constructors "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Contstructor initializes the environment name.
        ''' </summary>
        ''' <param name="environmentName">the name to be associated with these environment settings</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Sub New(ByVal environmentName As String)
            MyBase.New()
            mEnvironmentName = environmentName
        End Sub
#End Region

#Region " Public Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Adds a setting to this collection of environment settings.
        ''' </summary>
        ''' <param name="settingName">The name of the setting</param>
        ''' <param name="settingValue">The value of the setting</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub AddSetting(ByVal settingName As String, ByVal settingValue As Object)
            If Not MyBase.Item(settingName) Is Nothing Then
                Throw New ArgumentException("Setting name must be unique", "settingName")
            End If

            MyBase.Add(settingName, settingValue)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Adds an environment identifier to the list of identifiers associated with this environment
        ''' </summary>
        ''' <param name="identifier">The environment identifier to add.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub AddIdentifier(ByVal identifier As String)
            If Me.HasIdentifier(identifier) Then
                Throw New ArgumentException("The environment identifiers must each be unique.", "identifier")
            End If

            mIdentifiers.Add(identifier.ToLower)
        End Sub
#End Region

        Public Shared Function FromXML(ByVal node As XmlNode) As EnvironmentSettings
            If Not node.Name = "environment" Then
                Throw New ArgumentException("Expected <environment> tag")
            End If
            If node.Attributes("name") Is Nothing Then
                Throw New ArgumentException("<environment> tag must contain a name attribute.")
            End If

            Dim setting As New EnvironmentSettings(node.Attributes("name").Value)
            Dim conn As NRC.Web.ConnectionString
            For Each child As XmlNode In node.ChildNodes
                If child.GetType.ToString = "System.Configuration.ConfigXmlElement" Then
                    Select Case child.Name.ToLower
                        Case "environmentid"
                            setting.AddIdentifier(child.Attributes("name").Value.Trim)
                        Case "setting"
                            If Not child.Attributes("isEncrypted") Is Nothing AndAlso child.Attributes("isEncrypted").Value.ToLower = "true" Then
                                conn = New NRC.Web.ConnectionString(child.Attributes("value").Value)
                                setting.AddSetting(child.Attributes("name").Value.Trim, conn.DecryptedString.Trim)
                            Else
                                setting.AddSetting(child.Attributes("name").Value.Trim, child.Attributes("value").Value.Trim)
                            End If
                    End Select
                End If
            Next

            Return setting
        End Function
    End Class



End Namespace
