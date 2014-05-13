Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class VendorFileTelematchLogCollection
    Inherits BusinessListBase(Of VendorFileTelematchLogCollection, VendorFileTelematchLog)

#Region " Protected Methods "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As VendorFileTelematchLog = VendorFileTelematchLog.NewVendorFileTelematchLog
        Me.Add(newObj)
        Return newObj

    End Function

#End Region

End Class

