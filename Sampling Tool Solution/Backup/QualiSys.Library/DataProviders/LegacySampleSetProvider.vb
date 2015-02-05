Namespace DataProvider
    Public MustInherit Class LegacySampleSetProvider

#Region " Singleton Implementation "
        Private Shared mInstance As LegacySampleSetProvider
        Private Const mProviderName As String = "LegacySampleSetProvider"

        Public Shared ReadOnly Property Instance() As LegacySampleSetProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of LegacySampleSetProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub

        Public MustOverride Sub OpenLegacySamplesetConnection()
        Public MustOverride Sub CloseLegacySamplesetConnection()
        Public MustOverride Sub ExecutePreSample(ByVal surveyId As Integer, ByVal datasetId As String, ByVal fromDate As Nullable(Of Date), ByVal toDate As Nullable(Of Date))
        Public MustOverride Sub ExecutePopulateSampleUnitUniverse(ByVal studyId As Integer, ByVal surveyId As Integer, ByVal datasetId As String, ByVal popEnc As String, ByVal bigViewJoin As String, ByVal hhField As String)
        Public MustOverride Sub ExecutePopulateSampleUnitUniverse(ByVal studyId As Integer, ByVal surveyId As Integer, ByVal datasetId As String, ByVal popEnc As String, ByVal bigViewJoin As String)
        Public MustOverride Function ExecuteAddSampleSet(ByVal surveyId As Integer, ByVal employeeId As Integer, ByVal fromDate As Nullable(Of Date), ByVal toDate As Nullable(Of Date), ByVal periodId As Integer, ByVal isOverSample As Boolean, ByVal isNewPeriod As Boolean, ByVal surveyTypeID As Integer) As Integer
        Public MustOverride Sub ExecuteInitializeBusinessRules(ByVal surveyId As Integer, ByRef minorExceptionCriteriaId As Integer, ByRef newBornRuleCriteriaId As Integer, _
                                            ByRef minorExceptionCriteria As String, ByRef newBornRuleCriteria As String)
        Public MustOverride Function ExecuteEncounterTableExists(ByVal surveyId As Integer) As Boolean
        Public MustOverride Sub ExecuteFetchSurveyValues(ByVal surveyId As Integer, ByRef surveyType As String, ByRef householdType As String, _
                    ByRef resurveyExclusionPeriod As Integer)
        Public MustOverride Sub ExecuteFetchHouseholdingValues(ByVal surveyId As Integer, ByRef householdFieldSelectSyntax As String, ByRef householdFieldSelectBigViewSyntax As String, _
                    ByRef householdFieldCreateTableSyntax As String, ByRef householdJoinSyntax As String)
        Public MustOverride Sub ExecuteCreateTempTables(ByVal popIdEncIdCreateTableSyntax As String, ByVal householdFieldCreateTableSyntax As String)
        Public MustOverride Sub ExecuteCreateTempTables(ByVal popIdEncIdCreateTableSyntax As String)
        Public MustOverride Sub ExecuteDropTempTables(ByVal houseHoldingApplied As Boolean)
        Public MustOverride Sub ExecuteApplyIndex(ByVal encounterExists As Boolean)
        Public MustOverride Sub ExecuteResurveyExclusion(ByVal studyId As Integer, ByVal resurveyExclusionPeriod As Integer, ByVal resurveyMethodology As ResurveyMethod, ByVal samplingAlogrithmId As SamplingAlgorithm)
        Public MustOverride Sub ExecuteNewbornRule(ByVal studyId As Integer, ByVal bigViewJoinSyntax As String, ByVal newBornWhereClause As String, ByVal surveyId As Integer, ByVal sampleSetId As Integer)
        Public MustOverride Sub ExecuteToclRule(ByVal studyId As Integer)
        Public MustOverride Sub ExecuteDedupUniverseDynamic(ByVal seed As Integer)
        Public MustOverride Sub ExecuteDedupUniverseStatic(ByVal seed As Integer)
        Public MustOverride Sub ExecuteCalcResponseRates(ByVal surveyId As Integer)
        Public MustOverride Sub ExecuteCalcTargets(ByVal samplesetId As Integer, ByVal periodId As Integer)
        Public MustOverride Sub ExecuteUpdateSamplesetWithSeed(ByVal samplesetId As Integer, ByVal seed As Integer)
        Public MustOverride Function ExecuteSampleunitTiers(ByVal surveyId As Integer, ByVal samplesetId As Integer) As System.Collections.ObjectModel.Collection(Of Integer)
        Public MustOverride Sub ExecuteSample(ByVal sampleunitId As Integer, ByVal samplingMethod As String, ByVal samplesetId As Integer, ByVal seed As Integer)
        Public MustOverride Sub ExecuteStaticSampleAntecedIndirect(ByVal sampleunitId As Integer, ByVal popIdEncIdJoinSyntax As String)
        Public MustOverride Sub ExecuteStaticRemoveFromSiblings(ByVal sampleunitId As Integer)
        Public MustOverride Sub ExecuteStaticRemoveFromChildren(ByRef sampleunitId As Integer)
        <System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1706:ShortAcronymsShouldBeUppercase", MessageId:="Member")> Public MustOverride Sub ExecuteStaticDeDupeEncChildUnit(ByVal sampleunitId As Integer, ByVal popIdEncIdJoinSyntax As String, ByVal mPopIdEncIdSelectSyntax As String, ByVal mPopIdEncIdCreateTableSyntax As String, _
                    ByVal seed As Integer)
        Public MustOverride Sub ExecuteSampleChildDirect(ByVal sampleUnitId As Integer, ByVal popIdEncIdJoinsyntax As String)
        Public MustOverride Sub ExecuteDynamicIndirectSample(ByVal sampleunitId As Integer, ByVal popIdEncIdJoinSyntax As String)
        Public MustOverride Sub ExecuteUpdatePeriod(ByVal samplesetId As Integer, ByVal periodId As Integer)
        Public MustOverride Sub ExecuteUpdateSampleDataSet(ByVal samplesetId As Integer)
        Public MustOverride Sub ExecuteUpdateSamplePop(ByVal samplesetId As Integer)
        Public MustOverride Sub ExecuteUpdateSelectedSample(ByVal samplesetId As Integer, ByVal encounterExists As Boolean)
        <System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1706:ShortAcronymsShouldBeUppercase", MessageId:="4#")> Public MustOverride Sub ExecuteHouseholdingAdult(ByVal studyId As Integer, ByVal householdFieldCreateTableSyntax As String, ByVal householdFieldSelectSyntax As String, _
                    ByVal householdJoinSyntax As String, ByVal reSurveyExPeriod As Integer, ByVal seed As Integer)
        <System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1706:ShortAcronymsShouldBeUppercase", MessageId:="5#")> Public MustOverride Sub ExecuteHouseholdingMinor(ByVal minorExceptionCriteria As String, ByVal studyId As Integer, ByVal householdFieldCreateTableSyntax As String, ByVal householdFieldSelectSyntax As String, _
                    ByVal householdJoinSyntax As String, ByVal reSurveyExPeriod As Integer, ByVal seed As Integer)
        Public MustOverride Sub ExecuteRollbackSample(ByVal samplesetId As Integer)
        Public MustOverride Function ExecuteValidateConfiguration(ByVal surveyId As Integer) As String


    End Class
End Namespace
