Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class SampleUnitLinkingProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SampleUnitLinkingProvider


    Private Function PopulateSampleUnitLinking(ByVal rdr As SafeDataReader) As SampleUnitLinking
        Dim newObj As New SampleUnitLinking
        newObj.FromStudyId = rdr.GetInteger("FromStudyId")
        newObj.FromStudyName = rdr.GetString("FromStudyName").Trim
        newObj.FromSurveyId = rdr.GetInteger("FromSurveyId")
        newObj.FromSurveyName = rdr.GetString("FromSurveyName").Trim
        newObj.FromSampleUnitId = rdr.GetInteger("FromSampleUnitId")
        newObj.FromSampleUnitName = rdr.GetString("FromSampleUnitName").Trim

        newObj.ToStudyId = rdr.GetInteger("ToStudyId")
        newObj.ToStudyName = rdr.GetString("ToStudyName").Trim
        newObj.ToSurveyId = rdr.GetInteger("ToSurveyId")
        newObj.ToSurveyName = rdr.GetString("ToSurveyName").Trim
        newObj.ToSampleUnitId = rdr.GetInteger("ToSampleUnitId")
        newObj.ToSampleUnitName = rdr.GetString("ToSampleUnitName").Trim
        Return newObj
    End Function
    Public Overrides Function SelectByClientId(ByVal clientId As Integer) As SampleUnitLinkingCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSampleUnitLinkingsByClientId, clientId)

        Dim linkings As New SampleUnitLinkingCollection
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                PopulateSampleUnitLinking(rdr)
            End While
        End Using
        Return linkings
    End Function

    Public Overrides Sub DeleteByClientId(ByVal clientId As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSampleUnitLinkingsByClientId, clientId)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub Insert(ByVal fromSampleUnitId As Integer, ByVal toSampleUnitId As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertSampleUnitLinking, fromSampleUnitId, toSampleUnitId)
        ExecuteNonQuery(cmd)
    End Sub

End Class
