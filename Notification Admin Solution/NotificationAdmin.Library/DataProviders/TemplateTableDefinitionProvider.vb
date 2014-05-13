Namespace DataProviders

    Public MustInherit Class TemplateTableDefinitionProvider

#Region " Singleton Implementation "
        Private Shared mInstance As TemplateTableDefinitionProvider
        Private Const mProviderName As String = "TemplateTableDefinitionProvider"
        Public Shared ReadOnly Property Instance() As TemplateTableDefinitionProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of TemplateTableDefinitionProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectTemplateTableDefinition(ByVal id As Integer) As TemplateTableDefinition
        Public MustOverride Function SelectTemplateTableDefinitionsByTemplateDefinitionId(ByVal defintionId As Integer) As TemplateTableDefinitionCollection
        Public MustOverride Function InsertTemplateTableDefinition(ByVal instance As TemplateTableDefinition) As Integer
        Public MustOverride Sub UpdateTemplateTableDefinition(ByVal instance As TemplateTableDefinition)
        Public MustOverride Sub DeleteTemplateTableDefinition(ByVal id As Integer)
    End Class

End Namespace
