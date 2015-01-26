Imports System.Collections.ObjectModel
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Public Class SampleUnitSectionMappingProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SampleUnitSectionMappingProvider

#Region " SampleUnitSectionMapping Procs "

    Private Function PopulateSampleUnitSectionMapping(ByVal rdr As SafeDataReader) As SampleUnitSectionMapping
        Dim newObject As SampleUnitSectionMapping = SampleUnitSectionMapping.NewSampleUnitSectionMapping
        Dim privateInterface As ISampleUnitSectionMapping = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("SampleUnitSection_ID")
        newObject.SampleUnitId = rdr.GetInteger("SAMPLEUNIT_ID")
        newObject.QuestionSectionId = rdr.GetInteger("SELQSTNSSECTION")
        newObject.SurveyId = rdr.GetInteger("SELQSTNSSURVEY_ID")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSampleUnitSectionMappingsBySampleUnitId(ByVal sampleUnitId As Integer) As SampleUnitSectionMappingCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleUnitSectionMappingsBySampleUnitId, sampleUnitId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SampleUnitSectionMappingCollection, SampleUnitSectionMapping)(rdr, AddressOf PopulateSampleUnitSectionMapping)
        End Using
    End Function

    Public Overrides Function InsertSampleUnitSectionMapping(ByVal instance As SampleUnitSectionMapping) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSampleUnitSectionMapping, instance.SampleUnitId, instance.QuestionSectionId, instance.SurveyId)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub DeleteSampleUnitSectionMapping(ByVal id As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteSampleUnitSectionMapping, id)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
