Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class DataFileStateCollection
	Inherits BusinessListBase(Of DataFileStateCollection , DataFileState)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  DataFileState = DataFileState.NewDataFileState
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

