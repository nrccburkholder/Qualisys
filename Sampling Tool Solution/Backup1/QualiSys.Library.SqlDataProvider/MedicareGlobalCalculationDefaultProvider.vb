'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class MedicareGlobalCalculationDefaultProvider
    Inherits Nrc.QualiSys.Library.DataProvider.MedicareGlobalCalculationDefaultProvider

#Region " MedicareGlobalCalculationDefault Procs "

    ''' <summary>Populates the object with values from the data store.</summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function PopulateMedicareGlobalCalculationDefault(ByVal rdr As SafeDataReader) As MedicareGlobalCalculationDefault
        Dim newObject As MedicareGlobalCalculationDefault = MedicareGlobalCalculationDefault.NewMedicareGlobalCalculationDefault
        Dim privateInterface As IMedicareGlobalCalculationDefault = newObject
        newObject.BeginPopulate()
        privateInterface.MedicareGlobalCalculationDefaultId = rdr.GetInteger("MedicareGlobalCalcDefault_id")
        newObject.RespRate = rdr.GetDecimal("RespRate")
        newObject.IneligibleRate = rdr.GetDecimal("IneligibleRate")
        newObject.ProportionChangeThreshold = rdr.GetDecimal("ProportionChangeThreshold")
        newObject.AnnualReturnTarget = rdr.GetInteger("AnnualReturnTarget")
        newObject.ForceCensusSamplePercentage = rdr.GetDecimal("ForceCensusSamplePercentage")
        newObject.EndPopulate()

        Return newObject
    End Function

    ''' <summary>Retrieves from the data store by PK.</summary>
    ''' <param name="MedicareGlobalCalculationDefaultId"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function [Get](ByVal MedicareGlobalCalculationDefaultId As Integer) As MedicareGlobalCalculationDefault
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareGlobalCalculationDefault, MedicareGlobalCalculationDefaultId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicareGlobalCalculationDefault(rdr)
            End If
        End Using
    End Function

    ''' <summary>Retrieves all records from the data store.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function GetAll() As MedicareGlobalCalculationDefaultCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllMedicareGlobalCalculationDefaults)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MedicareGlobalCalculationDefaultCollection, MedicareGlobalCalculationDefault)(rdr, AddressOf PopulateMedicareGlobalCalculationDefault)
        End Using
    End Function

    ''' <summary>Inserts into the data store.</summary>
    ''' <param name="instance"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function Insert(ByVal instance As MedicareGlobalCalculationDefault) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMedicareGlobalCalculationDefault, instance.RespRate, instance.IneligibleRate, instance.ProportionChangeThreshold, instance.AnnualReturnTarget, instance.ForceCensusSamplePercentage)
        Return ExecuteInteger(cmd)
    End Function

    ''' <summary>Updates the data store.</summary>
    ''' <param name="instance"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Update(ByVal instance As MedicareGlobalCalculationDefault)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMedicareGlobalCalculationDefault, instance.MedicareGlobalCalculationDefaultId, instance.RespRate, instance.IneligibleRate, instance.ProportionChangeThreshold, instance.AnnualReturnTarget, instance.ForceCensusSamplePercentage)
        ExecuteNonQuery(cmd)
    End Sub

    ''' <summary>Deletes from the data store.</summary>
    ''' <param name="MedicareGlobalCalculationDefaultId"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Delete(ByVal MedicareGlobalCalculationDefaultId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMedicareGlobalCalculationDefault, MedicareGlobalCalculationDefaultId)
        ExecuteNonQuery(cmd)
    End Sub


#End Region


End Class
