Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data


Public Class DRGUpdateProvider
    Inherits Nrc.QualiSys.Library.DataProvider.DRGUpdateProvider


    Public Overrides Function [Select](ByVal studyid As Integer) As Collection(Of DRGUpdate)
        Dim cmd As DbCommand


        cmd = Db.GetStoredProcCommand(SP.SelectDRGUpdates, studyid)


        Dim drgUpdates As Collection(Of DRGUpdate)
        Using ds As DataSet = ExecuteDataSet(cmd)
            Using rdr As New SafeDataReader(New DataTableReader(ds.Tables(0)))
                drgUpdates = PopulateCollection(Of DRGUpdate)(rdr, AddressOf PopulateDRGUpdate)
            End Using

        End Using

        Return drgUpdates
    End Function


    Public Overrides Function Rollback(ByVal datafile As DRGUpdate) As DataTable

        Dim cmd As DbCommand

        cmd = Db.GetStoredProcCommand(SP.RollbackDRGUpdates, datafile.StudyID, datafile.DataFileID)

        Using ds As DataSet = ExecuteDataSet(cmd)

            Return ds.Tables(0)

        End Using

        Return Nothing

    End Function


    Public Overrides Sub UpdateFileStateDRG(ByVal datafile_id As Integer, ByVal State_id As Integer, ByVal StateParameter As String, ByVal StateDescription As String, ByVal Member_id As Integer)

        Dim cmd As DbCommand

        cmd = Db.GetStoredProcCommand(SP.UpdateFileStateDRG, datafile_id, State_id, StateParameter, StateDescription, Member_id)

        ExecuteNonQuery(cmd)

    End Sub

    Private Function PopulateDRGUpdate(ByVal rdr As SafeDataReader) As DRGUpdate
        Dim newObj As New DRGUpdate

        newObj.DataFileID = rdr.GetInteger("DataFile_id")
        newObj.StudyID = rdr.GetInteger("study_id")
        newObj.DatMinEncounter = rdr.GetDate("MinEncounterDate")
        newObj.DatMaxEncounter = rdr.GetDate("MaxEncounterDate")
        newObj.OrigFileName = rdr.GetString("origFileName")
        newObj.LoadedBy = rdr.GetString("LoadedBy")
        newObj.IsRollback = rdr.GetBoolean("bitRollback")
        newObj.Status = rdr.GetString("status")
        newObj.MemberID = rdr.GetInteger("Member_id")

        Return newObj
    End Function


End Class
