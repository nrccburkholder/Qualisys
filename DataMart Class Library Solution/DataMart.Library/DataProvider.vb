Imports Nrc.Framework.Data

''' <summary>
''' The DataProvider class defines an interface for persisting or retreiving DataMart.Library objects to or from a data store
''' </summary>
''' <remarks>This class is Abstract so that a more specialized class can implement the functionality needed for a specific type of data store</remarks>
Public MustInherit Class DataProvider

    Protected Sub New()

    End Sub

    ''' <summary>Holds the default instance of the data provider</summary>
    Private Shared mInstance As DataProvider

    ''' <summary>
    ''' Returns a collection of provider names and their corresponding types for all the providers defined in the config file
    ''' </summary>
    Public Shared ReadOnly Property ProviderList() As Collections.Specialized.NameValueCollection
        Get
            'Get the name-value list of providers from the config file
            Return TryCast(System.Configuration.ConfigurationManager.GetSection("Providers"), Collections.Specialized.NameValueCollection)
        End Get
    End Property

    ''' <summary>
    ''' Returns the default instance of the DataProvider as defined by the .Config file
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared ReadOnly Property Instance() As DataProvider
        <DebuggerHidden()> Get
            'If the instance is already cached then just use in
            If mInstance Is Nothing Then
                'Get the fully qualified type name from the .Config file
                Dim typeName As String = Config.DataMartDataProvider
                'Create a new instance and cache it
                Dim t As Type = Type.GetType(typeName, True)
                mInstance = CType(Activator.CreateInstance(t), DataProvider)
            End If

            Return mInstance
        End Get
    End Property

#Region " ReadOnlyAccessors "

    <System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible")> _
    Protected NotInheritable Class ReadOnlyAccessor

        Private Sub New()

        End Sub

#Region " Client "

        Public Shared WriteOnly Property ClientId(ByVal obj As Client) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " ExportSet "

        Public Shared WriteOnly Property ExportSetId(ByVal obj As ExportSet) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

        Public Shared WriteOnly Property ExportSetCreationDate(ByVal obj As ExportSet) As Date
            Set(ByVal value As Date)
                If obj IsNot Nothing Then
                    obj.CreatedDate = value
                End If
            End Set
        End Property

        Public Shared WriteOnly Property ExportSetCreationEmployeeName(ByVal obj As ExportSet) As String
            Set(ByVal value As String)
                If obj IsNot Nothing Then
                    obj.CreatedEmployeeName = value
                End If
            End Set
        End Property

        Public Shared WriteOnly Property ExportSetType(ByVal obj As ExportSet) As ExportSetType
            Set(ByVal value As ExportSetType)
                If obj IsNot Nothing Then
                    obj.ExportSetType = value
                End If
            End Set
        End Property

#End Region

#Region " ExportFile "

        Public Shared WriteOnly Property ExportFileId(ByVal obj As ExportFile) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " Sample Unit "

        Public Shared WriteOnly Property SampleUnitId(ByVal obj As SampleUnit) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " Sample Set "

        Public Shared WriteOnly Property SampleSetId(ByVal obj As SampleSet) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

        Public Shared WriteOnly Property SampleSetCreationDate(ByVal obj As SampleSet) As Date
            Set(ByVal value As Date)
                If obj IsNot Nothing Then
                    obj.DateCreated = value
                End If
            End Set
        End Property

        Public Shared WriteOnly Property SampleSetSurveyId(ByVal obj As SampleSet) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.SurveyId = value
                End If
            End Set
        End Property

        Public Shared WriteOnly Property SampleSetSamplePlanId(ByVal obj As SampleSet) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.SamplePlanId = value
                End If
            End Set
        End Property

#End Region

#Region " Study "

        Public Shared WriteOnly Property StudyId(ByVal obj As Study) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " Survey "

        Public Shared WriteOnly Property SurveyId(ByVal obj As Survey) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " Question "

        Public Shared WriteOnly Property QuestionId(ByVal obj As Question) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " Scale "

        Public Shared WriteOnly Property ScaleId(ByVal obj As Scale) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " ScheduledExport "

        Public Shared WriteOnly Property ScheduledExportId(ByVal obj As ScheduledExport) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " Study Weights "

        Public Shared WriteOnly Property WeightCategoryId(ByVal obj As WeightType) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.Id = value
                End If
            End Set
        End Property

#End Region

#Region " Medicare Export Set Methods "
        Public Shared WriteOnly Property MedicareExportSetId(ByVal obj As MedicareExportSet) As Integer
            Set(ByVal value As Integer)
                If obj IsNot Nothing Then
                    obj.MedicareExportSetId = value
                End If
            End Set
        End Property
#End Region
    End Class

#End Region

#Region " Client Methods "

    Public MustOverride Function SelectClient(ByVal clientId As Integer) As Client
    Public MustOverride Function SelectClientsAndStudiesByUser(ByVal userName As String) As Collection(Of Client)
    Public MustOverride Function SelectClientsStudiesAndSurveysByUser(ByVal userName As String) As Collection(Of Client)

#End Region

#Region " ExportSet Methods "

    Public MustOverride Function SelectExportSet(ByVal exportSetId As Integer) As ExportSet
    Public MustOverride Function SelectExportSetsBySampleUnitId(ByVal sampleUnitId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
    Public MustOverride Function SelectExportSetsBySurveyId(ByVal surveyId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
    Public MustOverride Function SelectExportSetsByStudyId(ByVal studyId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
    Public MustOverride Function SelectExportSetsByClientId(ByVal clientId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
    Public MustOverride Function SelectExportSetsByExportFileId(ByVal exportFileId As Integer) As Collection(Of ExportSet)
    Public MustOverride Function InsertExportSet(ByVal name As String, ByVal surveyId As Integer, ByVal sampleUnitId As Integer, ByVal encounterStartDate As Date, ByVal encounterEndDate As Date, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As Integer
    Public MustOverride Function DeleteExportSet(ByVal exportSetId As Integer, ByVal deletedEmployeeName As String, ByRef errorMessage As String) As Boolean
    Public MustOverride Sub RebuildExportSet(ByVal exportSetId As Integer)

#End Region

#Region " ExportFile Methods "
    Public MustOverride Function SelectExportFileData(ByVal exportSetIds As Integer(), ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFields As Boolean, ByVal exportGuid As Guid, ByVal saveData As Boolean, ByVal returnData As Boolean) As IDataReader
    Public MustOverride Function SelectExportFilesByExportSetId(ByVal exportSetId As Integer) As Collection(Of ExportFile)
    Public MustOverride Function SelectExportFilesAwaitingNotification() As Collection(Of ExportFile)
    Public MustOverride Function InsertExportFile(ByVal recordCount As Integer, ByVal createdEmployeeName As String, ByVal filePath As String, ByVal filePartsCount As Integer, ByVal fileType As ExportFileType, ByVal exportGuid As Guid, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal isScheduledExport As Boolean, ByVal exportSucceeded As Boolean, ByVal errorMessage As String, ByVal errorStack As String, ByVal isAwaitingNotification As Boolean, ByVal tpsFilePath As String, ByVal summaryFilePath As String, ByVal exceptionFilePath As String, Optional ByVal ignore As Boolean = False) As Integer
    Public MustOverride Sub InsertExportFileExportSet(ByVal exportSetId As Integer, ByVal medicareExportSetId As Integer, ByVal exportFileId As Integer)
    Public MustOverride Sub InsertExportFileExportSet(ByVal exportSetId As Integer, ByVal exportFileId As Integer)
    Public MustOverride Sub UpdateExportFile(ByVal file As ExportFile)
    Public MustOverride Sub UpdateExportFileErrorMessage(ByVal id As Integer, ByVal errrorMessage As String)
    Public MustOverride Function SelectMedicareExportFileData(ByVal medicareExportSetId As Integer, ByVal saveData As Boolean, ByVal returnData As Boolean) As IDataReader
    'Public MustOverride Function SelectACOCAHPSExportFileData(ByVal SurveyId As Integer) As Collection(Of ACOCAHPSExport)
    Public MustOverride Function SelectOCSExportFileData(ByVal medicareExportFileGuid As Guid) As IDataReader

    Public Function InsertExportFile(ByVal recordCount As Integer, ByVal createdEmployeeName As String, ByVal filePath As String, ByVal filePartsCount As Integer, ByVal fileType As ExportFileType, ByVal exportGuid As Guid, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal isScheduledExport As Boolean, ByVal isAwaitingNotification As Boolean) As Integer

        Return InsertExportFile(recordCount, createdEmployeeName, filePath, filePartsCount, fileType, exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, True, "", "", isAwaitingNotification, "", "", "")

    End Function

#End Region

#Region " Study Methods "

    Public MustOverride Function SelectStudy(ByVal studyId As Integer) As Study

#End Region

#Region " Sample Unit Methods "

    Public MustOverride Function SelectHcahpsClientsByUser(ByVal userName As String, ByVal unitList As Collection(Of SampleUnit)) As Collection(Of Client)
    Public MustOverride Function SelectHHcahpsClientsByUser(ByVal userName As String, ByVal unitList As Collection(Of SampleUnit)) As Collection(Of Client)
    Public MustOverride Function SelectCHARTClientsByUser(ByVal userName As String, ByVal unitList As Collection(Of SampleUnit)) As Collection(Of Client)
    Public MustOverride Function SelectSampleUnit(ByVal sampleUnitId As Integer) As SampleUnit
    Public MustOverride Function SelectSampleUnitsByMedicareNumber(ByVal medicareNumber As String) As Collection(Of SampleUnit)

#End Region

#Region " Team Methods "

    Public MustOverride Function SelectTeams() As Collection(Of Team) 'Less Than 100

#End Region

#Region " Sample Set Methods "

    Public MustOverride Function SelectSampleSet(ByVal sampleSetId As Integer) As SampleSet

#End Region

#Region " Survey Methods "

    Public MustOverride Function SelectSurvey(ByVal surveyId As Integer) As Survey
    Public MustOverride Function SelectSurveysByStudyId(ByVal studyId As Integer) As Collection(Of Survey)

#End Region

#Region " Question Methods "

    Public MustOverride Function SelectQuestionsbySurveyId(ByVal surveyId As Integer) As Collection(Of Question)

#End Region

#Region " Scale Methods "

    Public MustOverride Function SelectScalebySurveyIdandScaleId(ByVal surveyId As Integer, ByVal scaleId As Integer) As Scale

#End Region

#Region " Response Methods "

    Public MustOverride Function SelectResponsesbySurveyIdandScaleId(ByVal surveyId As Integer, ByVal scaleId As Integer) As Collection(Of Response)

#End Region

#Region " Weights "

    Public MustOverride Function SelectWeightTypes() As Collection(Of WeightType)
    Public MustOverride Function SelectWeightType(ByVal weightTypeId As Integer) As WeightType
    Public MustOverride Sub UpdateWeightType(ByVal weightTypeId As Integer, ByVal weightTypeLabel As String, ByVal exportColumnName As String)
    Public MustOverride Sub DeleteWeightType(ByVal weightTypeId As Integer)
    Public MustOverride Function InsertWeightType(ByVal weightTypeLabel As String, ByVal exportColumnName As String) As Integer
    Public MustOverride Function InsertWeightValues(ByVal studyId As Integer, ByVal tempTableName As String, ByVal replace As Boolean, ByVal WeightTypeID As Integer, ByVal employeeName As String) As Collection(Of String)
    Public MustOverride Function CreateTemporaryWeightValuesTable(ByVal studyId As Integer) As String
    Public MustOverride Sub BulkLoadWeightValuesTable(ByVal rdr As IDataReader, ByVal samplePopIdColumnName As String, ByVal WeightColumnName As String, ByVal tempTableName As String)
    Public MustOverride Function IsWeightTypeDeletable(ByVal weightTypeId As Integer) As Boolean
#End Region

#Region " ScheduledExport Methods "
    Public MustOverride Function SelectAllScheduledExports(ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
    Public MustOverride Function SelectScheduledExport(ByVal scheduledExportId As Integer) As ScheduledExport
    Public MustOverride Function SelectScheduledExportsByClientId(ByVal clientId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
    Public MustOverride Function SelectScheduledExportsByStudyId(ByVal studyId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
    Public MustOverride Function SelectScheduledExportsBySurveyId(ByVal surveyId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
    Public MustOverride Function SelectNextScheduledExport() As ScheduledExport
    Public MustOverride Function InsertScheduledExport(ByVal runDate As DateTime, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFiles As Boolean, ByVal fileType As ExportFileType, ByVal fileName As String, ByVal userName As String) As Integer
    Public MustOverride Sub InsertScheduledExportSet(ByVal scheduledExportId As Integer, ByVal exportSetId As Integer)
    Public MustOverride Sub DeleteScheduledExport(ByVal scheduledExportId As Integer)
    Public MustOverride Sub UpdateScheduledExport(ByVal scheduledExportId As Integer, ByVal runDate As Date, ByVal fileName As String)

#End Region

#Region " Special Updates "

    Public MustOverride Function SpecialSurveyUpdate(ByVal studyId As Integer, ByVal surveyId As Integer, ByVal samplePopId As Integer, ByVal fieldName As String, ByVal fieldValue As String, ByVal yearQtr As String, ByRef errorMessage As String) As Boolean

#End Region

#Region "ORYX"
    Public MustOverride Function SelectOryxMeasurements(ByVal HCOID As Nullable(Of Int32)) As List(Of Int32)
    Public MustOverride Function SelectOryxMeasurements() As List(Of Int32)
    Public MustOverride Function SelectOryxQuestions(ByVal MeasurementID As Int32) As List(Of Int32)
    Public MustOverride Function SelectOryxAnswerMappings(ByVal QuestionID As Int32) As Dictionary(Of Int32, Nullable(Of Int32))
    Public MustOverride Function SelectOryxLastUsedFileNum() As Int32
    Public MustOverride Sub UpdateOryxLastUsedFileNum(ByVal ControlNum As Int32)
    Public MustOverride Function SelectParentSampleUnitIDsByOryxHCOID(ByVal HCOID As Int32) As Collection(Of Int32)
    Public MustOverride Function SelectClientIDByORYXHCO(ByVal HCOID As Int32) As Int32
    Public MustOverride Function SelectAllOryxClients() As Dictionary(Of Int32, String)
    Public MustOverride Function SelectAllNonOryxClients() As Dictionary(Of Int32, String)
    Public MustOverride Function AddOryxClient(ByVal HCOID As Int32, ByVal ClientID As Int32) As Boolean
    Public MustOverride Sub DeleteAllHCOMeasurements(ByVal HCOID As Int32)
    Public MustOverride Sub AddHCOMeasurement(ByVal HCOID As Int32, ByVal MeasurementID As Int32)
    Public MustOverride Sub AddMeasurement(ByVal MeasurementID As Int32)
    Public MustOverride Function SelectQuestionText(ByVal QstnCore As Int32) As List(Of String)
    Public MustOverride Function SelectScale(ByVal QstnCore As Int32) As DataTable
    Public MustOverride Sub UpdateAnswerMapping(ByVal QuestionID As Int32, ByVal NRCValue As Nullable(Of Int32), ByVal ORYXValue As Nullable(Of Int32))
    Public MustOverride Sub DeleteQuestionsByMeasure(ByVal MeasurementID As Int32)
    Public MustOverride Sub AddQuestionToMeasure(ByVal MeasurementID As Int32, ByVal QuestionID As Int32)
    Public MustOverride Function SelectClientIDByExportSetID(ByVal ExportSetID As Int32) As Int32
    Public MustOverride Function SelectORYXHCOByExportSet(ByVal ExportSetID As Int32) As Int32


#End Region

#Region " Medicare Export Methods "

    Public MustOverride Function SelectAllByDistinctMedicareNumber(ByVal exportSetType As ExportSetType, ByVal activeOnly As Boolean) As Collection(Of MedicareExport)
    Public MustOverride Function SelectAllByDistinctSampleUnit(ByVal exportSetType As ExportSetType) As Collection(Of MedicareExport)
    Public MustOverride Function SelectMedicareExport(ByVal medicareNumber As String) As MedicareExport

#End Region

#Region " Medicare Export Set Methods "

    Public MustOverride Function SelectMedicareExportSet(ByVal medicareExportSetId As Integer) As MedicareExportSet
    Public MustOverride Function InsertMedicareExportSet(ByVal medicarenumber As String, ByVal exportname As String, ByVal startDate As Date, ByVal endDate As Date, ByVal directsOnly As Boolean, ByVal returnsOnly As Boolean, ByVal exportGuid As Guid, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As Integer
    Public MustOverride Function SelectFileGUIDsByClientGroup(ByVal surveyType As SurveyType, ByVal clientGroupName As String, ByVal sign As String, ByVal startDate As Date, ByVal endDate As Date) As Collection(Of MedicareExportSet)
#End Region

#Region " ACOCAHPS Export Methods"

    Public MustOverride Function SelectAllACOCAHPSBySurveyID(ByVal survey_Id As Integer, ByVal startDate As DateTime, ByVal endDate As DateTime) As Collection(Of ACOCAHPSExport)

#End Region

#Region " ACOCAHPS Export Set Methods "

    'Public MustOverride Function SelectACOCAHPSExportSet(ByVal acoCAHPSId As Integer) As ACOCAHPSExportSet
    'Public MustOverride Function InsertACOCAHPSExportSet(ByVal surveyID As Integer, ByVal surveyName As String, ByVal clientName As String, ByVal exportname As String, ByVal startDate As Date, ByVal endDate As Date, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As Integer

#End Region

#Region " Export File View "
    Public MustOverride Function SelectExportFilesByExportSetType(ByVal exportSetType As ExportSetType, ByVal filterStartDate As Date, ByVal filterEndDate As Date) As Collection(Of ExportFileView)
    Public MustOverride Function SelectExportFilesByExportSetTypeAllDetails(ByVal exportSetType As ExportSetType, ByVal filterStartDate As Date, ByVal filterEndDate As Date) As Collection(Of ExportFileView)
    Public MustOverride Sub UpdateExportFileTracking(ByVal file As ExportFileView)

#End Region
End Class
