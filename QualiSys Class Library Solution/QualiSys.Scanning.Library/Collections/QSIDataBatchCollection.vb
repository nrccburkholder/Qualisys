Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class QSIDataBatchCollection
	Inherits BusinessListBase(Of QSIDataBatchCollection , QSIDataBatch)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  QSIDataBatch = QSIDataBatch.NewQSIDataBatch
        Add(newObj)
        Return newObj

    End Function
	
End Class

