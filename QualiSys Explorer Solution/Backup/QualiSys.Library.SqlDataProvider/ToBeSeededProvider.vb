Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class ToBeSeededProvider
    Inherits Nrc.QualiSys.Library.DataProvider.ToBeSeededProvider

#Region " ToBeSeeded Procs "

    Private Function PopulateToBeSeeded(ByVal rdr As SafeDataReader) As ToBeSeeded

        Dim newObject As ToBeSeeded = ToBeSeeded.NewToBeSeeded
        Dim privateInterface As IToBeSeeded = newObject

        newObject.BeginPopulate()
        privateInterface.SeedId = rdr.GetInteger("Seed_id")
        newObject.SurveyId = rdr.GetInteger("Survey_id")
        newObject.IsSeeded = rdr.GetBoolean("IsSeeded")
        newObject.datSeeded = rdr.GetDate("datSeeded")
        newObject.SurveyTypeId = rdr.GetInteger("SurveyType_id")
        newObject.YearQtr = rdr.GetString("YearQtr")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectToBeSeeded(ByVal seedId As Integer) As ToBeSeeded

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectToBeSeeded, seedId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateToBeSeeded(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllToBeSeededs() As ToBeSeededCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllToBeSeededs)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ToBeSeededCollection, ToBeSeeded)(rdr, AddressOf PopulateToBeSeeded)
        End Using

    End Function

    Public Overrides Function InsertToBeSeeded(ByVal instance As ToBeSeeded) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertToBeSeeded, instance.SurveyId, instance.IsSeeded, SafeDataReader.ToDBValue(instance.datSeeded), instance.SurveyTypeId, instance.YearQtr)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateToBeSeeded(ByVal instance As ToBeSeeded)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateToBeSeeded, instance.SeedId, instance.SurveyId, instance.IsSeeded, SafeDataReader.ToDBValue(instance.datSeeded), instance.SurveyTypeId, instance.YearQtr)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteToBeSeeded(ByVal instance As ToBeSeeded)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteToBeSeeded, instance.SeedId)
            ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Function SelectToBeSeededBySurveyIDYearQtr(ByVal surveyId As Integer, ByVal yrQtr As String) As ToBeSeeded

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectToBeSeededBySurveyIDYearQtr, surveyId, yrQtr)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateToBeSeeded(rdr)
            End If
        End Using

    End Function

    Public Overrides Function IsTimeToPopulateForQuarter(ByVal yrQtr As String) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.IsTimeToPopulateToBeSeededForQuarter, yrQtr)
        Return (ExecuteInteger(cmd) = 0)

    End Function

    Public Overrides Function SelectToBeSeededsIncompleteByYearQtr(ByVal yrQtr As String) As ToBeSeededCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectToBeSeededsIncompleteByYearQtr, yrQtr)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ToBeSeededCollection, ToBeSeeded)(rdr, AddressOf PopulateToBeSeeded)
        End Using

    End Function

#End Region

End Class
