Imports Nrc.Framework.Data
Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.QualiSys.Library.DataProvider.ODSDBDataAccess
Imports Nrc.Framework.BusinessLogic.Configuration
Imports System.Linq


Partial Public Class SampleSet

    Private Class StaticPlusAlgorithm

        Private Sub New()

        End Sub

#Region "Sampling Algorithm Methods"

        ''' <summary>
        ''' This is the base method called to perform a static plus sample
        ''' </summary>
        ''' <param name="srvy">The Survey object being sampled</param>
        ''' <param name="period">The SamplePeriod object for this sample</param>
        ''' <param name="datasets">The collection of StudyDataset objects for this sample</param>
        ''' <param name="startDate">The start date for the encounters to be sampled</param>
        ''' <param name="endDate">The end date for the encounters to be sampled</param>
        ''' <param name="creator">The QualiSys Employee executing the sample</param>
        ''' <param name="hcahpsOverSample">Specifies whether or not to oversample the HCAHPS unit if this is an oversample</param>
        ''' <param name="specificSampleSeed">Pass in a number greater or equal than zero to use it a sample seed, otherwise a random one is generated</param>
        ''' <returns>Returns the ID of the newly created SampleSet</returns>
        ''' <remarks></remarks>
        Public Shared Function PerformStaticPlusSample(ByVal srvy As Survey, ByVal period As SamplePeriod, _
                                                       ByVal datasets As Collection(Of StudyDataset), _
                                                       ByVal startDate As Nullable(Of Date), _
                                                       ByVal endDate As Nullable(Of Date), _
                                                       ByVal creator As Employee, _
                                                       ByVal hcahpsOverSample As Boolean, _
                                                       ByVal specificSampleSeed As Integer) As Integer

            Dim dataSetIds As New System.Text.StringBuilder("")
            Dim sampleSetUnits As Dictionary(Of Integer, SampleSetUnit)
            Dim encounterTableExists As Boolean
            Dim outGoList As Dictionary(Of Integer, Integer)
            Dim sampleSetId As Integer
            Dim isOverSample As Boolean = (period.SampleSets.Count >= period.ExpectedSamples)
            Dim isFirstSampleinPeriod As Boolean = (period.SampleSets.Count = 0)
            Dim encounterDateRange As Collection(Of Nullable(Of Date)) = Nothing
            Dim preSampleTime As Integer = 0
            Dim postSampleTime As Integer = 0
            Dim now As DateTime = System.DateTime.Now
            Dim sampleEncounterDateField As String = Nothing
            Dim reportDateField As String = Nothing
            Dim sampleEncounterDateTableId As Integer = -1
            Dim sampleEncounterDateFieldId As Integer = -1
            Dim sampleHCAHPSUnit As Boolean
            Dim randomNumber As Integer
            Dim systematicIncrement As Integer

            'RTP-2395 Fill Resurvey Values from ODS at this time, prior to calling Sampling algorithm CJB 5/31/2017

            If Not (srvy.IsCAHPS) Then
                Dim odsdb As ODSDBDataAccess.ODSDBRepository = New ODSDBDataAccess.ODSDBRepository
                Dim clientId As Integer = Nrc.QualiSys.Library.Study.GetStudy(srvy.StudyId).ClientId
                Dim custSettings As Dictionary(Of String, Object) = odsdb.GetCustomerSettings(clientId, AppConfig.Params("MasterSurveyTypeForODSDB").StringValue)
                If custSettings.ContainsKey("LocationProviderResurveyDays") Then
                    srvy.LocationProviderResurveyDays = Integer.Parse(custSettings("LocationProviderResurveyDays").ToString)
                End If
                If custSettings.ContainsKey("IntraCustomerResurveyDays") Then
                    srvy.ResurveyPeriod = Integer.Parse(custSettings("IntraCustomerResurveyDays").ToString())
                End If
                srvy.Update()
            End If

            'RTP-2395 End

            If specificSampleSeed >= 0 Then
                'New feature allows specifying sample seed for IT users only - INC0019623
                randomNumber = specificSampleSeed
            Else
                'Generate random number to use as seed - this is the standard procedure
                Dim ran As New Random(CInt(DateTime.Now.Ticks Mod System.Int32.MaxValue))
                Randomize()
                randomNumber = ran.Next
            End If


            For Each table As StudyTable In srvy.Study.GetStudyTables
                If table.Name.ToUpper = "ENCOUNTER" Then
                    encounterTableExists = True
                    Exit For
                End If
            Next

            If srvy.SampleEncounterField IsNot Nothing Then
                sampleEncounterDateField = String.Format("{0}{1}", StudyTable.Get(srvy.SampleEncounterField.TableId).Name, srvy.SampleEncounterField.Name)
                sampleEncounterDateTableId = srvy.SampleEncounterField.TableId
                sampleEncounterDateFieldId = srvy.SampleEncounterField.Id
            Else
                startDate = Nothing
                endDate = Nothing
            End If

            If srvy.CutoffField IsNot Nothing Then
                reportDateField = String.Format("{0}{1}", srvy.CutoffTable.Name, srvy.CutoffField.Name)
            End If

            Try
                'Create a new sampleset in database
                sampleSetId = SampleSetProvider.Instance.Insert(srvy.Id, creator.Id, startDate, endDate, isOverSample, isFirstSampleinPeriod, period.Id, srvy.Name, sampleEncounterDateTableId, sampleEncounterDateFieldId, SamplingAlgorithm.StaticPlus, srvy.SamplePlanId, srvy.SurveyType, hcahpsOverSample)
                If sampleSetId = 0 Then Throw New Exception("Unable to add new record to sampleset table")

                'Get all of the datasets being sampled
                For Each ds As StudyDataset In datasets
                    If dataSetIds.Length > 0 Then dataSetIds.Append(",")
                    dataSetIds.Append(ds.Id.ToString)
                    InsertSampleDataSet(sampleSetId, ds.Id)
                Next

                'Determine if we are sampling the HCAHPS units
                If isOverSample Then
                    If hcahpsOverSample Then
                        sampleHCAHPSUnit = True
                    Else
                        sampleHCAHPSUnit = False
                    End If
                Else
                    sampleHCAHPSUnit = True
                End If

                'Get the outgo needed for all sampleunits
                outGoList = SampleSetProvider.Instance.SelectOutGoNeeded(sampleSetId, srvy.Id, period.Id, period.ExpectedSamples, period.SampleSets.Count, period.SamplingMethod, srvy.ResponseRateRecalculationPeriod, sampleHCAHPSUnit)

                'Logging
                If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                    SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "Building SampleUnit OutGo Needed", String.Format("QCL_SelectSampleUnitsBySurveyId {0}", srvy.Id))
                End If

                'Build the SampleSetUnit collection
                sampleSetUnits = BuildSampleUnitOutGoNeeded(srvy, outGoList)

                'Loop through each encounter
                Dim encounterUnitEligibility_s As EncounterUnitEligibilityCollection
                Using rdr As SafeDataReader = SampleSetProvider.Instance.SelectEncounterUnitEligibility(srvy.Id, srvy.StudyId, dataSetIds.ToString, startDate, endDate, randomNumber, srvy.ResurveyPeriod, sampleEncounterDateField, reportDateField, encounterTableExists, sampleSetId, period.SamplingMethod, srvy.ResurveyMethod, SamplingAlgorithm.StaticPlus)
                    encounterUnitEligibility_s = EncounterUnitEligibility.FillCollection(rdr)
                End Using

                'Validate 1 and only 1 CCN for Systematic (OAS)

                If srvy.IsSystematic Then
                    Dim CCNs As List(Of String) = (From row In encounterUnitEligibility_s.AsEnumerable() Select row.CCN Where Not String.IsNullOrEmpty(CCN)).Distinct().ToList()
                    If CCNs.Count > 1 Then
                        Dim CCNlist As String = String.Empty
                        For Each CCN As String In CCNs
                            CCNlist = CCNlist & ", " & CCN
                        Next
                        Throw New DataException("Multiple CCNs in Systematic Sampling Sampleset. Sampleset_id:" & sampleSetId.ToString() & CCNlist)
                    End If
                End If

                'Get the number of seconds it took to perform the presample steps

                preSampleTime = CInt(Math.Ceiling((System.DateTime.Now - now).TotalSeconds))
                now = System.DateTime.Now

                'Logging
                If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                    SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "RecalcDelayedOutGoNeeded()", String.Empty)
                End If

                'Calculate the outgo needed for all of the HCAHPS units using the Medicare Proportion and HCAHPS Eligilbe Encounter count
                'Calculate the outgo needed for all of the OASCAHPS units using the Annual sample size (calc if needed) to get monthly & interval
                RecalcDelayedOutGoNeeded(sampleSetId, sampleSetUnits, startDate, sampleHCAHPSUnit, period, srvy, systematicIncrement)

                'Logging
                If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                    SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "ExecuteSample()", String.Empty)
                End If

                'This will iterate through the collection and perform the sample
                If srvy.IsSystematic Then
                    Dim locations As List(Of Integer) = (From row In encounterUnitEligibility_s.AsEnumerable() Select row.Sampleunit_id).Distinct().ToList()
                    Dim outgo_s As Dictionary(Of Integer, Integer) = New Dictionary(Of Integer, Integer)
                    For Each location As Integer In locations
                        outgo_s.Add(location, sampleSetUnits(location).OutGoNeeded)
                    Next

                    Dim sortedForSystematicEncounterUnitEligibility As EncounterUnitEligibilityCollection
                    sortedForSystematicEncounterUnitEligibility = EncounterUnitEligibility.SortForSystematic(encounterUnitEligibility_s, locations, outgo_s, systematicIncrement)

                    ExecuteSample(sortedForSystematicEncounterUnitEligibility, sampleSetUnits, encounterTableExists, sampleSetId, srvy)
                Else
                    ExecuteSample(encounterUnitEligibility_s, sampleSetUnits, encounterTableExists, sampleSetId, srvy)
                End If

                'Finalize the sample
                UpdatePeriods(sampleSetId, period.Id)
                updateSamplePlanWorksheet(sampleSetId, sampleSetUnits)

                'Determine the encounter date range if required
                If startDate.HasValue = False Then encounterDateRange = CalculateSampleSetUnitMinMaxDates(sampleSetUnits)

                'Determine the number of seconds it took to perform the sample
                postSampleTime = CInt(Math.Ceiling((System.DateTime.Now - now).TotalSeconds))

                'Update the sampleset in the database
                UpdateSampleSetPostSample(sampleSetId, preSampleTime, postSampleTime, randomNumber, encounterDateRange)

                'Add Seeded Mailing encounters to the SampleSet
                Dim seed As ToBeSeeded = ToBeSeeded.GetBySurveyIDSampleDate(srvy.Id, startDate)
                If seed IsNot Nothing AndAlso Not seed.IsSeeded Then
                    'Add the seeds
                    SampleSetProvider.Instance.PopulateSeedMailingInfo(sampleSetId)
                End If

            Catch ex As Exception
                'We have encountered an error so delete the sampleset from the database and throw the error upstream.
                SampleSetProvider.Instance.Delete(sampleSetId)

                Throw

            End Try

            'Logging
            If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "Sampling Complete", String.Empty)
            End If

            Return sampleSetId

        End Function

        ''' <summary>
        ''' This method recalculates the outgo needed for all HCAHPS units based on the HCAHPS proportion calculated for that start date.
        ''' </summary>
        ''' <param name="sampleSetId">The ID for the SampleSet being executed.</param>
        ''' <param name="sampleSetUnits">The sample set unit dictionary being used for this sample.</param>
        ''' <param name="startDate">The starting date for the encounters being sampled.</param>
        ''' <param name="sampleHCAHPSUnit">Specifies whether or not we are sampling the HCAHPS unit.</param>
        ''' <remarks></remarks>
        Private Shared Sub RecalcDelayedOutGoNeeded(ByVal sampleSetId As Integer, ByVal sampleSetUnits As Dictionary(Of Integer, SampleSetUnit), _
                                                   ByVal startDate As Nullable(Of Date), ByVal sampleHCAHPSUnit As Boolean, ByVal period As SamplePeriod, srvy As Survey, ByRef SystematicIncrement As Integer)

            Dim strtDate As Date
            Dim medRecalc As MedicareRecalcHistory
            Dim medRecalcST As MedicareRecalcSurveyTypeHistory
            Dim eligibleEncounters As Integer
            Dim proportion As Decimal
            Dim updateSPW As Boolean

            'Determine the start date to use
            If startDate.HasValue Then
                strtDate = startDate.Value
            Else
                strtDate = Date.Now
            End If


            If srvy.IsSystematic Then 'OAS CAHPS block
                Dim SystematicOutgoSet As Dictionary(Of Integer, Dictionary(Of String, Object)) =
                    SampleSetProvider.Instance.SelectSystematicSamplingOutgo(sampleSetId, srvy.Id, strtDate)

                If Not (SystematicOutgoSet Is Nothing) Then
                    For Each unit As SampleSetUnit In sampleSetUnits.Values
                        updateSPW = False

                        If SystematicOutgoSet.ContainsKey(unit.SampUnit.Id) Then
                            Dim eligibleCount As Integer = Integer.Parse(SystematicOutgoSet(unit.SampUnit.Id)("EligibleCount").ToString)
                            Dim eligibleProportion As Double = Double.Parse(SystematicOutgoSet(unit.SampUnit.Id)("EligibleProportion").ToString)
                            Dim outgoNeeded As Integer = Integer.Parse(SystematicOutgoSet(unit.SampUnit.Id)("OutgoNeeded").ToString)

                            'This value is constant for all sample units (locations)
                            SystematicIncrement = Integer.Parse(SystematicOutgoSet(unit.SampUnit.Id)("Increment").ToString)

                            unit.OutGoNeeded = outgoNeeded

                            'Set the update flag
                            updateSPW = True
                        End If

                        'Update the SampleSetUnitTarget table
                        SampleSetProvider.Instance.UpdateSampleSetUnitTarget(sampleSetId, unit.SampUnit.Id, unit.OutGoNeeded, updateSPW)
                    Next
                    'Calculate increment as Total Eligible Count DIV Total Outgo Needed (integer quotient)

                End If
            Else
                If srvy.CheckMedicareProportion Then
                    'Find the CAHPS units
                    For Each unit As SampleSetUnit In sampleSetUnits.Values
                        'Modified 02-17-09 JJF - Fixed so it checks to see if the Survey is an HCAHPS survey as well as the unit itself
                        'If unit.SampUnit.IsHcahps Then
                        'If unit.SampUnit.IsHcahps AndAlso unit.SampUnit.Survey.SurveyTypeName.StartsWith("HCAHPS") Then
                        If (unit.SampUnit.CAHPSType > 0) Then
                            'Reset the update flag
                            updateSPW = False
                            If sampleHCAHPSUnit Then
                                'Determine if we are in a period that starts at or after the switch date Q408 (10/01/2008)
                                '  If not then we just leave things as they are
                                If period.ExpectedStartDate.HasValue Then 'AndAlso period.ExpectedStartDate.Value >= Nrc.Framework.BusinessLogic.Configuration.AppConfig.Params("SwitchToPropSamplingDate").DateValue Then
                                    'We need to get the appropriate proportion calculation
                                    If srvy.MedicareProportionBySurveyType Then
                                        medRecalcST = MedicareRecalcSurveyTypeHistory.GetLatestBySampleDate(unit.SampUnit.Facility.MedicareNumber.MedicareNumber, strtDate, srvy.SurveyType)
                                        SampleSetProvider.Instance.InsertSampleSetMedicareCalcLookup(sampleSetId, unit.SampUnit.Id, medRecalcST.MedicareReCalcLogId) 'TODO: new column? new proc?, new table?
                                        proportion = medRecalcST.ProportionCalcPct
                                    Else
                                        medRecalc = MedicareRecalcHistory.GetLatestBySampleDate(unit.SampUnit.Facility.MedicareNumber.MedicareNumber, strtDate)

                                        'Save the Medicare Recalc History ID used for this Sample Unit
                                        SampleSetProvider.Instance.InsertSampleSetMedicareCalcLookup(sampleSetId, unit.SampUnit.Id, medRecalc.MedicareReCalcLogId)

                                        'Determine the proportion to use
                                        If medRecalc.CensusForced Then
                                            proportion = 1
                                        Else
                                            proportion = medRecalc.ProportionCalcPct
                                        End If
                                    End If

                                    'Let's get the quantity of eligible encounters for this unit
                                    eligibleEncounters = SampleSetProvider.Instance.SelectHCAHPSEligibleEncountersBySampleSetID(sampleSetId, unit.SampUnit.Id)

                                    'Calculate the OutGoNeeded
                                    unit.OutGoNeeded = CInt(Decimal.Ceiling(eligibleEncounters * proportion))

                                    'Set the update flag
                                    updateSPW = True
                                End If
                            Else
                                'We are not sampling the HCAHPS unit so set the outgo needed to zero
                                unit.OutGoNeeded = 0
                            End If

                            'Update the SampleSetUnitTarget table
                            SampleSetProvider.Instance.UpdateSampleSetUnitTarget(sampleSetId, unit.SampUnit.Id, unit.OutGoNeeded, updateSPW)
                        End If
                    Next
                End If
            End If
        End Sub

        Private Shared Sub updateSamplePlanWorksheet(ByVal sampleSetId As Integer, ByVal samplesetUnits As Dictionary(Of Integer, SampleSetUnit))

            Dim minDate As Nullable(Of Date)
            Dim maxDate As Nullable(Of Date)

            'Logging
            If AppConfig.Params("SamplingLogEnabled").IntegerValue = 1 Then
                SampleSetProvider.Instance.InsertSamplingLog(sampleSetId, "UpdateSamplePlanWorksheet()", String.Empty)
            End If

            For Each unit As SampleSetUnit In samplesetUnits.Values
                'Get the total DQ Count 
                Dim dQCount As Integer = 0
                For Each dqRuleCount As Integer In unit.DQRules.Values
                    dQCount += dqRuleCount
                Next

                'Insert a record into SPWDQCounts for each DQ Rule
                For Each DQRuleId As Integer In unit.DQRules.Keys
                    SampleSetProvider.Instance.InsertDQRuleIntoSPWDQCounts(sampleSetId, unit.SampUnit.Id, DQRuleId, unit.DQRules.Item(DQRuleId))
                Next

                'Insert a record into SPWDQCounts for each Removed Rule
                'Don't Insert a record for None and DQRule
                For Each rule As RemovedRule In unit.RemovedRules.Keys
                    If rule <> RemovedRule.None AndAlso rule <> RemovedRule.DQRule Then
                        SampleSetProvider.Instance.InsertRemovedRulesIntoSPWDQCOUNTS(sampleSetId, unit.SampUnit.Id, rule, unit.RemovedRules.Item(rule))
                        dQCount += unit.RemovedRules.Item(rule)
                    End If
                Next

                If unit.MinSampledEncounterDate.HasValue Then minDate = unit.MinSampledEncounterDate
                If unit.MaxSampledEncounterDate.HasValue Then maxDate = unit.MaxSampledEncounterDate
                SampleSetProvider.Instance.UpdateSamplePlanWorksheet(sampleSetId, unit.SampUnit.Id, dQCount, unit.DirectSampleCount, unit.IndirectSampleCount, unit.UniverseCount, minDate, maxDate, unit.BadAddressCount, unit.BadPhoneCount, unit.HcaphsSampledCount)
            Next

        End Sub

        Private Shared Sub UpdateSampleSetPostSample(ByVal samplesetid As Integer, ByVal presampletime As Integer, ByVal postsampletime As Integer, ByVal seed As Integer, ByVal dateRange As Collection(Of Nullable(Of Date)))

            If dateRange Is Nothing Then
                SampleSetProvider.Instance.UpdateSampleSetPostSample(samplesetid, presampletime, postsampletime, seed, Nothing, Nothing)
            Else
                SampleSetProvider.Instance.UpdateSampleSetPostSample(samplesetid, presampletime, postsampletime, seed, dateRange.Item(0).Value, dateRange.Item(1).Value)
            End If

        End Sub

        Private Shared Sub InsertSampleDataSet(ByVal samplesetId As Integer, ByVal datasetId As Integer)

            SampleSetProvider.Instance.InsertSampleDataSet(samplesetId, datasetId)

        End Sub

        Private Shared Sub UpdatePeriods(ByVal samplesetId As Integer, ByVal periodId As Integer)

            SampleSetProvider.Instance.InsertSampleSetInPeriod(samplesetId, periodId)

        End Sub

        Private Shared Function CalculateSampleSetUnitMinMaxDates(ByVal samplesetUnits As Dictionary(Of Integer, SampleSetUnit)) As Collection(Of Nullable(Of Date))

            Dim minDate As Nullable(Of Date)
            Dim maxDate As Nullable(Of Date)

            Dim dates As New Collection(Of Nullable(Of Date))

            For Each unit As SampleSetUnit In samplesetUnits.Values
                'Initialize dates if they are null then check the value
                If unit.MinSampledEncounterDate.HasValue Then
                    If minDate.HasValue = False Then minDate = unit.MinSampledEncounterDate.Value
                    If unit.MinSampledEncounterDate.Value < minDate.Value Then minDate = unit.MinSampledEncounterDate.Value
                End If

                If unit.MaxSampledEncounterDate.HasValue Then
                    If maxDate.HasValue = False Then maxDate = unit.MaxSampledEncounterDate.Value
                    If unit.MaxSampledEncounterDate.Value > maxDate.Value Then maxDate = unit.MaxSampledEncounterDate.Value
                End If
            Next

            If minDate.HasValue Then dates.Add(minDate)
            If maxDate.HasValue Then dates.Add(maxDate)

            If dates.Count > 0 Then
                Return dates
            Else
                Return Nothing
            End If

        End Function

        ''' <summary>
        ''' This sub will loop through each pop record and sample it.  It will also call
        ''' methods that store information needed for the SPW.
        ''' </summary>
        ''' <param name="rdr"></param>
        ''' <remarks></remarks>
        Private Shared Sub ExecuteSample(ByVal encounterUnitEligibility_s As EncounterUnitEligibilityCollection, _
                                         ByVal sampleSetUnits As Dictionary(Of Integer, SampleSetUnit), ByVal encounterTableExists As Boolean, ByVal sampleSetId As Integer, ByVal srvy As Survey)

            Dim popID As Integer = 0
            Dim encID As Integer = 0
            Dim popRecord As New Pop
            Dim enc As New Encounter
            Dim encUnit As New EncounterUnit

            Try
                For Each encounterUE As EncounterUnitEligibility In encounterUnitEligibility_s 'While rdr.Read
                    Dim nextPop As Boolean
                    Dim nextEnc As Boolean

                    'Reset before reading next record
                    nextPop = False
                    nextEnc = False

                    'Determine if this is the next pop or encounter
                    nextPop = popID <> encounterUE.Pop_id 'rdr.GetInteger("pop_id")
                    If encounterTableExists Then
                        nextEnc = encID <> encounterUE.Id 'rdr.GetInteger("enc_id")
                    Else
                        'If no Encounter Table exists, then each now Pop is also a new Enc
                        nextEnc = nextPop
                    End If

                    If nextPop Then
                        'Before populating a new popRecord, process the previous one
                        If popRecord.ID <> 0 Then ExecuteIndividualSample(popRecord, sampleSetId, srvy)

                        'Create new Pop Record
                        popRecord = New Pop
                        popRecord.ID = encounterUE.Pop_id 'rdr.GetInteger("pop_id")
                        popRecord.StudyID = srvy.StudyId
                        popRecord.BadAddress = encounterUE.BitBadAddress 'rdr.GetBoolean("bitBadAddress")
                        popRecord.BadPhone = encounterUE.BitBadPhone 'rdr.GetBoolean("bitBadPhone")
                    End If

                    If nextEnc Then
                        'Create New Enc Record
                        enc = New Encounter
                        enc.PopRecord = popRecord
                        If encounterTableExists Then enc.ID = encounterUE.Id 'rdr.GetInteger("enc_id")
                        enc.EncounterDate = encounterUE.EncDate 'rdr.GetNullableDate("EncDate")
                        enc.ReportDate = encounterUE.ReportDate 'rdr.GetNullableDate("ReportDate")
                        enc.DQID = encounterUE.DQ_Bus_Rule 'rdr.GetInteger("DQ_Bus_Rule")
                        popRecord.Encounters.Add(enc)
                    End If

                    'Add the encounterUnit records
                    encUnit = New EncounterUnit
                    encUnit.SmpleSetUnit = sampleSetUnits.Item(encounterUE.Sampleunit_id) 'rdr.GetInteger("SampleUnit_id"))
                    If System.Enum.IsDefined(GetType(RemovedRule), encounterUE.Removed_Rule) Then 'rdr.GetInteger("Removed_Rule")) Then
                        encUnit.RemovedCode = DirectCast(encounterUE.Removed_Rule, RemovedRule) 'rdr.GetInteger("Removed_Rule"), RemovedRule)
                    End If

                    'Take action based on the removed rule value
                    If encUnit.RemovedCode <> RemovedRule.None Then
                        'Increment the removed rules count for the unit if the removed rule is not none
                        encUnit.SmpleSetUnit.RemovedRules(encUnit.RemovedCode) += 1
                        If encUnit.RemovedCode = RemovedRule.DQRule Then
                            encUnit.SmpleSetUnit.IncrementDQRuleCount(enc.DQID)
                        End If
                    Else
                        'Add to collections if removed rule is none
                        Select Case encUnit.SmpleSetUnit.SampUnit.SelectionType
                            Case SampleSelectionType.Exclusive
                                enc.ExclusiveEncounterUnits.Add(encUnit)
                            Case SampleSelectionType.MinorModule
                                enc.MinorModuleEncounterUnits.Add(encUnit)
                            Case SampleSelectionType.NonExclusive
                                enc.NonExclusiveEncounterUnits.Add(encUnit)
                        End Select
                    End If

                    'Increment the Universe Count for the unit that this encounter is for
                    'The universe count includes everyone, even people who have been removed
                    encUnit.SmpleSetUnit.UniverseCount += 1

                    popID = encounterUE.Pop_id 'rdr.GetInteger("pop_id")
                    encID = encounterUE.Id 'rdr.GetInteger("enc_id")

                    'End While

                Next 'For Each encounterUE In encounterUnitEligibility_s

                If popRecord.ID <> 0 Then
                    'Sample the last individual
                    ExecuteIndividualSample(popRecord, sampleSetId, srvy)
                End If

            Catch ex As Exception
                Throw

            End Try

        End Sub

        Private Shared Function PopulateSampleSetUnitList(ByVal unit As SampleUnit, ByVal parent As SampleSetUnit, ByVal sampleSetUnits As Dictionary(Of Integer, SampleSetUnit)) As SampleSetUnit

            Dim ssUnit As New SampleSetUnit

            ssUnit.SampUnit = unit
            ssUnit.ParentSampleUnit = parent
            sampleSetUnits.Add(ssUnit.SampUnit.Id, ssUnit)

            For Each childUnit As SampleUnit In unit.ChildUnits
                ssUnit.ChildSampleSetUnits.Add(PopulateSampleSetUnitList(childUnit, ssUnit, sampleSetUnits))
            Next

            Return ssUnit

        End Function

        ''' <summary>
        ''' This procedure will return a key value pair sampleunit Ids and samplesetunits.  
        ''' Each unit will reference its parent and children.  This set of items will be used
        ''' when we implement the sampling algorithm.  We will use it to traverse the tree, determine
        ''' outgo needed, evaluate priority, etc.
        ''' </summary>
        ''' <param name="survey"></param>
        ''' <param name="outGoList"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Private Shared Function BuildSampleUnitOutGoNeeded(ByVal survey As Survey, ByVal outGoList As Dictionary(Of Integer, Integer)) As Dictionary(Of Integer, SampleSetUnit)

            Dim units As Collection(Of SampleUnit) = SampleUnit.GetSampleUnitsBySurveyId(survey)
            Dim sampleSetUnits As New Dictionary(Of Integer, SampleSetUnit)

            For Each unit As SampleUnit In units
                'Find the root unit and then populate from it
                'There could be more than 1 root, so don't exit the loop
                'after finding the first
                If unit.ParentUnit Is Nothing Then
                    PopulateSampleSetUnitList(unit, Nothing, sampleSetUnits)
                End If
            Next

            'Add the outgo needed numbers
            For Each ssUnit As SampleSetUnit In sampleSetUnits.Values
                If outGoList.ContainsKey(ssUnit.SampUnit.Id) Then
                    ssUnit.OutGoNeeded = outGoList.Item(ssUnit.SampUnit.Id)
                Else
                    ssUnit.OutGoNeeded = 0
                End If
            Next

            Return sampleSetUnits

        End Function

        ''' <summary>
        ''' This sub will order the encounters and Encounter units
        ''' </summary>
        ''' <param name="popRecord"></param>
        ''' <remarks>Since we want the sort to be descending, we must call the sort method and 
        ''' then call the reverse method.</remarks>
        Private Shared Sub SortEncountersAndEncounterUnits(ByVal popRecord As Pop)
            'Order the encounters
            popRecord.Encounters.Sort()

            'Order the encounter units
            For Each enc As Encounter In popRecord.Encounters
                For Each encUnitList As List(Of EncounterUnit) In enc.EncounterUnitLists
                    encUnitList.Sort()
                Next
            Next
        End Sub

        ''' <summary>
        ''' This sub will order the encounters and encounter units, execute the sample,  update 
        ''' any count information needed for the SPW, and insert a record in the database
        ''' </summary>
        ''' <param name="popRecord"></param>
        ''' <remarks></remarks>
        Private Shared Sub ExecuteIndividualSample(ByVal popRecord As Pop, ByVal samplesetId As Integer, ByVal srvy As Survey)

            'Order the encounters and encounter units
            SortEncountersAndEncounterUnits(popRecord)

            Dim minNonExclusivePriority As Integer = Integer.MaxValue
            Dim minExclusivePriority As Integer = Integer.MaxValue
            Dim encIdToSample As Integer = -1

            'Steping through all encounters, starting with most current encounter (descending encounter date order)
            'Find the most current encounter with the highest priority nonexclusive unit to sample.
            'If no nonexclusive units exist on any encounters, find the most current exclusive unit with
            ' the highest priority still needing outgo to sample.
            For Each enc As Encounter In popRecord.Encounters
                'Searching for highest priority nonExclusive encounter still needing outgo
                For Each encUnit As EncounterUnit In enc.NonExclusiveEncounterUnits
                    If encUnit.RemovedCode = RemovedRule.None AndAlso encUnit.SmpleSetUnit.OutGoNeeded > 0 Then
                        If encUnit.SmpleSetUnit.SampUnit.Priority < minNonExclusivePriority Then
                            minNonExclusivePriority = encUnit.SmpleSetUnit.SampUnit.Priority
                            encIdToSample = enc.ID
                            If minNonExclusivePriority = 1 Then Exit For
                        End If
                    End If
                Next
                If minNonExclusivePriority = 1 Then Exit For

                'No nonExclusive encounter found yet so check for highest priority exclusive still needing outgo
                If minNonExclusivePriority = Integer.MaxValue Then
                    For Each encUnit As EncounterUnit In enc.ExclusiveEncounterUnits
                        If encUnit.RemovedCode = RemovedRule.None AndAlso encUnit.SmpleSetUnit.OutGoNeeded > 0 Then
                            If encUnit.SmpleSetUnit.SampUnit.Priority < minExclusivePriority Then
                                minExclusivePriority = encUnit.SmpleSetUnit.SampUnit.Priority
                                encIdToSample = enc.ID
                                If minExclusivePriority = 1 Then Exit For
                            End If
                        End If
                    Next
                End If
            Next

            'Encounter found to sample, now loop through all encounters and process them.
            For Each enc As Encounter In popRecord.Encounters
                If enc.ID = encIdToSample Then
                    'Apply SamplingAlgorithm for NonExclusive Units
                    ExecuteNonExclusiveUnitSample(enc)

                    'Apply SamplingAlgorithm for Exclusive Units
                    ExecuteExclusiveUnitSample(enc, samplesetId)

                    'Apply SamplingAlgorithm for MinorModule Units
                    If enc.IsSampled Then ExecuteMinorModuleUnitSample(enc)

                    popRecord.IsSampled = enc.IsSampled

                Else
                    'Set all removed rules to Excluded Encounter if another encounter has already
                    'been sampled
                    enc.SetExcludedEncountersRemovedRule(samplesetId)
                End If

                'Finalize
                enc.FinalizeEncounter(samplesetId)
            Next

        End Sub

        ''' <summary>
        ''' This sub will sample the NonExclusive Units
        ''' </summary>
        ''' <param name="enc"></param>
        ''' <remarks>We do not have to do a descendant sample because 
        ''' Non exclusive units cannot have children.</remarks>
        Private Shared Sub ExecuteNonExclusiveUnitSample(ByVal enc As Encounter)
            For Each encUnit As EncounterUnit In enc.NonExclusiveEncounterUnits
                If encUnit.RemovedCode = RemovedRule.None AndAlso encUnit.SmpleSetUnit.OutGoNeeded > 0 Then
                    encUnit.SelectionType = UnitSelectType.Direct
                    If encUnit.SmpleSetUnit.SampUnit.IsHcahps Then enc.IsSampledForHcahps = True
                    enc.IsSampled = True
                    ExecuteAncestralSample(encUnit.SmpleSetUnit.ParentSampleUnit, enc)
                    'We can only sample for 1 nonexclusive unit so exit
                    Exit For
                End If
            Next
        End Sub

        ''' <summary>
        ''' This sub samples Exclusive Units
        ''' </summary>
        ''' <param name="enc"></param>
        ''' <remarks></remarks>
        Private Shared Sub ExecuteExclusiveUnitSample(ByVal enc As Encounter, ByVal samplesetId As Integer)
            For Each encUnit As EncounterUnit In enc.ExclusiveEncounterUnits
                If encUnit.RemovedCode = RemovedRule.None AndAlso encUnit.SmpleSetUnit.OutGoNeeded > 0 Then
                    encUnit.SelectionType = UnitSelectType.Direct
                    If encUnit.SmpleSetUnit.SampUnit.IsHcahps Then enc.IsSampledForHcahps = True
                    enc.IsSampled = True
                    ExecuteAncestralSample(encUnit.SmpleSetUnit.ParentSampleUnit, enc)
                    ExecuteDescendantSample(encUnit.SmpleSetUnit, enc, samplesetId)
                    Exit For
                End If
            Next
        End Sub

        ''' <summary>
        ''' This sub samples minor module units
        ''' </summary>
        ''' <param name="enc"></param>
        ''' <remarks>A minor module unit can only be sampled if one or more of its siblings
        ''' where sampled.</remarks>
        Private Shared Sub ExecuteMinorModuleUnitSample(ByVal enc As Encounter)
            If enc.MinorModuleEncounterUnits.Count = 0 Then Exit Sub

            Dim sampledUnits As New Collection(Of Integer)

            'Populate a Collection with all sampled Units.
            For Each unit As EncounterUnit In enc.NonExclusiveEncounterUnits
                If unit.SelectionType <> UnitSelectType.None Then sampledUnits.Add(unit.SmpleSetUnit.SampUnit.Id)
            Next
            For Each unit As EncounterUnit In enc.ExclusiveEncounterUnits
                If unit.SelectionType <> UnitSelectType.None Then sampledUnits.Add(unit.SmpleSetUnit.SampUnit.Id)
            Next

            'Loop through each minor module unit to see if it has a sibling that was sampled
            For Each encUnit As EncounterUnit In enc.MinorModuleEncounterUnits
                If encUnit.RemovedCode = RemovedRule.None Then
                    Dim siblingSampled As Boolean = False

                    'Get a dictionary of siblings that have been sampled
                    For Each unit As SampleSetUnit In encUnit.SmpleSetUnit.ParentSampleUnit.ChildSampleSetUnits
                        If sampledUnits.Contains(unit.SampUnit.Id) Then
                            siblingSampled = True
                            Exit For
                        End If
                    Next

                    If siblingSampled Then
                        encUnit.SelectionType = UnitSelectType.Indirect
                    End If
                End If
            Next
        End Sub

        ''' <summary>
        ''' This sub will the parent unit for the unit indicated.
        ''' The parent unit must be an exclusive unit, and must not already be sampled
        ''' If the child unit still needs outgo, mark it as direct.  If it does not need
        ''' outgo, mark it as indirect
        ''' </summary>
        ''' <param name="parentUnit"></param>
        ''' <param name="enc"></param>
        ''' <remarks></remarks>
        Private Shared Sub ExecuteAncestralSample(ByVal parentUnit As SampleSetUnit, ByVal enc As Encounter)

            If parentUnit IsNot Nothing Then
                'Find the EncounterUnit record for this parnentunit and sample it if it's not already sampled
                For Each encUnit As EncounterUnit In enc.ExclusiveEncounterUnits
                    If encUnit.SmpleSetUnit.SampUnit.Id = parentUnit.SampUnit.Id Then
                        If encUnit.SelectionType = UnitSelectType.None Then
                            If encUnit.SmpleSetUnit.OutGoNeeded > 0 Then
                                encUnit.SelectionType = UnitSelectType.Direct
                                If encUnit.SmpleSetUnit.SampUnit.IsHcahps Then enc.IsSampledForHcahps = True
                            Else
                                encUnit.SelectionType = UnitSelectType.Indirect
                            End If
                        End If
                        Exit For
                    End If
                Next
                ExecuteAncestralSample(parentUnit.ParentSampleUnit, enc)
            End If
        End Sub

        ''' <summary>
        ''' This sub will sample 1 child unit for the unit indicated.
        ''' The child unit must be an exclusive unit.
        ''' If the child unit still needs outgo, mark it as direct.  If it does not need
        ''' outgo, mark it as indirect
        ''' </summary>
        ''' <param name="sampledUnit"></param>
        ''' <param name="enc"></param>
        ''' <remarks></remarks>

        Private Shared Sub ExecuteDescendantSample(ByVal sampledUnit As SampleSetUnit, ByVal enc As Encounter, ByVal samplesetId As Integer)
            If sampledUnit.ChildSampleSetUnits.Count = 0 Then Exit Sub

            Dim childUnits As New Dictionary(Of Integer, SampleSetUnit)
            Dim isSiblingSelected As Boolean = False

            For Each unit As SampleSetUnit In sampledUnit.ChildSampleSetUnits
                childUnits.Add(unit.SampUnit.Id, unit)
            Next

            If childUnits.Count > 0 Then
                'Find the highest Priority Child unit and sample it
                'Non-Exclusive Units don't have children, so don't check them
                'Minor Modules aren't evaluated until the end so don't check them
                For Each encUnit As EncounterUnit In enc.ExclusiveEncounterUnits
                    'Check to see if the EncounterUnit is a child unit
                    'We need to loop through all units so we can set the removed rule after
                    '1 unit is sampled on all other units
                    If childUnits.ContainsKey(encUnit.SmpleSetUnit.SampUnit.Id) Then
                        If isSiblingSelected = False Then
                            Dim childUnit As SampleSetUnit = childUnits.Item(encUnit.SmpleSetUnit.SampUnit.Id)
                            If encUnit.RemovedCode = RemovedRule.None Then
                                encUnit.SelectionType = UnitSelectType.Direct
                                If encUnit.SmpleSetUnit.SampUnit.IsHcahps Then enc.IsSampledForHcahps = True
                                isSiblingSelected = True
                                ExecuteDescendantSample(childUnit, enc, samplesetId)
                            End If
                        Else
                            encUnit.RemovedCode = RemovedRule.SecondarySampleRemoval
                            SampleSetProvider.Instance.InsertSampleSetExclusionLog(encUnit.SmpleSetUnit.SampUnit.SurveyId, samplesetId, encUnit.SmpleSetUnit.SampUnit.Id, enc.PopRecord.ID, enc.ID, RemovedRule.SecondarySampleRemoval)
                        End If
                    End If
                Next
            End If
        End Sub

#End Region

#Region "Private Classes"

        ''' <summary>
        ''' The sampleSetUnit Class contains information about the state of a unit during the sampling process.
        ''' </summary>
        ''' <remarks></remarks>
        Private Class SampleSetUnit

#Region "Demographic Information Fields"

            Private mSampleUnit As SampleUnit
            Private mParentSampleUnit As SampleSetUnit
            Private mChildSampleSetUnits As New Collection(Of SampleSetUnit)

#End Region

#Region "Sampling Specific Fields"

            Private mOutGoNeeded As Integer
            Private mDQRules As New Dictionary(Of Integer, Integer) 'The first integer is the DQRuleId, the second is the count
            Private mRemovedRules As New Dictionary(Of RemovedRule, Integer)
            Private mDirectSampleCount As Integer
            Private mIndirectSampleCount As Integer
            Private mUniverseCount As Integer
            Private mBadAddressCount As Integer
            Private mBadPhoneCount As Integer
            Private mHcahpsDirectSampledCount As Integer
            Private mMinSampledEncounterDate As Nullable(Of Date)
            Private mMaxSampledEncounterDate As Nullable(Of Date)

#End Region

#Region "Public Properties"

            ''' <summary>
            ''' This is a count of the number of people sampled who were also sampled for an HCAHPS unit
            ''' </summary>
            ''' <value></value>
            ''' <returns></returns>
            ''' <remarks></remarks>
            Public Property HcaphsSampledCount() As Integer
                Get
                    Return mHcahpsDirectSampledCount
                End Get
                Set(ByVal value As Integer)
                    mHcahpsDirectSampledCount = value
                End Set
            End Property

            Public Property BadPhoneCount() As Integer
                Get
                    Return mBadPhoneCount
                End Get
                Set(ByVal value As Integer)
                    mBadPhoneCount = value
                End Set
            End Property

            Public Property BadAddressCount() As Integer
                Get
                    Return mBadAddressCount
                End Get
                Set(ByVal value As Integer)
                    mBadAddressCount = value
                End Set
            End Property

            Public Property MaxSampledEncounterDate() As Nullable(Of Date)
                Get
                    Return mMaxSampledEncounterDate
                End Get
                Set(ByVal value As Nullable(Of Date))
                    mMaxSampledEncounterDate = value
                End Set
            End Property

            Public Property MinSampledEncounterDate() As Nullable(Of Date)
                Get
                    Return mMinSampledEncounterDate
                End Get
                Set(ByVal value As Nullable(Of Date))
                    mMinSampledEncounterDate = value
                End Set
            End Property

            Public ReadOnly Property ChildSampleSetUnits() As Collection(Of SampleSetUnit)
                Get
                    Return mChildSampleSetUnits
                End Get
            End Property

            Public Property ParentSampleUnit() As SampleSetUnit
                Get
                    Return mParentSampleUnit
                End Get
                Set(ByVal value As SampleSetUnit)
                    mParentSampleUnit = value
                End Set
            End Property

            Public Property UniverseCount() As Integer
                Get
                    Return mUniverseCount
                End Get
                Set(ByVal value As Integer)
                    mUniverseCount = value
                End Set
            End Property

            Public Property IndirectSampleCount() As Integer
                Get
                    Return mIndirectSampleCount
                End Get
                Set(ByVal value As Integer)
                    mIndirectSampleCount = value
                End Set
            End Property

            Public Property DirectSampleCount() As Integer
                Get
                    Return mDirectSampleCount
                End Get
                Set(ByVal value As Integer)
                    mDirectSampleCount = value
                End Set
            End Property

            Public ReadOnly Property RemovedRules() As Dictionary(Of RemovedRule, Integer)
                Get
                    If mRemovedRules.Count = 0 Then
                        For Each Rule As RemovedRule In System.Enum.GetValues(GetType(RemovedRule))
                            mRemovedRules.Add(Rule, 0)
                        Next
                    End If
                    Return mRemovedRules
                End Get
            End Property

            ''' <summary>
            ''' The first item is the DQ Rule Id, and the second is the count
            ''' </summary>
            ''' <value></value>
            ''' <returns>If you need to increment the count for a DQRule you should
            ''' use IncrementDQRuleCount.  Do not try to directly increment the Dictionary.
            ''' The dictionary may not include the DQRule you are trying to increment.</returns>
            ''' <remarks></remarks>
            Public ReadOnly Property DQRules() As Dictionary(Of Integer, Integer)
                Get
                    Return mDQRules
                End Get
            End Property

            Public Property OutGoNeeded() As Integer
                Get
                    Return mOutGoNeeded
                End Get
                Set(ByVal value As Integer)
                    mOutGoNeeded = value
                End Set
            End Property

            Public Property SampUnit() As SampleUnit
                Get
                    Return mSampleUnit
                End Get
                Set(ByVal value As SampleUnit)
                    mSampleUnit = value
                End Set
            End Property

            Public Sub IncrementDQRuleCount(ByVal DQRuleId As Integer)

                If mDQRules.ContainsKey(DQRuleId) = False Then mDQRules.Add(DQRuleId, 0)
                mDQRules(DQRuleId) += 1

            End Sub

#End Region

        End Class

        ''' <summary>
        ''' The EncounterUnit structure contains information about a specific unit that an encounter is 
        ''' eligible for.
        ''' </summary>
        ''' <remarks></remarks>
        Private Class EncounterUnit
            Implements IComparable(Of EncounterUnit)

            Private Const UnitTypePriorityMultiplier As Integer = 100000000
            Private Const SampleUnitPriorityMultiplier As Integer = 10000

            Private mSampleSetUnit As SampleSetUnit
            Private mRemovedCode As RemovedRule
            Private mSelectionType As UnitSelectType
            Private mRandomNumber As Integer
            Private mRelativePriority As Integer

            Public Sub New()

                Randomize()
                mRandomNumber = CInt(System.Math.Round(Rnd() * (SampleUnitPriorityMultiplier - 1), 0))

            End Sub

            Public ReadOnly Property RelativePriority() As Integer
                Get
                    If mRelativePriority = Nothing Then mRelativePriority = (UnitTypePriorityMultiplier * UnitType) + (SampleUnitPriorityMultiplier * mSampleSetUnit.SampUnit.Priority) + (mRandomNumber Mod 1000)
                    Return mRelativePriority
                End Get
            End Property

            Public ReadOnly Property UnitType() As SampleSelectionType
                Get
                    Return mSampleSetUnit.SampUnit.SelectionType
                End Get
            End Property

            Public Property RemovedCode() As RemovedRule
                Get
                    Return mRemovedCode
                End Get
                Set(ByVal value As RemovedRule)
                    mRemovedCode = value
                End Set
            End Property

            Public Property SelectionType() As UnitSelectType
                Get
                    Return mSelectionType
                End Get
                Set(ByVal value As UnitSelectType)

                    'Update counts based on what the old and new values are
                    Select Case value
                        Case UnitSelectType.Direct
                            Select Case mSelectionType
                                Case UnitSelectType.Indirect
                                    Me.mSampleSetUnit.DirectSampleCount += 1
                                    Me.mSampleSetUnit.OutGoNeeded -= 1
                                    Me.mSampleSetUnit.IndirectSampleCount -= 1
                                Case UnitSelectType.None
                                    Me.mSampleSetUnit.DirectSampleCount += 1
                                    Me.mSampleSetUnit.OutGoNeeded -= 1
                            End Select
                        Case UnitSelectType.Indirect
                            Select Case mSelectionType
                                Case UnitSelectType.Direct
                                    Me.mSampleSetUnit.DirectSampleCount -= 1
                                    Me.mSampleSetUnit.OutGoNeeded += 1
                                    Me.mSampleSetUnit.IndirectSampleCount += 1
                                Case UnitSelectType.None
                                    Me.mSampleSetUnit.IndirectSampleCount += 1
                            End Select
                        Case UnitSelectType.None
                            Select Case mSelectionType
                                Case UnitSelectType.Direct
                                    Me.mSampleSetUnit.DirectSampleCount -= 1
                                    Me.mSampleSetUnit.OutGoNeeded += 1
                                Case UnitSelectType.Indirect
                                    Me.mSampleSetUnit.IndirectSampleCount -= 1
                            End Select
                    End Select
                    mSelectionType = value

                End Set
            End Property

            Public Property SmpleSetUnit() As SampleSetUnit
                Get
                    Return mSampleSetUnit
                End Get
                Set(ByVal value As SampleSetUnit)
                    mSampleSetUnit = value
                End Set
            End Property

            Private Function CompareTo(ByVal other As EncounterUnit) As Integer Implements IComparable(Of EncounterUnit).CompareTo

                Return RelativePriority.CompareTo(other.RelativePriority)

            End Function

            Public Sub InsertSelectedSample(ByVal sampleSetId As Integer, ByVal popId As Integer, ByVal studyId As Integer, ByVal encID As Integer, ByVal encounterDate As Nullable(Of Date), ByVal reportDate As Nullable(Of Date))

                If Me.mSelectionType <> UnitSelectType.None Then
                    SampleSetProvider.Instance.InsertSelectedSample(sampleSetId, studyId, popId, Me.SmpleSetUnit.SampUnit.Id, Me.SelectionType, encID, encounterDate, reportDate)
                End If

            End Sub

        End Class

        ''' <summary>
        ''' This class contains information about an pop record used during sampling
        ''' </summary>
        ''' <remarks></remarks>
        Private Class Pop

            Private mID As Integer
            Private mStudyId As Integer
            Private mEncounters As New List(Of Encounter)
            Private mBadAddress As Boolean
            Private mBadPhone As Boolean
            Private mNeedsSamplePopRecordAdded As Boolean = True
            Private mIsSampled As Boolean

            Public Property IsSampled() As Boolean
                Get
                    Return mIsSampled
                End Get
                Set(ByVal value As Boolean)
                    mIsSampled = value
                End Set
            End Property

            Public ReadOnly Property NeedsSamplePopRecordAdded() As Boolean
                Get
                    Return mNeedsSamplePopRecordAdded
                End Get
            End Property

            Public Property BadPhone() As Boolean
                Get
                    Return mBadPhone
                End Get
                Set(ByVal value As Boolean)
                    mBadPhone = value
                End Set
            End Property

            Public Property BadAddress() As Boolean
                Get
                    Return mBadAddress
                End Get
                Set(ByVal value As Boolean)
                    mBadAddress = value
                End Set
            End Property

            Public ReadOnly Property Encounters() As List(Of Encounter)
                Get
                    Return mEncounters
                End Get
            End Property

            Public Property ID() As Integer
                Get
                    Return mID
                End Get
                Set(ByVal value As Integer)
                    mID = value
                End Set
            End Property

            Public Property StudyID() As Integer
                Get
                    Return mStudyId
                End Get
                Set(ByVal value As Integer)
                    mStudyId = value
                End Set
            End Property

            Public Sub InsertSamplePop(ByVal samplesetId As Integer)

                SampleSetProvider.Instance.InsertSamplePop(samplesetId, Me.StudyID, Me.ID, Me.BadAddress, Me.BadPhone)
                Me.mNeedsSamplePopRecordAdded = False

            End Sub

        End Class

        ''' <summary>
        ''' This class contains information about an encounter used during sampling
        ''' </summary>
        ''' <remarks></remarks>
        Private Class Encounter
            Implements IComparable(Of Encounter)

            Private mID As Integer
            Private mDQID As Integer
            Private mEncounterDate As Nullable(Of Date)
            Private mReportDate As Nullable(Of Date)
            Private mExclusiveEncounterUnits As New List(Of EncounterUnit)
            Private mNonExclusiveEncounterUnits As New List(Of EncounterUnit)
            Private mMinorModuleEncounterUnits As New List(Of EncounterUnit)
            Private mMinPriority As Integer = Integer.MaxValue
            Private mEncounterUnitLists As New List(Of List(Of EncounterUnit))
            Private mIsSampled As Boolean
            Private mIsSampledForHcahps As Boolean

            Public Sub New()

                mEncounterUnitLists.Add(mNonExclusiveEncounterUnits)
                mEncounterUnitLists.Add(mExclusiveEncounterUnits)
                mEncounterUnitLists.Add(mMinorModuleEncounterUnits)

            End Sub

            Private mPopRecord As Pop
            Public Property PopRecord() As Pop
                Get
                    Return mPopRecord
                End Get
                Set(ByVal value As Pop)
                    mPopRecord = value
                End Set
            End Property

            Public Property IsSampled() As Boolean
                Get
                    Return mIsSampled
                End Get
                Set(ByVal value As Boolean)
                    mIsSampled = value
                End Set
            End Property

            Public Property IsSampledForHcahps() As Boolean
                Get
                    Return mIsSampledForHcahps
                End Get
                Set(ByVal value As Boolean)
                    mIsSampledForHcahps = value
                End Set
            End Property

            Public ReadOnly Property EncounterUnitLists() As List(Of List(Of EncounterUnit))
                Get
                    Return mEncounterUnitLists
                End Get
            End Property

            'Public ReadOnly Property MinPriority() As Integer
            '    Get
            '        For Each encUnitList As List(Of EncounterUnit) In mEncounterUnitLists
            '            For Each encUnit As EncounterUnit In encUnitList
            '                If mMinPriority > encUnit.RelativePriority Then mMinPriority = encUnit.RelativePriority
            '            Next
            '        Next
            '        Return mMinPriority
            '    End Get
            'End Property

            Public ReadOnly Property MinPriority() As Integer
                Get
                    For Each encUnit As EncounterUnit In mNonExclusiveEncounterUnits
                        If mMinPriority > encUnit.SmpleSetUnit.SampUnit.Priority Then mMinPriority = encUnit.SmpleSetUnit.SampUnit.Priority
                    Next
                    Return mMinPriority
                End Get
            End Property

            Public ReadOnly Property ExclusiveEncounterUnits() As List(Of EncounterUnit)
                Get
                    Return mExclusiveEncounterUnits
                End Get
            End Property

            Public ReadOnly Property NonExclusiveEncounterUnits() As List(Of EncounterUnit)
                Get
                    Return mNonExclusiveEncounterUnits
                End Get
            End Property

            Public ReadOnly Property MinorModuleEncounterUnits() As List(Of EncounterUnit)
                Get
                    Return mMinorModuleEncounterUnits
                End Get
            End Property

            Public Property EncounterDate() As Nullable(Of Date)
                Get
                    Return mEncounterDate
                End Get
                Set(ByVal value As Nullable(Of Date))
                    mEncounterDate = value
                End Set
            End Property

            Public Property ReportDate() As Nullable(Of Date)
                Get
                    Return mReportDate
                End Get
                Set(ByVal value As Nullable(Of Date))
                    mReportDate = value
                End Set
            End Property

            Public Property DQID() As Integer
                Get
                    Return mDQID
                End Get
                Set(ByVal value As Integer)
                    mDQID = value
                End Set
            End Property

            Public Property ID() As Integer
                Get
                    Return mID
                End Get
                Set(ByVal value As Integer)
                    mID = value
                End Set
            End Property

            Private Function CompareTo(ByVal other As Encounter) As Integer Implements IComparable(Of Encounter).CompareTo

                'Return MinPriority.CompareTo(other.MinPriority)

                'Default null encounter dates to 1/1/1900
                Dim encDate As New Date(1900, 1, 1)
                If Me.EncounterDate.HasValue Then encDate = Me.EncounterDate.Value

                Dim otherEncDate As New Date(1900, 1, 1)
                If other.EncounterDate.HasValue Then otherEncDate = other.EncounterDate.Value

                Dim result As Integer
                If encDate = otherEncDate Then
                    result = Me.ID.CompareTo(other.ID)
                Else
                    result = encDate.CompareTo(otherEncDate)
                End If

                Return -result  'return descending

            End Function

            Public Sub SetExcludedEncountersRemovedRule(ByVal samplesetId As Integer)

                For Each encUnitList As List(Of EncounterUnit) In Me.EncounterUnitLists
                    For Each encUnit As EncounterUnit In encUnitList
                        If encUnit.RemovedCode = RemovedRule.None AndAlso encUnit.SmpleSetUnit.OutGoNeeded > 0 Then
                            encUnit.RemovedCode = RemovedRule.ExcludedEncounter
                            SampleSetProvider.Instance.InsertSampleSetExclusionLog(encUnit.SmpleSetUnit.SampUnit.SurveyId, samplesetId, encUnit.SmpleSetUnit.SampUnit.Id, Me.PopRecord.ID, Me.ID, RemovedRule.ExcludedEncounter)
                        End If
                    Next
                Next

            End Sub

            Public Sub FinalizeEncounter(ByVal samplesetId As Integer)

                For Each unitTypeList As List(Of EncounterUnit) In Me.EncounterUnitLists
                    For Each encUnit As EncounterUnit In unitTypeList
                        If encUnit.RemovedCode <> RemovedRule.None Then
                            'Increment the removed rules count for the unit
                            encUnit.SmpleSetUnit.RemovedRules(encUnit.RemovedCode) += 1
                        End If

                        'Increment the isHcahpsSampled count if necessary
                        If Me.IsSampledForHcahps AndAlso encUnit.SelectionType <> UnitSelectType.None Then encUnit.SmpleSetUnit.HcaphsSampledCount += 1

                        'Increment the badPhone and badAddress counts if necessary
                        If encUnit.SelectionType <> UnitSelectType.None AndAlso Me.PopRecord.BadAddress Then encUnit.SmpleSetUnit.BadAddressCount += 1
                        If encUnit.SelectionType <> UnitSelectType.None AndAlso Me.PopRecord.BadPhone Then encUnit.SmpleSetUnit.BadPhoneCount += 1

                        'Insert into the Database.  The method encUnit.InsertSampledRecord
                        'will only do an insert if the unit was sampled.
                        encUnit.InsertSelectedSample(samplesetId, PopRecord.ID, PopRecord.StudyID, Me.ID, Me.EncounterDate, Me.ReportDate)
                        'Add a record to samplepop if needed.
                        If Me.PopRecord.NeedsSamplePopRecordAdded AndAlso encUnit.SelectionType <> UnitSelectType.None Then Me.PopRecord.InsertSamplePop(samplesetId)

                        'Update the min and max sample dates for the units this encounter was selected for
                        If Me.IsSampled AndAlso encUnit.SelectionType <> UnitSelectType.None AndAlso Me.EncounterDate.HasValue Then
                            If (encUnit.SmpleSetUnit.MinSampledEncounterDate.HasValue = False) OrElse (Me.EncounterDate.Value < encUnit.SmpleSetUnit.MinSampledEncounterDate.Value) Then encUnit.SmpleSetUnit.MinSampledEncounterDate = Me.EncounterDate.Value
                            If (encUnit.SmpleSetUnit.MaxSampledEncounterDate.HasValue = False) OrElse (Me.EncounterDate.Value > encUnit.SmpleSetUnit.MaxSampledEncounterDate.Value) Then encUnit.SmpleSetUnit.MaxSampledEncounterDate = Me.EncounterDate.Value
                        End If
                    Next
                Next
            End Sub

        End Class

#End Region

    End Class

End Class
