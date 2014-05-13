Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data
Imports Nrc.QualiSys.QLoader.Library
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports Nrc.Framework.BusinessLogic.Configuration

Friend Class LoadToLiveDefinitionProvider
    Inherits QualiSys.QLoader.Library20.LoadToLiveDefinitionProvider

#Region " Private Populate Method "

    Private Function PopulateLoadToLiveDefinition(ByVal rdr As SafeDataReader) As LoadToLiveDefinition

        Dim newObject As LoadToLiveDefinition = LoadToLiveDefinition.NewLoadToLiveDefinition
        Dim privateInterface As ILoadToLiveDefinition = newObject

        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("LoadToLiveDefinition_id")
        newObject.DataFileId = rdr.GetInteger("DataFile_id")
        newObject.TableName = rdr.GetString("strTable_Nm")
        newObject.FieldName = rdr.GetString("strField_Nm")
        newObject.IsMatchField = rdr.GetBoolean("IsMatchField")
        newObject.DataType = rdr.GetEnum(Of DataTypes)("DataType")
        newObject.EndPopulate()

        Return newObject

    End Function

#End Region

#Region " Public Methods "

    Public Overrides Function SelectLoadToLiveDefinition(ByVal id As Integer) As LoadToLiveDefinition

        Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectLoadToLiveDefinition, id)

        Using rdr As New SafeDataReader(QLoaderDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateLoadToLiveDefinition(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllLoadToLiveDefinitions() As LoadToLiveDefinitionCollection

        Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAllLoadToLiveDefinitions)

        Using rdr As New SafeDataReader(QLoaderDatabaseHelper.ExecuteReader(cmd))
            Return PopulateCollection(Of LoadToLiveDefinitionCollection, LoadToLiveDefinition)(rdr, AddressOf PopulateLoadToLiveDefinition)
        End Using

    End Function

    Public Overrides Function SelectLoadToLiveDefinitionsByDataFileID(ByVal dataFileID As Integer) As LoadToLiveDefinitionCollection

        Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectLoadToLiveDefinitionsByDataFileID, dataFileID)

        Using rdr As New SafeDataReader(QLoaderDatabaseHelper.ExecuteReader(cmd))
            Return PopulateCollection(Of LoadToLiveDefinitionCollection, LoadToLiveDefinition)(rdr, AddressOf PopulateLoadToLiveDefinition)
        End Using

    End Function

    Public Overrides Function InsertLoadToLiveDefinition(ByVal instance As LoadToLiveDefinition) As Integer

        Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.InsertLoadToLiveDefinition, instance.DataFileId, instance.TableName, instance.FieldName, instance.IsMatchField, instance.DataType)
        Return QLoaderDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateLoadToLiveDefinition(ByVal instance As LoadToLiveDefinition)

        Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.UpdateLoadToLiveDefinition, instance.Id, instance.DataFileId, instance.TableName, instance.FieldName, instance.IsMatchField, instance.DataType)
        QLoaderDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteLoadToLiveDefinition(ByVal instance As LoadToLiveDefinition)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.DeleteLoadToLiveDefinition, instance.Id)
            QLoaderDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Function LoadToLiveDuplicateCheck(ByVal dataFileID As Integer, ByVal tableName As String, ByVal package As DTSPackage, _
                                                       ByVal definitions As LoadToLiveDefinitionCollection) As DataTable

        'Get a list of all match fields and another of all update fields
        Dim matchFields As List(Of String) = definitions.GetMatchFieldsByTableName(tableName)
        Dim updateFields As List(Of String) = definitions.GetUpdateFieldsByTableName(tableName)

        'Build the join portion of the where clause
        Dim where As String = String.Empty
        For Each field As String In matchFields
            where &= String.Format("m.{0} = t.{0} AND ", field)
        Next
        where = where.Remove(where.Length - 4)

        'Determine based on match field(s) which ones have more than one row
        Dim sql1 As String = "SELECT {0} " & _
                             "INTO #Match1 " & _
                             "FROM s{1}.{2}_Load " & _
                             "WHERE DataFile_id = {3} " & _
                             "GROUP BY {0} " & _
                             "HAVING Count(*) > 1"
        sql1 = String.Format(sql1, String.Join(", ", matchFields.ToArray), package.Study.StudyID, tableName, dataFileID)

        'Get the distinct match field(s) and update field(s) for the previous query's match field(s)
        Dim sql2 As String = "SELECT t.{0}, t.{1} " & _
                             "INTO #Dups " & _
                             "FROM #Match1 m, s{2}.{3}_Load t " & _
                             "WHERE {4} " & _
                             "AND dataFile_id = {5} " & _
                             "GROUP BY t.{0}, t.{1}"
        sql2 = String.Format(sql2, String.Join(", t.", matchFields.ToArray), String.Join(", t.", updateFields.ToArray), package.Study.StudyID, tableName, where, dataFileID)

        'Get the distinct match field(s) that have for than one row from the previous query
        Dim sql3 As String = "SELECT {0} " & _
                             "INTO #Match2 " & _
                             "FROM #Dups " & _
                             "GROUP BY {0} " & _
                             "HAVING Count(*) > 1"
        sql3 = String.Format(sql3, String.Join(", ", matchFields.ToArray))

        'Get the distinct match field(s) and update field(s) for the previous query's match field(s)
        Dim sql4 As String = "SELECT t.{0}, t.{1}, Count(*) AS QtyRows " & _
                             "FROM #Match2 m, s{2}.{3}_Load t " & _
                             "WHERE {4} " & _
                             "AND DataFile_id = {5} " & _
                             "GROUP BY t.{0}, t.{1}"
        sql4 = String.Format(sql4, String.Join(", t.", matchFields.ToArray), String.Join(", t.", updateFields.ToArray), package.Study.StudyID, tableName, where, dataFileID)

        'Add the cleanup code
        Dim sql5 As String = String.Format("DROP TABLE #Match1{0}DROP TABLE #Dups{0}DROP TABLE #Match2", vbCrLf)

        'Build the complete query
        Dim sql As String = String.Format("{0}{1}{2}{1}{3}{1}{4}{1}{5}", sql1, vbCrLf, sql2, sql3, sql4, sql5)
        Debug.Print(sql)    'TODO: Remove Debug.Print

        'Get the result set containing all duplicate rows
        Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetSqlStringCommand(sql)
        Return QLoaderDatabaseHelper.ExecuteDataSet(cmd).Tables(0)

    End Function

    Public Overrides Sub LoadToLiveDeleteDuplicate(ByVal row As DataRow, ByVal dataFileID As Integer, ByVal tableName As String, ByVal package As DTSPackage)

        'Get the load to live definitions for this table
        Dim definitions As LoadToLiveDefinitionCollection = LoadToLiveDefinition.GetByDataFileID(dataFileID)

        'Build the delete statement
        Dim sql As String = String.Format("DELETE FROM s{0}.{1}_Load WHERE DataFile_id = {2}", package.Study.StudyID, tableName, dataFileID)

        'Add the where clause
        For Each def As LoadToLiveDefinition In definitions
            If def.TableName.ToUpper = tableName.ToUpper Then
                If IsDBNull(row.Item(def.FieldName)) Then
                    sql &= String.Format(" AND {0} IS NULL", def.FieldName)
                Else
                    Select Case def.DataType
                        Case DataTypes.Int
                            sql &= String.Format(" AND {0} = {1}", def.FieldName, row.Item(def.FieldName).ToString)

                        Case DataTypes.Varchar
                            sql &= String.Format(" AND {0} = '{1}'", def.FieldName, row.Item(def.FieldName).ToString)

                        Case DataTypes.DateTime
                            sql &= String.Format(" AND {0} = '{1}'", def.FieldName, row.Item(def.FieldName).ToString)

                    End Select
                End If
            End If
        Next
        Debug.Print(sql)    'TODO: Remove Debug.Print

        'Execute the command
        Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetSqlStringCommand(sql)
        QLoaderDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub LoadToLiveUpdate(ByVal dataFileID As Integer, ByVal tableName As String, ByVal package As DTSPackage, _
                                          ByVal definitions As LoadToLiveDefinitionCollection, ByRef qualisysRecCount As Integer, _
                                          ByRef datamartRecCount As Integer, ByRef catalystRecCount As Integer)

        'Get a list of all match fields and another of all update fields
        Dim matchFields As List(Of String) = definitions.GetMatchFieldsByTableName(tableName)
        Dim updateFields As List(Of String) = definitions.GetUpdateFieldsByTableName(tableName)

        'Get a list of the datamart tables to be updated
        Dim datamartTables As List(Of String) = LoadToLiveGetDataMartTableNames(dataFileID, package.Study.StudyID, tableName, matchFields)

        'Start a transaction on the QualiSys database
        Using qualiSysConn As DbConnection = QualiSysDatabaseHelper.Db.CreateConnection
            qualiSysConn.Open()
            Using qualiSysTrans As DbTransaction = qualiSysConn.BeginTransaction
                Try
                    'Update all fields in the QualiSys database
                    qualisysRecCount = LoadToLiveUpdateQualiSys(qualiSysTrans, dataFileID, package.Study.StudyID, tableName, matchFields, updateFields)

                Catch ex As Exception
                    'Rollback the QualiSys transaction
                    qualiSysTrans.Rollback()

                    'Throw the error
                    Throw New Exception(String.Format("Load to Live QualiSys Update failed for DataFileID: {0}, TableName: {1}", dataFileID, tableName), ex)

                End Try

                Try
                    'Update the Catalyst extract queue
                    catalystRecCount = LoadToLiveUpdateCatalyst(qualiSysTrans, dataFileID, package, definitions)

                Catch ex As Exception
                    'Rollback the QualiSys transaction
                    qualiSysTrans.Rollback()

                    'Throw the error
                    Throw New Exception(String.Format("Load to Live Catalyst Update failed for DataFileID: {0}, TableName: {1}", dataFileID, tableName), ex)

                End Try

                'Start a transaction on the DataMart database
                Using dataMartConn As DbConnection = DataMartDatabaseHelper.Db.CreateConnection
                    dataMartConn.Open()
                    Using dataMartTrans As DbTransaction = dataMartConn.BeginTransaction
                        Try
                            'Update all fields in the DataMart database
                            datamartRecCount = LoadToLiveUpdateDataMart(dataMartTrans, dataFileID, package.Study.StudyID, tableName, datamartTables, matchFields, updateFields)

                            'Everything looks good so lets commit the transactions on both databases
                            qualiSysTrans.Commit()
                            dataMartTrans.Commit()

                        Catch ex As Exception
                            'Rollback the transactions on both databases
                            qualiSysTrans.Rollback()
                            dataMartTrans.Rollback()

                            'Throw the error
                            Throw New Exception(String.Format("Load to Live DataMart Update failed for DataFileID: {0}, QLoader TableName: {1}, DataMart TableNames: {2}", dataFileID, tableName, String.Join(", ", datamartTables.ToArray)), ex)

                        End Try
                    End Using
                End Using
            End Using
        End Using

    End Sub

#End Region

#Region " Private Methods "

    Private Function LoadToLiveUpdateQualiSys(ByVal trans As DbTransaction, ByVal dataFileID As Integer, ByVal studyID As Integer, _
                                              ByVal tableName As String, ByVal matchFields As List(Of String), _
                                              ByVal updateFields As List(Of String)) As Integer

        'Start the update statement
        Dim sql As String = "UPDATE qsys SET "

        'Add the updateFields
        For Each updateField As String In updateFields
            sql &= String.Format("qsys.{0} = qload.{0}, ", updateField)
        Next
        sql = sql.Remove(sql.Length - 2)

        'Add the from portion of the statement
        sql &= String.Format(" FROM s{0}.{1} qsys INNER JOIN QLoader.QP_Load.s{0}.{1}_Load qload ON ", studyID, tableName)

        'Add the join criteria
        For Each matchField As String In matchFields
            sql &= String.Format("qsys.{0} = qload.{0} AND ", matchField)
        Next
        sql = sql.Remove(sql.Length - 4)

        'Add the where clause
        sql &= String.Format("WHERE DataFile_id = {0}", dataFileID)
        Debug.Print(sql)    'TODO: Remove Debug.Print

        'Execute the command
        Dim cmd As DbCommand = QualiSysDatabaseHelper.Db.GetSqlStringCommand(sql)
        Return QualiSysDatabaseHelper.ExecuteNonQuery(cmd, trans)

    End Function

    Private Function LoadToLiveUpdateCatalyst(ByVal trans As DbTransaction, ByVal dataFileID As Integer, ByVal package As DTSPackage, ByVal definitions As LoadToLiveDefinitionCollection) As Integer

        Dim sql As String = String.Empty
        Dim updateTables As List(Of String) = definitions.GetTableList
        Dim samplePopIDs As New List(Of Integer)

        'Determine whether to use the Population or Encounter query
        If updateTables.Contains("ENCOUNTER") OrElse (updateTables.Contains("POPULATION") AndAlso package.Destinations.Item("ENCOUNTER") IsNot Nothing) Then
            'Use the encounter query
            sql = LoadToLiveGetCatalystEncounterQuery(dataFileID, package)
        ElseIf updateTables.Contains("POPULATION") Then
            'Use the population query
            sql = LoadToLiveGetCatalystPopulationQuery(dataFileID, package)
        End If
        Debug.Print(sql)    'TODO: Remove Debug.Print

        'Run this query if required
        If Not String.IsNullOrEmpty(sql) Then
            Dim cmd As DbCommand = QualiSysDatabaseHelper.Db.GetSqlStringCommand(sql)
            Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd, trans))
                Do While rdr.Read
                    'Add all distinct SamplePop_IDs to the list
                    Dim samplePopID As Integer = rdr.GetInteger("SamplePop_id")
                    If Not samplePopIDs.Contains(samplePopID) Then
                        samplePopIDs.Add(samplePopID)
                    End If
                Loop
            End Using
        End If

        'Determine if we need to run any lookup queries
        For Each updateTable As String In updateTables
            If updateTable <> "POPULATION" AndAlso updateTable <> "ENCOUNTER" Then
                'Get the tables this lookup table joins to
                Dim lookups As LoadToLiveLookupCollection = LoadToLiveLookup.GetByStudyIDTableName(package.Study.StudyID, updateTable)
                Dim masterTables As List(Of String) = lookups.GetMasterTableList

                'Process each joined table
                For Each masterTable As String In masterTables
                    'Get the lookup query
                    sql = LoadToLiveGetCatalystLookupQuery(dataFileID, package, updateTable, masterTable, lookups)
                    Debug.Print(sql)    'TODO: Remove Debug.Print

                    'Run the query
                    If Not String.IsNullOrEmpty(sql) Then
                        Dim cmd As DbCommand = QualiSysDatabaseHelper.Db.GetSqlStringCommand(sql)
                        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd, trans))
                            Do While rdr.Read
                                'Add all distinct SamplePop_IDs to the list
                                Dim samplePopID As Integer = rdr.GetInteger("SamplePop_id")
                                If Not samplePopIDs.Contains(samplePopID) Then
                                    samplePopIDs.Add(samplePopID)
                                End If
                            Loop
                        End Using
                    End If
                Next
            End If
        Next

        'Insert all of the SamplePop_IDs into the Catalyst table
        For Each samplePopID As Integer In samplePopIDs
            LoadToLiveInsertCatalyst(samplePopID)
        Next

        'Return the quantity of records inserted
        Return samplePopIDs.Count

    End Function

    Private Function LoadToLiveGetCatalystPopulationQuery(ByVal dataFileID As Integer, ByVal package As DTSPackage) As String

        'Start the select statement
        Dim sql As String = String.Format("SELECT DISTINCT sp.SamplePop_id FROM SamplePop sp INNER JOIN s{0}.Population po ON sp.Pop_id = po.Pop_id INNER JOIN QLoader.QP_Load.s{0}.Population_Load pl ON ", package.Study.StudyID)

        'Add the join criteria
        For Each column As DestinationColumn In package.Destinations("POPULATION").Columns
            If column.IsMatchField Then
                sql &= String.Format("po.{0} = pl.{0} AND ", column.ColumnName)
            End If
        Next
        sql = sql.Remove(sql.Length - 4)

        'Add the where clause
        sql &= String.Format("WHERE pl.DataFile_id = {0} AND sp.Study_id = {1}", dataFileID, package.Study.StudyID)

        Return sql

    End Function

    Private Function LoadToLiveGetCatalystEncounterQuery(ByVal dataFileID As Integer, ByVal package As DTSPackage) As String

        'Start the select statement
        Dim sql As String = String.Format("SELECT DISTINCT sp.SamplePop_id FROM SelectedSample ss INNER JOIN SamplePop sp ON ss.Pop_id = sp.Pop_id AND ss.Study_id = sp.Study_id INNER JOIN s{0}.Encounter en ON ss.Pop_id = en.Pop_id AND ss.Enc_id = en.Enc_id INNER JOIN QLoader.QP_Load.s{0}.Encounter_Load el ON ", package.Study.StudyID)

        'Add the join criteria
        For Each column As DestinationColumn In package.Destinations("ENCOUNTER").Columns
            If column.IsMatchField Then
                sql &= String.Format("en.{0} = el.{0} AND ", column.ColumnName)
            End If
        Next
        sql = sql.Remove(sql.Length - 4)

        'Add the where clause
        sql &= String.Format("WHERE el.DataFile_id = {0} AND sp.Study_id = {1}", dataFileID, package.Study.StudyID)

        Return sql

    End Function

    Private Function LoadToLiveGetCatalystLookupQuery(ByVal dataFileID As Integer, ByVal package As DTSPackage, ByVal updateTable As String, ByVal masterTable As String, ByVal allLookups As LoadToLiveLookupCollection) As String

        Dim sql As String = String.Empty
        Dim lookups As LoadToLiveLookupCollection = allLookups.GetLookupsByMasterTableName(masterTable)

        If masterTable.ToUpper = "POPULATION" Then
            'Start the select statement
            sql = String.Format("SELECT DISTINCT sp.SamplePop_id FROM SamplePop sp INNER JOIN s{0}.Population po ON sp.Pop_id = po.Pop_id INNER JOIN s{0}.{1} qsyslkup ON ", package.Study.StudyID, updateTable)

            'Add the join criteria
            For Each lookup As LoadToLiveLookup In lookups
                sql &= String.Format("po.{0} = qsyslkup.{1} AND ", lookup.MasterFieldName, lookup.LookupFieldName)
            Next
            sql = sql.Remove(sql.Length - 4)

            'Add join to load table
            sql &= String.Format("INNER JOIN QLoader.QP_Load.s{0}.{1}_Load qloadlkup ON ", package.Study.StudyID, updateTable)

            'Add the join criteria
            For Each lookup As LoadToLiveLookup In lookups
                sql &= String.Format("qsyslkup.{0} = qloadlkup.{0} AND ", lookup.LookupFieldName)
            Next
            sql = sql.Remove(sql.Length - 4)

            'Add the where clause
            sql &= String.Format("WHERE qloadlkup.DataFile_id = {0} AND sp.Study_id = {1}", dataFileID, package.Study.StudyID)

        ElseIf masterTable.ToUpper = "ENCOUNTER" Then
            'Start the select statement
            sql = String.Format("SELECT DISTINCT sp.SamplePop_id FROM SelectedSample ss INNER JOIN SamplePop sp ON ss.Pop_id = sp.Pop_id AND ss.Study_id = sp.Study_id INNER JOIN s{0}.Encounter en ON ss.Pop_id = en.Pop_id AND ss.Enc_id = en.Enc_id INNER JOIN s{0}.{1} qsyslkup ON ", package.Study.StudyID, updateTable)

            'Add the join criteria
            For Each lookup As LoadToLiveLookup In lookups
                sql &= String.Format("en.{0} = qsyslkup.{1} AND ", lookup.MasterFieldName, lookup.LookupFieldName)
            Next
            sql = sql.Remove(sql.Length - 4)

            'Add join to load table
            sql &= String.Format("INNER JOIN QLoader.QP_Load.s{0}.{1}_Load qloadlkup ON ", package.Study.StudyID, updateTable)

            'Add the join criteria
            For Each lookup As LoadToLiveLookup In lookups
                sql &= String.Format("qsyslkup.{0} = qloadlkup.{0} AND ", lookup.LookupFieldName)
            Next
            sql = sql.Remove(sql.Length - 4)

            'Add the where clause
            sql &= String.Format("WHERE qloadlkup.DataFile_id = {0} AND sp.Study_id = {1}", dataFileID, package.Study.StudyID)

        End If

        Return sql

    End Function

    Private Sub LoadToLiveInsertCatalyst(ByVal samplePopID As Integer)

        Dim cmd As DbCommand = QualiSysDatabaseHelper.Db.GetStoredProcCommand(SP.InsertNrcDataMartEtlExtractQueue, samplePopID)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Private Function LoadToLiveUpdateDataMart(ByVal trans As DbTransaction, ByVal dataFileID As Integer, ByVal studyID As Integer, _
                                              ByVal loadTable As String, ByVal dataMartTables As List(Of String), _
                                              ByVal matchFields As List(Of String), ByVal updateFields As List(Of String)) As Integer

        Dim quantityRecords As Integer

        For Each dataMartTable As String In dataMartTables
            'Start the update statement
            Dim sql As String = "UPDATE dmart SET "

            'Add the updateFields
            For Each updateField As String In updateFields
                sql &= String.Format("dmart.{0} = qload.{0}, ", updateField)
            Next
            sql = sql.Remove(sql.Length - 2)

            'Add the from portion of the statement
            sql &= String.Format(" FROM s{0}.{1} dmart INNER JOIN QLoader.QP_Load.s{0}.{2}_Load qload ON ", studyID, dataMartTable, loadTable)

            'Add the join criteria
            For Each matchField As String In matchFields
                sql &= String.Format("dmart.{0} = qload.{0} AND ", matchField)
            Next
            sql = sql.Remove(sql.Length - 4)

            'Add the where clause
            sql &= String.Format("WHERE DataFile_id = {0}", dataFileID)
            Debug.Print(sql)    'TODO: Remove Debug.Print

            'Execute the command
            Dim cmd As DbCommand = DataMartDatabaseHelper.Db.GetSqlStringCommand(sql)
            quantityRecords += DataMartDatabaseHelper.ExecuteNonQuery(cmd, trans)
        Next

        Return quantityRecords

    End Function

    Private Function LoadToLiveGetDataMartTableNames(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal tableName As String, _
                                                     ByVal matchFields As List(Of String)) As List(Of String)

        Dim tableNames As New List(Of String)

        'Start the select statement
        Dim sql As String = String.Format("select * into #tmpQLoad from QLoader.QP_Load.s{0}.{1}_Load ", studyID, tableName)
        'Add the where clause
        sql &= String.Format("WHERE DataFile_id = {0} ", dataFileID)

        sql &= "SELECT DISTINCT TableName "

        'Add the from pertion of the statement
        sql &= String.Format("FROM s{0}.Big_Table_View dmart INNER JOIN #tmpQLoad qload ON ", studyID, tableName)

        'Add the join criteria
        For Each matchField As String In matchFields
            sql &= String.Format("dmart.{0} = qload.{0} AND ", matchField)
        Next
        sql = sql.Remove(sql.Length - 4)

        Debug.Print(sql)    'TODO: Remove Debug.Print

        'Get the result set containing all duplicate rows
        Dim cmd As DbCommand = DataMartDatabaseHelper.Db.GetSqlStringCommand(sql)
        Using rdr As New SafeDataReader(DataMartDatabaseHelper.ExecuteReader(cmd))
            Do While rdr.Read
                tableNames.Add(rdr.GetString("TableName"))
            Loop
        End Using

        Return tableNames

    End Function

#End Region

End Class
