Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class CommentCollection
    Inherits BusinessListBase(Of CommentCollection, Comment)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As Comment = Comment.NewComment
        Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Public Methods "

    Public Function HasErrors() As Boolean

        For Each cmnt As Comment In Me
            If cmnt.ErrorId <> TransferErrorCodes.None Then
                Return True
            End If
        Next

        Return False

    End Function

    Public Function ErrorCount() As Integer

        Dim count As Integer

        For Each cmnt As Comment In Me
            If cmnt.ErrorId <> TransferErrorCodes.None Then
                count += 1
            End If
        Next

        Return count

    End Function

#End Region

End Class

