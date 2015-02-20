Imports Nrc.Framework.Data

Public Class CoverLetterProvider
    Inherits Nrc.QualiSys.Library.DataProvider.CoverLetterProvider

    Private Function PopulateCoverLetter(ByVal rdr As SafeDataReader) As CoverLetter
        Dim newObj As CoverLetter = CreateCoverLetter(rdr.GetInteger("SelCover_id"), rdr.GetString("Description").Trim)
        Return newObj
    End Function

    Public Overrides Function SelectBySurveyId(ByVal surveyId As Integer) As System.Collections.ObjectModel.Collection(Of CoverLetter)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCoverLettersBySurveyId, surveyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of CoverLetter)(rdr, AddressOf PopulateCoverLetter)
        End Using
    End Function
End Class
