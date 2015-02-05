Imports Nrc.QualiSys.Library.DataProvider

Partial Public Class SampleSet

#Region " Legacy Sampleset Class "
    Private Class LegacySampleSet
#Region " Legacy SampleSet Private Fields"

        'Module level vars used when running a sample
        Private mSamplingType As String = ""
        Private mMinorExceptionCriteriaId As Integer = -1
        Private mNewbornRuleCriteriaId As Integer = -1
        Private mMinorExceptionCriteria As String = ""
        Private mNewbornRuleCriteria As String = ""
        Private mHouseholdType As String = ""
        Private mResurveyExclusionPeriod As Integer = -1
        Private mBigViewJoinSyntax As String = ""
        Private mHouseholdFieldSelectSyntax As String = ""
        Private mHouseholdFieldSelectBigViewSyntax As String = ""
        Private mHouseholdFieldCreateTableSyntax As String = ""
        Private mHouseholdJoinSyntax As String = ""
        Private mPop_idEnc_idSelectSyntax As String = ""
        Private mPop_idEnc_idSelectAliasedSyntax As String = ""
        Private mPop_idEnc_idCreateTableSyntax As String = ""
        Private mPop_idEnc_idJoinSyntax As String = ""
        Private mSampleSetId As Integer = -1
        Private mEncounterExists As Boolean
        Private mSurveyId As Integer = -1
        Private mStudyId As Integer = -1
        Private mDatasets As String = ""
        Private mPeriodId As Integer = -1
        Private mRandomNumber As Integer = -1
        Private mEmployeeId As Integer = -1
        Private mFromDate As Nullable(Of Date)
        Private mToDate As Nullable(Of Date)
        Private mIsOverSample As Boolean
        Private mIsNewPeriod As Boolean
        Private msurvey As Survey
#End Region

#Region " Legacy SampleSet Public Methods"
        ''' <summary>
        ''' Performs a Static or Dyanamic Legacy sample
        ''' </summary>
        Public Shared Function PerformLegacySample(ByVal srvy As Survey, ByVal datasets As Collection(Of StudyDataset), ByVal startDate As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal creator As Employee, ByVal period As SamplePeriod) As Integer

            Dim legacySample As New LegacySampleSet
            Dim dsList As New System.Text.StringBuilder
            Dim isOverSample As Boolean
            Dim isNewPeriod As Boolean

            If period.SampleSets.Count >= period.ExpectedSamples Then
                isOverSample = True
            End If

            If period.SampleSets.Count = 0 Then
                isNewPeriod = True
            End If

            For Each ds As StudyDataset In datasets
                dsList.Append(ds.Id.ToString & ",")
            Next
            dsList.Remove(dsList.Length - 1, 1)
            Return legacySample.CreateSampleSet(srvy, dsList.ToString, creator.Id, startDate, endDate, period.Id, isOverSample, isNewPeriod)
        End Function

#End Region

#Region " Legacy SampleSet Private Methods"

        Private Function CreateSampleSet(ByVal srvy As Survey, ByVal dataSets As String, ByVal employeeId As Integer, ByVal fromDate As Nullable(Of Date), ByVal toDate As Nullable(Of Date), ByVal periodId As Integer, ByVal isOverSample As Boolean, ByVal isNewPeriod As Boolean) As Integer

            Dim sValidateConfig As String = ""
            mSurveyId = srvy.Id
            mStudyId = srvy.StudyId
            mDatasets = dataSets
            mPeriodId = periodId
            mEmployeeId = employeeId
            msurvey = srvy
            'Ignore the dates if the encounter field is null
            If msurvey.SampleEncounterField IsNot Nothing Then
                mFromDate = fromDate
                mToDate = toDate
            End If
            mIsOverSample = isOverSample
            mIsNewPeriod = isNewPeriod


            Try
                LegacySampleSetProvider.Instance.OpenLegacySamplesetConnection()
                'Determine whether or not a Study/Survey is properly configured for sampling
                sValidateConfig = ValidateConfiguration()
                If sValidateConfig = "NO ERROR" Then
                    Randomize()
                    mRandomNumber = CInt(System.Math.Round(Rnd() * 1000000, 0))
                    InitializeModuleLevelVars()
                    CreateTempTables()
                    PreSample()
                    SampleunitUniverse()
                    ApplyIndexUniverse()
                    ApplyBusinessRules()

                    mSampleSetId = AddSampleSetRecord()

                    DeDupeSampleUnitUniverse()
                    ApplyHouseholding()
                    ApplySample()
                    UpdatePermanentTables()

                    DropTempTables()
                Else
                    Throw New Exception(sValidateConfig)
                End If

                'Pass back the Configuration/Status Message
                Return mSampleSetId

            Catch ex As Exception
                RollbackSample()
                Throw
            Finally
                LegacySampleSetProvider.Instance.CloseLegacySamplesetConnection()
            End Try

        End Function

        Private Sub PreSample()
            LegacySampleSetProvider.Instance.ExecutePreSample(mSurveyId, mDatasets, mFromDate, mToDate)
        End Sub

        Private Sub SampleunitUniverse()
            If mHouseholdFieldSelectBigViewSyntax <> "" Then
                LegacySampleSetProvider.Instance.ExecutePopulateSampleUnitUniverse(mStudyId, mSurveyId, mDatasets, mPop_idEnc_idSelectSyntax, mBigViewJoinSyntax, mHouseholdFieldSelectBigViewSyntax)
            Else
                LegacySampleSetProvider.Instance.ExecutePopulateSampleUnitUniverse(mStudyId, mSurveyId, mDatasets, mPop_idEnc_idSelectSyntax, mBigViewJoinSyntax)
            End If
        End Sub

        Private Function AddSampleSetRecord() As Integer
            Return LegacySampleSetProvider.Instance.ExecuteAddSampleSet(mSurveyId, mEmployeeId, mFromDate, mToDate, mPeriodId, mIsOverSample, mIsNewPeriod, msurvey.SurveyType)
        End Function

        Private Sub InitializeModuleLevelVars()
            InitializeSetSurveyDefVars()
            InitializeBusinessRuleVars()
            InitializeBigViewVars()
            InitializeHouseholdingVars()
        End Sub

        Private Sub InitializeBusinessRuleVars()
            LegacySampleSetProvider.Instance.ExecuteInitializeBusinessRules(mSurveyId, mMinorExceptionCriteriaId, mNewbornRuleCriteriaId, mMinorExceptionCriteria, mNewbornRuleCriteria)
        End Sub

        Private Sub InitializeBigViewVars()

            'Determine if an Encounter Table exists
            mEncounterExists = LegacySampleSetProvider.Instance.ExecuteEncounterTableExists(mSurveyId)

            'Format the msBigViewJoin property
            mBigViewJoinSyntax = "X.Pop_id = BV.POPULATIONPop_id"
            If mEncounterExists = True Then mBigViewJoinSyntax = mBigViewJoinSyntax & " AND X.Enc_id = BV.ENCOUNTEREnc_id"

            'Format the msPop_idEnc_idSelect property
            mPop_idEnc_idSelectSyntax = "Pop_id"
            If mEncounterExists = True Then mPop_idEnc_idSelectSyntax = mPop_idEnc_idSelectSyntax & ", Enc_id"

            'Format the msPop_idEnc_idSelectAliased property
            mPop_idEnc_idSelectAliasedSyntax = "X.Pop_id"
            If mEncounterExists Then mPop_idEnc_idSelectAliasedSyntax = mPop_idEnc_idSelectAliasedSyntax & ", X.Enc_id"

            'Format the msPop_idEnc_idCreateTable property
            mPop_idEnc_idCreateTableSyntax = "Pop_id int"
            If mEncounterExists = True Then mPop_idEnc_idCreateTableSyntax = mPop_idEnc_idCreateTableSyntax & ", Enc_id int"

            'Format the msPop_idEnc_idJoin Property
            mPop_idEnc_idJoinSyntax = "X.Pop_id = Y.Pop_id"
            If mEncounterExists = True Then mPop_idEnc_idJoinSyntax = mPop_idEnc_idJoinSyntax & " AND X.Enc_id = Y.Enc_id"

        End Sub

        Private Sub InitializeSetSurveyDefVars()
            LegacySampleSetProvider.Instance.ExecuteFetchSurveyValues(mSurveyId, mSamplingType, mHouseholdType, mResurveyExclusionPeriod)
        End Sub

        Private Sub InitializeHouseholdingVars()
            If mHouseholdType <> "N" Then
                LegacySampleSetProvider.Instance.ExecuteFetchHouseholdingValues(mSurveyId, mHouseholdFieldSelectSyntax, mHouseholdFieldSelectBigViewSyntax, _
                    mHouseholdFieldCreateTableSyntax, mHouseholdJoinSyntax)
            End If

        End Sub

        Private Sub CreateTempTables()
            If mHouseholdType <> "N" Then
                LegacySampleSetProvider.Instance.ExecuteCreateTempTables(mPop_idEnc_idCreateTableSyntax, mHouseholdFieldCreateTableSyntax)
            Else
                LegacySampleSetProvider.Instance.ExecuteCreateTempTables(mPop_idEnc_idCreateTableSyntax)
            End If
        End Sub

        Private Sub DropTempTables()
            If mHouseholdType <> "N" Then
                LegacySampleSetProvider.Instance.ExecuteDropTempTables(True)
            Else
                LegacySampleSetProvider.Instance.ExecuteDropTempTables(False)
            End If
        End Sub

        Private Sub ApplyIndexUniverse()
            LegacySampleSetProvider.Instance.ExecuteApplyIndex(mEncounterExists)
        End Sub

        Private Sub ApplyBusinessRules()

            ApplyReSurveyExclusion()
            ApplyNewbornRule()
            ApplyTOCLRule()
        End Sub

        Private Sub ApplyReSurveyExclusion()
            LegacySampleSetProvider.Instance.ExecuteResurveyExclusion(mStudyId, mResurveyExclusionPeriod, msurvey.ResurveyMethod, msurvey.SamplingAlgorithm)
        End Sub

        Private Sub ApplyNewbornRule()
            If mNewbornRuleCriteriaId <> -1 Then
                LegacySampleSetProvider.Instance.ExecuteNewbornRule(mStudyId, mBigViewJoinSyntax, mNewbornRuleCriteria, mSurveyId, mSampleSetId)
            End If
        End Sub

        Private Sub ApplyTOCLRule()
            LegacySampleSetProvider.Instance.ExecuteTOCLRule(mStudyId)
        End Sub

        Private Sub DeDupeSampleUnitUniverse()
            If mEncounterExists Then
                If mSamplingType = "D" Then
                    LegacySampleSetProvider.Instance.ExecuteDedupUniverseDynamic(mRandomNumber)
                Else
                    LegacySampleSetProvider.Instance.ExecuteDedupUniverseStatic(mRandomNumber)
                End If
            End If
        End Sub

        Private Sub ApplySample()
            CalculateResponseRate()
            CalculateTargets()
            ExecuteSample()
        End Sub

        Private Sub CalculateResponseRate()
            LegacySampleSetProvider.Instance.ExecuteCalcResponseRates(mSurveyId)
        End Sub

        Private Sub CalculateTargets()
            LegacySampleSetProvider.Instance.ExecuteCalcTargets(mSampleSetId, mPeriodId)
        End Sub

        Private Sub ExecuteSample()
            Dim units As System.Collections.ObjectModel.Collection(Of Integer)

            LegacySampleSetProvider.Instance.ExecuteUpdateSamplesetWithSeed(mSampleSetId, mRandomNumber)
            units = LegacySampleSetProvider.Instance.ExecuteSampleunitTiers(mSurveyId, mSampleSetId)
            For Each unit As Integer In units
                LegacySampleSetProvider.Instance.ExecuteSample(unit, msurvey.ActiveSamplePeriod.SamplingMethodLabel, mSampleSetId, mRandomNumber)

                If mSamplingType = "S" And msurvey.ActiveSamplePeriod.SamplingMethod <> SamplingMethod.Census Then
                    ExecuteSecondarySampleStatic(unit)
                ElseIf mSamplingType = "D" And msurvey.ActiveSamplePeriod.SamplingMethod <> SamplingMethod.Census Then
                    ExecuteSecondarySampleDynamic(unit)
                End If
            Next

        End Sub

        Private Sub ExecuteSecondarySampleStatic(ByVal sampleunitId As Integer)
            ExecuteStaticSampleAntecedIndirect(sampleunitId)
            ExecuteStaticRemoveFromSiblings(sampleunitId)
            ExecuteStaticDeDupeEncChildUnit(sampleunitId)
            ExecuteSampleChildDirect(sampleunitId)
        End Sub

        Private Sub ExecuteStaticSampleAntecedIndirect(ByVal sampleunitId As Integer)
            LegacySampleSetProvider.Instance.ExecuteStaticSampleAntecedIndirect(sampleunitId, mPop_idEnc_idJoinSyntax)
        End Sub

        Private Shared Sub ExecuteStaticRemoveFromSiblings(ByVal sampleunitId As Integer)
            LegacySampleSetProvider.Instance.ExecuteStaticRemoveFromSiblings(sampleunitId)
        End Sub

        Private Shared Sub ExecuteStaticRemoveFromChildren(ByVal sampleunitId As Integer)
            LegacySampleSetProvider.Instance.ExecuteStaticRemoveFromChildren(sampleunitId)
        End Sub

        Private Sub ExecuteStaticDeDupeEncChildUnit(ByVal SampleunitId As Integer)
            LegacySampleSetProvider.Instance.ExecuteStaticDeDupeEncChildUnit(SampleunitId, mPop_idEnc_idJoinSyntax, mPop_idEnc_idSelectAliasedSyntax, mPop_idEnc_idCreateTableSyntax, mRandomNumber)
        End Sub

        Private Sub ExecuteSampleChildDirect(ByVal sampleunitid As Integer)
            LegacySampleSetProvider.Instance.ExecuteSampleChildDirect(sampleunitid, mPop_idEnc_idJoinSyntax)
        End Sub

        Private Sub ExecuteSecondarySampleDynamic(ByVal sampleunitId As Integer)

            ExecuteSampleChildDirect(sampleunitId)
            ExecuteDynamicIndirectSample(sampleunitId)
        End Sub

        Private Sub ExecuteDynamicIndirectSample(ByVal sampleunitId As Integer)
            LegacySampleSetProvider.Instance.ExecuteDynamicIndirectSample(sampleunitId, mPop_idEnc_idJoinSyntax)
        End Sub

        Private Sub UpdatePermanentTables()
            UpdateSelectedSample()
            UpdateSampleDataSet()
            UpdateSamplePop()
            UpdatePeriods()
        End Sub

        Private Sub UpdatePeriods()
            LegacySampleSetProvider.Instance.ExecuteUpdatePeriod(mSampleSetId, mPeriodId)
        End Sub

        Private Sub UpdateSampleDataSet()
            LegacySampleSetProvider.Instance.ExecuteUpdateSampleDataSet(mSampleSetId)
        End Sub

        Private Sub UpdateSamplePop()
            LegacySampleSetProvider.Instance.ExecuteUpdateSamplePop(mSampleSetId)
        End Sub

        Private Sub UpdateSelectedSample()
            LegacySampleSetProvider.Instance.ExecuteUpdateSelectedSample(mSampleSetId, mEncounterExists)
        End Sub

        Private Sub ApplyHouseholding()
            If mHouseholdType <> "N" Then
                If mHouseholdType = "A" Then
                    LegacySampleSetProvider.Instance.ExecuteHouseholdingAdult(mStudyId, mHouseholdFieldCreateTableSyntax, mHouseholdFieldSelectSyntax, _
                                mHouseholdJoinSyntax, mResurveyExclusionPeriod, mRandomNumber)
                Else
                    LegacySampleSetProvider.Instance.ExecuteHouseholdingMinor(mMinorExceptionCriteria, mStudyId, mHouseholdFieldCreateTableSyntax, mHouseholdFieldSelectSyntax, _
                                mHouseholdJoinSyntax, mResurveyExclusionPeriod, mRandomNumber)
                End If
            End If
        End Sub

        Private Sub RollbackSample()
            LegacySampleSetProvider.Instance.ExecuteRollbackSample(mSampleSetId)
        End Sub

        Private Function ValidateConfiguration() As String
            Return LegacySampleSetProvider.Instance.ExecuteValidateConfiguration(mSurveyId)
        End Function

#End Region

    End Class
#End Region

End Class
