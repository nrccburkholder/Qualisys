Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class HHCAHPSDispositionCollection
	Inherits BusinessListBase(Of HHCAHPSDispositionCollection , HHCAHPSDisposition)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  HHCAHPSDisposition = HHCAHPSDisposition.NewHHCAHPSDisposition
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

