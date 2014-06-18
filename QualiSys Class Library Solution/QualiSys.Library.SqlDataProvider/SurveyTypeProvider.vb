Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class SurveyTypeProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SurveyTypeProvider

#Region " SurveyType Procs "

    Private Function PopulateSurveyType(ByVal rdr As SafeDataReader) As SurveyType

        Dim newObject As SurveyType = SurveyType.NewSurveyType
        Dim privateInterface As ISurveyType = newObject

        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("SurveyType_ID")
        newObject.Description = rdr.GetString("SurveyType_dsc")
        newObject.CAHPSTypeId = rdr.GetInteger("CAHPSType_id")
        newObject.SeedMailings = rdr.GetBoolean("SeedMailings")
        newObject.SeedSurveyPercent = rdr.GetInteger("SeedSurveyPercent")
        newObject.SeedUnitField = rdr.GetString("SeedUnitField")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectSurveyType(ByVal id As Integer) As SurveyType

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurveyType, id)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSurveyType(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllSurveyTypes() As SurveyTypeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllSurveyTypes)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SurveyTypeCollection, SurveyType)(rdr, AddressOf PopulateSurveyType)
        End Using

    End Function

    Public Overrides Function InsertSurveyType(ByVal instance As SurveyType) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSurveyType, instance.Description, instance.CAHPSTypeId, instance.SeedMailings, instance.SeedSurveyPercent, instance.SeedUnitField)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateSurveyType(ByVal instance As SurveyType)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSurveyType, instance.Id, instance.Description, instance.CAHPSTypeId, instance.SeedMailings, instance.SeedSurveyPercent, instance.SeedUnitField)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteSurveyType(ByVal instance As SurveyType)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteSurveyType, instance.Id)
            ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region


End Class
