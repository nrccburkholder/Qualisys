Public Class SurveyTypesCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As SurveyType
        Get
            Return DirectCast(MyBase.List(index), SurveyType)
        End Get
    End Property

    Public Function Add(ByVal survey As SurveyType) As Integer
        Return MyBase.List.Add(survey)
    End Function

End Class
