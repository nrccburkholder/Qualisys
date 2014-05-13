Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VoviciDownloadLogCollection
	Inherits BusinessListBase(Of VoviciDownloadLogCollection , VoviciDownloadLog)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  VoviciDownloadLog = VoviciDownloadLog.NewVoviciDownloadLog
        Me.Add(newObj)
        Return newObj

    End Function
	
End Class

