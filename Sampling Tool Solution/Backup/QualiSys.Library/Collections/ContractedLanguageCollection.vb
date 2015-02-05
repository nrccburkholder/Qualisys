Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class ContractedLanguageCollection
	Inherits BusinessListBase(Of ContractedLanguageCollection , ContractedLanguage)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  ContractedLanguage = ContractedLanguage.NewContractedLanguage
        Add(newObj)
        Return newObj

    End Function
	
End Class

