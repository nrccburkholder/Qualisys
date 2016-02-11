Namespace DataProviders
    Public MustInherit Class SPTI_ColumnDefinitionsProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_ColumnDefinitionsProvider
        Private Const mProviderName As String = "SPTI_ColumnDefinitionsProvider"
        Public Shared ReadOnly Property Instance() As SPTI_ColumnDefinitionsProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_ColumnDefinitionsProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_ColumnDefinition(ByVal columnDefID As Integer) As SPTI_ColumnDefinition
        Public MustOverride Function SelectAllSPTI_ColumnDefinitions() As SPTI_ColumnDefinitionCollection
        Public MustOverride Function InsertSPTI_ColumnDefinition(ByVal instance As SPTI_ColumnDefinition) As Integer
        Public MustOverride Sub UpdateSPTI_ColumnDefinition(ByVal instance As SPTI_ColumnDefinition)
        Public MustOverride Sub DeleteSPTI_ColumnDefinition(ByVal columnDefID As Integer)
        Public MustOverride Function SelectSPTI_ColumnDefinitionsByFileTemplateID(ByVal fileTemplateID As Integer) As SPTI_ColumnDefinitionCollection
    End Class
End Namespace