Imports Nrc.Framework.BusinessLogic
''' <summary>Holds a collectio of ExportFileLayout Objects.  Each export group has one of these.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportFileLayoutCollection
    Inherits BusinessListBase(Of ExportFileLayoutCollection, ExportFileLayout)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportFileLayout = ExportFileLayout.NewExportFileLayout
        Me.Add(newObj)
        Return newObj
    End Function
End Class

