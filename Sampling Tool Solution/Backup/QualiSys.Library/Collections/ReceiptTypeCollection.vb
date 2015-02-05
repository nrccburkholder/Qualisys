Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class ReceiptTypeCollection
    Inherits BusinessListBase(Of ReceiptTypeCollection, ReceiptType)

    Public Function GetByTranslationCode(ByVal translationCode As String) As ReceiptType

        For Each receipt As ReceiptType In Me
            If receipt.TranslationCode.ToLower = translationCode.ToLower Then
                Return receipt
            End If
        Next

        Return Nothing

    End Function

End Class

