Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class TranslationModuleProvider
	Inherits QualiSys.Scanning.Library.TranslationModuleProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " TranslationModule Procs "

    Private Function PopulateTranslationModule(ByVal rdr As SafeDataReader) As TranslationModule

        Dim newObject As TranslationModule = TranslationModule.NewTranslationModule
        Dim privateInterface As ITranslationModule = newObject

        newObject.BeginPopulate()
        privateInterface.TranslationModuleId = rdr.GetInteger("TranslationModule_ID")
        newObject.VendorId = rdr.GetInteger("Vendor_ID")
        newObject.ModuleName = rdr.GetString("ModuleName")
        newObject.WatchedFolderPath = rdr.GetString("WatchedFolderPath")
        newObject.FileType = rdr.GetString("FileType")
        newObject.StudyId = rdr.GetInteger("Study_ID")
        newObject.SurveyId = rdr.GetInteger("Survey_ID")
        newObject.LithoLookupType = rdr.GetEnum(Of LithoLookupTypes)("LithoLookupType_ID")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectTranslationModule(ByVal translationModuleId As Integer) As TranslationModule

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTranslationModule, translationModuleId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateTranslationModule(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectTranslationModulesByVendorId(ByVal vendorId As Integer) As TranslationModuleCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTranslationModulesByVendorId, vendorId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of TranslationModuleCollection, TranslationModule)(rdr, AddressOf PopulateTranslationModule)
        End Using

    End Function

    Public Overrides Function InsertTranslationModule(ByVal instance As TranslationModule) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertTranslationModule, instance.VendorId, instance.ModuleName, instance.WatchedFolderPath, instance.FileType, instance.StudyId, instance.SurveyId, instance.LithoLookupType)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateTranslationModule(ByVal instance As TranslationModule)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateTranslationModule, instance.TranslationModuleId, instance.VendorId, instance.ModuleName, instance.WatchedFolderPath, instance.FileType, instance.StudyId, instance.SurveyId, instance.LithoLookupType)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteTranslationModule(ByVal instance As TranslationModule)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteTranslationModule, instance.TranslationModuleId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
