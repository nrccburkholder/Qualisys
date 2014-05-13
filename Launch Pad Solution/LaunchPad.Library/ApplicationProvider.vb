Imports Nrc.Framework.Businesslogic.Configuration

Public MustInherit Class ApplicationProvider

#Region " Private Shared Members "
    ''' <summary>A cache of all the provider instances</summary>
    Private Shared mProviders As New Dictionary(Of String, ApplicationProvider)
#End Region

#Region " Shared Properties "
    ''' <summary>This property used to read Provider names from config file. The new
    ''' version reads them from QualPro_Params table. To avoid extensive rewrite I kept
    ''' the return type the same. It reads the comma separated list of Application
    ''' provider setting names from QualPro_Params (LPApplicationProviderKeys  setting
    ''' has the comma separated values in QualPro_Params) then for each setting name
    ''' gets the setting and adds to a NameValueCollection to return.</summary>
    ''' <returns>NameValueCollection of Application provider names as keys and the comma
    ''' separated list of provider class and containing assembly name as values to crate
    ''' the instance of the class via reflection.</returns>
    ''' <revision>March - 12- 2009 by Arman Mnatsakanyan</revision>
    Public Shared ReadOnly Property ProviderList() As Collections.Specialized.NameValueCollection
        Get
            'Get the name-value list of providers from QualPro_Params table.

            'Get comma separated list of ApplicationProviders from QualPro_Params table
            Dim ApplicationProviderKeyString As String = AppConfig.Params("LPApplicationProviderKeys").StringValue

            'Convert comma separated list to a string array to loop through
            Dim ApplicationProviderKeyArray() As String = ApplicationProviderKeyString.Split(","c)
            Dim Providers As New Collections.Specialized.NameValueCollection

            'Loop through every key (every key is a param name in QualPro_Params table) and get their values 
            '(stored in strParamValue field in QualPro_Params) then add the key and the corresponding value to Providers collection.
            For Each key As String In ApplicationProviderKeyArray
                Providers.Add(key, AppConfig.Params(key).StringValue)
            Next
            Return Providers
        End Get
    End Property
    ''' <summary>This property used to read Provider categories from config file. The new
    ''' version reads them from QualPro_Params table. To avoid extensive rewrite I kept
    ''' the return type the same. It reads the comma separated list of category
    ''' setting names from QualPro_Params (LPProviderCategoryKeys  setting
    ''' has the comma separated values in QualPro_Params) then for each setting name
    ''' gets the setting and adds to a NameValueCollection to return.</summary>
    ''' <returns>NameValueCollection of category names as keys and the comma
    ''' separated list of category values as values (I'm not sure why is it implemented as a NameValueCollection
    ''' since it has only one key value pair: Default="Custom"). 
    ''' </returns>
    ''' <revision>March - 12- 2009 by Arman Mnatsakanyan</revision>
    Public Shared ReadOnly Property ProviderCategoriesList() As Collections.Specialized.NameValueCollection
        Get
            'Get the name-value list of provider categories from the config file
            'Return TryCast(System.Configuration.ConfigurationManager.GetSection("ProviderCategories"), Collections.Specialized.NameValueCollection)
            'Get comma separated list of Provider categories from QualPro_Params table
            Dim ProviderCategoryKeyString As String = AppConfig.Params("LPProviderCategoryKeys").StringValue

            'Convert comma separated list to a string array to loop through
            Dim ProviderCategoryKeyArray() As String = ProviderCategoryKeyString.Split(","c)
            Dim Categories As New Collections.Specialized.NameValueCollection

            'Loop through every key (every key is a param name in QualPro_Params table) and get their values 
            '(stored in strParamValue field in QualPro_Params) then add the key and the corresponding value to Providers collection.
            For Each key As String In ProviderCategoryKeyArray
                Categories.Add(key, AppConfig.Params(key).StringValue)
            Next
            Return Categories
        End Get
    End Property

    ''' <summary>
    ''' Gets the specified Provider instance
    ''' </summary>
    ''' <param name="providerName">The name of the ApplicationProvider to return</param>
    ''' <value></value>
    ''' <returns>Returns an instance of the ApplicationProvider specified</returns>
    ''' <remarks></remarks>
    Public Shared ReadOnly Property Provider(ByVal providerName As String) As ApplicationProvider
        Get
            'If the provider is not already in our cache then add it
            If Not mProviders.ContainsKey(providerName) Then
                Dim newProvider As ApplicationProvider

                'Get the name of the Type for the provider
                Dim providerTypeName As String = ProviderList(providerName)

                'Get an instance of the Type of the provider
                Dim providerType As Type = Type.GetType(providerTypeName, True, True)

                'Create an instance of the provider Type
                newProvider = TryCast(Activator.CreateInstance(providerType), ApplicationProvider)

                'Add this instance to our cache of providers
                mProviders.Add(providerName, newProvider)
            End If

            'return the provider with the name specified from our cache
            Return mProviders(providerName)
        End Get
    End Property

    ''' <summary>
    ''' Returns an instance of the default provider for the application
    ''' </summary>
    Public Shared ReadOnly Property DefaultProvider() As ApplicationProvider
        Get
            'Return the provider instance that is specified as the "Default"
            Return mProviders(ProviderCategoriesList("Default"))
        End Get
    End Property
#End Region

#Region " Shared Function "
    ''' <summary>
    ''' Returns a collection of all the applications from all the providers for the current user
    ''' </summary>
    Public Shared Function GetUserApplications() As ApplicationCollection
        'Create a universal collection
        Dim apps As New ApplicationCollection

        'For each provider available
        For Each providerName As String In ProviderList.Keys
            'Get all the applications from this provider
            Dim list As ApplicationCollection
            list = Provider(providerName).GetApplicationsForUser()

            'Add each application to our universal list of applications
            For Each app As Application In list
                apps.Add(app)
            Next
        Next

        'Return the universal collection of apps
        Return apps
    End Function

    Public Shared Sub RefreshApplications()
        'For each provider available
        For Each providerName As String In ProviderList.Keys
            'Refresh this provider
            Provider(providerName).RefreshApplicationList()
        Next

    End Sub
#End Region

#Region " Abstract Methods "
    Public MustOverride Sub RefreshApplicationList()
    Public MustOverride Function GetApplicationsForUser() As ApplicationCollection
    Public MustOverride Function GetAllApplications() As ApplicationCollection
    Public MustOverride Function CanAdministerApplications() As Boolean
    Public MustOverride Sub AddApplication(ByVal app As Application)
    Public MustOverride Sub UpdateApplication(ByVal app As Application)
    Public MustOverride Sub DeleteApplication(ByVal app As Application)
#End Region

End Class
