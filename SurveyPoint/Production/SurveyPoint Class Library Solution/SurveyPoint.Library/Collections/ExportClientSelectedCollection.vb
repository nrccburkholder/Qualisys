Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class ExportClientSelectedCollection
    Inherits BusinessListBase(Of ExportClientSelectedCollection, ExportClientSelected)

    ''' <summary>A collection class for ExportClientSelected class.</summary>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportClientSelected = ExportClientSelected.NewClient
        Me.Add(newObj)
        Return newObj
    End Function
End Class

