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
        Public MustOverride Function Insert(ByVal studyId As Integer, _
                                            ByVal name As String, _
                                            ByVal description As String, _
                                            ByVal responseRateRecalculationPeriod As Integer, _
                                            ByVal resurveyMethodId As ResurveyMethod, _
                                            ByVal resurveyPeriod As Integer, _
                                            ByVal surveyStartDate As Date, _
                                            ByVal surveyEndDate As Date, _
                                            ByVal samplingAlgorithmId As Integer, _
                                            ByVal enforceSkip As Boolean, _
                                            ByVal cutoffResponseCode As String, _
                                            ByVal cutoffTableId As Integer, _
                                            ByVal cutoffFieldId As Integer, _
                                            ByVal SampleEncounterField As StudyTableColumn, _
                                            ByVal clientFacingName As String, _
                                            ByVal surveyTypeId As Integer, _
                                            ByVal surveyTypeDefId As Integer, _
                                            ByVal houseHoldingType As HouseHoldingType, _
                                            ByVal contractNumber As String, _
                                            ByVal isActive As Boolean, _
                                            ByVal contractedLanguages As String, _
                                            ByVal surveysubtypes As SubTypeList, _
                                            ByVal questionnairesubtype As SubType, _
                                            ByVal UseUSPSAddrChangeService As Boolean _
                                           ) As Survey
        Public MustOverride Sub Delete(ByVal surveyId As Integer)
        Public MustOverride Function AllowDelete(ByVal surveyId As Integer) As Boolean
        Public MustOverride Function PerformSurveyValidation(ByVal surveyId As Integer) As SurveyValidationResult
        Public MustOverride Function SelectSubTypes(ByVal surveytypeid As Integer, ByVal categorytype_id As SubtypeCategories, ByVal survey_id As Integer) As SubTypeList

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
