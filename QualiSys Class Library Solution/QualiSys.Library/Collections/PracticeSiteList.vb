Imports Nrc.Framework.BusinessLogic

Public Class PracticeSiteList
    Inherits Nrc.Framework.BusinessLogic.BusinessListBase(Of PracticeSiteList, PracticeSite)

    Protected Overrides Function AddNewCore() As Object
        Dim ps As PracticeSite = PracticeSite.NewPracticeSite
        Me.Add(ps)
        Return ps
    End Function

End Class
