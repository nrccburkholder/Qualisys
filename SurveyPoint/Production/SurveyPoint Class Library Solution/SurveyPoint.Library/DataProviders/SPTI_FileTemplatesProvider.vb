Namespace DataProviders
    Public MustInherit Class SPTI_FileTemplatesProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_FileTemplatesProvider
        Private Const mProviderName As String = "SPTI_FileTemplatesProvider"
        Public Shared ReadOnly Property Instance() As SPTI_FileTemplatesProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_FileTemplatesProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_FileTemplate(ByVal fileTemplateID As Integer) As SPTI_FileTemplate
        Public MustOverride Function SelectAllSPTI_FileTemplates() As SPTI_FileTemplateCollection
        Public MustOverride Function InsertSPTI_FileTemplate(ByVal instance As SPTI_FileTemplate) As Integer
        Public MustOverride Sub UpdateSPTI_FileTemplate(ByVal instance As SPTI_FileTemplate)
        Public MustOverride Sub DeleteSPTI_FileTemplate(ByVal fileTemplateID As Integer)
        Public MustOverride Sub DeleteTemplateIncludingChildren(ByVal fileTemplateID As Integer)
        Public MustOverride Function CheckFileTemplateExistsByName(ByVal fileTemplateID As Integer, ByVal fileTemplateName As String) As Boolean
        Public MustOverride Function CopyFileTemplate(ByVal oldFileTemplateID As Integer, ByVal newFileTemplateName As String) As Integer        
        Public MustOverride Sub CreateImportTable(ByVal tableName As String, ByVal fieldList As String)
        Public MustOverride Sub InsertImportTable(ByVal logID As Integer, ByVal fieldList As String, ByVal fieldValues As String)
        Public MustOverride Function SelectExportFileData(ByVal logID As Integer, ByVal fileID As Integer, ByVal fieldList As String, ByVal whereCriteria As String) As System.Data.DataTable
        Public MustOverride Function SelectQMSDeDupedExportFileData(ByVal logID As Integer, ByVal fileID As Integer, ByVal fieldList As String) As System.Data.DataTable
        Public MustOverride Function CheckIfFileTemplatesExistInExportDefinitions(ByVal fileTemplateID As Integer) As Boolean
    End Class
End Namespace