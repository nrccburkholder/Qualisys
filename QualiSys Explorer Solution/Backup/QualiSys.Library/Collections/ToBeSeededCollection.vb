Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class ToBeSeededCollection
	Inherits BusinessListBase(Of ToBeSeededCollection , ToBeSeeded)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  ToBeSeeded = ToBeSeeded.NewToBeSeeded
        Add(newObj)
        Return newObj

    End Function
	
End Class

