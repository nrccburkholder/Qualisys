Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json
Imports System.IO
Imports System.Net
Imports System.Data
Imports System.Data.SqlClient
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class AddressCollection
    Inherits BusinessListBase(Of AddressCollection, Address)
#Region " Private Members "

    Private mCountryID As CountryIDs
    Private Const WEB_SERVICE_MAX_RETRIES As Integer = 3
    Private customerID As String
    Private transmissionReference As String = "" 'The Transmission Reference is a unique string value that identifies this particular request
    Private actions As String 'The Check action will validate the individual input data pieces for validity and correct them if possible. 
    Private options As String 'The Options field allows you to configure a number of options that change the way the service behaves.
    Private columns As String 'The Columns input field allows you to select either individual columns Or groups which will then be returned in the outpu


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

    Public Sub Clean(ByVal forceProxy As Boolean)

        'The DBKey property of the address object is not publicly exposed so it will need to be set by the application.
        Clean(True, -1)

    End Sub

    Public Sub Clean()

        'The DBKey property of the address object is not publicly exposed so it will need to be set by the application.
        Clean(True, -1)

    End Sub


    Public Sub Clean(ByVal populateGeoCoding As Boolean, ByVal dataFileId As Integer)

        'The DBKey property of the address object is not publicly exposed so it will need to be set by the application.
        Clean(populateGeoCoding, dataFileId, False)

    End Sub

    Public Sub Clean(ByVal populateGeoCoding As Boolean, ByVal dataFileId As Integer, ByVal propCase As Boolean)

        'The DBKey property of the address object is not publicly exposed so it will need to be set by the application.
        Clean(True, populateGeoCoding, dataFileId, propCase)

    End Sub

#End Region

#Region " Friend Methods "

    Private Function DoAddressCheckWithRetries(ByRef addressCleanRecords As List(Of Object), ByVal dataFileId As Integer) As JObject

        Dim tryCount As Integer = 0

        Dim responseText As String = String.Empty
        Dim jObj As JObject = Nothing

        Do
            tryCount += 1

            If (tryCount > 1) Then
                'Sleep for some seconds before retrying
                Threading.Thread.Sleep(5 * 1000)
            End If

            Try
                responseText = MelissaDataApiJsonCall(addressCleanRecords)
                jObj = JObject.Parse(responseText)

                If (tryCount > 1) Then
                    Logs.Info(String.Format("SUCCESS DoAddressCheckWithRetries - DataFile_Id:{0} Attempt:{1}", dataFileId, tryCount))
                End If
                Exit Do
            Catch ex As Exception
                Logs.LogException(ex, String.Format("ERROR DoAddressCheckWithRetries - DataFile_Id:{0} Attempt:{1}", dataFileId, tryCount))
                If (tryCount >= WEB_SERVICE_MAX_RETRIES) Then
                    Throw
                End If

            End Try

        Loop While tryCount < WEB_SERVICE_MAX_RETRIES

        Return jObj


    End Function


    Friend Sub Clean(ByVal assignIDs As Boolean, ByVal populateGeoCoding As Boolean, ByVal dataFileId As Integer, ByVal propCase As Boolean)

        Dim addrCount As Integer = 0
        Dim addrUsed As Integer = 0
        Dim webCallCount As Integer = 0
        Dim maxRecords As Integer = AppConfig.Params("AddressWebServiceMaxRecords").IntegerValue


        transmissionReference = Guid.NewGuid().ToString()
        customerID = AppConfig.Params("AddressWebServiceCustomerID").StringValue
        actions = AppConfig.Params("AddressCleaningActions").StringValue
        options = AppConfig.Params("AddressCleaningOptions").StringValue
        columns = AppConfig.Params("AddressCleaningColumns").StringValue

        Dim personatorResponse As JObject
        Dim transmissionResults As String

        Dim addressCleanRecords As New List(Of Object)

        'Clean all addresses in the collection
        For Each addr As Address In Me
            'Increment the counters
            addrCount += 1
            addrUsed += 1

            'Check to see if we need to assign the id
            If assignIDs Then
                addr.DBKey = addrUsed
            End If

            'Add this address to the web service request

            AddAddress(addrCount, addr, addressCleanRecords)

            'Determine if it is time to call the web service
            If addrCount = maxRecords OrElse addrUsed = Count Then
                webCallCount += 1
                'Call the web service to clean the current SOAP message
                Logs.Info(String.Format("Begin addrCheckService.doAddressCheck - DataFile_Id:{0}, AddrCount: {1}, WebCallCount: {2}, Pop_Id: {3}", dataFileId, addrCount, webCallCount, addr.DBKey))

                Try
                    personatorResponse = DoAddressCheckWithRetries(addressCleanRecords, dataFileId)
                    transmissionResults = personatorResponse.Item("TransmissionResults").ToString()
                Catch ex As Exception
                    Logs.LogException(ex, String.Format("ERROR addrCheckService.doAddressCheck - DataFile_Id:{0}, Pop_Id: {1}", dataFileId, addr.DBKey))
                    Throw ex
                End Try

                Logs.Info(String.Format("End addrCheckService.doAddressCheck - DataFile_Id:{0}, Pop_Id: {1}", dataFileId, addr.DBKey))
                'Check to see if the web service returned any errors
                Dim message As String = String.Empty
                If CheckForWebRequestErrors(transmissionResults, message) Then
                    'We have encountered a general error from the web service.
                    Throw New Exception(message)
                End If

                'Find and update the returned addresses and names
                UpdateAddresses(personatorResponse, populateGeoCoding, dataFileId, propCase)  ' modify UpdateAddress to update name, address and geocode

                'Reset and prepare for next set of addresses to be added to the request
                addrCount = 0
                addressCleanRecords.Clear()
            End If
        Next


    End Sub

    Friend Sub CleanAll(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal batchSize As Integer, ByRef metaData As AddressMetadata, ByVal loadDB As LoadDatabases)

        AddressProvider.CleanAll(dataFileID, studyID, batchSize, metaData, Me, loadDB)

    End Sub

    Friend Function MelissaDataApiJsonCall(ByVal addressCleanRecords As List(Of Object)) As String


        Dim httpWebRequest As HttpWebRequest = DirectCast(WebRequest.Create("https://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify"), HttpWebRequest)
        httpWebRequest.ContentType = "text/json"
        httpWebRequest.Method = "POST"

        Dim serializer As Newtonsoft.Json.JsonSerializer = New Newtonsoft.Json.JsonSerializer()
        Using sw As StreamWriter = New StreamWriter(httpWebRequest.GetRequestStream())
            Using tw As Newtonsoft.Json.JsonTextWriter = New Newtonsoft.Json.JsonTextWriter(sw)
                Dim requestData As Object = New With {
                Key .TransmissionReference = transmissionReference,
                Key .CustomerID = customerID,
                Key .Actions = actions,
                Key .Options = options,
                Key .Columns = columns,
                Key .Records = addressCleanRecords.ToArray()
            }

                serializer.Serialize(tw, requestData)
            End Using
        End Using
        Dim httpResponse As HttpWebResponse = DirectCast(httpWebRequest.GetResponse(), HttpWebResponse)
        Using streamReader As StreamReader = New StreamReader(httpResponse.GetResponseStream())
            Dim responseText As String = streamReader.ReadToEnd()
            Return responseText
        End Using
    End Function

    Private Function cleanSingleAddress(ByVal assignIDs As Boolean, ByVal populateGeoCoding As Boolean, ByRef addr As Address, ByVal dataFileId As Integer) As JObject
        Dim addrCount As Integer = 0
        Dim addrUsed As Integer = 0
        Dim webCallCount As Integer = 0
        Dim maxRecords As Integer = AppConfig.Params("AddressWebServiceMaxRecords").IntegerValue

        Dim personatorResponse As JObject
        Dim transmissionResults As String

        addrCount += 1
        addrUsed += 1

        'Check to see if we need to assign the id
        If assignIDs Then
            addr.DBKey = addrUsed
        End If

        Dim addressCleanRecords As New List(Of Object)
        'Add this address to the web service SOAP message
        AddAddress(addrCount, addr, addressCleanRecords)

        'Call the web service   
        Logs.Info(String.Format("Begin Single addrCheckService.doAddressCheck - DataFile_Id:{0}, Pop_Id: {1}", dataFileId, addr.DBKey))

        Try
            personatorResponse = DoAddressCheckWithRetries(addressCleanRecords, dataFileId)
            transmissionResults = personatorResponse.Item("TransmissionResults").ToString()
        Catch ex As Exception
            Logs.LogException(ex, String.Format("ERROR addrCheckService.doAddressCheck - DataFile_Id:{0}, Pop_Id: {1}", dataFileId, addr.DBKey))
            Throw ex
        End Try

        Logs.Info(String.Format("End Single addrCheckService.doAddressCheck - DataFile_Id:{0}, Pop_Id: {1}", dataFileId, addr.DBKey))

        'Check to see if the web service returned any errors
        Dim message As String = String.Empty

        If CheckForWebRequestErrors(transmissionResults, message) Then
            'We have encountered a general error from the web service.
            Throw New Exception(message)

        End If

        'Find and update the returned addresses and names
        Return personatorResponse


    End Function

#End Region

#Region " Private Methods "

    Private Sub AddAddress(ByVal cnt As Integer, ByVal addr As Address, ByRef addressCleanRecords As List(Of Object))

        Dim RecordID As String = addr.DBKey.ToString
        Dim CompanyName As String = ""

        Dim firstName As String = String.Empty
        Dim middleName As String = String.Empty
        Dim lastName As String = String.Empty
        Dim FullName As String = String.Empty

        If String.IsNullOrEmpty(addr.OriginalName.FirstName) Then
            firstName = "XXXXX"
        Else
            firstName = addr.OriginalName.FirstName
        End If

        If String.IsNullOrEmpty(addr.OriginalName.MiddleInitial) Then
            middleName = String.Empty
        Else
            middleName = addr.OriginalName.MiddleInitial
        End If

        If String.IsNullOrEmpty(addr.OriginalName.LastName) Then
            lastName = "ZZZZZ"
        Else
            lastName = addr.OriginalName.LastName
        End If

        'Build the name string
        FullName = String.Format("{0} {1} {2} {3}", firstName, middleName, lastName, addr.OriginalName.Suffix).Trim

        Dim AddressLine1 As String = CleanString(addr.OriginalAddress.StreetLine1, True, True)
        Dim AddressLine2 As String = String.Empty
        If addr.OriginalAddress.StreetLine2 <> "%NOT%USED%" Then
            AddressLine2 = CleanString(addr.OriginalAddress.StreetLine2, True, True)
        End If
        Dim Suite As String = ""
        Dim City As String = addr.OriginalAddress.City

        'Add the State/Province
        '-----------------------------------------------------------
        'State      Province    Use
        '-----------------------------------------------------------
        'Null       Not Null    Province
        'Null       Null        State
        'Not Null   Null        State
        'Not Null   Not Null    State
        '-----------------------------------------------------------
        Dim State As String = String.Empty
        If String.IsNullOrEmpty(addr.OriginalAddress.State) AndAlso Not String.IsNullOrEmpty(addr.OriginalAddress.Province) Then
            State = addr.OriginalAddress.Province
        Else
            State = addr.OriginalAddress.State
        End If


        Dim Zip As String = String.Empty

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
            Zip = addr.OriginalAddress.Postal
        Else
            Zip = GetZipCode(addr.OriginalAddress)
        End If

        Dim Country As String = ""

        'Add the Country
        If String.IsNullOrEmpty(addr.OriginalAddress.Country) Then
            Select Case mCountryID
                Case CountryIDs.US
                    Country = "US"

                Case CountryIDs.Canada
                    Country = "CA"

                Case Else
                    Country = String.Empty

            End Select
        Else
            Country = addr.OriginalAddress.Country
        End If

        'Set NewZip5 for Canada address to keep Zip5 as it is.
        If mCountryID = CountryIDs.Canada Then addr.WorkingAddress.Zip5 = addr.OriginalAddress.Zip5

        Dim o As Object = New With {
            Key .RecordID = RecordID,
            Key .CompanyName = CompanyName,
            Key .FullName = FullName,
            Key .AddressLine1 = AddressLine1,
            Key .AddressLine2 = AddressLine2,
            Key .Suite = Suite,
            Key .City = City,
            Key .State = State,
            Key .PostalCode = Zip,
            Key .Country = Country
        }

        addressCleanRecords.Add(o)

    End Sub

    Private Sub UpdateAddresses(ByVal personatorResponse As JObject, ByVal populateGeoCoding As Boolean, ByVal datafileId As Integer, ByVal propCase As Boolean)

        'Loop through all of the returned addresses and update them
        For i As Integer = 0 To CInt(personatorResponse.Item("TotalRecords")) - 1

            Dim cleanRecord As JToken = personatorResponse.Item("Records").Item(i)
            Dim recordID As Integer = CInt(cleanRecord("RecordID"))
            'Find the address to be updated
            Dim addr As Address = FindAddress(recordID)

            'Check to see that the address was found
            If addr Is Nothing Then
                Throw New Exception(String.Format("The Address Cleaning web service returned the following RecordID that could not be found in our collection: {0}", recordID))
            End If

            'If we are here then we need to update the address
            UpdateAddress(addr, cleanRecord, datafileId)
            UpdateName(addr, cleanRecord, propCase)
            If populateGeoCoding Then
                UpdateGeoCode(addr, cleanRecord)
            End If
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


    Private Sub UpdateAddress(ByVal addr As Address, ByRef response As JToken, ByVal datafileId As Integer)

        Dim results As String = response("Results").ToString

        With addr.WorkingAddress
            'Get the Address Type
            Select Case response("AddressTypeCode").ToString().Trim.ToUpper
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
            Select Case response("AddressTypeCode").ToString().Trim.ToUpper
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
            .UrbanizationName = response("UrbanizationName").ToString().Trim.ToUpper

            'Get the Private Mail Box
            .PrivateMailBox = response("PrivateMailBox").ToString().Trim.ToUpper

            'Get line 1 of the address
            .StreetLine1 = CleanString(response("AddressLine1").ToString(), True, False).ToUpper

            'Get line 2 of the address
            If addr.OriginalAddress.StreetLine2 = "%NOT%USED%" Then
                'Line 2 is not used in this study
                .StreetLine2 = String.Empty
            Else
                'Line 2 is used
                .StreetLine2 = CleanString(response("AddressLine2").ToString(), True, False).ToUpper
            End If

            'Get the suite information
            Dim suiteInfo As String = String.Format("{0} {1}", response("AddressSuiteName").ToString(), response("AddressSuiteNumber").ToString()).Trim
            Dim suite As String = CleanString(suiteInfo, True, False).ToUpper
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
            .City = CleanString(response("City").ToString(), True, False).ToUpper

            'Get remaining address parts based on country
            Select Case mCountryID
                Case CountryIDs.US
                    'Get the state
                    .State = response("State").ToString().ToUpper

                    'Get the zip5
                    If addr.OriginalAddress.Zip5 = "99999" OrElse addr.OriginalAddress.Zip5 = "88888" Then
                        'Non-QualiSys-Language so leave as is for NQL processing
                        .Zip5 = addr.OriginalAddress.Zip5
                    Else
                        'Save zip5
                        .Zip5 = response("PostalCode").ToString()
                    End If

                    'Get the zip4
                    .Zip4 = response("Plus4").ToString()

                    'Get the delivery point information
                    .DeliveryPoint = response("DeliveryPointCode").ToString & response("DeliveryPointCheckDigit").ToString

                    'Get the carrier route information
                    .Carrier = response("CarrierRoute").ToString

                Case CountryIDs.Canada
                    'Get the province
                    .Province = CleanString(response("State").ToString(), True, False).ToUpper

                    'Get the postal code
                    .Postal = response("PostalCode").ToString()

            End Select

            'Set the Country
            .Country = response("CountryCode").ToString.ToUpper

            'Set the Status Code
            .AddressStatus = GetResultStatus(GetResultCodes(response("Results").ToString, "A"))

            'Save the unique address key used for other Melissa services
            .AddressKey = response("AddressKey").ToString

            'Set the Error Code
            .AddressError = GetAddressError(GetResultCodes(response("Results").ToString, "A"))
        End With

        If (response("CountryCode").ToString.ToUpper = "US" AndAlso mCountryID <> CountryIDs.US) OrElse
           (response("CountryCode").ToString.ToUpper = "CA" AndAlso mCountryID <> CountryIDs.Canada) OrElse
           (IsForeignError(results)) Then
            'Foreign address detected so set to original with error FO (Foreign)
            addr.SetAddressCleanedTo(addr.OriginalAddress, "FO")
        ElseIf CheckForAddressErrors(results) Then
            If CheckForAddressSuccess(results) Then
                'At least one Address error was detected but so was one Address success so set to original with error NU (No Unit)
                addr.SetAddressCleanedTo(addr.OriginalAddress, "NU")
            ElseIf CheckForValidSecondAddress(results, addr) Then
                addr.SetAddressCleanedTo(addr.OriginalAddress, "NC")
                ResendSecondaryAddress(addr, datafileId)
            Else
                'Address errors only were detected so set to original with error NC (Not Cleaned)
                addr.SetAddressCleanedTo(addr.OriginalAddress, "NC")
            End If
        ElseIf addr.WorkingAddress.StreetLine1.Length > 60 OrElse addr.WorkingAddress.StreetLine2.Length > 42 Then
            'The address is too long so set to original with error TL (Too Long)
            addr.SetAddressCleanedTo(addr.OriginalAddress, "TL")
        Else
            'The new address is good so set to working
            addr.SetAddressCleanedTo(addr.WorkingAddress)
        End If

    End Sub

    Private Sub UpdateName(ByVal item As Address, ByRef response As JToken, ByVal properCase As Boolean)

        Dim results As String = GetResultCodes(response("Results").ToString, "N")

        Dim stringConv As Microsoft.VisualBasic.VbStrConv
        If mCountryID = CountryIDs.Canada OrElse Not properCase Then
            stringConv = VbStrConv.Uppercase
        Else
            stringConv = VbStrConv.ProperCase
        End If

        With item.WorkingName
            'Save the new name
            .Title = String.Empty
            .FirstName = CleanString(response("NameFirst").ToString, True, False)
            .MiddleInitial = CleanString(response("NameMiddle").ToString, True, False)
            .LastName = CleanString(response("NameLast").ToString, True, False)
            .Suffix = CleanString(response("NameSuffix").ToString, True, False)
            .NameStatus = GetResultStatus(results)

            'Check for error conditions
            Dim numString As String = "0123456789"
            Dim numArray As Char() = numString.ToCharArray()

            'Check the first name
            If .FirstName.ToUpper = "XXXXX" Then
                .FirstName = String.Empty
            ElseIf .FirstName.Length = 0 And item.OriginalName.FirstName.Length > 0 Then
                If item.OriginalName.FirstName.IndexOfAny(numArray) > -1 Then  ' checking to see if the firstname contains a number
                    .NameStatus = "ERROR"
                Else
                    .FirstName = StrConv(CleanString(item.OriginalName.FirstName, True, False), stringConv)
                End If
            End If

            'Check the middle name
            If .MiddleInitial.Length = 0 And item.OriginalName.MiddleInitial.Length > 0 Then
                .MiddleInitial = item.OriginalName.MiddleInitial.Substring(0, 1).ToUpper
            ElseIf .MiddleInitial.Length > 1 Then
                .MiddleInitial = .MiddleInitial.Substring(0, 1).ToUpper
            End If

            'Check the last name
            If .LastName.ToUpper = "ZZZZZ" Then
                .LastName = String.Empty
            ElseIf .LastName.Length = 0 And item.OriginalName.LastName.Length > 0 Then
                If item.OriginalName.LastName.IndexOfAny(numArray) > -1 Then ' checking to see if the lastname contains a number
                    .NameStatus = "ERROR"
                Else
                    .LastName = StrConv(CleanString(item.OriginalName.LastName, True, False), stringConv)
                End If
            End If
        End With

        If CheckForNameErrors(results) Then
            'Name errors were detected so set to original with working status
            item.SetNameCleanedTo(item.OriginalName, item.WorkingName.NameStatus)
        ElseIf Not item.WorkingName.NameStatus.StartsWith("ERR") Then
            'Check lengths
            If item.WorkingName.FirstName.Length > 42 OrElse item.WorkingName.LastName.Length > 42 Then
                'One of the working name fields is to long so set to original with status ERROR
                item.SetNameCleanedTo(item.OriginalName, "ERROR")
            Else
                'The new name is good so set to working
                item.SetNameCleanedTo(item.WorkingName)
            End If
        Else
            'The new name is good so set to working
            item.SetNameCleanedTo(item.WorkingName)
        End If

        'Determine if the result is supposed to be in UPPERCASE
        If stringConv = VbStrConv.Uppercase Then
            With item.CleanedName
                .Title = .Title.ToUpper
                .FirstName = .FirstName.ToUpper
                .MiddleInitial = .MiddleInitial.ToUpper
                .LastName = .LastName.ToUpper
                .Suffix = .Suffix.ToUpper
            End With
        End If

    End Sub

    Private Function GetResultCodes(cleanResultCode As String, code As String) As String
        Dim s As String = String.Empty
        For Each result As String In cleanResultCode.Split(","c)
            If result.StartsWith(code) Then
                s = s & result & ","
            End If
        Next
        If s = String.Empty Then
            Return s
        Else
            Return s.Substring(0, s.Length - 1)
        End If


    End Function


    Private Function ParseSingleAddress(ByRef responses As JObject, ByRef addr As Address) As Address


        Dim response As JToken = responses.Item("Records").Item(0)
        Dim results As String = response("Results").ToString

        With addr.WorkingAddress
            'Get the Address Type
            Select Case response("AddressTypeCode").ToString().Trim.ToUpper
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
            Select Case response("AddressTypeCode").ToString().Trim.ToUpper
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
            .UrbanizationName = response("UrbanizationName").ToString().Trim.ToUpper

            'Get the Private Mail Box
            .PrivateMailBox = response("PrivateMailBox").ToString().Trim.ToUpper

            'Get line 1 of the address
            .StreetLine1 = CleanString(response("AddressLine1").ToString(), True, False).ToUpper

            'Get line 2 of the address
            If addr.OriginalAddress.StreetLine2 = "%NOT%USED%" Then
                'Line 2 is not used in this study
                .StreetLine2 = String.Empty
            Else
                'Line 2 is used
                .StreetLine2 = CleanString(response("AddressLine2").ToString(), True, False).ToUpper
            End If

            'Get the suite information
            Dim suiteInfo As String = String.Format("{0} {1}", response("AddressSuiteName").ToString(), response("AddressSuiteNumber").ToString()).Trim
            Dim suite As String = CleanString(suiteInfo, True, False).ToUpper
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
            .City = CleanString(response("City").ToString(), True, False).ToUpper

            'Get remaining address parts based on country
            Select Case mCountryID
                Case CountryIDs.US
                    'Get the state
                    .State = response("State").ToString().ToUpper

                    'Get the zip5
                    If addr.OriginalAddress.Zip5 = "99999" OrElse addr.OriginalAddress.Zip5 = "88888" Then
                        'Non-QualiSys-Language so leave as is for NQL processing
                        .Zip5 = addr.OriginalAddress.Zip5
                    Else
                        'Save zip5
                        .Zip5 = response("PostalCode").ToString()
                    End If

                    'Get the zip4
                    .Zip4 = response("Plus4").ToString()

                    'Get the delivery point information
                    .DeliveryPoint = response("DeliveryPointCode").ToString & response("DeliveryPointCheckDigit").ToString

                    'Get the carrier route information
                    .Carrier = response("CarrierRoute").ToString

                Case CountryIDs.Canada
                    'Get the province
                    .Province = CleanString(response("State").ToString(), True, False).ToUpper

                    'Get the postal code
                    .Postal = response("PostalCode").ToString()

            End Select

            'Set the Country
            .Country = response("CountryCode").ToString.ToUpper

            'Set the Status Code
            .AddressStatus = GetResultStatus(GetResultCodes(response("Results").ToString, "A"))

            'Save the unique address key used for other Melissa services
            .AddressKey = response("AddressKey").ToString

            'Set the Error Code
            .AddressError = GetAddressError(GetResultCodes(response("Results").ToString, "A"))
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

    Private Sub ResendSecondaryAddress(ByRef origAddr As Address, ByVal datafileId As Integer)

        'Make clone of the address being passed in
        Dim clonedAddress As Address = origAddr.Clone

        'Swap first and second lines for this second attempt on the clone
        origAddr.OriginalAddress.StreetLine1 = clonedAddress.OriginalAddress.StreetLine2
        origAddr.OriginalAddress.StreetLine2 = clonedAddress.OriginalAddress.StreetLine1

        origAddr.WorkingAddress.StreetLine1 = clonedAddress.OriginalAddress.StreetLine2
        origAddr.WorkingAddress.StreetLine2 = clonedAddress.OriginalAddress.StreetLine1

        'Make the web service call with the clone/swapped address
        Dim responseArray As JObject = cleanSingleAddress(False, True, origAddr, datafileId)

        'Parse the address clean response into an Address object
        Dim returnedAddress As Address = ParseSingleAddress(responseArray, origAddr)

        If CheckForAddressSuccess(returnedAddress.WorkingAddress.AddressStatus) Then
            'Success, use new address
            origAddr.SetAddressCleanedTo(returnedAddress.WorkingAddress)
        Else
            'return the original address
            origAddr = clonedAddress
        End If

    End Sub

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

    Private Function CheckForWebRequestErrors(ByVal transmissionResults As String, ByRef message As String) As Boolean

        If Not String.IsNullOrEmpty(transmissionResults.Trim) Then
            'Errors have been encountered so lets build the error message
            message = String.Format("The Address Cleaning web service returned the following error(s):{0}{1}{0}", vbCrLf, transmissionResults)

            'Loop through each returned result and add it to the message
            For Each result As String In transmissionResults.Split(","c)
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
    Private Function GetResultStatus(ByVal results As String) As String

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


    Private Sub UpdateGeoCode(ByVal addr As Address, ByRef response As JToken)

        'Set the Status Code
        Dim GeoCodeResultCodes As String = GetResultCodes(response("Results").ToString, "G") & GetResultCodes(response("Results").ToString, "D")
        addr.GeoCode.GeoCodeStatus = GeoCodeResultCodes


        If Not CheckForGeoCodeErrors(GeoCodeResultCodes) Then
            With addr.GeoCode
                'Get the County
                .CountyFIPS = response("CountyFIPS").ToString
                .CountyName = response("CountyName").ToString

                'Get the latitude
                .Latitude = response("Latitude").ToString

                'Get the longitude
                .Longitude = response("Longitude").ToString

                'Get the Cencus Bureau's Place
                .PlaceCode = response("PlaceCode").ToString
                .PlaceName = response("PlaceName").ToString

                ''Get the time zone  - personator data only includes UTC offset
                '.TimeZoneCode = response("TimeZone.Code").ToString
                '.TimeZoneName = response("TimeZone.Name").ToString

                'Get the Census Bureau's Code Based Statistical Area (CBSA)
                .CBSACode = response("CBSACode").ToString
                .CBSALevel = response("CBSALevel").ToString
                .CBSATitle = response("CBSATitle").ToString
                .CBSADivisionCode = response("CBSADivisionCode").ToString
                .CBSADivisionLevel = response("CBSADivisionLevel").ToString
                .CBSADivisionTitle = response("CBSADivisionTitle").ToString

                'Get the Census Block
                .CensusBlock = response("CensusBlock").ToString
                .CensusTract = response("CensusTract").ToString
            End With
        End If

    End Sub

    Private Function CheckForNameErrors(ByVal results As String) As Boolean

        For Each result As String In results.Split(","c)
            If result.StartsWith("NE") Then
                Return True
            End If
        Next

        Return False

    End Function

#End Region

End Class
