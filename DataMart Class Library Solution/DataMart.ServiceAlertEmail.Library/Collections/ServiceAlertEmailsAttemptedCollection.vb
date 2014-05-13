Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class ServiceAlertEmailsAttemptedCollection
    Inherits BusinessListBase(Of ServiceAlertEmailsAttemptedCollection, ServiceAlertEmailsAttempted)

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As ServiceAlertEmailsAttempted = ServiceAlertEmailsAttempted.NewServiceAlertEmailsAttempted
        Add(newObj)
        Return newObj

    End Function

End Class

