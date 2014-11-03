Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class MedicareGlobalCalculationDefaultCollection
    Inherits BusinessListBase(Of MedicareGlobalCalculationDefaultCollection, MedicareGlobalCalculationDefault)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MedicareGlobalCalculationDefault = MedicareGlobalCalculationDefault.NewMedicareGlobalCalculationDefault
        Me.Add(newObj)
        Return newObj
    End Function
End Class