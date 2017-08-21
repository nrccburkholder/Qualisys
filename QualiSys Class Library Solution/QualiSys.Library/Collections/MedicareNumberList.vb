<Serializable()> _
Public Class MedicareNumberList
    Inherits Nrc.Framework.BusinessLogic.BusinessListBase(Of MedicareNumberList, MedicareNumber)

    Protected Overrides Function AddNewCore() As Object
        Dim globalDef As MedicareGlobalCalculationDefault = MedicareGlobalCalculationDefault.GetAll()(0)

        Dim medicareNum As MedicareNumber = MedicareNumber.NewMedicareNumber(globalDef)
        Me.Add(medicareNum)
        Return medicareNum
    End Function
End Class
