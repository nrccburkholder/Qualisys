Public Class FacilityViewModeChangedEventArgs
    Inherits System.EventArgs

#Region " Private Members "

    Private mViewMode As FacilitySection.DataViewMode

#End Region

#Region " Public Properties "

    Public ReadOnly Property ViewMode() As FacilitySection.DataViewMode
        Get
            Return mViewMode
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal viewMode As FacilitySection.DataViewMode)

        mViewMode = viewMode

    End Sub

#End Region

End Class
