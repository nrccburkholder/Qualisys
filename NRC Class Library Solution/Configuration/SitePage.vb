Imports System.Xml
Namespace Configuration
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Configuration.SitePage
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The SitePage class represents one page in a SiteMap.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	11/12/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SitePage

#Region " Private Members "
        Private mParent As SitePage
        Private mPageName As String
        Private mPagePath As String
        Private mSubPages As SitePageCollection
#End Region

#Region " Public Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' return a reference to the parent page.  This property is NULL if the page
        ''' is a root in the SiteMap hierarchy.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property Parent() As SitePage
            Get
                Return mParent
            End Get
        End Property
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The "friendly" name of the page.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property Name() As String
            Get
                Try
                    If Not Session("SiteMap_" & mPageName & "_Rename") Is Nothing Then
                        Return Session("SiteMap_" & mPageName & "_Rename")
                    Else

                        Return mPageName
                    End If
                Catch ex As Exception
                    Return mPageName
                End Try               
            End Get
            Set(ByVal Value As String)
                Try
                    Session("SiteMap_" & mPageName & "_Rename") = Value
                Catch ex As Exception
                End Try
                'mPageName = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The path of the page.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property Path() As String
            Get
                Return mPagePath
            End Get
            Set(ByVal Value As String)
                mPagePath = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The collection of child pages beneath this one in the SiteMap tree.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public ReadOnly Property Pages() As SitePageCollection
            Get
                Return mSubPages
            End Get
        End Property

        Private ReadOnly Property Session() As System.Web.SessionState.HttpSessionState
            Get
                Return System.Web.HttpContext.Current.Session
            End Get
        End Property

#End Region

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Creates a new SitePage instance and sets the parent page.
        ''' </summary>
        ''' <param name="parent">The parent SitePage instance.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Sub New(ByVal parent As SitePage)
            mParent = parent
            mSubPages = New SitePageCollection
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Creates a SitePage instance from a corresponding XML segment.
        ''' </summary>
        ''' <param name="root">The XML segment that defines this page</param>
        ''' <param name="parent">The parent SitePage instance.</param>
        ''' <returns>A new SitePage instance representing the XML data.</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Shared Function FromXML(ByVal root As XmlNode, ByVal parent As SitePage) As SitePage
            'Make sure the xmlnode is not null
            If root Is Nothing Then
                Throw New ArgumentNullException("root")
            End If
            'XML node must be <SiteMapPage> element or else throw exception
            If Not root.Name.ToLower = "sitemappage" Then
                Throw New ArgumentException(root.Name & " is not a valid element in the SiteMap section.")
            End If

            'Create the new page
            Dim pg As New SitePage(parent)
            'Set its properties
            pg.mPageName = root.Attributes("name").Value
            pg.mPagePath = root.Attributes("path").Value
            pg.mPagePath = ResolveUrl(pg.mPagePath)

            Dim iterator As IEnumerator
            'Recursively populate the collection of children if there are any
            If root.HasChildNodes Then
                iterator = root.GetEnumerator
                While iterator.MoveNext
                    pg.mSubPages.Add(SitePage.FromXML(iterator.Current, pg))
                End While
            End If

            Return pg
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Resolves a URL containing the special "~" character into the full local path
        ''' </summary>
        ''' <param name="url">The URL string to be resolved</param>
        ''' <returns>The fully qualified local path</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Friend Shared Function ResolveUrl(ByVal url As String) As String
            Dim appPath As String = System.Web.HttpContext.Current.Request.ApplicationPath
            If url Is Nothing OrElse url.Length = 0 OrElse Not url.StartsWith("~") Then
                Return url
            Else
                If url.Length = 1 Then
                    Return appPath
                End If

                If url.Substring(1, 1) = "/" OrElse url.Substring(1, 1) = "\" Then
                    'url looks like "~/" or "~\"

                    If appPath.Length > 1 Then
                        Return String.Format("{0}/{1}", appPath, url.Substring(2))
                    Else
                        Return "/" & url.Substring(2)
                    End If
                Else
                    'URL looks like "~something"
                    If appPath.Length > 1 Then
                        Return String.Format("{0}/{1}", appPath, url.Substring(1))
                    Else
                        Return "/" & url.Substring(1)
                    End If
                End If
            End If

        End Function
    End Class

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Configuration.SitePageCollection
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents a collection of SitePage instances
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	11/12/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SitePageCollection
        Inherits CollectionBase

        Default Public ReadOnly Property Item(ByVal index As Integer) As SitePage
            Get
                Return MyBase.List(index)
            End Get
        End Property

        Public Function Add(ByVal page As SitePage) As Integer
            Return MyBase.List.Add(page)
        End Function

    End Class
End Namespace
