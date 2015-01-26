Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class SamplePeriodProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SamplePeriodProvider

    Private Function PopulateSamplePeriod(ByVal rdr As SafeDataReader) As SamplePeriod
        Dim newObj As SamplePeriod = SamplePeriod.NewSamplePeriod
        newObj.BeginPopulate()
        ReadOnlyAccessor.SamplePeriodId(newObj) = rdr.GetInteger("PeriodDef_id")
        ReadOnlyAccessor.SamplePeriodSurveyId(newObj) = rdr.GetInteger("Survey_id")
        ReadOnlyAccessor.SamplePeriodCreationDate(newObj) = rdr.GetDate("datAdded")
        newObj.ExpectedStartDate = rdr.GetNullableDate("datExpectedEncStart")
        newObj.ExpectedEndDate = rdr.GetNullableDate("datExpectedEncEnd")
        newObj.Name = rdr.GetString("strPeriodDef_nm")
        newObj.EmployeeId = rdr.GetInteger("Employee_Id")
        newObj.NumberOfDaysPriorToSampleDataFileExpectedToArrive = rdr.GetInteger("DaysToSample")
        newObj.SamplingScheduleCharacter = rdr.GetString("MonthWeek")
        Select Case rdr.GetInteger("SamplingMethod_id")
            Case 1
                newObj.SamplingMethod = SampleSet.SamplingMethod.SpecifyTargets
            Case 2
                newObj.SamplingMethod = SampleSet.SamplingMethod.SpecifyOutgo
            Case 3
                newObj.SamplingMethod = SampleSet.SamplingMethod.Census
            Case Else
                'Do nothing
        End Select
        ReadOnlyAccessor.PeriodTimeFrame(newObj) = rdr.GetInteger("TimeFrame")
        newObj.EndPopulate()
        Return newObj
    End Function

    Public Overrides Function SelectSamplePeriod(ByVal samplePeriodId As Integer) As SamplePeriod
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSamplePeriod, samplePeriodId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateSamplePeriod(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectBySurveyId(ByVal surveyId As Integer) As SamplePeriodCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSamplePeriodsBySurvey, surveyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SamplePeriodCollection, SamplePeriod)(rdr, AddressOf PopulateSamplePeriod)
        End Using
    End Function

    Public Overrides Function Insert(ByVal instance As SamplePeriod) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSamplePeriod, instance.EmployeeId, instance.Name, instance.SamplePeriodScheduledSamples.Count, instance.NumberOfDaysPriorToSampleDataFileExpectedToArrive, SafeDataReader.ToDBValue(instance.ExpectedStartDate), SafeDataReader.ToDBValue(instance.ExpectedEndDate), instance.SamplingMethod, instance.SamplingScheduleCharacter, instance.SurveyId)
        Dim newID As Integer

        Using con As DbConnection = Db.CreateConnection
            con.Open()
            Using tran As DbTransaction = con.BeginTransaction
                Try
                    newID = ExecuteInteger(cmd, tran)
                    For Each scheduledSample As SamplePeriodScheduledSample In instance.SamplePeriodScheduledSamples
                        scheduledSample.SamplePeriodId = newID
                        SamplePeriodScheduledSampleProvider.Instance.InsertSamplePeriodScheduledSample(scheduledSample, tran)
                        scheduledSample.FinishedInserting()
                    Next

                    tran.Commit()
                    instance.FinishedInserting()
                    Return newID
                Catch ex As Exception
                    tran.Rollback()
                    Throw
                End Try

            End Using
        End Using
    End Function

    Public Overrides Sub Update(ByVal instance As SamplePeriod)
        Using con As DbConnection = Db.CreateConnection
            con.Open()
            Using tran As DbTransaction = con.BeginTransaction
                Try
                    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSamplePeriod, instance.Id, instance.EmployeeId, instance.Name, instance.SamplePeriodScheduledSamples.Count, instance.NumberOfDaysPriorToSampleDataFileExpectedToArrive, SafeDataReader.ToDBValue(instance.ExpectedStartDate), SafeDataReader.ToDBValue(instance.ExpectedEndDate), instance.SamplingMethod, instance.SamplingScheduleCharacter)
                    ExecuteNonQuery(cmd, tran)

                    For Each scheduledSample As SamplePeriodScheduledSample In instance.SamplePeriodScheduledSamples.DeletedItems
                        If Not scheduledSample.IsNew Then SamplePeriodScheduledSampleProvider.Instance.DeleteSamplePeriodScheduledSample(scheduledSample.SamplePeriodId, scheduledSample.SampleNumber)
                    Next
                    instance.SamplePeriodScheduledSamples.ClearDeletedItems()

                    For Each scheduledSample As SamplePeriodScheduledSample In instance.SamplePeriodScheduledSamples
                        If scheduledSample.IsDirty Then
                            If scheduledSample.IsNew Then
                                SamplePeriodScheduledSampleProvider.Instance.InsertSamplePeriodScheduledSample(scheduledSample, tran)
                                scheduledSample.FinishedInserting()
                            Else
                                SamplePeriodScheduledSampleProvider.Instance.UpdateSamplePeriodScheduledSample(scheduledSample, tran)
                                scheduledSample.FinishedUpdating()
                            End If
                        End If
                    Next

                    tran.Commit()
                    instance.FinishedUpdating()
                Catch ex As Exception
                    tran.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Public Overrides Sub Delete(ByVal samplePeriodId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteSamplePeriod, samplePeriodId)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Function SelectActivePeriodId(ByVal surveyId As Integer) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectActivePeriodbySurveyId, surveyId)
        Return ExecuteInteger(cmd)
    End Function
End Class
