Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class FormGenJobProvider
    Inherits Nrc.QualiSys.Library.DataProvider.FormGenJobProvider


    Private Function PopulateFormGenJob(ByVal rdr As SafeDataReader) As FormGenJob
        Dim obj As FormGenJob
        obj = CreateFormGenJob(rdr.GetInteger("Client_id"), _
                                rdr.GetString("strClient_nm").Trim, _
                                rdr.GetInteger("Study_id"), _
                                rdr.GetString("strStudy_nm").Trim, _
                                rdr.GetInteger("Survey_id"), _
                                rdr.GetString("strSurvey_nm").Trim, _
                                rdr.GetInteger("MailingStep_id"), _
                                rdr.GetString("strMailingStep_nm").Trim, _
                                rdr.GetString("SurveyType"), _
                                rdr.GetDate("datGenerate"), _
                                rdr.GetInteger("Priority_flg"), _
                                rdr.GetInteger("Total"), _
                                rdr.GetBoolean("bitFormGenRelease"))
        obj.ResetDirtyFlag()
        Return obj
    End Function

    Public Overrides Function SelectByGenerationDate(ByVal startDate As Date, ByVal endDate As Date) As Collection(Of FormGenJob)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectFormGenJobsByGenerationDate, startDate, endDate)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of FormGenJob)(rdr, AddressOf PopulateFormGenJob)
        End Using
    End Function

    Public Overrides Sub UpdateGenerationDate(ByVal surveyId As Integer, ByVal mailStepId As Integer, ByVal originalGenerationDate As Date, ByVal newGenerationDate As Date)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateFormGenJobGenerationDate, surveyId, mailStepId, originalGenerationDate, newGenerationDate)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UpdatePriority(ByVal surveyId As Integer, ByVal priority As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateFormGenJobPriority, surveyId, priority)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub ScheduleNextMailSteps()
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.ScheduleNextMailSteps, DBNull.Value)
        ExecuteNonQuery(cmd)
    End Sub

End Class
