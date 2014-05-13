Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class TranslationModuleCollection
    Inherits BusinessListBase(Of TranslationModuleCollection, TranslationModule)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As TranslationModule = TranslationModule.NewTranslationModule
        Add(newObj)
        Return newObj

    End Function

#End Region

End Class

