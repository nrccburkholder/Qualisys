Namespace DataProvider
    Public MustInherit Class FacilityProvider

#Region " Singleton Implementation "
        Private Shared mInstance As FacilityProvider
        Private Const mProviderName As String = "FacilityProvider"

        Public Shared ReadOnly Property Instance() As FacilityProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of FacilityProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub


        Public MustOverride Function [Select](ByVal facilityId As Integer, Optional ByVal isPracticeSite As Boolean = False) As Facility
        Public MustOverride Function SelectAll(Optional ByVal isPracticeSite As Boolean? = False) As FacilityList
        Public MustOverride Function SelectByClientId(ByVal clientId As Integer, Optional ByVal isPracticeSite? As Boolean = False) As FacilityList
        Public MustOverride Function SelectByAhaId(ByVal ahaId As Integer) As Collection(Of Facility)
        Public MustOverride Function SelectAllFacilityRegions() As Collection(Of FacilityRegion)

        Public MustOverride Sub Insert(ByVal fac As Facility)
        Public MustOverride Sub Update(ByVal fac As Facility)
        Public MustOverride Sub Delete(ByVal facilityId As Integer)

        Public MustOverride Function AllowDelete(ByVal facilityId As Integer) As Boolean
        Public MustOverride Function AllowUnassignment(ByVal facilityId As Integer, ByVal clientId As Integer, Optional ByVal isPracticeSite As Boolean = False) As Boolean
        Public MustOverride Sub AssignFacilityToClient(ByVal facilityId As Integer, ByVal clientId As Integer, Optional ByVal isPracticeSite As Boolean = False)
        Public MustOverride Sub UnassignFacilityFromClient(ByVal facilityId As Integer, ByVal clientId As Integer, Optional ByVal isPracticeSite As Boolean = False)

        Public MustOverride Function SelectAllSiteGroups() As DataSet
        Public MustOverride Sub UpdateSiteGroup(ByVal siteGroup As SiteGroup)
        Public MustOverride Sub UpdatePracticeSite(ByVal practiceSite As PracticeSite)
        Public MustOverride Sub InsertSiteGroup(ByVal siteGroup As SiteGroup)
        Public MustOverride Sub InsertPracticeSite(ByVal practiceSite As PracticeSite)
        Public MustOverride Sub DeleteSiteGroup(ByVal siteGroup As SiteGroup)
        Public MustOverride Sub DeletePracticeSite(ByVal practiceSite As PracticeSite)
        Public MustOverride Function AllowSiteDelete(ByVal siteGroup As SiteGroup) As Boolean
        Public MustOverride Function AllowSiteDelete(ByVal practiceSite As PracticeSite) As Boolean

        Protected Shared Function GetNewFacility(ByVal id As Integer) As Facility
            Return New Facility(id)
        End Function

        Protected Shared Function GetNewFacilityRegion(ByVal id As Integer, ByVal name As String) As FacilityRegion
            Return New FacilityRegion(id, name)
        End Function

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub
        End Class
    End Class

End Namespace
