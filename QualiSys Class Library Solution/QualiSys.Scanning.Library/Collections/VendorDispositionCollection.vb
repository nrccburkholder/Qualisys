Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class VendorDispositionCollection
    Inherits BusinessListBase(Of VendorDispositionCollection, VendorDisposition)

    Public Function GetByVendorDispositionCode(ByVal dispositionCode As String, ByVal isFinal As Boolean) As VendorDisposition

        For Each dispo As VendorDisposition In Me
            If dispo.isFinal = 1 Then
                If dispo.VendorDispositionCode.ToLower = dispositionCode.ToLower And isFinal Then
                    Return dispo
                End If
            ElseIf dispo.isFinal = 0 Then
                If dispo.VendorDispositionCode.ToLower = dispositionCode.ToLower And Not isFinal Then
                    Return dispo
                End If
            Else 'dispo.isFinal = 9 ==> don't care
                If dispo.VendorDispositionCode.ToLower = dispositionCode.ToLower Then
                    Return dispo
                End If
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

