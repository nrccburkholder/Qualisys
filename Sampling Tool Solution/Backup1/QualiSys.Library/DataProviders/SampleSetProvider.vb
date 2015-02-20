Imports Nrc.Framework.Data

Namespace DataProvider

    Public MustInherit Class SampleSetProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SampleSetProvider
        Private Const mProviderName As String = "SampleSetProvider"

        Public Shared ReadOnly Property Instance() As SampleSetProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SampleSetProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function [Select](ByVal sampleSetId As Integer) As SampleSet
        Public MustOverride Function SelectBySurveyId(ByVal surveyId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal showOnlyUnscheduled As Boolean) As DataTable
        Public MustOverride Function SelectByPeriodId(ByVal periodId As Integer) As Collection(Of SampleSet)
        Public MustOverride Function Insert(ByVal surveyId As Integer, ByVal employeeId As Integer, ByVal sampleEncounterStartDate As Nullable(Of Date), ByVal sampleEncounterEndDate As Nullable(Of Date), ByVal isOverSample As Boolean, ByVal isFirstSampleInPeriod As Boolean, ByVal periodId As Integer, ByVal surveyName As String, ByVal sampleEncounterDateTableId As Integer, ByVal sampleEncounterDateFieldId As Integer, ByVal algorithm As SamplingAlgorithm, ByVal samplePlanId As Integer, ByVal surveyTypeId As Integer, ByVal hcahpsOverSample As Boolean) As Integer
        Public MustOverride Sub Delete(ByVal sampleSetId As Integer)

        Public MustOverride Sub InsertSelectedSample(ByVal sampleSetId As Integer, ByVal studyId As Integer, ByVal popId As Integer, ByVal sampleUnitId As Integer, ByVal selectionType As SampleSet.UnitSelectType, ByVal encId As Integer, ByVal sampleEncounterDate As Nullable(Of Date), ByVal reportDate As Nullable(Of Date))
        Public MustOverride Sub InsertSampleSetInPeriod(ByVal sampleSetId As Integer, ByVal periodId As Integer)
        Public MustOverride Sub InsertSamplePop(ByVal sampleSetId As Integer, ByVal studyId As Integer, ByVal popId As Integer, ByVal badAddress As Boolean, ByVal badPhone As Boolean)
        Public MustOverride Sub InsertSampleDataSet(ByVal sampleSetId As Integer, ByVal dataSetId As Integer)
        Public MustOverride Sub ScheduleSampleSetGeneration(ByVal sampleSetId As Integer, ByVal generationDate As Date)
        Public MustOverride Sub UnscheduleSampleSetGeneration(ByVal sampleSetId As Integer)

        Public MustOverride Function SelectOutGoNeeded(ByVal sampleSetId As Integer, ByVal surveyId As Integer, ByVal periodId As Integer, ByVal samplesInPeriod As Integer, ByVal samplesRun As Integer, ByVal sampleMethod As SampleSet.SamplingMethod, ByVal responseRateRecalculationPeriod As Integer, ByVal sampleHCAHPSUnit As Boolean) As Dictionary(Of Integer, Integer)
        Public MustOverride Function SelectEncounterUnitEligibility(ByVal surveyId As Integer, ByVal studyId As Integer, ByVal datasetIds As String, ByVal startDate As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal randomSeed As Integer, ByVal reSurveyPeriod As Integer, ByVal sampleEncounterDateField As String, ByVal reportDateField As String, ByVal encounterTableExists As Boolean, ByVal sampleSetId As Integer, ByVal samplingMethod As SampleSet.SamplingMethod, ByVal resurveyMethodology As ResurveyMethod, ByVal samplingAlgorithmId As SamplingAlgorithm) As SafeDataReader
        Public MustOverride Function SelectHCAHPSEligibleEncountersBySampleSetID(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer) As Integer
        Public MustOverride Sub UpdateSamplePlanWorksheet(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal dqCount As Integer, ByVal directSampleCount As Integer, ByVal indirectSampleCount As Integer, ByVal universeCount As Integer, ByVal minEncounterDate As Nullable(Of Date), ByVal maxEncounterDate As Nullable(Of Date), ByVal badAddressCount As Integer, ByVal badPhoneCount As Integer, ByVal hcahpsDirectlySampledCount As Integer)
        Public MustOverride Sub UpdateSampleSetPostSample(ByVal sampleSetId As Integer, ByVal preSampleTime As Integer, ByVal postSampleTime As Integer, ByVal seed As Integer, ByVal minEncounterDate As Nullable(Of Date), ByVal maxEncounterDate As Nullable(Of Date))
        Public MustOverride Sub UpdateSampleSetUnitTarget(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal target As Integer, ByVal updateSPW As Boolean)
        Public MustOverride Sub InsertSampleSetMedicareCalcLookup(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal medicareReCalcLogId As Integer)
        <System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1705:LongAcronymsShouldBePascalCased", MessageId:="Member")> Public MustOverride Sub InsertRemovedRulesIntoSPWDQCOUNTS(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal rule As SampleSet.RemovedRule, ByVal count As Integer)
        <System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1705:LongAcronymsShouldBePascalCased", MessageId:="Member")> Public MustOverride Sub InsertDQRuleIntoSPWDQCounts(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal dqRuleId As Integer, ByVal count As Integer)
        Public MustOverride Sub InsertSampleSetExclusionLog(ByVal surveyId As Integer, ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal popId As Integer, ByVal encId As Integer, ByVal removeRule As SampleSet.RemovedRule)
        Public MustOverride Sub InsertSamplingLog(ByVal sampleSetId As Integer, ByVal stepName As String, ByVal sqlCode As String)
        Public MustOverride Sub PopulateSeedMailingInfo(ByVal sampleSetId As Integer)

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property SampleSetId(ByVal obj As SampleSet) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
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
            Public Shared WriteOnly Property SampleSetSurveyId(ByVal obj As SampleSet) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.SurveyId = value
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
            Public Shared WriteOnly Property SampleSetRandomSeed(ByVal obj As SampleSet) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.RandomSeed = value
                    End If
                End Set
            End Property

        End Class
    End Class

End Namespace
