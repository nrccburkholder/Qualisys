Imports Nrc.QualiSys.Scanning.Library.Vovici_ProjectData
Imports System.Net
Imports System.Data
Imports System.Xml
Imports Nrc.Framework.Notification
Imports Nrc.Framework.BusinessLogic.Configuration

''' <summary>
''' This class is used to interact with Vovici Web Service - Project Data
''' </summary>
''' <remarks></remarks>
Public Class VoviciProjectData

    Private mSvcProjectData As ProjectData

    Private _Login As String
    Private _Password As String

    Public Sub New()

        mSvcProjectData = New ProjectData
        Dim cookies As CookieContainer = New CookieContainer
        mSvcProjectData.CookieContainer = cookies

    End Sub


    Public Sub New(ByVal login As String, ByVal password As String, ByVal url As String)

        mSvcProjectData = New ProjectData
        mSvcProjectData.Url = url '"https://efm.nrcsurveyor.net/ws/projectdata.asmx"
        Me._Login = login
        Me._Password = password
        Dim cookies As CookieContainer = New CookieContainer
        mSvcProjectData.CookieContainer = cookies

    End Sub


    ''' <summary>
    ''' Logs into the Vovici projectdata web service.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub Login()

        mSvcProjectData.Login(_Login, _Password)

    End Sub

    ''' <summary>
    ''' Returns a list of surveys on Vovici
    ''' </summary>
    ''' <param name="filter">Lets you apply a filter to the list. Sample: Name Like 'NRC*'
    '''  Pass empty string for no filter.</param>
    ''' <returns>A dataview with the filtered Vovici survey list.</returns>
    ''' <remarks></remarks>
    Public Function GetSurveyList(ByVal filter As String) As DataView

        Dim node As XmlNode
        Dim ds As New DataSet

        node = mSvcProjectData.GetSurveyList(2)    '2 = All
        Dim reader As XmlTextReader = New XmlTextReader(node.OuterXml, XmlNodeType.Element, Nothing)
        ds.ReadXml(reader)

        'Need to create new table and add all the rows to it becaue the "id" field comes
        ' back as a string and we need to convert it to an integer.
        Dim dt As New DataTable
        dt.Columns.Add("id", System.Type.GetType("System.Int32"))
        dt.Columns.Add("Name", System.Type.GetType("System.String"))
        Dim newrow As DataRow

        For Each row As DataRow In ds.Tables(0).Rows
            newrow = dt.NewRow()
            newrow("id") = CInt(row("id"))
            newrow("Name") = row("Name")
            dt.Rows.Add(newrow)
        Next

        Dim dv As New DataView(dt)
        dv.RowFilter = filter

        Return dv

    End Function

    ''' <summary>
    ''' Adds a participant to an existing Vovici survey.
    ''' </summary>
    ''' <param name="projectID">The Vovici survey ID</param>
    ''' <param name="eMail">The participant's e-mail address</param>
    ''' <param name="userKey1">A key to allow the same person to be invited multiple times; pass null if not used.</param>
    ''' <param name="userKey2">A key to allow the same person to be invited multiple times; pass null if not used.</param>
    ''' <param name="userKey3">A key to allow the same person to be invited multiple times; pass null if not used.</param>
    ''' <param name="culture">The culture to be set for this participant, e.g. en-US.</param>
    ''' <returns>The Vovici record ID {participantId} for the newly added participant</returns>
    ''' <remarks></remarks>
    Public Function AddParticipantToSurvey(ByVal projectID As Integer, ByVal eMail As String, ByVal userKey1 As String, ByVal userKey2 As String, ByVal userKey3 As String, ByVal culture As String) As Long

        Return mSvcProjectData.AuthorizeParticipantForSurvey(projectID, eMail, userKey1, userKey2, userKey3, culture)

    End Function

    ''' <summary>
    ''' Adds the personalization information for the participant into the Vovici survey's hidden questions.
    ''' Vovici surveys need to match this template for the information to populate correctly.
    ''' </summary>
    ''' <param name="projectID">The Vovici survey ID</param>
    ''' <param name="participantID">The Vovici participant's ID</param>
    ''' <param name="participantData">Class containing personalization data for the participant</param>
    ''' <remarks></remarks>
    Public Sub AddHiddenQuestionDataToSurveyForParticipant(ByVal projectID As Integer, ByVal participantID As Long, ByVal participantData As VendorWebFile_Data, ByVal supressPiiFromVovici As Boolean)

        Dim sb As New Text.StringBuilder
        Dim settings As New XmlWriterSettings
        settings.OmitXmlDeclaration = True

        Dim writer As XmlWriter = XmlWriter.Create(sb, settings)
        With writer
            .WriteStartElement("Rows")
            .WriteStartElement("Row")
            .WriteAttributeString("id", participantID.ToString)

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q1_1")
            .WriteAttributeString("type", "Varchar")
            .WriteValue(participantData.WAC)
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q2_1")
            .WriteAttributeString("type", "Varchar")
            .WriteValue(participantData.Litho)
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q3_1")
            .WriteAttributeString("type", "Varchar")
            If supressPiiFromVovici Then
                .WriteValue("FirstName")
            Else
                .WriteValue(participantData.FName)
            End If
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q3_2")
            .WriteAttributeString("type", "Varchar")
            If supressPiiFromVovici Then
                .WriteValue("LastName")
            Else
                .WriteValue(participantData.LName)
            End If
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q4_1")
            .WriteAttributeString("type", "Varchar")
            If supressPiiFromVovici Then
                Dim toEmail As String = AppConfig.Params("QSIVoviciCanadaSurveyEmailAddress").StringValue
                .WriteValue(toEmail)
            Else
                .WriteValue(participantData.EmailAddr)
            End If
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q5_1")
            .WriteAttributeString("type", "Varchar")
            If participantData.WbServDate.HasValue Then
                .WriteValue(CDate(participantData.WbServDate).ToShortDateString)
            Else
                .WriteValue(String.Empty)
            End If
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q6_1")
            .WriteAttributeString("type", "Varchar")
            .WriteValue(participantData.wbServInd1)
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q6_2")
            .WriteAttributeString("type", "Varchar")
            .WriteValue(participantData.wbServInd2)
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q6_3")
            .WriteAttributeString("type", "Varchar")
            .WriteValue(participantData.wbServInd3)
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q6_4")
            .WriteAttributeString("type", "Varchar")
            .WriteValue(participantData.wbServInd4)
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q6_5")
            .WriteAttributeString("type", "Varchar")
            .WriteValue(participantData.wbServInd5)
            .WriteEndElement()  'Field

            .WriteStartElement("Field")
            .WriteAttributeString("id", "Q6_6")
            .WriteAttributeString("type", "Varchar")
            .WriteValue(participantData.wbServInd6)
            .WriteEndElement()  'Field

            .WriteEndElement()  'Row
            .WriteEndElement()  'Rows
            .Flush()
            .Close()
        End With

        mSvcProjectData.SetPreloadData(projectID, sb.ToString)

    End Sub

    ''' <summary>
    ''' Gets the response for a survey.
    ''' </summary>
    ''' <param name="projectID">The Vovici survey ID</param>
    ''' <param name="dataMapXml">If not null, this must be XML specifying a DataMap; same format as returned by GetDataMap. This allows fields to be omitted or renamed, and allows replacing choice question numeric values with the labels defined in the questionnaire--or any other mapping the client desires.</param>
    ''' <param name="filterXml">XML specifying a set of Criterion objects used to filter the data.</param>
    ''' <param name="startTime">Return only data modified past this date; use null or DateTime.MinValue if there is no early cutoff.</param>
    ''' <param name="endTime">Return only data modified before this date; use null or DateTime.MaxValue if there is no late cutoff.</param>
    ''' <param name="completedOnly">If true, return completed responses only; otherwise, return all started responses.</param>
    ''' <returns>Returns a DataSet of responses (max 10000) filtered by time or a set of test criteria.</returns>
    ''' <remarks></remarks>
    Public Function GetSurveyData(ByVal projectID As Integer, ByVal dataMapXml As String, ByVal filterXml As String, ByVal startTime As Nullable(Of Date), ByVal endTime As Nullable(Of Date), ByVal completedOnly As Boolean) As DataSet

        Return mSvcProjectData.GetSurveyDataEx(projectID, dataMapXml, filterXml, startTime, endTime, completedOnly)

    End Function

    ''' <summary>
    ''' Get basic information about a project.
    ''' </summary>
    ''' <param name="projectID">The Vovici survey ID</param>
    ''' <returns>A XMLNode with the basic information about a project. (Name, Description, id, type, owner, publish, status, source)</returns>
    ''' <remarks></remarks>
    Public Function GetProjectInformation(ByVal projectID As Integer) As XmlNode

        Return mSvcProjectData.GetProjectInformation(projectID)

    End Function

    ''' <summary>
    ''' Returns a list of active Vovici surveys
    ''' </summary>
    ''' <param name="surveyNameFilter">Lets you apply a filter to the survey list. Pass empty string for no filter.</param>
    ''' <returns>A dataview of the active surveys</returns>
    ''' <remarks></remarks>
    Public Function GetActiveSurveyList(ByVal surveyNameFilter As String) As DataView

        Dim ds As New DataSet
        Dim reader As XmlTextReader

        Dim surveys As DataView = GetSurveyList(surveyNameFilter)

        For Each survey As DataRowView In surveys
            Dim node As XmlNode = GetProjectInformation(CInt(survey("id")))
            reader = New XmlTextReader(node.OuterXml, Xml.XmlNodeType.Element, Nothing)
            ds.ReadXml(reader)
        Next

        Dim dv As New DataView(ds.Tables(0))
        dv.RowFilter = "publish = 'Open'"

        Return dv

    End Function

    ''' <summary>
    ''' Returns a dataset containing information about the survey question setup
    ''' </summary>
    ''' <param name="projectID">The Vovici survey ID</param>
    ''' <returns>A dataset</returns>
    ''' <remarks></remarks>
    Public Function GetSurveyInformation(ByVal projectID As Integer) As DataSet

        Dim node As XmlNode
        Dim ds As New DataSet

        node = mSvcProjectData.GetSurveyInformation(projectID)
        Dim reader As XmlTextReader = New XmlTextReader(node.OuterXml, XmlNodeType.Element, Nothing)
        ds.ReadXml(reader)

        Return ds

    End Function

    ''' <summary>
    ''' Return the data map for a questionnaire that maps the choice values to their specified
    '''  report values. If report values are not defined, the map specifies raw data values.
    '''  If the survey is not yet published, no information will be returned.
    ''' </summary>
    ''' <param name="projectID">The Vovici survey ID</param>
    ''' <returns>A XMLNode with the report value data mapping for the survey.</returns>
    ''' <remarks></remarks>
    Public Function GetReportDataMap(ByVal projectID As Integer) As XmlNode

        Return mSvcProjectData.GetReportDataMap(projectID)

    End Function

    Public Shared Function VerintProjectDataInstances() As Dictionary(Of Integer, VoviciProjectData)
        Dim IdVerintUS As Integer = AppConfig.Params("QSIVerint-US-VendorID").IntegerValue
        Dim IdVerintCA As Integer = AppConfig.Params("QSIVerint-CA-VendorID").IntegerValue

        Dim projData As New Dictionary(Of Integer, VoviciProjectData)
        projData.Add(IdVerintUS, New VoviciProjectData(AppConfig.Params("VerintUserName-US").StringValue, AppConfig.Params("VerintPassword-US").StringValue, AppConfig.Params("VerintURL-US").StringValue))
        projData(IdVerintUS).Login()

        Dim Country As String = AppConfig.Params("Country").StringValue()
        If Country = "CA" Then
            projData.Add(IdVerintCA, New VoviciProjectData(AppConfig.Params("VerintUserName-CA").StringValue, AppConfig.Params("VerintPassword-CA").StringValue, AppConfig.Params("VerintURL-CA").StringValue))
            projData(IdVerintCA).Login()
        End If

        Return projData
    End Function
End Class
