Imports System.Data.Common

Friend Class NameProvider

#Region " Public Shared Methods "

    ''' <summary>
    ''' This routine is the internal interface called to clean all of the 
    ''' names in the specified datafile and study.
    ''' </summary>
    ''' <param name="dataFileID">The datafile to be cleaned.</param>
    ''' <param name="studyID">The study to be cleaned.</param>
    ''' <param name="batchSize">The quantity of records to process on each pass.</param>
    ''' <param name="metaGroups">Collection of meta groups that specify information about this group.</param>
    ''' <param name="names">NameCollection object to hold names to be cleaned.</param>
    ''' <param name="loadDB">The database these records are stored in.</param>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests.</param>
    ''' <remarks></remarks>
    Public Shared Sub CleanAll(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal batchSize As Integer, ByRef metaGroups As MetaGroupCollection, ByVal names As NameCollection, ByVal loadDB As LoadDatabases, ByVal forceProxy As Boolean)

        Dim done As Boolean
        Dim cmd As DbCommand
        Dim nameTable As DataTable

        'Loop through all of the groups
        For Each metaGrp As MetaGroup In metaGroups
            'If this is a name group then process it
            If metaGrp.IsName And metaGrp.Selected Then
                'Store the start time
                metaGrp.Duration = New TimeSpan(0)
                Dim startDate As Date = Date.Now

                'Get the population records
                If loadDB = LoadDatabases.QPLoad Then
                    cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectNamesByMetaGroup, batchSize, metaGrp.SelectFieldList, metaGrp.KeyFieldName, metaGrp.SQLTableName(studyID), metaGrp.StatusFieldName, dataFileID)
                    nameTable = QLoaderDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
                Else
                    cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.SelectNamesByMetaGroup, batchSize, metaGrp.SelectFieldList, metaGrp.KeyFieldName, metaGrp.SQLTableName(studyID), metaGrp.StatusFieldName, dataFileID)
                    nameTable = DataLoadDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
                End If

                'Check to see if we got any records
                If nameTable.Rows.Count = 0 Then
                    'If there are no records then we are done
                    done = True
                    nameTable.Dispose()
                Else
                    'There are some records so process them
                    done = False
                End If

                'Clear the names collection
                names.Clear()

                'Since we are only selecting a subset of the records on each pass
                'this loop is used to keep it going until all records have been cleaned
                Do Until done
                    'Add these records to the collection
                    For Each row As DataRow In nameTable.Rows
                        'Create a new name object and add it to the collection
                        Dim item As Name = Name.NewName
                        names.Add(item)

                        'Loop through each field in the record
                        For Each col As DataColumn In nameTable.Columns
                            'Set the properties
                            Select Case col.ColumnName.ToUpper
                                Case "DBKEY"
                                    item.DBKey = CInt(row.Item(col))

                                Case "FIELDADDRTITLENAME"
                                    If Not row.IsNull(col) Then
                                        item.OriginalName.Title = row.Item(col).ToString.Trim
                                    Else
                                        item.OriginalName.Title = String.Empty
                                    End If

                                Case "FIELDADDRFNAME"
                                    If Not row.IsNull(col) Then
                                        item.OriginalName.FirstName = row.Item(col).ToString.Trim
                                    Else
                                        item.OriginalName.FirstName = String.Empty
                                    End If

                                Case "FIELDADDRMNAME"
                                    If Not row.IsNull(col) Then
                                        item.OriginalName.MiddleInitial = row.Item(col).ToString.Trim
                                    Else
                                        item.OriginalName.MiddleInitial = String.Empty
                                    End If

                                Case "FIELDADDRLNAME"
                                    If Not row.IsNull(col) Then
                                        item.OriginalName.LastName = row.Item(col).ToString.Trim
                                    Else
                                        item.OriginalName.LastName = String.Empty
                                    End If

                                Case "FIELDADDRSUFFIXNAME"
                                    If Not row.IsNull(col) Then
                                        item.OriginalName.Suffix = row.Item(col).ToString.Trim
                                    Else
                                        item.OriginalName.Suffix = String.Empty
                                    End If

                            End Select
                        Next
                    Next

                    'Cleanup
                    nameTable.Dispose()

                    'Clean the names
                    Logs.Info(String.Format("Begin CleanAll.names.Clean - DataFile_id: {0}, Study_id: {1}", dataFileID, studyID))
                    names.Clean(metaGrp.ProperCase, False, forceProxy, dataFileID)
                    Logs.Info(String.Format("End CleanAll.names.Clean - DataFile_id: {0}, Study_id: {1}", dataFileID, studyID))

                    'Update these names to the database
                    For Each nam As Name In names
                        'Update this Name
                        Dim updateCmd As DbCommand
                        If loadDB = LoadDatabases.QPLoad Then
                            updateCmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.UpdateNamesByMetaGroup, metaGrp.SQLTableName(studyID), metaGrp.UpdateFieldListName(nam), metaGrp.KeyFieldName, nam.DBKey)
                            QLoaderDatabaseHelper.ExecuteNonQuery(updateCmd)
                        Else
                            updateCmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.UpdateNamesByMetaGroup, metaGrp.SQLTableName(studyID), metaGrp.UpdateFieldListName(nam), metaGrp.KeyFieldName, nam.DBKey)
                            DataLoadDatabaseHelper.ExecuteNonQuery(updateCmd)
                        End If
                    Next

                    'Clear the names collection
                    names.Clear()

                    'Get the next set of population records
                    If loadDB = LoadDatabases.QPLoad Then
                        cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectNamesByMetaGroup, batchSize, metaGrp.SelectFieldList, metaGrp.KeyFieldName, metaGrp.SQLTableName(studyID), metaGrp.StatusFieldName, dataFileID)
                        nameTable = QLoaderDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
                    Else
                        cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.SelectNamesByMetaGroup, batchSize, metaGrp.SelectFieldList, metaGrp.KeyFieldName, metaGrp.SQLTableName(studyID), metaGrp.StatusFieldName, dataFileID)
                        nameTable = DataLoadDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
                    End If

                    'Check to see if we got any records
                    If nameTable.Rows.Count = 0 Then
                        'If there are no records then we are done
                        done = True
                        nameTable.Dispose()
                    End If
                Loop

                'Store the duration
                metaGrp.Duration = Date.Now.Subtract(startDate)

            End If
        Next metaGrp

    End Sub

#End Region

End Class
