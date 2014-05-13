Imports System.Configuration
Imports System.Xml

Namespace Configuration


    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Configuration.SiteMapSectionHandler
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' A custom ConfigurationSectionHandler for the SiteMap section 
    ''' of the web.config file
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <example>This is an example of a web.config file that uses the SiteMap section
    ''' and explicitly defines the current environment.
    ''' <code>
    ''' &lt;configSections&gt;
    ''' 	&lt;section name="SiteMap" type="NRC.Configuration.SiteMapSectionHandler, NRC"/&gt; 
    ''' &lt;/configSections&gt;
    ''' &lt;SiteMap&gt;
    ''' 	&lt;SiteMapPage name="Home" path="~/default.aspx"&gt;
    ''' 		&lt;SiteMapPage name="SubPage" path="~/page1.aspx"&gt;
    '''  		    &lt;SiteMapPage name="SubSubPage" path="~/page2.aspx" /&gt;
    ''' 		&lt;/SiteMapPage&gt;
    ''' 		&lt;SiteMapPage name="SubPage2" path="~/page3.aspx" /&gt;
    ''' 		&lt;SiteMapPage name="SubPage3" path="~/page4.aspx" /&gt;
    ''' 	&lt;/SiteMapPage&gt;
    ''' &lt;/SiteMap&gt;
    ''' </code>
    ''' </example>
    ''' <history>
    ''' 	[JCamp]	11/12/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SiteMapSectionHandler
        Implements IConfigurationSectionHandler

        Public Function Create(ByVal parent As Object, _
                            ByVal configContext As Object, _
                            ByVal section As System.Xml.XmlNode) _
                        As Object Implements IConfigurationSectionHandler.Create

            Return SiteMap.FromXML(section)
        End Function

    End Class
End Namespace
