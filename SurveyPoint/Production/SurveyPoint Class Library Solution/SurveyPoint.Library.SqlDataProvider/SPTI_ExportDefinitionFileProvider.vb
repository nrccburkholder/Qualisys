'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_ExportDefinitionFileProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_ExportDefinitionFileProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_ExportDefintionFile As String = "dbo.SPTI_DeleteSPTI_ExportDefintionFile"
        Public Const InsertSPTI_ExportDefintionFile As String = "dbo.SPTI_InsertSPTI_ExportDefintionFile"
        Public Const SelectAllSPTI_ExportDefintionFiles As String = "dbo.SPTI_SelectAllSPTI_ExportDefintionFiles"
        Public Const SelectSPTI_ExportDefintionFile As String = "dbo.SPTI_SelectSPTI_ExportDefintionFile"
        Public Const UpdateSPTI_ExportDefintionFile As String = "dbo.SPTI_UpdateSPTI_ExportDefintionFile"
        Public Const SelectAllByDefID As String = "dbo.SPTI_SelectAllSPTI_ExportDefintionFilesByDefinitionID"
        Public Const DeleteByDefIDAndSource As String = "dbo.SPTI_DeleteSPTI_ExportDefintionFileByDefIDAndSource"
        Public Const QMSDeDupOfImportFile As String = "dbo.SPTI_QMSDeDupOfImportFile"
        Public Const DeleteTempDeDupTable As String = "dbo.SPTI_DeleteTempDeDupTable"
    End Class
#End Region

#Region " SPTI_ExportDefintionFile Procs "

    Private Function PopulateSPTI_ExportDefintionFile(ByVal rdr As SafeDataReader) As SPTI_ExportDefintionFile
        Dim newObject As SPTI_ExportDefintionFile = SPTI_ExportDefintionFile.NewSPTI_ExportDefintionFile
        Dim privateInterface As ISPTI_ExportDefintionFile = newObject
        newObject.BeginPopulate()
        privateInterface.FileID = rdr.GetInteger("FileID")
        newObject.ExportDefinitionID = rdr.GetInteger("ExportDefinitionID")
        newObject.Name = rdr.GetString("Name")
        newObject.PathandFileName = rdr.GetString("PathandFileName")
        newObject.IsSourceFile = CBool(rdr.GetInteger("IsSourceFile"))
        newObject.SplitRule = rdr.GetString("SplitRule")
        'newObject.DeDupRule = rdr.GetString("DeDupRule")        
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_ExportDefintionFile(ByVal fileID As Integer) As SPTI_ExportDefintionFile
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_ExportDefintionFile, fileID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_ExportDefintionFile(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_ExportDefintionFiles() As SPTI_ExportDefintionFileCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_ExportDefintionFiles)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_ExportDefintionFileCollection, SPTI_ExportDefintionFile)(rdr, AddressOf PopulateSPTI_ExportDefintionFile)
        End Using
    End Function
    Public Overrides Function SelectExportFilesByDefID(ByVal exportDefinitionID As Integer) As SPTI_ExportDefintionFileCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllByDefID, exportDefinitionID, 0)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_ExportDefintionFileCollection, SPTI_ExportDefintionFile)(rdr, AddressOf PopulateSPTI_ExportDefintionFile)
        End Using
    End Function
    Public Overrides Function SelectSourceFileByDefID(ByVal exportDefinitionID As Integer) As SPTI_ExportDefintionFile
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllByDefID, exportDefinitionID, 1)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_ExportDefintionFile(rdr)
            End If
        End Using
    End Function
    Public Overrides Function InsertSPTI_ExportDefintionFile(ByVal instance As SPTI_ExportDefintionFile) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSPTI_ExportDefintionFile, instance.ExportDefinitionID, instance.Name, instance.PathandFileName, instance.IsSourceFile, instance.SplitRule, instance.DeDupRule)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_ExportDefintionFile(ByVal instance As SPTI_ExportDefintionFile)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_ExportDefintionFile, instance.FileID, instance.ExportDefinitionID, instance.Name, instance.PathandFileName, instance.IsSourceFile, instance.SplitRule, instance.DeDupRule)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_ExportDefintionFile(ByVal fileID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_ExportDefintionFile, fileID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub DeleteSPTI_ExportDefinitionFileByDefIDAndSource(ByVal exportDefinitionID As Integer, ByVal IsSourceFile As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteByDefIDAndSource, exportDefinitionID, IsSourceFile)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub DeDupQMSRecordsInImportFile(ByVal logID As Integer, ByVal fileID As Integer, ByVal baseCriteriaList As String, ByVal clientIDs As String, ByVal columnMaps As String, ByVal isActive As Boolean)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.QMSDeDupOfImportFile, fileID, logID, baseCriteriaList, clientIDs, columnMaps, isActive)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub DeleteTempDeDupTable(ByVal logID As Integer, ByVal fileID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteTempDeDupTable, fileID, logID)
        ExecuteNonQuery(cmd)
    End Sub
#End Region


End Class
