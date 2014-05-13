Imports NRC.Framework.BusinessLogic

Public MustInherit Class TranslationModuleProvider

#Region " Singleton Implementation "

    Private Shared mInstance As TranslationModuleProvider
    Private Const mProviderName As String = "TranslationModuleProvider"

    Public Shared ReadOnly Property Instance() As TranslationModuleProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of TranslationModuleProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

#Region " Constructors "

    Protected Sub New()

    End Sub

#End Region

#Region " Public MustOverride Methods "

    Public MustOverride Function SelectTranslationModule(ByVal translationModuleId As Integer) As TranslationModule
    Public MustOverride Function SelectTranslationModulesByVendorId(ByVal vendorId As Integer) As TranslationModuleCollection
    Public MustOverride Function InsertTranslationModule(ByVal instance As TranslationModule) As Integer
    Public MustOverride Sub UpdateTranslationModule(ByVal instance As TranslationModule)
    Public MustOverride Sub DeleteTranslationModule(ByVal instance As TranslationModule)

#End Region

End Class

