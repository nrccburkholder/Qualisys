
'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class MedicareGlobalCalcDateProvider
    Inherits Nrc.QualiSys.Library.DataProvider.MedicareGlobalCalcDateProvider

#Region " MedicareGlobalCalcDate Procs "

    ''' <summary>Populates the object with data from the store.</summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function PopulateMedicareGlobalCalcDate(ByVal rdr As SafeDataReader) As MedicareGlobalCalcDate
        Dim newObject As MedicareGlobalCalcDate = MedicareGlobalCalcDate.NewMedicareGlobalCalcDate
        Dim privateInterface As IMedicareGlobalCalcDate = newObject
        newObject.BeginPopulate()
        privateInterface.MedicareGlobalCalcDateId = rdr.GetInteger("MedicareGlobalReCalcDate_id")
        newObject.MedicareGlobalRecalDefaultId = rdr.GetInteger("MedicareGlobalRecalcDefault_id")
        newObject.ReCalcMonth = rdr.GetInteger("ReCalcMonth")
        newObject.EndPopulate()

        Return newObject
    End Function

    ''' <summary>Retrieves by PK from the data store.</summary>
    ''' <param name="MedicareGlobalCalcDateId"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function [Get](ByVal MedicareGlobalCalcDateId As Integer) As MedicareGlobalCalcDate
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareGlobalCalcDate, MedicareGlobalCalcDateId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicareGlobalCalcDate(rdr)
            End If
        End Using
    End Function

    ''' <summary>Retrieves all values from the data store.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetAll() As MedicareGlobalCalcDateCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllMedicareGlobalCalcDates)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MedicareGlobalCalcDateCollection, MedicareGlobalCalcDate)(rdr, AddressOf PopulateMedicareGlobalCalcDate)
        End Using
    End Function
    ''' <summary>Retrieves from the data store by FK</summary>
    ''' <param name="medicareGlobalDefaultID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetByGlobalDefaultID(ByVal medicareGlobalDefaultID As Integer) As MedicareGlobalCalcDateCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllMedicareGlobalCalcDatesByGlobalDefaultID, medicareGlobalDefaultID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MedicareGlobalCalcDateCollection, MedicareGlobalCalcDate)(rdr, AddressOf PopulateMedicareGlobalCalcDate)
        End Using
    End Function
    ''' <summary>Deletes from the data store by FK</summary>
    ''' <param name="medicareGlobalCalcDefaultID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub DeleteCalcDatesByGlobalDefaultID(ByVal medicareGlobalCalcDefaultID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteCalcDatesByGlobalDefaultID, medicareGlobalCalcDefaultID)
        ExecuteNonQuery(cmd)
    End Sub
    ''' <summary>Inserts into the data store.</summary>
    ''' <param name="instance"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function Insert(ByVal instance As MedicareGlobalCalcDate) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMedicareGlobalCalcDate, instance.MedicareGlobalRecalDefaultId, instance.ReCalcMonth)
        Return ExecuteInteger(cmd)
    End Function

    ''' <summary>Updates the data store.</summary>
    ''' <param name="instance"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Update(ByVal instance As MedicareGlobalCalcDate)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMedicareGlobalCalcDate, instance.MedicareGlobalCalcDateId, instance.MedicareGlobalRecalDefaultId, instance.ReCalcMonth)
        ExecuteNonQuery(cmd)
    End Sub

    ''' <summary>Deletes from the data store.</summary>
    ''' <param name="MedicareGlobalCalcDateId"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Delete(ByVal MedicareGlobalCalcDateId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMedicareGlobalCalcDate, MedicareGlobalCalcDateId)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
