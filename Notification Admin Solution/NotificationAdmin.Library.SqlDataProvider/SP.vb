Friend NotInheritable Class SP

    Private Sub New()

    End Sub

#Region "Template Procs"

    Public Shared ReadOnly DeleteTemplate As String = "dbo.NS_DeleteTemplate"
    Public Shared ReadOnly InsertTemplate As String = "dbo.NS_InsertTemplate"
    Public Shared ReadOnly SelectAllTemplates As String = "dbo.NS_SelectAllTemplates"
    Public Shared ReadOnly SelectTemplate As String = "dbo.NS_SelectTemplate"
    Public Shared ReadOnly SelectTemplateByName As String = "dbo.NS_SelectTemplateByTemplateName"
    Public Shared ReadOnly UpdateTemplate As String = "dbo.NS_UpdateTemplate"

#End Region

#Region "TemplateDefinition Procs"

    Public Shared ReadOnly DeleteTemplateDefinition As String = "dbo.NS_DeleteTemplateDefinitions"
    Public Shared ReadOnly InsertTemplateDefinition As String = "dbo.NS_InsertTemplateDefinitions"
    Public Shared ReadOnly SelectTemplateDefinition As String = "dbo.NS_SelectTemplateDefinitions"
    Public Shared ReadOnly SelectTemplateDefinitionsByTemplateId As String = "dbo.NS_SelectTemplateDefinitionsByTemplateId"
    Public Shared ReadOnly UpdateTemplateDefinition As String = "dbo.NS_UpdateTemplateDefinitions"

#End Region

#Region "TemplateTableDefinition Procs"

    Public Shared ReadOnly DeleteTemplateTableDefinition As String = "dbo.NS_DeleteTemplateTableDefinitions"
    Public Shared ReadOnly InsertTemplateTableDefinition As String = "dbo.NS_InsertTemplateTableDefinitions"
    Public Shared ReadOnly SelectTemplateTableDefinition As String = "dbo.NS_SelectTemplateTableDefinitions"
    'TP 20080613
    Public Shared ReadOnly SelectTemplateTableDefinitionsByTemplateDefinitionId As String = "dbo.NS_SelectTemplateTableDefinitionsByTemplateDefinitionsId"
    Public Shared ReadOnly UpdateTemplateTableDefinition As String = "dbo.NS_UpdateTemplateTableDefinitions"

#End Region

End Class
