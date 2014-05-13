Imports Nrc.Framework.BusinessLogic
Public Class ProjectManagerCollection
    Inherits List(Of ProjectManager)
    'Inherits BusinessListBase(Of ProjectManagerCollection, ProjectManager)


    Public Sub New(ByVal members As NRC.NRCAuthLib.MemberCollection)
        For Each member As NRCAuthLib.Member In members
            Dim PM As ProjectManager = ProjectManager.NewProjectManager(member)
            Me.Add(PM)
        Next
    End Sub
End Class
