Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class SurveyDataLoadCollection
    Inherits BusinessListBase(Of SurveyDataLoadCollection, SurveyDataLoad)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As SurveyDataLoad = SurveyDataLoad.NewSurveyDataLoad
        Add(newObj)
        Return newObj

    End Function

#End Region

End Class

