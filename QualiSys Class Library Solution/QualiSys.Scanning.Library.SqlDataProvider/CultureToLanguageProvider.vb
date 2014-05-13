'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class CultureToLanguageProvider
    Inherits QualiSys.Scanning.Library.CultureToLanguageProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property


#Region " CultureToLanguage Procs "

    Private Function PopulateCultureToLanguage(ByVal rdr As SafeDataReader) As CultureToLanguage

        Dim newObject As CultureToLanguage = CultureToLanguage.NewCultureToLanguage
        Dim privateInterface As ICultureToLanguage = newObject

        newObject.BeginPopulate()
        privateInterface.CultureLangID = rdr.GetInteger("CultureLangID")
        newObject.CultureID = rdr.GetInteger("CultureID")
        newObject.CultureCode = rdr.GetString("CultureCode")
        newObject.CultureDesc = rdr.GetString("CultureDesc")
        newObject.LangID = rdr.GetInteger("LangID")
        newObject.Language = rdr.GetString("Language")
        newObject.IsQualisysLanguage = CType(rdr.GetByte("QualiSysLanguage"), Boolean)
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectCultureToLanguage(ByVal cultureLangID As Integer) As CultureToLanguage

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCultureToLanguage, cultureLangID)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateCultureToLanguage(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllCultureToLanguages() As CultureToLanguageCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllCultureToLanguages)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of CultureToLanguageCollection, CultureToLanguage)(rdr, AddressOf PopulateCultureToLanguage)
        End Using

    End Function

    Public Overrides Function SelectByCultureCode(ByVal cultureCode As String) As CultureToLanguage

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCultureToLanguageByCultureCode, cultureCode)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateCultureToLanguage(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectByLanguageID(ByVal langID As Integer) As CultureToLanguage

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCultureToLanguageByLanguageID, langID)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateCultureToLanguage(rdr)
            End If
        End Using

    End Function

#End Region

End Class
