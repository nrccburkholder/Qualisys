Imports System.Data.Common

Friend Class AddressProvider

#Region " Public Shared Methods "

    ''' <summary>
    ''' This routine is used to determine whether or not the CleanAddressBit is set for the specified study.
    ''' </summary>
    ''' <param name="studyID">The study to be cleaned.</param>
    ''' <returns>The value of the CleanAddressBit.</returns>
    ''' <remarks></remarks>
    Public Shared Function SelectCleanAddressBit(ByVal studyID As Integer) As Boolean

        Dim cmd As DbCommand = QualiSysDatabaseHelper.Db.GetStoredProcCommand(SP.SelectCleanAddressBit, studyID)
        Return QualiSysDatabaseHelper.ExecuteBoolean(cmd)

    End Function

    ''' <summary>
    ''' This routine is the internal interface called to clean all of the 
    ''' addresses in the specified datafile and study.
    ''' </summary>
    ''' <param name="dataFileID">The datafile to be cleaned.</param>
    ''' <param name="studyID">The study to be cleaned.</param>
    ''' <param name="batchSize">The quantity of records to process on each pass.</param>
    ''' <param name="metaGroups">Collection of meta groups that specify information about this group.</param>
    ''' <param name="addresses">AddressCollection object to hold addresses to be cleaned.</param>
    ''' <param name="loadDB">The database these records are stored in.</param>
    ''' <param name="forceProxy">Specifies whether or not to force the use of a proxy server for web requests.</param>
    ''' <remarks></remarks>
    Public Shared Sub CleanAll(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal batchSize As Integer, ByRef metaGroups As MetaGroupCollection, ByVal addresses As AddressCollection, ByVal loadDB As LoadDatabases, ByVal forceProxy As Boolean)

        Dim done As Boolean
        Dim cmd As DbCommand
        Dim addrTable As DataTable

        'Loop through all of the groups
        For Each metaGrp As MetaGroup In metaGroups
            'If this is an address group then process it
            If metaGrp.IsAddress And metaGrp.Selected Then
                'Store the start time
                metaGrp.Duration = New TimeSpan(0)
                Dim startDate As Date = Date.Now

                'Get the population records
                If loadDB = LoadDatabases.QPLoad Then
                    cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAddressesByMetaGroup, batchSize, metaGrp.SelectFieldList, metaGrp.KeyFieldName, metaGrp.SQLTableName(studyID), metaGrp.StatusFieldName, dataFileID)
                    addrTable = QLoaderDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
                Else
                    cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAddressesByMetaGroup, batchSize, metaGrp.SelectFieldList, metaGrp.KeyFieldName, metaGrp.SQLTableName(studyID), metaGrp.StatusFieldName, dataFileID)
                    addrTable = DataLoadDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
                End If

                'Check to see if we got any records
                If addrTable.Rows.Count = 0 Then
                    'If there are no records then we are done
                    done = True
                    addrTable.Dispose()
                Else
                    'There are some records so process them
                    done = False
                End If

                'Clear the addresses collection
                addresses.Clear()

                'Since we are only selecting a subset of the records on each pass
                'this loop is used to keep it going until all records have been cleaned
                Do Until done
                    'Add these records to the collection
                    For Each row As DataRow In addrTable.Rows
                        'Create a new address object and add it to the collection
                        Dim addr As Address = Address.NewAddress
                        addresses.Add(addr)

                        'Reset variables
                        addr.OriginalAddress.StreetLine2 = "%NOT%USED%"

                        'Loop through each field in the record and populate the address object
                        For Each col As DataColumn In addrTable.Columns
                            'Set the properties
                            Select Case col.ColumnName.ToUpper
                                Case "DBKEY"
                                    addr.DBKey = CInt(row.Item(col))

                                Case "FIELDADDRSTREET1"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.StreetLine1 = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.StreetLine1 = String.Empty
                                    End If

                                Case "FIELDADDRSTREET2"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.StreetLine2 = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.StreetLine2 = String.Empty
                                    End If

                                Case "FIELDADDRCITY"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.City = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.City = String.Empty
                                    End If

                                Case "FIELDADDRSTATE"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.State = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.State = String.Empty
                                    End If

                                Case "FIELDADDRCOUNTRY"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.Country = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.Country = String.Empty
                                    End If

                                Case "FIELDADDRZIP5"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.Zip5 = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.Zip5 = String.Empty
                                    End If

                                Case "FIELDADDRZIP4"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.Zip4 = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.Zip4 = String.Empty
                                    End If

                                Case "FIELDADDRPROVINCE"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.Province = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.Province = String.Empty
                                    End If

                                Case "FIELDADDRPOSTAL"
                                    If Not row.IsNull(col) Then
                                        addr.OriginalAddress.Postal = row.Item(col).ToString.Trim
                                    Else
                                        addr.OriginalAddress.Postal = String.Empty
                                    End If

                                Case "FIELDADDRTIMEZONE"
                                    If Not row.IsNull(col) Then
                                        addr.GeoCode.TimeZoneName = row.Item(col).ToString.Trim
                                    Else
                                        addr.GeoCode.TimeZoneName = String.Empty
                                    End If

                                Case "FIELDADDRFIPSCOUNTY"
                                    If Not row.IsNull(col) Then
                                        addr.GeoCode.CountyFIPS = row.Item(col).ToString.Trim
                                    Else
                                        addr.GeoCode.CountyFIPS = String.Empty
                                    End If

                                Case "FIELDADDRFIPSSTATE"
                                    If Not row.IsNull(col) Then
                                        addr.GeoCode.CountyFIPS = row.Item(col).ToString.Trim
                                    Else
                                        addr.GeoCode.CountyFIPS = String.Empty
                                    End If
                            End Select
                        Next
                    Next

                    'Cleanup
                    addrTable.Dispose()

                    'Clean the addresses
                    addresses.Clean(False, forceProxy, True)

                    'Update these addresses to the database
                    For Each addr As Address In addresses
                        'Update this Address
                        Dim updateCmd As DbCommand
                        If loadDB = LoadDatabases.QPLoad Then
                            updateCmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.UpdateAddressesByMetaGroup, metaGrp.SQLTableName(studyID), metaGrp.UpdateFieldListAddress(addr), metaGrp.KeyFieldName, addr.DBKey)
                            QLoaderDatabaseHelper.ExecuteNonQuery(updateCmd)
                        Else
                            updateCmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.UpdateAddressesByMetaGroup, metaGrp.SQLTableName(studyID), metaGrp.UpdateFieldListAddress(addr), metaGrp.KeyFieldName, addr.DBKey)
                            DataLoadDatabaseHelper.ExecuteNonQuery(updateCmd)
                        End If
                    Next

                    'Clear the addresses collection
                    addresses.Clear()

                    'Get the next set of population records
                    If loadDB = LoadDatabases.QPLoad Then
                        cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAddressesByMetaGroup, batchSize, metaGrp.SelectFieldList, metaGrp.KeyFieldName, metaGrp.SQLTableName(studyID), metaGrp.StatusFieldName, dataFileID)
                        addrTable = QLoaderDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
                    Else
                        cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAddressesByMetaGroup, batchSize, metaGrp.SelectFieldList, metaGrp.KeyFieldName, metaGrp.SQLTableName(studyID), metaGrp.StatusFieldName, dataFileID)
                        addrTable = DataLoadDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
                    End If

                    'Check to see if we got any records
                    If addrTable.Rows.Count = 0 Then
                        'If there are no records then we are done
                        done = True
                        addrTable.Dispose()
                    End If
                Loop

                'Store the duration
                metaGrp.Duration = Date.Now.Subtract(startDate)

            End If
        Next metaGrp

    End Sub

#End Region

End Class
