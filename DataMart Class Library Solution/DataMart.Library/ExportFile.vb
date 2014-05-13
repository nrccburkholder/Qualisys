''' <summary>
''' The ExportFile class represents an actual file that has been created from an ExportSet
''' </summary>
''' <remarks></remarks>
Public Class ExportFile

#Region " Private Instance Fields "
    Private mId As Integer
    Private mRecordCount As Integer
    Private mCreatedDate As Date
    Private mCreatedEmployeeName As String
    Private mFilePath As String
    Private mTPSFilePath As String = String.Empty
    Private mSummaryFilePath As String = String.Empty
    Private mFilePartsCount As Integer
    Private mFileType As ExportFileType
    Private mIsScheduledExport As Boolean
    Private mIncludeOnlyReturns As Boolean
    Private mIncludeOnlyDirects As Boolean
    Private mCreatedSuccessfully As Boolean
    Private mErrorMessage As String
    Private mStackTrace As String
    Private mIsAwaitingNotification As Boolean
    Private mdatRejected As Date
    Private mdatSubmitted As Date
    Private mdatAccepted As Date
    Private mOverrideError As Boolean
    Private mOverrideErrorName As String = String.Empty
    Private mdatOverride As Date
    Private mIgnore As Boolean
    Private mExportSets As New Collection(Of ExportSet)
    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "

    ''' <summary>The ID of the ExportFile</summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            If mId <> value Then
                mId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The number of records that were written to the file</summary>
    Public Property RecordCount() As Integer
        Get
            Return mRecordCount
        End Get
        Set(ByVal value As Integer)
            If mRecordCount <> value Then
                mRecordCount = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The date that the file was created</summary>
    Public Property CreatedDate() As Date
        Get
            Return mCreatedDate
        End Get
        Set(ByVal value As Date)
            If mCreatedDate <> value Then
                mCreatedDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The name of the user who created the file</summary>
    Public Property CreatedEmployeeName() As String
        Get
            Return mCreatedEmployeeName
        End Get
        Set(ByVal value As String)
            If mCreatedEmployeeName <> value Then
                mCreatedEmployeeName = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The path where the file was initially stored</summary>
    Public Property FilePath() As String
        Get
            Return mFilePath
        End Get
        Set(ByVal value As String)
            If mFilePath <> value Then
                mFilePath = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property TPSFilePath() As String
        Get
            Return mTPSFilePath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTPSFilePath Then
                mTPSFilePath = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property SummaryFilePath() As String
        Get
            Return mSummaryFilePath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSummaryFilePath Then
                mSummaryFilePath = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>Type type of file that was written</summary>
    Public Property FileType() As ExportFileType
        Get
            Return mFileType
        End Get
        Set(ByVal value As ExportFileType)
            If mFileType <> value Then
                mFileType = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The number of parts that the file was broken into</summary>
    Public Property FilePartsCount() As Integer
        Get
            Return mFilePartsCount
        End Get
        Set(ByVal value As Integer)
            If mFilePartsCount <> value Then
                mFilePartsCount = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property IsScheduledExport() As Boolean
        Get
            Return mIsScheduledExport
        End Get
        Set(ByVal value As Boolean)
            mIsScheduledExport = value
        End Set
    End Property

    Public Property IncludeOnlyReturns() As Boolean
        Get
            Return mIncludeOnlyReturns
        End Get
        Set(ByVal value As Boolean)
            mIncludeOnlyReturns = value
        End Set
    End Property

    Public Property IncludeOnlyDirects() As Boolean
        Get
            Return mIncludeOnlyDirects
        End Get
        Set(ByVal value As Boolean)
            mIncludeOnlyDirects = value
        End Set
    End Property

    Public Property CreatedSuccessfully() As Boolean
        Get
            Return mCreatedSuccessfully
        End Get
        Set(ByVal value As Boolean)
            mCreatedSuccessfully = value
        End Set
    End Property

    Public Property ErrorMessage() As String
        Get
            Return mErrorMessage
        End Get
        Set(ByVal value As String)
            mErrorMessage = value
        End Set
    End Property

    Public Property StackTrace() As String
        Get
            Return mStackTrace
        End Get
        Set(ByVal value As String)
            mStackTrace = value
        End Set
    End Property

    Public Property IsAwaitingNotification() As Boolean
        Get
            Return mIsAwaitingNotification
        End Get
        Set(ByVal value As Boolean)
            If mIsAwaitingNotification <> value Then
                mIsAwaitingNotification = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property datRejected() As Date
        Get
            Return mdatRejected
        End Get
        Set(ByVal value As Date)
            If Not value = mdatRejected Then
                mdatRejected = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property datSubmitted() As Date
        Get
            Return mdatSubmitted
        End Get
        Set(ByVal value As Date)
            If Not value = mdatSubmitted Then
                mdatSubmitted = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property datAccepted() As Date
        Get
            Return mdatAccepted
        End Get
        Set(ByVal value As Date)
            If Not value = mdatAccepted Then
                mdatAccepted = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property OverrideError() As Boolean
        Get
            Return mOverrideError
        End Get
        Set(ByVal value As Boolean)
            If Not value = mOverrideError Then
                mOverrideError = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property OverrideErrorName() As String
        Get
            Return mOverrideErrorName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mOverrideErrorName Then
                mOverrideErrorName = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property datOverride() As Date
        Get
            Return mdatOverride
        End Get
        Set(ByVal value As Date)
            If Not value = mdatOverride Then
                mdatOverride = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property Ignore() As Boolean
        Get
            Return mIgnore
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIgnore Then
                mIgnore = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public ReadOnly Property ExportSets() As Collection(Of ExportSet)
        Get
            Return mExportSets
        End Get
    End Property

#End Region

#Region " Public Methods "

    ''' <summary>
    ''' Creates an export file for the specified ExportSet
    ''' </summary>
    ''' <param name="export">The ExportSet object being used to define the export file</param>
    ''' <param name="filePath">The path of the file to create</param>
    ''' <param name="fileType">The type of file to create</param>
    ''' <param name="includeOnlyReturns">If True, indicates that only returned records will be included, otherwise all records will be included</param>
    ''' <param name="includeOnlyDirects">If True, indicates that only direct sample unit records will be included, 
    ''' otherwise records for all units will be included.</param>
    ''' <param name="createdEmployeeName">The name of the user who created the file</param>
    Public Shared Function CreateExportFile(ByVal export As ExportSet, ByVal filePath As String, ByVal fileType As ExportFileType, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFields As Boolean, ByVal createdEmployeeName As String, ByVal isScheduledExport As Boolean) As Integer
        'Create a collection of ExportSets just because our overloaded method expects a collection
        Dim exports As New Collection(Of ExportSet)
        exports.Add(export)

        'Call the overload that handles collections
        Return CreateExportFile(exports, filePath, fileType, includeOnlyReturns, includeOnlyDirects, includePhoneFields, createdEmployeeName, isScheduledExport)
    End Function

    ''' <summary>
    ''' Creates an export file that combines the data for all the specified ExportSets
    ''' </summary>
    ''' <param name="exportSets">The collection of ExportSet objects used to define the export file</param>
    ''' <param name="filePath">The path of the file to create</param>
    ''' <param name="fileType">The type of file to create</param>
    ''' <param name="includeOnlyReturns">If True, indicates that only returned records will be included, otherwise all records will be included</param>
    ''' <param name="includeOnlyDirects">If True, indicates that only direct sample unit records will be included, 
    ''' otherwise records for all units will be included.</param>
    ''' <param name="createdEmployeeName">The name of the user who created the file</param>
    Public Shared Function CreateExportFile(ByVal exportSets As Collection(Of ExportSet), ByVal filePath As String, ByVal fileType As ExportFileType, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFields As Boolean, ByVal createdEmployeeName As String, ByVal isScheduledExport As Boolean) As Integer
        If Not exportSets.Count > 0 Then
            Throw New ArgumentException("The collection of ExportSet objects must contain at least one ExportSet")
        End If
        Dim exportType As ExportSetType = exportSets(0).ExportSetType
        For Each export As ExportSet In exportSets
            If export.ExportSetType <> exportType Then
                Throw New InvalidOperationException("All of the ExportSet objects in the collection must be of the same ExportSetType")
            End If
        Next

        Dim exp As Exporter = Exporter.GetExporter(exportType)
        Return exp.CreateExportFile(exportSets, filePath, fileType, includeOnlyReturns, includeOnlyDirects, includePhoneFields, createdEmployeeName, isScheduledExport)
    End Function

    Public Shared Function CreateCMSExportFile(ByVal exportSets As System.Collections.ObjectModel.Collection(Of ExportSet), _
                                          ByVal folderPath As String, ByVal fileExtension As String, ByVal fileType As ExportFileType, _
                                          ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFields As Boolean, _
                                          ByVal createdEmployeeName As String, ByVal isScheduledExport As Boolean) As Integer
        If Not exportSets.Count > 0 Then
            Throw New ArgumentException("The collection of ExportSet objects must contain at least one ExportSet")
        End If
        Dim exportType As ExportSetType = exportSets(0).ExportSetType
        For Each export As ExportSet In exportSets
            If export.ExportSetType <> exportType Then
                Throw New InvalidOperationException("All of the ExportSet objects in the collection must be of the same ExportSetType")
            End If
        Next

        Dim exp As CAHPSExporter = CAHPSExporter.GetExporter(exportType)
        Return exp.CreateExportFile(exportSets, folderPath, fileExtension, fileType, includeOnlyReturns, includeOnlyDirects, includePhoneFields, createdEmployeeName, isScheduledExport)
    End Function

    Public Shared Function CreateCMSExportFile(ByVal medicareExportSets As System.Collections.ObjectModel.Collection(Of MedicareExportSet), _
                                               ByVal folderPath As String, ByVal fileExtension As String, ByVal fileType As ExportFileType, _
                                               ByVal isScheduledExport As Boolean) As Integer

        If Not medicareExportSets.Count > 0 Then
            Throw New ArgumentException("The collection of MedicareExportSets objects must contain at least one MedicareExportSet")
        End If

        Dim exportType As Integer = medicareExportSets(0).ExportSetTypeID
        For Each export As MedicareExportSet In medicareExportSets
            If export.ExportSetTypeID <> exportType Then
                Throw New InvalidOperationException("All of the MedicareExportSet objects in the collection must be of the same ExportSetType")
            End If
        Next

        Dim exp As CAHPSExporter = CAHPSExporter.GetExporter(CType(exportType, ExportSetType))
        Return exp.CreateExportFile(medicareExportSets, folderPath, fileExtension, fileType, isScheduledExport)

    End Function

    Public Shared Function CreateOCSExportFile(ByVal ocsMedicareExportSet As MedicareExportSet, _
                                               ByVal medicareExportSets As System.Collections.ObjectModel.Collection(Of MedicareExportSet), _
                                               ByVal folderPath As String, ByVal fileExtension As String, ByVal fileType As ExportFileType, _
                                               ByVal isScheduledExport As Boolean) As Integer

        If ocsMedicareExportSet Is Nothing Then
            Throw New ArgumentException("The object of OCSMedicareExportSet must contain a value. Medicare export set not built")
        End If

        If Not medicareExportSets.Count > 0 Then
            Throw New ArgumentException("The collection of MedicareExportSets objects empty. No existing MedicareExportSets found to create the file")
        End If

        Dim exportType As Integer = ocsMedicareExportSet.ExportSetTypeID
        If CType(exportType, ExportSetType) <> ExportSetType.OCSClient AndAlso CType(exportType, ExportSetType) <> ExportSetType.OCSNonClient Then
            Throw New ArgumentException("CreateOCSExportFile can only be used for OCS export types of OCSClient and OCSNonClient")
        End If

        If fileType <> ExportFileType.Xml Then
            Throw New ArgumentException("FileType must be xml")
        End If

        Dim exp As CAHPSExporter = CAHPSExporter.GetExporter(CType(exportType, ExportSetType))
        Return exp.CreateExportFile(ocsMedicareExportSet, medicareExportSets, folderPath, fileExtension, fileType, isScheduledExport)

    End Function

    ''' <summary>Marks the object as being up-to-date with the data store</summary>
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub

    Public Sub Update()
        DataProvider.Instance.UpdateExportFile(Me)
    End Sub

    Public Shared Sub GenerateExportNotificationEmail(ByVal toAddresses() As System.Net.Mail.MailAddress, ByVal smtpServer As System.Net.Mail.SmtpClient)
        If toAddresses Is Nothing OrElse toAddresses.Length = 0 Then
            Throw New ArgumentNullException("toAddresses")
        End If
        If smtpServer Is Nothing Then
            Throw New ArgumentNullException("smptServer")
        End If

        Dim files As Collection(Of ExportFile) = DataProvider.Instance.SelectExportFilesAwaitingNotification
        Dim pendingFiles As Collection(Of ScheduledExport) = DataProvider.Instance.SelectAllScheduledExports(Date.Today, Date.Today)

        Dim html As String = GetNotificationHtml(files, pendingFiles)
        Dim mail As New System.Net.Mail.MailMessage
        mail.From = New System.Net.Mail.MailAddress("ExportService@NationalResearch.com", "Export Service")
        For Each addr As System.Net.Mail.MailAddress In toAddresses
            mail.To.Add(addr)
        Next
        mail.Subject = "Scheduled Export Summary"

        'Add environment name to subject line, if not production environment.
        If Not Config.EnvironmentName.ToUpper.Trim = "PRODUCTION" Then
            mail.Subject += " (" & Config.EnvironmentName & ")"
        End If

        mail.IsBodyHtml = True
        mail.Body = html

        smtpServer.Send(mail)

        'Mark all the files as not needing notification
        For Each file As ExportFile In files
            file.IsAwaitingNotification = False
            file.Update()
        Next
    End Sub

#End Region

#Region " Private Methods "

#Region " Get Notification Html "
    Private Shared Function GetNotificationHtml(ByVal files As Collection(Of ExportFile), ByVal pendingFiles As Collection(Of ScheduledExport)) As String
        Dim html As New System.Text.StringBuilder
        Dim successFiles As New List(Of ExportFile)
        Dim failureFiles As New List(Of ExportFile)
        Dim clientCache As New Dictionary(Of Integer, Client)
        Dim studyCache As New Dictionary(Of Integer, Study)
        Dim surveyCache As New Dictionary(Of Integer, Survey)
        Dim unitCache As New Dictionary(Of Integer, SampleUnit)
        Dim clnt As Client
        Dim stdy As Study
        Dim srvy As Survey
        Dim unit As SampleUnit


        'Separate the successful and failed files
        For Each file As ExportFile In files
            If file.CreatedSuccessfully Then
                successFiles.Add(file)
            Else
                failureFiles.Add(file)
            End If
        Next

        'Begin the HTML output
        html.AppendLine("<html>")
        html.AppendLine("<head>")
        html.AppendLine("<STYLE>.NotifyTable {FONT-SIZE: x-small; FONT-FAMILY: Tahoma, Verdana, Arial; BACKGROUND-COLOR: White;}")
        html.AppendLine(".HeaderCell {PADDING: 2px; FONT-WEIGHT: bold; FONT-SIZE: x-small; COLOR: #ffffff; TEXT-ALIGN: center; BACKGROUND-COLOR: #033791; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        html.AppendLine(".DataCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: #AFC8F5; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        html.AppendLine(".InnerCell {PADDING-RIGHT: 5px; PADDING-LEFT: 35px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; BACKGROUND-COLOR: #CDE1FA; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        html.AppendLine(".InnerHeaderCell {COLOR: DimGray; PADDING: 2px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: #AFC8F5; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        html.AppendLine(".SpacerCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: #FFFFFF; HEIGHT: 12px;}")
        html.AppendLine("</STYLE>")
        html.AppendLine("</head>")
        'html.AppendLine("<h2>Export File Creation Summary</h2>")
        html.AppendLine("<div style=""font-size: x-large;"">Export File Creation Summary</div>")
        'html.AppendLine("<br />")
        html.AppendLine("<div style=""font-size: x-small;""><i>" & Date.Now.ToString & "<i></div>")
        html.AppendLine("<hr />")

        '--------------------------------------Failed Files------------------------------------------'
        html.AppendLine("<strong><i>Files <font color='Red'>NOT</font> created successfully</i></strong>")
        '---------------------------------------------------------------------------------------------

        If failureFiles.Count > 0 Then
            html.AppendLine("<table border=""0"" class=""NotifyTable"" cellSpacing=""0"" cellPadding=""0"" width=""100%"">")

            'Header row
            html.AppendLine("<tr>")
            html.AppendLine("<td class=""HeaderCell"">Date</td>")
            html.AppendLine("<td class=""HeaderCell"">File Type</td>")
            html.AppendLine("<td class=""HeaderCell"">Records</td>")
            html.AppendLine("<td class=""HeaderCell"">Returns Only</td>")
            html.AppendLine("<td class=""HeaderCell"">Directs Only</td>")
            html.AppendLine("<td class=""HeaderCell"">Error Message</td>")
            html.AppendLine("</tr>")

            For Each file As ExportFile In failureFiles
                'Data row
                html.AppendLine("<tr>")
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.CreatedDate.ToString)
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.FileType.ToString)
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.RecordCount)
                html.AppendFormat("<td class=""DataCell"">{0}</td>", IIf(file.IncludeOnlyReturns, "Yes", "No"))
                html.AppendFormat("<td class=""DataCell"">{0}</td>", IIf(file.IncludeOnlyDirects, "Yes", "No"))
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.ErrorMessage)
                html.AppendLine("</tr>")

                'Inner table row
                html.AppendLine("<tr>")
                html.AppendLine("<td class=""InnerCell"" colspan=""6"">")
                html.AppendLine("<table class=""NotifyTable"" border=""0"" cellSpacing=""0"" cellPadding=""0"">")
                html.AppendLine("<tr>")
                html.AppendLine("<td class=""InnerHeaderCell"">Client</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Study</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Survey</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Sample Unit</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Name</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Encounter Start</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Encounter End</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Export Type</td>")
                html.AppendLine("</tr>")

                For Each export As ExportSet In file.ExportSets
                    'Get the client,study,survey,unit objects as needed
                    If Not surveyCache.ContainsKey(export.SurveyId) Then
                        surveyCache.Add(export.SurveyId, Survey.GetSurvey(export.SurveyId))
                    End If
                    srvy = surveyCache(export.SurveyId)
                    If Not studyCache.ContainsKey(srvy.StudyId) Then
                        studyCache.Add(srvy.StudyId, Study.GetStudy(srvy.StudyId))
                    End If
                    stdy = studyCache(srvy.StudyId)
                    If Not clientCache.ContainsKey(stdy.ClientId) Then
                        clientCache.Add(stdy.ClientId, Client.GetClient(stdy.ClientId))
                    End If
                    clnt = clientCache(stdy.ClientId)
                    If export.SampleUnitId = 0 Then
                        unit = Nothing
                    Else
                        If Not unitCache.ContainsKey(export.SampleUnitId) Then
                            unitCache.Add(export.SampleUnitId, SampleUnit.Get(export.SampleUnitId))
                        End If
                        unit = unitCache(export.SampleUnitId)
                    End If

                    html.AppendLine("<tr>")
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", clnt.DisplayLabel)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", stdy.DisplayLabel)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", srvy.DisplayLabel)
                    If unit Is Nothing Then
                        html.AppendFormat("<td class=""DataCell"">{0}</td>", "All")
                    Else
                        html.AppendFormat("<td class=""DataCell"">{0}</td>", unit.DisplayLabel)
                    End If
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.Name)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.StartDate.ToString)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.EndDate.ToString)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.ExportSetType.ToString)
                    html.AppendLine("</tr>")
                Next
                html.AppendLine("</table>")
                html.AppendLine("</td>")
                html.AppendLine("</tr>")

                html.AppendLine("<tr><td class=""SpacerCell"" colspan=""6""></td></tr>")
            Next
            html.AppendLine("</table>")
        Else
            html.AppendLine("<br />No files were unsuccessful.")
        End If

        html.AppendLine("<hr />")
        '--------------------------------------Successful Files------------------------------------------'
        html.AppendLine("<strong><i>Files created successfully</i></strong>")
        '---------------------------------------------------------------------------------------------
        If successFiles.Count > 0 Then

            html.AppendLine("<table border=""0"" class=""NotifyTable"" cellSpacing=""0"" cellPadding=""0"" width=""100%"">")

            'Header row
            html.AppendLine("<tr>")
            html.AppendLine("<td class=""HeaderCell"">Date</td>")
            html.AppendLine("<td class=""HeaderCell"">File Path</td>")
            html.AppendLine("<td class=""HeaderCell"">File Type</td>")
            html.AppendLine("<td class=""HeaderCell"">Records</td>")
            html.AppendLine("<td class=""HeaderCell"">Returns Only</td>")
            html.AppendLine("<td class=""HeaderCell"">Directs Only</td>")
            html.AppendLine("</tr>")

            For Each file As ExportFile In successFiles
                'Data row
                html.AppendLine("<tr>")
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.CreatedDate.ToString)
                html.AppendFormat("<td class=""DataCell""><a href=""file://{0}"">{1}</a></td>", IO.Path.GetDirectoryName(file.FilePath), file.FilePath.Substring(file.FilePath.LastIndexOf("\") + 1))
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.FileType.ToString)
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.RecordCount)
                html.AppendFormat("<td class=""DataCell"">{0}</td>", IIf(file.IncludeOnlyReturns, "Yes", "No"))
                html.AppendFormat("<td class=""DataCell"">{0}</td>", IIf(file.IncludeOnlyDirects, "Yes", "No"))
                html.AppendLine("</tr>")

                'Inner table row
                html.AppendLine("<tr>")
                html.AppendLine("<td class=""InnerCell"" colspan=""6"">")
                html.AppendLine("<table class=""NotifyTable"" border=""0"" cellSpacing=""0"" cellPadding=""0"">")
                html.AppendLine("<tr>")
                html.AppendLine("<td class=""InnerHeaderCell"">Client</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Study</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Survey</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Sample Unit</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Name</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Encounter Start</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Encounter End</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Export Type</td>")
                html.AppendLine("</tr>")
                For Each export As ExportSet In file.ExportSets
                    'Get the client,study,survey,unit objects as needed
                    If Not surveyCache.ContainsKey(export.SurveyId) Then
                        surveyCache.Add(export.SurveyId, Survey.GetSurvey(export.SurveyId))
                    End If
                    srvy = surveyCache(export.SurveyId)
                    If Not studyCache.ContainsKey(srvy.StudyId) Then
                        studyCache.Add(srvy.StudyId, Study.GetStudy(srvy.StudyId))
                    End If
                    stdy = studyCache(srvy.StudyId)
                    If Not clientCache.ContainsKey(stdy.ClientId) Then
                        clientCache.Add(stdy.ClientId, Client.GetClient(stdy.ClientId))
                    End If
                    clnt = clientCache(stdy.ClientId)
                    If export.SampleUnitId = 0 Then
                        unit = Nothing
                    Else
                        If Not unitCache.ContainsKey(export.SampleUnitId) Then
                            unitCache.Add(export.SampleUnitId, SampleUnit.Get(export.SampleUnitId))
                        End If
                        unit = unitCache(export.SampleUnitId)
                    End If

                    html.AppendLine("<tr>")
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", clnt.DisplayLabel)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", stdy.DisplayLabel)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", srvy.DisplayLabel)
                    If unit Is Nothing Then
                        html.AppendFormat("<td class=""DataCell"">{0}</td>", "All")
                    Else
                        html.AppendFormat("<td class=""DataCell"">{0}</td>", unit.DisplayLabel)
                    End If
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.Name)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.StartDate.ToString)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.EndDate.ToString)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.ExportSetType.ToString)
                    html.AppendLine("</tr>")
                Next
                html.AppendLine("</table>")
                html.AppendLine("</td>")
                html.AppendLine("</tr>")

                html.AppendLine("<tr><td class=""SpacerCell"" colspan=""6""></td></tr>")
            Next
            html.AppendLine("</table>")
        Else
            html.AppendLine("<br />No new files were created successfully.")
        End If

        html.AppendLine("<hr />")

        '--------------------------------------Pending Files------------------------------------------'
        html.AppendLine("<strong><i>Files still scheduled for creation today</i></strong>")
        '---------------------------------------------------------------------------------------------
        If pendingFiles.Count > 0 Then

            html.AppendLine("<table border=""0"" class=""NotifyTable"" cellSpacing=""0"" cellPadding=""0"" width=""100%"">")

            'Header row
            html.AppendLine("<tr>")
            html.AppendLine("<td class=""HeaderCell"">Run Date</td>")
            html.AppendLine("<td class=""HeaderCell"">File Type</td>")
            html.AppendLine("<td class=""HeaderCell"">Returns Only</td>")
            html.AppendLine("<td class=""HeaderCell"">Directs Only</td>")
            html.AppendLine("</tr>")

            For Each file As ScheduledExport In pendingFiles
                'Data row
                html.AppendLine("<tr>")
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.RunDate.ToString)
                html.AppendFormat("<td class=""DataCell"">{0}</td>", file.ExportFileType.ToString)
                html.AppendFormat("<td class=""DataCell"">{0}</td>", IIf(file.IncludeOnlyReturns, "Yes", "No"))
                html.AppendFormat("<td class=""DataCell"">{0}</td>", IIf(file.IncludeOnlyDirects, "Yes", "No"))
                html.AppendLine("</tr>")

                'Inner table row
                html.AppendLine("<tr>")
                html.AppendLine("<td class=""InnerCell"" colspan=""4"">")
                html.AppendLine("<table class=""NotifyTable"" border=""0"" cellSpacing=""0"" cellPadding=""0"">")
                html.AppendLine("<tr>")
                html.AppendLine("<td class=""InnerHeaderCell"">Client</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Study</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Survey</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Sample Unit</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Name</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Encounter Start</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Encounter End</td>")
                html.AppendLine("<td class=""InnerHeaderCell"">Export Type</td>")
                html.AppendLine("</tr>")
                For Each export As ExportSet In file.ExportSets
                    'Get the client,study,survey,unit objects as needed
                    If Not surveyCache.ContainsKey(export.SurveyId) Then
                        surveyCache.Add(export.SurveyId, Survey.GetSurvey(export.SurveyId))
                    End If
                    srvy = surveyCache(export.SurveyId)
                    If Not studyCache.ContainsKey(srvy.StudyId) Then
                        studyCache.Add(srvy.StudyId, Study.GetStudy(srvy.StudyId))
                    End If
                    stdy = studyCache(srvy.StudyId)
                    If Not clientCache.ContainsKey(stdy.ClientId) Then
                        clientCache.Add(stdy.ClientId, Client.GetClient(stdy.ClientId))
                    End If
                    clnt = clientCache(stdy.ClientId)
                    If export.SampleUnitId = 0 Then
                        unit = Nothing
                    Else
                        If Not unitCache.ContainsKey(export.SampleUnitId) Then
                            unitCache.Add(export.SampleUnitId, SampleUnit.Get(export.SampleUnitId))
                        End If
                        unit = unitCache(export.SampleUnitId)
                    End If

                    html.AppendLine("<tr>")
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", clnt.DisplayLabel)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", stdy.DisplayLabel)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", srvy.DisplayLabel)
                    If unit Is Nothing Then
                        html.AppendFormat("<td class=""DataCell"">{0}</td>", "All")
                    Else
                        html.AppendFormat("<td class=""DataCell"">{0}</td>", unit.DisplayLabel)
                    End If
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.Name)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.StartDate.ToString)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.EndDate.ToString)
                    html.AppendFormat("<td class=""DataCell"">{0}</td>", export.ExportSetType.ToString)
                    html.AppendLine("</tr>")
                Next
                html.AppendLine("</table>")
                html.AppendLine("</td>")
                html.AppendLine("</tr>")

                html.AppendLine("<tr><td class=""SpacerCell"" colspan=""4""></td></tr>")
            Next
            html.AppendLine("</table>")
        Else
            html.AppendLine("<br />There are no remaining files scheduled to be created today.")
        End If

        html.AppendLine("</html>")
        Return html.ToString
    End Function
#End Region


#End Region

    '''' <summary>
    '''' Returns all the ExportSet objects that were combined into the ExportFile
    '''' </summary>
    Public Function GetExportSets() As Collection(Of ExportSet)
        Return DataProvider.Instance.SelectExportSetsByExportFileId(mId)
    End Function

End Class
