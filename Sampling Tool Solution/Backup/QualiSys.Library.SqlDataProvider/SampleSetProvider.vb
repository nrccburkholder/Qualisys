Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class SampleSetProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SampleSetProvider

    ''' <summary>
    ''' Creates an instance of a sampleset from a datareader
    ''' </summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function PopulateSampleSet(ByVal rdr As SafeDataReader) As SampleSet

        Dim newObj As New SampleSet

        ReadOnlyAccessor.SampleSetId(newObj) = rdr.GetInteger("SampleSet_id")
        ReadOnlyAccessor.SampleSetCreationDate(newObj) = rdr.GetDate("datSampleCreate_dt")
        ReadOnlyAccessor.SampleSetSurveyId(newObj) = rdr.GetInteger("Survey_id")
        ReadOnlyAccessor.SampleSetSamplePlanId(newObj) = rdr.GetInteger("SamplePlan_Id")
        newObj.CreatorEmployeeId = rdr.GetInteger("Employee_Id")
        newObj.IsFirstSampleInPeriod = Convert.ToBoolean(rdr.GetByte("tiNewPeriod_flag"))
        newObj.IsOversample = Convert.ToBoolean(rdr.GetByte("tiOversample_flag"))
        newObj.SampleStartDate = rdr.GetDate("datExpectedEncStart")
        newObj.SampleEndDate = rdr.GetDate("datExpectedEncEnd")
        ReadOnlyAccessor.SampleSetRandomSeed(newObj) = rdr.GetInteger("intSample_Seed")
        If rdr.IsDBNull("datScheduled") Then
            newObj.ScheduledDate = Nothing
        Else
            newObj.ScheduledDate = rdr.GetDate("datScheduled")
        End If
        newObj.SamplingAlgorithm = DirectCast(System.Enum.ToObject(GetType(SamplingAlgorithm), rdr.GetInteger("SamplingAlgorithmId")), SamplingAlgorithm)
        newObj.HCAHPSOverSample = Convert.ToBoolean(rdr.GetByte("HCAHPSOverSample"))
        If rdr.IsDBNull("datDateRange_FromDate") Then
            newObj.DateRangeFrom = Nothing
        Else
            newObj.DateRangeFrom = rdr.GetDate("datDateRange_FromDate")
        End If
        If rdr.IsDBNull("datDateRange_ToDate") Then
            newObj.DateRangeTo = Nothing
        Else
            newObj.DateRangeTo = rdr.GetDate("datDateRange_ToDate")
        End If

        Return newObj

    End Function

    ''' <summary>
    ''' Creates an instance of an existing sampleset
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function [Select](ByVal sampleSetId As Integer) As SampleSet

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleSet, sampleSetId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateSampleSet(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    ''' <summary>
    ''' Returns a collection of all samplesets in a period
    ''' </summary>
    ''' <param name="periodId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectByPeriodId(ByVal periodId As Integer) As Collection(Of SampleSet)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleSetsByPeriod, periodId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SampleSet)(rdr, AddressOf PopulateSampleSet)
        End Using

    End Function

    ''' <summary>
    ''' Returns a collection of all samplesets in a survey created during the specified date range.
    ''' </summary>
    ''' <param name="surveyId"></param>
    ''' <param name="creationFilterStartDate"></param>
    ''' <param name="creationFilterEndDate"></param>
    ''' <param name="showOnlyUnscheduled"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectBySurveyId(ByVal surveyId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal showOnlyUnscheduled As Boolean) As System.Data.DataTable

        Dim startDate As Object = DBNull.Value
        Dim endDate As Object = DBNull.Value

        If creationFilterStartDate.HasValue Then
            startDate = creationFilterStartDate
        End If

        If creationFilterEndDate.HasValue Then
            endDate = creationFilterEndDate
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExistingSampleSetsBySurvey, surveyId, startDate, endDate, showOnlyUnscheduled)
        Dim ds As DataSet = ExecuteDataSet(cmd)
        Return ds.Tables(0)

    End Function

    ''' <summary>
    ''' Inserts a new sampleset
    ''' </summary>
    ''' <param name="surveyId"></param>
    ''' <param name="employeeId"></param>
    ''' <param name="sampleEncounterStartDate"></param>
    ''' <param name="sampleEncounterEndDate"></param>
    ''' <param name="isOverSample"></param>
    ''' <param name="isFirstSampleInPeriod"></param>
    ''' <param name="periodId"></param>
    ''' <param name="surveyName"></param>
    ''' <param name="sampleEncounterDateTableId"></param>
    ''' <param name="sampleEncounterDateFieldId"></param>
    ''' <param name="Algorithm"></param>
    ''' <param name="samplePlanId"></param>
    ''' <param name="surveyTypeId"></param>
    ''' <param name="HCAHPSOverSample"></param>
    ''' <returns></returns>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Function Insert(ByVal surveyId As Integer, ByVal employeeId As Integer, ByVal sampleEncounterStartDate As Nullable(Of Date), ByVal sampleEncounterEndDate As Nullable(Of Date), ByVal isOverSample As Boolean, ByVal isFirstSampleInPeriod As Boolean, ByVal periodId As Integer, ByVal surveyName As String, ByVal sampleEncounterDateTableId As Integer, ByVal sampleEncounterDateFieldId As Integer, ByVal Algorithm As SamplingAlgorithm, ByVal samplePlanId As Integer, ByVal surveyTypeId As Integer, ByVal hcahpsOverSample As Boolean) As Integer

        Dim startDt As Object = DBNull.Value
        Dim endDt As Object = DBNull.Value
        Dim sampleEncounterDtTableId As Object = DBNull.Value
        Dim sampleEncounterDtFieldId As Object = DBNull.Value

        If sampleEncounterStartDate.HasValue AndAlso sampleEncounterEndDate.HasValue Then
            startDt = sampleEncounterStartDate
            endDt = sampleEncounterEndDate
        End If

        If sampleEncounterDateTableId > 0 AndAlso sampleEncounterDateFieldId > 0 Then
            sampleEncounterDtTableId = sampleEncounterDateTableId
            sampleEncounterDtFieldId = sampleEncounterDateFieldId
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSampleSet, surveyId, employeeId, startDt, endDt, isOverSample, isFirstSampleInPeriod, periodId, surveyName, sampleEncounterDtTableId, sampleEncounterDtFieldId, Algorithm, samplePlanId, surveyTypeId, hcahpsOverSample)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read() Then
                'Logging
                If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                    SampleSetProvider.Instance.InsertSamplingLog(rdr.GetInteger("intSampleSet_id"), "Sampling Started", String.Format("QCL_InsertSampleSet {0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}", surveyId, employeeId, startDt, endDt, isOverSample, isFirstSampleInPeriod, periodId, surveyName, sampleEncounterDtTableId, sampleEncounterDtFieldId, Algorithm, samplePlanId, surveyTypeId, hcahpsOverSample))
                End If

                Return rdr.GetInteger("intSampleSet_id")
            Else
                Return 0
            End If
        End Using

    End Function

    ''' <summary>
    ''' Inserts a samplepop record
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="studyId"></param>
    ''' <param name="popId"></param>
    ''' <param name="badAddress"></param>
    ''' <param name="badPhone"></param>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Sub InsertSamplePop(ByVal sampleSetId As Integer, ByVal studyId As Integer, ByVal popId As Integer, ByVal badAddress As Boolean, ByVal badPhone As Boolean)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSamplePop, sampleSetId, studyId, popId, badAddress, badPhone)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Inserts a selected sampled record
    ''' </summary>
    ''' <param name="SampleSetId"></param>
    ''' <param name="StudyId"></param>
    ''' <param name="PopId"></param>
    ''' <param name="SampleUnitId"></param>
    ''' <param name="SelectionType"></param>
    ''' <param name="EncId"></param>
    ''' <param name="sampleEncounterDate"></param>
    ''' <param name="reportDate"></param>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Sub InsertSelectedSample(ByVal SampleSetId As Integer, ByVal StudyId As Integer, ByVal PopId As Integer, ByVal SampleUnitId As Integer, ByVal SelectionType As SampleSet.UnitSelectType, ByVal EncId As Integer, ByVal sampleEncounterDate As Nullable(Of Date), ByVal reportDate As Nullable(Of Date))

        Dim selectType As String
        Dim cmd As DbCommand
        Dim reportDt As Object = DBNull.Value
        Dim sampleEncounterDt As Object = DBNull.Value

        If reportDate.HasValue Then reportDt = reportDate.Value
        If sampleEncounterDate.HasValue Then sampleEncounterDt = sampleEncounterDate.Value

        Select Case SelectionType
            Case SampleSet.UnitSelectType.Direct
                selectType = "D"

            Case SampleSet.UnitSelectType.Indirect
                selectType = "I"

            Case Else
                Throw New Exception("Invalid selection type specified for InsertSelectedSample sub")

        End Select

        If EncId > 0 Then
            cmd = Db.GetStoredProcCommand(SP.InsertSelectedSample, SampleSetId, StudyId, PopId, SampleUnitId, selectType, EncId, sampleEncounterDt, reportDt)
        Else
            cmd = Db.GetStoredProcCommand(SP.InsertSelectedSample, SampleSetId, StudyId, PopId, SampleUnitId, selectType, DBNull.Value, sampleEncounterDt, reportDt)
        End If

        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Inserts a record into sampleDataSet
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="dataSetId"></param>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Sub InsertSampleDataSet(ByVal sampleSetId As Integer, ByVal dataSetId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSampleDataSet, sampleSetId, dataSetId)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Updates the samplesetId column in the perioddates table
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="periodId"></param>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Sub InsertSampleSetInPeriod(ByVal sampleSetId As Integer, ByVal periodId As Integer)

        'Logging
        If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
            SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "Updating Period", String.Format("QCL_InsertSampleSetInPeriod {0}, {1}", sampleSetId, periodId))
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSampleSetInPeriod, sampleSetId, periodId)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Inserts a DQ rule and count in the SPWDQcounts table.
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="sampleUnitId"></param>
    ''' <param name="dqRuleId"></param>
    ''' <param name="count"></param>
    ''' <remarks></remarks>
    Public Overrides Sub InsertDQRuleIntoSPWDQCounts(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal dqRuleId As Integer, ByVal count As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertDQRuleIntoSPWDQCOUNTS, sampleSetId, sampleUnitId, dqRuleId, count)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Inserts a removed rule and count in the SPWDQcounts table.
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="sampleUnitId"></param>
    ''' <param name="rule"></param>
    ''' <param name="count"></param>
    ''' <remarks></remarks>
    Public Overrides Sub InsertRemovedRulesIntoSPWDQCOUNTS(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal rule As SampleSet.RemovedRule, ByVal count As Integer)

        Dim ruleName As String = ""

        Select Case rule
            Case SampleSet.RemovedRule.ExcludedEncounter
                ruleName = "ExcEnc"

            Case SampleSet.RemovedRule.HouseHoldingAdult
                ruleName = "HHAdult"

            Case SampleSet.RemovedRule.HouseHoldingMinor
                ruleName = "HHMinor"

            Case SampleSet.RemovedRule.Newborn
                ruleName = "NewBorn"

            Case SampleSet.RemovedRule.Resurvey
                ruleName = "Resurvey"

            Case SampleSet.RemovedRule.SecondarySampleRemoval
                ruleName = "SSRemove"

            Case SampleSet.RemovedRule.Tocl
                ruleName = "TOCL"

        End Select

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertRemovedRulesIntoSPWDQCOUNTS, sampleSetId, sampleUnitId, ruleName, count)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Schedules a sampleset to be generated.
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="generationDate"></param>
    ''' <remarks></remarks>
    Public Overrides Sub ScheduleSampleSetGeneration(ByVal sampleSetId As Integer, ByVal generationDate As Date)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ScheduleSampleSetGeneration, sampleSetId, generationDate)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Unschedules a scheduled sample set.
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <remarks></remarks>
    Public Overrides Sub UnscheduleSampleSetGeneration(ByVal sampleSetId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UnscheduleSampleSetGeneration, sampleSetId)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Deletes a sampleset
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <remarks></remarks>
    Public Overrides Sub Delete(ByVal sampleSetId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteSampleSet, sampleSetId)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Returns a recordset with all individuals eligible to be sampled.
    ''' </summary>
    ''' <param name="surveyId"></param>
    ''' <param name="studyId"></param>
    ''' <param name="datasetIds"></param>
    ''' <param name="startDate"></param>
    ''' <param name="endDate"></param>
    ''' <param name="randomSeed"></param>
    ''' <param name="reSurveyPeriod"></param>
    ''' <param name="sampleEncounterDateField"></param>
    ''' <param name="reportDateField"></param>
    ''' <param name="encounterTableExists"></param>
    ''' <param name="sampleSetId"></param>
    ''' <param name="samplingMethod"></param>
    ''' <param name="resurveyMethodology"></param>
    ''' <param name="samplingAlgorithmId"></param>
    ''' <returns></returns>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Function SelectEncounterUnitEligibility(ByVal surveyId As Integer, ByVal studyId As Integer, ByVal datasetIds As String, ByVal startDate As System.Nullable(Of Date), ByVal endDate As System.Nullable(Of Date), ByVal randomSeed As Integer, ByVal reSurveyPeriod As Integer, ByVal sampleEncounterDateField As String, ByVal reportDateField As String, ByVal encounterTableExists As Boolean, ByVal sampleSetId As Integer, ByVal samplingMethod As SampleSet.SamplingMethod, ByVal resurveyMethodology As ResurveyMethod, ByVal samplingAlgorithmId As SamplingAlgorithm) As Framework.Data.SafeDataReader

        Dim cmd As DbCommand
        Dim encounterDtField As Object = DBNull.Value
        Dim reportDtField As Object = DBNull.Value

        If sampleEncounterDateField IsNot Nothing Then encounterDtField = sampleEncounterDateField
        If reportDtField IsNot Nothing Then reportDtField = reportDateField

        If (Not startDate.HasValue And endDate.HasValue) Or (startDate.HasValue And Not endDate.HasValue) Then
            Throw New Exception("Incomplete set of dates specified")
        ElseIf Not startDate.HasValue And Not endDate.HasValue Then
            'Logging
            If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "Getting Encounter Unit Eligibility", String.Format("QCL_SelectEncounterUnitEligibility {0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}", surveyId, studyId, datasetIds, "Null", "Null", randomSeed, reSurveyPeriod, encounterDtField, reportDtField, encounterTableExists, sampleSetId, samplingMethod, resurveyMethodology, samplingAlgorithmId))
            End If

            cmd = Db.GetStoredProcCommand(SP.SelectEncounterUnitEligibility, surveyId, studyId, datasetIds, DBNull.Value, DBNull.Value, randomSeed, reSurveyPeriod, encounterDtField, reportDtField, encounterTableExists, sampleSetId, samplingMethod, resurveyMethodology, samplingAlgorithmId)
        Else
            'Logging
            If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "Getting Encounter Unit Eligibility", String.Format("QCL_SelectEncounterUnitEligibility {0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}", surveyId, studyId, datasetIds, startDate, endDate, randomSeed, reSurveyPeriod, encounterDtField, reportDtField, encounterTableExists, sampleSetId, samplingMethod, resurveyMethodology, samplingAlgorithmId))
            End If

            cmd = Db.GetStoredProcCommand(SP.SelectEncounterUnitEligibility, surveyId, studyId, datasetIds, startDate, endDate, randomSeed, reSurveyPeriod, encounterDtField, reportDtField, encounterTableExists, sampleSetId, samplingMethod, resurveyMethodology, samplingAlgorithmId)
        End If

        Dim rdr As New SafeDataReader(ExecuteReader(cmd))
        Return rdr

    End Function

    ''' <summary>
    ''' Returns a dictionary of units and the outgo needed for each unit.
    ''' </summary>
    ''' <param name="sampleSetID"></param>
    ''' <param name="surveyId"></param>
    ''' <param name="periodId"></param>
    ''' <param name="samplesInPeriod"></param>
    ''' <param name="samplesRun"></param>
    ''' <param name="sampleMethod"></param>
    ''' <param name="responseRateRecalculationPeriod"></param>
    ''' <returns></returns>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Function SelectOutGoNeeded(ByVal sampleSetID As Integer, ByVal surveyId As Integer, ByVal periodId As Integer, ByVal samplesInPeriod As Integer, ByVal samplesRun As Integer, ByVal sampleMethod As SampleSet.SamplingMethod, ByVal responseRateRecalculationPeriod As Integer, ByVal sampleHCAHPSUnit As Boolean) As System.Collections.Generic.Dictionary(Of Integer, Integer)

        Dim outGoList As New Dictionary(Of Integer, Integer)

        'Logging
        If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
            SampleSetProvider.Instance.InsertSamplingLog(sampleSetID, "Getting OutGo Needed", String.Format("QCL_SelectOutGoNeeded {0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}", sampleSetID, surveyId, periodId, samplesInPeriod, samplesRun, sampleMethod, responseRateRecalculationPeriod, sampleHCAHPSUnit))
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectOutGoNeeded, sampleSetID, surveyId, periodId, samplesInPeriod, samplesRun, sampleMethod, responseRateRecalculationPeriod, sampleHCAHPSUnit)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                outGoList.Add(rdr.GetInteger("SampleUnit_Id"), rdr.GetInteger("intTarget"))
            End While
        End Using

        If outGoList.Count = 0 Then
            Return Nothing
        Else
            Return outGoList
        End If

    End Function

    ''' <summary>
    ''' Updates the Sampleplanworksheet table after sampling is completed.
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="sampleUnitId"></param>
    ''' <param name="DQCount"></param>
    ''' <param name="directSampleCount"></param>
    ''' <param name="indirectSampleCount"></param>
    ''' <param name="universeCount"></param>
    ''' <param name="minEncounterDate"></param>
    ''' <param name="maxEncounterDate"></param>
    ''' <param name="badAddressCount"></param>
    ''' <param name="badPhoneCount"></param>
    ''' <param name="hcahpsDirectlySampledCount"></param>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Sub UpdateSamplePlanWorksheet(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal DQCount As Integer, ByVal directSampleCount As Integer, ByVal indirectSampleCount As Integer, ByVal universeCount As Integer, ByVal minEncounterDate As Nullable(Of Date), ByVal maxEncounterDate As Nullable(Of Date), ByVal badAddressCount As Integer, ByVal badPhoneCount As Integer, ByVal hcahpsDirectlySampledCount As Integer)

        Dim cmd As DbCommand

        If (Not minEncounterDate.HasValue And maxEncounterDate.HasValue) Or (minEncounterDate.HasValue And Not maxEncounterDate.HasValue) Then
            Throw New Exception("Incomplete set of dates specified")
        ElseIf Not minEncounterDate.HasValue And Not maxEncounterDate.HasValue Then
            cmd = Db.GetStoredProcCommand(SP.UpdateSamplePlanWorksheet, sampleSetId, sampleUnitId, DQCount, directSampleCount, indirectSampleCount, universeCount, DBNull.Value, DBNull.Value, badAddressCount, badPhoneCount, hcahpsDirectlySampledCount)
        Else
            cmd = Db.GetStoredProcCommand(SP.UpdateSamplePlanWorksheet, sampleSetId, sampleUnitId, DQCount, directSampleCount, indirectSampleCount, universeCount, minEncounterDate, maxEncounterDate, badAddressCount, badPhoneCount, hcahpsDirectlySampledCount)
        End If

        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Updates that sampleset table after sampling is completed.
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="preSampleTime"></param>
    ''' <param name="PostSampleTime"></param>
    ''' <param name="seed"></param>
    ''' <param name="minEncounterDate"></param>
    ''' <param name="maxEncounterDate"></param>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Sub UpdateSampleSetPostSample(ByVal sampleSetId As Integer, ByVal preSampleTime As Integer, ByVal PostSampleTime As Integer, ByVal seed As Integer, ByVal minEncounterDate As Nullable(Of Date), ByVal maxEncounterDate As Nullable(Of Date))

        Dim cmd As DbCommand

        If (Not minEncounterDate.HasValue And maxEncounterDate.HasValue) Or (minEncounterDate.HasValue And Not maxEncounterDate.HasValue) Then
            Throw New Exception("Incomplete set of dates specified")
        ElseIf Not minEncounterDate.HasValue And Not maxEncounterDate.HasValue Then
            'Logging
            If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "Update SampleSet Post Sample", String.Format("QCL_UpdateSampleSetPostSample {0}, {1}, {2}, {3}, {4}, {5}", sampleSetId, preSampleTime, PostSampleTime, seed, "Null", "Null"))
            End If

            cmd = Db.GetStoredProcCommand(SP.UpdateSampleSetPostSample, sampleSetId, preSampleTime, PostSampleTime, seed, DBNull.Value, DBNull.Value)
        Else
            'Logging
            If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "Update SampleSet Post Sample", String.Format("QCL_UpdateSampleSetPostSample {0}, {1}, {2}, {3}, {4}, {5}", sampleSetId, preSampleTime, PostSampleTime, seed, minEncounterDate, maxEncounterDate))
            End If

            cmd = Db.GetStoredProcCommand(SP.UpdateSampleSetPostSample, sampleSetId, preSampleTime, PostSampleTime, seed, minEncounterDate, maxEncounterDate)
        End If

        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>
    ''' Gets the count of encounters eligible for HCAHPS sampling
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="sampleUnitId"></param>
    ''' <returns>Count of encounters eligible for HCAHPS sampling</returns>
    ''' <remarks>This method is currently used with static plus only.</remarks>
    Public Overrides Function SelectHCAHPSEligibleEncountersBySampleSetID(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectHCAHPSEligibleEncountersBySampleSetID, sampleSetId, sampleUnitId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read() Then
                Return CInt(rdr.Item(0))
            Else
                Return 0
            End If
        End Using

    End Function

    ''' <summary>
    ''' Updates the SampleSetUnitTarget table with the calculated target based on HCAHPS proportional sampling
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <param name="sampleUnitId"></param>
    ''' <param name="target"></param>
    ''' <remarks>This method is currently used with static plus only and is only called for HCAHPS units.</remarks>
    Public Overrides Sub UpdateSampleSetUnitTarget(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal target As Integer, ByVal updateSPW As Boolean)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSampleSetUnitTarget, sampleSetId, sampleUnitId, target, updateSPW)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub InsertSampleSetMedicareCalcLookup(ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal medicareReCalcLogId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSampleSetMedicareCalcLookup, sampleSetId, sampleUnitId, medicareReCalcLogId)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub InsertSampleSetExclusionLog(ByVal surveyId As Integer, ByVal sampleSetId As Integer, ByVal sampleUnitId As Integer, ByVal popId As Integer, ByVal encId As Integer, ByVal removeRule As SampleSet.RemovedRule)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSampleSetExclusionLog, surveyId, sampleSetId, sampleUnitId, popId, encId, removeRule, DBNull.Value, Date.Now)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub InsertSamplingLog(ByVal sampleSetId As Integer, ByVal stepName As String, ByVal sqlCode As String)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSamplingLog, sampleSetId, stepName, Date.Now, sqlCode)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub PopulateSeedMailingInfo(ByVal sampleSetId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.PopulateSeedMailingInfo, sampleSetId)
        ExecuteNonQuery(cmd)

    End Sub

End Class
