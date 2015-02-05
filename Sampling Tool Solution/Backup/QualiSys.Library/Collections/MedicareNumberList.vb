<Serializable()> _
Public Class MedicareNumberList
    Inherits Nrc.Framework.BusinessLogic.BusinessListBase(Of MedicareNumberList, MedicareNumber)

    Protected Overrides Function AddNewCore() As Object
        Dim medicareNum As MedicareNumber = MedicareNumber.NewMedicareNumber
        Me.Add(medicareNum)
        Return medicareNum
    End Function
End Class
