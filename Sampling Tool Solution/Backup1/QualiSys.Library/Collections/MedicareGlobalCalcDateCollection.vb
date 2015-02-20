Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class MedicareGlobalCalcDateCollection
    Inherits BusinessListBase(Of MedicareGlobalCalcDateCollection, MedicareGlobalCalcDate)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MedicareGlobalCalcDate = MedicareGlobalCalcDate.NewMedicareGlobalCalcDate()
        Me.Add(newObj)
        Return newObj
    End Function
End Class