Namespace DataProviders
    Public MustInherit Class SPTI_ExportDefinitionProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_ExportDefinitionProvider
        Private Const mProviderName As String = "SPTI_ExportDefinitionProvider"
        Public Shared ReadOnly Property Instance() As SPTI_ExportDefinitionProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_ExportDefinitionProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_ExportDefinition(ByVal exportDefinitionID As Integer) As SPTI_ExportDefinition
        Public MustOverride Function SelectAllSPTI_ExportDefinitions() As SPTI_ExportDefinitionCollection
        Public MustOverride Function InsertSPTI_ExportDefinition(ByVal instance As SPTI_ExportDefinition) As Integer
        Public MustOverride Sub UpdateSPTI_ExportDefinition(ByVal instance As SPTI_ExportDefinition)
        Public MustOverride Sub DeleteSPTI_ExportDefinition(ByVal exportDefinitionID As Integer)
        Public MustOverride Sub DeleteExportDefIncludingChildren(ByVal exportDefintionID As Integer)
        Public MustOverride Function CheckExportDefExistsByName(ByVal oldExportDefintionID As Integer, ByVal newExportDefName As String) As Boolean
        Public MustOverride Function CopyExportDefinition(ByVal oldExportDefID As Integer, ByVal newExportDefName As String) As Integer
        Public MustOverride Function InsertLog(ByVal exportDefID As Integer) As Integer
        Public MustOverride Sub DeDupImportFile(ByVal logID As Integer, ByVal qualifiedFieldList As String, ByVal temp1FieldList As String, ByVal temp2FieldList As String, ByVal criteriaString As String)
        Public MustOverride Sub FinalizeExportDefinitionLog(ByVal logId As Integer, ByVal errMsg As String, ByVal stackTrace As String)
    End Class
End Namespace