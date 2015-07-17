Imports Nrc.Qualisys.Library

Public Class FacilityAdminSection
    Inherits Section

#Region " Private Members "

    Private WithEvents mClientNavigator As ClientNavigator
    Private mViewMode As DataViewMode
#End Region

#Region " Enums "

    Public Enum DataViewMode
        ClientFacilities = 1
        AllFacilities = 2
        GroupsAndSites = 3
    End Enum

#End Region


#Region " Base Class Overrides "

    Public Overrides Sub ActivateSection()

        'Set the view mode (this reinitializes the screen each time it is activated)
        'PopulateMedicareList()
        SetViewMode(mViewMode)

    End Sub

    Public Overrides Sub InactivateSection()

        'Cleanup all memory collections and grid data sources
        'Me.AllFacilityGrid.ClearDataSources()
        'Me.ClientFacilityGrid.ClearDataSources()
        'mAllFacilityGridIsPopulated = False

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Select Case mViewMode
            Case FacilityAdminSection.DataViewMode.AllFacilities
                'Return VerifyOKToInactivateAllFacilities()
                Return True
            Case FacilityAdminSection.DataViewMode.ClientFacilities
                'We can always unload here because database updates are immediate
                Return True

            Case Else
                'No current view mode exists
                Return True
        End Select

    End Function

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        Me.mClientNavigator = TryCast(navCtrl, ClientNavigator)
        If mClientNavigator Is Nothing Then
            Throw New ArgumentException("The FacilitySection control expects a navigation control of type ClientNavigator")
        End If

    End Sub

#End Region

#Region "events"

    Private Sub mClientNavigator_FacilityViewModeChanged(ByVal sender As Object, ByVal e As FacilityViewModeChangedEventArgs) Handles mClientNavigator.FacilityViewModeChanged
        SetViewMode(e.ViewMode)
    End Sub


#End Region

#Region "private methods - general"


    Private Sub SetViewMode(ByVal viewMode As FacilityAdminSection.DataViewMode)

       Select Case viewMode
            Case FacilityAdminSection.DataViewMode.GroupsAndSites
                tabCtrlFacilityAdmin.SelectedTabPage = tpageGroupsSites
                FacilityGroupSiteMappingSection1.SetViewMode(viewMode)
            Case Else
                tabCtrlFacilityAdmin.SelectedTabPage = tpageFacility
                FacilitySection2.SetViewMode(viewMode, mClientNavigator)
        End Select
        'Save the mode
        mViewMode = viewMode
    End Sub




#End Region


End Class
