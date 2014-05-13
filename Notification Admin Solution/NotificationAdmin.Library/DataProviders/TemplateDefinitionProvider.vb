Namespace DataProviders

    Public MustInherit Class TemplateDefinitionProvider

#Region " Singleton Implementation "
        Private Shared mInstance As TemplateDefinitionProvider
        Private Const mProviderName As String = "TemplateDefinitionProvider"
        Public Shared ReadOnly Property Instance() As TemplateDefinitionProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of TemplateDefinitionProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectTemplateDefinition(ByVal id As Integer) As TemplateDefinition
        Public MustOverride Function SelectTemplateDefinitionsByTemplateId(ByVal templateId As Integer) As TemplateDefinitionCollection
        Public MustOverride Function InsertTemplateDefinition(ByVal instance As TemplateDefinition) As Integer
        Public MustOverride Sub UpdateTemplateDefinition(ByVal instance As TemplateDefinition)
        Public MustOverride Sub DeleteTemplateDefinition(ByVal id As Integer)
    End Class

End Namespace
