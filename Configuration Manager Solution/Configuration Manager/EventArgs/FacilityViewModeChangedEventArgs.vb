Public Class FacilityViewModeChangedEventArgs
    Inherits System.EventArgs

#Region " Private Members "

    Private mViewMode As FacilityAdminSection.DataViewMode

#End Region

#Region " Public Properties "

    Public ReadOnly Property ViewMode() As FacilityAdminSection.DataViewMode
        Get
            Return mViewMode
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal viewMode As FacilityAdminSection.DataViewMode)

        mViewMode = viewMode

    End Sub

#End Region

End Class
