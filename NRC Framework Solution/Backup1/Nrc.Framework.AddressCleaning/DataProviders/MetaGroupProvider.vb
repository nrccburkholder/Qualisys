Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class MetaGroupProvider

#Region " Populate Methods "

    Private Shared Sub PopulateMetaGroup(ByVal rdr As SafeDataReader, ByVal metaGroups As MetaGroupCollection)

        Dim newObject As MetaGroup = Nothing

        'Check to see if this metagroup exists already
        Dim groupID As Integer = rdr.GetInteger("FieldGroup_id")
        Dim tableID As Integer = rdr.GetInteger("Table_id")
        For Each metaGrp As MetaGroup In metaGroups
            If metaGrp.GroupID = groupID AndAlso metaGrp.TableID = tableID Then
                newObject = metaGrp
                Exit For
            End If
        Next

        'Add the group if it does not already exist
        If newObject Is Nothing Then
            newObject = MetaGroup.NewMetaGroup
            Dim privateInterface As IMetaGroup = newObject
            newObject.BeginPopulate()
            privateInterface.GroupID = rdr.GetInteger("FieldGroup_id")
            newObject.GroupName = rdr.GetString("strFieldGroup_Nm")
            newObject.GroupType = rdr.GetString("strAddrCleanType")
            newObject.CleanDefault = rdr.GetBoolean("bitAddrCleanDefault")
            newObject.TableID = rdr.GetInteger("Table_id")
            newObject.TableName = rdr.GetString("strTable_Nm")
            newObject.KeyFieldName = rdr.GetString("strKeyField_Nm")
            newObject.ProperCase = rdr.GetBoolean("bitProperCase")
            newObject.EndPopulate()
            metaGroups.Add(newObject)
        End If

        'Add this MetaField
        newObject.MetaFields.Add(PopulateMetaField(rdr))

    End Sub

    Private Shared Function PopulateMetaField(ByVal rdr As SafeDataReader) As MetaField

        Dim newObject As MetaField = MetaField.NewMetaField
        Dim privateInterface As IMetaField = newObject
        newObject.BeginPopulate()
        privateInterface.FieldID = rdr.GetInteger("Field_id")
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

    Friend Shared Function SelectMetaGroupsByStudyID(ByVal studyID As Integer) As MetaGroupCollection

        Dim metaGroups As New MetaGroupCollection

        Dim cmd As DbCommand = QualiSysDatabaseHelper.Db.GetStoredProcCommand(SP.SelectMetaGroupsByStudyID, studyID)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            While rdr.Read
                PopulateMetaGroup(rdr, metaGroups)
            End While
        End Using

        'Remove any groups that are not cleanable by the new system
        Dim remove As New List(Of MetaGroup)
        For Each metaGrp As MetaGroup In metaGroups
            If metaGrp.IsAddress AndAlso (String.IsNullOrEmpty(metaGrp.ErrorFieldName) OrElse String.IsNullOrEmpty(metaGrp.StatusFieldName)) Then
                'The error or status field is not present for this address so remove it from the collection
                remove.Add(metaGrp)
            ElseIf metaGrp.IsName AndAlso String.IsNullOrEmpty(metaGrp.StatusFieldName) Then
                'The status field is not present for this name so remove it from the collection
                remove.Add(metaGrp)
            End If
        Next
        For Each metaGrp As MetaGroup In remove
            metaGroups.Remove(metaGrp)
        Next

        Return metaGroups

    End Function

    Friend Shared Sub GetMetaGroupCounts(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal metaGroups As MetaGroupCollection, ByVal loadDB As LoadDatabases)

        For Each metaGrp As MetaGroup In metaGroups
            With metaGrp
                Dim cmd As DbCommand
                If loadDB = LoadDatabases.QPLoad Then
                    cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectMetaGroupCounts, dataFileID, .StatusFieldName, .ErrorFieldName, .SQLTableName(studyID), .IsAddress)
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
                    cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.SelectMetaGroupCounts, dataFileID, .StatusFieldName, .ErrorFieldName, .SQLTableName(studyID), .IsAddress)
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

    Friend Shared Sub SaveMetaGroupCounts(ByVal dataFileID As Integer, ByVal metaGroups As MetaGroupCollection, ByVal loadDB As LoadDatabases)

        For Each metaGrp As MetaGroup In metaGroups
            With metaGrp
                Dim cmd As DbCommand
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
