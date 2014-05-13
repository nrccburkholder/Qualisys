Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class DataLoadCollection
    Inherits BusinessListBase(Of DataLoadCollection, DataLoad)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As DataLoad = DataLoad.NewDataLoad
        Add(newObj)
        Return newObj

    End Function

#End Region

End Class

