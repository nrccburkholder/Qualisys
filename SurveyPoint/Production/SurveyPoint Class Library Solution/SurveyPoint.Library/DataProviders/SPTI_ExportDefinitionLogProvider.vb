Namespace DataProviders
    Public MustInherit Class SPTI_ExportDefinitionLogProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_ExportDefinitionLogProvider
        Private Const mProviderName As String = "SPTI_ExportDefinitionLogProvider"
        Public Shared ReadOnly Property Instance() As SPTI_ExportDefinitionLogProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_ExportDefinitionLogProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_ExportDefinitionLog(ByVal logID As Integer) As SPTI_ExportDefinitionLog
        Public MustOverride Function SelectAllSPTI_ExportDefinitionLogs() As SPTI_ExportDefinitionLogCollection
        Public MustOverride Function InsertSPTI_ExportDefinitionLog(ByVal instance As SPTI_ExportDefinitionLog) As Integer
        Public MustOverride Sub UpdateSPTI_ExportDefinitionLog(ByVal instance As SPTI_ExportDefinitionLog)
        Public MustOverride Sub DeleteSPTI_ExportDefinitionLog(ByVal logID As Integer)
    End Class
End Namespace
