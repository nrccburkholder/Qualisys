Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorDispositionCollection
    Inherits BusinessListBase(Of VendorDispositionCollection, VendorDisposition)

    Public Function GetByVendorDispositionCode(ByVal dispositionCode As String) As VendorDisposition

        For Each dispo As VendorDisposition In Me
            If dispo.VendorDispositionCode.ToLower = dispositionCode.ToLower Then
                Return dispo
            End If
        Next

        Return Nothing

    End Function

    Protected Overrides Function AddNewCore() As Object
        Dim dispo As VendorDisposition = VendorDisposition.NewVendorDisposition
        Me.Add(dispo)
        Return dispo
    End Function
End Class

