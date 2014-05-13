Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class PopMappingCollection
    Inherits BusinessListBase(Of PopMappingCollection, PopMapping)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As PopMapping = PopMapping.NewPopMapping
        Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Public Methods "

    Public Function HasErrors() As Boolean

        For Each pop As PopMapping In Me
            If pop.ErrorId <> TransferErrorCodes.None Then
                Return True
            End If
        Next

        Return False

    End Function

    Public Function ErrorCount() As Integer

        Dim count As Integer

        For Each pop As PopMapping In Me
            If pop.ErrorId <> TransferErrorCodes.None Then
                count += 1
            End If
        Next

        Return count

    End Function

#End Region

End Class

