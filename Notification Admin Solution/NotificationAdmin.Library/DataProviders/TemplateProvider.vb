Namespace DataProviders

    Public MustInherit Class TemplateProvider

#Region " Singleton Implementation "

        Private Shared mInstance As TemplateProvider
        Private Const mProviderName As String = "TemplateProvider"

        Public Shared ReadOnly Property Instance() As TemplateProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of TemplateProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function SelectTemplate(ByVal id As Integer) As Template
        Public MustOverride Function SelectTemplateByName(ByVal name As String) As Template
        Public MustOverride Function SelectAllTemplates() As TemplateCollection
        Public MustOverride Function InsertTemplate(ByVal instance As Template) As Integer
        Public MustOverride Sub UpdateTemplate(ByVal instance As Template)
        Public MustOverride Sub DeleteTemplate(ByVal id As Integer)

    End Class

End Namespace

