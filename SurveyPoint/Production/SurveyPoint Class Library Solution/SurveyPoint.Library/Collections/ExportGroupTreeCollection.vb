Imports Nrc.Framework.BusinessLogic
''' <summary>Allows for a collection of ExportGroupTree objects.  EGTree object are used for displaying export group info in a tree of grid.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportGroupTreeCollection
    Inherits BusinessListBase(Of ExportGroupTreeCollection, ExportGroupTree)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportGroupTree = ExportGroupTree.NewExportGroup
        Me.Add(newObj)
        Return newObj
    End Function
End Class
