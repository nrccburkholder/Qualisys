Namespace Miscellaneous
    Public Class Security
        Private Const NRCKEY As String = "FJ38DLF0WLKC089CU7D3KLD09SCKLA3290CZKQ8904KL3482DSIO"
        Private Shared _KeyCollection As New Collection

        Public Shared WriteOnly Property Key() As String
            Set(ByVal value As String)
                If _KeyCollection.Contains(My.Application.Info.Title) Then

                Else
                    _KeyCollection.Add(value, My.Application.Info.Title)
                End If

            End Set
        End Property

        Friend Shared Function ValidateKey() As Boolean
            If _KeyCollection.Contains(My.Application.Info.Title) Then
                If _KeyCollection.Item(My.Application.Info.Title).ToString = NRCKEY Then
                    Return True
                Else
                    Return False
                End If
            End If
        End Function

    End Class
End Namespace

