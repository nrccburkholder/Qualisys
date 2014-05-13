Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class DispositionCollection
    Inherits BusinessListBase(Of DispositionCollection, Disposition)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As Disposition = Disposition.NewDisposition
        Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Public Methods "

    Public Function DoesMustHaveResultsExist() As Boolean

        For Each dispo As Disposition In Me
            If dispo.VendorDispo.QCLDisposition.MustHaveResults Then
                Return True
            End If
        Next

        Return False

    End Function

    Public Function DoesFinalExist() As Boolean

        For Each dispo As Disposition In Me
            If dispo.IsFinal Then
                Return True
            End If
        Next

        Return False

    End Function

    Public Function GetFinalDisposition() As Disposition

        Dim final As Disposition = Nothing

        For Each dispo As Disposition In Me
            If dispo.IsFinal Then
                final = dispo
                Exit For
            End If
        Next

        Return final

    End Function

    Public Function FinalDispositionCount() As Integer

        Dim count As Integer

        For Each dispo As Disposition In Me
            If dispo.IsFinal Then
                count += 1
            End If
        Next

        Return count

    End Function

    Public Function HasErrors() As Boolean

        For Each dispo As Disposition In Me
            If dispo.ErrorId <> TransferErrorCodes.None Then
                Return True
            End If
        Next

        Return False

    End Function

    Public Function ErrorCount() As Integer

        Dim count As Integer

        For Each dispo As Disposition In Me
            If dispo.ErrorId <> TransferErrorCodes.None Then
                count += 1
            End If
        Next

        Return count

    End Function

#End Region

End Class

