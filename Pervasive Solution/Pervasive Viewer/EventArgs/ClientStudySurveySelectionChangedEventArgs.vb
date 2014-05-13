Imports Nrc.Qualisys.Pervasive.Library.Navigation

Public Class ClientStudySurveySelectionChangedEventArgs
    Inherits EventArgs

    Private mSelectionType As NavigationNodeType

    Public ReadOnly Property SelectionType() As NavigationNodeType
        Get
            Return mSelectionType
        End Get
    End Property

    Sub New(ByVal type As NavigationNodeType)

        mSelectionType = type

    End Sub

End Class
