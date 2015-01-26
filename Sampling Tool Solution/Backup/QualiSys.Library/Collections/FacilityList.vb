Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class FacilityList
    Inherits Nrc.Framework.BusinessLogic.BusinessListBase(Of FacilityList, Facility)

    Protected Overrides Function AddNewCore() As Object
        Dim fac As Facility = Facility.NewFacility
        Me.Add(fac)
        Return fac
    End Function
End Class
