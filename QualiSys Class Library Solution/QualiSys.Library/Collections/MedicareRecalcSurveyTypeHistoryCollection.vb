Imports Nrc.Framework.BusinessLogic

''' <summary>Collection container for MedicareRecalcHistory objects.</summary>
''' <CreatedBy></CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()>
Public Class MedicareRecalcSurveyTypeHistoryCollection
    Inherits BusinessListBase(Of MedicareRecalcSurveyTypeHistoryCollection, MedicareRecalcSurveyTypeHistory)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MedicareRecalcSurveyTypeHistory = MedicareRecalcSurveyTypeHistory.NewMedicareRecalcSurveyTypeHistory
        Me.Add(newObj)
        Return newObj
    End Function
End Class


