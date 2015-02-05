Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class SurveyTypeCollection
	Inherits BusinessListBase(Of SurveyTypeCollection , SurveyType)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  SurveyType = SurveyType.NewSurveyType
        Add(newObj)
        Return newObj

    End Function

End Class

