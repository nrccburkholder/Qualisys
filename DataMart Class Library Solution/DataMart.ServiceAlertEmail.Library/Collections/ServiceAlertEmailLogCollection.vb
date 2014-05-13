Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class ServiceAlertEmailLogCollection
	Inherits BusinessListBase(Of ServiceAlertEmailLogCollection , ServiceAlertEmailLog)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  ServiceAlertEmailLog = ServiceAlertEmailLog.NewServiceAlertEmailLog
        Add(newObj)
        Return newObj

    End Function
	
End Class

