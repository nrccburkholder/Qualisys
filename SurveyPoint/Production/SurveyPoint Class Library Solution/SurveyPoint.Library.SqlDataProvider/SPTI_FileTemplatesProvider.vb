'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.IO

Friend Class SPTI_FileTemplatesProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_FileTemplatesProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_FileTemplate As String = "dbo.SPTI_DeleteSPTI_FileTemplate"
        Public Const InsertSPTI_FileTemplate As String = "dbo.SPTI_InsertSPTI_FileTemplate"
        Public Const SelectAllSPTI_FileTemplates As String = "dbo.SPTI_SelectAllSPTI_FileTemplates"
        Public Const SelectSPTI_FileTemplate As String = "dbo.SPTI_SelectSPTI_FileTemplate"
        Public Const UpdateSPTI_FileTemplate As String = "dbo.SPTI_UpdateSPTI_FileTemplate"
        Public Const DeleteTemplateIncludingChildren As String = "dbo.SPTI_DeleteFileTemplateIncludingChildren"
        Public Const CheckFileTemplateExistsByName As String = "dbo.SPTI_CheckFileTemplateExistsByName"
        Public Const CopyFileTemplate As String = "dbo.SPTI_CopyFileTemplate"
        Public Const CreateTempImportTable As String = "dbo.SPTI_CreateTempImportTable"
        Public Const InsertTempImportTable As String = "dbo.SPTI_InsertTempImportTable"
        Public Const SelectExportData As String = "dbo.SPTI_SelectExportFileData"
        Public Const CheckIfFileTemplatesExistInExportDefinitions As String = "dbo.SPTI_CheckIfFileTemplatesExistInExportDefinitions"
        Public Const SelectQMSDeDupedExportData As String = "dbo.SPTI_SelectQMSDeDupedExportFileData"
    End Class
#End Region

#Region " SPTI_FileTemplate Procs "

    Private Function PopulateSPTI_FileTemplate(ByVal rdr As SafeDataReader) As SPTI_FileTemplate
        Dim newObject As SPTI_FileTemplate = SPTI_FileTemplate.NewSPTI_FileTemplate
        Dim privateInterface As ISPTI_FileTemplate = newObject
        newObject.BeginPopulate()
        privateInterface.FileTemplateID = rdr.GetInteger("FileTemplateID")
        newObject.Name = rdr.GetString("Name")
        newObject.Description = rdr.GetString("Description")
        newObject.IsFixedLength = CBool(rdr.GetInteger("IsFixedLength"))
        newObject.EncodingType = rdr.GetInteger("EncodingType")
        newObject.ImportAsString = CBool(rdr.GetInteger("ImportAsString"))
        newObject.TrimStrings = CBool(rdr.GetInteger("TrimStrings"))
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.Active = rdr.GetInteger("Active")
        newObject.Archive = rdr.GetInteger("Archive")
        newObject.UseQuotedIdentifier = CBool(rdr.GetInteger("UseQuotedIdentifier"))
        newObject.DelimeterID = rdr.GetInteger("DelimeterID")
        newObject.EndPopulate()

        Return newObject
    End Function
    Private Function ReturnBoolean(ByVal rdr As SafeDataReader) As Boolean
        Return CBool(rdr.GetValue("FileTemplateExists").ToString)
    End Function

    Public Overrides Function SelectSPTI_FileTemplate(ByVal fileTemplateID As Integer) As SPTI_FileTemplate
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_FileTemplate, fileTemplateID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_FileTemplate(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_FileTemplates() As SPTI_FileTemplateCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_FileTemplates)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_FileTemplateCollection, SPTI_FileTemplate)(rdr, AddressOf PopulateSPTI_FileTemplate)
        End Using
    End Function

    Public Overrides Function InsertSPTI_FileTemplate(ByVal instance As SPTI_FileTemplate) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSPTI_FileTemplate, instance.Name, instance.Description, instance.IsFixedLength, instance.EncodingType, instance.ImportAsString, instance.TrimStrings, instance.UseQuotedIdentifier, instance.DelimeterID)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_FileTemplate(ByVal instance As SPTI_FileTemplate)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_FileTemplate, instance.FileTemplateID, instance.Name, instance.Description, instance.IsFixedLength, instance.EncodingType, instance.ImportAsString, instance.TrimStrings, instance.UseQuotedIdentifier, instance.DelimeterID)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_FileTemplate(ByVal fileTemplateID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_FileTemplate, fileTemplateID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub DeleteTemplateIncludingChildren(ByVal fileTemplateID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteTemplateIncludingChildren, fileTemplateID)
        ExecuteNonQuery(cmd)
    End Sub
#End Region
    Public Overrides Function CheckFileTemplateExistsByName(ByVal fileTemplateID As Integer, ByVal fileTemplateName As String) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CheckFileTemplateExistsByName, fileTemplateName, fileTemplateID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return True
            Else
                Return ReturnBoolean(rdr)
            End If
        End Using
    End Function
    Public Overrides Function CopyFileTemplate(ByVal oldFileTemplateID As Integer, ByVal newFileTemplateName As String) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CopyFileTemplate, oldFileTemplateID, newFileTemplateName)
        Return ExecuteInteger(cmd)
    End Function
    Public Overrides Sub CreateImportTable(ByVal tableName As String, ByVal fieldList As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CreateTempImportTable, tableName, fieldList)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub InsertImportTable(ByVal logID As Integer, ByVal fieldList As String, ByVal fieldValues As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertTempImportTable, logID, fieldList, fieldValues)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function SelectExportFileData(ByVal logID As Integer, ByVal fileID As Integer, ByVal fieldList As String, ByVal whereCriteria As String) As DataTable
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportData, logID, fileID, fieldList, whereCriteria)
        Dim ds As System.Data.DataSet
        ds = Db.ExecuteDataSet(cmd)
        ds.Tables(0).TableName = "ExportData"
        Return ds.Tables(0)
    End Function
    Public Overrides Function SelectQMSDeDupedExportFileData(ByVal logID As Integer, ByVal fileID As Integer, ByVal fieldList As String) As System.Data.DataTable
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQMSDeDupedExportData, logID, fileID, fieldList)
        Dim ds As System.Data.DataSet
        ds = Db.ExecuteDataSet(cmd)
        ds.Tables(0).TableName = "ExportData"
        Return ds.Tables(0)
    End Function
    Public Overrides Function CheckIfFileTemplatesExistInExportDefinitions(ByVal fileTemplateID As Integer) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CheckIfFileTemplatesExistInExportDefinitions, fileTemplateID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return True
            Else
                Return CBool(rdr.GetValue("FileTemplateUsed").ToString)
            End If
        End Using
    End Function
End Class
