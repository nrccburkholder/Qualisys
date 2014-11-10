Imports System.Collections.ObjectModel
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Public Class SqlDataProvider
    Inherits DataProvider

#Region " Private Members "
    Private Delegate Function FillMethod(Of T)(ByVal rdr As SafeDataReader) As T
    Private mDbInstance As Database

    Friend ReadOnly Property Db() As Database
        Get
            If mDbInstance Is Nothing Then
                mDbInstance = New Sql.SqlDatabase(Config.DataMartConnection)
            End If

            Return mDbInstance
        End Get
    End Property
#End Region

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub

        Public Const SelectAllScheduledExports As String = "DBO.DCL_SelectScheduledExports"
        Public Const SelectClient As String = "DBO.DCL_SelectClient"
        Public Const SelectClientsStudiesAndSurveysByUser As String = "DBO.DCL_SelectClientsStudiesAndSurveysByUser"
        Public Const SelectExportFileData As String = "DBO.DCL_ExportCreateFile"
        Public Const SelectExportFilesAwaitingNotification As String = "DBO.DCL_SelectExportFilesAwaitingNotification"
        Public Const SelectExportFilesByExportSetId As String = "DBO.DCL_SelectExportFilesByExportSetId"
        Public Const SelectExportSet As String = "DBO.DCL_SelectExportSet"
        Public Const SelectExportSetsByClientId As String = "DBO.DCL_SelectExportSetsByClientId"
        Public Const SelectExportSetsByStudyId As String = "DBO.DCL_SelectExportSetsByStudyId"
        Public Const SelectExportSetsBySurveyId As String = "DBO.DCL_SelectExportSetsBySurveyId"
        Public Const SelectExportSetsBySampleUnitId As String = "DBO.DCL_SelectExportSetsBySampleUnitId"
        Public Const SelectExportSetsByExportFileId As String = "DBO.DCL_SelectExportSetsByExportFileId"
        Public Const SelectHcahpsClientsStudiesSurveysAndUnitsByUser As String = "DBO.DCL_SelectHCAHPSClientsStudiesSurveysAndUnitsByUser"
        Public Const SelectHHcahpsClientsStudiesSurveysAndUnitsByUser As String = "DBO.DCL_SelectHHCAHPSClientsStudiesSurveysAndUnitsByUser"
        Public Const SelectCHARTClientsStudiesSurveysAndUnitsByUser As String = "DBO.DCL_SelectCHARTClientsStudiesSurveysAndUnitsByUser"
        Public Const SelectNextScheduledExport As String = "DBO.DCL_SelectNextScheduledExport"
        Public Const SelectQuestionsbySurveyId As String = "DBO.DCL_SelectQuestionsbySurveyId"
        Public Const SelectResponsesbySurveyIdandScaleid As String = "DBO.DCL_SelectResponsesbySurveyIdandScaleid"
        Public Const SelectSampleSet As String = "DBO.DCL_SelectSampleSet"
        Public Const SelectSampleUnit As String = "DBO.DCL_SelectSampleUnit"
        Public Const SelectSampleUnitsByMedicareNumber As String = "DBO.DCL_SelectSampleUnitsByMedicareNumber"
        Public Const SelectScalebySurveyIdandScaleid As String = "DBO.DCL_SelectScalebySurveyIdandScaleId"
        Public Const SelectScheduledExport As String = "DBO.DCL_SelectScheduledExport"
        Public Const SelectScheduledExportsByClientId As String = "DBO.DCL_SelectScheduledExportsByClient"
        Public Const SelectScheduledExportsByStudyId As String = "DBO.DCL_SelectScheduledExportsByStudy"
        Public Const SelectScheduledExportsBySurveyId As String = "DBO.DCL_SelectScheduledExportsBySurvey"
        Public Const SelectStudy As String = "DBO.DCL_SelectStudy"
        Public Const SelectSurvey As String = "DBO.DCL_SelectSurvey"
        Public Const SelectSurveysByStudyId As String = "DBO.DCL_SelectSurveysByStudyId"
        Public Const SelectWeightType As String = "DBO.DCL_SelectWeightType"
        Public Const SelectWeightTypes As String = "DBO.DCL_SelectWeightTypes"

        Public Const InsertExportFile As String = "DBO.DCL_InsertExportFile"
        Public Const InsertExportFileExportSet As String = "DBO.DCL_InsertExportFileExportSet"
        Public Const InsertExportSet As String = "DBO.DCL_ExportInsertExportSet"
        Public Const InsertScheduledExport As String = "DBO.DCL_InsertScheduledExport"
        Public Const InsertScheduledExportSet As String = "DBO.DCL_InsertScheduledExportSet"
        Public Const InsertWeightType As String = "DBO.DCL_InsertWeightType"
        Public Const InsertWeightValues As String = "DBO.DCL_InsertWeightValues"

        Public Const UpdateExportFile As String = "DBO.DCL_UpdateExportFile"
        Public Const UpdateExportFileErrorMessage As String = "DBO.DCL_UpdateExportFileErrorMessage"
        Public Const UpdateScheduledExport As String = "DBO.DCL_UpdateScheduledExport"
        Public Const UpdateWeightType As String = "DBO.DCL_UpdateWeightType"

        Public Const DeleteExportSet As String = "DBO.DCL_DeleteExportSet"
        Public Const DeleteScheduledExport As String = "DBO.DCL_DeleteScheduledExport"
        Public Const DeleteWeightType As String = "DBO.DCL_DeleteWeightType"

        Public Const RebuildExportSet As String = "DBO.DCL_ExportRebuildExportSet"
        Public Const IsWeightTypeDeletable As String = "DBO.DCL_IsWeightTypeDeletable"


        Public Const DeleteRule As String = "dbo.DCL_DeleteRule"
        Public Const InsertRule As String = "dbo.DCL_InsertRule"
        Public Const SelectAllRules As String = "dbo.DCL_SelectAllRules"
        Public Const SelectRule As String = "dbo.DCL_SelectRule"
        Public Const SelectRulesByRuleTypeID As String = "dbo.DCL_SelectRulesByRuleTypeID"
        Public Const UpdateRule As String = "dbo.DCL_UpdateRule"

        Public Const DeleteRuleClause As String = "dbo.SP_DeleteRuleClause"
        Public Const InsertRuleClause As String = "dbo.SP_InsertRuleClause"
        Public Const SelectAllRuleClauses As String = "dbo.SP_SelectAllRuleClauses"
        Public Const SelectRuleClause As String = "dbo.SP_SelectRuleClause"
        Public Const SelectRuleClausesByRuleID As String = "dbo.SP_SelectRuleClausesByRuleID"
        Public Const UpdateRuleClause As String = "dbo.SP_UpdateRuleClause"

        Public Const DeleteRuleInlist As String = "dbo.SP_DeleteRuleInlist"
        Public Const InsertRuleInlist As String = "dbo.SP_InsertRuleInlist"
        Public Const SelectAllRuleInlists As String = "dbo.SP_SelectAllRuleInlists"
        Public Const SelectRuleInlist As String = "dbo.SP_SelectRuleInlist"
        Public Const SelectRuleInlistsByRuleClauseID As String = "dbo.SP_SelectRuleInlistsByRuleClauseID"
        Public Const UpdateRuleInlist As String = "dbo.SP_UpdateRuleInlist"

        Public Const DeleteRuleType As String = "dbo.SP_DeleteRuleType"
        Public Const InsertRuleType As String = "dbo.SP_InsertRuleType"
        Public Const SelectAllRuleTypes As String = "dbo.SP_SelectAllRuleTypes"
        Public Const SelectRuleType As String = "dbo.SP_SelectRuleType"
        Public Const UpdateRuleType As String = "dbo.SP_UpdateRuleType"

        Public Const SelectTeams As String = "dbo.DCL_SelectTeams"

        'SK 10/08/2008 For Special Update
        Public Const SpecialSurveyUpdate As String = "dbo.SP_SpecialSurveyUpdate"

        'ORYX
        Public Const ORYXSelectMeasurements As String = "dbo.ORYX_SelectMeasurements"
        Public Const ORYXSelectQuestions As String = "dbo.ORYX_SelectQuestions"
        Public Const ORYXSelectAnswerMapping As String = "dbo.ORYX_SelectAnswerMapping"
        Public Const ORYXSelectLastFileNum As String = "dbo.ORYX_SelectLastUsedFileNumber"
        Public Const ORYXUpdateLastFileNum As String = "dbo.ORYX_UpdateLastUsedFileNumber"
        Public Const ORYXSelectHCOByClientID As String = "dbo.ORYX_SelectHCOByClientID"
        Public Const ORYXSelectClientIDByExportSetID As String = "dbo.ORYX_SelectClientIDByExportSetID"
        Public Const ORYXSelectClientIDByHCOID As String = "dbo.ORYX_SelectClientIDByHCOID"
        Public Const ORYX_SelectParentSampleUnitIDsByHCOID As String = "dbo.ORYX_SelectParentSampleUnitIDsByHCOID"
        Public Const ORYX_SelectAllORYXClients As String = "dbo.ORYX_SelectAllOryxClients"
        Public Const ORYX_SelectAllNonORYXClients As String = "dbo.ORYX_SelectAllNonOryxClients"
        Public Const ORYX_AddOryxClient As String = "dbo.ORYX_AddOryxClient"
        Public Const ORYX_DeleteMeasuresByHCO As String = "dbo.ORYX_DeleteMeasuresByHCO"
        Public Const ORYX_AddMeasureByHCO As String = "dbo.ORYX_AddMeasuresByHCO"
        Public Const ORYX_SelectQuestionText As String = "dbo.ORYX_SelectQuestionText"
        Public Const ORYX_SelectScale As String = "dbo.ORYX_SelectScale"
        Public Const ORYX_AddOryxMeasurement As String = "dbo.ORYX_AddMeasurement"
        Public Const ORYX_UpdateAnswerMapping As String = "dbo.ORYX_UpdateAnswerMapping"
        Public Const ORYX_DeleteQuestionsByMeasure As String = "dbo.ORYX_DeleteQuestionsByMeasure"
        Public Const ORYX_AddQuestionToMeasure As String = "dbo.ORYX_AddQuestionToMeasure"

        Public Const SelectAllDistinctMedicareExport As String = "DBO.QCL_SelectAllDistinctMedicareExport"
        Public Const SelectMedicareExport As String = "DBO.QCL_SelectMedicareExport"

        Public Const InsertMedicareExportSet As String = "dbo.dcl_ExportInsertMedicareExportSets"
        Public Const SelectMedicareExportSet As String = "dbo.DCL_SelectMedicareExportSet"
        Public Const SelectMedicareExportFileData As String = "DBO.DCL_ExportCreateFile_ByMedicareNumber"
        Public Const SelectExportFileByFileType As String = "dbo.QCL_SelectExportFileView_ByDate"
        Public Const SelectExportFileByFileTypeAllDetails As String = "dbo.QCL_SelectExportFileViewAllDetails_ByDate"
        Public Const SelectOCSExportFileData As String = "DBO.DCL_ExportCreateFile_ReturnData"
        Public Const SelectFileGUIDsByClientGroup As String = "DBO.DCL_ExportCreateFile_GetFileGUID_ByClientGroup"
        Public Const UpdateExportFileTracking As String = "DBO.DCL_UpdateExportFileTracking"

        Public Const SelectAllACOCAHPSBySurveyId As String = "dbo.DCL_SelectACOCAHPSBySurveyId"
    End Class
#End Region

#Region " Helper Functions "

    Friend Function ExecuteReader(ByVal cmd As DbCommand) As IDataReader
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteReader(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteReader(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As IDataReader
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteReader(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteDataSet(ByVal cmd As DbCommand) As DataSet
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteDataSet(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteDataSet(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As DataSet
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteDataSet(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Sub ExecuteNonQuery(ByVal cmd As DbCommand)
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Db.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Sub ExecuteNonQuery(ByVal cmd As DbCommand, ByVal transaction As DbTransaction)
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Db.ExecuteNonQuery(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Function ExecuteScalar(ByVal cmd As DbCommand) As Object
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteScalar(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteScalar(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Object
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteScalar(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteInteger(ByVal cmd As DbCommand) As Integer
        Return CType(ExecuteScalar(cmd), Integer)
    End Function

    Friend Function ExecuteInteger(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Integer
        Return CType(ExecuteScalar(cmd, transaction), Integer)
    End Function

    Friend Function ExecuteBoolean(ByVal cmd As DbCommand) As Boolean
        Return CType(ExecuteScalar(cmd), Boolean)
    End Function

    Friend Function ExecuteBoolean(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Boolean
        Return CType(ExecuteScalar(cmd, transaction), Boolean)
    End Function

    'Legacy PopulateCollection method
    Private Overloads Shared Function PopulateCollection(Of T)(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As Collection(Of T)
        Dim list As New Collection(Of T)
        While rdr.Read
            list.Add(populateMethod(rdr))
        End While

        Return list
    End Function

    'CSLA Framework PopulateCollection method
    Private Overloads Function PopulateCollection(Of C As {BusinessListBase(Of C, T), New}, T As BusinessBase(Of T))(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C
        Dim list As New C
        While rdr.Read
            list.Add(populateMethod(rdr))
        End While

        Return list
    End Function

#End Region

#Region " Client Procs "
    Private Shared Function PopulateClient(ByVal rdr As SafeDataReader) As Client
        Dim newObject As New Client
        ReadOnlyAccessor.ClientId(newObject) = rdr.GetInteger("Client_id")
        newObject.Name = rdr.GetString("strClient_NM").Trim
        newObject.ResetDirtyFlag()

        Return newObject
    End Function

    Public Overrides Function SelectClient(ByVal clientId As Integer) As Client
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClient, clientId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateClient(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectClientsAndStudiesByUser(ByVal userName As String) As System.Collections.ObjectModel.Collection(Of Client)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientsStudiesAndSurveysByUser, userName)
        Using ds As DataSet = ExecuteDataSet(cmd)
            ds.Relations.Add("ClientStudy", ds.Tables(0).Columns("Client_id"), ds.Tables(1).Columns("Client_id"))
            ds.Relations.Add("StudySurvey", ds.Tables(1).Columns("Study_id"), ds.Tables(2).Columns("Study_id"))
            Dim clientList As New Collection(Of Client)
            Dim clnt As Client
            Dim stdy As Study

            'Iterate through each client row
            For Each row As DataRow In ds.Tables(0).Rows
                'Create a new client object and specify what will be the study collection
                Dim studies As New Collection(Of Study)
                clnt = New Client(studies)
                'Get the client data
                ReadOnlyAccessor.ClientId(clnt) = CInt(row("Client_id"))
                clnt.Name = row("strClient_nm").ToString().Trim()

                'Iterate through each study related to the client row
                For Each childStudy As DataRow In row.GetChildRows("ClientStudy")
                    'Create a new study object and specify what will be the survey collection
                    Dim surveys As New Collection(Of Survey)
                    stdy = New Study(clnt, surveys)
                    'Get the study data
                    ReadOnlyAccessor.StudyId(stdy) = CInt(childStudy("Study_id"))
                    stdy.Name = childStudy("strStudy_nm").ToString().Trim
                    stdy.ClientId = CInt(childStudy("Client_id"))
                    'AD information is not consistent in the datamart, so we are not using it
                    'stdy.AccountDirectorName = childStudy("AD").ToString.Trim

                    'Add the study to the study collection
                    studies.Add(stdy)
                Next
                'Add the client to the client collection
                clientList.Add(clnt)
            Next

            Return clientList

        End Using

    End Function

    Public Overrides Function SelectClientsStudiesAndSurveysByUser(ByVal userName As String) As System.Collections.ObjectModel.Collection(Of Client)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientsStudiesAndSurveysByUser, userName)
        Using ds As DataSet = ExecuteDataSet(cmd)
            ds.Relations.Add("ClientStudy", ds.Tables(0).Columns("Client_id"), ds.Tables(1).Columns("Client_id"))
            ds.Relations.Add("StudySurvey", ds.Tables(1).Columns("Study_id"), ds.Tables(2).Columns("Study_id"))
            Dim clientList As New Collection(Of Client)
            Dim clnt As Client
            Dim stdy As Study

            'Iterate through each client row
            For Each row As DataRow In ds.Tables(0).Rows
                'Create a new client object and specify what will be the study collection
                Dim studies As New Collection(Of Study)
                clnt = New Client(studies)
                'Get the client data
                ReadOnlyAccessor.ClientId(clnt) = CInt(row("Client_id"))
                clnt.Name = row("strClient_nm").ToString().Trim()

                'Iterate through each study related to the client row
                For Each childStudy As DataRow In row.GetChildRows("ClientStudy")
                    'Create a new study object and specify what will be the survey collection
                    Dim surveys As New Collection(Of Survey)
                    stdy = New Study(clnt, surveys)
                    'Get the study data
                    ReadOnlyAccessor.StudyId(stdy) = CInt(childStudy("Study_id"))
                    stdy.Name = childStudy("strStudy_nm").ToString().Trim
                    stdy.ClientId = CInt(childStudy("Client_id"))
                    'AD information is not consistent in the datamart, so we are not using it
                    'stdy.AccountDirectorName = childStudy("AD").ToString.Trim

                    'Iterate through each survey related to the study row
                    For Each childSurvey As DataRow In childStudy.GetChildRows("StudySurvey")
                        'Get the survey data
                        Dim srvy As New Survey(stdy)
                        ReadOnlyAccessor.SurveyId(srvy) = CInt(childSurvey("Survey_id"))
                        srvy.Name = childSurvey("strQSurvey_nm").ToString.Trim
                        srvy.Description = childSurvey("strSurvey_nm").ToString.Trim
                        srvy.StudyId = CInt(childSurvey("Study_id"))

                        'Create the new survey object and add it to the survey collection
                        surveys.Add(srvy)
                    Next
                    'Add the study to the study collection
                    studies.Add(stdy)
                Next
                'Add the client to the client collection
                clientList.Add(clnt)
            Next

            Return clientList

        End Using

    End Function

    Public Overrides Function SelectHcahpsClientsByUser(ByVal userName As String, ByVal unitList As Collection(Of SampleUnit)) As Collection(Of Client)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectHcahpsClientsStudiesSurveysAndUnitsByUser, userName)
        Dim clientList As New Collection(Of Client)

        Using ds As DataSet = ExecuteDataSet(cmd)
            ds.Relations.Add("ClientStudy", ds.Tables(0).Columns("Client_id"), ds.Tables(1).Columns("Client_id"))
            ds.Relations.Add("StudySurvey", ds.Tables(1).Columns("Study_id"), ds.Tables(2).Columns("Study_id"))
            Dim clnt As Client
            Dim stdy As Study

            'Iterate through each client row
            For Each row As DataRow In ds.Tables(0).Rows
                'Create a new client object and specify what will be the study collection
                Dim studies As New Collection(Of Study)
                clnt = New Client(studies)
                'Get the client data
                ReadOnlyAccessor.ClientId(clnt) = CInt(row("Client_id"))
                clnt.Name = row("strClient_nm").ToString().Trim()

                'Iterate through each study related to the client row
                For Each childStudy As DataRow In row.GetChildRows("ClientStudy")
                    'Create a new study object and specify what will be the survey collection
                    Dim surveys As New Collection(Of Survey)
                    stdy = New Study(clnt, surveys)
                    'Get the study data
                    ReadOnlyAccessor.StudyId(stdy) = CInt(childStudy("Study_id"))
                    stdy.Name = childStudy("strStudy_nm").ToString().Trim
                    stdy.ClientId = CInt(childStudy("Client_id"))
                    'AD information is not consistent in the datamart, so we are not using it
                    'stdy.AccountDirectorName = childStudy("AD").ToString.Trim

                    'Iterate through each survey related to the study row
                    For Each childSurvey As DataRow In childStudy.GetChildRows("StudySurvey")
                        'Get the survey data
                        Dim srvy As New Survey(stdy)
                        ReadOnlyAccessor.SurveyId(srvy) = CInt(childSurvey("Survey_id"))
                        srvy.Name = childSurvey("strQSurvey_nm").ToString.Trim
                        srvy.Description = childSurvey("strSurvey_nm").ToString.Trim
                        srvy.StudyId = CInt(childSurvey("Study_id"))

                        'Create the new survey object and add it to the survey collection
                        surveys.Add(srvy)
                    Next
                    'Add the study to the study collection
                    studies.Add(stdy)
                Next
                'Add the client to the client collection
                clientList.Add(clnt)
            Next
            For Each row As DataRow In ds.Tables(3).Rows
                Dim unit As New SampleUnit
                ReadOnlyAccessor.SampleUnitId(unit) = CInt(row("SampleUnit_id"))
                unit.Name = row("strSampleUnit_NM").ToString
                unit.SurveyId = CInt(row("Survey_id"))
                If row.IsNull("ParentSampleUnit_ID") Then
                    unit.ParentSampleUnitId = Nothing
                Else
                    unit.ParentSampleUnitId = CInt(row("ParentSampleUnit_ID"))
                End If
                unit.MedicareNumber = row("MedicareNumber").ToString
                If IsDBNull(row("bitHCAHPS")) Then
                    unit.IsHcahps = False
                Else
                    unit.IsHcahps = CType(row("bitHCAHPS"), Boolean)
                End If

                unit.ResetDirtyFlag()
                unitList.Add(unit)
            Next

        End Using

        Return clientList
    End Function

    Public Overrides Function SelectHHcahpsClientsByUser(ByVal userName As String, ByVal unitList As Collection(Of SampleUnit)) As Collection(Of Client)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectHHcahpsClientsStudiesSurveysAndUnitsByUser, userName)
        Dim clientList As New Collection(Of Client)

        Using ds As DataSet = ExecuteDataSet(cmd)
            ds.Relations.Add("ClientStudy", ds.Tables(0).Columns("Client_id"), ds.Tables(1).Columns("Client_id"))
            ds.Relations.Add("StudySurvey", ds.Tables(1).Columns("Study_id"), ds.Tables(2).Columns("Study_id"))
            Dim clnt As Client
            Dim stdy As Study

            'Iterate through each client row
            For Each row As DataRow In ds.Tables(0).Rows
                'Create a new client object and specify what will be the study collection
                Dim studies As New Collection(Of Study)
                clnt = New Client(studies)
                'Get the client data
                ReadOnlyAccessor.ClientId(clnt) = CInt(row("Client_id"))
                clnt.Name = row("strClient_nm").ToString().Trim()

                'Iterate through each study related to the client row
                For Each childStudy As DataRow In row.GetChildRows("ClientStudy")
                    'Create a new study object and specify what will be the survey collection
                    Dim surveys As New Collection(Of Survey)
                    stdy = New Study(clnt, surveys)
                    'Get the study data
                    ReadOnlyAccessor.StudyId(stdy) = CInt(childStudy("Study_id"))
                    stdy.Name = childStudy("strStudy_nm").ToString().Trim
                    stdy.ClientId = CInt(childStudy("Client_id"))
                    'AD information is not consistent in the datamart, so we are not using it
                    'stdy.AccountDirectorName = childStudy("AD").ToString.Trim

                    'Iterate through each survey related to the study row
                    For Each childSurvey As DataRow In childStudy.GetChildRows("StudySurvey")
                        'Get the survey data
                        Dim srvy As New Survey(stdy)
                        ReadOnlyAccessor.SurveyId(srvy) = CInt(childSurvey("Survey_id"))
                        srvy.Name = childSurvey("strQSurvey_nm").ToString.Trim
                        srvy.Description = childSurvey("strSurvey_nm").ToString.Trim
                        srvy.StudyId = CInt(childSurvey("Study_id"))

                        'Create the new survey object and add it to the survey collection
                        surveys.Add(srvy)
                    Next
                    'Add the study to the study collection
                    studies.Add(stdy)
                Next
                'Add the client to the client collection
                clientList.Add(clnt)
            Next
            For Each row As DataRow In ds.Tables(3).Rows
                Dim unit As New SampleUnit
                ReadOnlyAccessor.SampleUnitId(unit) = CInt(row("SampleUnit_id"))
                unit.Name = row("strSampleUnit_NM").ToString
                unit.SurveyId = CInt(row("Survey_id"))
                If row.IsNull("ParentSampleUnit_ID") Then
                    unit.ParentSampleUnitId = Nothing
                Else
                    unit.ParentSampleUnitId = CInt(row("ParentSampleUnit_ID"))
                End If
                unit.MedicareNumber = row("MedicareNumber").ToString
                If IsDBNull(row("bitHCAHPS")) Then
                    unit.IsHcahps = False
                Else
                    unit.IsHcahps = CType(row("bitHCAHPS"), Boolean)
                End If

                unit.ResetDirtyFlag()
                unitList.Add(unit)
            Next

        End Using

        Return clientList
    End Function

    Public Overrides Function SelectCHARTClientsByUser(ByVal userName As String, ByVal unitList As System.Collections.ObjectModel.Collection(Of SampleUnit)) As System.Collections.ObjectModel.Collection(Of Client)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCHARTClientsStudiesSurveysAndUnitsByUser, userName)
        Dim clientList As New Collection(Of Client)

        Using ds As DataSet = ExecuteDataSet(cmd)
            ds.Relations.Add("ClientStudy", ds.Tables(0).Columns("Client_id"), ds.Tables(1).Columns("Client_id"))
            ds.Relations.Add("StudySurvey", ds.Tables(1).Columns("Study_id"), ds.Tables(2).Columns("Study_id"))
            Dim clnt As Client
            Dim stdy As Study

            'Iterate through each client row
            For Each row As DataRow In ds.Tables(0).Rows
                'Create a new client object and specify what will be the study collection
                Dim studies As New Collection(Of Study)
                clnt = New Client(studies)
                'Get the client data
                ReadOnlyAccessor.ClientId(clnt) = CInt(row("Client_id"))
                clnt.Name = row("strClient_nm").ToString().Trim()

                'Iterate through each study related to the client row
                For Each childStudy As DataRow In row.GetChildRows("ClientStudy")
                    'Create a new study object and specify what will be the survey collection
                    Dim surveys As New Collection(Of Survey)
                    stdy = New Study(clnt, surveys)
                    'Get the study data
                    ReadOnlyAccessor.StudyId(stdy) = CInt(childStudy("Study_id"))
                    stdy.Name = childStudy("strStudy_nm").ToString().Trim
                    stdy.ClientId = CInt(childStudy("Client_id"))
                    'AD information is not consistent in the datamart, so we are not using it
                    'stdy.AccountDirectorName = childStudy("AD").ToString.Trim

                    'Iterate through each survey related to the study row
                    For Each childSurvey As DataRow In childStudy.GetChildRows("StudySurvey")
                        'Get the survey data
                        Dim srvy As New Survey(stdy)
                        ReadOnlyAccessor.SurveyId(srvy) = CInt(childSurvey("Survey_id"))
                        srvy.Name = childSurvey("strQSurvey_nm").ToString.Trim
                        srvy.Description = childSurvey("strSurvey_nm").ToString.Trim
                        srvy.StudyId = CInt(childSurvey("Study_id"))

                        'Create the new survey object and add it to the survey collection
                        surveys.Add(srvy)
                    Next
                    'Add the study to the study collection
                    studies.Add(stdy)
                Next
                'Add the client to the client collection
                clientList.Add(clnt)
            Next
            For Each row As DataRow In ds.Tables(3).Rows
                Dim unit As New SampleUnit
                ReadOnlyAccessor.SampleUnitId(unit) = CInt(row("SampleUnit_id"))
                unit.Name = row("strSampleUnit_NM").ToString
                unit.SurveyId = CInt(row("Survey_id"))
                If row.IsNull("ParentSampleUnit_ID") Then
                    unit.ParentSampleUnitId = Nothing
                Else
                    unit.ParentSampleUnitId = CInt(row("ParentSampleUnit_ID"))
                End If
                unit.MedicareNumber = row("MedicareNumber").ToString
                If IsDBNull(row("bitHCAHPS")) Then
                    unit.IsHcahps = False
                Else
                    unit.IsHcahps = CType(row("bitHCAHPS"), Boolean)
                End If

                unit.ResetDirtyFlag()
                unitList.Add(unit)
            Next

        End Using

        Return clientList
    End Function
#End Region

#Region " ExportSet Procs "

    Private Shared Function PopulateExportSet(ByVal rdr As SafeDataReader) As ExportSet
        Dim newObject As New ExportSet
        ReadOnlyAccessor.ExportSetId(newObject) = rdr.GetInteger("ExportSetId")
        newObject.Name = rdr.GetString("ExportSetName")
        newObject.SurveyId = rdr.GetInteger("Survey_id")
        newObject.StartDate = rdr.GetDate("EncounterStartDate")
        newObject.EndDate = rdr.GetDate("EncounterEndDate")
        newObject.ReportDateField = rdr.GetString("ReportDateField")
        ReadOnlyAccessor.ExportSetCreationDate(newObject) = rdr.GetDate("UpdatedDate")
        ReadOnlyAccessor.ExportSetCreationEmployeeName(newObject) = rdr.GetString("CreatedEmployeeName")
        newObject.SampleUnitId = rdr.GetInteger("SampleUnit_id")
        ReadOnlyAccessor.ExportSetType(newObject) = CType(rdr.GetInteger("ExportSetTypeID"), ExportSetType)
        newObject.ResetDirtyFlag()

        Return newObject
    End Function

    Public Overrides Function SelectExportSet(ByVal exportSetId As Integer) As ExportSet
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportSet, exportSetId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateExportSet(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectExportSetsByExportFileId(ByVal exportFileId As Integer) As System.Collections.ObjectModel.Collection(Of ExportSet)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportSetsByExportFileId, exportFileId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportSet)(rdr, AddressOf PopulateExportSet)
        End Using
    End Function

    Public Overrides Function SelectExportSetsByClientId(ByVal clientId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Dim startDate As Object
        Dim endDate As Object
        If creationFilterStartDate.HasValue Then
            startDate = creationFilterStartDate.Value
        Else
            startDate = DBNull.Value
        End If
        If creationFilterEndDate.HasValue Then
            endDate = creationFilterEndDate.Value
        Else
            endDate = DBNull.Value
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportSetsByClientId, clientId, exportType, startDate, endDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportSet)(rdr, AddressOf PopulateExportSet)
        End Using
    End Function

    Public Overrides Function SelectExportSetsByStudyId(ByVal studyId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Dim startDate As Object
        Dim endDate As Object
        If creationFilterStartDate.HasValue Then
            startDate = creationFilterStartDate.Value
        Else
            startDate = DBNull.Value
        End If
        If creationFilterEndDate.HasValue Then
            endDate = creationFilterEndDate.Value
        Else
            endDate = DBNull.Value
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportSetsByStudyId, studyId, exportType, startDate, endDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportSet)(rdr, AddressOf PopulateExportSet)
        End Using
    End Function

    Public Overrides Function SelectExportSetsBySurveyId(ByVal surveyId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Dim startDate As Object
        Dim endDate As Object
        If creationFilterStartDate.HasValue Then
            startDate = creationFilterStartDate.Value
        Else
            startDate = DBNull.Value
        End If
        If creationFilterEndDate.HasValue Then
            endDate = creationFilterEndDate.Value
        Else
            endDate = DBNull.Value
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportSetsBySurveyId, surveyId, exportType, startDate, endDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportSet)(rdr, AddressOf PopulateExportSet)
        End Using
    End Function

    Public Overrides Function SelectExportSetsBySampleUnitId(ByVal sampleUnitId As Integer, ByVal creationFilterStartDate As System.Nullable(Of Date), ByVal creationFilterEndDate As System.Nullable(Of Date), ByVal exportType As ExportSetType) As System.Collections.ObjectModel.Collection(Of ExportSet)
        Dim startDate As Object
        Dim endDate As Object
        If creationFilterStartDate.HasValue Then
            startDate = creationFilterStartDate.Value
        Else
            startDate = DBNull.Value
        End If
        If creationFilterEndDate.HasValue Then
            endDate = creationFilterEndDate.Value
        Else
            endDate = DBNull.Value
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportSetsBySampleUnitId, sampleUnitId, exportType, startDate, endDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportSet)(rdr, AddressOf PopulateExportSet)
        End Using
    End Function

    Public Overrides Function InsertExportSet(ByVal name As String, ByVal surveyId As Integer, ByVal sampleUnitId As Integer, ByVal encounterStartDate As Date, ByVal encounterEndDate As Date, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As Integer
        Dim sampUnit As Object = DBNull.Value
        If sampleUnitId > 0 Then
            sampUnit = sampleUnitId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportSet, name, surveyId, exportType, encounterStartDate, encounterEndDate, createdEmployeeName, sampUnit)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Function DeleteExportSet(ByVal exportSetId As Integer, ByVal deletedEmployeeName As String, ByRef errorMessage As String) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteExportSet, exportSetId, deletedEmployeeName)
        Dim result As Integer = ExecuteInteger(cmd)
        Select Case result
            Case 1
                errorMessage = ""
                Return True
            Case 2
                errorMessage = "The export definition cannot be deleted because there are currently export files scheduled to be created for this export definition."
                Return False
            Case Else
                Throw New InvalidOperationException("Unknown result value while trying to delete export definition.")
        End Select
    End Function

    Public Overrides Sub RebuildExportSet(ByVal exportSetId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.RebuildExportSet, exportSetId)
        ExecuteNonQuery(cmd)
    End Sub

#End Region

#Region " ExportFile Procs "
    Private Shared Function PopulateExportFile(ByVal rdr As SafeDataReader) As ExportFile
        Dim newObject As New ExportFile
        ReadOnlyAccessor.ExportFileId(newObject) = rdr.GetInteger("ExportFileId")
        newObject.RecordCount = rdr.GetInteger("RecordCount")
        newObject.CreatedDate = rdr.GetDate("CreatedDate")
        newObject.CreatedEmployeeName = rdr.GetString("CreatedEmployeeName")
        newObject.FilePath = rdr.GetString("FilePath")
        newObject.TPSFilePath = rdr.GetString("TPSFilePath")
        newObject.SummaryFilePath = rdr.GetString("SummaryFilePath")
        newObject.FilePartsCount = rdr.GetInteger("FilePartsCount")
        If Not System.Enum.IsDefined(GetType(ExportFileType), rdr.GetInteger("FileType")) Then
            Throw New Exception("Unknown export file type " & rdr.GetInteger("FileType").ToString)
        End If
        newObject.FileType = CType(rdr.GetInteger("FileType"), ExportFileType)
        newObject.IsScheduledExport = rdr.GetBoolean("bitScheduledExport")
        newObject.IncludeOnlyReturns = rdr.GetBoolean("ReturnsOnly")
        newObject.IncludeOnlyDirects = rdr.GetBoolean("DirectsOnly")
        newObject.CreatedSuccessfully = rdr.GetBoolean("bitSuccessful")
        newObject.ErrorMessage = rdr.GetString("ErrorMessage")
        newObject.StackTrace = rdr.GetString("StackTrace")
        newObject.IsAwaitingNotification = rdr.GetBoolean("bitNeedsNotification")
        newObject.datRejected = rdr.GetDate("datRejected")
        newObject.datSubmitted = rdr.GetDate("datSubmitted")
        newObject.datAccepted = rdr.GetDate("datAccepted")
        newObject.OverrideError = rdr.GetBoolean("bitOverrideError")
        newObject.OverrideErrorName = rdr.GetString("OverrideError_nm")
        newObject.datOverride = rdr.GetDate("datOverride")
        newObject.Ignore = rdr.GetBoolean("bitIgnore")

        newObject.ResetDirtyFlag()

        Return newObject
    End Function

    Private Function GetSingleExportFile(ByVal rdr As SafeDataReader) As ExportFile
        'Create the export file object
        Dim file As ExportFile = PopulateExportFile(rdr)

        'Now add the export sets
        If rdr.NextResult Then
            While rdr.Read
                file.ExportSets.Add(PopulateExportSet(rdr))
            End While
        End If

        Return file
    End Function

    Private Function GetManyExportFiles(ByVal rdr As SafeDataReader) As Collection(Of ExportFile)
        'Create the exportfile objects
        Dim files As Collection(Of ExportFile) = PopulateCollection(Of ExportFile)(rdr, AddressOf PopulateExportFile)
        Dim exportSetIndex As New Dictionary(Of Integer, List(Of ExportSet))

        If rdr.NextResult Then
            'Create an index of all the exportsets and the exportfile they belong to
            Dim exportFileId As Integer
            While rdr.Read
                exportFileId = rdr.GetInteger("ExportFileID")

                'Create the index entry if it doesn't exist
                If Not exportSetIndex.ContainsKey(exportFileId) Then
                    exportSetIndex.Add(exportFileId, New List(Of ExportSet))
                End If

                'Add the export to the index
                exportSetIndex(exportFileId).Add(PopulateExportSet(rdr))
            End While

            'Now go add the ExportSet objects from the index into each ExportFile object
            For Each file As ExportFile In files
                If exportSetIndex.ContainsKey(file.Id) Then
                    For Each export As ExportSet In exportSetIndex(file.Id)
                        file.ExportSets.Add(export)
                    Next
                End If
            Next
        End If

        Return files
    End Function

    Public Overrides Function SelectExportFileData(ByVal exportSetIds As Integer(), ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFields As Boolean, ByVal exportGuid As Guid, ByVal saveData As Boolean, ByVal returnData As Boolean) As System.Data.IDataReader
        'Build the list of ids
        Dim idList As String = ""
        For i As Integer = 0 To exportSetIds.Length - 2
            idList &= exportSetIds(i).ToString & ","
        Next

        idList &= exportSetIds(exportSetIds.Length - 1)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFileData, idList, includeOnlyReturns, includeOnlyDirects, exportGuid, includePhoneFields, saveData, returnData, 0)
        Return ExecuteReader(cmd)

    End Function

    Public Overrides Function SelectExportFilesByExportSetId(ByVal exportSetId As Integer) As System.Collections.ObjectModel.Collection(Of ExportFile)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFilesByExportSetId, exportSetId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return GetManyExportFiles(rdr)
        End Using
    End Function

    Public Overrides Function SelectExportFilesAwaitingNotification() As System.Collections.ObjectModel.Collection(Of ExportFile)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFilesAwaitingNotification)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return GetManyExportFiles(rdr)
        End Using
    End Function

    Public Overrides Function InsertExportFile(ByVal recordCount As Integer, ByVal createdEmployeeName As String, ByVal filePath As String, ByVal filePartsCount As Integer, ByVal fileType As ExportFileType, ByVal exportGuid As Guid, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal isScheduledExport As Boolean, ByVal exportSucceeded As Boolean, ByVal errorMessage As String, ByVal errorStack As String, ByVal isAwaitingNotification As Boolean, ByVal tpsFilePath As String, ByVal summaryFilePath As String, ByVal exceptionFilePath As String, Optional ByVal ignore As Boolean = False) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportFile, recordCount, createdEmployeeName, filePath, filePartsCount, CInt(fileType), exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, exportSucceeded, errorMessage, errorStack, isAwaitingNotification, tpsFilePath, summaryFilePath, exceptionFilePath, ignore)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub InsertExportFileExportSet(ByVal exportSetId As Integer, ByVal exportFileId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportFileExportSet, exportSetId, exportFileId, DBNull.Value)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub InsertExportFileExportSet(ByVal exportSetId As Integer, ByVal medicareExportSetId As Integer, ByVal exportFileId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportFileExportSet, exportSetId, exportFileId, medicareExportSetId)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UpdateExportFile(ByVal file As ExportFile)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateExportFile, file.Id, file.IsAwaitingNotification)
        ExecuteNonQuery(cmd)
        file.ResetDirtyFlag()
    End Sub

    Public Overrides Sub UpdateExportFileErrorMessage(ByVal id As Integer, ByVal errorMessage As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateExportFileErrorMessage, id, errorMessage)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Function SelectMedicareExportFileData(ByVal medicareExportSetId As Integer, ByVal saveData As Boolean, ByVal returnData As Boolean) As System.Data.IDataReader

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareExportFileData, medicareExportSetId, saveData, returnData, 0)
        Return ExecuteReader(cmd)

    End Function

    Public Overrides Function SelectOCSExportFileData(ByVal medicareExportFileGuid As System.Guid) As System.Data.IDataReader

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectOCSExportFileData, medicareExportFileGuid)
        Return ExecuteReader(cmd)

    End Function
#End Region

#Region " Question Procs "
    Private Shared Function PopulateQuestion(ByVal dr As DataRow) As Question
        Dim qstn As New Question
        Dim sc As New Scale
        Dim rsp As Response
        Dim responses As Collection(Of Response)
        Dim childRows As DataRow()


        ReadOnlyAccessor.QuestionId(qstn) = CInt(dr("Qstncore"))
        qstn.SurveyId = CInt(dr("Survey_Id"))
        If Not dr.IsNull("strFullQuestion") Then
            qstn.FullLabel = CStr(dr("strFullQuestion"))
        End If
        qstn.ReportLabel = CStr(dr("strQuestionLabel"))
        If Not dr.IsNull("bitMeanable") Then
            qstn.IsMeanable = CBool(dr("bitMeanable"))
        End If
        If CInt(dr("numMarkCount")) > 1 Then
            qstn.MultipleResponse = True
        Else
            qstn.MultipleResponse = False
        End If
        sc.ResetDirtyFlag()

        childRows = dr.GetChildRows("ScaleId")
        ReadOnlyAccessor.ScaleId(sc) = CInt(childRows(0)("scaleId"))

        If Not childRows(0).IsNull("max_ScaleOrder") Then
            sc.MaxScaleOrder = CInt(childRows(0)("max_ScaleOrder"))
        Else
            Throw New Exception("The question scale returned a NULL value for field 'max_ScaleOrder'")
        End If

        sc.SurveyId = CInt(childRows(0)("survey_ID"))
        sc.ResetDirtyFlag()
        qstn.Scale = sc

        responses = sc.Responses
        For Each row As DataRow In childRows
            rsp = New Response
            rsp.Value = CInt(row("val"))
            If Not row.IsNull("bitMissing") Then
                rsp.IsMissing = CBool(row("bitMissing"))
            End If
            If Not row.IsNull("ScaleOrder") Then
                rsp.Order = CInt(row("ScaleOrder"))
            End If
            rsp.Label = CStr(row("strScaleLabel"))
            rsp.ResetDirtyFlag()
            responses.Add(rsp)
        Next

        Return qstn
    End Function

    Public Overrides Function SelectQuestionsBySurveyId(ByVal surveyId As Integer) As Collection(Of Question)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQuestionsbySurveyId, surveyId)
        Dim questions As New Collection(Of Question)
        Dim ds As DataSet
        Dim parentColumn(1) As DataColumn
        Dim childColumn(1) As DataColumn
        Dim relation As DataRelation

        ds = ExecuteDataSet(cmd)
        parentColumn(0) = ds.Tables(0).Columns("Qstncore")
        parentColumn(1) = ds.Tables(0).Columns("ScaleId")
        childColumn(0) = ds.Tables(1).Columns("Qstncore")
        childColumn(1) = ds.Tables(1).Columns("ScaleId")
        relation = New System.Data.DataRelation("ScaleId", parentColumn, childColumn)

        ds.Relations.Add(relation)

        For Each row As DataRow In ds.Tables(0).Rows
            questions.Add(PopulateQuestion(row))
        Next

        Return questions
    End Function
#End Region

#Region " Response Procs "
    Private Shared Function PopulateResponse(ByVal rdr As SafeDataReader) As Response
        Dim newObject As New Response
        newObject.Value = rdr.GetInteger("val")
        newObject.IsMissing = rdr.GetBoolean("bitMissing")
        newObject.Order = rdr.GetInteger("ScaleOrder")
        newObject.Label = rdr.GetString("strScaleLabel")
        newObject.ResetDirtyFlag()

        Return newObject
    End Function
    Public Overrides Function SelectResponsesBySurveyIdAndScaleId(ByVal surveyId As Integer, ByVal scaleId As Integer) As Collection(Of Response)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectResponsesbySurveyIdandScaleid, surveyId, scaleId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of Response)(rdr, AddressOf PopulateResponse)
        End Using
    End Function
#End Region

#Region " Sample Unit Procs "
    ''' <summary>Reads a sample unit record from SampleUnit table and copies to the SampleUnit business object.</summary>
    ''' <param name="rdr">SQLDataReader object</param>
    ''' <returns>Populated SampleUnit object</returns>
    ''' <CreatedBy>AppDev team</CreatedBy>
    ''' <RevisionList>Added MedicareName property by Steve Grunberg</RevisionList>
    Private Shared Function PopulateSampleUnit(ByVal rdr As SafeDataReader) As SampleUnit
        Dim newObj As New SampleUnit
        ReadOnlyAccessor.SampleUnitId(newObj) = rdr.GetInteger("SampleUnit_id")
        newObj.Name = rdr.GetString("strSampleUnit_NM")
        newObj.SurveyId = rdr.GetInteger("Survey_id")
        newObj.ParentSampleUnitId = rdr.GetNullableInteger("ParentSampleUnit_ID")
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")
        newObj.MedicareName = rdr.GetString("MedicareName")
        If rdr.IsDBNull("bitHCAHPS") Then
            newObj.IsHcahps = False
        Else
            newObj.IsHcahps = rdr.GetBoolean("bitHCAHPS")
        End If

        Return newObj
    End Function
    ''' <summary>Calls Data Access layer to get a single sample unit by its ID</summary>
    ''' <param name="sampleUnitId">The ID of the queried sample unit.</param>
    ''' <returns>SampleUnit object</returns>
    ''' <CreatedBy>AppDev team</CreatedBy>
    Public Overrides Function SelectSampleUnit(ByVal sampleUnitId As Integer) As SampleUnit
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleUnit, sampleUnitId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateSampleUnit(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    ''' <summary>Calls Data Access layer to get sample units by their medicare number</summary>
    ''' <param name="medicareNumber">The medicare number of the queried sample unit.</param>
    ''' <returns>A collection of SampleUnit objects</returns>
    ''' <CreatedBy>AppDev team</CreatedBy>
    Public Overrides Function SelectSampleUnitsByMedicareNumber(ByVal medicareNumber As String) As System.Collections.ObjectModel.Collection(Of SampleUnit)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleUnitsByMedicareNumber, medicareNumber)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SampleUnit)(rdr, AddressOf PopulateSampleUnit)
        End Using
    End Function
#End Region

#Region " Team Procs "
    Private Shared Function PopulateTeam(ByVal rdr As SafeDataReader) As Team
        Dim newObject As New Team

        newObject.Id = rdr.GetInteger("Team_ID")
        newObject.Description = rdr.GetString("TeamDescription")
        newObject.Name = rdr.GetString("TeamName")

        newObject.ResetDirtyFlag()

        Return newObject
    End Function
    Public Overrides Function SelectTeams() As Collection(Of Team)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTeams)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of Team)(rdr, AddressOf PopulateTeam)
        End Using
    End Function
#End Region

#Region " Sample Set Procs "
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
        newObj.IsOversample = Convert.ToBoolean(rdr.GetByte("tiOversample_flag"))
        newObj.SampleFromDate = rdr.GetDate("datDateRange_FromDate")
        newObj.SampleToDate = rdr.GetDate("datDateRange_ToDate")
        If rdr.IsDBNull("datScheduled") Then
            newObj.ScheduledDate = Nothing
        Else
            newObj.ScheduledDate = rdr.GetDate("datScheduled")
        End If
        newObj.SamplingAlgorithm = DirectCast(System.Enum.ToObject(GetType(SamplingAlgorithm), rdr.GetInteger("SamplingAlgorithmId")), SamplingAlgorithm)

        Return newObj
    End Function

    ''' <summary>
    ''' Creates an instance of an existing sampleset
    ''' </summary>
    ''' <param name="sampleSetId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectSampleSet(ByVal sampleSetId As Integer) As SampleSet
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleSet, sampleSetId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateSampleSet(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

#End Region

#Region " Scale Procs "
    Private Shared Function PopulateScale(ByVal rdr As SafeDataReader) As Scale
        Dim newObject As New Scale
        ReadOnlyAccessor.ScaleId(newObject) = rdr.GetInteger("scaleId")
        newObject.MaxScaleOrder = rdr.GetInteger("max_ScaleOrder")
        newObject.SurveyId = rdr.GetInteger("survey_ID")
        newObject.ResetDirtyFlag()

        Return newObject
    End Function
    Public Overrides Function SelectScaleBySurveyIdAndScaleId(ByVal surveyId As Integer, ByVal scaleId As Integer) As Scale
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectScalebySurveyIdandScaleid, surveyId, scaleId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateScale(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function
#End Region

#Region " ScheduledExport Procs "
    Private Shared Function PopulateScheduledExport(ByVal rdr As SafeDataReader) As ScheduledExport
        Dim newObject As New ScheduledExport
        ReadOnlyAccessor.ScheduledExportId(newObject) = rdr.GetInteger("ExportScheduleId")
        newObject.RunDate = rdr.GetDate("RunDate")
        newObject.IncludeOnlyReturns = rdr.GetBoolean("ReturnsOnly")
        newObject.IncludeOnlyDirects = rdr.GetBoolean("DirectsOnly")
        newObject.IncludePhoneFields = rdr.GetBoolean("IncludeDispositionRecords")
        If Not System.Enum.IsDefined(GetType(ExportFileType), rdr.GetInteger("FileType")) Then
            Throw New Exception("Unknown export file type " & rdr.GetInteger("FileType").ToString)
        End If
        newObject.ExportFileType = CType(rdr.GetInteger("FileType"), ExportFileType)
        newObject.ExportFileName = rdr.GetString("FileName")
        newObject.ScheduledBy = rdr.GetString("ScheduledBy")
        newObject.ScheduledDate = rdr.GetDate("ScheduledDate")

        Return newObject
    End Function

    Private Function GetSingleScheduledExport(ByVal rdr As SafeDataReader) As ScheduledExport
        'Create the scheduled export object
        Dim export As ScheduledExport = PopulateScheduledExport(rdr)

        'Now add the export sets
        If rdr.NextResult Then
            While rdr.Read
                export.ExportSets.Add(PopulateExportSet(rdr))
            End While
        End If

        Return export
    End Function

    Private Function GetManyScheduledExports(ByVal rdr As SafeDataReader) As Collection(Of ScheduledExport)
        'Create the scheduled export object
        Dim scheduledExports As Collection(Of ScheduledExport) = PopulateCollection(Of ScheduledExport)(rdr, AddressOf PopulateScheduledExport)
        Dim exportSetIndex As New Dictionary(Of Integer, List(Of ExportSet))

        If rdr.NextResult Then
            'Create an index of all the exportsets and the scheduledexport the belong to
            Dim scheduledExportId As Integer
            While rdr.Read
                scheduledExportId = rdr.GetInteger("ExportScheduleID")

                'Create the index entry if it doesn't exist
                If Not exportSetIndex.ContainsKey(scheduledExportId) Then
                    exportSetIndex.Add(scheduledExportId, New List(Of ExportSet))
                End If

                'Add the export to the index
                exportSetIndex(scheduledExportId).Add(PopulateExportSet(rdr))
            End While

            'Now go add the ExportSet objects from the index into each ScheduledExport object
            For Each se As ScheduledExport In scheduledExports
                If exportSetIndex.ContainsKey(se.Id) Then
                    For Each export As ExportSet In exportSetIndex(se.Id)
                        se.ExportSets.Add(export)
                    Next
                End If
            Next
        End If

        Return scheduledExports
    End Function

    Public Overrides Function SelectScheduledExport(ByVal scheduledExportId As Integer) As ScheduledExport
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectScheduledExport, scheduledExportId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return GetSingleScheduledExport(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectAllScheduledExports(ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllScheduledExports, startFilterDate, endFilterDate)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return GetManyScheduledExports(rdr)
        End Using

    End Function

    Public Overrides Function SelectScheduledExportsByClientId(ByVal clientId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As System.Collections.ObjectModel.Collection(Of ScheduledExport)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectScheduledExportsByClientId, startFilterDate, endFilterDate, clientId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return GetManyScheduledExports(rdr)
        End Using
    End Function

    Public Overrides Function SelectScheduledExportsByStudyId(ByVal studyId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As System.Collections.ObjectModel.Collection(Of ScheduledExport)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectScheduledExportsByStudyId, startFilterDate, endFilterDate, studyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return GetManyScheduledExports(rdr)
        End Using
    End Function

    Public Overrides Function SelectScheduledExportsBySurveyId(ByVal surveyId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As System.Collections.ObjectModel.Collection(Of ScheduledExport)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectScheduledExportsBySurveyId, startFilterDate, endFilterDate, surveyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return GetManyScheduledExports(rdr)
        End Using
    End Function

    Public Overrides Function SelectNextScheduledExport() As ScheduledExport
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectNextScheduledExport)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return GetSingleScheduledExport(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function InsertScheduledExport(ByVal runDate As Date, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFiles As Boolean, ByVal fileType As ExportFileType, ByVal fileName As String, ByVal userName As String) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertScheduledExport, runDate, includeOnlyReturns, includeOnlyDirects, includePhoneFiles, fileType, fileName, userName)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub InsertScheduledExportSet(ByVal scheduledExportId As Integer, ByVal exportSetId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertScheduledExportSet, scheduledExportId, exportSetId)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UpdateScheduledExport(ByVal scheduledExportId As Integer, ByVal runDate As Date, ByVal fileName As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateScheduledExport, scheduledExportId, runDate, fileName)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteScheduledExport(ByVal scheduledExportId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteScheduledExport, scheduledExportId)
        ExecuteNonQuery(cmd)
    End Sub

#End Region

#Region " Study Procs "

    Private Shared Function PopulateStudy(ByVal rdr As SafeDataReader) As Study
        Dim newObject As New Study
        ReadOnlyAccessor.StudyId(newObject) = rdr.GetInteger("Study_id")
        newObject.Name = rdr.GetString("strStudy_NM").Trim
        'AD information is not consistent in the datamart, so we are not using it
        'newObject.AccountDirectorName = rdr.GetString("AD")
        newObject.ClientId = rdr.GetInteger("Client_id")
        newObject.ResetDirtyFlag()

        Return newObject
    End Function

    Public Overrides Function SelectStudy(ByVal studyId As Integer) As Study
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudy, studyId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateStudy(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

#End Region

#Region " Survey Procs "
    Private Shared Function PopulateSurvey(ByVal rdr As SafeDataReader) As Survey
        Dim newObject As New Survey
        ReadOnlyAccessor.SurveyId(newObject) = rdr.GetInteger("Survey_id")
        newObject.Name = rdr.GetString("strQSurvey_NM").Trim
        newObject.Description = rdr.GetString("strSurvey_NM").Trim
        newObject.StudyId = rdr.GetInteger("Study_id")
        newObject.ResetDirtyFlag()

        Return newObject
    End Function

    Public Overrides Function SelectSurvey(ByVal surveyId As Integer) As Survey
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurvey, surveyId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateSurvey(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectSurveysByStudyId(ByVal studyId As Integer) As System.Collections.ObjectModel.Collection(Of Survey)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurveysByStudyId, studyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of Survey)(rdr, AddressOf PopulateSurvey)
        End Using
    End Function
#End Region

#Region " Weights "
    Private Shared Function PopulateWeightType(ByVal rdr As SafeDataReader) As WeightType
        Dim newObject As New WeightType()
        ReadOnlyAccessor.WeightCategoryId(newObject) = rdr.GetInteger("WeightType_Id")
        newObject.Name = rdr.GetString("WeightTypeLabel")
        newObject.ExportColumnName = rdr.GetString("ExportColumnName")
        newObject.ResetDirtyFlag()

        Return newObject
    End Function

    Public Overrides Function SelectWeightTypes() As System.Collections.ObjectModel.Collection(Of WeightType)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectWeightTypes)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of WeightType)(rdr, AddressOf PopulateWeightType)
        End Using
    End Function

    Public Overrides Sub BulkLoadWeightValuesTable(ByVal rdr As IDataReader, ByVal samplePopIdColumnName As String, ByVal WeightColumnName As String, ByVal tempTableName As String)
        Using con As SqlClient.SqlConnection = DirectCast(Db.CreateConnection, SqlClient.SqlConnection)
            con.Open()
            Using bulkCopy As SqlClient.SqlBulkCopy = New SqlClient.SqlBulkCopy(con)
                bulkCopy.DestinationTableName = tempTableName
                Dim samplePopMapping As New SqlClient.SqlBulkCopyColumnMapping(samplePopIdColumnName, "SamplePop_ID")
                bulkCopy.ColumnMappings.Add(samplePopMapping)
                Dim WeightMapping As New SqlClient.SqlBulkCopyColumnMapping(WeightColumnName, "WeightValue")
                bulkCopy.ColumnMappings.Add(WeightMapping)
                Try
                    bulkCopy.WriteToServer(rdr)
                Catch ex As SqlClient.SqlException
                    DropWeightTempTable(tempTableName)
                    If ex.Number = 2627 Then
                        Throw New Exception("Multiple records exist for some samppops.  There can only be 1 record for each samppop.")
                    Else
                        Throw
                    End If
                Finally
                    ' Close the SqlDataReader. The SqlBulkCopy
                    ' object is automatically closed at the end
                    ' of the Using block.
                    rdr.Close()
                End Try
            End Using
        End Using
    End Sub

    Public Overrides Function SelectWeightType(ByVal weightTypeId As Integer) As WeightType
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectWeightType, weightTypeId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateWeightType(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function CreateTemporaryWeightValuesTable(ByVal studyId As Integer) As String
        Dim randomGuid As String = Guid.NewGuid.ToString.Replace("-", "")
        Dim tableName As String = String.Format("[s{0}].WeightValue{1}", studyId.ToString, randomGuid)
        Dim commandText As String = String.Format("CREATE TABLE {0}([SamplePop_ID] [int] NOT NULL, [WeightValue] [float] NOT NULL CONSTRAINT [PK_{1}] PRIMARY KEY CLUSTERED ([SamplePop_ID] ASC) ON [PRIMARY]) ON [PRIMARY]", tableName, randomGuid)
        Dim cmd As DbCommand = Db.GetSqlStringCommand(commandText)
        ExecuteNonQuery(cmd)

        Return tableName
    End Function

    Public Overrides Function InsertWeightValues(ByVal studyId As Integer, ByVal tempTableName As String, ByVal replace As Boolean, ByVal WeightTypeID As Integer, ByVal employeeName As String) As System.Collections.ObjectModel.Collection(Of String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertWeightValues, studyId, tempTableName, replace, WeightTypeID, employeeName)
        Dim messages As New Collection(Of String)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                messages.Add(rdr.GetString("message"))
            End While
        End Using

        Return messages
    End Function

    Public Overrides Function InsertWeightType(ByVal weightTypeLabel As String, ByVal exportColumnName As String) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertWeightType, weightTypeLabel, exportColumnName)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateWeightType(ByVal weightTypeId As Integer, ByVal weightTypeLabel As String, ByVal exportColumnName As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateWeightType, weightTypeId, weightTypeLabel, exportColumnName)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteWeightType(ByVal weightTypeId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteWeightType, weightTypeId)
        ExecuteNonQuery(cmd)
    End Sub

    Public Sub DropWeightTempTable(ByVal tableName As String)
        Dim commandText As String = String.Format("DROP TABLE {0}", tableName)
        Dim cmd As DbCommand = Db.GetSqlStringCommand(commandText)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Function IsWeightTypeDeletable(ByVal weightTypeId As Integer) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.IsWeightTypeDeletable, weightTypeId)
        Dim messages As New Collection(Of String)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return False
            Else
                Return True
            End If
        End Using
    End Function
#End Region

#Region " Special Updates "

    ''' <summary>For Special Updates</summary>
    ''' <author>Steve Kennedy</author>
    ''' <revision>SK 10/08/2008 Initial Creation</revision>
    Public Overrides Function SpecialSurveyUpdate(ByVal studyId As Integer, ByVal surveyId As Integer, ByVal samplePopId As Integer, ByVal fieldName As String, ByVal fieldValue As String, ByVal yearQtr As String, ByRef errorMessage As String) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SpecialSurveyUpdate, studyId, surveyId, samplePopId, fieldName, fieldValue, yearQtr)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                errorMessage = rdr.GetString("ErrMSG", "")
                Return CBool(rdr.GetInteger("StatusCode", 1))
            Else
                errorMessage = "No return value from sp_SpecialSurveyUpdate"
                Return False
            End If
        End Using

    End Function

#End Region

#Region "ORYX"
    Public Overrides Function SelectParentSampleUnitIDsByOryxHCOID(ByVal HCOID As Int32) As Collection(Of Int32)
        Dim result As New Collection(Of Int32)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_SelectParentSampleUnitIDsByHCOID, HCOID)
        Dim dt As New SafeDataReader(ExecuteReader(cmd))
        While dt.Read
            If dt("SampleUnit_ID") IsNot Nothing Then
                result.Add(Convert.ToInt32(dt("SampleUnit_ID")))
            End If
        End While
        Return result
    End Function
    Public Overrides Function SelectClientIDByORYXHCO(ByVal HCOID As Int32) As Int32
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYXSelectClientIDByHCOID, HCOID)
        Return Convert.ToInt32(ExecuteScalar(cmd))
    End Function
    Public Overrides Function SelectClientIDByExportSetID(ByVal ExportSetID As Integer) As Int32
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYXSelectClientIDByExportSetID, ExportSetID)
        Return Convert.ToInt32(ExecuteScalar(cmd))
    End Function
    Public Overrides Function SelectORYXHCOByExportSet(ByVal ExportSetID As Int32) As Int32
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYXSelectHCOByClientID, ExportSetID)
        Return Convert.ToInt32(ExecuteScalar(cmd))
    End Function
    Public Overrides Function SelectOryxMeasurements() As List(Of Int32)
        Return SelectOryxMeasurements(Nothing)
    End Function
    Public Overrides Function SelectOryxMeasurements(ByVal HCOID As Nullable(Of Int32)) As List(Of Int32)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYXSelectMeasurements, HCOID)
        Dim rdr As New SafeDataReader(ExecuteReader(cmd))
        Dim result As New List(Of Int32)
        'TODO: add error handling here
        While rdr.Read()
            result.Add(Convert.ToInt32(rdr("MeasurementID")))
        End While
        rdr.Close()
        Return result
    End Function
    Public Overrides Function SelectOryxQuestions(ByVal MeasurementID As Int32) As List(Of Int32)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYXSelectQuestions, MeasurementID)
        Dim rdr As New SafeDataReader(ExecuteReader(cmd))
        Dim result As New List(Of Int32)
        'TODO: add error handling here
        While rdr.Read()
            result.Add(Convert.ToInt32(rdr("QuestionID")))
        End While
        rdr.Close()
        Return result
    End Function
    Public Overrides Function SelectOryxAnswerMappings(ByVal QuestionID As Int32) As Dictionary(Of Int32, Nullable(Of Int32))
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYXSelectAnswerMapping, QuestionID)
        Dim rdr As New SafeDataReader(ExecuteReader(cmd))
        Dim result As New Dictionary(Of Int32, Nullable(Of Int32))
        'TODO: add error handling here
        Dim MapToValue As Nullable(Of Int32)
        While rdr.Read()
            If rdr("MapTo") Is Nothing Then
                MapToValue = Nothing
            Else
                MapToValue = Convert.ToInt32(rdr("MapTo"))
            End If
            result.Add(Convert.ToInt32(rdr("MapFrom")), MapToValue)
        End While
        rdr.Close()
        Return result
    End Function
    Public Overrides Function SelectOryxLastUsedFileNum() As Int32
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYXSelectLastFileNum)
        Return Convert.ToInt32(ExecuteScalar(cmd))
    End Function
    Public Overrides Sub UpdateOryxLastUsedFileNum(ByVal ControlNum As Int32)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYXUpdateLastFileNum, ControlNum)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function SelectAllOryxClients() As Dictionary(Of Int32, String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_SelectAllORYXClients)
        Dim rdr As New SafeDataReader(ExecuteReader(cmd))
        Dim result As Dictionary(Of Int32, String) = New Dictionary(Of Int32, String)
        While rdr.Read()
            result.Add(Convert.ToInt32(rdr("HCOID")), rdr("strClient_nm").ToString())
        End While
        rdr.Close()
        Return result
    End Function
    Public Overrides Function SelectAllNonOryxClients() As Dictionary(Of Int32, String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_SelectAllNonORYXClients)
        Dim rdr As New SafeDataReader(ExecuteReader(cmd))
        Dim result As Dictionary(Of Int32, String) = New Dictionary(Of Int32, String)
        While rdr.Read()
            If Not result.ContainsKey(Convert.ToInt32(rdr("Client_id"))) Then 'aparently the client table isn't keyed on client_id, so I have to de-dupe it here.
                result.Add(Convert.ToInt32(rdr("Client_id")), rdr("strClient_nm").ToString())
            End If
        End While
        rdr.Close()
        Return result
    End Function
    Public Overrides Function AddOryxClient(ByVal HCOID As Int32, ByVal ClientID As Int32) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_AddOryxClient, HCOID, ClientID)
        Return ExecuteInteger(cmd) = 1
    End Function
    Public Overrides Sub DeleteAllHCOMeasurements(ByVal HCOID As Int32)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_DeleteMeasuresByHCO, HCOID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub AddHCOMeasurement(ByVal HCOID As Int32, ByVal MeasurementID As Int32)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_AddMeasureByHCO, HCOID, MeasurementID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub AddMeasurement(ByVal MeasurementID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_AddOryxMeasurement, MeasurementID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function SelectQuestionText(ByVal QstnCore As Int32) As List(Of String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_SelectQuestionText, QstnCore)
        Dim rdr As New SafeDataReader(ExecuteReader(cmd))
        Dim result As New List(Of String)
        'TODO: add error handling here
        While rdr.Read()
            If Not rdr("label") Is Nothing Then
                result.Add(rdr("label").ToString())
            End If
        End While
        rdr.Close()
        Return result
    End Function
    Public Overrides Function SelectScale(ByVal QstnCore As Int32) As DataTable
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_SelectScale, QstnCore)
        Return ExecuteDataSet(cmd).Tables(0)
    End Function
    Public Overrides Sub UpdateAnswerMapping(ByVal QuestionID As Integer, ByVal NRCValue As System.Nullable(Of Integer), ByVal ORYXValue As System.Nullable(Of Integer))
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_UpdateAnswerMapping, QuestionID, NRCValue, ORYXValue)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub DeleteQuestionsByMeasure(ByVal MeasurementID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_DeleteQuestionsByMeasure, MeasurementID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub AddQuestionToMeasure(ByVal MeasurementID As Integer, ByVal QuestionID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ORYX_AddQuestionToMeasure, MeasurementID, QuestionID)
        ExecuteNonQuery(cmd)
    End Sub

#End Region

#Region " Medicare Export Procs "
    Private Shared Function PopulateMedicareExport(ByVal rdr As SafeDataReader) As MedicareExport
        Dim newObj As New MedicareExport
        newObj.MedicareName = rdr.GetString("MedicareName")
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")
        newObj.ClientGroupName = rdr.GetString("strClientGroup_nm")
        newObj.FacilityName = rdr.GetString("strFacility_nm")
        newObj.ClientName = rdr.GetString("strClient_NM")
        newObj.StudyName = rdr.GetString("strStudy_NM")
        newObj.SurveyName = rdr.GetString("strSurvey_NM")
        newObj.ClientGroupId = rdr.GetNullableInteger("ClientGroup_ID")
        newObj.ClientId = rdr.GetInteger("Client_id")
        newObj.StudyId = rdr.GetInteger("Study_id")
        newObj.SurveyId = rdr.GetInteger("Survey_id")
        newObj.AccountDirector = rdr.GetString("AD")
        newObj.SurveyTypeId = rdr.GetInteger("SurveyType_id")
        newObj.SampleUnitId = rdr.GetInteger("sampleunit_id")
        newObj.ParentSampleUnitId = rdr.GetNullableInteger("ParentSampleUnit_ID")
        newObj.SampleUnitName = rdr.GetString("strSampleunit_Nm")
        If rdr.IsDBNull("bitCHART") Then
            newObj.IsCHART = False
        Else
            newObj.IsCHART = rdr.GetBoolean("bitCHART")
        End If
        If rdr.IsDBNull("bitHCAHPS") Then
            newObj.IsHcahps = False
        Else
            newObj.IsHcahps = rdr.GetBoolean("bitHCAHPS")
        End If
        If rdr.IsDBNull("bitHHCAHPS") Then
            newObj.IsHHcahps = False
        Else
            newObj.IsHHcahps = rdr.GetBoolean("bitHHCAHPS")
        End If
        If rdr.IsDBNull("bitACOCAHPS") Then
            newObj.IsACOcahps = (newObj.SurveyTypeId = 10)
        Else
            newObj.IsACOcahps = rdr.GetBoolean("bitACOCAHPS")
        End If
        If rdr.IsDBNull("bitMNCM") Then
            newObj.IsMNCM = False
        Else
            newObj.IsMNCM = rdr.GetBoolean("bitMNCM")
        End If

        Return newObj
    End Function

    Private Shared Function PopulateDistinctMedicareExport(ByVal rdr As SafeDataReader) As MedicareExport
        Dim newObj As New MedicareExport
        newObj.MedicareName = rdr.GetString("MedicareName")
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")
        newObj.SampleUnitId = rdr.GetInteger("sampleunit_id")
        newObj.SampleUnitName = rdr.GetString("strSampleunit_Nm")
        newObj.SurveyId = rdr.GetInteger("Survey_ID")
        newObj.ClientName = rdr.GetString("strClient_NM")
        newObj.SurveyName = rdr.GetString("strSurvey_NM")

        Return newObj
    End Function

    Private Shared Function PopulateMedicareExportMedicareInfo(ByVal rdr As SafeDataReader) As MedicareExport
        Dim newObj As New MedicareExport
        newObj.MedicareName = rdr.GetString("MedicareName")
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")

        Return newObj
    End Function

    Public Overrides Function SelectAllByDistinctMedicareNumber(ByVal exportSetType As ExportSetType, ByVal activeOnly As Boolean) As System.Collections.ObjectModel.Collection(Of MedicareExport)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllDistinctMedicareExport, exportSetType, False, activeOnly)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MedicareExport)(rdr, AddressOf PopulateDistinctMedicareExport)
        End Using

    End Function

    Public Overrides Function SelectAllByDistinctSampleUnit(ByVal exportSetType As ExportSetType) As System.Collections.ObjectModel.Collection(Of MedicareExport)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllDistinctMedicareExport, exportSetType, True, False)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MedicareExport)(rdr, AddressOf PopulateDistinctMedicareExport)
        End Using

    End Function

    Public Overrides Function SelectMedicareExport(ByVal medicareNumber As String) As MedicareExport

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareExport, medicareNumber)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateMedicareExportMedicareInfo(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function
#End Region

#Region " Medicare Export Set Procs "

    Private Shared Function PopulateMedicareExportSet(ByVal rdr As SafeDataReader) As MedicareExportSet
        Dim newObj As New MedicareExportSet
        ReadOnlyAccessor.MedicareExportSetId(newObj) = rdr.GetInteger("MedicareExportSet_ID")
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")
        newObj.ExportName = rdr.GetString("ExportName")
        newObj.ExportStartDate = rdr.GetDate("ExportStartDate")
        newObj.ExportEndDate = rdr.GetDate("ExportEndDate")
        newObj.DirectsOnly = rdr.GetBoolean("DirectsOnly")
        newObj.ReturnsOnly = rdr.GetBoolean("ReturnsOnly")
        newObj.CreatedEmployeeName = rdr.GetString("CreatedEmployeeName")
        newObj.ExportFileGUID = rdr.GetGuid("ExportFileGUID")
        newObj.ExportSetTypeID = rdr.GetInteger("ExportSetTypeID")
        newObj.DateCreated = rdr.GetDate("DateCreated")

        Return newObj
    End Function

    Private Shared Function PopulateMedicareExportSetGuid(ByVal rdr As SafeDataReader) As MedicareExportSet
        Dim newObj As New MedicareExportSet
        ReadOnlyAccessor.MedicareExportSetId(newObj) = rdr.GetInteger("MedicareExportSet_ID")
        newObj.ExportFileGUID = rdr.GetGuid("ExportFileGUID")

        Return newObj
    End Function

    Public Overrides Function InsertMedicareExportSet(ByVal medicarenumber As String, ByVal exportname As String, ByVal startDate As Date, ByVal endDate As Date, ByVal directsOnly As Boolean, ByVal returnsOnly As Boolean, ByVal exportGuid As System.Guid, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMedicareExportSet, medicarenumber, exportname, startDate, endDate, directsOnly, returnsOnly, createdEmployeeName, exportGuid, exportType, Date.Now)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Function SelectMedicareExportSet(ByVal medicareExportSetId As Integer) As MedicareExportSet

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareExportSet, medicareExportSetId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateMedicareExportSet(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectFileGUIDsByClientGroup(ByVal surveyType As SurveyType, ByVal clientGroupName As String, ByVal sign As String, ByVal startDate As Date, ByVal endDate As Date) As System.Collections.ObjectModel.Collection(Of MedicareExportSet)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectFileGUIDsByClientGroup, surveyType, clientGroupName, sign, startDate, endDate, 0)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MedicareExportSet)(rdr, AddressOf PopulateMedicareExportSetGuid)
        End Using

    End Function
#End Region

#Region "ACOCAHPS"

    Public Overrides Function SelectAllACOCAHPSBySurveyId(ByVal survey_Id As Integer, ByVal startDate As DateTime, ByVal endDate As DateTime) As Collection(Of ACOCAHPSExport)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllACOCAHPSBySurveyId, survey_Id, startDate, endDate)
        Dim acoCAHPSExportList As New Collection(Of ACOCAHPSExport)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                acoCAHPSExportList.Add(PopulateACOCAHPSExportFileData(rdr))
            End While
        End Using

        Return acoCAHPSExportList

    End Function

    'Public Overrides Function SelectACOCAHPSExportSet(ByVal acoCAHPSId As Integer) As ACOCAHPSExportSet
    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareExportSet, medicareExportSetId)
    '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
    '        If rdr.Read Then
    '            Return PopulateACOCAHPSExportSet(rdr)
    '        Else
    '            Return Nothing
    '        End If
    '    End Using
    'End Function

    'Public Overrides Function InsertACOCAHPSExportSet(ByVal surveyID As Integer, ByVal surveyName As String, ByVal clientName As String, ByVal exportname As String, ByVal startDate As Date, ByVal endDate As Date, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As Integer
    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportFile, recordCount, createdEmployeeName, filePath, filePartsCount, CInt(fileType), exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, exportSucceeded, errorMessage, errorStack, isAwaitingNotification, tpsFilePath, summaryFilePath, exceptionFilePath)
    '    Return ExecuteInteger(cmd)
    'End Function

    Private Shared Function PopulateACOCAHPSExportFileData(ByVal rdr As SafeDataReader) As ACOCAHPSExport

        Dim newObj As New ACOCAHPSExport
        newObj.Qs = New List(Of String)
        newObj.SurveyId = rdr.GetInteger("Survey_ID")
        newObj.Finder = rdr.GetString("Finder")
        newObj.ACO_Id = rdr.GetString("ACO_Id")
        newObj.Dispositn = rdr.GetString("Dispositn", "10")
        newObj.Mode = rdr.GetString("Mode", "8")
        newObj.Dispo_Lang = rdr.GetString("Dispo_Lang", "8")
        newObj.Received = rdr.GetString("Received", "88888888")
        newObj.FocalType = rdr.GetString("FocalType", "1")
        newObj.PRTitle = rdr.GetString("PRTitle")
        newObj.PRFName = rdr.GetString("PRFName")
        newObj.PRLName = rdr.GetString("PRLName")
        newObj.QVersion = rdr.GetString("qversion")
        newObj.BitComplete = rdr.GetNullableBoolean("bitComplete")
        newObj.Qs.Add(rdr.GetInteger("Q01", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q02", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q03", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q04", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q05", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q06", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q07", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q08", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q09", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q10", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q11", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q12", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q13", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q14", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q15", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q16", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q17", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q18", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q19", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q20", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q21", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q22", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q23", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q24", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q25", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q26", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q27", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q28", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q29", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q30", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q31", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q32", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q33", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q34", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q35", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q36", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q37", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q38", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q39", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q40", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q41", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q42", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q43", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q44", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q45", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q46", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q47", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q48", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q49", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q50", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q51", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q52", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q53", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q54", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q55", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q56", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q57a", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q57b", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q57c", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q58", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q59", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q60", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q61", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q62", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q63", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q64", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q65", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q66", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q67", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q68", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q69", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q70", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q71", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q72", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q73", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q74", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q75", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q76", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q77", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q78", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79a", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79b", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79c", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79d", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79d1", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79d2", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79d3", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79d4", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79d5", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79d6", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79d7", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79e", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79e1", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79e2", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79e3", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q79e4", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q80", -9).ToString())
        newObj.Qs.Add(rdr.GetInteger("Q81", -9).ToString())
        'newObj.Qs.Add(rdr.GetInteger("Q81a", -9).ToString())
        'newObj.Qs.Add(rdr.GetInteger("Q81b", -9).ToString())
        'newObj.Qs.Add(rdr.GetInteger("Q81c", -9).ToString())
        'newObj.Qs.Add(rdr.GetInteger("Q81d", -9).ToString())
        'newObj.Qs.Add(rdr.GetInteger("Q81e", -9).ToString())

        Return newObj

    End Function

#End Region

#Region " Export File View "
    Private Shared Function PopulateExportFileViewAll(ByVal rdr As SafeDataReader) As ExportFileView
        Dim newObj As New ExportFileView
        newObj.BeginPopulate()
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")
        newObj.MedicareName = rdr.GetString("MedicareName")
        newObj.IsMedicareActive = rdr.GetBoolean("MedicareActive")
        newObj.ExportName = rdr.GetString("ExportName")
        newObj.FacilityName = rdr.GetString("strFacility_nm")
        newObj.SampleUnitName = rdr.GetString("strSampleunit_Nm")
        newObj.SampleUnitId = rdr.GetInteger("sampleunit_id")
        newObj.datSubmitted = rdr.GetNullableDate("datSubmitted")
        newObj.datAccepted = rdr.GetNullableDate("datAccepted")
        newObj.datRejected = rdr.GetNullableDate("datRejected")
        newObj.datOverride = rdr.GetNullableDate("datOverride")
        newObj.FilePath = rdr.GetString("FilePath")
        newObj.TPSFilePath = rdr.GetString("TPSFilePath")
        newObj.SummaryFilePath = rdr.GetString("SummaryFilePath")
        newObj.ExceptionFilePath = rdr.GetString("ExceptionFilePath")
        newObj.CreatedDate = rdr.GetDate("FileCreateDate")
        newObj.ExportStartDate = rdr.GetDate("ExportStartDate")
        newObj.ExportEndDate = rdr.GetDate("ExportEndDate")
        newObj.ErrorMessage = rdr.GetString("ErrorMessage")
        newObj.StackTrace = rdr.GetString("StackTrace")
        newObj.OverrideError = rdr.GetBoolean("bitOverrideError")
        newObj.OverrideErrorName = rdr.GetString("OverrideError_nm")
        newObj.Ignore = rdr.GetBoolean("bitIgnore")
        newObj.ClientGroupName = rdr.GetString("strClientGroup_nm")
        newObj.ClientGroupId = rdr.GetNullableInteger("ClientGroup_ID")
        newObj.IsClientGroupActive = rdr.GetBoolean("ClientGroupActive")
        newObj.ClientName = rdr.GetString("strClient_NM")
        newObj.ClientId = rdr.GetInteger("Client_id")
        newObj.IsClientActive = rdr.GetBoolean("ClientActive")
        newObj.StudyName = rdr.GetString("strStudy_NM")
        newObj.StudyId = rdr.GetInteger("Study_id")
        newObj.IsStudyActive = rdr.GetBoolean("StudyActive")
        newObj.SurveyName = rdr.GetString("strSurvey_NM")
        newObj.SurveyId = rdr.GetInteger("Survey_id")
        newObj.IsSurveyActive = rdr.GetBoolean("SurveyActive")
        newObj.MedicareExportSetId = rdr.GetInteger("MedicareExportSet_id")
        newObj.ExportFileId = rdr.GetInteger("ExportFileID")
        newObj.ExportSetTypeId = rdr.GetInteger("ExportSetTypeID")
        newObj.EndPopulate()

        Return newObj
    End Function

    Private Shared Function PopulateExportFileView(ByVal rdr As SafeDataReader) As ExportFileView
        Dim newObj As New ExportFileView
        newObj.BeginPopulate()
        newObj.ClientGroupName = rdr.GetString("strClientGroup_nm")
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")
        newObj.MedicareName = rdr.GetString("MedicareName")
        newObj.ExportName = rdr.GetString("ExportName")
        newObj.FilePath = rdr.GetString("FilePath")
        newObj.TPSFilePath = rdr.GetString("TPSFilePath")
        newObj.SummaryFilePath = rdr.GetString("SummaryFilePath")
        newObj.ExceptionFilePath = rdr.GetString("ExceptionFilePath")
        newObj.CreatedDate = rdr.GetDate("FileCreateDate")
        newObj.datSubmitted = rdr.GetNullableDate("datSubmitted")
        newObj.datAccepted = rdr.GetNullableDate("datAccepted")
        newObj.datRejected = rdr.GetNullableDate("datRejected")
        newObj.ErrorMessage = rdr.GetString("ErrorMessage")
        newObj.OverrideError = rdr.GetBoolean("bitOverrideError")
        newObj.Ignore = rdr.GetBoolean("bitIgnore")
        newObj.datOverride = rdr.GetNullableDate("datOverride")
        newObj.OverrideErrorName = rdr.GetString("OverrideError_nm")
        newObj.MedicareExportSetId = rdr.GetInteger("MedicareExportSet_id")
        newObj.ExportFileId = rdr.GetInteger("ExportFileID")
        newObj.ExportSetTypeId = rdr.GetInteger("ExportSetTypeID")
        newObj.EndPopulate()

        Return newObj
    End Function

    Public Overrides Function SelectExportFilesByExportSetType(ByVal exportSetType As ExportSetType, ByVal filterStartDate As Date, ByVal filterEndDate As Date) As System.Collections.ObjectModel.Collection(Of ExportFileView)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFileByFileType, exportSetType, filterStartDate.Date, filterEndDate.Date)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportFileView)(rdr, AddressOf PopulateExportFileView)
        End Using
    End Function

    Public Overrides Function SelectExportFilesByExportSetTypeAllDetails(ByVal exportSetType As ExportSetType, ByVal filterStartDate As Date, ByVal filterEndDate As Date) As System.Collections.ObjectModel.Collection(Of ExportFileView)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFileByFileTypeAllDetails, exportSetType, filterStartDate.Date, filterEndDate.Date)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportFileView)(rdr, AddressOf PopulateExportFileViewAll)
        End Using
    End Function

    Public Overrides Sub UpdateExportFileTracking(ByVal file As ExportFileView)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateExportFileTracking, file.ExportFileId, file.datSubmitted, file.datAccepted, file.datRejected, file.OverrideError, file.Ignore, file.datOverride, file.OverrideErrorName)
        ExecuteNonQuery(cmd)
    End Sub
#End Region

End Class
