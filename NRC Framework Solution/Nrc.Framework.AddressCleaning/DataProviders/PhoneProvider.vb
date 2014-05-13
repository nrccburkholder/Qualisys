Imports System.Data.Common

Friend Class PhoneProvider

#Region " Public Shared Methods "

    Public Shared Function SelectCleanPhoneBit(ByVal studyID As Integer) As Boolean

        Dim cmd As DbCommand = QualiSysDatabaseHelper.Db.GetStoredProcCommand(SP.SelectCleanPhoneBit, studyID)
        Return QualiSysDatabaseHelper.ExecuteBoolean(cmd)

    End Function

    Public Shared Sub CheckPhoneNumbers(ByVal dataFileID As Integer, ByVal loadDB As LoadDatabases)

        Dim cmd As DbCommand
        If loadDB = LoadDatabases.QPLoad Then
            cmd = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.CheckPhoneNumbers, dataFileID)
            QLoaderDatabaseHelper.ExecuteNonQuery(cmd)
        Else
            cmd = DataLoadDatabaseHelper.Db.GetStoredProcCommand(SP.CheckPhoneNumbers, dataFileID)
            DataLoadDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
