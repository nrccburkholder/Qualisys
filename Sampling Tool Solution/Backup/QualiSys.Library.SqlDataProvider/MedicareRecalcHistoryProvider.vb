'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class MedicareRecalcHistoryProvider
    Inherits Nrc.QualiSys.Library.DataProvider.MedicareRecalcHistoryProvider

    ''' <summary>Poulates the MedicareRecalcHistory object from the data store.</summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function PopulateMedicareRecalcHistory(ByVal rdr As SafeDataReader) As MedicareRecalcHistory

        Dim newObject As MedicareRecalcHistory = MedicareRecalcHistory.NewMedicareRecalcHistory
        Dim privateInterface As IMedicareRecalcHistory = newObject
        newObject.BeginPopulate()
        privateInterface.MedicareReCalcLogId = rdr.GetInteger("MedicareReCalcLog_ID")
        newObject.MedicareNumber = rdr.GetString("MedicareNumber")
        newObject.MedicareName = rdr.GetString("MedicareName")
        newObject.MedicarePropCalcTypeID = rdr.GetInteger("MedicarePropCalcType_ID")
        newObject.MedicarePropDataTypeID = rdr.GetInteger("MedicarePropDataType_ID")
        newObject.EstRespRate = rdr.GetDecimal("EstRespRate")
        newObject.EstIneligibleRate = rdr.GetDecimal("EstIneligibleRate")
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
        If rdr.GetByte("CensusForced") = 0 Then
            newObject.CensusForced = False
        Else
            newObject.CensusForced = True
        End If
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
        newObject.EndPopulate()

        Return newObject

    End Function

    ''' <summary>Proc call to get record by PK</summary>
    ''' <param name="medicareRecalcHistoryID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function [Get](ByVal medicareRecalcHistoryID As Integer) As MedicareRecalcHistory

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareCalcHistory, medicareRecalcHistoryID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicareRecalcHistory(rdr)
            End If
        End Using

    End Function

    ''' <summary>Proc call to get all records.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetAll() As MedicareRecalcHistoryCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllMedicareCalcHistory)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MedicareRecalcHistoryCollection, MedicareRecalcHistory)(rdr, AddressOf PopulateMedicareRecalcHistory)
        End Using

    End Function

    ''' <summary>Proc call to get lastest record by medicare number.</summary>
    ''' <param name="medicareNumber"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetLatestByMedicareNumber(ByVal medicareNumber As String, ByVal latestDate As Date) As MedicareRecalcHistory

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareCalcHistoryByMedicareNumber, medicareNumber, latestDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicareRecalcHistory(rdr)
            End If
        End Using

    End Function

    ''' <summary>Proc call to get lastest record by medicare number and sample date.</summary>
    ''' <param name="medicareNumber"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetLatestBySampleDate(ByVal medicareNumber As String, ByVal sampleDate As Date) As MedicareRecalcHistory

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareCalcHistoryBySampleDate, medicareNumber, sampleDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicareRecalcHistory(rdr)
            End If
        End Using

    End Function

    ''' <summary>Proc call for insert.</summary>
    ''' <param name="instance"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function Insert(ByVal instance As MedicareRecalcHistory) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMedicareCalcHistory, instance.MedicareNumber, instance.MedicareName, _
                                instance.MedicarePropCalcTypeID, instance.EstRespRate, instance.EstIneligibleRate, instance.EstAnnualVolume, _
                                instance.SwitchToCalcDate, instance.AnnualReturnTarget, instance.ProportionCalcPct, _
                                CByte(IIf(instance.SamplingLocked, 1, 0)), instance.ProportionChangeThreshold, _
                                CByte(IIf(instance.CensusForced, 1, 0)), instance.MemberId, instance.DateCalculated, instance.HistoricRespRate, _
                                CByte(IIf(instance.ForcedCalculation, 1, 0)), instance.PropSampleCalcDate, instance.MedicarePropDataTypeID, instance.HistoricAnnualVolume)
        Return ExecuteInteger(cmd)

    End Function

    ''' <summary>Proc call for update.</summary>
    ''' <param name="instance"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Update(ByVal instance As MedicareRecalcHistory)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMedicareCalcHistory, instance.MedicareReCalcLogId, instance.MedicareNumber, _
                                instance.MedicareName, instance.MedicarePropCalcTypeID, instance.EstRespRate, instance.EstIneligibleRate, _
                                instance.EstAnnualVolume, instance.SwitchToCalcDate, instance.AnnualReturnTarget, instance.ProportionCalcPct, _
                                CByte(IIf(instance.SamplingLocked, 1, 0)), instance.ProportionChangeThreshold, _
                                CByte(IIf(instance.CensusForced, 1, 0)), instance.MemberId, instance.DateCalculated, instance.HistoricRespRate, _
                                CByte(IIf(instance.ForcedCalculation, 1, 0)), instance.PropSampleCalcDate, instance.MedicarePropDataTypeID, instance.HistoricAnnualVolume)
        ExecuteNonQuery(cmd)

    End Sub

    ''' <summary>Proc call for delete.</summary>
    ''' <param name="medicareRecalcHistoryID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Delete(ByVal medicareRecalcHistoryID As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMedicareCalcHistory, medicareRecalcHistoryID)
        ExecuteNonQuery(cmd)

    End Sub

End Class

