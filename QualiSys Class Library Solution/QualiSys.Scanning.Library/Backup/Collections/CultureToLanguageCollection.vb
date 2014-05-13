Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class CultureToLanguageCollection
	Inherits BusinessListBase(Of CultureToLanguageCollection , CultureToLanguage)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As CultureToLanguage = CultureToLanguage.NewCultureToLanguage
        Add(newObj)
        Return newObj

    End Function

#End Region

End Class

