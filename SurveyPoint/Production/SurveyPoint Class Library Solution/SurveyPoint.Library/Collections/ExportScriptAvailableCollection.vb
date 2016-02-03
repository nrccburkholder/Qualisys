Imports Nrc.Framework.BusinessLogic
''' <summary>A collection of available script object.  Available object are for display and dont have as much data as their selected counterparts.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportScriptAvailableCollection
    Inherits BusinessListBase(Of ExportScriptAvailableCollection, ExportScriptAvailable)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportScriptAvailable = ExportScriptAvailable.NewExportScriptAvailable
        Me.Add(newObj)
        Return newObj
    End Function
End Class