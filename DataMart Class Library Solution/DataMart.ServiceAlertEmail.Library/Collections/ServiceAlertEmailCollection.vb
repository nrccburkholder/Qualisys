Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class ServiceAlertEmailCollection
	Inherits BusinessListBase(Of ServiceAlertEmailCollection , ServiceAlertEmail)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  ServiceAlertEmail = ServiceAlertEmail.NewServiceAlertEmail
        Add(newObj)
        Return newObj

    End Function
	
End Class

