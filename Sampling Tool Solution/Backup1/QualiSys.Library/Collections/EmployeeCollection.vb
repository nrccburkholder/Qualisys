Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class EmployeeCollection
    Inherits Nrc.Framework.BusinessLogic.BusinessListBase(Of EmployeeCollection, Employee)

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As Employee = Employee.NewEmployee
        Me.Add(newObj)
        Return newObj

    End Function
End Class
