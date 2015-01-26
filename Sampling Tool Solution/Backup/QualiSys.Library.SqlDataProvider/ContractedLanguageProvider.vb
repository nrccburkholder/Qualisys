Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class ContractedLanguageProvider
    Inherits Nrc.QualiSys.Library.DataProvider.ContractedLanguageProvider

#Region " ContractedLanguage Procs "

    Private Function PopulateContractedLanguage(ByVal rdr As SafeDataReader) As ContractedLanguage

        Dim newObject As ContractedLanguage = ContractedLanguage.NewContractedLanguage
        Dim privateInterface As IContractedLanguage = newObject

        newObject.BeginPopulate()
        privateInterface.LanguageCode = rdr.GetString("LanguageCode")
        newObject.LanguageName = rdr.GetString("LanguageName")
        newObject.LangID = rdr.GetInteger("LangID")
        newObject.DisplayOrder = rdr.GetShort("DisplayOrder")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectContractedLanguage(ByVal languageCode As String) As ContractedLanguage

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectContractedLanguage, languageCode)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateContractedLanguage(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllContractedLanguages() As ContractedLanguageCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllContractedLanguages)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ContractedLanguageCollection, ContractedLanguage)(rdr, AddressOf PopulateContractedLanguage)
        End Using

    End Function

#End Region

End Class
