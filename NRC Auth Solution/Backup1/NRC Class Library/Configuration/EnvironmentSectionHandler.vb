Imports System.Configuration
Imports System.Xml

Namespace Configuration

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Configuration.EnvironmentSectionHandler
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' A custom Configuration Section Handler for the environmentSettings section of 
    ''' a .Config file.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <example>This is an example of a .Config file that uses the environmentSettings section
    ''' and explicitly defines the current environment.
    ''' <code>
    ''' &lt;configuration&gt;
    '''   &lt;configSections&gt;
    '''     &lt;section name="environmentSettings" type="NRC.Configuration.EnvironmentSectionHandler, NRC"/&gt;
    '''   &lt;/configSections&gt;
    '''
    '''   &lt;environmentSettings currentEnvironment="Testing"&gt;
    '''     &lt;environment name="Production"&gt;
    '''       &lt;setting name="connectionString" value="Production connection string" /&gt;
    '''       &lt;setting name="SQLTimeout" value="60" /&gt;
    '''       &lt;setting name="ImportantPath" value="G:\Application\Data.xml" /&gt;	
    '''     &lt;/environment&gt;
    '''     &lt;environment name="Testing"&gt;
    '''       &lt;setting name="connectionString" value="Testing connection string" /&gt;
    '''       &lt;setting name="SQLTimeout" value="600" /&gt;
    '''       &lt;setting name="ImportantPath" value="C:\Application\Data.xml" /&gt;	
    '''     &lt;/environment&gt;
    '''   &lt;/environmentSettings&gt;
    ''' &lt;/configuration&gt;
    ''' </code>
    ''' </example>
    ''' <example>This is an example of a .Config file that does not explicitly define the current environment. 
    ''' Instead, the current environment will be determined at run time by the environmentID elements.
    ''' <code>
    ''' &lt;configuration&gt;
    '''   &lt;configSections&gt;
    '''     &lt;section name="environmentSettings" type="NRC.Configuration.EnvironmentSectionHandler, NRC"/&gt;
    '''   &lt;/configSections&gt;
    '''
    '''   &lt;environmentSettings&gt;
    '''     &lt;environment name="Production"&gt;
    '''       &lt;environmentID name="www.thenrcpickergroup.com" /&gt;
    '''       &lt;setting name="connectionString" value="Production connection string" /&gt;
    '''       &lt;setting name="SQLTimeout" value="60" /&gt;
    '''       &lt;setting name="ImportantPath" value="G:\Application\Data.xml" /&gt;	
    '''     &lt;/environment&gt;
    '''     &lt;environment name="Testing"&gt;
    '''       &lt;environmentID name="dev.thenrcpickergroup.com" /&gt;
    '''       &lt;environmentID name="localhost" /&gt;
    '''       &lt;setting name="connectionString" value="Testing connection string" /&gt;
    '''       &lt;setting name="SQLTimeout" value="600" /&gt;
    '''       &lt;setting name="ImportantPath" value="C:\Application\Data.xml" /&gt;	
    '''     &lt;/environment&gt;
    '''   &lt;/environmentSettings&gt;
    ''' &lt;/configuration&gt;
    ''' </code>
    ''' </example>
    ''' <history>
    ''' 	[JCamp]	7/15/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class EnvironmentSectionHandler
        Implements IConfigurationSectionHandler


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Implements IConfigurationSectionHandler.Create and reads the environmentSettings
        ''' XML section from the .Config file and uses that to return an 
        ''' EnvironmentSettingsCollection object
        ''' </summary>
        ''' <param name="parent"></param>
        ''' <param name="configContext"></param>
        ''' <param name="section"></param>
        ''' <returns>The EnvironmentSettingsCollection object that represents the information in the config file.</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/15/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Function Create(ByVal parent As Object, ByVal configContext As Object, ByVal section As System.Xml.XmlNode) As Object Implements System.Configuration.IConfigurationSectionHandler.Create
            Dim currentEnvironment As String = ""
            Dim settings As New EnvironmentSettingsCollection
            Dim setting As EnvironmentSettings
            Dim rootNode As XmlNode
            Dim childNode As XmlNode
            Dim name As String
            Dim conn As NRC.Web.ConnectionString
            Dim globals As New Hashtable

            'If a current environment has been explicitly defined then get it
            If Not section.Attributes("currentEnvironment") Is Nothing Then
                currentEnvironment = section.Attributes("currentEnvironment").Value()
            End If

            'For each root node in the XML segment, look for <environment> tags
            For Each rootNode In section.ChildNodes
                If rootNode.GetType.ToString = "System.Configuration.ConfigXmlElement" Then

                    Select Case rootNode.Name.ToLower
                        Case "environment"
                            'Create an new EnvironmentSettings object and store it in the collection
                            setting = EnvironmentSettings.FromXML(rootNode)
                            settings.Add(setting)
                        Case "globalsetting"
                            If Not rootNode.Attributes("isEncrypted") Is Nothing AndAlso rootNode.Attributes("isEncrypted").Value.ToLower = "true" Then
                                conn = New NRC.Web.ConnectionString(rootNode.Attributes("value").Value)
                                globals.Add(rootNode.Attributes("name").Value.Trim, conn.DecryptedString.Trim)
                            Else
                                globals.Add(rootNode.Attributes("name").Value.Trim, rootNode.Attributes("value").Value.Trim)
                            End If
                    End Select
                End If
            Next

            'If no <environment> tags were found that throw an error.
            If settings.Count = 0 Then
                Throw New ApplicationException("No environment settings found.")
            End If

            'If a currentEnvironment was explicitly defined
            If Not currentEnvironment = "" Then
                setting = Nothing
                'Try and get the environment settings for the specified environment
                setting = settings(currentEnvironment)
                'Save it as the current environment
                settings.CurrentEnvironment = setting

                'If we couldn't find it then throw an exception
                If settings.CurrentEnvironment Is Nothing Then
                    Throw New ApplicationException("The current environment is invalid.")
                End If
            End If

            'add globals
            For Each setKey As String In settings.Keys
                For Each key As String In globals.Keys
                    settings(setKey).AddSetting(key, globals(key))
                Next
            Next

            'Now return the collection for the client app.
            Return settings
        End Function


    End Class
End Namespace
