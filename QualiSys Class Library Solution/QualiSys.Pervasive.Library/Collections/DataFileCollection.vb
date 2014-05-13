Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class DataFileCollection
	Inherits BusinessListBase(Of DataFileCollection , DataFile)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  DataFile = DataFile.NewDataFile
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

