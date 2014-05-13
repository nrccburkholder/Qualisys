Public Class PrioritierViewModeChangedEventArgs
    Inherits System.EventArgs

    Private mViewMode As SampleUnitPrioritizer.DataViewMode
    Public ReadOnly Property ViewMode() As SampleUnitPrioritizer.DataViewMode
        Get
            Return mViewMode
        End Get
    End Property

    Public Sub New(ByVal viewMode As SampleUnitPrioritizer.DataViewMode)
        mViewMode = viewMode
    End Sub

End Class
