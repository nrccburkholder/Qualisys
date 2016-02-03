Namespace DataProviders

    Public MustInherit Class SPTI_ExportDefinitionFileProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_ExportDefinitionFileProvider
        Private Const mProviderName As String = "SPTI_ExportDefinitionFileProvider"
        Public Shared ReadOnly Property Instance() As SPTI_ExportDefinitionFileProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_ExportDefinitionFileProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_ExportDefintionFile(ByVal fileID As Integer) As SPTI_ExportDefintionFile
        Public MustOverride Function SelectAllSPTI_ExportDefintionFiles() As SPTI_ExportDefintionFileCollection
        Public MustOverride Function InsertSPTI_ExportDefintionFile(ByVal instance As SPTI_ExportDefintionFile) As Integer
        Public MustOverride Sub UpdateSPTI_ExportDefintionFile(ByVal instance As SPTI_ExportDefintionFile)
        Public MustOverride Sub DeleteSPTI_ExportDefintionFile(ByVal fileID As Integer)
        Public MustOverride Function SelectSourceFileByDefID(ByVal exportDefinitionID As Integer) As SPTI_ExportDefintionFile
        Public MustOverride Function SelectExportFilesByDefID(ByVal exportDefinitionID As Integer) As SPTI_ExportDefintionFileCollection
        Public MustOverride Sub DeleteSPTI_ExportDefinitionFileByDefIDAndSource(ByVal exportDefinitionID As Integer, ByVal IsSourceFile As Integer)
        Public MustOverride Sub DeDupQMSRecordsInImportFile(ByVal logID As Integer, ByVal fileID As Integer, ByVal baseCriteriaList As String, ByVal clientIDs As String, ByVal columnMaps As String, ByVal isActive As Boolean)
        Public MustOverride Sub DeleteTempDeDupTable(ByVal logID As Integer, ByVal fileID As Integer)
    End Class
End Namespace