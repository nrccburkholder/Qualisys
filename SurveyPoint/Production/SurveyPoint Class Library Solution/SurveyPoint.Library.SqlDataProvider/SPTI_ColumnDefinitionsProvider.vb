'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_ColumnDefinitionsProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_ColumnDefinitionsProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_ColumnDefinition As String = "dbo.SPTI_DeleteSPTI_ColumnDefinition"
        Public Const InsertSPTI_ColumnDefinition As String = "dbo.SPTI_InsertSPTI_ColumnDefinition"
        Public Const SelectAllSPTI_ColumnDefinitions As String = "dbo.SPTI_SelectAllSPTI_ColumnDefinitions"
        Public Const SelectSPTI_ColumnDefinition As String = "dbo.SPTI_SelectSPTI_ColumnDefinition"
        Public Const UpdateSPTI_ColumnDefinition As String = "dbo.SPTI_UpdateSPTI_ColumnDefinition"
        Public Const SelectSPTI_ColumnDefintionsByFileTemplateID As String = "dbo.SPTI_SelectAllSPTI_ColumnDefinitionsByFileTemplateID"
    End Class
#End Region

#Region " SPTI_ColumnDefinition Procs "

    Private Function PopulateSPTI_ColumnDefinition(ByVal rdr As SafeDataReader) As SPTI_ColumnDefinition
        Dim newObject As SPTI_ColumnDefinition = SPTI_ColumnDefinition.NewSPTI_ColumnDefinition
        Dim privateInterface As ISPTI_ColumnDefinition = newObject
        newObject.BeginPopulate()
        privateInterface.ColumnDefID = rdr.GetInteger("ColumnDefID")
        newObject.FileTemplateID = rdr.GetInteger("FileTemplateID")
        newObject.Name = rdr.GetString("Name")
        newObject.Ordinal = rdr.GetInteger("Ordinal")
        newObject.FixedStringLength = rdr.GetInteger("FixedStringLength")
        newObject.FormatingRuleID = rdr.GetInteger("FormatingRuleID")
        newObject.DateTypeID = rdr.GetInteger("DateTypeID")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.Active = rdr.GetInteger("Active")
        newObject.Archive = rdr.GetInteger("Archive")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_ColumnDefinition(ByVal columnDefID As Integer) As SPTI_ColumnDefinition
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_ColumnDefinition, columnDefID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_ColumnDefinition(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_ColumnDefinitions() As SPTI_ColumnDefinitionCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_ColumnDefinitions)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_ColumnDefinitionCollection, SPTI_ColumnDefinition)(rdr, AddressOf PopulateSPTI_ColumnDefinition)
        End Using
    End Function

    Public Overrides Function InsertSPTI_ColumnDefinition(ByVal instance As SPTI_ColumnDefinition) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSPTI_ColumnDefinition, instance.FileTemplateID, instance.Name, instance.Ordinal, instance.FixedStringLength, instance.DateTypeID, instance.FormatingRuleID)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_ColumnDefinition(ByVal instance As SPTI_ColumnDefinition)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_ColumnDefinition, instance.ColumnDefID, instance.FileTemplateID, instance.Name, instance.Ordinal, instance.FixedStringLength, instance.DateTypeID, instance.FormatingRuleID)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_ColumnDefinition(ByVal columnDefID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_ColumnDefinition, columnDefID)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Function SelectSPTI_ColumnDefinitionsByFileTemplateID(ByVal fileTemplateID As Integer) As SPTI_ColumnDefinitionCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSPTI_ColumnDefintionsByFileTemplateID, fileTemplateID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_ColumnDefinitionCollection, SPTI_ColumnDefinition)(rdr, AddressOf PopulateSPTI_ColumnDefinition)
        End Using
    End Function
#End Region


End Class
