Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json
Imports System.IO
Imports System.Net
Imports System.Data
Imports System.Data.SqlClient
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class NameCollection
    Inherits BusinessListBase(Of NameCollection, Name)

#Region " Private Members "

    Private mCountryID As CountryIDs

#End Region

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As Name = Name.NewName
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
    ''' names currently contained in collection.
    ''' </summary>
    ''' <param name="properCase">Specifies if proper case formatting should be applied.</param>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests</param>
    ''' <remarks></remarks>
    Public Sub Clean(ByVal properCase As Boolean, ByVal forceProxy As Boolean, ByVal dataFileId As Integer)

        'The DBKey property of the name object is not publicly exposed so it will need to be set by the application.
        Clean(properCase, True, forceProxy, dataFileId)

    End Sub

#End Region

#Region " Friend Methods "

    ''' <summary>
    ''' This routine is the internal interface called to clean all of the
    ''' names currently contained in collection
    ''' </summary>
    ''' <param name="properCase">Specifies if proper case formatting should be applied.</param>
    ''' <param name="assignIDs">Specified whether or not the names need to have the DBKey set</param>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests</param>
    ''' <remarks></remarks>
    Friend Sub Clean(ByVal properCase As Boolean, ByVal assignIDs As Boolean, ByVal forceProxy As Boolean, ByVal dataFileId As Integer)

        Dim nameCount As Integer = 0
        Dim nameUsed As Integer = 0
        Dim maxRecords As Integer = AppConfig.Params("NameWebServiceMaxRecords").IntegerValue

        'CAMELINCKX INC40090 IU Health Incorrect Name Issue
        'For this incident here we will introduce logic that will based on a list of MelissaData prefixes
        'decide whether the OptNameHint should be 1 (instead of default of 2), where the values are:
        '1 - DefinitelyFull: Name will always be treated as normal name order, regardless of formatting or punctuation.
        '2 - Name will be treated as normal name order unless inverse order is clearly indicated by formatting or punctuation.

        Dim personatorResponse As JObject
        Dim transmissionResults As String

        Dim nameCleaningPrefixes As List(Of String) = New List(Of String)

        For numNameCleaningPrefixParam As Integer = 1 To 100
            Try
                Dim prefixsLine As String
                Dim paramVal As Param = AppConfig.Params("NameCleaningPrefix" + numNameCleaningPrefixParam.ToString())
                If paramVal Is Nothing Then Exit For
                prefixsLine = paramVal.StringValue
                For Each prefix As String In prefixsLine.Split(";".ToCharArray())
                    nameCleaningPrefixes.Add(prefix)
                Next
            Catch ex As Exception
                Exit For
            End Try
        Next

        'Dimension the SOAP request message array for the first set of records
        Dim nameCleanRecords As New List(Of Object)

        'Clean all names in the collection
        For Each item As Name In Me
            'Increment the counters
            nameCount += 1
            nameUsed += 1

            'Check to see if we need to assign the id
            If assignIDs Then
                item.DBKey = nameUsed
            End If

            'Add this name to the web service SOAP message
            AddName(nameCount, item, nameCleanRecords, nameCleaningPrefixes)

            'Determine if it is time to call the web service
            If nameCount = maxRecords OrElse nameUsed = Count Then

                'Call the web service to clean the current SOAP message

                Logs.Info(String.Format("Begin nameCheckService.doNameCheck - DataFile_Id:{0}, AddrCount: {1}", dataFileId, nameCount))

                Try
                    personatorResponse = DoNameCheckWithRetries(nameCleanRecords, dataFileId)
                    transmissionResults = personatorResponse.Item("TransmissionResults").ToString()
                Catch ex As Exception
                    Logs.LogException(ex, String.Format("ERROR nameCheckService.doNameCheck - DataFile_Id:{0}", dataFileId))
                    Throw ex
                End Try

                Logs.Info(String.Format("End nameCheckService.doNameCheck - DataFile_Id:{0}", dataFileId))

                'Check to see if the web service returned any errors
                Dim message As String = String.Empty
                If CheckForWebRequestErrors(transmissionResults, message) Then
                    'We have encountered a general error from the web service.
                    Throw New Exception(message)
                End If

                'Find and update the returned names
                UpdateNames(personatorResponse, properCase, dataFileId)

                'Reset and prepare for next set of names to be added to the SOAP message
                nameCount = 0
                nameCleanRecords.Clear()
            End If
        Next

    End Sub

    ''' <summary>
    ''' This routine is the internal interface called to clean all of the 
    ''' names in the specified datafile and study.
    ''' </summary>
    ''' <param name="dataFileID">The datafile to be cleaned.</param>
    ''' <param name="studyID">The study to be cleaned.</param>
    ''' <param name="batchSize">The quantity of records to process on each pass.</param>
    ''' <param name="metaGroups">Collection of meta groups that specify information about this group.</param>
    ''' <param name="loadDB">The database these records are stored in.</param>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests.</param>
    ''' <remarks></remarks>
    Friend Sub CleanAll(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal batchSize As Integer, ByRef metaGroups As MetaGroupCollection, ByVal loadDB As LoadDatabases, ByVal forceProxy As Boolean)

        NameProvider.CleanAll(dataFileID, studyID, batchSize, metaGroups, Me, loadDB, forceProxy)

    End Sub

#End Region

#Region " Private Methods "

    Private Const WEB_SERVICE_MAX_RETRIES As Integer = 3

    Private Function DoNameCheckWithRetries(ByRef nameCleanRecords As List(Of Object), ByVal dataFileId As Integer) As JObject

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
                responseText = MelissaDataApiJsonCall(nameCleanRecords)
                jObj = JObject.Parse(responseText)

                If (tryCount > 1) Then
                    Logs.Info(String.Format("SUCCESS DoNameCheckWithRetries - DataFile_Id:{0} Attempt:{1}", dataFileId, tryCount))
                End If
                Exit Do
            Catch ex As Exception
                Logs.LogException(ex, String.Format("ERROR DoNameCheckWithRetries - DataFile_Id:{0} Attempt:{1}", dataFileId, tryCount))
                If (tryCount >= WEB_SERVICE_MAX_RETRIES) Then
                    Throw
                End If

            End Try

        Loop While tryCount < WEB_SERVICE_MAX_RETRIES

        Return jObj

    End Function


    Friend Function MelissaDataApiJsonCall(ByRef addressCleanRecords As List(Of Object)) As String
        Dim TransmissionReference As String = ""
        'The Transmission Reference is a unique string value that identifies this particular request
        Dim CustomerID As String = AppConfig.Params("AddressWebServiceCustomerID").StringValue
        ' I think this was provided by BJ
        Dim Actions As String = "Check"
        'The Check action will validate the individual input data pieces for validity and correct them if possible. 
        Dim Options As String = "AdvancedAddressCorrection:on"
        'UsePreferredCity:on
        Dim Columns As String = "GrpCensus,GrpGeocode,GrpAddressDetails,PrivateMailBox,GrpParsedAddress,Plus4"
        'To use Geocode, you must have the geocode columns on: GrpCensus or GrpGeocode.
        Dim NameHint As String = "2"

        Dim httpWebRequest As HttpWebRequest = DirectCast(WebRequest.Create("https://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify"), HttpWebRequest)
        httpWebRequest.ContentType = "text/json"
        httpWebRequest.Method = "POST"

        Dim serializer As Newtonsoft.Json.JsonSerializer = New Newtonsoft.Json.JsonSerializer()
        Using sw As StreamWriter = New StreamWriter(httpWebRequest.GetRequestStream())
            Using tw As Newtonsoft.Json.JsonTextWriter = New Newtonsoft.Json.JsonTextWriter(sw)
                Dim requestData As Object = New With {
                Key .TransmissionReference = TransmissionReference,
                Key .CustomerID = CustomerID,
                Key .Actions = Actions,
                Key .Options = Options,
                Key .Columns = Columns,
                Key .NameHint = NameHint,
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
    ''' <param name="cnt">Specifies which element of the request object to add this name to.</param>
    ''' <param name="item">The name to be added to the request object.</param>
    ''' <param name="request">The request object that the name should be added to.</param>
    ''' <remarks></remarks>
    Private Sub AddName(ByVal cnt As Integer, ByVal item As Name, ByRef nameCleanRecords As List(Of Object), ByRef nameCleaningPrefixes As List(Of String))

        Dim RecordID As String = item.DBKey.ToString

        'Let's try to deal with nulls
        Dim firstName As String = String.Empty
        Dim middleName As String = String.Empty
        Dim lastName As String = String.Empty

        If String.IsNullOrEmpty(item.OriginalName.FirstName) Then
            firstName = "XXXXX"
        Else
            firstName = item.OriginalName.FirstName
        End If

        If String.IsNullOrEmpty(item.OriginalName.MiddleInitial) Then
            middleName = String.Empty
        Else
            middleName = item.OriginalName.MiddleInitial
        End If

        If String.IsNullOrEmpty(item.OriginalName.LastName) Then
            lastName = "ZZZZZ"
        Else
            lastName = item.OriginalName.LastName
        End If

        'Build the name string
        Dim fullName As String = String.Format("{0} {1} {2} {3}", firstName, middleName, lastName, item.OriginalName.Suffix).Trim

        'If nameCleaningPrefixes.Contains(firstName.ToUpper()) _
        '    Or (nameCleaningPrefixes.Contains(middleName.ToUpper())) _
        '    Or (nameCleaningPrefixes.Contains(lastName.ToUpper())) Then
        '    request.OptNameHint = "1"
        'End If

        Dim o As Object = New With {
            Key .RecordID = RecordID,
            Key .FirstName = firstName,
            Key .MiddleName = middleName,
            Key .LastName = lastName,
            Key .Suffix = item.OriginalName.Suffix,
            Key .FullName = fullName
        }

        nameCleanRecords.Add(o)
    End Sub

    ''' <summary>
    ''' This routine updates the names in the collection with those returned in the response object.
    ''' </summary>
    ''' <param name="responseArray">The response object containing the updated names.</param>
    ''' <param name="properCase">Specifies if proper case formatting should be applied.</param>
    ''' <remarks></remarks>
    Private Sub UpdateNames(ByVal personatorResponse As JObject, ByVal properCase As Boolean, ByVal datafileId As Integer)

        'Loop through all of the returned names and update them
        For i As Integer = 0 To CInt(personatorResponse.Item("TotalRecords")) - 1

            Dim cleanRecord As JToken = personatorResponse.Item("Records").Item(i)
            Dim recordID As Integer = CInt(cleanRecord("RecordID"))

            'Find the name to be updated
            Dim item As Name = FindName(recordID)

            'Check to see that the name was found
            If item Is Nothing Then
                Throw New Exception(String.Format("The Name Cleaning web service returned the following RecordID that could not be found in our collection: {0}", recordID))
            End If

            'If we are here then we need to update the name
            UpdateName(item, cleanRecord, properCase, datafileId)
        Next

    End Sub

    ''' <summary>
    ''' This routine finds the name object with the specified dbKey.
    ''' </summary>
    ''' <param name="dbKey">The name key to be found.</param>
    ''' <returns>Returns the name object with the specified dbKey.</returns>
    ''' <remarks></remarks>
    Private Function FindName(ByVal dbKey As Integer) As Name

        'Find the specified name
        For Each item As Name In Me
            If item.DBKey = dbKey Then
                Return item
            End If
        Next

        'No name was found
        Return Nothing

    End Function

    ''' <summary>
    ''' This routine updates all of the individual elements of the specified name object.
    ''' </summary>
    ''' <param name="item">The name object to be updated.</param>
    ''' <param name="response">The response object containing the cleaned name.</param>
    ''' <param name="results">The result string for this name.</param>
    ''' <remarks></remarks>
    Private Sub UpdateName(ByVal item As Name, ByRef response As JToken, ByVal properCase As Boolean, ByVal datafileId As Integer)

        Dim stringConv As Microsoft.VisualBasic.VbStrConv
        If mCountryID = CountryIDs.Canada OrElse Not properCase Then
            stringConv = VbStrConv.Uppercase
        Else
            stringConv = VbStrConv.ProperCase
        End If

        With item.WorkingName
            'Save the new name
            .Title = String.Empty
            .FirstName = CleanString(response("FirstName").ToString(), True, False)
            .MiddleInitial = CleanString(response("MiddleName").ToString(), True, False)
            .LastName = CleanString(response("LastName").ToString(), True, False)
            .Suffix = CleanString(response("Suffix").ToString(), True, False)
            .NameStatus = GetNameStatus(GetResultCodes(response("Results").ToString, "A"))

            'Check for error conditions
            Dim numString As String = "0123456789"
            Dim numArray As Char() = numString.ToCharArray()

            'Check the first name
            If .FirstName.ToUpper = "XXXXX" Then
                .FirstName = String.Empty
            ElseIf .FirstName.Length = 0 And item.OriginalName.FirstName.Length > 0 Then
                If item.OriginalName.FirstName.IndexOfAny(numArray) > -1 Then
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
                If item.OriginalName.LastName.IndexOfAny(numArray) > -1 Then
                    .NameStatus = "ERROR"
                Else
                    .LastName = StrConv(CleanString(item.OriginalName.LastName, True, False), stringConv)
                End If
            End If
        End With

        If CheckForNameErrors(GetResultCodes(response("Results").ToString, "A")) Then
            'Name errors were detected so set to original with working status
            item.SetCleanedTo(item.OriginalName, item.WorkingName.NameStatus)
        ElseIf Not item.WorkingName.NameStatus.StartsWith("ERR") Then
            'Check lengths
            If item.WorkingName.FirstName.Length > 42 OrElse item.WorkingName.LastName.Length > 42 Then
                'One of the working name fields is to long so set to original with status ERROR
                item.SetCleanedTo(item.OriginalName, "ERROR")
            Else
                'The new name is good so set to working
                item.SetCleanedTo(item.WorkingName)
            End If
        Else
            'The new name is good so set to working
            item.SetCleanedTo(item.WorkingName)
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

    ''' <summary>
    ''' This routine checks the result string for an name and determines whether or not an error was encountered.
    ''' </summary>
    ''' <param name="results">The result string for this name.</param>
    ''' <returns>Returns a boolean indicating whether or not an error was encountered.</returns>
    ''' <remarks></remarks>
    Private Function CheckForNameErrors(ByVal results As String) As Boolean

        For Each result As String In results.Split(","c)
            If result.StartsWith("NE") Then
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
    Private Function CheckForWebRequestErrors(ByVal results As String, ByRef message As String) As Boolean

        If Not String.IsNullOrEmpty(results.Trim) Then
            'Errors have been encountered so lets build the error message
            message = String.Format("The Name Cleaning web service returned the following error(s):{0}{1}{0}", vbCrLf, results)

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
    ''' <returns>Returns a result string the will fit in the database column.</returns>
    ''' <remarks></remarks>
    Private Function GetNameStatus(ByVal results As String) As String

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

    Private Function GetResultCodes(cleanResultCode As String, code As String) As String
        Dim s As String = String.Empty
        For Each result As String In cleanResultCode.Split(","c)
            Dim c As String = result.Substring(0, 1)
            If result.StartsWith(code) Then
                s = s & result & ","
            End If
        Next

        If s.Length > 0 Then
            Return s.Substring(0, s.Length - 1)
        Else
            Return String.Empty
        End If

    End Function
#End Region

End Class
