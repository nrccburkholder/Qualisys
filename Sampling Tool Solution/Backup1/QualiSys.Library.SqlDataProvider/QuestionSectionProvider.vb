Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data
Public Class QuestionSectionProvider
    Inherits Nrc.QualiSys.Library.DataProvider.QuestionSectionProvider

    Private Shared Function PopulateQuestionSection(ByVal rdr As SafeDataReader) As QuestionSection
        Dim newObject As New QuestionSection
        Dim privateInterface As ISection = newObject
        privateInterface.SelQstnsId = rdr.GetInteger("SELQSTNS_ID")
        privateInterface.SurveyId = rdr.GetInteger("SURVEY_ID")
        privateInterface.Id = rdr.GetInteger("SECTION_ID")
        privateInterface.Label = rdr.GetString("LABEL")

        Return newObject
    End Function

    Public Overrides Function SelectSectionsBySurveyId(ByVal surveyId As Integer) As Collection(Of QuestionSection)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQuestionSectionsBySurveyId, surveyId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of QuestionSection)(rdr, AddressOf PopulateQuestionSection)
        End Using
    End Function

End Class
