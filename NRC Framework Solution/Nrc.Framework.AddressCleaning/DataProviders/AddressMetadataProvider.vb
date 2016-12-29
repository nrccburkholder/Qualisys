Imports System.Data.Common
Imports Nrc.Framework.Data

Friend Class AddressMetadataProvider

#Region " Populate Methods "

    Private Shared Sub PopulateMetadata(ByVal rdr As SafeDataReader, ByVal metaData As AddressMetadata)

        metaData.TableID = rdr.GetInteger("Table_id")
        metaData.TableName = rdr.GetString("strTable_Nm")
        metaData.KeyFieldName = rdr.GetString("strKeyField_Nm")
        metaData.ProperCase = rdr.GetBoolean("bitProperCase")

        'Add the MetaFields
        rdr.NextResult()

        While rdr.Read
            metaData.MetaGroups.Add(PopulateMetaGroup(rdr))
        End While

        rdr.NextResult()
        While rdr.Read
            metaData.MetaFields.Add(PopulateMetaField(rdr))
        End While
    End Sub


    Private Shared Function PopulateMetaGroup(ByVal rdr As SafeDataReader) As MetaGroup

        Dim newObject As MetaGroup = Nothing

        'Add the group if it does not already exist
        If newObject Is Nothing Then
            newObject = MetaGroup.NewMetaGroup
            Dim privateInterface As IMetaGroup = newObject
            newObject.BeginPopulate()
            privateInterface.GroupID = rdr.GetInteger("FieldGroup_id")
            newObject.GroupName = rdr.GetString("strFieldGroup_Nm")
            newObject.GroupType = rdr.GetString("strAddrCleanType")
            newObject.EndPopulate()
        End If

        Return newObject

    End Function


    Private Shared Function PopulateMetaField(ByVal rdr As SafeDataReader) As MetaField

        Dim newObject As MetaField = MetaField.NewMetaField
        Dim privateInterface As IMetaField = newObject
        newObject.BeginPopulate()
        privateInterface.FieldID = rdr.GetInteger("Field_id")
        newObject.FieldType = rdr.GetString("strAddrCleanType")
        newObject.FieldName = rdr.GetString("strField_Nm")
        newObject.FieldDataType = rdr.GetString("strFieldDataType")
        newObject.FieldLength = rdr.GetInteger("intFieldLength")
        newObject.AddrCleanCode = rdr.GetInteger("intAddrCleanCode")
        newObject.AddrCleanGroup = rdr.GetInteger("intAddrCleanGroup")
        newObject.ParamName = rdr.GetString("strParam_Nm")
        newObject.EndPopulate()

        Return newObject

    End Function

#End Region

#Region " Public Shared Methods "

    Friend Shared Function SelectAddressMetadataByStudyID(ByVal studyID As Integer) As AddressMetadata

        Dim metaData As New AddressMetadata()

        Dim cmd As DbCommand = QualiSysDatabaseHelper.Db.GetStoredProcCommand(SP.SelectMetadataByStudyID, studyID)

        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            While rdr.Read
                PopulateMetadata(rdr, metaData)
            End While
        End Using

        Return metaData

    End Function


    Friend Shared Sub GetMetadataCounts(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal metaData As AddressMetadata, ByVal loadDB As LoadDatabases)

        Dim cmd As DbCommand

        For Each mdGroup As MetaGroup In metaData.MetaGroups
            With mdGroup

                Dim statusFieldName As String

                If .IsAddress Then
                    statusFieldName = metaData.AddressStatusFieldName
                ElseIf .IsName Then
                    statusFieldName = metaData.NameStatusFieldName
                Else
                    statusFieldName = String.Empty
                End If

                If loadDB = LoadDatabases.QPLoad Then
                    cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectMetaGroupCounts, dataFileID, statusFieldName, metaData.ErrorFieldName, metaData.SQLTableName(studyID), .IsAddress)
                    Using rdr As New SafeDataReader(QLoaderDatabaseHelper.ExecuteReader(cmd))
                        If Not rdr.Read Then
                            .QtyUpdated = 0
                            .QtyErrors = 0
                            .QtyRemaining = 0
                            .QtyTotal = 0
                        Else
                            .QtyUpdated = rdr.GetInteger("intQtyUpdated")
                            .QtyErrors = rdr.GetInteger("intQtyErrors")
                            .QtyRemaining = rdr.GetInteger("intQtyRemaining")
                            .QtyTotal = rdr.GetInteger("intQtyTotal")
                        End If
                    End Using
                Else
                    cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.SelectMetaGroupCounts, dataFileID, statusFieldName, metaData.ErrorFieldName, metaData.SQLTableName(studyID), .IsAddress)
                    Using rdr As New SafeDataReader(DataLoadDatabaseHelper.ExecuteReader(cmd))
                        If Not rdr.Read Then
                            .QtyUpdated = 0
                            .QtyErrors = 0
                            .QtyRemaining = 0
                            .QtyTotal = 0
                        Else
                            .QtyUpdated = rdr.GetInteger("intQtyUpdated")
                            .QtyErrors = rdr.GetInteger("intQtyErrors")
                            .QtyRemaining = rdr.GetInteger("intQtyRemaining")
                            .QtyTotal = rdr.GetInteger("intQtyTotal")
                        End If
                    End Using
                End If
            End With
        Next

    End Sub

    Friend Shared Sub SaveMetadataCounts(ByVal dataFileID As Integer, ByVal metaData As AddressMetadata, ByVal loadDB As LoadDatabases)

        Dim cmd As DbCommand
        For Each md As MetaGroup In metaData.MetaGroups
            With md
                If loadDB = LoadDatabases.QPLoad Then
                    cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.InsertMetaGroupCounts, dataFileID, .RecordType, .GroupName, .QtyUpdated, .QtyErrors, .QtyRemaining, .QtyTotal)
                    QLoaderDatabaseHelper.ExecuteNonQuery(cmd)
                Else
                    cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.InsertMetaGroupCounts, dataFileID, .RecordType, .GroupName, .QtyUpdated, .QtyErrors, .QtyRemaining, .QtyTotal)
                    DataLoadDatabaseHelper.ExecuteNonQuery(cmd)
                End If
            End With
        Next
    End Sub

#End Region

End Class
