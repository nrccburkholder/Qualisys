Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class STUDY_EMPLOYEECollection
	Inherits BusinessListBase(Of STUDY_EMPLOYEECollection , STUDY_EMPLOYEE)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  STUDY_EMPLOYEE = STUDY_EMPLOYEE.NewSTUDY_EMPLOYEE
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

