Imports System.Data.Common
Imports System.Data.SqlClient
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Collections.Generic
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class PackageDB

#Region " Private Members "

    Private Shared mDatabase As Database

#End Region

#Region " Private Database Functions "

    Private Shared ReadOnly Property Db() As Database
        Get
            If mDatabase Is Nothing Then
                mDatabase = New Sql.SqlDatabase(AppConfig.QLoaderConnection)
            End If

            Return mDatabase
        End Get
    End Property

    Private Shared Function ExecuteDataset(ByVal procedureName As String, ByVal ParamArray params As Object()) As DataSet

        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedureName, params)

        Try
            cmd.CommandTimeout = AppConfig.Params("QLSSqlTimeout").IntegerValue
            Return Db.ExecuteDataSet(cmd)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Private Shared Function ExecuteDataset(ByVal tran As SqlTransaction, ByVal procedureName As String, ByVal ParamArray params As Object()) As DataSet

        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedureName, params)

        Try
            cmd.CommandTimeout = AppConfig.Params("QLSSqlTimeout").IntegerValue
            Return Db.ExecuteDataSet(cmd, tran)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Private Shared Function ExecuteScalar(ByVal procedureName As String, ByVal ParamArray params As Object()) As Object

        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedureName, params)

        Try
            cmd.CommandTimeout = AppConfig.Params("QLSSqlTimeout").IntegerValue
            Return Db.ExecuteScalar(cmd)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Private Shared Function ExecuteScalar(ByVal tran As SqlTransaction, ByVal procedureName As String, ByVal ParamArray params As Object()) As Object

        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedureName, params)

        Try
            cmd.CommandTimeout = AppConfig.Params("QLSSqlTimeout").IntegerValue
            Return Db.ExecuteScalar(cmd, tran)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Private Shared Function ExecuteInteger(ByVal procedureName As String, ByVal ParamArray params As Object()) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedureName, params)

        Try
            cmd.CommandTimeout = AppConfig.Params("QLSSqlTimeout").IntegerValue
            Return CType(Db.ExecuteScalar(cmd), Integer)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Private Shared Function ExecuteInteger(ByVal tran As SqlTransaction, ByVal procedureName As String, ByVal ParamArray params As Object()) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedureName, params)

        Try
            cmd.CommandTimeout = AppConfig.Params("QLSSqlTimeout").IntegerValue
            Return CType(Db.ExecuteScalar(cmd, tran), Integer)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Private Shared Sub ExecuteNonQuery(ByVal procedureName As String, ByVal ParamArray params As Object())

        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedureName, params)

        Try
            cmd.CommandTimeout = AppConfig.Params("QLSSqlTimeout").IntegerValue
            Db.ExecuteNonQuery(cmd)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Sub

    Private Shared Function ExecuteReader(ByVal procedureName As String, ByVal ParamArray params As Object()) As IDataReader

        Dim cmd As DbCommand = Db.GetStoredProcCommand(procedureName, params)

        Try
            cmd.CommandTimeout = AppConfig.Params("QLSSqlTimeout").IntegerValue
            Return Db.ExecuteReader(cmd)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

#End Region

#Region " Match Field Validation "

    Public Shared Function GetMatchFieldValidation(ByVal studyID As Integer) As DataTable

        Return ExecuteDataset("LD_GetMatchFieldValidation", studyID).Tables(0)

    End Function

    Public Shared Function SaveMatchFieldValidation(ByVal transaction As SqlTransaction, ByVal studyID As Integer, ByVal tableID As Integer, ByVal fields As String) As Integer

        Return ExecuteInteger(transaction, "LD_MatchFieldValidation", studyID, tableID, fields)

    End Function

#End Region

#Region " Function Methods "

    Public Shared Function GetFunctionList(ByVal clientID As Integer) As DataTable

        Return ExecuteDataset("LD_GetFunctionList", clientID).Tables(0)

    End Function

    Public Shared Function GetFunctionGroup(ByVal ParentFunctionGroupID As Integer) As DataTable

        Return ExecuteDataset("LD_GetFunctionGroup", ParentFunctionGroupID).Tables(0)

    End Function

    Public Shared Function GetFunctionTree(ByVal clientID As Integer, ByVal showCustom As Boolean, ByVal showSystem As Boolean) As DataTable

        Return ExecuteDataset("LD_GetFunctionTree", clientID, showCustom, showSystem).Tables(0)

    End Function

    Public Shared Function GetFunction(ByVal functionID As Integer) As DataRow

        Return ExecuteDataset("LD_GetFunction", functionID).Tables(0).Rows(0)

    End Function

    Public Shared Function GetAllFunctions(ByVal ClientID As Integer) As DataTable

        Return ExecuteDataset("LD_GetAllFunctions", ClientID).Tables(0)

    End Function

    Public Shared Function SaveFunctions(ByVal transaction As SqlTransaction, ByVal functionID As Integer, ByVal functionName As String, ByVal functionSig As String, ByVal functionDesc As String, _
                                         ByVal functionCode As String, ByVal bitVBS As Boolean, ByVal clientID As Integer, ByVal functionGroupID As Integer) As Integer

        Return ExecuteInteger(transaction, "LD_SaveFunction", functionID, functionName, functionSig, functionDesc, functionCode, bitVBS, clientID, functionGroupID)

    End Function

#End Region

#Region " Tree Methods "

    Public Shared Function GetPackageList(ByVal userName As String, ByVal showPackages As Boolean) As DataTable

        Return ExecuteDataset("LD_PackageOpen", userName, Not showPackages).Tables(0)

    End Function

    Public Shared Function GetDeletedPackageList(ByVal userName As String) As DataTable

        Return ExecuteDataset("LD_PackageOpenDeleted", userName, False).Tables(0)

    End Function

    Public Shared Function GetFileQueueTree(ByVal userName As String) As DataTable

        Return ExecuteDataset("LD_ShowFileQueue", userName).Tables(0)

    End Function

#End Region

#Region " Package Load Methods "

    Public Shared Function GetPackageData(ByVal packageID As Integer, ByVal versionID As Integer) As DataSet

        If versionID < 0 Then
            Return ExecuteDataset("LD_GetDTS", packageID, Nothing)
        Else
            Return ExecuteDataset("LD_GetDTS", packageID, versionID)
        End If

    End Function

    Public Shared Function GetFileTypes() As DataTable

        Return ExecuteDataset("LD_GetFileType").Tables(0)

    End Function

    Public Shared Function GetSignOffByList() As DataTable

        Return ExecuteDataset("LD_SignOffBy").Tables(0)

    End Function

    Public Shared Function CanDeletePackage(ByVal PackageID As Integer) As Boolean

        Return CType(ExecuteInteger("LD_PackageCanBeDeleted", PackageID), Boolean)

    End Function

    Public Shared Function GetPackageNotes(ByVal packageID As Integer) As DataTable

        Return ExecuteDataset("LD_GetPackageNotes", packageID).Tables(0)

    End Function

#End Region

#Region " Package Update Methods "

    Public Shared Function SavePackageInfo(ByVal transaction As SqlTransaction, ByVal packageID As Integer, ByVal packageName As String, ByVal clientID As Integer, _
                                           ByVal studyID As Integer, ByVal teamNumber As Integer, ByVal loginName As String, ByVal fileTypeID As Integer, _
                                           ByVal fileSettings As String, ByVal signOffByID As Integer, ByVal packageFriendlyName As String, ByVal BitActive As Boolean, _
                                           ByVal BitDeleted As Boolean, ByVal OwnerMemberID As Nullable(Of Integer)) As Integer

        Dim OwnerID As Object = IIf(OwnerMemberID.HasValue, OwnerMemberID, DBNull.Value)

        Return ExecuteInteger(transaction, "LD_SavePackage", packageID, packageName, clientID, studyID, teamNumber, Environment.UserName, _
                              fileTypeID, fileSettings, signOffByID, packageFriendlyName, BitActive, BitDeleted, OwnerID)

    End Function

    Public Shared Function IncrementVersion(ByVal transaction As SqlTransaction, ByVal packageID As Integer, ByVal isNewSourceTemplate As Boolean, _
                                            ByVal fileTypeID As Integer) As Integer

        Return ExecuteInteger(transaction, "LD_IncrementVersion", packageID, isNewSourceTemplate, fileTypeID)

    End Function

    Public Shared Function SaveSourceColumn(ByVal transaction As SqlTransaction, ByVal packageID As Integer, ByVal version As Integer, ByVal sourceID As Integer, _
                                            ByVal columnNameOriginal As String, ByVal columnNameAlias As String, ByVal dataTypeID As Integer, ByVal length As Integer, _
                                            ByVal ordinal As Integer) As Integer

        Return ExecuteInteger(transaction, "LD_SaveSource", packageID, version, sourceID, columnNameOriginal, columnNameAlias, dataTypeID, length, ordinal)

    End Function

    Public Shared Function SyncronizeTemplates(ByVal transaction As SqlTransaction, ByVal packageID As Integer, ByVal versionID As Integer) As Integer

        Return ExecuteInteger(transaction, "LD_SyncSources", packageID, versionID)

    End Function

    Public Shared Function SaveDestinationColumn(ByVal transaction As SqlTransaction, ByVal packageID As Integer, ByVal version As Integer, ByVal fieldID As Integer, _
                                                 ByVal tableID As Integer, ByVal formula As String, ByVal sourceIDList As String, ByVal checkNulls As Boolean, _
                                                 ByVal frequencyLimit As Integer) As Integer

        Return ExecuteInteger(transaction, "LD_SaveDestination", packageID, version, tableID, fieldID, formula, sourceIDList, checkNulls, frequencyLimit)

    End Function

    Public Shared Function PackageTableCleanup(ByVal transaction As SqlTransaction, ByVal packageID As Integer, ByVal tableList As String) As Integer

        Return ExecuteInteger(transaction, "LD_PackageTableCleanup", packageID, tableList)

    End Function

    Public Shared Function UpdatePackageStatus(ByVal transaction As SqlTransaction, ByVal packageID As Integer, ByVal userName As String, ByVal isLocked As Boolean) As Integer

        Return ExecuteInteger(transaction, "LD_PackageStatus", userName, packageID, isLocked)

    End Function

    Public Shared Function SavePackageAs(ByVal transaction As SqlTransaction, ByVal packageID As Integer, ByVal newPackageName As String, ByVal newClientID As Integer, _
                                         ByVal newStudyID As Integer, ByVal teamNumber As Integer, ByVal userName As String, ByVal fileTypeID As Integer, _
                                         ByVal fileSettings As String, ByVal signOffByID As Integer, ByVal packageFriendlyName As String, _
                                         ByVal OwnerMemberID As Nullable(Of Integer)) As Integer

        Dim bitActive As Boolean = True
        Dim bitDeleted As Boolean = False
        Dim OwnerID As Object = IIf(OwnerMemberID.HasValue, OwnerMemberID, DBNull.Value)

        Return ExecuteInteger(transaction, "LD_SaveAsPackage", packageID, newPackageName, newClientID, newStudyID, teamNumber, userName, fileTypeID, fileSettings, signOffByID, packageFriendlyName, bitActive, bitDeleted, OwnerID)

    End Function

    Public Shared Sub SavePackageNote(ByVal userName As String, ByVal packageID As Integer, ByVal noteText As String)

        ExecuteNonQuery("LD_PackageNotes", userName, packageID, noteText)

    End Sub

#End Region

#Region " Package Execution Procedures "

    Public Shared Function GetPackageIDFromStudyID(ByVal studyID As Integer) As IDataReader

        Return ExecuteReader("LD_GetPackageIDsByStudyID", CInt(studyID))

    End Function

    Public Shared Function ValidatePackage(ByVal packageID As Integer, ByVal versionID As Integer) As Boolean

        Return CType(ExecuteScalar("LD_ValidatePackage", packageID, versionID), Boolean)

    End Function

    Public Shared Function ConfirmUnqiueFriendlyPackageName(ByVal clientID As Integer, ByVal packageName As String) As Boolean

        Return CType(ExecuteScalar("LD_UniqueFriendlyPackageName", clientID, packageName), Boolean)

    End Function

    Public Shared Function FinishLoad(ByVal fileID As Integer) As Object

        Return ExecuteScalar("LD_PostDTS", fileID)

    End Function

    Public Shared Function Unload(ByVal fileID As Integer) As Object

        Return ExecuteScalar("LD_RollbackFile", fileID)

    End Function

    Public Shared Sub RunValidationReports(ByVal datafileID As Integer)

        ExecuteNonQuery("LD_RunValidation", datafileID)

    End Sub

    Public Shared Function LogServiceEvent(ByVal dataFileID As Integer, ByVal eventData As String, ByVal threadID As Integer) As Object

        Return ExecuteScalar("LD_LogServiceEvent", dataFileID, eventData, threadID)

    End Function

    Public Shared Sub ApplyFile(ByVal dataFileID As Integer)

        ExecuteNonQuery("LD_ApplyShell", dataFileID)

    End Sub

    Public Shared Function CheckForWork() As IDataReader

        Return ExecuteReader("LD_CheckForWork")

    End Function

#End Region

#Region " Data File Procedures "

    Public Shared Function NewDataFile(ByVal trans As SqlClient.SqlTransaction, ByVal packageID As Integer, ByVal versionID As Integer, ByVal fileType As Integer, _
                                       ByVal fileFolder As String, ByVal originalFileName As String, ByVal fileName As String, ByVal fileSize As Integer, _
                                       ByVal numRecords As Integer, ByVal isDRGUpdate As Boolean, ByVal isLoadToLive As Boolean) As DataTable

        Return ExecuteDataset(trans, "LD_AddDataFile", packageID, versionID, fileType, fileFolder, originalFileName, fileName, fileSize, numRecords, isDRGUpdate, isLoadToLive).Tables(0)

    End Function

    Public Shared Function GetDataFile(ByVal dataFileID As Integer) As DataTable

        Return ExecuteDataset("LD_GetDataFile", dataFileID).Tables(0)

    End Function

    Public Shared Function GetDataFileIdsByDatasetId(ByVal dataSetID As Integer) As Integer()

        Dim idList As New List(Of Integer)

        Using rdr As IDataReader = ExecuteReader("LD_GetDataFilesByDatasetId", dataSetID)
            While rdr.Read
                idList.Add(rdr.GetInt32(rdr.GetOrdinal("DataFile_id")))
            End While
        End Using

        Return idList.ToArray

    End Function

    Public Shared Function UpdateFileState(ByVal dataFileID As Integer, ByVal state As Integer, ByVal stateParam As String, ByVal stateDescription As String, _
                                           ByVal memberID As Nullable(Of Integer)) As Integer

        Dim lastUserMemberID As Object = IIf(memberID.HasValue, memberID.Value, DBNull.Value)

        Return ExecuteInteger("LD_UpdateFileState", dataFileID, state, stateParam, stateDescription, lastUserMemberID)

    End Function

    Public Shared Function GetLastUserMemberID(ByVal dataFileID As Integer) As Integer

        Return ExecuteInteger("LD_GetLastUserMemberID", dataFileID)

    End Function

    Public Shared Function GetLoadingQueue(ByVal stateFilter As String, ByVal startDate As Object, ByVal endDate As Object) As DataTable

        Return ExecuteDataset("LD_GetFileQueue", stateFilter, startDate, endDate).Tables(0)

    End Function

    Public Shared Function GetFileHistory(ByVal dataFileID As Integer) As DataTable

        Return ExecuteDataset("LD_GetFileHistory", dataFileID).Tables(0)

    End Function

    Public Shared Function GroupFiles(ByVal dataFileList As String) As Boolean

        Dim retVal As Integer = ExecuteInteger("LD_GroupFiles", dataFileList, 1)

        Return (retVal = 1)

    End Function

    Public Shared Function UnGroupFiles(ByVal dataFileList As String) As Boolean

        Dim retVal As Integer = ExecuteInteger("LD_GroupFiles", dataFileList, 0)

        Return (retVal = 1)

    End Function

    Public Shared Function WhoApproved(ByVal dataFileID As Integer) As DataTable

        Dim ds As DataSet = ExecuteDataset("LD_WhoApproved", dataFileID)

        If ds.Tables.Count = 0 Then
            Return Nothing
        Else
            Return ds.Tables(0)
        End If

    End Function

    Public Shared Function GetSkippedRecord(ByVal dataFileID As Integer) As DataTable

        Return ExecuteDataset("LD_ViewSkipped", dataFileID).Tables(0)

    End Function

    Public Shared Function GetSkippedCount(ByVal dataFileID As Integer) As Integer

        Dim table As DataTable = ExecuteDataset("LD_FileReview", dataFileID, 1, True).Tables(0)
        Return (CInt(table.Rows(0).Item(0)))

    End Function

    Public Shared Function GetFileMetaFields(ByVal dataFileID As Integer) As DataTable

        Return ExecuteDataset("LD_GetCrossTabFields", dataFileID).Tables(0)

    End Function

    Public Shared Function GetCrossTabResults(ByVal dataFileID As Integer, ByVal fieldList As String) As DataTable

        Return ExecuteDataset("LD_CrossTabs", dataFileID, fieldList).Tables(0)

    End Function

    Public Shared Function UpdateDRG(ByVal studyID As Integer, ByVal dataFileID As Integer) As DataTable

        Dim ds As System.Data.DataSet = ExecuteDataset("LD_UpdateDRG", studyID, dataFileID)

        Return ds.Tables(ds.Tables.Count - 1) 'negative (-1) because table ordinal positions are zero based

    End Function

    'Private Shared Function GetMatchFields(ByVal studyID As Integer, ByVal tableName As String) As List(Of String)
    '    Dim list As New List(Of String)
    '    Dim command As New SqlCommand
    '    command.Connection = New SqlConnection(AppConfig.QualisysConnection)
    '    command.CommandText = "select strField_nm from metadata_view where study_id = @StudyID and strTable_nm = @TableName and bitMatchField_FLG = 1"
    '    command.Parameters.AddWithValue("@StudyID", studyID)
    '    command.Parameters.AddWithValue("@TableName", tableName)
    '    command.Connection.Open()
    '    Dim reader As SqlDataReader = command.ExecuteReader
    '    Do While reader.Read
    '        list.Add(reader.Item("strField_nm").ToString)
    '    Loop
    '    reader.Close()
    '    Return list
    'End Function

    'Public Function CheckForDuplicateRowsFromLoad(ByVal StudyID As Integer, ByVal DataFileID As Integer, ByVal TableName As String, ByVal CopyColumnList As List(Of String)) As DataTable Implements IDataAccess.CheckForDuplicateRowsFromLoad
    '    Dim matchFields As List(Of String) = Me.GetMatchFields(StudyID, TableName)
    '    Dim selectCommandText As String = String.Format("SELECT {0}, {1} FROM s{2}.{3}_Load WHERE {0} in (Select {0} from s{2}.{3}_Load WHERE Datafile_ID = {4} GROUP BY {0} HAVING Count(*) > 1) GROUP BY {0}, {1} HAVING Count(*) < 2 ORDER BY {0}, {1}", String.Join(",", matchFields.ToArray), String.Join(",", CopyColumnList.ToArray), StudyID, TableName, DataFileID)
    '    Dim dataTable As New DataTable
    '    Dim dataAdapter As New SqlDataAdapter(selectCommandText, Me.LoadConnStr)
    '    dataAdapter.Fill(dataTable)
    '    Return dataTable
    'End Function

#End Region

End Class
