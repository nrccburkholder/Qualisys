Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class ErrorCodeCollection
    Inherits BusinessListBase(Of ErrorCodeCollection, ErrorCode)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As ErrorCode = ErrorCode.NewErrorCode
        Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Public Methods "

    Public Function GetErrorDescriptionByErrorID(ByVal errorID As TransferErrorCodes) As String

        Dim errorDescription As String = String.Empty

        For Each errCode As ErrorCode In Me
            If errCode.ErrorId = errorID Then
                errorDescription = errCode.ErrorDesc
                Exit For
            End If
        Next

        Return errorDescription

    End Function

#End Region

End Class

