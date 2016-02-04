'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_DeDupRuleColumnMapProvider
    Inherits DataProviders.SPTI_DeDupRuleColumnMapProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_DeDupRuleColumnMap As String = "dbo.SPTI_DeleteSPTI_DeDupRuleColumnMap"
        Public Const InsertSPTI_DeDupRuleColumnMap As String = "dbo.SPTI_InsertSPTI_DeDupRuleColumnMap"
        Public Const SelectAllSPTI_DeDupRuleColumnMaps As String = "dbo.SPTI_SelectAllSPTI_DeDupRuleColumnMaps"
        Public Const SelectAllSPTI_DeDupRuleColumnMapsByDeDupRuleID As String = "dbo.SPTI_SelectAllSPTI_DeDupRuleColumnMapsByDeDupRuleID"
        Public Const SelectSPTI_DeDupRuleColumnMap As String = "dbo.SPTI_SelectSPTI_DeDupRuleColumnMap"
        Public Const UpdateSPTI_DeDupRuleColumnMap As String = "dbo.SPTI_UpdateSPTI_DeDupRuleColumnMap"
    End Class
#End Region

#Region " SPTI_DeDupRuleColumnMap Procs "

    Private Function PopulateSPTI_DeDupRuleColumnMap(ByVal rdr As SafeDataReader) As SPTI_DeDupRuleColumnMap
        Dim newObject As SPTI_DeDupRuleColumnMap = SPTI_DeDupRuleColumnMap.NewSPTI_DeDupRuleColumnMap
        Dim privateInterface As ISPTI_DeDupRuleColumnMap = newObject
        newObject.BeginPopulate()
        privateInterface.ID = rdr.GetInteger("ID")
        newObject.DeDupRuleID = rdr.GetInteger("DeDupRuleID")
        newObject.QMSColumnName = rdr.GetString("QMSColumnName")
        newObject.FileTemplateColumnName = rdr.GetString("FileTemplateColumnName")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_DeDupRuleColumnMap(ByVal iD As Integer) As SPTI_DeDupRuleColumnMap
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_DeDupRuleColumnMap, iD)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_DeDupRuleColumnMap(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_DeDupRuleColumnMaps() As SPTI_DeDupRuleColumnMapCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_DeDupRuleColumnMaps)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_DeDupRuleColumnMapCollection, SPTI_DeDupRuleColumnMap)(rdr, AddressOf PopulateSPTI_DeDupRuleColumnMap)
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_DeDupRuleColumnMapsByDeDupRuleID(ByVal deDupRuleID As Integer) As SPTI_DeDupRuleColumnMapCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_DeDupRuleColumnMapsByDeDupRuleID, deDupRuleID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_DeDupRuleColumnMapCollection, SPTI_DeDupRuleColumnMap)(rdr, AddressOf PopulateSPTI_DeDupRuleColumnMap)
        End Using
    End Function

    Public Overrides Function InsertSPTI_DeDupRuleColumnMap(ByVal instance As SPTI_DeDupRuleColumnMap) As Integer
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertSPTI_DeDupRuleColumnMap, instance.DeDupRuleID, instance.QMSColumnName, instance.FileTemplateColumnName)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_DeDupRuleColumnMap(ByVal instance As SPTI_DeDupRuleColumnMap)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_DeDupRuleColumnMap, instance.ID, instance.DeDupRuleID, instance.QMSColumnName, instance.FileTemplateColumnName)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_DeDupRuleColumnMap(ByVal iD As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_DeDupRuleColumnMap, iD)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
