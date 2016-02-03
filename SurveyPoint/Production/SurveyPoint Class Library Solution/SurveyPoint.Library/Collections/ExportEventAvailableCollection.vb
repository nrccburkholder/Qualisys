Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class ExportEventAvailableCollection
    Inherits BusinessListBase(Of ExportEventAvailableCollection, ExportEventAvailable)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportEventAvailable = ExportEventAvailable.NewExportEvent
        Me.Add(newObj)
        Return newObj
    End Function
End Class
