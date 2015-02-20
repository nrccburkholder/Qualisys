Imports Nrc.Framework.BusinessLogic

''' <summary>Collection container for MedicareRecalcHistory objects.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class MedicareRecalcHistoryCollection
    Inherits BusinessListBase(Of MedicareRecalcHistoryCollection, MedicareRecalcHistory)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MedicareRecalcHistory = MedicareRecalcHistory.NewMedicareRecalcHistory
        Me.Add(newObj)
        Return newObj
    End Function
End Class


