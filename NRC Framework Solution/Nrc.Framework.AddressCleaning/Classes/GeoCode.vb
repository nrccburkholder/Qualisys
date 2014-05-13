Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class GeoCode
    Inherits BusinessBase(Of Address)

#Region " Private Members "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mCountyFIPS As String = String.Empty
    Private mCountyName As String = String.Empty
    Private mLatitude As String = String.Empty
    Private mLongitude As String = String.Empty
    Private mPlaceName As String = String.Empty
    Private mPlaceCode As String = String.Empty
    Private mTimeZoneName As String = String.Empty
    Private mTimeZoneCode As String = String.Empty
    Private mCBSALevel As String = String.Empty
    Private mCBSACode As String = String.Empty
    Private mCBSATitle As String = String.Empty
    Private mCBSADivisionLevel As String = String.Empty
    Private mCBSADivisionCode As String = String.Empty
    Private mCBSADivisionTitle As String = String.Empty
    Private mCensusBlock As String = String.Empty
    Private mCensusTract As String = String.Empty
    Private mGeoCodeStatus As String = String.Empty
    Private mDBKey As Integer

#End Region

#Region " Public ReadOnly Properties "

    ''' <summary>
    ''' The Federal Information Processing Standard (FIPS) is a 5-digit code defined 
    ''' by the U.S. Bureau of Census. 
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>
    ''' The first two digits are a state code and the last three indicate the county 
    ''' within the state.  "06037" is the County FIPS for Los Angeles, CA. "06" is 
    ''' the state code for California and "037" is the county code for Los Angeles.
    ''' </remarks>
    Public Property CountyFIPS() As String
        Get
            Return mCountyFIPS
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCountyFIPS Then
                mCountyFIPS = value
                PropertyHasChanged("CountyFIPS")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The County Name.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property CountyName() As String
        Get
            Return mCountyName
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCountyName Then
                mCountyName = value
                PropertyHasChanged("CountyName")
            End If
        End Set
    End Property

    ''' <summary>
    ''' Latitude is the geographic coordinate of a point measured in degrees north or 
    ''' south of the equator. The web service uses the WGS-84 standard for determining 
    ''' latitude.  Since all U.S. ZIP Code latitude coordinates are north of the 
    ''' equator, this value will always be positive.
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns a string value containing the latitude for the centroid of the location 
    ''' described by the submitted address key.
    ''' </returns>
    ''' <remarks>
    ''' The web service uses the WGS-84 standard for determining latitude.  Since all 
    ''' U.S. ZIP Code latitude coordinates are north of the equator, this value will 
    ''' always be positive.
    ''' </remarks>
    Public Property Latitude() As String
        Get
            Return mLatitude
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLatitude Then
                mLatitude = value
                PropertyHasChanged("Latitude")
            End If
        End Set
    End Property

    ''' <summary>
    ''' Longitude is the geographic coordinate of a point measured in degrees east or 
    ''' west of the Greenwich meridian.
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns a string value containing the longitude for the centroid of the location 
    ''' described by the submitted address key.
    ''' </returns>
    ''' <remarks>
    ''' The web service uses the WGS-84 standard for determining longitude.  Since all 
    ''' U.S. ZIP Code latitude coordinates are west of the Greenwich meridian, this 
    ''' value will always be negative.
    ''' </remarks>
    Public Property Longitude() As String
        Get
            Return mLongitude
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLongitude Then
                mLongitude = value
                PropertyHasChanged("Longitude")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The Census Bureau's Place Name
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns the Census Bureau’s Place Name for the address key submitted with the 
    ''' current record.
    ''' </returns>
    ''' <remarks>
    ''' ZIP Code boundaries sometime overlap with city limits and unincorporated 
    ''' areas.  The ZIP Code may place a location within one city even though it is 
    ''' physically located within a neighboring area.  These properties returns the Census 
    ''' Bureau’s official name for the area containing the location described the submitted 
    ''' address key.  For example, the 92688 ZIP Code is located mostly within the city of 
    ''' Rancho Santa Margarita.  However, it also contains parts of the unincorporated area 
    ''' of Los Flores.  For these ZIP + 4 codes, the City property of the Address Verifier 
    ''' service would return "Rancho Santa Margarita," but the Name property will return 
    ''' "Los Flores."
    ''' </remarks>
    Public Property PlaceName() As String
        Get
            Return mPlaceName
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPlaceName Then
                mPlaceName = value
                PropertyHasChanged("PlaceName")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The Census Bureau's Place Code
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns the Census Bureau’s Place Code for the address key submitted with the 
    ''' current record.
    ''' </returns>
    ''' <remarks>
    ''' ZIP Code boundaries sometime overlap with city limits and unincorporated 
    ''' areas.  The ZIP Code may place a location within one city even though it is 
    ''' physically located within a neighboring area.  These properties returns the Census 
    ''' Bureau’s official name for the area containing the location described the submitted 
    ''' address key.  For example, the 92688 ZIP Code is located mostly within the city of 
    ''' Rancho Santa Margarita.  However, it also contains parts of the unincorporated area 
    ''' of Los Flores.  For these ZIP + 4 codes, the City property of the Address Verifier 
    ''' service would return "Rancho Santa Margarita," but the Name property will return 
    ''' "Los Flores."
    ''' </remarks>
    Public Property PlaceCode() As String
        Get
            Return mPlaceCode
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPlaceCode Then
                mPlaceCode = value
                PropertyHasChanged("PlaceCode")
            End If
        End Set
    End Property

    ''' <summary>
    ''' Time Zone Name
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns the descriptive name for the time zone containing the location described 
    ''' by the submitted address key.
    ''' </returns>
    ''' <remarks></remarks>
    Public Property TimeZoneName() As String
        Get
            Return mTimeZoneName
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTimeZoneName Then
                mTimeZoneName = value
                PropertyHasChanged("TimeZoneName")
            End If
        End Set
    End Property

    ''' <summary>
    ''' Time Zone Code
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns the numeric code for the time zone containing the location described by 
    ''' the submitted address key.
    ''' </returns>
    ''' <remarks></remarks>
    Public Property TimeZoneCode() As String
        Get
            Return mTimeZoneCode
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTimeZoneCode Then
                mTimeZoneCode = value
                PropertyHasChanged("TimeZoneCode")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The U.S. Census Bureau’s Core Based Statistical Area (CBSA) data for the location 
    ''' associated with the submitted address key.
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns whether the particular CBSA is a metropolitan or micropolitan area.
    ''' </returns>
    ''' <remarks>
    ''' Metropolitan and micropolitan statistical areas (metro and micro areas) are 
    ''' geographic entities defined by the U.S. Office of Management and Budget (OMB) for 
    ''' use by Federal statistical agencies in collecting, tabulating, and publishing 
    ''' Federal statistics. The term "Core Based Statistical Area" (CBSA) is a collective 
    ''' term for both metro and micro areas. A metro area contains a core urban area of 
    ''' 50,000 or more population, and a micro area contains an urban core of at least 
    ''' 10,000 (but less than 50,000) population. Each metro or micro area consists of 
    ''' one or more counties and includes the counties containing the core urban area, as 
    ''' well as any adjacent counties that have a high degree of social and economic 
    ''' integration (as measured by commuting to work) with the urban core.
    ''' </remarks>
    Public Property CBSALevel() As String
        Get
            Return mCBSALevel
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCBSALevel Then
                mCBSALevel = value
                PropertyHasChanged("CBSALevel")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The U.S. Census Bureau’s Core Based Statistical Area (CBSA) data for the location 
    ''' associated with the submitted address key.
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns a five-digit code for the specific CBSA associated with the location 
    ''' described by the submitted address key.
    ''' </returns>
    ''' <remarks>
    ''' Metropolitan and micropolitan statistical areas (metro and micro areas) are 
    ''' geographic entities defined by the U.S. Office of Management and Budget (OMB) for 
    ''' use by Federal statistical agencies in collecting, tabulating, and publishing 
    ''' Federal statistics. The term "Core Based Statistical Area" (CBSA) is a collective 
    ''' term for both metro and micro areas. A metro area contains a core urban area of 
    ''' 50,000 or more population, and a micro area contains an urban core of at least 
    ''' 10,000 (but less than 50,000) population. Each metro or micro area consists of 
    ''' one or more counties and includes the counties containing the core urban area, as 
    ''' well as any adjacent counties that have a high degree of social and economic 
    ''' integration (as measured by commuting to work) with the urban core.
    ''' </remarks>
    Public Property CBSACode() As String
        Get
            Return mCBSACode
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCBSACode Then
                mCBSACode = value
                PropertyHasChanged("CBSACode")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The U.S. Census Bureau’s Core Based Statistical Area (CBSA) data for the location 
    ''' associated with the submitted address key.
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns the official U.S. Census Bureau name for the CBSA.
    ''' </returns>
    ''' <remarks>
    ''' Metropolitan and micropolitan statistical areas (metro and micro areas) are 
    ''' geographic entities defined by the U.S. Office of Management and Budget (OMB) for 
    ''' use by Federal statistical agencies in collecting, tabulating, and publishing 
    ''' Federal statistics. The term "Core Based Statistical Area" (CBSA) is a collective 
    ''' term for both metro and micro areas. A metro area contains a core urban area of 
    ''' 50,000 or more population, and a micro area contains an urban core of at least 
    ''' 10,000 (but less than 50,000) population. Each metro or micro area consists of 
    ''' one or more counties and includes the counties containing the core urban area, as 
    ''' well as any adjacent counties that have a high degree of social and economic 
    ''' integration (as measured by commuting to work) with the urban core.
    ''' </remarks>
    Public Property CBSATitle() As String
        Get
            Return mCBSATitle
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCBSATitle Then
                mCBSATitle = value
                PropertyHasChanged("CBSATitle")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The U.S. Census Bureau’s Core Based Statistical Area (CBSA) data for the location 
    ''' associated with the submitted address key.
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns whether the particular CBSA is a metropolitan or micropolitan area.
    ''' Some CBSA’s are broken into parts known as divisions. In this case, the CBSA 
    ''' Division fields will also be populated. If not, these fields will be empty.
    ''' </returns>
    ''' <remarks>
    ''' Metropolitan and micropolitan statistical areas (metro and micro areas) are 
    ''' geographic entities defined by the U.S. Office of Management and Budget (OMB) for 
    ''' use by Federal statistical agencies in collecting, tabulating, and publishing 
    ''' Federal statistics. The term "Core Based Statistical Area" (CBSA) is a collective 
    ''' term for both metro and micro areas. A metro area contains a core urban area of 
    ''' 50,000 or more population, and a micro area contains an urban core of at least 
    ''' 10,000 (but less than 50,000) population. Each metro or micro area consists of 
    ''' one or more counties and includes the counties containing the core urban area, as 
    ''' well as any adjacent counties that have a high degree of social and economic 
    ''' integration (as measured by commuting to work) with the urban core.
    ''' </remarks>
    Public Property CBSADivisionLevel() As String
        Get
            Return mCBSADivisionLevel
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCBSADivisionLevel Then
                mCBSADivisionLevel = value
                PropertyHasChanged("CBSADivisionLevel")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The U.S. Census Bureau’s Core Based Statistical Area (CBSA) data for the location 
    ''' associated with the submitted address key.
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns a five-digit code for the specific CBSA associated with the location 
    ''' described by the submitted address key.
    ''' Some CBSA’s are broken into parts known as divisions. In this case, the CBSA 
    ''' Division fields will also be populated. If not, these fields will be empty.
    ''' </returns>
    ''' <remarks>
    ''' Metropolitan and micropolitan statistical areas (metro and micro areas) are 
    ''' geographic entities defined by the U.S. Office of Management and Budget (OMB) for 
    ''' use by Federal statistical agencies in collecting, tabulating, and publishing 
    ''' Federal statistics. The term "Core Based Statistical Area" (CBSA) is a collective 
    ''' term for both metro and micro areas. A metro area contains a core urban area of 
    ''' 50,000 or more population, and a micro area contains an urban core of at least 
    ''' 10,000 (but less than 50,000) population. Each metro or micro area consists of 
    ''' one or more counties and includes the counties containing the core urban area, as 
    ''' well as any adjacent counties that have a high degree of social and economic 
    ''' integration (as measured by commuting to work) with the urban core.
    ''' </remarks>
    Public Property CBSADivisionCode() As String
        Get
            Return mCBSADivisionCode
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCBSADivisionCode Then
                mCBSADivisionCode = value
                PropertyHasChanged("CBSADivisionCode")
            End If
        End Set
    End Property

    ''' <summary>
    ''' The U.S. Census Bureau’s Core Based Statistical Area (CBSA) data for the location 
    ''' associated with the submitted address key.
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns the official U.S. Census Bureau name for the CBSA.
    ''' Some CBSA’s are broken into parts known as divisions. In this case, the CBSA 
    ''' Division fields will also be populated. If not, these fields will be empty.
    ''' </returns>
    ''' <remarks>
    ''' Metropolitan and micropolitan statistical areas (metro and micro areas) are 
    ''' geographic entities defined by the U.S. Office of Management and Budget (OMB) for 
    ''' use by Federal statistical agencies in collecting, tabulating, and publishing 
    ''' Federal statistics. The term "Core Based Statistical Area" (CBSA) is a collective 
    ''' term for both metro and micro areas. A metro area contains a core urban area of 
    ''' 50,000 or more population, and a micro area contains an urban core of at least 
    ''' 10,000 (but less than 50,000) population. Each metro or micro area consists of 
    ''' one or more counties and includes the counties containing the core urban area, as 
    ''' well as any adjacent counties that have a high degree of social and economic 
    ''' integration (as measured by commuting to work) with the urban core.
    ''' </remarks>
    Public Property CBSADivisionTitle() As String
        Get
            Return mCBSADivisionTitle
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCBSADivisionTitle Then
                mCBSADivisionTitle = value
                PropertyHasChanged("CBSADivisionTitle")
            End If
        End Set
    End Property

    ''' <summary>
    ''' Census Block
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns the Census Block number associated with the location described by the 
    ''' submitted address key.
    ''' </returns>
    ''' <remarks>
    ''' Census blocks, the smallest geographic area for which the Bureau of the Census 
    ''' collects and tabulates decennial census data, are formed by streets, roads, 
    ''' railroads, streams and other bodies of water, other visible physical and cultural 
    ''' features, and the legal boundaries shown on Census Bureau maps.  The Census Block 
    ''' is a four-character string value.  The first digit is the Block Group and the last 
    ''' three characters (if any) are the Block Number.  The block group returns a 
    ''' one-character string containing the block group number.
    ''' </remarks>
    Public Property CensusBlock() As String
        Get
            Return mCensusBlock
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCensusBlock Then
                mCensusBlock = value
                PropertyHasChanged("CensusBlock")
            End If
        End Set
    End Property

    ''' <summary>
    ''' Census Tract
    ''' </summary>
    ''' <value></value>
    ''' <returns>
    ''' Returns the Census Tract number associated with the location described by the 
    ''' submitted address key.
    ''' </returns>
    ''' <remarks>
    ''' Census Tracts are small, relatively permanent statistical subdivisions of a 
    ''' county.  Census Tracts are delineated for all metropolitan areas (MA’s) and 
    ''' other densely populated counties by local census statistical areas committees 
    ''' following Census Bureau guidelines (more than 3,000 Census Tracts have been 
    ''' established in 221 counties outside MA’s).  The CensusTract property is usually 
    ''' returned as a 4-digit string.  However, in areas that experience substantial 
    ''' growth, a Census Tract may be split to keep the population level even.  When 
    ''' this happens, a 6-digit number will be returned.  The web service requires a 
    ''' full nine-digit ZIP with a valid Plus 4 add-on to return the Census Tract.  If 
    ''' a five-digit ZIP is submitted, the Census Tract will not be returned.
    ''' </remarks>
    Public Property CensusTract() As String
        Get
            Return mCensusTract
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCensusTract Then
                mCensusTract = value
                PropertyHasChanged("CensusTract")
            End If
        End Set
    End Property

    ''' <summary>
    ''' Web service status (Return) string specifies any possible error conditions
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property GeoCodeStatus() As String
        Get
            Return mGeoCodeStatus
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mGeoCodeStatus Then
                mGeoCodeStatus = value
                PropertyHasChanged("GeoCodeStatus")
            End If
        End Set
    End Property

#End Region

#Region " Friend Properties "

    Friend Property DBKey() As Integer
        Get
            Return mDBKey
        End Get
        Set(ByVal value As Integer)
            If Not value = mDBKey Then
                mDBKey = value
                PropertyHasChanged("DBKey")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewGeoCode() As GeoCode

        Return New GeoCode

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mDBKey
        End If

    End Function

#End Region

#Region " Validation Methods "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

#End Region

End Class