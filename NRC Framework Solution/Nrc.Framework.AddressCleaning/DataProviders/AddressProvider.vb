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


    Public Shared Sub CleanAll(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal batchSize As Integer, ByRef metaData As AddressMetadata, ByVal addresses As AddressCollection, ByVal loadDB As LoadDatabases)

        Dim done As Boolean
        Dim cmd As DbCommand
        Dim addrTable As DataTable

        'Store the start time
        metaData.Duration = New TimeSpan(0)
        Dim startDate As Date = Date.Now

        'Get the population records
        If loadDB = LoadDatabases.QPLoad Then
            cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAddressesByMetaData, batchSize, metaData.SelectFieldList, metaData.KeyFieldName, metaData.SQLTableName(studyID), metaData.AddressStatusFieldName, metaData.NameStatusFieldName, dataFileID)
            addrTable = QLoaderDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
        Else
            cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAddressesByMetaData, batchSize, metaData.SelectFieldList, metaData.KeyFieldName, metaData.SQLTableName(studyID), metaData.AddressStatusFieldName, metaData.NameStatusFieldName, dataFileID)
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

                        Case "FIELDADDRTITLENAME"
                            If Not row.IsNull(col) Then
                                addr.OriginalName.Title = row.Item(col).ToString.Trim
                            Else
                                addr.OriginalName.Title = String.Empty
                            End If

                        Case "FIELDADDRFNAME"
                            If Not row.IsNull(col) Then
                                addr.OriginalName.FirstName = row.Item(col).ToString.Trim
                            Else
                                addr.OriginalName.FirstName = String.Empty
                            End If

                        Case "FIELDADDRMNAME"
                            If Not row.IsNull(col) Then
                                addr.OriginalName.MiddleInitial = row.Item(col).ToString.Trim
                            Else
                                addr.OriginalName.MiddleInitial = String.Empty
                            End If

                        Case "FIELDADDRLNAME"
                            If Not row.IsNull(col) Then
                                addr.OriginalName.LastName = row.Item(col).ToString.Trim
                            Else
                                addr.OriginalName.LastName = String.Empty
                            End If

                        Case "FIELDADDRSUFFIXNAME"
                            If Not row.IsNull(col) Then
                                addr.OriginalName.Suffix = row.Item(col).ToString.Trim
                            Else
                                addr.OriginalName.Suffix = String.Empty
                            End If
                    End Select
                Next
            Next

            'Cleanup
            addrTable.Dispose()

            'Clean the addresses
            Logs.Info(String.Format("Begin CleanAll.addresses.Clean - DataFile_id: {0}, Study_id: {1}", dataFileID, studyID))
            addresses.Clean(False, True, dataFileID, metaData.ProperCase)
            Logs.Info(String.Format("End CleanAll.addresses.Clean - DataFile_id: {0}, Study_id: {1}", dataFileID, studyID))


            'Update these addresses to the database
            For Each addr As Address In addresses

                Dim updateFieldList As String = metaData.UpdateFieldListAddress(addr)

                'Update this Address
                Dim updateCmd As DbCommand
                If loadDB = LoadDatabases.QPLoad Then
                    updateCmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.UpdateAddressesByMetaGroup, metaData.SQLTableName(studyID), metaData.UpdateFieldListAddress(addr), metaData.KeyFieldName, addr.DBKey)
                    QLoaderDatabaseHelper.ExecuteNonQuery(updateCmd)
                Else
                    updateCmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.UpdateAddressesByMetaGroup, metaData.SQLTableName(studyID), metaData.UpdateFieldListAddress(addr), metaData.KeyFieldName, addr.DBKey)
                    DataLoadDatabaseHelper.ExecuteNonQuery(updateCmd)
                End If
            Next

            'Clear the addresses collection
            addresses.Clear()

            'Get the next set of population records
            If loadDB = LoadDatabases.QPLoad Then
                cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAddressesByMetaData, batchSize, metaData.SelectFieldList, metaData.KeyFieldName, metaData.SQLTableName(studyID), metaData.AddressStatusFieldName, metaData.NameStatusFieldName, dataFileID)
                addrTable = QLoaderDatabaseHelper.ExecuteDataSet(cmd).Tables(0)
            Else
                cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.SelectAddressesByMetaData, batchSize, metaData.SelectFieldList, metaData.KeyFieldName, metaData.SQLTableName(studyID), metaData.AddressStatusFieldName, metaData.NameStatusFieldName, dataFileID)
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
        metaData.Duration = Date.Now.Subtract(startDate)


    End Sub

#End Region

End Class
