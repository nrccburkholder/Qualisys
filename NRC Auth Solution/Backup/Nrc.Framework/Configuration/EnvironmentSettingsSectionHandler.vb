Namespace Configuration

    ''' <summary>
    ''' A custom Configuration Section Handler for the environmentSettings
    ''' section of a .Config file
    ''' </summary>
    ''' <remarks>
    ''' <example>
    ''' <code>
    ''' <![CDATA[
    ''' <configuration>
    '''   <configSections>
    '''     <section name="environmentSettings" type="Nrc.Framework.Configuration.EnvironmentSettingsSectionHandler, Nrc.Framework"/>
    '''   </configSections>
    '''
    '''   <environmentSettings currentEnvironment="Testing">
    '''     <environment name="Production">
    '''       <setting name="connectionString" value="Production connection string" />
    '''       <setting name="SQLTimeout" value="60" />
    '''       <setting name="ImportantPath" value="G:\Application\Data.xml" />	
    '''     </environment>
    '''     <environment name="Testing">
    '''       <setting name="connectionString" value="Testing connection string" />
    '''       <setting name="SQLTimeout" value="600" />
    '''       <setting name="ImportantPath" value="C:\Application\Data.xml" />	
    '''     </environment>
    '''   </environmentSettings>
    ''' </configuration>
    ''' ]]>
    ''' </code>
    ''' </example>
    ''' <example>
    ''' <code>
    ''' <![CDATA[
    ''' <configuration>
    '''   <configSections>
    '''     <section name="environmentSettings" type="NRC.Configuration.EnvironmentSectionHandler, NRC"/>
    '''   </configSections>
    '''
    '''   <environmentSettings>
    '''     <environment name="Production">
    '''       <environmentID name="www.thenrcpickergroup.com" />
    '''       <setting name="connectionString" value="Production connection string" />
    '''       <setting name="SQLTimeout" value="60" />
    '''       <setting name="ImportantPath" value="G:\Application\Data.xml" />	
    '''     </environment>
    '''     <environment name="Testing">
    '''       <environmentID name="dev.thenrcpickergroup.com" />
    '''       <environmentID name="localhost" />
    '''       <setting name="connectionString" value="Testing connection string" />
    '''       <setting name="SQLTimeout" value="600" />
    '''       <setting name="ImportantPath" value="C:\Application\Data.xml" />	
    '''     </environment>
    '''   </environmentSettings>
    ''' </configuration>
    ''' ]]>
    ''' </code>
    ''' </example>
    ''' </remarks>
    Public Class EnvironmentSettingsSectionHandler
        Implements System.Configuration.IConfigurationSectionHandler

        Public Function Create(ByVal parent As Object, ByVal configContext As Object, ByVal section As System.Xml.XmlNode) As Object Implements System.Configuration.IConfigurationSectionHandler.Create
            Dim settings As EnvironmentSettings = EnvironmentSettings.Deserialize(section)
            Return settings
        End Function

    End Class
End Namespace
