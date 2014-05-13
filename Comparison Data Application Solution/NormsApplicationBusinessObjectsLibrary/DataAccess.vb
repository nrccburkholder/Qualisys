Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.Text
Imports NRC.Framework

Public Class DataAccess
    Private Shared mQpNormsDB As Database
    Private Shared ReadOnly Property QpNormsDB() As Database
        Get
            If mQpNormsDB Is Nothing Then
                mQpNormsDB = New Sql.SqlDatabase(Config.QP_NormsConnection)
            End If
            Return mQpNormsDB
        End Get
    End Property
    Private Shared mQpCommentsDB As Database
    Private Shared ReadOnly Property QpCommentsDB() As Database
        Get
            If mQpCommentsDB Is Nothing Then
                mQpCommentsDB = New Sql.SqlDatabase(Config.QP_CommentsConnection)
            End If
            Return mQpCommentsDB
        End Get
    End Property

#Region " General"

    Public Shared Function LoadNormSettings(ByVal normID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_LoadNormSettings", normID)
    End Function

    Public Shared Function SelectDimensionList(ByVal memberID As Integer, ByVal surveyTypeID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader( _
                                  "SP_NormAppUI_SelectDimensionList", _
                                  memberID, _
                                  surveyTypeID)
    End Function

#End Region

#Region " US Norms"
    Public Shared Sub LogNormReport(ByVal ID As Integer, ByVal MemberID As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_LogNormReport", ID, MemberID)
    End Sub

    Public Shared Function getSavedQueries(ByVal memberID As Integer, ByVal reportType As Integer) As DataSet
        Return QpNormsDB.ExecuteDataSet("SP_NormAppUI_SelectNormReportList", memberID, reportType)
    End Function

    Public Shared Function getComparisonDataQuery(ByVal id As Integer) As DataSet
        Return QpNormsDB.ExecuteDataSet("SP_NormAppUI_SelectNormReport", id)
    End Function

    Public Shared Function InsertComparisonDataQuery(ByVal reportTypeID As ComparisonDataQuery.enuReportType, ByVal label As String, ByVal description As String, ByVal IsSelectable As Boolean, ByVal memberID As Integer, ByVal Params As ParametersCollection) As Integer
        Select Case reportTypeID
            Case ComparisonDataQuery.enuReportType.DemographicCounts
                Return CType(QpNormsDB.ExecuteScalar("SP_NormAppUI_InsertNormReport", reportTypeID, label, description, IsSelectable, memberID, Params(0), Params(1), Params(2), System.DBNull.Value, System.DBNull.Value, System.DBNull.Value, System.DBNull.Value, System.DBNull.Value, System.DBNull.Value, System.DBNull.Value), Integer)
            Case ComparisonDataQuery.enuReportType.QuestionCounts, ComparisonDataQuery.enuReportType.QuestionUsers
                Return CType(QpNormsDB.ExecuteScalar("SP_NormAppUI_InsertNormReport", reportTypeID, label, description, IsSelectable, memberID, Params(0), Params(1), Params(2), Params(3), Params(4), System.DBNull.Value, System.DBNull.Value, System.DBNull.Value, System.DBNull.Value, System.DBNull.Value), Integer)
            Case ComparisonDataQuery.enuReportType.Frequencies
                Return CType(QpNormsDB.ExecuteScalar("SP_NormAppUI_InsertNormReport", reportTypeID, label, description, IsSelectable, memberID, Params(0), Params(1), Params(2), Params(3), Params(4), Params(5), System.DBNull.Value, System.DBNull.Value, System.DBNull.Value, System.DBNull.Value), Integer)
            Case ComparisonDataQuery.enuReportType.AverageScores, ComparisonDataQuery.enuReportType.GroupRanksAndScores, ComparisonDataQuery.enuReportType.Percentiles1to100
                Return CType(QpNormsDB.ExecuteScalar("SP_NormAppUI_InsertNormReport", reportTypeID, label, description, IsSelectable, memberID, Params(0), Params(1), Params(2), Params(3), Params(4), Params(5), Params(6), Params(7), System.DBNull.Value, System.DBNull.Value), Integer)
        End Select
        Return 0
    End Function

    Public Shared Sub DeleteComparisonDataQuery(ByVal id As Integer, ByVal memberID As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteNormReport", id, memberID)
    End Sub

    Public Shared Sub PromoteNorms(ByVal all As Boolean, ByVal normID As Integer)
        QpNormsDB.ExecuteNonQuery("NRM_US_PromoteSingleNorm", all, normID)
    End Sub

    Public Shared Function AddNewQuarterofData(ByVal yearQuarter As String, ByVal minDate As DateTime, ByVal maxDate As DateTime) As Boolean
        QpNormsDB.ExecuteNonQuery("sp_NormAPP_CreateStudyResultsData", yearQuarter, minDate.ToShortDateString, maxDate.ToShortDateString + " 23:59:59")
    End Function

    Public Shared Function UpdateAllLookupTables() As Boolean
        QpNormsDB.ExecuteNonQuery(CommandType.StoredProcedure, "sp_NormAPP_UpdateAllLookups")
    End Function

    Public Shared Sub PopulateNorm(ByVal normID As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_populateNorm", normID)
    End Sub

    Public Shared Function GetAllClients() As DataSet
        Return QpNormsDB.ExecuteDataSet(CommandType.StoredProcedure, "SP_NormAppUI_getAllClients")
    End Function
    Public Shared Function GetClientSurveys(ByVal clientID As Integer) As DataSet
        Return QpNormsDB.ExecuteDataSet("SP_NormAppUI_getClientSurveys", clientID)
    End Function

    Public Shared Sub updateSurveyCountry(ByVal survey_id As Integer, ByVal country_id As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_updateSurveyCountry", survey_id, country_id)
    End Sub

    Public Shared Sub UpdateUSNormSetting(ByVal normID As Integer, ByVal normLabel As String, ByVal normDescription As String, _
                                        ByVal minClientCheck As Boolean, ByVal criteriaStatement As String, _
                                        ByVal monthSpan As Integer, ByVal Ongoing As Boolean, _
                                        ByVal memberID As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_updateUSNormSetting", normID, normLabel, normDescription, minClientCheck, criteriaStatement, monthSpan, Ongoing, memberID)
    End Sub

    Public Shared Function InsertUSNormSetting(ByVal normLabel As String, ByVal normDescription As String, _
                                        ByVal minClientCheck As Boolean, ByVal criteriaStatement As String, _
                                        ByVal monthSpan As Integer, ByVal Ongoing As Boolean, _
                                        ByVal memberID As Integer) As Integer
        Return CInt(QpNormsDB.ExecuteScalar("SP_NormAppUI_addUSNormSetting", normLabel, normDescription, minClientCheck, criteriaStatement, monthSpan, Ongoing, memberID))
    End Function

    Public Shared Sub UpdateUSComparisonType(ByVal compTypeID As Integer, ByVal selectionBox As String, _
                                        ByVal description As String, ByVal normParam As Integer, ByVal memberID As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_updateUSComparisonType", compTypeID, selectionBox, description, normParam, memberID)
    End Sub

    Public Shared Function InsertUSComparisonType(ByVal normID As Integer, _
                                        ByVal selectionBox As String, ByVal selectionType As String, _
                                        ByVal description As String, ByVal normType As USComparisonType.NormType, ByVal normParam As Integer, _
                                        ByVal indPercentileCompTypeID As Integer, ByVal memberID As Integer) As Integer
        Return CInt(QpNormsDB.ExecuteScalar("SP_NormAppUI_addUSComparisonType", normID, selectionBox, selectionType, description, normType, normParam, indPercentileCompTypeID, memberID))
    End Function

    Public Shared Function GetSurveyTypes() As DataSet
        Return QpNormsDB.ExecuteDataSet(CommandType.StoredProcedure, "SP_NormAppUI_getSurveyTypes")
    End Function

    Public Shared Function GetSingleSurveyType(ByVal SurveyType_id As Integer) As DataRow
        Dim dr As DataRow
        dr = QpNormsDB.ExecuteDataSet("SP_NormAppUI_getSingleSurveyType", SurveyType_id).Tables(0).Rows(0)
        Return dr
    End Function

    Public Shared Function InsertSurveyType(ByVal name As String) As Integer
        Return CType(QpNormsDB.ExecuteScalar("SP_NormAppUI_AddSurveyType", name), Integer)
    End Function

    Public Shared Sub InsertSurveyQuestion(ByVal SurveyType_id As Integer, _
                                          ByVal Qstncore As Integer)

        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_AddSurveyQuestion", SurveyType_id, Qstncore)
    End Sub

    Public Shared Sub ClearSurveyQuestions(ByVal SurveyType_id As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteAllSurveyQuestions", SurveyType_id)
    End Sub

    Public Shared Function UpdateSurveyType(ByVal SurveyType_id As Integer, _
                                          ByVal name As String) As Integer
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_UpdateSurveyType", SurveyType_id, name)
    End Function

    Public Shared Sub DeleteSurveyType(ByVal SurveyType_id As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteSurveyType", SurveyType_id)
    End Sub

    Public Shared Function GetCountries() As DataSet
        Return QpNormsDB.ExecuteDataSet(CommandType.StoredProcedure, "SP_NormAppUI_getCountries")
    End Function

    Public Shared Function InsertCountry(ByVal name As String) As Integer
        Return CType(QpNormsDB.ExecuteScalar("SP_NormAppUI_AddCountry", name), Integer)
    End Function

    Public Shared Function UpdateCountry(ByVal Country_id As Integer, _
                                          ByVal name As String) As Integer
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_UpdateCountry", Country_id, name)
    End Function

    Public Shared Sub DeleteCountry(ByVal Country_id As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteCountry", Country_id)
    End Sub

    Public Shared Function GetSurveyQuestions(ByVal SurveyType_id As Integer) As DataSet
        Return QpNormsDB.ExecuteDataSet("SP_NormAppUI_getSurveyQuestions", SurveyType_id)
    End Function

    Public Shared Function GetDimensionUsers() As DataSet
        Return QpNormsDB.ExecuteDataSet(CommandType.StoredProcedure, "SP_NormAppUI_getDimensionUsers")
    End Function

    Public Shared Function GetDimensions(ByVal memberID As Integer, ByVal SurveyType_ID As Integer) As DataSet
        Return QpNormsDB.ExecuteDataSet("SP_NormAppUI_getDimensionsList", memberID, SurveyType_ID)
    End Function

    Public Shared Function GetSingleDimensions(ByVal Dimension_id As Integer) As DataSet
        Return QpNormsDB.ExecuteDataSet("SP_NormAppUI_getSingleDimension", Dimension_id)
    End Function

    Public Shared Function InsertDimension(ByVal name As String, _
                                              ByVal description As String, _
                                              ByVal surveyType_id As Integer, _
                                              ByVal member_id As Integer, _
                                              ByVal isStandard As Boolean) As Integer

        Return CType(QpNormsDB.ExecuteScalar("SP_NormAppUI_AddDimension", member_id, name, _
                                             description, surveyType_id, isStandard), Integer)

    End Function

    Public Shared Sub InsertDimensionQuestion(ByVal Dimension_id As Integer, _
                                              ByVal Qstncore As Integer)

        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_AddDimensionQuestion", Dimension_id, Qstncore)
    End Sub

    Public Shared Function UpdateDimension(ByVal Dimension_id As Integer, _
                                          ByVal name As String, _
                                          ByVal description As String, _
                                          ByVal surveyType_id As Integer) As Integer

        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_UpdateDimension", Dimension_id, name, _
                                             description, surveyType_id)

    End Function

    Public Shared Sub ClearDimensionQuestions(ByVal Dimension_id As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteAllDimensionQuestion", Dimension_id)
    End Sub

    Public Shared Sub DeleteDimension(ByVal Dimension_id As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteDimension", Dimension_id)
    End Sub

    Public Shared Function InsertQuestionGroup(ByVal name As String, _
                                                 ByVal description As String, _
                                                 ByVal norm_id As Integer, _
                                                 ByVal member_id As Integer) As Integer

        Return CType(QpNormsDB.ExecuteScalar("SP_NormAppUI_AddQuestionGroup", member_id, name, _
                                             description, norm_id), Integer)

    End Function

    Public Shared Sub InsertQuestionGroupQuestion(ByVal QuestionGroup_id As Integer, _
                                              ByVal Qstncore As Integer)

        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_AddQuestionGroupQuestions", QuestionGroup_id, Qstncore)
    End Sub

    Public Shared Function UpdateQuestionGroup(ByVal QuestionGroup_id As Integer, _
                                          ByVal name As String, _
                                          ByVal description As String, _
                                          ByVal norm_id As Integer) As Integer

        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_UpdateQuestionGroup", QuestionGroup_id, name, _
                                             description, norm_id)

    End Function

    Public Shared Sub ClearQuestionGroupQuestions(ByVal QuestionGroup_id As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteAllQuestionGroupQuestion", QuestionGroup_id)
    End Sub

    Public Shared Sub DeleteQuestionGroup(ByVal QuestionGroup_id As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteQuestionGroup", QuestionGroup_id)
    End Sub

    Public Shared Function GetSingleQuestion(ByVal Qstncore As Integer) As DataRow
        Dim dr As DataRow
        dr = QpNormsDB.ExecuteDataSet("SP_NormAppUI_getSingleQuestion", Qstncore).Tables(0).Rows(0)
        Return dr
    End Function

    Public Shared Function GetAllQuestionGroups() As DataSet
        Dim ds As DataSet
        ds = QpNormsDB.ExecuteDataSet("SP_NormAppUI_GetAllQuestionGroups")
        Return ds
    End Function

    Public Shared Function GetQuestionGroup(ByVal QuestionGroupID As Integer) As DataSet
        Dim ds As DataSet
        ds = QpNormsDB.ExecuteDataSet("SP_NormAppUI_GetQuestionGroup", QuestionGroupID)
        Return ds
    End Function

    Public Shared Function GetMeasures() As GroupingsCollection
        Dim tmpReader As SqlClient.SqlDataReader
        Dim tmpGroupings As New Groupings
        Dim tmpGroupingsCollection As New GroupingsCollection
        tmpReader = QpNormsDB.ExecuteReader(CommandType.StoredProcedure, "SP_NormAppUI_getMeasures")
        While tmpReader.Read
            tmpGroupings.GroupingName = CStr(tmpReader("strgrouping"))
            tmpGroupings.GroupingID = CInt(tmpReader("grouping_ID"))
            tmpGroupingsCollection.Add(tmpGroupings)
            tmpGroupings = New Groupings
        End While
        tmpReader.Close()
        Return tmpGroupingsCollection
    End Function

    Public Shared Function GetFilterColumns() As DataSet
        Return QpNormsDB.ExecuteDataSet(CommandType.StoredProcedure, "SP_NormAppUI_AvailableFilterColumns")
    End Function

    Public Shared Function GetFilterValues(ByRef ColumnName As String) As DataSet
        Return QpNormsDB.ExecuteDataSet("SP_NormAppUI_FilterColumnValues", ColumnName)
    End Function

    Public Shared Sub CheckFilterSyntax(ByVal criteria As String)
        Try
            QpNormsDB.ExecuteScalar(CommandType.Text, "Select top 0 * from facilityservicesView fs where " & criteria)
        Catch ex As Exception
            MsgBox(ex.ToString, MsgBoxStyle.Critical, "Syntax Check")
            Exit Sub
        End Try
        MsgBox("Syntax Check Successful", MsgBoxStyle.Information, "Syntax Check")
    End Sub

    Public Shared Function GetUSNormList(ByVal UseProduction As Boolean) As DataSet
        Dim ds As DataSet
        ds = QpNormsDB.ExecuteDataSet("SP_NormAppUI_getNormsList", UseProduction)
        Return ds
    End Function

    Public Shared Function GetComparisonList(ByVal norm_id As Integer) As DataSet
        Dim ds As DataSet
        ds = QpNormsDB.ExecuteDataSet("SP_NormAppUI_GetComparisonList", norm_id)
        Return ds
    End Function

    Public Shared Sub BackupNorms(ByVal ArchiveExtension As String)
        QpCommentsDB.ExecuteNonQuery("SP_APB_BackupNorms", ArchiveExtension)
    End Sub
#End Region

#Region " Canadian Norms"

    Public Shared Function GetCanadaNormList() As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader(CommandType.StoredProcedure, "SP_NormAppUI_GetCanadaNormList")
    End Function

    Public Shared Function LoadCanadaComparisons(ByVal normID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_LoadCanadaComparisons", normID)
    End Function

    Public Shared Function SelectCanadaClientUsed(ByVal normID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectClientUsed", normID)
    End Function

    Public Shared Function SelectCanadaClientUnused(ByVal normID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectClientUnused", normID)
    End Function

    Public Shared Function SelectCanadaNormSurvey(ByVal normID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectSurvey", normID, Nothing)
    End Function

    Public Shared Function SelectCanadaNormSurvey(ByVal normID As Integer, ByVal clientIDs As String) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectSurvey", normID, clientIDs)
    End Function

    Public Shared Function SelectCanadaNormRollup(ByVal normID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectRollup", normID, Nothing)
    End Function

    Public Shared Function SelectCanadaNormRollup(ByVal normID As Integer, ByVal clientIDs As String) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectRollup", normID, clientIDs)
    End Function

    Public Shared Function UpdateCanadaNormSettings( _
                                        ByVal normID As Integer, _
                                        ByVal normLabel As String, _
                                        ByVal normDescription As String, _
                                        ByVal criteriaStmt As String, _
                                        ByVal weightingType As Integer, _
                                        ByVal reportDateBegin As Date, _
                                        ByVal reportDateEnd As Date, _
                                        ByVal returnDateMax As Date, _
                                        ByVal doneBy As Integer, _
                                        ByVal hasAvgNorm As Boolean, _
                                        ByVal avgNormCompTypeID As Integer, _
                                        ByVal avgNormLabel As String, _
                                        ByVal avgNormDescription As String, _
                                        ByVal hasHpNorm As Boolean, _
                                        ByVal hpNormCompTypeID As Integer, _
                                        ByVal hpNormLabel As String, _
                                        ByVal hpNormDescription As String, _
                                        ByVal hpNormUnitIncluded As Integer, _
                                        ByVal hasLpNorm As Boolean, _
                                        ByVal lpNormCompTypeID As Integer, _
                                        ByVal lpNormLabel As String, _
                                        ByVal lpNormDescription As String, _
                                        ByVal lpNormUnitIncluded As Integer, _
                                        ByVal surveyList() As StringBuilder, _
                                        ByVal rollupList() As StringBuilder _
                                    ) As SqlClient.SqlDataReader

        Return QpNormsDB.ExecuteReader( _
                                  "SP_NormAppUI_UpdateCanadaNormSetting", _
                                  normID, _
                                  normLabel, _
                                  normDescription, _
                                  criteriaStmt, _
                                  weightingType, _
                                  reportDateBegin, _
                                  reportDateEnd, _
                                  returnDateMax, _
                                  doneBy, _
                                  hasAvgNorm, _
                                  avgNormCompTypeID, _
                                  avgNormLabel, _
                                  avgNormDescription, _
                                  hasHpNorm, _
                                  hpNormCompTypeID, _
                                  hpNormLabel, _
                                  hpNormDescription, _
                                  hpNormUnitIncluded, _
                                  hasLpNorm, _
                                  lpNormCompTypeID, _
                                  lpNormLabel, _
                                  lpNormDescription, _
                                  lpNormUnitIncluded, _
                                  surveyList(0).ToString, _
                                  surveyList(1).ToString, _
                                  surveyList(2).ToString, _
                                  surveyList(3).ToString, _
                                  surveyList(4).ToString, _
                                  rollupList(0).ToString _
                                 )

    End Function

    Public Shared Function SelectCanadaNormApproveInfo(ByVal normID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectApproveInfo", normID)
    End Function

    Public Shared Sub UpdateCanadaNormApproveStatus(ByVal normID As Integer, ByVal checkItem As Integer, ByVal approveStatus As Integer, ByVal approverMemberID As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_UpdateApproveStatus", normID, checkItem, approveStatus, approverMemberID)
    End Sub

    Public Shared Function SelectCanadaSchedulableNorm() As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectSchedulableNorm")
    End Function

    Public Shared Function CheckNormSchedulable(ByVal normID As Integer) As Integer
        Return CInt(QpNormsDB.ExecuteScalar("SP_NormAppUI_CheckNormSchedulable", normID))
    End Function

    Public Shared Sub ScheduleCanadaNormUpdate(ByVal normID As Integer, ByVal schedulerMemberID As Integer, ByVal scheduledStartTime As Date)
        If (scheduledStartTime = Date.MinValue) Then
            QpNormsDB.ExecuteNonQuery("SP_NormAppUI_ScheduleJob", normID, schedulerMemberID, Nothing)
        Else
            QpNormsDB.ExecuteNonQuery("SP_NormAppUI_ScheduleJob", normID, schedulerMemberID, scheduledStartTime)
        End If
    End Sub

    Public Shared Function SelectCanadaJobQueue(ByVal days As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectJobQueue", days)
    End Function

    Public Shared Sub ApproveCanadaNormUpdate(ByVal normJobID As Integer, ByVal isApprove As Boolean)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_ApproveJob", normJobID, isApprove)
    End Sub

    Public Shared Sub RemoveCanadaNormJob(ByVal normJobID As Integer)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_RemoveJob", normJobID)
    End Sub

    Public Shared Function SelectCanadaAllRollup() As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectAllRollup")
    End Function

    Public Shared Function SelectCanadaRollupSurvey(ByVal rollupID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectRollupSurvey", rollupID)
    End Function

    Public Shared Function UpdateCanadaRollup(ByVal rollupID As Integer, _
                                              ByVal rollupName As String, _
                                              ByVal Description As String, _
                                              ByVal surveys As StringBuilder) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_UpdateRollup", rollupID, rollupName, Description, surveys.ToString)
    End Function

    Public Shared Function SelectCanadaUsedRollup(ByVal rollups As String) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectUsedRollup", rollups)
    End Function

    Public Shared Function SelectCanadaComparisons(ByVal normID As Integer) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectCanadaComparisons", normID)
    End Function

    Public Shared Sub DeleteCanadaRollup(ByVal rollups As String)
        QpNormsDB.ExecuteNonQuery("SP_NormAppUI_DeleteRollup", rollups)
    End Sub

    Public Shared Function SelectCanadaInvalidSurvey(ByVal surveyList() As StringBuilder) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectInvalidSurvey", surveyList(0).ToString, surveyList(1).ToString, surveyList(2).ToString, surveyList(3).ToString, surveyList(4).ToString)
    End Function

    Public Shared Function SelectCanadaLoadedSurvey(ByVal surveyList() As StringBuilder) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader("SP_NormAppUI_SelectLoadedSurvey", surveyList(0).ToString, surveyList(1).ToString, surveyList(2).ToString, surveyList(3).ToString, surveyList(4).ToString)
    End Function

    Public Shared Function IsNormLabelExist(ByVal normID As Integer, ByVal normLabel As String) As Boolean
        Return CBool(QpNormsDB.ExecuteScalar("SP_NormAppUI_IsNormLabelExist", normID, normLabel))
    End Function

    Public Shared Function IsComparisonLabelExist(ByVal compTypeID As Integer, ByVal compTypeLabel As String) As Boolean
        Return CBool(QpNormsDB.ExecuteScalar("SP_NormAppUI_IsComparisonLabelExist", compTypeID, compTypeLabel))
    End Function

    Public Shared Sub CheckCanadaCriteria(ByVal criteriaStmt As String, ByVal surveyList() As StringBuilder)
        QpNormsDB.ExecuteNonQuery( _
                                  "SP_NormAppUI_CheckCanadaCriteria", _
                                  criteriaStmt, _
                                  surveyList(0).ToString, _
                                  surveyList(1).ToString, _
                                  surveyList(2).ToString, _
                                  surveyList(3).ToString, _
                                  surveyList(4).ToString)
    End Sub

    Public Shared Function SelectCanadaTableColumn(ByVal surveyList() As StringBuilder) As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader( _
                                  "SP_NormAppUI_SelectTableColumn", _
                                  surveyList(0).ToString, _
                                  surveyList(1).ToString, _
                                  surveyList(2).ToString, _
                                  surveyList(3).ToString, _
                                  surveyList(4).ToString)
    End Function

    Public Shared Function SelectCanadaBenchmarkNorm() As SqlClient.SqlDataReader
        Return QpNormsDB.ExecuteReader( _
                                  "SP_NormAppUI_SelectCanadaBenchmarkNorm")
    End Function

#End Region

End Class
