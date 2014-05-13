Imports System.Xml

Namespace Configuration
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Configuration.SiteMap
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The SiteMap class represents the hierarchical structure of a website.
    ''' The organization of the pages in the website is defined in the &lt;SiteMap&gt; section
    ''' of the web.config file.  The SiteMapSectionHandler is used to build and return
    ''' an instance of SiteMap from the web.config xml file.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	11/12/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SiteMap

        Private Shared mInstance As SiteMap
        Private mPages As SitePageCollection
        Private mPageDictionary As Hashtable

#Region " Public Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Provides access to the one and only instance of the SiteMap class.
        ''' </summary>
        ''' <value></value>
        ''' <remarks>
        ''' The SiteMap is a singleton object representing information contained in theThe SiteMap is a singleton object representing information contained in the
        ''' web.config file.  The information is static for all instances of the class
        ''' so only one instance is allowed.
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared ReadOnly Property Instance() As SiteMap
            Get
                If mInstance Is Nothing Then
                    mInstance = DirectCast(System.Configuration.ConfigurationSettings.GetConfig("SiteMap"), SiteMap)
                End If
                Return mInstance
            End Get
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns the collection of SitePages in the sitemap.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property Pages() As SitePageCollection
            Get
                Return mPages
            End Get
        End Property
#End Region

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Constructor is private for singleton objects.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub New()
            mPages = New SitePageCollection
            mPageDictionary = New Hashtable
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Returns a reference to the SitePage with the path specified.
        ''' </summary>
        ''' <param name="path">The path of the SitePage to return</param>
        ''' <returns></returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Function GetPage(ByVal path As String) As SitePage
            Return mPageDictionary(SitePage.ResolveUrl(path).ToLower)
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Builds a SiteMap instance from an XML Node containing the definition.
        ''' </summary>
        ''' <param name="root">The XML node that contains the SiteMap definition.</param>
        ''' <returns>An instance of SiteMap that represents the XML data.</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Function FromXML(ByVal root As System.Xml.XmlNode) As SiteMap
            If root Is Nothing Then
                Throw New ArgumentNullException("root")
            End If

            Dim map As New SiteMap
            Dim iterator As IEnumerator = root.GetEnumerator

            While iterator.MoveNext
                map.mPages.Add(SitePage.FromXML(iterator.Current, Nothing))
            End While

            map.BuildDictionary(map.mPages)
            Return map
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Flattens the hierarchical SiteMap into a flat dictionary lookup reference
        ''' to each SitePage instance.  This is used to lookup pages without having
        ''' to traverse the tree each time.
        ''' </summary>
        ''' <param name="pages">The SitePageCollection that should be indexed.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub BuildDictionary(ByVal pages As SitePageCollection)
            For Each page As SitePage In pages
                mPageDictionary.Add(page.Path.ToLower, page)
                If page.Pages.Count > 0 Then
                    BuildDictionary(page.Pages)
                End If
            Next
        End Sub
    End Class

End Namespace
