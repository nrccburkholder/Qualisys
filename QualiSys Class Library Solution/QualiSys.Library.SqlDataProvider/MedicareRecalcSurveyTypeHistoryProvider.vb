'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class MedicareRecalcSurveyTypeHistoryProvider
    Inherits Nrc.QualiSys.Library.DataProvider.MedicareRecalcSurveyTypeHistoryProvider

    ''' <summary>Poulates the MedicareRecalcSurveyTypeHistory object from the data store.</summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function PopulateMedicareRecalcSurveyTypeHistory(ByVal rdr As SafeDataReader) As MedicareRecalcSurveyTypeHistory

        Dim newObject As MedicareRecalcSurveyTypeHistory = MedicareRecalcSurveyTypeHistory.NewMedicareRecalcSurveyTypeHistory
        Dim privateInterface As IMedicareRecalcSurveyTypeHistory = newObject
        newObject.BeginPopulate()
        privateInterface.MedicareReCalcLogId = rdr.GetInteger("MedicareReCalcLog_ID")
        newObject.MedicareNumber = rdr.GetString("MedicareNumber")
        newObject.MedicareName = rdr.GetString("MedicareName")
        newObject.SurveyTypeID = rdr.GetInteger("SurveyTypeID")
        newObject.MedicarePropCalcTypeID = rdr.GetInteger("MedicarePropCalcType_ID")
        newObject.MedicarePropDataTypeID = rdr.GetInteger("MedicarePropDataType_ID")
        newObject.EstRespRate = rdr.GetDecimal("EstRespRate")
        newObject.EstAnnualVolume = rdr.GetInteger("EstAnnualVolume")
        newObject.SwitchToCalcDate = rdr.GetDate("SwitchToCalcDate")
        newObject.AnnualReturnTarget = rdr.GetInteger("AnnualReturnTarget")
        newObject.ProportionCalcPct = rdr.GetDecimal("ProportionCalcPct")
        If rdr.GetByte("SamplingLocked") = 0 Then
            newObject.SamplingLocked = False
        Else
            newObject.SamplingLocked = True
        End If
        newObject.ProportionChangeThreshold = rdr.GetDecimal("ProportionChangeThreshold")
        newObject.MemberId = rdr.GetInteger("Member_ID")
        newObject.DateCalculated = rdr.GetDate("DateCalculated")
        newObject.HistoricRespRate = rdr.GetDecimal("HistoricRespRate")
        newObject.HistoricAnnualVolume = rdr.GetInteger("HistoricAnnualVolume")
        If rdr.GetByte("ForcedCalculation") = 0 Then
            newObject.SamplingLocked = False
        Else
            newObject.SamplingLocked = True
        End If
        newObject.PropSampleCalcDate = rdr.GetDate("PropSampleCalcDate")

        newObject.SwitchFromRateOverrideDate = rdr.GetDate("SwitchFromRateOverrideDate")
        If DateTime.Compare(newObject.SwitchFromRateOverrideDate, #1/1/1900#) < 0 Then
            newObject.SwitchFromRateOverrideDate = New Date(1900, 1, 1)
        End If

        newObject.SamplingRateOverride = rdr.GetDecimal("SamplingRateOverride")

        newObject.EndPopulate()

        Return newObject

    End Function

    ''' <summary>Proc call to get record by PK</summary>
    ''' <param name="MedicareRecalcSurveyTypeHistoryID"></param>
    ''' <returns></returns>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function [Get](ByVal MedicareRecalcSurveyTypeHistoryID As Integer) As MedicareRecalcSurveyTypeHistory

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareRecalcSurveyTypeHistory, MedicareRecalcSurveyTypeHistoryID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicareRecalcSurveyTypeHistory(rdr)
            End If
        End Using

    End Function

    ''' <summary>Proc call to get all records.</summary>
    ''' <returns></returns>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetAll() As MedicareRecalcSurveyTypeHistoryCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllMedicareRecalcSurveyTypeHistory)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MedicareRecalcSurveyTypeHistoryCollection, MedicareRecalcSurveyTypeHistory)(rdr, AddressOf PopulateMedicareRecalcSurveyTypeHistory)
        End Using

    End Function

    ''' <summary>Proc call to get lastest record by medicare number.</summary>
    ''' <param name="medicareNumber"></param>
    ''' <returns></returns>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetLatestByMedicareNumber(ByVal medicareNumber As String, ByVal latestDate As Date, ByVal surveyTypeID As Integer) As MedicareRecalcSurveyTypeHistory

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareRecalcSurveyTypeHistoryByMedicareNumber, medicareNumber, latestDate, surveyTypeID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicareRecalcSurveyTypeHistory(rdr)
            End If
        End Using

    End Function

    ''' <summary>Proc call to get lastest record by medicare number and sample date.</summary>
    ''' <param name="medicareNumber"></param>
    ''' <returns></returns>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetLatestBySampleDate(ByVal medicareNumber As String, ByVal sampleDate As Date, ByVal surveyTypeId As Integer) As MedicareRecalcSurveyTypeHistory

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareRecalcSurveyTypeHistoryBySampleDate, medicareNumber, sampleDate, surveyTypeId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicareRecalcSurveyTypeHistory(rdr)
            End If
        End Using

    End Function

    ''' <summary>Proc call for insert.</summary>
    ''' <param name="instance"></param>
    ''' <returns></returns>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function Insert(ByVal instance As MedicareRecalcSurveyTypeHistory) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMedicareRecalcSurveyTypeHistory, instance.SurveyTypeID, instance.MedicareNumber,
                                instance.MedicarePropCalcTypeID, instance.MedicarePropDataTypeID, instance.EstRespRate,
                                instance.EstAnnualVolume, instance.SwitchToCalcDate, instance.AnnualReturnTarget, instance.ProportionCalcPct,
                                CByte(IIf(instance.SamplingLocked, 1, 0)), instance.ProportionChangeThreshold,
                                instance.MemberId, instance.DateCalculated, instance.HistoricRespRate, instance.HistoricAnnualVolume,
                                CByte(IIf(instance.ForcedCalculation, 1, 0)), instance.PropSampleCalcDate,
                                instance.SwitchFromRateOverrideDate, instance.SamplingRateOverride)
        Return ExecuteInteger(cmd)

    End Function

End Class

