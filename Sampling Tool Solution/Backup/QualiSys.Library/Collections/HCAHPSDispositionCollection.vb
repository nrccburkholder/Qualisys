Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class HCAHPSDispositionCollection
	Inherits BusinessListBase(Of HCAHPSDispositionCollection , HCAHPSDisposition)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  HCAHPSDisposition = HCAHPSDisposition.NewHCAHPSDisposition
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

