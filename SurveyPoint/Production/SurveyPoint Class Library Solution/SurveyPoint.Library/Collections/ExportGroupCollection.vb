Imports Nrc.Framework.BusinessLogic
''' <summary>A collectio of Export Group Objects.  Export groups are mostly used independatly, but this allows for a collection.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportGroupCollection
    Inherits BusinessListBase(Of ExportGroupCollection, ExportGroup)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportGroup = ExportGroup.NewExportGroup
        Me.Add(newObj)
        Return newObj
    End Function
End Class
