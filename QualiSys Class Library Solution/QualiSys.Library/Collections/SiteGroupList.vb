Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SiteGroupList
    Inherits Nrc.Framework.BusinessLogic.BusinessListBase(Of SiteGroupList, SiteGroup)

    Protected Overrides Function AddNewCore() As Object
        Dim grp As SiteGroup = SiteGroup.NewSiteGroup
        Me.Add(grp)
        Return grp
    End Function
End Class
