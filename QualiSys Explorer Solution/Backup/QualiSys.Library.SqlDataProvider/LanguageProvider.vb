Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class LanguageProvider
    Inherits Nrc.QualiSys.Library.DataProvider.LanguageProvider

    Private Function PopulateLanguage(ByVal rdr As SafeDataReader) As Language
        Dim newObj As New Language
        ReadOnlyAccessor.LanguageId(newObj) = rdr.GetInteger("LangId")
        newObj.Name = rdr.GetString("NRCLanguageLabel")
        newObj.DisplayLabel = rdr.GetString("Language")
        newObj.ResetDirtyFlag()
        Return newObj
    End Function

    Public Overrides Function [Select](ByVal languageId As Integer) As Language
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectLanguage, languageId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateLanguage(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectLanguagesAvailableForSurvey(ByVal surveyId As Integer) As Collection(Of Language)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectLanguagesAvailableForSurvey, surveyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of Language)(rdr, AddressOf PopulateLanguage)
        End Using
    End Function

End Class
