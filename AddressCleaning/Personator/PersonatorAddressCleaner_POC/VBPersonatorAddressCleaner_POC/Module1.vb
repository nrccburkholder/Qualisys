Imports System.TimeZoneInfo
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json
Imports System.IO
Imports System.Net
Imports System.Data
Imports System.Data.SqlClient


Module Module1

    Public Sub Main()
        Dim environment As String = "STAGE"
        Dim dataFile_id As Integer = 475774
        Dim study_id As Integer = 5575
        Dim batchSize As Integer = 100
        Dim totalBatches As Integer = 59

        Console.WriteLine("MelissaData Personator Address Cleaner")
        Console.WriteLine(String.Format("Running for:" & vbLf & vbTab & "Qualisys Environment {0}" & vbLf & vbTab & "DataFile_Id {1}" & vbLf & vbTab & "Study_Id {2}" & vbLf & vbTab & "MaxRecords {3}" & vbLf & vbTab & "TotalBatches {4}", environment, dataFile_id, study_id, batchSize, totalBatches))
        Console.WriteLine()

        Dim totalMatch As Integer = 0, totalMismatch As Integer = 0

        For batchIdx As Integer = 0 To totalBatches - 1
            Dim countMatch As Integer, countMismatch As Integer
            ProcessBatch(environment, dataFile_id, study_id, batchIdx, batchSize, countMatch,
            countMismatch)
            totalMatch += countMatch
            totalMismatch += countMismatch
        Next

        Console.WriteLine("FINAL Compare Counts")
        Console.WriteLine("      MATCHES " & totalMatch)
        Console.WriteLine("   MISMATCHES " & totalMismatch)


        Console.WriteLine("Press ENTER to exit.")
        Console.ReadLine()
    End Sub


    Private Sub ProcessBatch(environment As String, DataFile_id As Integer, Study_id As Integer, batchIdx As Integer, batchSize As Integer, ByRef countMatch As Integer,
    ByRef countMismatch As Integer)
        countMatch = 0
        countMismatch = 0

        Dim responseText As String = MelissaDataApiJsonCall(environment, DataFile_id, Study_id, batchIdx, batchSize)

        Dim jObj As JObject = Nothing
        Try
            'Console.WriteLine("API RESPONSE");
            'Console.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(jObj, Newtonsoft.Json.Formatting.Indented));
            jObj = JObject.Parse(responseText)
        Catch ex As Exception
            Console.WriteLine("Unable to parse json: " + ex.Message)
            Console.WriteLine("API RESPONSE")
            Console.WriteLine(responseText)
            Console.WriteLine()
        End Try


        Try
            If jObj IsNot Nothing Then
                Console.WriteLine()
                Console.WriteLine("Comparing Against QP_Load..EncounterTable")
                CompareResultAgainStudyPopulationTable(jObj, environment, DataFile_id, Study_id, batchIdx, batchSize,
                countMatch, countMismatch)
            End If
        Catch ex As Exception
            Console.WriteLine("Unable to compare against encounters: " + ex.Message)
            Console.WriteLine()
        End Try
    End Sub


    Public Function MelissaDataApiJsonCall(environment As String, DataFile_id As Integer, Study_id As Integer, batchIdx As Integer, batchSize As Integer) As String
        Dim TransmissionReference As String = ""
        'The Transmission Reference is a unique string value that identifies this particular request
        Dim CustomerID As String = "99869570"
        ' I think this was provided by BJ
        Dim Actions As String = "Check"
        'The Check action will validate the individual input data pieces for validity and correct them if possible. 
        Dim Options As String = "AdvancedAddressCorrection:on"
        'UsePreferredCity:on
        Dim Columns As String = "GrpCensus,GrpGeocode, GrpNameDetails,GrpAddressDetails,PrivateMailBox,GrpParsedAddress,Plus4"
        'To use Geocode, you must have the geocode columns on: GrpCensus or GrpGeocode.
        Dim NameHint As String = "2"

        Dim httpWebRequest = DirectCast(WebRequest.Create("https://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify"), HttpWebRequest)
        httpWebRequest.ContentType = "text/json"
        httpWebRequest.Method = "POST"

        Dim serializer = New Newtonsoft.Json.JsonSerializer()
        Using sw = New StreamWriter(httpWebRequest.GetRequestStream())
            Using tw = New Newtonsoft.Json.JsonTextWriter(sw)
                Dim requestData As Object = New With {
                Key .TransmissionReference = TransmissionReference,
                Key .CustomerID = CustomerID,
                Key .Actions = Actions,
                Key .Options = Options,
                Key .Columns = Columns,
                Key .NameHint = NameHint,
                Key .Records = BuildAddressRecords(environment, DataFile_id, Study_id, batchIdx, batchSize)
            }

                serializer.Serialize(tw, requestData)
            End Using
        End Using
        Dim httpResponse = DirectCast(httpWebRequest.GetResponse(), HttpWebResponse)
        Using streamReader = New StreamReader(httpResponse.GetResponseStream())
            Dim responseText = streamReader.ReadToEnd()
            Return responseText
        End Using
    End Function


    Private Function BuildAddressRecords(environment As String, DataFile_Id As Integer, Study_Id As Integer, batchIdx As Integer, batchSize As Integer) As Object()
        Dim CLEAN_PHONE As Boolean = False
        Dim CLEAN_NAME As Boolean = True

        Dim addressCleanRecords As New List(Of Object)()

        'Pull records from DataFile
        Dim encounters As DataTable = GetDataFileRecords(environment, DataFile_Id, batchIdx, batchSize)

        For Each e As DataRow In encounters.Rows
            Dim RecordID As String = e("DF_id").ToString()
            'e["DataFile_id"].ToString() + "_" + 
            Dim CompanyName As String = ""
            Dim FullName As String
            Dim Middle As String = e("Middle").ToString().Trim()

            If CLEAN_NAME Then
                If String.IsNullOrWhiteSpace(Middle) Then
                    FullName = String.Concat(e("FName"), " ", e("LName"))
                Else
                    FullName = String.Concat(e("FName"), " ", Middle, " ", e("LName"))
                End If
            Else
                FullName = ""
            End If


            ' NOTE:  The "raw" column names for a datafile will not always match these.  The current AddressCleaner makes a call to AC_GetMetaGroups and then reassigns to use "common" names

            Dim AddressLine1 As String = e("Addr").ToString()
            'e["Addr"].ToString();
            Dim AddressLine2 As String = e("Addr2").ToString()
            Dim Suite As String = ""
            Dim City As String = e("City").ToString()
            Dim State As String = e("ST").ToString()
            Dim PostalCode As String = e("Zip5").ToString()
            Dim Country As String = ""
            Dim PhoneNumber As String = If(CLEAN_PHONE, String.Concat(e("AreaCode"), e("Phone")), "")
            Dim EmailAddress As String = ""
            Dim FreeForm As String = ""

            'AddressLine2,
            Dim o = New With {
            Key .RecordID = RecordID,
            Key .CompanyName = CompanyName,
            Key .FullName = FullName,
            Key .AddressLine1 = AddressLine1,
            Key .AddressLine2 = "",
            Key .Suite = Suite,
            Key .City = City,
            Key .State = State,
            Key .PostalCode = PostalCode,
            Key .Country = Country,
            Key .PhoneNumber = PhoneNumber,
            Key .EmailAddress = EmailAddress,
            Key .FreeForm = FreeForm
        }

            addressCleanRecords.Add(o)
        Next


        Return addressCleanRecords.ToArray()
    End Function


    Private Function GetDataFileRecords(environment As String, datafile_id As Integer, batchIdx As Integer, batchSize As Integer) As DataTable
        'string limitExpression = maxRecords > 0 ? string.Format(" WHERE DF_ID <= {0} ", maxRecords) : "";
        'string sql = string.Format("SELECT * FROM DataFile_{0}{1}", datafile_id, limitExpression);
        Dim offset As Integer = (batchIdx * batchSize) + 1
        Dim sql As String = String.Format("SELECT * FROM DataFile_{0} WHERE DF_ID >= {1} AND DF_ID<{2} ORDER BY DF_ID", datafile_id, offset, offset + batchSize)
        Return SelectTableFromDB(environment, sql)
    End Function

    Private Function SelectTableFromDB(environment As String, sql As String) As DataTable
        Console.WriteLine("Executing SQL: " & sql)

        Dim serverName As String = GetEnvironmentQPLoadServerName(environment)

        Dim connStr As String = String.Format("Server={0};Database=QP_Load;Trusted_Connection=True;", serverName)

        Using conn As New SqlConnection(connStr)
            Dim sda As New SqlDataAdapter(sql, conn)
            Dim table As New DataTable()
            Try
                conn.Open()
                sda.Fill(table)
            Finally
                conn.Close()
            End Try
            Return table
        End Using
    End Function

    Private Function GetEnvironmentQPLoadServerName(environment As String) As String
        Dim serverName As String
        If environment.ToUpper() = "STAGE" Then
            serverName = "Cyclone"
            Return serverName
        End If
        If True Then
            Throw New Exception(String.Format("Don't know how to reach environment: [{0}]", environment))
        End If
    End Function

    Private Sub CompareResultAgainStudyPopulationTable(personatorResponse As JObject, environment As String, datafile_id As Integer, study_id As Integer, batchIdx As Integer, batchSize As Integer,
    ByRef countMatch As Integer, ByRef countMismatch As Integer)
        Console.WriteLine("Starting Data Compare")
        Dim offset As Integer = (batchIdx * batchSize) + 1
        Dim sql As String = String.Format("SELECT * FROM S{0}.POPULATION_Load WHERE DataFile_id = {1} AND DF_ID >= {2} AND DF_ID<{3} ORDER BY DF_ID", study_id, datafile_id, offset, offset + batchSize)
        Dim pops As DataTable = SelectTableFromDB(environment, sql)

        countMatch = 0
        countMismatch = 0
        Dim countNameMatch As Integer = 0
        Dim countNameMismatch As Integer = 0

        Dim totalRecords As String = personatorResponse.Item("TotalRecords").ToString()
        Dim transmissionResults As String = personatorResponse.Item("TransmissionResults").ToString()

        For i As Integer = 0 To pops.Rows.Count - 1

            Dim cleanRecord As JToken = personatorResponse.Item("Records").Item(i)
            Dim pop As DataRow = pops.Rows(i)

            Dim cleanAddr1 As String = cleanRecord("AddressLine1").ToString().Trim().ToUpper()
            Dim cleanAddr2 As String = cleanRecord("AddressLine2").ToString().Trim().ToUpper()
            Dim cleanAddr As String = cleanAddr1 & (If(String.IsNullOrWhiteSpace(cleanAddr2), "", (" " & cleanAddr2)))

            Dim suiteInfo As String = String.Format("{0} {1}", cleanRecord("AddressSuiteName").ToString(), cleanRecord("AddressSuiteNumber").ToString()).Trim

            If suiteInfo.Length > 0 Then
                Console.WriteLine(suiteInfo)
            End If

            Dim cleanFname As String = cleanRecord("NameFirst").ToString().Trim().ToUpper()
            Dim cleanLname As String = cleanRecord("NameLast").ToString().Trim().ToUpper()
            Dim cleanFullName As String = cleanRecord("NameFull").ToString().Trim().ToUpper()
            Dim cleanFullName2 As String = cleanFname & (If(String.IsNullOrWhiteSpace(cleanLname), "", (" " & cleanLname)))

            Dim utc As String = cleanRecord("UTC").ToString
            Dim tspan As TimeSpan = TimeSpan.Parse(utc)

            Dim cleanResultCode As String = cleanRecord("Results").ToString



            Dim popAddr1 As String = pop("Addr").ToString()
            Dim popAddr2 As String = pop("Addr2").ToString()
            Dim popAddr As String = popAddr1 & (If(String.IsNullOrWhiteSpace(popAddr2), "", (" " & popAddr2)))

            Dim popFname As String = pop("FName").ToString().ToUpper()
            Dim popLname As String = pop("LName").ToString().ToUpper()
            Dim popMname As String = pop("Middle").ToString().ToUpper()
            Dim popFullName As String = popFname & (If(String.IsNullOrWhiteSpace(popMname), "", (" " & popMname))) & (If(String.IsNullOrWhiteSpace(popLname), "", (" " & popLname)))

            Dim popResultCode As String = pop("AddrStat").ToString()
            Dim popResultName As String = pop("NameStat").ToString()

            Dim addressResultsCode As String = GetResultCodes(cleanResultCode, "A")
            Dim nameResultsCode As String = GetResultCodes(cleanResultCode, "N")



            Console.WriteLine()
            If cleanAddr = popAddr AndAlso addressResultsCode.Contains(popResultCode) Then
                countMatch += 1
                Console.WriteLine("ADDRESS PSEUDO-MATCH (upper casing, unsplit)")
                Console.WriteLine("Personator: [" & cleanAddr & "]" & vbTab & "[" & addressResultsCode & "]")
                Console.WriteLine("Legacy:     [" & popAddr & "]" & vbTab & "[" & popResultCode & "]")
            Else
                countMismatch += 1
                Console.WriteLine("ADDRESS MISMATCH")
                Console.WriteLine("Personator: [" & cleanAddr & "]" & vbTab & "[" & addressResultsCode & "]")
                Console.WriteLine("Legacy:     [" & popAddr & "]" & vbTab & "[" & popResultCode & "]")
                Console.WriteLine()
            End If
            Console.WriteLine()
            If cleanFullName = popFullName AndAlso nameResultsCode.Contains(popResultName) Then
                countNameMatch += 1
                Console.WriteLine("NAME PSEUDO-MATCH (upper casing, unsplit)")
                Console.WriteLine("Personator: [" & cleanFullName & "]" & vbTab & "[" & nameResultsCode & "]")
                Console.WriteLine("Legacy:     [" & popFullName & "]" & vbTab & "[" & popResultName & "]")
            Else
                countNameMismatch += 1
                Console.WriteLine("NAME MISMATCH")
                Console.WriteLine("Personator: [" & cleanFullName & "]" & vbTab & "[" & nameResultsCode & "]")
                Console.WriteLine("Legacy:     [" & popFullName & "]" & vbTab & "[" & popResultName & "]")
                Console.WriteLine()


            End If
        Next

        Console.WriteLine()
        Console.WriteLine("Batch Compare Counts")
        Console.WriteLine("   ADDRESS    MATCHES " & countMatch)
        Console.WriteLine("   ADDRESS MISMATCHES " & countMismatch)
        Console.WriteLine()
        Console.WriteLine("   NAME       MATCHES " & countNameMatch)
        Console.WriteLine("   NAME    MISMATCHES " & countNameMismatch)
        Console.WriteLine()
    End Sub

    Private Function GetResultCodes(cleanResultCode As String, code As String) As String
        Dim s As String = String.Empty
        For Each result As String In cleanResultCode.Split(","c)
            Dim c As String = result.Substring(0, 1)
            If result.Substring(0, 1) = code Then
                s = s & result & ","
            End If
        Next

        Return s

    End Function


End Module
