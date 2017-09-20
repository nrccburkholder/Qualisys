Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class StudyDatasetProvider
    Inherits Nrc.QualiSys.Library.DataProvider.StudyDatasetProvider


    Private Function PopulateStudyDataset(ByVal rdr As SafeDataReader) As StudyDataset
        Dim newObj As New StudyDataset
        ReadOnlyAccessor.StudyDatasetId(newObj) = rdr.GetInteger("DataSet_id")
        ReadOnlyAccessor.StudyDatasetDateLoaded(newObj) = rdr.GetDate("Date_Imported")
        ReadOnlyAccessor.StudyDatasetHasBeenSampled(newObj) = rdr.GetBoolean("Sampled")
        ReadOnlyAccessor.StudyDatasetRecordCount(newObj) = rdr.GetInteger("Records")
        ReadOnlyAccessor.StudyDatasetStudyId(newObj) = rdr.GetInteger("study_id")
        Return newObj
    End Function

    Public Overrides Function SelectByStudyId(ByVal studyId As Integer, ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date)) As Collection(Of StudyDataset)
        Dim cmd As DbCommand

        If (Not creationFilterStartDate.HasValue And creationFilterEndDate.HasValue) Or (creationFilterStartDate.HasValue And Not creationFilterEndDate.HasValue) Then
            Throw New Exception("Incomplete set of dates specified")
        ElseIf Not creationFilterStartDate.HasValue And Not creationFilterEndDate.HasValue Then
            cmd = Db.GetStoredProcCommand(SP.SelectStudyDatasetsByStudy, studyId, DBNull.Value, DBNull.Value)
        Else
            cmd = Db.GetStoredProcCommand(SP.SelectStudyDatasetsByStudy, studyId, creationFilterStartDate, creationFilterEndDate)
        End If

        Dim studyDatasets As Collection(Of StudyDataset)
        Using ds As DataSet = ExecuteDataSet(cmd)
            Using rdr As New SafeDataReader(New DataTableReader(ds.Tables(0)))
                studyDatasets = PopulateCollection(Of StudyDataset)(rdr, AddressOf PopulateStudyDataset)
            End Using

            Dim datasetIds As New Dictionary(Of Integer, StudyDataset)
            For Each studyDS As StudyDataset In studyDatasets
                datasetIds.Add(studyDS.Id, studyDS)
            Next

            Using rdr As New SafeDataReader(New DataTableReader(ds.Tables(1)))
                While rdr.Read
                    Dim studyDS As StudyDataset = datasetIds(rdr.GetInteger("Dataset_id"))
                    Dim range As New StudyDatasetDateRange
                    range.TableId = rdr.GetInteger("Table_id")
                    range.FieldId = rdr.GetInteger("Field_id")
                    range.MinimumDate = rdr.GetDate("MinDate")
                    range.MaximumDate = rdr.GetDate("MaxDate")
                    studyDS.DateRanges.Add(range)
                End While
            End Using
        End Using

        Return studyDatasets
    End Function

    Public Overrides Function SelectQuestionPodsByStudyId(ByVal studyId As Integer) As List(Of Integer)
        Dim questionPodIds As List(Of Integer) = New List(Of Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQuestionPodsByStudy, studyId)
        Using ds As DataSet = ExecuteDataSet(cmd)
            Using rdr As New SafeDataReader(New DataTableReader(ds.Tables(0)))
                questionPodIds.Add(rdr.GetInteger("QuestionPodid"))
            End Using
        End Using
        Return questionPodIds
    End Function

    Public Overrides Sub Delete(ByVal datasetId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteDataset, datasetId)
        ExecuteNonQuery(cmd)
    End Sub
End Class
