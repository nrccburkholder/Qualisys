Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class ExportClientAvailableCollection
    Inherits BusinessListBase(Of ExportClientAvailableCollection, ExportClientAvailable)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportClientAvailable = ExportClientAvailable.NewClient
        Me.Add(newObj)
        Return newObj
    End Function
End Class

