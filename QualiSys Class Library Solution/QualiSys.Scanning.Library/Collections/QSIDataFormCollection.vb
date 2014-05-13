Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class QSIDataFormCollection
	Inherits BusinessListBase(Of QSIDataFormCollection , QSIDataForm)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  QSIDataForm = QSIDataForm.NewQSIDataForm
        Add(newObj)
        Return newObj

    End Function
	
End Class

