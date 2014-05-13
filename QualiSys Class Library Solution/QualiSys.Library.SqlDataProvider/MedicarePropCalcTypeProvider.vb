Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class MedicarePropCalcTypeProvider
    Inherits Nrc.QualiSys.Library.DataProvider.MedicarePropCalcTypeProvider

    Private Function PopulateMedicarePropCalcType(ByVal rdr As SafeDataReader) As MedicarePropCalcType

        Dim newObject As MedicarePropCalcType = MedicarePropCalcType.NewMedicarePropCalcType
        Dim privateInterface As IMedicarePropCalcType = newObject

        newObject.BeginPopulate()
        privateInterface.MedicarePropCalcTypeId = rdr.GetInteger("MedicarePropCalcType_ID")
        newObject.MedicarePropCalcTypeName = rdr.GetString("MedicarePropCalcTypeName")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function [Select](ByVal medicarePropCalcTypeId As Integer) As MedicarePropCalcType

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicarePropCalcType, medicarePropCalcTypeId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMedicarePropCalcType(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAll() As MedicarePropCalcTypeCollection

        Dim propColl As New MedicarePropCalcTypeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllFacilities)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                propColl.Add(PopulateMedicarePropCalcType(rdr))
            End While
        End Using

        Return propColl

    End Function

End Class
