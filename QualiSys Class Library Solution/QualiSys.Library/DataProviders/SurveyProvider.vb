Namespace DataProvider

    Public MustInherit Class SurveyProvider

#Region " Singleton Implementation "

        Private Shared mInstance As SurveyProvider
        Private Const mProviderName As String = "SurveyProvider"

        Public Shared ReadOnly Property Instance() As SurveyProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SurveyProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

#Region " Constructors "

        Protected Sub New()

        End Sub

#End Region

#Region " Public MustOverride Methods "

        Public MustOverride Function [Select](ByVal surveyId As Integer) As Survey
        Public MustOverride Function SelectByStudy(ByVal study As Study) As Collection(Of Survey)
        Public MustOverride Function SelectBySurveyTypeMailOnly(ByVal srvyType As SurveyType) As Collection(Of Survey)
        Public MustOverride Function SelectSurveyTypes() As List(Of ListItem(Of SurveyTypes))
        Public MustOverride Function SelectCAHPSTypes(ByVal surveyType As Integer) As List(Of ListItem(Of CAHPSType))
        Public MustOverride Function SelectSamplingAlgorithms() As List(Of ListItem(Of SamplingAlgorithm))
        Public MustOverride Function SelectResurveyMethod() As List(Of ListItem(Of ResurveyMethod))
        Public MustOverride Function IsSurveySampled(ByVal surveyId As Integer) As Boolean
        Public MustOverride Sub Update(ByVal survey As Survey)
        Public MustOverride Function Insert(ByVal studyId As Integer,
                                            ByVal name As String,
                                            ByVal description As String,
                                            ByVal responseRateRecalculationPeriod As Integer,
                                            ByVal resurveyMethodId As ResurveyMethod,
                                            ByVal resurveyPeriod As Integer,
                                            ByVal surveyStartDate As Date,
                                            ByVal surveyEndDate As Date,
                                            ByVal samplingAlgorithmId As Integer,
                                            ByVal enforceSkip As Boolean,
                                            ByVal cutoffResponseCode As String,
                                            ByVal cutoffTableId As Integer,
                                            ByVal cutoffFieldId As Integer,
                                            ByVal SampleEncounterField As StudyTableColumn,
                                            ByVal clientFacingName As String,
                                            ByVal surveyTypeId As Integer,
                                            ByVal surveyTypeDefId As Integer,
                                            ByVal houseHoldingType As HouseHoldingType,
                                            ByVal contractNumber As String,
                                            ByVal isActive As Boolean,
                                            ByVal contractedLanguages As String,
                                            ByVal surveysubtypes As SubTypeList,
                                            ByVal questionnairesubtype As SubType,
                                            ByVal resurveyExclustionSubtype As SubType,
                                            ByVal UseUSPSAddrChangeService As Boolean,
                                            ByVal isHandout As Boolean,
                                            ByVal isPointInTime As Boolean
                                           ) As Survey
        Public MustOverride Sub Delete(ByVal surveyId As Integer)
        Public MustOverride Function AllowDelete(ByVal surveyId As Integer) As Boolean
        Public MustOverride Function PerformSurveyValidation(ByVal surveyId As Integer) As SurveyValidationResult
        Public MustOverride Function SelectSubTypes(ByVal surveytypeid As Integer, ByVal categorytype_id As SubtypeCategories, ByVal survey_id As Integer) As SubTypeList
        Public MustOverride Function HasFacilityMapping(ByVal surveyId As Integer) As Boolean

#End Region

#Region " ReadOnlyAccessor "

        Protected NotInheritable Class ReadOnlyAccessor

            Private Sub New()

            End Sub

            Public Shared WriteOnly Property SurveyId(ByVal obj As Survey) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

        End Class

#End Region

    End Class

End Namespace
