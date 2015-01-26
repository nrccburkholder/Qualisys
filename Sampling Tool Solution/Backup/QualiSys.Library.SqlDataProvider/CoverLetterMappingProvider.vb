Imports System.Collections.ObjectModel
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Public Class CoverLetterMappingProvider
    Inherits Nrc.QualiSys.Library.DataProvider.CoverLetterMappingProvider

    Private Function PopulateCoverLetterMapping(ByVal rdr As SafeDataReader) As CoverLetterMapping

        Dim newObject As CoverLetterMapping = CoverLetterMapping.NewCoverLetterMapping()
        newObject.BeginPopulate()
        newObject.Id = rdr.GetInteger("CoverLetterItemArtifactUnitMapping_id")
        newObject.Survey_Id = rdr.GetInteger("SURVEY_ID")
        newObject.SampleUnit_Id = rdr.GetInteger("SampleUnit_id")
        newObject.SampleUnit_name = rdr.GetString("strSampleUnit_nm").Trim()
        newObject.CoverLetterItemType_Id = rdr.GetByte("CoverLetterItemType_id")
        newObject.CoverLetter_name = rdr.GetString("CoverLetter_dsc").Trim()
        newObject.CoverLetterItem_label = rdr.GetString("CoverLetterItem_label").Trim()
        newObject.Artifact_name = rdr.GetString("Artifact_dsc").Trim()
        newObject.ArtifactItem_label = rdr.GetString("ArtifactItem_label").Trim()
        newObject.UniqueID = Guid.NewGuid
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectCoverLetterMappingsBySurveyId(ByVal SurveyId As Integer) As List(Of CoverLetterMapping)
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectCoverLetterItemArtifactUnitMapping", SurveyId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))

            Return PopulateCollection(Of List(Of CoverLetterMapping), CoverLetterMapping)(rdr, AddressOf PopulateCoverLetterMapping)
        End Using
    End Function

    Friend Function PopulateCollection(Of C As {List(Of T), New}, T)(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C
        Dim list As New C

        While rdr.Read
            list.Add(populateMethod(rdr))
        End While

        Return list

    End Function

    Public Overrides Function InsertCoverLetterMapping(ByVal instance As CoverLetterMapping) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_InsertCoverLetterItemArtifactUnitMapping", instance.Survey_Id, instance.SampleUnit_Id, instance.CoverLetterItemType_Id, instance.CoverLetter_name, instance.CoverLetterItem_label, instance.Artifact_name, instance.ArtifactItem_label)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub DeleteCoverLetterMapping(ByVal instance As CoverLetterMapping)
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_DeleteCoverLetterItemArtifactUnitMapping", instance.Id)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UpdateCoverLetterMapping(ByVal instance As CoverLetterMapping)
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_UpdateCoverLetterItemArtifactUnitMapping", instance.Id, instance.SampleUnit_Id, instance.CoverLetterItemType_Id, instance.CoverLetter_name, instance.CoverLetterItem_label, instance.Artifact_name, instance.ArtifactItem_label)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Function [Select](ByVal Id As Integer) As CoverLetterMapping
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectCoverLetterMappingById", Id)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateCoverLetterMapping(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

End Class
