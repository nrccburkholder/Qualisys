'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_ExportDefinitionProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_ExportDefinitionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_ExportDefinition As String = "dbo.SPTI_DeleteSPTI_ExportDefinition"
        Public Const DeleteSPTI_ExportDefinitionIncludingChildren As String = "dbo.SPTI_DeleteExportDefIncludingChildren"
        Public Const InsertSPTI_ExportDefinition As String = "dbo.SPTI_InsertSPTI_ExportDefinition"
        Public Const SelectAllSPTI_ExportDefinitions As String = "dbo.SPTI_SelectAllSPTI_ExportDefinitions"
        Public Const SelectSPTI_ExportDefinition As String = "dbo.SPTI_SelectSPTI_ExportDefinition"
        Public Const UpdateSPTI_ExportDefinition As String = "dbo.SPTI_UpdateSPTI_ExportDefinition"
        Public Const CheckExportDefExistsByName As String = "dbo.SPTI_CheckExportDefExistsByName"
        Public Const CopyExportDefinition As String = "dbo.SPTI_CopyExportDefinition"
        Public Const InsertExportDefinitionLog As String = "dbo.SPTI_InsertExportDefinitionLog"
        Public Const DeDupImportFile As String = "dbo.SPTI_DeDupImportFile"
        Public Const FinalizeExportDefLog As String = "dbo.SPTI_FinalizeExportLog"
    End Class
#End Region

#Region " SPTI_ExportDefinition Procs "
    Private Function ReturnBoolean(ByVal rdr As SafeDataReader) As Boolean
        Return CBool(rdr.GetValue("ExportDefExists").ToString)
    End Function
    Private Function PopulateSPTI_ExportDefinition(ByVal rdr As SafeDataReader) As SPTI_ExportDefinition
        Dim newObject As SPTI_ExportDefinition = SPTI_ExportDefinition.NewSPTI_ExportDefinition
        Dim privateInterface As ISPTI_ExportDefinition = newObject
        newObject.BeginPopulate()
        privateInterface.ExportDefinitionID = rdr.GetInteger("ExportDefinitionID")
        newObject.Name = rdr.GetString("Name")
        newObject.Description = rdr.GetString("Description")        
        newObject.SourceFileTemplateID = rdr.GetInteger("SourceFileTemplate")
        newObject.ExportFileTemplateID = rdr.GetInteger("ExportFileTemplate")
        newObject.HasHeader = CBool(rdr.GetInteger("HasHeader"))
        newObject.FileDeDupRule = rdr.GetString("FileDeDupRule")
        newObject.SIDeDupStartDate = rdr.GetInteger("SIDeDupStartDate")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_ExportDefinition(ByVal exportDefinitionID As Integer) As SPTI_ExportDefinition
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_ExportDefinition, exportDefinitionID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_ExportDefinition(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_ExportDefinitions() As SPTI_ExportDefinitionCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_ExportDefinitions)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_ExportDefinitionCollection, SPTI_ExportDefinition)(rdr, AddressOf PopulateSPTI_ExportDefinition)
        End Using
    End Function

    Public Overrides Function InsertSPTI_ExportDefinition(ByVal instance As SPTI_ExportDefinition) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSPTI_ExportDefinition, instance.Name, instance.Description, instance.SourceFileTemplateID, instance.ExportFileTemplateID, instance.HasHeader, instance.FileDeDupRule, instance.SIDeDupStartDate)
        Return ExecuteInteger(cmd)
    End Function    
    Public Overrides Function InsertLog(ByVal exportDefID As Integer) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportDefinitionLog, exportDefID)
        Return ExecuteInteger(cmd)
    End Function
    Public Overrides Sub UpdateSPTI_ExportDefinition(ByVal instance As SPTI_ExportDefinition)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_ExportDefinition, instance.ExportDefinitionID, instance.Name, instance.Description, instance.SourceFileTemplateID, instance.ExportFileTemplateID, instance.HasHeader, instance.FileDeDupRule, instance.SIDeDupStartDate)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_ExportDefinition(ByVal exportDefinitionID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_ExportDefinition, exportDefinitionID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub DeleteExportDefIncludingChildren(ByVal exportDefintionID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_ExportDefinitionIncludingChildren, exportDefintionID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function CheckExportDefExistsByName(ByVal oldExportDefintionID As Integer, ByVal newExportDefName As String) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CheckExportDefExistsByName, newExportDefName, oldExportDefintionID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return True
            Else
                Return ReturnBoolean(rdr)
            End If
        End Using
    End Function
    Public Overrides Function CopyExportDefinition(ByVal oldExportDefID As Integer, ByVal newExportDefName As String) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CopyExportDefinition, oldExportDefID, newExportDefName)
        Return ExecuteInteger(cmd)
    End Function
    Public Overrides Sub DeDupImportFile(ByVal logID As Integer, ByVal qualifiedFieldList As String, ByVal temp1FieldList As String, ByVal temp2FieldList As String, ByVal criteriaString As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeDupImportFile, logID, qualifiedFieldList, temp1FieldList, temp2FieldList, criteriaString)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub FinalizeExportDefinitionLog(ByVal logId As Integer, ByVal errMsg As String, ByVal stackTrace As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.FinalizeExportDefLog, logId, errMsg, stackTrace)
        ExecuteNonQuery(cmd)
    End Sub
#End Region
End Class
