Imports System.Net
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class AddressCollection
    Inherits BusinessListBase(Of AddressCollection, Address)

#Region " Private Members "

    Private mCountryID As CountryIDs


#End Region

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As Address = Address.NewAddress
        Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Constructors "

    Friend Sub New(ByVal countryID As CountryIDs)

        'Call the base class
        MyBase.New()

        'Store the parameters
        mCountryID = countryID

    End Sub

#End Region

#Region " Destructors "

    Protected Overrides Sub Finalize()

        'Call the base class
        MyBase.Finalize()

    End Sub

#End Region

#Region " Public Methods "

    ''' <summary>
    ''' This routine is the public interface called to clean all of the 
    ''' addresses currently contained in collection.
    ''' </summary>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests</param>
    ''' <remarks></remarks>
    Public Sub Clean(ByVal forceProxy As Boolean)

        'The DBKey property of the address object is not publicly exposed so it will need to be set by the application.
        Clean(True, forceProxy, True)

    End Sub

    ''' <summary>
    ''' This routine is the public interface called to clean all of the 
    ''' addresses currently contained in collection.
    ''' </summary>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests</param>
    ''' <param name="populateGeoCoding">Specifies whether or not to populate the geocoding information</param>
    ''' <remarks></remarks>
    Public Sub Clean(ByVal forceProxy As Boolean, ByVal populateGeoCoding As Boolean)

        'The DBKey property of the address object is not publicly exposed so it will need to be set by the application.
        Clean(True, forceProxy, populateGeoCoding)

    End Sub

#End Region

#Region " Friend Methods "

    ''' <summary>
    ''' This routine is the internal interface called to clean all of the
    ''' addresses currently contained in collection
    ''' </summary>
    ''' <param name="assignIDs">Specified whether or not the addresses need to have the DBKey set</param>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests</param>
    ''' <param name="populateGeoCoding">Specifies whether or not to populate the geocoding information</param>
    ''' <remarks></remarks>
    Friend Sub Clean(ByVal assignIDs As Boolean, ByVal forceProxy As Boolean, ByVal populateGeoCoding As Boolean)

        Dim addrCount As Integer = 0
        Dim addrUsed As Integer = 0
        Dim maxRecords As Integer = AppConfig.Params("AddressWebServiceMaxRecords").IntegerValue
        Dim addrCheckRequest As New net.melissadata.addresscheck.RequestArray
        Dim addrCheckResponse As New net.melissadata.addresscheck.ResponseArray
        Dim geoCodingCount As Integer = 0
        Dim geoCodingUsed As Integer = 0
        Dim geoCodingRequest As New net.melissadata.geocoder.RequestArray
        Dim geoCodingResponse As New net.melissadata.geocoder.ResponseArray

        'Initialize the SOAP request message
        addrCheckRequest.CustomerID = AppConfig.Params("AddressWebServiceCustomerID").StringValue
        addrCheckRequest.OptAddressParsed = "False"

        'Dimension the SOAP request message array for the first set of records
        ReDim addrCheckRequest.Record(GetArraySize(Count, addrUsed, maxRecords) - 1)

        'Create the address cleaning web service connection
        Using addrCheckService As New net.melissadata.addresscheck.Service
            'Initialize the web service
            addrCheckService.Url = AppConfig.Params("AddressWebServiceURL").StringValue

            'Determine if we need to use a proxy
            If forceProxy Then
                addrCheckService.Proxy = New WebProxy(AppConfig.Params("WebServiceProxyServer").StringValue, AppConfig.Params("WebServiceProxyPort").IntegerValue)
                addrCheckService.Proxy.Credentials = CredentialCache.DefaultCredentials
            End If

            'Clean all addresses in the collection
            For Each addr As Address In Me
                'Increment the counters
                addrCount += 1
                addrUsed += 1

                'Check to see if we need to assign the id
                If assignIDs Then
                    addr.DBKey = addrUsed
                End If

                'Add this address to the web service SOAP message
                AddAddress(addrCount, addr, addrCheckRequest)

                'Determine if it is time to call the web service
                If addrCount = maxRecords OrElse addrUsed = Count Then
                    'Call the web service to clean the current SOAP message
                    addrCheckResponse = addrCheckService.doAddressCheck(addrCheckRequest)

                    'Check to see if the web service returned any errors
                    Dim message As String = String.Empty
                    If CheckForAddressWebRequestErrors(addrCheckResponse.Results, message) Then
                        'We have encountered a general error from the web service.
                        Throw New Exception(message)
                    End If

                    'Find and update the returned addresses
                    UpdateAddresses(addrCheckResponse)

                    'Reset and prepare for next set of addresses to be added to the SOAP message
                    addrCount = 0
                    ReDim addrCheckRequest.Record(GetArraySize(Count, addrUsed, maxRecords) - 1)
                End If
            Next
        End Using

        'Determine if we are doing the GeoCoding
        If Not populateGeoCoding Then Exit Sub

        'Initialize the SOAP request message
        geoCodingRequest.CustomerID = AppConfig.Params("GeoCodingWebServiceCustomerID").StringValue

        'Dimension the SOAP request message array for the first set of records
        ReDim geoCodingRequest.Record(GetArraySize(Count, geoCodingUsed, maxRecords) - 1)

        'Create the address cleaning web service connection
        Using geoCodingService As New net.melissadata.geocoder.Service
            'Initialize the web service
            geoCodingService.Url = AppConfig.Params("GeoCodingWebServiceURL").StringValue

            'Determine if we need to use a proxy
            If forceProxy Then
                geoCodingService.Proxy = New WebProxy(AppConfig.Params("WebServiceProxyServer").StringValue, AppConfig.Params("WebServiceProxyPort").IntegerValue)
                geoCodingService.Proxy.Credentials = CredentialCache.DefaultCredentials
            End If

            'Add GeoCoding for all addresses in the collection
            For Each addr As Address In Me
                'Increment the counters
                geoCodingCount += 1
                geoCodingUsed += 1

                'Add this address to the web service SOAP message
                AddGeoCoding(geoCodingCount, addr, geoCodingRequest)

                'Determine if it is time to call the web service
                If geoCodingCount = maxRecords OrElse geoCodingUsed = Count Then
                    'Call the web service to clean the current SOAP message
                    geoCodingResponse = geoCodingService.doGeoCode(geoCodingRequest)

                    'Check to see if the web service returned any errors
                    Dim message As String = String.Empty
                    If CheckForGeoCodingWebRequestErrors(geoCodingResponse.Results, message) Then
                        'We have encountered a general error from the web service.
                        Throw New Exception(message)
                    End If

                    'Find and update the returned addresses
                    UpdateGeoCoding(geoCodingResponse)

                    'Reset and prepare for next set of addresses to be added to the SOAP message
                    geoCodingCount = 0
                    ReDim geoCodingRequest.Record(GetArraySize(Count, geoCodingUsed, maxRecords) - 1)
                End If
            Next
        End Using

    End Sub

    ''' <summary>
    ''' This routine is the internal interface called to clean all of the 
    ''' addresses in the specified datafile and study.
    ''' </summary>
    ''' <param name="dataFileID">The datafile to be cleaned.</param>
    ''' <param name="studyID">The study to be cleaned.</param>
    ''' <param name="batchSize">The quantity of records to process on each pass.</param>
    ''' <param name="metaGroups">Collection of meta groups that specify information about this group.</param>
    ''' <param name="loadDB">The database these records are stored in.</param>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests.</param>
    ''' <remarks></remarks>
    Friend Sub CleanAll(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal batchSize As Integer, ByRef metaGroups As MetaGroupCollection, ByVal loadDB As LoadDatabases, ByVal forceProxy As Boolean)

        AddressProvider.CleanAll(dataFileID, studyID, batchSize, metaGroups, Me, loadDB, forceProxy)

    End Sub

    Private Function cleanSingleAddress(ByVal assignIDs As Boolean, ByVal forceProxy As Boolean, ByVal populateGeoCoding As Boolean, ByRef addr As Address) As net.melissadata.addresscheck.ResponseArray
        Dim addrCount As Integer = 1
        Dim addrUsed As Integer = 1
        Dim maxRecords As Integer = AppConfig.Params("AddressWebServiceMaxRecords").IntegerValue
        Dim addrCheckRequest As New net.melissadata.addresscheck.RequestArray
        Dim addrCheckResponse As New net.melissadata.addresscheck.ResponseArray
        Dim geoCodingCount As Integer = 1
        Dim geoCodingUsed As Integer = 1
        Dim geoCodingRequest As New net.melissadata.geocoder.RequestArray
        Dim geoCodingResponse As New net.melissadata.geocoder.ResponseArray



        'Initialize the SOAP request message
        addrCheckRequest.CustomerID = AppConfig.Params("AddressWebServiceCustomerID").StringValue
        addrCheckRequest.OptAddressParsed = "False"
      
        'Dimension the SOAP request message array for the first set of records
        ReDim addrCheckRequest.Record(GetArraySize(Count, addrUsed, maxRecords) - 1)

        'Create the address cleaning web service connection
        Using addrCheckService As New net.melissadata.addresscheck.Service
            'Initialize the web service
            addrCheckService.Url = AppConfig.Params("AddressWebServiceURL").StringValue

            'Determine if we need to use a proxy
            If forceProxy Then
                addrCheckService.Proxy = New WebProxy(AppConfig.Params("WebServiceProxyServer").StringValue, AppConfig.Params("WebServiceProxyPort").IntegerValue)
                addrCheckService.Proxy.Credentials = CredentialCache.DefaultCredentials
            End If

            'Clean all addresses in the collection

            'Increment the counters
            addrCount = 1
            addrUsed = 1

            'Check to see if we need to assign the id
            If assignIDs Then
                addr.DBKey = addrUsed
            End If

            'Add this address to the web service SOAP message
            AddAddress(addrCount, addr, addrCheckRequest)

            'Determine if it is time to call the web service           
            addrCheckResponse = addrCheckService.doAddressCheck(addrCheckRequest)

            'Check to see if the web service returned any errors
            Dim message As String = String.Empty

            If CheckForAddressWebRequestErrors(addrCheckResponse.Results, message) Then
                'We have encountered a general error from the web service.
                Throw New Exception(message)

            End If

        End Using

        'Initialize the SOAP request message
        geoCodingRequest.CustomerID = AppConfig.Params("GeoCodingWebServiceCustomerID").StringValue

        'Dimension the SOAP request message array for the first set of records
        ReDim geoCodingRequest.Record(GetArraySize(Count, geoCodingUsed, maxRecords) - 1)

        'Create the address cleaning web service connection
        Using geoCodingService As New net.melissadata.geocoder.Service
            'Initialize the web service
            geoCodingService.Url = AppConfig.Params("GeoCodingWebServiceURL").StringValue

            'Determine if we need to use a proxy
            If forceProxy Then
                geoCodingService.Proxy = New WebProxy(AppConfig.Params("WebServiceProxyServer").StringValue, AppConfig.Params("WebServiceProxyPort").IntegerValue)
                geoCodingService.Proxy.Credentials = CredentialCache.DefaultCredentials
            End If

            'Add this address to the web service SOAP message
            AddGeoCoding(geoCodingCount, addr, geoCodingRequest)

            'Determine if it is time to call the web service
            If geoCodingCount = maxRecords OrElse geoCodingUsed = Count Then
                'Call the web service to clean the current SOAP message
                geoCodingResponse = geoCodingService.doGeoCode(geoCodingRequest)

                'Check to see if the web service returned any errors
                Dim message As String = String.Empty
                If CheckForGeoCodingWebRequestErrors(geoCodingResponse.Results, message) Then
                    'We have encountered a general error from the web service.
                    Throw New Exception(message)
                End If

                'Find and update the returned addresses
                UpdateGeoCoding(geoCodingResponse)
            End If

        End Using

        Return addrCheckResponse
       
    End Function

#End Region

#Region " Private Methods "

    ''' <summary>
    ''' This routine determines the array size for the request object.
    ''' </summary>
    ''' <param name="total">Total number of records in the collection.</param>
    ''' <param name="used">Number of records cleaned so far.</param>
    ''' <param name="maxSize">Maximum number of records allowed in the request object.</param>
    ''' <returns>Returns the size to be used for the request object.</returns>
    ''' <remarks></remarks>
    Private Function GetArraySize(ByVal total As Integer, ByVal used As Integer, ByVal maxSize As Integer) As Integer

        If total - used > maxSize Then
            Return maxSize
        Else
            Return total - used
        End If

    End Function

    ''' <summary>
    ''' This routine adds the specified address to the request object.
    ''' </summary>
    ''' <param name="cnt">Specifies which element of the request object to add this address to.</param>
    ''' <param name="addr">The address to be added to the request object.</param>
    ''' <param name="request">The request object that the address should be added to.</param>
    ''' <remarks></remarks>
    Private Sub AddAddress(ByVal cnt As Integer, ByVal addr As Address, ByVal request As net.melissadata.addresscheck.RequestArray)

        'Initialize this address request record
        request.Record(cnt - 1) = New net.melissadata.addresscheck.RequestArrayRecord

        'Populate the address request record
        With request.Record(cnt - 1)
            'Add the address key
            .RecordID = addr.DBKey.ToString

            'Add StreetLine1
            .AddressLine1 = CleanString(addr.OriginalAddress.StreetLine1, True, True)

            'Add StreetLine2
            If addr.OriginalAddress.StreetLine2 <> "%NOT%USED%" Then
                .AddressLine2 = CleanString(addr.OriginalAddress.StreetLine2, True, True)
            End If

            'Add City
            .City = addr.OriginalAddress.City

            'Add the State/Province
            '-----------------------------------------------------------
            'State      Province    Use
            '-----------------------------------------------------------
            'Null       Not Null    Province
            'Null       Null        State
            'Not Null   Null        State
            'Not Null   Not Null    State
            '-----------------------------------------------------------
            If String.IsNullOrEmpty(addr.OriginalAddress.State) AndAlso Not String.IsNullOrEmpty(addr.OriginalAddress.Province) Then
                .State = addr.OriginalAddress.Province
            Else
                .State = addr.OriginalAddress.State
            End If

            'Add the Country
            If String.IsNullOrEmpty(addr.OriginalAddress.Country) Then
                Select Case mCountryID
                    Case CountryIDs.US
                        .Country = "US"

                    Case CountryIDs.Canada
                        .Country = "CA"

                    Case Else
                        .Country = String.Empty

                End Select
            Else
                .Country = addr.OriginalAddress.Country
            End If
            '.Country = addr.OriginalAddress.Country

            'Add the Zip/Postal Code
            'Zip5 = 88888 => Canadian address
            'Zip5 = 99999 => US or Canadian address with foreign language
            '--------------------------------------------------------------
            'Zip5   Postal      Use             Country     Language
            '--------------------------------------------------------------
            'Null   Not Null    Postal Code     Canada      English
            '88888  Not Null    Postal Code     Canada      English
            '99999  Not Null    Postal Code     Canada      Foreign
            '#####  Null        Zip5(-Zip4)     US          English
            '99999  Null        Zip5(-Zip4)     US          Foreign
            '--------------------------------------------------------------
            If (String.IsNullOrEmpty(addr.OriginalAddress.Zip5) OrElse addr.OriginalAddress.Zip5 = "88888" OrElse addr.OriginalAddress.Zip5 = "99999") AndAlso Not String.IsNullOrEmpty(addr.OriginalAddress.Postal) Then
                .Zip = addr.OriginalAddress.Postal
            Else
                .Zip = GetZipCode(addr.OriginalAddress)
            End If

            'Set NewZip5 for Canada address to keep Zip5 as it is.
            If mCountryID = CountryIDs.Canada Then addr.WorkingAddress.Zip5 = addr.OriginalAddress.Zip5
        End With

    End Sub

    ''' <summary>
    ''' This routine updates the addresses in the collection with those returned in the response object.
    ''' </summary>
    ''' <param name="responseArray">The response object containing the updated addresses.</param>
    ''' <remarks></remarks>
    Private Sub UpdateAddresses(ByVal responseArray As net.melissadata.addresscheck.ResponseArray)

        Dim cnt As Integer

        'Loop through all of the returned addresses and update them
        For cnt = 0 To CInt(responseArray.TotalRecords) - 1
            With responseArray.Record(cnt)
                'Find the address to be updated
                Dim addr As Address = FindAddress(CInt(.RecordID))

                'Check to see that the address was found
                If addr Is Nothing Then
                    Throw New Exception(String.Format("The Address Cleaning web service returned the following RecordID that could not be found in our collection: {0}", .RecordID))
                End If

                'If we are here then we need to update the address
                UpdateAddress(addr, .Address, .Results)
            End With
        Next

    End Sub

    ''' <summary>
    ''' This routine finds the address object with the specified dbKey.
    ''' </summary>
    ''' <param name="dbKey">The address key to be found.</param>
    ''' <returns>Returns the address object with the specified dbKey.</returns>
    ''' <remarks></remarks>
    Private Function FindAddress(ByVal dbKey As Integer) As Address

        'Find the specified address
        For Each addr As Address In Me
            If addr.DBKey = dbKey Then
                Return addr
            End If
        Next

        'No address was found
        Return Nothing

    End Function

    ''' <summary>
    ''' This routine updates all of the individual elements of the specified address object.
    ''' </summary>
    ''' <param name="addr">The address object to be updated.</param>
    ''' <param name="response">The response object containing the cleaned address.</param>
    ''' <param name="results">The result string for this address.</param>
    ''' <remarks></remarks>
    Private Sub UpdateAddress(ByVal addr As Address, ByVal response As net.melissadata.addresscheck.ResponseArrayRecordAddress, ByVal results As String)

        With addr.WorkingAddress
            'Get the Address Type
            Select Case response.Type.Address.Code.Trim.ToUpper
                Case "F"
                    .AddressType = AddressTypes.FirmOrCompany

                Case "G"
                    .AddressType = AddressTypes.GeneralDelivery

                Case "H"
                    .AddressType = AddressTypes.HighriseOrBusinessComplex

                Case "P"
                    .AddressType = AddressTypes.POBox

                Case "R"
                    .AddressType = AddressTypes.RuralRoute

                Case "S"
                    .AddressType = AddressTypes.StreetOrResidential

                Case Else
                    .AddressType = AddressTypes.None

            End Select

            'Get the Zip Type
            Select Case response.Type.Zip.Code.Trim.ToUpper
                Case "P"
                    .ZipCodeType = ZipCodeTypes.POBox

                Case "U"
                    .ZipCodeType = ZipCodeTypes.Unique

                Case "M"
                    .ZipCodeType = ZipCodeTypes.Military

                Case Else
                    .ZipCodeType = ZipCodeTypes.Standard

            End Select

            'Get the Urbanization
            .UrbanizationName = response.Urbanization.Name

            'Get the Private Mail Box
            .PrivateMailBox = response.PrivateMailBox

            'Get line 1 of the address
            .StreetLine1 = CleanString(response.Address1, True, False).ToUpper

            'Get line 2 of the address
            If addr.OriginalAddress.StreetLine2 = "%NOT%USED%" Then
                'Line 2 is not used in this study
                .StreetLine2 = String.Empty
            Else
                'Line 2 is used
                .StreetLine2 = CleanString(response.Address2, True, False).ToUpper
            End If

            'Get the suite information
            Dim suite As String = CleanString(response.Suite, True, False).ToUpper
            If Not String.IsNullOrEmpty(suite) Then
                'Suite information exists
                If addr.OriginalAddress.StreetLine2 = "%NOT%USED%" Then
                    'Line 2 is not used for this study so add the suite information to line 1
                    If Not .StreetLine1.ToUpper.Contains(suite) Then
                        .StreetLine1 = String.Format("{0} {1}", .StreetLine1, suite).Trim
                    End If
                Else
                    'Add the suite information to line 2
                    If Not .StreetLine2.ToUpper.Contains(suite) Then
                        .StreetLine2 = String.Format("{0} {1}", .StreetLine2, suite).Trim
                    End If
                End If
            End If

            'Get the city
            .City = CleanString(response.City.Name, True, False).ToUpper

            'Get remaining address parts based on country
            Select Case mCountryID
                Case CountryIDs.US
                    'Get the state
                    .State = response.State.Abbreviation.ToUpper

                    'Get the zip5
                    If addr.OriginalAddress.Zip5 = "99999" OrElse addr.OriginalAddress.Zip5 = "88888" Then
                        'Non-QualiSys-Language so leave as is for NQL processing
                        .Zip5 = addr.OriginalAddress.Zip5
                    Else
                        'Save zip5
                        .Zip5 = response.Zip
                    End If

                    'Get the zip4
                    .Zip4 = response.Plus4

                    'Get the delivery point information
                    .DeliveryPoint = response.DeliveryPointCode & response.DeliveryPointCheckDigit

                    'Get the carrier route information
                    .Carrier = response.CarrierRoute

                Case CountryIDs.Canada
                    'Get the province
                    .Province = CleanString(response.State.Abbreviation, True, False).ToUpper

                    'Get the postal code
                    .Postal = response.Zip

            End Select

            'Set the Country
            .Country = response.Country.Abbreviation.ToUpper

            'Set the Status Code
            .AddressStatus = GetAddressStatus(results)

            'Save the unique address key used for other Melissa services
            .AddressKey = response.AddressKey

            'Set the Error Code
            .AddressError = GetAddressError(results)
        End With

        If (response.Country.Abbreviation.ToUpper = "US" AndAlso mCountryID <> CountryIDs.US) OrElse _
           (response.Country.Abbreviation.ToUpper = "CA" AndAlso mCountryID <> CountryIDs.Canada) OrElse _
           (IsForeignError(results)) Then
            'Foreign address detected so set to original with error FO (Foreign)
            addr.SetCleanedTo(addr.OriginalAddress, "FO")
        ElseIf CheckForAddressErrors(results) Then
            If CheckForAddressSuccess(results) Then
                'At least one Address error was detected but so was one Address success so set to original with error NU (No Unit)
                addr.SetCleanedTo(addr.OriginalAddress, "NU")
            ElseIf CheckForValidSecondAddress(results, addr) Then
                addr.SetCleanedTo(addr.OriginalAddress, "NC")
                Dim originalAddress As Address = addr.Clone
                ResendSecondaryAddress(addr, originalAddress)
            Else
                'Address errors only were detected so set to original with error NC (Not Cleaned)
                addr.SetCleanedTo(addr.OriginalAddress, "NC")
            End If
        ElseIf addr.WorkingAddress.StreetLine1.Length > 60 OrElse addr.WorkingAddress.StreetLine2.Length > 42 Then
            'The address is too long so set to original with error TL (Too Long)
            addr.SetCleanedTo(addr.OriginalAddress, "TL")
        Else
            'The new address is good so set to working
            addr.SetCleanedTo(addr.WorkingAddress)
        End If

    End Sub

    Private Function ParseSingleAddress(ByVal responseArray As net.melissadata.addresscheck.ResponseArray, ByRef addr As Address) As Address

        Dim response As net.melissadata.addresscheck.ResponseArrayRecordAddress
        Dim results As String

        response = responseArray.Record(0).Address
        results = responseArray.Record(0).Results

        With addr.WorkingAddress
            'Get the Address Type
            Select Case response.Type.Address.Code.Trim.ToUpper
                Case "F"
                    .AddressType = AddressTypes.FirmOrCompany

                Case "G"
                    .AddressType = AddressTypes.GeneralDelivery

                Case "H"
                    .AddressType = AddressTypes.HighriseOrBusinessComplex

                Case "P"
                    .AddressType = AddressTypes.POBox

                Case "R"
                    .AddressType = AddressTypes.RuralRoute

                Case "S"
                    .AddressType = AddressTypes.StreetOrResidential

                Case Else
                    .AddressType = AddressTypes.None

            End Select

            'Get the Zip Type
            Select Case response.Type.Zip.Code.Trim.ToUpper
                Case "P"
                    .ZipCodeType = ZipCodeTypes.POBox

                Case "U"
                    .ZipCodeType = ZipCodeTypes.Unique

                Case "M"
                    .ZipCodeType = ZipCodeTypes.Military

                Case Else
                    .ZipCodeType = ZipCodeTypes.Standard

            End Select

            'Get the Urbanization
            .UrbanizationName = response.Urbanization.Name

            'Get the Private Mail Box
            .PrivateMailBox = response.PrivateMailBox

            'Get line 1 of the address
            .StreetLine1 = CleanString(response.Address1, True, False).ToUpper

            'Get line 2 of the address
            If addr.OriginalAddress.StreetLine2 = "%NOT%USED%" Then
                'Line 2 is not used in this study
                .StreetLine2 = String.Empty
            Else
                'Line 2 is used
                .StreetLine2 = CleanString(response.Address2, True, False).ToUpper
            End If

            'Get the suite information
            Dim suite As String = CleanString(response.Suite, True, False).ToUpper
            If Not String.IsNullOrEmpty(suite) Then
                'Suite information exists
                If addr.OriginalAddress.StreetLine2 = "%NOT%USED%" Then
                    'Line 2 is not used for this study so add the suite information to line 1
                    If Not .StreetLine1.ToUpper.Contains(suite) Then
                        .StreetLine1 = String.Format("{0} {1}", .StreetLine1, suite).Trim
                    End If
                Else
                    'Add the suite information to line 2
                    If Not .StreetLine2.ToUpper.Contains(suite) Then
                        .StreetLine2 = String.Format("{0} {1}", .StreetLine2, suite).Trim
                    End If
                End If
            End If

            'Get the city
            .City = CleanString(response.City.Name, True, False).ToUpper

            'Get remaining address parts based on country
            Select Case mCountryID
                Case CountryIDs.US
                    'Get the state
                    .State = response.State.Abbreviation.ToUpper

                    'Get the zip5
                    If addr.OriginalAddress.Zip5 = "99999" OrElse addr.OriginalAddress.Zip5 = "88888" Then
                        'Non-QualiSys-Language so leave as is for NQL processing
                        .Zip5 = addr.OriginalAddress.Zip5
                    Else
                        'Save zip5
                        .Zip5 = response.Zip
                    End If

                    'Get the zip4
                    .Zip4 = response.Plus4

                    'Get the delivery point information
                    .DeliveryPoint = response.DeliveryPointCode & response.DeliveryPointCheckDigit

                    'Get the carrier route information
                    .Carrier = response.CarrierRoute

                Case CountryIDs.Canada
                    'Get the province
                    .Province = CleanString(response.State.Abbreviation, True, False).ToUpper

                    'Get the postal code
                    .Postal = response.Zip

            End Select

            'Set the Country
            .Country = response.Country.Abbreviation.ToUpper

            'Set the Status Code
            .AddressStatus = GetAddressStatus(results)

            'Save the unique address key used for other Melissa services
            .AddressKey = response.AddressKey

            'Set the Error Code
            .AddressError = GetAddressError(results)
        End With

        Return addr

    End Function

    ''' <summary>
    ''' This routine checks the result string for an address and determines whether or not an error was encountered.
    ''' </summary>
    ''' <param name="results">The result string for this address.</param>
    ''' <returns>Returns a boolean indicating whether or not an error was encountered.</returns>
    ''' <remarks></remarks>
    Private Function CheckForAddressErrors(ByVal results As String) As Boolean

        For Each result As String In results.Split(","c)
            If result.StartsWith("AE") Then
                Return True
            End If
        Next

        Return False

    End Function



    Private Function CheckForValidSecondAddress(ByVal results As String, ByRef addr As Address) As Boolean


        If Not String.IsNullOrEmpty(addr.OriginalAddress.StreetLine2) AndAlso addr.OriginalAddress.StreetLine2.Length > 5 Then
            'If line 1 is within valid deliverable USPS range and the lines have not been swapped by Melissa Data
            If results.Contains("AE10") AndAlso Not results.Contains("AC06") Then
                Return True
            Else
                Return False
            End If
        End If
        Return False

    End Function

    Private Function ResendSecondaryAddress(ByRef addr As Address, ByVal clonedAddress As Address) As Boolean

        Dim primaryAddressHolder As String = addr.OriginalAddress.StreetLine1

        addr.OriginalAddress.StreetLine1 = addr.OriginalAddress.StreetLine2
        addr.OriginalAddress.StreetLine2 = primaryAddressHolder

        Dim responseArray As net.melissadata.addresscheck.ResponseArray = cleanSingleAddress(True, False, True, addr)

        Dim returnedAddress As Address = ParseSingleAddress(responseArray, addr)

        If CheckForAddressSuccess(returnedAddress.WorkingAddress.AddressStatus) Then
            'Use new address
            addr.SetCleanedTo(returnedAddress.WorkingAddress)
        Else
            'reassign old address to new one and error out the original error
            addr = clonedAddress
            addr.SetCleanedTo(addr.OriginalAddress, "NC")
        End If

    End Function

    ''' <summary>
    ''' This routine checks the result string for an address and determines whether or not an error was encountered.
    ''' </summary>
    ''' <param name="results">The result string for this address.</param>
    ''' <returns>Returns a boolean indicating whether or not an error was encountered.</returns>
    ''' <remarks></remarks>
    Private Function CheckForAddressSuccess(ByVal results As String) As Boolean

        For Each result As String In results.Split(","c)
            If result.StartsWith("AS") Then
                Return True
            End If
        Next

        Return False

    End Function

    ''' <summary>
    ''' This routine checks the result string for the web service call and determines whether or not an error was encountered.
    ''' </summary>
    ''' <param name="results">The result string for the web service call.</param>
    ''' <param name="message">The error message to throw if an error was encountered.</param>
    ''' <returns>Returns a boolean indicating whether or not an error was encountered.</returns>
    ''' <remarks></remarks>
    Private Function CheckForAddressWebRequestErrors(ByVal results As String, ByRef message As String) As Boolean

        If Not String.IsNullOrEmpty(results.Trim) Then
            'Errors have been encountered so lets build the error message
            message = String.Format("The Address Cleaning web service returned the following error(s):{0}{1}{0}", vbCrLf, results)

            'Loop through each returned result and add it to the message
            For Each result As String In results.Split(","c)
                Select Case result
                    Case "SE01"
                        message &= String.Format("{0}{1}: Web Service Internal Error;", vbCrLf, result)

                    Case "GE01"
                        message &= String.Format("{0}{1}: Empty XML Request Structure;", vbCrLf, result)

                    Case "GE02"
                        message &= String.Format("{0}{1}: Empty XML Request Record Structure;", vbCrLf, result)

                    Case "GE03"
                        message &= String.Format("{0}{1}: Counted records send more than number of records allowed per request;", vbCrLf, result)

                    Case "GE04"
                        message &= String.Format("{0}{1}: CustomerID empty;", vbCrLf, result)

                    Case "GE05"
                        message &= String.Format("{0}{1}: CustomerID not valid;", vbCrLf, result)

                    Case "GE06"
                        message &= String.Format("{0}{1}: CustomerID disabled;", vbCrLf, result)

                    Case "GE07"
                        message &= String.Format("{0}{1}: XML Request invalid;", vbCrLf, result)

                End Select
            Next result

            Return True
        Else
            'No web request errors exist
            Return False
        End If

    End Function

    ''' <summary>
    ''' This routine assembles the zip code.
    ''' </summary>
    ''' <param name="addr">The address object to use to build the zip code string.</param>
    ''' <returns>The assembled zip code for the specified address object.</returns>
    ''' <remarks></remarks>
    Private Function GetZipCode(ByVal addr As AddressSub) As String

        Dim zipCode As String = String.Empty

        If Not String.IsNullOrEmpty(addr.Zip5) Then
            If Not String.IsNullOrEmpty(addr.Zip4) Then
                zipCode = String.Format("{0}-{1}", addr.Zip5, addr.Zip4)
            Else
                zipCode = addr.Zip5
            End If
        End If

        Return zipCode

    End Function

    ''' <summary>
    ''' This routine cleans up the result string to make sure it will fit in the database column.
    ''' </summary>
    ''' <param name="results">The result string to be cleaned up.</param>
    ''' <returns>Returns a result string the will fit in the database column.</returns>
    ''' <remarks></remarks>
    Private Function GetAddressStatus(ByVal results As String) As String

        results = results.Trim
        If Not String.IsNullOrEmpty(results) Then
            If results.Length > 42 Then
                Return results.Substring(0, 42)
            Else
                Return results
            End If
        Else
            Return String.Empty
        End If

    End Function

    ''' <summary>
    ''' This routine determines the error code to be used based on the supplied result string.
    ''' </summary>
    ''' <param name="results">The result string to be used.</param>
    ''' <returns>The error code to be stored in the database.</returns>
    ''' <remarks></remarks>
    Private Function GetAddressError(ByVal results As String) As String

        results = results.Trim
        If Not String.IsNullOrEmpty(results) Then
            If results.Length >= 2 Then
                Return results.Substring(0, 2)
            Else
                Return results
            End If
        Else
            Return String.Empty
        End If

    End Function

    ''' <summary>
    ''' This routine determines if the error is a foreign error code.
    ''' </summary>
    ''' <param name="results">The result string to be used.</param>
    ''' <returns>TRUE if the error code is a foreign error, 
    '''          FALSE is it is not a foreign error.</returns>
    ''' <remarks></remarks>
    Private Function IsForeignError(ByVal results As String) As Boolean

        If results.Contains("AS09") Then
            Return True
        Else
            Return False
        End If

    End Function

    ''' <summary>
    ''' This routine adds the specified addresses geocode to the request object.
    ''' </summary>
    ''' <param name="cnt">Specifies which element of the request object to add this geocode to.</param>
    ''' <param name="addr">The address to be added to the request object.</param>
    ''' <param name="request">The request object that the geocode should be added to.</param>
    ''' <remarks></remarks>
    Private Sub AddGeoCoding(ByVal cnt As Integer, ByVal addr As Address, ByVal request As net.melissadata.geocoder.RequestArray)

        'Initialize this geocode request record
        request.Record(cnt - 1) = New net.melissadata.geocoder.RequestArrayRecord

        'Populate the geocode request record
        With request.Record(cnt - 1)
            'Add the address DB key
            .RecordID = addr.DBKey.ToString

            'Add the AddressKey
            .AddressKey = addr.CleanedAddress.AddressKey
        End With

    End Sub

    ''' <summary>
    ''' This routine checks the result string for an addresses geocode and determines whether or not an error was encountered.
    ''' </summary>
    ''' <param name="results">The result string for this geocode.</param>
    ''' <returns>Returns a boolean indicating whether or not an error was encountered.</returns>
    ''' <remarks></remarks>
    Private Function CheckForGeoCodeErrors(ByVal results As String) As Boolean

        For Each result As String In results.Split(","c)
            If result.StartsWith("GE") OrElse result.StartsWith("DE") Then
                Return True
            End If
        Next

        Return False

    End Function

    ''' <summary>
    ''' This routine checks the result string for the web service call and determines whether or not an error was encountered.
    ''' </summary>
    ''' <param name="results">The result string for the web service call.</param>
    ''' <param name="message">The error message to throw if an error was encountered.</param>
    ''' <returns>Returns a boolean indicating whether or not an error was encountered.</returns>
    ''' <remarks></remarks>
    Private Function CheckForGeoCodingWebRequestErrors(ByVal results As String, ByRef message As String) As Boolean

        If Not String.IsNullOrEmpty(results.Trim) Then
            'Errors have been encountered so lets build the error message
            message = String.Format("The GeoCoding web service returned the following error(s):{0}{1}{0}", vbCrLf, results)

            'Loop through each returned result and add it to the message
            For Each result As String In results.Split(","c)
                Select Case result
                    Case "SE01"
                        message &= String.Format("{0}{1}: Web Service Internal Error;", vbCrLf, result)

                    Case "GE01"
                        message &= String.Format("{0}{1}: Empty XML Request Structure;", vbCrLf, result)

                    Case "GE02"
                        message &= String.Format("{0}{1}: Empty XML Request Record Structure;", vbCrLf, result)

                    Case "GE03"
                        message &= String.Format("{0}{1}: Counted records send more than number of records allowed per request;", vbCrLf, result)

                    Case "GE04"
                        message &= String.Format("{0}{1}: CustomerID empty;", vbCrLf, result)

                    Case "GE05"
                        message &= String.Format("{0}{1}: CustomerID not valid;", vbCrLf, result)

                    Case "GE06"
                        message &= String.Format("{0}{1}: CustomerID disabled;", vbCrLf, result)

                    Case "GE07"
                        message &= String.Format("{0}{1}: XML Request invalid;", vbCrLf, result)

                End Select
            Next result

            Return True
        Else
            'No web request errors exist
            Return False
        End If

    End Function

    ''' <summary>
    ''' This routine cleans up the result string to make sure it will fit in the database column.
    ''' </summary>
    ''' <param name="results">The result string to be cleaned up.</param>
    ''' <returns>Returns a result string that will fit in the database column.</returns>
    ''' <remarks></remarks>
    Private Function GetGeoCodeStatus(ByVal results As String) As String

        results = results.Trim
        If Not String.IsNullOrEmpty(results) Then
            If results.Length > 42 Then
                Return results.Substring(0, 42)
            Else
                Return results
            End If
        Else
            Return String.Empty
        End If

    End Function

    ''' <summary>
    ''' This routine updates the addresses in the collection with those returned in the response object.
    ''' </summary>
    ''' <param name="responseArray">The response object containing the updated addresses.</param>
    ''' <remarks></remarks>
    Private Sub UpdateGeoCoding(ByVal responseArray As net.melissadata.geocoder.ResponseArray)

        Dim cnt As Integer

        'Loop through all of the returned geocodes and update them
        For cnt = 0 To CInt(responseArray.TotalRecords) - 1
            With responseArray.Record(cnt)
                'Find the address to be updated
                Dim addr As Address = FindAddress(CInt(.RecordID))

                'Check to see that the address was found
                If addr Is Nothing Then
                    Throw New Exception(String.Format("The Address Cleaning web service returned the following RecordID that could not be found in our collection: {0}", .RecordID))
                End If

                'If we are here then we need to update the addresses geocode
                UpdateGeoCode(addr, .Address, .Results)
            End With
        Next

    End Sub

    ''' <summary>
    ''' This routine updates all of the individual elements of the specified address object.
    ''' </summary>
    ''' <param name="addr">The address object to be updated.</param>
    ''' <param name="response">The response object containing the cleaned address.</param>
    ''' <param name="results">The result string for this address.</param>
    ''' <remarks></remarks>
    Private Sub UpdateGeoCode(ByVal addr As Address, ByVal response As net.melissadata.geocoder.ResponseArrayRecordAddress, ByVal results As String)

        'Set the Status Code
        addr.GeoCode.GeoCodeStatus = GetGeoCodeStatus(results)

        If Not CheckForGeoCodeErrors(results) Then
            With addr.GeoCode
                'Get the County
                .CountyFIPS = response.County.Fips
                .CountyName = response.County.Name

                'Get the latitude
                .Latitude = response.Latitude

                'Get the longitude
                .Longitude = response.Longitude

                'Get the Cencus Bureau's Place
                .PlaceCode = response.Place.Code
                .PlaceName = response.Place.Name

                'Get the time zone
                .TimeZoneCode = response.TimeZone.Code
                .TimeZoneName = response.TimeZone.Name

                'Get the Census Bureau's Code Based Statistical Area (CBSA)
                .CBSACode = response.CBSA.Code
                .CBSALevel = response.CBSA.Level
                .CBSATitle = response.CBSA.Title
                .CBSADivisionCode = response.CBSA.CBSADivisionCode
                .CBSADivisionLevel = response.CBSA.CBSADivisionLevel
                .CBSADivisionTitle = response.CBSA.CBSADivisionTitle

                'Get the Census Block
                .CensusBlock = response.Census.Block
                .CensusTract = response.Census.Tract
            End With
        End If

    End Sub

#End Region

End Class
