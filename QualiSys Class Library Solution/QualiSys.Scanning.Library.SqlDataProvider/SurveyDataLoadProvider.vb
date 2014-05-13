'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class SurveyDataLoadProvider
	Inherits QualiSys.Scanning.Library.SurveyDataLoadProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

	
#Region " SurveyDataLoad Procs "

    Private Function PopulateSurveyDataLoad(ByVal rdr As SafeDataReader) As SurveyDataLoad

        Dim newObject As SurveyDataLoad = SurveyDataLoad.NewSurveyDataLoad
        Dim privateInterface As ISurveyDataLoad = newObject

        newObject.BeginPopulate()
        privateInterface.SurveyDataLoadId = rdr.GetInteger("SurveyDataLoad_ID")
        newObject.DataLoadId = rdr.GetInteger("DataLoad_ID")
        newObject.SurveyId = rdr.GetInteger("Survey_ID")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.Notes = rdr.GetString("Notes")
        newObject.HasErrors = rdr.GetBoolean("bitHasErrors")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectSurveyDataLoad(ByVal surveyDataLoadId As Integer) As SurveyDataLoad

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurveyDataLoad, surveyDataLoadId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSurveyDataLoad(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectSurveyDataLoadsByDataLoadId(ByVal dataLoadId As Integer) As SurveyDataLoadCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurveyDataLoadsByDataLoadId, dataLoadId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of SurveyDataLoadCollection, SurveyDataLoad)(rdr, AddressOf PopulateSurveyDataLoad)
        End Using

    End Function

    Public Overrides Function InsertSurveyDataLoad(ByVal instance As SurveyDataLoad) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSurveyDataLoad, instance.DataLoadId, instance.SurveyId, SafeDataReader.ToDBValue(instance.DateCreated), instance.Notes, instance.HasErrors)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateSurveyDataLoad(ByVal instance As SurveyDataLoad)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSurveyDataLoad, instance.SurveyDataLoadId, instance.DataLoadId, instance.SurveyId, SafeDataReader.ToDBValue(instance.DateCreated), instance.Notes, instance.HasErrors)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteSurveyDataLoad(ByVal instance As SurveyDataLoad)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteSurveyDataLoad, instance.SurveyDataLoadId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Function SelectValidationDataBySampleSet(ByVal sampleSetId As Integer) As System.Data.DataSet

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectValidationDataBySampleSet, sampleSetId)
        Return QualiSysDatabaseHelper.ExecuteDataSet(cmd)

    End Function

#End Region

End Class
