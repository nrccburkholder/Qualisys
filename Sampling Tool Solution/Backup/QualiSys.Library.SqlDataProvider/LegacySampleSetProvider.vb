Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class LegacySampleSetProvider
    Inherits Nrc.QualiSys.Library.DataProvider.LegacySampleSetProvider

    Private mLegacySamplesetConnection As SqlClient.SqlConnection

    Public Overrides Sub OpenLegacySamplesetConnection()
        If mLegacySamplesetConnection Is Nothing Then
            mLegacySamplesetConnection = CType(Db.CreateConnection, SqlClient.SqlConnection)
            mLegacySamplesetConnection.Open()
        End If
    End Sub

    Public Overrides Sub CloseLegacySamplesetConnection()
        If Not mLegacySamplesetConnection Is Nothing Then
            mLegacySamplesetConnection.Close()
            mLegacySamplesetConnection = Nothing
        End If
    End Sub

    Private Function StoredProcCommandWrapper(ByVal StoredProcedureName As String, ByVal ParamArray parameters() As Object) As SqlClient.SqlCommand
        Dim sqlSyntax As New System.Text.StringBuilder
        Dim cmd As New SqlClient.SqlCommand
        Dim param As SqlClient.SqlParameter
        Dim i As Integer = 0
        cmd.Connection = mLegacySamplesetConnection
        Dim command As DBCommand = Db.GetStoredProcCommand(SP.GetParameters, StoredProcedureName)

        Using rdr As New SafeDataReader(ExecuteReader(command))
            While rdr.Read
                param = New SqlClient.SqlParameter
                param.Value = parameters(i)
                Select Case rdr.GetString("paramType")
                    Case "int", "bigint", "tinyint"
                        param.DbType = DbType.Int64
                    Case "varchar", "char", "nvarchar"
                        param.DbType = DbType.String
                    Case "bit"
                        param.DbType = DbType.Boolean
                End Select
                param.ParameterName = rdr.GetString("paramName")
                cmd.Parameters.Add(param)
                i += 1
            End While
        End Using
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = StoredProcedureName
        cmd.CommandTimeout = AppConfig.SqlTimeout

        Return cmd
    End Function


    Public Overrides Sub ExecutePreSample(ByVal surveyId As Integer, ByVal dataset_Id As String, ByVal fromDate As Nullable(Of Date), ByVal toDate As Nullable(Of Date))
        Dim cmd As SqlClient.SqlCommand
        If fromDate.HasValue And Not toDate.HasValue Then Throw New Exception("Min date without a max date.")
        If Not fromDate.HasValue And toDate.HasValue Then Throw New Exception("Max date without a min date.")

        If fromDate.HasValue And toDate.HasValue Then
            cmd = StoredProcCommandWrapper(SP.ExecutePreSample, surveyId, dataset_Id, fromDate.Value.ToShortDateString, toDate.Value.ToShortDateString)
        Else
            cmd = StoredProcCommandWrapper(SP.ExecutePreSample, surveyId, dataset_Id, DBNull.Value, DBNull.Value)
        End If
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecutePopulateSampleUnitUniverse(ByVal studyId As Integer, ByVal surveyId As Integer, ByVal datasetId As String, ByVal popEnc As String, ByVal bigViewJoin As String, ByVal hhField As String)
        Dim cmd As SqlClient.SqlCommand
        If hhField Is Nothing Then
            cmd = StoredProcCommandWrapper(SP.ExecutePopulateSampleUnitUniverse, studyId, surveyId, datasetId, popEnc, bigViewJoin, DBNull.Value)
        Else
            cmd = StoredProcCommandWrapper(SP.ExecutePopulateSampleUnitUniverse, studyId, surveyId, datasetId, popEnc, bigViewJoin, hhField)
        End If
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecutePopulateSampleUnitUniverse(ByVal studyId As Integer, ByVal surveyId As Integer, ByVal datasetId As String, ByVal popEnc As String, ByVal bigViewJoin As String)
        ExecutePopulateSampleUnitUniverse(studyId, surveyId, datasetId, popEnc, bigViewJoin, Nothing)
    End Sub

    Public Overrides Function ExecuteAddSampleSet(ByVal surveyId As Integer, ByVal employeeId As Integer, ByVal fromDate As Nullable(Of Date), ByVal toDate As Nullable(Of Date), ByVal periodId As Integer, ByVal isOverSample As Boolean, ByVal isNewPeriod As Boolean, ByVal surveyTypeID As Integer) As Integer
        If fromDate.HasValue And Not toDate.HasValue Then Throw New Exception("Min date without a max date.")
        If Not fromDate.HasValue And toDate.HasValue Then Throw New Exception("Max date without a min date.")

        Dim cmd As SqlClient.SqlCommand
        If fromDate.HasValue And toDate.HasValue Then
            cmd = StoredProcCommandWrapper(SP.ExecuteAddSampleSet, surveyId, employeeId, fromDate.Value.ToShortDateString, toDate.Value.ToShortDateString, isOverSample, isNewPeriod, periodId, surveyTypeID)
        Else
            cmd = StoredProcCommandWrapper(SP.ExecuteAddSampleSet, surveyId, employeeId, DBNull.Value, DBNull.Value, isOverSample, isNewPeriod, periodId, surveyTypeID)
        End If
        Using rdr As New SafeDataReader(cmd.ExecuteReader)
            If rdr.Read Then
                Return rdr.GetInteger("intSampleSet_id")
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Sub ExecuteInitializeBusinessRules(ByVal surveyId As Integer, ByRef minorExceptionCriteriaId As Integer, ByRef newBornRuleCriteriaId As Integer, _
                                        ByRef minorExceptionCriteria As String, ByRef newBornRuleCriteria As String)

        Dim lArrayCount As Integer
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteInitializeBusinessRules, surveyId)

        lArrayCount = 0
        Using rdr As New SafeDataReader(cmd.ExecuteReader)
            While rdr.Read
                Select Case rdr.GetString("BusRule_cd")
                    Case "S"
                        'Do Nothing  We don't use these anymore
                    Case "M"
                        minorExceptionCriteriaId = rdr.GetInteger("CriteriaStmt_id")
                        minorExceptionCriteria = rdr.GetString("strCriteriaString")
                    Case "B"
                        newBornRuleCriteriaId = rdr.GetInteger("CriteriaStmt_id")
                        newBornRuleCriteria = rdr.GetString("strCriteriaString")
                    Case "Q"
                        'Do Nothing  These are DQ Rules, and they are already evaluated
                End Select
            End While
        End Using

    End Sub

    Public Overrides Function ExecuteEncounterTableExists(ByVal surveyId As Integer) As Boolean
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteEncounterTableExists, surveyId)
        Return CBool(cmd.ExecuteScalar)
    End Function

    Public Overrides Sub ExecuteFetchSurveyValues(ByVal surveyId As Integer, ByRef surveyType As String, ByRef householdType As String, _
                ByRef resurveyExclusionPeriod As Integer)
        Dim isDynamic As Boolean
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteFetchSurveyValues, surveyId)

        Using rdr As New SafeDataReader(cmd.ExecuteReader)
            If rdr.Read Then
                isDynamic = rdr.GetBoolean("bitDynamic")
                If isDynamic Then
                    surveyType = "D"
                Else
                    surveyType = "S"
                End If
                resurveyExclusionPeriod = rdr.GetInteger("intResurvey_Period")
                If Not IsDBNull(rdr.GetString("strHouseholdingType")) Then
                    householdType = (rdr.GetString("strHouseholdingType")).ToString.ToUpper
                Else
                    Throw New Exception("samplesetPROC.SampleSet.Initialize_Set_SurveyDef_Vars" & vbCrLf & "A 'Householding' type must be specified in the 'Business Rules Editor' module of Configuration Manager.")
                End If
            End If
        End Using

    End Sub

    Public Overrides Sub ExecuteFetchHouseholdingValues(ByVal surveyId As Integer, ByRef householdFieldSelectSyntax As String, ByRef householdFieldSelectBigViewSyntax As String, _
                ByRef householdFieldCreateTableSyntax As String, ByRef householdJoinSyntax As String)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteFetchHouseholdingValues, surveyId)

        Using rdr As New SafeDataReader(cmd.ExecuteReader)
            While rdr.Read
                Dim fieldName As String = rdr.GetString("strField_nm")
                If fieldName <> "Pop_id" Then

                    If Trim(householdFieldSelectSyntax) <> "" Then householdFieldSelectSyntax = householdFieldSelectSyntax & ", "
                    householdFieldSelectSyntax = householdFieldSelectSyntax & "X." & fieldName

                    If Trim(householdFieldSelectBigViewSyntax) <> "" Then householdFieldSelectBigViewSyntax = householdFieldSelectBigViewSyntax & ", "
                    householdFieldSelectBigViewSyntax = householdFieldSelectBigViewSyntax & "POPULATION" & fieldName

                    If Trim(householdFieldCreateTableSyntax) <> "" Then householdFieldCreateTableSyntax = householdFieldCreateTableSyntax & ", "
                    householdFieldCreateTableSyntax = householdFieldCreateTableSyntax & fieldName
                    Select Case rdr.GetString("strFieldDataType").ToUpper
                        Case "I"
                            householdFieldCreateTableSyntax = householdFieldCreateTableSyntax & " int"
                        Case "D"
                            householdFieldCreateTableSyntax = householdFieldCreateTableSyntax & " datetime"
                        Case "S"
                            householdFieldCreateTableSyntax = householdFieldCreateTableSyntax & " varchar(" & rdr.GetInteger("intFieldLength").ToString & ")"
                    End Select

                End If

                If Trim(householdJoinSyntax) <> "" Then householdJoinSyntax = householdJoinSyntax & " AND "
                householdJoinSyntax = householdJoinSyntax & "X." & fieldName & " = Y." & fieldName
            End While
        End Using
    End Sub

    Public Overrides Sub ExecuteCreateTempTables(ByVal popIdEncIdCreateTableSyntax As String, ByVal householdFieldCreateTableSyntax As String)
        Dim cmd As New SqlClient.SqlCommand
        Dim command As New SqlClient.SqlCommand
        Dim syntax As New Collections.ObjectModel.Collection(Of String)
        cmd.Connection = mLegacySamplesetConnection

        If householdFieldCreateTableSyntax Is Nothing Then
            cmd = StoredProcCommandWrapper(SP.ExecuteCreateTempTables, popIdEncIdCreateTableSyntax, DBNull.Value)
        Else
            cmd = StoredProcCommandWrapper(SP.ExecuteCreateTempTables, popIdEncIdCreateTableSyntax, householdFieldCreateTableSyntax)
        End If

        Using rdr As New SafeDataReader(cmd.ExecuteReader)
            While rdr.Read
                syntax.Add(rdr.GetString("SQLStatement"))
            End While
        End Using

        cmd.Parameters.Clear()
        cmd.CommandType = CommandType.Text
        For Each str As String In syntax
            cmd.CommandText = str
            cmd.ExecuteNonQuery()
        Next
    End Sub

    Public Overrides Sub ExecuteCreateTempTables(ByVal popIdEncIdCreateTableSyntax As String)
        ExecuteCreateTempTables(popIdEncIdCreateTableSyntax, Nothing)
    End Sub

    Public Overrides Sub ExecuteDropTempTables(ByVal HouseholdingApplied As Boolean)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteDropTempTables, HouseholdingApplied)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteApplyIndex(ByVal encounterExists As Boolean)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteApplyIndex, encounterExists)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteResurveyExclusion(ByVal studyId As Integer, ByVal resurveyExclusionPeriod As Integer, ByVal resurveyMethodology As ResurveyMethod, ByVal samplingAlogrithmId As SamplingAlgorithm)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteResurveyExclusion, studyId, resurveyMethodology, resurveyExclusionPeriod, CInt(samplingAlogrithmId))
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteNewbornRule(ByVal studyId As Integer, ByVal bigViewJoinSyntax As String, ByVal newBornWhereClause As String, ByVal surveyId As Integer, ByVal sampleSetId As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteNewbornRule, studyId, bigViewJoinSyntax, newBornWhereClause, surveyId, sampleSetId)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteTOCLRule(ByVal studyId As Integer)
        'Defaulting the surveryId, samplesetId, and logExclusion to 0. SP ignores those values for legacy algorithm.
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteTOCLRule, studyId, 0, 0, 0)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteDedupUniverseDynamic(ByVal seed As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteDedupUniverseDynamic, seed)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteDedupUniverseStatic(ByVal seed As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteDedupUniverseStatic, seed)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteCalcResponseRates(ByVal surveyId As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteCalcResponseRates, surveyId)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteCalcTargets(ByVal samplesetId As Integer, ByVal periodId As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteCalcTargets, samplesetId, periodId)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Function ExecuteSampleunitTiers(ByVal surveyId As Integer, ByVal samplesetId As Integer) As System.Collections.ObjectModel.Collection(Of Integer)
        Dim units As New System.Collections.ObjectModel.Collection(Of Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteFetchSampleUnitTiers, surveyId, samplesetId)

        Using rdr As New SafeDataReader(cmd.ExecuteReader)
            While rdr.Read
                units.Add(rdr.GetInteger("SampleUnit_id"))
            End While
        End Using
        Return units
    End Function

    Public Overrides Sub ExecuteUpdateSamplesetWithSeed(ByVal samplesetId As Integer, ByVal seed As Integer)
        Dim cmd As New SqlClient.SqlCommand
        Dim strsample As String = "Update dbo.SampleSet SET intsample_Seed=" & seed & " WHERE sampleset_Id =" & samplesetId
        cmd.Connection = mLegacySamplesetConnection
        cmd.CommandType = CommandType.Text
        cmd.CommandText = strsample
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteSample(ByVal sampleunitId As Integer, ByVal samplingMethod As String, ByVal samplesetId As Integer, ByVal seed As Integer)
        Dim cmd As New SqlClient.SqlCommand
        Dim strsample As String
        Dim intOutgo As Integer

        cmd.Connection = mLegacySamplesetConnection
        cmd.CommandType = CommandType.Text

        If samplingMethod <> "Census" Then

            strsample = "CREATE TABLE #RandomPop (Pop_Id int, numRandom int)"
            cmd.CommandText = strsample
            cmd.ExecuteNonQuery()

            strsample = "CREATE TABLE #SampledPop (Pop_Id int)"
            cmd.CommandText = strsample
            cmd.ExecuteNonQuery()

            cmd = StoredProcCommandWrapper(SP.ExecuteCalcOutgo, sampleunitId, samplesetId)
            intOutgo = CInt(cmd.ExecuteScalar)
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()

            If intOutgo > 0 Then

                ' Assign a Random number to each record in the Sample Unit Universe
                ' on the current Sample Unit.
                strsample = "SET NOCOUNT ON" & vbCrLf
                strsample = strsample & " INSERT INTO #RandomPop (Pop_Id, numRandom)" & vbCrLf
                strsample = strsample & " SELECT Pop_Id, numRandom" & vbCrLf
                strsample = strsample & " FROM #SampleUnit_Universe su, random_Numbers rn" & vbCrLf
                strsample = strsample & " WHERE SampleUnit_id = " & sampleunitId.ToString & vbCrLf
                strsample = strsample & " AND Removed_Rule = 0" & vbCrLf
                strsample = strsample & " AND strUnitSelectType = 'N'" & vbCrLf
                strsample = strsample & " AND ((su.id_num+" & seed.ToString & ")%1000000)=rn.random_id" & vbCrLf
                strsample = strsample & " SET NOCOUNT OFF"
                cmd.CommandText = strsample
                cmd.ExecuteNonQuery()

                strsample = "SET ROWCOUNT " & intOutgo & vbCrLf
                ' Directly Sample the first @intOutgo Sample Unit Universe
                ' records for the Sample Unit, in ascending order by the
                ' random number.
                strsample = strsample & "INSERT INTO #SampledPop "
                strsample = strsample & "SELECT Pop_Id "
                strsample = strsample & "FROM #RandomPop "
                strsample = strsample & "ORDER BY numRandom ASC " & vbCrLf
                strsample = strsample & "SET ROWCOUNT 0"
                cmd.CommandText = strsample
                cmd.ExecuteNonQuery()

                strsample = "UPDATE #SampleUnit_Universe "
                strsample = strsample & "SET strUnitSelectType = 'D' "
                strsample = strsample & "FROM #SampledPop SP "
                strsample = strsample & "WHERE #SampleUnit_Universe.Pop_Id = SP.Pop_Id "
                strsample = strsample & "  AND #SampleUnit_Universe.SampleUnit_id = " & sampleunitId.ToString
                strsample = strsample & "  AND #SampleUnit_Universe.Removed_Rule = 0"
                cmd.CommandText = strsample
                cmd.ExecuteNonQuery()
            End If

            strsample = " DROP TABLE #SampledPop DROP TABLE #RandomPop"
            cmd.CommandText = strsample
            cmd.ExecuteNonQuery()
        Else
            'Census Sample
            strsample = "UPDATE #SampleUnit_Universe "
            strsample = strsample & "SET strUnitSelectType = 'D' "
            strsample = strsample & "WHERE Removed_Rule = 0" & vbCrLf
            strsample = strsample & "AND strUnitSelectType = 'N'" & vbCrLf

            cmd.CommandText = strsample
            cmd.ExecuteNonQuery()
        End If
    End Sub

    Public Overrides Sub ExecuteStaticSampleAntecedIndirect(ByVal sampleunitId As Integer, ByVal popIdEncIdJoinSyntax As String)
        Dim strSQL As String
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = mLegacySamplesetConnection
        cmd.CommandType = CommandType.Text

        strSQL = "Update X "
        strSQL = strSQL & "SET X.strUnitSelectType = 'I' "
        strSQL = strSQL & "FROM #SampleUnit_Universe X, #SampleUnit_Universe Y, dbo.SampleUnitTreeIndex SUTI "
        strSQL = strSQL & "WHERE X.SampleUnit_id = SUTI.AncestorUnit_Id"
        strSQL = strSQL & "      AND " & popIdEncIdJoinSyntax
        strSQL = strSQL & "      AND Y.SampleUnit_id = SUTI.SampleUnit_id"
        strSQL = strSQL & "      AND X.strUnitSelectType = 'N'"
        strSQL = strSQL & "      AND X.Removed_Rule = 0"
        strSQL = strSQL & "      AND Y.strUnitSelectType = 'D'"
        strSQL = strSQL & "      AND Y.SampleUnit_id = " & sampleunitId.ToString

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteStaticRemoveFromSiblings(ByVal sampleunitId As Integer)

        Dim strSQL As String
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = mLegacySamplesetConnection
        cmd.CommandType = CommandType.Text

        'Add units that are not ancestors or child, grandchild, etc. of the source unit
        strSQL = "CREATE TABLE #NonAncestorUnits (SampleUnit_id int)" & vbCrLf
        strSQL = strSQL & "CREATE TABLE #AncestorUnits (SampleUnit_id int)" & vbCrLf
        strSQL = strSQL & "INSERT INTO #AncestorUnits Values (" & sampleunitId.ToString & ")" & vbCrLf
        strSQL = strSQL & "INSERT INTO #AncestorUnits" & vbCrLf
        strSQL = strSQL & "SELECT AncestorUnit_Id" & vbCrLf
        strSQL = strSQL & "FROM dbo.SampleUnitTreeIndex" & vbCrLf
        strSQL = strSQL & "WHERE SampleUnit_id = " & sampleunitId.ToString & vbCrLf
        strSQL = strSQL & "UNION" & vbCrLf
        strSQL = strSQL & "SELECT SampleUnit_id" & vbCrLf
        strSQL = strSQL & "FROM dbo.SampleUnitTreeIndex" & vbCrLf
        strSQL = strSQL & "WHERE AncestorUnit_Id = " & sampleunitId.ToString & vbCrLf
        strSQL = strSQL & "INSERT INTO #NonAncestorUnits" & vbCrLf
        strSQL = strSQL & "SELECT SampleUnit_id" & vbCrLf
        strSQL = strSQL & "FROM (Select distinct SampleUnit_id from #SampleUnit_Universe) s" & vbCrLf
        strSQL = strSQL & "WHERE SampleUnit_id not in (select SampleUnit_id from #AncestorUnits)" & vbCrLf

        ' Remove the people who have been sampled into the source sample unit
        ' from the sample unit's sibling units.
        strSQL = strSQL & "UPDATE SUUTarget" & vbCrLf
        strSQL = strSQL & "SET SUUTarget.Removed_Rule = 8" & vbCrLf
        strSQL = strSQL & "FROM #SampleUnit_Universe SUUTarget, #SampleUnit_Universe SUUSource, #NonAncestorUnits SU" & vbCrLf
        strSQL = strSQL & "WHERE SUUTarget.SampleUnit_id = SU.SampleUnit_id" & vbCrLf
        strSQL = strSQL & "      AND SUUSource.SampleUnit_id = " & sampleunitId.ToString & vbCrLf
        strSQL = strSQL & "      AND SUUTarget.Pop_Id = SUUSource.Pop_Id" & vbCrLf
        strSQL = strSQL & "      AND SUUTarget.strUnitSelectType = 'N'" & vbCrLf
        strSQL = strSQL & "      AND SUUTarget.Removed_Rule = 0" & vbCrLf
        strSQL = strSQL & "      AND SUUSource.strUnitSelectType = 'D'" & vbCrLf

        strSQL = strSQL & "DROP TABLE #NonAncestorUnits" & vbCrLf
        strSQL = strSQL & "DROP TABLE #AncestorUnits"

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

    End Sub

    Public Overrides Sub ExecuteStaticRemoveFromChildren(ByRef sampleunitId As Integer)

        Dim strSQL As String = ""
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = mLegacySamplesetConnection
        cmd.CommandType = CommandType.Text

        ' Create the Child Units Table
        strSQL = strSQL & " CREATE TABLE #ChildUnits" & vbCrLf
        strSQL = strSQL & "  (SampleUnit_id int)" & vbCrLf
        ' Get Children
        strSQL = strSQL & " INSERT INTO #ChildUnits" & vbCrLf
        strSQL = strSQL & " SELECT SampleUnit_id" & vbCrLf
        strSQL = strSQL & "  FROM dbo.SampleUnit " & vbCrLf
        strSQL = strSQL & "   WHERE ParentSampleUnit_id = " & sampleunitId.ToString & vbCrLf

        ' Remove them from the #SampleUnit_Universe
        strSQL = strSQL & "  UPDATE SUUTarget" & vbCrLf
        strSQL = strSQL & "   SET SUUTarget.Removed_Rule = 8" & vbCrLf
        strSQL = strSQL & "   FROM #SampleUnit_Universe SUUTarget, #SampleUnit_Universe SUUSource, #ChildUnits CU" & vbCrLf
        strSQL = strSQL & "     WHERE SUUTarget.SampleUnit_id = CU.SampleUnit_id" & vbCrLf
        strSQL = strSQL & "      AND SUUSource.SampleUnit_id = " & sampleunitId.ToString & vbCrLf
        strSQL = strSQL & "      AND SUUTarget.Pop_Id = SUUSource.Pop_Id " & vbCrLf
        strSQL = strSQL & "      AND SUUTarget.Removed_Rule = 0" & vbCrLf
        strSQL = strSQL & "      AND SUUSource.Removed_Rule = 8" & vbCrLf

        ' Clean up the temp table
        strSQL = strSQL & " DROP TABLE #ChildUnits" & vbCrLf

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

    End Sub

    Public Overrides Sub ExecuteStaticDeDupeEncChildUnit(ByVal sampleunitId As Integer, ByVal popIdEncIdJoinSyntax As String, ByVal mPopIdEncIdSelectSyntax As String, ByVal mPopIdEncIdCreateTableSyntax As String, _
                ByVal seed As Integer)

        Dim strSQL As String = ""
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = mLegacySamplesetConnection
        cmd.CommandType = CommandType.Text

        'strSQL = "drop table #ChildUnits  DROP TABLE #random truncate table #DD_ChildSample truncate table #DD_Dups"
        'cmd.CommandText = strSQL
        'cmd.ExecuteNonQuery()

        ' Create Child Sample Unit Temp Table
        strSQL = strSQL & " CREATE TABLE #ChildUnits (SampleUnit_id int)" & vbCrLf
        ' Fetch the Child Sample Units
        strSQL = strSQL & " INSERT INTO #ChildUnits" & vbCrLf
        strSQL = strSQL & " SELECT SampleUnit_id" & vbCrLf
        strSQL = strSQL & " FROM dbo.SampleUnit " & vbCrLf
        strSQL = strSQL & " WHERE ParentSampleUnit_id = " & sampleunitId.ToString & vbCrLf
        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        ' Find the duplicate encounters from child sample units that meet the parent sample unit
        strSQL = " INSERT INTO #DD_Dups" & vbCrLf
        strSQL = strSQL & " SELECT " & mPopIdEncIdSelectSyntax & vbCrLf
        strSQL = strSQL & " FROM #SampleUnit_Universe X, #SampleUnit_Universe Y, #ChildUnits CSU" & vbCrLf
        strSQL = strSQL & " WHERE " & popIdEncIdJoinSyntax & vbCrLf
        strSQL = strSQL & "       AND X.SampleUnit_id = " & sampleunitId.ToString & vbCrLf
        strSQL = strSQL & "       AND Y.SampleUnit_id = CSU.SampleUnit_id" & vbCrLf
        strSQL = strSQL & "       AND X.strUnitSelectType = 'D'" & vbCrLf
        strSQL = strSQL & "       AND Y.Removed_Rule = 0" & vbCrLf
        strSQL = strSQL & " GROUP BY " & mPopIdEncIdSelectSyntax & vbCrLf
        strSQL = strSQL & " HAVING COUNT(*) > 1" & vbCrLf
        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        ' Insert the duplicate encounters into #ChildSample
        strSQL = " INSERT INTO #DD_ChildSample " & vbCrLf
        strSQL = strSQL & " SELECT X.SampleUnit_id, " & mPopIdEncIdSelectSyntax & ", NULL, 0" & vbCrLf
        strSQL = strSQL & " FROM #SampleUnit_Universe X, #DD_Dups Y, #ChildUnits CSU" & vbCrLf
        strSQL = strSQL & " WHERE " & popIdEncIdJoinSyntax & vbCrLf
        strSQL = strSQL & "       AND X.SampleUnit_id = CSU.SampleUnit_id" & vbCrLf
        strSQL = strSQL & "       AND X.Removed_Rule = 0" & vbCrLf
        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        strSQL = "SET NOCOUNT ON" & vbCrLf
        strSQL = strSQL & "CREATE TABLE #Random (id_num int identity, cs_id int, " & mPopIdEncIdCreateTableSyntax & ")"
        strSQL = strSQL & " INSERT INTO #Random (cs_id, " & mPopIdEncIdSelectSyntax & ")" & vbCrLf
        strSQL = strSQL & " SELECT cs_id, " & mPopIdEncIdSelectSyntax & vbCrLf
        strSQL = strSQL & " FROM #DD_ChildSample x, random_Numbers rn" & vbCrLf
        strSQL = strSQL & " WHERE ((x.cs_id+" & seed.ToString & ")%1000000)=rn.random_id" & vbCrLf
        strSQL = strSQL & " ORDER BY " & mPopIdEncIdSelectSyntax & ", random_id" & vbCrLf
        strSQL = strSQL & " SET NOCOUNT OFF"
        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        ' For each duplicate encounter, select one to keep
        strSQL = "UPDATE #DD_ChildSample " & vbCrLf
        strSQL = strSQL & "    SET bitKeep = 1" & vbCrLf
        strSQL = strSQL & "    FROM (SELECT " & mPopIdEncIdSelectSyntax & ",MIN(id_num) AS id_num" & vbCrLf
        strSQL = strSQL & "      FROM #Random X" & vbCrLf
        strSQL = strSQL & "      GROUP BY " & mPopIdEncIdSelectSyntax & ") random_id, #Random r, #DD_ChildSample cs" & vbCrLf
        strSQL = strSQL & "    WHERE random_id.id_num=r.id_num and " & vbCrLf
        strSQL = strSQL & "      r.cs_id=cs.cs_id" & vbCrLf
        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        ' Remove from #SampleUnit_Universe
        strSQL = "UPDATE X " & vbCrLf
        strSQL = strSQL & " SET X.Removed_Rule = 8" & vbCrLf
        strSQL = strSQL & " FROM #SampleUnit_Universe X, #DD_ChildSample Y" & vbCrLf
        strSQL = strSQL & " WHERE X.SampleUnit_id = Y.SampleUnit_id" & vbCrLf
        strSQL = strSQL & "       AND " & popIdEncIdJoinSyntax & vbCrLf
        strSQL = strSQL & "       AND Y.bitKeep = 0" & vbCrLf
        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        ' Clean up Temp Tables
        strSQL = " DROP TABLE #ChildUnits DROP TABLE #random truncate table #DD_ChildSample truncate table #DD_Dups" & vbCrLf

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

    End Sub

    Public Overrides Sub ExecuteSampleChildDirect(ByVal sampleUnitId As Integer, ByVal popIdEncIdJoinsyntax As String)

        Dim strSQL As String = ""
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = mLegacySamplesetConnection
        cmd.CommandType = CommandType.Text

        ' Create the Temp Tables
        strSQL = strSQL & " CREATE TABLE #ChildUnits (SampleUnit_id int)" & vbCrLf
        ' Identify the child units
        strSQL = strSQL & " INSERT INTO #ChildUnits" & vbCrLf
        strSQL = strSQL & " SELECT SampleUnit_id" & vbCrLf
        strSQL = strSQL & " FROM dbo.SampleUnit" & vbCrLf
        strSQL = strSQL & " WHERE ParentSampleUnit_id = " & sampleUnitId.ToString & vbCrLf
        ' Directly Sample all non-removed child units
        strSQL = strSQL & " UPDATE Y" & vbCrLf
        strSQL = strSQL & " SET Y.strUnitSelectType = 'D'" & vbCrLf
        strSQL = strSQL & " FROM #SampleUnit_Universe X, #SampleUnit_Universe Y, #ChildUnits CU" & vbCrLf
        strSQL = strSQL & " WHERE " & popIdEncIdJoinsyntax & vbCrLf
        strSQL = strSQL & "      AND Y.SampleUnit_id = CU.SampleUnit_id" & vbCrLf
        strSQL = strSQL & "      AND X.SampleUnit_id = " & sampleUnitId.ToString & vbCrLf
        strSQL = strSQL & "      AND X.strUnitSelectType = 'D'" & vbCrLf
        strSQL = strSQL & "      AND Y.strUnitSelectType <> 'D'" & vbCrLf
        strSQL = strSQL & "      AND Y.Removed_Rule = 0" & vbCrLf
        strSQL = strSQL & " DROP TABLE #ChildUnits" & vbCrLf
        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

    End Sub

    Public Overrides Sub ExecuteDynamicIndirectSample(ByVal sampleunitId As Integer, ByVal popIdEncIdJoinSyntax As String)

        Dim strSQL As String = ""
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = mLegacySamplesetConnection
        cmd.CommandType = CommandType.Text

        ' Indirectly sample encounters in all units that were directly
        ' sampled into the source unit and are not already
        ' directly sampled.
        strSQL = strSQL & " UPDATE Y" & vbCrLf
        strSQL = strSQL & " SET strUnitSelectType = 'I'" & vbCrLf
        strSQL = strSQL & " FROM #SampleUnit_Universe X, #SampleUnit_Universe Y" & vbCrLf
        strSQL = strSQL & " WHERE " & popIdEncIdJoinSyntax & vbCrLf
        strSQL = strSQL & "       AND X.SampleUnit_id = " & sampleunitId.ToString & vbCrLf
        strSQL = strSQL & "       AND Y.SampleUnit_id <> " & sampleunitId.ToString & vbCrLf
        strSQL = strSQL & "       AND X.strUnitSelectType = 'D'" & vbCrLf
        strSQL = strSQL & "       AND Y.strUnitSelectType <> 'D'" & vbCrLf
        strSQL = strSQL & "       AND Y.Removed_Rule = 0" & vbCrLf

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        'Added to Mark all Parents as indirect for the same encounter as the child is marked
        'Direct.  This avoids situations where the parent unit encounter is not an encounter
        'that was directly sampled.  Only consider popids that haven't been Directly sampled already

        strSQL = "Update X "
        strSQL = strSQL & " SET X.strUnitSelectType = 'I' "
        strSQL = strSQL & " FROM #SampleUnit_Universe X, #SampleUnit_Universe Y, dbo.SampleUnitTreeIndex SUTI, "
        strSQL = strSQL & " (SELECT SampleUnit_id, Pop_Id FROM #SampleUnit_Universe "
        strSQL = strSQL & "   WHERE Removed_Rule=0 "
        strSQL = strSQL & "     AND StrUnitSelectType in ('I', 'N')) P "
        strSQL = strSQL & " WHERE X.SampleUnit_id = SUTI.AncestorUnit_Id"
        strSQL = strSQL & "      AND " & popIDEncIDJoinSyntax
        strSQL = strSQL & "      AND Y.SampleUnit_id = SUTI.SampleUnit_id"
        strSQL = strSQL & "      AND X.SampleUnit_id = P.SampleUnit_id"
        strSQL = strSQL & "      AND X.Pop_Id = P.Pop_Id"
        strSQL = strSQL & "      AND X.Removed_Rule in (0,5)"
        strSQL = strSQL & "      AND Y.strUnitSelectType = 'D'"
        strSQL = strSQL & "      AND Y.SampleUnit_id = " & sampleunitId.ToString

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()


        'Set the removed Rule to a dummy value for any encounters for a parent unit that we marked a
        'Different encounter as 'I'.  This will allow us to identify them later when we change
        'them to a 5
        strSQL = "Update X "
        strSQL = strSQL & "SET Removed_Rule = 255"
        strSQL = strSQL & "FROM #SampleUnit_Universe X, "
        strSQL = strSQL & "     (Select SampleUnit_id, Pop_Id "
        strSQL = strSQL & "      FROM #SampleUnit_Universe"
        strSQL = strSQL & "      WHERE strunitselecttype='I'"
        strSQL = strSQL & "         AND Removed_Rule=5) Y "
        strSQL = strSQL & "WHERE X.SampleUnit_id=Y.SampleUnit_id"
        strSQL = strSQL & "      AND X.Pop_Id=Y.Pop_Id"
        strSQL = strSQL & "      AND X.Removed_Rule=0"

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        'Set the Removed Rule to 0 for any parent encounters we marked as 'I' that were a 5
        strSQL = "Update #SampleUnit_Universe "
        strSQL = strSQL & " SET Removed_Rule = 0 "
        strSQL = strSQL & " WHERE strUnitSelectType = 'I'"
        strSQL = strSQL & "      AND Removed_Rule=5"

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()

        'Set the Removed Rule to 5 for any parent encounters we marked with the dummy value
        strSQL = "Update #SampleUnit_Universe "
        strSQL = strSQL & " SET Removed_Rule = 5, "
        strSQL = strSQL & " strUnitSelectType = 'N'"
        strSQL = strSQL & " WHERE Removed_Rule=255"

        cmd.CommandText = strSQL
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteUpdatePeriod(ByVal samplesetId As Integer, ByVal periodId As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteUpdatePeriod, samplesetId, periodId)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteUpdateSampleDataSet(ByVal samplesetId As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteUpdateSampleDataSet, samplesetId)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteUpdateSamplePop(ByVal samplesetId As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteUpdateSamplePop, samplesetId)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteUpdateSelectedSample(ByVal samplesetId As Integer, ByVal encounterExists As Boolean)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteUpdateSelectedSample, samplesetId, encounterExists)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteHouseholdingAdult(ByVal studyId As Integer, ByVal householdFieldCreateTableSyntax As String, ByVal householdFieldSelectSyntax As String, _
                ByVal householdJoinSyntax As String, ByVal reSurveyExPeriod As Integer, ByVal seed As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteHouseholdingAdult, studyId, householdFieldCreateTableSyntax, householdFieldSelectSyntax, _
                               householdJoinSyntax, reSurveyExPeriod, seed)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteHouseholdingMinor(ByVal minorExceptionCriteria As String, ByVal studyId As Integer, ByVal householdFieldCreateTableSyntax As String, ByVal householdFieldSelectSyntax As String, _
                ByVal householdJoinSyntax As String, ByVal reSurveyExPeriod As Integer, ByVal seed As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteHouseholdingMinor, studyId, householdFieldCreateTableSyntax, householdFieldSelectSyntax, _
                               householdJoinSyntax, reSurveyExPeriod, minorExceptionCriteria, seed)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Sub ExecuteRollbackSample(ByVal samplesetId As Integer)
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteRollbackSample, samplesetId)
        cmd.ExecuteNonQuery()
    End Sub

    Public Overrides Function ExecuteValidateConfiguration(ByVal surveyId As Integer) As String
        Dim cmd As SqlClient.SqlCommand = StoredProcCommandWrapper(SP.ExecuteValidateConfiguration, surveyId)
        Return CStr(cmd.ExecuteScalar)
    End Function

End Class
