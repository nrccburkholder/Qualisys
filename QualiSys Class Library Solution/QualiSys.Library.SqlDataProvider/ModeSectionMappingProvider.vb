Imports System.Collections.ObjectModel
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common


Public Class ModeSectionMappingProvider
    Inherits Nrc.QualiSys.Library.DataProvider.ModeSectionMappingProvider

#Region " ModeSectionMapping Procs "

    Private Function PopulateModeSectionMapping(ByVal rdr As SafeDataReader) As ModeSectionMapping
        Dim newObject As ModeSectionMapping = ModeSectionMapping.NewModeSectionMapping
        newObject.BeginPopulate()
        newObject.Id = rdr.GetInteger("Id")
        newObject.MailingStepMethodId = rdr.GetInteger("MailingStepMethod_ID")
        newObject.MailingStepMethodName = rdr.GetString("MailingStepMethod_nm")
        newObject.QuestionSectionId = rdr.GetInteger("SECTION_Id")
        newObject.QuestionSectionLabel = rdr.GetString("SectionLabel")
        newObject.SurveyId = rdr.GetInteger("SURVEY_ID")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectModeSectionMappingsBySurveyId(ByVal SurveyId As Integer) As List(Of ModeSectionMapping) 'Collection
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectModeSectionMappingsBySurveyId", SurveyId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            'Return PopulateCollection(Of ModeSectionMappingCollection, ModeSectionMapping)(rdr, AddressOf PopulateModeSectionMapping)
            Return PopulateCollection(Of List(Of ModeSectionMapping), ModeSectionMapping)(rdr, AddressOf PopulateModeSectionMapping)
        End Using
    End Function

    Public Overrides Function InsertModeSectionMapping(ByVal instance As ModeSectionMapping) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_InsertModeSectionMapping", instance.SurveyId, instance.MailingStepMethodId, instance.MailingStepMethodName, instance.QuestionSectionId, instance.QuestionSectionLabel)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub DeleteModeSectionMapping(ByVal instance As ModeSectionMapping)
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_DeleteModeSectionMapping", instance.Id)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UpdateModeSectionMapping(ByVal instance As ModeSectionMapping)
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_UpdateModeSectionMapping", instance.Id, instance.MailingStepMethodId, instance.MailingStepMethodName, instance.QuestionSectionId, instance.QuestionSectionLabel)
        ExecuteNonQuery(cmd)
    End Sub


    Friend Function PopulateCollection(Of C As {List(Of T), New}, T)(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C
        Dim list As New C

        While rdr.Read
            list.Add(populateMethod(rdr))
        End While

        Return list

    End Function

    ''' <summary>
    ''' Returns an instance of an existing unit.
    ''' </summary>
    ''' <param name="Id"></param>
    ''' <param name="Survey_Id"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function [Select](ByVal Id As Integer, ByVal Survey_Id As Integer) As ModeSectionMapping

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleUnit, Id)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateModeSectionMapping(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function
#End Region


End Class
